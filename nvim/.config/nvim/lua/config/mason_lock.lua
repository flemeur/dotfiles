--- Lockfile for mason packages, the mason counterpart to lazy-lock.json.
---
--- Inspired by zapling/mason-lock.nvim, with a restore that is safe to run headless:
--- - Only packages whose installed version differs from the lockfile are (re)installed.
--- - Packages LazyVim is already installing (`ensure_installed`) are waited on and then
---   corrected, instead of failing with "Package is already installing".
--- - Headless runs block until every install has finished, so `+qa` can't cut them off.
---
--- The lockfile is rewritten whenever a package is installed, updated or uninstalled, like
--- lazy.nvim does for plugins. Update on the main machine and commit the lockfile; elsewhere
--- run :MasonLockRestore (dotsync does this after pulling).
local M = {}

M.path = vim.fn.stdpath("config") .. "/mason-lock.json"

local restoring = false

local function notify(msg, level)
  msg = "[mason-lock] " .. msg
  if #vim.api.nvim_list_uis() == 0 then
    -- Headless: LazyVim queues vim.notify until a UI exists, so print directly
    io.stderr:write(msg .. "\n")
  else
    vim.notify(msg, level or vim.log.levels.INFO)
  end
end

--- @return table<string, string>?
local function read_lockfile()
  local fd = io.open(M.path, "r")
  if not fd then
    return nil
  end
  local ok, data = pcall(vim.json.decode, fd:read("*a"))
  fd:close()
  if not ok or type(data) ~= "table" then
    notify("Could not parse " .. M.path, vim.log.levels.ERROR)
    return nil
  end
  return data
end

--- Writes the versions of all installed packages to the lockfile.
--- @param opts? { notify?: boolean }
function M.write(opts)
  local registry = require("mason-registry")
  local lock = {}
  for _, name in ipairs(registry.get_installed_package_names()) do
    -- get_package errors for packages that have since been removed from the registry
    local ok, pkg = pcall(registry.get_package, name)
    local version = ok and pkg:get_installed_version() or nil
    if version then
      lock[name] = version
    end
  end

  local content = next(lock) and vim.json.encode(lock, { indent = "  ", sort_keys = true }) or "{}"
  content = content .. "\n"

  local fd = io.open(M.path, "r")
  local current = fd and fd:read("*a")
  if fd then
    fd:close()
  end
  if content ~= current then
    fd = assert(io.open(M.path, "w"))
    fd:write(content)
    fd:close()
  end

  if opts and opts.notify then
    notify(("Wrote %d packages to %s"):format(vim.tbl_count(lock), M.path))
  end
end

--- Installs every locked package whose installed version differs from the lockfile.
--- Packages that are installed but not in the lockfile are left alone.
--- @param on_done? fun()
function M.restore(on_done)
  local lock = read_lockfile()
  if not lock then
    notify("No lockfile at " .. M.path, vim.log.levels.ERROR)
    return on_done and on_done()
  end

  local registry = require("mason-registry")
  restoring = true

  registry.refresh(vim.schedule_wrap(function()
    local pending = vim.tbl_count(lock)
    local changed, failed = {}, {}

    local function finish()
      restoring = false
      -- Brings the file back in line if an install (e.g. LazyVim's ensure_installed) rewrote it
      M.write()
      if #failed > 0 then
        notify("Failed to restore: " .. table.concat(failed, ", "), vim.log.levels.WARN)
      end
      if #changed > 0 then
        notify("Restored " .. table.concat(changed, ", "))
      elseif #failed == 0 then
        notify("All packages already match the lockfile")
      end
      if on_done then
        on_done()
      end
    end

    local function done_one()
      pending = pending - 1
      if pending == 0 then
        finish()
      end
    end

    local function sync(name, version)
      local ok, pkg = pcall(registry.get_package, name)
      if not ok then
        table.insert(failed, name .. " (not in registry)")
        return done_one()
      end

      if pkg:is_installing() then
        -- Wait for the running install to finish, then check its version again
        local handle = pkg:get_install_handle()
        if handle:is_present() then
          handle:get():once("closed", vim.schedule_wrap(function()
            sync(name, version)
          end))
        else
          vim.defer_fn(function()
            sync(name, version)
          end, 200)
        end
        return
      end

      if pkg:get_installed_version() == version then
        return done_one()
      end

      pkg:install({ version = version }, vim.schedule_wrap(function(success)
        table.insert(success and changed or failed, ("%s@%s"):format(name, version))
        done_one()
      end))
    end

    if pending == 0 then
      return finish()
    end
    for name, version in pairs(lock) do
      sync(name, version)
    end
  end))
end

function M.setup()
  vim.api.nvim_create_user_command("MasonLock", function()
    M.write({ notify = true })
  end, { desc = "Write installed mason package versions to the lockfile" })

  vim.api.nvim_create_user_command("MasonLockRestore", function()
    local done = false
    M.restore(function()
      done = true
    end)
    -- Headless (e.g. dotsync): block so the following +qa doesn't kill running installs
    if #vim.api.nvim_list_uis() == 0 then
      vim.wait(10 * 60 * 1000, function()
        return done
      end, 200)
    end
  end, { desc = "Install the mason package versions from the lockfile" })

  -- Keep the lockfile current once mason is loaded, like lazy.nvim does for plugins
  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyLoad",
    callback = function(ev)
      if ev.data ~= "mason.nvim" then
        return
      end
      local registry = require("mason-registry")
      local function on_change()
        if not restoring then
          M.write()
        end
      end
      registry:on("package:install:success", vim.schedule_wrap(on_change))
      registry:on("package:uninstall:success", vim.schedule_wrap(on_change))
      return true -- only needs to run once
    end,
  })
end

return M

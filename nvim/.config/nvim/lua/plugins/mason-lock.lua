-- Lockfile for mason packages: mason-lock.json, :MasonLock and :MasonLockRestore.
-- See lua/config/mason_lock.lua.
return {
  "mason-org/mason.nvim",
  -- init runs at startup without loading mason, so the commands exist before mason is loaded
  init = function()
    require("config.mason_lock").setup()
  end,
}

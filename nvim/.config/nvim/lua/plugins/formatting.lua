local oxfmt = require("config.oxfmt")

--- Wraps a formatter's `condition` so it stands down in projects that format with oxfmt,
--- keeping whatever condition LazyVim's extras already gave it everywhere else. This runs
--- after those extras because lazy.nvim imports `plugins` last, so their `opts` functions
--- have already installed their conditions by the time this one runs.
--- @param formatters table<string, table>
--- @param name string
local function stand_down_for_oxfmt(formatters, name)
  local formatter = formatters[name] or {}
  local previous = formatter.condition

  formatter.condition = function(self, ctx)
    if oxfmt.is_project(ctx.filename) then
      return false
    end
    return previous == nil or previous(self, ctx) ~= false
  end

  formatters[name] = formatter
end

return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft = opts.formatters_by_ft or {}
    opts.formatters = opts.formatters or {}

    -- Searched upward from the buffer rather than the cwd, so a Laravel project is still
    -- recognised when Neovim was started somewhere else.
    opts.formatters_by_ft.php = function(bufnr)
      local path = vim.api.nvim_buf_get_name(bufnr)
      if vim.fs.find("vendor/bin/pint", { path = path, upward = true, type = "file" })[1] then
        return { "pint" }
      end
      return { "php_cs_fixer" }
    end

    -- Appended rather than prepended so anything that only injects content - `markdown-toc`
    -- in particular - has already run and oxfmt formats its output too.
    for _, ft in ipairs(oxfmt.filetypes) do
      local formatters = opts.formatters_by_ft[ft] or {}
      table.insert(formatters, "oxfmt")
      opts.formatters_by_ft[ft] = formatters
    end

    opts.formatters.oxfmt = {
      condition = function(_, ctx)
        return oxfmt.is_project(ctx.filename)
      end,
    }

    -- Both of these fight oxfmt over Markdown list indentation, and Prettier would fight
    -- it over every other filetype the two share.
    stand_down_for_oxfmt(opts.formatters, "prettier")
    stand_down_for_oxfmt(opts.formatters, "markdownlint-cli2")
  end,
}

return {
"stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      php = function(bufnr)
        if vim.fn.executable("./vendor/bin/pint") == 1 then
          return { "pint" }
        end
        return { "php_cs_fixer" }
      end,
      -- vue = { "prettier" },
      -- javascript = { "prettier" },
      -- typescript = { "prettier" },
    },
  },
}

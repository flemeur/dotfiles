return {
  "mfussenegger/nvim-lint",
  optional = true,
  opts = {
    linters = {
      -- Markdownlint's MD007 wants two-space list nesting and MD013 an eighty column
      -- limit, neither of which is oxfmt's business or oxfmt's answer. Left on
      -- everywhere else, where it is the only thing checking Markdown at all.
      --
      -- This also stops `markdownlint-cli2 --fix` running as a conform formatter: that
      -- one is conditioned on markdownlint diagnostics being present in the buffer, so
      -- with the linter held off there is nothing for it to act on.
      ["markdownlint-cli2"] = {
        condition = function(ctx)
          return not require("config.oxfmt").is_project(ctx.filename)
        end,
      },
    },
  },
}

--- Detects whether a file belongs to a project that formats with oxfmt.
---
--- Oxfmt is a drop-in replacement for Prettier and covers the same filetypes, so the two
--- must never both run: they disagree (most visibly on nested list indentation in
--- Markdown, where Prettier aligns to the parent marker and oxfmt uses the configured
--- indent width). Markdownlint's MD007 disagrees with oxfmt for the same reason, and
--- `markdownlint-cli2 --fix` runs as a conform formatter whenever markdownlint has
--- reported diagnostics for the buffer.
---
--- The project decides which one wins: a repo that checks in an oxfmt config is formatted
--- by oxfmt, everything else keeps Prettier and markdownlint. Nothing here requires oxfmt
--- to be installed - in a project without an oxfmt config it is never invoked.
local M = {}

--- Config file names oxfmt discovers on its own, matching conform's own oxfmt formatter.
--- @type string[]
local config_files = {
  ".oxfmtrc.json",
  ".oxfmtrc.jsonc",
  "oxfmt.config.ts",
  "oxfmt.config.mts",
  "oxfmt.config.cts",
  "oxfmt.config.js",
  "oxfmt.config.mjs",
  "oxfmt.config.cjs",
}

--- The filetypes oxfmt can parse. Deliberately the same set LazyVim's Prettier extra
--- claims, since oxfmt is meant to stand in for Prettier one for one.
--- @type string[]
M.filetypes = {
  "css",
  "graphql",
  "handlebars",
  "html",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "less",
  "markdown",
  "markdown.mdx",
  "scss",
  "typescript",
  "typescriptreact",
  "vue",
  "yaml",
}

--- Is `path` inside a project that formats with oxfmt?
---
--- Searches upward rather than from the cwd, so it stays correct when a buffer is opened
--- from somewhere else, and so oxfmt's own nested configs resolve the way oxfmt resolves
--- them. Not cached: a config file can be added or removed while Neovim is running, and
--- this is a handful of stat calls.
--- @param path string? A file or directory path; defaults to the current buffer's file.
--- @return boolean
function M.is_project(path)
  path = path or vim.api.nvim_buf_get_name(0)
  if path == "" then
    return false
  end

  return vim.fs.find(config_files, { path = path, upward = true, type = "file" })[1] ~= nil
end

return M

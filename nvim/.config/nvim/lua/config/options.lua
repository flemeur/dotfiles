-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Use real tabs and display them with a width of 8 chars
vim.opt.expandtab = false
vim.opt.tabstop = 8
vim.opt.softtabstop = 8
vim.opt.shiftwidth = 8

-- Disable hiding stuff
vim.wo.conceallevel = 0

-- Show column at 80 chars
vim.opt.colorcolumn = "80"
-- -- Show column at 120 chars
-- vim.opt.colorcolumn = "120"

-- Show whitespace
vim.opt.list = true
vim.opt.listchars = { tab = "» ", lead = "⋅", trail = "⋅" }

-- Disable mouse
-- vim.opt.mouse = ""

-- Disable annoying animation
vim.g.snacks_animate = false

-- Spell language
vim.opt.spelllang = { "en_us" }

-- vim.g.lazyvim_prettier_needs_config = true

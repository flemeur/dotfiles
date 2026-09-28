-- Catppuccin itself (integrations, bufferline theme) is set up by LazyVim; only pick it here.
-- The default `flavour = "auto"` follows 'background': latte when light, mocha when dark.
return {
  {
    "LazyVim/LazyVim",
    opts = {
      -- Not "catppuccin": Neovim 0.12+ ships its own colors/catppuccin.vim, which shadows the
      -- plugin's. "catppuccin-nvim" is the name catppuccin/nvim provides to avoid that clash.
      colorscheme = "catppuccin-nvim",
    },
  },
}

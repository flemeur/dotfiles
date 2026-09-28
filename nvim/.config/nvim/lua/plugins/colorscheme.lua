-- Catppuccin itself (integrations, bufferline theme) is set up by LazyVim; only pick it here.
-- The default `flavour = "auto"` follows 'background': latte when light, mocha when dark.
return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}

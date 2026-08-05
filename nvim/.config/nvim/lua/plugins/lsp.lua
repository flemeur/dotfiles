return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = false },

    servers = {
      gopls = {
        settings = {
          gopls = {
            -- Disable annoying placeholders
            usePlaceholders = false,
            completeUnimported = false,
          },
        },
      },
    },
  },
}

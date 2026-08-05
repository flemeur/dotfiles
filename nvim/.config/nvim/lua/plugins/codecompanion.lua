return {
  {
    "olimorris/codecompanion.nvim",
    enabled = false,
    opts = {
      schema = {
        model = {
          default = "gemini-2.5-flash",
        },
      },
      strategies = {
        chat = {
          adapter = "gemini",
          model = "gemini-2.5-pro",
        },
        inline = {
          adapter = "gemini",
          model = "gemini-2.5-flash",
        },
        cmd = {
          adapter = "gemini",
          model = "gemini-2.5-pro",
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
}

return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = { enabled = true },
      explorer = { trash = false },
      picker = {
        sources = {
          files = { hidden = true, ignored = false },
          grep = { hidden = true, ignored = false },
          explorer = { hidden = true, ignored = true },
        },
      },
    },
  },
}

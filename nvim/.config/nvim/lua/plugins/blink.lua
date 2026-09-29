return {
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      completion = {
        list = {
          selection = {
            -- Disable preselecting the first item of the completion suggestions
            preselect = false,
          },
        },
        menu = {
          -- Disable showing the completion popup automatically
          auto_show = false,
        },
        -- ghost_text = { enabled = false },
      },
    },
  },
}

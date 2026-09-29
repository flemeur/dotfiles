return {
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      keymap = {
        -- Only accept on Enter when the menu is actually open. Blink's `accept`
        -- also fires when just the ghost text is visible, which inserted a
        -- suggestion when I wanted a new line.
        ["<CR>"] = {
          function(cmp)
            if cmp.is_menu_visible() then
              return cmp.accept()
            end
          end,
          "fallback",
        },
      },
      completion = {
        menu = {
          -- Disable showing the completion popup automatically. Use <C-Space> to open it
          auto_show = false,
        },
        -- Disable ghost text when popup is not visible
        ghost_text = { enabled = false },
      },
    },
  },
}

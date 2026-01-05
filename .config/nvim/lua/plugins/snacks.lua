return {
  "folke/snacks.nvim",
  ---@type snacks.config
  opts = {
    scroll = {
      enabled = false, -- Disable scrolling animations
    },
    explorer = {
      ---@class snacks.explorer.Config
      {
        replace_netrw = true, -- Replace netrw with the snacks explorer
        trash = true, -- Use the system trash when deleting files
        hidden = true,
      },
    },
  },
}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "lazyvim.plugins.extras.ui.mini-animate" }, -- mini animate
    { "MunifTanjim/nui.nvim", branch = "main" }, -- nui.nvim (MUST be on main branch)

    -- venv-selector
    {
      "linux-cultist/venv-selector.nvim",
      dependencies = {
        "neovim/nvim-lspconfig",
        { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } }, -- optional: you can also use fzf-lua, snacks, mini-pick instead.
      },
      ft = "python", -- Load when opening Python files
      keys = {
        { ",v", "<cmd>VenvSelect<cr>" }, -- Open picker on keymap
      },
      opts = { -- this can be an empty lua table - just showing below for clarity.
        search = {}, -- if you add your own searches, they go here.
        options = {}, -- if you add plugin options, they go here.
      },
    },

    -- tmux-navigator
    {
      "christoomey/vim-tmux-navigator",
      cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
        "TmuxNavigatorProcessList",
      },
      keys = {
        { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
        { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
        { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
        { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
        { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
      },
    },

    -- herdr plugin
    {
      "lmilojevicc/herdr-splits.nvim",
      -- For local development, swap the repo line for `dir = '/path/to/herdr-splits'`
      -- (see "Local development" below).
      cond = vim.env.HERDR_ENV == "1",
      event = "VeryLazy",
      -- Optional: auto-sync the Herdr-side scripts when lazy updates this plugin.
      -- Requires `auto_sync_herdr = true` in setup() below to take effect.
      -- build = ':lua require("herdr-splits").sync_herdr()',
      config = function()
        require("herdr-splits").setup({
          -- Defaults shown. All fields optional.
          default_amount = 0.03, -- Herdr resize ratio
          neovim_amount = 3, -- Neovim resize cells
          at_edge = "wrap", -- 'wrap' | 'stop' | 'split' | function
          ignored_buftypes = { "nofile", "quickfix", "prompt", "help", "terminal" },
          ignored_filetypes = {
            "NvimTree",
            -- sidebars
            "neo-tree",
            "snacks_dashboard",
            "snacks_explorer",
            "snacks_picker",
            -- DB / REPL / data sidebars
            "dadbod-ui",
            "dbout",
            -- outlines / symbols
            "aerial",
            "Outline",
            -- diagnostics / quick lists
            "Trouble",
            "quickfix",
          },
          move_cursor_same_row = false,
          herdr_bin = nil, -- auto-detected from HERDR_BIN_PATH
          floating_zindex_max = 50, -- floats with zindex < this are treated as embedded sidebars
          ignore_previewwindows = false, -- opt-in: also treat previewwindow windows (e.g. .dbout) as sidebars
          -- auto_sync_herdr = true,      -- opt-in: sync Herdr-side scripts on update
          -- Managed keys — written to the generated herdr-splits.conf so the
          -- Herdr-side scripts agree. Pass Neovim notation (e.g. <M-Left>).
          nav_keys = { left = "<C-h>", down = "<C-j>", up = "<C-k>", right = "<C-l>" },
          resize_keys = { left = "<M-h>", down = "<M-j>", up = "<M-k>", right = "<M-l>" },
          unzoom_on_nav = true, -- auto-unzoom when navigating away from a zoomed pane
          nav_at_edge = "wrap", -- 'wrap' | 'stop' — Herdr pane-boundary wrap (distinct from at_edge)
        })
      end,
      keys = {
        {
          "<C-h>",
          function()
            require("herdr-splits").move_cursor_left()
          end,
          desc = "Navigate left",
        },
        {
          "<C-j>",
          function()
            require("herdr-splits").move_cursor_down()
          end,
          desc = "Navigate down",
        },
        {
          "<C-k>",
          function()
            require("herdr-splits").move_cursor_up()
          end,
          desc = "Navigate up",
        },
        {
          "<C-l>",
          function()
            require("herdr-splits").move_cursor_right()
          end,
          desc = "Navigate right",
        },
        {
          "<M-h>",
          function()
            require("herdr-splits").resize_left()
          end,
          desc = "Resize left",
        },
        {
          "<M-j>",
          function()
            require("herdr-splits").resize_down()
          end,
          desc = "Resize down",
        },
        {
          "<M-k>",
          function()
            require("herdr-splits").resize_up()
          end,
          desc = "Resize up",
        },
        {
          "<M-l>",
          function()
            require("herdr-splits").resize_right()
          end,
          desc = "Resize right",
        },
      },
    },

    -- parley.nvim
    {
      "HamzaHeikal2011/parley.nvim",
      event = "VeryLazy",
      opts = {
        url = "http://127.0.0.1:11434",
        model = "llama3.2:1b",
      },
      keys = {
        { "<leader>oc", "<cmd>Parley<cr>", desc = "Parley" },
        { "<leader>oa", "<cmd>ParleyAttach<cr>", desc = "Attach selection", mode = "v" },
        { "<leader>ob", "<cmd>ParleyAttachBuffer<cr>", desc = "Attach buffer" },
        { "<leader>ox", "<cmd>ParleyClearContext<cr>", desc = "Clear context" },
        { "<leader>om", "<cmd>ParleyModel<cr>", desc = "Switch model" },
      },
    },

    -- import/override with your plugins
    { import = "plugins" },
  },

  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,

    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
  },
  install = { colorscheme = { "matteblack", "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

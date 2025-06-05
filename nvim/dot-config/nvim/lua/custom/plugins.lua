local overrides = require "custom.configs.overrides"
local autocmd = vim.api.nvim_create_autocmd
local utils = require "core.utils"

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- format & linting
      {
        "nvimtools/none-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
      utils.load_mappings "lsp"
    end, -- Override to setup mason-lspconfig
  },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = overrides.treesitter,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "dmitmel/cmp-digraphs",
      "FelipeLema/cmp-async-path",
    },
    opts = overrides.cmp,
  },

  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    config = function()
      require "custom.configs.db"
    end,
  },

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    keys = {
      { "ys", mode = "n", desc = "Surround" },
      { "cs", mode = "n", desc = "Change Surround" },
      { "ds", mode = "n", desc = "Delete Surround" },
      { "S",  mode = "x", desc = "Surround (visual)" },
    },
    config = function()
      require("nvim-surround").setup {}
    end,
  },

  {
    "baskerville/vim-sxhkdrc",
    ft = "sxhkdrc",
    config = function()
      autocmd("BufWritePost", {
        pattern = "sxhkdrc",
        command = "!pkill -USR1 sxhkd",
      })
    end,
  },

  {
    "kmonad/kmonad-vim",
    event = { "BufReadPre *.kbd", "BufNewFile *.kbd" },
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "benfowler/telescope-luasnip.nvim",
      config = function()
        require("telescope").load_extension "luasnip"
      end,
    },
  },

  {
    "lervag/vimtex",
    ft = "tex",
    dependencies = {
      "iurimateus/luasnip-latex-snippets.nvim",
    },
    config = function()
      require "custom.configs.vimtex"
      utils.load_mappings "vimtex"
      require("luasnip-latex-snippets").setup()
    end,
  },

  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
  },

  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      vim.g.copilot_assume_mapped = true
    end,
  },

  {
    "kevinhwang91/nvim-hlslens",
    event = "SearchWrapped",
    config = function()
      require("hlslens").setup()
    end,
  },

  {
    "christoomey/vim-sort-motion",
    keys = {
      { "gs", mode = "n", desc = "Sort Motion" },
      { "gs", mode = "x", desc = "Sort Motion" },
    },
  },

  {
    "christoomey/vim-titlecase",
    keys = {
      { "gz", mode = "n", desc = "Titlecase" },
      { "gz", mode = "x", desc = "Titlecase" },
    },
  },

  {
    "smoka7/hop.nvim",
    event = "VeryLazy",
    config = function()
      require("hop").setup()
      utils.load_mappings "hop"
    end,
  },

  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        enabled = false,
      },
      "honza/vim-snippets",
    },
    config = function ()
      require("custom.configs.luasnip")
    end
  },

  {
    "tpope/vim-fugitive",
    event = "User FilePost",
    config = function()
      utils.load_mappings "fugitive"
      autocmd("FileType", {
        pattern = "fugitive",
        command = "nnoremap <buffer> cc :vert Git commit<cr> | nnoremap <buffer> gp :Git push<cr>",
      })
    end,
  },

  {
    "https://github.com/tpope/vim-eunuch",
    event = "User FilePost",
  },

  {
    -- automatically adjusts 'shiftwidth' and 'expandtab'
    "tpope/vim-sleuth",
    event = "BufRead",
  },

  {
    "Julian/lean.nvim",
    event = { "BufReadPre *.lean", "BufNewFile *.lean" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
    },
    opts = {
      mappings = true,
    },
  },

  -- {
  --   "andymass/vim-matchup",
  --   event = "CursorMoved",
  --   config = function()
  --     vim.g.matchup_matchparen_offscreen = { method = "popup" }
  --   end,
  -- },

  -- {
  --   "HiPhish/rainbow-delimiters.nvim",
  --   event = "BufReadPre",
  --   config = function()
  --     require("rainbow_delimiters").setup()
  --   end,
  -- },

  {
    "wakatime/vim-wakatime",
    lazy = false,
  },

  -- All NvChad plugins are lazy-loaded by default
  -- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
  -- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
  -- {
  --   "mg979/vim-visual-multi",
  --   lazy = false,
  -- }

  {
    "stevearc/dressing.nvim",
    event = "BufReadPre",
    config = function()
      require("dressing").setup()
    end,
  },

  { -- This plugin
    "Zeioth/compiler.nvim",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    dependencies = {
      {
        "stevearc/overseer.nvim",
        commit = "6271cab7ccc4ca840faa93f54440ffae3a3918bd",
        cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
        opts = {
          task_list = {
            direction = "bottom",
            min_height = 15,
            max_height = 15,
            default_detail = 1,
          },
        },
      },
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("compiler").setup()
      utils.load_mappings "compiler"
    end,
  },
}

return plugins

return {
  {
    "tpope/vim-sleuth",
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    keys = {
      { "ys", mode = "n" },
      { "ds", mode = "n" },
      { "cs", mode = "n" },
      { "S", mode = "v" },
    },
    config = function()
      require("nvim-surround").setup()
    end,
  },
  {
    "christoomey/vim-sort-motion",
    keys = {
      { "gs", mode = { "n", "v" }, desc = "Sort via motion" },
    },
  },
  {
    "christoomey/vim-titlecase",
    keys = {
      { "gz", mode = { "n", "v" }, desc = "Titlecase via motion" },
      { "gzz", mode = { "n" }, desc = "Titlecase line" },
    },
  },
  {
    "nvim-mini/mini.align",
    version = "*",
    keys = {
      { "ga", mode = { "n", "x" }, desc = "Align" },
      { "gA", mode = { "n", "x" }, desc = "Align with preview" },
    },
    config = function()
      require("mini.align").setup()
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup()
    end,
  },
}

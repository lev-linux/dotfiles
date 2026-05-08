return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "nvimdev/lspsaga.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("config.plugins.lsp.setup").setup_mason()
      require("config.plugins.lsp.keymaps").setup_lsp_attach_keymaps()
      require("config.plugins.lsp.setup").setup_diagnostics()
      require("config.plugins.lsp.servers").setup_servers()
    end,
  },
}

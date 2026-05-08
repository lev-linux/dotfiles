local M = {}

function M.setup_mason()
  require("mason").setup({
    ui = {
      icons = {
        package_pending = " ",
        package_installed = "󰄳 ",
        package_uninstalled = " 󰚌",
      },
      border = "rounded",
    },
    max_concurrent_installers = 10,
  })

  require("mason-lspconfig").setup({
    ensure_installed = {
      "bashls",
      "clangd",
      "cssls",
      "html",
      "lua_ls",
      "pylsp",
      "texlab",
    },
    automatic_installation = true,
    automatic_enable = true,
  })
end

function M.setup_diagnostics()
  vim.diagnostic.config({
    signs = {
      priority = 5,
    },
    underline = true,
    virtual_text = {
      spacing = 2,
      prefix = "●",
      severity = { min = vim.diagnostic.severity.HINT },
    },
    float = {
      border = "rounded",
    },
  })

  vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = false, underline = true, sp = "red" })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = false, underline = true, sp = "orange" })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = false, underline = true, sp = "LightBlue" })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = false, underline = true, sp = "LightGreen" })
end

return M

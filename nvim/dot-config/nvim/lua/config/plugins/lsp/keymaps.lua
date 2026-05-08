local M = {}

function M.setup_lsp_attach_keymaps()
  local group = vim.api.nvim_create_augroup("UserLspAttachKeymaps", { clear = true })
  vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(ev)
      local lmap = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc, silent = true })
      end

      lmap("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
      lmap("n", "gd", vim.lsp.buf.definition, "Go to definition")
      lmap("n", "gr", vim.lsp.buf.references, "References")
      lmap("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
      lmap("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end, "Hover docs")
      lmap("n", "<leader>ra", vim.lsp.buf.rename, "Rename symbol")
      lmap("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
      lmap("n", "<leader>fm", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")
      lmap("n", "<leader>lf", function() vim.diagnostic.open_float({ border = "rounded" }) end, "Line diagnostics")
      lmap("n", "<leader>q", vim.diagnostic.setloclist, "Diagnostics to loclist")
      lmap("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
      lmap("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
        "List workspace folders")
      lmap("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, "Prev diagnostic")
      lmap("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
    end,
  })
end

return M

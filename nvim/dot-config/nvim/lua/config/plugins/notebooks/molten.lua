return {
  "benlubas/molten-nvim",
  version = "^1.0.0",
  build = ":UpdateRemotePlugins",
  dependencies = {
    {
      "3rd/image.nvim",
      build = false,
      opts = {
        backend = "ueberzug",
        processor = "magick_cli",
      },
    },
  },
  ft = { "python" },
  config = function()
    local map = vim.keymap.set
    local autocmd = vim.api.nvim_create_autocmd
    local augroup = vim.api.nvim_create_augroup
    vim.g.molten_auto_open_output = false
    vim.g.molten_image_provider = "image.nvim"
    vim.g.molten_wrap_output = true
    vim.g.molten_virt_text_output = true
    vim.g.molten_virt_text_truncate = "bottom"

    local function setup_python_buffer(bufnr)
      local opts = { buffer = bufnr, silent = true }

      vim.cmd("MoltenInit python3")
      map("n", "<leader>mk", "<cmd>MoltenInit<cr>", vim.tbl_extend("force", opts, { desc = "Molten init kernel" }))
      map("n", "<leader>mK", "<cmd>MoltenRestart<cr>", vim.tbl_extend("force", opts, { desc = "Molten restart kernel" }))
      map("n", "<leader>mq", "<cmd>MoltenShutdown<cr>", vim.tbl_extend("force", opts, { desc = "Molten shutdown kernel" }))

      map("n", "<leader>mr", "<cmd>MoltenEvaluateOperator<cr>", vim.tbl_extend("force", opts, { desc = "Run operator" }))
      map("n", "<leader>ml", "<cmd>MoltenEvaluateLine<cr>", vim.tbl_extend("force", opts, { desc = "Run line" }))
      map("v", "<leader>mv", "<cmd>MoltenEvaluateVisual<cr>", vim.tbl_extend("force", opts, { desc = "Run selection" }))

      map("n", "<leader>mo", "<cmd>MoltenOpenOutput<cr>", vim.tbl_extend("force", opts, { desc = "Open output" }))
      map("n", "<leader>mh", "<cmd>MoltenHideOutput<cr>", vim.tbl_extend("force", opts, { desc = "Hide output" }))
      map("n", "<leader>md", "<cmd>MoltenDeleteOutput<cr>", vim.tbl_extend("force", opts, { desc = "Delete output" }))

      map("n", "]m", "<cmd>MoltenNext<cr>", vim.tbl_extend("force", opts, { desc = "Next cell" }))
      map("n", "[m", "<cmd>MoltenPrev<cr>", vim.tbl_extend("force", opts, { desc = "Previous cell" }))

      map("n", "<leader>ma", function()
        vim.api.nvim_put({ "", "# %%", "" }, "l", true, true)
      end, vim.tbl_extend("force", opts, { desc = "Add code cell below" }))

      map("n", "<leader>mm", function()
        vim.api.nvim_put({ "", "# %% [markdown]", "" }, "l", true, true)
      end, vim.tbl_extend("force", opts, { desc = "Add markdown cell below" }))
    end

    local group = augroup("UserMoltenPython", { clear = true })
    autocmd("FileType", {
      group = group,
      pattern = "python",
      callback = function(ev)
        setup_python_buffer(ev.buf)
      end,
    })

    if vim.bo.filetype == "python" then
      setup_python_buffer(vim.api.nvim_get_current_buf())
    end
  end,
}

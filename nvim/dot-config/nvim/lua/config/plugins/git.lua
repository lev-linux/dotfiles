return {
  {
    "tpope/vim-fugitive",
    keys = {
      { "<leader>gs", "<cmd>Git<cr>", desc = "Git status" },
      { "<leader>gc", "<cmd>Git commit<cr>", desc = "Git commit" },
      { "<leader>gp", "<cmd>Git push<cr>", desc = "Git push" },
      { "<leader>gl", "<cmd>Git log --oneline --graph --decorate<cr>", desc = "Git log" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "│", priority = 100 },
        change = { text = "│", priority = 100 },
        delete = { text = "_", priority = 100 },
        topdelete = { text = "‾", priority = 100 },
        changedelete = { text = "~", priority = 100 },
      },
      preview_config = {
        border = "rounded",
      },
      signcolumn = true,
      numhl = false,
      linehl = false,
      word_diff = false,
      current_line_blame = false,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map("n", "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, "Next hunk")

        map("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, "Prev hunk")

        map("n", "<leader>st", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>ph", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame line")
      end,
    },
  },
  {
    "salastro/vim-eunuch-doas",
    cmd = {
      "Rename",
      "Move",
      "Delete",
      "Chmod",
      "Mkdir",
      "SudoWrite",
      "SudoEdit",
      "DoasWrite",
    },
    init = function()
      vim.g.eunuch_use_doas = true
    end,
  },
  {
    "wakatime/vim-wakatime",
    lazy = false,
  },
}

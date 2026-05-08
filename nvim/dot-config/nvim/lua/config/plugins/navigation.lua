local autocmd = vim.api.nvim_create_autocmd
local map = vim.keymap.set

return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
    keys = {
      { "<C-n>", "<cmd>NvimTreeToggle<cr>", desc = "Toggle Explorer" },
      { "<leader>o", "<cmd>NvimTreeFocus<cr>", desc = "Focus Explorer" },
    },
    opts = {
      hijack_cursor = true,
      update_cwd = true,
      respect_buf_cwd = true,
      view = {
        width = 35,
        side = "left",
        preserve_window_proportions = true,
      },
      renderer = {
        highlight_git = true,
        highlight_opened_files = "all",
        indent_markers = {
          enable = true,
        },
        icons = {
          glyphs = {
            git = {
              unstaged = "",
              staged = "✓",
              unmerged = "",
              renamed = "➜",
              untracked = "★",
              deleted = "",
              ignored = "◌",
            },
          },
        },
      },
      git = {
        enable = true,
        ignore = false,
      },
      actions = {
        open_file = {
          quit_on_open = false,
          resize_window = true,
        },
      },
      filters = {
        dotfiles = false,
        custom = { ".DS_Store" },
      },
    },
    config = function(_, opts)
      require("nvim-tree").setup(opts)

      autocmd("BufEnter", {
        nested = true,
        callback = function()
          if #vim.api.nvim_list_wins() == 1 and vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then
            vim.cmd("quit")
          end
        end,
      })
    end,
  },
  {
    "phaazon/hop.nvim",
    branch = "v2",
    lazy = true,
    keys = {
      { "<leader>h", mode = { "n", "v" }, desc = "Hop to char" },
      { "<leader>ww", mode = { "n", "v" }, desc = "Hop to word start" },
    },
    config = function()
      require("hop").setup({
        jump_on_sole_occurrence = true,
        case_insensitive = true,
      })

      local hop = require("hop")
      map("", "<leader>h", function() hop.hint_char1() end, { desc = "Hop to char" })
      map("", "<leader>ww", function() hop.hint_words({}) end, { desc = "Hop to word start" })
    end,
  },
}

return {
  {
    "nvim-lualine/lualine.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("lualine").setup {
        options = {
          theme = "gruvbox",
          globalstatus = true,
        },
      }
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      local mode = vim.fn.system("darkman get"):gsub("%s+", "")
      require("gruvbox").setup({
        contrast = "hard",
        transparent_mode = true,
      })
      if mode == "light" then
        vim.o.background = "light"
      else
        vim.o.background = "dark"
      end
      vim.cmd("colorscheme gruvbox")
    end,
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function()
      require("bqf").setup({
        auto_enable = true,
        auto_resize_height = true,
        preview = {
          win_height = 12,
          win_vheight = 12,
          delay_syntax = 80,
          border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
          show_title = false,
        },
      })
    end,
    keys = {
      { "<leader>qq", "<cmd>copen<cr>", desc = "Toggle quickfix" },
    },
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local map = vim.keymap.set
      vim.opt.termguicolors = true

      require("bufferline").setup {
        highlights = {
          fill = {
            guibg = "NONE",
            ctermbg = "NONE",
          },
          background = {
            guibg = "NONE",
            ctermbg = "NONE",
          },
        },
        options = {
          mode = "buffers",
          numbers = "none",
          diagnostics = "nvim_lsp",
          show_buffer_close_icons = false,
          show_close_icon = false,
          always_show_bufferline = false,
          color_icons = true,
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "center",
              separator = true,
            },
          },
        },
      }

      map("n", "<Tab>", ":BufferLineCycleNext<CR>", { silent = true })
      map("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { silent = true })
      map("n", "<leader>bd", ":bdelete<CR>", { silent = true })

      vim.api.nvim_set_hl(0, "TabLineFill", { bg = "none" })
    end,
  },
}

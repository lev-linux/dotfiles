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
      require("gruvbox").setup({
        contrast = "hard",
        transparent_mode = true,
      })
      vim.o.background = "dark"
      vim.cmd("colorscheme gruvbox")

      local function sync_background()
        vim.system({ "darkman", "get" }, { text = true }, function(obj)
          if obj.code ~= 0 then
            return
          end
          local mode = obj.stdout:gsub("%s+", "")
          vim.schedule(function()
            vim.o.background = (mode == "light") and "light" or "dark"
          end)
        end)
      end

      sync_background()

      -- darkman notifies running instances of a theme switch via SIGUSR1
      local sigusr1 = vim.uv.new_signal()
      sigusr1:start("sigusr1", vim.schedule_wrap(sync_background))
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
      { "<leader>q",
        function()
          local qf_open = vim.tbl_contains(
            vim.tbl_map(function(win)
              return win.quickfix
            end, vim.fn.getwininfo()),
            1
          )

          vim.cmd(qf_open and "cclose" or "copen")
        end,
        desc = "Toggle quickfix",
      },
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

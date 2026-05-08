return {
  {
    "lervag/vimtex",
    ft = { "tex" },
    init = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_quickfix_mode = 2
      vim.g.vimtex_quickfix_open_on_warning = 0
      vim.g.vimtex_complete_enabled = 1
      vim.g.vimtex_indent_enabled = 1
      vim.g.vimtex_format_enabled = 1

      vim.opt.conceallevel = 2
      vim.g.tex_conceal = "abdmg"

      vim.g.vimtex_compiler_latexmk_engines = {
        _ = "-xelatex",
      }
      vim.g.vimtex_compiler_latexmk_continuous = 1
      vim.g.vimtex_compiler_latexmk = {
        out_dir = "output",
        options = {
          "-shell-escape",
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
        },
      }
    end,
    config = function()
      vim.opt_local.spell = true
      vim.opt_local.spelllang = "en_us"
    end,
  },
  {
    "baskerville/vim-sxhkdrc",
    ft = "sxhkdrc",
  },
  {
    "kmonad/kmonad-vim",
    ft = "kbd",
  },
  {
    "PyGamer0/vim-apl",
    ft = "apl",
    config = function()
      local autocmd = vim.api.nvim_create_autocmd
      local augroup = vim.api.nvim_create_augroup
      local Terminal = require("toggleterm.terminal").Terminal
      local apl_repl = Terminal:new({
        cmd = "apl --silent",
        id = 1,
        direction = "horizontal",
        hidden = true,
        close_on_exit = false,
        on_open = function()
          vim.cmd("startinsert!")
        end,
      })

      local function ensure_apl()
        if not apl_repl:is_open() then
          apl_repl:toggle()
        end
      end

      local function setup_apl_buffer(bufnr)
        ensure_apl()

        vim.keymap.set("i", "<C-x>", function()
          require("toggleterm").send_lines_to_terminal("single_line", true, { args = 1 })
        end, { buffer = bufnr, desc = "Send current line to APL REPL" })

        vim.keymap.set("n", "<leader>rr", function()
          require("toggleterm").send_lines_to_terminal("single_line", true, { args = 1 })
        end, { buffer = bufnr, desc = "Send current line to APL REPL" })

        vim.keymap.set("v", "<leader>rr", function()
          require("toggleterm").send_lines_to_terminal("visual_selection", false, { args = 1 })
        end, { buffer = bufnr, desc = "Send visual selection to APL REPL" })
      end

      local group = augroup("UserAplRepl", { clear = true })
      autocmd("FileType", {
        group = group,
        pattern = "apl",
        callback = function(ev)
          setup_apl_buffer(ev.buf)
        end,
      })

      if vim.bo.filetype == "apl" then
        setup_apl_buffer(vim.api.nvim_get_current_buf())
      end
    end,
  },
}

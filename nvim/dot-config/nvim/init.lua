-- Basic options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
-- vim.opt.cursorline = true
-- vim.opt.cursorcolumn = true
vim.opt.mouse = "a"
vim.opt.scrolloff = 5
-- vim.opt.sidescrolloff = 8 -- only makes sense when wrap=false
vim.opt.breakindent = true
vim.opt.showbreak = "↪ "
vim.opt.linebreak = true
vim.opt.showmode = false -- already shown by lualine
vim.opt.showcmd = true
vim.opt.undofile = true
vim.opt.signcolumn = "yes:2"
-- vim.opt.colorcolumn = "80"
vim.opt.fillchars:append("eob: ") -- hide ~ on end of buffer
vim.opt.list = true
vim.opt.listchars = {
  -- space = "·",
  -- lead = "·",
  tab = "→ ",
  -- eol = "¬",
  trail = "•",
  extends = "⟩", -- character when line extends beyond screen
  precedes = "⟨", -- character when text is hidden left of screen
  nbsp = "␣", -- non-breaking space
}
-- vim.cmd [[highlight ExtraWhitespace guibg=red]] -- highlight trailing spaces
-- vim.cmd [[match ExtraWhitespace /\s\+$/]]
vim.api.nvim_set_hl(0, "SpellBad", { undercurl = true, underline = false, sp = "red" })


-- Get back to the position where you left off
local autocmd = vim.api.nvim_create_autocmd
autocmd("BufReadPost", {
  callback = function()
    local last_pos = vim.fn.getpos("'\"") -- last cursor position mark
    local line = last_pos[2]
    local buf_line_count = vim.api.nvim_buf_line_count(0)
    if line > 0 and line <= buf_line_count then
      vim.api.nvim_win_set_cursor(0, { line, last_pos[3] })
    end
  end,
})

-- Remove trailing whitespace, globally or in selection
function TrimTrailingSpaces()
  local save_cursor = vim.fn.getpos(".")
  local _, ls, _ = unpack(vim.fn.getpos("'<"))
  local _, le, _ = unpack(vim.fn.getpos("'>"))
  if ls > 0 and le > 0 and ls ~= le then
    vim.cmd(string.format("%d,%ds/\\s\\+$//e", ls, le))
  else
    vim.cmd([[%s/\s\+$//e]])
  end
  vim.fn.setpos(".", save_cursor)
end

-- Track changed lines
local changed_lines = {}

autocmd({ "TextChanged", "TextChangedI" }, {
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local lnum = vim.fn.line(".")
    if not changed_lines[bufnr] then
      changed_lines[bufnr] = {}
    end
    changed_lines[bufnr][lnum] = true
  end,
})

-- Trim trailing spaces on given line
local function trim_line(bufnr, lnum)
  local line = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1]
  if not line then return end
  local trimmed = line:gsub("%s+$", "")
  if trimmed ~= line then
    vim.api.nvim_buf_set_lines(bufnr, lnum - 1, lnum, false, { trimmed })
  end
end

-- On leaving insert mode, clean up changed lines
autocmd("InsertLeave", {
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    if changed_lines[bufnr] then
      for lnum, _ in pairs(changed_lines[bufnr]) do
        trim_line(bufnr, lnum)
      end
      changed_lines[bufnr] = {} -- reset after cleanup
    end
  end,
})

-- Key maps
local map = vim.keymap.set
map("n", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
map("", ";", ":", { noremap = true })
map("", ":", ";", { noremap = true })
map("", "gl", "$", { noremap = true })
map("", "gh", "^", { noremap = true })
map("i", "jk", "", { noremap = true })
-- map("i", "<C-S>", "<c-g>u<Esc>[s1z=`]a<c-g>u", { noremap = true, silent = true })
-- map("n", "<C-S>", "]s1z=", { noremap = true, silent = true })
map("v", "<", "<gv")
map("v", ">", ">gv")

map("n", "<leader>tw", TrimTrailingSpaces, { desc = "Trim trailing whitespace" })
map("v", "<leader>tw", TrimTrailingSpaces, { desc = "Trim trailing whitespace" })

map('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
map('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
map('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
map('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

map('i', '<C-h>', '<Left>', { noremap = true, silent = true })
map('i', '<C-l>', '<Right>', { noremap = true, silent = true })

-- Lazy Plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  ui = {
    border = "rounded",
  },
  spec = {
    {
      "nvimdev/dashboard-nvim",
      dependencies = { { "nvim-tree/nvim-web-devicons" } },
      event = "VimEnter",
      priority = 1000,
      config = function()
        require("dashboard").setup {
          change_to_vcs_root = true,
          shortcut_type = "number",
          theme = "hyper",
          config = {
            header = {
              "",
              "           ▄ ▄                   ",
              "       ▄   ▄▄▄     ▄ ▄▄▄ ▄ ▄     ",
              "       █ ▄ █▄█ ▄▄▄ █ █▄█ █ █     ",
              "    ▄▄ █▄█▄▄▄█ █▄█▄█▄▄█▄▄█ █     ",
              "  ▄ █▄▄█ ▄ ▄▄ ▄█ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄  ",
              "  █▄▄▄▄ ▄▄▄ █ ▄ ▄▄▄ ▄ ▄▄▄ ▄ ▄ █ ▄",
              "▄ █ █▄█ █▄█ █ █ █▄█ █ █▄█ ▄▄▄ █ █",
              "█▄█ ▄ █▄▄█▄▄█ █ ▄▄█ █ ▄ █ █▄█▄█ █",
              "    █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█ █▄█▄▄▄█    ",
              "",
              "",
            },
            shortcut = {
              {
                icon = "󰊳 ",
                desc = "Update",
                group = "@property",
                action = "Lazy update",
                key = "u",
              },
              {
                icon = "󰈚 ",
                -- icon_hl = "@variable",
                desc = "Files",
                group = "Label",
                action = "Telescope find_files",
                key = "f",
              },
              {
                icon = " ",
                desc = "Bookmarks",
                group = "Number",
                action = "Telescope marks",
                key = "m",
              },
              {
                desc = " New file",
                key = "n",
                action = "enew"
              },
            },
            footer = function()
              local version = vim.version()
              local nvim_version = string.format("v%d.%d.%d", version.major,
                version.minor, version.patch)

              return {
                "",
                " " .. nvim_version
              }
            end
            ,
          },
        }
      end,
    },
    {
      "SirVer/ultisnips",
      event = "InsertEnter",
      dependencies = {
        "honza/vim-snippets", -- huge collection of snippets
      },
      init = function()
        -- Trigger expansion
        vim.g.UltiSnipsExpandTrigger = "<tab>"

        -- Jump forward and backward through snippet fields
        vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
        vim.g.UltiSnipsJumpBackwardTrigger = "<s-tab>"

        -- Split behavior for editing snippets
        vim.g.UltiSnipsEditSplit = "tabdo"

        -- Optional: search your own snippet paths in addition to defaults
        vim.g.UltiSnipsSnippetDirectories = {
          "UltiSnips",
        }
      end,
    },
    {
      "lervag/vimtex",
      ft = { "tex" },
      init = function()
        -- General
        vim.g.vimtex_view_method = "zathura"
        vim.g.vimtex_quickfix_mode = 2
        vim.g.vimtex_quickfix_open_on_warning = 0
        vim.g.vimtex_complete_enabled = 1
        vim.g.vimtex_indent_enabled = 1
        vim.g.vimtex_format_enabled = 1

        -- Conceal
        vim.opt.conceallevel = 2
        vim.g.tex_conceal = 'abdmg'

        -- Ignore mappings (if you want to use your own)
        -- vim.g.vimtex_mappings_enabled = 0
        --

        -- Compiler XeLaTeX
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
        -- Spell
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en_us"
      end
    },
    {
      "nvim-treesitter/nvim-treesitter",
      dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
      },
      build = ":TSUpdate",
      event = { "BufReadPost", "BufNewFile" },
      config = function()
        require("nvim-treesitter.configs").setup({
          modules = {},
          sync_install = false,
          ignore_install = {},
          auto_install = false,

          ensure_installed = {
            "lua", "vim", "vimdoc", "bash",
            "c", "cpp", "python", "javascript", "typescript",
            "html", "css", "json", "yaml", "toml", "markdown",
          },

          highlight = {
            enable = true,
            use_languagetree = true,
            additional_vim_regex_highlighting = false,
          },

          indent = { enable = true },

          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "gnn",
              node_incremental = "grn",
              node_decremental = "grp",
              scope_incremental = "grc",
            },
          },

          textobjects = {
            select = {
              enable = true,
              lookahead = true,
              keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["ab"] = "@block.outer",
                ["ib"] = "@block.inner",
              },
            },
          },
        })
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter-context",
      event = { "BufReadPost", "BufNewFile" },
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      config = function()
        require("treesitter-context").setup({
          enable = true, -- enable by default
          max_lines = 3, -- how many lines of context to show
          min_window_height = 0, -- 0 = no limit
          line_numbers = true, -- show line numbers in context window
          multiline_threshold = 20, -- max lines to show before truncation
          trim_scope = "outer", -- "inner" or "outer" — which scope to trim if too long
          mode = "cursor", -- "cursor" (top line) or "topline"
          separator = "─", -- e.g. "─" to add a line below context
          zindex = 20, -- z-index of the context window
          on_attach = nil, -- function(buf) → disables attaching
        })
      end,
    },
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "nvimdev/lspsaga.nvim",
      },
      event = { "BufReadPre", "BufNewFile" },
      config = function()
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

        -- require('lspsaga').setup({})

        -- vim.ui.input = function(opts, on_confirm)
        --   local buf = vim.api.nvim_create_buf(false, true)
        --   local width = math.max(30, #opts.prompt + 10)
        --   local height = 1
        --
        --   local win = vim.api.nvim_open_win(buf, true, {
        --     relative = "cursor",
        --     row = 1,
        --     col = 2,
        --     width = width,
        --     height = height,
        --     style = "minimal",
        --     border = "rounded",
        --   })
        --
        --   vim.api.nvim_buf_set_option(buf, "buftype", "prompt")
        --   vim.fn.prompt_setprompt(buf, opts.prompt)
        --   vim.fn.prompt_setcallback(buf, function(input)
        --     vim.api.nvim_win_close(win, true)
        --     on_confirm(input)
        --   end)
        --
        --   vim.cmd("startinsert")
        -- end

        vim.api.nvim_create_autocmd("LspAttach", {
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
            lmap("n", "<leader>lf", function() vim.diagnostic.open_float { border = "rounded" } end, "Line diagnostics")
            lmap("n", "<leader>q", vim.diagnostic.setloclist, "Diagnostics to loclist")
            lmap("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
            lmap("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
            lmap("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
              "List workspace folders")
            lmap("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, "Prev diagnostic")
            lmap("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
          end,
        })

        vim.diagnostic.config({
          signs = {
            priority = 5, -- lower than gitsigns
          },
          underline = true,
          virtual_text = {
            spacing = 2, -- space between text and line
            prefix = "●", -- could be "●", "▎", "x"
            severity = { min = vim.diagnostic.severity.HINT }, -- show all severities
          },
          float = {
            border = "rounded",
          },
        })

        vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = false, underline = true, sp = "red" })
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = false, underline = true, sp = "orange" })
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = false, underline = true, sp = "LightBlue" })
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = false, underline = true, sp = "LightGreen" })

        vim.lsp.config["lua_ls"] = {
          cmd = { "lua-language-server" },
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT", -- Neovim uses LuaJIT
              },
              diagnostics = {
                globals = { "vim" }, -- tell lua_ls that "vim" is a global
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false, -- stop asking about third-party
              },
            },
          },
        }
      end,
    },
    {
      "nvim-telescope/telescope.nvim",
      cmd = "Telescope",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "fhill2/telescope-ultisnips.nvim",
      },
      keys = {
        { "<leader>ff", "<cmd>Telescope find_files<cr>",                                          desc = "Find files" },
        { "<leader>fa", "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", desc = "Find all" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>",                                           desc = "Live grep" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>",                                             desc = "Find buffers" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>",                                           desc = "Help tags" },
        { "<leader>fs", "<cmd>Telescope ultisnips<cr>",                                           desc = "Search snippets" },
        { "<leader>fw", "<cmd>Telescope current_buffer_fuzzy_find<cr>",                           desc = "Find in current buffer" },
      },
      config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        telescope.setup({
          defaults = {
            prompt_prefix = "  ",
            selection_caret = "❯ ",
            mappings = {
              i = { ["<ESC>"] = actions.close },
            },
            file_sorter = require("telescope.sorters").get_fuzzy_file,
            generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
          },
        })
        telescope.load_extension("ultisnips")
      end,
    },
    {
      "zbirenbaum/copilot.lua",
      event = "InsertEnter",
      cmd = "Copilot",
      config = function()
        require("copilot").setup({
          panel = { enabled = false },
          suggestion = {
            enabled = false,
          },
          filetypes = {
            markdown = false,
            help = false,
            gitcommit = false,
            ["*"] = true,
          },
        })
      end,
    },
    {
      "zbirenbaum/copilot-cmp",
      dependencies = {
        "zbirenbaum/copilot.lua",
      },
      config = function()
        require("copilot_cmp").setup()
      end,
    },
    {
      "CopilotC-Nvim/CopilotChat.nvim",
      dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "zbirenbaum/copilot.lua" },
      },
      cmd = {
        "CopilotChat",
        "CopilotChatOpen",
        "CopilotChatToggle",
      },
      keys = {
        { "<leader>cc", "<cmd>CopilotChat<cr>",       desc = "Open Copilot Chat" },
        { "<leader>co", "<cmd>CopilotChatOpen<cr>",   desc = "Open Copilot Chat in new tab" },
        { "<leader>ct", "<cmd>CopilotChatToggle<cr>", desc = "Toggle Copilot Chat" },
      },
      opts = {
        model = "claude-opus-4.5",
        temperature = 0.1,
        auto_insert_mode = true,
        window = {
          layout = "vertical",
          width = 0.45,
        },
        sticky = { "$claude-opus-4.5", "#buffer:listed", "#glob", "#selection", },
      },
    },
    {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "quangnguyen30192/cmp-nvim-ultisnips",
        "SirVer/ultisnips",
        "onsails/lspkind.nvim", -- icons
      },
      config = function()
        local cmp = require("cmp")
        local lspkind = require("lspkind")

        cmp.setup({
          snippet = {
            expand = function(args)
              vim.fn["UltiSnips#Anon"](args.body)
            end,
          },
          window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Tab>"] = cmp.mapping(function()
              if cmp.visible() then
                cmp.confirm {
                  behavior = cmp.ConfirmBehavior.Insert,
                  select = true,
                }
              else
                cmp.complete()
              end
            end, { "i", "c" }),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<C-p>"] = cmp.mapping.select_prev_item(),
            ["<C-n>"] = cmp.mapping.select_next_item(),
            ["<Tab>"] = nil,
            ["<S-Tab>"] = nil,
          }),
          sources = cmp.config.sources({
            { name = "copilot" },
            { name = "nvim_lsp" },
            { name = "ultisnips" },
            { name = "buffer" },
            { name = "path" },
          }),
          formatting = {
            format = lspkind.cmp_format({
              mode = "symbol_text", -- show both icon and text
              maxwidth = 50,        -- truncate long entries
              ellipsis_char = "...",
              -- menu = {
              --   nvim_lsp = "[LSP]",
              --   ultisnips = "[Snip]",
              --   buffer = "[Buf]",
              --   path = "[Path]",
              -- },
            }),
          },
          experimental = {
            ghost_text = false, -- inline preview
          },
          sorting = {
            comparators = {
              cmp.config.compare.offset,
              cmp.config.compare.exact,
              cmp.config.compare.score,
              cmp.config.compare.recently_used,
              cmp.config.compare.kind,
              cmp.config.compare.length,
              cmp.config.compare.order,
            },
          },
        })
      end,
    },
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
      end
    },
    {
      "tpope/vim-sleuth",
      event = { "BufReadPost", "BufNewFile" },
    },
    {
      "nvim-tree/nvim-tree.lua",
      dependencies = {
        "nvim-tree/nvim-web-devicons", -- optional, for file icons
      },
      cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
      keys = {
        { "",         "<cmd>NvimTreeToggle<cr>", desc = "Toggle Explorer" },
        { "<leader>o", "<cmd>NvimTreeFocus<cr>",  desc = "Focus Explorer" },
      },
      opts = {
        hijack_cursor = true, -- place cursor at start of filename when opening
        update_cwd = true,    -- change cwd when you open a file
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
          ignore = false, -- show files in .gitignore
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

        -- -- optional: auto-close if nvim-tree is the last buffer
        -- local function is_modified_buffer_open(buffers)
        --   for _, buf in pairs(buffers) do
        --     if buf.name:match("NvimTree_") == nil then
        --       return true
        --     end
        --   end
        --   return false
        -- end

        autocmd("BufEnter", {
          nested = true,
          callback = function()
            if #vim.api.nvim_list_wins() == 1 and
                vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then
              vim.cmd "quit"
            end
          end,
        })
      end,
    },
    {
      "kylechui/nvim-surround",
      version = "*",
      keys = {
        { "ys", mode = "n" },
        { "ds", mode = "n" },
        { "cs", mode = "n" },
        { "S",  mode = "v" },
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
        { "gz",  mode = { "n", "v" }, desc = "Titlecase via motion" },
        { "gzz", mode = { "n" },      desc = "Titlecase line" },
      },
    },
    {
      "phaazon/hop.nvim",
      branch = "v2",
      lazy = true,
      keys = {
        { "<leader>h",  mode = { "n", "v" }, desc = "Hop to char" },
        { "<leader>ww", mode = { "n", "v" }, desc = "Hop to word start" },
      },
      config = function()
        require("hop").setup({
          jump_on_sole_occurrence = true, -- jump immediately if only one match
          case_insensitive = true,
        })

        local hop = require("hop")

        -- Normal mode mappings
        map("", "<leader>h", function() hop.hint_char1() end, { desc = "Hop to char" })
        map("", "<leader>ww", function() hop.hint_words({}) end, { desc = "Hop to word start" })
      end,
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
      "baskerville/vim-sxhkdrc",
      ft = "sxhkdrc",
    },
    {
      "kmonad/kmonad-vim",
      ft = "kbd",
    },
    {
      "tpope/vim-fugitive",
      keys = {
        { "<leader>gs", "<cmd>Git<cr>",                                  desc = "Git status" },
        { "<leader>gc", "<cmd>Git commit<cr>",                           desc = "Git commit" },
        { "<leader>gp", "<cmd>Git push<cr>",                             desc = "Git push" },
        { "<leader>gl", "<cmd>Git log --oneline --graph --decorate<cr>", desc = "Git log" },
        -- { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git blame" },
      },
    },
    {
      "lewis6991/gitsigns.nvim",
      event = { "BufReadPre", "BufNewFile" },
      opts = {
        signs = {
          add          = { text = "│", priority = 100 },
          change       = { text = "│", priority = 100 },
          delete       = { text = "_", priority = 100 },
          topdelete    = { text = "‾", priority = 100 },
          changedelete = { text = "~", priority = 100 },
        },
        preview_config = {
          -- Options passed to nvim_open_win
          border = "rounded"
        },
        -- Sign columns conflicts with LSP diagnostics
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

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then return "]c" end
            vim.schedule(function() gs.next_hunk() end)
            return "<Ignore>"
          end, "Next hunk")

          map("n", "[c", function()
            if vim.wo.diff then return "[c" end
            vim.schedule(function() gs.prev_hunk() end)
            return "<Ignore>"
          end, "Prev hunk")

          -- Actions
          map("n", "<leader>st", gs.stage_hunk, "Stage hunk")
          map("n", "<leader>ph", gs.preview_hunk, "Preview hunk")
          map("n", "<leader>gb", function() gs.blame_line({ full = true, }) end, "Blame line")
        end,
      },
    },
    {
      "tpope/vim-eunuch",
      cmd = {
        "Rename",
        "Move",
        "Delete",
        "Chmod",
        "Mkdir",
        "SudoWrite",
        "SudoEdit",
      },
    },
    {
      "kevinhwang91/nvim-bqf",
      ft = "qf",
      config = function()
        require("bqf").setup()
      end,
    },
    {
      "akinsho/bufferline.nvim",
      event = "VeryLazy",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
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
            mode = "buffers", -- show buffers, not tabs
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

        -- keymaps
        map("n", "<Tab>", ":BufferLineCycleNext<CR>", { silent = true })
        map("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { silent = true })
        map("n", "<leader>bd", ":bdelete<CR>", { silent = true })

        -- highlights
        -- bufferline backgrounds
        vim.api.nvim_set_hl(0, "TabLineFill", { bg = "none" })
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
    {
      "akinsho/toggleterm.nvim",
      version = "*",
      keys = {
        {
          "<A-h>",
          function()
            require("toggleterm.terminal").Terminal:new({
              direction = "horizontal",
              id = 1,
            }):toggle()
          end,
          mode = { "n", "t" },
          desc = "Toggle horizontal terminal",
        },
        {
          "<A-v>",
          function()
            require("toggleterm.terminal").Terminal:new({
              direction = "vertical",
              id = 2,
            }):toggle()
          end,
          mode = { "n", "t" },
          desc = "Toggle vertical terminal",
        },
      },
      config = function()
        require("toggleterm").setup({})

        -- Horizontal terminal
        vim.keymap.set({ "n", "t" }, "<A-h>", function()
          require("toggleterm").toggle(1, nil, nil, "horizontal")
        end, { desc = "Toggle horizontal terminal" })

        -- Vertical terminal
        vim.keymap.set({ "n", "t" }, "<A-v>", function()
          require("toggleterm").toggle(2, nil, nil, "vertical")
        end, { desc = "Toggle vertical terminal" })
      end,
    }
  }
})

local autocmd = vim.api.nvim_create_autocmd
local map = vim.keymap.set

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

        vim.lsp.config["arduino_language_server"] = {
          cmd = {
            "arduino-language-server",
            "-cli-config",
            "/home/salastro/.arduino15/arduino-cli.yaml",
            "-cli",
            "arduino-cli",
            "-clangd", "clangd",
            "-fqbn",
            "esp32:esp32:esp32",
          },
          root_dir = vim.loop.cwd(), -- or a function that returns the sketch root
        }

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
      "yetone/avante.nvim",
      -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
      -- ⚠️ must add this setting! ! !
      build = vim.fn.has("win32") ~= 0
        and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
        or "make",
      event = "VeryLazy",
      version = false, -- Never set this value to "*"! Never!
      ---@module 'avante'
      ---@type avante.Config
      opts = {
        -- add any opts here
        -- this file can contain specific instructions for your project
        instructions_file = "avante.md",
        -- for example
        provider = "copilot",
        providers = {
          claude = {
            endpoint = "https://api.anthropic.com",
            model = "claude-sonnet-4-20250514",
            timeout = 30000, -- Timeout in milliseconds
            extra_request_body = {
              temperature = 0.75,
              max_tokens = 20480,
            },
          },
          moonshot = {
            endpoint = "https://api.moonshot.ai/v1",
            model = "kimi-k2-0711-preview",
            timeout = 30000, -- Timeout in milliseconds
            extra_request_body = {
              temperature = 0.75,
              max_tokens = 32768,
            },
          },
        },
      },
      dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "nvim-mini/mini.pick", -- for file_selector provider mini.pick
        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
        "ibhagwan/fzf-lua", -- for file_selector provider fzf
        "stevearc/dressing.nvim", -- for input provider dressing
        "folke/snacks.nvim", -- for input provider snacks
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua", -- for providers='copilot'
        {
          -- support for image pasting
          "HakonHarnes/img-clip.nvim",
          event = "VeryLazy",
          opts = {
            -- recommended settings
            default = {
              embed_image_as_base64 = false,
              prompt_for_file_name = false,
              drag_and_drop = {
                insert_mode = true,
              },
              -- required for Windows users
              use_absolute_path = true,
            },
          },
        },
        {
          -- Make sure to set this up properly if you have lazy=true
          'MeanderingProgrammer/render-markdown.nvim',
          opts = {
            file_types = { "markdown", "Avante" },
          },
          ft = { "markdown", "Avante" },
        },
      },
    },

    -- {
    --   "CopilotC-Nvim/CopilotChat.nvim",
    --   dependencies = {
    --     { "nvim-lua/plenary.nvim" },
    --     { "zbirenbaum/copilot.lua" },
    --   },
    --   cmd = {
    --     "CopilotChat",
    --     "CopilotChatOpen",
    --     "CopilotChatToggle",
    --   },
    --   keys = {
    --     { "<leader>cc", "<cmd>CopilotChat<cr>",       desc = "Open Copilot Chat" },
    --     { "<leader>co", "<cmd>CopilotChatOpen<cr>",   desc = "Open Copilot Chat in new tab" },
    --     { "<leader>ct", "<cmd>CopilotChatToggle<cr>", desc = "Toggle Copilot Chat" },
    --   },
    --   opts = {
    --     model = "auto",
    --     temperature = 0.1,
    --     auto_insert_mode = true,
    --     window = {
    --       layout = "vertical",
    --       width = 0.45,
    --     },
    --     sticky = { "$auto", "#buffer:listed", "#glob", "#selection", },
    --   },
    -- },
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
        { "<C-n>",     "<cmd>NvimTreeToggle<cr>", desc = "Toggle Explorer" },
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
      "wakatime/vim-wakatime",
      lazy = false,
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
        require("toggleterm").setup({
          size = function(term)
            if term.direction == "horizontal" then
              return 15
            elseif term.direction == "vertical" then
              return vim.o.columns * 0.4
            end
          end,
        })

        -- Horizontal terminal
        map({ "n", "t" }, "<A-h>", function()
          require("toggleterm").toggle(1, nil, nil, "horizontal")
        end, { desc = "Toggle horizontal terminal" })

        -- Vertical terminal
        map({ "n", "t" }, "<A-v>", function()
          require("toggleterm").toggle(2, nil, nil, "vertical")
        end, { desc = "Toggle vertical terminal" })
      end,
    },

    -------------------------
    --  Jupyter Notebooks  --
    -------------------------
    {
      "benlubas/molten-nvim",
      version = "^1.0.0",
      build = ":UpdateRemotePlugins",
      dependencies = {
        {
          "3rd/image.nvim",
          build = false,      -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
          opts = {
            backend = "ueberzug", -- or "kitty" or "sixel"
            processor = "magick_cli",
          }
        },
      },
      ft = { "python" },
      config = function()
        -- Molten options
        vim.g.molten_auto_open_output = false
        vim.g.molten_image_provider = "image.nvim"
        vim.g.molten_wrap_output = true
        vim.g.molten_virt_text_output = true
        vim.g.molten_virt_text_truncate = "bottom"

        local map = vim.keymap.set

        -- Buffer-local keymaps
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "python",
          callback = function(ev)
            local opts = { buffer = ev.buf, silent = true }

            vim.cmd("MoltenInit python3")
            -- Kernel
            map("n", "<leader>mk", "<cmd>MoltenInit<cr>", vim.tbl_extend("force", opts, { desc = "Molten init kernel" }))
            map("n", "<leader>mK", "<cmd>MoltenRestart<cr>",
              vim.tbl_extend("force", opts, { desc = "Molten restart kernel" }))
            map("n", "<leader>mq", "<cmd>MoltenShutdown<cr>",
              vim.tbl_extend("force", opts, { desc = "Molten shutdown kernel" }))

            -- Execution
            map("n", "<leader>mr", "<cmd>MoltenEvaluateOperator<cr>",
              vim.tbl_extend("force", opts, { desc = "Run operator" }))
            map("n", "<leader>ml", "<cmd>MoltenEvaluateLine<cr>", vim.tbl_extend("force", opts, { desc = "Run line" }))
            map("v", "<leader>mv", "<cmd>MoltenEvaluateVisual<cr>",
              vim.tbl_extend("force", opts, { desc = "Run selection" }))

            -- Output
            map("n", "<leader>mo", "<cmd>MoltenOpenOutput<cr>", vim.tbl_extend("force", opts, { desc = "Open output" }))
            map("n", "<leader>mh", "<cmd>MoltenHideOutput<cr>", vim.tbl_extend("force", opts, { desc = "Hide output" }))
            map("n", "<leader>md", "<cmd>MoltenDeleteOutput<cr>",
              vim.tbl_extend("force", opts, { desc = "Delete output" }))

            -- Navigation
            map("n", "]m", "<cmd>MoltenNext<cr>", vim.tbl_extend("force", opts, { desc = "Next cell" }))
            map("n", "[m", "<cmd>MoltenPrev<cr>", vim.tbl_extend("force", opts, { desc = "Previous cell" }))

            -- Create cells
            map("n", "<leader>ma", function()
              -- code cell
              vim.api.nvim_put({ "", "# %%", "" }, "l", true, true)
            end, vim.tbl_extend("force", opts, { desc = "Add code cell below" }))

            map("n", "<leader>mm", function()
              -- markdown cell
              vim.api.nvim_put({ "", "# %% [markdown]", "" }, "l", true, true)
            end, vim.tbl_extend("force", opts, { desc = "Add markdown cell below" }))
          end,
        })
      end,
    },

    {
      "GCBallesteros/NotebookNavigator.nvim",
      keys = {
        { "]h",        function() require("notebook-navigator").move_cell "d" end },
        { "[h",        function() require("notebook-navigator").move_cell "u" end },
        { "<leader>X", "<cmd>lua require('notebook-navigator').run_cell()<cr>" },
        { "<leader>x", "<cmd>lua require('notebook-navigator').run_and_move()<cr>" },
      },
      dependencies = {
        -- "anuvyklack/hydra.nvim",
      },
      event = "VeryLazy",
      config = function()
        local nn = require "notebook-navigator"
        -- nn.setup({ activate_hydra_keys = "<leader>h" })
        nn.setup({
          repl_provider = "molten"
        })
      end,
    },

    {
      "GCBallesteros/jupytext.nvim",
      config = function()
        require("jupytext").setup({
          style = "percent",
          output_extension = "py",
          force_ft = nil,
          custom_language_formatting = {},
        })
      end,
    },

    {
      "PyGamer0/vim-apl",
      ft = "apl",
      config = function()
        local Terminal = require("toggleterm.terminal").Terminal

        local apl_repl = Terminal:new({
          cmd = "apl --silent",
          id = 1,
          direction = "horizontal",
          hidden = true,
          close_on_exit = false,
          on_open = function(term)
            vim.cmd("startinsert!")
          end,
        })

        -- function to ensure REPL is running
        local function ensure_apl()
          if not apl_repl:is_open() then
            apl_repl:toggle()
          end
        end

        -- auto-start REPL when opening APL files
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "apl",
          callback = function()
            ensure_apl()

            vim.keymap.set("i", "<C-x>", function()
              -- ensure_apl()
              require("toggleterm").send_lines_to_terminal("single_line", true, { args = 1 })
            end, { desc = "Send current line to APL REPL" })

            vim.keymap.set("n", "<leader>rr", function()
              -- ensure_apl()
              require("toggleterm").send_lines_to_terminal("single_line", true, { args = 1 })
            end, { desc = "Send current line to APL REPL" })

            vim.keymap.set("v", "<leader>rr", function()
              -- ensure_apl()
              require("toggleterm").send_lines_to_terminal("visual_selection", false, { args = 1 })
            end, { desc = "Send visual selection to APL REPL" })
          end,
        })
      end
    },

  }
})

-- Zathura
vim.g.vimtex_view_method = "zathura_simple"

-- Compiler XeLaTeX
vim.g.vimtex_compiler_latexmk_engines = {
  _ = "-xelatex",
}

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

-- Conceal
vim.opt.conceallevel = 2
vim.g.tex_conceal = "abdmgs"

-- Quick fix
vim.g.vimtex_quickfix_open_on_warning = 0

-- Local leader
vim.g.maplocalleader = " "

-- Spell
vim.opt.spell = true

-- Inkscape
function _G.inkscape_figure()
  -- Get current line and root directory
  local line = vim.fn.getline "."
  local root = vim.fn.expand "%:p:h"

  -- Create command
  -- inkscap-figures create <line> <root>/figures/
  local command = string.format('silent .!inkscape-figures create "%s" "%s/figures/"', line, root)

  -- Run command
  vim.cmd(command)
  vim.cmd "write"
end

-- Drag PDF
function _G.dragPDF()
  -- Get current file name without extension
  local file = vim.fn.expand "%:t:r"

  -- Get the output directory from vimtex_compiler_latexmk
  local output = vim.g.vimtex_compiler_latexmk.out_dir

  -- Create the file path
  if output or output == "" then
    file = string.format("%s/%s", output, file)
  end

  -- Create command
  -- setsid dragon-drop [<output>/]<file>.pdf &
  local command = string.format("silent !setsid dragon-drop %s.pdf &", file)

  -- Run command
  vim.cmd(command)

  -- Normal mode
  vim.cmd "stopinsert"
end

-- Command and Env surround
require("nvim-surround").buffer_setup {
  surrounds = {
    -- Command
    ["c"] = {
      add = function()
        local cmd = require("nvim-surround.config").get_input "Command: "
        return { { "\\" .. cmd .. "{" }, { "}" } }
      end,
    },
    -- Environment
    ["e"] = {
      add = function()
        local env = require("nvim-surround.config").get_input "Environment: "
        return { { "\\begin{" .. env .. "}" }, { "\\end{" .. env .. "}" } }
      end,
    },
    -- \left\ \right\
    ["("] = {
      add = function()
        return { { "\\left( " }, { " \\right)" } }
      end,
    },
    ["{"] = {
      add = function()
        return { { "\\left{ " }, { " \\right}" } }
      end,
    },
    ["["] = {
      add = function()
        return { { "\\left[ " }, { " \\right]" } }
      end,
    },
    ["l"] = {
      add = function()
        local left = require("nvim-surround.config").get_input "Left: "
        local right = require("nvim-surround.config").get_input "Right: "
        return { { "\\left" .. left }, { "\\right" .. right } }
      end,
    },
  },
}

-- Folds
vim.g.vimtex_fold_enabled = 1

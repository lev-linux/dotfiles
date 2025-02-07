-- Load autocommands
vim.loader.enable()
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Relative numbering
vim.opt.rnu = true

-- Auto commands
autocmd("BufWritePost", { -- Reload kmonad
  pattern = "*.kbd",
  command = "!pkill kmonad; setsid kmonad %:p &",
})
autocmd("BufReadPost", { -- Open the last edited position
  pattern = "*",
  command = 'if line("\'\\"") > 1 && line("\'\\"") <= line("$") | exe "normal! g\'\\"" | endif',
})
autocmd("VimResized", { -- Resize splits
  pattern = "*",
  command = "tabdo wincmd =",
})

-- Sudo Write
vim.cmd [[
  command! W execute 'w !doas tee % > /dev/null' | edit!
  command! Wq execute 'w !doas tee % > /dev/null' | quit
  command! WQ execute 'w !doas tee % > /dev/null' | quit
  command! Wqa execute 'w !doas tee % > /dev/null' | qall
  command! WQa execute 'w !doas tee % > /dev/null' | qall
]]

-- Load custom settings
require "custom.functions"

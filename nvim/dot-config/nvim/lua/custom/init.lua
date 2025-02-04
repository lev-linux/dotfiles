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
  command! W w !doas tee % > /dev/null
  command! Wq wq !doas tee % > /dev/null
  command! Wq wq !doas tee % > /dev/null
  command! WQ wq !doas tee % > /dev/null
  command! Wqa wqa !doas tee % > /dev/null
  command! WQa wqa !doas tee % > /dev/null
]]

-- Load custom settings
require "custom.functions"

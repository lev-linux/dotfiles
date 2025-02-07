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
local sudo = vim.fn.executable("doas") == 1 and "doas" or (vim.fn.executable("sudo") == 1 and "sudo" or nil)

if sudo then
  local function sudo_write()
    vim.cmd(string.format("write !%s tee %s > /dev/null", sudo, vim.fn.expand("%")))
    vim.cmd("edit!")
  end

  vim.api.nvim_create_user_command("W", sudo_write, {})

  vim.api.nvim_create_user_command("Wq", function()
    sudo_write()
    vim.cmd("quit")
  end, {})

  vim.api.nvim_create_user_command("WQ", function()
    sudo_write()
    vim.cmd("quit")
  end, {})

  vim.api.nvim_create_user_command("Wqa", function()
    sudo_write()
    vim.cmd("qall")
  end, {})

  vim.api.nvim_create_user_command("WQa", function()
    sudo_write()
    vim.cmd("qall")
  end, {})
end

-- Load custom settings
require "custom.functions"

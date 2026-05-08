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

-- Key maps
local map = vim.keymap.set
map("n", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
map("", ";", ":", { noremap = true })
map("", ":", ";", { noremap = true })
map("", "gl", "$", { noremap = true })
map("", "gh", "^", { noremap = true })
map("i", "jk", "\27", { noremap = true })
-- map("i", "<C-S>", "<c-g>u<Esc>[s1z=`]a<c-g>u", { noremap = true, silent = true })
-- map("n", "<C-S>", "]s1z=", { noremap = true, silent = true })
map("v", "<", "<gv")
map("v", ">", ">gv")

map("n", "<leader>tw", TrimTrailingSpaces, { desc = "Trim trailing whitespace" })
map("v", "<leader>tw", TrimTrailingSpaces, { desc = "Trim trailing whitespace" })

map("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
map("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
map("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
map("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

map("i", "<C-h>", "<Left>", { noremap = true, silent = true })
map("i", "<C-l>", "<Right>", { noremap = true, silent = true })

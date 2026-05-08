local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.termguicolors = true
opt.clipboard = "unnamedplus"
opt.splitright = true
opt.splitbelow = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
-- opt.cursorline = true
-- opt.cursorcolumn = true
opt.mouse = "a"
opt.scrolloff = 5
-- opt.sidescrolloff = 8 -- only makes sense when wrap=false
opt.breakindent = true
opt.showbreak = "↪ "
opt.linebreak = true
opt.showmode = false -- already shown by lualine
opt.showcmd = true
opt.undofile = true
opt.signcolumn = "yes:2"
-- opt.colorcolumn = "80"
opt.fillchars:append("eob: ") -- hide ~ on end of buffer
opt.list = true
opt.listchars = {
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

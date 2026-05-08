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

local spec = {}

local groups = {
  "config.plugins.treesitter",
  "config.plugins.lsp",
  "config.plugins.search",
  "config.plugins.completion",
  "config.plugins.ai",
  "config.plugins.ui",
  "config.plugins.navigation",
  "config.plugins.editing",
  "config.plugins.git",
  "config.plugins.terminals",
  "config.plugins.languages",
  "config.plugins.notebooks",
}

for _, group in ipairs(groups) do
  vim.list_extend(spec, require(group))
end

require("lazy").setup({
  ui = {
    border = "rounded",
  },
  spec = spec,
})

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local group = augroup("UserConfigAutocmds", { clear = true })

-- Get back to the position where you left off
autocmd("BufReadPost", {
  group = group,
  callback = function()
    local last_pos = vim.fn.getpos("'\"") -- last cursor position mark
    local line = last_pos[2]
    local buf_line_count = vim.api.nvim_buf_line_count(0)
    if line > 0 and line <= buf_line_count then
      vim.api.nvim_win_set_cursor(0, { line, last_pos[3] })
    end
  end,
})

-- Track changed lines
local changed_lines = {}

autocmd({ "TextChanged", "TextChangedI" }, {
  group = group,
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    if not vim.bo[bufnr].modifiable or vim.bo[bufnr].buftype ~= "" then
      return
    end
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
  if not line then
    return
  end
  local trimmed = line:gsub("%s+$", "")
  if trimmed ~= line then
    vim.api.nvim_buf_set_lines(bufnr, lnum - 1, lnum, false, { trimmed })
  end
end

-- On leaving insert mode, clean up changed lines
autocmd("InsertLeave", {
  group = group,
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    if not vim.bo[bufnr].modifiable or vim.bo[bufnr].buftype ~= "" then
      return
    end
    if changed_lines[bufnr] then
      for lnum, _ in pairs(changed_lines[bufnr]) do
        trim_line(bufnr, lnum)
      end
      changed_lines[bufnr] = {} -- reset after cleanup
    end
  end,
})

autocmd({ "BufWipeout", "BufDelete" }, {
  group = group,
  callback = function(ev)
    changed_lines[ev.buf] = nil
  end,
})

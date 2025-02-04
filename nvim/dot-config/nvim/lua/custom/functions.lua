-- Quickfix
function ToggleQuickFix()
  local wininfo = vim.fn.getwininfo()
  local has_quickfix = false

  for _, info in ipairs(wininfo) do
    if info.quickfix == 1 then
      has_quickfix = true
      break
    end
  end

  if not has_quickfix then
    vim.cmd "copen"
  else
    vim.cmd "cclose"
  end
end

-- Function to compile and run the current C++ file
function CompileAndRun()
  -- Use nvterm
  local nvterm = require "nvterm.terminal"

  -- Save the current file
  vim.cmd "w"

  -- Check if Makefile exists
  if vim.fn.filereadable "Makefile" == 1 then
    -- Run make
    vim.cmd "CompilerOpen"
    return
  end

  -- Get the current file name and file type
  local filetype = vim.bo.filetype
  local filename = vim.fn.expand "%"
  local output = vim.fn.expand "%:r" -- Gets the filename without the extension

  -- Define a table to store compile and run commands based on file type
  local commands = {
    cpp = {
      compile = "g++ -std=c++20 -o " .. output .. " " .. filename,
      run = "./" .. output,
    },
    c = {
      compile = "gcc -std=c11 -o " .. output .. " " .. filename,
      run = "./" .. output,
    },
    python = {
      run = "python3 " .. filename,
    },
    javascript = {
      run = "node " .. filename,
    },
    lua = {
      run = "lua " .. filename,
    },
    sh = {
      run = "sh " .. filename,
    },
    bash = {
      run = "bash " .. filename,
    },
    zsh = {
      run = "zsh " .. filename,
    },
    fish = {
      run = "fish " .. filename,
    },
  }

  -- Get the commands for the current file type
  local cmd = commands[filetype]

  if cmd then
    -- If there is a compile command, set makeprg and compile
    if cmd.compile then
      vim.bo.makeprg = cmd.compile
      vim.cmd "make"

      -- If there is an error, return
      if vim.fn.len(vim.fn.getqflist()) ~= 0 then
        print "Compilation failed"
        return
      end
    end

    -- Run the executable or script
    nvterm.send(cmd.run, "horizontal")
  else
    print("Unsupported file type: " .. filetype)
  end
end

-- Dragon and drop
function DragAndDrop()
  local filename = vim.fn.expand "%"
  local command = "setsid dragon-drop " .. filename .. " &"
  vim.fn.system(command)
end

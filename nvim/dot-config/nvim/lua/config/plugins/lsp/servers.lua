local M = {}

function M.setup_servers()
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
    root_dir = vim.loop.cwd(),
  }

  vim.lsp.config["lua_ls"] = {
    cmd = { "lua-language-server" },
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
      },
    },
  }
end

return M

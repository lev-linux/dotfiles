local map = vim.keymap.set

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      {
        "<A-h>",
        function()
          require("toggleterm.terminal").Terminal:new({
            direction = "horizontal",
            id = 1,
          }):toggle()
        end,
        mode = { "n", "t" },
        desc = "Toggle horizontal terminal",
      },
      {
        "<A-v>",
        function()
          require("toggleterm.terminal").Terminal:new({
            direction = "vertical",
            id = 2,
          }):toggle()
        end,
        mode = { "n", "t" },
        desc = "Toggle vertical terminal",
      },
    },
    config = function()
      require("toggleterm").setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
      })

      map({ "n", "t" }, "<A-h>", function()
        require("toggleterm").toggle(1, nil, nil, "horizontal")
      end, { desc = "Toggle horizontal terminal" })

      map({ "n", "t" }, "<A-v>", function()
        require("toggleterm").toggle(2, nil, nil, "vertical")
      end, { desc = "Toggle vertical terminal" })
    end,
  },
}

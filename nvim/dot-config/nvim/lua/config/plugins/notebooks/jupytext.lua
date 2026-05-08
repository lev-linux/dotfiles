return {
  "GCBallesteros/jupytext.nvim",
  config = function()
    require("jupytext").setup({
      style = "percent",
      output_extension = "py",
      force_ft = nil,
      custom_language_formatting = {},
    })
  end,
}

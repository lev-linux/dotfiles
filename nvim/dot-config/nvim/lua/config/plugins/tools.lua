return {
  {
    "salastro/vim-eunuch-doas",
    cmd = {
      "Rename",
      "Move",
      "Delete",
      "Chmod",
      "Mkdir",
      "SudoWrite",
      "SudoEdit",
      "DoasWrite",
    },
    init = function()
      vim.g.eunuch_use_doas = true
    end,
  },
  {
    "wakatime/vim-wakatime",
    lazy = false,
  },

}

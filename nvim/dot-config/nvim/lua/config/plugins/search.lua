return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "fhill2/telescope-ultisnips.nvim",
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>",                                          desc = "Find files" },
      { "<leader>fa", "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", desc = "Find all" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>",                                           desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",                                             desc = "Find buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>",                                           desc = "Help tags" },
      { "<leader>fs", "<cmd>Telescope ultisnips<cr>",                                           desc = "Search snippets" },
      { "<leader>fw", "<cmd>Telescope current_buffer_fuzzy_find<cr>",                           desc = "Find in current buffer" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      telescope.setup({
        defaults = {
          prompt_prefix = "  ",
          selection_caret = "❯ ",
          mappings = {
            i = { ["<ESC>"] = actions.close },
          },
          file_sorter = require("telescope.sorters").get_fuzzy_file,
          generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        },
      })
      telescope.load_extension("ultisnips")
    end,
  },
}

local map = vim.keymap.set
local opt = { noremap = true, silent = true }
map('n', '<leader>p', '<cmd>Telescope find_files<CR>', opt)
map('n', '<leader>fp', '<cmd>lua require(\'telescope.builtin\').find_files({ hidden = true })<CR>', opt)
map('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', opt)
map('n', '<leader>fb', '<cmd>Telescope buffers<CR>', opt)
map('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', opt)

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-lua/popup.nvim",
      "nvim-tree/nvim-web-devicons",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    cmd = "Telescope",
    version = false,
    opts = {
      defaults = {
        scroll_strategy = "cycle",
        selection_strategy = "reset",
        layout_strategy = "flex",
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        layout_config = {
          horizontal = {
            width = 0.8,
            height = 0.8,
            preview_width = 0.6,
          },
          vertical = {
            height = 0.8,
            preview_height = 0.5,
          },
        },
        mappings = {
          i = {
            ['<esc>'] = "close",
            ['<C-j>'] = "move_selection_next",
            ['<C-k>'] = "move_selection_previous",
          },
        },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension "fzf" -- Sorter using fzf algorithm
    end
  }
}

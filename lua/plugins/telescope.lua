local actions = require('telescope.actions')

require('telescope').setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--hidden',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    layout_config = {
      horizontal = {
        mirror = false,
        width = 0.8,
        preview_width = 0.6,
      }
    },
    file_ignore_patterns = { '.git/', 'node_modules/', '.yarn/' },
    winblend = 10,
    mappings = {
      i = {
        ['<esc>'] = actions.close,
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
      },
    },
  }
}

local opt = { noremap = true, silent = true }
vim.api.nvim_set_keymap( 'n', '<C-p>', '<cmd>lua require(\'telescope.builtin\').find_files({ hidden = true })<CR>', opt)
vim.api.nvim_set_keymap( 'n', '<leader>fg', '<cmd>Telescope live_grep<CR>', opt)
vim.api.nvim_set_keymap( 'n', '<leader>fb', '<cmd>Telescope buffers<CR>', opt)
vim.api.nvim_set_keymap( 'n', '<leader>fh', '<cmd>Telescope help_tags<CR>', opt)

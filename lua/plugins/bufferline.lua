local bufferline = require('bufferline')

-- Bufferline Settings
bufferline.setup {
  options = {
    numbers = 'ordinal',
    number_style = '',
    max_name_length = 18,
    max_prefix_length = 13,
    tab_size = 18,
    diagnostics = 'nvim_lsp',
    enforce_regular_tabs = false,
    view = 'multiwindow',
    offsets = {
      { filetype = 'NvimTree', text = 'File Explorer', text_align = 'center' },
      { filetype = 'vista_kind', text = 'Lsp Symbols', text_align = 'center' }
    },
    show_buffer_close_icons = true,
    separator_style = 'slant'
  },
}

-- Bufferline shortcuts
-- Switch buffer
for i = 1,9 do
  vim.api.nvim_set_keymap(
    'n', '<A-'..i..'>', ':lua require(\'bufferline\').go_to_buffer('..i..')<CR>',
    { noremap = true, silent = true }
  )
end
-- Close buffer
vim.api.nvim_set_keymap('n', '<A-c>', '<cmd>bdelete<CR>', { noremap = true, silent = true })
-- Move buffer
vim.api.nvim_set_keymap('n', '<A-l>', '<cmd>BufferLineCycleNext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-h>', '<cmd>BufferLineCyclePrev<CR>', { noremap = true, silent = true })
-- Change order
vim.api.nvim_set_keymap('n', '<A-L>', '<cmd>BufferLineMoveNext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-H>', '<cmd>BufferLineMovePrev<CR>', { noremap = true, silent = true })

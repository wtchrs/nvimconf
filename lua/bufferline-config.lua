-- Bufferline Settings
require('bufferline').setup {
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

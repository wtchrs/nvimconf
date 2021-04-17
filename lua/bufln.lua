-- Bufferline Settings

require "bufferline".setup {
  options = {
    max_name_length = 14,
    max_prefix_length = 13,
    tab_size = 18,
    diagnostics = "nvim_lsp",
    enforce_regular_tabs = false,
    view = "multiwindow",
    show_buffer_close_icons = true,
    separator_style = "slant"
  }
}

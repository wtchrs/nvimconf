require'nvim-tree'.setup {
  hijack_cursor = true,
  diagnostics = {
    enable = false
  },
  update_focused_file = {
    enable = true,
  },

  view = {
    width = 30,
    height = 30,
    side = 'right',
    auto_resize = false,
    mappings = {
      custom_only = false,
      list = {}
    }
  }
}

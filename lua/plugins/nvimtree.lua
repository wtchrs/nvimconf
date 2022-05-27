require('nvim-tree').setup {
  hijack_cursor = true,
  diagnostics = {
    enable = false
  },
  renderer = {
    indent_markers = {
      enable = true
    }
  },
  actions = {
    open_file = {
      quit_on_open = true
    }
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

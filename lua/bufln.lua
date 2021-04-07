-- Bufferline Settings

require "bufferline".setup {
  options = {
    max_name_length = 14,
    max_prefix_length = 13,
    tab_size = 18,
    enforce_regular_tabs = true,
    view = "multiwindow",
    show_buffer_close_icons = true,
    separator_style = "thin"
  },

  -- bufferline colors
  highlights = {
    fill = {
      guibg = "#2E3440"
    },
    background = {
      guibg = "#2A2F3B"
    },
    buffer_selected = {
      guibg = "#41495A",
      gui="bold"
    },
    buffer_visible = {
      guibg = "#2E3440"
    },
    tab_close = {
      guibg = "#282F38"
    },
    tab_selected = {
      guibg = "#282F38"
    },
    separator_selected = {
      guifg = "#41495A",
      guibg = "#41495A"
    },
    separator = {
      guifg = "#2E3440",
      guibg = "#2E3440"
    },
    indicator_selected = {
      guifg = "#41495A",
      guibg = "#41495A"
    },
    modified_selected = {
      guifg = "#98C379",
      guibg = "#41495A"
    },
    modified = {
      guifg = "#98C379"
    }
  }
}

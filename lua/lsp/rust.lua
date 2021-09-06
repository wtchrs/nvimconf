local opts = {
  tools = {
    autoSetHints = true,
    hover_with_actions = true,

    runnables = {
      use_telescope = true
    },

    debuggables = {
      use_telescope = true
    },

    inlay_hints = {
      only_current_line = false,
      only_current_line_autocmd = "CursorHold",
      show_parameter_hints = false,
      parameter_hints_prefix = "<- ",
      other_hints_prefix = " => ",
      max_len_align = false,
      max_len_align_padding = 1,
      right_align = false,
      right_align_padding = 7,
      highlight = "Comment",
    },

    hover_actions = {
      border = {
        {"╭", "FloatBorder"}, {"─", "FloatBorder"},
        {"╮", "FloatBorder"}, {"│", "FloatBorder"},
        {"╯", "FloatBorder"}, {"─", "FloatBorder"},
        {"╰", "FloatBorder"}, {"│", "FloatBorder"}
      },

      auto_focus = false
    }
  },

  server = {}
}

require('rust-tools').setup(opts)

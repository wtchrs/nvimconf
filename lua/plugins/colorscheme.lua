return {
  {
    "shaunsingh/nord.nvim",
    config = function()
      vim.g.nord_disable_background = true
      vim.g.nord_italic = false
    end,
    on_highlights = function(hl, c)
      hl.TabLineFill = { bg = c.none }
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "nord",
    },
  },
}

return {
  {
    "shaunsingh/nord.nvim",
    config = function()
      vim.g.nord_disable_background = true
      vim.g.nord_italic = false
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "nord",
    },
  },
}

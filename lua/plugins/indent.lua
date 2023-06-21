return {
  {
    "lukas-reineke/indent-blankline.nvim",
    version = false,
    opts = {
      filetype_exclude = {'help', 'dashboard'},
      use_treesitter = true,
      show_current_context = true,
      show_trailing_blankline_indent = false,
    },
    config = function(_, opts)
      require("indent_blankline").setup(opts)
    end
  }
}

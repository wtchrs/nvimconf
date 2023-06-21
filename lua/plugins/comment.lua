return {
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {
      ignore = "^$",
      toggler = {
        line = '<Leader>/',
      },
      opleader = {
        line = '<Leader>/',
      },
    },
    config = function(_, opts)
      require("Comment").setup(opts)
    end
  }
}

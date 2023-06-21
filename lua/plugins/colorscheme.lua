return {
  {
    "shaunsingh/nord.nvim",
    config = function()
      vim.g.nord_borders = true
      require('nord').set()
    end
  }
}

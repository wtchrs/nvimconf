return {
  {
    "andymass/vim-matchup",
    config = function()
      vim.g.matchup_matchparen_offscreen = {
        method = "popup",
        fullwidth = true,
        highlight = "Normal"
      }
    end
  },
}

local cmp_window = require("cmp.config.window")

local win_opt = {
  -- winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
  winhighlight = "CursorLine:PmenuSel,Search:None",
}

return {
  {
    "hrsh7th/nvim-cmp",
    config = {
      window = {
        completion = cmp_window.bordered(win_opt),
        documentation = cmp_window.bordered(win_opt),
      },
    },
  },

  {
    "folke/noice.nvim",
    opts = {
      presets = {
        lsp_doc_border = true,
      },
    },
  },
}

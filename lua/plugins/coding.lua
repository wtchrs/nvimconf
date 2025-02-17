return {
  "tikhomirov/vim-glsl",

  {
    "saghen/blink.cmp",
    lazy = false,
    opts = {
      completion = {
        menu = {
          border = "rounded",
        },
        documentation = {
          window = {
            border = "rounded",
          },
        },
      },
    },
  },

  {
    "folke/noice.nvim",
    opts = {
      presets = {
        lsp_doc_border = true,
      },
      views = {
        hover = {
          border = {
            padding = { 0, 1 },
          },
        },
      },
    },
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ui = {
        border = "rounded",
      },
    },
  },
}

return {
  {
    "saghen/blink.cmp",
    version = "1.*",
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

  { "tikhomirov/vim-glsl" },

  {
    "benomahony/uv.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    ft = "python",
    opts = {
      auto_activate_venv = true,
      notify_activate_venv = true,
      keymaps = {
        prefix = "<leader>p",
        -- venv = false,
        -- init = false,
      },
    },
  },
}

return {
  "tikhomirov/vim-glsl",

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

  {
    "mason-org/mason.nvim",
    -- version = "1.11.0",
    opts = {
      ui = {
        border = "rounded",
      },
    },
  },

  {
    "mason-org/mason-lspconfig.nvim",
    -- version = "1.32.0",
  },

  {
    "benomahony/uv.nvim",
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
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
  },

  "goerz/jupytext.nvim",
}

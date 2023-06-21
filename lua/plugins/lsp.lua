local servers = {
  "lua_ls",
  "cmake",
  "clangd",
  "bashls",
  "cssls",
  "html",
  "emmet_ls",
  "tsserver",
  "jsonls",
  "vimls",
  "pyright"
}

local server_settings = {
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = {"vim"}
        }
      }
    }
  }
}

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
    },
    config = function()
      local lspconfig = require('lspconfig')

      for _, server in ipairs(servers) do
        local option = server_settings[server] or {}
        lspconfig[server].setup(option)
      end
    end
  },

  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function(_, opts)
      require("mason").setup(opts)
    end
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {
      ensure_installed = servers,
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
    end
  }
}

return {
  -- Disable Mason
  { "mason-org/mason.nvim", enabled = false },
  { "mason-org/mason-lspconfig.nvim", enabled = false },
  { "jay-babu/mason-nvim-dap.nvim", enabled = false },

  {
    "neovim/nvim-lspconfig",
    dependencies = {},

    opts = function(_, opts)
      opts.servers = opts.servers or {}

      -- Overwrite default lua_ls server settings
      opts.servers.lua_ls = vim.tbl_deep_extend("force", opts.servers.lua_ls or {}, {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                vim.env.VIMRUNTIME .. "/lua",
              },
            },
          },
        },
      })

      -- Set `mason = false` for all lsp servers
      for server, server_opts in pairs(opts.servers) do
        if server_opts == true then
          opts.servers[server] = { mason = false }
        elseif type(server_opts) == "table" then
          server_opts.mason = false
        end
      end
    end,
  },

  { "stevearc/conform.nvim", dependencies = {} },
  { "mfussenegger/nvim-lint", dependencies = {} },
}

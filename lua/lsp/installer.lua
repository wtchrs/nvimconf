local servers = {
  "sumneko_lua",
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

require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = servers,
}

-- local lsp_installer = require "nvim-lsp-installer"

-- for _, name in pairs(servers) do
--   local server_is_found, server = lsp_installer.get_server(name)
--   if server_is_found then
--     if not server:is_installed() then
--       print("Installing " .. name)
--       server:install()
--     end
--   end
-- end

-- local enhance_server_opts = {
--   -- Provide settings that should only apply to specific servers
--   ["sumneko_lua"] = function(opts)
--     opts.settings = {
--       Lua = {
--         diagnostics = {
--           globals = { 'vim' }
--         }
--       }
--     }
--   end,
-- }

-- -- Register a handler that will be called for all installed servers.
-- lsp_installer.on_server_ready(function(server)
--   local opts = {}

--   -- Customize the options passed to the server
--   if enhance_server_opts[server.name] then
--     enhance_server_opts[server.name](opts)
--   end

--   server:setup(opts)
-- end)

-- lsp_installer.settings {}

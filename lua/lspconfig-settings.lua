local lspconfig = require'lspconfig'
local configs = require'lspconfig/configs'
local lspinstall = require'lspinstall'

if not lspconfig.emmet_ls then
  configs.emmet_ls = {
    default_config = {
      cmd = {'emmet-ls', '--stdio'};
      filetypes = {'html', 'css'};
      root_dir = function(_)
        return vim.loop.cwd()
      end;
      settings = {};
    };
  }
end

-- config that activates keymaps and enables snippet support
local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  return {
    -- enable snippet support
    capabilities = capabilities,
  }
end

-- lsp-install
local function setup_servers()
  lspinstall.setup()

  -- Install missing servers
  local required_servers = { "lua", "cmake", "cpp", "bash", "css", "html", "typescript", "vim" }
  local installed_servers = lspinstall.installed_servers()
  for _, server in pairs(required_servers) do
    if not vim.tbl_contains(installed_servers, server) then
      lspinstall.install_server(server)
    end
  end

  -- get all installed servers
  local servers = lspinstall.installed_servers()
  -- manually installed servers
  table.insert(servers, "emmet_ls")

  for _, server in pairs(servers) do
    local config = make_config()

    -- language specific config
    if server == "lua" then
      config.settings = {
        Lua = {
          diagnostics = {
              globals = { 'vim' }
          }
        }
      }
    end
    if server == "clangd" then
      config.filetypes = {"c", "cpp"};
    end

    lspconfig[server].setup(config)
  end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
lspinstall.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
  };
}

require'lspkind'.init{}

require'lspsaga'.init_lsp_saga{
	code_action_prompt = {
    enable = true,
    sign = true,
    sign_priority = 20,
    virtual_text = false,
  },
}

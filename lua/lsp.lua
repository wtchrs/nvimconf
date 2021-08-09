local lspconfig = require('lspconfig')
local configs = require('lspconfig/configs')
local lspinstall = require('lspinstall')
local null_ls = require('null-ls')

local sources = {
  null_ls.builtins.formatting.prettier.with({
    command = 'npx',
    args = { "prettier", "--stdin-filepath", "$FILENAME" }
  }),
  null_ls.builtins.diagnostics.eslint.with({
    command = 'npx',
    args = { "eslint", "-f", "json", "--stdin", "--stdin-filename", "$FILENAME" }
  })
}

null_ls.config({
  diagnostics_format = "[#{c}] #{m} (#{s})",
  debounce = 1000,
  save_after_format = true,
  sources = sources,
})

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

local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  return {
    capabilities = capabilities,
  }
end

-- lsp-install
local function setup_servers()
  lspinstall.setup()

  local required_servers = { 'lua', 'cmake', 'cpp', 'bash', 'css', 'html', 'typescript', 'vim' }
  local installed_servers = lspinstall.installed_servers()
  for _, server in pairs(required_servers) do
    if not vim.tbl_contains(installed_servers, server) then
      lspinstall.install_server(server)
    end
  end

  local servers = lspinstall.installed_servers()
  table.insert(servers, 'emmet_ls')
  table.insert(servers, 'null-ls')

  for _, server in pairs(servers) do
    local config = make_config()

    if server == 'lua' then
      config.settings = {
        Lua = {
          diagnostics = {
              globals = { 'vim' }
          }
        }
      }
    end
    if server == 'clangd' then
      config.filetypes = {'c', 'cpp'};
    end
    if server == 'typescript' then
      config.on_attach = function (client, bufnr)
        client.resolved_capabilities.document_formatting = false

        local ts_utils = require("nvim-lsp-ts-utils")
        ts_utils.setup({
          eslint_enable_diagnostics = true,
        })
        ts_utils.setup_client(client)

        vim.cmd("autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()")
      end
    end

    lspconfig[server].setup(config)
  end
end

setup_servers()

lspinstall.post_install_hook = function ()
  setup_servers()
  vim.cmd('bufdo e')
end

require('compe').setup {
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

require('lspkind').init{}

require('lspsaga').init_lsp_saga{
	code_action_prompt = {
    enable = true,
    sign = true,
    sign_priority = 20,
    virtual_text = false,
  },
}

require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'bash',
    'cpp', 'cmake',
    'comment',
    'lua',
    'css', 'html',
    'javascript', 'typescript',
    'json', 'jsonc'
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = 1000,
  },
  indent = {
    enable = true,
  }
}

require("trouble").setup {}

-- Highlighting symbols under cursor
vim.cmd([[augroup HiSymbols]])
vim.cmd([[  autocmd!]])
vim.cmd([[  autocmd CursorHold   * silent! lua vim.lsp.buf.document_highlight()]])
vim.cmd([[  autocmd CursorHoldI  * silent! lua vim.lsp.buf.document_highlight()]])
vim.cmd([[  autocmd CursorMoved  * silent! lua vim.lsp.buf.clear_references()]])
vim.cmd([[  autocmd CursorMovedI * silent! lua vim.lsp.buf.clear_references()]])
vim.cmd([[  autocmd VimEnter * highlight LspReferenceText cterm=bold guibg=#3b4252]])
vim.cmd([[  autocmd VimEnter * highlight LspReferenceRead cterm=bold guibg=#3b4252]])
vim.cmd([[  autocmd VimEnter * highlight LspReferenceWrite cterm=bold guibg=#3b4252]])
vim.cmd([[augroup END]])

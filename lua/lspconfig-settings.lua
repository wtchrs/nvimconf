local nvim_lsp = require('lspconfig')

nvim_lsp.bashls.setup{}
nvim_lsp.clangd.setup{}
nvim_lsp.cmake.setup{}
nvim_lsp.rust_analyzer.setup{}
nvim_lsp.tsserver.setup{}
nvim_lsp.vimls.setup{}

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

require('lspkind').init({})

require'lspsaga'.init_lsp_saga{
	code_action_prompt = {
    enable = true,
    sign = true,
    sign_priority = 20,
    virtual_text = false,
  },
}

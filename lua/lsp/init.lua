require('lsp.installer')
require('lsp.rust')
require('trouble').setup({})

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
    luasnip = true;
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
    'json', 'jsonc',
    'rust'
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

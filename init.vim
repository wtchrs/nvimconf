set encoding=UTF-8
scriptencoding UTF-8

" Use space bar as leader
noremap <space> <nop>
let mapleader=' '

" Vim-Plug Settings {{{

" Automatic Vim-Plug installation
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" After installing Vim-Plug, execute ':PlugInstall' to install plugins.

call plug#begin('~/.vim/plugged')

Plug 'neovim/nvim-lspconfig'
  set omnifunc=v:lua.vim.lsp.omnifunc
Plug 'williamboman/nvim-lsp-installer'

Plug 'onsails/lspkind-nvim'
Plug 'hrsh7th/nvim-compe'
  inoremap <silent><expr> <C-Space> compe#complete()
  inoremap <silent><expr> <CR>      compe#confirm({ 'keys': "\<Plug>delimitMateCR", 'mode': '' })
  inoremap <silent><expr> <C-e>     compe#close('<C-e>')
  inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
  inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
  " Tab to completion and skip over closing parenthesis
  inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : SkipClosingParentheses()
  inoremap <silent><expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  function! SkipClosingParentheses()
    let line = getline('.')
    let current_char = line[col('.')-1]

    "Ignore EOL
    if col('.') == col('$')
      return "\t"
    end

    return stridx(">]})'\"`", current_char)==-1 ? "\t" : "\<Right>"
  endfunction

" Plug 'glepnir/lspsaga.nvim'
Plug 'tami5/lspsaga.nvim'
  " lsp provider to find the cursor word definition and reference
  nnoremap <silent> gh <cmd>Lspsaga lsp_finder<CR>
  " code action
  nnoremap <silent> <leader>ca <cmd>Lspsaga code_action<CR>
  vnoremap <silent> <leader>ca <cmd><C-U>Lspsaga range_code_action<CR>
  " show hover doc
  nnoremap <silent> K <cmd>Lspsaga hover_doc<CR>
  " scroll hover doc or scroll in definition preview
  nnoremap <silent> <C-f> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
  nnoremap <silent> <C-b> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>
  " rename symbol
  nnoremap <silent> <leader>rn <cmd>Lspsaga rename<CR>
  " preview definition
  nnoremap <silent> gd <cmd>Lspsaga preview_definition<CR>
  " show signature help
  nnoremap <silent> gs <cmd>Lspsaga signature_help<CR>
  " jump diagnostics
  nnoremap <silent> [g <cmd>Lspsaga diagnostic_jump_prev<CR>
  nnoremap <silent> ]g <cmd>Lspsaga diagnostic_jump_next<CR>

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  augroup TreesitterFT
    autocmd!
    autocmd BufNewFile,BufRead tsconfig*.json setlocal filetype=jsonc
    autocmd FileType handlebars setlocal filetype=html
  augroup END
Plug 'p00f/nvim-ts-rainbow'

" Rust, Crates, Toml
Plug 'simrat39/rust-tools.nvim'
Plug 'rust-lang/rust.vim'
Plug 'arzg/vim-rust-syntax-ext'
Plug 'cespare/vim-toml'
Plug 'mhinz/vim-crates'
  augroup CratesHighlight
    autocmd!
    if has('nvim')
      autocmd BufRead Cargo.toml call crates#toggle()
    endif
  augroup END

Plug 'mfussenegger/nvim-dap'

Plug 'preservim/nerdcommenter'
  let g:NERDCreateDefaultMappings = 0
  let g:NERDSpaceDelims = 1
  let g:NERDDefaultAlign = 'left'
  nmap <Leader>/ <Plug>NERDCommenterToggle
  xmap <Leader>/ <Plug>NERDCommenterToggle

Plug 'folke/trouble.nvim'
  nmap <Leader>t <cmd>TroubleToggle<CR>

Plug 'dense-analysis/ale'
  let g:ale_linters = {
      \ 'c': ['clangd'],
      \ 'cpp': ['clangd'],
      \ 'javascript': ['eslint'],
      \ 'typescript': ['eslint']
      \ }
  let g:ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'sh': ['shfmt'],
      \ 'c': ['clang-format'],
      \ 'cpp': ['clang-format'],
      \ 'cmake': [],
      \ 'html': ['prettier'],
      \ 'javascript': ['prettier'],
      \ 'typescript': ['prettier'],
      \ 'rust': ['rustfmt'],
      \ 'haskell': ['brittany']
      \ }
  let g:ale_fix_on_save = 1
  let g:ale_lint_delay = 1000
  let g:ale_echo_msg_error_str = 'E'
  let g:ale_echo_msg_warning_str = 'W'
  let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
  " change ALEWarning color
  highlight SpellCap gui=underline cterm=underline guibg=NONE ctermbg=NONE
  " jump to diagnostic
  nmap <silent> [a <Plug>(ale_previous_wrap)
  nmap <silent> ]a <Plug>(ale_next_wrap)

Plug 'Raimondi/delimitMate'
  let delimitMate_expand_cr=1
  let delimitMate_expand_space=1

" Plug 'blackcauldron7/surround.nvim'
Plug 'tpope/vim-surround'

Plug 'kyazdani42/nvim-web-devicons'
Plug 'NTBBloodbath/galaxyline.nvim'
Plug 'glepnir/dashboard-nvim'
  let g:dashboard_default_executive = 'telescope'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'kyazdani42/nvim-tree.lua'
  let g:nvim_tree_git_hl = 1
  nnoremap <silent> <leader>n :NvimTreeToggle<CR>
  nnoremap <leader>fn :NvimTreeFindFile<CR>

Plug 'akinsho/bufferline.nvim'

" Vim Theme
Plug 'shaunsingh/nord.nvim'
  let g:nord_borders = v:true

Plug 'mattn/emmet-vim'
  let g:user_emmet_leader_key = ','
  let g:user_emmet_install_global = 0
  augroup emmet
    autocmd!
    autocmd FileType html,css,handlebars,html.handlebars EmmetInstall
  augroup END

Plug 'liuchengxu/vista.vim'
  let g:vista_icon_indent = ['╰─▸ ', '├─▸ ']
  let g:vista_close_on_jump = 1
  let g:vista_default_executive = 'nvim_lsp'
  let g:vista_update_on_text_changed = 1
  let g:vista_update_on_text_changed_delay = 2000
  nmap <silent> <F8> :Vista!!<CR>

Plug 'easymotion/vim-easymotion'

Plug 'lukas-reineke/indent-blankline.nvim'
  let g:indent_blankline_char = '│'
  let g:indent_blankline_filetype_exclude = ['help', 'dashboard']
  let g:indent_blankline_use_treesitter = v:true
  let g:indent_blankline_show_current_context = v:true
  let g:indent_blankline_show_trailing_blankline_indent = v:false

Plug 'turbio/bracey.vim', {'do': 'npm install --prefix server'}
"Plug 'pboettch/vim-cmake-syntax'
Plug 'lewis6991/gitsigns.nvim'
Plug 'dstein64/vim-startuptime'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }

"Plug 'joukevandermaas/vim-ember-hbs'

call plug#end()

" }}} End Vim-Plug Settings

" Color Theme
lua require('nord').set()

" Galaxyline Theme
lua require('themes.spaceline')

lua require('lsp')
lua require('plugins.bufferline')
lua require('plugins.nvimtree')
lua require('plugins.telescope')
" lua require('surround').setup({})
lua require('gitsigns').setup({})

set background=dark
set number
set ruler
set title
set wrap
set cursorline
set linebreak
set showmatch
set showcmd
set hidden
set belloff=all
set laststatus=2
set scrolloff=5

" Line length guide
set colorcolumn=80

" Indent setting
set smartindent
set expandtab
set tabstop=4
set shiftwidth=4

" tags
set tags=./tags;/

" mouse setting
set mouse=a
if !has('nvim')
  set ttymouse=xterm2
endif

set nobackup
set nowritebackup
set cmdheight=2
set updatetime=300
set signcolumn=yes
set completeopt=menuone,noinsert,noselect
set shortmess+=c

filetype plugin indent on

" Preview replace
if has('nvim')
  set inccommand=nosplit
endif

if !has('gui_running')
  set t_Co=256
endif

" Syntax Highlighting
if has('syntax')
  syntax on
endif

vmap <C-c> y:call system("xclip -i -selection clipboard", getreg("\""))<CR>

augroup NewBuffer
  autocmd!
  autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "norm g`\"" |
      \ endif
augroup END

augroup DisableWrapFT
  autocmd!
  autocmd FileType dashboard set nowrap
  let ftToDisableWrap = ['dashboard', 'NvimTree']
  autocmd BufEnter *
      \ if index(ftToDisableWrap, &ft) < 0 | set wrap |
      \ else | set nowrap |
      \ endif
augroup END

augroup file_type
  autocmd!
  let ftToUseTwoSpaceTab = [
      \ 'vim', 'lua', 'sh', 'zsh',
      \ 'html', 'javascript', 'typescript', 'json', 'jsonc',
      \ ]
  autocmd BufEnter *
      \ if !(index(ftToUseTwoSpaceTab, &ft) < 0) |
      \   setlocal shiftwidth=2 tabstop=2 |
      \ endif
  autocmd FileType help,h wincmd L
  autocmd BufNewFile,BufRead .prettierrc setlocal filetype=json
augroup END

if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" No background color for transparency
"highlight Normal guibg=NONE ctermbg=NONE

" indent-blankline current context highlight
highlight IndentBlanklineContextChar guifg=#5d6678 gui=nocombine

" resize split window
nnoremap <C-W><C-h> :vertical resize -5<CR>
nnoremap <C-W><C-j> :resize -2<CR>
nnoremap <C-W><C-k> :resize +2<CR>
nnoremap <C-W><C-l> :vertical resize +5<CR>

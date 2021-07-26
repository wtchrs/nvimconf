set encoding=UTF-8
scriptencoding UTF-8

let mapleader='`'

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
Plug 'kabouzeid/nvim-lspinstall'

Plug 'onsails/lspkind-nvim'
Plug 'hrsh7th/nvim-compe'
  inoremap <silent><expr> <C-Space> compe#complete()
  inoremap <silent><expr> <CR>      compe#confirm({ 'keys': "\<Plug>delimitMateCR", 'mode': '' })
  inoremap <silent><expr> <C-e>     compe#close('<C-e>')
  inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
  inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
  " Tab to completion and skip over closing parenthesis
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" : SkipClosingParentheses()
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

Plug 'glepnir/lspsaga.nvim'
  " lsp provider to find the cursor word definition and reference
  nnoremap <silent> gh :Lspsaga lsp_finder<CR>
  " code action
  nnoremap <silent> <leader>ca :Lspsaga code_action<CR>
  vnoremap <silent> <leader>ca :<C-U>Lspsaga range_code_action<CR>
  " show hover doc
  nnoremap <silent> K :Lspsaga hover_doc<CR>
  " scroll hover doc or scroll in definition preview
  nnoremap <silent> <C-f> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
  nnoremap <silent> <C-b> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>
  " rename symbol
  nnoremap <silent> <leader>rn :Lspsaga rename<CR>
  " preview definition
  nnoremap <silent> gd :Lspsaga preview_definition<CR>
  " show signature help
  nnoremap <silent> gs :Lspsaga signature_help<CR>
  " jump diagnostics
  nnoremap <silent> [g :Lspsaga diagnostic_jump_prev<CR>
  nnoremap <silent> ]g :Lspsaga diagnostic_jump_next<CR>

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'p00f/nvim-ts-rainbow'

Plug 'preservim/nerdcommenter'
  let g:NERDCreateDefaultMappings = 0
  let g:NERDDefaultAlign = 'left'
  nmap <Leader>/ <Plug>NERDCommenterToggle
  xmap <Leader>/ <Plug>NERDCommenterToggle

Plug 'preservim/tagbar'
  nnoremap <F8> :TagbarToggle<CR>

"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"  exec 'source '.stdpath('config').'\coc-settings.vim'
"Plug 'tjdevries/coc-zsh'

Plug 'dense-analysis/ale'
  let g:ale_linters = {
      \ 'c': ['clangd'],
      \ 'cpp': ['clangd'],
      \ }
  let g:ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'sh': ['shfmt'],
      \ 'c': ['clang-format'],
      \ 'cpp': ['clang-format'],
      \ 'cmake': [],
      \ 'html': ['prettier'],
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

Plug 'kyazdani42/nvim-web-devicons'
Plug 'glepnir/galaxyline.nvim'
Plug 'glepnir/dashboard-nvim'
  let g:dashboard_default_executive = 'telescope'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
  nnoremap <C-p> <cmd>lua require('telescope.builtin').find_files()<cr>
  nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
  nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
  nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

Plug 'kyazdani42/nvim-tree.lua'
  let g:nvim_tree_side = 'right'
  let g:nvim_tree_width = 35
  let g:nvim_tree_auto_close = 1
  let g:nvim_tree_quit_on_open = 1
  let g:nvim_tree_follow = 1
  let g:nvim_tree_indent_markers = 1
  let g:nvim_tree_git_hl = 1
  nnoremap <silent> <C-n> :NvimTreeToggle<CR>
  nnoremap <leader>r :NvimTreeRefresh<CR>
  nnoremap <leader>n :NvimTreeFindFile<CR>

Plug 'akinsho/nvim-bufferline.lua'
  nnoremap <silent> <A-1> :lua require"bufferline".go_to_buffer(1)<CR>
  nnoremap <silent> <A-2> :lua require"bufferline".go_to_buffer(2)<CR>
  nnoremap <silent> <A-3> :lua require"bufferline".go_to_buffer(3)<CR>
  nnoremap <silent> <A-4> :lua require"bufferline".go_to_buffer(4)<CR>
  nnoremap <silent> <A-5> :lua require"bufferline".go_to_buffer(5)<CR>
  nnoremap <silent> <A-6> :lua require"bufferline".go_to_buffer(6)<CR>
  nnoremap <silent> <A-7> :lua require"bufferline".go_to_buffer(7)<CR>
  nnoremap <silent> <A-8> :lua require"bufferline".go_to_buffer(8)<CR>
  " Close buffer
  nnoremap <silent> <A-c> :bdelete<CR>

" Vim Theme
"Plug 'arcticicestudio/nord-vim'
Plug 'shaunsingh/nord.nvim'
  let g:nord_borders = v:true

Plug 'mattn/emmet-vim'
  let g:user_emmet_leader_key = ','
  let g:user_emmet_install_global = 0
  augroup emmet
    autocmd!
    autocmd FileType html,css EmmetInstall
  augroup END

Plug 'junegunn/rainbow_parentheses.vim'
  let g:rainbow#max_level = 16
  let g:rainbow#pairs = [['(', ')'], ['{', '}'], ['[', ']']]
  augroup RainbowParenthesesSetting
    autocmd!
    " cmake syntax highlight conflict with RainbowParentheses
    let ftToDisableRainbow = ['cmake']
    autocmd BufEnter *
        \ if index(ftToDisableRainbow, &ft) < 0 |
        \   RainbowParentheses |
        \ else |
        \   RainbowParentheses! |
        \ endif
    autocmd TermOpen,TermEnter * RainbowParentheses!
  augroup END

Plug 'liuchengxu/vista.vim'
  let g:vista_icon_indent = ['╰─▸ ', '├─▸ ']
  let g:vista_executive_for = {
      \ 'vim': 'ctags',
      \ 'cpp': 'coc',
      \ 'rust': 'coc',
      \ 'javascript': 'coc',
      \ 'html': 'coc',
      \ 'haskell': 'coc'
      \ }
  let g:vista_update_on_text_changed = 1
  let g:vista_update_on_text_changed_delay = 3000
  nmap <Leader><F8> :Vista!!<CR>

Plug 'jackguo380/vim-lsp-cxx-highlight'
Plug 'easymotion/vim-easymotion'

Plug 'lukas-reineke/indent-blankline.nvim'
  let g:indent_blankline_char = '│'
  let g:indent_blankline_filetype_exclude = ['help', 'dashboard', 'json']

" Rust, Crates, Toml
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

Plug 'turbio/bracey.vim', {'do': 'npm install --prefix server'}
Plug 'dag/vim-fish'
Plug 'pboettch/vim-cmake-syntax'
Plug 'airblade/vim-gitgutter'
Plug 'dstein64/vim-startuptime'

call plug#end()

" }}} End Vim-Plug Settings

set background=dark
"colorscheme nord
lua require('nord').set()

lua require'spaceline'
lua require'lspconfig-settings'
lua require'bufln'


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

if &shell =~# 'fish$'
  set shell=sh
endif

augroup NewBuffer
  autocmd!
  autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "norm g`\"" |
      \ endif
  "autocmd BufReadPost * highlight BufferLineFill guibg=#191c23
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
  autocmd FileType vim,sh,zsh,html,javascript,lua setlocal shiftwidth=2 tabstop=2
  autocmd FileType help,h wincmd L
augroup END

if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" Change Color Highlight
" No background color for transparency
"highlight Normal guibg=NONE ctermbg=NONE
" lsp diagnostic color
"highlight LspDiagnosticsVirtualTextError guifg=#FFA500
"highlight LspDiagnosticsVirtualTextWarning guifg=#FFA500
"highlight BufferLineFill guibg=#191c23

" resize split window
nnoremap <C-W><C-h> :vertical resize -5<CR>
nnoremap <C-W><C-j> :resize -2<CR>
nnoremap <C-W><C-k> :resize +2<CR>
nnoremap <C-W><C-l> :vertical resize +5<CR>

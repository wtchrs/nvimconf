set encoding=UTF-8
scriptencoding UTF-8

let mapleader='`'

" Vim-Plug Settings {{{
call plug#begin('~/.vim/plugged')

Plug 'neovim/nvim-lspconfig'
  set omnifunc=v:lua.vim.lsp.omnifunc
  nnoremap <silent> gd <Cmd>lua vim.lsp.buf.definition()<CR>
  nnoremap <silent> K <Cmd>lua vim.lsp.buf.hover()<CR>
  nnoremap <silent> <space>wa <cmd>lua vim.lsp.buf.add_workspace_folder()<CR>
  nnoremap <silent> <space>wr <cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>
  nnoremap <silent> <space>wl <cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>
  nnoremap <silent> <space>D <cmd>lua vim.lsp.buf.type_definition()<CR>
  nnoremap <silent> <space>rn <cmd>lua vim.lsp.buf.rename()<CR>
  nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
  nnoremap <silent> <space>e <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
  nnoremap <silent> [g <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
  nnoremap <silent> ]g <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
  nnoremap <silent> <space>q <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>

Plug 'onsails/lspkind-nvim'
Plug 'hrsh7th/nvim-compe'
  inoremap <silent><expr> <C-Space> compe#complete()
  inoremap <silent><expr> <CR>      compe#confirm({ 'keys': "\<Plug>delimitMateCR", 'mode': '' })
  inoremap <silent><expr> <C-e>     compe#close('<C-e>')
  inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
  inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

Plug 'preservim/nerdcommenter'
  let g:NERDCreateDefaultMappings = 0
  let g:NERDDefaultAlign = 'left'
  nmap <Leader>/ <Plug>NERDCommenterToggle
  xmap <Leader>/ <Plug>NERDCommenterToggle

Plug 'preservim/tagbar'
  nnoremap <F8> :TagbarToggle<CR>

"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"  exec 'source '.stdpath('config').'\coc-settings.vim'

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
  augroup DashboardSetting
    autocmd!
    autocmd FileType dashboard set nowrap
    let ftToDisableWrap = ['dashboard']
    autocmd BufEnter *
        \ if index(ftToDisableWrap, &ft) < 0 | set wrap |
        \ else | set nowrap |
        \ endif
  augroup END

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
  "let g:nvim_tree_auto_open = 1
  let g:nvim_tree_auto_close = 1
  let g:nvim_tree_follow = 1
  let g:nvim_tree_indent_markers = 1
  let g:nvim_tree_git_hl = 1
  nnoremap <silent> <C-n> :NvimTreeToggle<CR>
  nnoremap <leader>r :NvimTreeRefresh<CR>
  nnoremap <leader>n :NvimTreeFindFile<CR>

Plug 'romgrk/barbar.nvim'
  " Magic buffer-picking mode
  nnoremap <silent> <C-s> :BufferPick<CR>
  " Sort automatically by...
  nnoremap <silent> <Space>bd :BufferOrderByDirectory<CR>
  nnoremap <silent> <Space>bl :BufferOrderByLanguage<CR>
  " Move to previous/next
  nnoremap <silent> <A-,> :BufferPrevious<CR>
  nnoremap <silent> <A-.> :BufferNext<CR>
  " Re-order to previous/next
  nnoremap <silent> <A-<> :BufferMovePrevious<CR>
  nnoremap <silent> <A->> :BufferMoveNext<CR>
  " Goto buffer in position...
  nnoremap <silent> <A-1> :BufferGoto 1<CR>
  nnoremap <silent> <A-2> :BufferGoto 2<CR>
  nnoremap <silent> <A-3> :BufferGoto 3<CR>
  nnoremap <silent> <A-4> :BufferGoto 4<CR>
  nnoremap <silent> <A-5> :BufferGoto 5<CR>
  nnoremap <silent> <A-6> :BufferGoto 6<CR>
  nnoremap <silent> <A-7> :BufferGoto 7<CR>
  nnoremap <silent> <A-8> :BufferGoto 8<CR>
  nnoremap <silent> <A-9> :BufferLast<CR>
  " Close buffer
  nnoremap <silent> <A-c> :BufferClose<CR>

" Vim Theme
Plug 'arcticicestudio/nord-vim'

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

Plug 'Yggdroot/indentLine'
  let g:indentLine_char = '│'
  let g:indentLine_fileTypeExclude = ['help', 'dashboard', 'json']
Plug 'lukas-reineke/indent-blankline.nvim'

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

Plug 'turbio/bracey.vim'
Plug 'tjdevries/coc-zsh'
Plug 'dag/vim-fish'
Plug 'pboettch/vim-cmake-syntax'
Plug 'airblade/vim-gitgutter'

call plug#end()
" }}} End Vim-Plug Settings

" Loading galaxyline setting from lua file
"lua require'spaceline'
lua require'eviline'
lua require'lspconfig-custom'

set background=dark
colorscheme nord

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
augroup END

if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" Change Color Highlight
" No background color for transparency
"highlight Normal guibg=NONE ctermbg=NONE
" change modified buffer color
highlight BufferCurrentMod guifg=lightgreen guibg=#2e3440
highlight BufferVisibleMod guifg=lightgreen guibg=#4c566a
highlight BufferInactiveMod guifg=lightgreen guibg=#3b4252
" change inlay hint color
highlight! link CocHintSign Comment

augroup file_type
  autocmd!
  autocmd FileType vim,sh,zsh,html,lua setlocal shiftwidth=2 tabstop=2
  autocmd FileType help,h wincmd L
augroup END

" skip over closing parenthesis
"inoremap <expr> <Tab> stridx('])}"', getline('.')[col('.')-1])==-1 ?
"    \ "\t" : "\<Right>"

" termdebug setting
packadd termdebug
  let g:termdebug_wide=1
  nnoremap <F5> :silent! Termdebug<CR>
  nnoremap <Leader><F5> :Run<CR>
  nnoremap <F6> :Step<CR>
  nnoremap <Leader><F6> :Over<CR>
  nnoremap <F7> :Continue<CR>
  nnoremap <F9> :Break<CR>
  nnoremap <F10> :Stop<CR>

" resize split window
nnoremap <C-W><C-h> :vertical resize -5<CR>
nnoremap <C-W><C-j> :resize -2<CR>
nnoremap <C-W><C-k> :resize +2<CR>
nnoremap <C-W><C-l> :vertical resize +5<CR>

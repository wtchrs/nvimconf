set encoding=UTF-8
scriptencoding UTF-8
set nobomb

let mapleader='`'

" Vim-Plug Settings {{{
call plug#begin('~/.vim/plugged')

Plug 'neovim/nvim-lspconfig'
  set omnifunc=v:lua.vim.lsp.omnifunc
  " GoTo code navigation.
  nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
  " for scrolling popup
  "nnoremap <expr> <c-d> coc#float#has_float() ? coc#float#scroll(1,2) : '<c-d>'
  "nnoremap <expr> <c-u> coc#float#has_float() ? coc#float#scroll(0,2) : '<c-u>'
  " Symbol renaming.
  nmap <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>
  " Formatting
  nnoremap <silent> <space>f :<cmd>lua vim.lsp.buf.formatting()<CR>
  " Highlight
  hi LspReferenceRead cterm=bold ctermbg=red guibg=grey
  hi LspReferenceText cterm=bold ctermbg=red guibg=grey
  hi LspReferenceWrite cterm=bold ctermbg=red guibg=grey
  augroup lsp_document_highlight
    autocmd!
    autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
  augroup END

Plug 'nvim-lua/completion-nvim'
  let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy', 'all']
  let g:completion_matching_smart_case = 1
  let g:completion_matching_ignore_case = 1
  " use <Tab> and <S-Tab> for navigate completion lists
  inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

Plug 'tjdevries/lsp_extensions.nvim'
  augroup InlayHint
    autocmd!
    autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
        \ lua require'lsp_extensions'.inlay_hints{ prefix = ' » ', aligned = true, highlight = "Comment", enabled = {"TypeHint", "ChainingHint"} }
  augroup END


Plug 'glepnir/lspsaga.nvim'
  " lsp provider to find the cursor word definition and reference
  nnoremap <silent> gh :LspSagaFinder<CR>
  " code action
  nnoremap <silent><leader>ca :LspSagaCodeAction<CR>
  vnoremap <silent><leader>ca :LspSagaRangeCodeAction<CR>
  " show hover doc
  nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
  " rename symbol
  nnoremap <silent> <silent>rn :LspRename<CR>
  " preview definition
  nnoremap <silent> gd :LspSagaDefPreview<CR>
  " show signature help
  nnoremap <silent> gs <cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>
  " jump diagnostics
  nnoremap <silent> [g :LspSagaDiagJumpPrev<CR>
  nnoremap <silent> ]g :LspSagaDiagJumpNext<CR>

Plug 'preservim/nerdcommenter'
  let g:NERDCreateDefaultMappings = 0
  let g:NERDDefaultAlign = 'left'
  nmap <Leader>/ <Plug>NERDCommenterToggle
  xmap <Leader>/ <Plug>NERDCommenterToggle

Plug 'preservim/tagbar'
  nnoremap <F8> :TagbarToggle<CR>

"Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'dense-analysis/ale'
  let g:ale_linters = {
      \ 'cpp': ['clangd'],
      \ }
  let g:ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'sh': ['shfmt'],
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
  let g:nvim_tree_auto_open = 1
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
  let g:indentLine_fileTypeExclude = ['dashboard','json']

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
lua require'lspsaga'.init_lsp_saga()

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

" Coc.nvim Settings {{{
" Extensions for install
"let g:coc_global_extensions = [
"    \ 'coc-cmake', 'coc-clangd', 'coc-vimlsp', 'coc-rust-analyzer',
"    \ 'coc-html', 'coc-json', 'coc-eslint', 'coc-tsserver', 'coc-prettier',
"    \ 'coc-css', 'coc-stylelint', 'coc-emmet', 'coc-sh', 'coc-snippets',
"    \ 'coc-lua'
"    \ ]

"nmap <silent> <c-F5> :CocRestart<CR>

"" Use tab for trigger completion with characters ahead and navigate.
"" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
"" other plugin before putting this into your config.
"" stridx(... for skip closing brakets and braces
"inoremap <silent><expr> <TAB>
"    \ pumvisible() ? "\<C-n>" :
"    \ (coc#expandableOrJumpable() ?
"    \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
"    \ (<SID>check_back_space() ? "\<TAB>" :
"    \ (stridx('])}>"', getline('.')[col('.')-1])!=-1 ? "\<Right>" :
"    \ coc#refresh())))

"inoremap <silent><expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

"function! s:check_back_space() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~# '\s'
"endfunction

"let g:coc_snippet_next = '<tab>'

"" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
"" position. Coc only does snippet and additional edit on confirm.
"" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
"" '\<c-r>=coc#on_enter()\<CR>' for delimitMate_expand_cr
"if exists('*complete_info')
"  inoremap <expr> <cr> complete_info()["selected"] != "-1" ?
"      \ "\<C-y>" : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
"else
"  inoremap <expr> <cr> pumvisible() ?
"      \ "\<C-y>" : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
"endif

"" GoTo code navigation.
"nnoremap <silent> gd :<C-u>call CocActionAsync('jumpDefinition')<CR>
"nnoremap <silent> gr :<C-u>call CocActionAsync('jumpReferences')<CR>

"" GoTo diagnostic
"nnoremap <silent> [g :<c-u>call CocActionAsync('diagnosticPrevious')<CR>
"nnoremap <silent> ]g :<c-u>call CocActionAsync('diagnosticNext')<CR>

"" Use K to show documentation in preview window.
"nnoremap <silent> K :call <SID>show_documentation()<CR>

"" for scrolling popup
"nnoremap <expr> <c-d> coc#float#has_float() ? coc#float#scroll(1,2) : '<c-d>'
"nnoremap <expr> <c-u> coc#float#has_float() ? coc#float#scroll(0,2) : '<c-u>'

"" Symbol renaming.
"nmap <leader>rn <Plug>(coc-rename)

"function! s:show_documentation()
"  if (index(['vim','help'], &filetype) >= 0)
"    execute 'h '.expand('<cword>')
"  else
"    call CocAction('doHover')
"  endif
"endfunction

"" Highlight the symbol and its references when holding the cursor.
"augroup CocHighlight
"  autocmd!
"  autocmd CursorHold * silent call CocActionAsync('highlight')
"augroup END
" }}} End Coc.nvim Settings

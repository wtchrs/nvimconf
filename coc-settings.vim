" Extensions for install
let g:coc_global_extensions = [
    \ 'coc-cmake', 'coc-clangd', 'coc-vimlsp', 'coc-rust-analyzer',
    \ 'coc-html', 'coc-json', 'coc-eslint', 'coc-tsserver',
    \ 'coc-css', 'coc-stylelint', 'coc-emmet', 'coc-sh', 'coc-snippets',
    \ 'coc-lua'
    \ ]

nmap <silent> <c-F5> :CocRestart<CR>

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
" stridx(... for skip closing brakets and braces
inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ (coc#expandableOrJumpable() ?
    \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
    \ (<SID>check_back_space() ? "\<TAB>" :
    \ (stridx('])}>"', getline('.')[col('.')-1])!=-1 ? "\<Right>" :
    \ coc#refresh())))

inoremap <silent><expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
" '\<c-r>=coc#on_enter()\<CR>' for delimitMate_expand_cr
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ?
      \ "\<C-y>" : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
else
  inoremap <expr> <cr> pumvisible() ?
      \ "\<C-y>" : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
endif

" GoTo code navigation.
nnoremap <silent> gd :<C-u>call CocActionAsync('jumpDefinition')<CR>
nnoremap <silent> gr :<C-u>call CocActionAsync('jumpReferences')<CR>

" GoTo diagnostic
nnoremap <silent> [g :<c-u>call CocActionAsync('diagnosticPrevious')<CR>
nnoremap <silent> ]g :<c-u>call CocActionAsync('diagnosticNext')<CR>

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

" for scrolling popup
nnoremap <expr> <c-d> coc#float#has_float() ? coc#float#scroll(1,2) : '<c-d>'
nnoremap <expr> <c-u> coc#float#has_float() ? coc#float#scroll(0,2) : '<c-u>'

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
augroup CocHighlight
  autocmd!
  autocmd CursorHold * silent call CocActionAsync('highlight')
augroup END

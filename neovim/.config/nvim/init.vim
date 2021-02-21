set number
syntax on

filetype plugin indent on
set autoindent
set smartindent

set expandtab
set tabstop=4
set shiftwidth=4

set wrap
set linebreak

" set working directory as the current file's directory
autocmd BufEnter * lcd %:p:h

" ------ Language specific settings ------
"
autocmd Filetype haskell setlocal tabstop=2 shiftwidth=2 softtabstop=2

" ------ key maps -------
"
" insert mode:
    " Shift-Tab
    inoremap <S-Tab> <C-d>


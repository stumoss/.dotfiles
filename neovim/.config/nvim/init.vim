"====[ Plugins ]===============================================================

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl --insecure -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'https://github.com/rust-lang/rust.vim'
Plug 'https://github.com/tomasr/molokai'
Plug 'https://github.com/scrooloose/nerdtree'
Plug 'https://github.com/jistr/vim-nerdtree-tabs'
Plug 'https://github.com/fatih/vim-go'
Plug 'https://github.com/vim-pandoc/vim-pandoc-syntax'
Plug 'https://github.com/dsanson/vim-pandoc'
Plug 'https://github.com/ElmCast/elm-vim'
"Plug 'https://github.com/MarcWeber/vim-addon-nix'
Plug 'https://github.com/LnL7/vim-nix'
Plug 'https://github.com/majutsushi/tagbar'
Plug 'https://github.com/junegunn/fzf.vim'
Plug 'https://github.com/MarcWeber/vim-addon-vim2nix'
Plug 'https://github.com/tpope/vim-fugitive'
Plug 'https://github.com/vim-airline/vim-airline'
Plug 'https://github.com/godlygeek/tabular'

if executable('nvim')
"    Plug 'https://github.com/neomake/neomake'
"    Plug 'https://github.com/roxma/nvim-completion-manager'
    Plug 'https://github.com/autozimu/LanguageClient-neovim'
endif

"Plug 'fzfWrapper'

call plug#end()

syntax on
set scrolloff=4
set hls!
set virtualedit=block
set number
set nocompatible
set foldenable
set foldmethod=syntax
set foldlevel=99
set softtabstop=4
set shiftwidth=4
set expandtab
set ruler
set smarttab autoindent copyindent
set nobackup
set noswapfile
set showmatch
set showmode
set background=dark
set ignorecase
set smartcase
set backspace=indent,eol,start
set nowrap
set textwidth=0
set wrapmargin=0
set formatoptions=qrn1
set autowriteall
set novisualbell
set noerrorbells
set autoread
set shellslash
set hidden

try
    colorscheme molokai
catch /^Vim\%((\a\+)\)\=:E185/
    " theme not found so do nothing
endtry

"====[ Highlight hidden characters ]===========================================
exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~"
set list

"====[ FileType Specific settings ]============================================
autocmd BufReadPre *.go
\ set nolist        |
\ set noexpandtab

au BufRead,BufNewFile *.md setlocal textwidth=80

"====[ Keymap Settings ]=======================================================
" Unmap F1 key
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" Remove whitespace with \w
nmap <leader>W :%s/\s\+$//<cr>:let @/=\'\'<CR>
" Run make in background with \bd
nmap <leader>bd :Make!
" Open NerdTree with \n
nmap <leader>n :NERDTreeToggle<CR>
" Perform git grep on current word with \g
nmap <leader>g :grep! <C-r><C-w><CR><CR>
" Get Ggrep ready for a custom search with \G
nmap <leader>G :grep!
" Toggle paste mode with \o
nmap <leader>o :set paste!<CR>
" Use FZF when doing ctrl+p
nmap <c-p> :Files .<CR>
nmap <leader>p : Files<CR>
" Use FZF find for \f
nmap <leader>f :Find


"====[ vim-go Settings ]=====================================================
let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 1
let g:go_list_type = "quickfix"


"====[ rust.vim Settings ]=====================================================
if executable('rustfmt')
let g:rustfmt_autosave = 1
endif


"====[ ripgrep ]===============================================================
if executable('rg')
" Use ripgrep over grep
set grepprg=rg\ --vimgrep

" Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
"let g:ctrlp_user_command = 'rg --no-heading %s ""'

" ripgrep is fast enough that CtrlP doesn't need to cache
let g:ctrlp_use_caching = 0
endif

let g:neomake_echo_current_error = 1
let g:neomake_verbose = 0
let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }


"===[ fzf ] ===================================================================
if executable('fd')
    let g:ctrlp_user_command = 'fd --hidden --exclude ".git" "" "%s"'
    let g:ctrlp_user_caching = 0
    "command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "\!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)
elseif executable('rg')
    command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "\!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)
endif

"===[ NERDTree ] ==============================================================
let NERDTreeMinimalUI=1

"===[ Language Server Client] =================================================
let g:LanguageClient_serverCommands = {
\ 'rust': ['rls'],
\ }

set completefunc=LanguageClient#complete

nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>

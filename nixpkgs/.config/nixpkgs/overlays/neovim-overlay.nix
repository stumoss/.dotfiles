self: super:
{
  neovim = super.neovim.override {
    vimAlias = true;
    configure = {
      vam = {
        knownPlugins = super.vimPlugins;
        pluginDictionaries = [
          { name = "airline"; }
          { name = "elm-vim"; }
          { name = "skim"; }
          { name = "LanguageClient-neovim"; }
          { name = "ncm2"; }
          { name = "molokai"; }
          { name = "nerdtree"; }
          { name = "rust-vim"; }
          { name = "vim-nix"; }
          { name = "vim-go"; }
          { name = "vim-abolish"; }
          { name = "vim-surround"; }
          { name = "vim-fugitive"; }
          { name = "echodoc"; }

          #{ name = "fzf-vim"; }
          #{ name = "fzfWrapper"; }
          #{ name = "neomake"; }
          #{ name = "vim-pandoc"; }
          #{ name = "vim-pandoc-syntax"; }
          #{ name = "tagbar"; }
          #{ name = "neosnippet"; }
          #{ name = "neosnippet-snippets"; }
          #{ name = "echodoc"; }
        ];
      };

      customRC = ''
            syntax on
            set scrolloff=4
            set hls!
            set virtualedit=block
            set number
            set relativenumber
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
            set signcolumn=yes

            try
                colorscheme molokai
            catch /^Vim\%((\a\+)\)\=:E185/
                " theme not found so do nothing
            endtry

            "====[ Highlight hidden characters ]===========================================
            exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~"
            set list

            "====[ FileType Specific settings ]============================================

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
            " Use skim when doing ctrl+p
            nmap <c-p> :SK<CR>
            nmap <leader>p :SK<CR>


            "====[ vim-go Settings ]=======================================================


            "====[ ripgrep ]===============================================================
            if executable('${super.ripgrep}/bin/rg')
              " Use ripgrep over grep
              set grepprg=${super.ripgrep}/bin/rg\ --vimgrep
            endif

            let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }


            "===[ NERDTree ] ==============================================================
            let NERDTreeMinimalUI=1
            autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


            "===[ LanguageCLient ] ========================================================
            let g:LanguageClient_serverCommands = {
              \ 'rust': ['${(super.latest.rustChannels.stable.rust.override {
                  extensions = [
                    "rust-src"
                    "rls-preview"
                    "clippy-preview"
                    "rustfmt-preview"
                    ];})}/bin/rls'],
              \ 'cpp': ['${super.cquery}/bin/cquery', '--log-file=/tmp/cquery.log'],
              \ 'c': ['${super.cquery}/bin/cquery', '--log-file=/tmp/cquery.log'],
              \ 'go': ['${super.gotools}/bin/gopls'],
              \ 'sh': ['${super.nodePackages.bash-language-server}/bin/bash-language-server'],
              \ }

            let g:LanguageClient_autostart = 1

            " Maps K to hover
            nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
            " Use gd to go to definition
            nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>

            " Rename - rn => rename
            nnoremap <leader> rn :call LanguageClient_textDocument_rename()<CR>

            " Rename - rc => rename camelCase
            noremap <leader>rc :call LanguageClient#textDocument_rename(
                        \ {'newName': Abolish.camelcase(expand('<cword>'))})<CR>

            " Rename - rs => rename snake_case
            noremap <leader>rs :call LanguageClient#textDocument_rename(
                        \ {'newName': Abolish.snakecase(expand('<cword>'))})<CR>

            " Rename - ru => rename UPPERCASE
            noremap <leader>ru :call LanguageClient#textDocument_rename(
                        \ {'newName': Abolish.uppercase(expand('<cword>'))})<CR>


            "===[ Go ]====================================================================
            autocmd BufReadPre *.go
            \ set nolist        |
            \ set noexpandtab

            "   Language Client "
            "autocmd BufReadPost *.go setlocal filetype=go
            " Run LanguageClient#textDocument_formatting on save
            "autocmd BufWritePre *.go :call LanguageClient#textDocument_formatting_sync()

            " vim-go "
            let g:go_fmt_command = "${super.goimports}/bin/goimports"
            let g:go_fmt_fail_silently = 1
            let g:go_list_type = "quickfix"
            let g:go_def_mode='gopls'
            let g:go_info_mode='gopls'
            let g:go_metalinter_command='${super.golangci-lint}/bin/golangci-lint'


            "===[ Rust ] =================================================================
            autocmd BufReadPost *.rs setlocal filetype=rust
            autocmd BufWritePre *.rs :call LanguageClient#textDocument_formatting_sync()


            "===[ C++ ]===================================================================
            autocmd BufReadPost *.cpp setlocal filetype=cpp
            autocmd BufReadPost *.hpp setlocal filetype=cpp
            autocmd BufReadPost *.h setlocal filetype=cpp
            autocmd BufWritePre *.cpp :call LanguageClient#textDocument_formatting_sync()
            autocmd BufWritePre *.hpp :call LanguageClient#textDocument_formatting_sync()
            autocmd BufWritePre *.h :call LanguageClient#textDocument_formatting_sync()
      '';
    };
  };
}

self: super: {
  customPlugins.vim-colors-github = super.vimUtils.buildVimPlugin {
    name = "vim-colors-github";
    src = super.fetchFromGitHub {
      owner = "cormacrelf";
      repo = "vim-colors-github";
      rev = "acb712c76bb73c20eb3d7e625a48b5ff59f150d0";
      sha256 = "1nnbyl6qm7rksz4sc0cs5hgpa9sw5mlan732bnn7vn296qm9sjv1";
    };
  };

  customPlugins.skWrapper = super.vimUtils.buildVimPluginFrom2Nix {
    pname = "skim";
    version = super.skim.version;
    src = super.skim.src;
  };

  customPlugins.skim-vim = super.vimUtils.buildVimPlugin {
    name = "skim-vim";
    src = super.fetchFromGitHub {
      owner = "lotabout";
      repo = "skim.vim";
      rev = "4e9d9a3deb2060e2e79fede1c213f13ac7866eb5";
      sha256 = "0vpfn2zivk8cf2l841jbd78zl1vzdw1wjf9p0dm6pgr84kj9pkx4";
    };
    dependencies = [ self.customPlugins.skWrapper ];
  };

  neovim = super.neovim.override {
    vimAlias = true;
    viAlias = true;
    withPython = false;
    withPython3 = true;
    withRuby = false;
    configure = {
        packages.myVimPackage = with super.vimPlugins; {
          start = [
            # Prettyness
            airline
            molokai
            nord-vim
            vim-highlightedyank
            self.customPlugins.vim-colors-github

            # IDE Like Stuff
            nerdtree
            vim-fugitive
            LanguageClient-neovim
            self.customPlugins.skim-vim

            # Utils
            vim-abolish
            unicode-vim
            vim-surround
            vim-commentary
            vim-repeat
            vim-unimpaired

            # Language Specific Plugins
            rust-vim
            vim-nix
            vim-go
            Jenkinsfile-vim-syntax
          ];

          opt = [ ultisnips ];
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
        set noshowmode
        set background=dark
        set ignorecase
        set smartcase
        set backspace=indent,eol,start
        set nowrap
        set textwidth=0
        set wrapmargin=0
        set formatoptions=qrn1j
        set autowriteall
        set novisualbell
        set noerrorbells
        set autoread
        set shellslash
        set hidden
        set signcolumn=yes
        set cursorline
        set inccommand=nosplit
        set noequalalways


        "autocmd BufEnter  *  call ncm2#enable_for_buffer()
        set completeopt=noinsert,menuone,noselect

        try
            colorscheme molokai
        catch /^Vim\%((\a\+)\)\=:E185/
            " theme not found so do nothing
        endtry

        "====[ Highlight hidden characters ]===========================================
        "set listchars=trail:\uB7,nbsp:~
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
        " Open NerdTree with \n
        nmap <leader>n :NERDTreeToggle<CR>
        " Perform grep on current word with \g
        nmap <leader>g :Rg <C-r><C-w><CR>
        " Grep a specified word with \G
        nmap <leader>G :Rg 
        " Toggle paste mode with \p
        nmap <leader>p :set paste!<CR>
        " Use FZF when doing ctrl+p
        nmap <c-p> :Files<CR>

        " Close if the quickfix window is the only one open
        aug QFClose
          au!
          au WinEnter * if winnr('$') == 1 && &buftype == "quickfix"|q|endif
        aug END

        " Use escape to exit terminal mode
        tnoremap <Esc> <C-\><C-n>
        tnoremap <C-w>k <C-\><C-n><C-w>k


        "====[ ripgrep ]===============================================================
        if executable('${super.ripgrep}/bin/rg')
          " Use ripgrep over grep
          set grepprg=${super.ripgrep}/bin/rg\ --vimgrep
        endif

        let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }


        "====[ ncm2 ]==================================================================
        " Use <TAB> to select the popup menu:
        ""inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
        ""inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"


        "===[ NERDTree ] ==============================================================
        let NERDTreeMinimalUI=1
        autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


        "===[ LanguageCLient ] ========================================================
        let g:LanguageClient_serverCommands = {
          \ 'rust': ['rls'],
          \ 'cpp': ['cquery', '--log-file=/tmp/cquery.log'],
          \ 'c': ['cquery', '--log-file=/tmp/cquery.log'],
          \ 'go': ['gopls'],
          \ 'sh': ['bash-language-server'],
          \ }

        function SetLSPShortcuts()
          nnoremap gd :call LanguageClient#textDocument_definition()<CR>

          nnoremap <leader>ld :call LanguageClient#textDocument_definition()<CR>
          nnoremap <leader>lf :call LanguageClient#textDocument_formatting()<CR>
          nnoremap <leader>lt :call LanguageClient#textDocument_typeDefinition()<CR>
          nnoremap <leader>lx :call LanguageClient#textDocument_references()<CR>
          nnoremap <leader>la :call LanguageClient_workspace_applyEdit()<CR>
          nnoremap <leader>lc :call LanguageClient#textDocument_completion()<CR>
          nnoremap <leader>lh :call LanguageClient#textDocument_hover()<CR>
          nnoremap <leader>ls :call LanguageClient_textDocument_documentSymbol()<CR>
          nnoremap <leader>lm :call LanguageClient_contextMenu()<CR>
          nnoremap <leader>lr :call LanguageClient#textDocument_rename()<CR>
          nnoremap <leader>lrc :call LanguageClient#textDocument_rename(
                    \ {'newName': Abolish.camelcase(expand('<cword>'))})<CR>
          nnoremap <leader>lrs :call LanguageClient#textDocument_rename(
                    \ {'newName': Abolish.snakecase(expand('<cword>'))})<CR>
          nnoremap <leader>lru :call LanguageClient#textDocument_rename(
                    \ {'newName': Abolish.uppercase(expand('<cword>'))})<CR>
        endfunction()

        augroup LSP
          autocmd!
          autocmd FileType cpp,c,go,rust,sh call SetLSPShortcuts()
        augroup END

        let g:LanguageClient_autostart = 1
        let g:LanguageClient_useVirtualText = 1


        "===[ Go ]====================================================================
        "   Language Client "
        autocmd FileType go setlocal
         \ shiftwidth=4
         \ tabstop=4
         \ softtabstop=4
         \ noexpandtab
         \ listchars=tab:\┃\ ,trail:·,extends:>,precedes:<,nbsp:+

        " vim-go "
        let g:go_def_mode = 'gopls'
        let g:go_info_mode = 'gopls'
        let g:go_referrers_mode = 'gopls'
        let g:go_rename_command = 'gopls'
        let g:go_fmt_autosave = 1
        let g:go_fmt_command = "goimports"
        let g:go_fmt_options = { 'goimports': '-s' }
        let g:go_metalinter_command = 'golangci-lint'


        "===[ Rust ] =================================================================
        autocmd BufWritePre *.rs :call LanguageClient#textDocument_formatting_sync()


        "===[ C++ ]===================================================================
        au BufRead,BufNewFile *.cpp set filetype=cpp
        au BufRead,BufNewFile *.hpp set filetype=cpp
        au BufRead,BufNewFile *.h set filetype=cpp
        autocmd FileType cpp :packadd LanguageClient-neovim
        autocmd BufWritePre *.cpp :call LanguageClient#textDocument_formatting_sync()
        autocmd BufWritePre *.hpp :call LanguageClient#textDocument_formatting_sync()
        autocmd BufWritePre *.h :call LanguageClient#textDocument_formatting_sync()


        "===[ YAML ]==================================================================
        au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
        autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expantab
      '';
    };
  };

  userPackages = super.userPackages or { } // {
    bash-language-server = super.nodePackages.bash-language-server;
    cquery = super.cquery;
    rust = (super.latest.rustChannels.stable.rust.override {
      extensions =
        [ "rust-src" "rls-preview" "clippy-preview" "rustfmt-preview" ];
    });
  };
}

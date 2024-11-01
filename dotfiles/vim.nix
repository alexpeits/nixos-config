{ pkgs }:

let

  # fzf-plugin = "${pkgs.fzf}/share/vim-plugins/fzf";

  markdown-frontmatter = ''
    unlet b:current_syntax
    syntax include @Yaml syntax/yaml.vim
    syntax region yamlFrontmatter start=/\%^---$/ end=/^---$/ keepend contains=@Yaml
  '';

  vimrc = ''
    set nocompatible

    let g:haskell_enable_quantification = 1   " highlighting `forall`
    let g:haskell_enable_recursivedo = 1      " highlighting `mdo` and `rec`
    let g:haskell_enable_arrowsyntax = 1      " highlighting `proc`
    let g:haskell_enable_pattern_synonyms = 1 " highlighting `pattern`
    let g:haskell_enable_typeroles = 1        " highlighting type roles
    let g:haskell_enable_static_pointers = 1  " highlighting `static`
    let g:haskell_backpack = 1                " highlighting backpack keywords
    let g:haskell_indent_disable = 1

    " install vim-plug if not installed
    if empty(glob('~/.vim/autoload/plug.vim'))
      silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      autocmd VimEnter * PlugInstall --sync
    endif

    call plug#begin('~/.vim/vimplug')

    " plugins
    Plug 'Raimondi/delimitMate'
    Plug 'airblade/vim-gitgutter'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'google/vim-searchindex'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'scrooloose/nerdcommenter'
    Plug 'tpope/vim-surround'
    Plug 'chaoren/vim-wordmotion'

    " filetypes
    Plug 'LnL7/vim-nix'
    Plug 'leafgarland/typescript-vim'
    Plug 'neovimhaskell/haskell-vim'
    Plug 'peitalin/vim-jsx-typescript'
    Plug 'chr4/nginx.vim'
    Plug 'tpope/vim-markdown'
    Plug 'jxnblk/vim-mdx-js'
    Plug 'Vimjas/vim-python-pep8-indent'
    Plug 'cespare/vim-toml'
    Plug 'hashivim/vim-terraform'

    " themes & ui
    Plug 'https://gitlab.com/protesilaos/tempus-themes-vim'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

    call plug#end()


    """""""""""""""""""""""""""""""""

    set lazyredraw
    set ttyfast
    set virtualedit=block
    set shortmess+=I
    set tabstop=4
    set softtabstop=4
    set shiftwidth=4
    set expandtab
    set hidden
    set backspace=2
    set wildmenu
    set wildmode=full
    set foldmethod=indent
    set foldlevel=99
    set hlsearch
    set autoread
    set showmatch
    set matchtime=4
    set timeoutlen=1000 ttimeoutlen=0
    set updatetime=100
    set number
    set splitbelow
    set splitright
    set noshowmode
    set noswapfile
    set wrap linebreak nolist
    set formatoptions+=r
    set incsearch
    set ignorecase
    set smartcase
    set colorcolumn=80

    syntax on
    filetype on
    filetype plugin indent on
    filetype plugin on

    autocmd BufRead,BufNewFile *.html,*.css,*.js,*.jsx,*.ts,*.tsx,*.json,*.nix,*.md,*.mdx set tabstop=2
    autocmd BufRead,BufNewFile *.html,*.css,*.js,*.jsx,*.ts,*.tsx,*.json,*.nix,*.md,*.mdx set softtabstop=2
    autocmd BufRead,BufNewFile *.html,*.css,*.js,*.jsx,*.ts,*.tsx,*.json,*.nix,*.md,*.mdx set shiftwidth=2

    autocmd BufRead,BufNewFile *.pants set syntax=python
    autocmd BufRead,BufNewFile .local-zshrc set syntax=zsh

    " jump to last position when opening file
    if has("autocmd")
      au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    endif

    " Powerline setup
    set laststatus=2
    let g:airline_powerline_fonts=1
    let g:airline#extensions#branch#enabled = 1
    let g:airline#extensions#tabline#enabled = 1
    let g:airline_skip_empty_sections = 1

    " NERDCommenter
    let g:NERDCustomDelimiters = {
        \ 'haskell': { 'left': '-- ', 'nested': 1, 'leftAlt': '{- ', 'rightAlt': ' -}', 'nestedAlt': 1 },
        \ 'cabal': { 'left': '-- ' },
        \ 'nix': { 'left': '# ' },
        \ 'c': { 'left': '// ', 'leftAlt': '/*', 'rightAlt': '*/' },
        \ 'cpp': { 'left': '// ', 'leftAlt': '/*', 'rightAlt': '*/' },
        \ 'javascript': { 'left': '// ', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ }
    execute "set <M-;>=\e;"
    nnoremap <M-;> :call NERDComment(0, "toggle")<CR>
    vnoremap <M-;> :call NERDComment(0, "toggle")<CR>

    " fzf
    let g:fzf_layout = { 'down': '~20%' }
    nnoremap <C-p> :GFiles<CR>
    nnoremap <C-s> :Rg<CR>
    nnoremap <leader>f :Files<CR>
    nnoremap <leader>b :Buffers<CR>
    nnoremap <leader>s :Rg<CR>
    nnoremap <leader>/ :BLines<CR>
    nnoremap <leader>gc :Commits<CR>
    nnoremap <leader>gd :BCommits<CR>

    if has("persistent_undo")
        call system('mkdir -p ~/.vim/undo')
        set undodir=~/.vim/undo/
        set undofile
    endif

    " tmux fixes for termguicolors
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors

    if $TERM_LIGHT != "1"
        set background=dark
        colorscheme tempus_winter
        highlight ExtraWhitespace ctermbg=88
        highlight haskellBottom ctermfg=Red
        highlight haskellFail ctermfg=LightRed
        highlight MatchParen guibg=#454857 cterm=bold
        let g:airline_theme='distinguished'
    else
        set background=light
        colorscheme tempus_dawn
        highlight ExtraWhitespace ctermbg=210
        highlight MatchParen guibg=#d7dbd5 cterm=bold
        let g:airline_theme='lucius'
    endif

    highlight Search cterm=reverse

    highlight Character cterm=NONE
    highlight Conditional cterm=NONE
    highlight Delimiter cterm=NONE
    highlight Exception cterm=NONE
    highlight Identifier cterm=NONE
    highlight Keyword cterm=NONE
    highlight Macro cterm=NONE
    highlight Operator cterm=NONE
    highlight Repeat cterm=NONE
    highlight Special cterm=NONE
    highlight SpecialComment cterm=NONE
    highlight Type cterm=NONE
    highlight Typedef cterm=NONE

    highlight MarkdownItalic cterm=italic
    hi clear MarkdownCodeDelimiter
    hi link MarkdownCodeDelimiter Comment
    hi clear MarkdownLinkDelimiter
    hi link MarkdownLinkDelimiter Comment

    match ExtraWhitespace /\s\+$/

    highlight GitGutterAdd ctermbg=none
    highlight GitGutterChange ctermbg=none
    highlight GitGutterChangeDelete ctermbg=none
    highlight GitGutterDelete ctermbg=none
    let g:gitgutter_map_keys = 0

    " haskell
    function! JumpHaskellFunction(reverse)
        call search('\C^[[:alnum:]]\+\_s*::', a:reverse ? 'bW' : 'W')
    endfunction

    au FileType haskell nnoremap <buffer><silent> ]] :call JumpHaskellFunction(0)<CR>
    au FileType haskell nnoremap <buffer><silent> [[ :call JumpHaskellFunction(1)<CR>
    au FileType haskell nnoremap <buffer> gI gg /\cimport<CR><ESC>:noh<CR>
    autocmd BufRead,BufNewFile *.hs set tabstop=2
    autocmd BufRead,BufNewFile *.hs set softtabstop=2
    autocmd BufRead,BufNewFile *.hs set shiftwidth=2

    " purescript
    au Bufread,BufNewFile *.purs set ft=haskell
    autocmd BufRead,BufNewFile *.purs set tabstop=2
    autocmd BufRead,BufNewFile *.purs set softtabstop=2
    autocmd BufRead,BufNewFile *.purs set shiftwidth=2

    " markdown
    autocmd FileType markdown set colorcolumn=100

    " starlark
    au Bufread,BufNewFile *.star set ft=python

    if exists("+mouse")
        set mouse=a
    endif

    "split navigations
    nnoremap <C-J> <C-W><C-J>
    nnoremap <C-K> <C-W><C-K>
    nnoremap <C-L> <C-W><C-L>
    nnoremap <C-H> <C-W><C-H>

    nnoremap Q <nop>
    noremap <silent> k gk
    noremap <silent> j gj

    "" various shortcuts
    noremap <C-n> :nohlsearch<CR>
    vnoremap > >gv
    vnoremap < <gv

    nnoremap <leader>q :bp<CR>
    nnoremap <leader>w :bn<CR>

    " lololol
    nmap ; :
    vmap ; :

    " trying that
    nmap <SPACE> <leader>

    " show identifier type under cursor
    map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
    \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
    \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
  '';

in

{
  vimrc = vimrc;
  markdown-frontmatter = markdown-frontmatter;
}

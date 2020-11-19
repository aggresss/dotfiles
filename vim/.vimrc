" Vim config file composed by aggresss
" https://raw.githubusercontent.com/aggresss/dotfiles/master/vim/.vimrc
" reference: http://vimdoc.sourceforge.net/htmldoc/options.htm
"
" Initial configuration
"
set nocompatible    " required
set backspace=indent,eol,start
filetype off        " required
let mapleader="\\"

" check if use bundle
if filereadable(expand("~/.vimrc.bundles"))
  " set the runtime path to include Vundle and initialize
  set rtp+=~/.vim/bundle/Vundle.vim
  call vundle#begin()
  Plugin 'VundleVim/Vundle.vim' " required
  Plugin 'scrooloose/nerdtree'
  Plugin 'editorconfig/editorconfig-vim'
  if filereadable(expand("/usr/bin/ctags"))
      \ || filereadable(expand("/usr/local/bin/ctags"))
      \ || filereadable(expand("~/bin/ctags"))
    Plugin 'taglist.vim'    " require install exuberant-ctags
  endif
  if filereadable(expand("/usr/bin/cscope"))
      \ || filereadable(expand("/usr/local/bin/cscope"))
      \ || filereadable(expand("~/bin/cscope"))
    Plugin 'cscope.vim'     " require install cscope
  endif
  call vundle#end()
  source ~/.vimrc.bundles   " source the plugin config
endif

filetype plugin indent on   " required

"
" Editor style list
"
colorscheme desert
highlight Pmenu ctermfg=black ctermbg=darkcyan
highlight PmenuSel ctermfg=black ctermbg=gray
syntax on
set encoding=utf-8
set fileencodings=utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1
set noswapfile
set number
set ruler
set nowrap
set nocursorline
set ts=4 sts=4 sw=4 et
set list
set listchars=tab:>-,trail:-
highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/

" statusline
set laststatus=2
set statusline=
set statusline+=%1*\[%n]%m%r%w%h
set statusline+=%2*\ %<%F
set statusline+=\ %3*\ %y
set statusline+=\ %4*\ %{''.(&fenc!=''?&fenc:&enc).''}%{(&bomb?\",BOM\ \":\"\")}
set statusline+=\ %5*\ %{&ff}
set statusline+=\ %6*\ %{&spelllang}
set statusline+=\ %7*\ %=\|\ VALUE=%b,\ HEX=%B\ \|
set statusline+=\ ROW:%l/%L\ (%03p%%)\ COL:%03c\ \|\ %P\ \|

" highlight StatusLine cterm=bold ctermfg=yellow ctermbg=darkblue
highlight User1 ctermfg=lightred  ctermbg=darkblue  cterm=bold
highlight User2 ctermfg=white  ctermbg=darkred
highlight User3 ctermfg=darkred  ctermbg=darkcyan
highlight User4 ctermfg=white  ctermbg=darkyellow
highlight User5 ctermfg=lightcyan  ctermbg=darkmagenta
highlight User6 ctermfg=darkred  ctermbg=darkgreen
highlight User7 ctermfg=yellow  ctermbg=darkblue

"
" Keyboard shortcut list
"
:map <F2>  :TlistToggle<cr>
:map <F3>  :NERDTreeToggle<cr>

:map <C-l> :vertical res +4<cr>
:map <C-h> :vertical res -4<cr>
:map <C-j> :res +2<cr>
:map <C-k> :res -2<cr>

:map <leader>r :%retab!<cr>
:map <leader>t :set noet<cr>
:map <leader>T :set et<cr>
:map <leader>p :set paste<cr>
:map <leader>P :set nopaste<cr>
:map <leader>n :set nonu<cr>
:map <leader>N :set nu<cr>
:map <leader>w :set wrap<cr>
:map <leader>W :set nowrap<cr>
:map <leader>l :set nolist<cr>
:map <leader>L :set list<cr>
:map <leader>s :set laststatus=0<cr>
:map <leader>S :set laststatus=2<cr>
:map <leader>h :set nocursorline<cr>
:map <leader>H :set cursorline<cr>
:map <leader>c :call Compile<cr>

"
" Custom command
"
" Trim CRLF to LF
command TrimCRLF %s/\r\(\n\)/\r/g
" Trim redundancy sapce at the end of line
command TrimEOL %s/\s\+$//g
" Trim number at the head of line
command TrimHnumber %s/^[0-9]\{1,}//g
" Trim one space at the head of line
command TrimOnespace %s/^\s//g
" Trim spaces at the head of line
command TrimSpaces %s/^\s*//g
" Trim blank lines
command TrimBlankLines g/^\s*$/d
" Trans SDP info \r\n
command TransSDP %s/\\r\\n/\r/g

"
" Custom function
"
" Compile singleton file
map <leader>c :call Compile()<CR>
function! Compile()
    exec "w"
    if &filetype == 'c'
        exec '!rm -rf %<.out'
        exec '!gcc -o %<.out %'
        exec '!%<.out'
    elseif &filetype == 'cpp'
        exec '!rm -rf %<.out'
        exec '!g++ -std=c++14 -o %<.out %'
        exec '!%<.out'
     elseif &filetype == 'go'
        exec '!rm -rf %<.out'
        exec '!go build -o %<.out %'
        exec '!%<.out'
    elseif &filetype == 'python'
        exec '!python %'
    elseif &filetype == 'sh'
        :!bash %
    endif
endfunc

" EOF


execute pathogen#infect()
syntax enable

" Color settings
let g:solarized_termcolors=256
set t_Co=256
" let g:solarized_termtrans=1
let g:solarized_contrast="high"
let g:solarized_visibility="normal"
set background=light
colorscheme solarized

" vim on Mac may mess up with the
" delete key, fix
set backspace=indent,eol,start

" Change map leader to ','
let mapleader = ','

" Toggle background
function! ToggleBG()
  let s:tbg = &background
  " Inversion
  if s:tbg == "dark"
      set background=light
  else
      set background=dark
  endif
endfunction
noremap <leader>bg :call ToggleBG()<CR>

if has("autocmd")
  " Make vim jump to the last position when reopening a file
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

  " Indentation based on filetype
  filetype plugin indent on
endif

" Enable spell-check
set spell spelllang=en_us

" Encoding
let &termencoding=&encoding
set fileencodings=utf-8,gbk,gb18030,cp936,ucs-bom,

" When split, split to the right
set splitright

" Highlight current line
set cursorline
hi cursorline term=underline cterm=underline ctermbg=NONE gui=underline

" Don't tab, space!
set tabstop=2
set shiftwidth=2
set expandtab

" Auto indentation
" set autoindent

" Search settings
set incsearch
set hls

" Show line number on left
set number

" Show (partial) command in status line
set showcmd

if has('cmdline_info')
  set ruler                   " Show the ruler
  set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
  set showcmd                 " Show partial commands in status line and
endif

set laststatus=2
"if has('statusline')
"  set laststatus=2
"
"  set statusline=%<%f\                     " Filename
"  set statusline+=%w%h%m%r                 " Options
"  set statusline+=\ [%{&ff}/%Y]            " Filetype
"  set statusline+=\ [%{getcwd()}]          " Current dir
"  set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
"endif

" Window manager short-cut
if bufwinnr(1) 
  map <Down> <C-W>+ 
  map <Up> <C-W>- 
  map <Right> <C-W>> 
  map <Left> <C-W>< 
endif 

" Set colorcolumn
if exists('+colorcolumn')
  set colorcolumn=81
  " ColorColumn highlight seems to be messed by Solarized, reset
	highlight ColorColumn term=reverse ctermbg=1 guibg=LightRed
	augroup colorcolumn
    autocmd!
    autocmd ColorScheme solarized highlight ColorColumn term=reverse ctermbg=1 guibg=LightRed
	augroup end
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>81v.\+', -1)
endif

" Set list special chars
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

" Use YCM for Eclim
let g:EclimCompletionMethod = 'omnifunc'

"" Setup Go highlight environment
"filetype off
"filetype plugin indent off
"set runtimepath+=/usr/local/go/misc/vim
"filetype plugin indent on
"" gofmt Go source files when they are saved.
"autocmd FileType go autocmd BufWritePre <buffer> Fmt

" C/C++ file extensions
autocmd BufRead,BufNewFile  *.h set filetype=cpp
autocmd BufRead,BufNewFile  *.hpp set filetype=cpp
let g:C_SourceCodeExtensions  = 'h hpp c cc cp cxx cpp CPP c++ C i ii'

" Insert header guard for C/C++ header files
function! s:insert_gates()
  let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
  execute "normal! i#ifndef __" . gatename . "_"
  execute "normal! o#define __" . gatename . "_"
  execute "normal! 3o"
  execute "normal! Go#endif /* __" . gatename . "_ */"
  normal! kk
endfunction
autocmd BufNewFile *.{h,hpp} call <SID>insert_gates()

" NERDTree {
    " Ignore object files in NERDTree
    let NERDTreeIgnore=['\.o$', '\~$']
" }

" YouCompleteMe (YCM) {
    " Default ycm build configuration file
    let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"
" }

" Conque term {
    " Disable conque term startup message
    let g:ConqueTerm_StartMessages = 0
" }


" Airline {
    let g:airline_theme='badwolf'
    " Enable tabline in airline
    let g:airline#extensions#tabline#enabled = 1
    " Show just the filename
    let g:airline#extensions#tabline#fnamemod = ':t'
" }


" Buffer management {
    " This allows buffers to be hidden if you've modified a buffer.
    " set hidden

    nmap <leader>T :enew<CR>
    nmap <leader>l :bnext<CR>
    nmap <leader>h :bprevious<CR>
    nmap <leader>bq :bp <BAR> bd #<CR>
    nmap <leader>bl :ls<CR>
" }

" Vim-LaTeX {
"    let g:tex_flavor='latex'
"    let g:Imap_PlaceHolderStart='<+'
"    let g:Imap_PlaceHolderEnd='+>'
" }

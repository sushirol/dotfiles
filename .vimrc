"------------------------------------------------------------------------------
" File:     $HOME/.vimrc
" Author:   Sushrut Shirole
"------------------------------------------------------------------------------
"
"------------------------------------------------------------------------------
" Pathogen (http://www.vim.org/scripts/script.php?script_id=2332).
"------------------------------------------------------------------------------
"

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdcommenter',
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'easymotion/vim-easymotion'
Plug 'vim-scripts/ZoomWin'
Plug 'BurntSushi/ripgrep'
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'christoomey/vim-tmux-navigator'
Plug 'majutsushi/tagbar'
Plug 'airblade/vim-gitgutter'
" Themes
Plug 'NLKNguyen/c-syntax.vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'morhetz/gruvbox'
Plug 'junegunn/seoul256.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'
call plug#end()

" The leader and local-leader characters.
let mapleader = ' '
let maplocalleader = ' '

" reload vimrc
map <leader>s :source ~/.vimrc<CR>

"------------------------------------------------------------------------------
" General.
"------------------------------------------------------------------------------

set scrolloff=10        " Keep a context (rows) when scrolling vertically.
set sidescroll=5        " Keep a context (columns) when scrolling horizontally.
set esckeys             " Cursor keys in insert mode.
set ttyfast             " Improves redrawing for newer computers.
set confirm             " Ask to save file before operations like :q or :e fail.
set magic               " Use 'magic' patterns (extended regular expressions).
set hidden              " Allow switching edited buffers without saving.
set nostartofline       " Keep the cursor in the current column with page cmds.
set nojoinspaces        " Insert just one space joining lines with J.
"set showcmd             " Show (partial) command in the status line.
set showmode            " Show the current mode.
set path=$PWD/**        " Include everything under $PWD into the path.
set nrformats-=octal    " Make incrementing 007 result into 008 rather than 010.

" Backup and swap files.
set nobackup            " Disable backup files.
set noswapfile          " Disable swap files.
set nowritebackup       " Disable auto backup before overwriting a file.

" Line numbers.
set number              " Show line numbers.
set relativenumber      " Show relative numbers instead of absolute ones.

" Whitespace.
set autoindent
set noexpandtab         " Do not expand tab with spaces.
"set tabstop=4           " Number of spaces a tab counts for.
"set shiftwidth=4        " Number of spaces to use for each step of indent.
set shiftround          " Round indent to multiple of shiftwidth.

" Wrapping.
set wrap                " Enable text wrapping.
set linebreak           " Break after words only.
set display+=lastline   " Show as much as possible from the last shown line.
set textwidth=0         " Don't automatically wrap lines.

" 80 characters line
execute "set colorcolumn=" . join(range(81,335), ',')
highlight ColorColumn ctermbg=Black ctermfg=DarkRed
set textwidth=0
if exists('&colorcolumn')
	set colorcolumn=80
endif

" Highlight trailing spaces
" " http://vim.wikia.com/wiki/Highlight_unwanted_spaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Statusline.
"set laststatus=2        " Always display a statusline.
"set statusline=%<%f                          " Path to the file in the buffer.
"set statusline+=\ %h%w%m%r%k                 " Flags (e.g. [+], [RO]).
"set statusline+=\ [%{(&fenc\ ==\"\"?&enc:&fenc).(&bomb?\",BOM\":\"\")},%{&ff}] " Encoding and line endings.
"set statusline+=\ %y                         " File type.
"set statusline+=\ [\%03.3b,0x\%02.2B,U+%04B] " Codes of the character under cursor.
"set statusline+=\ [%l/%L\ (%p%%),%v]         " Line and column numbers.

"highlight fzf1 ctermfg=161 ctermbg=251
"highlight fzf2 ctermfg=23 ctermbg=251
"highlight fzf3 ctermfg=237 ctermbg=251
"set statusline+=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f

" Searching.
set hlsearch            " Highlight search matches.
set incsearch           " Incremental search.
" Case-smart searching (make /-style searches case-sensitive only if there is
" a capital letter in the search expression).
set ignorecase
set smartcase

" No bell sounds.
set noerrorbells visualbell t_vb=

"------------------------------------------------------------------------------
" Colors.
"------------------------------------------------------------------------------

" Syntax highlighting.
syntax on

"------------------------------------------------------------------------------
" Abbreviations and other mappings.
"------------------------------------------------------------------------------

" Stay in visual mode when indenting.
vnoremap < <gv
vnoremap > >gv

" Quickly select the text I just pasted.
noremap gV `[v`]

" Disable arrows keys (I use exclusively h/j/k/l).
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>

" Make Y yank everything from the cursor to the end of the line.
" This makes Y act more like C or D because by default, Y yanks the current
" line (i.e. the same as yy).
noremap Y y$

" Check for changes in all buffers, automatically reload them, and redraw.
nnoremap <silent> <Leader>rr :set autoread <Bar> checktime <Bar> redraw! <Bar> set noautoread<CR>

" Opening files in tabs.
nnoremap <Leader>zsh :e ~/.zshrc<CR>
nnoremap <Leader>vim :e ~/.vimrc<CR>
nnoremap <Leader>tmux :e ~/.tmux.conf<CR>

"------------------------------------------------------------------------------
" Plugins.
"------------------------------------------------------------------------------

"------------------------------------------------------------------------------
" FZF.
"------------------------------------------------------------------------------
"
nnoremap <silent> <Leader>t :Tags<CR>
nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>w :Windows<CR>
nnoremap <silent> <leader>l :BLines<CR>
nnoremap <silent> <leader>? :History<CR>
nnoremap <silent> <Leader>C :Colors<CR>
"nnoremap <silent> <leader>/ :execute 'Ag ' . input('Ag/')<CR>
"nnoremap <silent> <leader>. :AgIn<space>
nnoremap <silent> <leader>/ :execute 'Rg ' . input('Rg/')<CR>
nnoremap <silent> <leader>. :RgIn<space>

" Hide statusline of terminal buffer
"autocmd! FileType fzf
"autocmd  FileType fzf set laststatus=0 noshowmode noruler
  "\| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R'

command! -bang Colors
  \ call fzf#vim#colors({'left': '15%', 'options': '--reverse --margin 30%,0'}, <bang>0)

"" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-q': 'wall | bdelete',
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }


" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Advanced customization using autoload functions
" inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})

set complete=.,w,b,u

"----------------------------------------------------------------------------
" Ag Silversearcher
"----------------------------------------------------------------------------
"nnoremap <silent> S :call SearchWordWithAg()<CR>
"function! SearchWordWithAg()
  "execute 'Ag' expand('<cword>')
"endfunction

"command! -nargs=+ -complete=dir AgIn call s:ag_in(<f-args>)

"   :Ag  - Start fzf with hidden preview window that can be enabled with "?" key
"   :Ag! - Start fzf in fullscreen and display the preview window above
"command! -bang -nargs=* Ag
  "\ call fzf#vim#ag(<q-args>,
  "\                 <bang>0 ? fzf#vim#with_preview('up:60%')
  "\                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  "\                 <bang>0)

"----------------------------------------------------------------------------
" Rg RipGrep
"----------------------------------------------------------------------------
" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options

command! -nargs=+ -complete=dir RgIn call s:rg_in(<f-args>)

command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

"   :Rg  - Start fzf with hidden preview window that can be enabled with '?' key
"   :Rg! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg -i --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

nnoremap <silent> S :call SearchWordWithRg()<CR>
function! SearchWordWithRg()
  execute 'Rg' expand('<cword>')
endfunction

"------------------------------------------------------------------------------

" Command mistypes.
nnoremap :W :w
nnoremap :E :e
nnoremap :Q :q
nnoremap :Set :set
nnoremap :Vsp :vsp
cmap w!! w !sudo tee >/dev/null %

"------------------------------------------------------------------------------
" Theme
"------------------------------------------------------------------------------

set t_Co=256   " This is may or may not needed.

"set background=light
set background=dark
colorscheme PaperColor
"colorscheme gruvbox

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_theme='distinguished'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tmuxline#enabled = 1
let airline#extensions#tmuxline#snapshot_file = "~/.tmux-status.conf"

" ------------------------------------------------------------------------------
"  persistant undo
" ------------------------------------------------------------------------------
" Put plugins and dictionaries in this dir (also on Windows)
let vimDir = '$HOME/.vim'
let &runtimepath.=','.vimDir

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let myUndoDir = expand(vimDir . '/undodir')
    " Create dirs
    call system('mkdir ' . vimDir)
    call system('mkdir ' . myUndoDir)
    let &undodir = myUndoDir
    set undofile
endif

"--------------------------------------------------------------------------------
" Tell vim-whitespace to strip whitespace on save
"au VimEnter * EnableStripWhitespaceOnSave
" Tell vim-whitespace to disable the current line highlightin
"au VimEnter * CurrentLineWhitespaceOff soft
"
"------------------------------------------------------------------------------
" Fugitive
"------------------------------------------------------------------------------
nmap     <Leader>gs :Gstatus<CR>gg<c-n>
nnoremap <Leader>d :Gdiff<CR>
nnoremap <Leader>gl :Glog<CR>

"
"nnoremap <silent> <S-Left> :wincmd h<CR>
"nnoremap <silent> <S-Right> :wincmd l<CR>
"
let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <S-Left> :TmuxNavigateLeft<cr>
nnoremap <silent> <S-Right> :TmuxNavigateRight<cr>
nnoremap <silent> <S-Up> :TmuxNavigateUp<cr>
nnoremap <silent> <S-Down> :TmuxNavigateDown<cr>

" DMS needs 4spaces.
autocmd BufNewFile,BufRead /home/sushrut/workspace/acadia_kernel/*/pavilion/target/* setlocal expandtab ts=4 sw=4

"Tagbar
nmap <leader>rt :TagbarToggle<CR>

"------------------------------------------------------------------------------
set encoding=UTF-8

set cursorline
:hi CursorLine cterm=NONE guibg=Grey40

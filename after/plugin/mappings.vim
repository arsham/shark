let mapleader = " "

noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>
" Disable Ex mode
nmap Q <Nop>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" make the regular expression less crazy
nnoremap / /\v
vnoremap / /\v
nnoremap ? ?\v
vnoremap ? ?\v

" Moving lines with alt key.
nnoremap <A-j> :<c-u>execute 'm +'. v:count1<cr>==
nnoremap <A-k> :<c-u>execute 'm -1-'. v:count1<cr>==
" nnoremap <A-j> :m .+1<CR>==
" nnoremap <A-k> :m .-2<CR>==

inoremap <A-j> <Esc>:<c-u>execute 'm +'. v:count1<cr>==gi
inoremap <A-k> <Esc>:<c-u>execute 'm -1-'. v:count1<cr>==gi
" inoremap <A-j> <Esc>:m .+1<CR>==gi
" inoremap <A-k> <Esc>:m .-2<CR>==gi

vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Keep the visually selected area when indenting.
xnoremap < <gv
xnoremap > >gv

" Re-indent the whole file.
nnoremap g= gg=Gg``

" insert empty lines with motions, can be 10[<space>
nnoremap <silent> [<space>  :<c-u>put!=repeat([''],v:count)<bar>']+1<cr>
nnoremap <silent> ]<space>  :<c-u>put =repeat([''],v:count)<bar>'[-1<cr>
" Old version
" nnoremap [<space>  :<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[
" nnoremap ]<space>  :<c-u>put =repeat(nr2char(10), v:count1)<gr>

nnoremap <C-h> <C-w><C-h>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>

nnoremap <C-e> 2<C-e>
nnoremap <C-y> 2<C-y>

" Auto re-centre when moving around
nmap G Gzz
nnoremap g; g;zz
nnoremap g, g,zz

" put numbered motions in the jumplist.
nnoremap <expr> k (v:count > 1 ? "m'" . v:count : '') . 'k'
nnoremap <expr> j (v:count > 1 ? "m'" . v:count : '') . 'j'

" Clear hlsearch
nnoremap <silent> <Esc><Esc> :<C-u>:nohlsearch<CR>

nmap <C-W>z <Plug>(zoom-toggle)

" Snippets
nnoremap \html :-1read $HOME/.config/nvim/files/snippets/html/skelleton.txt<CR>3jwf>a

" Terminal mappings.
tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
tnoremap <C-w><C-h> <C-\><C-N><C-w>h
tnoremap <C-w><C-j> <C-\><C-N><C-w>j
tnoremap <C-w><C-k> <C-\><C-N><C-w>k
tnoremap <C-w><C-l> <C-\><C-N><C-w>l

" Add comma at the end of the line.
inoremap <M-,> <Esc>m`A,<Esc>``a
nnoremap <M-,> m`A,<Esc>``

" Add period at the end of the line.
inoremap <M-.> <Esc>m`A.<Esc>``a
nnoremap <M-.> m`A.<Esc>``

" Insert a pair of brackets and go into insert mode.
inoremap <M-{> <Esc>A {<CR>}<Esc>O
nnoremap <M-{> A {<CR>}<Esc>O

noremap <Leader>y "+y
noremap <Leader>p "+p
noremap <Leader>P "+P

" select a text, and this will replace it with the " contents.
vnoremap <leader>p "_dP

" let the visual mode use the period. To add " at the begining of all lines:
" I:<ESC>j0vG.
vnoremap . :norm.<CR>

nnoremap <silent> <C-p> :Files<CR>
nnoremap <leader>@ :Vista finder nvim_lsp<cr>
nnoremap <leader>: :Commands<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>/ :BLines<CR>

" Open the search tool.
nnoremap <silent> <leader>f :ArshamRg<CR>
" Search over current word.
nnoremap <silent> <leader>rg :ArshamRg <C-R>=expand("<cword>")<CR><CR>

nnoremap ]q :cnext<CR>
nnoremap [q :cprevious<CR>

" auto correct spelling and jump back.
function! s:FixLastSpellingError()
    let l:currentspell=&spell
    setlocal spell
    normal! [s1z=``
    let &l:spell=l:currentspell
endfunction
nnoremap <leader>sp :call <SID>FixLastSpellingError()<cr>

if exists(':NvimTreeToggle')
    nmap <leader>tt :NvimTreeToggle<CR>
endif

if exists(':ALEInfo')
    nmap <Leader>lp <Plug>(ale_previous_wrap)
    nmap <Leader>ln <Plug>(ale_next_wrap)
    nmap <Leader>ll <Plug>(ale_lint)
endif

" Copied from https://gist.github.com/romainl/db725db7babc84a9a6436180cedee188
" Usage: 6. to repeat the . 6 times.
" nnoremap . :<C-u>execute "norm! " . repeat(".", v:count1)<CR>

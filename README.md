"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Dependencies
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" yay -S git-delta-bin xsel bat the_silver_searcher ctags


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Research
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*. Jumplist
*. Changelist
*. Marks




" wildmenu, wildoptions, wildignore and wildignorecase

" try this: https://github.com/ThePrimeagen/vim-be-good
" try this: https://github.com/victormours/dotfiles/tree/master/vim

" For mapping CapsLock to escape:
" ~/.xinitrc  (before the exec $(get-session))
" setxkbmap -option caps:escape



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
=> cheat sheet
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

qa                     : start recording a macro named "a"
q                      : stop recording
@a                     : play back the macro

@:                     : repeat last Ex-command

    quickfix window commands
http://vimdoc.sourceforge.net/htmldoc/vimindex.html#g
gUtl                     : uppercase to l
gq (on a highlighted line in VISUAL) : wraps the comment
gi                       : brings you to the last insertion position


:let @a='d2wj0^['     : create a new macro manually. The ^[ is one character and you should produce it by CTRL-D<ESC>
then select it, assign it to a register.

:let @/='cheat'          : manually put this string into the searching register, which initiates a search.
Double-space your file: :g/^/put _. This puts the contents of the black hole register (empty when reading, but writable, behaving like /dev/null) linewise, after each line (because every line has a beginning!).
https://jonasjacek.github.io/colors/


"This outputs the shortcuts, with where they were defined, to a text file.
":redir! > vim_keys.txt
":silent verbose map
":redir END


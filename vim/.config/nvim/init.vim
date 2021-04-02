" mkdir -o ~/.config/nvim/
" ln -s ~/dotfiles/.nvimrc ~/.config/nvim/init.vim


set runtimepath^=~/.nvim runtimepath+=~/.nvim/after
let &packpath = &runtimepath
source ~/.vimrc

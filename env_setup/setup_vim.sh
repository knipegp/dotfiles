#!/bin/bash

# From https://stackoverflow.com/questions/59895/
# get-the-source-directory-of-a-bash-script-from-within-the-script-itself
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

function get_vimrc() {
    cp $DIR/vimrc ~/.vimrc
}

function install_pathogen() {
    # From https://github.com/tpope/vim-pathogen
    mkdir -p ~/.vim/autoload ~/.vim/bundle && \
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
    printf "\" Setup Pathogen\n" >> ~/.vimrc
    printf "execute pathogen#infect()\n" >> ~/.vimrc
}

function install_nerd_tree() {
    mkdir -p ~/.vim/bundle/nerdtree
    git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree
    printf "\" Allow NERDTREE to make new files\n" >> ~/.vimrc
    printf "set modifiable\n" >> ~/.vimrc

}

function install_nerd_tree_git() {
    mkdir -p ~/.vim/bundle/nerdtree-git-plugin
    git clone https://github.com/Xuyuanp/nerdtree-git-plugin.git \
        ~/.vim/bundle/nerdtree-git-plugin
}


function install_commentary() {
    mkdir -p ~/.vim/bundle/vim-commentary
    git clone https://github.com/tpope/vim-commentary.git ~/.vim/bundle/vim-commentary
}

function install_syntastic() {
    mkdir -p ~/.vim/bundle/syntastic
    git clone --depth=1 https://github.com/vim-syntastic/syntastic.git \
        ~/.vim/bundle/syntastic
    printf "\" Syntastic setup\n" >> ~/.vimrc
    printf "set statusline+=%%#warningmsg#\n" >> ~/.vimrc
    printf "set statusline+=%%{SyntasticStatuslineFlag()}\n" >> ~/.vimrc
    printf "set statusline+=%%*\n\n" >> ~/.vimrc
    printf "let g:syntastic_always_populate_loc_list = 1\n" >> ~/.vimrc
    printf "let g:syntastic_auto_loc_list = 1\n" >> ~/.vimrc
    printf "let g:syntastic_check_on_open = 1\n" >> ~/.vimrc
    printf "let g:syntastic_check_on_wq = 0\n" >> ~/.vimrc
}

function install_multi_cursors() {
    mkdir -p ~/.vim/bundle/vim-multiple-cursors
    git clone https://github.com/terryma/vim-multiple-cursors.git \
        ~/.vim/bundle/vim-multiple-cursors
}

function install_airline() {
    mkdir -p ~/.vim/bundle/vim-airline
    git clone https://github.com/vim-airline/vim-airline ~/.vim/bundle/vim-airline
}

function install_gitgutter() {
    mkdir -p ~/.vim/bundle/vim-gitgutter
    git clone git://github.com/airblade/vim-gitgutter.git ~/.vim/bundle/vim-gitgutter
}

function main() {
    get_vimrc
    install_pathogen
    install_nerd_tree
    install_nerd_tree_git
    install_commentary
    install_syntastic
    install_multi_cursors
    install_airline
    install_gitgutter
    vim -u NONE -c "Helptags" -c q
}

main

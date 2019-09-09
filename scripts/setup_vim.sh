#!/bin/bash

# From https://stackoverflow.com/questions/59895/
# get-the-source-directory-of-a-bash-script-from-within-the-script-itself
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

BASHRC_ADDON=$DIR/.vimrc

function install_pathogen() {
    # From https://github.com/tpope/vim-pathogen
    mkdir -p ~/.vim/autoload ~/.vim/bundle && \
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
    printf "\" Setup Pathogen\n" >> $DIR/AddOns.vim
    printf "execute pathogen#infect()\n" >> $DIR/AddOns.vim
}

function install_nerd_tree() {
    mkdir -p ~/.vim/bundle/nerdtree
    git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree
    printf "\" Allow NERDTREE to make new files\n" >> $DIR/AddOns.vim
    printf "set modifiable\n" >> $DIR/AddOns.vim

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

function install_fugitive() {
    mkdir -p ~/.vim/bundle/vim-fugitive
    git clone https://github.com/tpope/vim-fugitive.git ~/.vim/bundle/vim-fugitive
    vim -u NONE -c "helptags ~/.vim/bundle/vim-fugitve/vim-fugitive/doc" -c q
}

function install_syntastic() {
    mkdir -p ~/.vim/bundle/syntastic
    git clone --depth=1 https://github.com/vim-syntastic/syntastic.git \
        ~/.vim/bundle/syntastic
    printf "\" Syntastic setup\n" >> $BASHRC_ADDON
    printf "set statusline+=%%#warningmsg#\n" >> $BASHRC_ADDON
    printf "set statusline+=%%{SyntasticStatuslineFlag()}\n" >> $BASHRC_ADDON
    printf "set statusline+=%%*\n\n" >> $BASHRC_ADDON
    printf "let g:syntastic_always_populate_loc_list = 1\n" >> $BASHRC_ADDON
    printf "let g:syntastic_auto_loc_list = 1\n" >> $BASHRC_ADDON
    printf "let g:syntastic_check_on_open = 1\n" >> $BASHRC_ADDON
    printf "let g:syntastic_check_on_wq = 0\n" >> $BASHRC_ADDON
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

function install_vimtex() {
    mkdir -p ~/.vim/bundle/vimtex
    git clone https://github.com/lervag/vimtex.git ~/.vim/bundle/vimtex
    printf "\" Vimtex setup\n" >> $BASHRC_ADDON
    printf "let g:tex_flavor = \"latex\"\n" >> $BASHRC_ADDON
}

function install_youcompleteme() {
    mkdir -p ~/.vim/bundle/youcompleteme
    git clone https://github.com/ycm-core/YouCompleteMe.git ~/.vim/budle/youcompleteme
    printf "\" YouCompleteMe setup\n" >> $BASHRC_ADDON
    printf "let g:ycm_filetype_blacklist = {\n"
    printf "\t\\ 'tex' : 1,\n" >> $BASHRC_ADDON
    printf "\t\\ 'plaintex' : 1,\n" >> $BASHRC_ADDON
    printf "\t\\ 'rst' : 1,\n" >> $BASHRC_ADDON
    printf "\t\\ 'markdown' : 1,\n" >> $BASHRC_ADDON
    printf "\\}\n" >> $BASHRC_ADDON
}

function install_snippets() {
    mkdir -p ~/.vim/bundle/ultisnips
    git clone https://github.com/SirVer/ultisnips.git ~/.vim/bundle/ultisnips
    mkdir -p ~/.vim/budle/vim-snippets
    git clone https://github.com/honza/vim-snippets.git ~/.vim/bundle/vim-snippets
    printf "\" Snippets setup\n" >> $BASHRC_ADDON
    printf "\" From: https://github.com/SirVer/ultisnips/blob/master/README.md#quick-start\n" \
        >> $BASHRC_ADDON
    printf "autocmd BufNewFile,BufRead *.tex\n" >> $BASHRC_ADDON
    printf "\t\\ let g:UltiSnipsExpandTrigger=\"<tab>\"\n" >> $BASHRC_ADDON
    printf "\t\\ let g:UltiSnipsJumpForwardTrigger=\"<c-b>\"\n" >> $BASHRC_ADDON
    printf "\t\\ let g:UltiSnipsJumpBackwardTrigger=\"<c-z>\"\n" >> $BASHRC_ADDON
}

function main() {
    install_pathogen
    install_nerd_tree
    install_nerd_tree_git
    install_commentary
    install_syntastic
    install_multi_cursors
    install_airline
    install_gitgutter
    install_fugitive
    install_vimtex
    install_youcompleteme
    install_snippets
    vim -u NONE -c "Helptags" -c q
}

main

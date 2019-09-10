#!/bin/bash

# From https://stackoverflow.com/questions/59895/
# get-the-source-directory-of-a-bash-script-from-within-the-script-itself
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

PLUGIN_RC=$DIR/PlugIns.vim

function install_pathogen() {
    # From https://github.com/tpope/vim-pathogen
    mkdir -p $DIR/autoload $DIR/bundle && \
    curl -LSso $DIR/autoload/pathogen.vim https://tpo.pe/pathogen.vim
    mkdir -p ~/.vim
    ln -s $DIR/autoload ~/.vim/autoload
    ln -s $DIR/bundle ~/.vim/bundle
    printf "\" Setup Pathogen\n" >> $PLUGIN_RC
    printf "execute pathogen#infect()\n" >> $PLUGIN_RC
}

function install_nerd_tree() {
    printf "\" Allow NERDTREE to make new files\n" >> $PLUGIN_RC
    printf "set modifiable\n" >> $PLUGIN_RC
}

function install_fugitive() {
    vim -u NONE -c "helptags $DIR/bundle/vim-fugitve/vim-fugitive/doc" -c q
}

function install_syntastic() {
    printf "\" Syntastic setup\n" >> $PLUGIN_RC
    printf "set statusline+=%%#warningmsg#\n" >> $PLUGIN_RC
    printf "set statusline+=%%{SyntasticStatuslineFlag()}\n" >> $PLUGIN_RC
    printf "set statusline+=%%*\n\n" >> $PLUGIN_RC
    printf "let g:syntastic_always_populate_loc_list = 1\n" >> $PLUGIN_RC
    printf "let g:syntastic_auto_loc_list = 1\n" >> $PLUGIN_RC
    printf "let g:syntastic_check_on_open = 1\n" >> $PLUGIN_RC
    printf "let g:syntastic_check_on_wq = 0\n" >> $PLUGIN_RC
}

function install_vimtex() {
    printf "\" Vimtex setup\n" >> $PLUGIN_RC
    printf "let g:tex_flavor = \"latex\"\n" >> $PLUGIN_RC
}

function install_youcompleteme() {
    printf "\" YouCompleteMe setup\n" >> $PLUGIN_RC
    printf "let g:ycm_filetype_blacklist = {\n"
    printf "\t\\ 'tex' : 1,\n" >> $PLUGIN_RC
    printf "\t\\ 'plaintex' : 1,\n" >> $PLUGIN_RC
    printf "\t\\ 'rst' : 1,\n" >> $PLUGIN_RC
    printf "\t\\ 'markdown' : 1,\n" >> $PLUGIN_RC
    printf "\\}\n" >> $PLUGIN_RC
}

function install_snippets() {
    printf "\" Snippets setup\n" >> $PLUGIN_RC
    printf "\" From: https://github.com/SirVer/ultisnips/blob/master/README.md#quick-start\n" \
        >> $PLUGIN_RC
    printf "autocmd BufNewFile,BufRead *.tex\n" >> $PLUGIN_RC
    printf "\t\\ let g:UltiSnipsExpandTrigger=\"<tab>\"\n" >> $PLUGIN_RC
    printf "\t\\ let g:UltiSnipsJumpForwardTrigger=\"<c-b>\"\n" >> $PLUGIN_RC
    printf "\t\\ let g:UltiSnipsJumpBackwardTrigger=\"<c-z>\"\n" >> $PLUGIN_RC
}

function main() {
    install_pathogen
    install_nerd_tree
    install_syntastic
    install_fugitive
    install_vimtex
    install_youcompleteme
    install_snippets
    vim -u NONE -c "Helptags" -c q
}

main

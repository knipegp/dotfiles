let bad = 0
if has('nvim')
    if !filereadable('~/.local/share/nvim/site/autoload/plug.vim')
        let bad = 1
    else
        call plug#begin()
    endif
else
    if !filereadable('~/.vim/autoload/plug.vim')
        let bad = 1
    else
        call plug#begin('~/.vim/plugged')
    endif
endif

if !bad
    Plug 'scrooloose/nerdtree'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'airblade/vim-gitgutter'
    Plug 'vim-syntastic/syntastic'
    Plug 'tpope/vim-fugitive'
    Plug 'vim-airline/vim-airline'
    Plug 'ycm-core/YouCompleteMe'
    Plug 'SirVer/ultisnips'

    call plug#end()
endif

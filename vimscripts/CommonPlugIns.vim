function InitCommonPlugIns(plugin_install_dir)
    call plug#begin(a:plugin_install_dir)

    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
    Plug 'preservim/nerdtree'
    Plug 'vim-airline/vim-airline'
    Plug 'ycm-core/YouCompleteMe', { 'do': 'python3 install.py --all' }
    Plug 'airblade/vim-gitgutter'
    Plug 'tpope/vim-fugitive'

    call plug#end()
endfunction

function ConfigPlugIns(vimscript_dir, plugin_install_dir, install_path_script_pairs)
    let l:loop_idx = 0
    while loop_idx < len(a:install_path_script_pairs)
        let l:pair = a:install_path_script_pairs[loop_idx]
        let l:loop_idx += 1
        let l:install_path = a:plugin_install_dir . pair[0]
        let l:config_path = a:vimscript_dir . '/' . pair[1]
        if FileExists(install_path) && FileExists(config_path)
            execute 'source' . config_path
        endif
    endwhile
endfunction

function ConfigCommonPlugIns(vimscript_dir, plugin_install_dir)
    let l:install_path_script_pairs = [
        \['nerdtree', 'NerdTree.vim'],
        \['vim-go', 'VimGo.vim'],
        \['vim-airline', 'VimAirline.vim'],
    \]
    call ConfigPlugIns(a:vimscript_dir, a:plugin_install_dir, install_path_script_pairs)
endfunction

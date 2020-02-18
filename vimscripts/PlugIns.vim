if has('nvim')
    " TODO: Break each section into its own file. 1 file per plugin.
    " Allow NERDTREE to make new files
    set modifiable
    " Syntastic setup
    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*
    let g:syntastic_sh_shellcheck_args = '-x'
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 0
    let g:syntastic_check_on_wq = 0
    let g:syntastic_aggregate_errors = 1
    " " Disable syntastic checkers for LaTeX
    " let g:syntastic_tex_checkers = []
    " autocmd BufNewFile,BufRead *.cls   set syntax=tex
    " " YouCompleteMe setup
    let g:ycm_show_diagnostics_ui = 0
    " Snippets setup
    let g:UltiSnipsExpandTrigger="<c-a>"
    let g:UltiSnipsJumpForwardTrigger="<c-b>"
    let g:UltiSnipsJumpBackwardTrigger="<c-z>"
    " YouCompleteMe setup
    let g:ycm_filetype_blacklist = {
        \ 'tex' : 1,
        \ 'plaintex' : 1,
        \ 'rst' : 1,
        \ 'markdown' : 1,
    \}
    " Snippets setup
    " From: https://github.com/SirVer/ultisnips/blob/master/README.md#quick-start
    " autocmd BufNewFile,BufRead *.tex
    " 	\ let g:UltiSnipsExpandTrigger="<tab>"
    " 	\ let g:UltiSnipsJumpForwardTrigger="<c-b>"
    " 	\ let g:UltiSnipsJumpBackwardTrigger="<c-z>"
    colorscheme molokai
endif

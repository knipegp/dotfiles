" Setup Pathogen
execute pathogen#infect()
" Allow NERDTREE to make new files
set modifiable
" Syntastic setup
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1
" Syntastic cpp setup
let g:syntastic_cpp_checkers = ['clang_tidy', 'gcc']
let g:syntastic_cpp_clang_tidy_args = '-checks=clang-analyzer-*'
let g:syntastic_cpp_gcc_args = '-Wall -Wextra -lstdc++'
" Vimtex setup
let g:tex_flavor = "latex"
let g:vimtex_compiler_latexmk = {
    \ 'backend' : 'jobs',
    \ 'background' : 1,
    \ 'build_dir' : 'latex_build',
    \ 'callback' : 1,
    \ 'continuous' : 1,
    \ 'executable' : 'latexmk',
    \ 'hooks' : [],
    \ 'options' : [
        \ '-verbose',
        \ '-file-line-error',
        \ '-synctex=1',
        \ '-interaction=nonstopmode',
    \ ],
\ }
" YouCompleteMe setup
let g:ycm_filetype_blacklist = {
    \ 'tex' : 1,
    \ 'plaintex' : 1,
    \ 'rst' : 1,
    \ 'markdown' : 1,
\ }
let g:ycm_show_diagnostics_ui = 0
function SetupSnippets()
    let g:UltiSnipsExpandTrigger="<tab>"
    let g:UltiSnipsJumpForwardTrigger="<c-b>"
    let g:UltiSnipsJumpBackwardTrigger="<c-z>"
endfunction

" Snippets setup
" From: https://github.com/SirVer/ultisnips/blob/master/README.md#quick-start
autocmd BufNewFile,BufRead *.tex call SetupSnippets()
" Powerline setup
let g:airline_powerline_fonts = 1

" TODO: Break each section into its own file. 1 file per plugin.
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
" Syntastic c setup
let g:syntastic_c_checkers = ['clang_tidy']
let g:syntastic_c_clang_tidy_args = '-checks=clang-analyzer-*,cppcoreguidelines-*'
" Syntastic cpp setup
let g:syntastic_cpp_checkers = ['clang_tidy', 'oclint']
let g:syntastic_cpp_clang_tidy_args = '-checks=clang-analyzer-*,cppcoreguidelines-*'
let g:syntastic_cpp_oclint_post_args = '-- -std=c++11'
" Syntastic python setup
let g:syntastic_python_checkers = ['pylint', 'mypy']
" TODO: Remove the absolute path
let g:syntastic_python_mypy_args = '--config-file=/home/griff/dotfiles/python/mypy.ini'
" Syntastic go setup
let g:syntastic_go_checkers = ['govet', 'gofmt', 'golint']
" Disable syntastic checkers for LaTeX
let g:syntastic_tex_checkers = []
" Vimtex setup
let g:tex_flavor = "latex"
let g:vimtex_compiler_latexmk = {
    \ 'backend' : 'jobs',
    \ 'background' : 1,
    \ 'build_dir' : 'build',
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
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
let g:vimtex_view_general_options_latexmk = '--unique'
autocmd BufNewFile,BufRead *.cls   set syntax=tex
" YouCompleteMe setup
let g:ycm_show_diagnostics_ui = 0
" Snippets setup
let g:UltiSnipsExpandTrigger="<c-a>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" Powerline setup
let g:airline_powerline_fonts = 1

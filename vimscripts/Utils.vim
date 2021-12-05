function FileExists(file_path)
    if filereadable(a:file_path) || isdirectory(a:file_path)
        return 1
    endif
    return 0
endfunction

function SourceIfExists(vim_script_dir, script_names)
    let l:loop_idx = 0
    while loop_idx < len(a:script_names)
        let l:script_path = a:vim_script_dir . '/' . a:script_names[loop_idx]
        let l:loop_idx += 1
        if FileExists(script_path)
            execute 'source' . script_path
        endif
    endwhile
endfunction

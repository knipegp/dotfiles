function FileExists(file_path)
   if filereadable(a:file_path)
       return 1
   endif
   return 0
endfunction

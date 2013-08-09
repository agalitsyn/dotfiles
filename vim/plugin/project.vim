let s:project_filename = 'project.vim'

if exists("is_project_file_loaded") 
    finish
endif

let is_project_file_loaded = 1

let current_dir = getcwd()
let full_path = current_dir . '/' . s:project_filename 

if filereadable(full_path)
    exec 'source ' . fnameescape(full_path)
endif

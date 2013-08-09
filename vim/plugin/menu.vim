function s:menu_action(...)
    echo line('.')    
endfunction

function! s:menu_open_window(...)
    let s:last_buffer = bufnr('%')
    let bname = '__menu__'
    let winnum = bufwinnr(bname)
    if winnum != -1
        if winnr() != winnum
            " If not already in the window, jump to it
            exe winnum . 'wincmd w'
        endif

        setlocal modifiable

        " Delete the contents of the buffer to the black-hole register
        silent! %delete _
    else
        " Open a new window at the bottom

        " If the __MRU_Files__ buffer exists, then reuse it. Otherwise open
        " a new buffer
        let bufnum = bufnr(bname)
        if bufnum == -1
            let wcmd = bname
        else
            let wcmd = '+buffer' . bufnum
        endif

        exe 'silent! botright ' . g:MRU_Window_Height . 'split ' . wcmd
    endif

    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal noswapfile
    setlocal nowrap
    setlocal nobuflisted
    " Use fixed height for the MRU window
    setlocal winfixheight

    " Setup the cpoptions properly for the maps to work
    let old_cpoptions = &cpoptions
    set cpoptions&vim
    nnoremap <buffer> <silent> <CR>
                \ :call <SID>menu_action()<CR>
    " Restore the previous cpoptions settings
    let &cpoptions = old_cpoptions
    normal! gg

    let m = 'test'
    silent! 0put =m

    setlocal nomodifiable

endfunction

command! -nargs=0 Mn call s:menu_open_window()

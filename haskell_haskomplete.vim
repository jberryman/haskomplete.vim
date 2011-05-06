" haskomplete.vim - Simple haskell syntax auto-completion
" Author:       brandon.m.simmons@gmail.com
" Version:      0.1
"
" Usage:
"   Type "ctrl-h" in insert mode to autocomplete some syntax.
"
" Functionality:
"   Pressing the accelerator keys (by default "ctrl-h") in insert mode causes
"   some syntax to be filled in depending on the context.
"
"   In the following examples, on the left is what the user has just typed
"   with "^" or "#" representing where the cursor was when typing the accelator
"   key. To the right of the arrow is what the typed code would be converted to.
"
"   The "^" character means the cursor is in insert mode, "#" means normal mode
"   with cursor over the character that follows. When "^" is omitted on the left
"   hand side we are in insert mode with the cursor anywhere on that line.
"
"   
"
"   Insert mode completions
"   ------------------------
"       func                   --->   func :: ^
"                                     func = undefined
"
"       func ::                --->   func :: (^)=>
"
"       func :: Type           --->   func :: Type -> ^
"
"       func x y               --->   func x y = #undefined
"
"       func x y = foo x . bar y       --->   func x y = ^ . foo x . bar y
"
"       newtype Type a b       --->   newtype Type a b = Type #a b
"
"     When on first line:
"       {                      --->   {-# LANGUAGE ^ #-}   
"
"     When NOT on first line:
"       {                      --->   {- ^ 
"                                      -}
"
"
"   Normal mode completions
"   ------------------------
"
"       func :: Type -> #m a   --->   func :: (^ m)=> Type -> m a
"     or...
"       func :: (F f)=> f -> #m a   --->   func :: (F f, ^ m)=> f -> m a
"
"
"     When on first or second line:
"       #                      --->     module #Main
"                                           where
"                                                                    
"                                       main = do undefined
"
"
" -------------------------------------------------
" check out :help function-list
"

" define what a line of haskell terms looks like, e.g.:
"     foo, bar,baz,(***) 
let s:hfunc = '[a-z_]\+[a-z_0-9' . "'" . ']*'  
let s:hoper = '(\W\+)'
let s:hterm = '\(' . s:hfunc . '\|' . s:hoper . '\)'
let s:hterms = '^\(\s*\)' . s:hterm . '\s*' . '\(,\s*' . s:hterm . '\s*\)*$'


function! InsertModeCompletion()
    let curline_num = line('.')
    let curline = getline('.')
    
    " ------------------------------------------------------------------------
    " If there are only spaces, commas, and allowable haskell function
    " characters to our left, then insert undefined(s) and ready cursor for
    " entering type sig:
    if match(curline,s:hterms) >= 0
        " preserves trailing whitespace. may not want that:
        let pad = match(curline,'\s\+$') >= 0 ? '' : ' '
        " We have to jump to the end of the line
        call setline('.', curline . pad . ":: ")
        " if following line non empty, don't insert skeleton definitions:
        if match(getline(curline_num + 1),'^\s*$') >= 0
            " first string prefixed with indentation whitespace:
            let hterm_list = split(curline,'\s*,\s*')
            let ind = matchstr(hterm_list[0],'^\s\+')
            let skel_func_lines = map(hterm_list, 'ind . substitute(v:val,"\\s*","","g") . " = undefined"')
            " set the skeleton declarations into buffer:
            call append(curline_num, skel_func_lines)
        endif
        return "\<END>"
    endif

    " ------------------------------------------------------------------------
    "continue with more matches...

    "nothing matched:
    return ""
endfunction

" this is an ftplugin:
inoremap <silent> <C-H> <C-R>=InsertModeCompletion()<CR>
"nmap <silent> <C-H> <C-R>=NormalModeCompletion()<CR>



"" I don't know what cp is:
"if exists("g:loaded_haskomplete") || &cp
"  finish
"endif
"let g:loaded_haskomplete = 1
"
"" This may not be necessary:
"if has("autocmd")
"  augroup haskomplete
"    autocmd!
"    " Would be nice to support .lhs here too:
"    autocmd FileType hs    call s:Init()
"    if version >= 700
"      autocmd InsertLeave * call s:Leave()
"    endif
"    autocmd CursorHold * if exists("b:loaded_haskomplete") | call s:Leave() | endif
"  augroup END
"endif

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
"   with cursor over the character that follows.
"
"   
"
"   Type signatures / function declarations
"   ---------------------------------------
"       func^                  --->   func :: ^
"                                     func = undefined
"
"       func :: ^              --->   func :: (^)=>
"
"       func :: Type^          --->   func :: Type -> ^
"
"       func :: Type -> #m a   --->   func :: (^ m)=> Type -> m a
"     or...
"       func :: (F f)=> f -> #m a   --->   func :: (F f, ^ m)=> f -> m a
"
"
"       func x y^              --->   func x y = #undefined
"
"       func x y = foo x . bar y^      --->   func x y = ^ . foo x . bar y
"
"
"   Data Declarations
"   -----------------
"       newtype Type a b^  --->   newtype Type a b = Type #a b
"
"
"   Module Creation
"   ---------------
"       When on first or second line:
"       #                      --->     module #Main
"                                           where
"                                                                    
"                                       main = do undefined
"
"       When on first line:
"       {^                     --->     {-# LANGUAGE ^ #-}   
"
"
"   Comments
"   --------
"       When NOT on first line:
"       {^                    --->     {- ^ 
"                                       -}
"
" -------------------------------------------------
" check out :help function-list
"

function! InsertModeCompletion()
    let curline = line('.')
    
    " ------------------------------------------------------------------------
    " If there are only spaces, commas, and allowable haskell function
    " characters to our left, then insert undefined(s) and ready cursor for
    " entering type sig:
    let hfunc = '[a-z_]\+[a-z_0-9' . "'" . ']*'  
    let hoper = '(\W\+)'
    let hterm = '\(' . hfunc . '\|' . hoper . '\)'
    let hterms = '\(' . '\(^\|,\)\s*' . hterm . '\s*' . '\)\+' . '$'

    let [lnum, coln] = searchpos(hterms, 'nb', curline) "backwards on this line
    if lnum == curline
        " TODO: use another regex to get the indentation of declaration(s):
        return ":: " . "\<ESC>"
    endif

    "continue with more matches...

    "nothing matched:
    return ""
endfunction

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

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



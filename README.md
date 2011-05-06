A vim ftplugin for magical haskell code completions. 

I hope this becomes a collaborative project. Please send me pull requests with
improvements or new completions you would like to see.

Installation
============

Copy the .vim file to your vim installation's _ftplugin_ directory:

    mkdir -p ~/.vim/ftplugin/
    cp haskell_haskomplete.vim ~/.vim/ftplugin/

the functionality should automatically load when you open a haskell source code
file.

Usage
=====

In insert or normal modes, press <CTRL-H>. If your cursor is in a context that
has an assigned completion (see below) some magic completion action will occur.

Implemented Completions
=======================

Below the cursor in insert mode looks like ^, in normal mode it looks like #.
When the cursor is ommited on the left hand side, assume the cursor is in insert
mode anywhere on the line shown:

Insert mode
-----------

    func1, func2           --->   func1, func2 :: ^
                                  func1 = undefined
                                  func2 = undefined

Normal mode
-----------

    ...todo

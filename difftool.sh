#!/bin/sh
# diff is called by git with 7 parameters:
# path old-file old-hex old-mode new-file new-hex new-mode
"c:/Program Files (x86)/Beyond Compare 3/BCompare.exe" "$2" "$5" | cat

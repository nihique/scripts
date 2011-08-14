@echo off

set CWD=%CD%
set TARGETDIR=%USERPROFILE%

echo Deleting old symbolic links...
del "%TARGETDIR%\.gitconfig"
del "%TARGETDIR%\difftool.sh"
echo Done

echo Creating new symbolic links...
mklink "%TARGETDIR%\.gitconfig"  "%CWD%\.gitconfig"
mklink "%TARGETDIR%\difftool.sh"  "%CWD%\difftool.sh"
echo Done

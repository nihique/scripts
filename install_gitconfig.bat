@echo off

set CWD=%CD%
set TARGETDIR=%USERPROFILE%

echo Deleting old symbolic links...
del "%TARGETDIR%\.gitconfig"
echo Done

echo Creating new symbolic links...
mklink "%TARGETDIR%\.gitconfig"  "%CWD%\.gitconfig"
echo Done

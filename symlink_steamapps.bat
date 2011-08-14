@echo off

rem set CWD=%CD%
set CWD=e:\games\steamapps\common
set TARGETDIR=%ProgramFiles(x86)%\Steam\steamapps\common

echo Deleting old symbolic links...
del "%TARGETDIR%\eye"
del "%TARGETDIR%\oblivion"
del "%TARGETDIR%\oblivion - Copy"
del "%TARGETDIR%\runaway a road adventure"
del "%TARGETDIR%\the secret of monkey island special edition"
del "%TARGETDIR%\titan quest"
del "%TARGETDIR%\titan quest immortal throne"
echo Done

echo Creating new symbolic links...
mklink "%TARGETDIR%\eye"  "%CWD%\eye"
mklink "%TARGETDIR%\oblivion"  "%CWD%\oblivion"
mklink "%TARGETDIR%\oblivion - Copy"  "%CWD%\oblivion - Copy"
mklink "%TARGETDIR%\runaway a road adventure"  "%CWD%\runaway a road adventure"
mklink "%TARGETDIR%\the secret of monkey island special edition"  "%CWD%\the secret of monkey island special edition"
mklink "%TARGETDIR%\titan quest"  "%CWD%\titan quest"
mklink "%TARGETDIR%\titan quest immortal throne"  "%CWD%\titan quest immortal throne"
echo Done

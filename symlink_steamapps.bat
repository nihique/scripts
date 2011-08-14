@echo off

rem set CWD=%CD%
set CWD=e:\games\steamapps\common
set TARGETDIR=%ProgramFiles(x86)%\Steam\steamapps\common

echo Deleting old symbolic links...
rd "%TARGETDIR%\oblivion"
rd "%TARGETDIR%\oblivion - Copy"
rd "%TARGETDIR%\runaway a road adventure"
rd "%TARGETDIR%\the secret of monkey island special edition"
rd "%TARGETDIR%\titan quest"
rd "%TARGETDIR%\titan quest immortal throne"
echo Done

echo Creating new symbolic links...
mklink /D "%TARGETDIR%\oblivion"  "%CWD%\oblivion"
mklink /D "%TARGETDIR%\oblivion - Copy"  "%CWD%\oblivion - Copy"
mklink /D "%TARGETDIR%\runaway a road adventure"  "%CWD%\runaway a road adventure"
mklink /D "%TARGETDIR%\the secret of monkey island special edition"  "%CWD%\the secret of monkey island special edition"
mklink /D "%TARGETDIR%\titan quest"  "%CWD%\titan quest"
mklink /D "%TARGETDIR%\titan quest immortal throne"  "%CWD%\titan quest immortal throne"
echo Done

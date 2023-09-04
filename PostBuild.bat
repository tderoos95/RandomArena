@echo off
    setlocal enableextensions disabledelayedexpansion
        set "systemDir=%~dp0\..\System"
        call :resolve "%systemDir%" resolvedDir

        echo Copying %resolvedDir%\RandomArena.u to steam directory...
        echo Copying %resolvedDir%\RandomArena.ucl to steam directory...

        del "E:\SteamLibrary\steamapps\common\Unreal Tournament 2004\System\RandomArena.u"
        del "E:\SteamLibrary\steamapps\common\Unreal Tournament 2004\System\RandomArena.ucl"
        copy %resolvedDir%\RandomArena.u "E:\SteamLibrary\steamapps\common\Unreal Tournament 2004\System\RandomArena.u"
        copy %resolvedDir%\RandomArena.ucl "E:\SteamLibrary\steamapps\common\Unreal Tournament 2004\System\RandomArena.ucl"
    endlocal
    goto :EOF
:resolve file/folder returnVarName
    rem Set the second argument (variable name) 
    rem to the full path to the first argument (file/folder)
    set "%~2=%~f1"
    goto :EOF
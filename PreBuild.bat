@echo off
echo Emptying classes directory...
del /q /s /f .\classes\*.*
echo Flattening sourcecode...
uccmake --flattensource src
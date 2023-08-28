@REM Build script for testbed
@ECHO OFF
SetLocal EnableExtensions EnableDelayedExpansion

REM Check if we want to build in release and save it to a variable
IF "%1" EQU "release" ( SET isRelease=release) else ( SET isRelease=)


REM Get a list of all the .cpp files.
SET cppFilenames=
FOR /R %%f in (*.cpp) do (
    SET cppFilenames=!cppFilenames! %%f
)

SET assembly=testbed
SET compilerFlags=-std=c++20
IF DEFINED isRelease ( 
    SET compilerFlags=!compilerFlags! -O3
) else ( 
    SET compilerFlags=!compilerFlags! -g3
)
SET includeFlags=-Isrc -I../stowy_physics_engine/src/
SET linkerFlags=-L../bin/ -lstowy_physics_engine
SET defines=
IF DEFINED isRelease ( 
    SET defines=!defines! -DNDEBUG
) else (
    SET defines=!defines! -DDEBUG
)

IF DEFINED isRelease ( ECHO Building %assembly% in release...) else ( ECHO Building %assembly% in debug...)
clang++ %cppFilenames% %compilerFlags% -o ../bin/%assembly%.exe %defines% %includeFlags% %linkerFlags%

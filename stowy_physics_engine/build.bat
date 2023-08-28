@REM Build script for stowy physics engine
@ECHO OFF
SetLocal EnableExtensions EnableDelayedExpansion

REM Check if we want to build in release and save it to a variable
IF "%1" EQU "release" ( SET isRelease=release) else ( SET isRelease=)


REM Get a list of all the .cpp files.
SET cFilenames=
FOR /R %%f in (*.cpp) do (
    SET cFilenames=!cFilenames! %%f
)

SET assembly=stowy_physics_engine

SET compilerFlags=-std=c++20
IF DEFINED isRelease ( 
    SET compilerFlags=!compilerFlags! -O3
) else ( 
    SET compilerFlags=!compilerFlags! -g3
)

SET includeFlags=-Isrc
SET linkerFlags=-luser32 -shared

SET defines=
IF DEFINED isRelease ( 
    SET defines=!defines! -DNDEBUG
) else (
    SET defines=!defines! -DDEBUG
)

IF DEFINED isRelease ( ECHO Building %assembly% in release...) else ( ECHO Building %assembly% in debug...)
clang++ %cFilenames% %compilerFlags% -o ../bin/%assembly%.dll %defines% %includeFlags% %linkerFlags%

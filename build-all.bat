@ECHO OFF
REM Build Everything

ECHO Building everything...

if not exist bin mkdir bin

PUSHD stowy_physics_engine
CALL build.bat %1
POPD
IF %ERRORLEVEL% NEQ 0 (echo Error:%ERRORLEVEL% && exit)

PUSHD testbed
CALL build.bat %1
POPD
IF %ERRORLEVEL% NEQ 0 (echo Error:%ERRORLEVEL% && exit)

ECHO All assemblies built successfully.
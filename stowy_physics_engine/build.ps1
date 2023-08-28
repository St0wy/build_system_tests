# Build script for stowy physics engine

$sw = [Diagnostics.Stopwatch]::StartNew()

$isRelease = $false

# Check if we want to build in release and save it to a variable
if ($args[0] -eq "release") {
	$isRelease = $true
}

# Get a list of all the .cpp files.
$cppFilenames = Get-ChildItem -Recurse -Filter "*.cpp" | ForEach-Object { $_.FullName }

$assembly = "stowy_physics_engine"

$compilerFlags = "-std=c++20"
if ($isRelease) {
	$compilerFlags += " -O3"
}
else {
	$compilerFlags += " -g3"
}

$includeFlags = "-Isrc"
$linkerFlags = "-shared"

$defines = "-DSTWEXPORT"
if ($isRelease) {
	$defines += " -DNDEBUG"
}
else {
	$defines += " -DDEBUG"
}

if ($isRelease) {
	Write-Host "Building $assembly in release..."
}
else {
	Write-Host "Building $assembly in debug..."
}

$cppFiles = $cppFilenames -join " "
$buildCommand = "clang++ $cppFiles $compilerFlags -o ..\bin\$assembly.dll $defines $includeFlags $linkerFlags"
Invoke-Expression $buildCommand

$sw.Stop()
$time = $sw.Elapsed

Write-Host "Built $assembly in $time"
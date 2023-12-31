# Build script for stowy physics engine

source ../common.nu

def main [buildType: string = 'debug'] {
	let isRelease = $buildType == 'release'

	# Setup flags
	let compilerFlags = [ '-std=c++20' '-fPIC' (if $isRelease { '-O3' } else { '-g3' })]
	let includeFlags = ['-Isrc']
	let linkerFlags = ['-shared' ]
	# Gotta use this line with zig c++
	let linkerFlags = ['-shared' (if $nu.os-info.name == 'windows' { '-Wl,--out-implib,../bin/stowy_physics_engine.lib' }) ]
	let defines = ['-DSTWEXPORT' (if $isRelease { '-DNDEBUG'} else { '-DDEBUG' })]

	build stowy_physics_engine 'src/' '../bin/' $compilerFlags $includeFlags $linkerFlags $defines $buildType library 'zig c++'
}

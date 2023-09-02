# Build script for stowy physics engine

source ../common.nu

def main [buildType: string = 'debug'] {
	let isRelease = $buildType == 'release'

	# Setup flags
	let compilerFlags = [ '-std=c++20' (if $isRelease { '-O3' } else { '-g3' })]
	const includeFlags = ['-Isrc']
	const linkerFlags = ['-shared']
	let defines = ['-DSTWEXPORT' (if $isRelease { '-DNDEBUG'} else { '-DDEBUG' })]

	build stowy_physics_engine 'src/' '../bin/' $compilerFlags $includeFlags $linkerFlags $defines $buildType library clang++ sccache
}

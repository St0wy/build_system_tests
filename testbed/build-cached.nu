# Build script with caching for stowy physics engine

source ../common.nu

def main [buildType: string = 'debug'] {
	let isRelease = $buildType == 'release'

	# Setup flags
	let compilerFlags = [ '-std=c++20' (if $isRelease { '-O3' } else { '-g3' })]
	const includeFlags = ['-Isrc' '-I../stowy_physics_engine/src']
	const linkerFlags = ['-L../bin/' '-lstowy_physics_engine']
	let defines = [(if $isRelease { '-DNDEBUG'} else { '-DDEBUG' })]

	build testbed 'src/' '../bin/' $compilerFlags $includeFlags $linkerFlags $defines $buildType executable
}

# Build script with caching for stowy physics engine

source ../common.nu

def main [buildType: string = 'debug'] {
	let isRelease = $buildType == 'release'

	# Setup flags
	let compilerFlags = [ '-std=c++20' '-fPIC' (if $isRelease { '-O3' } else { '-g3' })]
	let includeFlags = ['-Isrc' '-I../stowy_physics_engine/src']
	mut linkerFlags = ['-L../bin/' '-lstowy_physics_engine' ]
	if $nu.os-info.name != 'windows' {
		$linkerFlags = ($linkerFlags | append [ '-Wl,-rpath,.' ])
	}
	
	let defines = [(if $isRelease { '-DNDEBUG'} else { '-DDEBUG' })]

	build testbed 'src/' '../bin/' $compilerFlags $includeFlags $linkerFlags $defines $buildType executable 'zig c++'
}

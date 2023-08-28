# Build script for stowy physics engine

def main [input?: string] {
	let start = date now
	let isRelease = $input == 'release';

	let cppFiles = glob **/*.cpp;

	const assembly = 'stowy_physics_engine'

	mut compilerFlags = [ '-std=c++20' ]
	if $isRelease {
		$compilerFlags | append '-O3'
	} else {
		$compilerFlags | append '-O3'
	}

	const includeFlags = ['-Isrc']
	const linkerFlags = ['-shared']

	mut defines = ['-DSTWEXPORT']
	if $isRelease {
		$defines | append '-DNDEBUG'
	} else {
		$defines | append '-DDEBUG'
	}

	if $isRelease {
		print $'Building ($assembly) in release...'
	} else {
		print $'Building ($assembly) in debug...'
	}

	clang++ $cppFiles $compilerFlags -o $'../bin/($assembly).dll' $defines $includeFlags $linkerFlags

	let end = date now
	let totalTime = $end - $start;
	print $'Built ($assembly) in ($totalTime)'
}

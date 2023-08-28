# Build script for stowy physics engine

def main [input?: string] {
	let start = date now
	let isRelease = $input == 'release';

	let cppFiles = glob **/*.cpp;

	const assembly = 'testbed'

	mut compilerFlags = [ '-std=c++20' ]
	if $isRelease {
		$compilerFlags | append '-O3'
	} else {
		$compilerFlags | append '-O3'
	}

	const includeFlags = ['-Isrc' '-I../stowy_physics_engine/src']
	const linkerFlags = ['-L../bin/' '-lstowy_physics_engine']

	mut defines: list<string> = []
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

	clang++ $cppFiles $compilerFlags -o $'../bin/($assembly).exe' $defines $includeFlags $linkerFlags

	let end = date now
	let totalTime = $end - $start;
	print $'Built ($assembly) in ($totalTime)'
}

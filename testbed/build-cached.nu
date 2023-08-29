# Build script for stowy physics engine

def main [input?: string] {
	let startTime = date now
	let isRelease = $input == 'release';

	const assembly = 'testbed'
	const sourceFolder = 'src/'
	const outputFolder = '../bin/'

	let assemblyOutput = $'($outputFolder)($assembly)' + if ($env.OS | str contains 'Windows') { '.exe' }

	let compilerFlags = [ '-std=c++20' (if $isRelease { '-O3' } else { '-g3' })]

	const includeFlags = ['-Isrc' '-I../stowy_physics_engine/src']
	const linkerFlags = ['-L../bin/' '-lstowy_physics_engine']

	let defines = [(if $isRelease { '-DNDEBUG'} else { '-DDEBUG' })]

	if $isRelease {
		print $'Building ($assembly) in release...'
	} else {
		print $'Building ($assembly) in debug...'
	}

	let cppFiles = glob **/*.cpp;
	let relativeCppFiles = ($cppFiles  | path relative-to $"($env.PWD)/($sourceFolder)" | path parse)

	let objectFiles = $relativeCppFiles | par-each {|relativeCppFile| (
		let inputFile = ($relativeCppFile | path join);
		let outputFile = ($relativeCppFile | update extension 'o' | path join);
		let inputFolder = ($relativeCppFile | get parent);
		mkdir ($'($outputFolder)($inputFolder)');
		let outputFileWithDir = $'($outputFolder)($outputFile)';
		# print $inputFile;
		print $'Building ($outputFileWithDir)...';
		sccache clang++ -c -o $outputFileWithDir $'($sourceFolder)($inputFile)' $defines $includeFlags $compilerFlags;
		$outputFileWithDir
	)}
	let endBuild = date now
	let totalBuildTime = $endBuild - $startTime

	print $'Built objects in ($totalBuildTime)'

	let startTime = date now
	print 'Linking...'
	sccache clang++ -o $assemblyOutput $objectFiles $linkerFlags $includeFlags $defines $compilerFlags

	let endTime = date now
	let totalLinkTime = $endTime - $startTime;
	print $'Linked in ($totalLinkTime)'
	let totalTime = $totalBuildTime + $totalLinkTime
	print $'Built and linked ($assembly) in ($totalTime)'
}

# Builds the assembly according to the parameters
def build [
	assemblyName: string,
	sourceDirectory: path,
	binaryDirectory: path,
	compilerFlags: list<string>,
	includeFlags: list<string>,
	linkerFlags: list<string>,
	defines: list<string>,
	buildType: string = 'debug', # The optimisation level of the build. Can be 'release' or 'debug'.
	targetType: string = 'executable', # The type of target. Can be 'executable' or 'library'.
	compiler: string = 'clang++'
	cacheTool?: string
] {
	let startTime = date now
	let isRelease = $buildType == 'release'
	# We need to split the compiler to handle cases such as "zig c++" because run-external doesn't like spaces
	let splitCompiler = ($compiler | split row ' ')

	let assemblyExtension = if $targetType == 'executable' {
		if $nu.os-info.name == 'windows' { '.exe' } else { '' }
	} else if $targetType == 'library' {
		if $nu.os-info.name == 'windows' { '.dll' } else { '.so' }
	} else {
		return 'Invalid targetType'
	}

	let assemblyOutputFile = ($'($binaryDirectory)/($assemblyName)($assemblyExtension)' | path split | path join)

	print $'Building ($assemblyName) in ($buildType)...'

	let cppFiles = glob **/*.cpp

	let relativeCppFiles = ($cppFiles  | path relative-to $sourceDirectory | path parse)

	print -n $'(ansi grey)'
	# Build every .cpp to .o and get a list of every .o
	let objectFiles = $relativeCppFiles | par-each {|relativeCppFile| (
		# Convert from path object to string
		let inputFile = ($relativeCppFile | path join);
		let outputFile = ($relativeCppFile | upsert extension 'o' | path join);

		# Recreate the folder structure of .cpp files for the .o in the binary directory
		let inputDirectory = ($relativeCppFile | get parent);
		mkdir ($'($binaryDirectory)/($inputDirectory)');

		# concatenate the .o file with the bin directory
		let outputFileWithDir = ($'($binaryDirectory)/($outputFile)' | path split | path join);
		let sourceFileWithDir = ($'($sourceDirectory)($inputFile)' | path split | path join);
		
		print $'Building ($relativeCppFile | get stem)...';
		
		if $cacheTool != null {
			run-external $cacheTool $compiler '-c' '-o' $outputFileWithDir $sourceFileWithDir $defines $includeFlags $compilerFlags
		} else {
			run-external $splitCompiler.0 ($splitCompiler | range 1..) '-c' '-o' $outputFileWithDir $sourceFileWithDir $defines $includeFlags $compilerFlags
		};
		let clangExitCode = $env.LAST_EXIT_CODE;

		if $clangExitCode != 0 {
			print $'(ansi red)Failed to build ($relativeCppFile | get stem)(ansi reset)'
			exit $clangExitCode
		};

		$outputFileWithDir
	)}
	print -n $'(ansi reset)'

	# Print building time
	let endTime = date now
	let totalBuildTime = $endTime - $startTime
	print $'Built objects in ($totalBuildTime)'

	let startTime = date now

	print 'Linking...'
	run-external $splitCompiler.0 ($splitCompiler | range 1..) '-o' $assemblyOutputFile $objectFiles $linkerFlags $includeFlags $defines $compilerFlags

	let clangExitCode = $env.LAST_EXIT_CODE;
	if $clangExitCode != 0 {
		print $'(ansi red)Failed to link ($assemblyName)(ansi reset)'
		exit $clangExitCode
	};

	# Print link time and total time
	let endTime = date now
	let totalLinkTime = $endTime - $startTime;
	print $'Linked in ($totalLinkTime)'
	let totalTime = $totalBuildTime + $totalLinkTime
	
	print $'(ansi green)Built and linked ($assemblyName) in ($totalTime) successfully.(ansi reset)'
}
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

	let assemblyExtension = if $targetType == 'executable' {
		if ($env.OS | str contains 'Windows') { '.exe' } else { '' }
	} else if $targetType == 'library' {
		if ($env.OS | str contains 'Windows') { '.dll' } else { '.so' }
	} else {
		return 'Invalid targetType'
	}

	let assemblyOutputFile = ($'($binaryDirectory)/($assemblyName)($assemblyExtension)' | path split | path join)

	print $'Building ($assemblyName) in ($buildType)...'

	let cppFiles = glob **/*.cpp

	let relativeCppFiles = ($cppFiles  | path relative-to $sourceDirectory | path parse)

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

		print $'Building ($outputFileWithDir)...';
		if $cacheTool != null {
			run-external --redirect-combine $cacheTool $compiler '-c' '-o' $outputFileWithDir $sourceFileWithDir $defines $includeFlags $compilerFlags;
		} else {
			run-external --redirect-combine $compiler '-c' '-o' $outputFileWithDir $sourceFileWithDir $defines $includeFlags $compilerFlags;
		};
		$outputFileWithDir
	)}

	# Print building time
	let endTime = date now
	let totalBuildTime = $endTime - $startTime
	print $'Built objects in ($totalBuildTime)'

	let startTime = date now

	print 'Linking...'
	run-external --redirect-combine $compiler '-o' $assemblyOutputFile $objectFiles $linkerFlags $includeFlags $defines $compilerFlags

	# Print link time and total time
	let endTime = date now
	let totalLinkTime = $endTime - $startTime;
	print $'Linked in ($totalLinkTime)'
	let totalTime = $totalBuildTime + $totalLinkTime
	
	print $'(ansi green)Built and linked ($assemblyName) in ($totalTime) successfully.(ansi reset)'
}
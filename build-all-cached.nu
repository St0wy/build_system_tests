def main [input: string =  'debug'] {
	let startTime = date now
	print 'Building everything...'

	mkdir bin

	cd stowy_physics_engine
	nu build-cached.nu $input

	let libBuildCode = $env.LAST_EXIT_CODE
	if $libBuildCode != 0 {
		print Error : $libBuildCode
		exit $libBuildCode
	}

	cd ..

	cd testbed
	nu build-cached.nu $input

	let testbedBuildCode = $env.LAST_EXIT_CODE
	if $testbedBuildCode != 0 {
		print Error : $testbedBuildCode
		exit $testbedBuildCode
	}

	let endTime = date now
	let totalTime = $endTime - $startTime
	print $'(ansi green)All assemblies built successfully in ($totalTime).(ansi reset)'
}

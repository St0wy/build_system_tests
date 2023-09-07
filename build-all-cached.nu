def main [input: string =  'debug'] {
	let startTime = date now
	print 'Building everything...'

	mkdir bin

	cd stowy_physics_engine
	nu build-cached.nu $input

	cd ..

	cd testbed
	nu build-cached.nu $input

	let endTime = date now
	let totalTime = $endTime - $startTime
	print $'(ansi green)All assemblies built successfully in ($totalTime).(ansi reset)'
}

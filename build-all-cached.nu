def main [input?: string] {
	let startTime = date now
	print 'Building everything...'

	mkdir bin

	cd stowy_physics_engine
	nu build-cached.nu $'($input)'

	if $env.LAST_EXIT_CODE != 0 {
		print Error : $env.LAST_EXIT_CODE
		return $env.LAST_EXIT_CODE
	}

	cd ..

	cd testbed
	nu build-cached.nu $'($input)'

	if $env.LAST_EXIT_CODE != 0 {
		print Error : $env.LAST_EXIT_CODE
		return $env.LAST_EXIT_CODE
	}

	let endTime = date now
	let totalTime = $endTime - $startTime
	print $'(ansi green)All assemblies built successfully in ($totalTime).(ansi reset)'
}

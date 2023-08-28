def main [input?: string] {
	print 'Building everything...'

	mkdir bin

	cd stowy_physics_engine
	nu build.nu $'($input)'

	if $env.LAST_EXIT_CODE != 0 {
		print Error : $env.LAST_EXIT_CODE
		return $env.LAST_EXIT_CODE
	}

	cd ..

	cd testbed
	nu build.nu $'($input)'

	if $env.LAST_EXIT_CODE != 0 {
		print Error : $env.LAST_EXIT_CODE
		return $env.LAST_EXIT_CODE
	}

	print 'All assemblies built successfully.'
}


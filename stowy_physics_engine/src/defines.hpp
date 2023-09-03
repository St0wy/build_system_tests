#pragma once

// TODO : test this with other compilers and on linux
#ifndef STWCMAKE
	#ifdef STWEXPORT
		// Exports
		#define STWAPI __declspec(dllexport)
	#else
		// Imports
		#define STWAPI __declspec(dllimport)
	#endif
#else
	#define STWAPI
#endif
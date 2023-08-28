#pragma once

#ifndef STWCMAKE
	#ifdef STWEXPORT
		// Exports
		#ifdef _MSC_VER
			#define STWAPI __declspec(dllexport)
		#else
			#define STWAPI __attribute__((visibility("default")))
		#endif
	#else
		// Imports
		#ifdef _MSC_VER
			#define STWAPI __declspec(dllimport)
		#else
			#define STWAPI
		#endif
	#endif
#else
	#define STWAPI
#endif
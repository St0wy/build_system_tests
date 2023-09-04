#pragma once

#if defined(WIN32) || defined(_WIN32) || defined(__WIN32)
	#define STWPLATFORM_WINDOWS 1
	#ifndef _WIN64
		#error "64-bit is required on Windows !"
	#endif
#endif

#ifndef STWCMAKE
	#ifdef STWEXPORT
		// Exports
		#ifdef STWPLATFORM_WINDOWS
			#define STWAPI __declspec(dllexport)
		#else
			#define STWAPI __attribute__((visibility("default")))
		#endif
	#else
		// Imports
		#ifdef STWPLATFORM_WINDOWS
			#define STWAPI __declspec(dllimport)
		#else
			#define STWAPI
		#endif
	#endif
#else
	#define STWAPI
#endif

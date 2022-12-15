//#define LOWMEMORYMODE //uncomment this to load centcom and runtime station and thats it.

#include "endpoint.dmm"

#ifndef LOWMEMORYMODE
	#ifdef ALL_MAPS
		#include "mining\lavaland.dmm"
		#include "stations\boxstation.dmm"
		#include "stations\blueshift.dmm"
		#include "stations\construction.dmm"
		#include "stations\dawn.dmm"
		#include "stations\delta.dmm"
		#include "stations\kilo.dmm"
		#include "stations\meta.dmm"
		#include "stations\null.dmm"
		#include "stations\tram.dmm"
		#ifdef CIBUILDING
			#include "templates.dm"
		#endif
	#endif
#endif

//#define LOWMEMORYMODE //uncomment this to load centcom and runtime station and thats it.

#include "map_files\protocol_c\endpoint.dmm"

#ifndef LOWMEMORYMODE
	#ifdef ALL_MAPS
		#include "map_files\Mining\Lavaland.dmm"
		#include "map_files\BoxStation\BoxStationWhite.dmm"
		#include "map_files\BoxStation\BoxStationWhite_under.dmm"
		#ifdef CIBUILDING
			#include "templates.dm"
		#endif
	#endif
#endif

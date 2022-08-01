//#define LOWMEMORYMODE //uncomment this to load centcom and runtime station and thats it.

#include "map_files\protocol_c\endpoint.dmm"

#ifndef LOWMEMORYMODE
	#ifdef ALL_MAPS
		#include "map_files\Mining\Lavaland.dmm"
		#include "map_files\BoxStation\BoxStationWhite.dmm"
		#include "map_files\Bashenka\Bashenka.dmm"
		#include "map_files\Blueshift\BlueShift_lower.dmm"
		#include "map_files\Blueshift\BlueShift_middle.dmm"
		#include "map_files\Blueshift\BlueShift_upper.dmm"
		#include "map_files\Box\Box.dmm"
		#include "map_files\Coldstone\Coldstone.dmm"
		#include "map_files\ConstructionStation\ConstructionStation.dmm"
		#include "map_files\CrashSite\CrashSite.dmm"
		#include "map_files\Dawn\dawn.dmm"
		#include "map_files\Deltastation\DeltaStation2.dmm"
		#include "map_files\KiloStation\KiloStation.dmm"
		#include "map_files\MetaStation\MetaStationWhite.dmm"
		#include "map_files\Null\Null.dmm"
		#include "map_files\Prison\Prison.dmm"
		#ifdef CIBUILDING
			#include "templates.dm"
		#endif
	#endif
#endif

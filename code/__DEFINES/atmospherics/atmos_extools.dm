GLOBAL_VAR(atmos_extools_initialized) // this must be an uninitialized (null) one or init_monstermos will be called twice because reasons
#define ATMOS_EXTOOLS_CHECK if(!GLOB.atmos_extools_initialized){\
	GLOB.atmos_extools_initialized=TRUE;\
	if(fexists(EXTOOLS)){\
		var/result = call(EXTOOLS,"init_monstermos")();\
		if(result != "ok") {CRASH(result);}\
	} else {\
		CRASH("byond-extools.dll does not exist!");\
	}\
}

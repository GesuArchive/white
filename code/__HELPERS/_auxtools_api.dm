//#define EXTOOLS_LOGGING // rust_g is used as a fallback if this is undefined

/proc/extools_log_write()

/proc/extools_finalize_logging()

#define AUXTOOLS_FULL_INIT 2
#define AUXTOOLS_PARTIAL_INIT 1

//this exists because gases may be created when the MC doesn't exist yet
GLOBAL_REAL_VAR(list/__auxtools_initialized)

#define AUXTOOLS_CHECK(LIB)\
	if (!islist(__auxtools_initialized)) {\
		__auxtools_initialized = list();\
	}\
	if (!__auxtools_initialized[LIB] != AUXTOOLS_FULL_INIT) {\
		if (fexists(LIB)) {\
			var/string = LIBCALL(LIB,"auxtools_init")();\
			if(findtext(string, "SUCCESS")) {\
				__auxtools_initialized[LIB] = AUXTOOLS_FULL_INIT;\
			} else {\
				CRASH(string);\
			}\
		} else {\
			CRASH("No file named [LIB] found!")\
		}\
	}\

#define AUXTOOLS_SHUTDOWN(LIB)\
	if (__auxtools_initialized[LIB] && fexists(LIB)){\
		LIBCALL(LIB,"auxtools_shutdown")();\
		__auxtools_initialized[LIB] = FALSE;\
	}\

#define AUXTOOLS_FULL_SHUTDOWN(LIB)\
	if (__auxtools_initialized[LIB] && fexists(LIB)){\
		LIBCALL(LIB,"auxtools_full_shutdown")();\
		__auxtools_initialized[LIB] = FALSE;\
	}\

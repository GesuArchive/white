/// Attempt to get the turf below the provided one according to Z traits
#define GET_TURF_BELOW(turf) ((!(turf) || !length(SSmapping.multiz_levels) || !SSmapping.multiz_levels[(turf).z]["16"]) ? null : get_step((turf), DOWN))
/// Attempt to get the turf above the provided one according to Z traits
#define GET_TURF_ABOVE(turf) ((!(turf) || !length(SSmapping.multiz_levels) || !SSmapping.multiz_levels[(turf).z]["32"]) ? null : get_step((turf), UP))

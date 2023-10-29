/datum/component/bloodshed_precursor

/datum/component/bloodshed_precursor/Initialize(mapload)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

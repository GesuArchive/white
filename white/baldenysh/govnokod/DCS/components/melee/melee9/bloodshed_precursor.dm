/datum/component/bloodshed_precursor

/datum/component/bloodshed_precursor/Initialize()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

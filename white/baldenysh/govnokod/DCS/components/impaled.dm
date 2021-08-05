/datum/component/impaled
	var/obj/impaled_by
	var/turf/impaled_to

/datum/component/impaled/Initialize(obj/imp_by, turf/imp_to)
	if(!iscarbon(parent))
		return COMPONENT_INCOMPATIBLE
	impaled_by = imp_by
	impaled_to = imp_to

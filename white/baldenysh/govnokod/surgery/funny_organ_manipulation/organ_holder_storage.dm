/datum/component/storage/concrete/multicompartment/organ_holder
	max_items = 20
	max_w_class = WEIGHT_CLASS_NORMAL
	max_combined_w_class = 50
	rustle_sound = FALSE
	silent = TRUE

/datum/component/storage/concrete/multicompartment/organ_holder/Initialize()
	. = ..()
	init_compartment(BODY_ZONE_HEAD, 3, WEIGHT_CLASS_SMALL, 6)
	init_compartment(BODY_ZONE_PRECISE_EYES, 1, WEIGHT_CLASS_SMALL, 2)
	init_compartment(BODY_ZONE_PRECISE_MOUTH, 1, WEIGHT_CLASS_SMALL, 2)
	init_compartment(BODY_ZONE_CHEST, 9, WEIGHT_CLASS_NORMAL, 20)
	init_compartment(BODY_ZONE_PRECISE_GROIN, 6, WEIGHT_CLASS_NORMAL, 15)

/datum/component/storage/concrete/multicompartment/organ_holder/canreach_react(datum/source, list/next)
	. = ..()
	var/atom/A = parent
	if(ismob(A.loc))
		next += A.loc

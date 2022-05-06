//мб лишняя хрень, а мб так и надо было делать, похуй короче прикольный костыль уменьшает еблю с компонентом сторейжа
/atom/movable/organ_holder
	name = ""

/atom/movable/organ_holder/Initialize(mapload)
	. = ..()
	verbs.Cut()
	AddComponent(/datum/component/storage/concrete/multicompartment/organ_holder)

/atom/movable/organ_holder/proc/RegisterWithMob(mob/living/carbon/C)
	RegisterSignal(C, COMSIG_CARBON_GAIN_ORGAN, .proc/on_organ_gain)
	//RegisterSignal(C, COMSIG_CARBON_GAIN_ORGAN, .proc/on_organ_loss)
	var/datum/component/storage/concrete/multicompartment/organ_holder/MULSTR = GetComponent(/datum/component/storage/concrete/multicompartment/organ_holder)
	for(var/obj/item/organ/O in C.internal_organs)
		MULSTR.try_insert_into_compartment(O, O.zone)

/atom/movable/organ_holder/proc/on_organ_gain(mob/living/carbon/C, obj/item/organ/O)
	SIGNAL_HANDLER
	var/datum/component/storage/concrete/multicompartment/organ_holder/MULSTR = GetComponent(/datum/component/storage/concrete/multicompartment/organ_holder)
	MULSTR.try_insert_into_compartment(O, O.zone)

/*
/atom/movable/organ_holder/proc/on_organ_loss(mob/living/carbon/C, obj/item/organ/O)
	SIGNAL_HANDLER
*/

/atom/movable/organ_holder/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	if(isorgan(arrived))
		arrived.AddElement(/datum/element/organ_holder_organ)

/atom/movable/organ_holder/Exited(atom/movable/gone, direction)
	. = ..()
	if(isorgan(gone))
		gone.RemoveElement(/datum/element/organ_holder_organ)

/atom/movable/organ_holder/ex_act(severity)
	return FALSE
/atom/movable/organ_holder/singularity_act()
	return
/atom/movable/organ_holder/singularity_pull()
	return
/atom/movable/organ_holder/blob_act()
	return
/atom/movable/organ_holder/on_changed_z_level(turf/old_turf, turf/new_turf)
	return
/atom/movable/organ_holder/forceMove(atom/destination)
	return

/mob/living/carbon/proc/test_organ_holder()
	var/atom/movable/organ_holder/OH = new(src)
	OH.RegisterWithMob(src)

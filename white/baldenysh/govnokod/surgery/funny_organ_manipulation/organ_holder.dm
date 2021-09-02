//мб лишняя хрень, а мб так и надо было делать, похуй короче прикольный костыль уменьшает еблю с компонентом сторейжа
/atom/movable/organ_holder
	name = ""
	var/list/contents_by_zone = list()

/atom/movable/organ_holder/proc/RegisterWithMob(mob/living/carbon/C)
	for(var/obj/item/organ/O in C.internal_organs)
		LAZYADD(contents_by_zone[O.zone], O)
		O.loc = src

/atom/movable/organ_holder/Initialize(mapload)
	. = ..()
	verbs.Cut()
	AddComponent(/datum/component/storage/concrete/organ_holder)

/atom/movable/organ_holder/proc/GetZoneContents(zone)
	return contents & contents_by_zone[zone]

/atom/movable/organ_holder/ex_act(severity)
	return FALSE
/atom/movable/organ_holder/singularity_act()
	return
/atom/movable/organ_holder/singularity_pull()
	return
/atom/movable/organ_holder/blob_act()
	return
/atom/movable/organ_holder/onTransitZ()
	return
/atom/movable/organ_holder/forceMove(atom/destination)
	return

/mob/living/carbon/proc/test_organ_holder()
	var/atom/movable/organ_holder/OH = new(src)
	OH.RegisterWithMob(src)

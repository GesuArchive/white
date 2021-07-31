//GLOBAL_VAR_INIT(detnumoftheday, hex2num(copytext(md5(time2text(world.realtime, "MMM DD YYYY")), 1, 7)))

/mob/proc/make_possess_obj(obj/O)
	loc = O
	reset_perspective(O)
	control_object = O

/atom/proc/make_aneme_mimic()
	var/mob/living/simple_animal/hostile/mimic/copy/C = new(drop_location(), src)
	C.cut_overlay(C.googly_eyes)
	C.add_overlay(mutable_appearance('white/baldenysh/icons/mob/aneme.dmi', "chaika_eyes"))
	return C

/mob/living/carbon/proc/spawn_and_insert_organ(organpathtxt)
	var/path = text2path(organpathtxt)
	if(!(path in subtypesof(/obj/item/organ)))
		return
	var/obj/item/organ/organ = new path()
	organ.Insert(src)


//find_obstruction_free_location тока в профиль
/area/proc/get_unobstructed_turfs()
	var/list/turf/unobstructed = list()
	for(var/turf/T in contents)
		var/contains_dense = FALSE
		for(var/atom/A in T.contents)
			if(A.density)
				contains_dense = TRUE
				break
		if(!contains_dense)
			unobstructed.Add(T)
			break
	return unobstructed

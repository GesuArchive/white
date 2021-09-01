//редфокс красный лис четыре фашист
/datum/mind/proc/is_artist()
	for(var/obj/effect/mob_spawn/human/artist/S)
		if(current in S.spawned_mobs)
			return TRUE

/datum/mind/proc/get_artist()
	for(var/datum/mind/M)
		if(!M.active)
			continue
		if(!M.current)
			continue
		if(M.key != key)
			continue
		if(M.is_artist())
			return M.current

//переписанный прок из невайтовского файла артисты сосать
/datum/mind/proc/grab_ghost(force)
	var/mob/dead/observer/G = get_ghost(even_if_they_cant_reenter = force)
	if(!G)
		var/mob/living/L = get_artist()
		if(L)
			G = L.ghostize()
			L.gib()
	. = G
	if(G)
		G.reenter_corpse()

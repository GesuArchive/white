//редфокс красный лис четыре фашист
/datum/mind/proc/is_artist()
	for(var/obj/effect/mob_spawn/human/donate/artist/S)
		if(current in S.spawned_mobs)
			return TRUE
		//надо штоб еще гостов артистов закидывало

/datum/mind/proc/get_artist_mob()
	for(var/datum/mind/M)
		if(!M.active)
			continue
		if(!M.current)
			continue
		if(lowertext(M.key) != lowertext(key)) //оно разное каковата хуя может быть у заспавненных спавнером и станционных
			continue
		if(M.is_artist())
			return M.current

//переписанный прок из невайтовского файла артисты сосать
/datum/mind/proc/grab_ghost(force)
	var/mob/dead/observer/G = get_ghost(even_if_they_cant_reenter = force)
	if(!G)
		var/mob/M = get_artist_mob()
		if(M)
			if(isobserver(M))
				G = M
			else if(isliving(M))
				M.visible_message(span_danger("[M] отправляется обратно куда-то в даль загадочно.........................."), span_danger("Отправляюсь обратно..."))
				G = M.ghostize(FALSE)
			current.client = G.client
	. = G
	if(G)
		G.reenter_corpse()

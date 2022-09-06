/obj/item/grenade/c4/miningcharge
	name = "шахтёрский заряд"
	desc = "Используется для создания больших отверстий в камнях. Работает только на камнях!"
	icon_state = "mining-charge"
	det_time = 5 //uses real world seconds cause screw you i guess
	boom_sizes = list(1,3,5)
	alert_admins = FALSE

/obj/item/grenade/c4/miningcharge/Initialize(mapload)
	. = ..()
	plastic_overlay = mutable_appearance(icon, "[icon_state]_active", ON_EDGED_TURF_LAYER)

/obj/item/grenade/c4/miningcharge/afterattack(atom/movable/AM, mob/user, flag, notify_ghosts = FALSE)
	if(ismineralturf(AM))
		..()
	else
		to_chat(user, span_warning("Работает только на камнях!"))

/obj/item/grenade/c4/miningcharge/detonate(mob/living/lanced_by)
	var/turf/closed/mineral/location = get_turf(target)
	location.attempt_drill(null,TRUE,3) //orange says it doesnt include the actual middle
	for(var/turf/closed/mineral/rock in circle_range_turfs(location,boom_sizes[3]))
		var/distance = get_dist_euclidian(location,rock)
		if(distance <= boom_sizes[1])
			rock.attempt_drill(null,TRUE,3)
		else if (distance <= boom_sizes[2])
			rock.attempt_drill(null,TRUE,2)
		else if (distance <= boom_sizes[3])
			rock.attempt_drill(null,TRUE,1)
	for(var/mob/living/carbon/C in circle_range(location,boom_sizes[3]))
		if(ishuman(C) && C.soundbang_act(1, 0))
			to_chat(C, span_userdanger("Взрыв отбрасывает меня!"))
			var/distance = get_dist_euclidian(location,C)
			C.Knockdown((boom_sizes[3] - distance) * 1 SECONDS) //1 second for how close you are to center if you're in range
			C.soundbang_act(1, (boom_sizes[3] - distance) * 5, (boom_sizes[3] - distance), (boom_sizes[3] - distance)) //5 ear damage for every tile you're closer to the center
	qdel(src)


/obj/item/grenade/c4/miningcharge/deconstruct(disassembled = TRUE) //no gibbing a miner with pda bombs
	if(!QDELETED(src))
		qdel(src)

/datum/orbital_objective/headhunt
	name = "Охота за головами"
	var/generated = FALSE
	var/objective_z_level
	var/mob/living/mob_to_recover
	min_payout = 20 * CARGO_CRATE_VALUE
	max_payout = 50 * CARGO_CRATE_VALUE

/datum/orbital_objective/headhunt/get_text()
	return "Требуется ликвидировать опасного преступника, скрывающегося на [station_name]. \
			Живым или мертвым, его необходимо доставить на мостик и отправить к вашему нанимателю с помощью предоставленной системы доставки. \
			Следует принять во внимание, что преступник может быть экипирован гораздо лучше обычного рейнджера. \
			Возможно, может потребоваться помощь сотрудников службы безопасности. \
			Задание будет провалено в случае побега преступника со станции или уничтожения его тела!"

/datum/orbital_objective/headhunt/on_assign(obj/machinery/computer/objective/objective_computer)
	var/area/A = GLOB.areas_by_type[/area/bridge]
	//var/obj/machinery/atmospherics/components/unary/infactiveseenhimvent = locate() in shuffle(A.contents)
	var/turf/open/T = pick(A.get_unobstructed_turfs())
	if(!T)
		T = locate() in shuffle(A.contents)
	var/obj/structure/closet/supplypod/extractionpod/empty_pod = new()
	empty_pod.name = "орбитальная система доставки Nanotrasen"
	empty_pod.desc = "Сюда сувать того самого преступника с [station_name]. Пожалуйста, игнорируйте символику синдиката, это трофейный под со Второй Космической."
	//empty_pod.style = STYLE_CENTCOM //хуета имеет всего три кликабельных пикселя, да и синдикатовский спрайт впринципе тоже в этом плане говнище

	new /obj/effect/pod_landingzone(T, empty_pod)

	RegisterSignal(empty_pod, COMSIG_ATOM_ENTERED, .proc/enter_check)

	empty_pod.stay_after_drop = TRUE
	empty_pod.reversing = TRUE
	empty_pod.explosionSize = list(0,0,0,1)
	empty_pod.leavingSound = 'sound/effects/podwoosh.ogg'

/datum/orbital_objective/headhunt/proc/enter_check(datum/source, entered_mob)
	if(!istype(source, /obj/structure/closet/supplypod/extractionpod))
		return
	if(!isliving(entered_mob))
		return
	if(entered_mob != mob_to_recover)
		return
	var/mob/living/M = entered_mob
	if (iscarbon(M))
		for(var/obj/item/W in M)
			if (ishuman(M))
				var/mob/living/carbon/human/H = M
				if(W == H.w_uniform)
					continue
				if(W == H.shoes)
					continue
			M.dropItemToGround(W)

	var/obj/structure/closet/supplypod/extractionpod/pod = source
	pod.startExitSequence(pod)
	complete_objective()

/datum/orbital_objective/headhunt/generate_objective_stuff(turf/chosen_turf)
	var/mob/living/carbon/human/created_human = new(chosen_turf)
	objective_z_level = created_human.z
	created_human.ice_cream_mob = TRUE
	ADD_TRAIT(created_human, TRAIT_CLIENT_LEAVED, "ice_cream")
	notify_ghosts("Цель охоты за головами может быть занята.", source = created_human, action = NOTIFY_ORBIT, flashwindow = FALSE, ignore_key = POLL_IGNORE_SPLITPERSONALITY, notify_suiciders = FALSE)
	created_human.AddElement(/datum/element/point_of_interest)
	created_human.mind_initialize()
	mob_to_recover = created_human

	for(var/mob/living/simple_animal/hostile/SA in range(10, created_human))
		qdel(SA)
	var/turf/open/T = locate() in shuffle(view(1, created_human))
	if(T)
		new /obj/item/clothing/suit/space/hardsuit/ancient(T)
		new /obj/item/tank/internals/oxygen(T)
		new /obj/item/clothing/mask/gas(T)
		new /obj/item/storage/belt/utility/full(T)

	switch(pickweight(list("dreamer" = 1, "heretic" = 5)))
		if("dreamer")
			created_human.equipOutfit(/datum/outfit/dreamer)

			created_human.mind.store_memory("И вот, после долгих скитаний по заброшенным станциям, подходящее место с порталом наконец найдено. \
				Чудом удалось оторваться от прошлой группы охотников, но новая наверняка не заставит себя ждать. \
				Нужно как можно быстрее активировать портал на Лаваленд и убить мою цель. Риск несомненно велик, но награда еще больше!")

			created_human.mind.add_antag_datum(/datum/antagonist/dreamer_orbital)
			created_human.mind.set_level(/datum/skill/gaming, SKILL_LEVEL_LEGENDARY, TRUE)
			ADD_TRAIT(created_human, TRAIT_NOSOFTCRIT, "gaming")
			ADD_TRAIT(created_human, TRAIT_FREERUNNING, "gaming")
			place_portal()

		if("heretic")
			created_human.equipOutfit(/datum/outfit/heretic_orbital)
			created_human.mind.add_antag_datum(/datum/antagonist/heretic)

	generated = TRUE

/datum/orbital_objective/headhunt/check_failed()
	if(generated)
		if(!mob_to_recover || QDELETED(mob_to_recover))
			return TRUE
		if(mob_to_recover.z != objective_z_level)
			return TRUE
		/*
		switch(target_type)
			if("dreamer")
				var/datum/antagonist/dreamer_orbital/DO = locate() in mob_to_recover.mind.antag_datums
				var/datum/objective/slay/S = locate() in DO.objectives
				if(S.completed)
					return TRUE
		*/
	return FALSE

/datum/orbital_objective/headhunt/proc/place_portal()
	if(!mob_to_recover)
		return
	var/list/turf/possible_turfs = list()
	for(var/obj/machinery/door/airlock/AL in world)
		if(AL.z != mob_to_recover.z)
			continue
		var/turf/western_turf = locate(AL.x-1, AL.y, AL.z)
		if(isopenturf(western_turf))
			possible_turfs.Add(get_turf(AL))

	var/turf/place_target
	if(!possible_turfs.len)
		place_target = get_turf(mob_to_recover)
	else
		place_target = pick(possible_turfs)

	var/datum/map_template/lavaportal/LP = new()
	LP.load(locate(place_target.x - LP.width + 1, place_target.y - LP.height/2 + 1, place_target.z))

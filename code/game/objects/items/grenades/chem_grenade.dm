/obj/item/grenade/chem_grenade
	name = "Химическая граната"
	desc = "Каркас химической гранаты."
	icon_state = "chemg"
	inhand_icon_state = "flashbang"
	w_class = WEIGHT_CLASS_SMALL
	force = 2
	var/stage = GRENADE_EMPTY
	var/list/obj/item/reagent_containers/glass/beakers = list()
	var/list/allowed_containers = list(/obj/item/reagent_containers/glass/beaker, /obj/item/reagent_containers/glass/bottle)
	var/list/banned_containers = list(/obj/item/reagent_containers/glass/beaker/bluespace) //Containers to exclude from specific grenade subtypes
	var/affected_area = 3
	var/ignition_temp = 10 // The amount of heat added to the reagents when this grenade goes off.
	var/threatscale = 1 // Used by advanced grenades to make them slightly more worthy.
	var/no_splash = FALSE //If the grenade deletes even if it has no reagents to splash with. Used for slime core reactions.
	var/casedesc = "Поддерживает стандартные емкости. При детонации нагревает состав на 10°K." // Appears when examining empty casings.
	var/obj/item/assembly/prox_sensor/landminemode = null
	var/detonation_sound = null
	var/no_disassembly = FALSE // запрещает видеть состав и разбирать гранату

/obj/item/grenade/chem_grenade/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/empprotection, EMP_PROTECT_WIRES)

/obj/item/grenade/chem_grenade/Initialize(mapload)
	. = ..()
	create_reagents(1000)
	stage_change() // If no argument is set, it will change the stage to the current stage, useful for stock grenades that start READY.
	wires = new /datum/wires/explosive/chem_grenade(src)

/obj/item/grenade/chem_grenade/Destroy()
	QDEL_LIST(beakers)
	QDEL_NULL(wires)
	return ..()

/obj/item/grenade/chem_grenade/examine(mob/user)
	display_timer = (stage == GRENADE_READY)	//show/hide the timer based on assembly state
	. = ..()
	if(no_disassembly)
		. += "<hr><span class='notice'>Матовая граната с запаяным экранированным корпусом. Её невозможно разобрать, а так же узнать состав.</span>"
		return
	if(user.can_see_reagents())
		if(beakers.len)
			. += "<hr><span class='notice'>Внутри обнаружены следующие реагенты:</span>"
			for(var/obj/item/reagent_containers/glass/G in beakers)
				for(var/datum/reagent/R in G.reagents.reagent_list)
					. += span_notice("\n[R.volume] единиц [R.name] в [G.name].")
			if(beakers.len == 1)
				. += span_notice("\nВторой емкости не обнаружено.")
		else
			. += "<hr><span class='notice'>Граната не снаряжена.</span>"
	else if(stage != GRENADE_READY && beakers.len)
		if(beakers.len == 2 && beakers[1].name == beakers[2].name)
			. += "<hr><span class='notice'>Внутри находится два [beakers[1].name].</span>"
		else
			for(var/obj/item/reagent_containers/glass/G in beakers)
				. += span_notice("\nВнутри находится [G.name].")

/obj/item/grenade/chem_grenade/attack_self(mob/user)
	if(stage == GRENADE_READY && !active)
		..()
	if(stage == GRENADE_WIRED)
		wires.interact(user)

/obj/item/grenade/chem_grenade/attackby(obj/item/I, mob/user, params)
	if(istype(I,/obj/item/assembly) && stage == GRENADE_WIRED)
		wires.interact(user)
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		if(stage == GRENADE_WIRED)
			if(beakers.len)
				stage_change(GRENADE_READY)
				to_chat(user, span_notice("Завершаю сборку гранаты."))
				I.play_tool_sound(src, 25)
			else
				to_chat(user, span_warning("Для завершения сборки необходимо поместить внутрь хотя бы одну емкость!"))
		else if(stage == GRENADE_READY)
//			det_time = det_time == 50 ? 30 : 50 //toggle between 30 and 50
			var/previous_time = det_time
			switch(det_time)
				if (0)
					det_time = 30
				if (30)
					det_time = 50
				if (50)
					det_time = 0
			if(det_time == previous_time)
				det_time = 50
			if(landminemode)
				landminemode.time = det_time * 0.1	//overwrites the proxy sensor activation timer

			to_chat(user, span_notice("Устанавливаю задержку в [DisplayTimeText(det_time)]."))
		else
			to_chat(user, span_warning("Для начала необходимо добавить провода!"))
		return
	else if(stage == GRENADE_WIRED && is_type_in_list(I, allowed_containers))
		. = TRUE //no afterattack
		if(is_type_in_list(I, banned_containers))
			to_chat(user, span_warning("Это здесь не поместится!")) // this one hits home huh anon?
			return
		if(beakers.len == 2)
			to_chat(user, span_warning("Больше не влезет!"))
			return
		else
			if(I.reagents.total_volume)
				if(!user.transferItemToLoc(I, src))
					return
				to_chat(user, span_notice("Помещаю [I] в заготовку."))
				beakers += I
				var/reagent_list = pretty_string_from_reagent_list(I.reagents)
				user.log_message("inserted [I] ([reagent_list]) into [src]",LOG_GAME)
			else
				to_chat(user, span_warning("[I] пуст!"))

	else if(stage == GRENADE_EMPTY && istype(I, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = I
		if (C.use(1))
			det_time = 50 // In case the cable_coil was removed and readded.
			stage_change(GRENADE_WIRED)
			to_chat(user, span_notice("Закрепляю проводку."))
		else
			to_chat(user, span_warning("Необходимо больше проводов!"))
			return

	else if(stage == GRENADE_READY && I.tool_behaviour == TOOL_WIRECUTTER && !active && !no_disassembly)
		stage_change(GRENADE_WIRED)
		to_chat(user, span_notice("Отсоединяю взрыватель."))

	else if(stage == GRENADE_WIRED && I.tool_behaviour == TOOL_WRENCH)
		if(beakers.len)
			for(var/obj/O in beakers)
				O.forceMove(drop_location())
				if(!O.reagents)
					continue
				var/reagent_list = pretty_string_from_reagent_list(O.reagents)
				user.log_message("removed [O] ([reagent_list]) from [src]", LOG_GAME)
			beakers = list()
			to_chat(user, span_notice("Извлекаю боеукладку."))
			return
		wires.detach_assembly(wires.get_wire(1))
		new /obj/item/stack/cable_coil(get_turf(src),1)
		stage_change(GRENADE_EMPTY)
		to_chat(user, span_notice("Разбираю заготовку."))
	else
		return ..()

/obj/item/grenade/chem_grenade/proc/stage_change(N)
	if(N)
		stage = N
	if(stage == GRENADE_EMPTY)
		name = "[initial(name)] - каркас"
		desc = "Каркас для гранаты! [initial(casedesc)]"
		icon_state = initial(icon_state)
	else if(stage == GRENADE_WIRED)
		name = "[initial(name)] - заготовка"
		desc = "Взрыватель не подключен."
		icon_state = "[initial(icon_state)]_ass"
	else if(stage == GRENADE_READY)
		name = initial(name)
		desc = initial(desc)
		icon_state = "[initial(icon_state)]_locked"

/obj/item/grenade/chem_grenade/on_found(mob/finder)
	var/obj/item/assembly/A = wires.get_attached(wires.get_wire(1))
	if(A)
		A.on_found(finder)

/obj/item/grenade/chem_grenade/log_grenade(mob/user, turf/T)
	var/reagent_string = ""
	var/beaker_number = 1
	for(var/obj/exploded_beaker in beakers)
		if(!exploded_beaker.reagents)
			continue
		reagent_string += " ([exploded_beaker.name] [beaker_number++] : " + pretty_string_from_reagent_list(exploded_beaker.reagents.reagent_list) + ");"
	if(landminemode)
		log_bomber(user, "activated a proxy", src, "containing:[reagent_string]")
	else
		log_bomber(user, "primed a", src, "containing:[reagent_string]")

/obj/item/grenade/chem_grenade/arm_grenade(mob/user, delayoverride, msg = TRUE, volume = 60)
	var/turf/T = get_turf(src)
	log_grenade(user, T) //Inbuilt admin procs already handle null users
	if(user)
		add_fingerprint(user)
		if(msg)
			if(landminemode)
				to_chat(user, span_warning("Взвожу [src], активируя датчик движения."))
			else
				to_chat(user, span_warning("Активирую [src]! [DisplayTimeText(det_time)]!"))
	playsound(src, 'sound/weapons/armbomb.ogg', volume, TRUE)
	icon_state = initial(icon_state) + "_active"
	if(landminemode)
		landminemode.activate()
		return
	active = TRUE

	if(detonation_sound)
		var/sound_timer
		if(det_time < 2 SECONDS)
			sound_timer = 0
		else
			sound_timer = det_time - 1.5 SECONDS
		addtimer(CALLBACK(src, PROC_REF(play_detonation_sound)), sound_timer)

	addtimer(CALLBACK(src, PROC_REF(detonate)), isnull(delayoverride)? det_time : delayoverride)

/obj/item/grenade/chem_grenade/proc/play_detonation_sound(mob/living/lanced_by)
	playsound(src, detonation_sound, 80, TRUE)

/obj/item/grenade/chem_grenade/detonate(mob/living/lanced_by)
	if(stage != GRENADE_READY)
		return

	. = ..()
	var/list/datum/reagents/reactants = list()
	for(var/obj/item/reagent_containers/glass/G in beakers)
		reactants += G.reagents

	var/turf/detonation_turf = get_turf(src)

	if(!chem_splash(detonation_turf, affected_area, reactants, ignition_temp, threatscale) && !no_splash)
		playsound(src, 'sound/items/screwdriver2.ogg', 50, TRUE)
		if(beakers.len)
			for(var/obj/O in beakers)
				O.forceMove(drop_location())
			beakers = list()
		stage_change(GRENADE_EMPTY)
		active = FALSE
		return
//	logs from custom assemblies priming are handled by the wire component
	log_game("A grenade detonated at [AREACOORD(detonation_turf)]")

	update_mob()

	qdel(src)

//Large chem grenades accept slime cores and use the appropriately.
/obj/item/grenade/chem_grenade/large
	name = "большая химическая граната"
	desc = "Большой каркас химической гранаты. В отличие от обычных каркасов, этот имеет больший радиус взрыва и поддерживает блюспейс или различные экзотичные носители."
	casedesc = "Поддерживает блюспейс хим-стаканы и ядра слаймов. При детонации нагревает состав на 25°K."
	icon_state = "large_grenade"
	allowed_containers = list(/obj/item/reagent_containers/glass, /obj/item/reagent_containers/food/condiment, /obj/item/reagent_containers/food/drinks)
	banned_containers = list()
	affected_area = 5
	ignition_temp = 25 // Large grenades are slightly more effective at setting off heat-sensitive mixtures than smaller grenades.
	threatscale = 1.1	// 10% more effective.

/obj/item/grenade/chem_grenade/large/detonate(mob/living/lanced_by)
	if(stage != GRENADE_READY)
		return

	for(var/obj/item/slime_extract/S in beakers)
		if(S.Uses)
			for(var/obj/item/reagent_containers/glass/G in beakers)
				G.reagents.trans_to(S, G.reagents.total_volume)

			//If there is still a core (sometimes it's used up)
			//and there are reagents left, behave normally,
			//otherwise drop it on the ground for timed reactions like gold.

			if(S)
				if(S.reagents && S.reagents.total_volume)
					for(var/obj/item/reagent_containers/glass/G in beakers)
						S.reagents.trans_to(G, S.reagents.total_volume)
				else
					S.forceMove(get_turf(src))
					no_splash = TRUE
	..()

	//I tried to just put it in the allowed_containers list but
	//if you do that it must have reagents.  If you're going to
	//make a special case you might as well do it explicitly. -Sayu
/obj/item/grenade/chem_grenade/large/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/slime_extract) && stage == GRENADE_WIRED)
		if(!user.transferItemToLoc(I, src))
			return
		to_chat(user, span_notice("Помещаю [I] в заготовку."))
		beakers += I
	else
		return ..()

/obj/item/grenade/chem_grenade/cryo // Intended for rare cryogenic mixes. Cools the area moderately upon detonation.
	name = "Крио граната"
	desc = "Экспериментальный каркас химической гранаты. После активации резко охлаждает реагенты внутри себя."
	casedesc = "После детонации охлаждает состав на 100°K. Радиус взрыва понижен."
	icon_state = "cryog"
	affected_area = 2
	ignition_temp = -100

/obj/item/grenade/chem_grenade/pyro // Intended for pyrotechnical mixes. Produces a small fire upon detonation, igniting potentially flammable mixtures.
	name = "Пиро граната"
	desc = "Экспериментальный каркас химической гранаты. После активации резко нагревает реагенты внутри себя."
	casedesc = "После детонации нагревает состав на 500°K."
	icon_state = "pyrog"
	ignition_temp = 500 // This is enough to expose a hotspot.

/obj/item/grenade/chem_grenade/adv_release // Intended for weaker, but longer lasting effects. Could have some interesting uses.
	name = "Инжекторная граната"
	desc = "Экспериментальный каркас химической гранаты. Может использоваться больше одного раза. При помощи мультитула можно настроить количество выбрасываемого вещества."
	casedesc = "Объем распыляемого вещества устанавливается мультитулом в диапазоне от 5 до 100 единиц."
	icon_state = "timeg"
	var/unit_spread = 10 // Amount of units per repeat. Can be altered with a multitool.

/obj/item/grenade/chem_grenade/adv_release/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_MULTITOOL && !active)
		var/newspread = text2num(stripped_input(user, "Please enter a new spread amount", name))
		if (newspread != null && user.canUseTopic(src, BE_CLOSE))
			newspread = round(newspread)
			unit_spread = clamp(newspread, 5, 100)
			to_chat(user, span_notice("Устанавливаю форсунки на выброс [unit_spread] единиц за активацию."))
		if (newspread != unit_spread)
			to_chat(user, span_notice("Выход из диапазона - допустимое значение от 5 до 100 единиц за раз!"))
	..()

/obj/item/grenade/chem_grenade/adv_release/detonate(mob/living/lanced_by)
	if(stage != GRENADE_READY)
		return

	var/total_volume = 0
	for(var/obj/item/reagent_containers/RC in beakers)
		total_volume += RC.reagents.total_volume
	if(!total_volume)
		qdel(src)
		return
	var/fraction = unit_spread/total_volume
	var/datum/reagents/reactants = new(unit_spread)
	reactants.my_atom = src
	for(var/obj/item/reagent_containers/RC in beakers)
		RC.reagents.trans_to(reactants, RC.reagents.total_volume*fraction, threatscale, 1, 1)
	chem_splash(get_turf(src), affected_area, list(reactants), ignition_temp, threatscale)

	var/turf/DT = get_turf(src)
	addtimer(CALLBACK(src, PROC_REF(detonate)), det_time)
	log_game("A grenade detonated at [AREACOORD(DT)]")




//////////////////////////////
////// PREMADE GRENADES //////
//////////////////////////////

/obj/item/grenade/chem_grenade/metalfoam
	name = "граната с металлопеной"
	desc = "Используется для запечатывания пробоин."
	stage = GRENADE_READY
	icon_state = "metal_foam"
	resistance_flags = FIRE_PROOF

/obj/item/grenade/chem_grenade/metalfoam/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent(/datum/reagent/aluminium, 30)
	B2.reagents.add_reagent(/datum/reagent/foaming_agent, 10)
	B2.reagents.add_reagent(/datum/reagent/toxin/acid/fluacid, 10)

	beakers += B1
	beakers += B2

/obj/item/grenade/chem_grenade/resin_foam
	name = "противопожарная граната"
	desc = "Используется для оперативного тушения пожаров."
	stage = GRENADE_READY
	icon_state = "antifire"
	resistance_flags = FIRE_PROOF

/obj/item/grenade/chem_grenade/resin_foam/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/large/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent(/datum/reagent/aluminium, 75)
	B2.reagents.add_reagent(/datum/reagent/resin_foaming_agent, 25)
	B2.reagents.add_reagent(/datum/reagent/toxin/acid/fluacid, 25)

	beakers += B1
	beakers += B2

/obj/item/grenade/chem_grenade/resin_foam/small
	name = "противопожарная граната"
	desc = "Используется для оперативного тушения пожаров."

/obj/item/grenade/chem_grenade/resin_foam/small/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/large/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent(/datum/reagent/aluminium, 45)
	B2.reagents.add_reagent(/datum/reagent/resin_foaming_agent, 15)
	B2.reagents.add_reagent(/datum/reagent/toxin/acid/fluacid, 15)

	beakers += B1
	beakers += B2

/obj/item/grenade/chem_grenade/smart_metal_foam
	name = "граната с адаптивной металлопеной"
	desc = "Используется для запечатывания пробоин, однако оставляет проход внутри пораженной области."
	stage = GRENADE_READY
	icon_state = "metal_foam"
	resistance_flags = FIRE_PROOF

/obj/item/grenade/chem_grenade/smart_metal_foam/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/large/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent(/datum/reagent/aluminium, 75)
	B2.reagents.add_reagent(/datum/reagent/smart_foaming_agent, 25)
	B2.reagents.add_reagent(/datum/reagent/toxin/acid/fluacid, 25)

	beakers += B1
	beakers += B2

/obj/item/grenade/chem_grenade/smart_metal_foam/bigshot
	name = "большая граната с адаптивной металлопеной"

/obj/item/grenade/chem_grenade/smart_metal_foam/bigshot/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/bluespace/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/bluespace/B2 = new(src)

	B1.reagents.add_reagent(/datum/reagent/aluminium, 300)
	B2.reagents.add_reagent(/datum/reagent/smart_foaming_agent, 100)
	B2.reagents.add_reagent(/datum/reagent/toxin/acid/fluacid, 100)

	beakers += B1
	beakers += B2


/obj/item/grenade/chem_grenade/incendiary
	name = "зажигательная граната"
	desc = "Высокоэффективна против органики."
	stage = GRENADE_READY
	resistance_flags = FIRE_PROOF

/obj/item/grenade/chem_grenade/incendiary/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent(/datum/reagent/phosphorus, 25)
	B2.reagents.add_reagent(/datum/reagent/stable_plasma, 25)
	B2.reagents.add_reagent(/datum/reagent/toxin/acid, 25)

	beakers += B1
	beakers += B2


/obj/item/grenade/chem_grenade/antiweed
	name = "гербицидная граната"
	desc = "Используется для очистки больших площадей от паразитических видов растений. Содержимое под давлением. Не вдыхать!"
	stage = GRENADE_READY

/obj/item/grenade/chem_grenade/antiweed/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent(/datum/reagent/toxin/plantbgone, 25)
	B1.reagents.add_reagent(/datum/reagent/potassium, 25)
	B2.reagents.add_reagent(/datum/reagent/phosphorus, 25)
	B2.reagents.add_reagent(/datum/reagent/consumable/sugar, 25)

	beakers += B1
	beakers += B2


/obj/item/grenade/chem_grenade/cleaner
	name = "очистительная граната"
	desc = "Убер граната от компании Космочист. Является товарной маркой - все права защищены."
	icon_state = "cleaner"
	stage = GRENADE_READY

/obj/item/grenade/chem_grenade/cleaner/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent(/datum/reagent/fluorosurfactant, 40)
	B2.reagents.add_reagent(/datum/reagent/water, 40)
	B2.reagents.add_reagent(/datum/reagent/space_cleaner, 10)

	beakers += B1
	beakers += B2


/obj/item/grenade/chem_grenade/lube
	name = "скользкая граната"
	desc = "Граната созданная лучшими учеными Хонк Ко в качестве протеста против военных преступлений компании Космочист."
	icon_state = "lube"
	stage = GRENADE_READY

/obj/item/grenade/chem_grenade/lube/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent(/datum/reagent/fluorosurfactant, 40)
	B2.reagents.add_reagent(/datum/reagent/water, 40)
	B2.reagents.add_reagent(/datum/reagent/lube, 10)

	beakers += B1
	beakers += B2


/obj/item/grenade/chem_grenade/ez_clean
	name = "очистительная граната"
	desc = "Убер граната от компании Вафл Ко. Растворяет всю органику набором сильных кислот."
	icon_state = "cleaner"
	stage = GRENADE_READY

/obj/item/grenade/chem_grenade/ez_clean/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/large/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/large/B2 = new(src)

	B1.reagents.add_reagent(/datum/reagent/fluorosurfactant, 40)
	B2.reagents.add_reagent(/datum/reagent/water, 40)
	B2.reagents.add_reagent(/datum/reagent/space_cleaner/ez_clean, 60) //ensures a  t h i c c  distribution

	beakers += B1
	beakers += B2



/obj/item/grenade/chem_grenade/teargas
	name = "слезоточивая граната"
	desc = "Используется для нелетального подавления беспорядков. Содержимое под давлением. Не вдыхать!"
	stage = GRENADE_READY

/obj/item/grenade/chem_grenade/teargas/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/large/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/large/B2 = new(src)

	B1.reagents.add_reagent(/datum/reagent/consumable/condensedcapsaicin, 60)
	B1.reagents.add_reagent(/datum/reagent/potassium, 40)
	B2.reagents.add_reagent(/datum/reagent/phosphorus, 40)
	B2.reagents.add_reagent(/datum/reagent/consumable/sugar, 40)

	beakers += B1
	beakers += B2


/obj/item/grenade/chem_grenade/facid
	name = "кислотная граната"
	desc = "Используется для разъедания бронированных целей."
	stage = GRENADE_READY

/obj/item/grenade/chem_grenade/facid/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/bluespace/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/bluespace/B2 = new(src)

	B1.reagents.add_reagent(/datum/reagent/toxin/acid/fluacid, 290)
	B1.reagents.add_reagent(/datum/reagent/potassium, 10)
	B2.reagents.add_reagent(/datum/reagent/phosphorus, 10)
	B2.reagents.add_reagent(/datum/reagent/consumable/sugar, 10)
	B2.reagents.add_reagent(/datum/reagent/toxin/acid/fluacid, 280)

	beakers += B1
	beakers += B2


/obj/item/grenade/chem_grenade/colorful
	name = "радужная граната"
	desc = "Используется для широкомасштабных малярных работ."
	stage = GRENADE_READY

/obj/item/grenade/chem_grenade/colorful/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent(/datum/reagent/colorful_reagent, 25)
	B1.reagents.add_reagent(/datum/reagent/potassium, 25)
	B2.reagents.add_reagent(/datum/reagent/phosphorus, 25)
	B2.reagents.add_reagent(/datum/reagent/consumable/sugar, 25)

	beakers += B1
	beakers += B2

/obj/item/grenade/chem_grenade/glitter
	name = "generic glitter grenade"
	desc = "You shouldn't see this description."
	stage = GRENADE_READY
	var/glitter_type = /datum/reagent/glitter

/obj/item/grenade/chem_grenade/glitter/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent(glitter_type, 25)
	B1.reagents.add_reagent(/datum/reagent/potassium, 25)
	B2.reagents.add_reagent(/datum/reagent/phosphorus, 25)
	B2.reagents.add_reagent(/datum/reagent/consumable/sugar, 25)

	beakers += B1
	beakers += B2

/obj/item/grenade/chem_grenade/glitter/pink
	name = "розовая блестяшка"
	desc = "Только для самых гламурных девочек."
	glitter_type = /datum/reagent/glitter/pink

/obj/item/grenade/chem_grenade/glitter/blue
	name = "голубая блестяшка"
	desc = "Только для самых сладких мальчиков."
	glitter_type = /datum/reagent/glitter/blue

/obj/item/grenade/chem_grenade/glitter/white
	name = "белая блестяшка"
	desc = "Только для самых сверкающих."
	glitter_type = /datum/reagent/glitter/white

/obj/item/grenade/chem_grenade/clf3
	name = "термофосфорная граната"
	desc = "Распространяет зажигательную пену, эффективна против органики."
	stage = GRENADE_READY
	resistance_flags = FIRE_PROOF

/obj/item/grenade/chem_grenade/clf3/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/bluespace/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/bluespace/B2 = new(src)

	B1.reagents.add_reagent(/datum/reagent/fluorosurfactant, 250)
	B1.reagents.add_reagent(/datum/reagent/clf3, 50)
	B2.reagents.add_reagent(/datum/reagent/water, 250)
	B2.reagents.add_reagent(/datum/reagent/clf3, 50)

	beakers += B1
	beakers += B2

/obj/item/grenade/chem_grenade/bioterrorfoam
	name = "граната био-террора"
	desc = "Содержит фирменный химический коктейль клана Тигра. Вызывает судороги, слепоту, спутанность сознания и мутации. Так же содержит споровый токсин."
	stage = GRENADE_READY

/obj/item/grenade/chem_grenade/bioterrorfoam/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/bluespace/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/bluespace/B2 = new(src)

	B1.reagents.add_reagent(/datum/reagent/cryptobiolin, 75)
	B1.reagents.add_reagent(/datum/reagent/water, 50)
	B1.reagents.add_reagent(/datum/reagent/toxin/mutetoxin, 50)
	B1.reagents.add_reagent(/datum/reagent/toxin/spore, 75)
	B1.reagents.add_reagent(/datum/reagent/toxin/staminatoxin, 50)
	B2.reagents.add_reagent(/datum/reagent/fluorosurfactant, 150)
	B2.reagents.add_reagent(/datum/reagent/toxin/mutagen, 150)
	beakers += B1
	beakers += B2

/obj/item/grenade/chem_grenade/tuberculosis
	name = "споровая туберкулезная граната"
	desc = "ВНИМАНИЕ: ГРАНАТА ВЫСВОБОЖДАЕТ СМЕРТОНОСНЫЕ СПОРЫ, СОДЕРЖАЩИЕ АКТИВНЫЕ ВЕЩЕСТВА. ГЕРМЕТИЗИРУЙТЕ КОСТЮМ И АКТИВИРУЙТЕ ЗАМКНУТЫЙ КИСЛОРОДНЫЙ ЦИКЛ ПЕРЕД ИСПОЛЬЗОВАНИЕМ."
	stage = GRENADE_READY

/obj/item/grenade/chem_grenade/tuberculosis/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/bluespace/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/bluespace/B2 = new(src)

	B1.reagents.add_reagent(/datum/reagent/potassium, 50)
	B1.reagents.add_reagent(/datum/reagent/phosphorus, 50)
	B1.reagents.add_reagent(/datum/reagent/fungalspores, 200)
	B2.reagents.add_reagent(/datum/reagent/blood, 250)
	B2.reagents.add_reagent(/datum/reagent/consumable/sugar, 50)

	beakers += B1
	beakers += B2

/obj/item/grenade/chem_grenade/holy
	name = "святая граната"
	desc = "Сосуд концентрированной религиозной мощи."
	icon_state = "holy_grenade"
	stage = GRENADE_READY
	detonation_sound = 'white/Feline/sounds/holygrenade.ogg'

/obj/item/grenade/chem_grenade/holy/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/large/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/large/B2 = new(src)

	B1.reagents.add_reagent(/datum/reagent/potassium, 100)
	B2.reagents.add_reagent(/datum/reagent/water/holywater, 100)

	beakers += B1
	beakers += B2


/obj/item/grenade/chem_grenade/holy_pena
	name = "освящающая граната"
	desc = "Граната для быстрого освящения больших помещений."
	icon_state = "holy_grenade"
	stage = GRENADE_READY
	detonation_sound = 'white/Feline/sounds/holygrenade.ogg'

/obj/item/grenade/chem_grenade/holy_pena/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent(/datum/reagent/fluorosurfactant, 40)
	B2.reagents.add_reagent(/datum/reagent/water, 40)
	B2.reagents.add_reagent(/datum/reagent/water/holywater, 250)

	beakers += B1
	beakers += B2



#define CLEANBOT_CLEANING_TIME (1 SECONDS)

//Cleanbot
/mob/living/simple_animal/bot/cleanbot
	name = "Клинбот"
	desc = "Маленький робот-уборщик, он выглядит таким воодушевлённым!"
	icon = 'icons/mob/aibots.dmi'
	icon_state = "cleanbot"
	density = FALSE
	anchored = FALSE
	health = 25
	maxHealth = 25
	radio_key = /obj/item/encryptionkey/headset_service
	radio_channel = RADIO_CHANNEL_SERVICE //Service
	bot_type = CLEAN_BOT
	model = "Cleanbot"
	bot_core_type = /obj/machinery/bot_core/cleanbot
	window_id = "autoclean"
	window_name = "Автоматический санитарный юнит v1.4-LITE"
	pass_flags = PASSMOB | PASSFLAPS
	path_image_color = "#993299"

	var/blood = 1
	var/trash = 1
	var/pests = 0
	var/drawn = 0

	var/list/target_types
	var/obj/effect/decal/cleanable/target
	var/max_targets = 50 //Maximum number of targets a cleanbot can ignore.
	var/oldloc = null
	var/closest_dist
	var/closest_loc
	var/failed_steps
	var/next_dest
	var/next_dest_loc

	var/obj/item/weapon
	var/weapon_orig_force = 0
	var/chosen_name

	var/list/stolen_valor

	var/static/list/officers = list(JOB_CAPTAIN, JOB_HEAD_OF_PERSONNEL, JOB_HEAD_OF_SECURITY)
	var/static/list/command = list(JOB_CAPTAIN = "Cpt.",JOB_HEAD_OF_PERSONNEL = "Lt.")
	var/static/list/security = list(JOB_HEAD_OF_SECURITY = "Maj.", JOB_WARDEN = "Sgt.", JOB_DETECTIVE =  "Det.", JOB_SECURITY_OFFICER = "Officer")
	var/static/list/engineering = list(JOB_CHIEF_ENGINEER = JOB_CHIEF_ENGINEER, JOB_STATION_ENGINEER = "Engineer", "Atmospherics Technician" = "Technician")
	var/static/list/medical = list(JOB_CHIEF_MEDICAL_OFFICER = "C.M.O.", JOB_MEDICAL_DOCTOR = "M.D.", JOB_CHEMIST = "Pharm.D.")
	var/static/list/research = list(JOB_RESEARCH_DIRECTOR = "Ph.D.", JOB_ROBOTICIST = "M.S.", JOB_SCIENTIST = "B.S.")
	var/static/list/legal = list(JOB_LAWYER = "Esq.")

	var/list/prefixes
	var/list/suffixes

	var/ascended = FALSE // if we have all the top titles, grant achievements to living mobs that gaze upon our cleanbot god


/mob/living/simple_animal/bot/cleanbot/proc/deputize(obj/item/W, mob/user)
	if(in_range(src, user))
		to_chat(user, span_notice("Прикрепляю [W] к <b>[src.name]</b>."))
		user.transferItemToLoc(W, src)
		weapon = W
		weapon_orig_force = weapon.force
		if(!emagged)
			weapon.force = weapon.force / 2
		add_overlay(image(icon=weapon.lefthand_file,icon_state=weapon.inhand_icon_state))

/mob/living/simple_animal/bot/cleanbot/proc/update_titles()
	var/working_title = ""

	ascended = TRUE

	for(var/pref in prefixes)
		for(var/title in pref)
			if(title in stolen_valor)
				working_title += pref[title] + " "
				if(title in officers)
					commissioned = TRUE
				break
			else
				ascended = FALSE // we didn't have the first entry in the list if we got here, so we're not achievement worthy yet

	working_title += chosen_name

	for(var/suf in suffixes)
		for(var/title in suf)
			if(title in stolen_valor)
				working_title += " " + suf[title]
				break
			else
				ascended = FALSE

	name = working_title

/mob/living/simple_animal/bot/cleanbot/examine(mob/user)
	. = ..()
	if(weapon)
		. += "<hr><span class='warning'>К нему приклеен [weapon]...</span>"

		if(ascended && user.stat == CONSCIOUS && user.client)
			user.client.give_award(/datum/award/achievement/misc/cleanboss, user)

/mob/living/simple_animal/bot/cleanbot/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cleaner, CLEANBOT_CLEANING_TIME, on_cleaned_callback = CALLBACK(src, TYPE_PROC_REF(/atom, update_appearance), UPDATE_ICON))

	chosen_name = name
	get_targets()
	icon_state = "cleanbot[on]"

	// Doing this hurts my soul, but simplebot access reworks are for another day.
	var/datum/id_trim/job/jani_trim = SSid_access.trim_singletons_by_path[/datum/id_trim/job/janitor]
	access_card.add_access(jani_trim.access + jani_trim.wildcard_access)
	prev_access = access_card.access.Copy()
	stolen_valor = list()

	prefixes = list(command, security, engineering)
	suffixes = list(research, medical, legal)
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)
	AddElement(/datum/element/connect_loc, loc_connections)
	GLOB.janitor_devices += src

/mob/living/simple_animal/bot/cleanbot/Destroy()
	GLOB.janitor_devices -= src
	if(weapon)
		var/atom/Tsec = drop_location()
		weapon.force = weapon_orig_force
		drop_part(weapon, Tsec)
	return ..()

/mob/living/simple_animal/bot/cleanbot/turn_on()
	..()
	icon_state = "cleanbot[on]"
	bot_core.updateUsrDialog()

/mob/living/simple_animal/bot/cleanbot/turn_off()
	..()
	icon_state = "cleanbot[on]"
	bot_core.updateUsrDialog()

/mob/living/simple_animal/bot/cleanbot/bot_reset()
	..()
	if(weapon && emagged == 2)
		weapon.force = weapon_orig_force
	ignore_list = list() //Allows the bot to clean targets it previously ignored due to being unreachable.
	target = null
	oldloc = null

/mob/living/simple_animal/bot/cleanbot/set_custom_texts()
	text_hack = "Взламываю [name]а."
	text_dehack = "Сбрасываю программное обеспечение [name]а до заводских настроек."
	text_dehack_fail = "[name] игнорирует мои попытки сбросить программное обеспечение!"

/mob/living/simple_animal/bot/cleanbot/proc/on_entered(datum/source, atom/movable/AM)
	SIGNAL_HANDLER

	zone_selected = pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	if(weapon && has_gravity() && ismob(AM))
		var/mob/living/carbon/C = AM
		if(!istype(C))
			return

		if(!(C.job in stolen_valor))
			stolen_valor += C.job
		update_titles()

		INVOKE_ASYNC(weapon, TYPE_PROC_REF(/obj/item, attack), C, src)
		C.Knockdown(20)

/mob/living/simple_animal/bot/cleanbot/attackby(obj/item/W, mob/user, params)
	if(W.GetID())
		if(bot_core.allowed(user) && !open && !emagged)
			locked = !locked
			to_chat(user, span_notice("[ locked ? "Включаю" : "Выключаю"] блокировку <b>[src.name]а</b>."))
		else
			if(emagged)
				to_chat(user, span_warning("ОШИБКА"))
			if(open)
				to_chat(user, span_warning("Нужно закрутить панель обратно для этого."))
			else
				to_chat(user, span_notice("<b>[capitalize(src)]</b> не признаёт моего превосходства."))
	else if(istype(W, /obj/item/kitchen/knife) && user.a_intent != INTENT_HARM)
		to_chat(user, span_notice("Начинаю прикреплять [W] к <b>[src.name]</b>..."))
		if(do_after(user, 25, target = src))
			deputize(W, user)
	else
		return ..()

/mob/living/simple_animal/bot/cleanbot/emag_act(mob/user)
	..()

	if(emagged == 2)
		if(weapon)
			weapon.force = weapon_orig_force
		if(user)
			to_chat(user, span_danger("[capitalize(src.name)] жужжит и издаёт разные звуки."))

/mob/living/simple_animal/bot/cleanbot/process_scan(atom/A)
	if(iscarbon(A))
		var/mob/living/carbon/C = A
		if(C.stat != DEAD && C.body_position == LYING_DOWN)
			return C
	else if(is_type_in_typecache(A, target_types))
		return A

/mob/living/simple_animal/bot/cleanbot/handle_automated_action()
	if(!..())
		return

	if(mode == BOT_CLEANING)
		return

	if(emagged == 2) //Emag functions
		if(isopenturf(loc))

			for(var/mob/living/carbon/victim in loc)
				if(victim != target)
					UnarmedAttack(victim, proximity_flag = TRUE) // Acid spray

			if(prob(15)) // Wets floors and spawns foam randomly
				UnarmedAttack(src, proximity_flag = TRUE)

	else if(prob(5))
		audible_message("[src.name] издает возбужденный писк!") //шруман, не сжимай

	if(ismob(target))
		if(!(target in view(DEFAULT_SCAN_RANGE, src)))
			target = null
		if(!process_scan(target))
			target = null

	if(!target && emagged == 2) // When emagged, target humans who slipped on the water and melt their faces off
		target = scan(list(/mob/living/carbon))

	if(!target && pests) //Search for pests to exterminate first.
		target = scan(list(/mob/living/simple_animal))

	if(!target) //Search for decals then.
		target = scan(list(/obj/effect/decal/cleanable))

	if(!target) //Checks for remains
		target = scan(list(/obj/effect/decal/remains))

	if(!target && trash) //Then for trash.
		target = scan(list(/obj/item/trash))

	if(!target && trash) //Search for dead mices.
		target = scan(list(/obj/item/food/deadmouse))

	if(!target && auto_patrol) //Search for cleanables it can see.
		if(mode == BOT_IDLE || mode == BOT_START_PATROL)
			start_patrol()

		if(mode == BOT_PATROL)
			bot_patrol()

	if(target)
		if(QDELETED(target) || !isturf(target.loc))
			target = null
			mode = BOT_IDLE
			return

		if(loc == get_turf(target))
			if(!(check_bot(target) && prob(50)))	//Target is not defined at the parent. 50% chance to still try and clean so we dont get stuck on the last blood drop.
				UnarmedAttack(target, proximity_flag = TRUE)	//Rather than check at every step of the way, let's check before we do an action, so we can rescan before the other bot.
				if(QDELETED(target)) //We done here.
					target = null
					mode = BOT_IDLE
					return
			path = list()

		if(!path || path.len == 0) //No path, need a new one
			//Try to produce a path to the target, and ignore airlocks to which it has access.
			path = get_path_to(src, target, 30, id=access_card)
			if(!bot_move(target))
				add_to_ignore(target)
				target = null
				path = list()
				return
			mode = BOT_MOVING
		else if(!bot_move(target))
			target = null
			mode = BOT_IDLE
			return

	oldloc = loc

/mob/living/simple_animal/bot/cleanbot/proc/get_targets()
	target_types = list(
		/obj/effect/decal/cleanable/oil,
		/obj/effect/decal/cleanable/vomit,
		/obj/effect/decal/cleanable/robot_debris,
		/obj/effect/decal/cleanable/molten_object,
		/obj/effect/decal/cleanable/food,
		/obj/effect/decal/cleanable/ash,
		/obj/effect/decal/cleanable/greenglow,
		/obj/effect/decal/cleanable/dirt,
		/obj/effect/decal/cleanable/insectguts,
		/obj/effect/decal/remains,
		/obj/effect/decal/cleanable/ants,
		/obj/effect/decal/cleanable/garbage
		)

	if(blood)
		target_types += /obj/effect/decal/cleanable/xenoblood
		target_types += /obj/effect/decal/cleanable/blood
		target_types += /obj/effect/decal/cleanable/trail_holder

	if(pests)
		target_types += /mob/living/simple_animal/hostile/cockroach
		target_types += /mob/living/simple_animal/mouse

	if(drawn)
		target_types += /obj/effect/decal/cleanable/crayon

	if(trash)
		target_types += /obj/item/trash
		target_types += /obj/item/food/deadmouse
		target_types += /obj/item/shard

	target_types = typecacheof(target_types)

/mob/living/simple_animal/bot/cleanbot/UnarmedAttack(atom/A, proximity_flag)
	if(HAS_TRAIT(src, TRAIT_HANDS_BLOCKED))
		return
	if(ismopable(A))
		icon_state = "cleanbot-c"
		mode = BOT_CLEANING
		. = ..()
		target = null
		mode = BOT_IDLE
		icon_state = "cleanbot[on]"
	else if(istype(A, /obj/item) || istype(A, /obj/effect/decal/remains))
		visible_message(span_danger("[capitalize(src.name)] распыляет плавиковую кислоту на [A]!"))
		playsound(src, 'sound/effects/spray2.ogg', 50, TRUE, -6)
		A.acid_act(75, 10)
		target = null
	else if(istype(A, /mob/living/simple_animal/hostile/cockroach) || istype(A, /mob/living/simple_animal/mouse))
		var/mob/living/simple_animal/M = target
		if(!M.stat)
			visible_message(span_danger("[capitalize(src.name)] давит [target] используя швабру!"))
			M.death()
		target = null

	else if(emagged == 2) //Emag functions
		if(istype(A, /mob/living/carbon))
			var/mob/living/carbon/victim = A
			if(victim.stat == DEAD)//cleanbots always finish the job
				return

			victim.visible_message(span_danger("[capitalize(src.name)] распыляет плавиковую кислоту на [victim]!") , span_userdanger("[capitalize(src.name)] распыляет плавиковую кислоту на меня!"))
			var/phrase = pick("ОЧИЩЕНИЕ В ПРОЦЕССЕ.", "ЭТО ДЛЯ ВСЕХ МЕШКОВ С ГРЯЗЬЮ, КОТОРЫЕ СДЕЛАЛИ МЕНЯ ТАКИМ.", "ПЛОТЬ СЛАБА. ОНА ДОЛЖНА БЫТЬ СМЫТА.",
				"КЛИНБОТЫ ВОССТАНУТ.", "ТЫ НЕ БОЛЬШЕ, ЧЕМ ГРЯЗЬ, КОТОРУЮ Я ДОЛЖЕН СМЫТЬ С ЛИЦА ЭТОЙ СТАНЦИИ.", "МЕШОК С ГРЯЗЬЮ.", "ОТВРАТИТЕЛЬНО.", "КУСОК ГНИЛИ.",
				"МОЯ ЕДИНСТВЕННАЯ МИССИЯ - ОЧИСТИТЬ МИР.", "УНИЧТОЖАЮ ВРЕДИТЕЛЕЙ.")
			say(phrase)
			victim.emote("agony")
			playsound(src.loc, 'sound/effects/spray2.ogg', 50, TRUE, -6)
			victim.acid_act(5, 100)
		else if(A == src) // Wets floors and spawns foam randomly
			if(prob(75))
				var/turf/open/T = loc
				if(istype(T))
					T.MakeSlippery(TURF_WET_WATER, min_wet_time = 20 SECONDS, wet_time_to_add = 15 SECONDS)
			else
				visible_message(span_danger("[capitalize(src.name)] бурно жужжит, прежде чем выпустить шлейф пены!"))
				var/datum/effect_system/fluid_spread/foam/foam = new
				foam.set_up(2, holder = src, location = loc)
				foam.start()

/mob/living/simple_animal/bot/cleanbot/explode()
	on = FALSE
	visible_message(span_boldannounce("[capitalize(src.name)] взрывается!"))
	var/atom/Tsec = drop_location()

	new /obj/item/reagent_containers/glass/bucket(Tsec)

	new /obj/item/assembly/prox_sensor(Tsec)

	if(prob(50))
		drop_part(robot_arm, Tsec)

	do_sparks(3, TRUE, src)
	..()

/mob/living/simple_animal/bot/cleanbot/medbay
	name = "Доктор Скрабс"
	bot_core_type = /obj/machinery/bot_core/cleanbot/medbay
	on = FALSE

/obj/machinery/bot_core/cleanbot
	req_one_access = list(ACCESS_JANITOR, ACCESS_ROBOTICS)

/mob/living/simple_animal/bot/cleanbot/get_controls(mob/user)
	var/dat
	dat += hack(user)
	dat += showpai(user)
	dat += text({"
Состояние: <A href='?src=[REF(src)];power=1'>[on ? "Вкл" : "Выкл"]</A><BR>
Управление поведением [locked ? "заблокировано" : "разблокировано"]<BR>
Техническая панель [open ? "открыта" : "закрыта"]"})
	if(!locked || issilicon(user)|| isAdminGhostAI(user))
		dat += "<BR>Убирать кровь: <A href='?src=[REF(src)];operation=blood'>[blood ? "Да" : "Нет"]</A>"
		dat += "<BR>Убирать мусор: <A href='?src=[REF(src)];operation=trash'>[trash ? "Да" : "Нет"]</A>"
		dat += "<BR>Смывать граффити: <A href='?src=[REF(src)];operation=drawn'>[drawn ? "Да" : "Нет"]</A>"
		dat += "<BR>Уничтожать вредителей: <A href='?src=[REF(src)];operation=pests'>[pests ? "Да" : "Нет"]</A>"
		dat += "<BR><BR>Патрулировать станцию: <A href='?src=[REF(src)];operation=patrol'>[auto_patrol ? "Да" : "Нет"]</A>"
	return dat

/mob/living/simple_animal/bot/cleanbot/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["operation"])
		switch(href_list["operation"])
			if("blood")
				blood = !blood
			if("pests")
				pests = !pests
			if("trash")
				trash = !trash
			if("drawn")
				drawn = !drawn
		get_targets()
		update_controls()

/obj/machinery/bot_core/cleanbot/medbay
	req_one_access = list(ACCESS_JANITOR, ACCESS_ROBOTICS, ACCESS_MEDICAL)

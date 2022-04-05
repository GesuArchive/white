
// turfs -------------------------------------------------------

/turf/open/floor/dz
	icon = 'white/valtos/icons/dz-031.dmi'

/turf/open/indestructible/labfloor
	name = "сверхкрепкий пол"
	desc = "Гарантированно выдержит взрыв любой мощноости. Правда нет никаких гарантий для тех, кто будет стоять во время взрыва на нём."
	icon = 'white/valtos/icons/dz-031.dmi'
	icon_state = "labfloor"
	footstep = FOOTSTEP_FLOOR

/turf/closed/dz
	icon = 'white/valtos/icons/dz-031.dmi'
	turf_flags = NOJAUNT

/turf/open/floor/dz/normal
	name = "киберпространство"
	icon_state = "open"
	plane = PLANE_SPACE
	layer = SPACE_LAYER
	vis_flags = VIS_INHERIT_ID
	blocks_air = FALSE

/turf/open/floor/dz/normal/Initialize()
	SHOULD_CALL_PARENT(FALSE)
	vis_contents.Cut()
	visibilityChanged()

	if(flags_1 & INITIALIZED_1)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	flags_1 |= INITIALIZED_1

	ComponentInitialize()

	if(!blocks_air)
		air = new
		air.copy_from_turf(src)
		update_air_ref(0)

	SSvis_overlays.add_vis_overlay(src, icon, "fucked", plane = PLANE_SPACE)

	return INITIALIZE_HINT_NORMAL

/turf/open/floor/dz/green
	name = "пол"
	icon_state = "green1"

/turf/open/floor/dz/green/Initialize(mapload)
	. = ..()
	icon_state = "green[rand(1, 6)]"

/turf/open/floor/dz/cyber
	name = "си-пол"
	icon_state = "c_floor"

/turf/open/floor/dz/pre_exit
	name = "зона выхода"
	icon_state = "pre_exit"

/turf/open/floor/dz/exit
	name = "выход"
	icon_state = "exit"

/turf/open/floor/dz/corruption
	name = "повреждение"
	icon_state = "corruption"

/turf/open/floor/dz/hot_plates
	name = "опасная зона"
	icon_state = "hot_plates1"

/turf/open/floor/dz/hot_plates/Initialize(mapload)
	. = ..()
	icon_state = "hot_plates[rand(1,3)]"

/turf/closed/dz/normal
	name = "блок"
	icon_state = "closed"

/turf/closed/dz/normal/cyber
	name = "си-блок"
	icon_state = "c_wall1"

/turf/closed/dz/normal/cyber/Initialize()
	. = ..()
	if(prob(0.1))
		icon_state = "c_wall2"
		density = 0

/turf/closed/dz/lab
	name = "сверхкрепкая стена"
	icon_state = "labwall-h"
	plane = FLOOR_PLANE


// structures --------------------------------------------------

/obj/structure/sign/dz
	name = "DZ-0031"
	desc = "Удивительно, что у тебя есть время на рассматривание этого."
	icon = 'white/valtos/icons/dz-031.dmi'
	icon_state = "dz1"

/obj/structure/sign/dz/middle
	icon_state = "dz2"

/obj/structure/sign/dz/end
	icon_state = "dz3"


// areas -------------------------------------------------------

/area/cyberspace
	name = "Киберпространство"
	icon_state = "maint_bar"
	has_gravity = STANDARD_GRAVITY
	area_flags = NOTELEPORT | HIDDEN_AREA | BLOCK_SUICIDE

/area/cyberspace/exit
	name = "Выход"
	icon_state = "maint_eva"

/area/cyberspace/border
	name = "Граница киберпространства"
	icon_state = "maint_sec"

/area/lab031
	name = "Лаборатория x031"
	icon_state = "maint_eva"
	has_gravity = STANDARD_GRAVITY
	area_flags = NOTELEPORT | HIDDEN_AREA | BLOCK_SUICIDE

/area/lab031/zone1
	name = "Лаборатория x031: Зона 1"

/area/lab031/zone2
	name = "Лаборатория x031: Зона 2"

/area/lab031/zone3
	name = "Лаборатория x031: Зона 3"

/area/lab031/zone4
	name = "Лаборатория x031: Зона 4"

/area/lab031/zone5
	name = "Лаборатория x031: Зона 5"


// objs --------------------------------------------------------

/obj/lab_monitor
	name = "Монитор"
	desc = "Стекло выглядит не очень крепким..."
	icon = 'white/valtos/icons/dz-031.dmi'
	icon_state = "monitor"
	flags_1 = INDESTRUCTIBLE
	plane = GAME_PLANE
	anchored = TRUE
	var/what_pic = "anonist"

/obj/lab_monitor/attacked_by(obj/item/I, mob/living/user)
	if(. && I.force > 5)
		icon_state = "monitor_cracked"
	return ..()

/obj/lab_monitor/Initialize()
	. = ..()
	add_overlay(what_pic)

/obj/effect/attack_spike
	name = "ОПАСНОСТЬ"
	icon = 'white/valtos/icons/dz-031.dmi'
	icon_state = "attention"

/obj/effect/attack_spike/Initialize()
	. = ..()
	spawn(10)
		icon_state = "spike_hole"
		spawn(10)
			icon_state = "spike_strike"
			var/latched = FALSE
			for(var/mob/living/L in loc)
				visible_message(span_danger("Стержень жёстко пробивает тушку <b>[L]</b>!"))
				L.adjustBruteLoss(50)
				var/turf/T = get_turf(src)
				new /obj/effect/decal/cleanable/blood(T)
				playsound(T, 'sound/effects/wounds/pierce3.ogg', 50, 1)
				latched = TRUE
			spawn(10)
				if(latched)
					icon_state = "spike_bloody_retract"
				else
					icon_state = "spike_retract"
				spawn(5)
					icon_state = "spike_hole"
					spawn(5)
						qdel(src)

/obj/machinery/door/veryblastdoor
	name = "сверхкрепкий шлюз"
	desc = "Достаточно крепкий для сдерживания выстрелов из блюспейс артиллерии в упор."
	icon = 'white/valtos/icons/dz-031.dmi'
	icon_state = "veryblastdoor_closed"
	explosion_block = 3
	heat_proof = TRUE
	max_integrity = 1200
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | LAVA_PROOF
	damage_deflection = 90
	poddoor = TRUE
	safe = FALSE
	use_power = NO_POWER_USE
	var/id = 1
	var/pos = ""

/obj/machinery/door/veryblastdoor/vertical
	icon_state = "veryblastdoorvert_closed"
	pos = "vert"

/obj/machinery/door/veryblastdoor/trader
	id = "trador1"

/obj/machinery/door/veryblastdoor/do_animate(animation)
	switch(animation)
		if("opening")
			flick("veryblastdoor[pos]_opening", src)
			playsound(src, 'white/valtos/sounds/dz/verydoor.ogg', 40, TRUE)
		if("closing")
			flick("veryblastdoor[pos]_closing", src)
			playsound(src, 'white/valtos/sounds/dz/verydoor.ogg', 40, TRUE)

/obj/machinery/door/veryblastdoor/update_icon_state()
	if(density)
		icon_state = "veryblastdoor[pos]_closed"
	else
		icon_state = "veryblastdoor[pos]_open"

/obj/machinery/door/veryblastdoor/Bumped(atom/movable/AM)
	return !density && ..()

/obj/machinery/door/veryblastdoor/try_to_crowbar(obj/item/I, mob/user)
	return

/obj/machinery/door/veryblastdoor/try_to_activate_door(mob/user)
	return

/obj/machinery/door/veryblastdoor/emp_act(severity)
	return

/obj/machinery/door/veryblastdoor/ex_act(severity, target)
	return

/obj/machinery/card_button
	name = "Картоприёмник"
	desc = "Используется для открытия чего-то."
	icon = 'white/valtos/icons/dz-031.dmi'
	icon_state = "cardbutton"
	power_channel = AREA_USAGE_ENVIRON
	var/id = null
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	use_power = NO_POWER_USE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/obj/item/assembly/device

/obj/machinery/card_button/trader
	id = "trador1"
	req_access = list(ACCESS_TRADER)

/obj/machinery/card_button/trader/extension
	id = "trador_ex"
	req_access = list(ACCESS_TRADER_EX)

/obj/machinery/card_button/Initialize(mapload)
	. = ..()
	if(!device)
		var/obj/item/assembly/control/veryblastdoor/C = new(src)
		C.sync_doors = TRUE
		device = C
	if(id && istype(device, /obj/item/assembly/control/veryblastdoor))
		var/obj/item/assembly/control/veryblastdoor/A = device
		A.id = id

/obj/machinery/card_button/attackby(obj/item/W, mob/user, params)
	if(isidcard(W))
		playsound(src, 'white/valtos/sounds/dz/cardin.ogg', 60, TRUE)
		if(check_access(W))
			spawn(10)
				if(device)
					device.pulsed()
				say("Доступ разрешён.")
				SEND_GLOBAL_SIGNAL(COMSIG_GLOB_BUTTON_PRESSED,src)
				return
		else
			spawn(10)
				say("Доступ запрещён.")

	if(W.tool_behaviour == TOOL_SCREWDRIVER)
		to_chat(user, span_warning("Вставляю отвёртку в картоприёмник..."))
		playsound(src, 'white/valtos/sounds/dz/cardin.ogg', 60, TRUE)
		if(isliving(user))
			var/mob/living/L = user
			L.electrocute_act(10, src)
		say("Доступ НЕ разрешён.")
		flick("[icon_state]_deny", src)
		return

	if(user.a_intent != INTENT_HARM && !(W.item_flags & NOBLUDGEON))
		return attack_hand(user)
	else
		return ..()

/obj/machinery/card_button/emag_act(mob/user)
	playsound(src, "sparks", 100, TRUE)
	return

/obj/machinery/card_button/attack_ai(mob/user)
	return

/obj/machinery/card_button/attack_robot(mob/user)
	return

/obj/item/assembly/control/veryblastdoor
	name = "veryblastdoor controller"
	desc = "A small electronic device able to control a veryblastdoor remotely."
	icon_state = "control"

/obj/item/assembly/control/veryblastdoor/activate()
	var/openclose
	if(cooldown)
		return
	cooldown = TRUE
	for(var/obj/machinery/door/veryblastdoor/M in GLOB.machines)
		if(M.id == src.id)
			if(openclose == null || !sync_doors)
				openclose = M.density
			playsound(src, 'white/valtos/sounds/dz/ping.ogg', 30, TRUE)
			INVOKE_ASYNC(M, openclose ? /obj/machinery/door/veryblastdoor.proc/open : /obj/machinery/door/veryblastdoor.proc/close)
	addtimer(VARSET_CALLBACK(src, cooldown, FALSE), 30)

/*
/datum/map_template/cyberspess
	name = "Киберпространство"
	var/description = "Ебани с локтя тому, кто забыл добавить описание."
	var/dif = 1
	keep_cached_map = TRUE

/datum/map_template/cyberspess/rospilovo
	name = "Миссия \"Гоп-стоп\""
	description = "У кого-то сегодня будет выбор."
	dif = 1
	mappath = '_maps/map_files/protocol_c/dz/rospilovo_ch1.dmm'
*/

/obj/machinery/cyberdeck
	name = "кибердека"
	desc = "Пока не завершена. Описание могут видеть только педали или те, кто прямо сейчас читает этот текст."
	icon = 'white/valtos/icons/dz-031.dmi'
	icon_state = "cyberpod"
	occupant_typecache = list(/mob/living/carbon/human)
	light_color = LIGHT_COLOR_CYAN
	//var/mob/living/carbon/human/virtual_reality/vr_human

/obj/machinery/cyberdeck/Initialize()
	. = ..()
	set_light(1)

/obj/machinery/cyberdeck/examine(mob/user)
	if(user.client && !user.client.holder) // прикол
		to_chat(user, "Не-а.")
		qdel(user.client)
		return FALSE
	. = ..()

/obj/effect/turf_decal/dz031
	icon = 'white/valtos/icons/dz-031.dmi'

/obj/effect/turf_decal/dz031/grid
	icon_state = "grid"

/obj/effect/turf_decal/dz031/grid_full
	icon_state = "grid_center"

/obj/effect/temp_visual/soundwave
	name = "звук"
	icon = 'white/valtos/icons/sw.dmi'
	icon_state = "wave"
	duration = 6
	randomdir = FALSE

/obj/structure/sign/decksign
	name = "дисплей"
	desc = "Покажет какой здесь этаж. Да?"
	icon = 'white/valtos/icons/decksign.dmi'
	icon_state = "sign"
	light_color = LIGHT_COLOR_ORANGE
	var/cur_deck = 0

/obj/structure/sign/decksign/Initialize()
	. = ..()
	add_overlay("deck-[cur_deck]")

/obj/structure/sign/decksign/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_MULTITOOL)
		if(icon_state == "sign")
			icon_state = "sign-off"
			set_light(0)
			cut_overlays()
			playsound(get_turf(src), I.usesound, 60)
		else
			var/inset = input(user, "Какой этаж это тогда?", "Ммм?", "0") as num|null
			if(!inset)
				return
			cur_deck = inset
			icon_state = "sign"
			set_light(1)
			add_overlay("deck-[cur_deck]")
			playsound(get_turf(src), I.usesound, 60)

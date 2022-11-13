
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

/turf/open/floor/dz/normal/Initialize(mapload)
	..()
	return INITIALIZE_HINT_LATELOAD

/turf/open/floor/dz/normal/LateInitialize()
	. = ..()
	AddElement(/datum/element/turf_z_transparency)

/turf/open/floor/dz/green
	name = "пол"
	icon_state = "green1"

/turf/open/floor/dz/green/Initialize(mapload)
	. = ..()
	icon_state = "green[rand(1, 6)]"

/turf/open/floor/dz/trippy_green
	name = "ПОЛ"
	icon_state = "green8"

/turf/open/floor/dz/cyber
	name = "си-пол"
	icon_state = "c_floor"

/turf/open/floor/dz/cyber/Initialize(mapload)
	..()
	return INITIALIZE_HINT_LATELOAD

/turf/open/floor/dz/cyber/LateInitialize()
	. = ..()
	AddElement(/datum/element/turf_z_transparency)

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

/turf/closed/dz/normal/cyber/Initialize(mapload)
	. = ..()
	if(prob(0.1))
		icon_state = "c_wall3"
		density = 0
	else if(prob(1))
		icon_state = "c_wall2"
		dir = pick(GLOB.cardinals)
	return INITIALIZE_HINT_LATELOAD

/turf/closed/dz/normal/cyber/LateInitialize()
	. = ..()
	AddElement(/datum/element/turf_z_transparency, _ignore_closed_turf_shit = TRUE)

/turf/closed/dz/normal/cyber/ice
	name = "лёд"
	icon_state = "ice"
	var/money_to_adjust = 0

/turf/closed/dz/normal/cyber/ice/attack_hand(mob/user)
	. = ..()
	if(isliving(user))
		melt_ice(user)

/turf/closed/dz/normal/cyber/ice/bullet_act(obj/projectile/P, def_zone, piercing_hit)
	. = ..()
	if(P?.firer && isliving(P?.firer))
		melt_ice(P.firer)

/turf/closed/dz/normal/cyber/ice/proc/melt_ice(mob/living/user)
	playsound(src, 'white/valtos/sounds/rapidslice.ogg', 60, TRUE)

	var/obj/effect/dz/ice/IC = new /obj/effect/dz/ice(src)
	IC.old_type = type
	IC.color = color

	if(money_to_adjust)
		// прост даём или забираем бабло игрока
		var/datum/violence_player/VP = vp_get_player(user?.ckey)
		if(VP)
			VP.money += money_to_adjust
			to_chat(user, span_boldnotice("[money_to_adjust > 0 ? "+[money_to_adjust]" : "[money_to_adjust]"]₽"))

	ChangeTurf(/turf/open/floor/dz/cyber)

/turf/closed/dz/normal/cyber/ice/red
	name = "красный лёд"
	color = "#B34646"
	money_to_adjust = -25

/turf/closed/dz/normal/cyber/ice/red/melt_ice(mob/living/user)
	visible_message(span_warning("<b>[user]</b> уничтожает <b>[src]</b> и покрывается ссадинами!"), \
					span_userdanger("Уничтожаю <b>[src]</b> и... УХ БЛЯ!"))
	user.adjustBruteLoss(15)
	. = ..()

/turf/closed/dz/normal/cyber/ice/yellow
	name = "жёлтый лёд"
	color = "#AEA341"
	money_to_adjust = -25

/turf/closed/dz/normal/cyber/ice/yellow/melt_ice(mob/living/user)
	visible_message(span_warning("<b>[user]</b> уничтожает <b>[src]</b> и загорается!"), \
					span_userdanger("Уничтожаю <b>[src]</b> и... ЗАГОРАЮСЬ!"))
	user.adjust_fire_stacks(2)
	user.ignite_mob()
	. = ..()

/turf/closed/dz/normal/cyber/ice/green
	name = "зелёный лёд"
	color = "#55AC3F"
	money_to_adjust = -25

/turf/closed/dz/normal/cyber/ice/green/melt_ice(mob/living/user)
	visible_message(span_warning("<b>[user]</b> уничтожает <b>[src]</b> и покрывается кислотой!"), \
					span_userdanger("Уничтожаю <b>[src]</b> и... КИСЛОТА-А-А!"))
	user.acid_act(100, 200)
	. = ..()

/turf/closed/dz/normal/cyber/ice/black
	name = "чёрный лёд"
	color = "#222222"
	money_to_adjust = -25

/turf/closed/dz/normal/cyber/ice/black/melt_ice(mob/living/user)
	visible_message(span_warning("<b>[user]</b> уничтожает <b>[src]</b> и засыпает!"), \
					span_userdanger("Уничтожаю <b>[src]</b> и засыпаю..."))
	user.AdjustSleeping(3 SECONDS)
	. = ..()

/turf/closed/dz/normal/cyber/ice/blue
	name = "синий лёд"
	color = "#4684B3"
	money_to_adjust = 25

/obj/effect/dz
	density = FALSE
	anchored = TRUE
	invisibility = INVISIBILITY_OBSERVER
	alpha = 100
	resistance_flags = INDESTRUCTIBLE

GLOBAL_LIST_EMPTY(hacked_ice)

/obj/effect/dz/ice
	name = "взломанный лёд"
	icon_state = "ice"
	icon = 'white/valtos/icons/dz-031.dmi'
	var/old_type = null

/obj/effect/dz/ice/Initialize(mapload)
	. = ..()
	GLOB.hacked_ice += src

/obj/effect/dz/ice/Destroy(force)
	GLOB.hacked_ice -= src
	. = ..()

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
	plane = GAME_PLANE_UPPER

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
	plane = GAME_PLANE_UPPER
	anchored = TRUE
	var/what_pic = "anonist"

/obj/lab_monitor/attacked_by(obj/item/I, mob/living/user)
	if(. && I.force > 5)
		icon_state = "monitor_cracked"
	return ..()

/obj/lab_monitor/Initialize(mapload)
	. = ..()
	add_overlay(what_pic)

/obj/effect/attack_spike
	name = "ОПАСНОСТЬ"
	icon = 'white/valtos/icons/dz-031.dmi'
	icon_state = "attention"

/obj/effect/attack_spike/Initialize(mapload)
	. = ..()
	INVOKE_ASYNC(src, .proc/do_attack_sequence)

/obj/effect/attack_spike/proc/do_attack_sequence()
	sleep(10)
	icon_state = "spike_hole"

	sleep(10)
	flick("spike_strike", src)
	var/latched = FALSE
	for(var/mob/living/L in loc)
		visible_message(span_danger("Стержень жёстко пробивает тушку <b>[L]</b>!"))
		L.apply_damage_type(50, BRUTE)
		var/turf/T = get_turf(src)
		new /obj/effect/decal/cleanable/blood(T)
		playsound(T, 'sound/effects/wounds/pierce3.ogg', 50, 1)
		latched = TRUE

	sleep(2.2)
	if(latched)
		flick("spike_bloody_retract", src)
	else
		flick("spike_retract", src)

	sleep(5)
	icon_state = "spike_hole"

	sleep(5)
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
	can_open_with_hands = FALSE
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
	playsound(src, "zap", 100, TRUE)
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

/obj/machinery/cyberdeck/Initialize(mapload)
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

/obj/structure/sign/decksign/Initialize(mapload)
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

/obj/effect/temp_visual/dz_effects
	name = "???"
	icon = 'white/valtos/icons/dz-031.dmi'
	icon_state = "node"
	plane = POINT_PLANE
	duration = 10
	randomdir = FALSE

/obj/effect/temp_visual/dz_effects/arrow_red
	icon_state = "arrow_red"

/obj/effect/temp_visual/dz_effects/arrow_green
	icon_state = "arrow_green"

/obj/effect/temp_visual/dz_effects/top
	icon_state = "arrow_top"

/obj/effect/temp_visual/dz_effects/attention
	duration = 30
	icon_state = "danger"

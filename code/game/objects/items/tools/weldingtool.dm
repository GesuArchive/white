/// How many seconds between each fuel depletion tick ("use" proc)
#define WELDER_FUEL_BURN_INTERVAL 26
/obj/item/weldingtool
	name = "сварочный аппарат"
	desc = "Сварка стандартного исполнения, предоставленная компанией NanoTrasen."
	icon = 'icons/obj/tools.dmi'
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	icon_state = "welder"
	inhand_icon_state = "welder"
	worn_icon_state = "welder"
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	force = 3
	throwforce = 5
	hitsound = "swing_hit"
	usesound = list('sound/items/welder.ogg', 'sound/items/welder2.ogg')
	drop_sound = 'sound/items/handling/weldingtool_drop.ogg'
	pickup_sound =  'sound/items/handling/weldingtool_pickup.ogg'
	light_system = MOVABLE_LIGHT
	light_range = 2
	light_power = 0.75
	light_color = LIGHT_COLOR_FIRE
	light_on = FALSE
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 30)
	resistance_flags = FIRE_PROOF
	heat = 3800
	tool_behaviour = TOOL_WELDER
	toolspeed = 1
	wound_bonus = 10
	bare_wound_bonus = 15
	custom_materials = list(/datum/material/iron=70, /datum/material/glass=30)
	///Whether the welding tool is on or off.
	var/welding = FALSE
	var/status = TRUE 		//Whether the welder is secured or unsecured (able to attach rods to it to make a flamethrower)
	var/max_fuel = 20 	//The max amount of fuel the welder can hold
	var/change_icons = 1
	var/can_off_process = 0
	var/burned_fuel_for = 0	//when fuel was last removed
	gender = FEMALE
	var/acti_sound = 'sound/items/welderactivate.ogg'
	var/deac_sound = 'sound/items/welderdeactivate.ogg'

/obj/item/weldingtool/Initialize(mapload)
	. = ..()
	create_reagents(max_fuel)
	reagents.add_reagent(/datum/reagent/fuel, max_fuel)
	update_icon()

/obj/item/weldingtool/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	AddElement(/datum/element/tool_flash, light_range)

/obj/item/weldingtool/update_icon_state()
	if(welding)
		inhand_icon_state = "[initial(inhand_icon_state)]1"
	else
		inhand_icon_state = "[initial(inhand_icon_state)]"


/obj/item/weldingtool/update_overlays()
	. = ..()
	if(change_icons)
		var/ratio = get_fuel() / max_fuel
		ratio = CEILING(ratio*4, 1) * 25
		. += "[initial(icon_state)][ratio]"
	if(welding)
		. += "[initial(icon_state)]-on"


/obj/item/weldingtool/process(delta_time)
	switch(welding)
		if(0)
			force = 3
			damtype = BRUTE
			update_icon()
			if(!can_off_process)
				SEND_SIGNAL(src, COMSIG_UPDATE_AMMO_HUD)
				STOP_PROCESSING(SSobj, src)
			return
	//Welders left on now use up fuel, but lets not have them run out quite that fast
		if(1)
			force = 15
			damtype = BURN
			burned_fuel_for += delta_time
			if(burned_fuel_for >= WELDER_FUEL_BURN_INTERVAL)
				use(1)
			SEND_SIGNAL(src, COMSIG_UPDATE_AMMO_HUD)
			update_icon()

	//This is to start fires. process() is only called if the welder is on.
	open_flame()


/obj/item/weldingtool/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] welds [user.ru_ego()] every orifice closed! It looks like [user.p_theyre()] trying to commit suicide!"))
	return (FIRELOSS)


/obj/item/weldingtool/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		flamethrower_screwdriver(I, user)
	else if(istype(I, /obj/item/stack/rods))
		flamethrower_rods(I, user)
	else
		. = ..()
	update_icon()

/obj/item/weldingtool/proc/explode()
	var/plasmaAmount = reagents.get_reagent_amount(/datum/reagent/toxin/plasma)
	dyn_explosion(src, plasmaAmount/5, explosion_cause = src)//20 plasma in a standard welder has a 4 power explosion. no breaches, but enough to kill/dismember holder
	qdel(src)

/obj/item/weldingtool/use_tool(atom/target, mob/living/user, delay, amount, volume, datum/callback/extra_checks)
	var/mutable_appearance/sparks = mutable_appearance('icons/effects/welding_effect.dmi', "welding_sparks", GASFIRE_LAYER, src, ABOVE_LIGHTING_PLANE)
	target.add_overlay(sparks)
	LAZYADD(update_overlays_on_z, sparks)
	. = ..()
	LAZYREMOVE(update_overlays_on_z, sparks)
	target.cut_overlay(sparks)

/obj/item/weldingtool/attack(mob/living/carbon/human/H, mob/user)
	if(!istype(H))
		return ..()

	var/obj/item/bodypart/affecting = H.get_bodypart(check_zone(user.zone_selected))

	if(affecting && affecting.status == BODYPART_ROBOTIC && user.a_intent != INTENT_HARM)
		if(src.use_tool(H, user, 0, volume=50, amount=1))
			if(user == H)
				user.visible_message(span_notice("[user] начинает чинить вмятины [H] на [ru_exam_parse_zone(affecting.name)].") ,
					span_notice("Начинаю чинить вмятины [H == user ? "своей" : "[H]"] на [ru_exam_parse_zone(affecting.name)]."))
				if(!do_mob(user, H, 50))
					return
			item_heal_robotic(H, user, 15, 0)
	else
		return ..()

/obj/item/weldingtool/afterattack(atom/O, mob/user, proximity)
	. = ..()
	if(!proximity)
		return

	if(isOn())
		handle_fuel_and_temps(1, user)

		if(!QDELETED(O) && isliving(O)) // can't ignite something that doesn't exist
			var/mob/living/L = O
			if(L.ignite_mob())
				message_admins("[ADMIN_LOOKUPFLW(user)] set [key_name_admin(L)] on fire with [src] at [AREACOORD(user)]")
				log_game("[key_name(user)] set [key_name(L)] on fire with [src] at [AREACOORD(user)]")

	if(!status && O.is_refillable())
		reagents.trans_to(O, reagents.total_volume, transfered_by = user)
		to_chat(user, span_notice("Опустошаю топливный бак [src] в [O]."))
		update_icon()

/obj/item/weldingtool/attack_qdeleted(atom/O, mob/user, proximity)
	. = ..()
	if(!proximity)
		return

	if(isOn())
		handle_fuel_and_temps(1, user)

		if(!QDELETED(O) && isliving(O)) // can't ignite something that doesn't exist
			var/mob/living/L = O
			if(L.ignite_mob())
				message_admins("[ADMIN_LOOKUPFLW(user)] set [key_name_admin(L)] on fire with [src] at [AREACOORD(user)]")
				log_game("[key_name(user)] set [key_name(L)] on fire with [src] at [AREACOORD(user)]")


/obj/item/weldingtool/attack_self(mob/user)
	if(src.reagents.has_reagent(/datum/reagent/toxin/plasma))
		message_admins("[ADMIN_LOOKUPFLW(user)] activated a rigged welder at [AREACOORD(user)].")
		explode()
	switched_on(user)

	update_icon()


// Ah fuck, I can't believe you've done this
/obj/item/weldingtool/proc/handle_fuel_and_temps(used = 0, mob/living/user)
	use(used)
	var/turf/location = get_turf(user)
	location.hotspot_expose(700, 50, 1)

// Returns the amount of fuel in the welder
/obj/item/weldingtool/proc/get_fuel()
	return reagents.get_reagent_amount(/datum/reagent/fuel)


// Uses fuel from the welding tool.
/obj/item/weldingtool/use(used = 0)
	if(!isOn() || !check_fuel())
		return FALSE

	if(used > 0)
		burned_fuel_for = 0

	if(get_fuel() >= used)
		reagents.remove_reagent(/datum/reagent/fuel, used)
		check_fuel()
		return TRUE
	else
		return FALSE


//Toggles the welding value.
/obj/item/weldingtool/proc/set_welding(new_value)
	if(welding == new_value)
		return
	. = welding
	welding = new_value
	set_light_on(welding)

	SEND_SIGNAL(src, COMSIG_UPDATE_AMMO_HUD)


//Turns off the welder if there is no more fuel (does this really need to be its own proc?)
/obj/item/weldingtool/proc/check_fuel(mob/user)
	if(get_fuel() <= 0 && welding)
		set_light_on(FALSE)
		switched_on(user)
		update_icon()
		return FALSE
	return TRUE

//Switches the welder on
/obj/item/weldingtool/proc/switched_on(mob/user)
	if(!status)
		to_chat(user, span_warning("Надо бы закрутить обратно всё в [src]!"))
		return
	set_welding(!welding)
	if(welding)
		if(get_fuel() >= 1)
			to_chat(user, span_notice("Включаю [skloname(src.name, VINITELNI, src.gender)]."))
			playsound(loc, acti_sound, 50, TRUE)
			force = 15
			damtype = BURN
			hitsound = 'sound/items/welder.ogg'
			update_icon()
			START_PROCESSING(SSobj, src)
		else
			to_chat(user, span_warning("Мало топлива!"))
			switched_off(user)
	else
		to_chat(user, span_notice("Выключаю [skloname(src.name, VINITELNI, src.gender)]."))
		playsound(loc, deac_sound, 50, TRUE)
		switched_off(user)

//Switches the welder off
/obj/item/weldingtool/proc/switched_off(mob/user)
	set_welding(FALSE)

	force = 3
	damtype = BRUTE
	hitsound = "swing_hit"
	update_icon()


/obj/item/weldingtool/examine(mob/user)
	. = ..()
	. += "<hr>"
	. += "Здесь примерно [get_fuel()] единиц топлива из максимальных [max_fuel]."

/obj/item/weldingtool/get_temperature()
	return welding * heat

//Returns whether or not the welding tool is currently on.
/obj/item/weldingtool/proc/isOn()
	return welding

// If welding tool ran out of fuel during a construction task, construction fails.
/obj/item/weldingtool/tool_use_check(mob/living/user, amount)
	if(!isOn() || !check_fuel())
		to_chat(user, span_warning("Надо бы включить [skloname(src.name, VINITELNI, src.gender)]!"))
		return FALSE

	if(get_fuel() >= amount)
		return TRUE
	else
		to_chat(user, span_warning("Нужно больше топлива для этой задачи!"))
		return FALSE


/obj/item/weldingtool/proc/flamethrower_screwdriver(obj/item/I, mob/user)
	if(welding)
		to_chat(user, span_warning("Надо бы выключить!"))
		return
	status = !status
	if(status)
		to_chat(user, span_notice("Собираю обратно [skloname(src.name, VINITELNI, src.gender)]."))
		reagents.flags &= ~(OPENCONTAINER)
	else
		to_chat(user, span_notice("Теперь можно модифицировать [skloname(src.name, VINITELNI, src.gender)]."))
		reagents.flags |= OPENCONTAINER
	add_fingerprint(user)

/obj/item/weldingtool/proc/flamethrower_rods(obj/item/I, mob/user)
	if(!status)
		var/obj/item/stack/rods/R = I
		if (R.use(1))
			var/obj/item/flamethrower/F = new /obj/item/flamethrower(user.loc)
			if(!remove_item_from_storage(F))
				user.transferItemToLoc(src, F, TRUE)
			F.weldtool = src
			add_fingerprint(user)
			to_chat(user, span_notice("Добавляю пруток к сварке и начинаю делать огнемёт."))
			user.put_in_hands(F)
		else
			to_chat(user, span_warning("Надо бы больше прутков!"))

/obj/item/weldingtool/ignition_effect(atom/A, mob/user)
	if(use_tool(A, user, 0, amount=1))
		return span_notice("[user] классически поджигает [skloname(A.name, VINITELNI, A.gender)] используя [skloname(src.name, VINITELNI, src.gender)], какой крутой засранец.")
	else
		return ""

/obj/item/weldingtool/largetank
	name = "индустриальный сварочный аппарат"
	desc = "Сварочный аппарат немного большего размера с большим баком."
	icon_state = "indwelder"
	max_fuel = 40
	custom_materials = list(/datum/material/glass=60)

/obj/item/weldingtool/largetank/flamethrower_screwdriver()
	return

/obj/item/weldingtool/largetank/cyborg
	name = "интегрированный сварочный аппарат"
	desc = "Усовершенствованный сварочный аппарат, предназначенный для использования в роботизированных системах. Специальная рамка удваивает скорость сварки."
	icon = 'white/Feline/icons/cyber_arm_tools.dmi'
	icon_state = "indwelder_cyborg"
	toolspeed = 0.5

/obj/item/weldingtool/largetank/cyborg/cyborg_unequip(mob/user)
	if(!isOn())
		return
	switched_on(user)


/obj/item/weldingtool/mini
	name = "аварийный сварочный аппарат"
	desc = "Миниатюрный сварочный аппарат, используемый в чрезвычайных ситуациях."
	icon_state = "miniwelder"
	inhand_icon_state = "miniwelder"
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	max_fuel = 10
	w_class = WEIGHT_CLASS_TINY
	custom_materials = list(/datum/material/iron=30, /datum/material/glass=10)
	change_icons = FALSE

/obj/item/weldingtool/mini/flamethrower_screwdriver()
	return

/obj/item/weldingtool/abductor
	name = "инопланетная сварка"
	desc = "Инопланетный сварочный инструмент. Какое бы топливо он ни использовал, оно у него никогда не заканчивается."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "welder"
	toolspeed = 0.1
	light_system = NO_LIGHT_SUPPORT
	light_range = 0
	change_icons = FALSE

/obj/item/weldingtool/abductor/process()
	if(get_fuel() <= max_fuel)
		reagents.add_reagent(/datum/reagent/fuel, 1)
	..()

/obj/item/weldingtool/hugetank
	name = "модернизированный сварочный аппарат"
	desc = "Модернизированная сварка на базе промышленного сварщика."
	icon_state = "upindwelder"
	inhand_icon_state = "upindwelder"
	max_fuel = 80
	custom_materials = list(/datum/material/iron=70, /datum/material/glass=120)

/obj/item/weldingtool/experimental
	name = "экспериментальный сварочный аппарат"
	desc = "Экспериментальный сварочный аппарат, способный самостоятельно генерировать топливо и менее вредный для глаз."
	icon_state = "exwelder"
	inhand_icon_state = "exwelder"
	max_fuel = 40
	custom_materials = list(/datum/material/iron=70, /datum/material/glass=120)
	change_icons = 0
	can_off_process = 1
	light_range = 1
	toolspeed = 0.5
	var/last_gen = 0
	var/nextrefueltick = 0

/obj/item/weldingtool/experimental/process()
	..()
	if(get_fuel() < max_fuel && nextrefueltick < world.time)
		nextrefueltick = world.time + 10
		reagents.add_reagent(/datum/reagent/fuel, 1)

#undef WELDER_FUEL_BURN_INTERVAL

/obj/structure/reagent_dispensers/bath
	name = "ванна"
	desc = "Старая чугунная ванна. Ничего особенного."
	icon = 'white/nocringe/icons/bath.dmi'
	icon_state = "bath_empty"
	density = TRUE
	anchored = TRUE
	reagent_id = /datum/reagent/water
	tank_volume = 14000
	leaking = FALSE
	amount_to_leak = 50

/obj/structure/reagent_dispensers/bath/Initialize(mapload)
	var/_liquid = list(
		/datum/reagent/water,
		/datum/reagent/consumable/ethanol,
		/datum/reagent/consumable/ethanol/vodka,
		/datum/reagent/consumable/ethanol/boyarka,
		/datum/reagent/consumable/ethanol/beer,
		/datum/reagent/toxin/fakebeer
	)
	var/num = rand(1, 6)
	create_reagents(tank_volume)
	reagent_id = _liquid[num]
	reagents.add_reagent(_liquid[num], 14000)
	switch(num)
		if(1)
			desc = "Старая чугунная ванна. Кажется, она наполнена водой."
			icon_state = "bath_water"
		if(2)
			desc = "Старая чугунная ванна. От жидкости в ней несёт спиртом."
			icon_state = "bath_vodka"
		if(3)
			desc = "Старая чугунная ванна. От жидкости в ней несёт спиртом."
			icon_state = "bath_vodka"
		if(4)
			desc = "Старая чугунная ванна. От жидкости в ней пахнет бомжом..."
			icon_state = "bath_RND"
		if(5)
			desc = "Старая чугунная ванна. ДА ЭТО ЖЕ ВАННА ПИВА!!!"
			icon_state = "bath_beer"
		if(6)
			desc = "Старая чугунная ванна. Запах жидкости очень напоминает вам то, что бармен называет пивом..."
			icon_state = "bath_fake_beer"
		else
			desc = "Если ты это видишь, то кодер обосрался."
			icon_state = "bath_shit"
	. = ..()

/obj/structure/reagent_dispensers/bath/proc/bath_leak()
	if(leaking && reagents && reagents.total_volume >= amount_to_leak)
		reagents.expose(get_turf(src), TOUCH, amount_to_leak / max(amount_to_leak, reagents.total_volume))
		reagents.remove_reagent(reagent_id, amount_to_leak)
		return TRUE
	return FALSE


/obj/structure/reagent_dispensers/bath/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	. = ..()
	if(leaking)
		bath_leak()

/obj/structure/reagent_dispensers/bath/wrench_act(mob/living/user, obj/item/tool)
	if(tool.tool_behaviour == TOOL_WRENCH)
		if(isinspace() && !anchored)
			return
		set_anchored(!anchored)
		leaking = !leaking
		tool.play_tool_sound(src, 75)
		user.visible_message(span_notice("<b>[user]</b> [anchored ? "прикручивает" : "откручивает"] <b>ванну</b> [anchored ? "к полу" : "от пола"].") , \
						span_notice("[anchored ? "Прикручиваю" : "Откручиваю"] <b>ванну</b> [anchored ? "к полу" : "от пола"].") , \
						span_hear("Слышу трещотку."))
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/structure/reagent_dispensers/bath/examine(mob/user)
	. = ..()


/obj/machinery/coffeemaker
	name = "кофеварка"
	desc = "Кофеварка Modello 3, которая варит кофе и поддерживает его идеальную температуру 176 градусов по Фаренгейту. Изготовлена компанией Piccionaia Home Appliances."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "coffeemaker_nopot_nocart"
	base_icon_state = "coffeemaker"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	circuit = /obj/item/circuitboard/machine/coffeemaker
	pixel_y = 4 //needed to make it sit nicely on tables
	var/obj/item/reagent_containers/glass/coffeepot/coffeepot = null
	var/brewing = FALSE
	var/brew_time = 20 SECONDS
	var/speed = 1
	/// The coffee cartridge to make coffee from. In the future, coffee grounds are like printer ink.
	var/obj/item/coffee_cartridge/cartridge = null
	/// The type path to instantiate for the coffee cartridge the device initially comes with, eg. /obj/item/coffee_cartridge
	var/initial_cartridge = /obj/item/coffee_cartridge
	/// The number of cups left
	var/coffee_cups = 20
	/// The amount of sugar packets left
	var/sugar_packs = 20
	/// The amount of sweetener packets left
	var/sweetener_packs = 20
	/// The amount of creamer packets left
	var/creamer_packs = 20

	var/static/radial_examine = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_examine")
	var/static/radial_brew = image(icon = 'icons/hud/radial_coffee.dmi', icon_state = "radial_brew")
	var/static/radial_eject_pot = image(icon = 'icons/hud/radial_coffee.dmi', icon_state = "radial_eject_pot")
	var/static/radial_eject_cartridge = image(icon = 'icons/hud/radial_coffee.dmi', icon_state = "radial_eject_cartridge")
	var/static/radial_take_cup = image(icon = 'icons/hud/radial_coffee.dmi', icon_state = "radial_take_cup")
	var/static/radial_take_sugar = image(icon = 'icons/hud/radial_coffee.dmi', icon_state = "radial_take_sugar")
	var/static/radial_take_sweetener = image(icon = 'icons/hud/radial_coffee.dmi', icon_state = "radial_take_sweetener")
	var/static/radial_take_creamer = image(icon = 'icons/hud/radial_coffee.dmi', icon_state = "radial_take_creamer")

/obj/machinery/coffeemaker/Initialize(mapload)
	. = ..()
	if(mapload)
		coffeepot = new /obj/item/reagent_containers/glass/coffeepot(src)
		cartridge = new /obj/item/coffee_cartridge(src)

/obj/machinery/coffeemaker/deconstruct()
	coffeepot?.forceMove(drop_location())
	cartridge?.forceMove(drop_location())
	return ..()

/obj/machinery/coffeemaker/Destroy()
	QDEL_NULL(coffeepot)
	QDEL_NULL(cartridge)
	return ..()

/obj/machinery/coffeemaker/Exited(atom/movable/gone, direction)
	if(gone == coffeepot)
		coffeepot = null
	if(gone == cartridge)
		cartridge = null
	return ..()

/obj/machinery/coffeemaker/RefreshParts()
	. = ..()
	speed = 0
	for(var/obj/item/stock_parts/micro_laser/laser in component_parts)
		speed += laser.rating

/obj/machinery/coffeemaker/examine(mob/user)
	. = ..()
	if(!in_range(user, src) && !issilicon(user) && !isobserver(user))
		. += "<hr>[span_warning("Слишком далеко, чтобы рассмотреть кофеварку!")]"
		return

	if(brewing)
		. += "<hr>[span_warning("[capitalize(src)] работает.")]"
		return

	if(panel_open)
		. += span_notice("Техническая панель кофеварки открыта!")
		return

	if(coffeepot || cartridge)
		. += "<hr>[span_notice("Внутри кофеварки:")]"
		if(coffeepot)
			. += span_notice("\n- [coffeepot].")
		if(cartridge)
			. += span_notice("\n- [cartridge].")

	if(!(machine_stat & (NOPOWER|BROKEN)))
		. += "<hr>[span_notice("На дисплее отображается:")]\n"+\
		span_notice("- Варка кофе со скоростью <b>[speed*100]%</b>.")
		if(coffeepot)
			for(var/datum/reagent/consumable/cawfee as anything in coffeepot.reagents.reagent_list)
				. += span_notice("\n- [cawfee.volume] юнитов кофе в кофейнике.")
		if(cartridge)
			if(cartridge.charges < 1)
				. += span_notice("\n- картридж пуст.")
			else
				. += span_notice("\n- картриджа хватит, чтобы сварить кофе еще [cartridge.charges] раз.")

	if (coffee_cups >= 1)
		. += span_notice("\nЧашек для кофе - [coffee_cups]")
	else
		. += span_notice("\nЧашки для кофе закончились.")

	if (sugar_packs >= 1)
		. += span_notice("\nУпаковок сахара - [sugar_packs]")
	else
		. += span_notice("\nСахар закончился.")

	if (sweetener_packs >= 1)
		. += span_notice("\nУпаковок сахарозаменителя - [sweetener_packs]")
	else
		. += span_notice("\nСахарозаменитель закончился.")

	if (creamer_packs > 1)
		. += span_notice("\nУпаковок сливок - [creamer_packs]")
	else
		. += span_notice("\nСливки закончились.")

/obj/machinery/coffeemaker/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(!can_interact(user) || !user.canUseTopic(src, !issilicon(user), FALSE, no_tk = TRUE))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(brewing)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	replace_pot(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/coffeemaker/attack_robot_secondary(mob/user, list/modifiers)
	return attack_hand_secondary(user, modifiers)

/obj/machinery/coffeemaker/attack_ai_secondary(mob/user, list/modifiers)
	return attack_hand_secondary(user, modifiers)

/obj/machinery/coffeemaker/handle_atom_del(atom/A)
	. = ..()
	if(A == coffeepot)
		coffeepot = null
	if(A == cartridge)
		cartridge = null
	update_appearance()

/obj/machinery/coffeemaker/update_icon_state()
	icon_state = "[base_icon_state][coffeepot ? "_pot" : "_nopot"][cartridge ? "_cart": "_nocart"]"
	return ..()

/obj/machinery/coffeemaker/proc/replace_pot(mob/living/user, obj/item/reagent_containers/glass/coffeepot/new_coffeepot)
	if(!user)
		return FALSE
	if(coffeepot)
		try_put_in_hand(coffeepot, user)
	if(new_coffeepot)
		coffeepot = new_coffeepot
	update_appearance()
	return TRUE

/obj/machinery/coffeemaker/proc/replace_cartridge(mob/living/user, obj/item/coffee_cartridge/new_cartridge)
	if(!user)
		return FALSE
	if(cartridge)
		try_put_in_hand(cartridge, user)
	if(new_cartridge)
		cartridge = new_cartridge
	update_appearance()
	return TRUE

/obj/machinery/coffeemaker/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/coffeemaker/attackby(obj/item/attack_item, mob/living/user, params)
	//You can only screw open empty grinder
	if(!coffeepot && default_deconstruction_screwdriver(user, icon_state, icon_state, attack_item))
		return

	if(default_deconstruction_crowbar(attack_item))
		return

	if(panel_open) //Can't insert objects when its screwed open
		return TRUE

	if (istype(attack_item, /obj/item/reagent_containers/glass/coffeepot) && !(attack_item.item_flags & ABSTRACT) && attack_item.is_open_container())
		var/obj/item/reagent_containers/glass/coffeepot/new_pot = attack_item
		. = TRUE //no afterattack
		if(!user.transferItemToLoc(new_pot, src))
			return TRUE
		replace_pot(user, new_pot)
		balloon_alert(user, "устанавливаю кофейник.")
		update_appearance()
		return TRUE //no afterattack

	if (istype(attack_item, /obj/item/coffee_cartridge) && !(attack_item.item_flags & ABSTRACT))
		var/obj/item/coffee_cartridge/new_cartridge = attack_item
		. = TRUE //no afterattack
		if(!user.transferItemToLoc(new_cartridge, src))
			return TRUE
		replace_cartridge(user, new_cartridge)
		balloon_alert(user, "устанавливаю картридж.")
		update_appearance()
		return TRUE //no afterattack

/obj/machinery/coffeemaker/ui_interact(mob/user) // The microwave Menu //I am reasonably certain that this is not a microwave //I am positively certain that this is not a microwave
	. = ..()

	if(brewing || !user.canUseTopic(src, !issilicon(user)))
		return

	var/list/options = list()

	if(coffeepot)
		options["Достать кофейник"] = radial_eject_pot

	if(cartridge)
		options["Достать картридж"] = radial_eject_cartridge

	if(coffeepot && cartridge && cartridge.charges > 0)
		options["Сварить"] = radial_brew

	if(coffee_cups > 0)
		options["Взять чашку"] = radial_take_cup

	if(sugar_packs > 0)
		options["Взять сахар"] = radial_take_sugar

	if(sweetener_packs > 0)
		options["Взять сахарозаменитель"] = radial_take_sweetener

	if(creamer_packs > 0)
		options["Взять сливки"] = radial_take_creamer

	if(isAI(user))
		if(machine_stat & NOPOWER)
			return
		options["Осмотреть"] = radial_examine

	var/choice

	if(length(options) < 1)
		return
	if(length(options) == 1)
		choice = options[1]
	else
		choice = show_radial_menu(user, src, options, require_near = !issilicon(user))

	// post choice verification
	if(brewing || (isAI(user) && machine_stat & NOPOWER) || !user.canUseTopic(src, !issilicon(user)))
		return

	switch(choice)
		if("Сварить")
			brew(user)
		if("Достать кофейник")
			eject_pot(user)
		if("Достать картридж")
			eject_cartridge(user)
		if("Осмотреть")
			examine(user)
		if("Взять чашку")
			take_cup(user)
		if("Взять сахар")
			take_sugar(user)
		if("Взять сахарозаменитель")
			take_sweetener(user)
		if("Взять сливки")
			take_creamer(user)

/obj/machinery/coffeemaker/proc/eject_pot(mob/user)
	if(coffeepot)
		replace_pot(user)

/obj/machinery/coffeemaker/proc/eject_cartridge(mob/user)
	if(cartridge)
		replace_cartridge(user)

/obj/machinery/coffeemaker/proc/take_cup(mob/user)
	if(!coffee_cups) //shouldn't happen, but we all know how stuff manages to break
		balloon_alert("чашки закончились!")
		return
	balloon_alert_to_viewers("берет чашку.")
	var/obj/item/reagent_containers/food/drinks/coffee_cup/new_cup = new(get_turf(src))
	user.put_in_hands(new_cup)
	coffee_cups--

/obj/machinery/coffeemaker/proc/take_sugar(mob/user)
	if(!sugar_packs)
		balloon_alert("сахар закончился!")
		return
	balloon_alert_to_viewers("берет пакетик сахара.")
	var/obj/item/reagent_containers/food/condiment/pack/sugar/new_pack = new(get_turf(src))
	user.put_in_hands(new_pack)
	sugar_packs--

/obj/machinery/coffeemaker/proc/take_sweetener(mob/user)
	if(!sweetener_packs)
		balloon_alert("сахарозаменитель закончился!")
		return
	balloon_alert_to_viewers("берет пакетик сахарозаменителя.")
	var/obj/item/reagent_containers/food/condiment/pack/astrotame/new_pack = new(get_turf(src))
	user.put_in_hands(new_pack)
	sweetener_packs--

/obj/machinery/coffeemaker/proc/take_creamer(mob/user)
	if(!creamer_packs)
		balloon_alert("сливки закончились!")
		return
	balloon_alert_to_viewers("берет пакетик сливок.")
	var/obj/item/reagent_containers/food/condiment/pack/creamer/new_pack = new(get_turf(src))
	user.put_in_hands(new_pack)
	creamer_packs--

///Updates the smoke state to something else, setting particles if relevant
/obj/machinery/coffeemaker/proc/toggle_steam()
	QDEL_NULL(particles)
	if(brewing)
		particles = new /particles/smoke/steam/mild()
		particles.position = list(-6, 0, 0)

/obj/machinery/coffeemaker/proc/operate_for(time, silent = FALSE)
	brewing = TRUE
	if(!silent)
		playsound(src, 'sound/machines/coffeemaker_brew.ogg', 20, vary = TRUE)
	toggle_steam()
	use_power(active_power_usage * time * 0.1) // .1 needed here to convert time (in deciseconds) to seconds such that watts * seconds = joules
	addtimer(CALLBACK(src, PROC_REF(stop_operating)), time / speed)

/obj/machinery/coffeemaker/proc/stop_operating()
	brewing = FALSE
	toggle_steam()

/obj/machinery/coffeemaker/proc/brew()
	power_change()
	if(!coffeepot || machine_stat & (NOPOWER|BROKEN) || coffeepot.reagents.total_volume >= coffeepot.reagents.maximum_volume)
		return
	operate_for(brew_time)
	coffeepot.reagents.add_reagent_list(cartridge.drink_type)
	cartridge.charges--

//Coffee Cartridges: like toner, but for your coffee!
/obj/item/coffee_cartridge
	name = "картридж для кофеварки - Caffè Generico"
	desc = "Картридж для кофеварки производства Piccionaia Coffee, для использования в системе Modello 3."
	icon = 'icons/obj/food/food.dmi'
	icon_state = "cartridge_basic"
	var/charges = 4
	var/list/drink_type = list(/datum/reagent/consumable/coffee = 120)

/obj/item/coffee_cartridge/examine(mob/user)
	. = ..()
	if(charges)
		. += span_warning("\nКартриджа хватит, чтобы сварить кофе еще [charges] раз.")
	else
		. += span_warning("\nВ картридже закончилась основа для кофе!")

/obj/item/coffee_cartridge/fancy
	name = "картридж для кофемашины - Caffè Fantasioso"
	desc = "Изысканный картридж для кофеварки производства Piccionaia Coffee, для использования в системе Modello 3."
	icon_state = "cartridge_blend"

//Here's the joke before I get 50 issue reports: they're all the same, and that's intentional
/obj/item/coffee_cartridge/fancy/Initialize(mapload)
	. = ..()
	var/coffee_type = pick("blend", "blue_mountain", "kilimanjaro", "mocha")
	switch(coffee_type)
		if("blend")
			name = "картридж для кофеварки - Miscela di Piccione"
			icon_state = "cartridge_blend"
		if("blue_mountain")
			name = "картридж для кофеварки - Montagna Blu"
			icon_state = "cartridge_blue_mtn"
		if("kilimanjaro")
			name = "картридж для кофеварки - Kilimangiaro"
			icon_state = "cartridge_kilimanjaro"
		if("mocha")
			name = "картридж для кофеварки - Moka Arabica"
			icon_state = "cartridge_mocha"

/obj/item/coffee_cartridge/decaf
	name = "картридж для кофеварки - Caffè Decaffeinato"
	desc = "Декофеинизированный картридж для кофеварки производства Piccionaia Coffee, для использования в системе Modello 3."
	icon_state = "cartridge_decaf"

// no you can't just squeeze the juice bag into a glass!
/obj/item/coffee_cartridge/bootleg
	name = "картридж для кофеварки - Botany Blend"
	desc = "Картридж для кофеварки, созданный при наблюдении жюри. Для использования в системе Modello 3, хотя это может привести к потере гарантии."
	icon_state = "cartridge_bootleg"

// blank cartridge for crafting's sake, can be made at the service lathe
/obj/item/blank_coffee_cartridge
	name = "пустой картридж для кофеварки"
	desc = "Пустой картридж для кофеварки, готовый к заполнению."
	icon = 'icons/obj/food/food.dmi'
	icon_state = "cartridge_blank"

//now, how do you store coffee carts? well, in a rack, of course!
/obj/item/storage/fancy/coffee_cart_rack
	name = "подставка для картриджей кофеварки"
	desc = "Небольшая подставка для картриджей кофеварки. Может содержать до четырех картриджей."
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "coffee_cartrack4"
	base_icon_state = "coffee_cartrack"
	spawn_count = 4
	spawn_type = /obj/item/coffee_cartridge

/obj/item/storage/fancy/coffee_cart_rack/Initialize()
	. = ..()
	atom_storage.max_slots = 4
	atom_storage.set_holdable(list(/obj/item/coffee_cartridge))

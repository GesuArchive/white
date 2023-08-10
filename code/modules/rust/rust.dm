/proc/load_rust_map()
	var/static/rust_loaded = FALSE
	if(rust_loaded)
		return
	var/datum/map_template/template = new("_maps/rusty/forest.dmm", "Rust")
	template.load_new_z(null, ZTRAITS_RUSTY)
	rust_loaded = TRUE

/obj/item/multifunctional_rust_rock
	name = "камень"
	desc = "Умеет всякое. Да."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "rust_rock"
	force = 10 // base force just for rock crushing
	throwforce = 10
	sharpness = SHARP_EDGED
	var/mob/rock_owner

/obj/structure/flora/resource_rock
	icon_state = "iron"
	name = "камень"
	desc = "Его можно разбить, если постараться."
	icon = 'icons/obj/rocks.dmi'
	resistance_flags = FIRE_PROOF
	plane = GAME_PLANE_UPPER
	density = TRUE
	pixel_x = -16
	pixel_y = -8
	var/obj/item/stack/base_resource = /obj/item/stack/ore/iron
	var/resource_amount = 8

/obj/structure/flora/resource_rock/obj_destruction(damage_flag)
	obj_break(damage_flag)
	return

/obj/structure/proc/hide_for_some_time(time_amount = 5 MINUTES)
	density = FALSE
	invisibility = INVISIBILITY_OBSERVER
	alpha = 100
	resistance_flags = INDESTRUCTIBLE

	spawn(rand(time_amount - 60 SECONDS, time_amount + 60 SECONDS))
		obj_integrity = max_integrity
		density = TRUE
		invisibility = NONE
		alpha = 255
		resistance_flags = FIRE_PROOF

/obj/structure/flora/resource_rock/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(loc, 'sound/weapons/stoneaxe.ogg', 80, TRUE)
			else
				playsound(loc, 'sound/weapons/tap.ogg', 50, TRUE)
		if(BURN)
			playsound(loc, 'sound/items/welder.ogg', 80, TRUE)

/obj/structure/flora/resource_rock/obj_break(damage_flag)
	visible_message(span_notice("<b>[src]</b> распадается на части."))
	new base_resource(loc, resource_amount)
	playsound(loc, 'sound/effects/stonerip.ogg', 80, TRUE)
	resource_amount = rand(6, 10)
	hide_for_some_time()

/obj/structure/flora/resource_rock/Destroy()
	. = ..()
	SSrust_mode.resource_rocks -= src

/obj/structure/flora/resource_rock/attackby(obj/item/W, mob/user, params)
	if(W?.force < 10 || W?.damtype != BRUTE)
		return ..()

	if(flags_1 & NODECONSTRUCT_1)
		return ..()

	if(resource_amount <= 2)
		obj_break()
		return ..()

	new base_resource(get_turf(user), 1)
	resource_amount--

	..()

	if(W.tool_behaviour == TOOL_MINING)
		user.changeNext_move(CLICK_CD_MELEE - 4)
	else
		user.changeNext_move(CLICK_CD_MELEE)

/obj/structure/flora/resource_rock/iron
	name = "железный камень"
	icon_state = "iron"
	base_resource = /obj/item/stack/ore/iron

/obj/structure/flora/resource_rock/glass
	name = "песочный камень"
	icon_state = "glass"
	base_resource = /obj/item/stack/ore/glass

/obj/structure/flora/resource_rock/gold
	name = "золотой камень"
	icon_state = "gold"
	base_resource = /obj/item/stack/ore/gold

/obj/structure/flora/resource_rock/silver
	name = "серебряный камень"
	icon_state = "silver"
	base_resource = /obj/item/stack/ore/silver

/obj/structure/flora/resource_rock/uranium
	name = "урановый камень"
	desc = "Всё в порядке?"
	icon_state = "uranium"
	base_resource = /obj/item/stack/ore/uranium

/obj/structure/flora/resource_rock/titanium
	name = "титановый камень"
	icon_state = "titanium"
	base_resource = /obj/item/stack/ore/titanium

/obj/structure/flora/resource_rock/plasma
	name = "плазмовый камень"
	icon_state = "plasma"
	base_resource = /obj/item/stack/ore/plasma

/obj/structure/flora/resource_rock/random
	name = "случайный камень"
	icon_state = "random"

/obj/structure/flora/resource_rock/random/Initialize(mapload)
	. = ..()
	var/random_type = pick(subtypesof(/obj/structure/flora/resource_rock) - list(/obj/structure/flora/resource_rock/random))
	new random_type(loc)
	qdel(src)

/obj/structure/resource_spawner
	name = "бочка"
	desc = "В ней точно что-то есть!"
	icon = 'white/valtos/icons/rospilovo/decor.dmi'
	icon_state = "bochka"
	max_integrity = 25
	density = TRUE
	anchored = TRUE
	var/break_sound = 'sound/effects/barrel_break.ogg'
	var/break_resource = /obj/item/stack/sheet/iron
	var/list/possible_loot = list(
		/obj/item/stack/sheet/mineral/wood = 66,
		/obj/item/stack/ore/iron = 50,
		/obj/item/stack/ore/glass = 50,
		/obj/item/stack/sheet/bone = 25,
		/obj/item/stack/sheet/cloth = 25,
		/obj/item/stack/sheet/paperframes = 15,
		/obj/item/stack/medical/bruise_pack = 8,
		/obj/item/stack/medical/ointment = 8,
		/obj/item/stack/ore/gold = 7,
		/obj/item/stack/ore/silver = 7,
		/obj/item/stack/ore/uranium = 7,
		/obj/item/stack/ore/titanium = 7,
		/obj/item/stack/ore/plasma = 7,
		/obj/item/stack/ore/diamond = 1
	)

/obj/structure/resource_spawner/obj_destruction(damage_flag)
	obj_break(damage_flag)
	return

/obj/structure/resource_spawner/obj_break(damage_flag)
	visible_message(span_notice("<b>[src]</b> распадается на части."))
	drop_resource()
	playsound(loc, break_sound, 80, TRUE)
	hide_for_some_time(10 MINUTES)

/obj/structure/resource_spawner/proc/drop_resource()
	new break_resource(loc)
	for(var/I in 1 to rand(1, 3))
		var/picked_type = pick_weight(possible_loot)
		var/obj/new_resource = new picked_type(loc)
		new_resource.pixel_x = rand(-8, 8)
		new_resource.pixel_y = rand(-8, 8)

/obj/structure/resource_spawner/rich
	icon_state = "red_bochka"
	possible_loot = list(
		/obj/item/stack/cable_coil/fifteen = 50,
		/obj/item/stock_parts/capacitor = 50,
		/obj/item/stock_parts/matter_bin = 50,
		/obj/item/stock_parts/cell = 50,
		/obj/item/stock_parts/manipulator = 50,
		/obj/item/stock_parts/micro_laser = 50,
		/obj/item/stock_parts/scanning_module = 50,
		/obj/item/stack/circuit_stack = 25,
		/obj/item/circuitboard/machine/pacman = 17,
		/obj/item/circuitboard/machine/autolathe = 16,
		/obj/item/circuitboard/machine/biogenerator = 18,
		/obj/item/circuitboard/machine/techfab = 15,
		/obj/item/circuitboard/computer/rdconsole = 10,
		/obj/item/circuitboard/machine/destructive_analyzer = 10,
		/obj/item/circuitboard/machine/protolathe = 10,
		/obj/item/circuitboard/machine/circuit_imprinter = 10,
		/obj/item/circuitboard/machine/chem_dispenser = 10,
		/obj/item/stack/ore/diamond = 5
	)

/obj/structure/resource_spawner/crate
	name = "ящик"
	icon_state = "yashik"
	desc = "В нём что-то есть?"
	break_sound = 'sound/effects/crate_break.ogg'
	break_resource = /obj/item/stack/sheet/mineral/wood
	possible_loot = list(
		/obj/item/food/canned/beans = 25,
		/obj/item/food/canned/peaches = 25,
		/obj/item/food/canned/pine_nuts = 25,
		/obj/item/food/canned/tomatoes = 25,
		/obj/item/reagent_containers/food/drinks/waterbottle = 25,
		/obj/item/weldingtool = 25,
		/obj/item/wrench = 25,
		/obj/item/crowbar = 25,
		/obj/item/screwdriver = 25,
		/obj/item/wirecutters = 25,
		/obj/item/multitool = 10,
		/obj/item/storage/crayons = 8,
		/obj/item/storage/mrebag/protein = 5,
		/obj/item/storage/mrebag/dessert = 5,
		/obj/item/storage/mrebag/vegan = 5,
		/obj/item/storage/toolbox/mechanical = 5,
		/obj/item/storage/toolbox/electrical = 4
	)

/obj/structure/resource_spawner/crate/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(loc, 'sound/weapons/wood_impact.ogg', 80, TRUE)
			else
				playsound(loc, 'sound/weapons/tap.ogg', 50, TRUE)
		if(BURN)
			playsound(loc, 'sound/items/welder.ogg', 80, TRUE)

/obj/structure/resource_spawner/crate/attackby(obj/item/attacking_item, mob/user, params)
	if(flags_1 & NODECONSTRUCT_1)
		return ..()

	if(attacking_item.tool_behaviour == TOOL_CROWBAR)
		playsound(loc, 'sound/effects/crate_crack.ogg', 80, TRUE)
		if(do_after(user, 1.5 SECONDS, target = src))
			obj_break()
			return

	..()

/obj/structure/resource_spawner/crate/rich
	icon_state = "yashik_a"
	possible_loot = list(
		/obj/item/weldingtool = 25,
		/obj/item/wrench = 25,
		/obj/item/crowbar = 25,
		/obj/item/screwdriver = 25,
		/obj/item/wirecutters = 25,
		/obj/item/multitool = 10,
		/obj/item/clothing/neck/necklace/dope/merchant = 10,
		/obj/item/gun/ballistic/automatic/pistol/fallout/m9mm/handmade = 5,
		/obj/item/ammo_box/magazine/fallout/m9mm = 5,
		/obj/item/card/id/advanced/gold/captains_spare = 5,
		/obj/item/clothing/head/helmet/alt = 5,
		/obj/item/clothing/suit/armor = 5,
		/obj/item/gun/ballistic/automatic/pistol/tanner = 5,
		/obj/item/ammo_box/c10mm = 5,
	)


/**********************Ore box**************************/

/obj/structure/ore_box
	icon = 'icons/obj/mining.dmi'
	icon_state = "orebox"
	name = "ящик для руды"
	desc = "Тяжелый деревянный ящик, который можно наполнить большим количеством руды."
	density = TRUE
	pressure_resistance = 5*ONE_ATMOSPHERE

/obj/structure/ore_box/attackby(obj/item/W, mob/user, params)
	if (istype(W, /obj/item/stack/ore))
		user.transferItemToLoc(W, src)
	else if(W.atom_storage)
		W.atom_storage.remove_type(/obj/item/stack/ore, src, INFINITY, TRUE, FALSE, user, null)
		to_chat(user, span_notice("You empty the ore in [W] into <b>[src.name]</b>."))
	else
		return ..()

/obj/structure/ore_box/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/rad_insulation, 0.01) //please datum mats no more cancer

/obj/structure/ore_box/crowbar_act(mob/living/user, obj/item/I)
	if(I.use_tool(src, user, 50, volume=50))
		user.visible_message(span_notice("[user] pries <b>[src.name]</b> apart.") ,
			span_notice("You pry apart <b>[src.name]</b>.") ,
			span_hear("You hear splitting wood."))
		deconstruct(TRUE, user)
	return TRUE

/obj/structure/ore_box/examine(mob/living/user)
	if(Adjacent(user) && istype(user))
		ui_interact(user)
	. = ..()

/obj/structure/ore_box/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(Adjacent(user))
		ui_interact(user)

/obj/structure/ore_box/attack_robot(mob/user)
	if(Adjacent(user))
		ui_interact(user)

/obj/structure/ore_box/proc/dump_box_contents()
	var/drop = drop_location()
	var/turf/our_turf = get_turf(src)
	for(var/obj/item/stack/ore/O in src)
		if(QDELETED(O))
			continue
		if(QDELETED(src))
			break
		O.forceMove(drop)
		SET_PLANE(O, PLANE_TO_TRUE(O.plane), our_turf)
		if(TICK_CHECK)
			stoplag()
			our_turf = get_turf(src)
			drop = drop_location()

/obj/structure/ore_box/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "OreBox", name)
		ui.open()

/obj/structure/ore_box/ui_data()
	var/contents = list()
	for(var/obj/item/stack/ore/O in src)
		contents[O.type] += O.amount

	var/data = list()
	data["materials"] = list()
	for(var/type in contents)
		var/obj/item/stack/ore/O = type
		var/name = initial(O.name)
		data["materials"] += list(list("name" = name, "amount" = contents[type], "id" = type))

	return data

/obj/structure/ore_box/ui_act(action, params)
	. = ..()
	if(.)
		return
	if(!Adjacent(usr))
		return
	add_fingerprint(usr)
	usr.set_machine(src)
	switch(action)
		if("removeall")
			dump_box_contents()
			to_chat(usr, span_notice("You open the release hatch on the box.."))

/obj/structure/ore_box/deconstruct(disassembled = TRUE, mob/user)
	var/obj/item/stack/sheet/mineral/wood/WD = new (loc, 4)
	if(user && !QDELETED(WD))
		WD.add_fingerprint(user)
	dump_box_contents()
	qdel(src)

/// Special override for notify_contents = FALSE.
/obj/structure/ore_box/on_changed_z_level(turf/old_turf, turf/new_turf, same_z_layer, notify_contents = FALSE)
	return ..()

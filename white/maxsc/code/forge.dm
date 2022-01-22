
/obj/machinery/forge/part
	icon_state = "5"
	var/obj/machinery/forge/part/main_part

/obj/machinery/forge/main
	icon_state = "2"
	density = TRUE
	var/list/parts = list()
	var/datum/reagent/selected_material

/obj/machinery/forge/main/Initialize()
	. = ..()
	setup_parts()
	create_reagents(150, REFILLABLE)
	AddComponent(/datum/component/plumbing/simple_demand, TRUE, _turn_connects = FALSE)

/obj/machinery/forge/main/Destroy()
	. = ..()
	for(var/P in parts)
		qdel(P)

/obj/machinery/forge/main/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/C = I
		if(C.reagents.trans_to(src, C.amount_per_transfer_from_this))
			src.visible_message(span_notice("[user] переливает немного содержимого [I.name] в [src]"), \
			span_notice("Переливаю немного содержимого [I.name] в [src]"))
	else
		. = ..()

/obj/machinery/forge/main/proc/get_crafts()
	var/list/crafts = list()
	for(var/I in list(/obj/item/melee/forge/dagger, /obj/item/melee/forge/sword, /obj/item/melee/forge/mace))
		var/obj/item/melee/forge/W = I
		var/list/craft = list()
		craft["path"] = W
		craft["name"] = initial(W.name)
		craft["cost"] = initial(W.mat_cost)
		crafts+=list(craft)
	return crafts

/obj/machinery/forge/main/attack_hand(mob/living/user)
	. = ..()
	ui_interact(user)

/obj/machinery/forge/main/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Forge", name)
		ui.open()

/obj/machinery/forge/main/ui_data(mob/user)
	var/list/data = list()
	var/list/crafts = get_crafts()
	data["reagent_list"] = list()
	if(reagents && reagents.reagent_list.len)
		for(var/datum/reagent/R in reagents.reagent_list)
			data["reagent_list"] += list(list("name" = R.name, "volume" = R.volume))
	data["selected_material"] = selected_material ? selected_material.name : "Не выбран реагент"
	data["amount"] = selected_material ? selected_material.volume : 0
	data["max_amount"] = reagents ? reagents.maximum_volume : "SHIT BROKEN"
	data["crafts"] = crafts

	return data

/obj/machinery/forge/main/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("create")
			if(!reagents.remove_reagent(selected_material.type, text2num(params["cost"])))
				return
			// да похуй блядь
			//if(!istype(text2path(params["path"]), /obj/item/melee/forge))
			//	message_admins("[ADMIN_LOOKUPFLW(usr)] пытается создать [params["path"]] в реагентной печке в локации [AREACOORD(usr)]")
			//	return
			var/obj/item/melee/forge/forged_item = params["path"]
			forged_item = new forged_item(get_turf(src))
			forged_item.material = selected_material.type
			forged_item.setup()
		if("select")
			selected_material = reagents.get_reagent(get_chem_id(params["reagent"]))
		if("dump")
			reagents.remove_all(reagents.total_volume)
			QDEL_NULL(selected_material)

/obj/machinery/forge/part/attackby(obj/item/attacking_item, mob/user, params)
	return main_part.attackby(attacking_item, user, params)

/obj/machinery/forge/part/attack_hand(mob/living/user)
	return main_part.attack_hand(user)

/obj/machinery/forge
	name = "forge"
	desc = "Why?"
	icon = 'white/maxsc/icons/forge.dmi'

/obj/machinery/forge/main/proc/setup_parts()
	var/turf/our_turf = get_turf(src)
	var/count = 0
	// 9x9 block obtained from the bottom middle of the block
	var/list/spawn_turfs = block(locate(our_turf.x - 1, our_turf.y + 2, our_turf.z), locate(our_turf.x + 1, our_turf.y, our_turf.z))
	for(var/turf/T in spawn_turfs)
		count++
		if(T == our_turf)
			continue
		var/obj/machinery/forge/part/part = new(T)
		part.icon_state = "[count]"
		if(count < 7)
			part.set_density(TRUE)
		else
			part.plane = ABOVE_GAME_PLANE
		part.main_part = src
		parts += part

/obj/item/melee/forge
	name = "forge weapon"
	desc = "Made with love."
	icon = 'white/maxsc/icons/forged_weapons.dmi'
	righthand_file = 'white/maxsc/icons/righthand.dmi'
	lefthand_file = 'white/maxsc/icons/lefthand.dmi'
	var/datum/reagent/material
	var/mat_cost = 50

/obj/item/melee/forge/proc/setup()
	if(material)
		material = new material
		rename()
		repaint()

/obj/item/melee/forge/proc/rename()
	name += " из [lowertext(material.name)]"

/obj/item/melee/forge/proc/repaint()
	var/icon/I = new(icon)
	I.Blend(material.color, ICON_MULTIPLY)
	icon = I
	I = new(righthand_file)
	I.Blend(material.color, ICON_MULTIPLY)
	righthand_file = I
	I = new(lefthand_file)
	I.Blend(material.color, ICON_MULTIPLY)
	lefthand_file = I

/obj/item/melee/forge/attack(mob/living/M, mob/living/user, params)
	. = ..()
	if(material)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H.reagents)
				H.reagents.add_reagent(material.type, force)

/obj/item/melee/forge/sword
	name = "меч"
	icon_state = "forged_sword"
	force = 10
	throwforce = 10
	sharpness = SHARP_EDGED
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BELT
	attack_verb_continuous = list("slashes", "cuts")
	attack_verb_simple = list("slash", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	mat_cost = 100

/obj/item/melee/forge/mace
	name = "булава"
	icon_state = "forged_mace"
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_BULKY
	force = 12
	throwforce = 12
	mat_cost = 100


/obj/item/melee/forge/dagger
	name = "кинжал"
	icon_state = "forged_dagger"
	force = 1
	throwforce = 1
	sharpness = SHARP_POINTY
	w_class = WEIGHT_CLASS_SMALL
	attack_verb_continuous = list("stabs", "cuts")
	attack_verb_simple = list("stab", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	mat_cost = 50

/obj/item/melee/forge/dagger/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	user.changeNext_move(CLICK_CD_RAPID)

/obj/item/melee/forge/hammer
	name = "молот"
	icon_state = "forged_hammer0"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	force = 15
	throwforce = 15
	mat_cost = 150

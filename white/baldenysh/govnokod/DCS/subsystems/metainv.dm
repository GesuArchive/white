SUBSYSTEM_DEF(metainv)
	name = "МетаИнвентарь"
	flags = SS_NO_FIRE //хз потом убрать если дроп кейсов со временем прикрутить припрет
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	init_order = 5

	var/datum/metainv_object/test/ABOBA = new
	var/datum/metainventory/test/AMONGUS = new

	var/list/datum/metainventory/inventories = list()

/datum/controller/subsystem/metainv/Initialize()
	. = ..()

/datum/controller/subsystem/metainv/proc/get_inv(ckey)
	if(inventories[ckey])
		. = inventories[ckey]
	else
		var/json_file = file("data/player_saves/[ckey[1]]/[ckey]/metainv.json")
		if(!fexists(json_file))
			. = new /datum/metainventory
		else
			. = r_json_decode(json_file)
		inventories[ckey] = .

/datum/controller/subsystem/metainv/proc/save_inv(ckey)
	var/datum/metainventory/MI = inventories?[ckey]
	if(MI && MI?.obj_list.len)
		WRITE_FILE("data/player_saves/[ckey[1]]/[ckey]/metainv.json", json_encode(inventories[ckey]))
		return TRUE

////////////////////////////////////////////////////////////////////

#define METAINVENTORY_SLOT_CURSOR	-1
#define METAINVENTORY_SLOT_TURF 	-2
#define METAINVENTORY_SLOT_HAND_L 	-3
#define METAINVENTORY_SLOT_HAND_R 	-4

/datum/metainventory
	var/owner_ckey
	var/null_slots = 20
	var/list/datum/metainv_object/obj_list = list()

/datum/metainventory/serialize_list(list/options)
	. = list()
	.["ckey"] = owner_ckey
	.["slots"] = slots
	.["objs"] = list()
	for(var/datum/metainv_object/MO in obj_list)
		.["objs"] += MO.serialize_json()

/datum/metainventory/deserialize_list(list/input, list/options)
	if(!input["ckey"] || !input["slots"] || !input["objs"])
		return
	owner_ckey = input["ckey"]
	slots = input["slots"]
	for(var/json_obj in input["objs"])
		var/datum/metainv_object/MO = new
		obj_list += MO.deserialize_json(json_obj)

/datum/metainventory/proc/create_all_objects(atom/location)
	for(var/datum/metainv_object/MO in obj_list)
		MO.create_object(location)

/datum/metainventory/proc/get_equipped_items_slot_assoc()
	. = list()
	for(var/datum/metainv_object/MO in obj_list)
		if(.["[MO.equipped_to_slot]"])
			.["[MO.equipped_to_slot]"] += MO
		else
			.["[MO.equipped_to_slot]"] = list(MO)

//PIZDEC
/datum/metainventory/proc/equip_carbon(mob/living/carbon/target)
	if(!target || !istype(target))
		return
	var/list/equipped = get_equipped_items_slot_assoc()
	var/turf/T = get_turf(target)

	for(var/datum/metainv_object/MO in equipped["[METAINVENTORY_SLOT_TURF]"])
		MO.create_object(T)

	var/datum/metainv_object/l_hand_metaobj = equipped["[METAINVENTORY_SLOT_HAND_L]"]?[1]
	if(l_hand_metaobj)
		target.put_in_l_hand(l_hand_metaobj.create_object(T))

	var/datum/metainv_object/r_hand_metaobj = equipped["[METAINVENTORY_SLOT_HAND_R]"]?[1]
	if(r_hand_metaobj)
		target.put_in_r_hand(r_hand_metaobj.create_object(T))

	for(var/i = 1; i < SLOTS_AMT; i++)
		var/slot = (1<<i)
		if(equipped["[slot]"]?[1])
			try_equip_metaobj(target, slot, equipped["[slot]"][1])

/datum/metainventory/proc/try_equip_metaobj(mob/living/carbon/target, slot, datum/metainv_object/MO)
	if(MO && istype(MO))
		var/obj/item/I = MO.create_object(get_turf(target))
		var/obj/item/unequipped = target.get_item_by_slot(slot)
		if(target.dropItemToGround(unequipped, force = FALSE, silent = TRUE, invdrop = FALSE))
			if(!target.equip_to_slot_if_possible(I, slot, bypass_equip_delay_self = TRUE))
				target.equip_to_slot_if_possible(unequipped, slot, bypass_equip_delay_self = TRUE)

////////////////////////////////

/datum/metainventory/test
	owner_ckey = "imposter"
	slots = 11

/datum/metainventory/test/New()
	. = ..()
	var/datum/metainv_object/test/bimba = new
	bimba.equipped_to_slot = METAINVENTORY_SLOT_TURF

	var/datum/metainv_object/stels = new
	stels.object_path_txt = "/obj/item/stack/sheet/mineral/wood"
	stels.var_overrides = list("name" = "жопные доски", "desc" = "фичи, каторые мы заслужили", "amount" = 15)
	stels.equipped_to_slot = METAINVENTORY_SLOT_HAND_R

	var/datum/metainv_object/uniform = new
	uniform.object_path_txt = "/obj/item/clothing/under/rank/engineering/atmospheric_technician"
	uniform.equipped_to_slot = ITEM_SLOT_ICLOTHING

	obj_list += uniform
	obj_list += bimba
	obj_list += stels

////////////////////////////////////////////////////////////////////

/datum/metainv_object
	var/object_path_txt
	var/equipped_to_slot = 0 //используются дефайны инвентаря типа ITEM_SLOT_ICLOTHING, плюс дефайны метаинвентаря выше для рук и прочего
	var/rarity
	var/list/var_overrides

/datum/metainv_object/proc/create_object(atom/location)
	var/object_path = text2path(object_path_txt)
	var/obj/O = new object_path(location)
	for(var/varname in var_overrides)
		O.vars[varname] = var_overrides[varname]
	return O

/datum/metainv_object/serialize_list(list/options) //нужно для работы serialize_json
	. = list()
	.["OPT"] = object_path_txt
	if(equipped_to_slot)
		.["ETS"] = equipped_to_slot
	if(rarity)
		.["R"] = rarity
	if(var_overrides && var_overrides.len)
		.["VO"] = json_encode(var_overrides)

/datum/metainv_object/deserialize_list(list/input, list/options)
	if(!input["OPT"])
		return
	object_path_txt = input["OPT"]
	equipped_to_slot = input?["ETS"]
	rarity = input?["R"]
	var_overrides = json_decode(input?["VO"])
	return src


/datum/metainv_object/test
	object_path_txt = "/obj/machinery/nuclearbomb"
	var_overrides = list("name" = "Українська бiмба", "throwforce" = 999)

SUBSYSTEM_DEF(metainv)
	name = "МетаИнвентарь"
	flags = SS_NO_FIRE //хз потом убрать если дроп кейсов со временем прикрутить припрет
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	init_order = 5

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

#define METAINVENTORY_SLOT_HAND_L 		-1
#define METAINVENTORY_SLOT_HAND_R 		-2
#define METAINVENTORY_SLOT_TURF(num) 	(-2-num)

/datum/metainventory
	var/owner_ckey
	var/slots_max = 24
	var/active_loadout = 1
	var/list/datum/metainv_loadout/loadout_list = list()
	var/list/datum/metainv_object/obj_list = list()

/datum/metainventory/serialize_list(list/options)
	. = list()
	.["ckey"] = owner_ckey
	.["slots"] = slots_max
	.["objs"] = list()
	for(var/datum/metainv_object/MO in obj_list)
		.["objs"] += MO.serialize_json()
	.["loadouts"] = list()
	for(var/datum/metainv_loadout/ML in loadout_list)
		.["loadouts"] += ML.serialize_json()
	.["a_loadout"] = active_loadout

/datum/metainventory/deserialize_list(list/input, list/options)
	if(!input["ckey"] || !input["slots"] || !input["objs"] || !input["loadouts"])
		return
	owner_ckey = input["ckey"]
	slots_max = input["slots"]
	for(var/json_obj in input["objs"])
		var/datum/metainv_object/MO = new
		obj_list += MO.deserialize_json(json_obj)
	for(var/json_loadout in input["loadouts"])
		var/datum/metainv_loadout/ML = new
		ML.inv = src
		loadout_list += ML.deserialize_json(json_loadout)
	active_loadout = input?["a_loadout"]


/datum/metainventory/proc/create_all_objects(atom/location)
	for(var/datum/metainv_object/MO in obj_list)
		MO.create_object(location)

/datum/metainventory/proc/get_uid_to_metaobj_assoc()
	. = list()
	for(var/datum/metainv_object/MO in obj_list)
		.["[MO.uid]"] = MO

////////////////////////////////

/datum/metainventory/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "MetaInventory")
		ui.open()

/datum/metainventory/ui_assets(mob/user)
	return list(get_asset_datum(/datum/asset/simple/inventory))

/datum/metainventory/ui_data(mob/user)
	var/list/data = list()

	data["objects"] = list()
	for(var/datum/metainv_object/MO in obj_list)
		var/list/res = list()
		var/obj/O = text2path(MO.object_path_txt)
		var/mo_name = (MO.var_overrides && MO.var_overrides["name"]) ? MO.var_overrides["name"] : initial(O.name)
		var/mo_icon = (MO.var_overrides && MO.var_overrides["icon"]) ? MO.var_overrides["icon"] : initial(O.icon)
		var/mo_icon_state = (MO.var_overrides && MO.var_overrides["icon_state"]) ? MO.var_overrides["icon_state"] : initial(O.icon_state)
		res["icon"] = icon2base64(icon(mo_icon, mo_icon_state))
		res["name"] = mo_name
		res["uid"] = "[MO.uid]"

		data["objects"] += list(res)

	var/datum/metainv_loadout/cur_loadout = loadout_list[active_loadout]
	data["loadout"] = cur_loadout.loadout_slots

	data["slots"] = slots_max
	return data

/datum/metainventory/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("loadoutSlotClick")
			//var/clicked_slot_str = params["key"]
			. = TRUE
		if("invSlotClick")
			//var/clicked_obj_id = params["key"]
			. = TRUE

/datum/metainventory/ui_status(mob/user)
	return UI_INTERACTIVE

/datum/metainventory/proc/ui_data_json()
	return json_encode(ui_data())


////////////////////////////////

/datum/metainventory/test
	owner_ckey = "imposter"

/datum/metainventory/test/New()
	. = ..()
	var/datum/metainv_object/bimba = new
	bimba.uid = 1
	bimba.object_path_txt = "/obj/machinery/nuclearbomb"
	bimba.var_overrides = list("name" = "Українська бiмба", "throwforce" = 999)

	var/datum/metainv_object/stels = new
	stels.uid = 3
	stels.object_path_txt = "/obj/item/stack/sheet/mineral/wood"
	stels.var_overrides = list("amount" = 15)

	var/datum/metainv_object/uniform = new
	uniform.uid = 5
	uniform.object_path_txt = "/obj/item/clothing/under/rank/engineering/atmospheric_technician"

	var/datum/metainv_object/tarelka = new
	tarelka.uid = 6
	tarelka.object_path_txt = "/obj/item/clothing/mask/gas/tarelka"

	obj_list += tarelka

	obj_list += uniform
	obj_list += bimba
	obj_list += stels

	var/datum/metainv_loadout/ML = new
	ML.set_slot(METAINVENTORY_SLOT_HAND_R, stels.uid)
	ML.set_slot(ITEM_SLOT_ICLOTHING, uniform.uid)
	ML.set_slot(METAINVENTORY_SLOT_TURF(3), bimba.uid)
	ML.inv = src
	loadout_list += ML

////////////////////////////////////////////////////////////////////

/datum/metainv_loadout
	var/datum/metainventory/inv
	//в качестве ключей используются дефайны инвентаря типа ITEM_SLOT_ICLOTHING, плюс дефайны метаинвентаря выше для рук и прочего
	var/list/loadout_slots

/datum/metainv_loadout/New()
	. = ..()
	build_slots()

/datum/metainv_loadout/proc/build_slots()
	var/list/res = list()
	var/list/metainv_slots = list(METAINVENTORY_SLOT_HAND_L, METAINVENTORY_SLOT_HAND_R)
	for(var/i in 1 to 5)
		metainv_slots += METAINVENTORY_SLOT_TURF(i)
	for(var/slot in metainv_slots)
		res["[slot]"] = "0"
	for(var/i = 0; i < SLOTS_AMT; i++)
		res["[1<<i]"] = "0"
	loadout_slots = res

/datum/metainv_loadout/proc/set_slot(slot, uid)
	loadout_slots["[slot]"] = "[uid]"

/datum/metainv_loadout/proc/get_slot_to_metaobj_assoc()
	. = list()
	var/list/uid_assoc = inv.get_uid_to_metaobj_assoc()
	for(var/slot in loadout_slots)
		var/equipped_uid = loadout_slots[slot]
		if(equipped_uid != "0")
			var/datum/metainv_object/MO = uid_assoc?[equipped_uid]
			if(MO)
				.[slot] = MO

/datum/metainv_loadout/proc/equip_carbon(mob/living/carbon/target)
	if(!target || !istype(target))
		return
	var/turf/T = get_turf(target)

	var/list/equipped = get_slot_to_metaobj_assoc()

	for(var/i in 1 to 5)
		var/datum/metainv_object/turf_obj = equipped["[METAINVENTORY_SLOT_TURF(i)]"]
		if(turf_obj)
			turf_obj.create_object(T)

	var/datum/metainv_object/l_hand_metaobj = equipped["[METAINVENTORY_SLOT_HAND_L]"]
	if(l_hand_metaobj)
		target.put_in_l_hand(l_hand_metaobj.create_object(T))

	var/datum/metainv_object/r_hand_metaobj = equipped["[METAINVENTORY_SLOT_HAND_R]"]
	if(r_hand_metaobj)
		target.put_in_r_hand(r_hand_metaobj.create_object(T))

	for(var/i = 1; i < SLOTS_AMT; i++)
		var/datum/metainv_object/MO = equipped["[1<<i]"]
		if(MO)
			equip_metaobj_to_invslot(target, (1<<i), MO)

/datum/metainv_loadout/proc/equip_metaobj_to_invslot(mob/living/target, slot, datum/metainv_object/MO)
	if(MO && istype(MO))
		var/obj/item/I = MO.create_object(get_turf(target))
		var/obj/item/unequipped = target.get_item_by_slot(slot)
		if(target.dropItemToGround(unequipped, force = FALSE, silent = TRUE, invdrop = FALSE))
			if(!target.equip_to_slot_if_possible(I, slot, bypass_equip_delay_self = TRUE))
				target.equip_to_slot_if_possible(unequipped, slot, bypass_equip_delay_self = TRUE)

/datum/metainv_loadout/serialize_list(list/options)
	. = list()
	.["slots_contents"] = list()
	for(var/slot in loadout_slots)
		if(loadout_slots[slot] && loadout_slots[slot] != "0")
			.["slots_contents"][slot] = loadout_slots[slot]

/datum/metainv_loadout/deserialize_list(list/input, list/options)
	if(!input["slots_contents"])
		return
	var/list/slots_contents = input["slots_contents"]
	for(var/slot in slots_contents)
		loadout_slots[slot] = slots_contents[slot]
	return src

////////////////////////////////////////////////////////////////////

/datum/metainv_object
	var/uid = 0
	var/object_path_txt
	var/rarity
	var/list/var_overrides

/datum/metainv_object/proc/create_object(atom/location)
	var/object_path = text2path(object_path_txt)
	var/obj/O = new object_path(location)
	for(var/varname in var_overrides)
		O.vars[varname] = var_overrides[varname]
	return O

/datum/metainv_object/serialize_list(list/options)
	. = list()
	.["UID"] = uid
	.["OPT"] = object_path_txt
	if(rarity)
		.["R"] = rarity
	if(var_overrides && var_overrides.len)
		.["VO"] = json_encode(var_overrides)

/datum/metainv_object/deserialize_list(list/input, list/options)
	if(!input["UID"] || !input["OPT"])
		return
	uid = input["UID"]
	object_path_txt = input["OPT"]
	if(input["R"])
		rarity = input["R"]
	if(input["VO"])
		var_overrides = json_decode(input["VO"])
	return src

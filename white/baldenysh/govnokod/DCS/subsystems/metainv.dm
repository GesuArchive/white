#define METAINVENTORY_PERSONAL_INVENTORY_PATH(ckey) "data/player_saves/[ckey[1]]/[ckey]/metainv.json"
#define METAINVENTORY_CATEGORIES_PATH "data/metainv/categories.json"

SUBSYSTEM_DEF(metainv)
	name = "МетаИнвентарь"
	flags = SS_NO_FIRE
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	init_order = 75

	var/list/inventories = list()
	var/list/categories = list()

/datum/controller/subsystem/metainv/Initialize()
	. = ..()
	load_categories()
	RegisterSignal(SSdcs, COMSIG_GLOB_JOB_AFTER_SPAWN, .proc/on_job_after_spawn)

/datum/controller/subsystem/metainv/proc/on_job_after_spawn(datum/source, datum/job/job, mob/living/spawned, client/player_client)
	if(length(player_client.prefs.equipped_gear))
		return
	if(!spawned || istype(job, /datum/job/ai) || istype(job, /datum/job/cyborg)) //русские идут домой рантаймить
		return
	if(!is_station_level(spawned.z))
		RegisterSignal(spawned, COMSIG_MOVABLE_Z_CHANGED, .proc/equip_kostil)
		return
	var/ckey = spawned.ckey ? spawned.ckey : player_client.ckey
	var/datum/metainventory/MI = get_inv(ckey)
	var/datum/metainv_loadout/ML = MI.loadout_list[MI.active_loadout]
	ML.equip_carbon(spawned)

//чтоб костылей не было надо пофикшенные тгшные джобки, но там мержить пиздец просто плюс приколы вайта не в отдельном файле
/datum/controller/subsystem/metainv/proc/equip_kostil(datum/source, old_z, new_z)
	var/mob/living/L = source
	if(!is_station_level(L.z))
		return
	UnregisterSignal(source, COMSIG_MOVABLE_Z_CHANGED)
	var/datum/metainventory/MI = get_inv(L.ckey)
	var/datum/metainv_loadout/ML = MI.loadout_list[MI.active_loadout]
	ML.equip_carbon(L)

/datum/controller/subsystem/metainv/proc/metashop2metainv(client/C)
	if(!C || !LAZYLEN(C.prefs.purchased_gear))
		return
	var/datum/metainventory/MI = get_inv(C.ckey)
	for(var/gear in C.prefs.purchased_gear)
		var/datum/gear/G = GLOB.gear_datums[gear]
		if(!G || !G.path)
			continue
		var/datum/metainv_object/MO = new(G.path)
		if(G.allowed_roles)
			LAZYADDASSOC(MO.metadata, "role_whitelist", G.allowed_roles)
		if(G.species_whitelist)
			LAZYADDASSOC(MO.metadata, "species_whitelist", G.species_whitelist)
		if(G.species_blacklist)
			LAZYADDASSOC(MO.metadata, "species_blacklist", G.species_blacklist)
		MI.add_object(MO)

/datum/controller/subsystem/metainv/proc/add_initial_items(ckey, datum/metainventory/MI)
	var/mob/M = get_mob_by_ckey(ckey)
	var/client/C = M.client
	if(C)
		if(check_rights_for(C, R_ADMIN))
			add_test_items(MI)
		//меташоп надо выпилить
		metashop2metainv(M.client)

/datum/controller/subsystem/metainv/proc/add_test_items(datum/metainventory/MI)
	var/datum/metainv_object/bimba = new("/obj/machinery/nuclearbomb")
	bimba.var_overrides = list("name" = "Українська бiмба", "throwforce" = 999)
	var/datum/metainv_object/bimba2 = new("/obj/machinery/nuclearbomb")
	var/datum/metainv_object/stels = new("/obj/item/stack/sheet/mineral/wood")
	stels.var_overrides = list("amount" = 15)
	var/datum/metainv_object/uniform = new("/obj/item/clothing/under/rank/engineering/atmospheric_technician")
	var/datum/metainv_object/restcase = new("/obj/item/storage/briefcase/surgery")
	restcase.metadata = list()
	restcase.metadata["role_whitelist"] = list("Field Medic", "Paramedic", "Medical Doctor", "Chief Medical Officer")
	var/datum/metainv_object/icontest = new("/obj/item/clothing/suit/armor/hos/ranger")
	var/datum/metainv_object/gstest = new("/obj/item/clothing/shoes/sneakers/purple")
	MI.add_object(list(icontest, bimba2, restcase, uniform, bimba, stels, gstest))

/datum/controller/subsystem/metainv/proc/get_inv(ckey)
	if(!ckey)
		CRASH("Попытка вернуть инвентарь без сикея!")
	if(inventories[ckey])
		return inventories[ckey]
	else
		var/datum/metainventory/newMI = new
		if(fexists(METAINVENTORY_PERSONAL_INVENTORY_PATH(ckey)))
			newMI.deserialize_json("[file2text(METAINVENTORY_PERSONAL_INVENTORY_PATH(ckey))]")
		if(!length(newMI.loadout_list))
			newMI.loadout_list += new /datum/metainv_loadout(newMI)
			newMI.active_loadout = 1
		inventories[ckey] = newMI
		add_initial_items(ckey, newMI)
		return newMI

/datum/controller/subsystem/metainv/proc/save_inv(ckey)
	if(!inventories[ckey])
		return FALSE
	if(fexists(METAINVENTORY_PERSONAL_INVENTORY_PATH(ckey)))
		fdel(METAINVENTORY_PERSONAL_INVENTORY_PATH(ckey))
	var/datum/metainventory/MI = inventories[ckey]
	text2file("[MI.serialize_json()]", METAINVENTORY_PERSONAL_INVENTORY_PATH(ckey))
	return TRUE

/datum/controller/subsystem/metainv/proc/load_categories()
	if(fexists(METAINVENTORY_CATEGORIES_PATH))
		categories = json_decode(file2text(METAINVENTORY_CATEGORIES_PATH))

/datum/controller/subsystem/metainv/proc/save_categories()
	if(fexists(METAINVENTORY_CATEGORIES_PATH))
		fdel(METAINVENTORY_CATEGORIES_PATH)
	text2file(json_encode(categories), METAINVENTORY_CATEGORIES_PATH)

/datum/controller/subsystem/metainv/proc/get_new_uid(cid, typepath)
	if(!cid || "[cid]" == "0")
		return 0
	if(!categories["[cid]"])
		categories["[cid]"] = list()
		if(!categories["[cid]"]["[typepath]"])
			categories["[cid]"]["[typepath]"] = 0
	categories["[cid]"]["[typepath]"] += 1
	. = categories["[cid]"]["[typepath]"]
	save_categories()

/datum/controller/subsystem/metainv/proc/open_inventory(client/C)
	if(!SSticker || SSticker.current_state < GAME_STATE_PREGAME)
		to_chat(C,span_warning("Не так быстро, мир все еще не создан!"))
		return
	var/datum/metainventory/MI = get_inv(C.ckey)
	MI.ui_interact(C.mob)

/datum/controller/subsystem/metainv/proc/add_real_item_test(ckey, typepath_txt)
	var/datum/metainventory/MI = get_inv(ckey)
	var/datum/metainv_object/MO = new(typepath_txt, 1)
	MI.add_object(MO)
	save_inv(ckey)

////////////////////////////////////////////////////////////////////

#define METAINVENTORY_SLOT_HAND_L 		-1
#define METAINVENTORY_SLOT_HAND_R 		-2
#define METAINVENTORY_SLOT_TURF(num) 	(-2-num)

/datum/metainventory
	//слоты (можно впилить чтоб их допкупать можно было)
	var/slots_max = 16
	//временные слоты
	var/temp_slots = 0
	//нажатый в интерфейсе слот инвентаря (не лоудаута)
	var/active_slot = 0
	//активный лоудаут
	var/active_loadout = 1
	//лоудауты (переключение не впилено, но как будет - можно тож докупание впилить)
	var/list/datum/metainv_loadout/loadout_list = list()
	//вся фигня в инвентаре
	var/list/datum/metainv_object/obj_list = list()

//для добавления объектов использовать этот прок, принимает объект или лист объектов
/datum/metainventory/proc/add_object(input)
	if(istype(input, /datum/metainv_object))
		add_single_obj(input)
	else if(islist(input))
		for(var/datum/metainv_object/MO in input)
			add_single_obj(MO)
	else
		stack_trace("Произошло хуевое добавление объектов в инвентарь")
		return FALSE
	SStgui.update_uis(src)
	return TRUE

//этот прок за пределами метаинвентаря не трогать
/datum/metainventory/proc/add_single_obj(datum/metainv_object/MO)
	if(!MO)
		stack_trace("Попытка добавить в инвентарь объект без объекта...")
		return
	if(!MO.cid)
		temp_slots++
	obj_list += MO

/datum/metainventory/serialize_list(list/options)
	. = list()
	.["slots"] = slots_max
	.["objs"] = list()
	for(var/datum/metainv_object/MO in obj_list)
		var/obj_json = MO.serialize_json()
		if(obj_json)
			.["objs"] += obj_json
	.["loadouts"] = list()
	for(var/datum/metainv_loadout/ML in loadout_list)
		.["loadouts"] += ML.serialize_json()
	if(active_loadout != 1)
		.["a_loadout"] = active_loadout

/datum/metainventory/deserialize_list(list/input, list/options)
	if(!input["slots"] || !input["objs"] || !input["loadouts"])
		return
	slots_max = input["slots"]
	for(var/json_obj in input["objs"])
		var/datum/metainv_object/MO = new
		add_single_obj(MO.deserialize_json(json_obj))
	for(var/json_loadout in input["loadouts"])
		var/datum/metainv_loadout/ML = new(src)
		loadout_list += ML.deserialize_json(json_loadout)
	active_loadout = input["a_loadout"] ? input["a_loadout"] : 1
	return src

/datum/metainventory/proc/get_id_to_metaobj_assoc()
	. = list()
	for(var/datum/metainv_object/MO in obj_list)
		.["[MO.get_id()]"] = MO

////////////////////////////////

/datum/metainventory/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "MetaInventory")
		ui.open()
		ui.set_autoupdate(FALSE)

/datum/metainventory/ui_assets(mob/user)
	return list(get_asset_datum(/datum/asset/simple/inventory))

/datum/metainventory/ui_data(mob/user)
	var/list/data = list()

	data["objects"] = list()
	for(var/datum/metainv_object/MO in obj_list)
		var/list/res = list()
		var/obj/O = text2path(MO.object_path_txt)
		var/mo_name = (MO.var_overrides && MO.var_overrides["name"]) ? MO.var_overrides["name"] : initial(O.name)

		var/image/I
		if(MO.var_overrides && MO.var_overrides["icon"] && MO.var_overrides["icon_state"])
			I = image(icon = initial(MO.var_overrides["icon"]), icon_state = initial(MO.var_overrides["icon_state"]))
		else
			I = path2image(O)

		res["icon"] = icon2base64(getFlatIcon(I, defdir = SOUTH, no_anim = TRUE))
		res["name"] = mo_name
		res["id"] = "[MO.get_id()]"

		data["objects"] += list(res)

	var/datum/metainv_loadout/cur_loadout = loadout_list[active_loadout]
	data["loadout"] = cur_loadout.loadout_slots
	data["active_slot"] = active_slot
	data["slots"] = slots_max + temp_slots
	return data

/datum/metainventory/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("loadoutSlotClick")
			var/clicked_slot_key = params["key"]
			var/datum/metainv_loadout/a_loadout = loadout_list[active_loadout]
			if(active_slot)
				var/datum/metainv_object/MO = obj_list[active_slot]
				active_slot = 0
				if(MO)
					a_loadout.clear_id(MO.get_id())
					a_loadout.set_slot(clicked_slot_key, MO.get_id())
					return TRUE
			a_loadout.set_slot(clicked_slot_key, "0")
			return TRUE
		if("invSlotClick")
			var/clicked_slot_id = params["key"]
			active_slot = clicked_slot_id
			return TRUE

/datum/metainventory/ui_status(mob/user)
	return UI_INTERACTIVE

////////////////////////////////////////////////////////////////////

/datum/metainv_loadout
	var/datum/metainventory/inv
	//слоты лоудаута, в качестве ключей используются дефайны инвентаря типа ITEM_SLOT_ICLOTHING, плюс дефайны метаинвентаря выше для рук и прочего
	var/list/loadout_slots

/datum/metainv_loadout/New(datum/metainventory/MI)
	. = ..()
	if(!MI)
		CRASH("Лоудаут создан без инвентаря")
	inv = MI
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

/datum/metainv_loadout/proc/set_slot(slot, id)
	loadout_slots["[slot]"] = "[id]"

/datum/metainv_loadout/proc/get_slot(slot)
	return loadout_slots["[slot]"]

/datum/metainv_loadout/proc/clear_id(id)
	for(var/slot in loadout_slots)
		if(loadout_slots[slot] == "[id]")
			loadout_slots[slot] = "0"
			return

/datum/metainv_loadout/proc/get_slot_to_metaobj_assoc()
	. = list()
	var/list/uid_assoc = inv.get_id_to_metaobj_assoc()
	for(var/slot in loadout_slots)
		var/equipped_uid = loadout_slots[slot]
		if(equipped_uid != "0")
			var/datum/metainv_object/MO = uid_assoc?[equipped_uid]
			if(MO)
				.[slot] = MO

/datum/metainv_loadout/proc/equip_carbon(mob/living/carbon/target, silent = FALSE)
	if(!target || !istype(target))
		return
	var/turf/T = get_turf(target)

	var/list/equipped = get_slot_to_metaobj_assoc()

	for(var/i in 1 to 5)
		var/datum/metainv_object/turf_obj = equipped["[METAINVENTORY_SLOT_TURF(i)]"]
		if(turf_obj && turf_obj.can_create_for(target))
			turf_obj.create_object(T)

	var/datum/metainv_object/l_hand_metaobj = equipped["[METAINVENTORY_SLOT_HAND_L]"]
	if(l_hand_metaobj && l_hand_metaobj.can_create_for(target))
		target.put_in_l_hand(l_hand_metaobj.create_object(T))
	var/datum/metainv_object/r_hand_metaobj = equipped["[METAINVENTORY_SLOT_HAND_R]"]
	if(r_hand_metaobj && r_hand_metaobj.can_create_for(target))
		target.put_in_r_hand(r_hand_metaobj.create_object(T))

	for(var/i = 0; i < SLOTS_AMT; i++)
		var/datum/metainv_object/MO = equipped["[1<<i]"]
		if(MO)
			equip_metaobj_to_invslot(target, (1<<i), MO, silent)

/datum/metainv_loadout/proc/equip_metaobj_to_invslot(mob/living/target, slot, datum/metainv_object/MO, silent = FALSE)
	if(MO && istype(MO) && MO.can_create_for(target))
		var/obj/item/I = MO.create_object(get_turf(target))
		var/obj/item/unequipped = target.get_item_by_slot(slot)
		if(target.dropItemToGround(unequipped, force = FALSE, silent = TRUE, invdrop = FALSE))
			if(!target.equip_to_slot_if_possible(I, slot, bypass_equip_delay_self = TRUE))
				target.equip_to_slot_if_possible(unequipped, slot, bypass_equip_delay_self = TRUE)
				if(!silent)
					to_chat(target, span_warning("Пришлось оставить [I]!"))
				qdel(I)

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
	//айди категории, выдается при регистарции в подсистеме
	//нулевая категория для объектов, выдающихся каждый раз заново всякими ачивками, меташопами или просто на раунд. она не сохраняется, объекты в ней не занимаю место и существуют в единственном экземпляре
	var/cid = 0
	//тип объекта в текстовом виде (пример - "/obj/machinery/nuclearbomb")
	var/object_path_txt
	//уникальный айди типа объекта в категории, выдается при регистарции в подсистеме
	var/uid = 0
	//метаданные вроде редкости и прочего, за пределами инвентаря не используются
	var/list/metadata
	//перменные, которые изменены у конкретного объекта
	var/list/var_overrides

/datum/metainv_object/New(obj_typepath, category = 0)
	. = ..()
	if(!obj_typepath || !isnum(category))
		return
	if(!istext(obj_typepath))
		obj_typepath = "[obj_typepath]"
	cid = category
	object_path_txt = obj_typepath
	uid = SSmetainv.get_new_uid(category, obj_typepath)

/datum/metainv_object/proc/get_id()
	if(!cid)
		return "[cid]:[object_path_txt]"
	return "[cid]:[object_path_txt]:[uid]"

/datum/metainv_object/proc/create_object(atom/location)
	var/object_path = text2path(object_path_txt)
	var/obj/O = new object_path(location)
	for(var/varname in var_overrides)
		O.vars[varname] = var_overrides[varname]
	return O

/datum/metainv_object/proc/can_create_for(mob/living/L, silent = FALSE)
	if(!metadata)
		return TRUE
	var/obj/O = text2path(object_path_txt)
	var/obj_name = (var_overrides && var_overrides["name"]) ? var_overrides["name"] : initial(O.name)
	if(metadata["role_whitelist"] || metadata["role_blacklist"])
		if(!L.mind || !L.mind.assigned_role)
			return FALSE
		if(metadata["role_whitelist"] && !(L.mind.assigned_role in metadata["role_whitelist"]))
			if(!silent)
				to_chat(L, span_warning("Должность не позволяет мне иметь [obj_name]!"))
			return FALSE
		if(metadata["role_blacklist"] && (L.mind.assigned_role in metadata["role_blacklist"]))
			if(!silent)
				to_chat(L, span_warning("Должность не позволяет мне иметь [obj_name]!"))
			return FALSE
	if(metadata["species_whitelist"] || metadata["species_blacklist"])
		if(!ishuman(L))
			return FALSE
		var/mob/living/carbon/human/H = L
		if(!H.dna) //хуманы без днк это борги и ии ебаные, какого-то хуя они ими становятся уже после становления хуманом при спавне за профу
			return FALSE
		if(metadata["species_whitelist"] && !(H.dna.species.id in metadata["species_whitelist"]))
			if(!silent)
				to_chat(L, span_warning("Раса не позволяет мне иметь [obj_name]!"))
			return FALSE
		if(metadata["species_blacklist"] && (H.dna.species.id in metadata["species_blacklist"]))
			if(!silent)
				to_chat(L, span_warning("Раса не позволяет мне иметь [obj_name]!"))
			return FALSE
	return TRUE

/datum/metainv_object/serialize_list(list/options)
	if(!cid)
		return
	if(!uid || !object_path_txt)
		stack_trace("Оторви себе руки пж пж")
		return
	. = list()
	.["CID"] = cid
	.["UID"] = uid
	.["OPT"] = object_path_txt
	if(metadata)
		.["MD"] = metadata
	if(var_overrides && var_overrides.len)
		.["VO"] = json_encode(var_overrides)

/datum/metainv_object/deserialize_list(list/input, list/options)
	if(!input["CID"] || !input["UID"] || !input["OPT"])
		return
	cid = input["CID"]
	uid = input["UID"]
	object_path_txt = input["OPT"]
	if(input["MD"])
		metadata = json_decode(input["R"])
	if(input["VO"])
		var_overrides = json_decode(input["VO"])
	return src

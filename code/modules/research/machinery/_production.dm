/obj/machinery/rnd/production
	name = "фабрикатор технологий"
	desc = "Изготавливает исследуемые и прототипы предметов с использованием материалов и энергии."
	layer = BELOW_OBJ_LAYER
	var/efficiency_coeff = 1				//Materials needed / coeff = actual.
	var/list/categories = list()
	var/datum/component/remote_materials/materials
	var/allowed_department_flags = ALL
	var/production_animation				//What's flick()'d on print.
	var/allowed_buildtypes = NONE
	var/list/datum/design/cached_designs
	var/list/datum/design/matching_designs
	var/department_tag = "Неизвестный"			//used for material distribution among other things.

	var/search = null
	var/selected_category = null

	var/list/mob/viewing_mobs = list()

/obj/machinery/rnd/production/Initialize(mapload)
	. = ..()
	create_reagents(0, OPENCONTAINER)
	matching_designs = list()
	cached_designs = list()
	update_designs()
	materials = AddComponent(/datum/component/remote_materials, "lathe", mapload, mat_container_flags=BREAKDOWN_FLAGS_LATHE)
	RefreshParts()

/obj/machinery/rnd/production/Destroy()
	materials = null
	cached_designs = null
	matching_designs = null
	return ..()

/obj/machinery/rnd/production/proc/update_designs()
	cached_designs.Cut()
	for(var/i in stored_research.researched_designs)
		var/datum/design/d = SSresearch.techweb_design_by_id(i)
		if((isnull(allowed_department_flags) || (d.departmental_flags & allowed_department_flags)) && (d.build_type & allowed_buildtypes))
			cached_designs |= d
	update_viewer_statics()

/obj/machinery/rnd/production/RefreshParts()
	. = ..()
	calculate_efficiency()
	update_viewer_statics()

/obj/machinery/rnd/production/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TechFab")
		ui.open()
		viewing_mobs += user

/obj/machinery/rnd/production/ui_close(mob/user)
	. = ..()
	viewing_mobs -= user

/obj/machinery/rnd/production/proc/update_viewer_statics()
	for(var/mob/M as() in viewing_mobs)
		if(QDELETED(M) || !(M.client || M.mind))
			continue
		update_static_data(M)

/obj/machinery/rnd/production/ui_data(mob/user)
	var/list/data = list()

	data["busy"] = busy
	data["efficiency"] = efficiency_coeff

	data["category"] = selected_category
	data["search"] = search

	return data

/obj/machinery/rnd/production/proc/build_materials()
	if(!materials || !materials.mat_container)
		return null

	var/list/L = list()
	for(var/datum/material/material as() in materials.mat_container.materials)
		L[material.name] = list(
				name = material.name,
				amount = materials.mat_container.materials[material]/MINERAL_MATERIAL_AMOUNT,
				id = material.id,
			)

	return list(
		materials = L,
		materials_label = materials.format_amount()
	)

/obj/machinery/rnd/production/proc/build_reagents()
	if(!reagents)
		return null

	var/list/L = list()
	for(var/datum/reagent/reagent as() in reagents.reagent_list)
		L["[reagent.type]"] = list(
				name = reagent.name,
				volume = reagent.volume,
				id = "[reagent.type]",
			)

	return list(
		reagents = L,
		reagents_label = "[reagents.total_volume] / [reagents.maximum_volume]"
	)

/obj/machinery/rnd/production/ui_static_data(mob/user)
	var/list/data = list()

	data["recipes"] = build_recipes()
	data["categories"] = categories
	data["stack_to_mineral"] = MINERAL_MATERIAL_AMOUNT

	data += build_materials()
	data += build_reagents()

	return data

/obj/machinery/rnd/production/proc/build_recipes()
	var/list/L = list()
	for(var/datum/design/design as() in cached_designs)
		L += list(build_design(design))
	return L

/obj/machinery/rnd/production/proc/build_design(datum/design/design)
	return list(
			name = design.name,
			description = design.desc,
			id = design.id,
			category = design.category,
			max_amount = design.maxstack,
			efficiency_affects = efficient_with(design.build_path),
			materials = design.materials,
			reagents = build_recipe_reagents(design.reagents_list),
		)

/obj/machinery/rnd/production/proc/build_recipe_reagents(list/reagents)
	var/list/L = list()

	for(var/id in reagents)
		L[id] = list(
			name = CallMaterialName(id),
			volume = reagents[id],
		)

	return L

/obj/machinery/rnd/production/ui_act(action, params)
	if(..())
		return
	if(action == "build")
		if(busy)
			playsound(src, 'white/valtos/sounds/error1.ogg', 20, TRUE)
			say("Внимание: Фабрикатор занят!")
		else
			user_try_print_id(params["design_id"], params["amount"])
			. = TRUE
	if(action == "sync_research")
		update_designs()
		playsound(src, 'white/valtos/sounds/click2.ogg', 20, TRUE)
		say("Синхронизация исследований с базой данных хост-технологий.")
		. = TRUE
	if(action == "dispose")
		var/R = text2path(params["reagent_id"])
		if(R)
			reagents.del_reagent(R)
			. = TRUE
	if(action == "disposeall")
		reagents.clear_reagents()
		. = TRUE
	if(action == "ejectsheet" && materials && materials.mat_container)
		var/datum/material/M
		for(var/datum/material/potential_material as() in materials.mat_container.materials)
			if(potential_material.id == text2path(params["material_id"]))
				M = potential_material
				break
		if(M)
			eject_sheets(M, params["amount"])
			. = TRUE
	if(action == "search")
		var/new_search = params["value"]
		if(new_search != search)
			search = new_search
			. = TRUE
	if(action == "category")
		var/new_category = params["category"]
		if(new_category != selected_category)
			search = null
			selected_category = new_category
			. = TRUE
	if(action == "mainmenu" && (search != null || selected_category != null))
		search = null
		selected_category = null
		. = TRUE

/obj/machinery/rnd/production/proc/calculate_efficiency()
	efficiency_coeff = 1
	if(reagents)		//If reagents/materials aren't initialized, don't bother, we'll be doing this again after reagents init anyways.
		reagents.maximum_volume = 0
		for(var/obj/item/reagent_containers/glass/G in component_parts)
			reagents.maximum_volume += G.volume
			G.reagents.trans_to(src, G.reagents.total_volume)
	if(materials)
		var/total_storage = 0
		for(var/obj/item/stock_parts/matter_bin/M in component_parts)
			total_storage += M.rating * 75000
		materials.set_local_size(total_storage)
	var/total_rating = 1.2
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		total_rating = clamp(total_rating - (M.rating * 0.1), 0, 1)
	if(total_rating == 0)
		efficiency_coeff = INFINITY
	else
		efficiency_coeff = 1/total_rating

//we eject the materials upon deconstruction.
/obj/machinery/rnd/production/on_deconstruction()
	for(var/obj/item/reagent_containers/glass/G in component_parts)
		reagents.trans_to(G, G.reagents.maximum_volume)
	return ..()

/obj/machinery/rnd/production/proc/do_print(path, amount, list/matlist, notify_admins)
	if(notify_admins)
		investigate_log("[key_name(usr)] built [amount] of [path] at [src]([type]).", INVESTIGATE_RESEARCH)
		message_admins("[ADMIN_LOOKUPFLW(usr)] has built [amount] of [path] at <b>[src.name]</b>([type]).")
	for(var/i in 1 to amount)
		var/obj/item/I = new path(get_turf(src))
		if(efficient_with(I.type))
			I.material_flags |= MATERIAL_NO_EFFECTS //Find a better way to do this.
			I.set_custom_materials(matlist)
	SSblackbox.record_feedback("nested tally", "item_printed", amount, list("[type]", "[path]"))

/**
 * Returns how many times over the given material requirement for the given design is satisfied.
 *
 * Arguments:
 * - [being_built][/datum/design]: The design being referenced.
 * - material: The material being checked.
 */
/obj/machinery/rnd/production/proc/check_material_req(datum/design/being_built, material)
	if(!materials.mat_container)  // no connected silo
		return 0

	var/mat_amt = materials.mat_container.get_material_amount(material)
	if(!mat_amt)
		return 0

	// these types don't have their .materials set in do_print, so don't allow
	// them to be constructed efficiently
	var/efficiency = efficient_with(being_built.build_path) ? efficiency_coeff : 1
	return round(mat_amt / max(1, being_built.materials[material] / efficiency))

/**
 * Returns how many times over the given reagent requirement for the given design is satisfied.
 *
 * Arguments:
 * - [being_built][/datum/design]: The design being referenced.
 * - reagent: The reagent being checked.
 */
/obj/machinery/rnd/production/proc/check_reagent_req(datum/design/being_built, reagent)
	if(!reagents)  // no reagent storage
		return 0

	var/chem_amt = reagents.get_reagent_amount(reagent)
	if(!chem_amt)
		return 0

	// these types don't have their .materials set in do_print, so don't allow
	// them to be constructed efficiently
	var/efficiency = efficient_with(being_built.build_path) ? efficiency_coeff : 1
	return round(chem_amt / max(1, being_built.reagents_list[reagent] / efficiency))

/obj/machinery/rnd/production/proc/efficient_with(path)
	return !ispath(path, /obj/item/stack/sheet) && !ispath(path, /obj/item/stack/ore/bluespace_crystal)

/obj/machinery/rnd/production/proc/user_try_print_id(id, amount)
	if(!id)
		return FALSE
	if(istext(amount))
		amount = text2num(amount)
	if(isnull(amount))
		amount = 1
	var/datum/design/D = stored_research.researched_designs[id] ? SSresearch.techweb_design_by_id(id) : null
	if(!istype(D))
		return FALSE
	if(!(isnull(allowed_department_flags) || (D.departmental_flags & allowed_department_flags)))
		playsound(src, 'white/valtos/sounds/error1.ogg', 20, TRUE)
		say("Внимание: Ошибка печати: У этого производителя нет необходимых ключей для расшифровки проектных схем. Обновите данные исследования с помощью экранной кнопки и обратитесь в службу поддержки NanoTrasen!")
		return FALSE
	if(D.build_type && !(D.build_type & allowed_buildtypes))
		playsound(src, 'white/valtos/sounds/error1.ogg', 20, TRUE)
		say("Эта машина не имеет необходимых систем манипулирования для этой конструкции. Обратитесь в службу поддержки NanoTrasen!")
		return FALSE
	if(!materials.mat_container)
		playsound(src, 'white/valtos/sounds/error1.ogg', 20, TRUE)
		say("Нет связи со складом материалов, обратитесь к завхозу.")
		return FALSE
	if(materials.on_hold())
		playsound(src, 'white/valtos/sounds/error1.ogg', 20, TRUE)
		say("Доступ к минералам приостановлен, обратитесь к завхозу.")
		return FALSE
	var/power = active_power_usage
	amount = clamp(amount, 1, 10)
	for(var/M in D.materials)
		power += round(D.materials[M] * amount / 35)
	power = min(active_power_usage, power)
	use_power(power)
	var/coeff = efficient_with(D.build_path) ? efficiency_coeff : 1
	var/list/efficient_mats = list()
	for(var/MAT in D.materials)
		efficient_mats[MAT] = D.materials[MAT]/coeff
	if(!materials.mat_container.has_materials(efficient_mats, amount))
		playsound(src, 'white/valtos/sounds/error1.ogg', 20, TRUE)
		say("Недостаточно материалов для завершения прототип[amount > 1? "ов" : "а"].")
		return FALSE
	for(var/R in D.reagents_list)
		if(!reagents.has_reagent(R, D.reagents_list[R]*amount/coeff))
			playsound(src, 'white/valtos/sounds/error1.ogg', 20, TRUE)
			say("Недостаточно химикатов для завершения прототипа[amount > 1? "ов" : "а"].")
			return FALSE
	materials.mat_container.use_materials(efficient_mats, amount)
	materials.silo_log(src, "built", -amount, "[D.name]", efficient_mats)
	for(var/R in D.reagents_list)
		reagents.remove_reagent(R, D.reagents_list[R]*amount/coeff)
	busy = TRUE
	if(production_animation)
		flick(production_animation, src)
	playsound(get_turf(src), "production", 50, TRUE)
	var/timecoeff = D.lathe_time_factor / efficiency_coeff
	addtimer(CALLBACK(src, PROC_REF(reset_busy)), (30 * timecoeff * amount) ** 0.5)
	addtimer(CALLBACK(src, PROC_REF(do_print), D.build_path, amount, efficient_mats, D.dangerous_construction), (32 * timecoeff * amount) ** 0.8)
	return TRUE

/obj/machinery/rnd/production/proc/eject_sheets(eject_sheet, eject_amt)
	var/datum/component/material_container/mat_container = materials.mat_container
	if (!mat_container)
		playsound(src, 'white/valtos/sounds/error1.ogg', 20, TRUE)
		say("Нет доступа к складу материалов, обратитесь к завхозу.")
		return 0
	if (materials.on_hold())
		playsound(src, 'white/valtos/sounds/error1.ogg', 20, TRUE)
		say("Доступ к минералам приостановлен, обратитесь к завхозу.")
		return 0
	var/count = mat_container.retrieve_sheets(text2num(eject_amt), eject_sheet, drop_location())
	var/list/matlist = list()
	matlist[eject_sheet] = MINERAL_MATERIAL_AMOUNT
	materials.silo_log(src, "ejected", -count, "sheets", matlist)
	return count

/obj/machinery/rnd/production/reset_busy()
	. = ..()
	SStgui.update_uis(src)

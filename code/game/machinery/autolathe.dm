#define AUTOLATHE_MAIN_MENU		1
#define AUTOLATHE_CATEGORY_MENU	2
#define AUTOLATHE_SEARCH_MENU	3

/obj/machinery/autolathe
	name = "автолат"
	desc = "Производит изделия из металла и стекла."
	icon_state = "autolathe"
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 10
	active_power_usage = 10000
	circuit = /obj/item/circuitboard/machine/autolathe
	layer = BELOW_OBJ_LAYER

	var/operating = FALSE
	var/list/L = list()
	var/list/LL = list()
	var/hacked = FALSE
	var/disabled = FALSE
	var/shocked = FALSE
	var/hack_wire
	var/disable_wire
	var/shock_wire

	var/busy = FALSE
	var/prod_coeff = 1

	var/datum/design/being_built
	var/datum/techweb/stored_research
	var/list/datum/design/matching_designs
	var/selected_category = "Ничего"
	var/base_price = 25
	var/hacked_price = 50

	var/list/categories = list(
							"Инструменты",
							"Электроника",
							"Конструкции",
							"Телекомы",
							"Безопасность",
							"Оборудование",
							"Медицина",
							"Разное",
							"Кухня",
							"Импорт"
							)

/obj/machinery/autolathe/Initialize()
	AddComponent(/datum/component/material_container, SSmaterials.materials_by_category[MAT_CATEGORY_ITEM_MATERIAL], 0, MATCONTAINER_EXAMINE, _after_insert = CALLBACK(src, .proc/AfterMaterialInsert))
	. = ..()

	wires = new /datum/wires/autolathe(src)
	stored_research = new /datum/techweb/specialized/autounlocking/autolathe
	matching_designs = list()

/obj/machinery/autolathe/Destroy()
	QDEL_NULL(wires)
	return ..()

/obj/machinery/autolathe/ui_interact(mob/user, datum/tgui/ui)
	if(!is_operational)
		return

	if(shocked && !(machine_stat & NOPOWER))
		shock(user,50)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Autolathe")
		ui.open()

/obj/machinery/autolathe/ui_data(mob/user)
	var/list/data = list()
	data["materials"] = list()
	var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
	data["materialtotal"] = materials.total_amount
	data["materialsmax"] = materials.max_amount
	data["categories"] = categories
	data["designs"] = list()
	data["active"] = busy

	for(var/mat_id in materials.materials)
		var/datum/material/M = mat_id
		var/mineral_count = materials.materials[mat_id]
		var/list/material_data = list(
			name = M.name,
			mineral_amount = mineral_count
		)
		data["materials"] += list(material_data)
	if(selected_category != "Ничего" && !length(matching_designs))
		data["designs"] = handle_designs(stored_research.researched_designs, TRUE)
	else
		data["designs"] = handle_designs(matching_designs, FALSE)
	return data

/obj/machinery/autolathe/proc/handle_designs(list/designs, categorycheck)
	var/list/output = list()
	for(var/v in designs)
		var/datum/design/D = categorycheck ? SSresearch.techweb_design_by_id(v) : v
		if(categorycheck)
			if(!(selected_category in D.category))
				continue
		var/unbuildable = FALSE // we can't build the design currently
		var/m10 = FALSE // 10x mult
		var/m25 = FALSE // 25x mult
		var/m50 = FALSE // 50x mult
		var/m5 = FALSE // 5x mult
		var/sheets = FALSE // sheets or no?
		if(disabled || !can_build(D))
			unbuildable = TRUE
		var/max_multiplier = unbuildable ? 0 : 1
		if(ispath(D.build_path, /obj/item/stack))
			sheets = TRUE
			if(!unbuildable)
				var/datum/component/material_container/mats = GetComponent(/datum/component/material_container)
				for(var/datum/material/mat in D.materials)
					max_multiplier = min(D.maxstack, round(mats.get_material_amount(mat)/D.materials[mat]))
				if (max_multiplier>10 && !disabled)
					m10 = TRUE
				if (max_multiplier>25 && !disabled)
					m25 = TRUE
		else
			if(!unbuildable)
				if(!disabled && can_build(D, 5))
					m5 = TRUE
				if(!disabled && can_build(D, 10))
					m10 = TRUE
				var/datum/component/material_container/mats = GetComponent(/datum/component/material_container)
				for(var/datum/material/mat in D.materials)
					max_multiplier = min(50, round(mats.get_material_amount(mat)/(D.materials[mat])))

		var/list/design = list(
			name = D.name,
			id = D.id,
			ref = REF(src),
			cost = get_design_cost(D),
			buildable = unbuildable,
			mult5 = m5,
			mult10 = m10,
			mult25 = m25,
			mult50 = m50,
			sheet = sheets,
			maxmult = max_multiplier,
		)
		output += list(design)
	return output

/obj/machinery/autolathe/ui_act(action, params)
	. = ..()
	if(.)
		return
	if(action == "menu")
		selected_category = null
		matching_designs.Cut()
		. = TRUE

	if(action == "category")
		selected_category = params["selectedCategory"]
		matching_designs.Cut()
		. = TRUE

	if(action == "search")
		matching_designs.Cut()

		for(var/v in stored_research.researched_designs)
			var/datum/design/D = SSresearch.techweb_design_by_id(v)
			if(findtext(D.name,params["to_search"]))
				matching_designs.Add(D)
		. = TRUE

	if(action == "make")
		if (!busy)
			/////////////////
			//href protection
			being_built = stored_research.isDesignResearchedID(params["id"])
			if(!being_built)
				return

			var/multiplier = text2num(params["multiplier"])
			if(!multiplier)
				to_chat(usr, "<span class=\"alert\">[capitalize(src.name)] принимает только циферки!</span>")
				return
			var/is_stack = ispath(being_built.build_path, /obj/item/stack)
			multiplier = clamp(round(multiplier),1,50)

			/////////////////

			var/coeff = (is_stack ? 1 : prod_coeff) //stacks are unaffected by production coefficient
			var/total_amount = 0

			for(var/MAT in being_built.materials)
				total_amount += being_built.materials[MAT]

			var/power = max(2000, (total_amount)*multiplier/5) //Change this to use all materials

			var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)

			var/list/materials_used = list()
			var/list/custom_materials = list() //These will apply their material effect, This should usually only be one.

			for(var/MAT in being_built.materials)
				var/datum/material/used_material = MAT
				var/amount_needed = being_built.materials[MAT] * coeff * multiplier
				if(istext(used_material)) //This means its a category
					var/list/list_to_show = list()
					for(var/i in SSmaterials.materials_by_category[used_material])
						if(materials.materials[i] > 0)
							list_to_show += i

					used_material = input("Выбирайте мудро [used_material]", "Материал") as null|anything in sortList(list_to_show, /proc/cmp_typepaths_asc)
					if(!used_material)
						return //Didn't pick any material, so you can't build shit either.
					custom_materials[used_material] += amount_needed

				materials_used[used_material] = amount_needed

			if(materials.has_materials(materials_used))
				busy = TRUE
				to_chat(usr, "<span class=\"notice\">Удалось распечатать [multiplier] предметов в [src]</span>")
				use_power(power)
				icon_state = "autolathe_n"
				var/time = is_stack ? 32 : (32 * coeff * multiplier) ** 0.8
				addtimer(CALLBACK(src, .proc/make_item, power, materials_used, custom_materials, multiplier, coeff, is_stack, usr), time)
				. = TRUE
			else
				to_chat(usr, "<span class=\"alert\">Недостаточно материалов для этой операции.</span>")
		else
			to_chat(usr, "<span class=\"alert\">Автолат занят. Дождитесь завершения предыдущей операции.</span>")

/obj/machinery/autolathe/on_deconstruction()
	var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
	materials.retrieve_all()

/obj/machinery/autolathe/attackby(obj/item/O, mob/living/user, params)
	if (busy)
		to_chat(user, "<span class=\"alert\">Автолат занят. Дождитесь завершения предыдущей операции.</span>")
		return TRUE

	if(default_deconstruction_screwdriver(user, "autolathe_t", "autolathe", O))
		return TRUE

	if(default_deconstruction_crowbar(O))
		return TRUE

	if(panel_open && is_wire_tool(O))
		wires.interact(user)
		return TRUE

	if(user.a_intent == INTENT_HARM) //so we can hit the machine
		return ..()

	if(machine_stat)
		return TRUE

	if(istype(O, /obj/item/disk/design_disk))
		user.visible_message(span_notice("[user] начинает загружать [O] в [src]...") ,
			span_notice("Начинаю загружать [O]...") ,
			span_hear("Слышу шелест дискет."))
		busy = TRUE
		var/obj/item/disk/design_disk/D = O
		if(do_after(user, 14.4, target = src))
			for(var/B in D.blueprints)
				if(B)
					stored_research.add_design(B)
		busy = FALSE
		return TRUE

	return ..()


/obj/machinery/autolathe/proc/AfterMaterialInsert(obj/item/item_inserted, id_inserted, amount_inserted)
	if(istype(item_inserted, /obj/item/stack/ore/bluespace_crystal))
		use_power(MINERAL_MATERIAL_AMOUNT / 10)
	else if(item_inserted.has_material_type(/datum/material/glass))
		flick("autolathe_r", src)//plays glass insertion animation by default otherwise
	else
		flick("autolathe_o", src)//plays metal insertion animation

		use_power(min(1000, amount_inserted / 100))

/obj/machinery/autolathe/proc/make_item(power, list/materials_used, list/picked_materials, multiplier, coeff, is_stack, mob/user)
	var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
	var/atom/A = drop_location()
	use_power(power)

	materials.use_materials(materials_used)

	if(is_stack)
		var/obj/item/stack/N = new being_built.build_path(A, multiplier, FALSE)
		N.update_icon()
		N.autolathe_crafted(src)

		if(length(picked_materials))
			N.set_custom_materials(picked_materials, 1 / multiplier) //Ensure we get the non multiplied amount
			for(var/x in picked_materials)
				var/datum/material/M = x
				if(!istype(M, /datum/material/glass) && !istype(M, /datum/material/iron))
					user.client.give_award(/datum/award/achievement/misc/getting_an_upgrade, user)

	else
		for(var/i=1, i<=multiplier, i++)
			var/obj/item/new_item = new being_built.build_path(A)
			new_item.autolathe_crafted(src)

			if(length(picked_materials))
				new_item.set_custom_materials(picked_materials, 1 / multiplier) //Ensure we get the non multiplied amount
				for(var/x in picked_materials)
					var/datum/material/M = x
					if(!istype(M, /datum/material/glass) && !istype(M, /datum/material/iron))
						user.client.give_award(/datum/award/achievement/misc/getting_an_upgrade, user)


	icon_state = "autolathe"
	busy = FALSE

/obj/machinery/autolathe/RefreshParts()
	var/T = 0
	for(var/obj/item/stock_parts/matter_bin/MB in component_parts)
		T += MB.rating*75000
	var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
	materials.max_amount = T
	T=1.2
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		T -= M.rating*0.2
	prod_coeff = min(1,max(0,T)) // Coeff going 1 -> 0,8 -> 0,6 -> 0,4

/obj/machinery/autolathe/examine(mob/user)
	. += ..()
	var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
	if(in_range(user, src) || isobserver(user))
		. += "<hr><span class='notice'>Дисплей: Хранение до <b>[materials.max_amount]</b> юнитов.<br>Потребление материалов <b>[prod_coeff*100]%</b>.</span>"

/obj/machinery/autolathe/proc/can_build(datum/design/D, amount = 1)
	if(D.make_reagents.len)
		return FALSE

	var/coeff = (ispath(D.build_path, /obj/item/stack) ? 1 : prod_coeff)

	var/list/required_materials = list()

	for(var/i in D.materials)
		required_materials[i] = D.materials[i] * coeff * amount

	var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)

	return materials.has_materials(required_materials)


/obj/machinery/autolathe/proc/get_design_cost(datum/design/D)
	var/coeff = (ispath(D.build_path, /obj/item/stack) ? 1 : prod_coeff)
	var/dat
	for(var/i in D.materials)
		if(istext(i)) //Category handling
			dat += "[D.materials[i] * coeff] [i]"
		else
			var/datum/material/M = i
			dat += "[D.materials[i] * coeff] [M.name] "
	return dat

/obj/machinery/autolathe/proc/reset(wire)
	switch(wire)
		if(WIRE_HACK)
			if(!wires.is_cut(wire))
				adjust_hacked(FALSE)
		if(WIRE_SHOCK)
			if(!wires.is_cut(wire))
				shocked = FALSE
		if(WIRE_DISABLE)
			if(!wires.is_cut(wire))
				disabled = FALSE

/obj/machinery/autolathe/proc/shock(mob/user, prb)
	if(machine_stat & (BROKEN|NOPOWER))		// unpowered, no shock
		return FALSE
	if(!prob(prb))
		return FALSE
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(5, 1, src)
	s.start()
	if (electrocute_mob(user, get_area(src), src, 0.7, TRUE))
		return TRUE
	else
		return FALSE

/obj/machinery/autolathe/proc/adjust_hacked(state)
	hacked = state
	for(var/id in SSresearch.techweb_designs)
		var/datum/design/D = SSresearch.techweb_design_by_id(id)
		if((D.build_type & AUTOLATHE) && ("hacked" in D.category))
			if(hacked)
				stored_research.add_design(D)
			else
				stored_research.remove_design(D)

/obj/machinery/autolathe/hacked/Initialize()
	. = ..()
	adjust_hacked(TRUE)

//Called when the object is constructed by an autolathe
//Has a reference to the autolathe so you can do !!FUN!! things with hacked lathes
/obj/item/proc/autolathe_crafted(obj/machinery/autolathe/A)
	return

/datum/crafting_recipe/improv_explosive
	name = "СВУ"
	result = /obj/item/grenade/iedcasing
	reqs = list(/datum/reagent/fuel = 50,
				/obj/item/stack/cable_coil = 1,
				/obj/item/assembly/igniter = 1,
				/obj/item/reagent_containers/food/drinks/soda_cans = 1)
	parts = list(/obj/item/reagent_containers/food/drinks/soda_cans = 1)
	time = 15
	category = CAT_CHEMISTRY

/datum/crafting_recipe/molotov
	name = "Коктейль Молотова"
	result = /obj/item/reagent_containers/food/drinks/bottle/molotov
	reqs = list(/obj/item/reagent_containers/glass/rag = 1,
				/obj/item/reagent_containers/food/drinks/bottle = 1)
	parts = list(/obj/item/reagent_containers/food/drinks/bottle = 1)
	time = 40
	category = CAT_CHEMISTRY

/datum/crafting_recipe/chemical_payload
	name = "Химический боезаряд"
	result = /obj/item/bombcore/chemical
	reqs = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/grenade/c4 = 1,
		/obj/item/grenade/chem_grenade = 2
	)
	parts = list(/obj/item/stock_parts/matter_bin = 1, /obj/item/grenade/chem_grenade = 2)
	time = 30
	category = CAT_CHEMISTRY

/datum/crafting_recipe/chemical_payload2
	name = "Химический боезаряд (Гибтонит)"
	result = /obj/item/bombcore/chemical
	reqs = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/gibtonite = 1,
		/obj/item/grenade/chem_grenade = 2
	)
	parts = list(/obj/item/stock_parts/matter_bin = 1, /obj/item/grenade/chem_grenade = 2)
	time = 50
	category = CAT_CHEMISTRY

/datum/crafting_recipe/alcohol_burner
	name = "Спиртовая горелка"
	result = /obj/item/burner
	time = 5 SECONDS
	reqs = list(/obj/item/reagent_containers/glass/beaker  = 1,
				/datum/reagent/consumable/ethanol = 15,
				/obj/item/paper = 1
				)
	category = CAT_CHEMISTRY

/datum/crafting_recipe/oil_burner
	name = "Масляная горелка"
	result = /obj/item/burner/oil
	time = 5 SECONDS
	reqs = list(/obj/item/reagent_containers/glass/beaker  = 1,
				/datum/reagent/fuel/oil = 15,
				/obj/item/paper = 1
				)
	category = CAT_CHEMISTRY

/datum/crafting_recipe/fuel_burner
	name = "Топливная горелка"
	result = /obj/item/burner/fuel
	time = 5 SECONDS
	reqs = list(/obj/item/reagent_containers/glass/beaker  = 1,
				/datum/reagent/fuel = 15,
				/obj/item/paper = 1
				)
	category = CAT_CHEMISTRY

/datum/crafting_recipe/thermometer
	name = "Термометр"
	tool_behaviors = list(TOOL_WELDER)
	result = /obj/item/thermometer
	time = 5 SECONDS
	reqs = list(
				/datum/reagent/mercury = 5,
				/obj/item/stack/sheet/glass = 1
				)
	category = CAT_CHEMISTRY

/datum/crafting_recipe/thermometer_alt
	name = "Термометр"
	result = /obj/item/thermometer/pen
	time = 5 SECONDS
	reqs = list(
				/datum/reagent/mercury = 5,
				/obj/item/pen = 1
				)
	category = CAT_CHEMISTRY

/datum/crafting_recipe/ph_booklet
	name = "pH тест"
	result = /obj/item/ph_booklet
	time = 5 SECONDS
	reqs = list(
				/datum/reagent/universal_indicator = 5,
				/obj/item/paper = 1
				)
	category = CAT_CHEMISTRY

/datum/crafting_recipe/dropper //Maybe make a glass pipette icon?
	name = "Пипетка"
	result = /obj/item/reagent_containers/dropper
	tool_behaviors = list(TOOL_WELDER)
	time = 5 SECONDS
	reqs = list(
				/obj/item/stack/sheet/glass  = 1,
				)
	category = CAT_CHEMISTRY

/datum/crafting_recipe/improvised_chem_heater
	name = "Самодельный нагреватель химикатов"
	result = /obj/machinery/space_heater/improvised_chem_heater
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_MULTITOOL, TOOL_WIRECUTTER)
	time = 15 SECONDS
	reqs = list(
				/obj/item/stack/cable_coil = 2,
				/obj/item/stack/sheet/glass = 2,
				/obj/item/stack/sheet/iron = 2,
				/datum/reagent/water = 50,
				/obj/item/thermometer = 1
				)
	machinery = list(/obj/machinery/space_heater = CRAFTING_MACHINERY_CONSUME)
	category = CAT_CHEMISTRY

/datum/crafting_recipe/improvised_chem_heater/on_craft_completion(mob/user, atom/result)
	var/obj/item/stock_parts/cell/cell = locate(/obj/item/stock_parts/cell) in range(1)
	if(!cell)
		return
	var/obj/machinery/space_heater/improvised_chem_heater/heater = result
	var/turf/turf = get_turf(cell)
	heater.forceMove(turf)
	heater.attackby(cell, user) //puts it into the heater

/datum/crafting_recipe/improvised_coolant
	name = "Самодельный охлаждающий спрей"
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	result = /obj/item/extinguisher/crafted
	time = 10 SECONDS
	reqs = list(
			/obj/item/toy/crayon/spraycan = 1,
			/datum/reagent/water = 20,
			/datum/reagent/consumable/ice = 10
			)
	category = CAT_CHEMISTRY

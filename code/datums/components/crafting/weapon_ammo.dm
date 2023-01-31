/datum/crafting_recipe/meteorslug
	name = "Метеоритный патрон"
	result = /obj/item/ammo_casing/shotgun/meteorslug
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/obj/item/rcd_ammo = 1,
				/obj/item/stock_parts/manipulator = 2)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/pulseslug
	name = "Имульсный патрон"
	result = /obj/item/ammo_casing/shotgun/pulseslug
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/obj/item/stock_parts/capacitor/adv = 2,
				/obj/item/stock_parts/micro_laser/ultra = 1)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/dragonsbreath
	name = "Патрон \"Дыхание дракона\""
	result = /obj/item/ammo_casing/shotgun/dragonsbreath
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1, /datum/reagent/phosphorus = 5)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/frag12
	name = "Разрывной патрон"
	result = /obj/item/ammo_casing/shotgun/frag12
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/datum/reagent/glycerol = 5,
				/datum/reagent/toxin/acid = 5,
				/datum/reagent/toxin/acid/fluacid = 5)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/ionslug
	name = "Ионная картечь"
	result = /obj/item/ammo_casing/shotgun/ion
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/obj/item/stock_parts/micro_laser/ultra = 1,
				/obj/item/stock_parts/subspace/crystal = 1)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/improvisedslug
	name = "Самодельный картечный патрон"
	result = /obj/item/ammo_casing/shotgun/improvised
	reqs = list(/obj/item/stack/sheet/iron = 2,
				/obj/item/stack/cable_coil = 1,
				/datum/reagent/fuel = 10)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 12
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/laserslug
	name = "Лазерная картечь"
	result = /obj/item/ammo_casing/shotgun/laserslug
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/obj/item/stock_parts/capacitor/adv = 1,
				/obj/item/stock_parts/micro_laser/high = 1)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/trashball
	name = "Мусорный шар"
	always_available = FALSE
	result = /obj/item/stack/cannonball/trashball
	reqs = list(
		/obj/item/stack/sheet = 5,
		/datum/reagent/consumable/space_cola = 10,
	)
	category = CAT_WEAPON_AMMO

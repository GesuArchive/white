/datum/crafting_recipe/bola
	name = "Бола"
	result = /obj/item/restraints/legcuffs/bola
	reqs = list(/obj/item/restraints/handcuffs/cable = 1,
				/obj/item/stack/sheet/iron = 6)
	time = 20 //15 faster than crafting them by hand!
	category= CAT_WEAPON_RANGED

/datum/crafting_recipe/gonbola
	name = "Гонбола"
	result = /obj/item/restraints/legcuffs/bola/gonbola
	reqs = list(/obj/item/restraints/handcuffs/cable = 1,
				/obj/item/stack/sheet/iron = 6,
				/obj/item/stack/sheet/animalhide/gondola = 1)
	time = 40
	category= CAT_WEAPON_RANGED

/datum/crafting_recipe/advancedegun
	name = "Продвинутая энергетическая винтовка"
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	result = /obj/item/gun/energy/e_gun/nuclear
	reqs = list(/obj/item/gun/energy/e_gun = 1,
				/obj/item/stack/cable_coil = 5,
				/obj/item/weaponcrafting/gunkit/nuclear = 1)
	time = 200
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/advancedegun/New()
	..()
	blacklist += subtypesof(/obj/item/gun/energy/e_gun)

/datum/crafting_recipe/tempgun
	name = "Температурная винтовка"
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	result = /obj/item/gun/energy/temperature
	reqs = list(/obj/item/gun/energy/e_gun = 1,
				/obj/item/stack/cable_coil = 5,
				/obj/item/weaponcrafting/gunkit/temperature = 1)
	time = 200
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/tempgun/New()
	..()
	blacklist += subtypesof(/obj/item/gun/energy/e_gun)

/datum/crafting_recipe/beam_rifle
	name = "Винтовка ускорения частиц"
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	result = /obj/item/gun/energy/beam_rifle
	reqs = list(/obj/item/gun/energy/e_gun = 1,
				/obj/item/assembly/signaler/anomaly/flux = 1,
				/obj/item/assembly/signaler/anomaly/grav = 1,
				/obj/item/stack/cable_coil = 5,
				/obj/item/weaponcrafting/gunkit/beam_rifle = 1)
	time = 200
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/beam_rifle/New()
	..()
	blacklist += subtypesof(/obj/item/gun/energy/e_gun)

/datum/crafting_recipe/ebow
	name = "Энергетический арбалет"
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	result = /obj/item/gun/energy/kinetic_accelerator/crossbow/large
	reqs = list(/obj/item/gun/energy/kinetic_accelerator = 1,
				/obj/item/stack/cable_coil = 5,
				/obj/item/weaponcrafting/gunkit/ebow = 1,
				/datum/reagent/uranium/radium = 15)
	time = 200
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/ebow/New()
	..()
	blacklist += subtypesof(/obj/item/gun/energy/kinetic_accelerator)

/datum/crafting_recipe/xraylaser
	name = "Рентгеновская лазерная винтовка"
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	result = /obj/item/gun/energy/xray
	reqs = list(/obj/item/gun/energy/laser = 1,
				/obj/item/stack/cable_coil = 5,
				/obj/item/weaponcrafting/gunkit/xray = 1)
	time = 200
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/xraylaser/New()
	..()
	blacklist += subtypesof(/obj/item/gun/energy/laser)

/datum/crafting_recipe/hellgun
	name = "Лазерная пушка \"Адское пламя\""
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	result = /obj/item/gun/energy/laser/hellgun
	reqs = list(/obj/item/gun/energy/laser = 1,
				/obj/item/stack/cable_coil = 5,
				/obj/item/weaponcrafting/gunkit/hellgun = 1)
	time = 200
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/hellgun/New()
	..()
	blacklist += subtypesof(/obj/item/gun/energy/laser)

/datum/crafting_recipe/ioncarbine
	name = "Ионный карабин"
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	result = /obj/item/gun/energy/ionrifle/carbine
	reqs = list(/obj/item/gun/energy/laser = 1,
				/obj/item/stack/cable_coil = 5,
				/obj/item/weaponcrafting/gunkit/ion = 1)
	time = 200
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/ioncarbine/New()
	..()
	blacklist += subtypesof(/obj/item/gun/energy/laser)

/datum/crafting_recipe/decloner
	name = "Клеточный Демолекуляризатор"
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	result = /obj/item/gun/energy/decloner
	reqs = list(/obj/item/gun/energy/laser = 1,
				/obj/item/stack/cable_coil = 5,
				/obj/item/weaponcrafting/gunkit/decloner = 1,
				/datum/reagent/baldium = 30,
				/datum/reagent/toxin/mutagen = 40)
	time = 200
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/decloner/New()
	..()
	blacklist += subtypesof(/obj/item/gun/energy/laser)

/datum/crafting_recipe/teslacannon
	name = "Пушка Теслы"
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	result = /obj/item/gun/energy/tesla_cannon
	reqs = list(/obj/item/assembly/signaler/anomaly/flux = 1,
				/obj/item/stack/cable_coil = 5,
				/obj/item/weaponcrafting/gunkit/tesla = 1)
	time = 200
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/improvised_pneumatic_cannon //Pretty easy to obtain but
	name = "Самодельная пневмопушка"
	result = /obj/item/pneumatic_cannon/ghetto
	tool_behaviors = list(TOOL_WELDER, TOOL_WRENCH)
	reqs = list(/obj/item/stack/sheet/iron = 4,
				/obj/item/stack/package_wrap = 8,
				/obj/item/pipe = 2)
	time = 50
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/flamethrower
	name = "Огнемет"
	result = /obj/item/flamethrower
	reqs = list(/obj/item/weldingtool = 1,
				/obj/item/assembly/igniter = 1,
				/obj/item/stack/rods = 1)
	parts = list(/obj/item/assembly/igniter = 1,
				/obj/item/weldingtool = 1)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 10
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/ishotgun
	name = "Самодельный дробовик"
	result = /obj/item/gun/ballistic/shotgun/doublebarrel/improvised
	reqs = list(/obj/item/weaponcrafting/receiver = 1,
				/obj/item/pipe = 1,
				/obj/item/weaponcrafting/stock = 1,
				/obj/item/stack/sticky_tape = 1)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 50
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/trash_cannon
	name = "Мусорная пушка"
	always_available = FALSE
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER)
	result = /obj/structure/cannon/trash
	reqs = list(
		/obj/item/melee/skateboard/improvised = 1,
		/obj/item/tank/internals/oxygen = 1,
		/datum/reagent/drug/maint/tar = 15,
		/obj/item/restraints/handcuffs/cable = 1,
		/obj/item/storage/toolbox = 1,
	)
	category = CAT_WEAPON_RANGED

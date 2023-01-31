/datum/crafting_recipe/ed209
	name = "ED209"
	result = /mob/living/simple_animal/bot/secbot/ed209
	reqs = list(/obj/item/robot_suit = 1,
				/obj/item/clothing/head/helmet = 1,
				/obj/item/clothing/suit/armor/vest = 1,
				/obj/item/bodypart/l_leg/robot = 1,
				/obj/item/bodypart/r_leg/robot = 1,
				/obj/item/stack/sheet/iron = 1,
				/obj/item/stack/cable_coil = 1,
				/obj/item/gun/energy/disabler = 1,
				/obj/item/assembly/prox_sensor = 1)
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER)
	time = 60
	category = CAT_ROBOT

/datum/crafting_recipe/secbot
	name = "Офицер Бибски"
	result = /mob/living/simple_animal/bot/secbot
	reqs = list(/obj/item/assembly/signaler = 1,
				/obj/item/clothing/head/helmet/sec = 1,
				/obj/item/melee/baton = 1,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/bodypart/r_arm/robot = 1)
	tool_behaviors = list(TOOL_WELDER)
	time = 60
	category = CAT_ROBOT

/datum/crafting_recipe/cleanbot
	name = "Бот уборщик"
	result = /mob/living/simple_animal/bot/cleanbot
	reqs = list(/obj/item/reagent_containers/glass/bucket = 1,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/bodypart/r_arm/robot = 1)
	time = 40
	category = CAT_ROBOT

/datum/crafting_recipe/floorbot
	name = "Ремонтник полов"
	result = /mob/living/simple_animal/bot/floorbot
	reqs = list(/obj/item/storage/toolbox = 1,
				/obj/item/stack/tile/plasteel = 10,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/bodypart/r_arm/robot = 1)
	time = 40
	category = CAT_ROBOT

/datum/crafting_recipe/medbot
	name = "Медицинский бот"
	result = /mob/living/simple_animal/bot/medbot
	reqs = list(/obj/item/healthanalyzer = 1,
				/obj/item/storage/firstaid = 1,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/bodypart/r_arm/robot = 1)
	time = 40
	category = CAT_ROBOT

/datum/crafting_recipe/honkbot
	name = "Хонкобот"
	result = /mob/living/simple_animal/bot/honkbot
	reqs = list(/obj/item/storage/box/clown = 1,
				/obj/item/bodypart/r_arm/robot = 1,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/bikehorn/ = 1)
	time = 40
	category = CAT_ROBOT

/datum/crafting_recipe/firebot
	name = "Пожарный бот"
	result = /mob/living/simple_animal/bot/firebot
	reqs = list(/obj/item/extinguisher = 1,
				/obj/item/bodypart/r_arm/robot = 1,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/clothing/head/hardhat/red = 1)
	time = 40
	category = CAT_ROBOT

/datum/crafting_recipe/vibebot
	name = "Вайб бот"
	result = /mob/living/simple_animal/bot/vibebot
	reqs = list(/obj/item/light/bulb = 2,
				/obj/item/bodypart/head/robot = 1,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/toy/crayon = 1)
	time = 40
	category = CAT_ROBOT

/datum/crafting_recipe/hygienebot
	name = "Гигиенический бот"
	result = /mob/living/simple_animal/bot/hygienebot
	reqs = list(/obj/item/bot_assembly/hygienebot = 1,
				/obj/item/stack/ducts = 1,
				/obj/item/assembly/prox_sensor = 1)
	tool_behaviors = list(TOOL_WELDER)
	time = 40
	category = CAT_ROBOT

/datum/crafting_recipe/vim
	name = "Вим"
	result = /obj/vehicle/sealed/car/vim
	reqs = list(/obj/item/clothing/head/helmet/space/eva = 1,
				/obj/item/bodypart/l_leg/robot = 1,
				/obj/item/bodypart/r_leg/robot = 1,
				/obj/item/flashlight = 1,
				/obj/item/assembly/voice = 1)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 6 SECONDS //Has a four second do_after when building manually
	category = CAT_ROBOT

/datum/crafting_recipe/atmosbot
	name = "Атмос бот"
	result = /mob/living/simple_animal/bot/atmosbot
	reqs = list(/obj/item/analyzer = 1,
				/obj/item/bodypart/r_arm/robot = 1,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/tank/internals = 1)
	time = 40
	category = CAT_ROBOT

/datum/crafting_recipe/mod_core_standard
	name = "MOD ядро (Стандартное)"
	result = /obj/item/mod/core/standard
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 10 SECONDS
	reqs = list(/obj/item/stack/cable_coil = 5,
				/obj/item/stack/rods = 2,
				/obj/item/stack/sheet/glass = 1,
				/obj/item/organ/heart/ethereal = 1,
				)
	category = CAT_ROBOT

/datum/crafting_recipe/mod_core_ethereal
	name = "MOD ядро (Этериал)"
	result = /obj/item/mod/core/ethereal
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 10 SECONDS
	reqs = list(/datum/reagent/consumable/liquidelectricity = 5,
				/obj/item/stack/cable_coil = 5,
				/obj/item/stack/rods = 2,
				/obj/item/stack/sheet/glass = 1,
				/obj/item/reagent_containers/syringe = 1,
				)
	category = CAT_ROBOT

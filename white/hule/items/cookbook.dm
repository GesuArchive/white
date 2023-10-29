/*
#define TOOL_COOKBOOK 		"cookbook"

/obj/item/book/cookbook
	name = "generic russian cookbook"
	desc = "Обычная книга с надписью <<Русская кухня>> - Содержит пошаговые инструкции сборки различного самодельного снаряжения из металла, клея и бутылки водки."
	icon_state ="demonomicon"
	lefthand_file = 'icons/mob/inhands/misc/books_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/books_righthand.dmi'
	throw_speed = 1
	throw_range = 10
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	author = "Forces beyond your comprehension"
	unique = 1
	title = "the Russian Cookbook"
	tool_behaviour = TOOL_COOKBOOK
	dat = {"<html><body>
	<img src=https://pp.userapi.com/c306902/v306902481/11e6/7YOW5xnctHU.jpg>
	<br>
	<img src=https://pp.userapi.com/c306902/v306902481/1257/5swZEHEzVCs.jpg>
	<br>
	<img src=https://pp.userapi.com/c306902/v306902481/142e/YlRwVsqEQbY.jpg>
	<br>
	<img src=https://pp.userapi.com/c306902/v306902481/1480/6oFGL30v8DA.jpg>
	<br>
	<img src=https://pp.userapi.com/c306903/v306903481/2a80/074GF0u69Bo.jpg>
	<br>
	<img src=https://pp.userapi.com/c306903/v306903481/2cad/0TMt0vRWFEk.jpg>
	<br>
	<img src=https://pp.userapi.com/c319529/v319529481/227a/g0QZqwKnwIM.jpg>
	</body>
	</html>"}
*/

#define CAT_COOKBOOK	"Cookbook"

/obj/item/book/granter/crafting_recipe/cookbook
	name = "generic russian cookbook"
	desc = "Обычная книга с надписью <<Русская кухня>> - Содержит пошаговые инструкции сборки различного самодельного снаряжения из металла, клея и бутылки водки."
	crafting_recipe_types = list(
									/datum/crafting_recipe/cookbook/mshotgun,
									/datum/crafting_recipe/cookbook/mshotgunmag,
									/datum/crafting_recipe/cookbook/npgrenade,
									/datum/crafting_recipe/cookbook/grenadeprimer,
									/datum/crafting_recipe/cookbook/poleaxe,
									/datum/crafting_recipe/cookbook/plastid
								)

/datum/uplink_item/cookbook
	name = "Cookbook"
	category = "Devices and Tools"
	desc = "Очень интересная и познавательная книга."
	item = /obj/item/book/granter/crafting_recipe/cookbook
	cost = 2
	surplus = 10

/datum/uplink_item/badass/fate_dice
	name = "Fate D20"
	desc = "Prikol."
	item = /obj/item/dice/d20/fate/one_use
	cost = 20

/datum/crafting_recipe/cookbook
	always_available = FALSE

/datum/crafting_recipe/cookbook/mshotgun
	name = "Самодельный дробовик"
	result = /obj/item/gun/ballistic/shotgun/makeshift
	reqs = list(/obj/item/weaponcrafting/receiver = 1,
				/obj/item/pipe = 1,
				/obj/item/stack/sheet/iron = 20,
				/obj/item/stack/rods = 5)
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER, TOOL_WIRECUTTER, TOOL_WRENCH)
	time = 150
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/cookbook/mshotgunmag
	name = "Самодельный магазин для дробовика"
	result = /obj/item/ammo_box/magazine/makeshift
	reqs = list(/obj/item/stack/sheet/iron = 5,
				/obj/item/stack/rods = 4)
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER, TOOL_WRENCH)
	time = 75
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/cookbook/npgrenade
	name = "Нервно-паралитическая газовая граната"
	result = /obj/item/grenade/chem_grenade/npgrenade
	reqs = list(/datum/reagent/toxin/mindbreaker = 10,
				/datum/reagent/drug/krokodil = 10,
				/datum/reagent/consumable/ethanol/vodka = 5,
				/obj/item/grenade/smokebomb = 1)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER, TOOL_WRENCH)
	time = 100
	category = CAT_CHEMISTRY

/datum/crafting_recipe/cookbook/grenadeprimer
	name = "Капсюль для гранаты"
	result = /obj/item/assembly/primer
	reqs = list(/obj/item/assembly/igniter = 1,
				/obj/item/stock_parts/manipulator = 2,
				/obj/item/stack/cable_coil = 20)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	time = 100
	category = CAT_MISC

/datum/crafting_recipe/cookbook/poleaxe
	name = "Топор Ебанумба"
	result = /obj/item/paxe
	reqs = list(/obj/item/stack/sheet/plasteel = 1,
				/obj/item/stack/sheet/iron = 5,
				/obj/item/spear = 1,
				/obj/item/stack/cable_coil = 10)
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER, TOOL_WIRECUTTER, TOOL_WRENCH)
	time = 100
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/cookbook/plastid
	name = "Пластид из гексогена"
	result = /obj/item/grenade/c4
	reqs = list(/obj/item/grenade/chem_grenade = 1,
				/datum/reagent/rdx = 4,
				/obj/item/stack/cable_coil = 1)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	time = 40
	category = CAT_CHEMISTRY

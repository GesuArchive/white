/datum/crafting_recipe/boneshovel
	name = "Зазубренная костяная лопата"
	always_available = FALSE
	reqs = list(
		/obj/item/stack/sheet/bone = 4,
		/datum/reagent/fuel/oil = 5,
		/obj/item/shovel/spade = 1,
	)
	result = /obj/item/shovel/serrated
	category = CAT_TOOLS

/datum/crafting_recipe/lasso
	name = "Костяное лассо"
	reqs = list(
		/obj/item/stack/sheet/bone = 1,
		/obj/item/stack/sheet/sinew = 5,
	)
	result = /obj/item/key/lasso
	category = CAT_TOOLS

/datum/crafting_recipe/ore_sensor
	name = "Датчик Руды"
	time = 3 SECONDS
	reqs = list(
		/datum/reagent/brimdust = 15,
		/obj/item/stack/sheet/bone = 1,
		/obj/item/stack/sheet/sinew = 1,
	)
	result = /obj/item/ore_sensor
	category = CAT_TOOLS

/datum/crafting_recipe/rake //Category resorting incoming
	name = "Грабли"
	time = 30
	reqs = list(/obj/item/stack/sheet/mineral/wood = 5)
	result = /obj/item/cultivator/rake
	category = CAT_TOOLS

/datum/crafting_recipe/firebrand
	name = "Факел"
	result = /obj/item/match/firebrand
	time = 100 //Long construction time. Making fire is hard work.
	reqs = list(/obj/item/stack/sheet/mineral/wood = 2)
	category = CAT_TOOLS

/datum/crafting_recipe/ipickaxe
	name = "Самодельная кирка"
	reqs = list(
		/obj/item/crowbar = 1,
		/obj/item/kitchen/knife = 1,
		/obj/item/stack/sticky_tape = 1,
	)
	result = /obj/item/pickaxe/improvised
	category = CAT_TOOLS

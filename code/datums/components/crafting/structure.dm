/datum/crafting_recipe/bonfire
	name = "Костёр (древошляпник)"
	time = 60
	reqs = list(/obj/item/grown/log = 5)
	parts = list(/obj/item/grown/log = 5)
	blacklist = list(/obj/item/grown/log/steel)
	result = /obj/structure/bonfire
	category = CAT_STRUCTURE

/datum/crafting_recipe/bonfire_wood
	name = "Костёр (древесина)"
	time = 60
	reqs = list(/obj/item/stack/sheet/mineral/wood = 5)
	parts = list(/obj/item/stack/sheet/mineral/wood = 5)
	result = /obj/structure/bonfire
	category = CAT_STRUCTURE

/datum/crafting_recipe/headpike
	name = "Голова на копье (Стеклянное копье)"
	time = 65
	reqs = list(/obj/item/spear = 1,
				/obj/item/bodypart/head = 1)
	parts = list(/obj/item/bodypart/head = 1,
			/obj/item/spear = 1)
	blacklist = list(/obj/item/spear/explosive, /obj/item/spear/bonespear, /obj/item/spear/bamboospear)
	result = /obj/structure/headpike
	category = CAT_STRUCTURE

/datum/crafting_recipe/headpikebone
	name = "Голова на копье (Костяное копье)"
	time = 65
	reqs = list(/obj/item/spear/bonespear = 1,
				/obj/item/bodypart/head = 1)
	parts = list(/obj/item/bodypart/head = 1,
			/obj/item/spear/bonespear = 1)
	result = /obj/structure/headpike/bone
	category = CAT_STRUCTURE

/datum/crafting_recipe/headpikebamboo
	name = "Голова на копье (Бамбуковое копье)"
	time = 65
	reqs = list(/obj/item/spear/bamboospear = 1,
				/obj/item/bodypart/head = 1)
	parts = list(/obj/item/bodypart/head = 1,
			/obj/item/spear/bamboospear = 1)
	result = /obj/structure/headpike/bamboo
	category = CAT_STRUCTURE

/datum/crafting_recipe/pressureplate
	name = "Нажимная плита"
	result = /obj/item/pressure_plate
	time = 5
	reqs = list(/obj/item/stack/sheet/iron = 1,
				/obj/item/stack/tile/plasteel = 1,
				/obj/item/stack/cable_coil = 2,
				/obj/item/assembly/igniter = 1)
	category = CAT_STRUCTURE

/datum/crafting_recipe/guillotine
	name = "Гильотина"
	result = /obj/structure/guillotine
	time = 150 // Building a functioning guillotine takes time
	reqs = list(/obj/item/stack/sheet/plasteel = 3,
				/obj/item/stack/sheet/mineral/wood = 20,
				/obj/item/stack/cable_coil = 10)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WRENCH, TOOL_WELDER)
	category = CAT_STRUCTURE

/datum/crafting_recipe/rib
	name = "Ребро Колосса"
	always_available = FALSE
	reqs = list(
		/obj/item/stack/sheet/bone = 10,
		/datum/reagent/fuel/oil = 5,
	)
	result = /obj/structure/statue/bone/rib
	category = CAT_STRUCTURE

/datum/crafting_recipe/skull
	name = "Вырезать череп"
	always_available = FALSE
	reqs = list(
		/obj/item/stack/sheet/bone = 6,
		/datum/reagent/fuel/oil = 5,
	)
	result = /obj/structure/statue/bone/skull
	category = CAT_STRUCTURE

/datum/crafting_recipe/halfskull
	name = "Вырезать половину черепа"
	always_available = FALSE
	reqs = list(
		/obj/item/stack/sheet/bone = 3,
		/datum/reagent/fuel/oil = 5,
	)
	result = /obj/structure/statue/bone/skull/half
	category = CAT_STRUCTURE

/datum/crafting_recipe/toiletbong
	name = "Toiletbong"
	category = CAT_STRUCTURE
	tool_behaviors = list(TOOL_WRENCH)
	reqs = list(
		/obj/item/flamethrower = 1)
	result = /obj/structure/toiletbong
	time = 5 SECONDS
	additional_req_text = " plasma tank (on flamethrower), toilet"

/datum/crafting_recipe/toiletbong/check_requirements(mob/user, list/collected_requirements)
	if((locate(/obj/structure/toilet) in range(1, user.loc)) == null)
		return FALSE
	var/obj/item/flamethrower/flamethrower = collected_requirements[/obj/item/flamethrower][1]
	if(flamethrower.ptank == null)
		return FALSE
	return TRUE

/datum/crafting_recipe/toiletbong/on_craft_completion(mob/user, atom/result)
	var/obj/structure/toiletbong/toiletbong = result
	var/obj/structure/toilet/toilet = locate(/obj/structure/toilet) in range(1, user.loc)
	for (var/obj/item/cistern_item in toilet.contents)
		cistern_item.forceMove(user.loc)
		to_chat(user, span_warning("[cistern_item] falls out of the toilet!"))
	toiletbong.dir = toilet.dir
	toiletbong.loc = toilet.loc
	qdel(toilet)
	to_chat(user, span_notice("[user] attaches the flamethrower to the repurposed toilet."))

/datum/crafting_recipe/shutters
	name = "Бронежалюзи"
	reqs = list(/obj/item/stack/sheet/plasteel = 10,
				/obj/item/stack/cable_coil = 10,
				/obj/item/electronics/airlock = 1
				)
	result = /obj/machinery/door/poddoor/shutters/preopen
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_MULTITOOL, TOOL_WIRECUTTER, TOOL_WELDER)
	time = 15 SECONDS
	category = CAT_DOORS
	one_per_turf = TRUE

/datum/crafting_recipe/blast_doors
	name = "Бронеставни"
	reqs = list(/obj/item/stack/sheet/plasteel = 15,
				/obj/item/stack/cable_coil = 15,
				/obj/item/electronics/airlock = 1
				)
	result = /obj/machinery/door/poddoor/preopen
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_MULTITOOL, TOOL_WIRECUTTER, TOOL_WELDER)
	time = 30 SECONDS
	category = CAT_DOORS
	one_per_turf = TRUE

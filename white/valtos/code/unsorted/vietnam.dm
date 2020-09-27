/area/awaymission/vietnam
	name = "Дикие джунгли"
	icon_state = "unexplored"
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	ambientsounds = AWAY_MISSION
	enabled_area_tension = FALSE

/area/awaymission/vietnam/dark
	name = "Тёмное джунглевое место"
	icon_state = "unexplored"
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	ambientsounds = AWAY_MISSION
	requires_power = FALSE

/datum/outfit/vietcong
	name = "Вьетконговец"
	uniform = /obj/item/clothing/under/pants/khaki
	implants = list(/obj/item/implant/exile)

/obj/effect/mob_spawn/human/vietcong
	name = "шконка"
	desc = "Джонни... Тут кто-то затаился под шконкой..."
	icon = 'white/valtos/icons/prison/prison.dmi'
	icon_state = "spwn"
	roundstart = FALSE
	death = FALSE
	short_desc = "Я житель провинции Хаостан."
	flavour_text = "Проснуться, работать в рисовом поле, лечь спать, повторить."
	outfit = /datum/outfit/vietcong
	assignedrole = "Vietcong"

/obj/effect/mob_spawn/human/vietcong/special(mob/living/L)
	var/list/fn = list("Сунь", "Хунь", "Дунь", "Пунь", "Ляо", "Хуао", "Мао", "Жень", "Пам")
	var/list/ln = list("Хуй", "Дуй", "Дзинь", "Минь", "Кинь", "Пинь", "Вынь", "Синь", "Жунь", "Вунь")
	L.real_name = "[pick(fn)] [pick(ln)]"
	L.name = L.real_name
	ADD_TRAIT(L, TRAIT_ASIAT, type)

/mob/living/simple_animal/hostile/russian/bydlo
	name = "Гопник"
	desc = "Ку-ку, ёпта!"
	icon = 'white/valtos/icons/rospilovo/sh.dmi'
	icon_state = "gopnik"
	icon_living = "gopnik"
	icon_dead = "gopnik_dead"
	icon_gib = "gopnik_bottle_dead"
	attack_verb_continuous = "ебошит"
	attack_verb_simple = "прописывает двоечку"
	loot = list(/obj/item/clothing/under/switer/tracksuit)

/obj/structure/barricade/wooden/stockade
	name = "частокол"
	desc = "Дешево и сердито."
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "stockade"
	drop_amount = 1
	pixel_y = 16
	layer = ABOVE_MOB_LAYER

/turf/open/floor/grass/gensgrass/dirty/stone
	name = "каменный пол"
	icon = 'white/valtos/icons/gensokyo/turfs.dmi'
	icon_state = "stone_floor"
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	stoned = TRUE

/turf/open/floor/grass/gensgrass/dirty/stone/crowbar_act(mob/living/user, obj/item/I)
	return FALSE

/turf/open/floor/grass/gensgrass/dirty/stone/attackby(obj/item/I, mob/user, params)
	if((I.tool_behaviour == TOOL_SHOVEL) && params)
		user.visible_message("<span class='warning'>[user] грустно долбит лопатой по [src].</span>", "<span class='warning'>Как я блять лопатой буду копать [src]?!</span>")
		return FALSE
	if(..())
		return

/turf/open/floor/grass/gensgrass/dirty/stone/raw
	name = "уродливый камень"
	icon = 'white/valtos/icons/gensokyo/turfs.dmi'
	icon_state = "stone"
	stoned = FALSE
	var/digged_up = FALSE

/turf/closed/wall/stonewall
	name = "каменная стена"
	desc = "Не дай боженька увидеть такое на продвинутой исследовательской станции!"
	icon = 'white/valtos/icons/stonewall.dmi'
	icon_state = "wallthefuck"
	smoothing_flags = SMOOTH_CORNERS
	smoothing_groups = list(SMOOTH_GROUP_INDUSTRIAL_LIFT)
	canSmoothWith = list(SMOOTH_GROUP_INDUSTRIAL_LIFT)
	sheet_type = /obj/item/raw_stone/block
	baseturfs = /turf/open/floor/grass/gensgrass/dirty/stone
	sheet_amount = 4
	girder_type = null

/turf/open/floor/grass/gensgrass/dirty/stone/raw/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(istype(I, /obj/item/pickaxe))
		if(!digged_up)
			playsound(src, pick(I.usesound), 100, TRUE)
			if(do_after(user, 5 SECONDS, target = src))
				if(digged_up)
					return
				for(var/i in 1 to rand(3, 6))
					var/obj/item/S = new /obj/item/raw_stone(src)
					S.pixel_x = rand(-8, 8)
					S.pixel_y = rand(-8, 8)
				digged_up = TRUE
				user.visible_message("<span class='notice'><b>[user]</b> выкапывает немного камней.</span>", \
									"<span class='notice'>Выкапываю немного камней.</span>")
		else
			to_chat(user, "<span class='warning'>Здесь уже всё раскопано!</span>")

/turf/closed/mineral/random/vietnam
	icon = 'white/valtos/icons/rocks.dmi'
	icon_state = "rock"
	smooth_icon = 'white/valtos/icons/rocks_smooth.dmi'
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	environment_type = "stone_raw"
	turf_type = /turf/open/floor/grass/gensgrass/dirty/stone/raw
	baseturfs = /turf/open/floor/grass/gensgrass/dirty/stone/raw
	mineralSpawnChanceList = list(/obj/item/stack/ore/diamond = 1, /obj/item/stack/ore/gold = 3, /obj/item/stack/ore/iron = 40)

/turf/closed/mineral/random/vietnam/Initialize()
	. = ..()
	transform = null // backdoor

/datum/outfit/huev_latnik_one
	name = "Лёгкий лабеб"
	uniform = /obj/item/clothing/under/chainmail
	gloves = /obj/item/clothing/gloves/plate_gloves
	head = /obj/item/clothing/head/helmet/plate_helmet
	suit = /obj/item/clothing/suit/armor/light_plate
	shoes = /obj/item/clothing/shoes/jackboots/plate_boots
	back = /obj/item/blacksmith/katanus

/datum/outfit/huev_latnik_two
	name = "Тяжёлый лабеб"
	uniform = /obj/item/clothing/under/chainmail
	gloves = /obj/item/clothing/gloves/plate_gloves
	head = /obj/item/clothing/head/helmet/plate_helmet
	suit = /obj/item/clothing/suit/armor/heavy_plate
	shoes = /obj/item/clothing/shoes/jackboots/plate_boots
	r_hand = /obj/item/blacksmith/zwei

/datum/crafting_recipe/smithman/anvil
	name = "Наковальня"
	result = /obj/item/blacksmith/anvil_free
	tools = list(/obj/item/blacksmith/smithing_hammer)
	reqs = list(/obj/item/blacksmith/ingot = 3,
				/obj/item/raw_stone/block = 5)
	time = 350
	category = CAT_STRUCTURE
	always_available = TRUE

/datum/crafting_recipe/smithman/workplace
	name = "Наковальня на полене"
	result = /obj/anvil
	tools = list(/obj/item/blacksmith/smithing_hammer)
	reqs = list(/obj/item/blacksmith/srub = 1,
				/obj/item/blacksmith/anvil_free = 1)
	time = 350
	category = CAT_STRUCTURE
	always_available = TRUE

/datum/crafting_recipe/smithman/srub
	name = "Полено"
	result = /obj/item/blacksmith/srub
	reqs = list(/obj/item/stack/sheet/mineral/wood = 10)
	time = 100
	category = CAT_STRUCTURE
	always_available = TRUE

/datum/crafting_recipe/smithman/furnace
	name = "Плавильня"
	result = /obj/furnace
	reqs = list(/obj/item/raw_stone/block = 10, /obj/item/stack/sheet/mineral/wood = 10)
	time = 300
	category = CAT_STRUCTURE
	always_available = TRUE

/datum/crafting_recipe/smithman/furnace_cook
	name = "Печь для готовки"
	result = /obj/machinery/microwave/furnace
	reqs = list(/obj/item/raw_stone/block = 8, /obj/item/stack/sheet/mineral/wood = 6)
	time = 200
	category = CAT_STRUCTURE
	always_available = TRUE

/datum/crafting_recipe/smithman/forge
	name = "Кузница"
	result = /obj/forge
	reqs = list(/obj/item/raw_stone/block = 20, /obj/item/stack/sheet/mineral/wood = 20)
	time = 300
	category = CAT_STRUCTURE
	always_available = TRUE

/datum/crafting_recipe/smithman/stonedoor
	name = "Каменная дверь"
	result = /obj/structure/mineral_door/heavystone
	reqs = list(/obj/item/raw_stone/block = 5, /obj/item/stack/sheet/mineral/wood = 1, /obj/item/blacksmith/ingot = 1)
	time = 300
	category = CAT_STRUCTURE
	always_available = TRUE

/datum/crafting_recipe/smithman/stonechair
	name = "Каменный стул"
	result = /obj/structure/chair/comfy/stone
	reqs = list(/obj/item/raw_stone/block = 1)
	time = 100
	category = CAT_STRUCTURE
	always_available = TRUE

/datum/crafting_recipe/smithman/stonetable
	name = "Каменный стол"
	result = /obj/structure/table/stone
	reqs = list(/obj/item/raw_stone/block = 2)
	time = 100
	category = CAT_STRUCTURE
	always_available = TRUE

/datum/crafting_recipe/smithman/sarcophage
	name = "Саркофаг"
	result = /obj/structure/closet/crate/sarcophage
	reqs = list(/obj/item/raw_stone/block = 10)
	time = 250
	category = CAT_STRUCTURE
	always_available = TRUE

/obj/effect/baseturf_helper/beach/raw_stone
	name = "raw stone baseturf editor"
	baseturf = /turf/open/floor/grass/gensgrass/dirty/stone/raw

/obj/effect/mob_spawn/human/dwarf
	name = "шконка"
	desc = "Тут кто-то под шконкой, кирку мне в зад..."
	icon = 'white/valtos/icons/prison/prison.dmi'
	icon_state = "spwn"
	roundstart = FALSE
	death = FALSE
	short_desc = "Я ебучий карлик в невероятно диких условиях."
	flavour_text = "Выжить."
	mob_species = /datum/species/dwarf
	outfit = /datum/outfit/dwarf
	assignedrole = "Dwarf"

/turf/closed/mineral/random/dwarf_lustress
	icon = 'white/valtos/icons/rockwall.dmi'
	smooth_icon = 'white/valtos/icons/rockwall.dmi'
	icon_state = "rockthefuck"
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	environment_type = "stone_raw"
	smoothing_flags = SMOOTH_CORNERS
	smoothing_groups = list(SMOOTH_GROUP_INDUSTRIAL_LIFT)
	canSmoothWith = list(SMOOTH_GROUP_INDUSTRIAL_LIFT)
	turf_type = /turf/open/floor/grass/gensgrass/dirty/stone/raw
	baseturfs = /turf/open/floor/grass/gensgrass/dirty/stone/raw
	mineralSpawnChanceList = list(/obj/item/stack/ore/diamond = 1, /obj/item/stack/ore/gold = 3, /obj/item/stack/ore/iron = 40)

/turf/closed/mineral/random/dwarf_lustress/Initialize()
	. = ..()
	transform = null // backdoor

/area/awaymission/vietnam/dwarf
	name = "Тёмное подземелье"
	icon_state = "unexplored"
	outdoors = TRUE
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	ambientsounds = AWAY_MISSION
	requires_power = FALSE
	ambientsounds = list('white/valtos/sounds/lifeweb/caves8.ogg', 'white/valtos/sounds/lifeweb/caves_old.ogg')

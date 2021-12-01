/area/awaymission/vietnam
	name = "Дикие джунгли"
	icon_state = "unexplored"
	static_lighting = FALSE
	base_lighting_alpha = 255
	base_lighting_color = COLOR_WHITE
	map_generator = /datum/map_generator/jungle_generator
	ambientsounds = AWAY_MISSION
	enabled_area_tension = FALSE

/area/awaymission/vietnam/Initialize(mapload)
	. = ..()
	RunGeneration()

/area/awaymission/vietnam/dark
	name = "Тёмное джунглевое место"
	icon_state = "unexplored"
	static_lighting = TRUE
	base_lighting_alpha = 1
	base_lighting_color = COLOR_WHITE
	ambientsounds = AWAY_MISSION
	requires_power = FALSE

/datum/outfit/vietcong
	name = "Вьетконговец"
	uniform = /obj/item/clothing/under/pants/khaki
	implants = list(/obj/item/implant/exile)

/obj/effect/mob_spawn/human/vietcong
	name = "пещера гуков"
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

/obj/effect/mob_spawn/human/milikanes
	name = "шконка миликанса"
	desc = "Джонни... Тут кто-то затаился под шконкой?"
	icon = 'white/valtos/icons/prison/prison.dmi'
	icon_state = "spwn"
	roundstart = FALSE
	death = FALSE
	short_desc = "ПОРА ПРЕПОДАТЬ УРОК ПИЗДОГЛАЗЫМ!"
	flavour_text = "Вырезать всех гуков к хуям во славу демократии!"
	outfit = /datum/outfit/milikanes
	assignedrole = "Milikanes"

/obj/effect/mob_spawn/human/milikanes/special(mob/living/L)
	var/list/fn = list("PVT", "PFC", "CPL", "SGT", "SFC", "MSG", "1SG", "SGM", "CSM")
	var/list/ln = list("Логан", "Лиам", "Мэйсон", "Джейкоб", "Этан", "Митчел", "Джейден", "Дэниэль", "Айден", "Мэттью", "Джеймс", "Энтони", "Бенджамин", "Эндрю", "Джозеф", "Дэвид", "Сэм")
	L.real_name = "[pick(fn)] [pick(ln)]"
	L.name = L.real_name

/datum/outfit/milikanes
	name = "Миликанес"

	mask = /obj/item/clothing/mask/bandana/green
	glasses = /obj/item/clothing/glasses/sunglasses
	suit = /obj/item/clothing/suit/toggle/hawaii
	uniform = /obj/item/clothing/under/syndicate/camo
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/satchel/leather/withwallet

	l_pocket = /obj/item/flashlight/seclite
	r_pocket = /obj/item/radio

	implants = list(/obj/item/implant/exile)

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

/turf/open/floor/grass/gensgrass/dirty/stone
	name = "каменный пол"
	desc = "Классика."
	icon = 'white/valtos/icons/gensokyo/turfs.dmi'
	icon_state = "stone_floor"
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	stoned = TRUE
	floor_tile = /turf/open/floor/grass/gensgrass/dirty/stone/raw
	slowdown = 0
	var/busy = FALSE

/turf/open/floor/grass/gensgrass/dirty/stone/crowbar_act(mob/living/user, obj/item/I)
	if(pry_tile(I, user))
		new /obj/item/stack/sheet/stone(get_turf(src))
		return TRUE

/turf/open/floor/grass/gensgrass/dirty/stone/attackby(obj/item/I, mob/user, params)
	if((I.tool_behaviour == TOOL_SHOVEL) && params)
		user.visible_message(span_warning("[user] грустно долбит лопатой по [src].") , span_warning("Как я лопатой буду копать [src]?!"))
		return FALSE
	if(..())
		return

/turf/open/floor/grass/gensgrass/dirty/stone/raw
	name = "уродливый камень"
	desc = "Ужас."
	icon = 'white/valtos/icons/gensokyo/turfs.dmi'
	icon_state = "stone"
	stoned = FALSE
	slowdown = 1
	baseturfs = /turf/open/floor/grass/gensgrass/dirty/stone/raw
	var/digged_up = FALSE

/turf/open/floor/grass/gensgrass/dirty/stone/raw/crowbar_act(mob/living/user, obj/item/I)
	return FALSE

/turf/closed/wall/stonewall
	name = "каменная стена"
	desc = "Не дай боженька увидеть такое на продвинутой исследовательской станции!"
	icon = 'white/valtos/icons/stonewall.dmi'
	icon_state = "stonewall-0"
	base_icon_state = "stonewall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_INDUSTRIAL_LIFT)
	canSmoothWith = list(SMOOTH_GROUP_INDUSTRIAL_LIFT)
	sheet_type = /obj/item/stack/sheet/stone
	baseturfs = /turf/open/floor/grass/gensgrass/dirty/stone
	sheet_amount = 4
	girder_type = null
	var/busy = FALSE

/turf/closed/wall/stonewall/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(istype(W, /obj/item/blacksmith/chisel))
		if(busy)
			to_chat(user, span_warning("Сейчас занято."))
			return
		busy = TRUE
		if(!do_after(user, 10 SECONDS, target = src))
			busy = FALSE
			return
		busy = FALSE
		to_chat(user, span_warning("Обрабатываю [src]."))
		ChangeTurf(/turf/closed/wall/stonewall_fancy)

/turf/closed/wall/stonewall_fancy
	name = "красивая каменная стена"
	desc = "KrasIVo!"
	icon = 'white/valtos/icons/dwarfs/rich_wall.dmi'
	icon_state = "rich_wall-0"
	base_icon_state = "rich_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_INDUSTRIAL_LIFT)
	canSmoothWith = list(SMOOTH_GROUP_INDUSTRIAL_LIFT)
	sheet_type = /obj/item/stack/sheet/stone
	baseturfs = /turf/open/floor/grass/gensgrass/dirty/stone
	sheet_amount = 4
	girder_type = null

/turf/open/floor/grass/gensgrass/dirty/stone/fancy
	name = "красивый каменный пол"
	desc = "Красивая классика."
	icon = 'white/valtos/icons/gensokyo/turfs.dmi'
	icon_state = "stone_floor_fancy"
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	stoned = TRUE
	floor_tile = /turf/open/floor/grass/gensgrass/dirty/stone/raw
	slowdown = 0

/turf/open/floor/grass/gensgrass/dirty/stone/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(istype(W, /obj/item/blacksmith/chisel)&&isstrictlytype(src, /turf/open/floor/grass/gensgrass/dirty/stone))
		if(busy)
			to_chat(user, span_warning("Сейчас занято."))
			return
		busy = TRUE
		if(!do_after(user, 10 SECONDS, target = src))
			busy = FALSE
			return
		busy = FALSE
		to_chat(user, span_warning("Обрабатываю [src]."))
		ChangeTurf(/turf/open/floor/grass/gensgrass/dirty/stone/fancy, flags=CHANGETURF_INHERIT_AIR)

/turf/open/floor/grass/gensgrass/dirty/stone/raw/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(istype(I, /obj/item/pickaxe))
		if(!digged_up)
			playsound(src, pick(I.usesound), 100, TRUE)
			if(do_after(user, 5 SECONDS, target = src))
				if(digged_up)
					return
				for(var/i in 1 to rand(3, 6))
					var/obj/item/S = new /obj/item/stack/ore/stone(src)
					S.pixel_x = rand(-8, 8)
					S.pixel_y = rand(-8, 8)
				digged_up = TRUE
				user.visible_message(span_notice("<b>[user]</b> выкапывает немного камней.") , \
									span_notice("Выкапываю немного камней."))
		else
			to_chat(user, span_warning("Здесь уже всё раскопано!"))

/turf/closed/mineral/random/vietnam
	icon = 'white/valtos/icons/rocks.dmi'
	icon_state = "rock"
	smooth_icon = 'white/valtos/icons/rocks_smooth.dmi'
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	smoothing_flags = SMOOTH_CORNERS
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
	tool_paths = list(/obj/item/blacksmith/smithing_hammer)
	reqs = list(/obj/item/blacksmith/ingot = 3,
				/obj/item/stack/sheet/stone = 5)
	time = 350
	category = CAT_STRUCTURE
	always_available = TRUE

/datum/crafting_recipe/smithman/workplace
	name = "Наковальня на полене"
	result = /obj/anvil
	tool_paths = list(/obj/item/blacksmith/smithing_hammer)
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
	reqs = list(/obj/item/stack/sheet/stone = 10, /obj/item/stack/sheet/mineral/wood = 10)
	time = 300
	category = CAT_STRUCTURE
	always_available = TRUE

/datum/crafting_recipe/smithman/furnace_cook
	name = "Печь для готовки"
	result = /obj/machinery/microwave/furnace
	reqs = list(/obj/item/stack/sheet/stone = 8, /obj/item/stack/sheet/mineral/wood = 6)
	time = 200
	category = CAT_STRUCTURE
	always_available = TRUE

/datum/crafting_recipe/smithman/forge
	name = "Кузница"
	result = /obj/forge
	reqs = list(/obj/item/stack/sheet/stone = 20, /obj/item/stack/sheet/mineral/wood = 20)
	time = 300
	category = CAT_STRUCTURE
	always_available = TRUE

/datum/crafting_recipe/smithman/stonedoor
	name = "Каменная дверь"
	result = /obj/structure/mineral_door/heavystone
	reqs = list(/obj/item/stack/sheet/stone = 5, /obj/item/stack/sheet/mineral/wood = 1, /obj/item/blacksmith/ingot = 1)
	time = 300
	category = CAT_STRUCTURE
	always_available = TRUE

/datum/crafting_recipe/smithman/stonechair
	name = "Каменный стул"
	result = /obj/structure/chair/comfy/stone
	reqs = list(/obj/item/stack/sheet/stone = 1)
	time = 100
	category = CAT_STRUCTURE
	always_available = TRUE

/datum/crafting_recipe/smithman/stonetable
	name = "Каменный стол"
	result = /obj/structure/table/stone
	reqs = list(/obj/item/stack/sheet/stone = 2)
	time = 100
	category = CAT_STRUCTURE
	always_available = TRUE

/datum/crafting_recipe/smithman/sarcophage
	name = "Саркофаг"
	result = /obj/structure/closet/crate/sarcophage
	reqs = list(/obj/item/stack/sheet/stone = 10)
	time = 250
	category = CAT_STRUCTURE
	always_available = TRUE

/obj/effect/baseturf_helper/beach/raw_stone
	name = "raw stone baseturf editor"
	baseturf = /turf/open/floor/grass/gensgrass/dirty/stone/raw

/obj/effect/mob_spawn/human/dwarf
	name = "мягкая шконка"
	desc = "Тут кто-то под шконкой, кирку мне в зад..."
	icon = 'white/valtos/icons/prison/prison.dmi'
	icon_state = "spwn"
	roundstart = FALSE
	death = FALSE
	short_desc = "Я Дварф в невероятно диких условиях."
	flavour_text = "Выжить."
	mob_species = /datum/species/dwarf
	outfit = /datum/outfit/dwarf
	assignedrole = "Dwarf"

/turf/closed/mineral/random/dwarf_lustress
	icon = 'white/valtos/icons/rockwall.dmi'
	smooth_icon = 'white/valtos/icons/rockwall.dmi'
	icon_state = "rockwall-0"
	base_icon_state = "rockwall"
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	environment_type = "stone_raw"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_INDUSTRIAL_LIFT)
	canSmoothWith = list(SMOOTH_GROUP_INDUSTRIAL_LIFT)
	turf_type = /turf/open/floor/grass/gensgrass/dirty/stone/raw
	baseturfs = /turf/open/floor/grass/gensgrass/dirty/stone/raw
	mineralSpawnChanceList = list(/obj/item/stack/ore/gold = 5, /obj/item/stack/ore/iron = 40, /obj/item/gem/diamond=1,/obj/item/gem/ruby=1,/obj/item/gem/saphire=1)

/turf/closed/mineral/random/dwarf_lustress/Initialize()
	. = ..()
	transform = null

/turf/closed/mineral/random/dwarf_lustress/gets_drilled(user, give_exp = FALSE)
	. = ..()

	if(prob(0.8))
		to_chat(user, span_userdanger("КАМЕНЬ ОКАЗАЛСЯ УДИВИТЕЛЬНО МЯГКИМ!"))
		new /mob/living/simple_animal/hostile/troll(src)

/area/awaymission/vietnam/dwarf
	name = "Тёмное подземелье"
	icon_state = "unexplored"
	outdoors = TRUE
	static_lighting = FALSE
	ambientsounds = AWAY_MISSION
	requires_power = FALSE
	sound_environment = SOUND_ENVIRONMENT_CAVE
	ambientsounds = list('white/valtos/sounds/lifeweb/caves8.ogg', 'white/valtos/sounds/lifeweb/caves_old.ogg')

/area/awaymission/vietnam
	name = "Дикие джунгли"
	icon_state = "unexplored"
	static_lighting = FALSE
	base_lighting_alpha = 255
	base_lighting_color = COLOR_WHITE
	map_generator = /datum/map_generator/jungle_generator
	ambientsounds = AWAY_MISSION
	enabled_area_tension = FALSE

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
	icon = 'white/kacherkin/icons/dwarfs/obj/turfs1.dmi'
	icon_state = "stone_floor"
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	stoned = TRUE
	floor_tile = /turf/open/floor/grass/gensgrass/dirty/stone/raw
	slowdown = 0
	var/busy = FALSE

/turf/open/floor/grass/gensgrass/dirty/stone/raw
	name = "уродливый камень"
	desc = "Ужас."
	icon = 'white/kacherkin/icons/dwarfs/obj/turfs1.dmi'
	icon_state = "stone"
	stoned = FALSE
	slowdown = 1
	baseturfs = /turf/open/floor/plating/grass
	var/digged_up = FALSE
/*
/turf/open/floor/grass/gensgrass/dirty/stone/raw/crowbar_act(mob/living/user, obj/item/I)
	return FALSE
*/
/turf/closed/wall/stonewall
	name = "каменная стена"
	desc = "Не дай боженька увидеть такое на продвинутой исследовательской станции!"
	icon = 'white/valtos/icons/stonewall.dmi'
	icon_state = "stonewall-0"
	base_icon_state = "stonewall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_INDUSTRIAL_LIFT)
	canSmoothWith = list(SMOOTH_GROUP_INDUSTRIAL_LIFT)
	sheet_type = /obj/item/stack/sheet/iron
	baseturfs = /turf/open/floor/grass/gensgrass/dirty/stone
	sheet_amount = 4
	girder_type = null
	var/busy = FALSE

/turf/closed/wall/stonewall_fancy
	name = "красивая каменная стена"
	desc = "KrasIVo!"
	icon = 'white/valtos/icons/dwarfs/rich_wall.dmi'
	icon_state = "rich_wall-0"
	base_icon_state = "rich_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_INDUSTRIAL_LIFT)
	canSmoothWith = list(SMOOTH_GROUP_INDUSTRIAL_LIFT)
	sheet_type = /obj/item/stack/sheet/iron
	baseturfs = /turf/open/floor/grass/gensgrass/dirty/stone
	sheet_amount = 4
	girder_type = null

/turf/open/floor/grass/gensgrass/dirty/stone/fancy
	name = "красивый каменный пол"
	desc = "Красивая классика."
	icon = 'white/kacherkin/icons/dwarfs/obj/turfs1.dmi'
	icon_state = "stone_floor_fancy"
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	stoned = TRUE
	slowdown = 0

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

/turf/closed/mineral/random/vietnam/Initialize(mapload)
	. = ..()
	transform = null // backdoor

/obj/effect/baseturf_helper/beach/raw_stone
	name = "raw stone baseturf editor"
	baseturf = /turf/open/floor/grass/gensgrass/dirty/stone/raw

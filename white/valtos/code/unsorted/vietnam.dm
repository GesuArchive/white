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
	icon_state = "stone"
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/grass/gensgrass/dirty/stone/raw
	name = "уродливый камень"
	icon = 'white/valtos/icons/gensokyo/turfs.dmi'
	icon_state = "stone_raw"

/obj/item/smithing_hammer
	name = "молот"
	desc = "Используется для ковки. По идее."
	icon = 'white/valtos/icons/objects.dmi'
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	icon_state = "molotochek"
	w_class = WEIGHT_CLASS_HUGE
	force = 20
	throwforce = 25
	throw_range = 4

/obj/item/smithing_hammer/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, require_twohands=TRUE, force_unwielded=20, force_wielded=20)

/obj/item/anvil_free
	name = "наковальня"
	desc = "На ней неудобно ковать. Стоит поставить её на что-то крепкое."
	icon = 'white/valtos/icons/objects.dmi'
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	icon_state = "anvil_free"
	w_class = WEIGHT_CLASS_HUGE
	force = 10
	throwforce = 20
	throw_range = 2

/obj/item/anvil_free/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, require_twohands=TRUE, force_unwielded=10, force_wielded=10)

/obj/item/srub
	name = "полено"
	desc = "Достаточно крепкое, чтобы удерживать на себе наковальню."
	icon = 'white/valtos/icons/objects.dmi'
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	icon_state = "srub"
	w_class = WEIGHT_CLASS_HUGE
	force = 7
	throwforce = 10
	throw_range = 3

/obj/item/srub/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, require_twohands=TRUE, force_unwielded=7, force_wielded=7)

/obj/item/tongs
	name = "клещи"
	desc = "Для ковки. Не для анальных утех."
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "tongs"
	w_class = WEIGHT_CLASS_SMALL
	force = 4
	throwforce = 6
	throw_range = 7

/obj/item/ingot
	name = "слиток"
	desc = "Из него можно сделать что-то."
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "iron_ingot"
	w_class = WEIGHT_CLASS_NORMAL
	force = 2
	throwforce = 5
	throw_range = 7

/obj/item/raw_stone
	name = "камень"
	desc = "Олдфаг."
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "stone"
	w_class = WEIGHT_CLASS_TINY
	force = 3
	throwforce = 7
	throw_range = 14

/obj/item/katanus
	name = "катанус"
	desc = "Не путать с катаной."
	icon_state = "katanus"
	inhand_icon_state = "katanus"
	worn_icon_state = "katanus"
	icon = 'white/valtos/icons/objects.dmi'
	worn_icon = 'white/valtos/icons/back.dmi'
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BACK
	force = 20
	throwforce = 10
	w_class = WEIGHT_CLASS_HUGE
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("атакует", "рубит", "втыкает", "разрубает", "кромсает", "разрывает", "нарезает", "режет")
	block_chance = 25
	sharpness = IS_SHARP
	max_integrity = 50
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 50)
	resistance_flags = FIRE_PROOF

/obj/item/clothing/suit/armor/light_plate
	name = "нагрудная пластина"
	desc = "Защищает только грудь, плохо останавливает пули."
	body_parts_covered = CHEST
	icon_state = "light_plate"
	inhand_icon_state = "light_plate"
	worn_icon = 'white/valtos/icons/clothing/mob/suit.dmi'
	icon = 'white/valtos/icons/clothing/suits.dmi'
	armor = list("melee" = 55, "bullet" = 10, "laser" = 20, "energy" = 0, "bomb" = 30, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10, "wound" = 35)

/obj/item/clothing/under/chainmail
	name = "кольчуга"
	desc = "Неплохо защищает от всех видов колющего и режущего оружия. Немного стесняет движения."
	worn_icon = 'white/valtos/icons/clothing/mob/uniform.dmi'
	icon = 'white/valtos/icons/clothing/uniforms.dmi'
	icon_state = "chainmail"
	inhand_icon_state = "chainmail"
	armor = list("melee" = 35, "bullet" = 5, "laser" = 0, "energy" = 0, "bomb" = 40, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0, "wound" = 55)

/obj/item/clothing/head/helmet/plate_helmet
	name = "железный шлем"
	desc = "Спасёт голову от внезапного удара по ней."
	worn_icon = 'white/valtos/icons/clothing/mob/hat.dmi'
	icon = 'white/valtos/icons/clothing/hats.dmi'
	icon_state = "plate_helmet"
	flags_inv = HIDEHAIR
	armor = list("melee" = 75, "bullet" = 15, "laser" = 10,"energy" = 0, "bomb" = 20, "bio" = 0, "rad" = 0, "fire" = 5, "acid" = 5, "wound" = 55)

/obj/item/clothing/gloves/plate_gloves
	name = "железные перчатки"
	desc = "Уберегут ваши руки от внезапных потерь."
	worn_icon = 'white/valtos/icons/clothing/mob/glove.dmi'
	icon = 'white/valtos/icons/clothing/gloves.dmi'
	icon_state = "plate_gloves"
	armor = list("melee" = 65, "bullet" = 10, "laser" = 5,"energy" = 0, "bomb" = 20, "bio" = 0, "rad" = 0, "fire" = 25, "acid" = 25, "wound" = 55)

/obj/item/clothing/shoes/jackboots/plate_boots
	name = "железные сапоги"
	desc = "Спасут ваши ноги от внезапных переломов и других страшных штук."
	worn_icon = 'white/valtos/icons/clothing/mob/shoe.dmi'
	icon = 'white/valtos/icons/clothing/shoes.dmi'
	icon_state = "plate_boots"
	armor = list("melee" = 75, "bullet" = 15, "laser" = 10,"energy" = 0, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 15, "acid" = 15, "wound" = 55)

/datum/outfit/huev_latnik
	name = "СУКА ЛАБЕБ"
	uniform = /obj/item/clothing/under/chainmail
	gloves = /obj/item/clothing/gloves/plate_gloves
	head = /obj/item/clothing/head/helmet/plate_helmet
	suit = /obj/item/clothing/suit/armor/light_plate
	shoes = /obj/item/clothing/shoes/jackboots/plate_boots
	back = /obj/item/katanus

/obj/anvil
	name = "наковальня"
	desc = "Вот на этом удобно ковать, да?"
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "anvil"

/datum/smithing_recipe
	var/name = ""
	var/req_ingots = 1
	var/result
	var/enabled = FALSE

/datum/smithing_recipe/katanus
	name = "Катанус"
	req_ingots = 1
	result = /obj/item/katanus

/datum/smithing_recipe/light_plate
	name = "Нагрудник"
	req_ingots = 2
	result = /obj/item/clothing/suit/armor/light_plate

/datum/smithing_recipe/chainmail
	name = "Кольчуга"
	req_ingots = 2
	result = /obj/item/clothing/under/chainmail

/datum/smithing_recipe/plate_helmet
	name = "Шлем"
	req_ingots = 1
	result = /obj/item/clothing/head/helmet/plate_helmet

/datum/smithing_recipe/plate_gloves
	name = "Перчатки"
	req_ingots = 1
	result = /obj/item/clothing/gloves/plate_gloves

/datum/smithing_recipe/plate_boots
	name = "Ботинки"
	req_ingots = 1
	result = /obj/item/clothing/shoes/jackboots/plate_boots

/obj/furnace
	name = "плавильня"
	desc = "Плавит."
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "furnace"

/obj/forge
	name = "кузница"
	desc = "Нагревает различные штуки, но реже всего слитки."
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "forge"

/datum/crafting_recipe/smithman/anvil
	name = "Наковальня"
	result = /obj/item/anvil_free
	tools = list(/obj/item/smithing_hammer)
	reqs = list(/obj/item/ingot = 3,
				/obj/item/raw_stone = 5)
	time = 350
	category = CAT_STRUCTURE
	always_availible = TRUE

/datum/crafting_recipe/smithman/srub
	name = "Полено"
	result = /obj/item/srub
	reqs = list(/obj/item/stack/sheet/mineral/wood = 10)
	time = 100
	category = CAT_STRUCTURE
	always_availible = TRUE

/datum/crafting_recipe/smithman/furnace
	name = "Плавильня"
	result = /obj/furnace
	reqs = list(/obj/item/raw_stone = 10, /obj/item/stack/sheet/mineral/wood = 10)
	time = 300
	category = CAT_STRUCTURE
	always_availible = TRUE

/datum/crafting_recipe/smithman/forge
	name = "Кузница"
	result = /obj/forge
	reqs = list(/obj/item/raw_stone = 20, /obj/item/stack/sheet/mineral/wood = 20)
	time = 300
	category = CAT_STRUCTURE
	always_availible = TRUE

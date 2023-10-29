/**********************Areas******************************/

/area/prisonv2
	name = "Тюрьма СССР"
	icon_state = "brig"
	static_lighting = TRUE
	requires_power = TRUE
	has_gravity = TRUE
	area_flags = NOTELEPORT
	flags_1 = NONE
	ambientsounds = SOVIET_AMB

/area/prisonv2out
	name = "Пещеры СССР"
	icon_state = "yellow"
	requires_power = TRUE
	has_gravity = TRUE
	area_flags = NOTELEPORT
	flags_1 = NONE
	ambientsounds = SOVIET_AMB_CAVES

/**********************Turf Walls**************************/

/turf/closed/wall/brick
	name = "кирпичная стена"
	desc = "Изначально эти стены были белого цвета, но со временем люди стали их красить. Собой."
	icon = 'white/valtos/icons/prison/brick_wall.dmi'
	icon_state = "brick_wall-0"
	base_icon_state = "brick_wall"
	hardness = 4500
	explosion_block = 5
	slicing_duration = 20000

/**********************Turf Minerals************************/

/turf/closed/mineral/bscrystal/dirty
	turf_type = /turf/open/floor/plating/asteroid/dirty
	baseturfs = /turf/open/floor/plating/asteroid/dirty
	initial_gas_mix = "o2=22;n2=82;TEMP=293.15"
	defer_change = 1

/turf/closed/mineral/uranium/dirty
	turf_type = /turf/open/floor/plating/asteroid/dirty
	baseturfs = /turf/open/floor/plating/asteroid/dirty
	initial_gas_mix = "o2=22;n2=82;TEMP=293.15"
	defer_change = 1

/turf/closed/mineral/plasma/dirty
	turf_type = /turf/open/floor/plating/asteroid/dirty
	baseturfs = /turf/open/floor/plating/asteroid/dirty
	initial_gas_mix = "o2=22;n2=82;TEMP=293.15"
	defer_change = 1

/turf/closed/mineral/titanium/dirty
	turf_type = /turf/open/floor/plating/asteroid/dirty
	baseturfs = /turf/open/floor/plating/asteroid/dirty
	initial_gas_mix = "o2=22;n2=82;TEMP=293.15"
	defer_change = 1

/turf/closed/mineral/silver/dirty
	turf_type = /turf/open/floor/plating/asteroid/dirty
	baseturfs = /turf/open/floor/plating/asteroid/dirty
	initial_gas_mix = "o2=22;n2=82;TEMP=293.15"
	defer_change = 1

/turf/closed/mineral/gold/dirty
	turf_type = /turf/open/floor/plating/asteroid/dirty
	baseturfs = /turf/open/floor/plating/asteroid/dirty
	initial_gas_mix = "o2=22;n2=82;TEMP=293.15"
	defer_change = 1

/turf/closed/mineral/diamond/dirty
	turf_type = /turf/open/floor/plating/asteroid/dirty
	baseturfs = /turf/open/floor/plating/asteroid/dirty
	initial_gas_mix = "o2=22;n2=82;TEMP=293.15"
	defer_change = 1

/turf/closed/mineral/coal
	mineralType = /obj/item/stack/sheet/mineral/coal
	turf_type = /turf/open/floor/plating/asteroid/dirty
	baseturfs = /turf/open/floor/plating/asteroid/dirty
	scan_state = "rock_Iron"

/turf/closed/mineral/random/prison
	turf_type = /turf/open/floor/plating/asteroid/dirty
	baseturfs = /turf/open/floor/plating/asteroid/dirty
	initial_gas_mix = "o2=22;n2=82;TEMP=293.15"
	defer_change = 1
	mineralChance = 10
	mineralSpawnChanceList = list(
	/turf/closed/mineral/uranium/dirty = 3, /turf/closed/mineral/diamond/dirty = 3, /turf/closed/mineral/gold/dirty = 3, /turf/closed/mineral/titanium/dirty = 3,
	/turf/closed/mineral/silver/dirty = 3, /turf/closed/mineral/plasma/dirty = 3, /turf/closed/mineral/bscrystal/dirty = 3, /turf/closed/mineral/coal = 25)

/**********************Turf Floors**************************/

/turf/open/floor/plating/asteroid/dirty
	name = "земля"
	desc = "Мягенькая."
	icon = 'white/valtos/icons/prison/prison.dmi'
	postdig_icon_change = TRUE
	icon_state = "dirt"
	base_icon_state = "dirt"
	turf_type = /turf/open/floor/plating/asteroid/dirty
	floor_variance = 0
	initial_gas_mix = "o2=22;n2=82;TEMP=225.15"
	slowdown = 1

/turf/open/floor/plating/asteroid/dirty/fake_lava_v1
	name = "искусственная лава"
	desc = "Пол это лава!"
	icon = 'icons/turf/floors/lava.dmi'
	icon_state = "lava-255"
	base_icon_state = "lava"
	postdig_icon_change = FALSE
	turf_type = /turf/open/floor/plating/asteroid/dirty
	floor_variance = 0
	initial_gas_mix = "o2=22;n2=82;TEMP=225.15"
	slowdown = 3

/turf/open/floor/plating/asteroid/dirty/fake_lava_v2
	name = "искусственная лава"
	desc = "Пол это лава!"
	icon = 'icons/turf/floors.dmi'
	icon_state = "lava"
	base_icon_state = "lava"
	postdig_icon_change = FALSE
	turf_type = /turf/open/floor/plating/asteroid/dirty
	floor_variance = 0
	initial_gas_mix = "o2=22;n2=82;TEMP=225.15"
	slowdown = 3

/turf/open/floor/trot
	name = "тротуар"
	desc = "В самый раз для пробежек."
	icon_state = "trot"
	initial_gas_mix = "o2=22;n2=82;TEMP=293.15"
	icon = 'white/valtos/icons/prison/beton.dmi'
	floor_tile = /obj/item/stack/tile/trot
	slowdown = -0.1
	baseturfs = /turf/open/floor/plating/beach/sand

/turf/open/floor/trot/setup_broken_states()
	return list("damaged")

/turf/open/floor/trot/setup_burnt_states()
	return list("damaged")

/turf/open/floor/beton
	name = "бетон"
	desc = "Падать на него не самый лучший вариант."
	icon_state = "beton-0"
	base_icon_state = "beton"
	initial_gas_mix = "o2=22;n2=82;TEMP=293.15"
	icon = 'white/valtos/icons/prison/beton.dmi'
	floor_tile = /obj/item/stack/tile/beton
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_CARPET_DONK)
	canSmoothWith = list(SMOOTH_GROUP_CARPET_DONK)
	flags_1 = NONE
	baseturfs = /turf/open/floor/plating/beach/sand

/turf/open/floor/beton/setup_broken_states()
	return list("damaged")

/turf/open/floor/beton/setup_burnt_states()
	return list("damaged")

/turf/open/floor/beton/Initialize(mapload)
	..()
	update_icon()

/turf/open/floor/beton/update_icon()
	if(!..())
		return 0
	if(!broken && !burnt)
		if(smoothing_flags)
			QUEUE_SMOOTH(src)
	else
		make_plating()
		if(smoothing_flags)
			QUEUE_SMOOTH_NEIGHBORS(src)

/******************Structures***************************/

/obj/structure/falsewall/brick
	name = "кирпичная стена"
	desc = "Изначально эти стены были белого цвета, но со временем люди стали их красить. Собой."
	icon = 'white/valtos/icons/prison/brick_wall.dmi'
	icon_state = "brick_wall-0"
	walltype = /turf/closed/wall/brick
	canSmoothWith = list(SMOOTH_GROUP_WALLS)

/obj/structure/curtain/prison/update_icon()
	. = ..()
	if(!open)
		icon_state = "closed"
		layer = WALL_OBJ_LAYER
		density = FALSE
		open = FALSE
		opacity = 1

	else
		icon_state = "open"
		layer = WALL_OBJ_LAYER
		density = FALSE
		open = TRUE
		opacity = 0

/******************Uniforms****************************/

/obj/item/clothing/under/prison/nach
	name = "костюм начальника"
	desc = "Стильная рубашка к не менее модным штанам."
	icon = 'white/valtos/icons/prison/uniform.dmi'
	worn_icon = 'white/valtos/icons/prison/uniform_onmob.dmi'
	icon_state = "nach"
	inhand_icon_state = "nach"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0, fire = 50, acid = 50)
	strip_delay = 60

/obj/item/clothing/under/prison/vertuhai
	name = "костюм вертухая"
	desc = "Стандартная униформа военнослужащего."
	icon = 'white/valtos/icons/prison/uniform.dmi'
	worn_icon = 'white/valtos/icons/prison/uniform_onmob.dmi'
	icon_state = "vert"
	inhand_icon_state = "vert"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0, fire = 50, acid = 50)
	strip_delay = 60

/obj/item/clothing/under/prison/prison
	desc = "Форма уличного мима. Погодите-ка... Нет, все таки тюремная."
	icon = 'white/valtos/icons/prison/uniform.dmi'
	worn_icon = 'white/valtos/icons/prison/uniform_onmob.dmi'
	icon_state = "prisoner"
	inhand_icon_state = "prisoner"
	has_sensor = LOCKED_SENSORS
	sensor_mode = SENSOR_COORDS
	random_sensor = 0

/obj/item/clothing/under/prison/prison/Initialize(mapload)
	..()
	name = "форма #[rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)]"

/******************Suits*******************************/

/obj/item/clothing/suit/armor/ussr
	name = "бронепальто"
	desc = "Крепкий и теплый."
	icon = 'white/valtos/icons/prison/uniform.dmi'
	worn_icon = 'white/valtos/icons/prison/uniform_onmob.dmi'
	icon_state = "vertsuit"
	inhand_icon_state = "vertsuit"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	armor = list(melee = 30, bullet = 30, laser = 30, energy = 10, bomb = 25, bio = 0, rad = 0, fire = 70, acid = 90)
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	strip_delay = 80

/******************Headgear****************************/

/obj/item/clothing/head/helmet/ussr
	name = "каска"
	desc = "Крепкая каска."
	icon = 'white/valtos/icons/prison/uniform.dmi'
	worn_icon = 'white/valtos/icons/prison/uniform_onmob.dmi'
	icon_state = "helm"
	inhand_icon_state = "helm"
	w_class = WEIGHT_CLASS_NORMAL
	armor = list(melee = 50, bullet = 50, laser = 50, energy = 40, bomb = 60, bio = 0, rad = 0, fire = 60, acid = 60)

/obj/item/clothing/head/tyubet
	name = "тюбетейка"
	desc = "Тюбетейка."
	icon = 'white/valtos/icons/prison/uniform.dmi'
	worn_icon = 'white/valtos/icons/prison/uniform_onmob.dmi'
	icon_state = "phat"
	inhand_icon_state = "phat"

/******************Doors*******************************/

/obj/machinery/door/airlock/prison
	name = "дверь"
	icon = 'white/valtos/icons/prison/doors.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_wood
	desc = "Обычная стальная дверь покрытая плотным слоем дерева."
	glass = FALSE
	autoclose = FALSE
	lights = FALSE
	normal_integrity = 1200
	damage_deflection = 30
	req_access_txt = "150"
	doorOpen = 'sound/machines/door_open.ogg'
	doorClose = 'sound/machines/door_close.ogg'
	boltUp = 'sound/machines/door_locked.ogg'
	boltDown = 'sound/machines/door_locked.ogg'
	doorDeni = 'sound/machines/door_locked.ogg'

/obj/machinery/door/airlock/prison/cell
	glass = TRUE
	locked = 1
	opacity = 0
	assemblytype = /obj/structure/door_assembly/door_assembly_wood

/obj/machinery/door/poddoor/shutters/prison
	name = "крепкая дверь"
	desc = "Сверхкрепкая."
	icon = 'white/valtos/icons/prison/prison.dmi'
	icon_state = "closed"
	id = "cells"
	max_integrity = 1200

/obj/machinery/door/poddoor/shutters/prison/update_icon()
	. = ..()
	if(density)
		playsound(src, 'white/valtos/sounds/prison/close.ogg', 20, 1)
		icon_state = "closed"
	else
		playsound(src, 'white/valtos/sounds/prison/open.ogg', 20, 1)
		icon_state = "open"

/******************Structures Signs********************/

/obj/structure/sign/prison
	icon = 'white/valtos/icons/prison/prison.dmi'

/obj/structure/sign/prison/tablo
	name = "табло"
	icon = 'white/valtos/icons/prison/prisonw.dmi'
	desc = "Табличка. Кусь."
	icon_state = "t1"

/obj/structure/sign/prison/tablo/Initialize(mapload)
	..()
	icon_state = "t[rand(1,18)]"

/obj/structure/sign/prison/uprava
	name = "управа"
	icon = 'white/valtos/icons/prison/prisonw.dmi'
	desc = "Здесь решаются судьбы."
	icon_state = "uprava"

/obj/structure/sign/prison/blok1
	name = "первый блок"
	desc = "Родная хата."
	icon_state = "blok1"

/obj/structure/sign/prison/tok
	desc = "Не прикасайся!"
	icon_state = "tok"

/obj/structure/sign/prison/hitler
	desc = "Какой красивый мальчик."
	icon_state = "hitler"

/obj/structure/sign/prison/net
	desc = "Нет!"
	icon_state = "net"

/obj/structure/sign/prison/kolesa
	desc = "Помни о колесах."
	icon_state = "kolesa"

/obj/structure/sign/prison/pobeda
	desc = "К новым победам в труде и спорте!"
	icon_state = "pobeda"

/obj/structure/sign/prison/bolt
	desc = "Не болтай!"
	icon_state = "bolt"

/obj/structure/sign/prison/pyan
	desc = "Я на производстве был пьян."
	icon_state = "pyan"

/obj/structure/sign/prison/yannp
	desc = "У меня возник когнитивный диссонанс!"
	icon_state = "yannp"

/obj/structure/sign/prison/bolt
	desc = "Не болтай!."
	icon_state = "bolt"

/********************Machinery***************************/

/obj/machinery/vending/sovietvend
	name = "БОДА?"
	icon = 'white/valtos/icons/prison/prison.dmi'
	desc = "Каждому трудящемуся по инструменту!"
	icon_state = "sovietvend"
	product_ads = "За Царя и Страну.;А ты выполнил норму сегодня?;Слава Советскому Союзу!"
	products = list(/obj/item/clothing/under/costume/soviet = 20, /obj/item/clothing/head/ushanka = 20, /obj/item/food/candy = 40,
					/obj/item/reagent_containers/food/drinks/bottle/vodka = 40, /obj/item/kitchen/knife/butcher = 10)
	contraband = list(/obj/item/clothing/under/syndicate/tacticool = 20)
	armor = list(melee = 100, bullet = 100, laser = 100, energy = 100, bomb = 0, bio = 0, rad = 0, fire = 100, acid = 50)
	resistance_flags = FIRE_PROOF

/obj/machinery/door/airlock/woodsov
	name = "деревянная советская дверь"
	icon = 'icons/obj/doors/airlocks/station/wood.dmi'
	var/mineral = "wood"
	req_access_txt = "150"
	assemblytype = /obj/structure/door_assembly/door_assembly_wood

/obj/machinery/power/port_gen/pacman/coal
	name = "HellMachine"
	desc = "Эта штука заставляет лампочки полыхать адским пламенем за счет сжигания угля. Сатанинская машина."
	icon = 'white/valtos/icons/prison/prisond.dmi'
	icon_state = "portgen0_0"
	base_icon = "portgen0"
	sheet_path = /obj/item/stack/sheet/mineral/coal
	power_gen = 25000
	time_per_sheet = 85
	density = TRUE
	anchored = TRUE

/********************Top Z-Levels***************************/

/obj/effect/bump_teleporter/prison/Bumped(atom/movable/AM)
	if(!ismob(AM))
		return
	if(!id_target)
		return

	for(var/obj/effect/bump_teleporter/BT in AllTeleporters)
		if(BT.id == src.id_target)
			AM.visible_message(span_boldwarning("[AM] сорвался!") , span_userdanger("Кажется я упал..."))
			AM.forceMove(BT.loc) //Teleport to location with correct id.
			if(isliving(AM))
				var/mob/living/L = AM
				L.Knockdown(100)
				L.adjustBruteLoss(70)

/obj/effect/decal/tuman
	name = "туман"
	desc = "Синий туман, похож на обман..."
	icon = 'white/valtos/icons/prison/prison.dmi'
	icon_state = "tuman"
	layer = 6

/********************Tiles***************************/

/obj/item/stack/tile/beton
	name = "бетонная плитка"
	singular_name = "бетонная плитка"
	desc = "Кусок бетона. Ммм..."
	icon = 'white/valtos/icons/prison/prison.dmi'
	icon_state = "tile_beton"
	turf_type = /turf/open/floor/beton
	merge_type = /obj/item/stack/tile/beton

/obj/item/stack/tile/trot
	name = "кусок асфальта"
	singular_name = "кусок асфальта"
	desc = "Кусок тротуарной плитки. Зачем?"
	icon = 'white/valtos/icons/prison/prison.dmi'
	icon_state = "tile_trot"
	turf_type = /turf/open/floor/trot
	merge_type = /obj/item/stack/tile/trot

/********************Plants***************************/

/obj/machinery/prisonplant
	name = "растение"
	icon = 'icons/obj/flora/plants.dmi'
	icon_state = "plant-01"
	layer = 5
	anchored = 1

/obj/machinery/prisonplant/Initialize(mapload)
	..()
	icon_state = "plant-[rand(0,2)][rand(0,5)]"

/********************Misc-Deco****************************/

/obj/structure/chair/prison/wood
	name = "стул"
	desc = "Стул. Простой стул из дерева."
	icon = 'white/valtos/icons/prison/decor.dmi'
	icon_state = "chair"
	item_chair = null

/obj/structure/prison/fence
	name = "забор"
	desc = "Сложный забор. СЛОЖНЫЙ!"
	icon = 'white/valtos/icons/prison/decor.dmi'
	icon_state = "fence"
	pass_flags = LETPASSTHROW
	var/proj_pass_rate = 80
	max_integrity = 1000
	damage_deflection = 10
	layer = 5
	anchored = 1
	density = 1
	opacity = 0

/obj/structure/prison/fence/CanPass(atom/movable/mover, border_dir)
	if(locate(/obj/structure/prison/fence) in get_turf(mover))
		return 1
	else if(istype(mover, /obj/projectile))
		if(!anchored)
			return 1
		var/obj/projectile/proj = mover
		if(proj.firer && Adjacent(proj.firer))
			return 1
		if(prob(proj_pass_rate))
			return 1
		return ..()
	else
		return ..()

/obj/structure/prison/pipe
	name = "труб"
	desc = "Идеальный путь на свободу. Но не сейчас."
	icon = 'white/valtos/icons/prison/decor.dmi'
	icon_state = "trubas"
	density = 0
	opacity = 0
	layer = 6
	alpha = 205

/obj/structure/table/prison
	desc = "Самый обычный стол из дерева, ничего интересного."
	icon = 'white/valtos/icons/prison/decor.dmi'
	icon_state = "table"
	smoothing_flags = NONE
	deconstruction_ready = 0
	max_integrity = 1000

/obj/structure/closet/pcloset
	name = "шкаф"
	desc = "Довольно старый."
	icon_state = "cabinet"
	resistance_flags = FLAMMABLE
	max_integrity = 70

/obj/effect/decal/prison/pipe
	name = "труба"
	desc = "Тепленькая."
	icon = 'white/valtos/icons/prison/decor.dmi'
	icon_state = "pipe1"
	layer = 2.5
	pixel_y = 12

/obj/effect/decal/prison/pipe/pipea
	icon_state = "pipe2"

/obj/effect/decal/prison/pipe/pipeb
	icon_state = "pipe3"

/obj/effect/decal/prison/pipe/pipec
	icon_state = "pipe4"

/obj/effect/decal/prison/pipe/piped
	icon_state = "pipe5"

/obj/structure/prison/tv
	name = "телевизор"
	icon = 'white/valtos/icons/prison/prison.dmi'
	desc = "Наш любимый советский телевизор."
	icon_state = "TV"
	density = 1

/obj/structure/bed/prison/bed
	name = "кровать"
	icon = 'white/valtos/icons/prison/decor.dmi'
	desc = "Тут можно отдохнуть, но не всегда."
	buildstacktype = /obj/item/stack/sheet/iron
	icon_state = "bed"

/obj/structure/bed/prison/bed/Initialize(mapload)
	GLOB.dwarf_shkonka_list += src
	. = ..()

/obj/structure/bed/prison/bed/Destroy()
	GLOB.dwarf_shkonka_list -= src
	. = ..()

/********************Lights***************************/

/obj/machinery/light/streetlight
	name = "уличная лампа"
	icon = 'white/valtos/icons/prison/prisonh.dmi'
	base_state = "light"
	icon_state = "light1"
	brightness = 10
	layer = 5
	density = 1
	light_type = /obj/item/light/bulb
	fitting = "bulb"

/********************Guns***************************/

/obj/item/gun/ballistic/automatic/ak
	name = "\improper AK-47"
	desc = "Легендарный автомат Калашникова. Использует патроны калибра 7.62"
	icon = 'white/valtos/icons/prison/prison.dmi'
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	worn_icon = 'white/valtos/icons/weapons/mob/back.dmi'
	icon_state = "kalash"
	inhand_icon_state = "ak47"
	worn_icon_state = "ak47"
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_BELT
	mag_type = /obj/item/ammo_box/magazine/ak762
	burst_size = 3

/obj/item/ammo_box/magazine/ak762
	name = "AK-47 magazine (7.62)"
	icon = 'white/valtos/icons/prison/prison.dmi'
	icon_state = "akmag"
	ammo_type = /obj/item/ammo_casing/a762
	caliber = "a762"
	max_ammo = 30

/*********************ID system*************************/

/obj/item/card/id/keys
	name = "ключи"
	icon = 'white/valtos/icons/prison/prison.dmi'
	icon_state = "keys"
	desc = "Ключи от всех дверей"
	access = list(ACCESS_SYNDICATE)

/*********************Sovietlathe************************/

/obj/machinery/autolathe/soviet
	name = "sovietlathe"
	circuit = /obj/item/circuitboard/machine/autolathe/soviet
	categories = list(
					"Инструменты",
					"Электроника",
					"Телекомы",
					"Безопасность",
					"Оборудование",
					"Медицина",
					"Разное",
					"Кухня",
					"Импорт")

/obj/item/circuitboard/machine/autolathe/soviet
	name = "Советлат (Оборудование)"
	build_path = /obj/machinery/autolathe/soviet

/*********************Radio Shit*************************/

/obj/item/radio/headset/radioprison
	name = "советская рация"
	icon = 'white/valtos/icons/prison/prison.dmi'
	desc = "Новейшая разработка советских ученых - рация!"
	slot_flags = ITEM_SLOT_EARS
	icon_state = "radio"

/**********************Spawners**************************/

/obj/effect/mob_spawn/human/prison
	desc = "Кажется тут кто-то затаился под шконкой..."
	icon = 'white/valtos/icons/prison/prison.dmi'
	icon_state = "spwn"
	roundstart = FALSE
	death = FALSE
	var/list/imena = list("Петренко", "Гаврилов", "Смирнов", "Гмызенко", "Юлия", "Сафронов", "Павлов", "Пердюк", "Золотарев", "Михалыч", "Попов", "Лштшфум Ащьф")


/obj/effect/mob_spawn/human/prison/doctor
	name = "доктор"
	flavour_text = "Вы вечный патологоанатом тюрьмы Ромашка. Постарайтесь следить за телами, живые они или нет, и не забывайте готовить мясо для котлет. Убивать и сбегать без особой причины запрещено, иначе Вас забанят. Правила тут работают в полную силу."
	outfit = /datum/outfit/prison/doctor
	assignedrole = "Doctor USSR"

/obj/effect/mob_spawn/human/prison/chaplain
	name = "пророк"
	flavour_text = "Вы бывший заключенный тюрьмы Ромашка подавшийся в священнослужение. Помогайте чем можете всем нуждающимся. Убивать и сбегать без особой причины запрещено, иначе Вас забанят. Правила тут работают в полную силу."
	outfit = /datum/outfit/prison/prisoner
	assignedrole = "Prorok USSR"

/obj/effect/mob_spawn/human/prison/vertuhai
	name = "вертухай"
	flavour_text = "Вы вечный смотритель тюрьмы Ромашка. Постарайтесь не убивать зеков без приказа свыше и не забывайте кушать котлеты. Убивать и сбегать без особой причины запрещено, иначе Вас забанят. Правила тут работают в полную силу."
	outfit = /datum/outfit/prison/vertuhai
	assignedrole = "Vertuhai USSR"

/obj/effect/mob_spawn/human/prison/mehanik
	name = "механик"
	flavour_text = "Вы вечный механик тюрьмы Ромашка. Постарайтесь не взорвать двигатель, починить, что не сломано и не забывайте спрашивать у зеков, когда котлеты будут там. Убивать и сбегать без особой причины запрещено, иначе Вас забанят. Правила тут работают в полную силу."
	outfit = /datum/outfit/prison/mehanik
	assignedrole = "Mehanik USSR"

/obj/effect/mob_spawn/human/prison/nachalnik
	name = "начальник"
	flavour_text = "Вы вечный надзиратель тюрьмы Ромашка. Постарайтесь привести её в порядок и не забывайте напоминать зекам о том, что котлеты только завтра. Убивать и сбегать без особой причины запрещено, иначе Вас забанят. Правила тут работают в полную силу."
	icon_state = "spwn"
	outfit = /datum/outfit/prison/nachalnik
	assignedrole = "Nachalnik USSR"

/obj/effect/mob_spawn/human/prison/prisoner
	name = "шконка"
	desc = "Кажется тут кто-то затаился под шконкой..."
	flavour_text = "Вы вечный заключенный тюрьмы Ромашка. Отсиживайте свой тюремный срок как следует, слушайтесь начальника и не забывайте о том, что котлеты только завтра. Убивать и сбегать без особой причины запрещено, иначе Вас забанят. Правила тут работают в полную силу. Кстати, сидишь ты тут за "
	outfit = /datum/outfit/prison/prisoner
	assignedrole = "Prisoner USSR"

/**********************Outfits**************************/

/datum/outfit/prison
	name = "USSR"

/datum/outfit/prison/doctor
	name = "Doctor USSR"
	head = /obj/item/clothing/head/ushanka
	ears = /obj/item/radio/headset/radioprison
	uniform = /obj/item/clothing/under/costume/soviet
	suit = /obj/item/clothing/suit/toggle/labcoat
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	r_pocket = /obj/item/gun/ballistic/automatic/pistol
	l_pocket = /obj/item/card/id/keys
	back = /obj/item/storage/backpack/satchel/leather
	backpack_contents = list(/obj/item/flashlight/lantern = 1, /obj/item/crowbar/red = 1, /obj/item/melee/classic_baton = 1)
	implants = list(/obj/item/implant/weapons_auth, /obj/item/implant/exile)

/datum/outfit/prison/vertuhai
	name = "Vertuhai USSR"
	head = /obj/item/clothing/head/ushanka
	ears = /obj/item/radio/headset/radioprison
	uniform = /obj/item/clothing/under/costume/soviet
	suit = /obj/item/clothing/suit/armor/vest
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	r_pocket = /obj/item/restraints/handcuffs
	l_pocket = /obj/item/card/id/keys
	belt = /obj/item/melee/classic_baton
	back = /obj/item/storage/backpack/satchel/leather
	backpack_contents = list(/obj/item/flashlight/lantern = 1, /obj/item/crowbar/red = 1, /obj/item/melee/classic_baton = 1)
	implants = list(/obj/item/implant/weapons_auth, /obj/item/implant/exile)

/datum/outfit/prison/mehanik
	name = "Mehanik USSR"
	head = /obj/item/clothing/head/ushanka
	ears = /obj/item/radio/headset/radioprison
	uniform = /obj/item/clothing/under/costume/soviet
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	r_pocket = /obj/item/gun/ballistic/automatic/pistol
	l_pocket = /obj/item/card/id/keys
	belt = /obj/item/storage/belt/utility/full/engi
	back = /obj/item/storage/backpack/satchel/leather
	backpack_contents = list(/obj/item/flashlight/lantern = 1, /obj/item/crowbar/red = 1, /obj/item/melee/classic_baton = 1)
	implants = list(/obj/item/implant/weapons_auth, /obj/item/implant/exile)

/datum/outfit/prison/nachalnik
	name = "Nachalnik USSR"
	head = /obj/item/clothing/head/ushanka
	ears = /obj/item/radio/headset/radioprison
	uniform = /obj/item/clothing/under/syndicate/combat
	suit = /obj/item/clothing/suit/armor/vest/capcarapace/syndicate
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	r_pocket = /obj/item/gun/ballistic/automatic/pistol
	l_pocket = /obj/item/card/id/keys
	belt = /obj/item/storage/belt/military
	back = /obj/item/storage/backpack/satchel/leather
	backpack_contents = list(/obj/item/flashlight/lantern = 1, /obj/item/crowbar/red = 1)
	implants = list(/obj/item/implant/weapons_auth, /obj/item/implant/exile)

/datum/outfit/prison/prisoner
	name = "Prisoner USSR"
	uniform = /obj/item/clothing/under/rank/prisoner
	shoes = /obj/item/clothing/shoes/sneakers/orange

/**********************Spawn-flavoures**************************/

/obj/effect/mob_spawn/human/prison/doctor/special(mob/living/L)
	L.real_name = "Доктор [pick(imena)]"
	L.name = L.real_name

/obj/effect/mob_spawn/human/prison/vertuhai/special(mob/living/L)
	L.real_name = "Смотритель [pick(imena)]"
	L.name = L.real_name

/obj/effect/mob_spawn/human/prison/mehanik/special(mob/living/L)
	L.real_name = "Механик [pick(imena)]"
	L.name = L.real_name

/obj/effect/mob_spawn/human/prison/nachalnik/special(mob/living/L)
	L.real_name = "Начальник [pick(imena)]"
	L.name = L.real_name

/obj/effect/mob_spawn/human/prison/prisoner/special(mob/living/L)
	var/list/klikuhi = list("Борзый", "Дохляк", "Академик", "Акула", "Базарило", "Бродяга", "Валет", "Воровайка", "Гнедой", \
	"Гребень", "Дельфин", "Дырявый", "Игловой", "Карась", "Каторжанин", "Лабух", "Мазурик", "Мокрушник", "Понтовитый", \
	"Ржавый", "Седой", "Сявка", "Темнила", "Чайка", "Чепушило", "Шакал", "Шерстяной", "Шмаровоз", "Шпилевой", "Олька", "Машка", \
	"Щипач", "Якорник", "Сладкий", "Семьянин", "Порученец", "Блатной", "Арап", "Артист", "Апельсин", "Афер")
	L.real_name = "[pick(klikuhi)]"
	L.name = L.real_name

/obj/effect/mob_spawn/human/prison/prisoner/Initialize(mapload)
	. = ..()
	var/list/zacho = list("убийство", "воровство", "коррупцию", "неисполнение обязанностей", "похищение людей", "грубую некомпетентность", \
	"кражу", "поклонение запрещенному божеству", "межвидовые отношения", "мятеж")
	flavour_text += "[pick(zacho)]."

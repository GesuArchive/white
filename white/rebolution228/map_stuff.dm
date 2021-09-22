
////////////////////////////////////////////////
//
// chilly.dmm
//
////////////////////////////////////////////////

/* AREAS */

//Main
/area/awaymission/chilly
	name = "Chilly"
	icon = 'white/rebolution228/map_sprites.dmi'
	icon_state = "coutdoor"
	requires_power = TRUE
	has_gravity = STANDARD_GRAVITY
	area_flags = VALID_TERRITORY | UNIQUE_AREA | NOTELEPORT
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	//poweralm = FALSE
	ambientsounds = list('sound/ambience/white/snowyambient.ogg')
	env_temp_relative = -25
	static_lighting = FALSE
	base_lighting_color = COLOR_WHITE
	base_lighting_alpha = 255

/area/awaymission/chilly/surface // костыль, потому что шторм иначе будет применяться на все зоны
	name = "Surface"
	icon_state = "coutdoor"
	env_temp_relative = -25
	blend_mode = 0

/area/awaymission/chilly/surface/Initialize()
	. = ..()
	icon = 'white/valtos/icons/cliffs.dmi'
	icon_state = "snow_storm"
	layer = OPENSPACE_LAYER

/area/awaymission/chilly/surface/update_icon_state()
	return

//Facilities
/area/awaymission/chilly/facility
	name = "Base I"
	icon_state = "base"
	base_lighting_alpha = 1
	static_lighting = TRUE
	requires_power = TRUE
	always_unpowered = TRUE
	ambientsounds = list('sound/ambience/ambireebe1.ogg')
	env_temp_relative = -10

/area/awaymission/chilly/facility/croom
	name = "Base I Underground Control Room"
	icon_state = "base_eng"
	static_lighting = TRUE
	requires_power = FALSE
	always_unpowered = FALSE
	env_temp_relative = -5

/area/awaymission/chilly/facility2
	name = "Base II"
	icon_state = "base2"
	base_lighting_alpha = 1
	static_lighting = TRUE
	requires_power = TRUE
	ambientsounds = list('sound/ambience/ambireebe3.ogg')
	always_unpowered = TRUE
	env_temp_relative = -10

/area/awaymission/chilly/facility3
	name = "Base III"
	icon_state = "base3"
	base_lighting_alpha = 1
	static_lighting = TRUE
	requires_power = TRUE
	always_unpowered = TRUE
	ambientsounds = list('sound/ambience/ambireebe2.ogg')
	env_temp_relative = -15

/area/awaymission/chilly/facility4
	name = "Base IV House"
	icon_state = "base4"
	base_lighting_alpha = 1
	static_lighting = TRUE
	requires_power = TRUE
	always_unpowered = TRUE
	ambientsounds = list('sound/ambience/ambiruin4.ogg')
	env_temp_relative = -15

/area/awaymission/chilly/facility5
	name = "Base V"
	icon_state = "base5"
	base_lighting_alpha = 1
	static_lighting = TRUE
	requires_power = TRUE
	always_unpowered = TRUE
	ambientsounds = list('sound/ambience/ambitech.ogg')
	env_temp_relative = -20


//Underground something
/area/awaymission/chilly/cave
	name = "Underground Train Tracks"
	icon_state = "caverns"
	base_lighting_alpha = 1
	static_lighting = TRUE
	requires_power = TRUE
	always_unpowered = TRUE
	ambientsounds = list('sound/ambience/ambireebe3.ogg')
	env_temp_relative = -15

/area/awaymission/chilly/syndietrain
	name = "Syndicate Cargo Train"
	icon_state = "syndie_train"
	base_lighting_alpha = 1
	static_lighting = TRUE
	requires_power = FALSE
	ambientsounds = list('sound/ambience/ambireebe3.ogg')
	always_unpowered = FALSE
	env_temp_relative = -5

/area/awaymission/chilly/ntcargotrain
	name = "NanoTrasen Cargo Train Wreckage"
	icon_state = "nt_train"
	base_lighting_alpha = 1
	static_lighting = TRUE
	requires_power = TRUE
	ambientsounds = list('sound/ambience/ambireebe3.ogg')
	always_unpowered = TRUE
	env_temp_relative = -25



//Misc
/area/awaymission/chilly/mountain
	name = "Mountain"
	icon_state = "mountain"
	base_lighting_alpha = 1
	static_lighting = TRUE
	always_unpowered = TRUE
	env_temp_relative = -30

/area/awaymission/chilly/gatewaystart
	name = "Gateway Entrance"
	icon_state = "gateways"
	base_lighting_alpha = 1
	static_lighting = TRUE
	requires_power = FALSE
	always_unpowered = FALSE
	ambientsounds = list('sound/ambience/ambitech.ogg', 'sound/ambience/ambitech2.ogg', 'sound/ambience/ambitech3.ogg')
	env_temp_relative = 0

/area/awaymission/chilly/gatewaystart/base2armory
	name = "Base II Armory"
	icon_state = "base2armory"
	env_temp_relative = 0
	base_lighting_alpha = 1

/area/awaymission/chilly/facility/emergencystorage
	name = "Emergency Storage"
	icon_state = "estorage"
	env_temp_relative = -5
	base_lighting_alpha = 1

/* TURFS */


/turf/open/floor/plasteel/stairs/old/chilly
	name = "stairs"
	icon = 'white/rebolution228/map_sprites.dmi'
	icon_state = "stairs"

/turf/open/floor/plasteel/stairs/old/chilly/right
	name = "stairs"
	icon = 'white/rebolution228/map_sprites.dmi'
	icon_state = "stairs_right"

/turf/open/floor/plasteel/stairs/old/chilly/left
	name = "stairs"
	icon = 'white/rebolution228/map_sprites.dmi'
	icon_state = "stairs_left"

/turf/open/floor/plasteel/stairs/old/chilly/single
	name = "stairs"
	icon = 'white/rebolution228/map_sprites.dmi'
	icon_state = "stairs_single"

/* MISC */


/obj/effect/turf_decal/weather/side
	name = "side"
	icon = 'white/rebolution228/map_sprites.dmi'
	icon_state = "side"
	mouse_opacity = 0

/obj/effect/turf_decal/weather/side/corner
	icon_state = "sidecorn"

/obj/effect/turf_decal/dust
	name = "dust"
	icon = 'white/rebolution228/map_sprites.dmi'
	icon_state = "dirty"
	mouse_opacity = 0

/turf/open/floor/grass/snow/safe/oxy
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS

/turf/open/floor/plating/snowed/oxy
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = FALSE

/turf/open/floor/plating/asteroid/snow/ice/oxy
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = FALSE

/turf/open/floor/plating/snowed/smoothed/temperatre
	temperature = 255.37
	planetary_atmos = FALSE

/turf/open/floor/engine/hull/oxy
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	temperature = 255.37

/turf/open/floor/plating/ice/smooth/oxy
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = FALSE
	temperature = 250
	baseturfs = /turf/open/floor/grass/snow/safe/oxy

/turf/closed/mineral/snowmountain/cavern/oxy
	baseturfs = /turf/open/floor/plating/asteroid/snow/ice/oxy
	environment_type = null
	turf_type = /turf/open/floor/plating/asteroid/snow/ice/oxy

/obj/machinery/porta_turret/armory/chilly
	name = "heavy laser turret"
	desc = "An energy blaster auto-turret."
	lethal_projectile = /obj/projectile/beam/laser/heavylaser
	turret_flags = TURRET_FLAG_SHOOT_ALL
	scan_range = 6
	armor = list(MELEE = 50, BULLET = 30, LASER = 30, ENERGY = 30, BOMB = 80, BIO = 0, RAD = 0, FIRE = 90, ACID = 90)

/obj/machinery/porta_turret/syndicate/shuttle/chilly
	shot_delay = 8
	armor = list(MELEE = 50, BULLET = 30, LASER = 30, ENERGY = 30, BOMB = 80, BIO = 0, RAD = 0, FIRE = 90, ACID = 90)

/obj/effect/mob_spawn/human/corpse/damaged/chilly
	burn_damage = 1000
	hairstyle = null
	facial_hairstyle = null
	husk = TRUE

/obj/structure/sign/warning/securearea/deck1
	name = "DECK I"
	icon = 'white/rebolution228/map_sprites.dmi'
	icon_state = "deck1"

/obj/structure/sign/warning/securearea/ntsign
	name = "NanoTrasen sign"
	desc = "Logo of NanoTrasen megacorporation, signifying their property."
	icon = 'white/rebolution228/map_sprites.dmi'
	icon_state = "nt_sign"

/obj/machinery/doorpanel // just decor so it does nothing
	name = "screen"
	desc = "Some kind of machinery that opens some door."
	icon = 'white/rebolution228/map_sprites.dmi'
	icon_state = "screen"
	anchored = 1
	density = 0
	opacity = 0

/obj/machinery/doorpanel/broken
	desc = "Some kind of machinery that opens some door. Their screen appears to be broken."
	icon = 'white/rebolution228/map_sprites.dmi'
	icon_state = "screen_b"

/obj/machinery/doorpanel/attack_hand(mob/living/carbon/human/user)
    to_chat(user, span_warning("It has no power!"))

/obj/machinery/doorpanel/broken/attack_hand(mob/living/carbon/human/user)
    to_chat(user, span_warning("It's broken."))

/obj/machinery/oldvents
	name = "ventilation"
	icon = 'white/rebolution228/map_sprites.dmi'
	icon_state = "vent1"
	anchored = 1
	density = 0
	opacity = 0
	plane = -2

/obj/machinery/oldvents/variant1
	icon_state = "vent1_1"

/obj/machinery/oldvents/variant2
	icon_state = "vent1_2"

/obj/machinery/oldvents/variant3
	icon_state = "vent1_3"

/obj/machinery/oldvents/variant4
	icon_state = "vent1_4"

/obj/machinery/oldvents/scrubber
	name = "scrubber"
	icon_state = "vent2"

/* NOTES */

/obj/item/paper/fluff/awaymissions/chilly/test
	name = "scribbled note"
	info = {"Тест. <br>test<br>сука"}

/obj/item/paper/crumpled/awaymissions/chilly/base1scientist
	name = "scribbled note"
	desc = "You can see something's written on it."
	info = {"<b>22.09.2554</b>
			<br>Отправили в командировку на планету: собрать как можно больше информацию о климате. По правде говоря, мне это место уже не нравится. Ещё и охранник какую-то лабуду несёт, говорит, что он службу в спецназе вёл. Ага, конечно, так я и поверил.
			<br>
			<br><b>25.09.2554</b>
			<br>Когда я делал замеры, то краем глаза заметил какую-то парочку, гуляющую неподалеку от нас. То ли обдолбанные, то ли ещё что-то. Пришлось позвать охрану, чтобы они убрались отсюда. Это же ведь охраняемая территория, какого хрена здесь ходят какие-то плебеи?!
			<br>
			<br><b>28.09.2554</b>
			<br>Во время вечерней отклички наш инженер куда-то делся. Валериан сказал, что тот выходил на улицу, с тех пор не возвращался. Может, на медведей напоролся? Охрана прочистила ближайший участок около нашей базы, но из-за бури ничего особенного не нашла. Надеюсь, что этот любитель приключений найдётся.
			<br>
			<br><b>02.10.2554</b>
			<br>Инженера все ещё не нашли, мы предполагаем, что тот сбежал или его загрызли волки. Нашли место для исследований, ага. Ещё и этой ночью заснуть не мог из-за шорохов в вентиляции. Зачем я только на это подписывался?
			<br>
			<br><b>07.10.2554</b>
			<br>Сегодня отказал движок. Питания на базу хватит на 3-4 дня, не более. Смотритель пытался сообщить командованию об этой проблеме, но связь здесь не ловит. Проклятая буря.
			<br>К нам ещё приходил инженер с соседней базы, спрашивал, не слышим ли мы странные звуки из вентиляции. Как оказалось, это не только наша проблема.
			<br>
			<br><b>10.10.2554</b>
			<br>Вот и всё, питание кончилось. Придётся запитывать важные отсеки ПАКМАНОМ, благо у нас плазма ещё оставалась, но её при таком использовании хватит максимум на неделю. Связи до сих пор нет.
			<br>
			<br><b>11.10.2554</b>
			<br>Решил выйти и покурить в местных подземных путях, как вдруг из за дверей соседней базы услышал глухой крик. Хотел проведать, что там, а шлюз оказался на болтах. Какого чёрта там происходит?
			<br>
			<br><b>13.10.2554</b>
			<br>Ночью перед отбоем слышали громкий стук в шлюз. Мы вышли, но никого там не оказалось. Мне уже хочётся свалить отсюда, здесь слишком страшно.
			<br>
			<br><b>14.10.2554</b>
			<br>Меня внезапно пробудил Эрнест, говорит, что полчаса назад двое наших вышли на улицу, а спустя время слышали агонический крик. У нас назрела паника: офицер снабжения закрылся у себя в комнате, а стекло в южном корридоре оказалось разбито. Нас всех сейчас собирают в столовой, направляюсь туда."}

/obj/item/paper/fluff/awaymissions/chilly/base2traitorobj
	name = "Mission Note"
	info = {"<b>СОВЕРШЕННО СЕКРЕТНО</b>
			<br>
			<br><b>Название:</b> NT-RF-9024R.
			<br><b>Координаты:</b> 54° С.Ш, 73° В.Д. Квадрат Y8-Y9.
			<br><b>Деятельность:</b> Подробное исследование метеорологии планеты, разработка биологического оружия.
			<br><b>Статус:</b> <i>Функционирует.</i>"
			<br><b>Тип двигателя: Ядерный. ND065Pu-6000</b>
			<br><b>Численность экипажа:</b> 52 человек гражданского персонала, 23 представителей службы безопасности.
			<br>
			<br><b>Цель миссии:</b> Кража биологического оружия.
			<br><b>Задание №1:</b> Украсть биологическое оружие с кодовым названием 'Ромерол'.
			<br><b>Задание №2:</b> Инициировать саботаж комплекса.
			<br><b>Задание №3:</b> Сбежать с комплекса живым и без содержания под стражей.
			<br><i>Для осуществления эвакуации и дальнейшей связи с командованием необходимо написать через ПДА сообщение по идентификатору 5305-26-79 код 'Весна встретит новый рассвет'.
			<br><b>Мы замаскировали аплинк в ваш ПДА. Нужно просто ввести в название рингтона код "365 Дельта", чтобы получить доступ к нему.</b>
			<br>
			<br>
			<br><b>Время на выполнение задания:</b> 2 недели."}

/obj/item/paper/crumpled/awaymissions/chilly/camp3
	name = "Note"
	info = {"<b>07/09/2554</b>
			<br><i>Только что высадились с вертолёта. Здесь так здорово! Нам сказали, что припасы и еду нам будут доставлять каждые 2 недели. Надеюсь, что здесь очень хорошо отдохну!</i>
			<br>
			<br><b>09/09/2554</b>
			<br><i>Сегодня весь день были под кайфом - Джейкоб умудрился с собой притащить семена каннабиса. Удивительно, что она выросла всего за несколько часов.</i>
			<br>
			<br><b>14/09/2554</b>
			<br><i>Пока ничего особенного не случилось. Скотт скурил всю шмаль, но мы вырастили ещё.</i>
			<br>
			<br><b>21/09/2554</b>
			<br><i>Прошло уже 2 недели, как мы отдыхаем здесь, но вертолет почему-то всё еще не прилетел. Мы попытались связаться с той компанией, но нам никто не ответил. Странно.</i>
			<br>
			<br><b>25/09/2554</b>
			<br><i>Анна и Давид рассказали, что севернее нашей деревушки была какая-то база, окруженная забором. Когда они подошли близко, то к ним подбежал человек в красно-черной куртке и приказал немедленно уходить отсюда. Мда. Я не думала, что недалеко от нас будут офисные клерки, занимающиеся своими дебильными исследованиями.</i>
			<br>
			<br><b>29/09/2554</b>
			<br><i>Кто-то шарился у нас в лагере этой ночью. Еды и воды скоро не будет, мне становится страшно. На связь никто с нами не выходит. Ещё и эта снежная буря - из-за неё нам очень холодно.</i>
			<br>
			<br><b>01/10/2554</b>
			<br><i>Аллен и Джейкоб ещё утром пошли искать помощь, но их до сих пор нет. Я начинаю волноваться. Воды осталось совсем мало.</i>
			<br>
			<br><b>03/10/2554</b>
			<br><i>С тех пор мы до сих пор не видели Аллена и Джейкоба. Анна, Давид и Андрю куда-то пропали. Мне очень страшно. Вода уже кончилась, приходится есть снег.</i>
			<br>
			<br><b>0UI/I0/255U</b>
			<br><i>МНе ОчЕНb ПлОХО П0моrиТе</i>"}

/obj/item/paper/crumpled/awaymissions/chilly/howtoopenfukkendoor
	name = "Crumpled Note"
	info ={"<i>Левее располагается пульт управления, который открывает ворота. Шифр для тех, кто поймет: РРРЭХБ ВВСА ИННП СХББ ЭСЛМ ЖВВРК 150УТ ПВСЖ.</i>"}


/* cocksucking motherfucker */
/obj/item/clothing/shoes/combat/coldres2
	name = "insulated combat boots"
	desc = "High speed, low drag combat boots, now with an added layer of insulation."
	cold_protection = FEET|LEGS
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	heat_protection = FEET|LEGS
	max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT

/obj/item/clothing/suit/armor/tac_hazmat/grey/coldres
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT

/obj/item/clothing/head/helmet/riot/coldres
	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT





////////////////////////////////////////////////
//
// some zombieapoc weird stuff
//
////////////////////////////////////////////////

/* TURFS */

//walls

/turf/closed/wall/cataclysmdda
	name = "стена"
	desc = "Простая стена."
	icon = 'white/rebolution228/icons/cataclysmdda/wall01.dmi'
	icon_state = "wall-0"
	base_icon_state = "wall"
	slicing_duration = 150
	explosion_block = 1
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_WALLS, SMOOTH_GROUP_WINDOW_FULLTILE)
	canSmoothWith = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_WINDOW_FULLTILE)
	baseturfs = /turf/open/indestructible/cataclysmdda/sand

/turf/closed/wall/cataclysmdda/blue
	color = LIGHT_COLOR_DARK_BLUE

/turf/closed/wall/cataclysmdda/wooden
	name = "деревянная стена"
	icon = 'white/rebolution228/icons/cataclysmdda/wall02.dmi'
	icon_state = "walld-0"
	base_icon_state = "walld"
	sheet_type = /obj/item/stack/sheet/mineral/wood
	hardness = 70
	explosion_block = 0
	custom_materials = list(/datum/material/wood = 4000)

/turf/closed/wall/cataclysmdda/redbrick
	name = "кирпичная стена"
	desc = "Типичная стена из красных кирпичей. Поразительно! Вы только посмотрите на то, как укладывали кирпичи, это явно были не простые иммигранты из Азербайджана..."
	icon = 'white/rebolution228/icons/cataclysmdda/wall03.dmi'
	icon_state = "wallb-0"
	base_icon_state = "wallb"
	sheet_type = null
	hardness = 100
	explosion_block = 1
	custom_materials = null

//floors

/turf/open/floor/wood/cataclysmdda/parquet
	name = "паркетный пол"
	desc = "Деревянный пол, уложенный в стиле 'ёлочки'. Подозрительно как-то напоминает о домашнем уюте."
	icon = 'white/rebolution228/icons/cataclysmdda/cata_floors.dmi'
	icon_state = "wooden1"
	baseturfs = /turf/open/indestructible/cataclysmdda/sand

/turf/open/floor/wood/cataclysmdda
	name = "деревянный пол"
	desc = "Простой непримечательный деревянный пол. У вас возникает ощущение, что когда-нибудь этот пол провалится над вами."
	icon = 'white/rebolution228/icons/cataclysmdda/cata_floors.dmi'
	icon_state = "wooden2"
	baseturfs = /turf/open/indestructible/cataclysmdda/sand

/turf/open/floor/plasteel/tile
	name = "плитка"
	icon = 'white/rebolution228/icons/cataclysmdda/cata_floors.dmi'
	icon_state = "tile1"
	base_icon_state = "tile1"
	initial_gas_mix = "o2=22;n2=82;TEMP=293.15"
	floor_tile = /obj/item/stack/tile/plasteel
	flags_1 = NONE
	baseturfs = /turf/open/indestructible/cataclysmdda/sand
	slowdown = 0

/turf/open/floor/plating/baseturfsand // костыль и мне похуй
	baseturfs = /turf/open/indestructible/cataclysmdda/sand

/turf/open/floor/plasteel/tile/white
	icon_state = "tile2"
	base_icon_state = "tile2"

/turf/open/floor/plasteel/tile/monofloor/cataclysmdda
	name = "пол"
	icon_state = "block1"
	base_icon_state = "block1"
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_SAND

/turf/open/floor/plasteel/tile/monofloor/cataclysmdda/alt
	icon_state = "block2"
	base_icon_state = "block2"

/turf/open/floor/plasteel/tile/monofloor/cataclysmdda/alt2
	name = "бетонный пол"
	icon_state = "concrete"
	base_icon_state = "concrete"

/turf/open/floor/plasteel/tile/monofloor/cataclysmdda/alt3
	icon_state = "block3"
	base_icon_state = "block3"

/turf/open/floor/plasteel/tile/monofloor/cataclysmdda/blue
	icon_state = "blue"
	base_icon_state = "blue"

/turf/open/floor/plasteel/tile/monofloor/cataclysmdda/crowbar_act(mob/living/user/, obj/item/I)
	return FALSE

/turf/open/floor/plating/beach/sand/cataclysmdda
	icon = 'white/rebolution228/icons/cataclysmdda/cata_floors.dmi'
	icon_state = "sand"
	base_icon_state = "sand"

/turf/open/indestructible/cataclysmdda/sand
	name = "песок"
	icon = 'white/rebolution228/icons/cataclysmdda/cata_floors.dmi'
	icon_state = "sand"
	base_icon_state = "sand"
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_SAND

/turf/open/floor/grass/cataclysmdda
	name = "трава"
	desc = "В ней классно валяться."
	icon = 'white/rebolution228/icons/cataclysmdda/cata_floors.dmi'
	icon_state = "grass0"
	base_icon_state = "grass0"
	baseturfs = /turf/open/indestructible/cataclysmdda/sand
	slowdown = 2
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_GRASS
	clawfootstep = FOOTSTEP_GRASS
	heavyfootstep = FOOTSTEP_GRASS

/turf/open/floor/grass/cataclysmdda/Initialize()
	. = ..()
	icon_state = "grass[rand(0, 6)]"
	if (prob(70))
		var/obj/structure/flora/ausbushes/rospilovo/F = pick(subtypesof(/obj/structure/flora/ausbushes/rospilovo))
		new F(get_turf(src))
		if (prob(70))
			var/obj/structure/flora/ausbushes/rospilovo/D = pick(subtypesof(/obj/structure/flora/ausbushes/rospilovo))
			new D(get_turf(src))

/turf/open/floor/grass/cataclysmdda/dirt
	name = "грязь"
	desc = null
	icon = 'white/rebolution228/icons/cataclysmdda/cata_floors.dmi'
	icon_state = "dirt1"
	base_icon_state = "dirt1"
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_SAND
	slowdown = 0.5
	baseturfs = /turf/open/indestructible/cataclysmdda/sand

/turf/open/floor/grass/cataclysmdda/dirt/proc/changeicon()
	icon_state = "dirt[rand(1,4)]"

/turf/open/floor/grass/cataclysmdda/dirt/Initialize()
	. = ..()
	if(nospawn)
		return
	changeicon()

/turf/open/floor/grass/cataclysmdda/dirt/alt
	icon_state = "dirtalt"
	base_icon_state = "dirt1"

/turf/open/floor/asphalt
	name = "асфальт"
	desc = "Асфальтное покрытие, использумое в основном для покрытия дорог. По сути, особая смесь битумов и минеральных веществ."
	icon = 'white/rebolution228/icons/cataclysmdda/cata_floors.dmi'
	icon_state = "asphalt1"
	base_icon_state = "asphalt"
	initial_gas_mix = "o2=22;n2=82;TEMP=293.15"
	baseturfs = /turf/open/floor/plating/beach/sand
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_SAND
	slowdown = 0
	baseturfs = /turf/open/indestructible/cataclysmdda/sand

/turf/open/floor/asphalt/Initialize()
	. = ..()
	if(prob(2))
		icon_state = "asphalt[rand(2,7)]"
	else
		icon_state = "asphalt1"

/turf/open/water/cataclysmdda
	icon = 'white/rebolution228/icons/cataclysmdda/cata_floors.dmi'
	icon_state = "water"
	initial_gas_mix = "o2=22;n2=82;TEMP=293.15"
	baseturfs = /turf/open/water/cataclysmdda // yeah
	planetary_atmos = FALSE
	slowdown = 3

/turf/open/water/cataclysmdda/Entered(atom/movable/AM)
	. = ..()
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		H.wash()
		H.wash_poo()
		if(H.fire_stacks)
			H.fire_stacks = 0
			H.extinguish_mob()

/turf/open/floor/carpet/tentfloor
	name = "пол палатки"
	desc = "Мягкий пол."
	icon = 'white/rebolution228/icons/cataclysmdda/cata_floors.dmi'
	icon_state = "tent_floor"
	base_icon_state = null
	floor_tile = null
	baseturfs = /turf/open/floor/plating/beach/sand

/turf/open/floor/carpet/tentfloor/crowbar_act(mob/living/user/, obj/item/I)
	return FALSE

/* Objects */

//Flora
/obj/structure/flora/cataclysmdda/decoration
	name = "кустик"
	desc = null
	icon = 'white/rebolution228/icons/cataclysmdda/cata_objects.dmi'
	icon_state = "plant"

/obj/structure/flora/cataclysmdda/decoration/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(I.sharpness == SHARP_EDGED)
		new /obj/item/stack/sheet/cloth(get_turf(src))
		user.visible_message(span_notice("<b>[user]</b> нарезает <b>[src]</b> на нитки и быстро сплетает из него куски ткани при помощи <b>[I]</b>.") , \
			span_notice("Нарезаю <b>[src]</b> на нитки и быстро сплетаю из него куски ткани при помощи <b>[I]</b>.") , \
			span_hear("Слышу как что-то режет ткань."))
		qdel(src)

/obj/structure/flora/cataclysmdda/decoration/nature
	icon_state = "plant"

/obj/structure/flora/cataclysmdda/decoration/nature/Initialize()
	. = ..()
	icon_state = "[icon_state][rand(1,8)]"

/obj/structure/flora/cataclysmdda/decoration/houseplant
	icon_state = "houseplant1"

/obj/structure/flora/cataclysmdda/decoration/houseplant/alt
	icon_state = "houseplant2"

/obj/structure/flora/cataclysmdda/decoration/houseplant/alt2
	icon_state = "houseplant3"

/obj/structure/flora/cataclysmdda/decoration/houseplant/alt3
	icon_state = "houseplant4"

/obj/structure/flora/cataclysmdda/decoration/houseplant/alt4
	icon_state = "houseplant5"

/obj/structure/flora/cataclysmdda/decoration/reed
	name = "камыш"
	icon_state = "kamish"

/obj/structure/flora/cataclysmdda/decoration/jug
	name = "кувшинка"
	icon_state = "koovshin"

/obj/structure/flora/cataclysmdda/decoration/nature/wheat
	name = "пшеница"
	icon_state = "wheat1"
	icon = 'white/rebolution228/icons/cataclysmdda/cata_objects.dmi'
	opacity = 1
	layer = ABOVE_MOB_LAYER
	mouse_opacity = 0

/obj/structure/flora/cataclysmdda/decoration/nature/wheat/Initialize()
	. = ..()
	icon_state = "wheat[rand(1,4)]"


//Trees

/obj/structure/flora/tree/cataclysmdda
	name = "КОДЕР"
	desc = "МУДАК"
	icon = 'white/rebolution228/icons/cataclysmdda/cata_trees.dmi'
	pixel_x = -16
	density = TRUE
	icon_state = "els1"
	base_icon_state = "els"
	// living variations
	var/lv = 1
	// dead variations
	var/dv = 1
	// productive variations
	var/pv = 0

/obj/structure/flora/tree/cataclysmdda/Initialize()
	if(dv && prob(5))
		icon_state = "[base_icon_state]d[rand(1, dv)]"
	else if (pv && prob(1))
		icon_state = "[base_icon_state]p[rand(1, pv)]"
	else
		icon_state = "[base_icon_state][rand(1, lv)]"
	. = ..()

/obj/structure/flora/tree/cataclysmdda/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(!. && istype(mover, /obj/projectile))
		return prob(30)

/obj/structure/flora/tree/cataclysmdda/iva
	name = "ива"
	desc = "Род древесных растений семейства Ивовые (Salicaceae). В русском языке по отношению к видам ивы используется также много других названий — ветла́, раки́та, лоза́, лози́на, ве́рба́, тальник."
	icon_state = "iva1"
	base_icon_state = "iva"
	lv = 8
	dv = 0

/obj/structure/flora/tree/cataclysmdda/cash
	name = "каштан"
	desc = "Небольшой род деревьев семейства Буковые (Fagaceae). Каштан — дерево тёплого умеренного климата. Произрастает по склонам гор, как правило, на затенённых склонах с бурыми средневлажными почвами, залегающими на безызвестковых горных породах; сухих и заболоченных почв не переносит."
	icon_state = "cash1"
	base_icon_state = "cash"
	lv = 19
	dv = 2
	pv = 6

/obj/structure/flora/tree/cataclysmdda/yabl
	name = "яблоня"
	desc = "Род листопадных деревьев и кустарников семейства Розовые (Rosaceae) с шаровидными сладкими или кисло-сладкими плодами. Происходит из зон умеренного климата Северного полушария."
	icon_state = "yabl1"
	base_icon_state = "yabl"
	lv = 25
	dv = 2
	pv = 8

/obj/structure/flora/tree/cataclysmdda/topol
	name = "тополь"
	desc = "Род двудомных (редко однодомных) листопадных быстрорастущих деревьев семейства Ивовые (Salicaceae). Лес с преобладанием тополей называют тополёвником."
	icon_state = "topol1"
	base_icon_state = "topol"
	lv = 21
	dv = 4
	pv = 3

/obj/structure/flora/tree/cataclysmdda/el
	name = "ель"
	desc = "Род хвойных вечнозелёных деревьев семейства Сосновые (Pinaceae). Вечнозелёные деревья. Корневая система первые 10—15 лет стержневая, затем поверхностная (главный корень отмирает). Дерево слабо ветроустойчиво, часто ветровально."
	icon_state = "el1"
	base_icon_state = "el"
	lv = 10
	dv = 1

/obj/structure/flora/tree/cataclysmdda/el/small
	name = "маленькая ель"
	icon_state = "els1"
	base_icon_state = "els"

/obj/structure/flora/tree/cataclysmdda/oreh
	name = "орех"
	desc = "Род растений семейства Ореховые (Juglandaceae), включающий в себя более 20 видов, произрастающих в теплоумеренных районах Евразии, Северной Америки и в горах Южной Америки."
	icon_state = "oreh1"
	base_icon_state = "oreh"
	lv = 8
	dv = 2
	pv = 3

/obj/structure/flora/tree/cataclysmdda/kedr
	name = "кедр"
	desc = "Олиготипный род деревьев семейства Сосновые (Pinaceae). Представители рода однодомные, вечнозелёные деревья высотой до 40—50 метров, с раскидистой кроной. Кора тёмно-серая, на молодых стволах гладкая, на старых растрескивающаяся, чешуйчатая. Побеги укороченные и удлинённые, последние несут спирально расположенную хвою."
	icon_state = "kedr1"
	base_icon_state = "kedr"
	lv = 4
	dv = 3

/obj/structure/flora/tree/cataclysmdda/sosna
	name = "сосна"
	desc = "Типовой род хвойных деревьев, кустарников или стлаников семейства Сосновые (Pinaceae). Одна из двух версий производит латинское название дерева от кельтского слова pin, что означает скала, гора, то есть растущее на скалах, другая — от латинских слов pix, picis, что означает смола, то есть смолистое дерево."
	icon_state = "sosna1"
	base_icon_state = "sosna"
	lv = 3
	dv = 3

/obj/structure/flora/tree/cataclysmdda/dub
	name = "дуб"
	desc = "Род деревьев и кустарников семейства Буковые (Fagaceae). Род объединяет около 600 видов. Естественным ареалом дуба являются регионы Северного полушария с умеренным климатом. Южной границей распространения являются тропические высокогорья; несколько видов встречаются и южнее экватора."
	icon_state = "dub1"
	base_icon_state = "dub"
	lv = 9
	dv = 11 // suka

/obj/structure/flora/tree/cataclysmdda/ht
	name = "дерево"
	desc = "Данное дерево ничем не примечательно."
	icon_state = "ht1"
	base_icon_state = "ht"
	lv = 7
	dv = 7

/obj/structure/flora/tree/cataclysmdda/mt
	name = "большое дерево"
	desc = "Данное дерево ничем не примечательно. Это выглядит больше."
	icon_state = "mt1"
	base_icon_state = "mt"
	lv = 3
	dv = 3

//Structure
/obj/structure/cataclysmdda
	name = "structure"
	icon = 'white/rebolution228/icons/cataclysmdda/cata_objects.dmi'
	anchored = 1
	can_be_unanchored = FALSE
	opacity = 0
	density = 1
	var/sheetType = /obj/item/stack/sheet/iron
	var/sheetAmount = 1

/obj/structure/cataclysmdda/deconstruct(disassembled = TRUE)
	var/turf/T = get_turf(src)
	if(disassembled)
		new sheetType(T, sheetAmount)
	else
		new sheetType(T, max(sheetAmount - 2, 1))
	qdel(src)

/obj/structure/barricade/wooden/dark
	name = "деревянная баррикада"
	desc = "Вход заборонен."
	icon = 'white/rebolution228/icons/cataclysmdda/cata_objects.dmi'
	icon_state = "barricade"

/obj/structure/cataclysmdda/lamp
	name = "напольный светильник"
	desc = "Прикольно светится."
	icon = 'white/rebolution228/icons/cataclysmdda/cata_objects.dmi'
	icon_state = "lomp"
	density = 1
	opacity = 0
	max_integrity = 70
	sheetType = /obj/item/stack/rods
	sheetAmount = 3

/obj/structure/curtain/cataclysmdda
	name = "занавеска"
	icon = 'white/rebolution228/icons/cataclysmdda/cata_objects.dmi'
	icon_state = "shtora-open"
	icon_type = "shtora"
	color = null
	alpha = 240

/obj/structure/curtain/cataclysmdda/window
	name = "штора"
	icon = 'white/rebolution228/icons/cataclysmdda/cata_objects.dmi'
	icon_state = "curtain-open"
	icon_type = "curtain"
	color = null
	alpha = 255
	opaque_closed = TRUE
	flags_1 = ON_BORDER_1
	interaction_flags_atom = NONE
	max_integrity = 120
	//вставь в окно и выстави дир внутрь здания.........

/obj/structure/curtain/cataclysmdda/window/Initialize()
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_EXIT = .proc/on_exit,
	)
	AddElement(/datum/element/connect_loc, loc_connections)
	AddElement(/datum/element/border_reach_check, TRUE)

/obj/structure/curtain/cataclysmdda/window/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(!(border_dir == dir))
		return TRUE

/obj/structure/curtain/cataclysmdda/window/proc/on_exit(datum/source, atom/movable/leaving, direction)
	SIGNAL_HANDLER
	if(leaving == src)
		return
	if(direction == dir && density)
		leaving.Bump(src)
		return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/curtain/cataclysmdda/alt
	icon_state = "shtora1-open"
	icon_type = "shtora1"

/obj/structure/curtain/cataclysmdda/alt/update_icon()
	if(!open)
		icon_state = "[icon_type]-closed"
		layer = WALL_OBJ_LAYER
		density = FALSE
		open = FALSE
		if(opaque_closed)
			set_opacity(TRUE)
	else
		icon_state = "[icon_type]-open"
		layer = SIGN_LAYER
		density = FALSE
		open = TRUE
		set_opacity(FALSE)

/obj/structure/cataclysmdda/bath
	name = "ванна"
	desc = "Вода не включена в стоимость."
	icon_state = "bath"
	anchored = 1
	density = 0
	max_integrity = 150
	obj_integrity = 150
	sheetType = /obj/item/stack/sheet/iron
	sheetAmount = 7

/obj/structure/cataclysmdda/bath/another
	icon_state = "bath2"

/obj/structure/sink/kitchen/cataclysmdda
	icon = 'white/rebolution228/icons/cataclysmdda/cata_objects.dmi'
	icon_state = "thasink"
	density = 1
	opacity = 0
	max_integrity = 150
	obj_integrity = 150

/obj/structure/toilet/cataclysmdda
	icon = 'white/rebolution228/icons/cataclysmdda/cata_objects.dmi'
	icon_state = "thatoilet"
	anchored = 1
	max_integrity = 100
	obj_integrity = 100

/obj/structure/cataclysmdda/arcade
	name = "Arcade Machine"
	desc = "Не работает."
	icon_state = "thaarcade"
	density = 1
	anchored = 1
	opacity = 0
	max_integrity = 200
	obj_integrity = 200

/obj/structure/cataclysmdda/bassboost
	name = "колонка"
	desc = "Долбит нормально."
	icon_state = "bassiebut"
	anchored = 1
	max_integrity = 100
	obj_integrity = 100
	sheetType = /obj/item/stack/sheet/iron
	sheetAmount = 4

/obj/structure/trash_pile/hay
	name = "стог сена"
	icon_state = "hay"
	max_integrity = 25
	obj_integrity = 25

/obj/structure/cataclysmdda/tablichka
	name = "ВНИМАНИЕ: МИННОЕ ПОЛЕ"
	desc = null
	icon_state = "minefield"
	max_integrity = 25
	obj_integrity = 25
	sheetType = /obj/item/stack/sheet/mineral/wood
	sheetAmount = 1

/obj/structure/cataclysmdda/antenna
	name = "спутниковая антенна"
	desc = "Используется для приёма различных радиосигналов между станциями через спутники."
	icon_state = "antenn"
	max_integrity = 100
	obj_integrity = 100

/obj/structure/cataclysmdda/oven
	name = "кухонная плита"
	desc = "К сожалению, газа нет."
	icon_state = "oven"
	max_integrity = 200
	obj_integrity = 200
	opacity = 0
	density = 1
	sheetType = /obj/item/stack/sheet/iron
	sheetAmount = 7

/obj/structure/cataclysmdda/oven/Initialize()
	. = ..()
	AddElement(/datum/element/climbable)

/obj/structure/cataclysmdda/penek
	name = "пенек"
	desc = "При осмотре этого пенька вы потеряли где-то свои 1000 рублей."
	icon_state = "penek"
	max_integrity = 25
	obj_integrity = 25
	sheetType = /obj/item/grown/log/tree
	sheetAmount = 4
/*
/obj/structure/cataclysmdda/washingmachine
	name = "стиральная машинка"
	desc = "Производитель этих стиральных машин дал обещание, что они будут работать. Когда-нибудь."
	icon_state = "washingmachine"
	max_integrity = 200
	obj_integrity = 200
	sheetType = /obj/item/stack/sheet/iron
	sheetAmount = 2
*/
/obj/structure/bed/cataclysmdda
	icon = 'white/rebolution228/icons/cataclysmdda/cata_objects.dmi'
	icon_state = "bed"

/obj/structure/bed/cataclysmdda/matress
	icon_state = "matress"

/obj/structure/closet/crate/box
	name = "коробка"
	icon = 'white/rebolution228/icons/cataclysmdda/cata_objects.dmi'
	icon_state = "box01"
	open_sound = 'sound/machines/cardboard_box.ogg'
	close_sound = 'sound/machines/cardboard_box.ogg'
	open_sound_volume = 35
	close_sound_volume = 50

/obj/structure/closet/crate/shkaf
	name = "шкаф"
	icon = 'white/rebolution228/icons/cataclysmdda/cata_objects.dmi'
	icon_state = "shkaf"
	open_sound_volume = 35
	close_sound_volume = 50
	obj_integrity = 200
	max_integrity = 200
	anchored = 1
	can_be_unanchored = FALSE

/obj/structure/grille/cataclysmdda
	name = "решетка"
	desc = "Крепкая решетка."
	icon = 'white/rebolution228/icons/cataclysmdda/cata_objects.dmi'
	icon_state = "grille"
	density = 1
	anchored = 1
	max_integrity = 700
	obj_integrity = 700
	flags_1 = CONDUCT_1
	layer = CLOSED_DOOR_LAYER
	smoothing_flags = NONE
/*
/obj/structure/cataclysmdda/bookcase
	name = "книжная полка"
	icon = 'white/rebolution228/icons/cataclysmdda/cata_objects.dmi'
	icon_state = "bookshelf"
	max_integrity = 80
	obj_integrity = 80
	sheetType = /obj/item/stack/sheet/mineral/wood
	sheetAmount = 3
*/
/obj/structure/cataclysmdda/veshalka
	name = "вешалка"
	desc = null
	icon_state = "veshalka"
	max_integrity = 25
	obj_integrity = 25
	sheetType = /obj/item/stack/sheet/mineral/wood
	sheetAmount = 3

/obj/structure/mineral_door/wood/cataclysmdda
	name = "деревянная дверь"
	icon = 'white/rebolution228/icons/cataclysmdda/cata_objects.dmi'
	icon_state = "door"
	openSound = 'sound/effects/doorcreaky.ogg'
	closeSound = 'sound/effects/doorcreaky.ogg'
	sheetType = /obj/item/stack/sheet/mineral/wood
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_WALLS, SMOOTH_GROUP_WINDOW_FULLTILE)
	canSmoothWith = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_WINDOW_FULLTILE)

/obj/structure/cataclysmdda/kitchencloset
	name = "кухонный шкаф"
	desc = null
	icon_state = "kitchencloset"
	max_integrity = 50
	obj_integrity = 50
	opacity = 0
	density = 1
	sheetType = /obj/item/stack/sheet/mineral/wood
	sheetAmount = 7

/obj/structure/cataclysmdda/kitchencloset/Initialize()
	. = ..()
	AddElement(/datum/element/climbable)

/obj/structure/rack/cataclysmdda
	name = "деревянный стеллаж"
	icon = 'white/rebolution228/icons/cataclysmdda/cata_objects.dmi'
	icon_state = "shelf"
	obj_integrity = 100
	max_integrity = 100
	pass_flags_self = null

/obj/structure/rack/cataclysmdda/entertaiment
	name = "entertaiment center"
	icon = 'white/rebolution228/icons/cataclysmdda/cata_objects.dmi'
	icon_state = "7,33"
	obj_integrity = 100
	max_integrity = 100

/obj/structure/rack/cataclysmdda/deconstruct(disassembled = TRUE)
	if(!(flags_1&NODECONSTRUCT_1))
		density = FALSE
		var/obj/item/stack/sheet/mineral/wood/dropwood = new(loc)
		transfer_fingerprints_to(dropwood)
	qdel(src)

/obj/structure/rack/cataclysmdda/metal
	name = "металлический стеллаж"
	icon = 'white/rebolution228/icons/cataclysmdda/cata_objects.dmi'
	icon_state = "shelf2"
	max_integrity = 150
	max_integrity = 150

/obj/structure/rack/cataclysmdda/metal/alt
	icon_state = "shelf3"

/obj/structure/rack/cataclysmdda/metal/deconstruct(disassembled = TRUE)
	if(!(flags_1&NODECONSTRUCT_1))
		density = FALSE
		var/obj/item/stack/sheet/iron/dropmetal = new(loc)
		transfer_fingerprints_to(dropmetal)
	qdel(src)

/obj/structure/barricade/wooden/fence
	name = "деревянный забор"
	desc = "Для изоляции от лишних глаз."
	icon = 'white/rebolution228/icons/cataclysmdda/cata_objects.dmi'
	icon_state = "fence"
	opacity = 1

/obj/structure/fence/door/cataclysmdda/wooden
	icon = 'white/rebolution228/icons/cataclysmdda/cata_objects.dmi'
	icon_state = "door_closed"

/obj/structure/filingcabinet/cataclysmdda
	icon = 'white/rebolution228/icons/cataclysmdda/cata_objects.dmi'
	icon_state = "8,33"

/obj/structure/chair/stool/bar/cataclysmdda
	icon = 'white/rebolution228/icons/cataclysmdda/cata_objects.dmi'
	icon_state = "barstool"
	item_chair = /obj/item/chair/stool/bar/cataclysmdda

/obj/item/chair/stool/bar/cataclysmdda
	icon = 'white/rebolution228/icons/cataclysmdda/cata_objects.dmi'
	icon_state = "barstool_item"
	lefthand_file = 'icons/mob/inhands/misc/chairs_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/chairs_righthand.dmi'
	inhand_icon_state = "stool_bar"
	origin_type = /obj/structure/chair/stool/bar/cataclysmdda

/obj/structure/dresser/cataclysmdda
	icon = 'white/rebolution228/icons/cataclysmdda/cata_objects.dmi'
	icon_state = "dresser"

/obj/structure/table/wood/cataclysmdda
	name = "стол"
	icon = 'white/rebolution228/icons/cataclysmdda/cata_table01.dmi'
	base_icon_state = "reinforced_table"
	icon_state = "reinforced_table-0"

/obj/structure/table/wood/cataclysmdda/desk
	name = "стол"
	icon = 'white/rebolution228/icons/cataclysmdda/cata_table02.dmi'
	base_icon_state = "reinforced_table"
	icon_state = "reinforced_table-0"

/obj/structure/table/wood/cataclysmdda/sci
	name = "стол"
	desc = "Обычный деревянный, слегка пошарпанный стол."
	icon = 'white/rebolution228/icons/cataclysmdda/cata_table03.dmi'
	base_icon_state = "reinforced_table"
	icon_state = "reinforced_table-0"

/obj/structure/chair/wood/cataclysmdda
	icon = 'white/rebolution228/icons/cataclysmdda/cata_objects.dmi'
	icon_state = "thastool"
	buildstacktype = /obj/item/stack/sheet/mineral/wood
	buildstackamount = 3
	item_chair = /obj/item/chair/wood/cataclysmdda

/obj/item/chair/wood/cataclysmdda
	icon = 'white/rebolution228/icons/cataclysmdda/cata_objects.dmi'
	icon_state = "thastool_item"
	lefthand_file = 'icons/mob/inhands/misc/chairs_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/chairs_righthand.dmi'
	inhand_icon_state = "woodenchair"
	origin_type = /obj/structure/chair/wood/cataclysmdda

/obj/structure/chair/comfy/cataclysmdda
	icon = 'white/rebolution228/icons/cataclysmdda/cata_objects.dmi'
	icon_state = "thachair"
	color = null

/obj/effect/turf_decal/cataclysmdda
	name = "Пидрила"
	icon = 'white/rebolution228/icons/cataclysmdda/cata_decals.dmi'
	icon_state = null
	mouse_opacity = 0

/obj/effect/turf_decal/cataclysmdda/asphaltpaint
	name = "asphalt road paint"
	icon_state = "asphalt_y"

/obj/effect/turf_decal/cataclysmdda/grass
	name = "grass decal"
	icon_state = "grassdecal"

/obj/effect/turf_decal/cataclysmdda/grass/alt
	icon_state = "grassdecal2"


/obj/effect/invisiblewall
	name = "Invisible Wall"
	icon = 'white/rebolution228/map_sprites.dmi'
	icon_state = "blocker"
	anchored = TRUE
	density = 1
	opacity = 0
	invisibility = 101

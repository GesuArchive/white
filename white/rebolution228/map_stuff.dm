
/* AREAS */

//Main
/area/awaymission/chilly
	name = "Surface"
	icon = 'white/rebolution228/map_sprites.dmi'
	icon_state = "coutdoor"
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	requires_power = TRUE
	has_gravity = STANDARD_GRAVITY
	area_flags = VALID_TERRITORY | UNIQUE_AREA | NOTELEPORT
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	poweralm = FALSE
	ambientsounds = list('sound/ambience/ambimine.ogg')


//Facilities
/area/awaymission/chilly/facility
	name = "Base I"
	icon_state = "base"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	requires_power = TRUE
	always_unpowered = TRUE
	ambientsounds = list('sound/ambience/ambireebe1.ogg')

/area/awaymission/chilly/facility/croom
	name = "Base I Underground Control Room"
	icon_state = "base_eng"
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	requires_power = FALSE
	always_unpowered = FALSE

/area/awaymission/chilly/facility2
	name = "Base II"
	icon_state = "base2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	requires_power = TRUE
	ambientsounds = list('sound/ambience/ambireebe3.ogg')
	always_unpowered = TRUE

/area/awaymission/chilly/facility3
	name = "Base III"
	icon_state = "base3"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	requires_power = TRUE
	always_unpowered = TRUE
	ambientsounds = list('sound/ambience/ambireebe2.ogg')

/area/awaymission/chilly/facility4
	name = "Base IV House"
	icon_state = "base4"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	requires_power = TRUE
	always_unpowered = TRUE
	ambientsounds = list('sound/ambience/ambiruin4.ogg')

/area/awaymission/chilly/facility5
	name = "Base V"
	icon_state = "base5"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	requires_power = TRUE
	always_unpowered = TRUE
	ambientsounds = list('sound/ambience/ambitech.ogg')


//Underground something
/area/awaymission/chilly/cave
	name = "Underground Train Tracks"
	icon_state = "caverns"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	requires_power = TRUE
	always_unpowered = TRUE
	ambientsounds = list('sound/ambience/ambireebe3.ogg')

/area/awaymission/chilly/syndietrain
	name = "Syndicate Cargo Train"
	icon_state = "syndie_train"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	requires_power = FALSE
	ambientsounds = list('sound/ambience/ambireebe3.ogg')
	always_unpowered = FALSE

/area/awaymission/chilly/ntcargotrain
	name = "NanoTrasen Cargo Train Wreckage"
	icon_state = "nt_train"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	requires_power = TRUE
	ambientsounds = list('sound/ambience/ambireebe3.ogg')
	always_unpowered = TRUE



//Misc
/area/awaymission/chilly/mountain
	name = "Mountain"
	icon_state = "mountain"
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	always_unpowered = TRUE

/area/awaymission/chilly/gatewaystart
	name = "Gateway Entrance"
	icon_state = "gateways"
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	requires_power = FALSE
	always_unpowered = FALSE
	ambientsounds = list('sound/ambience/ambitech.ogg', 'sound/ambience/ambitech2.ogg', 'sound/ambience/ambitech3.ogg')

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
    to_chat(user, "<span class='warning'>It has no power!</span>")

/obj/machinery/doorpanel/broken/attack_hand(mob/living/carbon/human/user)
    to_chat(user, "<span class='warning'>It's broken.</span>")

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

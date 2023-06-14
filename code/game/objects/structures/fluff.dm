//Fluff structures serve no purpose and exist only for enriching the environment. They can be destroyed with a wrench.

/obj/structure/fluff
	name = "структура пуха"
	desc = "Пушистее овцы. Этого не должно быть."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "minibar"
	anchored = TRUE
	density = FALSE
	opacity = FALSE
	var/deconstructible = TRUE

/obj/structure/fluff/attackby(obj/item/I, mob/living/user, params)
	if(I.tool_behaviour == TOOL_WRENCH && deconstructible)
		user.visible_message(span_notice("[user] начинает разбирать [src]...") , span_notice("Начинаю разбирать [src]..."))
		I.play_tool_sound(src)
		if(I.use_tool(src, user, 50))
			user.visible_message(span_notice("[user] разобрал [src]!") , span_notice("Разломал [src] на куски металла."))
			playsound(user, 'sound/items/deconstruct.ogg', 50, TRUE)
			new/obj/item/stack/sheet/iron(drop_location())
			qdel(src)
		return
	..()

/obj/structure/fluff/empty_terrarium //Empty terrariums are created when a preserved terrarium in a lavaland seed vault is activated.
	name = "пустой террариум"
	desc = "Древняя машина, которая, кажется, использовалась для хранения растительных материалов. Люк открыт."
	icon = 'icons/obj/lavaland/spawners.dmi'
	icon_state = "terrarium_open"
	density = TRUE

/obj/structure/fluff/empty_sleeper //Empty sleepers are created by a good few ghost roles in lavaland.
	name = "пустой слипер"
	desc = "Открытый слипер. Похоже, он был готов принять пациента, если бы не сломался."
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper-open"

/obj/structure/fluff/empty_sleeper/nanotrasen
	name = "сломанная камера гиперсна"
	desc = "Камера гиперсна NanoTrasen - похоже она сломана. \
		Это болты с неполной резьбой, легко демонтируются гаечным ключом."
	icon_state = "sleeper-o"

/obj/structure/fluff/empty_sleeper/syndicate
	icon_state = "sleeper_s-open"

/obj/structure/fluff/empty_cryostasis_sleeper //Empty cryostasis sleepers are created when a malfunctioning cryostasis sleeper in a lavaland shelter is activated
	name = "пустой слипер"
	desc = "К сожалению, этот слипер больше не выполняет своих функций и в лучшем случае может быть использован как кровать."
	icon = 'icons/obj/lavaland/spawners.dmi'
	icon_state = "cryostasis_sleeper_open"

/obj/structure/fluff/broken_flooring
	name = "сломанная черепица"
	desc = "Часть сломанного настила."
	icon = 'icons/obj/brokentiling.dmi'
	icon_state = "corner"

/obj/structure/fluff/drake_statue //Ash drake status spawn on either side of the necropolis gate in lavaland.
	name = "статуя дракона"
	desc = "Возвышающаяся базальтовая скульптура гордого и царственного дракона. Его глаза как шесть сияющих самоцветов."
	icon = 'icons/effects/64x64.dmi'
	icon_state = "drake_statue"
	pixel_x = -16
	density = TRUE
	deconstructible = FALSE
	layer = EDGED_TURF_LAYER
	plane = GAME_PLANE_UPPER

/obj/structure/fluff/drake_statue/falling //A variety of statue in disrepair; parts are broken off and a gemstone is missing
	desc = "Возвышающаяся базальтовая скульптура дракона. На поверхности трещины, а некоторые куски отвалились."
	icon_state = "drake_statue_falling"

/obj/structure/fluff/tendril
	name = "статуя тендрила"
	desc = "Искусная имитация загадочного обелиска лаваленда."
	icon = 'icons/mob/nest.dmi'
	icon_state = "tendril"
	density = TRUE
	deconstructible = FALSE
	layer = EDGED_TURF_LAYER
	plane = GAME_PLANE_UPPER

/obj/structure/fluff/meteor
	name = "метеорит"
	desc = "Этот огромный кусок камня с вкраплениями руды даже можно посчитать красивым, особенно когда он не летит в тебя на огромной скорости."
	icon = 'icons/obj/meteor.dmi'
	icon_state = "pod"
	density = TRUE
	deconstructible = FALSE
	layer = EDGED_TURF_LAYER
	plane = GAME_PLANE_UPPER
	var/meteor_icon_state = "large"
	var/list/meteordrop = list(/obj/item/stack/ore/iron)
	var/mutable_appearance/meteor_overlay

/obj/structure/fluff/meteor/Initialize(mapload)
	. = ..()
	meteor_overlay = mutable_appearance(icon, meteor_icon_state)
	var/matrix/M = matrix()
	M.Translate(0, 5)
	meteor_overlay.transform = M
	add_overlay(meteor_overlay)

/obj/structure/fluff/meteor/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_MINING)
		var/thing_to_spawn = pick(meteordrop)
		new thing_to_spawn(get_turf(src))
		cut_overlay(meteor_overlay)
		density = FALSE
		name = "подставка метеорита"
	else
		. = ..()

/obj/structure/fluff/meteor/Destroy()
	if(prob(50))
		var/thing_to_spawn = pick(meteordrop)
		new thing_to_spawn(get_turf(src))
	. = ..()

/obj/structure/fluff/meteor/silver
	meteor_icon_state = "silver"
	meteordrop = list(/obj/item/stack/ore/silver)

/obj/structure/fluff/meteor/gold
	meteor_icon_state = "gold"
	meteordrop = list(/obj/item/stack/ore/gold)

/obj/structure/fluff/meteor/titanium
	meteor_icon_state = "titanium"
	meteordrop = list(/obj/item/stack/ore/titanium)

/obj/structure/fluff/meteor/diamond
	meteor_icon_state = "diamond"
	meteordrop = list(/obj/item/stack/ore/diamond)

/obj/structure/fluff/meteor/bsc
	meteor_icon_state = "bsc"
	meteordrop = list(/obj/item/stack/ore/bluespace_crystal)

/obj/structure/fluff/meteor/plasma
	meteor_icon_state = "flaming"
	meteordrop = list(/obj/item/stack/ore/plasma)

/obj/structure/fluff/meteor/uranium
	meteor_icon_state = "glowing"
	meteordrop = list(/obj/item/stack/ore/uranium)

/obj/effect/spawner/random/decoration/meteor
	name = "случайный метеор"
	icon_state = "statue"
	loot = list(
		/obj/structure/fluff/meteor,
		/obj/structure/fluff/meteor/silver,
		/obj/structure/fluff/meteor/gold,
		/obj/structure/fluff/meteor/titanium,
		/obj/structure/fluff/meteor/diamond,
		/obj/structure/fluff/meteor/bsc,
		/obj/structure/fluff/meteor/plasma,
		/obj/structure/fluff/meteor/uranium,
	)

/obj/structure/fluff/bus
	name = "автобус"
	desc = "ИДИ В ШКОЛУ. ПОЧИТАЙ КНИГУ."
	icon = 'icons/obj/bus.dmi'
	density = TRUE
	anchored = TRUE
	deconstructible = FALSE

/obj/structure/fluff/bus/dense
	name = "автобус"
	icon_state = "backwall"

/obj/structure/fluff/bus/passable
	name = "автобус"
	icon_state = "frontwalltop"
	density = FALSE
	layer = ABOVE_ALL_MOB_LAYER //except for the stairs tile, which should be set to OBJ_LAYER aka 3.
	plane = ABOVE_GAME_PLANE


/obj/structure/fluff/bus/passable/seat
	name = "сиденье"
	desc = "Пристегнитесь! ...Что значит тут нет ремней безопасности?!"
	icon_state = "backseat"
	pixel_y = 17
	layer = OBJ_LAYER
	plane = GAME_PLANE


/obj/structure/fluff/bus/passable/seat/driver
	name = "кресло водителя"
	desc = "Космический Иисус мой второй пилот."
	icon_state = "driverseat"

/obj/structure/fluff/bus/passable/seat/driver/attack_hand(mob/user)
	playsound(src, 'sound/items/carhorn.ogg', 50, TRUE)
	. = ..()

/obj/structure/fluff/paper
	name = "плотная подкладка из бумаги"
	desc = "Подкладка из бумаги, разбросанная у подножия стены."
	icon = 'icons/obj/fluff.dmi'
	icon_state = "paper"
	deconstructible = FALSE

/obj/structure/fluff/paper/corner
	icon_state = "papercorner"

/obj/structure/fluff/paper/stack
	name = "плотная стопка бумаг"
	desc = "Стопка разных бумаг, детские каракули накаляканы на каждой странице."
	icon_state = "paperstack"


/obj/structure/fluff/divine
	name = "Чудо"
	icon = 'icons/obj/hand_of_god_structures.dmi'
	anchored = TRUE
	density = TRUE

/obj/structure/fluff/divine/nexus
	name = "Нексус"
	desc = "Он создает связь с божеством в этом мире. Он излучает необычную ауру. Выглядит взрывостойким."
	icon_state = "nexus"

/obj/structure/fluff/divine/conduit
	name = "канал"
	desc = "Позволяет божеству расширить свою зону влияния. Их силы так же сильны рядом с каналом, как и нексус."
	icon_state = "conduit"

/obj/structure/fluff/divine/convertaltar
	name = "алтарь обращения"
	desc = "Алтарь, посвященный божеству."
	icon_state = "convertaltar"
	density = FALSE
	can_buckle = 1

/obj/structure/fluff/divine/powerpylon
	name = "пилон силы"
	desc = "Пилон который увеличивает интенсивность с которой божество может влиять на мир."
	icon_state = "powerpylon"
	can_buckle = 1

/obj/structure/fluff/divine/defensepylon
	name = "защитный пилон"
	desc = "Пилон, благословлен, чтобы выдержать много ударов и стрелять снарядами в неверующих. Бог может переключать его."
	icon_state = "defensepylon"

/obj/structure/fluff/divine/shrine
	name = "святыня"
	desc = "Святыня, посвященная божеству."
	icon_state = "shrine"

/obj/structure/fluff/fokoff_sign
	name = "грубый символ"
	desc = "Грубо нарисованный символ с надписью \"от бись\", написанной чем-то вроде красной краски."
	icon = 'icons/obj/fluff.dmi'
	icon_state = "fokof"

/obj/structure/fluff/sale_sign
	name = "crude sign"
	desc = "A crudely-made sign with the words 'sale :)' written in some sort of red paint."
	icon = 'icons/obj/fluff.dmi'
	icon_state = "salesign"

/obj/structure/fluff/big_chain
	name = "огромная цепь"
	desc = "Возвышающееся звено цепей, ведущих к потолку."
	icon = 'icons/effects/32x96.dmi'
	icon_state = "chain"
	layer = ABOVE_OBJ_LAYER
	resistance_flags = FIRE_PROOF | LAVA_PROOF
	anchored = TRUE
	density = TRUE
	deconstructible = FALSE

/obj/structure/fluff/beach_towel
	name = "пляжное полотенце"
	desc = "Полотенце в пляжном стиле."
	icon = 'icons/obj/fluff.dmi'
	icon_state = "railing"
	density = FALSE
	anchored = TRUE
	deconstructible = FALSE

/obj/structure/fluff/beach_umbrella
	name = "пляжный зонтик"
	desc = "Модный зонтик, предназначен для защиты от солнца."
	icon = 'icons/obj/fluff.dmi'
	icon_state = "brella"
	density = FALSE
	anchored = TRUE
	deconstructible = FALSE

/obj/structure/fluff/beach_umbrella/security
	icon_state = "hos_brella"

/obj/structure/fluff/beach_umbrella/science
	icon_state = "rd_brella"

/obj/structure/fluff/beach_umbrella/engine
	icon_state = "ce_brella"

/obj/structure/fluff/beach_umbrella/cap
	icon_state = "cap_brella"

/obj/structure/fluff/beach_umbrella/syndi
	icon_state = "syndi_brella"

/obj/structure/fluff/clockwork
	name = "Клокворк Пушистик"
	icon = 'icons/obj/clockwork_objects.dmi'
	deconstructible = FALSE

/obj/structure/fluff/clockwork/alloy_shards
	name = "replicant alloy shards"
	desc = "Broken shards of some oddly malleable metal. They occasionally move and seem to glow."
	icon_state = "alloy_shards"

/obj/structure/fluff/clockwork/alloy_shards/small
	icon_state = "shard_small1"

/obj/structure/fluff/clockwork/alloy_shards/medium
	icon_state = "shard_medium1"

/obj/structure/fluff/clockwork/alloy_shards/medium_gearbit
	icon_state = "gear_bit1"

/obj/structure/fluff/clockwork/alloy_shards/large
	icon_state = "shard_large1"

/obj/structure/fluff/clockwork/blind_eye
	name = "blind eye"
	desc = "A heavy brass eye, its red iris fallen dark."
	icon_state = "blind_eye"

/obj/structure/fluff/clockwork/fallen_armor
	name = "fallen armor"
	desc = "Lifeless chunks of armor. They're designed in a strange way and won't fit on you."
	icon_state = "fallen_armor"

/obj/structure/fluff/clockwork/clockgolem_remains
	name = "clockwork golem scrap"
	desc = "A pile of scrap metal. It seems damaged beyond repair."
	icon_state = "clockgolem_dead"

/obj/structure/fluff/hedge
	name = "живая изгородь"
	desc = "Огромная."
	icon = 'icons/obj/smooth_structures/hedge.dmi'
	icon_state = "hedge-0"
	base_icon_state = "hedge"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_HEDGE_FLUFF)
	canSmoothWith = list(SMOOTH_GROUP_HEDGE_FLUFF)
	density = TRUE
	anchored = TRUE
	deconstructible = FALSE
	max_integrity = 80

/obj/structure/fluff/hedge/attacked_by(obj/item/I, mob/living/user)
	if(opacity && HAS_TRAIT(user, TRAIT_BONSAI) && I.get_sharpness())
		to_chat(user,span_notice("Начинаю стричь <b>[src.name]</b>."))
		if(do_after(user, 3 SECONDS,target=src))
			to_chat(user,span_notice("Стригу <b>[src.name]</b>."))
			opacity = FALSE
	else
		return ..()

/obj/structure/fluff/hedge/opaque //useful for mazes and such
	opacity = TRUE

/obj/structure/fluff/tram_rail
	name = "трамвайные рельсы"
	desc = "Отлично подходят для трамваев."
	icon = 'icons/obj/tram_railing.dmi'
	icon_state = "rail"
	layer = MID_TURF_LAYER
	plane = FLOOR_PLANE
	deconstructible = TRUE

/obj/structure/fluff/tram_rail/floor
	icon_state = "rail_floor"

/obj/structure/fluff/tram_rail/end
	icon_state = "railend"

/obj/structure/fluff/tram_rail/anchor
	name = "удерживающие рельсы"
	icon_state = "anchor"

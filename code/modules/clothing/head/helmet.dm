/obj/item/clothing/head/helmet
	name = "шлем"
	desc = "Стандартное снаряжение безопасности. Защищает голову от ударов."
	icon_state = "helmet"
	inhand_icon_state = "helmet"
	armor = list(MELEE = 35, BULLET = 30, LASER = 30,ENERGY = 40, BOMB = 25, BIO = 0, RAD = 0, FIRE = 50, ACID = 50, WOUND = 10)
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_TEMP_PROTECT
	strip_delay = 60
	clothing_flags = SNUG_FIT
	flags_cover = HEADCOVERSEYES
	flags_inv = HIDEHAIR

	dog_fashion = /datum/dog_fashion/head/helmet

	var/can_flashlight = FALSE //if a flashlight can be mounted. if it has a flashlight and this is false, it is permanently attached.
	var/obj/item/flashlight/seclite/attached_light
	var/datum/action/item_action/toggle_helmet_flashlight/alight

/obj/item/clothing/head/helmet/AltClick(mob/user)
	. = ..()
	if(.)
		return

	if(!user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE, !iscyborg(user)))
		return
	rolldown()

/obj/item/clothing/head/helmet/verb/helmet_adjust()
	set name = "Поправить прическу"
	set category = null
	set src in usr
	rolldown()

/obj/item/clothing/head/helmet/proc/rolldown()
	if(ishuman(usr))
		if(flags_inv == HIDEHAIR)
			to_chat(usr, span_notice("Распускаю волосы."))
			flags_inv = null
		else
			to_chat(usr, span_notice("Заправляю волосы под шлем."))
			flags_inv = initial(flags_inv)
		var/mob/living/carbon/human/H = usr
//		H.update_inv_w_uniform()
		H.update_hair()
		H.update_inv_head()

/obj/item/clothing/head/helmet/Initialize(mapload)
	. = ..()
//	AddComponent(/datum/component/armor_plate/plasteel)
	if(attached_light)
		alight = new(src)
/*
/obj/item/clothing/head/helmet/worn_overlays(mutable_appearance/standing, isinhands = FALSE, icon_file)
	. = ..()
	if(!isinhands)
		var/datum/component/armor_plate/plasteel/ap = GetComponent(/datum/component/armor_plate/plasteel)
		if(ap?.amount)
			var/mutable_appearance/armor_overlay = mutable_appearance('icons/mob/clothing/head.dmi', "armor_plasteel_[ap.amount]")
			. += armor_overlay
*/

/obj/item/clothing/head/helmet/Destroy()
	var/obj/item/flashlight/seclite/old_light = set_attached_light(null)
	if(old_light)
		qdel(old_light)
	return ..()


/obj/item/clothing/head/helmet/examine(mob/user)
	. = ..()
	if(attached_light)
		. += "<hr>Имеет [attached_light] [can_flashlight ? "" : "намертво "] прикрученый к нему."
		if(can_flashlight)
			. += "<hr><span class='info'>Похоже, что [attached_light] может быть <b>откручен</b> от [src].</span>"
	else if(can_flashlight)
		. += "<hr>Имеет точку для монтирования <b>фонарика</b>."
	. += "<hr><b>ПКМ или Alt + Клик</b> для изменения отображения прически."


/obj/item/clothing/head/helmet/handle_atom_del(atom/A)
	if(A == attached_light)
		set_attached_light(null)
		update_helmlight()
		update_icon()
		QDEL_NULL(alight)
		qdel(A)
	return ..()


///Called when attached_light value changes.
/obj/item/clothing/head/helmet/proc/set_attached_light(obj/item/flashlight/seclite/new_attached_light)
	if(attached_light == new_attached_light)
		return
	. = attached_light
	attached_light = new_attached_light
	if(attached_light)
		attached_light.set_light_flags(attached_light.light_flags | LIGHT_ATTACHED)
		if(attached_light.loc != src)
			attached_light.forceMove(src)
	else if(.)
		var/obj/item/flashlight/seclite/old_attached_light = .
		old_attached_light.set_light_flags(old_attached_light.light_flags & ~LIGHT_ATTACHED)
		if(old_attached_light.loc == src)
			old_attached_light.forceMove(get_turf(src))


/obj/item/clothing/head/helmet/sec
	can_flashlight = TRUE

/obj/item/clothing/head/helmet/sec/attackby(obj/item/I, mob/user, params)
	if(issignaler(I))
		var/obj/item/assembly/signaler/S = I
		if(attached_light) //Has a flashlight. Player must remove it, else it will be lost forever.
			to_chat(user, span_warning("Установленный фонарик мешает, сначала снять бы его!"))
			return

		if(S.secured)
			qdel(S)
			var/obj/item/bot_assembly/secbot/A = new
			user.put_in_hands(A)
			to_chat(user, span_notice("Добавляю сигналлер к шлему."))
			qdel(src)
			return
	return ..()

/obj/item/clothing/head/helmet/alt
	name = "пуленепробиваемый шлем"
	desc = "Боевой пуленепробиваемый шлем, который в незначительной степени защищает владельца от традиционного стрелкового оружия и взрывчатых веществ."
	icon_state = "helmetalt"
	inhand_icon_state = "helmetalt"
	armor = list(MELEE = 15, BULLET = 60, LASER = 10, ENERGY = 10, BOMB = 40, BIO = 0, RAD = 0, FIRE = 50, ACID = 50, WOUND = 5)
	can_flashlight = TRUE
	dog_fashion = null

/obj/item/clothing/head/helmet/marine
	name = "tactical combat helmet"
	desc = "A tactical black helmet, sealed from outside hazards with a plate of glass and not much else."
	icon_state = "marine_command"
	inhand_icon_state = "helmetalt"
	armor = list(MELEE = 50, BULLET = 50, LASER = 30, ENERGY = 25, BOMB = 50, BIO = 100, FIRE = 40, ACID = 50, WOUND = 20)
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	clothing_flags = STOPSPRESSUREDAMAGE
	resistance_flags = FIRE_PROOF | ACID_PROOF
	can_flashlight = TRUE
	dog_fashion = null

/obj/item/clothing/head/helmet/marine/Initialize(mapload)
	set_attached_light(new /obj/item/flashlight/seclite)
	update_helmlight()
	update_icon()
	. = ..()

/obj/item/clothing/head/helmet/marine/security
	name = "marine heavy helmet"
	icon_state = "marine_security"

/obj/item/clothing/head/helmet/marine/engineer
	name = "marine utility helmet"
	icon_state = "marine_engineer"

/obj/item/clothing/head/helmet/marine/medic
	name = "marine medic helmet"
	icon_state = "marine_medic"

/obj/item/clothing/head/helmet/old
	name = "старый шлем"
	desc = "Стандартный защитный шлем. Предоставляет гораздо меньшую защиту, по сравнению с шлемами нового поколения."
	armor = list(MELEE = 25, BULLET = 20, LASER = 10, ENERGY = 30, BOMB = 25, BIO = 0, RAD = 0, FIRE = 30, ACID = 30, WOUND = 10)


/obj/item/clothing/head/helmet/blueshirt
	name = "синий шлем"
	desc = "Надежный шлем синего цвета, напоминающий вам, что вы все еще должны инженеру пиво."
	icon_state = "blueshift"
	inhand_icon_state = "blueshift"
	custom_premium_price = PAYCHECK_HARD

/obj/item/clothing/head/helmet/riot
	name = "анти-мятежный шлем"
	desc = "Шлем, специально разработанный для защиты от оружия ближнего боя."
	icon_state = "riot"
	inhand_icon_state = "helmet"
	toggle_message = "Опускаю козырёк вниз"
	alt_toggle_message = "Поднимаю козырёк вверх"
	can_toggle = 1
	armor = list(MELEE = 50, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 0, BIO = 0, RAD = 0, FIRE = 80, ACID = 80, WOUND = 15)
	flags_inv = HIDEEARS|HIDEFACE|HIDESNOUT
	strip_delay = 80
	actions_types = list(/datum/action/item_action/toggle)
	visor_flags_inv = HIDEFACE|HIDESNOUT
	toggle_cooldown = 0
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	dog_fashion = null
	can_flashlight = TRUE

/obj/item/clothing/head/helmet/riot/update_icon_state()
	. = ..()
	var/state = "[initial(icon_state)]"
	if(up)
		state += "up"
		if(attached_light)
			if(attached_light.on)
				state += "-flight-on"
			else
				state += "-flight"
	else
		if(attached_light)
			if(attached_light.on)
				state += "-flight-on"
			else
				state += "-flight"
	icon_state = state

/obj/item/clothing/head/helmet/attack_self(mob/user)
	if(can_toggle && !user.incapacitated())
		if(world.time > cooldown + toggle_cooldown)
			cooldown = world.time
			up = !up
			flags_1 ^= visor_flags
			flags_inv ^= visor_flags_inv
			flags_cover ^= visor_flags_cover
			update_icon_state()
			to_chat(user, span_notice("[up ? alt_toggle_message : toggle_message] [src]."))

			user.update_inv_head()
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.head_update(src, forced = 1)

/obj/item/clothing/head/helmet/justice
	name = "шлем правосудия"
	desc = "ВИИИУУУ. ВИИИУУУ. ВИИИУУУ."
	icon_state = "justice"
	toggle_message = "Выключаю свет"
	alt_toggle_message = "Включаю свет"
	actions_types = list(/datum/action/item_action/toggle_helmet_light)
	can_toggle = 1
	toggle_cooldown = 20
	dog_fashion = null
	///Looping sound datum for the siren helmet
	var/datum/looping_sound/siren/weewooloop

/obj/item/clothing/head/helmet/justice/Initialize(mapload)
	. = ..()
	weewooloop = new(src, FALSE, FALSE)

/obj/item/clothing/head/helmet/justice/Destroy()
	QDEL_NULL(weewooloop)
	return ..()

/obj/item/clothing/head/helmet/justice/attack_self(mob/user)
	. = ..()
	if(up)
		weewooloop.start()
	else
		weewooloop.stop()

/obj/item/clothing/head/helmet/justice/escape
	name = "тревожный шлем"
	desc = "ВИИИУУУ. ВИИИУУУ. ОСТАНОВИ ЭТУ ОБЕЗЬЯНУ. ВИИИУУУ."
	icon_state = "justice2"
	toggle_message = "Выключаю свет"
	alt_toggle_message = "Включаю свет"

/obj/item/clothing/head/helmet/swat
	name = "шлем спецназа"
	desc = "Чрезвычайно прочный, компактный шлем в мерзкой красной и черной полосе."
	icon_state = "swatsyndie"
	inhand_icon_state = "swatsyndie"
	armor = list(MELEE = 40, BULLET = 30, LASER = 30,ENERGY = 40, BOMB = 50, BIO = 90, RAD = 20, FIRE = 100, ACID = 100, WOUND = 15)
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	clothing_flags = STOPSPRESSUREDAMAGE
	strip_delay = 80
	resistance_flags = FIRE_PROOF | ACID_PROOF
	dog_fashion = null

/obj/item/clothing/head/helmet/police
	name = "полицейская шляпа"
	desc = "Шляпа офицера полиции. Эта шляпа подчеркивает, что ты - ЗАКОН."
	icon_state = "policehelm"
	dynamic_hair_suffix = ""

/obj/item/clothing/head/helmet/constable
	name = "шлем констебля"
	desc = "Такой британский."
	icon_state = "constable"
	inhand_icon_state = "constable"
	custom_price = PAYCHECK_HARD * 1.5
	worn_y_offset = 4

/obj/item/clothing/head/helmet/swat/nanotrasen
	name = "шлем спецназа"
	desc = "Чрезвычайно прочный, космический шлем с логотипом NanoTrasen, украшенный сверху."
	icon_state = "swat"
	inhand_icon_state = "swat"

/obj/item/clothing/head/helmet/thunderdome
	name = "Thunderdome шлем"
	desc = "<i>'Да начнется битва!'</i>"
	flags_inv = HIDEEARS|HIDEHAIR
	icon_state = "thunderdome"
	inhand_icon_state = "thunderdome"
	armor = list(MELEE = 80, BULLET = 80, LASER = 50, ENERGY = 50, BOMB = 100, BIO = 100, RAD = 100, FIRE = 90, ACID = 90)
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	strip_delay = 80
	dog_fashion = null

/obj/item/clothing/head/helmet/roman
	name = "римский шлем"
	desc = "Древний шлем из бронзы и кожи."
	flags_inv = HIDEEARS|HIDEHAIR
	flags_cover = HEADCOVERSEYES
	armor = list(MELEE = 25, BULLET = 0, LASER = 25, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 100, ACID = 50, WOUND = 5)
	resistance_flags = FIRE_PROOF
	icon_state = "roman"
	inhand_icon_state = "roman"
	strip_delay = 100
	dog_fashion = null

/obj/item/clothing/head/helmet/roman/fake
	desc = "Древний шлем из пластика и кожи."
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/head/helmet/roman/legionnaire
	name = "шлем римского легионера"
	desc = "Древний шлем из бронзы и кожи. На нем красный гребень."
	icon_state = "roman_c"
	inhand_icon_state = "roman_c"

/obj/item/clothing/head/helmet/roman/legionnaire/fake
	desc = "Древний шлем из бронзы и кожи. На нем красный гребень."
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/head/helmet/gladiator
	name = "шлем гладиатора"
	desc = "Славься, Император, идущие на смерть приветствуют тебя!"
	icon_state = "gladiator"
	inhand_icon_state = "gladiator"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR
	flags_cover = HEADCOVERSEYES
	dog_fashion = null

/obj/item/clothing/head/helmet/redtaghelm
	name = "красный шлем лазер-тэга"
	desc = "Они выбрали свою цель."
	icon_state = "redtaghelm"
	flags_cover = HEADCOVERSEYES
	inhand_icon_state = "redtaghelm"
	armor = list(MELEE = 15, BULLET = 10, LASER = 20,ENERGY = 10, BOMB = 20, BIO = 0, RAD = 0, FIRE = 0, ACID = 50)
	// Offer about the same protection as a hardhat.
	dog_fashion = null

/obj/item/clothing/head/helmet/bluetaghelm
	name = "синий шлем лазер-тэга"
	desc = "Им понадобится больше людей."
	icon_state = "bluetaghelm"
	flags_cover = HEADCOVERSEYES
	inhand_icon_state = "bluetaghelm"
	armor = list(MELEE = 15, BULLET = 10, LASER = 20,ENERGY = 10, BOMB = 20, BIO = 0, RAD = 0, FIRE = 0, ACID = 50)
	// Offer about the same protection as a hardhat.
	dog_fashion = null

/obj/item/clothing/head/helmet/knight
	name = "средневековый шлем"
	desc = "Классический металлический шлем."
	icon_state = "knight_green"
	inhand_icon_state = "knight_green"
	armor = list(MELEE = 50, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 0, BIO = 0, RAD = 0, FIRE = 80, ACID = 80) // no wound armor cause getting domed in a bucket head sounds like concussion city
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	strip_delay = 80
	dog_fashion = null


/obj/item/clothing/head/helmet/knight/Initialize(mapload)
	. = ..()
	var/datum/component = GetComponent(/datum/component/wearertargeting/earprotection)
	qdel(component)

/obj/item/clothing/head/helmet/knight/blue
	icon_state = "knight_blue"
	inhand_icon_state = "knight_blue"

/obj/item/clothing/head/helmet/knight/yellow
	icon_state = "knight_yellow"
	inhand_icon_state = "knight_yellow"

/obj/item/clothing/head/helmet/knight/red
	icon_state = "knight_red"
	inhand_icon_state = "knight_red"

/obj/item/clothing/head/helmet/knight/greyscale
	name = "рыцарский шлем"
	desc = "Классический средневековый шлем, если держать его вверх ногами, то можно увидеть, что на самом деле это ведро."
	icon_state = "knight_greyscale"
	inhand_icon_state = "knight_greyscale"
	armor = list(MELEE = 35, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 10, RAD = 10, FIRE = 40, ACID = 40)
	material_flags = MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS //Can change color and add prefix

/obj/item/clothing/head/helmet/skull
	name = "черепной шлем"
	desc = "Страшный племенной шлем, он выглядит не очень удобно."
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES
	armor = list(MELEE = 35, BULLET = 25, LASER = 25, ENERGY = 35, BOMB = 25, BIO = 0, RAD = 0, FIRE = 50, ACID = 50)
	icon_state = "skull"
	inhand_icon_state = "skull"
	strip_delay = 100

/obj/item/clothing/head/helmet/durathread
	name = "дюратканевый шлем"
	desc = "Шлем из черного хлеба и кожи."
	icon_state = "durathread"
	inhand_icon_state = "durathread"
	resistance_flags = FLAMMABLE
	armor = list(MELEE = 20, BULLET = 10, LASER = 30, ENERGY = 40, BOMB = 15, BIO = 0, RAD = 0, FIRE = 40, ACID = 50, WOUND = 5)
	strip_delay = 60

/obj/item/clothing/head/helmet/rus_helmet
	name = "русский шлем"
	desc = "Он может вместить бутылку водки."
	icon_state = "rus_helmet"
	inhand_icon_state = "rus_helmet"
	armor = list(MELEE = 25, BULLET = 30, LASER = 0, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 20, FIRE = 20, ACID = 50, WOUND = 5)

/obj/item/clothing/head/helmet/rus_helmet/Initialize(mapload)
	. = ..()

	create_storage(type = /datum/storage/pockets/helmet)

/obj/item/clothing/head/helmet/rus_ushanka
	name = "боевая ушанка"
	desc = "100% медвежья."
	icon_state = "rus_ushanka"
	inhand_icon_state = "rus_ushanka"
	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	armor = list(MELEE = 25, BULLET = 20, LASER = 20, ENERGY = 30, BOMB = 20, BIO = 50, RAD = 20, FIRE = -10, ACID = 50, WOUND = 5)

/obj/item/clothing/head/helmet/infiltrator
	name = "шлем лазутчика"
	desc = "Галактика слишком мала для нас двоих."
	icon_state = "infiltrator"
	inhand_icon_state = "infiltrator"
	armor = list(MELEE = 40, BULLET = 40, LASER = 30, ENERGY = 40, BOMB = 70, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	flash_protect = FLASH_PROTECTION_WELDER
	flags_inv = HIDEHAIR|HIDEFACIALHAIR|HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	strip_delay = 80

/obj/item/clothing/head/helmet/elder_atmosian
	name = "Древний Атмосианский Шлем"
	desc = "Превосходный шлем, созданный из самых крепких и редких материалов, доступных людям."
	icon_state = "h2helmet"
	inhand_icon_state = "h2helmet"
	armor = list(MELEE = 15, BULLET = 10, LASER = 30, ENERGY = 30, BOMB = 10, BIO = 10, RAD = 20, FIRE = 65, ACID = 40, WOUND = 15)
	material_flags = MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS //Can change color and add prefix
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH

//monkey sentience caps

/obj/item/clothing/head/helmet/monkey_sentience
	name = "шлем для увеличения интеллекта обезьян"
	desc = "Хрупкий шлем со встроенными микросхемами, предназначенный для повышения уровня IQ обезьян. Вижу несколько предопреждающих табличек..."

	icon_state = "monkeymind"
	inhand_icon_state = "monkeymind"
	strip_delay = 100
	var/mob/living/carbon/human/magnification = null ///if the helmet is on a valid target (just works like a normal helmet if not (cargo please stop))
	var/polling = FALSE///if the helmet is currently polling for targets (special code for removal)
	var/light_colors = 1 ///which icon state color this is (red, blue, yellow)

/obj/item/clothing/head/helmet/monkey_sentience/Initialize(mapload)
	. = ..()
	light_colors = rand(1,3)
	update_icon()

/obj/item/clothing/head/helmet/monkey_sentience/examine(mob/user)
	. = ..()
	. += "<hr><span class='boldwarning'>---ВНИМАНИЕ: УДАЛЕНИЕ ШЛЕМА С СУБЪЕКТА МОЖЕТ ПРИВЕСТИ К:---</span>"
	. += span_warning("\nЖАЖДЕ КРОВИ")
	. += span_warning("\nСМЕРТИ МОЗГА")
	. += span_warning("\nАКТИВАЦИИ ПЕРВОБЫТНОГО ГЕНА")
	. += span_warning("\nМАССОВОЙ УСТОЙЧИВОСТИ ГЕНЕТИЧЕСКОГО СОСТАВА")
	. += span_boldnotice("\nПеред применением устройства проконсультируйтесь с вашим главным врачом.")

/obj/item/clothing/head/helmet/monkey_sentience/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)][light_colors][magnification ? "up" : ""]"

/obj/item/clothing/head/helmet/monkey_sentience/equipped(mob/user, slot)
	. = ..()
	if(slot != ITEM_SLOT_HEAD)
		return
	if(!ismonkey(user) || user.ckey)
		var/mob/living/something = user
		to_chat(something, span_boldnotice("На секунду ощутил колющую боль в затылке."))
		something.apply_damage(5,BRUTE,BODY_ZONE_HEAD,FALSE,FALSE,FALSE) //notably: no damage resist (it's in your helmet), no damage spread (it's in your helmet)
		playsound(src, 'white/valtos/sounds/error1.ogg', 30, TRUE)
		return
	if(!(GLOB.ghost_role_flags & GHOSTROLE_STATION_SENTIENCE))
		say("ERROR: Центральное командование временно запретило использование шлемов по увеличению обезьянего интеллекта в этом секторе. БЛИЖАЙШИЙ ЗАКОННЫЙ СЕКТОР: в 2,537 миллионов световых лет от меня.")
	magnification = user //this polls ghosts
	visible_message(span_warning("[capitalize(src.name)] включается!"))
	playsound(src, 'sound/machines/ping.ogg', 30, TRUE)
	polling = TRUE
	var/list/candidates = poll_candidates_for_mob("Хотите поиграть за обезьянку с увеличенным интеллектом?", ROLE_SENTIENCE, null, 50, magnification, POLL_IGNORE_SENTIENCE_POTION)
	polling = FALSE
	if(!candidates.len)
		magnification = null
		visible_message(span_notice("[capitalize(src.name)] замолкает и падает на пол. Может стоит попробовать позже?"))
		playsound(src, 'white/valtos/sounds/error1.ogg', 30, TRUE)
		user.dropItemToGround(src)
		return
	var/mob/picked = pick(candidates)
	magnification.key = picked.key
	playsound(src, 'sound/machines/microwave/microwave-end.ogg', 100, FALSE)
	to_chat(magnification, span_notice("Обезьянка с увеличенным интеллектом! Нужно защищать свой шлем ценой жизни - если я его потеряю, то и моя разумность пропадет вместе с ним!"))
	var/policy = get_policy(ROLE_MONKEY_HELMET)
	if(policy)
		to_chat(magnification, policy)
	icon_state = "[icon_state]up"

/obj/item/clothing/head/helmet/monkey_sentience/Destroy()
	disconnect()
	return ..()

/obj/item/clothing/head/helmet/monkey_sentience/proc/disconnect()
	if(!magnification) //not put on a viable head
		return
	if(!polling)//put on a viable head, but taken off after polling finished.
		if(magnification.client)
			to_chat(magnification, span_userdanger("Чую как я теряю проблески разума, и всё становится тусклым..."))
			magnification.ghostize(FALSE)
		if(prob(10))
			switch(rand(1,4))
				if(1) //blood rage
					magnification.ai_controller.blackboard[BB_MONKEY_AGRESSIVE] = TRUE
				if(2) //brain death
					magnification.apply_damage(500,BRAIN,BODY_ZONE_HEAD,FALSE,FALSE,FALSE)
				if(3) //primal gene (gorilla)
					magnification.gorillize()
				if(4) //genetic mass susceptibility (gib)
					magnification.gib()
	//either used up correctly or taken off before polling finished (punish this by destroying the helmet)
	playsound(src, 'white/valtos/sounds/error1.ogg', 30, TRUE)
	playsound(src, "sparks", 100, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	visible_message(span_warning("[capitalize(src.name)] шипит и распадается"))
	magnification = null
	new /obj/effect/decal/cleanable/ash/crematorium(drop_location()) //just in case they're in a locker or other containers it needs to use crematorium ash, see the path itself for an explanation

/obj/item/clothing/head/helmet/monkey_sentience/dropped(mob/user)
	. = ..()
	if(magnification || polling)
		qdel(src)//runs disconnect code


//LightToggle

/obj/item/clothing/head/helmet/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/clothing/head/helmet/update_icon_state()
	. = ..()
	var/state = "[initial(icon_state)]"
	if(attached_light)
		if(attached_light.on)
			state += "-flight-on" //"helmet-flight-on" // "helmet-cam-flight-on"
		else
			state += "-flight" //etc.

	icon_state = state

/obj/item/clothing/head/helmet/ui_action_click(mob/user, action)
	if(istype(action, alight))
		toggle_helmlight()
	else
		..()

/obj/item/clothing/head/helmet/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/flashlight/seclite))
		var/obj/item/flashlight/seclite/S = I
		if(can_flashlight && !attached_light)
			if(!user.transferItemToLoc(S, src))
				return
			to_chat(user, span_notice("Прикрепляю [S] к [src]."))
			set_attached_light(S)
			update_icon()
			update_helmlight()
			alight = new(src)
			if(loc == user)
				alight.Grant(user)
		return
	return ..()

/obj/item/clothing/head/helmet/screwdriver_act(mob/living/user, obj/item/I)
	. = ..()
	if(can_flashlight && attached_light) //if it has a light but can_flashlight is false, the light is permanently attached.
		I.play_tool_sound(src)
		to_chat(user, span_notice("Откручиваю [attached_light] от [src]."))
		attached_light.forceMove(drop_location())
		if(Adjacent(user) && !issilicon(user))
			user.put_in_hands(attached_light)

		var/obj/item/flashlight/removed_light = set_attached_light(null)
		update_helmlight()
		removed_light.update_brightness(user)
		update_icon()
		user.update_inv_head()
		QDEL_NULL(alight)
		return TRUE

/obj/item/clothing/head/helmet/proc/toggle_helmlight()
	set name = "Переключить нашлемный фонарик"
	set category = "Объект"
	set desc = "Нажмите чтобы включить или выключить прикрепленный к шлему фонарик."

	if(!attached_light)
		return

	var/mob/user = usr
	if(user.incapacitated())
		return
	attached_light.on = !attached_light.on
	attached_light.update_brightness()
	to_chat(user, span_notice("[attached_light.on ? "Включаю":"Выключаю"] фонарик на шлеме."))

	playsound(user, 'sound/weapons/empty.ogg', 100, TRUE)
	update_helmlight()

/obj/item/clothing/head/helmet/proc/update_helmlight()
	if(attached_light)
		update_icon()

	update_item_action_buttons()

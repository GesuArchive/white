/// How much damage you take from an emp when wearing a hardsuit
#define HARDSUIT_EMP_BURN 2 // a very orange number

	//Baseline hardsuits
/obj/item/clothing/head/helmet/space/hardsuit
	name = "герметичный шлем"
	desc = "Специальный шлем, разработаный для работы в опасных условиях, в условиях низкого давления. Имеет радиационную защиту."
	icon_state = "hardsuit0-engineering"
	inhand_icon_state = "eng_helm"
	max_integrity = 300
	armor = list(MELEE = 10, BULLET = 5, LASER = 10, ENERGY = 20, BOMB = 10, BIO = 100, RAD = 75, FIRE = 50, ACID = 75)
	light_system = MOVABLE_LIGHT_DIRECTIONAL
	light_range = 4
	light_power = 1
	light_on = FALSE
	var/basestate = "hardsuit"
	var/on = FALSE
	var/obj/item/clothing/suit/space/hardsuit/suit
	var/hardsuit_type = "engineering" //Determines used sprites: hardsuit[on]-[type]
	actions_types = list(/datum/action/item_action/toggle_helmet_light)
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH	| PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	var/current_tick_amount = 0
	var/radiation_count = 0
	var/grace = RAD_GEIGER_GRACE_PERIOD
	var/datum/looping_sound/geiger/soundloop

/obj/item/clothing/head/helmet/space/hardsuit/Initialize(mapload)
	. = ..()
	soundloop = new(src, FALSE, TRUE)
	soundloop.volume = 5
	START_PROCESSING(SSobj, src)

/obj/item/clothing/head/helmet/space/hardsuit/Destroy()
	. = ..()
	if(!QDELETED(suit))
		qdel(suit)
	suit = null
	QDEL_NULL(soundloop)
	STOP_PROCESSING(SSobj, src)

/obj/item/clothing/head/helmet/space/hardsuit/attack_self(mob/user)
	on = !on
	icon_state = "[basestate][on]-[hardsuit_type]"
	user.update_inv_head()	//so our mob-overlays update

	set_light_on(on)

	update_item_action_buttons()

/obj/item/clothing/head/helmet/space/hardsuit/dropped(mob/user)
	..()
	if(suit)
		suit.RemoveHelmet()
		soundloop.stop(user)

/obj/item/clothing/head/helmet/space/hardsuit/item_action_slot_check(slot)
	if(slot == ITEM_SLOT_HEAD)
		return 1

/obj/item/clothing/head/helmet/space/hardsuit/equipped(mob/user, slot)
	..()
	if(slot != ITEM_SLOT_HEAD)
		if(suit)
			suit.RemoveHelmet()
			soundloop.stop(user)
		else
			qdel(src)
	else
		soundloop.start(user)
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			C.head_update(src)

/obj/item/clothing/head/helmet/space/hardsuit/proc/display_visor_message(msg)
	var/mob/wearer = loc
	if(msg && ishuman(wearer))
		wearer.show_message("[icon2html(src, wearer)]<b><span class='robot'>[msg]</span></b>", MSG_VISUAL)

/obj/item/clothing/head/helmet/space/hardsuit/rad_act(amount)
	. = ..()
	if(amount <= RAD_BACKGROUND_RADIATION)
		return
	current_tick_amount += amount

/obj/item/clothing/head/helmet/space/hardsuit/process(delta_time)
	radiation_count = LPFILTER(radiation_count, current_tick_amount, delta_time, RAD_GEIGER_RC)

	if(current_tick_amount)
		grace = RAD_GEIGER_GRACE_PERIOD
	else
		grace -= delta_time
		if(grace <= 0)
			radiation_count = 0

	current_tick_amount = 0

	soundloop.last_radiation = radiation_count

/obj/item/clothing/head/helmet/space/hardsuit/emp_act(severity)
	. = ..()
	display_visor_message("Обнаружен [severity > 1 ? "лекгий" : "сильный"] электромагнитный импульс!")


/obj/item/clothing/suit/space/hardsuit
	name = "герметичный скафандр"
	desc = "Специальный костюм позволит работать в опасных условиях космоса."
	icon_state = "hardsuit-engineering"
	inhand_icon_state = "eng_hardsuit"
	max_integrity = 300
	armor = list(MELEE = 10, BULLET = 5, LASER = 10, ENERGY = 20, BOMB = 10, BIO = 100, RAD = 75, FIRE = 50, ACID = 75, WOUND = 10)
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/tank/jetpack, /obj/item/t_scanner, /obj/item/construction/rcd, /obj/item/pipe_dispenser, /obj/item/watertank)
	siemens_coefficient = 0
	var/obj/item/clothing/head/helmet/space/hardsuit/helmet
	actions_types = list(/datum/action/item_action/toggle_spacesuit, /datum/action/item_action/toggle_helmet)
	var/helmettype = /obj/item/clothing/head/helmet/space/hardsuit
	var/obj/item/tank/jetpack/suit/jetpack = null
	var/hardsuit_type
	var/armor_plate_amount = 0
	var/armor_plate_plasteel = 0
	var/armor_plate_ceramic = 0
	var/armor_plate_ablative = 0

/obj/item/clothing/suit/space/hardsuit/Initialize(mapload)
	if(jetpack && ispath(jetpack))
		jetpack = new jetpack(src)
	. = ..()

/obj/item/clothing/suit/space/hardsuit/attack_self(mob/user)
	user.changeNext_move(CLICK_CD_MELEE)
	..()

/obj/item/clothing/suit/space/hardsuit/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>Здесь есть крепления для дополнительных <b>броневых пластин</b>. На текущий момент закреплено <b>[armor_plate_amount]/3</b> бронепластин.</span>"
	if(!helmet && helmettype)
		. += span_notice("\nШлем [src] кажется неисправным. На нем нужно заменить лампочку.")

/obj/item/clothing/suit/space/hardsuit/attackby(obj/item/I, mob/user, params)
	. = ..()
// 	Модернизация бронепластинами
	if(istype(I, /obj/item/stack/sheet/armor_plate))
		if(armor_plate_amount < 3)
			var/obj/item/stack/sheet/armor_plate/S = I
			if(armor.getRating(S.armor_type) >= 70)
				to_chat(user, span_warning("Все уязвимые места уже перекрыты, я не представляю как это можно дополнительно укрепить!"))
				return
			else
				if(armor.getRating(S.armor_type) >= 20)
					src.armor = src.armor.attachArmor(I.armor)
					to_chat(user, span_notice("Закрепляю дополнительную бронепластину на [src]."))
				else
					if(armor.getRating(S.armor_type) >= 10)
						src.armor = src.armor.attachArmor(I.armor)
						src.armor = src.armor.attachArmor(I.armor)
					else
						src.armor = src.armor.attachArmor(I.armor)
						src.armor = src.armor.attachArmor(I.armor)
						src.armor = src.armor.attachArmor(I.armor)
					to_chat(user, span_notice("Закрепляю основную бронепластину на груди [src]."))
			armor_plate_amount = armor_plate_amount + 1
			playsound(get_turf(src), 'white/Feline/sounds/molnia.ogg', 80)

			if(S.amount > 1)
				S.amount = S.amount - 1
				S.update_icon()
			else
				qdel(I)
		else
			to_chat(user, span_warning("Все слоты дополнительного бронирования заняты!"))

	if(istype(I, /obj/item/tank/jetpack/suit))
		if(jetpack)
			to_chat(user, span_warning("Джетпак [src] уже установлен."))
			return
		if(src == user.get_item_by_slot(ITEM_SLOT_OCLOTHING)) //Make sure the player is not wearing the suit before applying the upgrade.
			to_chat(user, span_warning("Не могу установить улучшение [src] пока он надет."))
			return

		if(user.transferItemToLoc(I, src))
			jetpack = I
			to_chat(user, span_notice("Успешно установил джетпак в [src]."))
			return
	else if(!cell_cover_open && I.tool_behaviour == TOOL_SCREWDRIVER)

// 	Извлечение бронепластин
		if(armor_plate_amount)
			to_chat(user, span_notice("Извлекаю внешние бронепластины..."))
			playsound(user, 'sound/items/screwdriver.ogg',70, TRUE)
			if(!do_after(user, 5 SECONDS, src))
				return TRUE
			playsound(user, 'sound/items/handling/toolbelt_pickup.ogg', 70, TRUE)
			if(armor_plate_plasteel)
				for(var/i in 1 to armor_plate_plasteel)
					new /obj/item/stack/sheet/armor_plate/plasteel(src.drop_location())
			if(armor_plate_ceramic)
				for(var/i in 1 to armor_plate_ceramic)
					new /obj/item/stack/sheet/armor_plate/ceramic(src.drop_location())
			if(armor_plate_ablative)
				for(var/i in 1 to armor_plate_ablative)
					new /obj/item/stack/sheet/armor_plate/ablative(src.drop_location())
			new src.type(src.drop_location())
			qdel(src)
			return

		if(!jetpack)
			to_chat(user, span_warning("Джетпак [src] не установлен."))
			return
		if(src == user.get_item_by_slot(ITEM_SLOT_OCLOTHING))
			to_chat(user, span_warning("Не могу вытащить джетпак из надетого [src]."))
			return

		jetpack.turn_off(user)
		jetpack.forceMove(drop_location())
		jetpack = null
		to_chat(user, span_notice("Успешно вытащил джетпак из [src]."))
		return
	else if(istype(I, /obj/item/light) && helmettype)
		if(src == user.get_item_by_slot(ITEM_SLOT_OCLOTHING))
			to_chat(user, span_warning("Не могу заменить лампочку на шлеме [src] пока он надет."))
			return
		if(helmet)
			to_chat(user, span_warning("Шлему [src] не нужна новая лампочка."))
			return
		var/obj/item/light/L = I
		if(L.status)
			to_chat(user, span_warning("Эта лампочка слишком повреждена чтобы использовать её в качестве замены!"))
			return
		if(do_after(user, 5 SECONDS, src))
			qdel(I)
			helmet = new helmettype(src)
			to_chat(user, span_notice("Успешно заменил лампочку на шлеме [src]."))
			new /obj/item/light/bulb/broken(drop_location())
	return ..()

/obj/item/clothing/suit/space/hardsuit/equipped(mob/user, slot)
	..()
	if(jetpack)
		if(slot == ITEM_SLOT_OCLOTHING)
			for(var/X in jetpack.actions)
				var/datum/action/A = X
				A.Grant(user)

/obj/item/clothing/suit/space/hardsuit/dropped(mob/user)
	..()
	if(jetpack)
		for(var/X in jetpack.actions)
			var/datum/action/A = X
			A.Remove(user)

/obj/item/clothing/suit/space/hardsuit/item_action_slot_check(slot)
	if(slot == ITEM_SLOT_OCLOTHING) //we only give the mob the ability to toggle the helmet if he's wearing the hardsuit.
		return 1

/// Burn the person inside the hard suit just a little, the suit got really hot for a moment
/obj/item/clothing/suit/space/emp_act(severity)
	. = ..()
	var/mob/living/carbon/human/user = src.loc
	if(istype(user))
		user.apply_damage(HARDSUIT_EMP_BURN, BURN, spread_damage=TRUE)
		to_chat(user, span_warning("You feel <b>[src.name]</b> heat up from the EMP burning you slightly."))

		// Chance to scream
		if (user.stat < UNCONSCIOUS && prob(10))
			user.emote("agony")

	//Engineering
/obj/item/clothing/head/helmet/space/hardsuit/engine
	name = "инженерный герметичный шлем"
	desc = "Специальный шлем для работы в опасных условиях космоса. Имеет защиту от радиации."
	icon_state = "hardsuit0-engineering"
	inhand_icon_state = "eng_helm"
	armor = list(MELEE = 30, BULLET = 5, LASER = 10, ENERGY = 20, BOMB = 10, BIO = 100, RAD = 75, FIRE = 100, ACID = 75, WOUND = 10)
	hardsuit_type = "engineering"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/suit/space/hardsuit/engine
	name = "инженерный скафандр"
	desc = "Специальный скафандр для работы в опасных условиях космоса. Имеет защиту от радиации"
	icon_state = "hardsuit-engineering"
	inhand_icon_state = "eng_hardsuit"
	armor = list(MELEE = 30, BULLET = 5, LASER = 10, ENERGY = 20, BOMB = 10, BIO = 100, RAD = 75, FIRE = 100, ACID = 75, WOUND = 10)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/engine
	resistance_flags = FIRE_PROOF

	//Atmospherics
/obj/item/clothing/head/helmet/space/hardsuit/engine/atmos
	name = "атмосферный герметичный шлем"
	desc = "Специальный шлем, разработаный для атмосферных техников. Имеет защиту от температурных воздействий."
	icon_state = "hardsuit0-atmospherics"
	inhand_icon_state = "atmo_helm"
	hardsuit_type = "atmospherics"
	armor = list(MELEE = 30, BULLET = 5, LASER = 10, ENERGY = 20, BOMB = 10, BIO = 100, RAD = 25, FIRE = 100, ACID = 75, WOUND = 10)
	heat_protection = HEAD												//Uncomment to enable firesuit protection
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT

/obj/item/clothing/suit/space/hardsuit/engine/atmos
	name = "скафандр атмотеха"
	desc = "Разработан для работы в условиях космоса. Имеет защиту от температурных воздействий."
	icon_state = "hardsuit-atmospherics"
	inhand_icon_state = "atmo_hardsuit"
	armor = list(MELEE = 30, BULLET = 5, LASER = 10, ENERGY = 20, BOMB = 10, BIO = 100, RAD = 25, FIRE = 100, ACID = 75, WOUND = 10)
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS					//Uncomment to enable firesuit protection
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/engine/atmos


	//Chief Engineer's hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/engine/elite
	name = "усовершенствованный герметичный шлем"
	desc = "Усовершенствованный шлем для работы в условиях космоса."
	icon_state = "hardsuit0-white"
	inhand_icon_state = "ce_helm"
	hardsuit_type = "white"
	armor = list(MELEE = 40, BULLET = 5, LASER = 10, ENERGY = 20, BOMB = 50, BIO = 100, RAD = 100, FIRE = 100, ACID = 90, WOUND = 10)
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT

/obj/item/clothing/suit/space/hardsuit/engine/elite
	icon_state = "hardsuit-white"
	name = "усовершенствованный скафандр"
	desc = "Усовершенствованный скафандр для работы в условиях космоса."
	inhand_icon_state = "ce_hardsuit"
	armor = list(MELEE = 40, BULLET = 5, LASER = 10, ENERGY = 20, BOMB = 50, BIO = 100, RAD = 100, FIRE = 100, ACID = 90, WOUND = 10)
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/engine/elite
	jetpack = /obj/item/tank/jetpack/suit
	cell = /obj/item/stock_parts/cell/super

	//Mining hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/mining
	name = "шахтерский герметичный шлем"
	desc = "Разработан для работы в условиях космоса, имеет два фонарика для подсветки."
	icon_state = "hardsuit0-mining"
	inhand_icon_state = "mining_helm"
	hardsuit_type = "mining"
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF
	heat_protection = HEAD
	armor = list(MELEE = 30, BULLET = 5, LASER = 10, ENERGY = 20, BOMB = 50, BIO = 100, RAD = 50, FIRE = 50, ACID = 75, WOUND = 15)
	light_range = 7
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/tank/jetpack, /obj/item/resonator, /obj/item/mining_scanner, /obj/item/t_scanner/adv_mining_scanner, /obj/item/gun/energy/kinetic_accelerator)

/obj/item/clothing/head/helmet/space/hardsuit/mining/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/armor_plate)
	RegisterSignal(src, COMSIG_ARMOR_PLATED, PROC_REF(upgrade_icon_mining))

/obj/item/clothing/head/helmet/space/hardsuit/mining/proc/upgrade_icon_mining(datum/source, amount, maxamount)
	SIGNAL_HANDLER

	if(amount)
		name = "бронированный [initial(name)]"
		hardsuit_type = "mining_goliath"
		if(amount == maxamount)
			hardsuit_type = "mining_goliath_full"
	icon_state = "hardsuit[on]-[hardsuit_type]"
	if(ishuman(loc))
		var/mob/living/carbon/human/wearer = loc
		if(wearer.head == src)
			wearer.update_inv_head()

/obj/item/clothing/suit/space/hardsuit/mining
	name = "шахтерский скафандр"
	desc = "Специальный скафандр для работы в космосе. Должен защищать от тварей на Лаваленде."
	icon_state = "hardsuit-mining"
	inhand_icon_state = "mining_hardsuit"
	hardsuit_type = "mining"
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF
	armor = list(MELEE = 30, BULLET = 5, LASER = 10, ENERGY = 20, BOMB = 50, BIO = 100, RAD = 50, FIRE = 50, ACID = 75, WOUND = 15)
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/tank/jetpack, /obj/item/storage/bag/ore, /obj/item/pickaxe)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/mining
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/suit/space/hardsuit/mining/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/armor_plate)
	RegisterSignal(src, COMSIG_ARMOR_PLATED, PROC_REF(upgrade_icon_mining))

/obj/item/clothing/suit/space/hardsuit/mining/proc/upgrade_icon_mining(datum/source, amount, maxamount)
	SIGNAL_HANDLER

	if(amount)
		name = "бронированный [initial(name)]"
		hardsuit_type = "mining_goliath"
		if(amount == maxamount)
			hardsuit_type = "mining_goliath_full"
	icon_state = "hardsuit-[hardsuit_type]"
	if(ishuman(loc))
		var/mob/living/carbon/human/wearer = loc
		if(wearer.wear_suit == src)
			wearer.update_inv_wear_suit()

//Exploration hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/exploration
	name = "шлем рейнджера"
	desc = "Продвинутый шлем, который спасёт от космоса и других угроз."
	icon_state = "hardsuit0-exploration"
	inhand_icon_state = "death_commando_mask"
	heat_protection = HEAD
	armor = list(MELEE = 40, BULLET = 30, LASER = 30, ENERGY = 40, BOMB = 50, BIO = 100, RAD = 50, FIRE = 95, ACID = 95, WOUND = 25)
	light_range = 7
	hardsuit_type = "exploration"
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/tank/jetpack, /obj/item/resonator, /obj/item/mining_scanner, /obj/item/t_scanner/adv_mining_scanner, /obj/item/gun/energy/kinetic_accelerator)

/obj/item/clothing/suit/space/hardsuit/exploration
	icon_state = "hardsuit-exploration"
	name = "костюм рейнджера"
	desc = "Продвинутый костюм, который спасёт от космоса и других угроз."
	inhand_icon_state = "mining_hardsuit"
	armor = list(MELEE = 40, BULLET = 30, LASER = 30, ENERGY = 40, BOMB = 50, BIO = 100, RAD = 50, FIRE = 95, ACID = 95, WOUND = 25)
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/tank/jetpack, /obj/item/storage/bag/ore, /obj/item/pickaxe)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/exploration
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS

	//Syndicate hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/syndi
	name = "кроваво-красный герметичный шлем"
	desc = "Два режима работы имеет шлем для работы в спецоперациях. Сейчас он в режиме скафандра. Изготовлено компанией Gorlex Marauders."
	alt_desc = "Два режима работы имеет шлем для работы в спецоперациях. Сейчас он в боевом режиме. Изготовлено компанией Gorlex Marauders."
	icon_state = "hardsuit1-syndi"
	inhand_icon_state = "syndie_helm"
	hardsuit_type = "syndi"
	armor = list(MELEE = 40, BULLET = 50, LASER = 30, ENERGY = 40, BOMB = 35, BIO = 100, RAD = 50, FIRE = 50, ACID = 90, WOUND = 25)
	on = TRUE
	var/obj/item/clothing/suit/space/hardsuit/syndi/linkedsuit = null
	actions_types = list(/datum/action/item_action/toggle_helmet_mode)
	visor_flags_inv = HIDEMASK|HIDEEYES|HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	visor_flags = STOPSPRESSUREDAMAGE

/obj/item/clothing/head/helmet/space/hardsuit/syndi/update_icon_state()
	. = ..()
	icon_state = "hardsuit[on]-[hardsuit_type]"

/obj/item/clothing/head/helmet/space/hardsuit/syndi/Initialize(mapload)
	. = ..()
	if(istype(loc, /obj/item/clothing/suit/space/hardsuit/syndi))
		linkedsuit = loc

/obj/item/clothing/head/helmet/space/hardsuit/syndi/attack_self(mob/user) //Toggle Helmet
	if(!isturf(user.loc))
		to_chat(user, span_warning("Не могу переключить шлем. На нём [user.loc]!")  )
		return
	on = !on
	if(on || force)
		to_chat(user, span_notice("Переключаю костюм в режим скафандра, жертвуем скоростью для защиты от космоса."))
		name = initial(name)
		desc = initial(desc)
		set_light_on(TRUE)
		clothing_flags |= visor_flags
		flags_cover |= HEADCOVERSEYES | HEADCOVERSMOUTH
		flags_inv |= visor_flags_inv
		cold_protection |= HEAD
	else
		to_chat(user, span_notice("Переключаю костюм в боевой режим. Скорость увеличена."))
		name += " (боевой)"
		desc = alt_desc
		set_light_on(FALSE)
		clothing_flags &= ~visor_flags
		flags_cover &= ~(HEADCOVERSEYES | HEADCOVERSMOUTH)
		flags_inv &= ~visor_flags_inv
		cold_protection &= ~HEAD
	update_icon()
	playsound(src.loc, 'sound/mecha/mechmove03.ogg', 50, TRUE)
	toggle_hardsuit_mode(user)
	user.update_inv_head()
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		C.head_update(src, forced = 1)
	update_item_action_buttons()

/obj/item/clothing/head/helmet/space/hardsuit/syndi/proc/toggle_hardsuit_mode(mob/user) //Helmet Toggles Suit Mode
	if(linkedsuit)
		if(on)
			linkedsuit.name = initial(linkedsuit.name)
			linkedsuit.desc = initial(linkedsuit.desc)
			linkedsuit.slowdown = initial(linkedsuit.slowdown)
			linkedsuit.clothing_flags |= STOPSPRESSUREDAMAGE
			linkedsuit.cold_protection |= CHEST | GROIN | LEGS | FEET | ARMS | HANDS
		else
			linkedsuit.name += " (боевой)"
			linkedsuit.desc = linkedsuit.alt_desc
			linkedsuit.slowdown = 0
			linkedsuit.clothing_flags &= ~STOPSPRESSUREDAMAGE
			linkedsuit.cold_protection &= ~(CHEST | GROIN | LEGS | FEET | ARMS | HANDS)

		linkedsuit.icon_state = "hardsuit[on]-[hardsuit_type]"
		linkedsuit.update_icon()
		user.update_inv_wear_suit()
		user.update_inv_w_uniform()
		user.update_equipment_speed_mods()


/obj/item/clothing/suit/space/hardsuit/syndi
	name = "кроваво-красный скафандр"
	desc = "Два режима работы имеет шлем для работы в спецоперациях. Сейчас он в режиме скафандра. Изготовлено компанией Gorlex Marauders.."
	alt_desc = "Два режима работы имеет шлем для работы в спецоперациях. Сейчас он в боевом режиме. Изготовлено компанией Gorlex Marauders.."
	icon_state = "hardsuit1-syndi"
	inhand_icon_state = "syndie_hardsuit"
	hardsuit_type = "syndi"
	w_class = WEIGHT_CLASS_NORMAL
	armor = list(MELEE = 40, BULLET = 50, LASER = 30, ENERGY = 40, BOMB = 35, BIO = 100, RAD = 50, FIRE = 50, ACID = 90, WOUND = 25)
	allowed = list(/obj/item/gun, /obj/item/ammo_box,/obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/melee/energy/sword/saber, /obj/item/restraints/handcuffs, /obj/item/tank/internals)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/syndi
	jetpack = /obj/item/tank/jetpack/suit
	cell = /obj/item/stock_parts/cell/hyper

//Elite Syndie suit
/obj/item/clothing/head/helmet/space/hardsuit/syndi/elite
	name = "элитный синдикатский скафандр"
	desc = "Элитная версия синдикатского скафандра с усовершенствованной броней и большей защитой от огня. Сейчас он в режиме скафандра. Изготовлено компанией Gorlex Marauders."
	alt_desc = "Элитная версия синдикатского скафандра с усовершенствованной броней и большей защитой от огня. Сейчас он в боевом режиме. Изготовлено компанией Gorlex Marauders"
	icon_state = "hardsuit0-syndielite"
	hardsuit_type = "syndielite"
	armor = list(MELEE = 60, BULLET = 60, LASER = 50, ENERGY = 60, BOMB = 55, BIO = 100, RAD = 70, FIRE = 100, ACID = 100, WOUND = 25)
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/debug

/obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/debug/Initialize(mapload)
	. = ..()
	soundloop.volume = 0

/obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/admin
	name = "jannie hardsuit helmet"
	armor = list(MELEE = 100, BULLET = 100, LASER = 100, ENERGY = 100, BOMB = 100, BIO = 100, RAD = 100, FIRE = 100, ACID = 100, WOUND = 100)

/obj/item/clothing/suit/space/hardsuit/syndi/elite
	name = "синдикатский скафандр"
	desc = "Имеет улучшенную защиту от огнестрельного оружия, огнеустойчив. В походном режиме."
	alt_desc = "Имеет улучшенную защиту от огнестрельного оружия, огнеустойчив. В боевом режиме."
	icon_state = "hardsuit0-syndielite"
	hardsuit_type = "syndielite"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/syndi/elite
	armor = list(MELEE = 60, BULLET = 60, LASER = 50, ENERGY = 60, BOMB = 55, BIO = 100, RAD = 70, FIRE = 100, ACID = 100, WOUND = 25)
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | ACID_PROOF
	cell = /obj/item/stock_parts/cell/bluespace

/obj/item/clothing/suit/space/hardsuit/syndi/elite/debug
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/debug

/obj/item/clothing/suit/space/hardsuit/syndi/elite/admin //the hardsuit to end all other hardsuits
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/admin
	name = "jannie hardsuit"
	slowdown = 0
	armor = list(MELEE = 100, BULLET = 100, LASER = 100, ENERGY = 100, BOMB = 100, BIO = 100, RAD = 100, FIRE = 100, ACID = 100, WOUND = 100)
	cell = /obj/item/stock_parts/cell/infinite
	clothing_flags = BLOCKS_SHOVE_KNOCKDOWN
	strip_delay = 1000
	equip_delay_other = 1000

//The Owl Hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/syndi/owl
	name = "совиный скафандр"
	desc = "Сделан кустарно для криминальных разборок. В походном режиме."
	alt_desc = "Сделан кустарно для криминальных разборок. В боевом режиме."
	icon_state = "hardsuit1-owl"
	inhand_icon_state = "s_helmet"
	hardsuit_type = "owl"
	visor_flags_inv = 0
	visor_flags = 0
	on = FALSE

/obj/item/clothing/suit/space/hardsuit/syndi/owl
	name = "совиный скафандр"
	desc = "Сделан кустарно для криминальных разборок. В походном режиме."
	alt_desc = "Сделан кустарно для криминальных разборок. В боевом режиме."
	icon_state = "hardsuit1-owl"
	inhand_icon_state = "s_suit"
	hardsuit_type = "owl"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/syndi/owl


	//Wizard hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/wizard
	name = "магический герметический шлем"
	desc = "Украшеный волшебными камнями, данный шлем излучает магическую энергию."
	icon_state = "hardsuit0-wiz"
	inhand_icon_state = "wiz_helm"
	hardsuit_type = "wiz"
	clothing_flags = SNUG_FIT | CASTING_CLOTHES
	resistance_flags = FIRE_PROOF | ACID_PROOF //No longer shall our kind be foiled by lone chemists with spray bottles!
	armor = list(MELEE = 40, BULLET = 40, LASER = 40, ENERGY = 50, BOMB = 35, BIO = 100, RAD = 50, FIRE = 100, ACID = 100, WOUND = 30)
	heat_protection = HEAD												//Uncomment to enable firesuit protection
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT

/obj/item/clothing/suit/space/hardsuit/wizard
	name = "магический скафандр"
	desc = "Украшеный драгоценными камнями, данный скафандр излучает магическую энергию"
	icon_state = "hardsuit-wiz"
	inhand_icon_state = "wiz_hardsuit"
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FIRE_PROOF | ACID_PROOF
	armor = list(MELEE = 40, BULLET = 40, LASER = 40, ENERGY = 50, BOMB = 35, BIO = 100, RAD = 50, FIRE = 100, ACID = 100, WOUND = 30)
	allowed = list(/obj/item/teleportation_scroll, /obj/item/tank/internals)
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS					//Uncomment to enable firesuit protection
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/wizard
	cell = /obj/item/stock_parts/cell/hyper
	slowdown = 0 //you're spending 2 wizard points on this thing, the least it could do is not make you a sitting duck

/obj/item/clothing/suit/space/hardsuit/wizard/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/anti_magic, TRUE, FALSE, FALSE, ITEM_SLOT_OCLOTHING, INFINITY, FALSE)


	//Medical hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/medical
	name = "медицицинский герметичный шлем"
	desc = "Сделан для работы в условиях низкого давления. Не для сварочных работ!"
	icon_state = "hardsuit0-medical"
	inhand_icon_state = "medical_helm"
	hardsuit_type = "medical"
	flash_protect = FLASH_PROTECTION_NONE
	armor = list(MELEE = 30, BULLET = 5, LASER = 10, ENERGY = 20, BOMB = 10, BIO = 100, RAD = 60, FIRE = 60, ACID = 75, WOUND = 10)
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL | SNUG_FIT
	clothing_traits = list(TRAIT_REAGENT_SCANNER, TRAIT_RESEARCH_SCANNER)

/obj/item/clothing/suit/space/hardsuit/medical
	name = "медицинский скафандр"
	desc = "Сделан для работы в условиях низкого давления из светоотражающих материалов"
	icon_state = "hardsuit-medical"
	inhand_icon_state = "medical_hardsuit"
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/tank/jetpack, /obj/item/storage/firstaid, /obj/item/healthanalyzer, /obj/item/stack/medical, /obj/item/medbot_carrier)
	armor = list(MELEE = 30, BULLET = 5, LASER = 10, ENERGY = 20, BOMB = 10, BIO = 100, RAD = 60, FIRE = 60, ACID = 75, WOUND = 10)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/medical
	slowdown = 0.5

	//Research Director hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/rd
	name = "прототип герметичного шлема"
	desc = "Разработан для исследований в опасных условиях низкого давления. Данные ученых мелькают на визоре."
	icon_state = "hardsuit0-rd"
	hardsuit_type = "rd"
	resistance_flags = ACID_PROOF | FIRE_PROOF
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	armor = list(MELEE = 30, BULLET = 5, LASER = 10, ENERGY = 20, BOMB = 100, BIO = 100, RAD = 60, FIRE = 60, ACID = 80, WOUND = 15)
	var/explosion_detection_dist = 21
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL | SNUG_FIT
	clothing_traits = list(TRAIT_REAGENT_SCANNER, TRAIT_RESEARCH_SCANNER)

/obj/item/clothing/head/helmet/space/hardsuit/rd/Initialize(mapload)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_EXPLOSION, PROC_REF(sense_explosion))

/obj/item/clothing/head/helmet/space/hardsuit/rd/equipped(mob/living/carbon/human/user, slot)
	..()
	if (slot == ITEM_SLOT_HEAD)
		var/datum/atom_hud/DHUD = GLOB.huds[DATA_HUD_DIAGNOSTIC_BASIC]
		DHUD.show_to(user)

/obj/item/clothing/head/helmet/space/hardsuit/rd/dropped(mob/living/carbon/human/user)
	..()
	if (user.head == src)
		var/datum/atom_hud/DHUD = GLOB.huds[DATA_HUD_DIAGNOSTIC_BASIC]
		DHUD.hide_from(user)

/obj/item/clothing/head/helmet/space/hardsuit/rd/proc/sense_explosion(datum/source, turf/epicenter, devastation_range, heavy_impact_range,
		light_impact_range, took, orig_dev_range, orig_heavy_range, orig_light_range)
	var/turf/T = get_turf(src)
	if(!T || T?.z != epicenter?.z)
		return
	if(get_dist(epicenter, T) > explosion_detection_dist)
		return
	display_visor_message("Explosion detected! Epicenter: [devastation_range], Outer: [heavy_impact_range], Shock: [light_impact_range]")

/obj/item/clothing/suit/space/hardsuit/rd
	name = "прототип скафандра"
	desc = "Прототип скафандра, защищающего владельца от взрывной волны. Лучше не тестировать."
	icon_state = "hardsuit-rd"
	inhand_icon_state = "hardsuit-rd"
	resistance_flags = ACID_PROOF | FIRE_PROOF
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT //Same as an emergency firesuit. Not ideal for extended exposure.
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/tank/jetpack, /obj/item/gun/energy/wormhole_projector,
	/obj/item/hand_tele, /obj/item/aicard)
	armor = list(MELEE = 30, BULLET = 5, LASER = 10, ENERGY = 20, BOMB = 100, BIO = 100, RAD = 60, FIRE = 60, ACID = 80, WOUND = 15)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/rd
	cell = /obj/item/stock_parts/cell/super

	//Security hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/security
	name = "герметичный шлем охраны"
	desc = "Специальный шлем для работы в условиях низкого давления. Имеет дополнительный слой брони."
	icon_state = "hardsuit0-sec"
	inhand_icon_state = "sec_helm"
	hardsuit_type = "sec"
	armor = list(MELEE = 40, BULLET = 30, LASER = 30, ENERGY = 40, BOMB = 50, BIO = 100, RAD = 50, FIRE = 75, ACID = 75, WOUND = 20)

/obj/item/clothing/suit/space/hardsuit/security
	icon_state = "hardsuit-sec"
	name = "скафандр охраны"
	desc = "Специальный костюм для работы в условиях низкого давления. Имеет дополнительный слой брони."
	inhand_icon_state = "sec_hardsuit"
	armor = list(MELEE = 40, BULLET = 30, LASER = 30, ENERGY = 40, BOMB = 50, BIO = 100, RAD = 50, FIRE = 75, ACID = 75, WOUND = 20)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/security

/obj/item/clothing/suit/space/hardsuit/security/Initialize(mapload)
	. = ..()
	allowed = GLOB.security_hardsuit_allowed

	//Head of Security hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/security/hos
	name = "герметичный шлем начальника охраны"
	desc = "Специальный шлем для работы в условиях низкого давления. Имеет дополнительный слой брони."
	icon_state = "hardsuit0-hos"
	hardsuit_type = "hos"
	armor = list(MELEE = 45, BULLET = 40, LASER = 40, ENERGY = 50, BOMB = 50, BIO = 100, RAD = 50, FIRE = 95, ACID = 95, WOUND = 25)

/obj/item/clothing/suit/space/hardsuit/security/hos
	icon_state = "hardsuit-hos"
	name = "скафандр начальника охраны"
	desc = "Специальный скафандр для работы в условиях низкого давления. Имеет дополнительный слой брони."
	armor = list(MELEE = 45, BULLET = 40, LASER = 40, ENERGY = 50, BOMB = 50, BIO = 100, RAD = 50, FIRE = 95, ACID = 95, WOUND = 25)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/security/hos
	jetpack = /obj/item/tank/jetpack/suit
	cell = /obj/item/stock_parts/cell/super

	//SWAT MKII
/obj/item/clothing/head/helmet/space/hardsuit/swat
	name = "шлем спецназа MK.II"
	icon_state = "swat2helm"
	inhand_icon_state = "swat2helm"
	desc = "Тактический шлем спецназа MK.II."
	armor = list(MELEE = 40, BULLET = 50, LASER = 50, ENERGY = 60, BOMB = 50, BIO = 100, RAD = 50, FIRE = 100, ACID = 100, WOUND = 15)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDESNOUT //we want to see the mask //this makes the hardsuit not fireproof you genius
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	actions_types = list()

/obj/item/clothing/head/helmet/space/hardsuit/swat/attack_self()

/obj/item/clothing/suit/space/hardsuit/swat
	name = "скафандр спецназа MK.II"
	desc = "A MK.II SWAT сделан из усовершенствованных материалов, лучший выбор для охраны и тех, кто хочет повоевать."
	icon_state = "swat2"
	inhand_icon_state = "swat2"
	armor = list(MELEE = 40, BULLET = 50, LASER = 50, ENERGY = 60, BOMB = 50, BIO = 100, RAD = 50, FIRE = 100, ACID = 100, WOUND = 15)
	slowdown = 0.5
	resistance_flags = FIRE_PROOF | ACID_PROOF
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT //this needed to be added a long fucking time ago
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/swat

// SWAT and Captain get EMP Protection
/obj/item/clothing/suit/space/hardsuit/swat/Initialize(mapload)
	. = ..()
	allowed = GLOB.security_hardsuit_allowed

	//Captain
/obj/item/clothing/head/helmet/space/hardsuit/swat/captain
	name = "капитанский шлем спецназа"
	icon_state = "capspace"
	inhand_icon_state = "capspacehelmet"
	desc = "A tactical MK.II шлем спецназа boasting better protection and a reasonable fashion sense."

/obj/item/clothing/suit/space/hardsuit/swat/captain
	name = "капитанский SWAT скафандр"
	desc = "A MK.II SWAT suit with streamlined joints and armor made out of superior materials, insulated against intense heat with the complementary gas mask. The most advanced tactical armor available. Usually reserved for heavy hitter corporate security, this one has a regal finish in Nanotrasen company colors. Better not let the assistants get a hold of it."
	icon_state = "caparmor"
	inhand_icon_state = "capspacesuit"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/swat/captain
	cell = /obj/item/stock_parts/cell/super

	//Clown
/obj/item/clothing/head/helmet/space/hardsuit/clown
	name = "клоунский герметичный шлем"
	desc = "Предназначен для работы в условиях низкого давления. Имеет радиационную защиту."
	icon_state = "hardsuit0-clown"
	inhand_icon_state = "hardsuit0-clown"
	armor = list(MELEE = 30, BULLET = 5, LASER = 10, ENERGY = 20, BOMB = 10, BIO = 100, RAD = 75, FIRE = 60, ACID = 30)
	hardsuit_type = "clown"

/obj/item/clothing/suit/space/hardsuit/clown
	name = "клоунский скафандр"
	desc = "Только истинный клоун оденет это."
	icon_state = "hardsuit-clown"
	inhand_icon_state = "clown_hardsuit"
	armor = list(MELEE = 30, BULLET = 5, LASER = 10, ENERGY = 20, BOMB = 10, BIO = 100, RAD = 75, FIRE = 60, ACID = 30)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/clown

/obj/item/clothing/suit/space/hardsuit/clown/mob_can_equip(mob/M, mob/living/equipper, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	if(!..() || !ishuman(M))
		return FALSE
	var/mob/living/carbon/human/H = M
	if(H.mind.assigned_role == JOB_CLOWN)
		return TRUE
	else
		return FALSE

	//Old Prototype
/obj/item/clothing/head/helmet/space/hardsuit/ancient
	name = "прототип RIG герметичного шлема"
	desc = "Обычный древний шлем космонавта"
	icon_state = "hardsuit0-ancient"
	inhand_icon_state = "anc_helm"
	armor = list(MELEE = 30, BULLET = 5, LASER = 5, ENERGY = 15, BOMB = 50, BIO = 100, RAD = 100, FIRE = 100, ACID = 75)
	hardsuit_type = "ancient"
	resistance_flags = FIRE_PROOF
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT

/obj/item/clothing/suit/space/hardsuit/ancient
	name = "прототип RIG скафандра"
	desc = "Обычный древний скафандр космонавта."
	icon_state = "hardsuit-ancient"
	inhand_icon_state = "anc_hardsuit"
	armor = list(MELEE = 30, BULLET = 5, LASER = 5, ENERGY = 15, BOMB = 50, BIO = 100, RAD = 100, FIRE = 100, ACID = 75)
	slowdown = 3
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ancient
	resistance_flags = FIRE_PROOF
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	var/footstep = 1
	var/mob/listeningTo

/obj/item/clothing/suit/space/hardsuit/ancient/proc/on_mob_move()
	var/mob/living/carbon/human/H = loc
	if(!istype(H) || H.wear_suit != src)
		return
	if(footstep > 1)
		playsound(src, 'sound/effects/servostep.ogg', 100, TRUE)
		footstep = 0
	else
		footstep++

/obj/item/clothing/suit/space/hardsuit/ancient/equipped(mob/user, slot)
	. = ..()
	if(slot != ITEM_SLOT_OCLOTHING)
		if(listeningTo)
			UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)
		return
	if(listeningTo == user)
		return
	if(listeningTo)
		UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(on_mob_move))
	listeningTo = user

/obj/item/clothing/suit/space/hardsuit/ancient/dropped()
	. = ..()
	if(listeningTo)
		UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)

/obj/item/clothing/suit/space/hardsuit/ancient/Destroy()
	listeningTo = null
	return ..()

/////////////SHIELDED//////////////////////////////////

/obj/item/clothing/suit/space/hardsuit/shielded
	name = "экранированный скафандр"
	desc = "Костюм с силовой бронёй. Должен быть предварительно заряженым."
	icon_state = "hardsuit-hos"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/security/hos
	allowed = null
	armor = list(MELEE = 30, BULLET = 15, LASER = 30, ENERGY = 40, BOMB = 10, BIO = 100, RAD = 50, FIRE = 100, ACID = 100, WOUND = 15)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	/// How many charges total the shielding has
	var/max_charges = 3
	/// How long after we've been shot before we can start recharging.
	var/recharge_delay = 20 SECONDS
	/// How quickly the shield recharges each charge once it starts charging
	var/recharge_rate = 1 SECONDS
	/// The icon for the shield
	var/shield_icon = "shield-old"

/obj/item/clothing/suit/space/hardsuit/shielded/Initialize(mapload)
	. = ..()
	if(!allowed)
		allowed = GLOB.advanced_hardsuit_allowed
	AddComponent(/datum/component/shielded, max_charges = max_charges, recharge_start_delay = recharge_delay, charge_increment_delay = recharge_rate, shield_icon = shield_icon)

/obj/item/clothing/head/helmet/space/hardsuit/shielded
	resistance_flags = FIRE_PROOF | ACID_PROOF

///////////////Capture the Flag////////////////////

/obj/item/clothing/suit/space/hardsuit/shielded/ctf
	name = "белый силовой костюм"
	desc = "Стандартный предмет для игры в захват флага."
	icon_state = "ctf_white"
	inhand_icon_state = "ert_medical"
	hardsuit_type = "ctf_white"
	// Adding TRAIT_NODROP is done when the CTF spawner equips people
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/shielded/ctf
	armor = list(MELEE = 0, BULLET = 30, LASER = 30, ENERGY = 40, BOMB = 50, BIO = 100, RAD = 100, FIRE = 95, ACID = 95)
	slowdown = 0
	max_charges = 5

/obj/item/clothing/suit/space/hardsuit/shielded/ctf/red
	name = "красный силовой костюм"
	icon_state = "ctf_red"
	inhand_icon_state = "ert_security"
	hardsuit_type = "ctf_red"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/shielded/ctf/red
	shield_icon = "shield-red"

/obj/item/clothing/suit/space/hardsuit/shielded/ctf/blue
	name = "синий силовой костюм"
	desc = "Стандартный предмет для игры в захват флага."
	icon_state = "ctf_blue"
	inhand_icon_state = "ert_command"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/shielded/ctf/blue

/obj/item/clothing/suit/space/hardsuit/shielded/ctf/green
	name = "green shielded hardsuit"
	icon_state = "ctf_green"
	inhand_icon_state = "ert_green"
	hardsuit_type = "ctf_green"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/shielded/ctf/green
	shield_icon = "shield-green"

/obj/item/clothing/suit/space/hardsuit/shielded/ctf/yellow
	name = "yellow shielded hardsuit"
	icon_state = "ctf_yellow"
	inhand_icon_state = "ert_engineer"
	hardsuit_type = "ctf_yellow"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/shielded/ctf/yellow
	shield_icon = "shield-yellow"


/obj/item/clothing/head/helmet/space/hardsuit/shielded/ctf
	name = "экранированый герметичный шлем"
	desc = "Стандартный предмет для игры в захват флага."
	icon_state = "hardsuit0-ctf_white"
	inhand_icon_state = "hardsuit0-ert_medical"
	hardsuit_type = "ctf_white"
	armor = list(MELEE = 0, BULLET = 30, LASER = 30, ENERGY = 40, BOMB = 50, BIO = 100, RAD = 100, FIRE = 95, ACID = 95)


/obj/item/clothing/head/helmet/space/hardsuit/shielded/ctf/red
	icon_state = "hardsuit0-ctf_red"
	inhand_icon_state = "hardsuit0-ert_security"
	hardsuit_type = "ctf_red"

/obj/item/clothing/head/helmet/space/hardsuit/shielded/ctf/blue
	name = "экранированый герметичный шлем"
	desc = "Стандартный предмет для игры в захват флага."
	icon_state = "hardsuit0-ctf_blue"
	inhand_icon_state = "hardsuit0-ert_commander"
	hardsuit_type = "ctf_blue"

/obj/item/clothing/head/helmet/space/hardsuit/shielded/ctf/green
	icon_state = "hardsuit0-ctf_green"
	inhand_icon_state = "hardsuit0-ert_green"
	hardsuit_type = "ctf_green"

/obj/item/clothing/head/helmet/space/hardsuit/shielded/ctf/yellow
	icon_state = "hardsuit0-ctf_yellow"
	inhand_icon_state = "hardsuit0-ert_engineer"
	hardsuit_type = "ctf_yellow"

//////Syndicate Version

/obj/item/clothing/suit/space/hardsuit/shielded/syndi
	name = "кроваво-красный скафандр"
	desc = "Улучшеный костюм с силовым полем."
	icon_state = "hardsuit1-syndi"
	inhand_icon_state = "syndie_hardsuit"
	hardsuit_type = "syndi"
	armor = list(MELEE = 40, BULLET = 50, LASER = 30, ENERGY = 40, BOMB = 35, BIO = 100, RAD = 50, FIRE = 100, ACID = 100, WOUND = 30)
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/melee/energy/sword/saber, /obj/item/restraints/handcuffs, /obj/item/tank/internals)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/shielded/syndi
	slowdown = 0
	shield_icon = "shield-red"
	jetpack = /obj/item/tank/jetpack/suit

/obj/item/clothing/head/helmet/space/hardsuit/shielded/syndi
	name = "кроваво-красный шлем"
	desc = "Шлем с силовым полем."
	icon_state = "hardsuit1-syndi"
	inhand_icon_state = "syndie_helm"
	hardsuit_type = "syndi"
	armor = list(MELEE = 40, BULLET = 50, LASER = 30, ENERGY = 40, BOMB = 35, BIO = 100, RAD = 50, FIRE = 100, ACID = 100, WOUND = 30)

///SWAT version
/obj/item/clothing/suit/space/hardsuit/shielded/swat
	name = "скафандр отряда смерти"
	desc = "Усовершенствованный скафандр для секретных операций."
	icon_state = "deathsquad"
	inhand_icon_state = "swat_suit"
	hardsuit_type = "syndi"
	max_charges = 4
	recharge_delay = 1.5 SECONDS
	armor = list(MELEE = 80, BULLET = 80, LASER = 50, ENERGY = 60, BOMB = 100, BIO = 100, RAD = 100, FIRE = 100, ACID = 100, WOUND = 30)
	strip_delay = 130
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/shielded/swat
	dog_fashion = /datum/dog_fashion/back/deathsquad

/obj/item/clothing/head/helmet/space/hardsuit/shielded/swat
	name = "герметичный шлем отряда смерти"
	desc = "Усовершенствованный шлем для секретных операций с силовой бронёй."
	icon_state = "deathsquad"
	inhand_icon_state = "deathsquad"
	hardsuit_type = "syndi"
	armor = list(MELEE = 80, BULLET = 80, LASER = 50, ENERGY = 60, BOMB = 100, BIO = 100, RAD = 100, FIRE = 100, ACID = 100, WOUND = 30)
	strip_delay = 130
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	actions_types = list()

#undef HARDSUIT_EMP_BURN

//backpack item
#define HALFWAYCRITDEATH ((HEALTH_THRESHOLD_CRIT + HEALTH_THRESHOLD_DEAD) * 0.5)

/obj/item/defibrillator
	name = "дефибриллятор"
	desc = "Устройство генерирует короткий высоковольтный импульс, вызывающий полное сокращение миокарда. После того, как сердце полностью сократилось, существует вероятность восстановления нормального синусового ритма."
	icon = 'icons/obj/defib.dmi'
	icon_state = "defibunit"
	inhand_icon_state = "defibunit"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	slot_flags = ITEM_SLOT_BACK
	force = 5
	throwforce = 6
	w_class = WEIGHT_CLASS_BULKY
	actions_types = list(/datum/action/item_action/toggle_paddles)
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 50)

	var/obj/item/shockpaddles/paddle_type = /obj/item/shockpaddles
	var/on = FALSE //if the paddles are equipped (1) or on the defib (0)
	var/safety = TRUE //if you can zap people with the defibs on harm mode
	var/powered = FALSE //if there's a cell in the defib with enough power for a revive, blocks paddles from reviving otherwise
	var/obj/item/shockpaddles/paddles
	var/obj/item/stock_parts/cell/high/cell
	var/combat = FALSE //if true, revive through hardsuits, allow for combat shocking
	var/cooldown_duration = 5 SECONDS//how long does it take to recharge
	/// The icon state for the paddle overlay, not applied if null
	var/paddle_state = "defibunit-paddles"
	/// The icon state for the powered on overlay, not applied if null
	var/powered_state = "defibunit-powered"
	/// The icon state for the charge bar overlay, not applied if null
	var/charge_state = "defibunit-charge"
	/// The icon state for the missing cell overlay, not applied if null
	var/nocell_state = "defibunit-nocell"
	/// The icon state for the emagged overlay, not applied if null
	var/emagged_state = "defibunit-emagged"

/obj/item/defibrillator/get_cell()
	return cell

//	Осмотр дефиба
/obj/item/defibrillator/examine(mob/user)
	. = ..()
	var/obj/item/stock_parts/cell/C = get_cell()
	. += "<hr><span class='notice'>Дисплей:</span>"
	if(C)
		. += "</br><span class='notice'>- Уроверь батареи <b>[C.percent()]%</b>.</span>"
	else
		. += "<hr><span class='notice'>- Батарея отсутствует!</span>"

/obj/item/defibrillator/Initialize(mapload) //starts without a cell for rnd
	. = ..()
	paddles = new paddle_type(src)
	update_power()
	return

/obj/item/defibrillator/loaded/Initialize(mapload) //starts with hicap
	. = ..()
	cell = new(src)
	update_power()
	return

/obj/item/defibrillator/fire_act(exposed_temperature, exposed_volume)
	. = ..()
	if(paddles?.loc == src)
		paddles.fire_act(exposed_temperature, exposed_volume)

/obj/item/defibrillator/extinguish()
	. = ..()
	if(paddles?.loc == src)
		paddles.extinguish()

/obj/item/defibrillator/proc/update_power()
	if(!QDELETED(cell))
		if(QDELETED(paddles) || cell.charge < paddles.revivecost)
			powered = FALSE
		else
			powered = TRUE
	else
		powered = FALSE
	update_icon()

/obj/item/defibrillator/update_overlays()
	. = ..()

	if(!on && paddle_state)
		. += paddle_state
	if(powered && powered_state)
		. += powered_state
		if(!QDELETED(cell) && charge_state)
			var/ratio = cell.charge / cell.maxcharge
			ratio = CEILING(ratio*4, 1) * 25
			. += "[charge_state][ratio]"
	if(!cell && nocell_state)
		. += "[nocell_state]"
	if(!safety && emagged_state)
		. += emagged_state

/obj/item/defibrillator/CheckParts(list/parts_list)
	..()
	cell = locate(/obj/item/stock_parts/cell) in contents
	update_power()

/obj/item/defibrillator/ui_action_click()
	toggle_paddles()

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/item/defibrillator/attack_hand(mob/user)
	if(loc == user)
		if(slot_flags == ITEM_SLOT_BACK)
			if(user.get_item_by_slot(ITEM_SLOT_BACK) == src)
				ui_action_click()
			else
				to_chat(user, span_warning("Для этого нужно экипировать дефибриллятор на спину!"))

		else if(slot_flags == ITEM_SLOT_BELT)
			if(user.get_item_by_slot(ITEM_SLOT_BELT) == src)
				ui_action_click()
			else
				to_chat(user, span_warning("Для этого нужно экипировать дефибриллятор на поясе!"))
		return
	else if(istype(loc, /obj/machinery/defibrillator_mount))
		ui_action_click() //checks for this are handled in defibrillator.mount.dm
	return ..()

/obj/item/defibrillator/MouseDrop(obj/over_object)
	. = ..()
	if(ismob(loc))
		var/mob/M = loc
		if(!M.incapacitated() && istype(over_object, /atom/movable/screen/inventory/hand))
			var/atom/movable/screen/inventory/hand/H = over_object
			M.putItemFromInventoryInHandIfPossible(src, H.held_index)

/obj/item/defibrillator/attackby(obj/item/W, mob/user, params)
	if(W == paddles)
		toggle_paddles()
	else if(istype(W, /obj/item/stock_parts/cell))
		var/obj/item/stock_parts/cell/C = W
		if(cell)
			to_chat(user, span_warning("[capitalize(src.name)] уже имеет батарейку!"))
		else
			if(C.maxcharge < paddles.revivecost)
				to_chat(user, span_notice("[capitalize(src.name)] требует батарейку большей ёмкости."))
				return
			if(!user.transferItemToLoc(W, src))
				return
			cell = W
			to_chat(user, span_notice("Устанавливаю батарейку в [src]."))
			update_power()

	else if(W.tool_behaviour == TOOL_SCREWDRIVER)
		if(cell)
			cell.update_icon()
			cell.forceMove(get_turf(src))
			cell = null
			to_chat(user, span_notice("Вытаскиваю батарейку из [src]."))
			update_power()
	else
		return ..()

/obj/item/defibrillator/emag_act(mob/user)
	if(safety)
		safety = FALSE
		to_chat(user, span_warning("Незаметно выключаю протоколы безопасности [src] при помощи криптографического секвенсора."))
	else
		safety = TRUE
		to_chat(user, span_notice("Незаметно включаю протоколы безопасности [src] при помощи криптографического секвенсора."))

/obj/item/defibrillator/emp_act(severity)
	. = ..()
	if(cell && !(. & EMP_PROTECT_CONTENTS))
		deductcharge(1000 / severity)
	if (. & EMP_PROTECT_SELF)
		return
	if(safety)
		safety = FALSE
		visible_message(span_notice("[capitalize(src.name)] пиликает: протоколы безопасности выключены!"))
		playsound(src, 'sound/machines/defib_saftyOff.ogg', 50, FALSE)
	else
		safety = TRUE
		visible_message(span_notice("[capitalize(src.name)] пиликает: протоколы безопасности включены!"))
		playsound(src, 'sound/machines/defib_saftyOn.ogg', 50, FALSE)
	update_power()

/obj/item/defibrillator/proc/toggle_paddles()
	set name = "Достать электроды"
	set category = "Объект"
	on = !on

	var/mob/living/carbon/user = usr
	if(on)
		//Detach the paddles into the user's hands
		if(!usr.put_in_hands(paddles))
			on = FALSE
			to_chat(user, span_warning("Нужна свободная рука чтобы держать электроды!"))
			update_power()
			return
	else
		//Remove from their hands and back onto the defib unit
		remove_paddles(user)

	update_power()
	update_item_action_buttons()


/obj/item/defibrillator/equipped(mob/user, slot)
	..()
	if((slot_flags == ITEM_SLOT_BACK && slot != ITEM_SLOT_BACK) || (slot_flags == ITEM_SLOT_BELT && slot != ITEM_SLOT_BELT))
		remove_paddles(user)
		update_power()

/obj/item/defibrillator/item_action_slot_check(slot, mob/user)
	if(slot == user.getBackSlot())
		return 1

/obj/item/defibrillator/proc/remove_paddles(mob/user) //this fox the bug with the paddles when other player stole you the defib when you have the paddles equiped
	if(ismob(paddles.loc))
		var/mob/M = paddles.loc
		M.dropItemToGround(paddles, TRUE)
	return

/obj/item/defibrillator/Destroy()
	if(on)
		var/M = get(paddles, /mob)
		remove_paddles(M)
	QDEL_NULL(paddles)
	QDEL_NULL(cell)
	return ..()

/obj/item/defibrillator/proc/deductcharge(chrgdeductamt)
	if(cell)
		if(cell.charge < (paddles.revivecost+chrgdeductamt))
			powered = FALSE
			update_power()
		if(cell.use(chrgdeductamt))
			update_power()
			return TRUE
		else
			return FALSE

/obj/item/defibrillator/proc/cooldowncheck(mob/user)
		addtimer(CALLBACK(src, PROC_REF(finish_charging)), cooldown_duration)

/obj/item/defibrillator/proc/finish_charging()
	if(cell)
		if(cell.charge >= paddles.revivecost)
			visible_message(span_notice("[capitalize(src.name)] пищит: Конденсатор заряжен."))
			playsound(src, 'sound/machines/defib_ready.ogg', 50, FALSE)
		else
			visible_message(span_notice("[capitalize(src.name)] пищит: Недостаточно энергии."))
			playsound(src, 'sound/machines/defib_failed.ogg', 50, FALSE)
	paddles.cooldown = FALSE
	paddles.update_icon()
	update_power()

/obj/item/defibrillator/compact
	name = "компактный дефибриллятор"
	desc = "Более компактная и продвинутая версия дефибриллятора. Можно носить на поясе."
	icon_state = "defibcompact"
	inhand_icon_state = "defibcompact"
	worn_icon_state = "defibcompact"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BELT
	paddle_state = "defibcompact-paddles"
	powered_state = "defibcompact-powered"
	charge_state = "defibcompact-charge"
	nocell_state = "defibcompact-nocell"
	emagged_state = "defibcompact-emagged"

/obj/item/defibrillator/compact/item_action_slot_check(slot, mob/user)
	if(slot == user.getBeltSlot())
		return TRUE

/obj/item/defibrillator/compact/loaded/Initialize(mapload)
	. = ..()
	cell = new(src)
	update_power()

/obj/item/defibrillator/compact/combat
	name = "боевой дефибриллятор"
	desc = "Военный образец дефибриллятора. Его мощные конденсаторы позволяют реанимировать пациента через одежду, а так же он может быть использован в бою в обезоруживающей или агрессивной манере."
	icon_state = "defibcombat" //needs defib inhand sprites
	inhand_icon_state = "defibcombat"
	worn_icon_state = "defibcombat"
	combat = TRUE
	safety = FALSE
	cooldown_duration = 2.5 SECONDS
	paddle_type = /obj/item/shockpaddles/syndicate
	paddle_state = "defibcombat-paddles"
	powered_state = null
	emagged_state = null

/obj/item/defibrillator/compact/combat/loaded/Initialize(mapload)
	. = ..()
	cell = new /obj/item/stock_parts/cell/infinite(src)
	update_power()

/obj/item/defibrillator/compact/combat/loaded/attackby(obj/item/W, mob/user, params)
	if(W == paddles)
		toggle_paddles()
		return

/obj/item/defibrillator/compact/combat/loaded/nanotrasen
	name = "элитный дефибриллятор NanoTrasen"
	desc = "Военный образец. Мощные конденсаторы позволяют пробивать легкую одежду, а так же использовать его в бою для разоружения или агрессивного электрошока."
	icon_state = "defibnt" //needs defib inhand sprites
	inhand_icon_state = "defibnt"
	worn_icon_state = "defibnt"
	paddle_type = /obj/item/shockpaddles/syndicate/nanotrasen
	paddle_state = "defibnt-paddles"

/obj/item/defibrillator/compact/fieldmed
	name = "дефибриллятор полевого медика"
	desc = "Улучшенный образец дефибриллятора. Усиленные конденсаторы позволяют эффективнее использовать его в бою, но за это приходится расплачиваться повышенным энергопотреблением."
	icon_state = "defibfield"
	inhand_icon_state = "defibfield"
	worn_icon_state = "defibfield"
	paddle_state = "defibfield-paddles"
	powered_state = "defibcompact-powered"
	charge_state = "defibcompact-charge"
	nocell_state = "defibcompact-nocell"
	combat = TRUE
	safety = FALSE
	cooldown_duration = 4 SECONDS
	paddle_type = /obj/item/shockpaddles/field
	paddle_state = "defibfield-paddles"
	emagged_state = null

/obj/item/defibrillator/compact/fieldmed/loaded/Initialize(mapload)
	. = ..()
	cell = new(src)
	update_power()

/obj/item/defibrillator/compact/fieldmed/loaded/attackby(obj/item/W, mob/user, params)
	if(W == paddles)
		toggle_paddles()
	else if(istype(W, /obj/item/stock_parts/cell))
		var/obj/item/stock_parts/cell/C = W
		if(cell)
			to_chat(user, span_warning("[capitalize(src.name)] уже имеет батарейку!"))
		else
			if(C.maxcharge < paddles.revivecost)
				to_chat(user, span_notice("[capitalize(src.name)] требует батарейку большей ёмкости."))
				return
			if(!user.transferItemToLoc(W, src))
				return
			cell = W
			to_chat(user, span_notice("Устанавливаю батарейку в [src]."))
			update_power()

	else if(W.tool_behaviour == TOOL_SCREWDRIVER)
		if(cell)
			cell.update_icon()
			cell.forceMove(get_turf(src))
			cell = null
			to_chat(user, span_notice("Вытаскиваю батарейку из [src]."))
			update_power()
	else
		return ..()
//paddles

/obj/item/shockpaddles
	name = "электроды дефибриллятора"
	desc = "Пара токопроводящих электродов."
	icon = 'icons/obj/defib.dmi'
	icon_state = "defibpaddles0"
	inhand_icon_state = "defibpaddles0"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'

	force = 0
	throwforce = 6
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = INDESTRUCTIBLE
	base_icon_state = "defibpaddles"

	var/revivecost = 1000
	var/cooldown = FALSE
	var/busy = FALSE
	var/obj/item/defibrillator/defib
	var/req_defib = TRUE
	var/combat = FALSE //If it penetrates armor and gives additional functionality
	var/wielded = FALSE // track wielded status on item

/obj/item/shockpaddles/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	AddComponent(/datum/component/two_handed, force_unwielded=8, force_wielded=12)

/// triggered on wield of two handed item
/obj/item/shockpaddles/proc/on_wield(obj/item/source, mob/user)
	SIGNAL_HANDLER

	wielded = TRUE

/// triggered on unwield of two handed item
/obj/item/shockpaddles/proc/on_unwield(obj/item/source, mob/user)
	SIGNAL_HANDLER

	wielded = FALSE

/obj/item/shockpaddles/Destroy()
	defib = null
	return ..()

/obj/item/shockpaddles/equipped(mob/user, slot)
	. = ..()
	if(!req_defib)
		return
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(check_range))

/obj/item/shockpaddles/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	. = ..()
	check_range()

/obj/item/shockpaddles/fire_act(exposed_temperature, exposed_volume)
	. = ..()
	if((req_defib && defib) && loc != defib)
		defib.fire_act(exposed_temperature, exposed_volume)

/obj/item/shockpaddles/proc/check_range()
	SIGNAL_HANDLER

	if(!req_defib || !defib)
		return
	if(!in_range(src,defib))
		if(isliving(loc))
			var/mob/living/user = loc
			to_chat(user, span_warning("Электроды [defib] перетянуты и вылетают из рук!"))
		else
			visible_message(span_notice("[capitalize(src.name)] возвращаются обратно в [defib]."))
		snap_back()

/obj/item/shockpaddles/proc/recharge(time)
	if(req_defib || !time)
		return
	cooldown = TRUE
	update_icon()
	sleep(time)
	var/turf/T = get_turf(src)
	T.audible_message(span_notice("[capitalize(src.name)] пищит: Конденсатор заряжен."))
	playsound(src, 'sound/machines/defib_ready.ogg', 50, FALSE)
	cooldown = FALSE
	update_icon()

/obj/item/shockpaddles/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NO_STORAGE_INSERT, GENERIC_ITEM_TRAIT) //stops shockpaddles from being inserted in BoH
	RegisterSignal(src, COMSIG_TWOHANDED_WIELD, PROC_REF(on_wield))
	RegisterSignal(src, COMSIG_TWOHANDED_UNWIELD, PROC_REF(on_unwield))
	if(!req_defib)
		return //If it doesn't need a defib, just say it exists
	if (!loc || !istype(loc, /obj/item/defibrillator)) //To avoid weird issues from admin spawns
		return INITIALIZE_HINT_QDEL
	defib = loc
	busy = FALSE
	update_icon()

/obj/item/shockpaddles/suicide_act(mob/user)
	user.visible_message(span_danger("[user] прикладывает активные электроды себе на грудь! Похоже [user.p_theyre()] пытается покончить с собой!"))
	if(req_defib)
		defib.deductcharge(revivecost)
	playsound(src, 'sound/machines/defib_zap.ogg', 50, TRUE, -1)
	return (OXYLOSS)

/obj/item/shockpaddles/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][wielded]"
	inhand_icon_state = icon_state
	if(cooldown)
		icon_state = "[base_icon_state][wielded]_cooldown"

/obj/item/shockpaddles/dropped(mob/user)
	. = ..()
	if(user)
		UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
	if(req_defib)
		if(user)
			to_chat(user, span_notice("Электроды возвращаются обратно в дефибриллятор."))
		snap_back()

/obj/item/shockpaddles/proc/snap_back()
	if(!defib)
		return
	defib.on = FALSE
	forceMove(defib)
	defib.update_power()

/obj/item/shockpaddles/attack(mob/M, mob/user)
	if(busy)
		return
	if(req_defib && !defib.powered)
		user.visible_message(span_notice("[defib] пищит: Устройство обесточено."))
		playsound(src, 'sound/machines/defib_failed.ogg', 50, FALSE)
		return
	if(!wielded)
		if(iscyborg(user))
			to_chat(user, span_warning("Требуется активация модуля дефибриллятора для работы электродов!"))
		else
			to_chat(user, span_warning("Необходимо взять электроды в обе руки для использования!"))
		return
	if(cooldown)
		if(req_defib)
			to_chat(user, span_warning("[defib] перезаряжается!"))
		else
			to_chat(user, span_warning("[capitalize(src.name)] перезаряжается!"))
		return

	if(user.a_intent == INTENT_DISARM)
		do_disarm(M, user)
		return

	if(!iscarbon(M))
		if(req_defib)
			to_chat(user, span_warning("Приложенные инструкции не поясняют как работать... с этим..."))
		else
			to_chat(user, span_warning("Понятия не имею как можно это реанимировать..."))
		return
	var/mob/living/carbon/H = M

	if(user.zone_selected != BODY_ZONE_CHEST)
		to_chat(user, span_warning("Нужно нацелиться на грудь пациента!"))
		return

	if(user.a_intent == INTENT_HARM)
		do_harm(H, user)
		return

	if(H.can_defib() == DEFIB_POSSIBLE)
		H.notify_ghost_cloning("Кто-то пытается меня откачать!")
		//H.grab_ghost() // Shove them back in their body. оно ломает приколы с возвращением артистов

	do_help(H, user)

/obj/item/shockpaddles/proc/shock_touching(dmg, mob/H)
	if(isliving(H.pulledby))		//CLEAR!
		var/mob/living/M = H.pulledby
		if(M.electrocute_act(30, H.name))
			M.visible_message(span_danger("[M] получает удар током при контакте с [H]"))
			M.emote("agony")

/obj/item/shockpaddles/proc/do_disarm(mob/living/M, mob/living/user)
	if(req_defib && defib.safety)
		return
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_notice("Не могу."))
		return
	if(!req_defib && !combat)
		return
	busy = TRUE
	M.visible_message(span_danger("[user] касается [M] [src]!") , \
			span_userdanger("[user] касается [M] [src]!"))
	M.adjustStaminaLoss(60)
	M.Knockdown(60)
	M.Jitter(70)
	M.apply_status_effect(STATUS_EFFECT_CONVULSING)
	playsound(src,  'sound/machines/defib_zap.ogg', 50, TRUE, -1)
	if(HAS_TRAIT(M,MOB_ORGANIC))
		M.emote("gasp")
	log_combat(user, M, "zapped", src)
	if(req_defib)
		defib.deductcharge(revivecost)
		cooldown = TRUE
	busy = FALSE
	update_icon()
	if(req_defib)
		defib.cooldowncheck(user)
	else
		recharge(80)

/obj/item/shockpaddles/proc/do_harm(mob/living/carbon/H, mob/living/user)
	if(req_defib && defib.safety)
		return
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_notice("Не могу."))
		return
	if(!req_defib && !combat)
		return
	user.visible_message(span_warning("[user] начинает устанавливать [src] на грудь [H].") ,
		span_warning("Перегружаю электроды и устанавливаю на грудь [H]..."))
	busy = TRUE
	update_icon()
	if(do_after(user, 1.5 SECONDS, H))
		user.visible_message(span_notice("[user] устанавливает [src] на грудь [H].") ,
			span_warning("Устанавливаю [src] на грудь [H] и начинаю зарядку."))
		var/turf/T = get_turf(defib)
		playsound(src, 'sound/machines/defib_charge.ogg', 50, FALSE)
		if(req_defib)
			T.audible_message(span_warning("<b>[capitalize(defib)]</b> издаёт громкий звуковой сигнал и начинает сильно гудеть..."))
		else
			user.audible_message(span_warning("[capitalize(src.name)] издаёт громкий звуковой сигнал."))
		if(do_after(user, 1.5 SECONDS, H)) //Takes longer due to overcharging
			if(!H)
				busy = FALSE
				update_icon()
				return
			if(H && H.stat == DEAD)
				to_chat(user, span_warning("[H] мёртв."))
				playsound(src, 'sound/machines/defib_failed.ogg', 50, FALSE)
				busy = FALSE
				update_icon()
				return
			user.visible_message(span_boldannounce("<i>[user] ударяет током [H] используя <b>[src.name]</b>!") , span_warning("Ударяю током [H] используя <b>[src.name]</b>!"))
			playsound(src, 'sound/machines/defib_zap.ogg', 100, TRUE, -1)
			playsound(src, 'sound/weapons/egloves.ogg', 100, TRUE, -1)
			H.emote("agony")
			shock_touching(45, H)
			if(H.can_heartattack() && !H.undergoing_cardiac_arrest())
				if(!H.stat)
					H.visible_message(span_warning("[H] изгибается в дугу, хватаясь [H.ru_ego()] грудь!") ,
						span_userdanger("Чувствую ужасно сильную боль у себя в груди!"))
				H.set_heartattack(TRUE)
			H.apply_damage(50, BURN, BODY_ZONE_CHEST)
			log_combat(user, H, "overloaded the heart of", defib)
			H.Paralyze(100)
			H.Jitter(100)
			if(req_defib)
				defib.deductcharge(revivecost)
				cooldown = TRUE
			busy = FALSE
			update_icon()
			if(!req_defib)
				recharge(60)
			if(req_defib && (defib.cooldowncheck(user)))
				return
	busy = FALSE
	update_icon()

/obj/item/shockpaddles/proc/do_help(mob/living/carbon/H, mob/living/user)
	user.visible_message(span_warning("[user] устанавливает [src] на грудь [H].") , span_warning("Начинаю устанавливать [src] на грудь [H]..."))
	busy = TRUE
	update_icon()
	if(do_after(user, 3 SECONDS, H)) //beginning to place the paddles on patient's chest to allow some time for people to move away to stop the process
		user.visible_message(span_notice("[user] устанавливает [src] на грудь [H].") , span_warning("Устанавливаю [src] на грудь [H]."))
		playsound(src, 'sound/machines/defib_charge.ogg', 75, FALSE)
		var/obj/item/organ/heart = H.getorgan(/obj/item/organ/heart)
		if(do_after(user, 2 SECONDS, H)) //placed on chest and short delay to shock for dramatic effect, revive time is 5sec total
			if((!combat && !req_defib) || (req_defib && !defib.combat))
				for(var/obj/item/clothing/C in H.get_equipped_items())
					if((C.body_parts_covered & CHEST) && (C.clothing_flags & THICKMATERIAL)) //check to see if something is obscuring their chest.
						user.audible_message(span_warning("[req_defib ? "[defib]" : "[src]"] гудит: Грудь пациента недоступна. Операция прервана."))
						playsound(src, 'sound/machines/defib_failed.ogg', 50, FALSE)
						busy = FALSE
						update_icon()
						return
			if(H.stat == DEAD)
				H.visible_message(span_warning("[H] недолго бьется в конвульсиях."))
				playsound(src, "bodyfall", 50, TRUE)
				playsound(src, 'sound/machines/defib_zap.ogg', 75, TRUE, -1)
				shock_touching(30, H)

				var/defib_result = H.can_defib()
				var/fail_reason

				switch (defib_result)
					if (DEFIB_FAIL_SUICIDE)
						fail_reason = "Восстановление пациента невозможно. Дальнейшие попытки будут безрезультативны."
					if (DEFIB_FAIL_NO_HEART)
						fail_reason = "Сердце пациента отсутствует."
					if (DEFIB_FAIL_FAILING_HEART)
						fail_reason = "Сердце пациента слишком сильно повреждено. Требуется замена или хирургическое вмешательство."
					if (DEFIB_FAIL_TISSUE_DAMAGE)
						fail_reason = "Ткани пациента слишком сильно повреждены. Требуется хирургическое вмешательство."
					if (DEFIB_FAIL_HUSK)
						fail_reason = "Тело пациента хаскировано. Требуется регенерация всех тканей."
					if (DEFIB_FAIL_FAILING_BRAIN)
						fail_reason = "Мозг пациента слишком сильно поврежден. Требуется хирургическое вмешательство."
					if (DEFIB_FAIL_NO_INTELLIGENCE)
						fail_reason = "Не обнаружены признаки разума. Дальнейшие попытки будут безрезультативны."
					if (DEFIB_FAIL_NO_BRAIN)
						fail_reason = "Мозг пациента отсутсвует. Дальнейшие попытки будут безрезультативны."

				if(fail_reason)
					user.visible_message(span_warning("[req_defib ? "[defib]" : "[src]"] гудит: Реанимация провалена - [fail_reason]"))
					playsound(src, 'sound/machines/defib_failed.ogg', 50, FALSE)
				else
					var/total_brute = H.getBruteLoss()
					var/total_burn = H.getFireLoss()

					//If the body has been fixed so that they would not be in crit when defibbed, give them oxyloss to put them back into crit
					if (H.health > HALFWAYCRITDEATH)
						H.adjustOxyLoss(H.health - HALFWAYCRITDEATH, 0)
					else
						var/overall_damage = total_brute + total_burn + H.getToxLoss() + H.getOxyLoss()
						var/mobhealth = H.health
						H.adjustOxyLoss((mobhealth - HALFWAYCRITDEATH) * (H.getOxyLoss() / overall_damage), 0)
						H.adjustToxLoss((mobhealth - HALFWAYCRITDEATH) * (H.getToxLoss() / overall_damage), 0)
						H.adjustFireLoss((mobhealth - HALFWAYCRITDEATH) * (total_burn / overall_damage), 0)
						H.adjustBruteLoss((mobhealth - HALFWAYCRITDEATH) * (total_brute / overall_damage), 0)
					H.updatehealth() // Previous "adjust" procs don't update health, so we do it manually.
					user.visible_message(span_notice("[req_defib ? "[defib]" : "[src]"] пищит: Реанимация успешна."))
					playsound(src, 'sound/machines/defib_success.ogg', 50, FALSE)
					H.set_heartattack(FALSE)
					if(!(H.grab_ghost())) //sosanie
						H.ice_cream_mob = TRUE
						H.ice_cream_check()
					H.revive(full_heal = FALSE, admin_revive = FALSE)
					H.emote("gasp")
					H.Jitter(100)
					SEND_SIGNAL(H, COMSIG_LIVING_MINOR_SHOCK)
					SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "saved_life", /datum/mood_event/saved_life)
					log_combat(user, H, "revived", defib)
				if(req_defib)
					defib.deductcharge(revivecost)
					cooldown = 1
				update_icon()
				if(req_defib)
					defib.cooldowncheck(user)
				else
					recharge(60)
			else if (!H.getorgan(/obj/item/organ/heart))
				user.visible_message(span_warning("[req_defib ? "[defib]" : "[src]"] гудит: Сердце пациента отсутсвует. Операция прервана."))
				playsound(src, 'sound/machines/defib_failed.ogg', 50, FALSE)
			else if(H.undergoing_cardiac_arrest())
				playsound(src, 'sound/machines/defib_zap.ogg', 50, TRUE, -1)
				if(!(heart.organ_flags & ORGAN_FAILING))
					H.set_heartattack(FALSE)
					user.visible_message(span_notice("[req_defib ? "[defib]" : "[src]"] пищит: Сердечный ритм нормализирован."))
				else
					user.visible_message(span_warning("[req_defib ? "[defib]" : "[src]"] гудит: Реанимация провалена, обнаружено повреждение сердца."))

			else
				user.visible_message(span_warning("[req_defib ? "[defib]" : "[src]"] гудит: Состояние пациента не удовлетворительное. Операция прервана."))
				playsound(src, 'sound/machines/defib_failed.ogg', 50, FALSE)
	busy = FALSE
	update_icon()

/obj/item/shockpaddles/cyborg
	name = "кибернетические электроды дефибриллятора"
	icon = 'icons/obj/defib.dmi'
	icon_state = "defibpaddles0"
	inhand_icon_state = "defibpaddles0"
	req_defib = FALSE

/obj/item/shockpaddles/cyborg/attack(mob/M, mob/user)
	if(iscyborg(user))
		var/mob/living/silicon/robot/R = user
		if(R.emagged)
			combat = TRUE
		else
			combat = FALSE
	else
		combat = FALSE

	. = ..()

/obj/item/shockpaddles/syndicate
	name = "электроды дефибриллятора Синдиката"
	desc = "Военный образец. Мощные конденсаторы позволяют пробивать легкую одежду, а так же использовать его в бою для разоружения или агрессивного электрошока."
	combat = TRUE
	icon = 'icons/obj/defib.dmi'
	icon_state = "syndiepaddles0"
	inhand_icon_state = "syndiepaddles0"
	base_icon_state = "syndiepaddles"

/obj/item/shockpaddles/syndicate/nanotrasen
	name = "электроды элитного дефибриллятора НаноТрейзен"
	desc = "Военный образец. Мощные конденсаторы позволяют пробивать легкую одежду, а так же использовать его в бою для разоружения или агрессивного электрошока."
	icon_state = "ntpaddles0"
	inhand_icon_state = "ntpaddles0"
	base_icon_state = "ntpaddles"

/obj/item/shockpaddles/syndicate/cyborg
	req_defib = FALSE

/obj/item/shockpaddles/field
	name = "электроды дефибриллятора полевого медика"
	desc = "Улучшенный образец. Усиленные конденсаторы позволяют эффективнее использовать его в бою."
	icon = 'icons/obj/defib.dmi'
	icon_state = "fieldpaddles0"
	inhand_icon_state = "fieldpaddles0"
	base_icon_state = "fieldpaddles"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	revivecost = 2000

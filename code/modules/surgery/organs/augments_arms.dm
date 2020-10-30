/obj/item/organ/cyberimp/arm
	name = "имплантат руки"
	desc = "You shouldn't see this! Adminhelp and report this as an issue on github!"
	zone = BODY_ZONE_R_ARM
	icon_state = "implant-toolkit"
	w_class = WEIGHT_CLASS_SMALL
	actions_types = list(/datum/action/item_action/organ_action/toggle)
	///A ref for the arm we're taking up. Mostly for the unregister signal upon removal
	var/obj/hand
	/// Used to store a list of all items inside, for multi-item implants.
	var/list/items_list = list()// I would use contents, but they shuffle on every activation/deactivation leading to interface inconsistencies.
	/// You can use this var for item path, it would be converted into an item on New().
	var/obj/item/active_item

/obj/item/organ/cyberimp/arm/Initialize()
	. = ..()
	if(ispath(active_item))
		active_item = new active_item(src)

	update_icon()
	SetSlotFromZone()
	items_list = contents.Copy()

/obj/item/organ/cyberimp/arm/proc/SetSlotFromZone()
	switch(zone)
		if(BODY_ZONE_L_ARM)
			slot = ORGAN_SLOT_LEFT_ARM_AUG
		if(BODY_ZONE_R_ARM)
			slot = ORGAN_SLOT_RIGHT_ARM_AUG
		else
			CRASH("Invalid zone for [type]")

/obj/item/organ/cyberimp/arm/update_icon()
	if(zone == BODY_ZONE_R_ARM)
		transform = null
	else // Mirroring the icon
		transform = matrix(-1, 0, 0, 0, 1, 0)

/obj/item/organ/cyberimp/arm/examine(mob/user)
	. = ..()
	. += "<span class='info'>[capitalize(src.name)] собран в [zone == BODY_ZONE_R_ARM ? "правой" : "левой"] зоне рук. Вы можете использовать отвертку для его пересборки.</span>"

/obj/item/organ/cyberimp/arm/screwdriver_act(mob/living/user, obj/item/I)
	. = ..()
	if(.)
		return TRUE
	I.play_tool_sound(src)
	if(zone == BODY_ZONE_R_ARM)
		zone = BODY_ZONE_L_ARM
	else
		zone = BODY_ZONE_R_ARM
	SetSlotFromZone()
	to_chat(user, "<span class='notice'>Я изменил положение [src] и пересобрал его в [zone == BODY_ZONE_R_ARM ? "правой" : "левой"] руке.</span>")
	update_icon()

/obj/item/organ/cyberimp/arm/Insert(mob/living/carbon/M, special = FALSE, drop_if_replaced = TRUE)
	. = ..()
	var/side = zone == BODY_ZONE_R_ARM? RIGHT_HANDS : LEFT_HANDS
	hand = owner.hand_bodyparts[side]
	if(hand)
		RegisterSignal(hand, COMSIG_ITEM_ATTACK_SELF, .proc/ui_action_click) //If the limb gets an attack-self, open the menu. Only happens when hand is empty

/obj/item/organ/cyberimp/arm/Remove(mob/living/carbon/M, special = 0)
	Retract()
	if(hand)
		UnregisterSignal(hand, COMSIG_ITEM_ATTACK_SELF)
	..()

/obj/item/organ/cyberimp/arm/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(prob(15/severity) && owner)
		to_chat(owner, "<span class='warning'>Электромагнитный импульс вызвал неисправность [src]!</span>")
		// give the owner an idea about why his implant is glitching
		Retract()

/obj/item/organ/cyberimp/arm/proc/Retract()
	if(!active_item || (active_item in src))
		return

	owner.visible_message("<span class='notice'>[owner] втягивает [active_item] обратно в [owner.ru_ego()] [zone == BODY_ZONE_R_ARM ? "правую" : "левую"] руку.</span>",
		"<span class='notice'>[capitalize(active_item)] возвращается в мою [zone == BODY_ZONE_R_ARM ? "правую" : "левую"] руку.</span>",
		"<span class='hear'>Слышу короткий механический шелчок.</span>")

	owner.transferItemToLoc(active_item, src, TRUE)
	UnregisterSignal(active_item, COMSIG_ITEM_DROPPED)
	active_item = null
	playsound(get_turf(owner), 'sound/mecha/mechmove03.ogg', 50, TRUE)

/obj/item/organ/cyberimp/arm/proc/Extend(obj/item/item)
	if(!(item in src))
		return

	active_item = item
	RegisterSignal(active_item, COMSIG_ITEM_DROPPED, .proc/Retract) //Drop it to put away.

	active_item.resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	active_item.slot_flags = null
	active_item.set_custom_materials(null)

	var/side = zone == BODY_ZONE_R_ARM? RIGHT_HANDS : LEFT_HANDS
	var/hand = owner.get_empty_held_index_for_side(side)
	if(hand)
		owner.put_in_hand(active_item, hand)
	else
		var/list/hand_items = owner.get_held_items_for_side(side, all = TRUE)
		var/success = FALSE
		var/list/failure_message = list()
		for(var/i in 1 to hand_items.len) //Can't just use *in* here.
			var/I = hand_items[i]
			if(!owner.dropItemToGround(I))
				failure_message += "<span class='warning'>Мой [I] мешает [src]!</span>"
				continue
			to_chat(owner, "<span class='notice'>Бросаю [I] чтобы активировать [src]!</span>")
			success = owner.put_in_hand(active_item, owner.get_empty_held_index_for_side(side))
			break
		if(!success)
			for(var/i in failure_message)
				to_chat(owner, i)
			return
	owner.visible_message("<span class='notice'>[owner] вытягивает [active_item] из [owner.ru_ego()] [zone == BODY_ZONE_R_ARM ? "правой" : "левой"] руки.</span>",
		"<span class='notice'>Вытягиваю [active_item] из моей [zone == BODY_ZONE_R_ARM ? "правой" : "левой"] руки.</span>",
		"<span class='hear'>Слышу короткий механический шелчок.</span>")
	playsound(get_turf(owner), 'sound/mecha/mechmove03.ogg', 50, TRUE)

/obj/item/organ/cyberimp/arm/ui_action_click()
	if((organ_flags & ORGAN_FAILING) || (!active_item && !contents.len))
		to_chat(owner, "<span class='warning'>Имплант не отвечает. Похоже что он сломался...</span>")
		return

	if(!active_item || (active_item in src))
		active_item = null
		if(contents.len == 1)
			Extend(contents[1])
		else
			var/list/choice_list = list()
			for(var/obj/item/I in items_list)
				choice_list[I] = image(I)
			var/obj/item/choice = show_radial_menu(owner, owner, choice_list)
			if(owner && owner == usr && owner.stat != DEAD && (src in owner.internal_organs) && !active_item && (choice in contents))
				// This monster sanity check is a nice example of how bad input is.
				Extend(choice)
	else
		Retract()


/obj/item/organ/cyberimp/arm/gun/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(prob(30/severity) && owner && !(organ_flags & ORGAN_FAILING))
		Retract()
		owner.visible_message("<span class='danger'> Из [owner] [zone == BODY_ZONE_R_ARM ? "правой" : "левой"] руки [owner] раздался громкий хлопок!</span>")
		playsound(get_turf(owner), 'sound/weapons/flashbang.ogg', 100, TRUE)
		to_chat(owner, "<span class='userdanger'>Чувствую взрыв в моей [zone == BODY_ZONE_R_ARM ? "правой" : "левой"] руке, сломался имплант!</span>")
		owner.adjust_fire_stacks(20)
		owner.IgniteMob()
		owner.adjustFireLoss(25)
		organ_flags |= ORGAN_FAILING


/obj/item/organ/cyberimp/arm/gun/laser
	name = "встроенный в руку лазерный имплант"
	desc = "Вариация импланта ручной пушки которая стреляет смертоносными лазернами лучами. Если не используется то пушка остается внутри руки, при стрельбе высовывается из неё."
	icon_state = "arm_laser"
	contents = newlist(/obj/item/gun/energy/laser/mounted)

/obj/item/organ/cyberimp/arm/gun/laser/l
	zone = BODY_ZONE_L_ARM

/obj/item/organ/cyberimp/arm/gun/laser/Initialize()
	. = ..()
	var/obj/item/organ/cyberimp/arm/gun/laser/laserphasergun = locate(/obj/item/gun/energy/laser/mounted) in contents
	laserphasergun.icon = icon //No invisible laser guns kthx
	laserphasergun.icon_state = icon_state

/obj/item/organ/cyberimp/arm/gun/taser
	name = "встроенный в руку тазер"
	desc = "Вариация импланта ручной пушки, которая стреляет электродами и вырубающими снарядами. Если не используется то пушка остается внутри руки, при стрельбе высовывается из неё."
	icon_state = "arm_taser"
	contents = newlist(/obj/item/gun/energy/e_gun/advtaser/mounted)

/obj/item/organ/cyberimp/arm/gun/taser/l
	zone = BODY_ZONE_L_ARM

/obj/item/organ/cyberimp/arm/toolset
	name = "Имплант встроенного набора инструментов"
	desc = "Урезанная версия набора инструментов инженерного киборга, сконструированная для установки в руку. Содержит улучшенные версии всех инструментов."
	contents = newlist(/obj/item/screwdriver/cyborg, /obj/item/wrench/cyborg, /obj/item/weldingtool/largetank/cyborg,
		/obj/item/crowbar/cyborg, /obj/item/wirecutters/cyborg, /obj/item/multitool/cyborg)

/obj/item/organ/cyberimp/arm/toolset/l
	zone = BODY_ZONE_L_ARM

/obj/item/organ/cyberimp/arm/toolset/emag_act(mob/user)
	if(!(locate(/obj/item/kitchen/knife/combat/cyborg) in items_list))
		to_chat(user, "<span class='notice'>Вы разблокировали интегрированный нож [src]!</span>")
		items_list += new /obj/item/kitchen/knife/combat/cyborg(src)
		return 1
	return 0

/obj/item/organ/cyberimp/arm/esword
	name = "встроенный в руку энергетический клинок"
	desc = "Незаконный и крайне опасный кибернетический имплант способный выпустить смертоносный клинок из концетрированной энергии."
	contents = newlist(/obj/item/melee/transforming/energy/blade/hardlight)

/obj/item/organ/cyberimp/arm/medibeam
	name = "встроенная медицинская лучевая пушка"
	desc = "Кибернетический имплант позволяющий пользователю излучать исцеляющие лучи из своей руки."
	contents = newlist(/obj/item/gun/medbeam)


/obj/item/organ/cyberimp/arm/flash
	name = "встроенный проектор фотонов высокой интенсивности" //Why not
	desc = "Встроенный в руку пользователя проектор способный создавать мощную вспышку."
	contents = newlist(/obj/item/assembly/flash/armimplant)

/obj/item/organ/cyberimp/arm/flash/Initialize()
	. = ..()
	if(locate(/obj/item/assembly/flash/armimplant) in items_list)
		var/obj/item/assembly/flash/armimplant/F = locate(/obj/item/assembly/flash/armimplant) in items_list
		F.I = src

/obj/item/organ/cyberimp/arm/flash/Extend()
	. = ..()
	active_item.set_light_range(7)
	active_item.set_light_on(TRUE)

/obj/item/organ/cyberimp/arm/flash/Retract()
	active_item.set_light_on(FALSE)
	return ..()

/obj/item/organ/cyberimp/arm/baton
	name = "имплант электрификации руки"
	desc = "Незаконный боевой имплант позволяющий пользователю контролировать обезвреживающие электричество из своей руки."
	contents = newlist(/obj/item/borg/stun)

/obj/item/organ/cyberimp/arm/combat
	name = "боевой кибернетический имплант"
	desc = "Мощный кибернетический имплант встроенный в руку пользователя и содержащий боевые модули."
	contents = newlist(/obj/item/melee/transforming/energy/blade/hardlight, /obj/item/gun/medbeam, /obj/item/borg/stun, /obj/item/assembly/flash/armimplant)

/obj/item/organ/cyberimp/arm/combat/Initialize()
	. = ..()
	if(locate(/obj/item/assembly/flash/armimplant) in items_list)
		var/obj/item/assembly/flash/armimplant/F = locate(/obj/item/assembly/flash/armimplant) in items_list
		F.I = src

/obj/item/organ/cyberimp/arm/surgery
	name = "имплант хирургических инструментов"
	desc = "Набор хирургических инструментов скрывающийся за скрытой панелью на руке пользователя."
	contents = newlist(/obj/item/retractor/augment, /obj/item/hemostat/augment, /obj/item/cautery/augment, /obj/item/surgicaldrill/augment, /obj/item/scalpel/augment, /obj/item/circular_saw/augment, /obj/item/surgical_drapes)

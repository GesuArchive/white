

//The robot bodyparts have been moved to code/module/surgery/bodyparts/robot_bodyparts.dm

/obj/item/robot_suit
	name = "эндоскелет киборга"
	desc = "Сложный металлический каркас со стандартными гнездами для конечностей и креплениями синтетических псевдо-мышц."
	icon = 'icons/mob/augmentation/augments.dmi'
	icon_state = "robo_suit"
	/// Left arm part of the endoskeleton
	var/obj/item/bodypart/l_arm/robot/l_arm = null
	/// Right arm part of the endoskeleton
	var/obj/item/bodypart/r_arm/robot/r_arm = null
	/// Left leg part of this endoskeleton
	var/obj/item/bodypart/l_leg/robot/l_leg = null
	/// Right leg part of this endoskeleton
	var/obj/item/bodypart/r_leg/robot/r_leg = null
	/// Chest part of this endoskeleton
	var/obj/item/bodypart/chest/robot/chest = null
	/// Head part of this endoskeleton
	var/obj/item/bodypart/head/robot/head = null
	/// Forced name of the cyborg
	var/created_name = ""
	/// Forced master AI of the cyborg
	var/mob/living/silicon/ai/forced_ai
	/// If the cyborg starts movement free and not under lockdown
	var/locomotion = TRUE
	/// If the cyborg synchronizes it's laws with it's master AI
	var/lawsync = TRUE
	/// If the cyborg starts with a master AI
	var/aisync = TRUE
	/// If the cyborg's cover panel starts locked
	var/panel_locked = TRUE

/obj/item/robot_suit/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/robot_suit/prebuilt/Initialize(mapload)
	. = ..()
	l_arm = new(src)
	r_arm = new(src)
	l_leg = new(src)
	r_leg = new(src)
	head = new(src)
	head.flash1 = new(head)
	head.flash2 = new(head)
	chest = new(src)
	chest.wired = TRUE
	chest.cell = new /obj/item/stock_parts/cell/high/plus(chest)
	update_icon()

/obj/item/robot_suit/update_overlays()
	. = ..()
	if(l_arm)
		. += "[l_arm.icon_state]+o"
	if(r_arm)
		. += "[r_arm.icon_state]+o"
	if(chest)
		. += "[chest.icon_state]+o"
	if(l_leg)
		. += "[l_leg.icon_state]+o"
	if(r_leg)
		. += "[r_leg.icon_state]+o"
	if(head)
		. += "[head.icon_state]+o"

/obj/item/robot_suit/proc/check_completion()
	if(l_arm && r_arm && l_leg && r_leg && head && head.flash1 && head.flash2 && chest && chest.wired && chest.cell)
		SSblackbox.record_feedback("amount", "cyborg_frames_built", 1)
		return TRUE
	return FALSE

/obj/item/robot_suit/wrench_act(mob/living/user, obj/item/I) //Deconstucts empty borg shell. Flashes remain unbroken because they haven't been used yet
	. = ..()
	var/turf/T = get_turf(src)
	if(l_leg || r_leg || chest || l_arm || r_arm || head)
		if(I.use_tool(src, user, 5, volume=50))
			if(l_leg)
				l_leg.forceMove(T)
				l_leg = null
			if(r_leg)
				r_leg.forceMove(T)
				r_leg = null
			if(chest)
				if (chest.cell) //Sanity check.
					chest.cell.forceMove(T)
					chest.cell = null
				chest.forceMove(T)
				new /obj/item/stack/cable_coil(T, 1)
				chest.wired = FALSE
				chest = null
			if(l_arm)
				l_arm.forceMove(T)
				l_arm = null
			if(r_arm)
				r_arm.forceMove(T)
				r_arm = null
			if(head)
				head.forceMove(T)
				head.flash1.forceMove(T)
				head.flash1 = null
				head.flash2.forceMove(T)
				head.flash2 = null
				head = null
			to_chat(user, span_notice("Разбираю киборга на части."))
	else
		to_chat(user, span_warning("На этом экзоскелете нет запчастей, которые можно снять!"))
	update_icon()

/obj/item/robot_suit/proc/put_in_hand_or_drop(mob/living/user, obj/item/I) //normal put_in_hands() drops the item ontop of the player, this drops it at the suit's loc
	if(!user.put_in_hands(I))
		I.forceMove(drop_location())
		return FALSE
	return TRUE

/obj/item/robot_suit/screwdriver_act(mob/living/user, obj/item/I) //Swaps the power cell if you're holding a new one in your other hand.
	. = ..()
	if(.)
		return TRUE

	if(!chest) //can't remove a cell if there's no chest to remove it from.
		to_chat(user, span_warning("[capitalize(src.name)] не имеет торса!"))
		return

	var/obj/item/stock_parts/cell/temp_cell = user.is_holding_item_of_type(/obj/item/stock_parts/cell)
	var/swap_failed
	if(!temp_cell) //if we're not holding a cell
		swap_failed = TRUE
	else if(!user.transferItemToLoc(temp_cell, chest))
		swap_failed = TRUE
		to_chat(user, span_warning("Что-то не получается установить [temp_cell] в [src]!"))

	if(chest.cell) //drop the chest's current cell no matter what.
		put_in_hand_or_drop(user, chest.cell)

	if(swap_failed) //we didn't transfer any new items.
		if(chest.cell) //old cell ejected, nothing inserted.
			to_chat(user, span_notice("Извлекаю [chest.cell] из [src]."))
			chest.cell = null
		else
			to_chat(user, span_warning("Батарея, установленная в торсе [src] разряжена!"))
		return

	to_chat(user, span_notice("[chest.cell ? "Меняю [src] [chest.cell.name] на [temp_cell]" : "Устанавливаю [temp_cell] в [src]"]."))
	chest.cell = temp_cell
	return TRUE

/obj/item/robot_suit/attackby(obj/item/W, mob/user, params)

	if(istype(W, /obj/item/stack/sheet/iron))
		var/obj/item/stack/sheet/iron/M = W
		if(!l_arm && !r_arm && !l_leg && !r_leg && !chest && !head)
			if (M.use(1))
				var/obj/item/bot_assembly/ed209/B = new
				B.forceMove(drop_location())
				to_chat(user, span_notice("Киборг готов."))
				var/holding_this = user.get_inactive_held_item()==src
				qdel(src)
				if (holding_this)
					user.put_in_inactive_hand(B)
			else
				to_chat(user, span_warning("Мне понадобится как минимум один лист железа, чтобы начать строить ED-209!"))
				return
	else if(istype(W, /obj/item/bodypart/l_leg/robot))
		if(l_leg)
			return
		if(!user.transferItemToLoc(W, src))
			return
		W.icon_state = initial(W.icon_state)
		W.cut_overlays()
		l_leg = W
		update_icon()

	else if(istype(W, /obj/item/bodypart/r_leg/robot))
		if(src.r_leg)
			return
		if(!user.transferItemToLoc(W, src))
			return
		W.icon_state = initial(W.icon_state)
		W.cut_overlays()
		r_leg = W
		update_icon()

	else if(istype(W, /obj/item/bodypart/l_arm/robot))
		if(l_arm)
			return
		if(!user.transferItemToLoc(W, src))
			return
		W.icon_state = initial(W.icon_state)
		W.cut_overlays()
		l_arm = W
		update_icon()

	else if(istype(W, /obj/item/bodypart/r_arm/robot))
		if(r_arm)
			return
		if(!user.transferItemToLoc(W, src))
			return
		W.icon_state = initial(W.icon_state)//in case it is a dismembered robotic limb
		W.cut_overlays()
		r_arm = W
		update_icon()

	else if(istype(W, /obj/item/bodypart/chest/robot))
		var/obj/item/bodypart/chest/robot/CH = W
		if(chest)
			return
		if(CH.wired && CH.cell)
			if(!user.transferItemToLoc(CH, src))
				return
			CH.icon_state = initial(CH.icon_state) //in case it is a dismembered robotic limb
			CH.cut_overlays()
			chest = CH
			update_icon()
		else if(!CH.wired)
			to_chat(user, span_warning("Сначала нужно смонтировать проводку!"))
		else
			to_chat(user, span_warning("Сначала нужно установить батарею!"))

	else if(istype(W, /obj/item/bodypart/head/robot))
		var/obj/item/bodypart/head/robot/HD = W
		for(var/X in HD.contents)
			if(istype(X, /obj/item/organ))
				to_chat(user, span_warning("Внутри [HD] что-то находится!"))
				return
		if(head)
			return
		if(HD.flash2 && HD.flash1)
			if(!user.transferItemToLoc(HD, src))
				return
			HD.icon_state = initial(HD.icon_state)//in case it is a dismembered robotic limb
			HD.cut_overlays()
			head = HD
			update_icon()
		else
			to_chat(user, span_warning("Нужно установить вспышки!"))

	else if (W.tool_behaviour == TOOL_MULTITOOL)
		if(check_completion())
			ui_interact(user)
		else
			to_chat(user, span_warning("Прежде чем проводить отладку, нужно закончить сборку киборга!"))

	else if(istype(W, /obj/item/mmi))
		var/obj/item/mmi/M = W
		if(check_completion())
			if(!chest.cell)
				to_chat(user, span_warning("Не хватает батареи!"))
				return
			if(!isturf(loc))
				to_chat(user, span_warning("Надо сначала поставить киборга на землю и уже потом устанавливать [M] внутрь!"))
				return
			if(!M.brain_check(user))
				return

			var/mob/living/brain/B = M.brainmob
			if(is_banned_from(B.ckey, JOB_CYBORG) || QDELETED(src) || QDELETED(B) || QDELETED(user) || QDELETED(M) || !Adjacent(user))
				if(!QDELETED(M))
					to_chat(user, span_warning("Кажется [M.name] не подходит для установки! Видимо сами цифровые боги против этого..."))
				return
			if(!user.temporarilyRemoveItemFromInventory(W))
				return

			var/mob/living/silicon/robot/O = new /mob/living/silicon/robot/nocell(get_turf(loc))
			if(!O)
				return
			if(M.laws && M.laws.id != DEFAULT_AI_LAWID)
				aisync = FALSE
				lawsync = FALSE
				O.laws = M.laws
				M.laws.associate(O)

			O.invisibility = 0
			//Transfer debug settings to new mob
			O.custom_name = created_name
			O.locked = panel_locked
			if(!aisync)
				lawsync = FALSE
				O.set_connected_ai(null)
			else
				O.notify_ai(NEW_BORG)
				if(forced_ai)
					O.set_connected_ai(forced_ai)
			if(!lawsync)
				O.lawupdate = FALSE
				if(M.laws.id == DEFAULT_AI_LAWID)
					O.make_laws()

			SSticker.mode.remove_antag_for_borging(B.mind)
			O.job = "Киборг"

			O.cell = chest.cell
			chest.cell.forceMove(O)
			chest.cell = null
			W.forceMove(O)//Should fix cybros run time erroring when blown up. It got deleted before, along with the frame.
			if(O.mmi) //we delete the mmi created by robot/New()
				qdel(O.mmi)
			O.mmi = W //and give the real mmi to the borg.

			O.updatename(B.client)

			B.mind.transfer_to(O)

			if(O.mind && O.mind.special_role)
				O.mind.store_memory("В роли киборга я должен следовать своим законам и приказам ИИ. Моя старая личность подавлена, я не помню ничего о прошлом себе, для всех окружающих прошлый я буду считаться мертвым.")
				to_chat(O, span_userdanger("Я стал киборгом!"))
				to_chat(O, span_danger("Я должны следовать своим законам и приказам ИИ. Моя старая личность подавлена, я не помню ничего о прошлом себе, для всех окружающих прошлый я буду считаться мертвым."))

			SSblackbox.record_feedback("amount", "cyborg_birth", 1)
			forceMove(O)
			O.robot_suit = src

			log_game("[key_name(user)] установил MMI/posibrain [key_name(M.brainmob)] в киборга в локации [AREACOORD(src)]")

			if(!locomotion)
				O.set_lockcharge(TRUE)
				to_chat(O, span_warning("Ошибка: сервоприводы не отвечают."))

		else
			to_chat(user, span_warning("MMI нужно устанавливать в самом конце!"))

	else if(istype(W, /obj/item/borg/upgrade/ai))
		var/obj/item/borg/upgrade/ai/M = W
		if(check_completion())
			if(!isturf(loc))
				to_chat(user, span_warning("Поставьте киборга на землю и установите [M] внутрь!"))
				return
			if(!user.temporarilyRemoveItemFromInventory(M))
				to_chat(user, span_warning("[M] прилип к моей руке!"))
				return
			qdel(M)
			var/mob/living/silicon/robot/O = new /mob/living/silicon/robot/shell(get_turf(src))

			if(!aisync)
				lawsync = FALSE
				O.set_connected_ai(null)
			else
				if(forced_ai)
					O.set_connected_ai(forced_ai)
				O.notify_ai(AI_SHELL)
			if(!lawsync)
				O.lawupdate = FALSE
				O.make_laws()

			O.cell = chest.cell
			chest.cell.forceMove(O)
			chest.cell = null
			O.locked = panel_locked
			O.job = JOB_CYBORG
			forceMove(O)
			O.robot_suit = src
			if(!locomotion)
				O.set_lockcharge(TRUE)

	else if(istype(W, /obj/item/pen))
		to_chat(user, span_warning("Мне нужен мультитул, для того чтобы переименовать [src]!"))
	else
		return ..()

/obj/item/robot_suit/ui_status(mob/user)
	if(isobserver(user))
		return ..()
	var/obj/item/held_item = user.get_active_held_item()
	if(held_item?.tool_behaviour == TOOL_MULTITOOL)
		return ..()
	to_chat(user, span_warning("Мне нужен мультитул, для того чтобы совершить отладку!"))
	return UI_CLOSE

/obj/item/robot_suit/ui_state(mob/user)
	return GLOB.physical_state

/obj/item/robot_suit/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CyborgBootDebug", "Производится отладка киборга")
		ui.open()

/obj/item/robot_suit/ui_data(mob/user)
	var/list/data = list()
	data["designation"] = created_name
	data["locomotion"] = locomotion
	data["panel"] = panel_locked
	data["aisync"] = aisync
	data["master"] = forced_ai ? forced_ai.name : null
	data["lawsync"] = lawsync
	return data

/obj/item/robot_suit/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	var/mob/living/user = usr

	switch(action)
		if("rename")
			var/new_name = reject_bad_name(html_encode(params["new_name"]), TRUE)
			if(!new_name)
				created_name = ""
				return
			created_name = new_name
			log_game("[key_name(user)] have set \"[new_name]\" as a cyborg shell name at [loc_name(user)]")
			return TRUE
		if("locomotion")
			locomotion = !locomotion
			return TRUE
		if("panel")
			panel_locked = !panel_locked
			return TRUE
		if("aisync")
			aisync = !aisync
			return TRUE
		if("set_ai")
			var/selected_ai = select_active_ai(user, z)
			if(!in_range(src, user) && loc != user)
				return
			if(!selected_ai)
				to_chat(user, span_alert("Не найдено активного ИИ."))
				return
			forced_ai = selected_ai
			return TRUE
		if("lawsync")
			lawsync = !lawsync
			return TRUE

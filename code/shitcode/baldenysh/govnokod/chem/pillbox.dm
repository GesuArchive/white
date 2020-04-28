/obj/item/storage/box/pillbox
	name = "Галоперидол"
	desc = "Разрушитель приколов."
	icon = 'code/shitcode/baldenysh/icons/obj/pillstorage.dmi'
	icon_state = "pillbox"
	item_state = "syringe_kit"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	illustration = "haloperidol"
	w_class = WEIGHT_CLASS_TINY
	var/blister_type = /obj/item/storage/blister
	//custom_price = 100

/obj/item/storage/box/pillbox/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 2
	STR.set_holdable(list(blister_type))

	STR.locked = TRUE

/obj/item/storage/box/pillbox/PopulateContents()
	SEND_SIGNAL(src, COMSIG_TRY_STORAGE_FILL_TYPE, blister_type)

/obj/item/storage/box/pillbox/attack_self(mob/user)
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	if(STR.locked)
		icon_state += "_open"
		user.visible_message("<span class='notice'>[user] открывает [src].</span>", "<span class='notice'>Ты открываешь [src].</span>")
		STR.locked = FALSE
		if(contents.len)
			return
	else
		icon_state = initial(icon_state)
		user.visible_message("<span class='notice'>[user] закрывает [src].</span>", "<span class='notice'>Ты закрываешь [src].</span>")
		STR.locked = TRUE
		return

	..()

/obj/item/storage/box/pillbox/hohlomicin
	name = "Хохломицин"
	desc = "Таблетки содержат правий сиктор."
	illustration = "hohlomicin"
	blister_type = /obj/item/storage/blister/long



/obj/item/storage/blister
	name = "блистерная упаковка (Галоперидол)"
	desc = "Прозрачная."
	icon = 'code/shitcode/baldenysh/icons/obj/pillstorage.dmi'
	icon_state = "foil"
	item_state = null
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY

	var/icon/base_icon = null

	var/pill_state = "round"
	var/pill_type = /obj/item/reagent_containers/pill/haloperidol
	var/max_pills = 5
	var/list/pill_pos_x = list(-4, -5, 3, 2, 10)
	var/list/pill_pos_y = list(-7, 1, 0, 8, 7)
	var/list/pill_list = list()

/obj/item/storage/blister/ComponentInitialize()
	. = ..()
	RegisterSignal(src, COMSIG_ATOM_EXITED, .proc/take_pill)

	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = max_pills
	STR.set_holdable(list(pill_type))
	STR.allow_quick_empty = FALSE
	STR.quickdraw = TRUE

/obj/item/storage/blister/PopulateContents()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)

	base_icon = icon(initial(icon), "foil")
	base_icon.Blend(icon(initial(icon), "plastic"), ICON_OVERLAY)

	for(var/i = 1 to STR.max_items)
		var/obj/item/reagent_containers/pill/P = new pill_type(src)
		pill_list.Add(P)
		base_icon.Blend(icon(P.icon, P.icon_state), ICON_OVERLAY, pill_pos_x[i], pill_pos_y[i])
		base_icon.Blend(icon(initial(icon), pill_state), ICON_OVERLAY, pill_pos_x[i], pill_pos_y[i])

	icon = fcopy_rsc(base_icon)

	STR.set_holdable(list())

/obj/item/storage/blister/proc/take_pill(datum/source, atom/movable/thing, atom/newLoc)
	var/pill_index = pill_list.Find(thing)

	if(!pill_index)
		return

	var/icon/pill_mask = icon(initial(icon), "white_mask")
	pill_mask.Blend(icon(initial(icon), pill_state+"_mask"), ICON_OVERLAY, pill_pos_x[pill_index], pill_pos_y[pill_index])
	pill_mask.BecomeAlphaMask()
	base_icon.AddAlphaMask(pill_mask)
	base_icon.Blend(icon(initial(icon), pill_state+"_broken"), ICON_OVERLAY, pill_pos_x[pill_index], pill_pos_y[pill_index])

	icon = fcopy_rsc(base_icon)

	pill_list.Remove(thing)
	pill_pos_x.Remove(pill_pos_x[pill_index])
	pill_pos_y.Remove(pill_pos_y[pill_index])

/obj/item/storage/blister/long
	name = "блистерная упаковка (Хохломицин)"
	pill_state = "long"
	pill_type = /obj/item/reagent_containers/pill/hohlomicin
	max_pills = 3
	pill_pos_x = list(-6, -1, 4)
	pill_pos_y = list(-4, 2, 8)


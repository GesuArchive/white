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
	custom_price = 200

/obj/item/storage/box/pillbox/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 2
	STR.set_holdable(list(/obj/item/storage/blister))
	STR.exception_hold = /obj/item/storage/blister

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
	blister_type = /obj/item/storage/blister/hohlomicin
	custom_price = 6666



/obj/item/storage/blister
	name = "блистерная упаковка (Галоперидол)"
	desc = "Прозрачная."
	icon = 'code/shitcode/baldenysh/icons/obj/pillstorage.dmi'
	icon_state = "foilplastic"
	item_state = null
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY

	var/list/pill_list = list(
								list(pilltype = /obj/item/reagent_containers/pill/haloperidol, pillstate = "round", posx = -4, posy = -7),
								list(pilltype = /obj/item/reagent_containers/pill/haloperidol, pillstate = "round", posx = -5, posy = 1),
								list(pilltype = /obj/item/reagent_containers/pill/haloperidol, pillstate = "round", posx = 3, posy = 0),
								list(pilltype = /obj/item/reagent_containers/pill/haloperidol, pillstate = "round", posx = 2, posy = 8),
								list(pilltype = /obj/item/reagent_containers/pill/haloperidol, pillstate = "round", posx = 10, posy = 7)
								)

/obj/item/storage/blister/ComponentInitialize()
	. = ..()

	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = pill_list.len
	STR.set_holdable(list(/obj/item/reagent_containers/pill))
	STR.allow_quick_empty = FALSE
	STR.quickdraw = TRUE

/obj/item/storage/blister/PopulateContents()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)

	for(var/i = 1 to STR.max_items)
		var/pill_type = pill_list[i]["pilltype"]
		pill_list[i]["pillobj"] = new pill_type(src)
		var/list/curitem = pill_list[i]
		var/obj/curobj = curitem["pillobj"]

		var/list/overlays = list()
		overlays.Add(image(icon = curobj.icon, icon_state = curobj.icon_state, pixel_x = curitem["posx"], pixel_y = curitem["posy"]))
		overlays.Add(image(icon = icon, icon_state = curitem["pillstate"], pixel_x = curitem["posx"], pixel_y = curitem["posy"]))

		pill_list[i]["overlays"] = overlays

		add_overlay(overlays)

	STR.max_items = 0
	STR.set_holdable(list())

/obj/item/storage/blister/Exited(atom/movable/thing, atom/newLoc)
	..()

	var/list/curitem = null
	for(var/list/L in pill_list)
		if(L["pillobj"] == thing)
			curitem = L
			break

	if(!curitem)
		return

	cut_overlay(curitem["overlays"])

	var/list/overlays_broken = list()
	overlays_broken.Add(image(icon = initial(icon), icon_state = "foil_broken", pixel_x = curitem["posx"], pixel_y = curitem["posy"]))
	overlays_broken.Add(image(icon = initial(icon), icon_state = curitem["pillstate"]+"_broken", pixel_x = curitem["posx"], pixel_y = curitem["posy"]))

	add_overlay(overlays_broken)

	pill_list.Remove(curitem)


/obj/item/storage/blister/hohlomicin
	name = "блистерная упаковка (Хохломицин)"
	pill_list = list(
					list(pilltype = /obj/item/reagent_containers/pill/hohlomicin, pillstate = "long", posx = -6, posy = -4),
					list(pilltype = /obj/item/reagent_containers/pill/hohlomicin, pillstate = "long", posx = -1, posy = 2),
					list(pilltype = /obj/item/reagent_containers/pill/hohlomicin, pillstate = "long", posx = 4, posy = 8)
					)

/obj/item/storage/box/pillbox
	name = "хохломицин"
	desc = "Ну хохломицин и хохломицин."
	icon = 'code/shitcode/baldenysh/icons/obj/pillstorage.dmi'
	icon_state = "pillbox"
	item_state = "syringe_kit"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	illustration = "hohlomicin"
	w_class = WEIGHT_CLASS_TINY
	custom_price = 100
	foldable = FALSE
	var/pill_type = /obj/item/reagent_containers/pill/hohlomicin
	var/pill_amount = 6

/obj/item/storage/box/pillbox/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = pill_amount
	STR.set_holdable(list(pill_type))
	STR.attack_hand_interact = FALSE
	STR.locked = TRUE

/obj/item/storage/box/pillbox/PopulateContents()
	SEND_SIGNAL(src, COMSIG_TRY_STORAGE_FILL_TYPE, pill_type)

/obj/item/storage/box/pillbox/attack_self(mob/user)
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	if(STR.locked)
		icon_state += "_open"
		user.visible_message("<span class='notice'>[user] открывает пачку [src]а.</span>", "<span class='notice'>Ты открываешь  пачку [src]а.</span>")
		STR.locked = FALSE
	else
		icon_state = initial(icon_state)
		user.visible_message("<span class='notice'>[user] закрывает пачку [src]а.</span>", "<span class='notice'>Ты закрываешь пачку [src]а.</span>")
		STR.locked = TRUE
		return

	..()

/obj/item/storage/box/pillbox/attackby(obj/O, mob/user, params)
	if(istype(O, pill_type))
		to_chat(user, "<span class='warning'>Бесполезно. Блистер уже вскрыт, данное действие не имеет смысла.</span>")
		return

	..()

/obj/item/storage/box/pillbox/haloperidol
	name = "галоперидол"
	desc = "Удаление прикола."
	illustration = "haloperidol"
	pill_type = /obj/item/reagent_containers/pill/haloperidol
	pill_amount = 10

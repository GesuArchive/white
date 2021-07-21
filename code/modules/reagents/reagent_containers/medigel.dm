/obj/item/reagent_containers/medigel
	name = "medical gel"
	desc = "A medical gel applicator bottle, designed for precision application, with an unscrewable cap."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "medigel"
	inhand_icon_state = "spraycan"
	worn_icon_state = "spraycan"
	lefthand_file = 'icons/mob/inhands/equipment/hydroponics_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/hydroponics_righthand.dmi'
	item_flags = NOBLUDGEON
	obj_flags = UNIQUE_RENAME
	reagent_flags = OPENCONTAINER
	slot_flags = ITEM_SLOT_BELT
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 7
	amount_per_transfer_from_this = 10
	volume = 60
	var/can_fill_from_container = TRUE
	var/apply_type = PATCH
	var/apply_method = "распылить" //the thick gel is sprayed and then dries into patch like film.
	var/self_delay = 30
	var/squirt_mode = 0
	var/squirt_amount = 5
	custom_price = PAYCHECK_MEDIUM * 2
	unique_reskin = list(
		"Blue" = "medigel_blue",
		"Cyan" = "medigel_cyan",
		"Green" = "medigel_green",
		"Red" = "medigel_red",
		"Orange" = "medigel_orange",
		"Purple" = "medigel_purple"
	)

/obj/item/reagent_containers/medigel/attack_self(mob/user)
	squirt_mode = !squirt_mode
	if(squirt_mode)
		amount_per_transfer_from_this = squirt_amount
	else
		amount_per_transfer_from_this = initial(amount_per_transfer_from_this)
	to_chat(user, "<span class='notice'>Буду применять содержимое в [squirt_mode ? "коротком":"длинном"] режиме. Теперь используется [amount_per_transfer_from_this] единиц за раз.</span>")

/obj/item/reagent_containers/medigel/attack(mob/M, mob/user, def_zone)
	if(!reagents || !reagents.total_volume)
		to_chat(user, "<span class='warning'>[capitalize(src.name)] is empty!</span>")
		return

	if(M == user)
		M.visible_message("<span class='notice'>[user] пытается [apply_method] [src] на [user.ru_na()].</span>")
		if(self_delay)
			if(!do_mob(user, M, self_delay))
				return
			if(!reagents || !reagents.total_volume)
				return
		to_chat(M, "<span class='notice'>Пытаюсь [apply_method] [src] на себя.</span>")

	else
		log_combat(user, M, "attempted to apply", src, reagents.log_list())
		M.visible_message("<span class='danger'>[user] пытается [apply_method] [src] на [M].</span>", \
							"<span class='userdanger'>[user] пытается [apply_method] [src] на меня.</span>")
		if(!do_mob(user, M, CHEM_INTERACT_DELAY(3 SECONDS, user)))
			return
		if(!reagents || !reagents.total_volume)
			return
		M.visible_message("<span class='danger'>[user] применяет [M] [src].</span>", \
							"<span class='userdanger'>[user] применяет на мне [src].</span>")

	if(!reagents || !reagents.total_volume)
		return

	else
		log_combat(user, M, "applied", src, reagents.log_list())
		playsound(src, 'sound/effects/spray.ogg', 30, TRUE, -6)
		reagents.trans_to(M, amount_per_transfer_from_this, transfered_by = user, methods = apply_type)
	return

/obj/item/reagent_containers/medigel/libital
	name = "medical gel (libital)"
	desc = "A medical gel applicator bottle, designed for precision application, with an unscrewable cap. This one contains libital, for treating cuts and bruises. Libital does minor liver damage. Diluted with granibitaluri."
	icon_state = "brutegel"
	current_skin = "brutegel"
	list_reagents = list(/datum/reagent/medicine/c2/libital = 24, /datum/reagent/medicine/granibitaluri = 36)

/obj/item/reagent_containers/medigel/aiuri
	name = "medical gel (aiuri)"
	desc = "A medical gel applicator bottle, designed for precision application, with an unscrewable cap. This one contains aiuri, useful for treating burns. Aiuri does minor eye damage. Diluted with granibitaluri."
	icon_state = "burngel"
	current_skin = "burngel"
	list_reagents = list(/datum/reagent/medicine/c2/aiuri = 24, /datum/reagent/medicine/granibitaluri = 36)

/obj/item/reagent_containers/medigel/synthflesh
	name = "medical gel (synthflesh)"
	desc = "A medical gel applicator bottle, designed for precision application, with an unscrewable cap. This one contains synthflesh, a slightly toxic medicine capable of healing both bruises and burns."
	icon_state = "synthgel"
	current_skin = "synthgel"
	list_reagents = list(/datum/reagent/medicine/c2/synthflesh = 60)
	custom_price = PAYCHECK_MEDIUM * 5

/obj/item/reagent_containers/medigel/sterilizine
	name = "sterilizer gel"
	desc = "gel bottle loaded with non-toxic sterilizer. Useful in preparation for surgery."
	icon_state = "medigel_blue"
	current_skin = "medigel_blue"
	list_reagents = list(/datum/reagent/space_cleaner/sterilizine = 60)
	custom_price = PAYCHECK_MEDIUM * 2

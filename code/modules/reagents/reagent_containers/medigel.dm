/obj/item/reagent_containers/medigel
	name = "медицинский аэрозоль"
	desc = "Аппликатор спроектированный для быстрого и точечного нанесения лекарственного состава в виде аэрозоля."
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
	to_chat(user, span_notice("Буду применять содержимое в [squirt_mode ? "коротком":"длинном"] режиме. Теперь используется [amount_per_transfer_from_this] единиц за раз."))

/obj/item/reagent_containers/medigel/attack(mob/M, mob/user, def_zone)
	if(!reagents || !reagents.total_volume)
		to_chat(user, span_warning("[capitalize(src.name)] is empty!"))
		return

	if(M == user)
		M.visible_message(span_notice("[user] пытается [apply_method] [src] на [user.ru_na()]."))
		if(self_delay)
			if(!do_mob(user, M, self_delay))
				return
			if(!reagents || !reagents.total_volume)
				return
		to_chat(M, span_notice("Пытаюсь [apply_method] [src] на себя."))

	else
		log_combat(user, M, "attempted to apply", src, reagents.log_list())
		M.visible_message(span_danger("[user] пытается [apply_method] [src] на [M].") , \
							span_userdanger("[user] пытается [apply_method] [src] на меня."))
		if(!do_mob(user, M, CHEM_INTERACT_DELAY(3 SECONDS, user)))
			return
		if(!reagents || !reagents.total_volume)
			return
		M.visible_message(span_danger("[user] применяет [M] [src].") , \
							span_userdanger("[user] применяет на мне [src]."))

	if(!reagents || !reagents.total_volume)
		return

	else
		log_combat(user, M, "applied", src, reagents.log_list())
		playsound(src, 'sound/effects/spray.ogg', 30, TRUE, -6)
		reagents.trans_to(M, amount_per_transfer_from_this, transfered_by = user, methods = apply_type)
	return

/obj/item/reagent_containers/medigel/libital
	name = "Медицинский аэрозоль (Либитал)"
	desc = "Аппликатор спроектированный для быстрого и точечного нанесения лекарственного состава в виде аэрозоля. Содержит Либитал - вещество для лечения физических повреждений. Наносит небольшой урон печени. Разбавлен Гранибиталирином."
	icon_state = "brutegel"
	current_skin = "brutegel"
	list_reagents = list(/datum/reagent/medicine/c2/libital/pure = 30, /datum/reagent/medicine/granibitaluri = 30)

/obj/item/reagent_containers/medigel/aiuri
	name = "Медицинский аэрозоль (Лентури)"
	desc = "Аппликатор спроектированный для быстрого и точечного нанесения лекарственного состава в виде аэрозоля. Содержит Лентури - вещество для лечения ожоговых повреждений. Наносит небольшой урон желудку. Разбавлен Гранибиталирином."
	icon_state = "burngel"
	current_skin = "burngel"
	list_reagents = list(/datum/reagent/medicine/c2/lenturi/pure = 30, /datum/reagent/medicine/granibitaluri = 30)

/obj/item/reagent_containers/medigel/synthflesh
	name = "Медицинский аэрозоль (Синтеплоть)"
	desc = "Аппликатор спроектированный для быстрого и точечного нанесения лекарственного состава в виде аэрозоля. Содержит Синтеплоть - вещество для лечения физических и ожоговых повреждений. Токсична и вызывает отравление. Восстанавливает тело после получения ожогов высшей степени тяжести."
	icon_state = "synthgel"
	current_skin = "synthgel"
	list_reagents = list(/datum/reagent/medicine/c2/synthflesh = 60)
	custom_price = PAYCHECK_MEDIUM * 5

/obj/item/reagent_containers/medigel/sterilizine
	name = "Стерилизационный аэрозоль"
	desc = "Аппликатор спроектированный для быстрого и точечного нанесения лекарственного состава в виде аэрозоля. Содержит стерилизатор для повышения шанса успеха и скорости хирургических операций."
	icon_state = "medigel_blue"
	current_skin = "medigel_blue"
	list_reagents = list(/datum/reagent/space_cleaner/sterilizine = 60)
	custom_price = PAYCHECK_MEDIUM * 2

/obj/item/reagent_containers/medigel/multiver
	name = "Мультивер в аэрозоли"
	desc = "Аппликатор спроектированный для быстрого и точечного нанесения лекарственного состава в виде аэрозоля. Выводит из крови химические вещества и нейтрализует токсины. Эффективность растет по мере того, как увеличвается количество нейтрализуемых вещество. Вызывает средние повреждения легких."
	icon_state = "medigel"
	current_skin = "medigel"
	list_reagents = list(/datum/reagent/medicine/c2/multiver = 60)
	custom_price = PAYCHECK_MEDIUM * 2

/obj/item/reagent_containers/medigel/epinephrine
	name = "Адреналин в аэрозоли"
	desc = "Аппликатор спроектированный для быстрого и точечного нанесения лекарственного состава в виде аэрозоля. Стабилизирует пациентов находящихся в критическом состоянии, нейтрализует удушье и мобилизует организм к восстановлению при тяжелых повреждениях. Очень незначительно повышает скорость и стойкость к оглушению. Передозировка вызывает слабость и повреждение токсинами."
	icon_state = "medigel_cyan"
	current_skin = "medigel_cyan"
	list_reagents = list(/datum/reagent/medicine/epinephrine = 60)
	custom_price = PAYCHECK_MEDIUM * 2
/obj/item/reagent_containers/medigel/formaldehyde
	name = "Формальдегид в аэрозоли"
	desc = "Аппликатор спроектированный для быстрого и точечного нанесения лекарственного состава в виде аэрозоля. Формальдегид, сам по себе, крайне слабый токсин. Полностью останавливает разложение в трупах. В нем есть следы Гистомина, отчего он очень редко распадается на этот самый Гистомин."
	icon_state = "medigel_purple"
	current_skin = "medigel_purple"
	list_reagents = list(/datum/reagent/toxin/formaldehyde = 60)
	custom_price = PAYCHECK_MEDIUM * 2

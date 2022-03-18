//Переноска для Медботов

#define ismedbot(A) (istype(A, /mob/living/simple_animal/bot/medbot))

/obj/item/medbot_carrier
	name = "Переноска для медботов"
	desc = "Набор специальных ремней для комфортной транспортировки медицинских ботов на спине. Крепления подходят к медицинской верхней одежде. При экипированном медботе невозможно убрать в сумку. Медбот не может лечить пока сидит в переноске."
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BACK
	icon = 'white/Feline/icons/medbot_carrier.dmi'
	icon_state = "medbot_carrier_empty"
	worn_icon = 'white/Feline/icons/medbot_carrier_back.dmi'
	worn_icon_state = "carrier_empty"

/obj/item/medbot_carrier/attack(mob/living/M, mob/user, params)
	var/mob/living/simple_animal/bot/medbot/bot = M
	if(length(contents))
		to_chat(user, span_warning("Переноска уже занята."))
		return
	if(!ismedbot(M))
		to_chat(user, span_warning("В переноску можно поместить только медицинских ботов!"))
		return
	to_chat(user, span_notice("Помещаю [M] в переноску, он довольно виляет лапками."))
	store(M)
	if(bot.damagetype_healer == "all")
		icon_state = "medbot_carrier_all"
	if(bot.damagetype_healer == "brute")
		icon_state = "medbot_carrier_brute"
	if(bot.damagetype_healer == "burn")
		icon_state = "medbot_carrier_burn"
	if(bot.damagetype_healer == "toxin")
		icon_state = "medbot_carrier_toxin"
	if(bot.damagetype_healer == "oxygen")
		icon_state = "medbot_carrier_oxygen"
	w_class = WEIGHT_CLASS_BULKY
	worn_icon_state = "carrier_full"

/obj/item/medbot_carrier/attack_self(mob/user)
	if(contents.len)
		to_chat(user, span_notice("Выпускаю медбота на пол"))
		release()
		icon_state = "medbot_carrier_empty"
		w_class = WEIGHT_CLASS_NORMAL
		worn_icon_state = "carrier_empty"
	else
		to_chat(user, span_warning("В переноске ничего нет..."))

/obj/item/medbot_carrier/proc/store(mob/living/M)
	M.forceMove(src)

/obj/item/medbot_carrier/proc/release()
	for(var/atom/movable/M in contents)
		M.forceMove(get_turf(loc))

//Мед пояс для ЕРТ

/obj/item/storage/belt/medical/ert

/obj/item/storage/belt/medical/ert/PopulateContents()
	new /obj/item/surgical_drapes(src)
	new /obj/item/scalpel/advanced(src)
	new /obj/item/retractor/advanced(src)
	new /obj/item/cautery/advanced(src)
	new /obj/item/bonesetter/advanced(src)
	new /obj/item/healthanalyzer/advanced(src)

/obj/item/reagent_containers/medigel/sal_acid_oxandrolone
	name = "Оксандролон и Салицил"
	desc = "Аппликатор спроектированный для быстрого и точечного нанесения лекарственного состава в виде аэрозоля. Содержит Оксандролон и Салициловую кислоту - вещеста для лечения тяжелых физических и ожоговых повреждений. Крайне не эффективны при низких уровнях повреждений. Передозировка 25 единиц. Без побочных эффектов."
	icon = 'white/Feline/icons/med_items.dmi'
	icon_state = "medigel_red_orange"
	current_skin = "medigel_red_orange"
	list_reagents = list(/datum/reagent/medicine/sal_acid = 30, /datum/reagent/medicine/oxandrolone = 30)

/obj/item/reagent_containers/medigel/pen_acid
	name = "Пентетовая кислота"
	desc = "Аппликатор спроектированный для быстрого и точечного нанесения лекарственного состава в виде аэрозоля. Содержит Пентетовую кислоту - вещество для вывода токсинов, радиации и химикатов из крови. Без побочных эффектов."
	icon_state = "medigel_green"
	current_skin = "medigel_green"
	list_reagents = list(/datum/reagent/medicine/pen_acid = 60)

/obj/item/storage/pill_bottle/big
	name = "Большая баночка для таблеток"
	desc = "Вмещает в себя много пилюлек и таблеток."
	icon = 'white/Feline/icons/med_items.dmi'
	icon_state = "pill_bottle_big"

/obj/item/storage/pill_bottle/big/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.allow_quick_gather = TRUE
	STR.click_gather = TRUE
	STR.display_numerical_stacking = TRUE
	STR.max_items = 20
	STR.max_combined_w_class = 40
	STR.set_holdable(list(/obj/item/reagent_containers/pill, /obj/item/dice))


// Пенал для медипенов

/obj/item/storage/belt/medipenal
	name = "пенал для медипенов"
	desc = "Компактный и очень удобный пенал вмещающий до 5 медипенов, специальная клипса позволяет закрепить его на карманах или поясе, а с его маленькими габаритами он поместится в коробке или аптечке."
	icon = 'white/Feline/icons/medipenal.dmi'
	icon_state = "penal"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_SMALL
	max_integrity = 300
	equip_sound = 'sound/items/equip/toolbelt_equip.ogg'

/obj/item/storage/belt/medipenal/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 5
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.pocket_belt = TRUE
	STR.max_combined_w_class = 10
	STR.set_holdable(list(
		/obj/item/reagent_containers/hypospray/medipen,
		/obj/item/reagent_containers/syringe
		))

/obj/item/storage/belt/medipenal/update_icon_state()
	icon_state = initial(icon_state)
	worn_icon_state = initial(worn_icon_state)
	if(length(contents))
		icon_state = "penal[length(contents)]"

/obj/item/storage/belt/medipenal/rangers	//	Рейнджер медик

/obj/item/storage/belt/medipenal/rangers/PopulateContents()
	new /obj/item/reagent_containers/hypospray/medipen/salacid(src)
	new /obj/item/reagent_containers/hypospray/medipen/penacid(src)
	new /obj/item/reagent_containers/hypospray/medipen/sputnik_lite(src)
	new /obj/item/reagent_containers/hypospray/medipen/sputnik_lite(src)

/obj/item/storage/belt/medipenal/field_med	//	Полевой медик

/obj/item/storage/belt/medipenal/field_med/PopulateContents()
	new /obj/item/reagent_containers/hypospray/medipen/salacid(src)
	new /obj/item/reagent_containers/hypospray/medipen/salacid(src)
	new /obj/item/reagent_containers/hypospray/medipen/oxandrolone(src)
	new /obj/item/reagent_containers/hypospray/medipen/penacid(src)

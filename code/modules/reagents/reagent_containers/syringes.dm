/obj/item/reagent_containers/syringe
	name = "шприц"
	desc = "Может содержать 15 единиц."
	icon = 'icons/obj/syringe.dmi'
	inhand_icon_state = "syringe_0"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	icon_state = "0"
	worn_icon_state = "pen"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list()
	volume = 15
	var/mode = SYRINGE_DRAW
	var/busy = FALSE		// needed for delayed drawing of blood
	var/proj_piercing = 0 //does it pierce through thick clothes when shot with syringe gun
	custom_materials = list(/datum/material/iron=10, /datum/material/glass=20)
	embedding = list()
	reagent_flags = TRANSPARENT
	custom_price = PAYCHECK_EASY * 0.5
	sharpness = SHARP_POINTY
	hitsound = 'sound/weapons/stab1.ogg'

/obj/item/reagent_containers/syringe/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/caltrop, min_damage = 5)
	if(list_reagents) //syringe starts in inject mode if its already got something inside
		mode = SYRINGE_INJECT
		update_icon()

/obj/item/reagent_containers/syringe/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/reagent_containers/syringe/pickup(mob/user)
	..()
	update_icon()

/obj/item/reagent_containers/syringe/dropped(mob/user)
	..()
	update_icon()

/obj/item/reagent_containers/syringe/attack_self(mob/user)
	mode = !mode
	update_icon()

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/item/reagent_containers/syringe/attack_hand()
	. = ..()
	update_icon()

/obj/item/reagent_containers/syringe/attack_paw(mob/user)
	return attack_hand(user)

/obj/item/reagent_containers/syringe/attackby(obj/item/I, mob/user, params)
	return

/obj/item/reagent_containers/syringe/afterattack(atom/target, mob/user , proximity)
	. = ..()
	if(busy)
		return
	if(!proximity)
		return
	if(!target.reagents)
		return

	var/mob/living/L
	if(isliving(target))
		L = target
		if(!L.can_inject(user, 1))
			return

	// chance of monkey retaliation
	SEND_SIGNAL(target, COMSIG_LIVING_TRY_SYRINGE, user)

	switch(mode)
		if(SYRINGE_DRAW)

			if(reagents.total_volume >= reagents.maximum_volume)
				to_chat(user, span_notice("Шприц полон."))
				return

			if(L) //living mob
				var/drawn_amount = reagents.maximum_volume - reagents.total_volume
				if(target != user)
					target.visible_message(span_danger("<b>[user]</b> пытается взять кровь у <b>[target]</b>!") , \
									span_userdanger("<b>[user]</b> пытается взять кровь у меня!"))
					busy = TRUE
					if(!do_mob(user, target, extra_checks=CALLBACK(L, /mob/living/proc/can_inject, user, TRUE)))
						busy = FALSE
						return
					if(reagents.total_volume >= reagents.maximum_volume)
						return
				busy = FALSE
				if(L.transfer_blood_to(src, drawn_amount))
					user.visible_message(span_notice("<b>[user]</b> берёт кровь у <b>[L]</b>."))
				else
					to_chat(user, span_warning("Не могу взять кровь у <b>[L]</b>!"))

			else //if not mob
				if(!target.reagents.total_volume)
					to_chat(user, span_warning("<b>[target]</b> пустая!"))
					return

				if(!target.is_drawable(user))
					to_chat(user, span_warning("Из <b>[target]</b> не получится изъять что-то!"))
					return

				var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this, transfered_by = user) // transfer from, transfer to - who cares?

				to_chat(user, span_notice("Наполняю <b>[src]</b> [trans] единицами раствора. Теперь он содержит [reagents.total_volume] единиц."))
			if (reagents.total_volume >= reagents.maximum_volume)
				mode=!mode
				update_icon()

		if(SYRINGE_INJECT)
			// Always log attemped injections for admins
			var/contained = reagents.log_list()
			log_combat(user, target, "attempted to inject", src, addition="which had [contained]")

			if(!reagents.total_volume)
				to_chat(user, span_warning("<b>[capitalize(src.name)]</b> пуст!"))
				return

			if(!L && !target.is_injectable(user)) //only checks on non-living mobs, due to how can_inject() handles
				to_chat(user, span_warning("Не могу напрямую заполнить <b>[target]</b>!"))
				return

			if(target.reagents.total_volume >= target.reagents.maximum_volume)
				to_chat(user, span_notice("<b>[target]</b> полная."))
				return

			if(L) //living mob
				if(!L.can_inject(user, TRUE))
					return
				if(L != user)
					L.visible_message(span_danger("<b>[user]</b> пытается ввести что-то в <b>[L]</b>!") , \
											span_userdanger("<b>[user]</b> пытается ввести что-то в меня!"))
					if(!do_mob(user, L, extra_checks=CALLBACK(L, /mob/living/proc/can_inject, user, TRUE)))
						return
					if(!reagents.total_volume)
						return
					if(L.reagents.total_volume >= L.reagents.maximum_volume)
						return
					L.visible_message(span_danger("<b>[user]</b> вводит что-то в <b>[L]</b> шприцом!") , \
									span_userdanger("<b>[user]</b> вводит в меня что-то шприцом!"))

				if(L != user)
					log_combat(user, L, "injected", src, addition="which had [contained]")
				else
					L.log_message("injected themselves ([contained]) with [src.name]", LOG_ATTACK, color="orange")
			reagents.trans_to(target, amount_per_transfer_from_this, transfered_by = user, methods = INJECT)
			to_chat(user, span_notice("Ввожу [amount_per_transfer_from_this] единиц раствора. Шприц теперь содержит [reagents.total_volume] единиц."))
			if (reagents.total_volume <= 0 && mode==SYRINGE_INJECT)
				mode = SYRINGE_DRAW
				update_icon()

/*
 * On accidental consumption, inject the eater with 2/3rd of the syringe and reveal it
 */
/obj/item/reagent_containers/syringe/on_accidental_consumption(mob/living/carbon/victim, mob/living/carbon/user, obj/item/source_item,  discover_after = TRUE)
	if(source_item)
		to_chat(victim, span_boldwarning("Здесь [name] в [source_item]!!"))
	else
		to_chat(victim, span_boldwarning("[capitalize(name)] входит в меня!"))

	victim.apply_damage(5, BRUTE, BODY_ZONE_HEAD)
	reagents?.trans_to(victim, round(reagents.total_volume*(2/3)), transfered_by = user, methods = INJECT)

	return discover_after

/obj/item/reagent_containers/syringe/update_icon_state()
	. = ..()
	var/rounded_vol = get_rounded_vol()
	icon_state = "[rounded_vol]"
	inhand_icon_state = "syringe_[rounded_vol]"

/obj/item/reagent_containers/syringe/update_overlays()
	. = ..()
	var/rounded_vol = get_rounded_vol()
	if(reagents?.total_volume)
		var/mutable_appearance/filling_overlay = mutable_appearance('icons/obj/reagentfillings.dmi', "syringe[rounded_vol]")
		filling_overlay.color = mix_color_from_reagents(reagents.reagent_list)
		. += filling_overlay
	if(ismob(loc))
		var/injoverlay
		switch(mode)
			if (SYRINGE_DRAW)
				injoverlay = "draw"
			if (SYRINGE_INJECT)
				injoverlay = "inject"
		. += injoverlay

/obj/item/reagent_containers/syringe/bluespace/update_overlays()
	. = ..()
	var/mutable_appearance/animation_overlay = mutable_appearance('white/Feline/icons/syringe_bluespace.dmi', "animation")
	. += animation_overlay

///Used by update_icon() and update_overlays()
/obj/item/reagent_containers/syringe/proc/get_rounded_vol()
	if(reagents?.total_volume)
		return clamp(round((reagents.total_volume / volume * 15),5), 1, 15)
	else
		return 0

/obj/item/reagent_containers/syringe/epinephrine
	name = "шприц с адреналином"
	desc = "Cодержит <b>Адреналин</b> - используется для стабилизации пациентов."
	list_reagents = list(/datum/reagent/medicine/epinephrine = 15)

/obj/item/reagent_containers/syringe/multiver
	name = "шприц с мультивером"
	desc = "Cодержит <b>мультивер</b>."
	list_reagents = list(/datum/reagent/medicine/c2/multiver = 15)

/obj/item/reagent_containers/syringe/convermol
	name = "шприц с конвермолом"
	desc = "Cодержит <b>конвермол</b>."
	list_reagents = list(/datum/reagent/medicine/c2/convermol = 15)

/obj/item/reagent_containers/syringe/antiviral
	name = "шприц с космоцилином"
	desc = "Cодержит <b>антивирусы</b>."
	list_reagents = list(/datum/reagent/medicine/spaceacillin = 15)

/obj/item/reagent_containers/syringe/seiver_cold
	name = "шприц с охлажденным сейвером"
	desc = "Cодержит <b>охлажденный сейвер</b>. Применяется для выведения радиоактивного заражения."
	list_reagents = list(/datum/reagent/medicine/c2/seiver/cold = 15)

/obj/item/reagent_containers/syringe/seiver_hot
	name = "шприц с нагретым сейвером"
	desc = "Cодержит <b>нагретый сейвер</b>. Применяется для выведения токсинов."
	list_reagents = list(/datum/reagent/medicine/c2/seiver/hot = 15)

/obj/item/reagent_containers/syringe/leporazine
	name = "шприц с лепоразином"
	desc = "Cодержит <b>лепоразин</b>. Применяется для стабилизации температуры."
	list_reagents = list(/datum/reagent/medicine/leporazine = 15)

/obj/item/reagent_containers/syringe/bioterror
	name = "шприц биотеррора"
	desc = "Cодержит <b>различные отравляющие вещества</b>."
	list_reagents = list(/datum/reagent/consumable/ethanol/neurotoxin = 5, /datum/reagent/toxin/mutetoxin = 5, /datum/reagent/toxin/sodium_thiopental = 5)

/obj/item/reagent_containers/syringe/calomel
	name = "шприц с каломелом"
	desc = "Cодержит <b>каломел</b>."
	list_reagents = list(/datum/reagent/medicine/calomel = 15)

/obj/item/reagent_containers/syringe/plasma
	name = "шприц с плазмой"
	desc = "Cодержит <b>плазму</b>."
	list_reagents = list(/datum/reagent/toxin/plasma = 15)

/obj/item/reagent_containers/syringe/lethal
	name = "летальная инъекция"
	desc = "Шприц с летальной инъекцией. Может хранить до 50 единиц."
	amount_per_transfer_from_this = 50
	volume = 50

/obj/item/reagent_containers/syringe/lethal/choral
	name = "летальная инъекция - безболезненная"
	list_reagents = list(/datum/reagent/toxin/chloralhydrate = 50)

/obj/item/reagent_containers/syringe/lethal/execution
	name = "летальная инъекция - пыточная"
	list_reagents = list(/datum/reagent/toxin/plasma = 15, /datum/reagent/toxin/formaldehyde = 15, /datum/reagent/toxin/cyanide = 10, /datum/reagent/toxin/acid/fluacid = 10)

/obj/item/reagent_containers/syringe/mulligan
	name = "Миксоген"
	desc = "Шприц со случайным набором геномов. Изменяет внешность до неузнаваемости."
	amount_per_transfer_from_this = 1
	volume = 1
	list_reagents = list(/datum/reagent/mulligan = 1)

/obj/item/reagent_containers/syringe/gluttony
	name = "благословение обжорства"
	desc = "Шприц из довольно ужасного места. Лучше не вкалывать себе это."
	amount_per_transfer_from_this = 1
	volume = 1
	list_reagents = list(/datum/reagent/gluttonytoxin = 1)

/*
/obj/item/reagent_containers/syringe/apostletoxin
	name = "Вознесение"
	desc = "Скользкий, сладкий шприц. Интересно, что будет если вколоть его в себя? Или в ДРУГИХ?"
	amount_per_transfer_from_this = 1
	volume = 1
	list_reagents = list(/datum/reagent/apostletoxin = 1)
*/

//	Медипен Хонкоматери
/obj/item/reagent_containers/hypospray/medipen/apostletoxin
	name = "Вознесение"
	desc = "Скользкий, сладкий шприц. Интересно, что будет если вколоть его в себя? Или в ДРУГИХ?"
	icon = 'icons/obj/syringe.dmi'
	icon_state = "gorillapen"
	inhand_icon_state = "tbpen"
	reagent_flags = null
	list_reagents = list(/datum/reagent/apostletoxin = 1)

/obj/item/reagent_containers/syringe/bluespace
	name = "блюспейс шприц"
	desc = "Эта малышка может хранить 60 единиц в себе."
	icon = 'white/Feline/icons/syringe_bluespace.dmi'
	amount_per_transfer_from_this = 20
	volume = 60

/obj/item/reagent_containers/syringe/piercing
	name = "бронебойный шприц"
	desc = "Шприц с алмазным наконечником. Может хранить примерно 10 единиц."
	icon = 'white/Feline/icons/syringe_piercing.dmi'
	volume = 10
	proj_piercing = 1

/obj/item/reagent_containers/syringe/crude
	name = "примитивный шприц"
	desc = "Экологически правильный продукт."
	icon_state = "crude_0"
	possible_transfer_amounts = list(1,5)
	volume = 5

/obj/item/reagent_containers/syringe/spider_extract
	name = "шприц с экстрактом паука"
	desc = "Cодержит <b>экстракт паука</b> - заставляет любое золотое ядро создавать самых смертоносных товарищей в мире."
	list_reagents = list(/datum/reagent/spider_extract = 1)

/obj/item/reagent_containers/syringe/oxandrolone
	name = "шприц с оксандролоном"
	desc = "Cодержит <b>оксандролон</b>, используется для лечения серьёзных ожогов."
	list_reagents = list(/datum/reagent/medicine/oxandrolone = 15)

/obj/item/reagent_containers/syringe/salacid
	name = "шприц с салициловой кислотой"
	desc = "Cодержит <b>салициловую кислоту</b>, используется для лечения серьёзных травм."
	list_reagents = list(/datum/reagent/medicine/sal_acid = 15)

/obj/item/reagent_containers/syringe/penacid
	name = "шприц с ДТПА"
	desc = "Cодержит <b>диэтилентриаминпентауксусную кислоту</b>, используется для снижения уровня облучения и небольшого выведения токсинов."
	list_reagents = list(/datum/reagent/medicine/pen_acid = 15)

/obj/item/reagent_containers/syringe/syriniver
	name = "шприц с сиринивиром"
	desc = "Cодержит <b>сиринивир</b>, используется для выведения токсинов и химикатов. Метка на шприце сообщает 'Вводить один раз в минуту'."
	list_reagents = list(/datum/reagent/medicine/c2/syriniver = 15)

/obj/item/reagent_containers/syringe/contraband
	name = "безымянный шприц"
	desc = "Старый и потёртый шприц, внутри какая-то мутная жидкость."

/obj/item/reagent_containers/syringe/contraband/space_drugs
	list_reagents = list(/datum/reagent/drug/space_drugs = 15)

/obj/item/reagent_containers/syringe/contraband/krokodil
	list_reagents = list(/datum/reagent/drug/krokodil = 15)

/obj/item/reagent_containers/syringe/contraband/saturnx
	list_reagents = list(/datum/reagent/drug/saturnx = 15)

/obj/item/reagent_containers/syringe/contraband/methamphetamine
	list_reagents = list(/datum/reagent/drug/methamphetamine = 15)

/obj/item/reagent_containers/syringe/contraband/bath_salts
	list_reagents = list(/datum/reagent/drug/bath_salts = 15)

/obj/item/reagent_containers/syringe/contraband/fentanyl
	list_reagents = list(/datum/reagent/toxin/fentanyl = 15)

/obj/item/reagent_containers/syringe/contraband/morphine
	list_reagents = list(/datum/reagent/medicine/morphine = 15)

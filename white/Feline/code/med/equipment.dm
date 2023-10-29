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
	icon_state = "medbot_carrier_[bot.damagetype_healer]"
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
	preload = TRUE

/obj/item/storage/belt/medical/ert/PopulateContents()
	new /obj/item/surgical_drapes(src)
	new /obj/item/breathing_bag(src)
	new /obj/item/scalpel/advanced(src)
	new /obj/item/retractor/advanced(src)
	new /obj/item/cautery/advanced(src)
	new /obj/item/bonesetter/advanced(src)
	new /obj/item/healthanalyzer/advanced(src)

/obj/item/storage/belt/medical/ert/get_types_to_preload()
	var/list/to_preload = list()
	to_preload += /obj/item/surgical_drapes
	to_preload += /obj/item/breathing_bag
	to_preload += /obj/item/scalpel/advanced
	to_preload += /obj/item/retractor/advanced
	to_preload += /obj/item/bonesetter/advanced
	to_preload += /obj/item/cautery/advanced
	to_preload += /obj/item/healthanalyzer/advanced
	return to_preload

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

/obj/item/storage/pill_bottle/big/Initialize()
	. = ..()
	atom_storage.allow_quick_gather = TRUE
	atom_storage.numerical_stacking = TRUE
	atom_storage.max_slots = 20
	atom_storage.max_total_storage = 40
	atom_storage.set_holdable(list(/obj/item/reagent_containers/pill, /obj/item/dice))

/obj/item/storage/pill_bottle/ultra
	name = "таблетница"
	desc = "Вмещает в себя очень много пилюлек и таблеток."
	icon = 'white/Feline/icons/med_items.dmi'
	icon_state = "pill_box_green"

/obj/item/storage/pill_bottle/ultra/Initialize()
	. = ..()
	atom_storage.allow_quick_gather = TRUE
	atom_storage.numerical_stacking = TRUE
	atom_storage.max_slots = 50
	atom_storage.max_total_storage = 100
	atom_storage.set_holdable(list(/obj/item/reagent_containers/pill))

/obj/item/storage/pill_bottle/ultra/doc	//	Врач
	desc = "Хранит обширный набор таблеток на все случаи жизни."
	icon_state = "pill_box_blue"

/obj/item/storage/pill_bottle/ultra/doc/PopulateContents()
	new /obj/item/reagent_containers/pill/epinephrine(src)
	new /obj/item/reagent_containers/pill/epinephrine(src)
	new /obj/item/reagent_containers/pill/lenturi(src)
	new /obj/item/reagent_containers/pill/lenturi(src)
	new /obj/item/reagent_containers/pill/libital(src)
	new /obj/item/reagent_containers/pill/libital(src)
	new /obj/item/reagent_containers/pill/probital(src)
	new /obj/item/reagent_containers/pill/probital(src)
	new /obj/item/reagent_containers/pill/multiver(src)
	new /obj/item/reagent_containers/pill/multiver(src)
	new /obj/item/reagent_containers/pill/penacid(src)
	new /obj/item/reagent_containers/pill/penacid(src)
	new /obj/item/reagent_containers/pill/salicylic(src)
	new /obj/item/reagent_containers/pill/salicylic(src)
	new /obj/item/reagent_containers/pill/oxandrolone(src)
	new /obj/item/reagent_containers/pill/oxandrolone(src)
	new /obj/item/reagent_containers/pill/salbutamol(src)
	new /obj/item/reagent_containers/pill/salbutamol(src)
	new /obj/item/reagent_containers/pill/hematogen(src)
	new /obj/item/reagent_containers/pill/hematogen(src)
	new /obj/item/reagent_containers/pill/sens(src)
	new /obj/item/reagent_containers/pill/sens(src)
	new /obj/item/reagent_containers/pill/potassiodide(src)
	new /obj/item/reagent_containers/pill/potassiodide(src)
	new /obj/item/reagent_containers/pill/mannitol(src)
	new /obj/item/reagent_containers/pill/mannitol(src)
	new /obj/item/reagent_containers/pill/neurine(src)
	new /obj/item/reagent_containers/pill/neurine(src)
	new /obj/item/reagent_containers/pill/psicodine(src)
	new /obj/item/reagent_containers/pill/psicodine(src)
	new /obj/item/reagent_containers/pill/spaceacillin(src)
	new /obj/item/reagent_containers/pill/spaceacillin(src)
	new /obj/item/reagent_containers/pill/mutadone(src)
	new /obj/item/reagent_containers/pill/mutadone(src)

/obj/item/storage/pill_bottle/ultra/psih	//	Психолог
	desc = "Содержит стандартный набор психотропных веществ."
	icon_state = "pill_box_purple"

/obj/item/storage/pill_bottle/ultra/psih/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/pill/neurine(src)
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/pill/psicodine(src)
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/pill/mannitol(src)
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/pill/paxpsych(src)
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/pill/happinesspsych(src)
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/pill/lsdpsych(src)
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/pill/labebium(src)

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

/obj/item/storage/belt/medipenal/Initialize()
	. = ..()
	atom_storage.max_slots = 5
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL
	atom_storage.max_total_storage = 10
	atom_storage.set_holdable(list(
		/obj/item/reagent_containers/hypospray/medipen,
		/obj/item/reagent_containers/syringe
		))

/obj/item/storage/belt/medipenal/update_icon_state()
	. = ..()
	icon_state = initial(icon_state)
	worn_icon_state = initial(worn_icon_state)
	if(length(contents))
		icon_state = "penal[length(contents)]"

/obj/item/storage/belt/medipenal/attack_hand(mob/user, list/modifiers)
	if(loc == user)
		if((user.get_item_by_slot(ITEM_SLOT_BELT) == src) || (user.get_item_by_slot(ITEM_SLOT_LPOCKET) == src) || (user.get_item_by_slot(ITEM_SLOT_RPOCKET) == src))
			if(!user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE, TRUE))
				return
			atom_storage?.show_contents(user)
	else ..()
	return

/obj/item/storage/belt/medipenal/rangers	//	Рейнджер медик

/obj/item/storage/belt/medipenal/rangers/PopulateContents()
	new /obj/item/reagent_containers/hypospray/medipen/salacid(src)
	new /obj/item/reagent_containers/hypospray/medipen/penacid(src)
	new /obj/item/reagent_containers/hypospray/medipen/sputnik_lite(src)
	new /obj/item/reagent_containers/hypospray/medipen/sputnik_lite(src)

/obj/item/storage/belt/medipenal/field_med	//	Полевой медик

/obj/item/storage/belt/medipenal/field_med/PopulateContents()
	new /obj/item/reagent_containers/hypospray/medipen/super_brute(src)
	new /obj/item/reagent_containers/hypospray/medipen/super_brute(src)
	new /obj/item/reagent_containers/hypospray/medipen/oxandrolone(src)
	new /obj/item/reagent_containers/hypospray/medipen/penacid(src)

/obj/item/storage/belt/medipenal/paramed	//	Парамед

/obj/item/storage/belt/medipenal/paramed/PopulateContents()
	new /obj/item/reagent_containers/hypospray/medipen(src)
	new /obj/item/reagent_containers/hypospray/medipen(src)
	new /obj/item/reagent_containers/hypospray/medipen(src)
	new /obj/item/reagent_containers/hypospray/medipen/blood_boost(src)
	new /obj/item/reagent_containers/hypospray/medipen/blood_boost(src)

// Изя взял у Мойши ПАМК на позвонить

#define TYPE_SUN "sun"
#define TYPE_VENUS "venus"
#define TYPE_MARS "mars"
#define TYPE_EARTH "earth"
#define TYPE_JUPITER "jupiter"
#define TYPE_SATURN "saturn"

#define BLANK_STEP_1 "step1"
#define BLANK_STEP_2 "step2"
#define BLANK_STEP_3 "step3"
#define BLANK_STEP_4 "step4"
#define BLANK_STEP_5 "step5"
#define BLANK_STEP_6 "step6"

/obj/item/solnce
	name = "МК-Солнце"
	desc = "Многофункциональный медицинский комплекс \"Солнце\". Передовая военная разработка в области экстренной полевой медицины. Для начала работы необходимо нажать кнопку инициации выбора модуля, после чего установить соответствующие расходные материалы."
	icon = 'white/Feline/icons/sun.dmi'
	icon_state = "sun"
	var/charge = 0
	var/model_type = TYPE_SUN
	var/blank = FALSE
	var/static_state = "static"
	var/blank_item_1 = /obj/item/scalpel
	var/blank_item_2 = /obj/item/hemostat
	var/blank_chem_1 = /datum/reagent/medicine/sal_acid
	var/blank_chem_2 = /datum/reagent/medicine/oxandrolone

/obj/item/solnce/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'><b>Уровень заряда:</b></span> [charge].</span>"
/*	if(model_type == TYPE_SUN)
		. += "<hr><span class='notice'><b>Выберите модель устройства</b>.</span></span>"
	if(blank == BLANK_STEP_1)
		var/obj/item/helper1 = blank_item_1
		. += "<hr><span class='notice'>Закрепите внутри <b>[helper1.name]</b>.</span></span>"
	if(blank == BLANK_STEP_2)
		var/obj/item/helper2 = blank_item_2
		. += "<hr><span class='notice'>Закрепите внутри <b>[helper2.name]</b>.</span></span>"
	if(blank == BLANK_STEP_3)
		var/datum/reagent/helper3 = blank_chem_1
		. += "<hr><span class='notice'>Добавте химикат №1 <b>[helper3.name]</b> - 10 единиц.</span></span>"
	if(blank == BLANK_STEP_4)
		var/datum/reagent/helper4 = blank_chem_2
		. += "<hr><span class='notice'>Добавте химикат №2 <b>[helper4.name]</b> - 10 единиц.</span></span>"
	if(blank == BLANK_STEP_6)
		. += "<hr><span class='notice'><b>Уровень заряда:</b></span> [charge].</span>"
		if(charge == 0)
			. += "<hr><span class='notice'><b>Необходима перезарядка!</b> Сбросьте устройство к заводским настройкам при помощи отвертки, после чего переснарядите все инструменты и химикаты</span>.</span>"
*/

/obj/item/solnce/Initialize(mapload)
	. = ..()
	update_icon()

// 	Пресеты
/obj/item/solnce/venus
	name = "МК-Венера"
	desc = "Многофункциональный медицинский комплекс \"Солнце\", модель \"Венера\". При активации встроенный автохирург подключается к кровеносной системе и мгновенно выбрасывает в кровь пациента мощные нейтрализаторы, связывая и выводя токсины из организма."
	icon = 'white/Feline/icons/sun.dmi'
	icon_state = "venus"
	charge = 3
	model_type = TYPE_VENUS
	blank = BLANK_STEP_6

/obj/item/solnce/mars
	name = "МК-Марс"
	desc = "Многофункциональный медицинский комплекс \"Солнце\", модель \"Марс\". При активации встроенный автохирург быстро зашивает даже самые тяжелые повреждения мягких тканей, используя медицинские скобы, гель и медикаменты."
	icon = 'white/Feline/icons/sun.dmi'
	icon_state = "mars"
	charge = 3
	model_type = TYPE_MARS
	blank = BLANK_STEP_6

/obj/item/solnce/earth
	name = "МК-Земля"
	desc = "Многофункциональный медицинский комплекс \"Солнце\", модель \"Земля\". При активации встроенный автохирург производит полевую трахеотомию с инъекциями стимулирующих препаратов. Также инициирует временную мутацию, защищающую от любого воздействия окружающей среды."
	icon = 'white/Feline/icons/sun.dmi'
	icon_state = "earth"
	charge = 3
	model_type = TYPE_EARTH
	blank = BLANK_STEP_6

/obj/item/solnce/jupiter
	name = "МК-Юпитер"
	desc = "Многофункциональный медицинский комплекс \"Солнце\", модель \"Юпитер\". При активации встроенный автохирург подключается к кровеносной системе, вводит коагулянт и, автоматически определяя группу крови пострадавшего, восстанавливает уровень крови из внутренних запасов устройства. Так же восстанавливает организм после хаскирования."
	icon = 'white/Feline/icons/sun.dmi'
	icon_state = "jupiter"
	charge = 3
	model_type = TYPE_JUPITER
	blank = BLANK_STEP_6

/obj/item/solnce/saturn
	name = "МК-Сатурн"
	desc = "Многофункциональный медицинский комплекс \"Солнце\", модель \"Сатурн\". При активации встроенный автохирург производит полевую операцию по восстановлению костной структуры, коагуляции ран и удалению пораженных некрозом тканей."
	icon = 'white/Feline/icons/sun.dmi'
	icon_state = "saturn"
	charge = 3
	model_type = TYPE_SATURN
	blank = BLANK_STEP_6

/obj/item/solnce/update_icon()
	. = ..()
	icon_state = initial(icon_state)
	cut_overlays()
	switch(model_type)
		if(TYPE_SUN)
			icon_state = "sun"
		if(TYPE_VENUS)
			icon_state = "venus"
		if(TYPE_MARS)
			icon_state = "mars"
		if(TYPE_EARTH)
			icon_state = "earth"
		if(TYPE_JUPITER)
			icon_state = "jupiter"
		if(TYPE_SATURN)
			icon_state = "saturn"
	if(blank == BLANK_STEP_1 || blank == BLANK_STEP_2 || blank == BLANK_STEP_3 || blank == BLANK_STEP_4 || blank == BLANK_STEP_5)
		icon_state += "_blank"
	if(blank == BLANK_STEP_6)
		static_state = initial(static_state)
		if(model_type == TYPE_VENUS || model_type == TYPE_JUPITER)
			static_state += "_s"
		else
			static_state += "_u"
		static_state += "_[charge]"
		var/mutable_appearance/overlay = mutable_appearance(icon, static_state)
		add_overlay(overlay)

/obj/item/paper/solnce
	name = "Инструкция МК-Солнце"
	info = "<center>Инструкция по применению</center><BR><BR>Для инициации изделия МК-Солнце нажмите <B>кнопку активации</B> на главной приборной панели.<BR>Выберите модель устройства, установите инструмент <B>№1</B>, установите инструмент <B>№2</B>, добавьте химикат <B>№1</B>, добавьте химикат <B>№2</B>. <BR>1) Модель <B>МК-Венера</B> - полностью выводит токсины из организма.<BR>   * Скальпель<BR>   * Фильтр крови<BR>   * Мультивер<BR>   * Пентетовая кислота<BR>2) Модель <B>МК-Марс</B> - излечивает раны средней степени тяжести.<BR>   * Скальпель<BR>   * Зажим<BR>   * Салициловая кислота<BR>   * Оксандролон<BR>3) Модель <B>МК-Земля</B> - нейтрализует удушье и временно защищает цель от ВСЕХ опасностей окружающей среды, таких как температура и давление<BR>   * Скальпель<BR>   * Малый кислородный баллон<BR>   * Кислород (в жидкой форме)<BR>   * Конвермол <BR>4) Модель <B>МК-Юпитер</B> - восстанавливает уровень крови<BR>   * Скальпель<BR>   * Расширитель<BR>   * Физраствор<BR>   * Нестабильный мутаген <BR>5) Модель <B>МК-Сатурн</B> - ликвидирует физические травмы (переломы, кровотечения, ожоги, инфекцию)<BR>   * Скальпель<BR>   * Костоправ<BR>   * Адреналин<BR>   * Синтеплоть <BR><BR> Заряда расходных инструментов хватает на <B>3</B> применения, после чего устройство необходимо сбросить к заводским настройкам при помощи <B>отвертки</B>. Досрочный сброс устройства к заводским настройкам не возвращает расходные элементы."

// 	Выбор модели

/obj/item/solnce/attack_self(mob/user)
	. = ..()
	if(model_type == TYPE_SUN)
		to_chat(usr, span_notice("Нажимаю кнопку выбора модели."))
		var/static/list/choices = list(
			"Инструкция" 	= image(icon = 'icons/obj/bureaucracy.dmi', icon_state = "paper_stack_words"),
			"Венера" 		= image(icon = 'white/Feline/icons/sun.dmi', icon_state = "venus"),
			"Марс" 			= image(icon = 'white/Feline/icons/sun.dmi', icon_state = "mars"),
			"Земля" 		= image(icon = 'white/Feline/icons/sun.dmi', icon_state = "earth"),
			"Юпитер" 		= image(icon = 'white/Feline/icons/sun.dmi', icon_state = "jupiter"),
			"Сатурн" 		= image(icon = 'white/Feline/icons/sun.dmi', icon_state = "saturn")
			)
		var/choice = show_radial_menu(user, src, choices, tooltips = TRUE)
		if(!choice)
			return
		switch(choice)
			if("Инструкция")
				playsound(user, 'sound/items/poster_being_created.ogg', 50, TRUE)
				var/obj/item/paper/solnce/S = new()
				user.put_in_hands(S)
				return

			if("Венера")
				model_type = TYPE_VENUS
				name = "МК-Венера"
				desc = "Многофункциональный медицинский комплекс \"Солнце\", модель \"Венера\". При активации встроенный автохирург подключается к кровеносной системе и мгновенно выбрасывает в кровь пациента мощные нейтрализаторы, связывая и выводя токсины из организма."
				blank_item_1 = /obj/item/scalpel
				blank_item_2 = /obj/item/blood_filter
				blank_chem_1 = /datum/reagent/medicine/c2/multiver
				blank_chem_2 = /datum/reagent/medicine/pen_acid
			if("Марс")
				model_type = TYPE_MARS
				name = "МК-Марс"
				desc = "Многофункциональный медицинский комплекс \"Солнце\", модель \"Марс\". При активации встроенный автохирург при помощи медицинских скоб, геля и медикаментов быстро зашивает даже самые тяжелые повреждения мягких тканей."
				blank_item_1 = /obj/item/scalpel
				blank_item_2 = /obj/item/hemostat
				blank_chem_1 = /datum/reagent/medicine/sal_acid
				blank_chem_2 = /datum/reagent/medicine/oxandrolone
			if("Земля")
				model_type = TYPE_EARTH
				name = "МК-Земля"
				desc = "Многофункциональный медицинский комплекс \"Солнце\", модель \"Земля\". При активации встроенный автохирург производит полевую трахеотомию с инъекциями стимулирующих препаратов. Также инициирует временную мутацию, защищающую от любого воздействия окружающей среды."
				blank_item_1 = /obj/item/scalpel
				blank_item_2 = /obj/item/tank/internals/emergency_oxygen
				blank_chem_1 = /datum/reagent/oxygen
				blank_chem_2 = /datum/reagent/medicine/c2/convermol
			if("Юпитер")
				model_type = TYPE_JUPITER
				name = "МК-Юпитер"
				desc = "Многофункциональный медицинский комплекс \"Солнце\", модель \"Юпитер\". При активации встроенный автохирург подключается к кровеносной системе, вводит коагулянт и, автоматически определяя группу крови пострадавшего, восстанавливает уровень крови из внутренних запасов устройства. Так же восстанавливает организм после хаскирования."
				blank_item_1 = /obj/item/scalpel
				blank_item_2 = /obj/item/retractor
				blank_chem_1 = /datum/reagent/medicine/salglu_solution
				blank_chem_2 = /datum/reagent/toxin/mutagen
			if("Сатурн")
				model_type = TYPE_SATURN
				name = "МК-Сатурн"
				desc = "Многофункциональный медицинский комплекс \"Солнце\", модель \"Сатурн\". При активации встроенный автохирург производит полевую операцию по восстановлению костной структуры, коагуляции ран и удалению пораженных некрозом тканей."
				blank_item_1 = /obj/item/scalpel
				blank_item_2 = /obj/item/bonesetter
				blank_chem_1 = /datum/reagent/medicine/epinephrine
				blank_chem_2 = /datum/reagent/medicine/c2/synthflesh
		blank = BLANK_STEP_1
		to_chat(user, span_notice("Выбрана модель МК-[model_type]."))
		playsound(user, 'sound/items/rped.ogg', 100, TRUE)
		update_icon()

// 	Сборка

/obj/item/solnce/attackby(obj/item/I, mob/user, params)
// 	Сброс при помощи отвертки
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		to_chat(user, span_notice("Сбрасываю выбранную систему к заводским настройкам."))
		playsound(user, 'sound/items/screwdriver.ogg', 100, TRUE)
		if(!do_after(user, 2 SECONDS, src))
			return TRUE
		charge = 0
		model_type = TYPE_SUN
		blank = FALSE
		name = "МК-Солнце"
		desc = "Многофункциональный медицинский комплекс \"Солнце\". Передовая военная разработка в области экстренной полевой медицины. Для начала работы необходимо нажать кнопку инициации выбора модуля, после чего установить соответствующие расходные материалы."
		playsound(user, 'sound/items/screwdriver2.ogg', 100, TRUE)
		update_icon()

	if(blank == BLANK_STEP_1)
		if(istype(I, blank_item_1))
//			var/obj/item/helper1 = blank_item_2
//			to_chat(user, span_notice("Закрепляю [I] в первом слоте. Для следующего шага мне понадобится <b>[helper1.name]</b>."))
			to_chat(user, span_notice("Закрепляю [I] в первом слоте."))
			playsound(user, 'sound/machines/click.ogg', 100, TRUE)
			qdel(I)
			blank = BLANK_STEP_2

	if(blank == BLANK_STEP_2)
		if(istype(I, blank_item_2))
//			var/datum/reagent/helper2 = blank_chem_1
//			to_chat(user, span_notice("Закрепляю [I] во втором слоте. Для следующего шага мне понадобится <b>[helper2.name]</b> в объеме 10 единиц."))
			to_chat(user, span_notice("Закрепляю [I] во втором слоте."))
			playsound(user, 'sound/machines/click.ogg', 100, TRUE)
			qdel(I)
			blank = BLANK_STEP_3

	if(blank == BLANK_STEP_3)
		if(I.is_drainable() && I.reagents.has_reagent(blank_chem_1))
			if(!I.reagents.has_reagent(blank_chem_1, 10))
				to_chat(user, span_warning("В [I.name] недостаточно реагентов, необходимо по крайней мере 10 единиц!"))
				return
//			var/datum/reagent/helper3 = blank_chem_2
//			to_chat(user, span_notice("Заливаю первый химический реагент. Для следующего шага мне понадобится <b>[helper3.name]</b> в объеме 10 единиц."))
			to_chat(user, span_notice("Заливаю первый химический реагент."))
			playsound(user, 'sound/machines/click.ogg', 100, TRUE)
			I.reagents.remove_reagent(blank_chem_1, 10)
			blank = BLANK_STEP_4

	if(blank == BLANK_STEP_4)
		if(I.is_drainable() && I.reagents.has_reagent(blank_chem_2))

			if(!I.reagents.has_reagent(blank_chem_2, 10))
				to_chat(user, span_warning("В [I.name] недостаточно реагентов, необходимо по крайней мере 10 единиц!"))
				return
			to_chat(user, span_notice("Заливаю второй химический реагент."))
			playsound(user, 'sound/machines/click.ogg', 100, TRUE)
			I.reagents.remove_reagent(blank_chem_2, 10)
			blank = BLANK_STEP_6
			charge = 3
			update_icon()
	return ..()

/obj/item/solnce/proc/use_charge()
	charge = charge - 1
	playsound(get_turf(src), 'white/Feline/sounds/solnce_use.ogg', 80)
	update_icon()

// 	Лечение

/obj/item/solnce/attack(mob/living/carbon/human/M, mob/user)
	. = ..()
	if(model_type == TYPE_SUN)
		to_chat(user, span_warning("Для начала работы, необходимо выбрать систему и установить расходные элементы."))
		return
	if(!blank == BLANK_STEP_6)
		to_chat(user, span_warning("Необходимо установить расходные элементы."))
		return
	var/obj/item/bodypart/limb = M.get_bodypart(check_zone(user.zone_selected))
	if(!limb)
		to_chat(user, span_notice("Конечность отсутствует!"))
		return
	if(limb.status != BODYPART_ORGANIC)
		to_chat(user, span_notice("Медицина бессильна перед синтетикой!"))
		return
	switch(model_type)
		if(TYPE_MARS)
			if(M.getBruteLoss() > 10 || M.getFireLoss() > 10)
				if(charge > 0)
					use_charge()
					M.heal_overall_damage(60, 60)
				else
					to_chat(user, span_warning("Уровень заряда критический, необходима перезарядка."))
					playsound(user, 'white/Feline/sounds/solnce_off.ogg', 100, TRUE)
			else
				to_chat(user, span_notice("Состояние пациента удовлетворительное."))
		if(TYPE_EARTH)
			if(charge > 0)
				use_charge()
				M.setOxyLoss(0)
				M.reagents.add_reagent(/datum/reagent/medicine/space_stab,10)
			else
				to_chat(user, span_warning("Уровень заряда критический, необходима перезарядка."))
				playsound(user, 'white/Feline/sounds/solnce_off.ogg', 100, TRUE)
		if(TYPE_VENUS)
			if(M.getToxLoss() > 5)
				if(charge > 0)
					use_charge()
					M.setToxLoss(0)
				else
					to_chat(user, span_warning("Уровень заряда критический, необходима перезарядка."))
					playsound(user, 'white/Feline/sounds/solnce_off.ogg', 100, TRUE)
			else
				to_chat(user, span_warning("Токсины отсутствуют."))
		if(TYPE_SATURN)
			if(limb?.wounds?.len)
				if(charge > 0)
					use_charge()
					for(var/thing in limb.wounds)
						var/datum/wound/W = thing
						W.remove_wound()
						if(istype(limb, /obj/item/bodypart/head))
							M.cure_all_traumas(TRAUMA_RESILIENCE_WOUND)
					to_chat(user, span_notice("Успешно исправили все переломы и вывихи в этой конечности."))
				else
					to_chat(user, span_warning("Уровень заряда критический, необходима перезарядка."))
					playsound(user, 'white/Feline/sounds/solnce_off.ogg', 100, TRUE)
			else
				to_chat(user, span_warning("Не обнаружено травм в этой конечности."))
		if(TYPE_JUPITER)
			if((M.blood_volume <= initial(M.blood_volume) - 50) || (HAS_TRAIT(M, TRAIT_HUSK))) // проверка на малокровие и хаска
				if(charge > 0)
					if(HAS_TRAIT(M, TRAIT_HUSK))
						if(HAS_TRAIT(M, TRAIT_BADDNA))
							REMOVE_TRAIT(M, TRAIT_BADDNA, CHANGELING_DRAIN)
							to_chat(user, span_notice("Ликвидация генетического хаскирования..."))
						else
							to_chat(user, span_notice("Ликвидация ожогового хаскирования..."))
						M.cure_husk()
						use_charge()
					if(M.blood_volume <= initial(M.blood_volume) - 50)
						if(charge <= 0)
							to_chat(user, span_warning("Процедура завершена не до конца - уровень заряда критический, необходима перезарядка."))
							playsound(user, 'white/Feline/sounds/solnce_off.ogg', 100, TRUE)
							return
						M.reagents.add_reagent(/datum/reagent/medicine/coagulant,10)
						M.restore_blood()
						to_chat(user, span_notice("Уровень крови восстановлен."))
						use_charge()
				else
					to_chat(user, span_warning("Уровень заряда критический, необходима перезарядка."))
					playsound(user, 'white/Feline/sounds/solnce_off.ogg', 100, TRUE)
			else
				to_chat(user, span_warning("Уровень крови в пределах нормы."))

#undef TYPE_SUN
#undef TYPE_VENUS
#undef TYPE_MARS
#undef TYPE_EARTH
#undef TYPE_JUPITER
#undef TYPE_SATURN

#undef BLANK_STEP_1
#undef BLANK_STEP_2
#undef BLANK_STEP_3
#undef BLANK_STEP_4
#undef BLANK_STEP_5
#undef BLANK_STEP_6

/obj/item/storage/box/med
	name = "медицинская коробка"
	desc = "Коробка стерильно-белого цвета. Изначально использовалась как контейнер для радиоактивных веществ, однако наши ученые выяснили, что радиация неплохо уничтожает микробов!"
	icon = 'white/Feline/icons/med_items.dmi'
	icon_state = "med_box"

// 	Перчатки полевика и парамеда

/obj/item/clothing/gloves/color/latex/nitrile/polymer
	name = "полимерные перчатки"
	desc = "Продвинутые медицинские перчатки изготовленные из винил-неопренового полимера. Содержит наночипы третьего порядка, корректирующие тонкую моторику носителя при переноске тел и хирургических операциях."
	icon = 'white/Feline/icons/med_items.dmi'
	icon_state = "polymer"
	worn_icon = 'white/Feline/icons/gloves.dmi'
	worn_icon_state = "polymer"
	inhand_icon_state = "nitrilegloves"
	clothing_traits = list(TRAIT_QUICKER_CARRY, TRAIT_FASTMED, TRAIT_QUICKER_PULLING)
	transfer_prints = FALSE

// 	Головные уборы Полевика

/obj/item/clothing/head/helmet/field_med
	name = "шлем полевого медика"
	desc = "Боевой шлем белого цвета с эмблемой медицинской службы. Помогает раненым бойцам быстро идентифицировать врача на поле боя. Но всегда стоит помнить, что для кого-то крест это спасение, а для кого-то - мишень."
	icon = 'white/Feline/icons/field_med_head.dmi'
	icon_state = "helmet_plus"
	worn_icon = 'white/Feline/icons/field_med_head_body.dmi'
	inhand_icon_state = "helmetalt"
	armor = list(MELEE = 35, BULLET = 30, LASER = 30, ENERGY = 40, BOMB = 25, BIO = 90, RAD = 30, FIRE = 50, ACID = 90, WOUND = 20)
	can_flashlight = TRUE

/obj/item/clothing/head/helmet/field_med/beret
	name = "берет полевого медика"
	desc = "Красный берет спецназа с белыми полосками. По ободу вышита надпись: \"Предотвращение, спасение, помощь.\""
	icon_state = "beret"
	inhand_icon_state = "helmetalt"
	can_flashlight = FALSE
	flags_inv = null

/obj/item/clothing/head/helmet/field_med/cap
	name = "кепка полевого медика"
	desc = "Красная кепка службы безопасности с эмблемой медицинской службы. Удачно выполненный козырек неплохо прикрывает лицо от шальных осколков"
	icon_state = "cap"
	inhand_icon_state = "helmetalt"
	can_flashlight = TRUE
	var/alt_skin = FALSE
	flags_inv = null

/obj/item/clothing/head/helmet/field_med/cap/attack_self(mob/user)
	if(alt_skin)
		alt_skin = TRUE
		worn_icon = 'white/Feline/icons/field_med_head_body_alt.dmi'
		to_chat(user, span_notice("Разворачиваю кепку козырьком назад."))
	else
		alt_skin = FALSE
		worn_icon = 'white/Feline/icons/field_med_head_body.dmi'
		to_chat(user, span_notice("Разворачиваю кепку козырьком вперед."))

// 	Шкаф Полевика

/obj/structure/closet/secure_closet/security/field_med
	name = "шкаф полевого медика"
	req_access = list(ACCESS_BRIG_MED)
	icon = 'white/Feline/icons/closet.dmi'
	icon_state = "field_med"

/obj/structure/closet/secure_closet/security/field_med/PopulateContents()
	..()
	new /obj/item/storage/bag/garment/field_med(src)
	new /obj/item/detective_scanner(src)
	new /obj/item/storage/belt/security/full(src)
	new /obj/item/storage/box/trackimp(src)
	new /obj/item/storage/box/chemimp(src)
	new /obj/item/storage/firstaid/medical/field_surgery(src)
	new /obj/item/defibrillator/compact/loaded(src)
	new /obj/item/optable(src)
	new /obj/item/modular_computer/laptop/preset/medical(src)

/obj/item/storage/bag/garment/field_med
	name = "сумка для одежды полевого медика"

/obj/item/storage/bag/garment/field_med/PopulateContents()
	new /obj/item/clothing/under/rank/medical/brigphys(src)
	new /obj/item/clothing/under/rank/medical/brigphys/skirt(src)
	new /obj/item/clothing/suit/armor/vest/fieldmedic(src)
	new /obj/item/clothing/head/helmet/field_med(src)
	new /obj/item/clothing/head/helmet/field_med/beret(src)
	new /obj/item/clothing/head/helmet/field_med/cap(src)
	new /obj/item/radio/headset/headset_medsec(src)
	new /obj/item/radio/headset/headset_medsec/alt(src)
	new /obj/item/clothing/shoes/jackboots/sec(src)

/obj/item/iv_drip_item
	name = "телескопическая капельница"
	desc = "Складная капельница для переливания крови и лекарств. Весьма удобно лежит в двух руках."
	icon = 'white/Feline/icons/iv_drip_tele.dmi'
	lefthand_file = 'white/Feline/icons/iv_drip_tele_left.dmi'
	righthand_file = 'white/Feline/icons/iv_drip_tele_right.dmi'
	icon_state = "iv_drip_1hands"
	force = 5
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 200
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 30)
	resistance_flags = FIRE_PROOF
	wound_bonus = 0
	bare_wound_bonus = 0
	var/wielded = FALSE // удержание

/obj/item/iv_drip_item/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_TWOHANDED_WIELD, PROC_REF(on_wield))
	RegisterSignal(src, COMSIG_TWOHANDED_UNWIELD, PROC_REF(on_unwield))

/obj/item/iv_drip_item/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=5, force_wielded=10, icon_wielded="iv_drip_2hands")

//	Двуручный режим
/obj/item/iv_drip_item/proc/on_wield(obj/item/source, mob/user)
	SIGNAL_HANDLER

	wielded = TRUE
	icon_state = "iv_drip_2hands"
	playsound(user, 'sound/weapons/batonextend.ogg', 50, TRUE)


//	Одноручный режим
/obj/item/iv_drip_item/proc/on_unwield(obj/item/source, mob/user)
	SIGNAL_HANDLER

	wielded = FALSE
	icon_state = "iv_drip_1hands"
	playsound(user, 'sound/weapons/batonextend.ogg', 50, TRUE)

// 	Отбрасывание
/obj/item/iv_drip_item/attack(mob/living/target, mob/living/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		return
	if(wielded)
		if(!target.anchored)
			var/atom/throw_target = get_edge_target_turf(target, user.dir)
			var/whack_speed = (prob(60) ? 1 : 4)
			target.throw_at(throw_target, rand(1, 2), whack_speed, user, gentle = TRUE)

// 	Поставить на место
/obj/item/iv_drip_item/afterattack(obj/target, mob/user , proximity)
	. = ..()
	if(!proximity)
		return
	if(user.a_intent == INTENT_HELP)
		if(isopenturf(target))
			deploy_iv_drip(user, target)

/obj/item/iv_drip_item/proc/deploy_iv_drip(mob/user, atom/location)
	var/obj/machinery/iv_drip/R = new /obj/machinery/iv_drip(location)
	R.add_fingerprint(user)
	qdel(src)

/obj/item/iv_drip_item/attack_robot(mob/user, list/modifiers)
	new /obj/machinery/iv_drip (src.drop_location())
	qdel(src)

/// Набор вирусов для каргопака
/obj/item/storage/briefcase/surgery/virus
	name = "кейс с вирусами"
	desc = "Хранит в себе образцы вирусов."

/obj/item/storage/briefcase/surgery/virus/PopulateContents()
	new /obj/item/reagent_containers/glass/bottle/flu_virion(src)
	new /obj/item/reagent_containers/glass/bottle/cold(src)
	new /obj/item/reagent_containers/glass/bottle/random_virus(src)
	new /obj/item/reagent_containers/glass/bottle/random_virus(src)
	new /obj/item/reagent_containers/glass/bottle/random_virus(src)
	new /obj/item/reagent_containers/glass/bottle/random_virus(src)
	new /obj/item/reagent_containers/glass/bottle/fake_gbs(src)
	new /obj/item/reagent_containers/glass/bottle/magnitis(src)
	new /obj/item/reagent_containers/glass/bottle/pierrot_throat(src)
	new /obj/item/reagent_containers/glass/bottle/brainrot(src)
	new /obj/item/reagent_containers/glass/bottle/anxiety(src)
	new /obj/item/reagent_containers/glass/bottle/beesease(src)

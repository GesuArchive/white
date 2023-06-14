/*Power cells are in code\modules\power\cell.dm

If you create T5+ please take a pass at mech_fabricator.dm. The parts being good enough allows it to go into minus values and create materials out of thin air when printing stuff.*/
/obj/item/storage/part_replacer
	name = "автоматическое монтажное устройство (РПЕД)"
	desc = "Специальный механический модуль, предназначенный для хранения, сортировки и монтажа стандартных деталей машин. Вмещает 50 деталей."
	icon_state = "RPED"
	inhand_icon_state = "RPED"
	worn_icon_state = "RPED"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_HUGE
	var/works_from_distance = FALSE
	var/pshoom_or_beepboopblorpzingshadashwoosh = 'sound/items/rped.ogg'
	var/alt_sound = null
	slot_flags = ITEM_SLOT_BELT

/obj/item/storage/part_replacer/Initialize()
	. = ..()

	atom_storage.allow_quick_empty = TRUE
	atom_storage.allow_quick_gather = TRUE
	atom_storage.max_slots = 50
	atom_storage.max_total_storage = 100
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL
	atom_storage.numerical_stacking = TRUE
	atom_storage.set_holdable(list(/obj/item/stock_parts), null)

/obj/item/storage/part_replacer/pre_attack(obj/machinery/T, mob/living/user, params)
	if(!istype(T) || !T.component_parts)
		return ..()
	if(user.Adjacent(T)) // no TK upgrading.
		if(works_from_distance)
			user.Beam(T, icon_state = "rped_upgrade", time = 5)
		T.exchange_parts(user, src)
		return TRUE
	return ..()

/obj/item/storage/part_replacer/afterattack(obj/machinery/T, mob/living/user, adjacent, params)
	if(adjacent || !istype(T) || !T.component_parts)
		return ..()
	if(works_from_distance)
		user.Beam(T, icon_state = "rped_upgrade", time = 5)
		T.exchange_parts(user, src)
		return
	return ..()

/obj/item/storage/part_replacer/proc/play_rped_sound()
	//Plays the sound for RPED exhanging or installing parts.
	if(alt_sound && prob(1))
		playsound(src, alt_sound, 40, TRUE)
	else
		playsound(src, pshoom_or_beepboopblorpzingshadashwoosh, 40, TRUE)

/obj/item/storage/part_replacer/bluespace
	name = "Блюспейс монтажное устройство (РПЕД)"
	desc = "Продвинутая модель, основанная на технологии блюспейса, за счет фазового сдвига позволяет модернизировать машины на расстоянии, без необходимости снятия передней панели. Вмещает 400 деталей."
	icon_state = "BS_RPED"
	w_class = WEIGHT_CLASS_NORMAL
	works_from_distance = TRUE
	pshoom_or_beepboopblorpzingshadashwoosh = 'sound/items/pshoom.ogg'
	alt_sound = 'sound/items/pshoom_2.ogg'

/obj/item/storage/part_replacer/bluespace/Initialize(mapload)
	. = ..()

	atom_storage.max_slots = 400
	atom_storage.max_total_storage = 800
	atom_storage.max_specific_storage = WEIGHT_CLASS_GIGANTIC

	RegisterSignal(src, COMSIG_ATOM_ENTERED, PROC_REF(on_part_entered))

/obj/item/storage/part_replacer/bluespace/proc/on_part_entered(datum/source, obj/item/I)
	if(!istype(I, /obj/item/stock_parts/cell))
		return

	var/obj/item/stock_parts/cell/inserted_cell = I

	if(inserted_cell.rigged || inserted_cell.corrupted)
		message_admins("[ADMIN_LOOKUPFLW(usr)] has inserted rigged/corrupted [inserted_cell] into [src].")
		log_game("[key_name(usr)] has inserted rigged/corrupted [inserted_cell] into [src].")
		usr.log_message("inserted rigged/corrupted [inserted_cell] into [src]", LOG_ATTACK)

/obj/item/storage/part_replacer/bluespace/tier1

/obj/item/storage/part_replacer/bluespace/tier1/PopulateContents()
	for(var/i in 1 to 20)
		new /obj/item/stock_parts/capacitor(src)
		new /obj/item/stock_parts/scanning_module(src)
		new /obj/item/stock_parts/manipulator(src)
		new /obj/item/stock_parts/micro_laser(src)
		new /obj/item/stock_parts/matter_bin(src)
		new /obj/item/stock_parts/cell/high(src)

/obj/item/storage/part_replacer/bluespace/tier2

/obj/item/storage/part_replacer/bluespace/tier2/PopulateContents()
	for(var/i in 1 to 20)
		new /obj/item/stock_parts/capacitor/adv(src)
		new /obj/item/stock_parts/scanning_module/adv(src)
		new /obj/item/stock_parts/manipulator/nano(src)
		new /obj/item/stock_parts/micro_laser/high(src)
		new /obj/item/stock_parts/matter_bin/adv(src)
		new /obj/item/stock_parts/cell/super(src)

/obj/item/storage/part_replacer/bluespace/tier3

/obj/item/storage/part_replacer/bluespace/tier3/PopulateContents()
	for(var/i in 1 to 20)
		new /obj/item/stock_parts/capacitor/super(src)
		new /obj/item/stock_parts/scanning_module/phasic(src)
		new /obj/item/stock_parts/manipulator/pico(src)
		new /obj/item/stock_parts/micro_laser/ultra(src)
		new /obj/item/stock_parts/matter_bin/super(src)
		new /obj/item/stock_parts/cell/hyper(src)

/obj/item/storage/part_replacer/bluespace/tier4

/obj/item/storage/part_replacer/bluespace/tier4/PopulateContents()
	for(var/i in 1 to 20)
		new /obj/item/stock_parts/capacitor/quadratic(src)
		new /obj/item/stock_parts/scanning_module/triphasic(src)
		new /obj/item/stock_parts/manipulator/femto(src)
		new /obj/item/stock_parts/micro_laser/quadultra(src)
		new /obj/item/stock_parts/matter_bin/bluespace(src)
		new /obj/item/stock_parts/cell/bluespace(src)

/obj/item/storage/part_replacer/bluespace/tier5
	color = "#ff3333"
	w_class = WEIGHT_CLASS_TINY

/obj/item/storage/part_replacer/bluespace/tier5/PopulateContents()
	for(var/i in 1 to 50)
		new /obj/item/stock_parts/capacitor/noneuclid(src)
		new /obj/item/stock_parts/scanning_module/noneuclid(src)
		new /obj/item/stock_parts/manipulator/noneuclid(src)
		new /obj/item/stock_parts/micro_laser/noneuclid(src)
		new /obj/item/stock_parts/matter_bin/noneuclid(src)
		new /obj/item/stock_parts/cell/bluespace(src)

/obj/item/storage/part_replacer/cargo //used in a cargo crate

/obj/item/storage/part_replacer/cargo/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/stock_parts/capacitor(src)
		new /obj/item/stock_parts/scanning_module(src)
		new /obj/item/stock_parts/manipulator(src)
		new /obj/item/stock_parts/micro_laser(src)
		new /obj/item/stock_parts/matter_bin(src)

/obj/item/storage/part_replacer/tier2 //used in mechanic outfit

/obj/item/storage/part_replacer/tier2/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/stock_parts/capacitor/adv(src)
		new /obj/item/stock_parts/scanning_module/adv(src)
		new /obj/item/stock_parts/manipulator/nano(src)
		new /obj/item/stock_parts/micro_laser/high(src)
		new /obj/item/stock_parts/matter_bin/adv(src)


/obj/item/storage/part_replacer/cyborg
	name = "автоматическое монтажное устройство (РПЕД)"
	desc = "Специальный механический модуль, предназначенный для хранения, сортировки и монтажа стандартных деталей машин. Вмещает 100 деталей."
	icon_state = "borgrped"
	inhand_icon_state = "RPED"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'

/obj/item/storage/part_replacer/cyborg/Initialize(mapload)
	. = ..()
	atom_storage.max_slots = 150
	atom_storage.max_total_storage = 300

/proc/cmp_rped_sort(obj/item/A, obj/item/B)
	return B.get_part_rating() - A.get_part_rating()

/obj/item/stock_parts
	name = "stock part"
	desc = "What?"
	icon = 'icons/obj/stock_parts.dmi'
	w_class = WEIGHT_CLASS_SMALL
	var/rating = 1
	var/energy_rating = 1

/obj/item/stock_parts/Initialize(mapload)
	. = ..()
	pixel_x = base_pixel_x + rand(-5, 5)
	pixel_y = base_pixel_y + rand(-5, 5)

/obj/item/stock_parts/get_part_rating()
	return rating

//	1 ранг

/obj/item/stock_parts/capacitor
	name = "базовый конденсатор"
	desc = "Конденсатор, используемый при конструировании различных устройств."
	icon_state = "capacitor"
	custom_materials = list(/datum/material/iron=50, /datum/material/glass=50)

/obj/item/stock_parts/scanning_module
	name = "базовый модуль сканирования"
	desc = "Компактный сканирующий модуль с высоким разрешением, используемый при конструировании различных устройств."
	icon_state = "scan_module"
	custom_materials = list(/datum/material/iron=50, /datum/material/glass=20)

/obj/item/stock_parts/manipulator
	name = "базовый микроманипулятор"
	desc = "Крошечный манипулятор, используемый при конструировании различных устройств."
	icon_state = "micro_mani"
	custom_materials = list(/datum/material/iron=30)

/obj/item/stock_parts/micro_laser
	name = "базовый микролазер"
	desc = "Крошечный лазер, используемый при конструировании различных устройств."
	icon_state = "micro_laser"
	custom_materials = list(/datum/material/iron=10, /datum/material/glass=20)

/obj/item/stock_parts/matter_bin
	name = "базовый резервуар материи"
	desc = "Контейнер, предназначенный для хранения сжатой материи, используемый при конструировании различных устройств."
	icon_state = "matter_bin"
	custom_materials = list(/datum/material/iron=80)

//	2 ранг

/obj/item/stock_parts/capacitor/adv
	name = "продвинутый конденсатор"
	icon_state = "adv_capacitor"
	rating = 2
	energy_rating = 3
	custom_materials = list(/datum/material/iron=50, /datum/material/glass=50)

/obj/item/stock_parts/scanning_module/adv
	name = "продвинутый модуль сканирования"
	icon_state = "adv_scan_module"
	rating = 2
	energy_rating = 3
	custom_materials = list(/datum/material/iron=50, /datum/material/glass=20)

/obj/item/stock_parts/manipulator/nano
	name = "продвинутый наноманипулятор"
	icon_state = "nano_mani"
	rating = 2
	energy_rating = 3
	custom_materials = list(/datum/material/iron=30)

/obj/item/stock_parts/micro_laser/high
	name = "продвинутый мощный микролазер"
	icon_state = "high_micro_laser"
	rating = 2
	energy_rating = 3
	custom_materials = list(/datum/material/iron=10, /datum/material/glass=20)

/obj/item/stock_parts/matter_bin/adv
	name = "продвинутый резервуар материи"
	icon_state = "advanced_matter_bin"
	rating = 2
	energy_rating = 3
	custom_materials = list(/datum/material/iron=80)

//	3 ранг

/obj/item/stock_parts/capacitor/super
	name = "супер конденсатор"
	icon_state = "super_capacitor"
	rating = 3
	energy_rating = 5
	custom_materials = list(/datum/material/iron=50, /datum/material/glass=50)

/obj/item/stock_parts/scanning_module/phasic
	name = "супер фазированный модуль сканирования"
	icon_state = "super_scan_module"
	rating = 3
	energy_rating = 5
	custom_materials = list(/datum/material/iron=50, /datum/material/glass=20)

/obj/item/stock_parts/manipulator/pico
	name = "супер пикоманипулятор"
	icon_state = "pico_mani"
	rating = 3
	energy_rating = 5
	custom_materials = list(/datum/material/iron=30)

/obj/item/stock_parts/micro_laser/ultra
	name = "супер высокомощный микролазер"
	icon_state = "ultra_high_micro_laser"
	rating = 3
	energy_rating = 5
	custom_materials = list(/datum/material/iron=10, /datum/material/glass=20)

/obj/item/stock_parts/matter_bin/super
	name = "супер резервуар материи"
	icon_state = "super_matter_bin"
	rating = 3
	energy_rating = 5
	custom_materials = list(/datum/material/iron=80)

//	4 ранг

/obj/item/stock_parts/capacitor/quadratic
	name = "ультра конденсатор"
	icon_state = "quadratic_capacitor"
	rating = 4
	energy_rating = 10
	custom_materials = list(/datum/material/iron=50, /datum/material/glass=50)

/obj/item/stock_parts/scanning_module/triphasic
	name = "ультра трифазированный модуль сканирования"
	icon_state = "triphasic_scan_module"
	rating = 4
	energy_rating = 10
	custom_materials = list(/datum/material/iron=50, /datum/material/glass=20)

/obj/item/stock_parts/manipulator/femto
	name = "ультра фемтоманипулятор"
	icon_state = "femto_mani"
	rating = 4
	energy_rating = 10
	custom_materials = list(/datum/material/iron=30)

/obj/item/stock_parts/micro_laser/quadultra
	name = "ультра квадромощный микролазер"
	icon_state = "quadultra_micro_laser"
	rating = 4
	energy_rating = 10
	custom_materials = list(/datum/material/iron=10, /datum/material/glass=20)

/obj/item/stock_parts/matter_bin/bluespace
	name = "ультра блюспейс резервуар материи"
	icon_state = "bluespace_matter_bin"
	rating = 4
	energy_rating = 10
	custom_materials = list(/datum/material/iron=80)

//	5 ранг

/obj/item/stock_parts/capacitor/noneuclid
	name = "неевклидовый конденсатор"
	icon_state = "quadratic_capacitor"
	rating = 5
	energy_rating = 20
	custom_materials = list(/datum/material/iron=1, /datum/material/glass=1)
	color = "#ff3333"

/obj/item/stock_parts/scanning_module/noneuclid
	name = "неевклидовый модуль сканирования"
	icon_state = "triphasic_scan_module"
	rating = 5
	energy_rating = 20
	custom_materials = list(/datum/material/iron=1, /datum/material/glass=1)
	color = "#ff3333"

/obj/item/stock_parts/manipulator/noneuclid
	name = "неевклидовый манипулятор"
	icon_state = "femto_mani"
	rating = 5
	energy_rating = 20
	custom_materials = list(/datum/material/iron=1)
	color = "#ff3333"

/obj/item/stock_parts/micro_laser/noneuclid
	name = "неевклидовый микролазер"
	icon_state = "quadultra_micro_laser"
	rating = 5
	energy_rating = 20
	custom_materials = list(/datum/material/iron=1, /datum/material/glass=1)
	color = "#ff3333"

/obj/item/stock_parts/matter_bin/noneuclid
	name = "неевклидовый резервуар материи"
	icon_state = "bluespace_matter_bin"
	rating = 5
	energy_rating = 20
	custom_materials = list(/datum/material/iron=1)
	color = "#ff3333"

// Subspace stock parts

/obj/item/stock_parts/subspace/ansible
	name = "подпространственный ансибль"
	desc = "Компактный модуль, способный воспринимать межпространственное излучение."
	icon_state = "subspace_ansible"
	custom_materials = list(/datum/material/iron=30, /datum/material/glass=10)

/obj/item/stock_parts/subspace/filter
	name = "гиперволновой фильтр"
	desc = "Крошечное устройство, способное фильтровать и преобразовывать сверхинтенсивные радиоволны."
	icon_state = "hyperwave_filter"
	custom_materials = list(/datum/material/iron=30, /datum/material/glass=10)

/obj/item/stock_parts/subspace/amplifier
	name = "подпространственный усилитель"
	desc = "Компактное устройство, способное усиливать слабые межпространственные передачи."
	icon_state = "subspace_amplifier"
	custom_materials = list(/datum/material/iron=30, /datum/material/glass=10)

/obj/item/stock_parts/subspace/treatment
	name = "подпространственная стабилизирующая тарелка"
	desc = "Компактное устройство, способное растягивать сверхсжатые радиоволны."
	icon_state = "treatment_disk"
	custom_materials = list(/datum/material/iron=30, /datum/material/glass=10)

/obj/item/stock_parts/subspace/analyzer
	name = "анализатор длины подпространственных волн"
	desc = "Сложный анализатор, способный анализировать зашифрованные передачи подпространственных волн."
	icon_state = "wavelength_analyzer"
	custom_materials = list(/datum/material/iron=30, /datum/material/glass=10)

/obj/item/stock_parts/subspace/crystal
	name = "анзибль-кристалл"
	desc = "Кристалл из сверхчистого стекла, используемый для передачи в подпространство импульсов данных при помощи лазера."
	icon_state = "ansible_crystal"
	custom_materials = list(/datum/material/glass=50)

/obj/item/stock_parts/subspace/transmitter
	name = "подпространственный передатчик"
	desc = "Большое оборудование, используемое для открытия окна в подпространственное измерение."
	icon_state = "subspace_transmitter"
	custom_materials = list(/datum/material/iron=50)

// Misc. Parts

/obj/item/stock_parts/card_reader
	name = "кардридер"
	desc = "Небольшой считыватель магнитных карт, используемый для устройств, которые принимают и передают голографические кредиты."
	icon_state = "card_reader"
	custom_materials = list(/datum/material/iron=50, /datum/material/glass=10)

/obj/item/stock_parts/water_recycler
	name = "рециркулятор воды"
	desc = "Компонент химической рекультивации, который служит для повторного накопления и фильтрации воды с течением времени."
	icon_state = "water_recycler"
	custom_materials = list(/datum/material/plastic=200, /datum/material/iron=50)

/obj/item/research//Makes testing much less of a pain -Sieve
	name = "research"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "capacitor"
	desc = "A debug item for research."

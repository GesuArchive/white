// SPAS12

/obj/item/gun/ballistic/shotgun/spas12
	name = "Franchi SPAS-12"
	desc = "Древний, но эффективный дробовик, разработанный в Италии. Предназначался для использования силовыми структурами."
	icon_state = "spas12"
	icon = 'white/rebolution228/icons/weapons/spas12.dmi'
	lefthand_file = 'white/rebolution228/icons/weapons/guns_inhand_left.dmi'
	righthand_file = 'white/rebolution228/icons/weapons/guns_inhand_right.dmi'
	inhand_icon_state = "spess12"
	worn_icon = 'white/rebolution228/icons/weapons/guns_back.dmi'
	worn_icon_state = "spas12_back"
	fire_sound = 'white/rebolution228/sounds/weapons/spas_shoot.ogg'
	rack_sound = 'white/rebolution228/sounds/weapons/spas_pump.ogg'
	load_sound = 'white/rebolution228/sounds/weapons/spas_insert.ogg'
	w_class = WEIGHT_CLASS_BULKY
	mag_type = /obj/item/ammo_box/magazine/internal/shot/lethal/eight
	weapon_weight = WEAPON_HEAVY
	pb_knockback = 1
	fire_delay = 5
	inhand_x_dimension = 32
	inhand_y_dimension = 32

/obj/item/gun/ballistic/shotgun/spas12/rubber
	mag_type = /obj/item/ammo_box/magazine/internal/shot/riot/eight

/obj/item/ammo_box/magazine/internal/shot/lethal/eight // lethal rounds
	max_ammo = 8
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot

/obj/item/ammo_box/magazine/internal/shot/riot/eight // rubber rounds
	max_ammo = 8
	ammo_type = /obj/item/ammo_casing/shotgun/rubbershot


/////////////////////////////////////////// M41A MKII

/obj/item/gun/ballistic/automatic/m41a2
	var/obj/item/gun/ballistic/revolver/grenadelauncher/underbarrel
	name = "Импульсная Винтовка M41A"
	desc = "Основное оружие колониальных морпехов, оснащенная подствольным 40мм гранатомётом. Использует безгильзовые 10х24мм патроны. Неплохо работает против ксеноморфов."
	icon = 'white/rebolution228/icons/weapons/rguns.dmi'
	icon_state = "m41a2"
	inhand_icon_state = "m41a2"
	selector_switch_icon = TRUE
	lefthand_file = 'white/rebolution228/icons/weapons/guns_inhand_left.dmi'
	righthand_file = 'white/rebolution228/icons/weapons/guns_inhand_right.dmi'
	mag_type = /obj/item/ammo_box/magazine/m41a/caseless
	worn_icon = 'white/rebolution228/icons/weapons/guns_back.dmi'
	worn_icon_state = "m41a2_back"
	pin = /obj/item/firing_pin
	fire_delay = 1.5
	slot_flags = ITEM_SLOT_BACK
	can_suppress = FALSE
	burst_size = 4
	empty_indicator = TRUE
	spread = 5
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'white/rebolution228/sounds/weapons/fire_m41a1.ogg'
	var/list/fucking = list('white/rebolution228/sounds/weapons/fire_m41a1.ogg',
						'white/rebolution228/sounds/weapons/fire_m41a2.ogg',
						'white/rebolution228/sounds/weapons/fire_m41a3.ogg',
						'white/rebolution228/sounds/weapons/fire_m41a4.ogg')

// рандомизация звука
/obj/item/gun/ballistic/automatic/m41a2/process_chamber()
	. = ..()
	fire_sound = pick(fucking)

// добавляем гранатомет
/obj/item/gun/ballistic/automatic/m41a2/Initialize()
	. = ..()
	underbarrel = new /obj/item/gun/ballistic/revolver/grenadelauncher/unrestricted/m41a
	update_icon()
// настраиваем гранатомет
/obj/item/gun/ballistic/automatic/m41a2/afterattack(atom/target, mob/living/user, flag, params)
	if(select == 2)
		underbarrel.afterattack(target, user, flag, params)
	else
		return ..()
// даем возможность менять режимы стрельбы
/obj/item/gun/ballistic/automatic/m41a2/burst_select()
	var/mob/living/carbon/human/user = usr
	switch(select)
		if(0)
			select = 1
			burst_size = initial(burst_size)
			fire_delay = initial(fire_delay)
			to_chat(user, span_notice("Выбираю режим стрельбы очередью."))
		if(1)
			select = 2
			to_chat(user, span_notice("Выбираю режим гранатомёта."))
		if(2)
			select = 0
			burst_size = 1
			fire_delay = 0
			to_chat(user, span_notice("Выбираю полуавтоматический режим."))
	playsound(user, 'white/rebolution228/sounds/weapons/dryfire1.ogg', 100, TRUE)
	update_icon()
	return
//обновляем оверлеи
/obj/item/gun/ballistic/automatic/m41a2/update_overlays()
	. = ..()
	switch(select)
		if(0)
			. += "[initial(icon_state)]_semi"
		if(1)
			. += "[initial(icon_state)]_burst"
		if(2)
			. += "[initial(icon_state)]_gren"
// посылаем нахуй гильзу от 40мм снаряда
/obj/item/gun/ballistic/automatic/m41a2/attackby(obj/item/A, mob/user, params)
	if(istype(A, /obj/item/ammo_casing))
		if(istype(A, underbarrel.magazine.ammo_type))
			underbarrel.attack_self(user)
			underbarrel.attackby(A, user, params)
	else
		..()
// обновляем иконку при отсутствии магазина
/obj/item/gun/ballistic/automatic/m41a2/update_icon()
	..()
	if(magazine)
		icon_state = "m41a2"
		if(magazine.ammo_count() <= 0)
			icon_state = "m41a2_nm"
	else
		icon_state = "m41a2_e"

// m41a2 ammo

/obj/item/ammo_box/magazine/m41a/caseless
	name = "M41A2 Magazine"
	icon = 'white/rebolution228/icons/weapons/rammo.dmi'
	icon_state = "m41a2"
	ammo_type = /obj/item/ammo_casing/caseless/m41acaseless
	caliber = "10x24mm"
	max_ammo = 99
// обновляем иконку при отсутствии патрон
/obj/item/ammo_box/magazine/m41a/caseless/update_icon()
	..()
	if(ammo_count() <= 0)
		icon_state = "m41a2_e"
	else
		icon_state = "m41a2"
// сама пуля
/obj/projectile/bullet/m41acaseless
	name = "10x24мм пуля"
	damage = 25
	armour_penetration = 25
	wound_bonus = -40
// бонус к дамагу ксен, на деле не тестил и вроде бы не работает
/obj/projectile/bullet/m41acaseless/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(isalien(target))
		damage = 50

// патрон
/obj/item/ammo_casing/caseless/m41acaseless
	name = "10x24мм патрон"
	caliber = "10x24mm"
	projectile_type = /obj/projectile/bullet/m41acaseless
// сам гранатомет
/obj/item/gun/ballistic/revolver/grenadelauncher/unrestricted/m41a
	fire_sound = 'white/rebolution228/sounds/weapons/fire_m41agrenadelauncher.ogg'
	mag_type = /obj/item/ammo_box/magazine/internal/grenadelauncher/m41a
// магазин гранатомета
/obj/item/ammo_box/magazine/internal/grenadelauncher/m41a
	max_ammo = 2
// гильза идет нахуй
/obj/item/gun/ballistic/revolver/grenadelauncher/unrestricted/m41a/afterattack()
	. = ..()
	magazine.get_round(FALSE)

/////////////////////////////////////////// AS VAL

/obj/item/gun/ballistic/automatic/asval
	name = "АС \"Вал\""
	desc = "Бесшумный автомат, используемый войсками осназа Новой России. Использует 9х39 калибр."
	icon = 'white/rebolution228/icons/weapons/rguns.dmi'
	icon_state = "asval"
	inhand_icon_state = "asval"
	selector_switch_icon = TRUE
	lefthand_file = 'white/rebolution228/icons/weapons/guns_inhand_left.dmi'
	righthand_file = 'white/rebolution228/icons/weapons/guns_inhand_right.dmi'
	worn_icon = 'white/rebolution228/icons/weapons/guns_back.dmi'
	worn_icon_state = "asval_back"
	mag_type = /obj/item/ammo_box/magazine/asval
	pin = /obj/item/firing_pin
	fire_delay = 1
	slot_flags = ITEM_SLOT_BACK
	burst_size = 3
	empty_indicator = TRUE
	mag_display = TRUE
	spread = 3
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'white/rebolution228/sounds/weapons/fire_asval.ogg'
	rack_sound = 'white/rebolution228/sounds/weapons/asval_zatvor.ogg'
	eject_sound = 'white/rebolution228/sounds/weapons/asval_magout.ogg'
	eject_empty_sound = 'white/rebolution228/sounds/weapons/asval_magout.ogg'
	load_sound = 'white/rebolution228/sounds/weapons/asval_magout.ogg'
	load_empty_sound = 'white/rebolution228/sounds/weapons/asval_magin.ogg'
	can_suppress = FALSE
// обновляем иконку ствола в руках, убирая магазин
/obj/item/gun/ballistic/automatic/asval/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/gun/ballistic/automatic/asval/update_icon_state()
	inhand_icon_state = "[initial(icon_state)][magazine ? "":"_nmag"]"
// магазин
/obj/item/ammo_box/magazine/asval
	name = "9х39 магазин"
	icon = 'white/rebolution228/icons/weapons/rammo.dmi'
	icon_state = "asval"
	ammo_type = /obj/item/ammo_casing/c9x39
	caliber = "9x39"
	max_ammo = 20
// обновляем иконку у магазина
/obj/item/ammo_box/magazine/asval/update_icon()
	..()
	if(ammo_count() <= 0)
		icon_state = "asval_e"
	else
		icon_state = "asval"
// патрон
/obj/item/ammo_casing/c9x39
	name = "9x39 гильза"
	caliber = "9x39"
	projectile_type = /obj/projectile/bullet/c9x39eb
// пуля
/obj/projectile/bullet/c9x39eb
	name = "9x39 пуля"
	damage = 30
	armour_penetration = 60
	wound_bonus = -10

/////////////////////////////////////////// AK74M

/obj/item/gun/ballistic/automatic/ak74m
	name = "AK-74M"
	desc = "Основной образец индивидуального оружия личного состава пехотных и других подразделений Вооруженных сил Новой России, специальных подразделений правоохранительных органов. Использует 5,45мм патроны."
	icon = 'white/rebolution228/icons/weapons/rguns.dmi'
	icon_state = "ak74m"
	inhand_icon_state = "ak74m"
	selector_switch_icon = TRUE
	lefthand_file = 'white/rebolution228/icons/weapons/guns_inhand_left.dmi'
	righthand_file = 'white/rebolution228/icons/weapons/guns_inhand_right.dmi'
	worn_icon = 'white/rebolution228/icons/weapons/guns_back.dmi'
	worn_icon_state = "ak74m_back"
	mag_type = /obj/item/ammo_box/magazine/ak74m
	pin = /obj/item/firing_pin
	fire_delay = 2
	slot_flags = ITEM_SLOT_BACK
	burst_size = 3
	empty_indicator = TRUE
	empty_alarm = TRUE
	mag_display = TRUE
	spread = 5
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	rack_sound = 'white/rebolution228/sounds/weapons/74_zatvor.ogg'
	eject_sound = 'white/rebolution228/sounds/weapons/74_magout.ogg'
	eject_empty_sound = 'white/rebolution228/sounds/weapons/74_magout.ogg'
	load_sound = 'white/rebolution228/sounds/weapons/74_magout.ogg'
	load_empty_sound = 'white/rebolution228/sounds/weapons/74_magin.ogg'
	fire_sound = 'white/rebolution228/sounds/weapons/74_ebashit1.ogg'
	var/list/huipizdaaa = list('white/rebolution228/sounds/weapons/74_ebashit1.ogg',
							'white/rebolution228/sounds/weapons/74_ebashit2.ogg',
							'white/rebolution228/sounds/weapons/74_ebashit3.ogg')
	can_suppress = FALSE
// обновляем иконку в руках при отсутствии магазина
/obj/item/gun/ballistic/automatic/ak74m/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/gun/ballistic/automatic/ak74m/update_icon_state()
	inhand_icon_state = "[initial(icon_state)][magazine ? "":"_nmag"]"
// добавляем счетчик патронов на ствол
/obj/item/gun/ballistic/automatic/ak74m/update_overlays()
	. = ..()
	if(!chambered && empty_indicator)
		. += "[icon_state]_empty"
// рандомизируем звук
/obj/item/gun/ballistic/automatic/ak74m/process_chamber()
	. = ..()
	fire_sound = pick(huipizdaaa)
//  магазин
/obj/item/ammo_box/magazine/ak74m
	name = "Магазин АК-74 (5.45)"
	icon = 'white/rebolution228/icons/weapons/rammo.dmi'
	icon_state = "ak74m"
	ammo_type = /obj/item/ammo_casing/a545
	caliber = "a545"
	max_ammo = 30
// обновление спрайта магазина при отсутствии патрон в нем
/obj/item/ammo_box/magazine/ak74m/update_icon()
	..()
	if(ammo_count() <= 0)
		icon_state = "ak74m_e"
	else
		icon_state = "ak74m"
// патрон
/obj/item/ammo_casing/a545
	name = "5.45x39 гильза"
	icon_state = "762-casing"
	caliber = "a545"
	projectile_type = /obj/projectile/bullet/a545
// пуля
/obj/projectile/bullet/a545
	name = "5.45 пуля"
	damage = 25
	armour_penetration = 20
	wound_bonus = -20

/////////////////////////////////////////// AK74M GP25
// наследуем объект
/obj/item/gun/ballistic/automatic/ak74m/gp25
	var/obj/item/gun/ballistic/revolver/grenadelauncher/underbarrel
	desc = "Основной образец индивидуального оружия личного состава пехотных и других подразделений Вооруженных сил Новой России, специальных подразделений правоохранительных органов. Использует 5,45мм патроны и имеет при себе подствольный 40-мм гранатомёт ГП-25."
	icon_state = "ak74mgl"
	inhand_icon_state = "ak74mgl"
	worn_icon_state = "ak74mgl_back"
// создаем гранатомет гп25
/obj/item/gun/ballistic/revolver/grenadelauncher/unrestricted/gp25
	fire_sound = 'white/rebolution228/sounds/weapons/fire_m41agrenadelauncher.ogg'
	mag_type = /obj/item/ammo_box/magazine/internal/grenadelauncher/gp25

//  добавляем гранатомет к оружию
/obj/item/gun/ballistic/automatic/ak74m/gp25/Initialize()
	. = ..()
	underbarrel = new /obj/item/gun/ballistic/revolver/grenadelauncher/unrestricted/gp25
	update_icon()

/obj/item/gun/ballistic/automatic/ak74m/gp25/afterattack(atom/target, mob/living/user, flag, params)
	if(select == 2)
		underbarrel.afterattack(target, user, flag, params)
	else
		return ..()

// создаем магазин для гранатомета 2
/obj/item/ammo_box/magazine/internal/grenadelauncher/gp25
	name = "ebalo"
	ammo_type = /obj/item/ammo_casing/a40mm/vog25
	caliber = "40mmvog"
	max_ammo = 1
//  гильзу посылаем нахуй
/obj/item/gun/ballistic/automatic/ak74m/gp25/attackby(obj/item/A, mob/user, params)
	if(istype(A, /obj/item/ammo_casing))
		if(istype(A, underbarrel.magazine.ammo_type))
			underbarrel.attack_self(user)
			underbarrel.attackby(A, user, params)
	else
		..()
// выстрел вог25
/obj/item/ammo_casing/a40mm/vog25
	name = "Выстрел ВОГ-25"
	desc = "Бум."
	caliber = "40mmvog"
	icon = 'white/rebolution228/icons/weapons/rammo.dmi'
	icon_state = "vog25"
	projectile_type = /obj/projectile/bullet/vog25
// проджектайл гп25
/obj/projectile/bullet/vog25
	name = "40mm round VOG"
	icon = 'white/rebolution228/icons/weapons/projectile.dmi'
	icon_state = "vog25"
	damage = 150
// настройки взрыва
/obj/projectile/bullet/vog25/on_hit(atom/target, blocked = FALSE)
	..()
	explosion(target, 0, 2, 3, 4, flame_range = 4)
	return BULLET_ACT_HIT
// гильзу опять нахуй посылаем
/obj/item/gun/ballistic/revolver/grenadelauncher/unrestricted/gp25/afterattack()
	. = ..()
	magazine.get_round(FALSE)
// даем возможность менять режимы стрельбы
/obj/item/gun/ballistic/automatic/ak74m/gp25/burst_select()
	var/mob/living/carbon/human/user = usr
	switch(select)
		if(0)
			select = 1
			burst_size = initial(burst_size)
			fire_delay = initial(fire_delay)
			to_chat(user, span_notice("Выбираю режим стрельбы очередью."))
		if(1)
			select = 2
			to_chat(user, span_notice("Выбираю режим стрельбы из подствольника."))
		if(2)
			select = 0
			burst_size = 1
			fire_delay = 0
			to_chat(user, span_notice("Выбираю полуавтоматический режим."))
	playsound(user, 'white/rebolution228/sounds/weapons/dryfire1.ogg', 100, TRUE)
	update_icon()
	return


///////////////////////////////////////////  HS 010 SMG
// наследие кулдена, нигде не используется, жестко лагает, планировалось добавить триторам
/obj/item/gun/ballistic/automatic/hs010
	name = "HS 010"
	desc = "Произведенный компанией CROON, этот пистолет-пулемёт прославлен за свою крайне высокую скорострельность. Использовался не только армиями различных частных корпораций, но и террористами всех сортов. Использует 2,5мм калибр."
	icon = 'white/rebolution228/icons/weapons/rguns.dmi'
	icon_state = "hs010"
	inhand_icon_state = "hs010"
	lefthand_file = 'white/rebolution228/icons/weapons/guns_inhand_left.dmi'
	righthand_file = 'white/rebolution228/icons/weapons/guns_inhand_right.dmi'
	mag_type = /obj/item/ammo_box/magazine/hs010
	pin = /obj/item/firing_pin
	fire_delay = 0
	burst_size = 1
	spread = 10
	w_class = WEIGHT_CLASS_NORMAL
	weapon_weight = WEAPON_LIGHT

	fire_sound = 'white/baldenysh/sounds/eyedc/HS_STEREO_FIRE_SOSANIE.ogg'
	fire_sound_volume = 25

	eject_sound = 'white/baldenysh/sounds/eyedc/hs_reload_02.wav'
	eject_empty_sound = 'white/baldenysh/sounds/eyedc/hs_reload_02.wav'
	load_sound = 'white/baldenysh/sounds/eyedc/hs_reload_02.wav'
	load_empty_sound = 'white/baldenysh/sounds/eyedc/hs_reload_02.wav'
	rack_sound = 'white/baldenysh/sounds/eyedc/hs_reload_03.wav'

	actions_types = list()
	can_suppress = FALSE
	var/fuller_auto = FALSE
	var/tail_sound = 'white/baldenysh/sounds/eyedc/HS_STEREO_FIRE_TAIL.wav'
// компонент для ствола, делающий звук зацикленным
/obj/item/gun/ballistic/automatic/hs010/Initialize()
	. = ..()
	AddComponent(/datum/component/automatic_fire_funny, 1)
	RegisterSignal(src, COMSIG_AUTOFIRE_STOPPED, .proc/play_tail_sound)

/obj/item/gun/ballistic/automatic/hs010/proc/play_tail_sound()
	SIGNAL_HANDLER
	playsound(get_turf(src), tail_sound, 50)
// режимы стрельбы
/obj/item/gun/ballistic/automatic/hs010/AltClick(mob/user)
	. = ..()
	fuller_auto = !fuller_auto
	balloon_alert(user, "режим: [fuller_auto ? "fuller" : "full"] auto")
	if(fuller_auto)
		var/datum/component/automatic_fire_funny/D = GetComponent(/datum/component/automatic_fire_funny)
		D.autofire_shot_delay = 0.1
		spread = 10
		fire_sound = 'white/baldenysh/sounds/eyedc/HS_STEREO_FIRE_HSPEED_SOSANIE.ogg'
		tail_sound = 'white/baldenysh/sounds/eyedc/HS_STEREO_FIRE_HSPEED_TAIL.wav'
	else
		var/datum/component/automatic_fire_funny/D = GetComponent(/datum/component/automatic_fire_funny)
		D.autofire_shot_delay = 1
		spread = 30
		fire_sound = 'white/baldenysh/sounds/eyedc/HS_STEREO_FIRE_SOSANIE.ogg'
		tail_sound = 'white/baldenysh/sounds/eyedc/HS_STEREO_FIRE_TAIL.wav'
// магазин
/obj/item/ammo_box/magazine/hs010
	name = "HS 010 Magazine"
	icon = 'white/rebolution228/icons/weapons/rammo.dmi'
	icon_state = "hs010ammo"
	ammo_type = /obj/item/ammo_casing/c25mm
	caliber = "c25mm"
	max_ammo = 100

/obj/item/ammo_box/magazine/hs010/update_icon()
	..()
	if(ammo_count() <= 0)
		icon_state = "hs010ammo_e"
	else
		icon_state = "hs010ammo"
// изначально пустой магазин
/obj/item/ammo_box/magazine/hs010/empty
	start_empty = TRUE
// патрон
/obj/item/ammo_casing/c25mm
	name = "2,5мм гильза"
	caliber = "c25mm"
	projectile_type = /obj/projectile/bullet/c25mm
// пуля
/obj/projectile/bullet/c25mm
	name = "2,5мм пуля"
	damage = 7
	armour_penetration = 0
	wound_bonus = 2
// коробка с патронами
/obj/item/ammo_box/c25mm
	name = "коробка с патронами (2,5mm)"
	icon_state = "10mmbox" //аааааааааааааааааааааааааааааааааааааааааааааааааааа?
	ammo_type = /obj/item/ammo_casing/c25mm
	max_ammo = 100
//  плата для диска, чтобы печатать патроны
/obj/item/disk/design_disk/adv/hs010_ammo
	name = "HS 010 Ammo and Mags"

/obj/item/disk/design_disk/adv/hs010_ammo/Initialize()
	. = ..()
	var/datum/design/hs010_mag/M = new
	var/datum/design/c25mm_box/B = new
	blueprints[1] = M
	blueprints[2] = B
// схема коробки в автолате
/datum/design/c25mm_box
	name = "Ammo Box (2.5mm)"
	desc = "Коробка патронов калибра 2,5мм."
	id = "hs010_ammo"
	build_type = AUTOLATHE
	materials = list(MAT_CATEGORY_RIGID = 30000)
	build_path = /obj/item/ammo_box/c25mm
	category = list("Импорт")
// схема магазина в автолате
/datum/design/hs010_mag
	name = "HS 010 Magazine"
	desc = "Это магазин......... Что еще сказать....."
	id = "hs010_mag"
	build_type = AUTOLATHE
	materials = list(MAT_CATEGORY_RIGID = 2500)
	build_path = /obj/item/ammo_box/magazine/hs010/empty
	category = list("Импорт")

///////////////////////////////////////////  AKSU74


/obj/item/gun/ballistic/automatic/aksu74
	name = "AKС-74У"
	desc = "Укороченный вариант АКС-74, разработанный примерно 500 лет назад для вооружения десантников и экипажа боевой техники. Использует 5,45мм патроны."
	icon = 'white/rebolution228/icons/weapons/rguns.dmi'
	icon_state = "aksu74"
	inhand_icon_state = "aksu74"
	selector_switch_icon = TRUE
	lefthand_file = 'white/rebolution228/icons/weapons/guns_inhand_left.dmi'
	righthand_file = 'white/rebolution228/icons/weapons/guns_inhand_right.dmi'
	worn_icon = 'white/rebolution228/icons/weapons/guns_back.dmi'
	mag_type = /obj/item/ammo_box/magazine/ak74m/orange
	pin = /obj/item/firing_pin
	fire_delay = 2
	burst_size = 3
	spread = 10
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_NORMAL
	weapon_weight = WEAPON_HEAVY
	worn_icon_state = "aksu74_back"
	rack_sound = 'white/rebolution228/sounds/weapons/74_zatvor.ogg'
	eject_sound = 'white/rebolution228/sounds/weapons/74_magout.ogg'
	eject_empty_sound = 'white/rebolution228/sounds/weapons/74_magout.ogg'
	load_sound = 'white/rebolution228/sounds/weapons/74_magout.ogg'
	load_empty_sound = 'white/rebolution228/sounds/weapons/74_magin.ogg'
	fire_sound = 'white/rebolution228/sounds/weapons/74_ebashit1.ogg'
	var/list/aksushoot = list('white/rebolution228/sounds/weapons/74_ebashit1.ogg',
							'white/rebolution228/sounds/weapons/74_ebashit2.ogg',
							'white/rebolution228/sounds/weapons/74_ebashit3.ogg')
	can_suppress = FALSE
// ну думаю тут очевидно
/obj/item/gun/ballistic/automatic/aksu74/process_chamber()
	. = ..()
	fire_sound = pick(aksushoot)
// магазин
/obj/item/ammo_box/magazine/ak74m/orange
	icon_state = "ak74"

/obj/item/ammo_box/magazine/ak74m/orange/update_icon()
	..()
	if(ammo_count() <= 0)
		icon_state = "ak74_e"
	else
		icon_state = "ak74"
//  компонент для смены иконки в руках
/obj/item/gun/ballistic/automatic/aksu74/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/gun/ballistic/automatic/aksu74/update_icon_state()
	inhand_icon_state = "[initial(icon_state)][magazine ? "":"_nmag"]"

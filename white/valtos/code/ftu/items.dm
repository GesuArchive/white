/obj/item/melee/energy/sword/ignis
	name = "FTU 'Ignis'"
	desc = "Дорогая конструкция FTU, Ignis - один из многих прототипов создания энергетического меча из плазмы, а не из жесткого света. У этого есть флаг FTU, отпечатанный на его высококачественной деревянной рукоятке, и, в отличие от более ранних моделей, он может выдержать несколько ударов, не разряжая батарею."
	icon = 'white/valtos/icons/serviceguns.dmi'
	icon_state = "ignis"
	icon_state_on = "ignis_active"
	lefthand_file = 'white/valtos/icons/lefthand_big.dmi'
	righthand_file = 'white/valtos/icons/righthand_big.dmi'
	force = 3
	force_on = 48
	block_chance = 65
	sharpness = SHARP_EDGED
	sword_color = null
	throwforce = 5
	throwforce_on = 40
	wound_bonus = 50
	hitsound = 'white/valtos/sounds/ignis_hit.ogg'
	throw_speed = 4
	throw_range = 10
	w_class = WEIGHT_CLASS_SMALL
	w_class_on = WEIGHT_CLASS_HUGE
	armour_penetration = 90
	attack_verb_on = list("разрывает", "выпаривает", "пробивает", "прорубает", "пилит", "протыкает", "уничтожает")
	resistance_flags = FIRE_PROOF
	damtype = BURN

/obj/item/melee/energy/sword/ignis/transform_messages(mob/living/user, supress_message_text)
	playsound(user, 'white/valtos/sounds/ignis_toggle.ogg', 35, TRUE)  //changed it from 50% volume to 35% because deafness
	if(!supress_message_text)
		to_chat(user, span_notice("[src] [active ? "теперь активен":"может быть убран"]."))


///////40x32 R37 PULSE RIFLE
/obj/item/gun/ballistic/automatic/pitbull/pulse/r37
	name = "Xan-Jing R37 'Шершень-убийца'"
	desc = "Импульсная винтовка Xan-Jing Armories, прозванная наемниками и экспедиторами FTU «Шершнем-убийцей». У этого есть встроенный компьютер, который отображает объективный компас, счетчик боеприпасов и поставляется со ссылкой на HUD для легкого прицеливания."
	icon = 'white/valtos/icons/serviceguns.dmi'
	righthand_file = 'white/valtos/icons/righthand_big.dmi'
	lefthand_file = 'white/valtos/icons/lefthand_big.dmi'
	inhand_icon_state = "killerhornet_lefthand"
	icon_state = "killerhornet"
	worn_icon = 'white/valtos/icons/serviceguns.dmi'
	worn_icon_state = "killerhornet_worn"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_OCLOTHING
	mag_type = /obj/item/ammo_box/magazine/pulse/r37
	fire_delay = 4
	can_suppress = FALSE
	burst_size = 5
	spread = 3
	mag_display = TRUE
	mag_display_ammo = TRUE
	fire_sound = 'white/valtos/sounds/r37.ogg'
	can_bayonet = FALSE
	can_flashlight = TRUE
	mag_type = /obj/item/ammo_box/magazine/pulse/r37

/obj/item/ammo_box/magazine/pulse/r37
	name = "коробчатый магазин 6.5mm XJP"
	icon = 'white/valtos/icons/mags.dmi'
	icon_state = "hornet"
	ammo_type = /obj/item/ammo_casing/pulse/mm65
	caliber = "6.5mm"
	max_ammo = 36


///////40x32 R40 MACHINE GUN
/obj/item/gun/ballistic/automatic/pitbull/pulse/r40
	name = "Xan-Jing R40 'Enforcer'"
	desc = "Средний пулемет Xan-Jing Armouries, прозванный наемниками FTU и частными военными \"Enforcer\". У этого есть сделанная на заказ деревянная мебель, а его батареи питают прицел."
	icon = 'white/valtos/icons/serviceguns.dmi'
	righthand_file = 'white/valtos/icons/lefthand_big.dmi'
	lefthand_file = 'white/valtos/icons/righthand_big.dmi'
	inhand_icon_state = "enforcer_righthand"
	icon_state = "enforcer"
	worn_icon = 'white/valtos/icons/serviceguns.dmi'
	worn_icon_state = "killerhornet_worn"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	mag_type = /obj/item/ammo_box/magazine/pulse/r40
	fire_delay = 1
	can_suppress = FALSE
	burst_size = 8
	spread = 5
	mag_display = TRUE
	mag_display_ammo = FALSE
	fire_sound = 'white/valtos/sounds/r40.ogg'
	can_bayonet = FALSE
	can_flashlight = TRUE
	mag_type = /obj/item/ammo_box/magazine/pulse/r40

/obj/item/ammo_box/magazine/pulse/r40
	name = "ленточный магазин 7.2mm XJP"
	icon = 'white/valtos/icons/mags.dmi'
	icon_state = "enforcer"
	ammo_type = /obj/item/ammo_casing/pulse/mm72
	caliber = "7.2mm"
	max_ammo = 140

//////////12.7 SAPHE GOLDEN EAGLE
/obj/item/gun/ballistic/automatic/pistol/pdh/pulse/golden_eagle
	name = "FTU PDH-6G 'Морская змея'"
	desc = "Изготовленный по индивидуальному заказу мощный боевой пистолет, который можно увидеть в руках высокопоставленных наемников FTU и важных руководителей, с отделкой из 24-каратного золота и зеленым лазерным прицелом. На его слайде выгравирован китайский дракон."
	icon = 'white/valtos/icons/serviceguns.dmi'
	icon_state = "eagle"
	can_suppress = FALSE
	mag_display = TRUE
	fire_sound = 'white/valtos/sounds/serpent_fire.ogg'
	fire_sound_volume = 100
	rack_sound = 'white/valtos/sounds/magnum_slide.ogg'
	lock_back_sound = 'sound/weapons/gun/pistol/slide_lock.ogg'
	bolt_drop_sound = 'sound/weapons/gun/pistol/slide_drop.ogg'
	w_class = WEIGHT_CLASS_NORMAL
	mag_type = /obj/item/ammo_box/magazine/pulse/mm12/saphe
	can_suppress = FALSE
	fire_delay = 25 //Mind your wrists.
	fire_sound_volume = 110
	rack_sound_volume = 110
	spread = 1
	can_flashlight = FALSE

/obj/item/ammo_box/magazine/pulse/mm12/saphe
	name = "магазин магнума 12.7x35mm SAP-HE"
	icon_state = "50ae"
	ammo_type = /obj/item/ammo_casing/pulse/mm12
	caliber = "12mm SAP-HE"
	max_ammo = 12

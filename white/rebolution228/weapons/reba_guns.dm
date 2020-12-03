// SPAS12

/obj/item/gun/ballistic/shotgun/spas12
	name = "Franchi SPAS-12"
	desc = "Древний, но эффективный дробовик, разработанный в Италии. Предназначался для использования силовыми структурами."
	icon_state = "spas12"
	icon = 'white/rebolution228/weapons/spas12.dmi'
	lefthand_file = 'white/rebolution228/weapons/guns_inhand_left.dmi'
	righthand_file = 'white/rebolution228/weapons/guns_inhand_right.dmi'
	inhand_icon_state = "spess12"
	worn_icon = 'white/rebolution228/weapons/guns_back.dmi'
	worn_icon_state = "spas12_back"
	fire_sound = 'white/rebolution228/weapons/sounds/spas_shoot.ogg'
	rack_sound = 'white/rebolution228/weapons/sounds/spas_pump.ogg'
	load_sound = 'white/rebolution228/weapons/sounds/spas_insert.ogg'
	w_class = WEIGHT_CLASS_BULKY
	mag_type = /obj/item/ammo_box/magazine/internal/shot/com/eight
	weapon_weight = WEAPON_HEAVY
	pb_knockback = 1
	fire_delay = 5
	inhand_x_dimension = 32
	inhand_y_dimension = 32

/obj/item/gun/ballistic/shotgun/spas12/rubber
	mag_type = /obj/item/ammo_box/magazine/internal/shot/riot/eight

/obj/item/ammo_box/magazine/internal/shot/com/eight // lethal rounds
	max_ammo = 8

/obj/item/ammo_box/magazine/internal/shot/riot/eight // rubber rounds
	max_ammo = 8


// M41A MKII

/obj/item/gun/ballistic/automatic/m41a2
	var/obj/item/gun/ballistic/revo	lver/grenadelauncher/underbarrel
	name = "M41A Pulse Rifle MK.II"
	desc = "Новая версия громоздкой импульсной винтовки, оснащенная подствольным гранатомётом. Использует безгильзовые 10х24мм патроны."
	icon = 'white/rebolution228/weapons/rguns.dmi'
	icon_state = "m41a2"
	inhand_icon_state = "m41a2"
	selector_switch_icon = TRUE
	lefthand_file = 'white/rebolution228/weapons/guns_inhand_left.dmi'
	righthand_file = 'white/rebolution228/weapons/guns_inhand_right.dmi'
	mag_type = /obj/item/ammo_box/magazine/m41a/caseless
	worn_icon = 'white/rebolution228/weapons/guns_back.dmi'
	worn_icon_state = "m41a2_back"
	pin = /obj/item/firing_pin
	fire_delay = 1.5
	slot_flags = ITEM_SLOT_BACK
	burst_size = 4
	empty_indicator = TRUE
	spread = 5
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_MEDIUM
	fire_sound = 'white/rebolution228/weapons/sounds/fire_m41a1.ogg'

/obj/item/gun/ballistic/automatic/m41a2/Initialize()
	. = ..()
	underbarrel = new /obj/item/gun/ballistic/revolver/grenadelauncher/unrestricted/m41a
	update_icon()

/obj/item/gun/ballistic/automatic/m41a2/afterattack(atom/target, mob/living/user, flag, params)
	if(select == 2)
		underbarrel.afterattack(target, user, flag, params)
	else
		return ..()

/obj/item/gun/ballistic/automatic/m41a2/burst_select()
	var/mob/living/carbon/human/user = usr
	switch(select)
		if(0)
			select = 1
			burst_size = initial(burst_size)
			fire_delay = initial(fire_delay)
			to_chat(user, "<span class='notice'>Выбираю режим стрельбы очередью.</span>")
		if(1)
			select = 2
			to_chat(user, "<span class='notice'>Выбран режим гранатомёта.</span>")
		if(2)
			select = 0
			burst_size = 1
			fire_delay = 0
			to_chat(user, "<span class='notice'>Выбран полуавтоматический режим.</span>")
	playsound(user, 'white/rebolution228/weapons/sounds/dryfire1.ogg', 100, TRUE)
	update_icon()
	return

/obj/item/gun/ballistic/automatic/m41a2/update_overlays()
	. = ..()
	switch(select)
		if(0)
			. += "[initial(icon_state)]_semi"
		if(1)
			. += "[initial(icon_state)]_burst"
		if(2)
			. += "[initial(icon_state)]_gren"

/obj/item/gun/ballistic/automatic/m41a2/attackby(obj/item/A, mob/user, params)
	if(istype(A, /obj/item/ammo_casing))
		if(istype(A, underbarrel.magazine.ammo_type))
			underbarrel.attack_self(user)
			underbarrel.attackby(A, user, params)
	else
		..()

/obj/item/gun/ballistic/automatic/m41a2/update_icon()
	..()
	if(magazine)
		icon_state = "m41a2"
		if(magazine.ammo_count() <= 0)
			icon_state = "m41a2_nm"
	else
		icon_state = "m41a2_e"

/obj/item/gun/ballistic/automatic/m41a2/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, require_twohands=TRUE, force_unwielded=10, force_wielded=10)

// m41a2 ammo

/obj/item/ammo_box/magazine/m41a/caseless
	name = "M41A2 Magazine"
	icon = 'white/rebolution228/weapons/rammo.dmi'
	icon_state = "m41a2"
	ammo_type = /obj/item/ammo_casing/caseless/m41acaseless
	caliber = "10x24mm"
	max_ammo = 99

/obj/item/ammo_box/magazine/m41a/caseless/update_icon()
	..()
	if(ammo_count() <= 0)
		icon_state = "m41a2_e"
	else
		icon_state = "m41a2"

/obj/projectile/bullet/m41acaseless
	name = "10x24мм пуля"
	damage = 35
	armour_penetration = 25
	wound_bonus = -40

/obj/item/ammo_casing/caseless/m41acaseless
	name = "10x24мм патрон"
	projectile_type = /obj/projectile/bullet/m41acaseless

/obj/item/gun/ballistic/revolver/grenadelauncher/unrestricted/m41a
	fire_sound = 'white/rebolution228/weapons/sounds/fire_m41agrenadelauncher.ogg'
	mag_type = /obj/item/ammo_box/magazine/internal/grenadelauncher/m41a

/obj/item/ammo_box/magazine/internal/grenadelauncher/m41a
	max_ammo = 2

/obj/item/gun/ballistic/revolver/grenadelauncher/unrestricted/m41a/afterattack()
	. = ..()
	magazine.get_round(FALSE)

/obj/item/gun/ballistic/automatic/toy
	name = "игрушечный ПП"
	desc = "Прототип стреляющего трехзарядной очередью из пены игрушечного пистолета. Для лиц старше 8 лет."
	icon_state = "saber"
	selector_switch_icon = TRUE
	inhand_icon_state = "gun"
	mag_type = /obj/item/ammo_box/magazine/toy/smg
	fire_sound = 'sound/items/syringeproj.ogg'
	auto_fire = TRUE
	force = 0
	throwforce = 0
	burst_size = 3
	can_suppress = TRUE
	clumsy_check = FALSE
	item_flags = NONE
	gun_flags = TOY_FIREARM_OVERLAY
	casing_ejector = FALSE

/obj/item/gun/ballistic/automatic/toy/unrestricted
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/automatic/pistol/toy
	name = "игрушечный пистолет"
	desc = "Маленький игрушечный пистолет, стреляющий пеной. Для лиц старше 8 лет."
	mag_type = /obj/item/ammo_box/magazine/toy/pistol
	auto_fire = TRUE
	fire_sound = 'sound/items/syringeproj.ogg'
	gun_flags = TOY_FIREARM_OVERLAY

/obj/item/gun/ballistic/automatic/pistol/toy/riot
	mag_type = /obj/item/ammo_box/magazine/toy/pistol/riot

/obj/item/gun/ballistic/automatic/pistol/riot/Initialize(mapload)
	magazine = new /obj/item/ammo_box/magazine/toy/pistol/riot(src)
	return ..()

/obj/item/gun/ballistic/shotgun/toy
	name = "игрушечный дробовик"
	desc = "Стреляющий пеной игрушечный дробовик в деревянном оформлении, емкостью в 4 патрона. Для лиц старше 8 лет.."
	force = 0
	throwforce = 0
	mag_type = /obj/item/ammo_box/magazine/internal/shot/toy
	fire_sound = 'sound/items/syringeproj.ogg'
	clumsy_check = FALSE
	item_flags = NONE
	casing_ejector = FALSE
	can_suppress = FALSE
	pb_knockback = 0
	gun_flags = TOY_FIREARM_OVERLAY

/obj/item/gun/ballistic/shotgun/toy/handle_chamber(empty_chamber = TRUE, from_firing = TRUE, chamber_next_round = TRUE, atom/shooter = null)
	..()
	if(chambered && !chambered.loaded_projectile)
		qdel(chambered)

/obj/item/gun/ballistic/shotgun/toy/unrestricted
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/shotgun/toy/crossbow
	name = "игрушечный арбалет"
	desc = "Фаворит среди стреляющего пеной оружия среди множества гиперактивных детей. Для лиц старше 8 лет."
	icon = 'icons/obj/toy.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	icon_state = "foamcrossbow"
	inhand_icon_state = "crossbow"
	worn_icon_state = "gun"
	worn_icon = null
	mag_type = /obj/item/ammo_box/magazine/internal/shot/toy/crossbow
	fire_sound = 'sound/items/syringeproj.ogg'
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	gun_flags = NONE

/obj/item/gun/ballistic/automatic/c20r/toy //This is the syndicate variant with syndicate firing pin and riot darts.
	name = "donksoft SMG"
	desc = "A bullpup three-round burst toy SMG, designated 'C-20r'. Ages 8 and up."
	can_suppress = TRUE
	item_flags = NONE
	mag_type = /obj/item/ammo_box/magazine/toy/smgm45/riot
	casing_ejector = FALSE
	clumsy_check = FALSE
	gun_flags = TOY_FIREARM_OVERLAY

/obj/item/gun/ballistic/automatic/c20r/toy/unrestricted //Use this for actual toys
	pin = /obj/item/firing_pin
	mag_type = /obj/item/ammo_box/magazine/toy/smgm45

/obj/item/gun/ballistic/automatic/c20r/toy/unrestricted/riot
	mag_type = /obj/item/ammo_box/magazine/toy/smgm45/riot

/obj/item/gun/ballistic/automatic/l6_saw/toy //This is the syndicate variant with syndicate firing pin and riot darts.
	name = "donksoft LMG"
	desc = "A heavily modified toy light machine gun, designated 'L6 SAW'. Ages 8 and up."
	fire_sound = 'sound/items/syringeproj.ogg'
	can_suppress = FALSE
	item_flags = NONE
	mag_type = /obj/item/ammo_box/magazine/toy/m762/riot
	casing_ejector = FALSE
	clumsy_check = FALSE
	gun_flags = TOY_FIREARM_OVERLAY

/obj/item/gun/ballistic/automatic/l6_saw/toy/unrestricted //Use this for actual toys
	pin = /obj/item/firing_pin
	mag_type = /obj/item/ammo_box/magazine/toy/m762

/obj/item/gun/ballistic/automatic/l6_saw/toy/unrestricted/riot
	mag_type = /obj/item/ammo_box/magazine/toy/m762/riot

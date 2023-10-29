//Fallout 13 related guns and variables to inherent

/obj/item/gun/ballistic/fallout
	name = "generic fallout gun"
	icon = 'white/valtos/icons/fallout/ballistics.dmi'
	lefthand_file = 'white/valtos/icons/fallout/guns_lefthand.dmi'
	righthand_file = 'white/valtos/icons/fallout/guns_righthand.dmi'
	legacy_icon_handler = TRUE

//Fallout version for shotguns
/obj/item/gun/ballistic/shotgun/fallout
	name = "generic fallout gun"
	icon = 'white/valtos/icons/fallout/ballistics.dmi'
	lefthand_file = 'white/valtos/icons/fallout/guns_lefthand.dmi'
	righthand_file = 'white/valtos/icons/fallout/guns_righthand.dmi'
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	legacy_icon_handler = TRUE

/obj/item/gun/ballistic/shotgun/fallout/update_legacy_icon()
	icon_state = "[initial(icon_state)][magazine.ammo_count() ? "" : "_e"]"

//Automatic shotguns
/obj/item/gun/ballistic/shotgun/automatic/fallout
	name = "generic fallout gun"
	icon = 'white/valtos/icons/fallout/ballistics.dmi'
	lefthand_file = 'white/valtos/icons/fallout/guns_lefthand.dmi'
	righthand_file = 'white/valtos/icons/fallout/guns_righthand.dmi'
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	legacy_icon_handler = TRUE

//Revolvers
/obj/item/gun/ballistic/revolver/fallout
	name = "generic fallout gun"
	icon = 'white/valtos/icons/fallout/ballistics.dmi'
	lefthand_file = 'white/valtos/icons/fallout/guns_lefthand.dmi'
	righthand_file = 'white/valtos/icons/fallout/guns_righthand.dmi'
	legacy_icon_handler = TRUE

/obj/item/gun/ballistic/revolver/fallout/update_legacy_icon()
	icon_state = "[initial(icon_state)][magazine.ammo_count() ? "" : "_e"]"

//Automatics
/obj/item/gun/ballistic/automatic/fallout
	name = "generic fallout gun"
	icon = 'white/valtos/icons/fallout/ballistics.dmi'
	lefthand_file = 'white/valtos/icons/fallout/guns_lefthand.dmi'
	righthand_file = 'white/valtos/icons/fallout/guns_righthand.dmi'
	force = 20
	auto_fire = FALSE
	legacy_icon_handler = TRUE

//Pistols
/obj/item/gun/ballistic/automatic/pistol/fallout
	name = "generic fallout gun"
	desc = "complain when seeing this"
	icon = 'white/valtos/icons/fallout/ballistics.dmi'
	lefthand_file = 'white/valtos/icons/fallout/guns_lefthand.dmi'
	righthand_file = 'white/valtos/icons/fallout/guns_righthand.dmi'
	auto_fire = FALSE
	legacy_icon_handler = TRUE

//Bolt-actions
/obj/item/gun/ballistic/rifle/fallout
	name = "generic fallout gun"
	icon = 'white/valtos/icons/fallout/ballistics.dmi'
	lefthand_file = 'white/valtos/icons/fallout/guns_lefthand.dmi'
	righthand_file = 'white/valtos/icons/fallout/guns_righthand.dmi'
	internal_magazine = FALSE
	tac_reloads = TRUE
	legacy_icon_handler = TRUE

/obj/item/gun/ballistic/rifle/fallout/update_legacy_icon()
	icon_state = "[initial(icon_state)][magazine.ammo_count() ? "" : "_e"]"

//Loaders/Ammo boxes
/obj/item/ammo_box/fallout
	name = "generic fallout ammo box"
	icon = 'white/valtos/icons/fallout/ammo.dmi'
	multiple_sprites = AMMO_BOX_PER_BULLET

//Magazines
/obj/item/ammo_box/magazine/fallout
	name = "generic fallout magazine"
	icon = 'white/valtos/icons/fallout/ammo.dmi'
	multiple_sprites = AMMO_BOX_PER_BULLET

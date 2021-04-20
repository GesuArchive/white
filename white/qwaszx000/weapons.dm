/*
Arrow&bow
*/
/obj/item/reagent_containers/syringe/arrow
	name = "Arrow"
	desc = "A arrow that can hold up to 5 units."
	icon = 'icons/obj/projectiles.dmi'
	inhand_icon_state = "arrow"
	icon_state = "arrow"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list()
	volume = 5
	mode = SYRINGE_DRAW
	busy = FALSE
	proj_piercing = 0
	//materials = list(/datum/material/iron=10, /datum/material/glass=20)
	//container_type = TRANSPARENT

/obj/item/reagent_containers/syringe/arrow/update_icon()
	cut_overlays()

/obj/projectile/bullet/dart/syringe/bow//Arrow
	name = "arrow"
	icon_state = "bolter"
	damage = 10
	piercing = FALSE

/obj/item/ammo_casing/syringegun/bow//Bow chamber
	name = "Arrow"
	desc = "A high-power spring that throws arrows."
	projectile_type = /obj/projectile/bullet/dart/syringe/bow
	firing_effect_type = null

/obj/item/gun/syringe/bow//Bow
	name = "Bow"
	desc = "Bow"
	icon_state = "bow_unloaded"
	inhand_icon_state = "bow_unloaded"
	force = 10

/obj/item/gun/syringe/bow/examine(mob/user)
	..()
	to_chat(user, "Can hold [max_syringes] arrow\s. Has [syringes.len] arrow\s remaining.")

/obj/item/gun/syringe/bow/Initialize()
	. = ..()

	chambered = new /obj/item/ammo_casing/syringegun/bow(src)

/obj/item/gun/syringe/bow/attackby(obj/item/A, mob/user, params, show_msg = TRUE)
	if(istype(A, /obj/item/reagent_containers/syringe/arrow))
		if(syringes.len < max_syringes)
			if(!user.transferItemToLoc(A, src))
				return FALSE
			to_chat(user, "<span class='notice'>You load [A] into <b>[src.name]</b>.</span>")
			syringes += A
			recharge_newshot()
			return TRUE
		else
			to_chat(user, "<span class='warning'>[capitalize(src.name)] cannot hold more syringes!</span>")
	return FALSE

/datum/crafting_recipe/bow_h
	name = "Bow"
	result = /obj/item/gun/syringe/bow
	reqs = list(/obj/item/stack/cable_coil = 5,/obj/item/stack/sheet/mineral/wood = 10)
	time = 100
	category= CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/arrow_h
	name = "Arrow"
	result = /obj/item/reagent_containers/syringe/arrow
	reqs = list(/obj/item/stack/rods = 1)
	tool_behaviors = list(TOOL_WIRECUTTER)
	time = 25
	category= CAT_WEAPONRY
	subcategory = CAT_WEAPON

//M41A

/obj/item/gun/ballistic/automatic/M41A
	name = "M41A rifle"
	desc = "Rifle."
	icon = 'white/qwaszx000/sprites/M41A.dmi'
	icon_state = "M41A"
	inhand_icon_state = "M41A"
	mag_type = /obj/item/ammo_box/magazine/m41a
	pin = /obj/item/firing_pin
	fire_delay = 2
	can_suppress = FALSE
	burst_size = 5
	actions_types = list(/datum/action/item_action/toggle_firemode)
	can_bayonet = FALSE
	lefthand_file = 'white/qwaszx000/sprites/left_hand.dmi'
	righthand_file = 'white/qwaszx000/sprites/right_hand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_MEDIUM
	fire_sound = 'white/qwaszx000/sounds/pulse_rifle_01.ogg'

/obj/item/gun/ballistic/automatic/M41A/update_icon()
	..()
	if(magazine)
		icon_state = "M41A"
		if(magazine.ammo_count() <= 0)
			icon_state = "M41A_noammo"
	else
		icon_state = "M41A_withoutmag"

/obj/item/ammo_box/magazine/m41a
	name = "m41a magazine"
	icon = 'white/qwaszx000/sprites/M41A.dmi'
	icon_state = "ammo"
	ammo_type = /obj/item/ammo_casing/c46x30mm
	caliber = "4.6x30mm"
	max_ammo = 30

/obj/item/ammo_box/magazine/m41a/update_icon()
	..()
	if(ammo_count() <= 0)
		icon_state = "ammo_e"
	else
		icon_state = "ammo"

/*
 * New taser
 */

/obj/item/gun/ballistic/stabba_taser
	name = "Taser"
	desc = "updated taser."
	icon = 'white/qwaszx000/sprites/stabba_taser.dmi'
	icon_state = "taser_gun"
	inhand_icon_state = "stabba_taser"
	lefthand_file = 'white/qwaszx000/sprites/stabba_taser_left.dmi'
	righthand_file = 'white/qwaszx000/sprites/stabba_taser_right.dmi'
	pin = /obj/item/firing_pin
	mag_type = /obj/item/ammo_box/magazine/internal/stabba_taser_magazine
	internal_magazine = TRUE

/obj/item/ammo_box/magazine/internal/stabba_taser_magazine
	name = "stabba taser magazine"
	icon = null
	icon_state = null
	ammo_type = /obj/item/ammo_casing/caseless/stabba_taser_projectile_casing
	caliber = "taser"
	max_ammo = 3
	start_empty = FALSE

/obj/item/ammo_box/magazine/internal/stabba_taser_magazine/give_round(obj/item/ammo_casing/R, replace_spent = 0)
	return FALSE

/obj/item/ammo_casing/caseless/stabba_taser_projectile_casing
	name = "taser bullet"
	desc = "Bzzzt"
	icon = 'white/qwaszx000/sprites/stabba_taser.dmi'
	icon_state = "taser_projectile"
	throwforce = 1
	projectile_type = /obj/projectile/bullet/stabba_taser_projectile
	firing_effect_type = null
	caliber = "taser"
	heavy_metal = FALSE

/obj/projectile/bullet/stabba_taser_projectile
	name = "taser projectile"
	desc = "Bzzt"
	icon = 'white/qwaszx000/sprites/stabba_taser.dmi'
	icon_state = "taser_projectile"
	damage = 0
	nodamage = TRUE
	stamina = 10
	speed = 1
	range = 25
	embedding = list(embed_chance=100, fall_chance=7, pain_stam_pct=10, pain_mult=1, pain_chance=80)


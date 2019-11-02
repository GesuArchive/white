//Shitty variant of the normal bolt action rifle.
/obj/item/weapon/gun/projectile/shotgun/pump/boltaction/shitty
	name = "\improper Mark I Stormrider"
	desc = "The much, much older brother of the sleaker, better, Mark II. Kind of a piece of shit."
	icon_state = "mosin2"
	item_state = "mosin2"
	wielded_item_state = "mosin2-wielded"
	jam_chance = 15
	//pumpsound = 'sound/weapons/newrifle_reload.ogg'
	fire_sound = "brifle"
	caliber = "763"
	ammo_type = /obj/item/ammo_casing/brifle

/obj/item/weapon/gun/projectile/shotgun/pump/boltaction/shitty/bayonet
	name = "\improper Mark I Stormrider"
	desc = "The much, much older brother of the sleaker, better, Mark II. This one has a bayonet."
	icon_state = "mosin2-bayonet"
	force = 15
	sharp = 1
	attack_verb = list ("stabbed", "sliced")
	hitsound = "stab_sound"


/obj/item/weapon/gun/projectile/shotgun/pump/boltaction/shitty/pump(mob/M as mob)
	..()
	M.visible_message("[M] pushes the bolt of \the [src.name]")//For deaf people.


//Paryying.
/obj/item/weapon/gun/projectile/shotgun/pump/boltaction/handle_shield(mob/living/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(default_sword_parry(user, damage, damage_source, attacker, def_zone, attack_text))
		return 1
	return 0

/*
//This is OP at the moment.
/obj/item/weapon/gun/projectile/shotgun/pump/boltaction/verb/scope()
	set category = "Object"
	set name = "Use Iron Sights"
	set popup_menu = 1

	toggle_scope(usr, 2.0)
*/


//AMMO
/obj/item/ammo_casing/brifle
	desc = "An old worn out looking bullet casing."
	caliber = "763"
	projectile_type = /obj/item/projectile/bullet/rifle/a762/brifle
	icon_state = "rifle-casing"
	spent_icon = "rifle-casing-spent"

/obj/item/projectile/bullet/rifle/a762/brifle
	fire_sound = "brifle"
	penetration_modifier = 1.5



//Shitty shotgun
/obj/item/weapon/gun/projectile/shotgun/pump/shitty
	name = "\improper WTX Frontier Special"
	desc = "A common shotgun used on the frontiers of space. It's not the best made and is prone to jamming."
	jam_chance = 15

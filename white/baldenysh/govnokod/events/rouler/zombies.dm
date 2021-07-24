/datum/species/zombie/infectious/event
	name = "Event Zombie"
	id = "eventzombies"
	mutanteyes = /obj/item/organ/eyes/night_vision/alien

//////////////////////////////////////////////////////////generic

/datum/species/zombie/infectious/event/generic
	name = "Generic Event Zombie"
	id = "eventzombies_generic"
	armor = 30

//////////////////////////////////////////////////////////armblade

/datum/species/zombie/infectious/event/armblade
	name = "Armblade Event Zombie"
	id = "eventzombies_armblade"
	armor = 50
	mutanthands = /obj/item/melee/arm_blade
	speedmod = 1.8

//////////////////////////////////////////////////////////tentacle

/datum/species/zombie/infectious/event/tentacle
	name = "Tentacle Event Zombie"
	id = "eventzombies_tentacle"
	armor = 10
	mutanthands = /obj/item/gun/magic/tentacle/eventzombie

/obj/item/gun/magic/tentacle/eventzombie
	recharge_rate = 1 MINUTES
	should_del = FALSE
	force = 21
	item_flags = NEEDS_PERMIT | ABSTRACT | DROPDEL
	hitsound = 'sound/effects/splat.ogg'
	ammo_type = /obj/item/ammo_casing/magic/tentacle/eventzombie

/obj/item/ammo_casing/magic/tentacle/eventzombie
	projectile_type = /obj/projectile/tentacle/eventzombie

/obj/projectile/tentacle/eventzombie
	range = 7

//////////////////////////////////////////////////////////fast

/datum/species/zombie/infectious/event/fast
	name = "Fast Event Zombie"
	id = "eventzombies_fast"
	armor = 0
	speedmod = 0

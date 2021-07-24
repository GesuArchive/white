/datum/component/zombie_weapon/event
	possible_tumors = list(
		/obj/item/organ/zombie_infection/eventzombie/armblade,
		/obj/item/organ/zombie_infection/eventzombie/tentacle,
		/obj/item/organ/zombie_infection/eventzombie/fast
	)

/datum/species/zombie/infectious/event
	name = "Event Zombie"
	id = "eventzombies"
	mutanteyes = /obj/item/organ/eyes/night_vision/alien

//////////////////////////////////////////////////////////armblade

/datum/species/zombie/infectious/event/armblade
	name = "Armblade Event Zombie"
	id = "eventzombies_armblade"
	armor = 50
	mutanthands = /obj/item/melee/arm_blade/eventzombie
	speedmod = 1.8

/////////////////////////////organ

/obj/item/organ/zombie_infection/eventzombie/armblade
	zombie_species = /datum/species/zombie/infectious/event/armblade

/////////////////////////////weapon

/obj/item/melee/arm_blade/eventzombie/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/zombie_weapon/event)

/obj/item/melee/arm_blade/eventzombie/equipped(mob/user, slot)
	. = ..()
	if(!(user.get_held_index_of_item(src) % 2))
		var/matrix/M = matrix()
		M.Scale(-1,1)
		transform = M

//////////////////////////////////////////////////////////tentacle

/datum/species/zombie/infectious/event/tentacle
	name = "Tentacle Event Zombie"
	id = "eventzombies_tentacle"
	armor = 10
	mutanthands = /obj/item/gun/magic/tentacle/eventzombie

/////////////////////////////organ

/obj/item/organ/zombie_infection/eventzombie/tentacle
	zombie_species = /datum/species/zombie/infectious/event/tentacle

/////////////////////////////weapon

/obj/item/gun/magic/tentacle/eventzombie
	recharge_rate = 1 MINUTES
	should_del = FALSE
	force = 21
	item_flags = NEEDS_PERMIT | ABSTRACT | DROPDEL
	hitsound = 'sound/effects/splat.ogg'
	ammo_type = /obj/item/ammo_casing/magic/tentacle/eventzombie

/obj/item/gun/magic/tentacle/eventzombie/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/zombie_weapon/event)

/obj/item/gun/magic/tentacle/eventzombie/equipped(mob/user, slot)
	. = ..()
	if(!(user.get_held_index_of_item(src) % 2))
		var/matrix/M = matrix()
		M.Scale(-1,1)
		transform = M

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

/////////////////////////////organ

/obj/item/organ/zombie_infection/eventzombie/fast
	zombie_species = /datum/species/zombie/infectious/event/fast

/////////////////////////////weapon //надо обычные зомбируки переделать чтоб они во все типы инфецировать могли могли

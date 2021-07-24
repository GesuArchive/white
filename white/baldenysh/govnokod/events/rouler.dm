/mob/living/carbon/human/species/zombie/event


/datum/species/zombie/infectious/event
	name = "Event Zombie"
	id = "eventzombies"
	mutanteyes = /obj/item/organ/eyes/night_vision/alien



/datum/species/zombie/infectious/event/generic
	name = "Generic Event Zombie"
	id = "eventzombies_generic"
	armor = 30

/datum/species/zombie/infectious/event/armblade
	name = "Armblade Event Zombie"
	id = "eventzombies_armblade"
	armor = 50

/datum/species/zombie/infectious/event/tentacle
	name = "Tentacle Event Zombie"
	id = "eventzombies_tentacle"
	armor = 10
	mutanthands = /obj/item/gun/magic/tentacle/eventzombie

/obj/item/gun/magic/tentacle/eventzombie
	recharge_rate = 10 SECONDS
	should_del = FALSE
	force = 15
	item_flags = NEEDS_PERMIT | ABSTRACT | DROPDEL

/datum/species/zombie/infectious/event/fast
	name = "Generic Event Zombie"
	id = "eventzombies_fast"
	armor = 0
	speedmod = 0

/obj/item/gun/magic/tentacle

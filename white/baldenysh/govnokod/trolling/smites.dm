/datum/smite/human_rocket_click
	name = "Human Rocket (Point Controls)"

/datum/smite/human_rocket_click/effect(client/user, mob/living/target)
	. = ..()
	target.AddComponent(/datum/component/human_rocket)

/datum/smite/human_rocket_tank_controls
	name = "Human Rocket (Tank Controls)"

/datum/smite/human_rocket_tank_controls/effect(client/user, mob/living/target)
	. = ..()
	target.AddComponent(/datum/component/human_rocket/tank_controls)

/datum/smite/make_weapons_nodrop
	name = "Make All Weapons Nodrop"

/datum/smite/make_weapons_nodrop/effect(client/user, mob/living/target)
	. = ..()
	for(var/obj/item/I in target.get_contents())
		if(I.force > 15 || isgun(I))
			ADD_TRAIT(I, TRAIT_NODROP, "funny_trolling")

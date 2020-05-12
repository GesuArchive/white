/datum/map_template/ruin/space/bseruin
	id = "bseruin"
	suffix = "bseruin.dmm"
	name = "BSE Ruin"
	always_place = TRUE
	allow_duplicates = FALSE
	description = "Аааааааааааааааа. А."


/area/ruin/space/has_grav/bseruin
	name = "BSE Ruin"
	icon_state = "yellow"

/area/ruin/space/has_grav/bseruin/asteroid
	name = "Asteroid"
	icon_state = "yellow"

/area/ruin/space/has_grav/bseruin/foam
	name = "Foam"
	icon_state = "bluenew"

/area/ruin/space/has_grav/bseruin/ntnet
	name = "Building 1"
	icon_state = "tcomsatcham"

/area/ruin/space/has_grav/bseruin/shop
	name = "Building 2"
	icon_state = "storage"

/area/ruin/space/has_grav/bseruin/backyard
	name = "Building 3"
	icon_state = "red"


/obj/effect/mob_spawn/human/ethereal
	mob_species = /datum/species/ethereal


/obj/effect/mob_spawn/human/smuggler
	name = "stasis unit"
	desc = "A humming sleeper with a silhouetted occupant inside."
	mob_name = "контрабандист"
	icon = 'icons/obj/lavaland/spawners.dmi'
	icon_state = "cryostasis_sleeper"
	outfit = /datum/outfit/smuggler
	roundstart = FALSE
	death = FALSE
	random = TRUE
	mob_species = /datum/species/human
	short_desc = "Прив вы контрабандист. Че как делать думай сам."
	assignedrole = "Контрабандист"

/obj/effect/mob_spawn/human/smuggler/Destroy()
	new /obj/machinery/stasis/survival_pod(get_turf(src))
	return ..()

/datum/outfit/smuggler
	name = "Smuggler"
	uniform = /obj/item/clothing/under/suit/charcoal
	shoes = /obj/item/clothing/shoes/laceup
	r_hand = /obj/item/storage/secure/briefcase

/obj/item/storage/secure/briefcase/smuggler/PopulateContents()
	new /obj/item/modular_computer/laptop/preset/civilian

/obj/effect/mob_spawn/human/dukra
	name = "спящий больной"
	desc = "Накачался и спит."
	icon_state = "corpsegreytider"
	roundstart = FALSE
	death = FALSE
	short_desc = "Я точно не болен... Врачи убийцы держат меня тут насильно... Надо придумать способ сбежать отсюда..."
	flavour_text = "Сбежать из дурки."
	outfit = /datum/outfit/durka
	assignedrole = "Больной"

/datum/outfit/durka
	name = "Больной"
	uniform = /obj/item/clothing/under/color/white
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit = /obj/item/clothing/suit/straight_jacket
	back = null

/datum/outfit/durka/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return
	var/new_name = H.dna.species.random_name(H.gender, TRUE)
	H.fully_replace_character_name(H.real_name, new_name)
	H.regenerate_icons()
	H.add_quirk(pick(SSquirks.hardcore_quirks), TRUE)

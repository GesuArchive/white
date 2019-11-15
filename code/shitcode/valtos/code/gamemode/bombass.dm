/area/awaymission/bombass
	name = "bombass"
	icon_state = "awaycontent6"
	requires_power = FALSE
	noteleport = TRUE
	has_gravity = TRUE
	mood_bonus = 150
	mood_message = "<span class='nicegreen'>СЕГОДНЯ Я УМРУ!\n</span>"

/obj/structure/closet/bombcloset/bombsquad
	name = "\improper BOMBSQUAD closet"
	anchored = TRUE

/obj/structure/closet/bombcloset/bombsquad/PopulateContents()
	..()
	new /obj/item/clothing/suit/bomb_suit(src)
	new /obj/item/clothing/under/color/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/head/bomb_hood/bombsquad(src)

/obj/item/clothing/head/bomb_hood/bombsquad
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR


/obj/effect/landmark/start/bombsquad
	name = "Defender"
	icon_state = "Assistant"

/obj/effect/landmark/start/bombscmd
	name = "Defend Commander"
	icon_state = "Chaplain"

/datum/outfit/job/bombsquad
	name = "BombMeat uniform"

	jobtype = /datum/job/bombmeat
	id = /obj/item/card/id

/datum/job/bombmeat
	title = "Defender"
	faction = "Assault"

	total_positions = 32
	spawn_positions = 32
	current_positions = 0
	selection_color = "#ff0000"
	minimal_player_age = 0
	outfit = /datum/outfit/job/bombsquad

	display_order = JOB_DISPLAY_ORDER_DEFAULT

/obj/effect/mob_spawn/human/bombmeat
	name = "кровавая капсула"
	desc = "Промёрзшая изнутри капсула. Если присмотреться, то внутри находится спящий человек."
	mob_name = "Бомбасист"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	roundstart = FALSE
	death = FALSE
	random = FALSE
	oxy_damage = 20
	mob_species = /datum/species/human
	flavour_text = "<span class='big bold'>ПОРА УМИРАТЬ!</b>"
	uniform = /datum/outfit/job/assistant
	shoes = null
	assignedrole = "Bombmeat"

/obj/effect/mob_spawn/human/bombmeat/equip(mob/living/carbon/human/H)
	. = ..()
	if(H.gender==FEMALE)
		H.real_name = "Бомбасистка [capitalize(pick(GLOB.first_names_female))]"
	else
		H.real_name = "Бомбасист [capitalize(pick(GLOB.first_names_male))]"

/obj/effect/mob_spawn/human/bombmeat/Destroy()
	new/obj/structure/showcase/machinery/oldpod/used(drop_location())
	return ..()

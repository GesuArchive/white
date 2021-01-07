/area/awaymission/bombass
	name = "Бомбасс"
	icon_state = "awaycontent6"
	requires_power = TRUE
	area_flags = NOTELEPORT
	has_gravity = TRUE
	outdoors = TRUE
	mood_bonus = 150
	mood_message = "<span class='nicegreen'>СЕГОДНЯ Я УМРУ!\n</span>"

/area/awaymission/bombass/indoors
	name = "Бункер бомбасса"
	outdoors = FALSE
	requires_power = FALSE
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED

/obj/structure/closet/bombcloset/bombsquad
	name = "BOMBSQUAD"
	anchored = TRUE

/obj/structure/closet/bombcloset/bombsquad/PopulateContents()
	return

/datum/outfit/job/bombsquad
	name = "BombMeat uniform"

	jobtype = /datum/job/bombmeat
	id = /obj/item/card/id

/datum/job/bombmeat
	title = "Защитник"
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
	oxy_damage = 30
	mob_species = /datum/species/human
	short_desc = "Я бомбасист. Моя задача состоит в защите входа в бункер."
	flavour_text = "К сожалению, система клонирования дала сбой и теперь вся надежда только на самих себя."
	important_info = "ПОРА УМИРАТЬ!"
	uniform = /datum/outfit/job/assistant
	shoes = null
	disease = /datum/disease/dnaspread
	assignedrole = "Bombmeat"

/obj/effect/mob_spawn/human/bombmeat/equip(mob/living/carbon/human/H)
	. = ..()
	if(H.gender == FEMALE)
		H.real_name = "Бомбасистка [capitalize(pick(GLOB.first_names_female))]"
	else
		H.real_name = "Бомбасист [capitalize(pick(GLOB.first_names_male))]"

/obj/effect/mob_spawn/human/bombmeat/Destroy()
	new/obj/structure/showcase/machinery/oldpod/used(drop_location())
	return ..()

/datum/team/bombmeat

/datum/antagonist/bombmeat/get_team()
	return bombmeat_team

/datum/antagonist/bombmeat
	name = "Bombmeat"
	roundend_category = "Bombmeat"
	silent = TRUE //greet called by the spawn
	show_in_antagpanel = FALSE
	prevent_roundtype_conversion = FALSE
	antag_hud_type = ANTAG_HUD_FUGITIVE
	antag_hud_name = "fugitive_hunter"
	var/datum/team/bombmeat/bombmeat_team

/datum/antagonist/bombmeat/apply_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current
	add_antag_hud(antag_hud_type, antag_hud_name, M)

/datum/antagonist/bombmeat/remove_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current
	remove_antag_hud(antag_hud_type, M)

/datum/antagonist/bombmeat/create_team(datum/team/bombmeat/new_team)
	if(!new_team)
		for(var/datum/antagonist/bombmeat/H in GLOB.antagonists)
			if(!H.owner)
				continue
			if(H.bombmeat_team)
				bombmeat_team = H.bombmeat_team
				return
		bombmeat_team = new /datum/team/bombmeat
		return
	if(!istype(new_team))
		stack_trace("Wrong team type passed to [type] initialization.")
	bombmeat_team = new_team

/obj/effect/mob_spawn/human/bombmeat/special(mob/living/new_spawn)
	var/datum/antagonist/bombmeat/bt = new
	new_spawn.mind.add_antag_datum(bt)

/obj/item/disk/design_disk/adv/kar98k_ammo
	name = "Kar98k Ammo and Clips"

/obj/item/disk/design_disk/adv/kar98k_ammo/Initialize()
	. = ..()
	var/datum/design/kar98k_ammo/A = new
	var/datum/design/kar98k_clip/C = new
	blueprints[1] = A
	blueprints[2] = C

/datum/design/kar98k_ammo
	name = "Kar98k Ammo (7.92x57mm)"
	desc = "Патрон калибра 7.92x57mm."
	id = "kar98k_ammo"
	build_type = AUTOLATHE
	materials = list(MAT_CATEGORY_RIGID = 1250)
	build_path = /obj/item/ammo_casing/a792x57
	category = list("Импорт")

/datum/design/kar98k_clip
	name = "Kar98k Clip"
	desc = "Зарядник для винтовки Kar98k. Принимает патроны калибра 7.92x57mm."
	id = "kar98k_clip"
	build_type = AUTOLATHE
	materials = list(MAT_CATEGORY_RIGID = 2500)
	build_path = /obj/item/ammo_box/magazine/wzzzz/a792x57/empty
	category = list("Импорт")

/obj/effect/mob_spawn/human/dukra
	name = "спящий больной"
	desc = "Накачался и спит."
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "shiz"
	roundstart = FALSE
	death = FALSE
	short_desc = "Я точно не болен... Врачи убийцы держат меня тут насильно... Надо придумать способ сбежать отсюда..."
	flavour_text = "Нужно обезвредить всех НЕ-шизов и угнать эвакуационный шаттл."
	outfit = /datum/outfit/durka
	assignedrole = "Больной"
	faction = list("shiz")
	important_info = "Каждый может быть опасным для меня... Доверять можно только шизам..."
	oxy_damage = 40

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

/obj/effect/mob_spawn/human/dukra/special(mob/living/new_spawn)
	var/datum/antagonist/shizoid/shiz = new
	new_spawn.mind.add_antag_datum(shiz)
	message_admins("[ADMIN_LOOKUPFLW(new_spawn)] стал шизом.")
	log_game("[key_name(new_spawn)] стал шизом.")

/datum/antagonist/shizoid
	name = "Шизоид"
	roundend_category = "Больной"
	silent = TRUE
	show_in_antagpanel = FALSE
	prevent_roundtype_conversion = FALSE
	antag_hud_type = ANTAG_HUD_FUGITIVE
	antag_hud_name = "fugitive_hunter"
	var/datum/team/shizoid_team/shizoid_team

/datum/antagonist/shizoid/apply_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current
	add_antag_hud(antag_hud_type, antag_hud_name, M)

/datum/antagonist/shizoid/remove_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current
	remove_antag_hud(antag_hud_type, M)

/datum/antagonist/shizoid/proc/forge_objectives()
	var/datum/objective/escape/escape = new
	escape.owner = owner
	objectives += escape

/datum/antagonist/shizoid/on_gain()
	forge_objectives()
	. = ..()

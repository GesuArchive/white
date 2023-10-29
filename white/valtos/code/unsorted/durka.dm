/obj/effect/mob_spawn/human/dukra
	name = "спящий больной"
	desc = "Смотрит мне прямо в душу. Он что-то замышляет???"
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "shiz"
	roundstart = FALSE
	death = FALSE
	short_desc = "Местные врачи моя последняя надежда, ведь именно благодаря им я всё ещё могу дышать и хоть как-то мыслить."
	flavour_text = "Хотелось бы вылечиться и начать новую жизнь!"
	outfit = /datum/outfit/durka
	assignedrole = "Больной"
	faction = list("shiz")
	important_info = "Однако, каждый может быть опасным для меня... Доверять можно только моему психологу, хотя тот в последнее время что-то недоговаривает..."
	oxy_damage = 12

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
	if(prob(90))
		H.add_quirk(pick(SSquirks.hardcore_quirks), TRUE)
		if(prob(50))
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
	antag_hud_name = "fugitive_hunter"
	var/datum/team/shizoid_team/shizoid_team
	greentext_reward = 10

/datum/antagonist/shizoid/proc/forge_objectives()
	var/datum/objective/escape/escape = new
	escape.owner = owner
	objectives += escape

/datum/antagonist/shizoid/on_gain()
	forge_objectives()
	. = ..()

/obj/item/psihi
	name = "ПСИХИ"
	desc = "Эта вывеска внезапно хочет о чём-то предупредить."
	icon = 'white/valtos/icons/psihi.dmi'
	icon_state = "psihi"
	density = 0
	anchored = 1

/datum/antagonist/santa
	name = "Санта"
	show_in_antagpanel = FALSE
	show_name_in_check_antagonists = TRUE
	show_to_ghosts = TRUE
	greentext_reward = 15

/datum/antagonist/santa/on_gain()
	. = ..()
	give_equipment()
	give_objective()

	ADD_TRAIT(owner, TRAIT_CANNOT_OPEN_PRESENTS, TRAIT_SANTA)
	ADD_TRAIT(owner, TRAIT_PRESENT_VISION, TRAIT_SANTA)

/datum/antagonist/santa/greet()
	. = ..()
	to_chat(owner, span_boldannounce("Ты Санта! Твоя задача заключается в том, чтобы радовать население станции. В твоём наличии волшебный мешок, который создает подарки пока он в твоём распоряжении! Ты можешь изучить подарки, чтобы посмотреть что внутри для того чтобы убедиться в том, что ты отдаешь подарок в верные руки."))

/datum/antagonist/santa/proc/give_equipment()
	var/mob/living/carbon/human/H = owner.current
	if(istype(H))
		H.equipOutfit(/datum/outfit/santa)
		H.dna.update_dna_identity()

	owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/area_teleport/teleport/santa)

/datum/antagonist/santa/proc/give_objective()
	var/datum/objective/santa_objective = new()
	santa_objective.explanation_text = "Bring joy and presents to the station!"
	santa_objective.completed = TRUE //lets cut our santas some slack.
	santa_objective.owner = owner
	objectives |= santa_objective

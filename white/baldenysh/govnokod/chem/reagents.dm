/datum/reagent/medicine/aspirin
	name = "Aspirin"
	description = "Увеличивает скорость метаболизма, сопротивляемость температурам и скорость кровотечения."
	reagent_state = LIQUID
	color = "#D2FFFA"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM

/datum/reagent/medicine/aspirin/on_mob_add(mob/living/M)
	..()
	M.metabolism_efficiency *= 1.6
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.physiology.bleed_mod *= 2
		H.physiology.heat_mod *= 0.5

/datum/reagent/medicine/aspirin/on_mob_end_metabolize(mob/living/M)
	..()
	M.metabolism_efficiency *= 0.625
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.physiology.bleed_mod *= 0.5
		H.physiology.heat_mod *= 2




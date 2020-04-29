/datum/reagent/toxin/hohlomicin
	name = "Hohlomicin"
	description = "Pizdec"
	color = "#00FF00"
	toxpwr = 0
	taste_description = "сало"
	metabolization_rate = 0.05 * REAGENTS_METABOLISM

/datum/reagent/toxin/hohlomicin/on_mob_life(mob/living/L)
	..()
	if(current_cycle == 100)
		ADD_TRAIT(L, TRAIT_UKRAINISH, type)
		playsound(L,'code/shitcode/baldenysh/sounds/cs/holyshit.wav', 100, 5, pressure_affected = FALSE)





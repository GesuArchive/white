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


/obj/item/reagent_containers/pill/hohlomicin
	name = "таблетка Хохломицина"
	desc = "ПИЗДЕЦ."
	icon_state = "pill17"
	list_reagents = list(/datum/reagent/toxin/hohlomicin = 3)



/obj/item/reagent_containers/pill/haloperidol
	name = "таблетка Галоперидола"
	desc = "Шутки кончились."
	icon_state = "pill9"
	list_reagents = list(/datum/reagent/medicine/haloperidol = 5)

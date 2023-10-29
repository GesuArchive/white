/datum/action/changeling/panacea
	name = "Анатомическая панацея"
	desc = "Исключает недостаки из нашей формы; лечит болезни, удаляет паразитов, отрезвляет нас, очищает от токсинов и радиации, лечит травмы и повреждения головного мозга и полностью переустанавливает наш генетический код. Стоит 20 химикатов."
	helptext = "Может использоваться в бессознательном состоянии."
	button_icon_state = "panacea"
	chemical_cost = 20
	dna_cost = 1
	req_stat = HARD_CRIT

//Heals the things that the other regenerative abilities don't.
/datum/action/changeling/panacea/sting_action(mob/user)
	to_chat(user, span_notice("Мы очищаем примеси от нашей формы."))
	..()
	var/list/bad_organs = list(
		user.getorgan(/obj/item/organ/body_egg),
		user.getorgan(/obj/item/organ/zombie_infection))

	for(var/o in bad_organs)
		var/obj/item/organ/O = o
		if(!istype(O))
			continue

		O.Remove(user)
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			C.vomit(0)
		O.forceMove(get_turf(user))

	user.reagents.add_reagent(/datum/reagent/medicine/mutadone, 10)
	user.reagents.add_reagent(/datum/reagent/medicine/pen_acid, 20)
	user.reagents.add_reagent(/datum/reagent/medicine/antihol, 10)
	user.reagents.add_reagent(/datum/reagent/medicine/mannitol, 25)

	if(iscarbon(user))
		var/mob/living/carbon/C = user
		C.cure_all_traumas(TRAUMA_RESILIENCE_LOBOTOMY)

	if(isliving(user))
		var/mob/living/L = user
		for(var/thing in L.diseases)
			var/datum/disease/D = thing
			if(D.severity == DISEASE_SEVERITY_POSITIVE)
				continue
			D.cure()
	return TRUE

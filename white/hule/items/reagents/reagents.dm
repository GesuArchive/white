/datum/reagent/toxin/hyperpsy
	name = "Полураспад-228"
	description = "Сильнодействующий наркотик вызывающий раздвоение личности."
	color = "#00FF00"
	toxpwr = 0
	taste_description = "дикая смесь из сладкого, соленого и кислого"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM

/datum/reagent/toxin/hyperpsy/on_mob_add(mob/M)
	..()
//	Протекание и лечение
/datum/reagent/toxin/hyperpsy/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(current_cycle > 20)
		if(iscarbon(M))
			var/mob/living/carbon/C = M
			C.gain_trauma(/datum/brain_trauma/severe/split_personality)

	..()

/datum/reagent/toxin/nptox
	name = "Neuroparalitic toxin"
	description = "Powerful toxin that causes paralysis."
	color = "#0064C8"
	toxpwr = 0
	taste_description = "лайфвеб"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM

/datum/reagent/toxin/nptox/on_mob_add(mob/M)
	..()
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		C.gain_trauma(/datum/brain_trauma/severe/paralysis, TRAUMA_RESILIENCE_SURGERY)

/datum/reagent/toxin/nptox/on_mob_life(mob/living/M)
	M.drowsyness += 3
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2)
	M.Sleeping(10, 0)

/obj/item/grenade/chem_grenade/npgrenade
	name = "smoke grenade"
	desc = "The word 'утбябтрднвллк' is scribbled on it in crayon. You'd better don't try to disassemble this."
	icon = 'white/hule/icons/obj/weapons.dmi'
	icon_state = "npgrenade"
	icon_preview = 'white/hule/icons/obj/weapons.dmi'
	icon_state_preview = "npgrenade_ass"
	stage = 3

/obj/item/grenade/chem_grenade/npgrenade/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent(/datum/reagent/toxin/nptox, 25)
	B1.reagents.add_reagent(/datum/reagent/potassium, 25)
	B2.reagents.add_reagent(/datum/reagent/phosphorus, 25)
	B2.reagents.add_reagent(/datum/reagent/consumable/sugar, 25)

	beakers += B1
	beakers += B2

/obj/item/grenade/chem_grenade/npgrenade/attackby(obj/item/I, mob/user, params)
	if(stage == 3 && istype(I, /obj/item/wirecutters) && !active)
		if(prob(90))
			arm_grenade()
			return
	..()

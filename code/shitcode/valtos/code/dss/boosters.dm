/obj/item/reagent_containers/pill/viagra
	name = "таблетка виагры"
	desc = "Заставит вкусившего получить немного силы."
	icon_state = "pill16"
	list_reagents = list(/datum/reagent/viagra = 1)

/datum/reagent/viagra
	name = "Viagra"
	description = "Жидкость, которая делает из мальчика мужчину."
	color = "#FF00FF"
	metabolization_rate = 10 * REAGENTS_METABOLISM
	overdose_threshold = 10

/datum/reagent/viagra/reaction_mob(mob/living/M, method=TOUCH)
	if(ishuman(M))
		if(method == INGEST)
			var/mob/living/carbon/human/N = M
			N.dstats[MOB_STR] = N.dstats[MOB_STR] + rand(3, 7)
			N.dstats[MOB_INT] = N.dstats[MOB_INT] - rand(3, 5)
			to_chat(M, "<span class='notice'>ЧУВСТВУЮ СИЛУ И БЕЗЗАБОТСТВО!</span>")
			H.recalculate_stats()

/obj/item/reagent_containers/pill/askorbinka
	name = "аскорбинка"
	desc = "Говорят такими раньше пытали людей."
	icon_state = "pill15"
	list_reagents = list(/datum/reagent/askorbinka = 1)

/datum/reagent/askorbinka
	name = "Askorbinka"
	description = "Ммм, на вкус как уран."
	color = "#FFFFFF"
	metabolization_rate = 10 * REAGENTS_METABOLISM
	overdose_threshold = 10

/datum/reagent/askorbinka/reaction_mob(mob/living/M, method=TOUCH)
	if(ishuman(M))
		if(method == INGEST)
			var/mob/living/carbon/human/N = M
			N.dstats[MOB_STR] = N.dstats[MOB_STR] - rand(1, 2)
			N.dstats[MOB_INT] = N.dstats[MOB_INT] + rand(3, 7)
			N.dstats[MOB_DEX] = N.dstats[MOB_DEX] + rand(2, 4)
			to_chat(M, "<span class='notice'>Ням!</span>")
			H.recalculate_stats()

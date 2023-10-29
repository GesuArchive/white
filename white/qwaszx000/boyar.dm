/datum/reagent/consumable/ethanol/boyarka
	name = "Боярка"
	description = "Православная настойка."
	color = "#880000"
	nutriment_factor = 1 * REAGENTS_METABOLISM
	boozepwr = 75
	taste_description = "вишня и Россия"
	glass_name = "боярка"
	glass_desc = "Стакан полный вкусной настойки боярышника."

/datum/reagent/consumable/ethanol/boyarka/on_mob_life(mob/living/M)
	var/obj/item/organ/liver/liver = M.get_organ_slot(ORGAN_SLOT_LIVER)
	if(liver && HAS_TRAIT(liver, TRAIT_BOMJ_METABOLISM))
		M.heal_bodypart_damage(brute = 5, burn = 5)
		. = TRUE
	else
		M.reagents.add_reagent(get_random_reagent_id(),1)
		M.reagents.add_reagent(/datum/reagent/toxin/rotatium,1)
	..()

/datum/reagent/consumable/ethanol/boyarka/traitor
	name = "Концентрированная Боярка"
	boozepwr = 80

/datum/reagent/consumable/ethanol/boyarka/traitor/on_mob_add(mob/living/M)
	. = ..()
	var/obj/item/organ/liver/liver = M.get_organ_slot(ORGAN_SLOT_LIVER)
	if(liver && HAS_TRAIT(liver, TRAIT_BOMJ_METABOLISM))
		M.emote("agony")
		to_chat(M, span_userdanger("ОЩУЩАЮ МОЩНЕЙШИЙ ПРИЛИВ СИЛ!!!"))
		for(var/i in 1 to 100)
			addtimer(CALLBACK(M, /atom/proc/add_atom_colour, (i % 2)? "#FF00FF" : "#00FFFF", ADMIN_COLOUR_PRIORITY), i)

/datum/reagent/consumable/ethanol/boyarka/traitor/on_mob_life(mob/living/M)
	var/obj/item/organ/liver/liver = M.get_organ_slot(ORGAN_SLOT_LIVER)
	if(liver && HAS_TRAIT(liver, TRAIT_BOMJ_METABOLISM))
		M.heal_bodypart_damage(brute = 15, burn = 15)
		. = TRUE
	else
		M.reagents.add_reagent(get_random_reagent_id(),10)
		M.reagents.add_reagent(/datum/reagent/toxin/rotatium,2)
		spawn(0)
			new /datum/hallucination/delusion(M, TRUE, "demon",600,0)
		to_chat(M, span_warning("KILL THEM ALL!"))
	..()

/obj/item/reagent_containers/pill/boyar_t
	name = "true boyar pill"
	desc = "TRUE BOYAR."
	icon_state = "pill5"
	list_reagents = list(/datum/reagent/consumable/ethanol/boyarka/traitor = 10)
	//roundstart = 1

/datum/uplink_item/stealthy_weapons/boyar_t_pill
	name = "True boyar pill"
	desc = "Oh no! Its TRUE boyar pill!!!"
	item = /obj/item/reagent_containers/pill/boyar_t
	cost = 2

/datum/chemical_reaction/boyar
	results = list(/datum/reagent/consumable/ethanol/boyarka = 10)
	required_reagents = list(/datum/reagent/consumable/ethanol/vodka = 10, /datum/reagent/consumable/berryjuice = 1)

/obj/item/reagent_containers/food/drinks/boyarka
	name = "Боярка"
	desc = "Твой новый лучший друг."
	icon = 'white/hule/icons/obj/boyarka.dmi'
	icon_state = "boyarka"
	list_reagents = list(/datum/reagent/consumable/ethanol/boyarka = 30)
	foodtype = ALCOHOL | FRUIT

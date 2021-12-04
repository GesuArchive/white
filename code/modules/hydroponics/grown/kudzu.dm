// A very special plant, deserving it's own file.

/obj/item/seeds/kudzu
	name = "Пачка семян кудзу "
	desc = "Эти семена невероятно быстро вырастают в сорняк, который также молниеносно распространяется."
	icon_state = "seed-kudzu"
	species = "kudzu"
	plantname = "Kudzu"
	product = /obj/item/food/grown/kudzupod
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/plant_type/weed_hardy)
	lifespan = 20
	endurance = 10
	yield = 4
	instability = 55
	growthstages = 4
	rarity = 30
	var/list/mutations = list()
	reagents_add = list(/datum/reagent/medicine/c2/multiver = 0.04, /datum/reagent/consumable/nutriment = 0.02)
	graft_gene = /datum/plant_gene/trait/plant_type/weed_hardy

/obj/item/seeds/kudzu/Copy()
	var/obj/item/seeds/kudzu/S = ..()
	S.mutations = mutations.Copy()
	return S

/obj/item/seeds/kudzu/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] съедает пачку кудзу семян! Похоже [user.p_theyre()] пытается покончить с собой!"))
	plant(user)
	return (BRUTELOSS)

/obj/item/seeds/kudzu/proc/plant(mob/user)
	if(isspaceturf(user.loc))
		return
	if(!isturf(user.loc))
		to_chat(user, span_warning("Нужно больше места, чтобы посадить росток [src]."))
		return FALSE
	if(locate(/obj/structure/spacevine) in user.loc)
		to_chat(user, span_warning("Здесь слишком много кудзу, чтобы посадить [src]."))
		return FALSE
	to_chat(user, span_notice("Сажаю [src]."))
	message_admins("Kudzu planted by [ADMIN_LOOKUPFLW(user)] at [ADMIN_VERBOSEJMP(user)]")
	investigate_log("was planted by [key_name(user)] at [AREACOORD(user)]", INVESTIGATE_BOTANY)
	new /datum/spacevine_controller(get_turf(user), mutations, potency, production)
	qdel(src)

/obj/item/seeds/kudzu/attack_self(mob/user)
	user.visible_message(span_danger("[user] начинает раскидывать семена..."))
	if(do_after(user, 5 SECONDS, target = user.drop_location(), progress = TRUE))
		plant(user)
		to_chat(user, span_notice("Вы посадили кудзу. Вы - монстр."))

/obj/item/seeds/kudzu/get_unique_analyzer_text()
	var/kudzu_mutations = ""
	var/output_message = ""
	for(var/datum/spacevine_mutation/SM in mutations)
		kudzu_mutations += "[(kudzu_mutations == "") ? "" : ", "][SM.name]"
	output_message += "- Plant Mutations: [(kudzu_mutations == "") ? "None." : "[kudzu_mutations]."]"
	return output_message

/obj/item/seeds/kudzu/on_chem_reaction(datum/reagents/reagents)
	var/list/temp_mut_list = list()

	if(reagents.has_reagent(/datum/reagent/space_cleaner/sterilizine, 5))
		for(var/datum/spacevine_mutation/SM in mutations)
			if(SM.quality == NEGATIVE)
				temp_mut_list += SM
		if(prob(20) && temp_mut_list.len)
			mutations.Remove(pick(temp_mut_list))
		temp_mut_list.Cut()

	if(reagents.has_reagent(/datum/reagent/fuel, 5))
		for(var/datum/spacevine_mutation/SM in mutations)
			if(SM.quality == POSITIVE)
				temp_mut_list += SM
		if(prob(20) && temp_mut_list.len)
			mutations.Remove(pick(temp_mut_list))
		temp_mut_list.Cut()

	if(reagents.has_reagent(/datum/reagent/phenol, 5))
		for(var/datum/spacevine_mutation/SM in mutations)
			if(SM.quality == MINOR_NEGATIVE)
				temp_mut_list += SM
		if(prob(20) && temp_mut_list.len)
			mutations.Remove(pick(temp_mut_list))
		temp_mut_list.Cut()

	if(reagents.has_reagent(/datum/reagent/blood, 15))
		adjust_production(rand(15, -5))

	if(reagents.has_reagent(/datum/reagent/toxin/amatoxin, 5))
		adjust_production(rand(5, -15))

	if(reagents.has_reagent(/datum/reagent/toxin/plasma, 5))
		adjust_potency(rand(5, -15))

	if(reagents.has_reagent(/datum/reagent/water/holywater, 10))
		adjust_potency(rand(15, -5))


/obj/item/food/grown/kudzupod
	seed = /obj/item/seeds/kudzu
	name = "Стручок кудзу"
	desc = "<I>Пуэрария Вираллис</I>: Инвазивный вид с виноградными лозами, которые быстро ползают и обвивают все, с чем они соприкасаются."
	icon_state = "kudzupod"
	foodtypes = VEGETABLES | GROSS
	tastes = list("kudzu" = 1)
	wine_power = 20

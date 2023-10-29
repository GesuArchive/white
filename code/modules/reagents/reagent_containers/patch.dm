/obj/item/reagent_containers/pill/patch
	name = "химический пластырь"
	desc = "Благодаря эпидермальному обмену веществ позволяет вводить химические вещества прямо в кровь без посредников в виде шприцев."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "band1"
	inhand_icon_state = "bandaid"
	possible_transfer_amounts = list()
	volume = 40
	apply_type = PATCH
	apply_method = "применить"
	self_delay = 30		// three seconds
	dissolvable = FALSE

/obj/item/reagent_containers/pill/patch/attack(mob/living/L, mob/user)
	if(ishuman(L))
		var/obj/item/bodypart/affecting = L.get_bodypart(check_zone(user.zone_selected))
		if(!affecting)
			to_chat(user, span_warning("Конечности нет!"))
			return
		if(affecting.status != BODYPART_ORGANIC)
			to_chat(user, span_notice("Медицина бессильна перед синтетикой!"))
			return
	..()

/obj/item/reagent_containers/pill/patch/canconsume(mob/eater, mob/user)
	if(!iscarbon(eater))
		return FALSE
	return TRUE // Masks were stopping people from "eating" patches. Thanks, inheritance.

/obj/item/reagent_containers/pill/patch/libital
	name = "пластырь либитала"
	desc = "Применяется при лечении легких травм, негативно сказывается на печени. Разбавлен Гранбиталури."
	list_reagents = list(/datum/reagent/medicine/c2/libital/pure = 10, /datum/reagent/medicine/granibitaluri = 10) //10 iterations
	icon_state = "band14"

/obj/item/reagent_containers/pill/patch/aiuri
	name = "пластырь айури"
	desc = "Применяется при лечении легких ожогов, негативно сказывается на органах зрения. Разбавлен Гранбиталури."
	list_reagents = list(/datum/reagent/medicine/c2/aiuri/pure = 10, /datum/reagent/medicine/granibitaluri = 10)
	icon_state = "band7"

/obj/item/reagent_containers/pill/patch/lenturi
	name = "пластырь лентури"
	desc = "Применяется при лечении легких ожогов, негативно сказывается на желудке. Вызывает переутомление. Разбавлен Гранбиталури."
	list_reagents = list(/datum/reagent/medicine/c2/lenturi/pure = 10, /datum/reagent/medicine/granibitaluri = 10)
	icon_state = "band16"

/obj/item/reagent_containers/pill/patch/synthflesh
	name = "пластырь синтеплоти"
	desc = "Излечивает физические и ожоговые травмы ценой сильной интоксикации в размере 2/3 от объема повреждений. Применяется при лечении хаскированных ожогов высшей степени тяжести."
	list_reagents = list(/datum/reagent/medicine/c2/synthflesh = 50)
	icon_state = "band17"


////////////////////////////////////////////EGGS////////////////////////////////////////////

/obj/item/food/chocolateegg
	name = "шоколадное яйцо"
	desc = "Такая сладкая, жирная еда."
	icon_state = "chocolateegg"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/sugar = 2, /datum/reagent/consumable/coco = 2, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("шоколад" = 4, "сладость" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/egg
	name = "яйцо"
	desc = "ЯЙЦО!"
	icon_state = "egg"
	food_reagents = list(/datum/reagent/consumable/eggyolk = 4)
	microwaved_type = /obj/item/food/boiledegg
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_TINY
	var/static/chick_count = 0 //I copied this from the chicken_count (note the "en" in there) variable from chicken code.

/obj/item/food/egg/gland
	desc = "ЯЙЦО! Яйцо?"

/obj/item/food/egg/gland/Initialize(mapload)
	. = ..()
	reagents.add_reagent(get_random_reagent_id(), 15)

	var/color = mix_color_from_reagents(reagents.reagent_list)
	add_atom_colour(color, FIXED_COLOUR_PRIORITY)

/obj/item/food/egg/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!..()) //was it caught by a mob?
		var/turf/T = get_turf(hit_atom)
		new /obj/effect/decal/cleanable/food/egg_smudge(T)
		if(prob(13)) //Roughly a 1/8 (12.5%) chance to make a chick, as in Minecraft. I decided not to include the chances for the creation of multiple chicks from the impact of one egg, since that'd probably require nested prob()s or something (and people might think that it was a bug, anyway).
			if(chick_count < MAX_CHICKENS) //Chicken code uses this MAX_CHICKENS variable, so I figured that I'd use it again here. Even this check and the check in chicken code both use the MAX_CHICKENS variable, they use independent counter variables and thus are independent of each other.
				new /mob/living/simple_animal/chick(T)
				chick_count++
		reagents.expose(hit_atom, TOUCH)
		qdel(src)

/obj/item/food/egg/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/toy/crayon))
		var/obj/item/toy/crayon/C = W
		var/clr = C.crayon_color

		if(!(clr in list("blue", "green", "mime", "orange", "purple", "rainbow", "red", "yellow")))
			to_chat(usr, span_notice("[capitalize(src.name)] не хочет принимать новый цвет!"))
			return

		to_chat(usr, span_notice("Крашу [src] используя [W]."))
		icon_state = "egg-[clr]"
	else if(istype(W, /obj/item/stamp/clown))
		var/clowntype = pick("grock", "grimaldi", "rainbow", "chaos", "joker", "sexy", "standard", "bobble", "krusty", "bozo", "pennywise", "ronald", "jacobs", "kelly", "popov", "cluwne")
		icon_state = "egg-clown-[clowntype]"
		desc = "Яйцо, украшенное гротескным подобием лица клоуна. "
		to_chat(usr, span_notice("Штампую [src] используя [W], создавая художественное и ничуть не ужасающее подобие клоунского грима."))
	else
		..()

/obj/item/food/egg/blue
	icon_state = "egg-blue"

/obj/item/food/egg/green
	icon_state = "egg-green"

/obj/item/food/egg/mime
	icon_state = "egg-mime"

/obj/item/food/egg/orange
	icon_state = "egg-orange"

/obj/item/food/egg/purple
	icon_state = "egg-purple"

/obj/item/food/egg/rainbow
	icon_state = "egg-rainbow"

/obj/item/food/egg/red
	icon_state = "egg-red"

/obj/item/food/egg/yellow
	icon_state = "egg-yellow"

/obj/item/food/friedegg
	name = "яичница"
	desc = "Жареное яйцо с оттенком соли и перца."
	icon_state = "friedegg"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 6, /datum/reagent/consumable/nutriment/vitamin = 1)
	bite_consumption = 1
	tastes = list("яйцо" = 4, "соль" = 1, "перец" = 1)
	foodtypes = MEAT | FRIED | BREAKFAST
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/boiledegg
	name = "вареное яйцо"
	desc = "Сварено вкрутую."
	icon_state = "egg"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("яйцо" = 1)
	foodtypes = MEAT | BREAKFAST
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/omelette	//FUCK THIS
	name = "омлет дю фромаж"
	desc = "Это все, что ты можешь сказать!"
	icon_state = "omelette"
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 10, /datum/reagent/consumable/nutriment/vitamin = 3)
	bite_consumption = 1
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("яйцо" = 1, "сыр" = 1)
	foodtypes = MEAT | BREAKFAST | DAIRY
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/omelette/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/kitchen/fork))
		var/obj/item/kitchen/fork/F = W
		if(F.forkload)
			to_chat(user, span_warning("У меня уже есть омлет на вилке!"))
		else
			F.icon_state = "forkloaded"
			user.visible_message(span_notice("[user] отрывает кусочек омлета [user.ru_ego()] вилкой!") , \
				span_notice("Беру кусочек омлета вилкой."))

			var/datum/reagent/R = pick(reagents.reagent_list)
			reagents.remove_reagent(R.type, 1)
			F.forkload = R
			if(reagents.total_volume <= 0)
				qdel(src)
		return
	..()

/obj/item/food/benedict
	name = "яйцо Бенедикт"
	desc = "Здесь всего одно яйцо, как грубо."
	icon_state = "benedict"
	food_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 6, /datum/reagent/consumable/nutriment/protein = 6, /datum/reagent/consumable/nutriment = 3)
	trash_type = /obj/item/trash/plate
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("яйцо" = 1, "бекон" = 1, "булка" = 1)
	foodtypes = MEAT | BREAKFAST | GRAIN

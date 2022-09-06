/obj/item/organ/snus_mycosis
	name = "подозрительная грибница"
	desc = "Подозрительно пахнет табаком и чем-то еще."
	icon = 'white/baldenysh/icons/obj/organs.dmi'
	icon_state = "snus_mycosis"
	zone = BODY_ZONE_PRECISE_GROIN
	slot = "mycosis"
	decay_factor = 0
	food_reagents = list(/datum/reagent/consumable/nutriment/organ_tissue = 5)
	var/obj/structure/spider/cocoon/mycelium/cocoon
	var/nutriments = 0
	var/nutrition_leeching_factor = 1.5
	var/cocoon_req = 400
	var/mushroom_req = 100

/obj/item/organ/snus_mycosis/Insert(mob/living/carbon/M, special = 0)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/organ/snus_mycosis/Remove(mob/living/carbon/M, special = 0)
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/item/organ/snus_mycosis/process(delta_time, times_fired)
	..()
	if(!owner)
		return
	nutriments += feed(delta_time)
	if(!cocoon)
		if(nutriments > cocoon_req)
			wrap_owner()
		else
			return
	if(nutriments > mushroom_req)
		cocoon.fruit()
		nutriments -= mushroom_req

/obj/item/organ/snus_mycosis/proc/feed(delta_time)
	if(nutrition_leeching_factor <= 0)
		return 0
	if(owner.nutrition > nutrition_leeching_factor * delta_time)
		owner.nutrition -= nutrition_leeching_factor * delta_time
		return nutrition_leeching_factor * delta_time
	if(!cocoon)
		return 0
	if(prob(80)) //atmos optimization
		return 0
	for(var/obj/item/organ/O in owner.internal_organs)
		if(O == src|| istype(O, /obj/item/organ/brain) || !(O.organ_flags & ORGAN_EDIBLE))
			continue
		var/organ_nutriments = 0
		for(var/datum/reagent/consumable/nutriment/N in O.reagents.reagent_list)
			organ_nutriments += N.volume * N.nutriment_factor
		to_chat(owner, span_userdanger("Чувствую жгучую боль в районе [O.name]!"))
		qdel(O)
		return organ_nutriments*5
	if(!HAS_TRAIT(owner, TRAIT_HUSK) && prob(10))
		owner.become_husk()
		return 200

/obj/item/organ/snus_mycosis/proc/wrap_owner()
	if(!owner)
		return
	cocoon = new(get_turf(owner))
	owner.forceMove(cocoon)

/obj/structure/spider/cocoon/mycelium
	name = "мицелиевый кокон"
	desc = "Кокон из мицелия. На нем растут подозрительные грибы."
	var/sprite_lower_left_bound_x = 5
	var/sprite_lower_left_bound_y = 5
	var/spawn_rect_width = 22
	var/spawn_rect_height = 8

/obj/structure/spider/cocoon/mycelium/Initialize(mapload)
	. = ..()
	icon_state = "cocoon_large1"

/obj/structure/spider/cocoon/mycelium/proc/fruit()
	var/obj/structure/flora/snus_cap/cap
	if(prob(10))
		var/subtype = pick(subtypesof(/obj/structure/flora/snus_cap))
		cap = new subtype(get_turf(src))
	else
		cap = new /obj/structure/flora/snus_cap(get_turf(src))

	var/rand_valid_x = rand(sprite_lower_left_bound_x, sprite_lower_left_bound_x + spawn_rect_width)
	var/rand_valid_y = rand(sprite_lower_left_bound_y, sprite_lower_left_bound_y + spawn_rect_height)
	cap.pixel_x = rand_valid_x - cap.stem_base_x
	cap.pixel_y = rand_valid_y - cap.stem_base_y


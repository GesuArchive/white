/obj/machinery/gibber
	name = "мясорубка"
	desc = "Полагаю в более подробном описании не нуждается."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "grinder"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/gibber

	var/operating = FALSE //Is it on?
	var/dirty = FALSE // Does it need cleaning?
	var/gibtime = 40 // Time from starting until meat appears
	var/meat_produced = 0
	var/ignore_clothing = FALSE


/obj/machinery/gibber/Initialize(mapload)
	. = ..()
	add_overlay("grjam")

/obj/machinery/gibber/RefreshParts()
	. = ..()
	gibtime = 40
	meat_produced = 0
	for(var/obj/item/stock_parts/matter_bin/B in component_parts)
		meat_produced += B.rating
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		gibtime -= 5 * M.rating
		if(M.rating >= 2)
			ignore_clothing = TRUE

/obj/machinery/gibber/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += "<hr>[span_notice("Дисплей: Обработка мяса займет <b>[gibtime*0.1]</b> секунд.")]"
		for(var/obj/item/stock_parts/manipulator/M in component_parts)
			if(M.rating >= 2)
				. += "<hr>[span_notice("Мясорубка была улучшена для обработки неорганики.")]"

/obj/machinery/gibber/update_overlays()
	. = ..()
	if (dirty)
		. +="grbloody"
	if(machine_stat & (NOPOWER|BROKEN))
		return
	if (!occupant)
		. += "grjam"
	else if (operating)
		. += "gruse"
	else
		. += "gridle"

/obj/machinery/gibber/attack_paw(mob/user)
	return attack_hand(user)

/obj/machinery/gibber/container_resist_act(mob/living/user)
	go_out()

/obj/machinery/gibber/relaymove(mob/living/user, direction)
	go_out()

/obj/machinery/gibber/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(machine_stat & (NOPOWER|BROKEN))
		return
	if(operating)
		to_chat(user, span_danger("Заблокирована во время работы!"))
		return

	if(!anchored)
		to_chat(user, span_warning("[capitalize(src.name)] не может быть использована, пока не прикручена к полу!"))
		return

	if(user.pulling && user.a_intent == INTENT_GRAB && isliving(user.pulling))
		var/mob/living/L = user.pulling
		if(!iscarbon(L))
			to_chat(user, span_warning("Этот предмет не может быть обработан!"))
			return
		var/mob/living/carbon/C = L
		if(C.buckled ||C.has_buckled_mobs())
			to_chat(user, span_warning("[C] привязан к чему-то!"))
			return

		if(!ignore_clothing)
			for(var/obj/item/I in C.held_items + C.get_equipped_items())
				if(!HAS_TRAIT(I, TRAIT_NODROP))
					to_chat(user, span_warning("На [C] есть что-то, что не может быть обработано!"))
					return

		user.visible_message(span_danger("[user] суёт [C] в мясорубку!"))

		add_fingerprint(user)

		if(do_after(user, gibtime, target = src))
			if(C && user.pulling == C && !C.buckled && !C.has_buckled_mobs() && !occupant)
				user.visible_message(span_danger("[user] засунул [C] в мясорубку!"))
				C.forceMove(src)
				set_occupant(C)
				update_icon()
	else
		startgibbing(user)

/obj/machinery/gibber/attackby(obj/item/P, mob/user, params)
	if(default_deconstruction_screwdriver(user, "grinder_open", "grinder", P))
		return

	else if(default_pry_open(P))
		return

	else if(default_unfasten_wrench(user, P))
		return

	else if(default_deconstruction_crowbar(P))
		return
	else
		return ..()

/obj/machinery/gibber/verb/eject()
	set category = "Объект"
	set name = "empty gibber"
	set src in oview(1)

	if (usr.stat != CONSCIOUS || HAS_TRAIT(usr, TRAIT_HANDS_BLOCKED))
		return
	src.go_out()
	add_fingerprint(usr)
	return

/obj/machinery/gibber/proc/go_out()
	dump_inventory_contents()
	update_icon()

/obj/machinery/gibber/proc/startgibbing(mob/user)
	if(operating)
		return
	if(!occupant)
		audible_message(span_hear("Слышу громкий металлический скрежет."))
		return

	use_power(active_power_usage)
	audible_message(span_hear("Слышу громкое хлюпанье."))
	playsound(loc, 'sound/machines/juicer.ogg', 50, TRUE)
	operating = TRUE
	update_icon()

	var/offset = prob(50) ? -2 : 2
	animate(src, pixel_x = pixel_x + offset, time = 0.2, loop = 200) //start shaking
	var/mob/living/mob_occupant = occupant
	var/sourcename = mob_occupant.real_name
	var/sourcejob
	if(ishuman(occupant))
		var/mob/living/carbon/human/gibee = occupant
		sourcejob = gibee.job
	var/sourcenutriment = mob_occupant.nutrition / 15
	var/gibtype = /obj/effect/decal/cleanable/blood/gibs
	var/typeofmeat = /obj/item/food/meat/slab/human
	var/typeofskin

	var/obj/item/food/meat/slab/allmeat[meat_produced]
	var/obj/item/stack/sheet/animalhide/skin
	var/list/datum/disease/diseases = mob_occupant.get_static_viruses()

	if(ishuman(occupant))
		var/mob/living/carbon/human/gibee = occupant
		if(gibee.dna && gibee.dna.species)
			typeofmeat = gibee.dna.species.meat
			typeofskin = gibee.dna.species.skinned_type

	else if(iscarbon(occupant))
		var/mob/living/carbon/C = occupant
		typeofmeat = C.type_of_meat
		gibtype = C.gib_type
		if(isalien(C))
			typeofskin = /obj/item/stack/sheet/animalhide/xeno

	var/occupant_volume
	if(occupant?.reagents)
		occupant_volume = occupant.reagents.total_volume
	if(typeofmeat)
		for (var/i=1 to meat_produced)
			var/obj/item/food/meat/slab/newmeat = new typeofmeat
			newmeat.name = "[sourcename] [newmeat.name]"
			newmeat.set_custom_materials(list(GET_MATERIAL_REF(/datum/material/meat/mob_meat, occupant) = 4 * MINERAL_MATERIAL_AMOUNT))
			if(istype(newmeat))
				newmeat.subjectname = sourcename
				newmeat.reagents.add_reagent (/datum/reagent/consumable/nutriment, sourcenutriment / meat_produced) // Thehehe. Fat guys go first
				if(occupant_volume)
					occupant.reagents.trans_to(newmeat, occupant_volume / meat_produced, remove_blacklisted = TRUE)
				if(sourcejob)
					newmeat.subjectjob = sourcejob
			allmeat[i] = newmeat

	if(typeofskin)
		skin = new typeofskin

	log_combat(user, occupant, "gibbed")
	mob_occupant.death(1)
	mob_occupant.ghostize()
	set_occupant(null)
	qdel(mob_occupant)
	addtimer(CALLBACK(src, PROC_REF(make_meat), skin, allmeat, meat_produced, gibtype, diseases), gibtime)

/obj/machinery/gibber/proc/make_meat(obj/item/stack/sheet/animalhide/skin, list/obj/item/food/meat/slab/allmeat, meat_produced, gibtype, list/datum/disease/diseases)
	playsound(src.loc, 'sound/effects/splat.ogg', 50, TRUE)
	operating = FALSE
	var/turf/T = get_turf(src)
	var/list/turf/nearby_turfs = RANGE_TURFS(3,T) - T
	if(skin)
		skin.forceMove(loc)
		skin.throw_at(pick(nearby_turfs),meat_produced,3)
	for (var/i=1 to meat_produced)
		var/obj/item/meatslab = allmeat[i]
		meatslab.forceMove(loc)
		meatslab.throw_at(pick(nearby_turfs),i,3)
		for (var/turfs=1 to meat_produced)
			var/turf/gibturf = pick(nearby_turfs)
			if (!gibturf.density && (src in view(gibturf)))
				new gibtype(gibturf,i,diseases)

	pixel_x = base_pixel_x //return to its spot after shaking
	operating = FALSE
	update_icon()

//auto-gibs anything that bumps into it
/obj/machinery/gibber/autogibber
	var/input_dir = NORTH

/obj/machinery/gibber/autogibber/Bumped(atom/movable/AM)
	var/atom/input = get_step(src, input_dir)
	if(isliving(AM))
		var/mob/living/victim = AM

		if(victim.loc == input)
			victim.forceMove(src)
			victim.gib()

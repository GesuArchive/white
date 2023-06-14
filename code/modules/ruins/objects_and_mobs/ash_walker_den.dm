#define ASH_WALKER_SPAWN_THRESHOLD 2
//The ash walker den consumes corpses or unconscious mobs to create ash walker eggs. For more info on those, check ghost_role_spawners.dm
/obj/structure/lavaland/ash_walker
	name = "гнездо некро-тентаклей"
	desc = "Мерзкие искажённые тентакли. Они окружены гнездом быстро растущих яиц..."
	icon = 'icons/mob/nest.dmi'
	icon_state = "ash_walker_nest"

	move_resist=INFINITY // just killing it tears a massive hole in the ground, let's not move it
	anchored = TRUE
	density = TRUE

	resistance_flags = FIRE_PROOF | LAVA_PROOF
	max_integrity = 200


	var/faction = list("ashwalker")
	var/meat_counter = 6
	var/datum/team/ashwalkers/ashies
	var/datum/linked_objective

/obj/structure/lavaland/ash_walker/Initialize(mapload)
	. = ..()
	ashies = new /datum/team/ashwalkers()
	var/datum/objective/protect_object/objective = new
	objective.set_target(src)
	linked_objective = objective
	ashies.objectives += objective
	START_PROCESSING(SSprocessing, src)

/obj/structure/lavaland/ash_walker/Destroy()
	ashies.objectives -= linked_objective
	ashies = null
	QDEL_NULL(linked_objective)
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/structure/lavaland/ash_walker/deconstruct(disassembled)
	new /obj/item/assembly/signaler/anomaly (get_step(loc, pick(GLOB.alldirs)))
	new	/obj/effect/collapse(loc)
	return ..()

/obj/structure/lavaland/ash_walker/process()
	consume()
	spawn_mob()

/obj/structure/lavaland/ash_walker/proc/consume()
	for(var/mob/living/H in view(src, 1)) //Only for corpse right next to/on same tile
		if(H.stat)
			for(var/obj/item/W in H)
				if(!H.dropItemToGround(W))
					qdel(W)
			if(issilicon(H)) //no advantage to sacrificing borgs...
				H.gib()
				visible_message(span_notice("Зазубренные тентакли жадно разрывают [H] на кусочки, но не находят ничего интересного."))
				return

			if(H.mind?.has_antag_datum(/datum/antagonist/ashwalker) && (H.key || H.get_ghost(FALSE, TRUE)) && H.client) //special interactions for dead lava lizards with ghosts attached
				visible_message(span_warning("Зазубренные тентакли аккуратно притягивают [H] к [src], поглощая тело и создавая его заново."))
				var/datum/mind/deadmind
				if(H.key)
					deadmind = H
				else
					deadmind = H.get_ghost(FALSE, TRUE)
				to_chat(deadmind, "Ваше тело вернулось в гнездо. Вас создают заново, и вы скоро проснетесь. </br><b>Ваши воспоминания останутся с вами, в отличии от поглощаемой гнездом души.</b>")
				SEND_SOUND(deadmind, sound('sound/magic/enter_blood.ogg',volume=100))
				addtimer(CALLBACK(src, PROC_REF(remake_walker), H.mind, H.real_name), 20 SECONDS)
				new /obj/effect/gibspawner/generic(get_turf(H))
				qdel(H)
				return

			if(ismegafauna(H))
				meat_counter += 20
			else
				meat_counter++
			visible_message(span_warning("Зазубренные тентакли жадно притягивают [H] к [src], разрывая тело на кусочки и поливая яйца кровью."))
			playsound(get_turf(src),'sound/magic/demon_consume.ogg', 100, TRUE)
			var/deliverykey = H.fingerprintslast //key of whoever brought the body
			var/mob/living/deliverymob = get_mob_by_key(deliverykey) //mob of said key
			//there is a 40% chance that the Lava Lizard unlocks their respawn with each sacrifice
			if(deliverymob && (deliverymob.mind?.has_antag_datum(/datum/antagonist/ashwalker)) && (deliverykey in ashies.players_spawned) && (prob(40)))
				to_chat(deliverymob, span_warning("<b>Некрополис удовлетворён вашей жертвой. Вы ощущаете уверенность в своём посмертии .</b>"))
				ashies.players_spawned -= deliverykey
			H.gib()
			obj_integrity = min(obj_integrity + max_integrity*0.05,max_integrity)//restores 5% hp of tendril
			for(var/mob/living/L in view(src, 5))
				if(L.mind?.has_antag_datum(/datum/antagonist/ashwalker))
					SEND_SIGNAL(L, COMSIG_ADD_MOOD_EVENT, "oogabooga", /datum/mood_event/sacrifice_good)
				else
					SEND_SIGNAL(L, COMSIG_ADD_MOOD_EVENT, "oogabooga", /datum/mood_event/sacrifice_bad)

/obj/structure/lavaland/ash_walker/proc/remake_walker(datum/mind/oldmind, oldname)
	var/mob/living/carbon/human/M = new /mob/living/carbon/human(get_step(loc, pick(GLOB.alldirs)))
	M.set_species(/datum/species/lizard/ashwalker)
	M.real_name = oldname
	M.underwear = "Nude"
	M.update_body()
	oldmind.transfer_to(M)
	M.mind.grab_ghost()
	to_chat(M, "<b>Вы ощущаете, как возвращаетесь с того света с новым телом и новой задачей. Слава Некрополису!</b>")
	playsound(get_turf(M),'sound/magic/exit_blood.ogg', 100, TRUE)

/obj/structure/lavaland/ash_walker/proc/spawn_mob()
	if(meat_counter >= ASH_WALKER_SPAWN_THRESHOLD)
		new /obj/effect/mob_spawn/human/ash_walker(get_step(loc, pick(GLOB.alldirs)), ashies)
		visible_message(span_danger("Одно из яиц вырастает до ненормальных размеров и свободно дергается. Оно готово к вылуплению!"))
		meat_counter -= ASH_WALKER_SPAWN_THRESHOLD

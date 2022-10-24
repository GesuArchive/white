/datum/yohei_task
	var/desc = null
	var/prize = 0
	var/can_autocomplete = FALSE
	var/obj/lab_monitor/yohei/parent

/datum/yohei_task/proc/generate_task()
	return

/datum/yohei_task/proc/check_task(autocheck)
	return FALSE

/datum/yohei_task/New()
	generate_task()

/datum/yohei_task/proc/get_crewmember_minds()
	. = list()
	for(var/V in GLOB.data_core.locked)
		var/datum/data/record/R = V
		var/datum/mind/M = R.fields["mindref"]
		if(M)
			. += M

/datum/yohei_task/proc/get_someone_fuck()
	. = list()
	for(var/V in GLOB.clients)
		var/client/C = V
		if(C.mob && ishuman(C.mob))
			. += C.mob

/datum/yohei_task/proc/find_target()
	var/list/possible_targets = list()
	for(var/datum/mind/possible_target in get_crewmember_minds())
		if(ishuman(possible_target.current) && (possible_target.current.stat != DEAD) && (!HAS_TRAIT(possible_target, TRAIT_YOHEI)))
			possible_targets += possible_target.current
	if(possible_targets.len > 0)
		return pick(possible_targets)
	return pick(get_someone_fuck())

/datum/yohei_task/kill
	desc = "Убить цель."
	prize = 10
	var/mob/living/target
	can_autocomplete = TRUE

/datum/yohei_task/kill/generate_task()
	target = find_target()
	desc = "Убить [target.real_name]."
	prize = max(rand(prize - 5, prize + 5), 1)
	to_chat(target, span_userdanger("Кто-то хочет мне навредить..."))

/datum/yohei_task/kill/check_task(autocheck)
	if(target && target.stat != DEAD)
		return YOHEI_MISSION_UNFINISHED
	return YOHEI_MISSION_COMPLETED

/datum/yohei_task/capture
	desc = "Захватить цель."
	prize = 20
	var/mob/living/target
	can_autocomplete = TRUE // not neccecary successfully complete

/datum/yohei_task/capture/generate_task()
	target = find_target()
	desc = "Захватить [target.real_name] и доставить живьём в логово."
	prize = max(rand(prize - 10, prize + 20), 1)

/datum/yohei_task/capture/check_task(autocheck)
	if(target && target.stat != DEAD && !autocheck) // you WILL press the screen to confirm it
		var/area/A = get_area(target)
		if(A.type != /area/shuttle/yohei)
			return YOHEI_MISSION_UNFINISHED
		target.Unconscious(60 SECONDS)
		var/obj/structure/closet/supplypod/return_pod = new()
		return_pod.bluespace = TRUE
		return_pod.explosionSize = list(0,0,0,0)
		return_pod.style = STYLE_SYNDICATE

		do_sparks(8, FALSE, target)
		target.visible_message(span_notice("<b>[target]</b> исчезает..."))

		for(var/obj/item/W in target)
			if (ishuman(target))
				var/mob/living/carbon/human/H = target
				if(W == H.w_uniform)
					continue //So all they're left with are shoes and uniform.
				if(W == H.shoes)
					continue
			target.dropItemToGround(W)

		target.forceMove(return_pod)

		target.blur_eyes(30)
		target.Dizzy(35)
		target.lastattackermob = null // we just don't care what happens with him after teleportation. also avoids false mood debuffs
		new /obj/effect/pod_landingzone(find_safe_turf(zlevels = SSmapping.levels_by_trait(ZTRAIT_STATION)), return_pod)
		if(prob(99))
			if(prob(10))
				/* target.gib() */
				/* gibbing is not gud, lets try something different */
				var/resistance = pick(
					50;TRAUMA_RESILIENCE_BASIC,
					30;TRAUMA_RESILIENCE_SURGERY,
					15;TRAUMA_RESILIENCE_LOBOTOMY,
					5;TRAUMA_RESILIENCE_MAGIC)

				var/trauma_type = pick_weight(list(
					BRAIN_TRAUMA_MILD = 60,
					BRAIN_TRAUMA_SEVERE = 30,
					BRAIN_TRAUMA_SPECIAL = 10))

				var/mob/living/carbon/human/targetH = target
				targetH?.gain_trauma_type(trauma_type, resistance)
				return YOHEI_MISSION_COMPLETED
			target?.mind?.make_Traitor()
			return YOHEI_MISSION_COMPLETED
		else
			target?.mind?.make_Wizard() // SEE MY ORB!
			return YOHEI_MISSION_COMPLETED
	var/mob/living/carbon/C = target
	if(!target || !(C.can_defib() & DEFIB_REVIVABLE_STATES)) // wtf target got deleted or died entierly
		return YOHEI_MISSION_FAILED
	else
		return YOHEI_MISSION_UNFINISHED // you still can find him and heal!

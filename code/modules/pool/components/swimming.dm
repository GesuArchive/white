//Component used to show that a mob is swimming, and force them to swim a lil' bit slower. Components are actually really based!

/datum/component/swimming
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/lengths = 0 //How far have we swum?
	var/lengths_for_bonus = 25 //If you swim this much, you'll count as having "excercised" and thus gain a buff.
	var/list/species = list()
	var/drowning = FALSE
	var/ticks_drowned = 0
	var/slowdown = 4
	var/bob_height_min = 2
	var/bob_height_max = 5
	var/bob_tick = 0

/datum/component/swimming/Initialize(mapload)
	. = ..()
	if(!isliving(parent))
		message_admins("Swimming component erroneously added to a non-living mob ([parent]).")
		return INITIALIZE_HINT_QDEL //Only mobs can swim, like Ian...
	var/mob/M = parent
	M.visible_message(span_notice("[parent] starts splashing around in the water!"))
	M.add_movespeed_modifier(/datum/movespeed_modifier/swimming, TRUE)
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(onMove))
	RegisterSignal(parent, COMSIG_MOB_ATTACK_HAND_TURF, PROC_REF(try_leave_pool))
	START_PROCESSING(SSprocessing, src)
	enter_pool()

/datum/component/swimming/proc/onMove()
	lengths ++
	if(lengths > lengths_for_bonus)
		var/mob/living/L = parent
		SEND_SIGNAL(L, COMSIG_ADD_MOOD_EVENT, "exercise", /datum/mood_event/exercise)
		L.apply_status_effect(STATUS_EFFECT_EXERCISED) //Swimming is really good excercise!
		lengths = 0

/datum/component/swimming/proc/try_leave_pool(datum/source, turf/clicked_turf)
	var/mob/living/L = parent
	if(!L.can_interact_with(clicked_turf))
		return
	if(is_blocked_turf(clicked_turf))
		return
	if(istype(clicked_turf, /turf/open/indestructible/pool))
		return
	to_chat(parent, span_notice("You start to climb out of the pool..."))
	if(do_after(parent, 1 SECONDS, target=clicked_turf))
		L.forceMove(clicked_turf)
		L.visible_message(span_notice("[parent] climbs out of the pool."))
		qdel(src)

/datum/component/swimming/UnregisterFromParent()
	exit_pool()
	var/mob/M = parent
	if(drowning)
		stop_drowning(M)
	if(bob_tick)
		M.pixel_y = 0
	M.remove_movespeed_modifier(/datum/movespeed_modifier/swimming)
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(parent, COMSIG_MOB_ATTACK_HAND_TURF)
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/datum/component/swimming/process()
	var/mob/living/L = parent
	var/floating = FALSE
	var/obj/item/pool/helditem = L.get_active_held_item()
	if(istype(helditem))
		bob_tick ++
		animate(L, time=9.5, pixel_y = (L.pixel_y == bob_height_max) ? bob_height_min : bob_height_max)
		floating = TRUE
	else
		if(bob_tick)
			animate(L, time=5, pixel_y = 0)
			bob_tick = 0
	if(!floating && is_drowning(L))
		if(!drowning)
			start_drowning(L)
			drowning = TRUE
		drown(L)
	else if(drowning)
		stop_drowning(L)
		drowning = FALSE
	L.adjust_wet_stacks(1)

/datum/component/swimming/proc/is_drowning(mob/living/victim)
	var/obj/item/pool/helditem = victim.get_active_held_item()
	if(istype(helditem))
		return
	return ((!(victim.mobility_flags & MOBILITY_STAND)) && (!HAS_TRAIT(victim, TRAIT_NOBREATH)))

/datum/component/swimming/proc/drown(mob/living/victim)
	if(victim.losebreath < 1)
		victim.losebreath += 1
	ticks_drowned ++
	if(prob(20))
		victim.emote("cough")
	else if(prob(25))
		victim.emote("gasp")
	if(ticks_drowned > 20)
		if(prob(10))
			victim.visible_message(span_warning("[victim] falls unconcious for a moment!"))
			victim.Unconscious(10)

/datum/component/swimming/proc/start_drowning(mob/living/victim)
	to_chat(victim, span_userdanger("Water fills your lungs and mouth, you can't breathe!"))
	ADD_TRAIT(victim, TRAIT_MUTE, "pool")

/datum/component/swimming/proc/stop_drowning(mob/living/victim)
	victim.emote("cough")
	to_chat(victim, span_notice("You cough up the last of the water, regaining your ability to speak and breathe clearly!"))
	REMOVE_TRAIT(victim, TRAIT_MUTE, "pool")
	ticks_drowned = 0

/datum/component/swimming/proc/enter_pool()
	return

//Essentially the same as remove component, but easier for overiding
/datum/component/swimming/proc/exit_pool()
	return

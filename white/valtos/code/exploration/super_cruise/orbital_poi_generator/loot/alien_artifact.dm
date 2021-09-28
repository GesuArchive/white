
/obj/item/alienartifact
	name = "артефакт"
	desc = "Что же это такое?"
	icon = 'icons/obj/artifact.dmi'
	icon_state = "artifact"
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/list/datum/artifact_effect/effects

/obj/item/alienartifact/examine(mob/user)
	. = ..()
	var/mob/living/L = user
	if(istype(L) && L.mind?.assigned_role != "Curator")
		return
	for(var/datum/artifact_effect/effect in effects)
		for(var/verb in effect.effect_act_descs)
			. += "[src] видимо [verb]."

/obj/item/alienartifact/ComponentInitialize()
	AddComponent(/datum/component/discoverable, 10000, TRUE)

/obj/item/alienartifact/objective/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/gps, "[scramble_message_replace_chars("#########", 100)]", TRUE)

/obj/item/alienartifact/Initialize()
	. = ..()
	effects = list()
	for(var/i in 1 to pick(1, 500; 2, 70; 3, 20; 1))
		var/picked_type = pick(subtypesof(/datum/artifact_effect))
		var/valid = TRUE
		var/datum/artifact_effect/effect = new picked_type
		for(var/datum/artifact_effect/old_effect as() in effects)
			//Cant have the same one twice
			if(istype(old_effect, picked_type))
				valid = FALSE
				qdel(effect)
				break
			//Cant have incompatible signals
			for(var/signal_type in old_effect.signal_types)
				if(signal_type in effect.signal_types)
					valid = FALSE
					qdel(effect)
					break
		if(valid)
			effect.register_signals(src)
			effect.Initialize(src)
			effects += effect

/obj/item/alienartifact/Destroy()
	. = ..()
	QDEL_LIST(effects)

/area/tear_in_reality
	name = "???"
	requires_power = FALSE
	mood_bonus = -999
	has_gravity = STANDARD_GRAVITY
	ambience_index = AMBIENCE_NONE
	sound_environment = SOUND_ENVIRONMENT_DRUGGED
	static_lighting = FALSE

/area/tear_in_reality/Initialize()
	. = ..()
	mood_message = span_warning("[scramble_message_replace_chars("###### ### #### ###### #######", 100)]!")

/area/tear_in_reality/proc/get_virtual_z(turf/T)
	return REALITY_TEAR_VIRTUAL_Z

//===================
// Raw artifact datum
//===================

/datum/artifact_effect
	var/requires_processing = FALSE
	var/effect_act_descs = list()	//List of verbs for things that can be done with the artifact.
	var/obj/item/source_object
	var/list/signal_types = list()

/datum/artifact_effect/proc/register_signals(source)
	return

/datum/artifact_effect/proc/Initialize(source)
	source_object = source
	if(requires_processing)
		START_PROCESSING(SSobj, src)

/datum/artifact_effect/Destroy()
	. = ..()
	if(requires_processing)
		STOP_PROCESSING(SSobj, src)

//===================
// Chaos Throw
//===================

/datum/artifact_effect/throwchaos
	signal_types = list(COMSIG_MOVABLE_POST_THROW)
	effect_act_descs = list("брошенный")

/datum/artifact_effect/throwchaos/register_signals(source)
	RegisterSignal(source, COMSIG_MOVABLE_POST_THROW, .proc/throw_thing_randomly)

/datum/artifact_effect/throwchaos/proc/throw_thing_randomly(datum/source, datum/thrownthing, spin)
	SIGNAL_HANDLER
	if(!isitem(thrownthing) || QDELETED(thrownthing))
		return
	if(prob(40))
		return
	var/atom/new_throw_target = pick(view(5, thrownthing))
	var/obj/item/I = thrownthing
	I.throw_at(new_throw_target, 5, 4)

//===================
// Laughing
//===================

/datum/artifact_effect/soundindark
	requires_processing = TRUE
	effect_act_descs = list("тёмный")

/datum/artifact_effect/soundindark/process(delta_time)
	var/turf/T = get_turf(source_object)
	if(!T || T.get_lumcount())
		return
	if(prob(5))
		playsound(T, pick('sound/voice/human/womanlaugh.ogg', 'sound/voice/human/manlaugh1.ogg'), 40)

//===================
// Spasm inducing
//===================

/datum/artifact_effect/inducespasm
	signal_types = list(COMSIG_PARENT_EXAMINE)
	effect_act_descs = list("осмотренный")

/datum/artifact_effect/inducespasm/register_signals(source)
	RegisterSignal(source, COMSIG_PARENT_EXAMINE, .proc/do_effect)

/datum/artifact_effect/inducespasm/proc/do_effect(datum/source, mob/observer, list/examine_text)
	SIGNAL_HANDLER
	if(ishuman(observer))
		var/mob/living/carbon/human/H = observer
		H.gain_trauma(/datum/brain_trauma/mild/muscle_spasms, TRAUMA_RESILIENCE_BASIC)

//===================
// Projectile Reflector
//===================

/datum/artifact_effect/projreflect
	requires_processing = TRUE
	effect_act_descs = list("стреляющий")

/datum/artifact_effect/projreflect/process(delta_time)
	for(var/obj/projectile/P in range(3, src))
		//Reflect projectile
		P.setAngle(rand(0, 360))

//===================
// Air Blocker
//===================

/datum/artifact_effect/airfreeze
	effect_act_descs = list("вакуумный")

/datum/artifact_effect/airfreeze/Initialize(atom/source)
	. = ..()
	source.CanAtmosPass = ATMOS_PASS_NO

//===================
// Atmos Stabilizer
//===================

/datum/artifact_effect/atmosfix
	requires_processing = TRUE
	effect_act_descs = list("вакуумный")

/datum/artifact_effect/atmosfix/process(delta_time)
	var/turf/T = get_turf(source_object)
	var/datum/gas_mixture/air = T.return_air()
	air.parse_gas_string(T.initial_gas_mix)

//===================
// Gravity Well
//===================

/datum/artifact_effect/gravity_well
	signal_types = list(COMSIG_ITEM_ATTACK_SELF)
	var/next_use_world_time = 0
	effect_act_descs = list("использованный")

/datum/artifact_effect/gravity_well/register_signals(source)
	RegisterSignal(source, COMSIG_ITEM_ATTACK_SELF, .proc/suck)

/datum/artifact_effect/gravity_well/proc/suck(datum/source, mob/warper)
	SIGNAL_HANDLER
	if(world.time < next_use_world_time)
		return
	var/turf/T = get_turf(warper)
	if(T)
		goonchem_vortex(T, FALSE, 8)
		playsound(src, 'sound/magic/repulse.ogg')
		next_use_world_time = world.time + 150

//===================
// Access Modifier
// Just replaces access 4noraisin
//===================

/datum/artifact_effect/access
	requires_processing = TRUE
	var/next_use_time = 0
	effect_act_descs = list("рядом с чем-то")

/datum/artifact_effect/access/process(delta_time)
	if(next_use_time < world.time)
		return
	next_use_time = world.time + rand(30 SECONDS, 5 MINUTES)
	var/list/idcards = list()
	var/list/things_in_view = view(5, src)
	for(var/mob/living/carbon/human/H in things_in_view)
		if(H.get_idcard())
			idcards += H.get_idcard()
	for(var/obj/item/card/id/id_card in things_in_view)
		idcards += id_card
	for(var/obj/item/card/id/id_card as() in idcards)
		id_card.trim = /datum/id_trim/admin
		id_card.wildcard_slots = WILDCARD_LIMIT_ADMIN

//===================
// Reality Destabilizer
//===================

GLOBAL_LIST_EMPTY(destabilization_spawns)
GLOBAL_LIST_EMPTY(destabliization_exits)

/obj/effect/landmark/destabilization_loc
	name = "destabilization spawn"

/obj/effect/landmark/destabilization_loc/Initialize()
	..()
	GLOB.destabilization_spawns += get_turf(src)
	return INITIALIZE_HINT_QDEL

/datum/artifact_effect/reality_destabilizer
	requires_processing = TRUE
	var/cooldown = 0
	var/list/contained_things = list()
	effect_act_descs = list("рядом с чем-то")

/datum/artifact_effect/reality_destabilizer/Initialize(source)
	. = ..()
	GLOB.destabliization_exits += source

/datum/artifact_effect/reality_destabilizer/Destroy()
	for(var/atom/movable/AM as() in contained_things)
		AM.forceMove(get_turf(src))
	contained_things.Cut()
	GLOB.destabliization_exits -= source_object
	. = ..()

/datum/artifact_effect/reality_destabilizer/process(delta_time)
	if(world.time < cooldown)
		return
	cooldown = world.time + rand(0, 30 SECONDS)
	var/turf/T = get_turf(source_object)
	if(!T)
		return
	for(var/atom/movable/AM in view(3, T))
		if(AM == src)
			continue
		if(isobj(AM))
			var/obj/O = AM
			if(O.resistance_flags & INDESTRUCTIBLE)
				continue
		if(AM.anchored)
			continue
		if(prob(3))
			destabilize(AM)

/datum/artifact_effect/reality_destabilizer/proc/destabilize(atom/movable/AM)
	//Banish to the void
	addtimer(CALLBACK(src, .proc/restabilize, AM, get_turf(AM)), rand(10 SECONDS, 90 SECONDS))

	if(GLOB.destabilization_spawns.len == 0)
		for(var/i in 1 to rand(3, 9))
			var/turf/T = get_safe_random_station_turf()
			if(T)
				GLOB.destabilization_spawns += T

	//Forcemove to ignore teleport checks
	if(GLOB.destabilization_spawns.len != 0) //@valtos долбоёб
		AM.forceMove(pick(GLOB.destabilization_spawns))
	else
		stack_trace("Пустой GLOB.destabilization_spawns. мапперу пизда звоните фиксикам")//@valtos фашист где маппер где фиксики

	contained_things += AM

/datum/artifact_effect/reality_destabilizer/proc/create_random_destabilization_spawns()


/datum/artifact_effect/reality_destabilizer/proc/restabilize(atom/movable/AM, turf/T)
	if(QDELETED(src))
		return
	if(QDELETED(AM))
		return
	var/area/A = get_area(AM)
	//already left the tear.
	if(!istype(A, /area/tear_in_reality))
		return
	AM.forceMove(T)
	contained_things -= AM

//===================
// Teleport
//===================

/datum/artifact_effect/warp
	signal_types = list(COMSIG_ITEM_ATTACK_SELF)
	var/next_use_world_time = 0
	effect_act_descs = list("использованный")

/datum/artifact_effect/warp/register_signals(source)
	RegisterSignal(source, COMSIG_ITEM_ATTACK_SELF, .proc/teleport)

/datum/artifact_effect/warp/proc/teleport(datum/source, mob/warper)
	SIGNAL_HANDLER
	if(world.time < next_use_world_time)
		return
	var/turf/T = get_turf(warper)
	if(T)
		do_teleport(warper, pick(RANGE_TURFS(10, T)), channel = TELEPORT_CHANNEL_FREE)
		next_use_world_time = world.time + 150

//===================
// Curse
//===================

/datum/artifact_effect/curse
	var/used = FALSE
	signal_types = list(COMSIG_ITEM_PICKUP)
	effect_act_descs = list("поднятый")

/datum/artifact_effect/curse/register_signals(source)
	RegisterSignal(source, COMSIG_ITEM_PICKUP, .proc/curse)

/datum/artifact_effect/curse/proc/curse(datum/source, mob/taker)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/H = taker
	if(istype(H) && !used)
		used = TRUE
		H.gain_trauma(/datum/brain_trauma/magic/stalker, TRAUMA_RESILIENCE_LOBOTOMY)

//===================
// Gas ~~Remover~~ Converter
// Probably one of the most obvious but also the most potentially dangerous.
//===================

/datum/artifact_effect/gas_remove
	requires_processing = TRUE
	var/static/list/valid_inputs = list(
		/datum/gas/oxygen = 6,
		/datum/gas/nitrogen = 3,
		/datum/gas/plasma = 1,
		/datum/gas/carbon_dioxide = 1,
		/datum/gas/water_vapor = 3
	)
	var/static/list/valid_outputs = list(
		/datum/gas/bz = 3,
		/datum/gas/hypernoblium = 1,
		/datum/gas/miasma = 3,
		/datum/gas/plasma = 3,
		/datum/gas/tritium = 2,
		/datum/gas/nitryl = 1
	)
	var/datum/gas/input
	var/datum/gas/output

/datum/artifact_effect/gas_remove/Initialize(source)
	. = ..()
	input = pickweight(valid_inputs)
	var/datum/gas/temp_gas = new input(src)
	effect_act_descs = list("рядом с [temp_gas.name]")
	qdel(temp_gas)
	output = pickweight(valid_outputs)

/datum/artifact_effect/gas_remove/process(delta_time)
	var/turf/T = get_turf(source_object)
	var/datum/gas_mixture/air = T.return_air()
	var/moles = min(air.get_moles(input), 5)
	if(moles)
		air.adjust_moles(input, -moles)
		air.adjust_moles(output, moles)

//===================
// Recharger
//===================

/datum/artifact_effect/recharger
	requires_processing = TRUE
	effect_act_descs = list("рядом с чем-то")

/datum/artifact_effect/recharger/process(delta_time)
	var/turf/T = get_turf(source_object)
	if(!T)
		return
	for(var/atom/movable/thing in view(3, T))
		var/obj/item/stock_parts/cell/C = thing.get_cell()
		if(C)
			C.give(250 * delta_time)

//===================
// Light Breaker
//===================

/datum/artifact_effect/light_breaker
	requires_processing = TRUE
	effect_act_descs = list("рядом с чем-то")
	var/next_world_time

/datum/artifact_effect/light_breaker/process(delta_time)
	if(world.time < next_world_time)
		return
	var/turf/T = get_turf(source_object)
	for(var/datum/light_source/light_source in T.contents)
		var/atom/movable/AM = light_source.source_atom
		//Starts at light but gets stronger the longer it is in light.
		AM.lighteater_act()
	next_world_time = world.time + rand(30 SECONDS, 5 MINUTES)

//===================
// Insanity Pulse
//===================

/datum/artifact_effect/insanity_pulse
	var/next_use_time = 0
	var/cooldown
	var/first_time = TRUE
	signal_types = list(COMSIG_ITEM_ATTACK_SELF)
	effect_act_descs = list("использованный")

/datum/artifact_effect/insanity_pulse/Initialize(source)
	. = ..()
	cooldown = rand(5 MINUTES, 15 MINUTES)

/datum/artifact_effect/insanity_pulse/register_signals(source)
	RegisterSignal(source, COMSIG_ITEM_ATTACK_SELF, .proc/pulse)

/datum/artifact_effect/insanity_pulse/proc/pulse(datum/source, mob/living/pulser)
	SIGNAL_HANDLER
	if(!istype(pulser))
		return
	if(world.time < next_use_time)
		return
	SEND_SOUND(world, 'sound/magic/repulse.ogg')
	next_use_time = world.time + cooldown
	var/turf/T = get_turf(pulser)
	log_attack("[key_name_admin(pulser)] activated an insanity pulse at [COORD(T)]. [first_time ? " (Effects were unknown)" : " (Artifact had been activated before)"]")
	message_admins("[ADMIN_LOOKUPFLW(pulser)] activated an insanity pulse [first_time ? " (Effects were unknown)" : " (Artifact had been activated before)"].")
	if(first_time)
		var/research_reward = rand(5000, 20000)
		priority_announce("Временные аномалии обнаружены в локации [T.loc]. Анализ завершён, [research_reward] научных очков получено.", "Исследовательский отдел Нантрейзен", ANNOUNCER_SPANOMALIES)
		SSresearch.science_tech.add_points_all(research_reward)
	first_time = FALSE
	pulser.blind_eyes(300)
	pulser.Stun(100)
	pulser.hallucination = 500
	INVOKE_ASYNC(src, .proc/do_pulse, T)

/datum/artifact_effect/insanity_pulse/proc/do_pulse(turf/T)
	var/xrange = 50
	var/yrange = 50
	var/cx = T.x
	var/cy = T.y
	for(var/r in 1 to max(xrange, yrange))
		var/xr = min(xrange, r)
		var/yr = min(yrange, r)
		var/turf/TL = locate(cx - xr, cy + yr, T.z)
		var/turf/BL = locate(cx - xr, cy - yr, T.z)
		var/turf/TR = locate(cx + xr, cy + yr, T.z)
		var/turf/BR = locate(cx + xr, cy - yr, T.z)
		var/list/turfs = list()
		turfs += block(TL, TR)
		turfs += block(TL, BL)
		turfs |= block(BL, BR)
		turfs |= block(BR, TR)
		for(var/turf/T1 as() in turfs)
			new /obj/effect/temp_visual/mining_scanner(T1)
			var/mob/living/M = locate() in T1
			if(M)
				to_chat(M, span_warning("Ооох..."))
				M.blind_eyes(30)
				M.Knockdown(10)
				M.emote("agony")
				M.Jitter(50)
				M.hallucination = M.hallucination + 20
			CHECK_TICK
		sleep(2)

#define NARSIE_CHANCE_TO_PICK_NEW_TARGET 5
#define NARSIE_CONSUME_RANGE 12
#define NARSIE_GRAV_PULL 10
#define NARSIE_MESMERIZE_CHANCE 25
#define NARSIE_MESMERIZE_EFFECT 60
#define NARSIE_SINGULARITY_SIZE 12

/// Nar'Sie, the God of the blood cultists
/obj/narsie
	name = "Nar'Sie"
	desc = "Your mind begins to bubble and ooze as it tries to comprehend what it sees."
	icon = 'icons/obj/narsie.dmi'
	icon_state = "narsie"
	anchored = TRUE
	appearance_flags = LONG_GLIDE
	density = FALSE
	gender = FEMALE
	light_color = COLOR_RED
	light_power = 0.7
	light_range = 15
	light_range = 6
	move_resist = INFINITY
	obj_flags = CAN_BE_HIT | DANGEROUS_POSSESSION
	pixel_x = -236
	pixel_y = -256
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	flags_1 = SUPERMATTER_IGNORES_1

	/// The singularity component to move around Nar'Sie.
	/// A weak ref in case an admin removes the component to preserve the functionality.
	var/datum/weakref/singularity

	var/list/souls_needed = list()
	var/soul_goal = 0
	var/souls = 0
	var/resolved = FALSE
	var/clashing = FALSE
	var/next_attack_tick

/obj/narsie/Initialize(mapload)
	. = ..()

	SSpoints_of_interest.make_point_of_interest(src)

	singularity = WEAKREF(AddComponent(
		/datum/component/singularity, \
		bsa_targetable = FALSE, \
		consume_callback = CALLBACK(src, PROC_REF(consume)), \
		consume_range = NARSIE_CONSUME_RANGE, \
		disregard_failed_movements = TRUE, \
		grav_pull = NARSIE_GRAV_PULL, \
		roaming = FALSE, /* This is set once the animation finishes */ \
		singularity_size = NARSIE_SINGULARITY_SIZE, \
	))

	send_to_playing_players(span_narsie("NAR'SIE HAS RISEN"))
	sound_to_playing_players('sound/creatures/narsie_rises.ogg')

	var/area/area = get_area(src)
	if(area)
		var/mutable_appearance/alert_overlay = mutable_appearance('icons/effects/cult_effects.dmi', "ghostalertsie")
		notify_ghosts("Nar'Sie has risen in [area]. Reach out to the Geometer to be given a new shell for your soul.", source = src, alert_overlay = alert_overlay, action = NOTIFY_ATTACK)
	narsie_spawn_animation()

	GLOB.cult_narsie = src
	var/list/all_cults = list()

	for (var/datum/antagonist/cult/cultist in GLOB.antagonists)
		if (!cultist.owner)
			continue
		all_cults |= cultist.cult_team

	for (var/_cult_team in all_cults)
		var/datum/team/cult/cult_team = _cult_team
		deltimer(cult_team.blood_target_reset_timer)
		cult_team.blood_target = src
		var/datum/objective/eldergod/summon_objective = locate() in cult_team.objectives
		if(summon_objective)
			summon_objective.summoned = TRUE

	for (var/_cult_mind in SSticker.mode.cult)
		var/datum/mind/cult_mind = _cult_mind
		if (isliving(cult_mind.current))
			var/mob/living/L = cult_mind.current
			L.narsie_act()

	for (var/mob/living/carbon/player in GLOB.player_list)
		if (player.stat != DEAD && is_station_level(player.loc?.z) && !iscultist(player))
			souls_needed[player] = TRUE

	soul_goal = round(1 + LAZYLEN(souls_needed) * 0.75)
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(begin_the_end))

	check_gods_battle()

/obj/narsie/Destroy()
	send_to_playing_players(span_narsie("\"<b>[pick("Nooooo...", "Not die. How-", "Die. Mort-", "Sas tyen re-")]\"</b>"))
	sound_to_playing_players('sound/magic/demon_dies.ogg', 50)

	var/list/all_cults = list()

	for (var/datum/antagonist/cult/cultist in GLOB.antagonists)
		if (!cultist.owner)
			continue
		all_cults |= cultist.cult_team

	for(var/_cult_team in all_cults)
		var/datum/team/cult/cult_team = _cult_team
		var/datum/objective/eldergod/summon_objective = locate() in cult_team.objectives
		if (summon_objective)
			summon_objective.summoned = FALSE
			summon_objective.killed = TRUE

	return ..()

/obj/narsie/attack_ghost(mob/user)
	makeNewConstruct(/mob/living/simple_animal/hostile/construct/harvester, user, cultoverride = TRUE, loc_override = loc)

/obj/narsie/process(delta_time)
	var/datum/component/singularity/singularity_component = singularity.resolve()

	if(clashing)
		//Oh god what is it doing...
		singularity_component?.target = clashing
		if(get_dist(src, clashing) < 5)
			if(next_attack_tick < world.time)
				next_attack_tick = world.time + rand(50, 100)
				to_chat(world, span_danger("[pick("You hear the scratching of cogs.","You hear the clanging of pipes.","You feel your bones start to rust...")]"))
				SEND_SOUND(world, 'sound/magic/clockwork/narsie_attack.ogg')
				SpinAnimation(4, 0)
				for(var/mob/living/M in GLOB.player_list)
					shake_camera(M, 25, 6)
					M.Knockdown(10)
				if(DT_PROB(max(SSticker.mode?.cult.len/2, 15), delta_time))
					SEND_SOUND(world, 'sound/magic/clockwork/anima_fragment_death.ogg')
					SEND_SOUND(world, pick(FAR_EXPLOSION_SOUNDS))
					to_chat(world, span_narsie("You really thought you could best me twice?"))
					QDEL_NULL(clashing)
					for(var/datum/mind/M as() in GLOB.servants_of_ratvar)
						to_chat(M, span_userdanger("You feel a stabbing pain in your chest... This can't be happening!"))
						M.current?.dust()

	if (!isnull(singularity_component) && (!singularity_component?.target || prob(NARSIE_CHANCE_TO_PICK_NEW_TARGET)))
		pickcultist()

	if (prob(NARSIE_MESMERIZE_CHANCE))
		mesmerize()

/obj/narsie/Bump(atom/target)
	var/turf/target_turf = get_turf(target)
	if (target_turf == loc)
		target_turf = get_step(target, target.dir) //please don't slam into a window like a bird, Nar'Sie
	forceMove(target_turf)

/// Stun people around Nar'Sie that aren't cultists
/obj/narsie/proc/mesmerize()
	for (var/mob/living/carbon/victim in viewers(NARSIE_CONSUME_RANGE, src))
		if (victim.stat == CONSCIOUS)
			if (!iscultist(victim))
				to_chat(victim, span_cultsmall("You feel conscious thought crumble away in an instant as you gaze upon [src]..."))
				victim.apply_effect(NARSIE_MESMERIZE_EFFECT, EFFECT_STUN)

/// Narsie rewards her cultists with being devoured first, then picks a ghost to follow.
/obj/narsie/proc/pickcultist()
	var/list/cultists = list()
	var/list/noncultists = list()

	for (var/mob/living/carbon/food in GLOB.alive_mob_list) //we don't care about constructs or cult-Ians or whatever. cult-monkeys are fair game i guess
		var/turf/pos = get_turf(food)
		if (!pos || (pos.z != z))
			continue

		if (iscultist(food))
			cultists += food
		else
			noncultists += food

		if (cultists.len) //cultists get higher priority
			acquire(pick(cultists))
			return

		if (noncultists.len)
			acquire(pick(noncultists))
			return

	//no living humans, follow a ghost instead.
	for (var/mob/dead/observer/ghost in GLOB.player_list)
		var/turf/pos = get_turf(ghost)
		if (!pos || (pos.z != z))
			continue
		cultists += ghost
	if (cultists.len)
		acquire(pick(cultists))
		return

/// Nar'Sie gets a taste of something, and will start to gravitate towards it
/obj/narsie/proc/acquire(atom/food)
	var/datum/component/singularity/singularity_component = singularity.resolve()

	if (isnull(singularity_component))
		return

	var/old_target = singularity_component.target
	if (food == old_target)
		return

	to_chat(old_target, span_cultsmall("NAR'SIE HAS LOST INTEREST IN YOU."))
	singularity_component.target = food
	if(ishuman(food))
		to_chat(food, span_cult("NAR'SIE HUNGERS FOR YOUR SOUL."))
	else
		to_chat(food, span_cult("NAR'SIE HAS CHOSEN YOU TO LEAD HER TO HER NEXT MEAL."))

/// Called to make Nar'Sie convert objects to cult stuff, or to eat
/obj/narsie/proc/consume(atom/target)
	if (isturf(target))
		target.narsie_act()

/obj/narsie/proc/narsie_spawn_animation()
	setDir(SOUTH)
	flick("narsie_spawn_anim", src)
	addtimer(CALLBACK(src, PROC_REF(narsie_spawn_animation_end)), 3.5 SECONDS)

/obj/narsie/proc/narsie_spawn_animation_end()
	var/datum/component/singularity/singularity_component = singularity.resolve()
	singularity_component?.roaming = TRUE

/proc/begin_the_end()
	sleep(50)
	if(QDELETED(GLOB.cult_narsie)) // uno
		priority_announce("Status report? We detected an anomaly, but it disappeared almost immediately.","Central Command Higher Dimensional Affairs", 'sound/misc/notice1.ogg')
		GLOB.cult_narsie = null
		sleep(20)
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(cult_ending_helper), 2)
		return
	priority_announce("An acausal dimensional event has been detected in your sector. Event has been flagged EXTINCTION-CLASS. Directing all available assets toward simulating solutions. SOLUTION ETA: 60 SECONDS.","Central Command Higher Dimensional Affairs", 'sound/misc/airraid.ogg')
	sleep(500)
	if(QDELETED(GLOB.cult_narsie)) // dos
		priority_announce("Simulations aborted, sensors report that the acasual event is normalizing. Good work, crew.","Central Command Higher Dimensional Affairs", 'sound/misc/notice1.ogg')
		GLOB.cult_narsie = null
		sleep(20)
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(cult_ending_helper), 2)
		return
	priority_announce("Simulations on acausal dimensional event complete. Deploying solution package now. Deployment ETA: ONE MINUTE. ","Central Command Higher Dimensional Affairs")
	sleep(50)
	SSsecurity_level.set_level("delta")
	SSshuttle.registerHostileEnvironment(GLOB.cult_narsie)
	SSshuttle.lockdown = TRUE
	sleep(600)
	if(QDELETED(GLOB.cult_narsie)) // tres
		priority_announce("Normalization detected! Abort the solution package!","Central Command Higher Dimensional Affairs", 'sound/misc/notice1.ogg')
		GLOB.cult_narsie = null
		sleep(20)
		SSsecurity_level.set_level("red")
		SSshuttle.clearHostileEnvironment()
		SSshuttle.lockdown = FALSE
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(cult_ending_helper), 2)
		return
	if(GLOB.cult_narsie.resolved == FALSE)
		GLOB.cult_narsie.resolved = TRUE
		sound_to_playing_players('sound/machines/alarm.ogg')
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(cult_ending_helper)), 120)

/proc/ending_helper()
	SSticker.force_ending = 1

/proc/cult_ending_helper(ending_type = 0)
	if(ending_type == 2) //narsie fukkin died
		Cinematic(CINEMATIC_CULT_FAIL,world,CALLBACK(GLOBAL_PROC,/proc/ending_helper))
	else if(ending_type) //no explosion
		Cinematic(CINEMATIC_CULT,world,CALLBACK(GLOBAL_PROC,/proc/ending_helper))
	else // explosion
		Cinematic(CINEMATIC_CULT_NUKE,world,CALLBACK(GLOBAL_PROC,/proc/ending_helper))

#undef NARSIE_CHANCE_TO_PICK_NEW_TARGET
#undef NARSIE_CONSUME_RANGE
#undef NARSIE_GRAV_PULL
#undef NARSIE_MESMERIZE_CHANCE
#undef NARSIE_MESMERIZE_EFFECT
#undef NARSIE_SINGULARITY_SIZE

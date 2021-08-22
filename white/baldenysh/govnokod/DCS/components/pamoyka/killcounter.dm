GLOBAL_LIST_EMPTY(killcounter_counted_kills)

/datum/component/killcounter
	var/kill_count = 0
	var/cur_killstreak = 0
	var/max_killstreak = 0
	var/killstreak_time = 10 SECONDS
	var/last_kill_time = 0
	var/count_clientless = FALSE

/datum/component/killcounter/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, .proc/on_mob_death)

/datum/component/killcounter/Destroy(force, silent)
	. = ..()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, .proc/on_mob_death)

/datum/component/killcounter/proc/on_mob_death(datum/source, mob/living/dead, gibbed)
	SIGNAL_HANDLER
	var/mob/living/owner = parent
	if(!owner)
		return
	if(!dead.lastattacker)
		return
	if(dead.lastattacker != owner.real_name)
		return
	if(dead.real_name == owner.real_name)
		return
	on_kill(dead)

/datum/component/killcounter/proc/on_kill(mob/living/killed)
	if(!killed.ckey && !count_clientless)
		return

	kill_count++

	if(world.time < last_kill_time + killstreak_time)
		cur_killstreak++
		if(cur_killstreak > max_killstreak)
			max_killstreak = cur_killstreak
		if(should_play_sound())
			play_funny_sound()
	else
		cur_killstreak = 1

	if(GLOB.killcounter_counted_kills[key_name(parent)])
		GLOB.killcounter_counted_kills[key_name(parent)] |= key_name(killed)
	else
		GLOB.killcounter_counted_kills[key_name(parent)] = list(key_name(killed))

	last_kill_time = world.time

/datum/component/killcounter/proc/should_play_sound()
	if(GLOB.prikol_mode)
		return TRUE
	var/mob/living/owner = parent
	for(var/datum/antagonist/A in owner?.mind?.antag_datums)
		if(locate(/datum/objective/hijack) in A.objectives)
			return TRUE
		if(locate(/datum/objective/martyr) in A.objectives)
			return TRUE
		if(locate(/datum/objective/elimination) in A.objectives)
			return TRUE
		if(locate(/datum/objective/nuclear) in A.objectives)
			return TRUE
	return FALSE

/datum/component/killcounter/proc/play_funny_sound()
	var/turf/T = get_turf(parent)
	switch(cur_killstreak)
		if(2) playsound(T,'white/hule/SFX/csSFX/doublekill1_ultimate.wav', 150, 5, pressure_affected = FALSE)
		if(3) playsound(T,'white/hule/SFX/csSFX/triplekill_ultimate.wav', 150, 5, pressure_affected = FALSE)
		if(4) playsound(T,'white/hule/SFX/csSFX/killingspree.wav', 150, 5, pressure_affected = FALSE)
		if(5) playsound(T,'white/hule/SFX/csSFX/godlike.wav', 150, 5, pressure_affected = FALSE)
		if(6) playsound(T,'white/hule/SFX/csSFX/monsterkill.wav', 150, 5, pressure_affected = FALSE)
		if(7) playsound(T,'white/hule/SFX/csSFX/multikill.wav', 150, 5, pressure_affected = FALSE)
		if(8) playsound(T,'white/hule/SFX/csSFX/multikill.wav', 150, 5, pressure_affected = FALSE)
		if(9 to INFINITY) playsound(T,'white/hule/SFX/csSFX/holyshit.wav', 150, 5, pressure_affected = FALSE)

/proc/log_combat_extension(atom/user, atom/target)
	if(!isliving(user) || !isliving(target))
		return
	var/mob/living/attacker = user
	var/mob/living/attacked = target
	attacked.lastattacker = attacker.real_name

/mob/living/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/killcounter)

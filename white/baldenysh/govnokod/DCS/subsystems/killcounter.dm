SUBSYSTEM_DEF(killcounter)
	name = "Счетчик убийств"
	flags = SS_NO_FIRE
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	init_order = 5

	var/force_funny_sound = FALSE
	var/count_clientless = FALSE
	var/killstreak_time = 30 SECONDS

	var/list/key_name_kill_counter = list()
	var/list/datum/killstreak_counter/killstreak_tracker = list()


/datum/controller/subsystem/killcounter/Initialize(mapload)
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(on_mob_death))
	return SS_INIT_SUCCESS

/datum/controller/subsystem/killcounter/proc/on_mob_death(datum/source, mob/living/dead, gibbed)
	SIGNAL_HANDLER
	if(!dead.lastattackermob)
		return
	var/mob/living/killer = dead.lastattackermob

	if(!dead.ckey && !count_clientless)
		return

	if(!killstreak_tracker[ref(killer)])
		killstreak_tracker[ref(killer)] = new /datum/killstreak_counter()

	var/datum/killstreak_counter/killers_counter = killstreak_tracker[ref(killer)]
	killers_counter.count(killstreak_time)
	killers_counter.try_set_loc(get_turf(killer))

	if(should_play_sound(killer))
		play_funny_sound(killers_counter)

	if(key_name_kill_counter[key_name(killer)])
		key_name_kill_counter[key_name(killer)] |= key_name(dead)
	else
		key_name_kill_counter[key_name(killer)] = list(key_name(dead))

/datum/controller/subsystem/killcounter/proc/should_play_sound(mob/living/killer)
	if(GLOB.prikol_mode || force_funny_sound)
		return TRUE
	for(var/datum/antagonist/A in killer?.mind?.antag_datums)
		if(locate(/datum/objective/hijack) in A.objectives)
			return TRUE
		if(locate(/datum/objective/martyr) in A.objectives)
			return TRUE
		if(locate(/datum/objective/elimination) in A.objectives)
			return TRUE
		if(locate(/datum/objective/nuclear) in A.objectives)
			return TRUE
	return FALSE

/datum/controller/subsystem/killcounter/proc/play_funny_sound(datum/killstreak_counter/ksc)
	switch(ksc.cur_killstreak)
		if(2) playsound(ksc.last_location,'white/hule/SFX/csSFX/doublekill1_ultimate.wav', 150, 5, pressure_affected = FALSE)
		if(3) playsound(ksc.last_location,'white/hule/SFX/csSFX/triplekill_ultimate.wav', 150, 5, pressure_affected = FALSE)
		if(4) playsound(ksc.last_location,'white/hule/SFX/csSFX/killingspree.wav', 150, 5, pressure_affected = FALSE)
		if(5) playsound(ksc.last_location,'white/hule/SFX/csSFX/godlike.wav', 150, 5, pressure_affected = FALSE)
		if(6) playsound(ksc.last_location,'white/hule/SFX/csSFX/monsterkill.wav', 150, 5, pressure_affected = FALSE)
		if(7) playsound(ksc.last_location,'white/hule/SFX/csSFX/multikill.wav', 150, 5, pressure_affected = FALSE)
		if(8) playsound(ksc.last_location,'white/hule/SFX/csSFX/multikill.wav', 150, 5, pressure_affected = FALSE)
		if(9 to INFINITY) playsound(ksc.last_location,'white/hule/SFX/csSFX/holyshit.wav', 150, 5, pressure_affected = FALSE)

///////////////////

/proc/log_combat_extension(atom/user, atom/target)
	if(!isliving(user) || !isliving(target))
		return
	var/mob/living/attacked = target
	attacked.lastattackermob = user

/datum/killstreak_counter
	var/turf/last_location
	var/kill_count = 0
	var/cur_killstreak = 0
	var/max_killstreak = 0
	var/last_kill_time = 0

/datum/killstreak_counter/proc/try_set_loc(turf/T)
	if(T)
		last_location = T

/datum/killstreak_counter/proc/count(killstreak_time)
	kill_count++
	if(world.time < last_kill_time + killstreak_time)
		cur_killstreak++
		if(cur_killstreak > max_killstreak)
			max_killstreak = cur_killstreak
	else
		cur_killstreak = 1
	last_kill_time = world.time

////////////////////////////////////////////////////////////////////кнопка

/client/proc/open_killcounter_counts()
	set category = "Адм.Игра"
	set name = "Возможные убийства"

	if(!check_rights())
		return

	debug_variables(SSkillcounter.key_name_kill_counter) //чиста паебать

/// Fires an absurd amount of pies at the target
/datum/smite/pieforate
	name = ":P:ieforate"

	/// Determines how fucked the target is
	var/hatred

/datum/smite/pieforate/configure(client/user)
	var/static/list/how_fucked_is_this_dude = list("A little", "A lot", "So fucking much", "FUCK THIS DUDE")
	hatred = tgui_input_list(user, "How much do you hate this guy?", ,how_fucked_is_this_dude)

/datum/smite/pieforate/effect(client/user, mob/living/target)
	. = ..()
	if (!iscarbon(target))
		to_chat(user, span_warning("This must be used on a carbon mob."))
		return

	var/repetitions
	switch (hatred)
		if ("A little")
			repetitions = 1
		if ("A lot")
			repetitions = 2
		if ("So fucking much")
			repetitions = 3
		if ("FUCK THIS DUDE")
			repetitions = 4

	var/mob/living/carbon/dude = target
	var/list/open_adj_turfs = get_adjacent_open_turfs(dude)

	var/delay_per_shot = 1
	var/delay_counter = 1

	for (var/i in 1 to repetitions)
		for (var/_limb in dude.bodyparts)
			for (var/_iter_turf in shuffle(open_adj_turfs))
				var/turf/iter_turf = _iter_turf
				addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(pieing_squad), dude, iter_turf), delay_counter)
				delay_counter += delay_per_shot

	dude.Immobilize(delay_counter+1)

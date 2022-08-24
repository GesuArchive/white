/// Consume things that run into the supermatter from the tram. The tram calls forceMove (doesn't call Bump/ed) and not Move, and I'm afraid changing it will do something chaotic
/obj/machinery/power/supermatter_crystal/proc/tram_contents_consume(datum/source, list/tram_contents)
	SIGNAL_HANDLER

	spawn(-1) // le async de crutch
		for(var/atom/thing_to_consume as anything in tram_contents)
			Bumped(thing_to_consume)

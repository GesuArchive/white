// These defines are used to mark the cells as explored or not
#define MAZEGEN_TURF_UNSEARCHED "#ff0000"
#define MAZEGEN_TURF_CELL "#00ff00"

// Dont place this in the very corner of a map. It relies on adjacent turfs, and at the very edges you dont have turfs on all sides
/datum/map_generator/labyrinth
	/// List of turfs to iterate in total
	var/list/turf_list = list()
	/// "Stack" structure to be used while iterating
	var/list/working_stack = list()

// "Push" a turf to the working "stack"
/datum/map_generator/labyrinth/proc/push_turf(turf/T)
	working_stack.Add(T) // Add it to the end of the list

// "Pop" a turf off the working "stack"
/datum/map_generator/labyrinth/proc/pop_turf()
	var/turf/T = working_stack[length(working_stack)] // Get the last item in the list
	working_stack.Remove(T) // Take it off the top
	return T // Send it back

/datum/map_generator/labyrinth/generate_terrain(list/turfs)
	// Generate a turf stack
	for(var/target in turfs)
		var/turf/T = target
		// Mark as unsearched
		T.color = MAZEGEN_TURF_UNSEARCHED
		// Throw it in the list
		turf_list |= T

		// Windows time
		var/obj/structure/window/reinforced/WN = new(T)
		WN.dir = NORTH
		var/obj/structure/window/reinforced/WS = new(T)
		WS.dir = SOUTH
		var/obj/structure/window/reinforced/WE = new(T)
		WE.dir = EAST
		var/obj/structure/window/reinforced/WW = new(T)
		WW.dir = WEST
		CHECK_TICK

	// Do the actual work
	push_turf(turf_list[1]) // Use the first turf as the stack base
	while(length(working_stack))
		var/turf/T = pop_turf()

		// If you dont force cast these to strings, stuff cries. A lot.
		var/list/cardinals = list("[NORTH]", "[SOUTH]", "[EAST]", "[WEST]")

		// Unvisited turfs
		var/list/turf/unvisited_neighbours = list()

		// Check all cardinal turfs
		for(var/D in cardinals)
			var/turf/T2 = get_step(T, text2num(D))
			if(T2.color == MAZEGEN_TURF_UNSEARCHED)
				unvisited_neighbours["[D]"] += T2

		if(length(unvisited_neighbours))
			push_turf(T)
			var/D = pick(unvisited_neighbours)
			var/turf/T3 = unvisited_neighbours["[D]"] // Pick random dir turf

			// Remove the window between the two
			for(var/obj/structure/window/reinforced/W in T)
				if(W.dir == text2num(D))
					qdel(W)

			// On both tiles
			for(var/obj/structure/window/reinforced/W in T3)
				if(W.dir == REVERSE_DIR(text2num(D)))
					qdel(W)

			// Mark as visited
			T3.color = MAZEGEN_TURF_CELL
			push_turf(T3)

		CHECK_TICK

	// The walls have been generated, now cleanup turfs
	for(var/i in turf_list)
		var/turf/T = i
		// Reset markings
		T.color = null

		// Make sure we have adequate CPU
		CHECK_TICK

#undef MAZEGEN_TURF_UNSEARCHED
#undef MAZEGEN_TURF_CELL

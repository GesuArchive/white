/turf
	//conductivity is divided by 10 when interacting with air for balance purposes
	var/thermal_conductivity = 0.05
	var/heat_capacity = 1
	var/temperature_archived

	//list of open turfs adjacent to us
	var/list/atmos_adjacent_turfs
	//bitfield of dirs in which we thermal conductivity is blocked
	var/conductivity_blocked_directions = NONE

	//used to determine whether we should archive
	var/archived_cycle = 0
	var/current_cycle = 0

	//used for mapping and for breathing while in walls (because that's a thing that needs to be accounted for...)
	//string parsed by /datum/gas/proc/copy_from_turf
	var/initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	//approximation of MOLES_O2STANDARD and MOLES_N2STANDARD pending byond allowing constant expressions to be embedded in constant strings
	// If someone will place 0 of some gas there, SHIT WILL BREAK. Do not do that.

/turf/open
	//used for spacewind
	var/pressure_difference = 0
	var/pressure_direction = 0
	var/turf/pressure_specific_target

	var/datum/excited_group/excited_group
	var/excited = FALSE
	var/datum/gas_mixture/turf/air

	var/obj/effect/hotspot/active_hotspot
	var/planetary_atmos = FALSE //air will revert to initial_gas_mix over time

	var/list/atmos_overlay_types //gas IDs of current active gas overlays

/turf/open/Initialize(mapload)
	if(!blocks_air)
		air = new(2500,src)
		air.copy_from_turf(src)
	. = ..()

/turf/open/Destroy()
	if(active_hotspot)
		QDEL_NULL(active_hotspot)
	return ..()

/////////////////GAS MIXTURE PROCS///////////////////

/turf/open/assume_air(datum/gas_mixture/giver) //use this for machines to adjust air
	return assume_air_ratio(giver, 1)

/turf/open/assume_air_moles(datum/gas_mixture/giver, moles)
	if(!giver?.total_moles() || !moles)
		return FALSE
	if(SSair.thread_running())
		var giver_moles = giver.total_moles()
		if(giver_moles > 0)
			SSair.deferred_airs += list(list(giver, air, moles / giver_moles))
		else
			SSair.deferred_airs += list(list(giver, air, 0))
	else
		giver.transfer_to(air, moles)
		update_visuals()
	return TRUE

/turf/open/assume_air_ratio(datum/gas_mixture/giver, ratio)
	if(!giver)
		return FALSE
	if(SSair.thread_running())
		SSair.deferred_airs += list(list(giver, air, ratio))
	else
		giver.transfer_ratio_to(air, ratio)
		update_visuals()
	return TRUE

/turf/open/transfer_air(datum/gas_mixture/taker, moles)
	if(!taker || !return_air()) // shouldn't transfer from space
		return FALSE
	if(SSair.thread_running())
		var air_moles = air.total_moles()
		if(air_moles > 0)
			SSair.deferred_airs += list(list(air, taker, moles / air_moles))
		else
			SSair.deferred_airs += list(list(air, taker, 0))
	else
		air.transfer_to(taker, moles)
		update_visuals()
	return TRUE

/turf/open/transfer_air_ratio(datum/gas_mixture/taker, ratio)
	if(!taker || !return_air())
		return FALSE
	if(SSair.thread_running())
		SSair.deferred_airs += list(list(air, taker, ratio))
	else
		air.transfer_ratio_to(taker, ratio)
		update_visuals()
	return TRUE

/turf/open/remove_air(amount)
	var/datum/gas_mixture/ours = return_air()
	var/datum/gas_mixture/removed = ours.remove(amount)
	update_visuals()
	return removed

/turf/open/remove_air_ratio(ratio)
	var/datum/gas_mixture/ours = return_air()
	var/datum/gas_mixture/removed = ours?.remove_ratio(ratio)
	update_visuals()
	return removed

/turf/open/proc/copy_air_with_tile(turf/open/T)
	if(istype(T))
		air.copy_from(T.air)

/turf/open/proc/copy_air(datum/gas_mixture/copy)
	if(copy)
		air.copy_from(copy)

/turf/return_air()
	RETURN_TYPE(/datum/gas_mixture)
	var/datum/gas_mixture/GM = new
	GM.copy_from_turf(src)
	return GM

/turf/open/return_air()
	RETURN_TYPE(/datum/gas_mixture)
	return air

/turf/open/return_analyzable_air()
	return return_air()

/turf/temperature_expose()
	if(return_temperature() > heat_capacity)
		to_be_destroyed = TRUE

/turf/open/temperature_expose(datum/gas_mixture/air, exposed_temperature)
	SEND_SIGNAL(src, COMSIG_TURF_EXPOSE, air, exposed_temperature)
	check_atmos_process(src, air, exposed_temperature) //Manually do this to avoid needing to use elements, don't want 200 second atom init times

/turf/proc/archive()
	temperature_archived = temperature

/turf/open/archive()
	air.archive()
	archived_cycle = SSair.times_fired
	temperature_archived = temperature

/////////////////////////GAS OVERLAYS//////////////////////////////


/turf/open/proc/update_visuals()

	var/list/atmos_overlay_types = src.atmos_overlay_types // Cache for free performance
	var/list/new_overlay_types = list()
	var/static/list/nonoverlaying_gases = typecache_of_gases_with_no_overlays()

	if(!air) // 2019-05-14: was not able to get this path to fire in testing. Consider removing/looking at callers -Naksu
		if (atmos_overlay_types)
			for(var/overlay in atmos_overlay_types)
				vis_contents -= overlay
			src.atmos_overlay_types = null
		return


	for(var/id in air.get_gases())
		if (nonoverlaying_gases[id])
			continue
		var/gas_overlay = GLOB.gas_data.overlays[id]
		if(gas_overlay && air.get_moles(id) > GLOB.gas_data.visibility[id])
			new_overlay_types += gas_overlay[min(FACTOR_GAS_VISIBLE_MAX, CEILING(air.get_moles(id) / MOLES_GAS_VISIBLE_STEP, 1))]

	if (atmos_overlay_types)
		for(var/overlay in atmos_overlay_types-new_overlay_types) //doesn't remove overlays that would only be added
			vis_contents -= overlay

	if (length(new_overlay_types))
		if (atmos_overlay_types)
			vis_contents += new_overlay_types - atmos_overlay_types //don't add overlays that already exist
		else
			vis_contents += new_overlay_types

	UNSETEMPTY(new_overlay_types)
	src.atmos_overlay_types = new_overlay_types

/turf/open/proc/set_visuals(list/new_overlay_types)
	if (atmos_overlay_types)
		for(var/overlay in atmos_overlay_types-new_overlay_types) //doesn't remove overlays that would only be added
			vis_contents -= overlay

	if (length(new_overlay_types))
		if (atmos_overlay_types)
			vis_contents += new_overlay_types - atmos_overlay_types //don't add overlays that already exist
		else
			vis_contents += new_overlay_types
	UNSETEMPTY(new_overlay_types)
	src.atmos_overlay_types = new_overlay_types

/proc/typecache_of_gases_with_no_overlays()
	. = list()
	for (var/gastype in subtypesof(/datum/gas))
		var/datum/gas/gasvar = gastype
		if (!initial(gasvar.gas_overlay))
			.[initial(gasvar.id)] = TRUE

/////////////////////////////SIMULATION///////////////////////////////////

#define LAST_SHARE_CHECK \
	var/last_share = our_air.last_share;\
	if(last_share > MINIMUM_AIR_TO_SUSPEND){\
		our_excited_group.reset_cooldowns();\
		cached_atmos_cooldown = 0;\
	} else if(last_share > MINIMUM_MOLES_DELTA_TO_MOVE) {\
		our_excited_group.dismantle_cooldown = 0;\
		cached_atmos_cooldown = 0;\
	}

/turf/proc/process_cell(fire_count)
	return

/turf/open/process_cell(fire_count)
	if(archived_cycle < fire_count) //archive self if not already done
		archive()
	current_cycle = fire_count
	//cache for sanic speed
	var/list/adjacent_turfs = atmos_adjacent_turfs
	var/datum/excited_group/our_excited_group = excited_group
	var/adjacent_turfs_length = LAZYLEN(adjacent_turfs)
	//var/cached_atmos_cooldown = atmos_cooldown + 1
	var/planet_atmos = planetary_atmos
	if (planet_atmos)
		adjacent_turfs_length++
	var/datum/gas_mixture/our_air = air
	for(var/t in adjacent_turfs)
		var/turf/open/enemy_tile = t
		if(fire_count <= enemy_tile.current_cycle)
			continue
		enemy_tile.archive()
	/******************* GROUP HANDLING START *****************************************************************/
		var/should_share_air = FALSE
		var/datum/gas_mixture/enemy_air = enemy_tile.air
		//cache for sanic speed
		var/datum/excited_group/enemy_excited_group = enemy_tile.excited_group
		if(our_excited_group && enemy_excited_group)
			if(our_excited_group != enemy_excited_group)
				//combine groups (this also handles updating the excited_group var of all involved turfs)
				our_excited_group.merge_groups(enemy_excited_group)
				our_excited_group = excited_group //update our cache
			should_share_air = TRUE
		else if(our_air.compare(enemy_air))
			//if(!enemy_tile.excited)
				//SSair.add_to_active(enemy_tile)
			var/datum/excited_group/EG = our_excited_group || enemy_excited_group || new
			if(!our_excited_group)
				EG.add_turf(src)
			if(!enemy_excited_group)
				EG.add_turf(enemy_tile)
			our_excited_group = excited_group
			should_share_air = TRUE
		//air sharing
		if(should_share_air)
			var/difference = our_air.share(enemy_air, adjacent_turfs_length)
			if(difference)
				if(difference > 0)
					consider_pressure_difference(enemy_tile, difference)
				else
					enemy_tile.consider_pressure_difference(src, -difference)
			//LAST_SHARE_CHECK
	/******************* GROUP HANDLING FINISH *********************************************************************/
	if (planet_atmos) //share our air with the "atmosphere" "above" the turf
		var/datum/gas_mixture/G = new
		G.copy_from_turf(src)
		G.archive()
		if(our_air.compare(G))
			if(!our_excited_group)
				var/datum/excited_group/EG = new
				EG.add_turf(src)
				our_excited_group = excited_group
			our_air.share(G, adjacent_turfs_length)
			//LAST_SHARE_CHECK
	our_air.react(src)
	update_visuals()
	/*if((!our_excited_group && !(our_air.temperature > MINIMUM_TEMPERATURE_START_SUPERCONDUCTION && consider_superconductivity(starting = TRUE))) \
	  || (cached_atmos_cooldown > (EXCITED_GROUP_DISMANTLE_CYCLES * 2)))
		SSair.remove_from_active(src)*/
	//atmos_cooldown = cached_atmos_cooldown

/turf/open/proc/equalize_pressure_in_zone(cyclenum)
/turf/open/proc/consider_firelocks(turf/T2)

/turf/proc/handle_decompression_floor_rip()
/turf/open/floor/handle_decompression_floor_rip(sum)
	if(sum > 20 && prob(clamp(sum / 20, 0, 15)))
		if(floor_tile)
			new floor_tile(src)
		make_plating()

/turf/open/floor/plating/handle_decompression_floor_rip()
	return

/turf/open/floor/engine/handle_decompression_floor_rip()
	return

//////////////////////////SPACEWIND/////////////////////////////

/turf/proc/consider_pressure_difference()
	return

/turf/open/consider_pressure_difference(turf/T, difference)
	SSair.high_pressure_delta |= src
	if(difference > pressure_difference)
		pressure_direction = get_dir(src, T)
		pressure_difference = difference

/turf/open/proc/high_pressure_movements()
	var/atom/movable/M
	var/multiplier = 1
	if(locate(/obj/structure/rack) in src)
		multiplier *= 0.1
	else if(locate(/obj/structure/table) in src)
		multiplier *= 0.2
	for(var/thing in src)
		M = thing
		if (!M.anchored && !M.pulledby && M.last_high_pressure_movement_air_cycle < SSair.times_fired)
			M.experience_pressure_difference(pressure_difference * multiplier, pressure_direction, 0, pressure_specific_target)
	if(pressure_difference > 100)
		new /obj/effect/temp_visual/dir_setting/space_wind(src, pressure_direction, clamp(round(sqrt(pressure_difference) * 2), 10, 255))
		//if(pressure_difference > 400)
		//	playsound(src, 'white/valtos/sounds/depressurize.ogg', 50)

/atom/movable/var/pressure_resistance = 10
/atom/movable/var/last_high_pressure_movement_air_cycle = 0

/atom/movable/proc/experience_pressure_difference(pressure_difference, direction, pressure_resistance_prob_delta = 0, throw_target)
	set waitfor = FALSE
	if(SEND_SIGNAL(src, COMSIG_ATOM_PRE_PRESSURE_PUSH) & COMSIG_ATOM_BLOCKS_PRESSURE)
		return
	var/const/PROBABILITY_OFFSET = 40
	var/const/PROBABILITY_BASE_PRECENT = 10
	var/max_force = sqrt(pressure_difference)*(MOVE_FORCE_DEFAULT / 5)
	var/move_prob = 100
	if (pressure_resistance > 0)
		move_prob = (pressure_difference/pressure_resistance*PROBABILITY_BASE_PRECENT)-PROBABILITY_OFFSET
	move_prob += pressure_resistance_prob_delta
	if (move_prob > PROBABILITY_OFFSET && prob(move_prob) && (move_resist != INFINITY) && (!anchored && (max_force >= (move_resist * MOVE_FORCE_PUSH_RATIO))) || (anchored && (max_force >= (move_resist * MOVE_FORCE_FORCEPUSH_RATIO))))
		var/move_force = max_force * clamp(move_prob, 0, 100) / 100
		if(move_force > 6000)
			// WALLSLAM HELL TIME OH BOY
			var/turf/throw_turf = get_ranged_target_turf(get_turf(src), direction, round(move_force / 2000))
			if(throw_target && (get_dir(src, throw_target) & direction))
				throw_turf = get_turf(throw_target)
			var/throw_speed = clamp(round(move_force / 3000), 1, 10)
			throw_at(throw_turf, move_force / 3000, throw_speed)
		else
			step(src, direction)
		last_high_pressure_movement_air_cycle = SSair.times_fired

///////////////////////////EXCITED GROUPS/////////////////////////////

/datum/excited_group
	var/list/turf_list = list()
	var/breakdown_cooldown = 0
	var/dismantle_cooldown = 0

/datum/excited_group/New()
	SSair.excited_groups += src

/datum/excited_group/proc/add_turf(turf/open/T)
	turf_list += T
	T.excited_group = src
	reset_cooldowns()

/datum/excited_group/proc/merge_groups(datum/excited_group/E)
	if(turf_list.len > E.turf_list.len)
		SSair.excited_groups -= E
		for(var/t in E.turf_list)
			var/turf/open/T = t
			T.excited_group = src
			turf_list += T
		reset_cooldowns()
	else
		SSair.excited_groups -= src
		for(var/t in turf_list)
			var/turf/open/T = t
			T.excited_group = E
			E.turf_list += T
		E.reset_cooldowns()

/datum/excited_group/proc/reset_cooldowns()
	breakdown_cooldown = 0
	dismantle_cooldown = 0

//argument is so world start can clear out any turf differences quickly.
/datum/excited_group/proc/self_breakdown(space_is_all_consuming = FALSE, poke_turfs = FALSE)
	return
	/*
	var/datum/gas_mixture/A = new
	//make local for sanic speed
	var/list/A_gases = A.gases
	var/list/turf_list = src.turf_list
	var/turflen = turf_list.len
	var/space_in_group = FALSE
	for(var/t in turf_list)
		var/turf/open/T = t
		if (space_is_all_consuming && !space_in_group && istype(T.air, /datum/gas_mixture/immutable/space))
			space_in_group = TRUE
			qdel(A)
			A = new /datum/gas_mixture/immutable/space()
			A_gases = A.gases //update the cache
			break
		A.merge(T.air)
	for(var/id in A_gases)
		A_gases[id][MOLES] /= turflen
	for(var/t in turf_list)
		var/turf/open/T = t
		T.air.copy_from(A)
		T.atmos_cooldown = 0
		T.update_visuals()
	breakdown_cooldown = 0*/

/datum/excited_group/proc/dismantle()
	for(var/t in turf_list)
		var/turf/open/T = t
		T.excited = FALSE
		T.excited_group = null
		SSair.active_turfs -= T
	garbage_collect()

/datum/excited_group/proc/garbage_collect()
	for(var/t in turf_list)
		var/turf/open/T = t
		T.excited_group = null
	turf_list.Cut()
	SSair.excited_groups -= src

////////////////////////SUPERCONDUCTIVITY/////////////////////////////
/turf/proc/conductivity_directions()
	if(archived_cycle < SSair.times_fired)
		archive()
	return NORTH|SOUTH|EAST|WEST

/turf/open/conductivity_directions()
	for(var/direction in GLOB.cardinals)
		var/turf/T = get_step(src, direction)
		if(!(T in atmos_adjacent_turfs) && !(conductivity_blocked_directions & direction))
			. |= direction

/turf/proc/neighbor_conduct_with_src(turf/open/other)
	if(!isclosedturf(other)) //Open but neighbor is solid
		other.temperature_share_open_to_solid(src)
	else //Both tiles are solid
		other.share_temperature_mutual_solid(src, thermal_conductivity)
	temperature_expose(null, temperature, null)

/turf/open/neighbor_conduct_with_src(turf/other)
	if(!isclosedturf(other)) //Both tiles are open
		var/turf/open/T = other
		T.air.temperature_share(air, WINDOW_HEAT_TRANSFER_COEFFICIENT)
	else //Solid but neighbor is open
		temperature_share_open_to_solid(other)
	//SSair.add_to_active(src, 0)

/turf/proc/super_conduct()
	var/conductivity_directions = conductivity_directions()

	if(conductivity_directions)
		//Conduct with tiles around me
		for(var/direction in GLOB.cardinals)
			if(conductivity_directions & direction)
				var/turf/neighbor = get_step(src,direction)

				if(!neighbor.thermal_conductivity)
					continue

				if(neighbor.archived_cycle < SSair.times_fired)
					neighbor.archive()

				neighbor.neighbor_conduct_with_src(src)

				neighbor.consider_superconductivity()

	radiate_to_spess()

	finish_superconduction()

/turf/proc/finish_superconduction(temp = temperature)
	//Make sure still hot enough to continue conducting heat
	if(temp < MINIMUM_TEMPERATURE_FOR_SUPERCONDUCTION)
		SSair.active_super_conductivity -= src
		return FALSE

/turf/open/finish_superconduction()
	//Conduct with air on my tile if I have it
	temperature = air.temperature_share(null, thermal_conductivity, temperature, heat_capacity)
	..(air.temperature)

/turf/proc/consider_superconductivity()
	if(!thermal_conductivity)
		return FALSE

	SSair.active_super_conductivity |= src
	return TRUE

/turf/open/consider_superconductivity(starting)
	if(air.temperature < (starting?MINIMUM_TEMPERATURE_START_SUPERCONDUCTION:MINIMUM_TEMPERATURE_FOR_SUPERCONDUCTION))
		return FALSE
	if(air.heat_capacity() < M_CELL_WITH_RATIO) // Was: MOLES_CELLSTANDARD*0.1*0.05 Since there are no variables here we can make this a constant.
		return FALSE
	return ..()

/turf/closed/consider_superconductivity(starting)
	if(temperature < (starting?MINIMUM_TEMPERATURE_START_SUPERCONDUCTION:MINIMUM_TEMPERATURE_FOR_SUPERCONDUCTION))
		return FALSE
	return ..()

/turf/proc/radiate_to_spess() //Radiate excess tile heat to space
	if(temperature > T0C) //Considering 0 degC as te break even point for radiation in and out
		var/delta_temperature = (temperature_archived - TCMB) //hardcoded space temperature
		if((heat_capacity > 0) && (abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER))

			var/heat = thermal_conductivity*delta_temperature* \
				(heat_capacity*HEAT_CAPACITY_VACUUM/(heat_capacity+HEAT_CAPACITY_VACUUM))
			temperature -= heat/heat_capacity

/turf/open/proc/temperature_share_open_to_solid(turf/sharer)
	sharer.temperature = air.temperature_share(null, sharer.thermal_conductivity, sharer.temperature, sharer.heat_capacity)

/turf/proc/share_temperature_mutual_solid(turf/sharer, conduction_coefficient) //to be understood
	var/delta_temperature = (temperature_archived - sharer.temperature_archived)
	if(abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER && heat_capacity && sharer.heat_capacity)

		var/heat = conduction_coefficient*delta_temperature* \
			(heat_capacity*sharer.heat_capacity/(heat_capacity+sharer.heat_capacity))

		temperature -= heat/heat_capacity
		sharer.temperature += heat/sharer.heat_capacity

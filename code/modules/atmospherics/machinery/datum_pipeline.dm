/datum/pipeline
	var/datum/gas_mixture/air
	var/list/datum/gas_mixture/other_airs

	var/list/obj/machinery/atmospherics/pipe/members
	var/list/obj/machinery/atmospherics/components/other_atmosmch

	var/update = TRUE

/datum/pipeline/New()
	other_airs = list()
	members = list()
	other_atmosmch = list()
	SSair.networks += src

/datum/pipeline/Destroy()
	SSair.networks -= src
	if(air?.return_volume())
		temporarily_store_air()
	for(var/obj/machinery/atmospherics/pipe/considered_pipe in members)
		considered_pipe.parent = null
		if(QDELETED(considered_pipe))
			continue
		SSair.add_to_rebuild_queue(considered_pipe)
	for(var/obj/machinery/atmospherics/components/considered_component in other_atmosmch)
		considered_component.nullifyPipenet(src)
	return ..()

/datum/pipeline/process()
	if(update)
		update = FALSE
		reconcile_air()
	update = air.react(src)

/datum/pipeline/proc/build_pipeline(obj/machinery/atmospherics/base)
	var/volume = 0
	if(!istype(base, /obj/machinery/atmospherics/pipe))
		addMachineryMember(base)
	else
		var/obj/machinery/atmospherics/pipe/considered_pipe = base
		volume = considered_pipe.volume
		members += considered_pipe
		if(considered_pipe.air_temporary)
			air = considered_pipe.air_temporary
			considered_pipe.air_temporary = null

	if(!air)
		air = new
	var/list/possible_expansions = list(base)
	while(possible_expansions.len)
		for(var/obj/machinery/atmospherics/borderline in possible_expansions)
			var/list/result = borderline.pipeline_expansion(src)
			if(!result?.len)
				possible_expansions -= borderline
				continue
			for(var/obj/machinery/atmospherics/considered_device in result)
				if(!istype(considered_device, /obj/machinery/atmospherics/pipe))
					considered_device.setPipenet(src, borderline)
					addMachineryMember(considered_device)
					continue
				var/obj/machinery/atmospherics/pipe/item = considered_device
				if(members.Find(item))
					continue
				if(item.parent)
					var/static/pipenetwarnings = 10
					if(pipenetwarnings > 0)
						log_mapping("build_pipeline(): [item.type] added to a pipenet while still having one. (pipes leading to the same spot stacking in one turf) around [AREACOORD(item)].")
						pipenetwarnings--
					if(pipenetwarnings == 0)
						log_mapping("build_pipeline(): further messages about pipenets will be suppressed")

				members += item
				possible_expansions += item

				volume += item.volume
				item.parent = src

				if(item.air_temporary)
					air.merge(item.air_temporary)
					item.air_temporary = null

			possible_expansions -= borderline

	air.set_volume(volume)

/datum/pipeline/proc/addMachineryMember(obj/machinery/atmospherics/components/C)
	other_atmosmch |= C
	var/datum/gas_mixture/G = C.returnPipenetAir(src)
	if(!G)
		stack_trace("addMachineryMember: Null gasmix added to pipeline datum from [C] which is of type [C.type]. Nearby: ([C.x], [C.y], [C.z])")
	other_airs |= G

/datum/pipeline/proc/addMember(obj/machinery/atmospherics/A, obj/machinery/atmospherics/N)
	if(istype(A, /obj/machinery/atmospherics/pipe))
		var/obj/machinery/atmospherics/pipe/P = A
		if(P.parent)
			merge(P.parent)
		P.parent = src
		var/list/adjacent = P.pipeline_expansion()
		for(var/obj/machinery/atmospherics/pipe/I in adjacent)
			if(I.parent == src)
				continue
			var/datum/pipeline/E = I.parent
			merge(E)
		if(!members.Find(P))
			members += P
			air.set_volume(air.return_volume() + P.volume)
	else
		var/obj/machinery/atmospherics/pipe/reference_pipe = reference_device
		if(reference_pipe.parent)
			merge(reference_pipe.parent)
		reference_pipe.parent = src
		var/list/adjacent = reference_pipe.pipeline_expansion()
		for(var/obj/machinery/atmospherics/pipe/adjacent_pipe in adjacent)
			if(adjacent_pipe.parent == src)
				continue
			var/datum/pipeline/parent_pipeline = adjacent_pipe.parent
			merge(parent_pipeline)
		if(!members.Find(reference_pipe))
			members += reference_pipe
			air.volume += reference_pipe.volume

/datum/pipeline/proc/merge(datum/pipeline/parent_pipeline)
	if(parent_pipeline == src)
		return
	air.set_volume(air.return_volume() + E.air.return_volume())
	members.Add(E.members)
	for(var/obj/machinery/atmospherics/pipe/S in E.members)
		S.parent = src
	air.merge(E.air)
	for(var/obj/machinery/atmospherics/components/C in E.other_atmosmch)
		C.replacePipenet(E, src)
	other_atmosmch.Add(E.other_atmosmch)
	other_airs.Add(E.other_airs)
	E.members.Cut()
	E.other_atmosmch.Cut()
	update = TRUE
	qdel(parent_pipeline)

/obj/machinery/atmospherics/proc/addMember(obj/machinery/atmospherics/considered_device)
	return

/obj/machinery/atmospherics/pipe/addMember(obj/machinery/atmospherics/considered_device)
	parent.addMember(considered_device, src)

/obj/machinery/atmospherics/components/addMember(obj/machinery/atmospherics/considered_device)
	var/datum/pipeline/device_pipeline = returnPipenet(considered_device)
	if(!device_pipeline)
		CRASH("null.addMember() called by [type] on [COORD(src)]")
	device_pipeline.addMember(considered_device, src)


/datum/pipeline/proc/temporarily_store_air()
	//Update individual gas_mixtures by volume ratio

	for(var/obj/machinery/atmospherics/pipe/member in members)
		member.air_temporary = new
		member.air_temporary.set_volume(member.volume)
		member.air_temporary.copy_from(air)

		member.air_temporary.multiply(member.volume/air.return_volume())

		member.air_temporary.set_temperature(air.return_temperature())

/datum/pipeline/proc/temperature_interact(turf/target, share_volume, thermal_conductivity)
	var/total_heat_capacity = air.heat_capacity()
	var/partial_heat_capacity = total_heat_capacity*(share_volume/air.return_volume())
	var/target_temperature
	var/target_heat_capacity

	if(isopenturf(target))

		var/turf/open/modeled_location = target
		target_temperature = modeled_location.GetTemperature()
		target_heat_capacity = modeled_location.GetHeatCapacity()

		if(modeled_location.blocks_air)

			if((modeled_location.heat_capacity>0) && (partial_heat_capacity>0))
				var/delta_temperature = air.return_temperature() - target_temperature

				var/heat = thermal_conductivity * delta_temperature * (partial_heat_capacity * target_heat_capacity / (partial_heat_capacity + target_heat_capacity))

				air.set_temperature(air.return_temperature() - heat/total_heat_capacity)
				modeled_location.TakeTemperature(heat/target_heat_capacity)

		else
			var/delta_temperature = 0
			var/sharer_heat_capacity = 0

			delta_temperature = (air.return_temperature() - target_temperature)
			sharer_heat_capacity = target_heat_capacity

			var/self_temperature_delta = 0
			var/sharer_temperature_delta = 0

			if((sharer_heat_capacity <= 0) || (partial_heat_capacity <= 0))
				return TRUE
			var/heat = thermal_conductivity * delta_temperature * (partial_heat_capacity * sharer_heat_capacity / (partial_heat_capacity + sharer_heat_capacity))

			self_temperature_delta = - heat / total_heat_capacity
			sharer_temperature_delta = heat / sharer_heat_capacity

			air.set_temperature(air.return_temperature() + self_temperature_delta);
			modeled_location.TakeTemperature(sharer_temperature_delta)


	else
		if((target.heat_capacity>0) && (partial_heat_capacity>0))
			var/delta_temperature = air.return_temperature() - target.temperature

			var/heat = thermal_conductivity*delta_temperature* \
				(partial_heat_capacity*target.heat_capacity/(partial_heat_capacity+target.heat_capacity))

			air.set_temperature(air.return_temperature() - heat/total_heat_capacity)
	update = TRUE

/datum/pipeline/proc/return_air()
	. = other_airs + air
	if(null in .)
		stack_trace("[src] has one or more null gas mixtures, which may cause bugs. Null mixtures will not be considered in reconcile_air().")
		return removeNullsFromList(.)

/datum/pipeline/proc/reconcile_air()
	var/list/datum/gas_mixture/gas_mixture_list = list()
	var/list/datum/pipeline/pipeline_list = list()
	pipeline_list += src

	for(var/i = 1; i <= pipeline_list.len; i++) //can't do a for-each here because we may add to the list within the loop
		var/datum/pipeline/pipeline = pipeline_list[i]
		if(!pipeline)
			continue
		GL += P.return_air()
		for(var/atmosmch in P.other_atmosmch)
			if (istype(atmosmch, /obj/machinery/atmospherics/components/binary/valve))
				var/obj/machinery/atmospherics/components/binary/valve/considered_valve = atmosmch
				if(considered_valve.on)
					pipeline_list |= considered_valve.parents[1]
					pipeline_list |= considered_valve.parents[2]
			else if (istype(atmosmch, /obj/machinery/atmospherics/components/unary/portables_connector))
				var/obj/machinery/atmospherics/components/unary/portables_connector/considered_connector = atmosmch
				if(considered_connector.connected_device)
					gas_mixture_list += considered_connector.connected_device.air_contents

	var/datum/gas_mixture/total_gas_mixture = new(0)
	var/total_volume = 0

	for(var/i in GL)
		var/datum/gas_mixture/G = i
		total_gas_mixture.merge(G)
		total_volume += G.return_volume()

	if(total_volume > 0)
		//Update individual gas_mixtures by volume ratio
		for(var/i in GL)
			var/datum/gas_mixture/G = i
			G.copy_from(total_gas_mixture)
			G.multiply(G.return_volume()/total_volume)

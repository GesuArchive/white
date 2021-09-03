//"immutable" gas mixture used for immutable calculations
//it can be changed, but any changes will ultimately be undone before they can have any effect

/datum/gas_mixture/immutable
	var/initial_temperature = 0

/datum/gas_mixture/immutable/New()
	..()
	set_temperature(initial_temperature)
	populate()
	mark_immutable()

/datum/gas_mixture/immutable/proc/populate()
	return

//used by space tiles
/datum/gas_mixture/immutable/space
	initial_temperature = TCMB

/datum/gas_mixture/immutable/space/populate()
	set_min_heat_capacity(HEAT_CAPACITY_VACUUM)

/*
//planet side stuff
/datum/gas_mixture/immutable/planetary

/datum/gas_mixture/immutable/planetary/proc/parse_string_immutable(gas_string) //I know I know, I need this tho
	gas_string = SSair.preprocess_gas_string(gas_string)

	var/list/gas = params2list(gas_string)
	if(gas["TEMP"])
		initial_temperature = text2num(gas["TEMP"])
		set_temperature(initial_temperature)
		gas -= "TEMP"
	for(var/id in gas)
		var/path = id
		if(!ispath(path))
			path = gas_id2path(path) //a lot of these strings can't have embedded expressions (especially for mappers), so support for IDs needs to stick around
		set_moles(path, gas[path][MOLES])
*/

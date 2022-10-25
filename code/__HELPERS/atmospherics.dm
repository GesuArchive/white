/** A simple rudimentary gasmix to information list converter. Can be used for UIs.
 * Args:
 * * gasmix: [/datum/gas_mixture]
 * * name: String used to name the list, optional.
 * Returns: A list parsed_gasmixes with the following structure:
 * - parsed_gasmixes    Value: Assoc List     Desc: The thing we return
 * -- Key: name         Value: String         Desc: Gasmix Name
 * -- Key: temperature  Value: Number         Desc: Temperature in kelvins
 * -- Key: volume       Value: Number         Desc: Volume in liters
 * -- Key: pressure     Value: Number         Desc: Pressure in kPa
 * -- Key: ref          Value: String         Desc: The reference for the instantiated gasmix.
 * -- Key: gases        Value: Numbered list  Desc: List of gasses in our gasmix
 * --- Key: 1           Value: String         Desc: gas id var from the gas
 * --- Key: 2           Value: String         Desc: Human readable gas name.
 * --- Key: 3           Value: Number         Desc: Mol amount of the gas.
 * -- Key: gases        Value: Numbered list  Desc: Assoc list of reactions that occur inside.
 * --- Key: 1           Value: String         Desc: reaction id var from the gas.
 * --- Key: 2           Value: String         Desc: Human readable reaction name.
 * --- Key: 3           Value: Number         Desc: The number associated with the reaction.
 * Returned list should always be filled with keys even if value are nulls.
 */
/proc/gas_mixture_parser(datum/gas_mixture/gasmix, name)
	. = list(
		"gases" = list(),
		"reactions" = list(),
		"name" = format_text(name),
		"total_moles" = null,
		"temperature" = null,
		"volume"= null,
		"pressure"= null,
		"reference" = null,
	)
	if(!gasmix)
		return
	for(var/gas_id in gasmix.get_gases())
		.["gases"] += list(list(
			gas_id,
			GLOB.gas_data.names[gas_id],
			gasmix.get_moles(gas_id),
		))
	for(var/datum/gas_reaction/reaction_result as anything in gasmix.reaction_results)
		.["reactions"] += list(list(
			initial(reaction_result.id),
			initial(reaction_result.name),
			gasmix.reaction_results[reaction_result],
		))
	.["total_moles"] = gasmix.total_moles()
	.["temperature"] = gasmix.return_temperature()
	.["volume"] = gasmix.return_volume()
	.["pressure"] = gasmix.return_pressure()
	.["reference"] = REF(gasmix)

/// Logs the contents of the gasmix to the game log, prefixed by text
/proc/log_atmos(text, datum/gas_mixture/mix)
	var/message = text
	message += "TEMP=[mix.return_temperature()], MOL=[mix.total_moles()], VOL=[mix.return_volume()] "
	for(var/id in mix.get_gases())
		message += "[id]=[mix.get_moles(id)];"
	log_game(message)

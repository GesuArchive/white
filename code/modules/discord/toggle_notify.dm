/*
// Verb to toggle restart notifications
/client/verb/notify_restart()
	set category = "Особенное"
	set name = "Notify Restart"
	set desc = "Notifies you on Discord when the server restarts."
	set hidden = 1

	// Safety checks
	if(!CONFIG_GET(flag/sql_enabled))
		to_chat(src, span_warning("This feature requires the SQL backend to be running."))
		return

	if(!SSdiscord) // SS is still starting
		to_chat(src, span_notice("Сервер все еще запускается. Пожалуйста, подождите, прежде чем пытаться привязать свой аккаунт."))
		return

	if(!SSdiscord.enabled)
		to_chat(src, span_warning("This feature requires the server is running on the TGS toolkit"))
		return

	var/stored_id = SSdiscord.lookup_id(usr.ckey)
	if(!stored_id) // Account is not linked
		to_chat(src, span_warning("This requires you to link your Discord account with the \"Link Discord Account\" verb."))
		return

	else // Linked
		for(var/member in SSdiscord.notify_members) // If they are in the list, take them out
			if(member == "[stored_id]")
				SSdiscord.notify_members -= "[stored_id]" // The list uses strings because BYOND cannot handle a 17 digit integer
				to_chat(src, span_notice("Теперь вас не будут оповещать о перезапуске сервера."))
				return // This is necassary so it doesnt get added again, as it relies on the for loop being unsuccessful to tell us if they are in the list or not

		// If we got here, they arent in the list. Chuck 'em in!
		to_chat(src, span_notice("Теперь вас будут оповещать о перезапуске сервера."))
		SSdiscord.notify_members += "[stored_id]" // The list uses strings because BYOND cannot handle a 17 digit integer
*/

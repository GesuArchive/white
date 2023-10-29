/atom/proc/investigate_log(message, subject)
	if(!message || !subject)
		return
	var/F = file("[GLOB.log_directory]/[subject].html")
	WRITE_FILE(F, "[time_stamp()] [REF(src)] ([x],[y],[z]) || [src] [message]<br>")

/client/proc/investigate_show()
	set name = "Investigate"
	set category = "Адм.Игра"
	if(!holder)
		return

	var/list/investigates = list(INVESTIGATE_RESEARCH,
								INVESTIGATE_EXONET,
								INVESTIGATE_PORTAL,
								INVESTIGATE_SINGULO,
								INVESTIGATE_WIRES,
								INVESTIGATE_TELESCI,
								INVESTIGATE_GRAVITY,
								INVESTIGATE_RECORDS,
								INVESTIGATE_CARGO,
								INVESTIGATE_CRAFTING,
								INVESTIGATE_SUPERMATTER,
								INVESTIGATE_ATMOS,
								INVESTIGATE_EXPERIMENTOR,
								INVESTIGATE_BOTANY,
								INVESTIGATE_HALLUCINATIONS,
								INVESTIGATE_RADIATION,
								INVESTIGATE_NANITES,
								INVESTIGATE_PRESENTS,
								INVESTIGATE_HYPERTORUS,
								INVESTIGATE_ACCESSCHANGES,
								INVESTIGATE_DEATHS)

	var/list/logs_present = list("notes, memos, watchlist")
	var/list/logs_missing = list("---")

	for(var/subject in investigates)
		var/temp_file = file("[GLOB.log_directory]/[subject].html")
		if(fexists(temp_file))
			logs_present += subject
		else
			logs_missing += "[subject] (empty)"

	var/list/combined = sort_list(logs_present) + sort_list(logs_missing)

	var/selected = tgui_input_list(usr, "Investigate what?", "Investigate", combined)

	if(!(selected in combined) || selected == "---")
		return

	selected = replacetext(selected, " (empty)", "")

	if(selected == "notes, memos, watchlist" && check_rights(R_ADMIN))
		browse_messages()
		return

	var/F = file("[GLOB.log_directory]/[selected].html")
	if(!fexists(F))
		to_chat(src, span_danger("No [selected] logfile was found."))
		return
	src << browse(F,"window=investigate[selected];size=800x300")
	src << browse("<head><meta http-equiv='Content-Type' content='text/html; charset=utf-8'></head>","window=investigate[selected];size=800x300")

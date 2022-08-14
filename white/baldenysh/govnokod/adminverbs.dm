/client/proc/manage_lists()
	set category = "Дбг"
	set name = "Manage autoeban"

	if(!check_rights())
		return

	var/list/listoflists = list(
		"плохие слова" = list(GLOB.bad_words, "cfg/autoeban/bad_words.fackuobema"),
		"исключ. (начало)" =  list(GLOB.exc_start, "cfg/autoeban/exc_start.fackuobema"),
		"исключ. (конец)" =  list(GLOB.exc_end, "cfg/autoeban/exc_end.fackuobema"),
		"исключ. (целое)" = list(GLOB.exc_full, "cfg/autoeban/exc_full.fackuobema")
	)

	var/selected = tgui_input_list(usr, "Main Menu", "Manage autoeban", listoflists)
	if(!islist(listoflists[selected]))
		return

	var/list/L = listoflists[selected]
	var/list/LT = L[1]
	var/owtext = input(usr, "[selected]", "Manage list", LT.Join("\n")) as message|null

	if(!owtext) // retort
		return

	LT.Remove(LT)
	LT.Add(splittext(owtext,"\n"))

	if(fexists(L[2]))
		fdel(L[2])

	log_admin("[key_name(usr)] edits [selected].")
	message_admins("[key_name_admin(usr)] редактирует [selected].")

	text2file(LT.Join("\n"), L[2])

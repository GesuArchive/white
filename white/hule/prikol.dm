GLOBAL_VAR_INIT(prikol_mode, FALSE)

/client/proc/toggle_prikol()
	set category = "Адм.Веселье"
	set name = "Toggle P.R.I.K.O.L"

	if(!check_rights())
		return

	GLOB.prikol_mode = !GLOB.prikol_mode

	if(GLOB.prikol_mode)
		message_admins("[key] toggled P.R.I.K.O.L mode on.")
	else
		message_admins("[key] toggled P.R.I.K.O.L mode off.")

/client/proc/cinematic()
	set name = "Cinematic"
	set category = "Адм.Веселье"
	set desc = "Shows a cinematic."	// Intended for testing but I thought it might be nice for events on the rare occasion Feel free to comment it out if it's not wanted.
	set hidden = TRUE
	if(!SSticker)
		return

	var/datum/cinematic/choice = tgui_input_list(src, "Cinematic", "Choose", sort_list(subtypesof(/datum/cinematic), GLOBAL_PROC_REF(cmp_typepaths_asc)))
	if(choice)
		Cinematic(initial(choice.id),world,null)

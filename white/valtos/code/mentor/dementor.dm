/client/proc/cmd_mentor_dementor()
	set category = "Знаток"
	set name = "ДеЗнаток"
	if(!is_mentor())
		return
	remove_mentor_verbs()
	if (/client/proc/mentor_unfollow in verbs)
		mentor_unfollow()
	GLOB.mentors -= src
	add_verb(src,/client/proc/cmd_mentor_rementor)

/client/proc/cmd_mentor_rementor()
	set category = "Знаток"
	set name = "РеЗнаток"
	if(!is_mentor())
		return
	add_mentor_verbs()
	GLOB.mentors[src] = TRUE
	remove_verb(src,/client/proc/cmd_mentor_rementor)

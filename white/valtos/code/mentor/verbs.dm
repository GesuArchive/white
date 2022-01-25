/client/proc/add_mentor_verbs()
	if(mentor_datum)
		add_verb(src, GLOB.mentor_verbs)

/client/proc/remove_mentor_verbs()
	remove_verb(src, GLOB.mentor_verbs)

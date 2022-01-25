//all clients whom are mentors
GLOBAL_LIST_EMPTY(mentors)
GLOBAL_PROTECT(mentors)

GLOBAL_LIST_EMPTY(mentor_log)
GLOBAL_PROTECT(mentor_log)

GLOBAL_LIST_EMPTY(mentor_datums)
GLOBAL_PROTECT(mentor_datums)

GLOBAL_VAR_INIT(mentor_href_token, GenerateToken())
GLOBAL_PROTECT(mentor_href_token)

GLOBAL_LIST_INIT(mentor_verbs, list(
	/client/proc/cmd_mentor_say,
	/client/proc/cmd_mentor_dementor
	))
GLOBAL_PROTECT(mentor_verbs)

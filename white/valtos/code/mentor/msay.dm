/client/proc/cmd_mentor_say(msg as text)
	set category = "Знаток"
	set name = "ЗЧат"
	if(!is_mentor())
		return

	msg = copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
		return

	msg = emoji_parse(msg)
	log_mentor("MSAY: [key_name(src)] : [msg]")

	msg = keywords_lookup(msg)

	msg = "<span class='mentor'><span class='prefix'>ЗНАТОК:</span> <EM>[key_name(src, 0, 0)]</EM>: <span class='message linkify'>[msg]</span></span>"
	to_chat(GLOB.admins | GLOB.mentors, msg)

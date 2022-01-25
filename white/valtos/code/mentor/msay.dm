/client/proc/cmd_mentor_say(msg as text)
	set category = "Знаток"
	set name = "ЗЧат"
	if(!is_mentor())
		return

	msg = copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
		return

	msg = emoji_parse(msg)
	log_mentor("MSAY: [key_name(src)]: [msg]")

	msg = span_mentor("<span class='prefix'>ЗНАТОК:</span> <EM>[key_name(src, 0, 0)]</EM>: <span class='message'>[msg]</span>")

	to_chat(GLOB.mentors | GLOB.admins, msg)

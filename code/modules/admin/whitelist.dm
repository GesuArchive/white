#define WHITELISTFILE "[global.config.directory]/whitelist.txt"

GLOBAL_LIST(whitelist)
GLOBAL_PROTECT(whitelist)

/proc/load_whitelist()
	GLOB.whitelist = list()
	for(var/line in world.file2list(WHITELISTFILE))
		if(!line)
			continue
		if(findtextEx(line,"#",1,2))
			continue
		GLOB.whitelist += line

	if(!GLOB.whitelist.len)
		GLOB.whitelist = pick(list("CoomerAI"), list("DoomerAI"), list("ZoomerAI"))

/proc/check_whitelist(ckey)
	if(!GLOB.whitelist)
		return FALSE
	. = (ckey in GLOB.whitelist)

/proc/add_to_whitelist(ckey, who, date, reason)
	var/new_data = "\n# - [date] - \n# - [reason] - \n# - [ckey(who)] - \n[ckey(ckey)]"
	text2file(new_data, WHITELISTFILE)
	GLOB.whitelist += ckey(ckey)

/client/proc/invite_friend()
	set name = "Пригласить друга"
	set category = "Знаток"

	if(!is_mentor())
		return

	var/newkey = tgui_input_text(src, "Введи CKEY друга:", "Приглашение")
	if(!newkey || newkey == "")
		return

	var/newreason = tgui_input_text(src, "Почему его стоит пригласить? ВНИМАНИЕ! Всё записывается и в случае недоразумения к тебе будут вопросы.", "Приглашение")
	if(!newreason || newreason == "")
		return

	add_to_whitelist(newkey, ckey, time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss"), newreason)

	log_mentor("Приглашение [newkey] от [key_name(src)].")
	to_chat(GLOB.mentors | GLOB.admins, span_mentor("<EM>[key_name(src, 0, 0)]</EM>: <span class='message'>Приглашает [newkey] со словами \"[newreason]\".</span>"))

/client/proc/reload_whitelist()
	set category = "Адм"
	set name = "Whitelist Reload"

	load_whitelist()

	message_admins("[key_name_admin(usr)] перегружает вайтлист.")

#undef WHITELISTFILE

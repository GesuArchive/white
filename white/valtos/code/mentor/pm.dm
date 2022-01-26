//shows a list of clients we could send PMs to, then forwards our choice to cmd_Mentor_pm
/client/proc/cmd_mentor_pm_panel()
	set category = "Знаток"
	set name = "Сообщение знатока"
	if(!is_mentor())
		to_chat(src, span_danger("Ошибка: Только знатоки или администраторы могут использовать эту команду.</span>"))
		return
	var/list/client/targets[0]
	for(var/client/T)
		targets["[T]"] = T

	var/list/sorted = sort_list(targets)
	var/target = input(src, "Кому же мы напишем?", "Сообщение знатока", null) in sorted|null
	cmd_mentor_pm(targets[target],null)
	SSblackbox.record_feedback("tally", "Mentor_verb", 1, "APM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


//takes input from cmd_mentor_pm_context, cmd_Mentor_pm_panel or /client/Topic and sends them a PM.
//Fetching a message if needed. src is the sender and C is the target client
/client/proc/cmd_mentor_pm(whom, msg)
	var/client/target
	if(ismob(whom))
		var/mob/mob_target = whom
		target = mob_target.client
	else if(istext(whom))
		target = GLOB.directory[whom]
	else if(istype(whom,/client))
		target = whom
	if(!target)
		if(is_mentor())
			to_chat(src, span_danger("Ошибка: Клиент не найден."))
		else
			mentorhelp(msg)	//Mentor we are replying to left. Mentorhelp instead(check below)
		return

	if(is_mentor(whom))
		to_chat(GLOB.mentors, span_mentor("[src] начинает отвечать [whom].</span>"))

	//get message text, limit it's length.and clean/escape html
	if(!msg)
		msg = input(src,"Сообщение:", "Приватное сообщение") as text|null

		if(!msg)
			if (is_mentor(whom))
				to_chat(GLOB.mentors, span_mentor("[src] прекращает отвечать [whom].</span>"))
			return

		if(!target)
			if(is_mentor())
				to_chat(src, span_danger("Ошибка: Клиент не найден."))
			else
				mentorhelp(msg)	//Mentor we are replying to has vanished, Mentorhelp instead (how the fuck does this work?let's hope it works,shrug)
				return

		// Neither party is a mentor, they shouldn't be PMing!
		if (!target.is_mentor() && !is_mentor())
			return

	if(!msg)
		if (is_mentor(whom))
			to_chat(GLOB.mentors, span_mentor("[src] прекращает отвечать [whom]."))
		return
	log_mentor("Mentor PM: [key_name(src)]->[key_name(target)]: [msg]")

	msg = emoji_parse(msg)
	SEND_SOUND(target, 'sound/items/bikehorn.ogg')
	var/show_char = CONFIG_GET(flag/mentors_mobname_only)
	if(target.is_mentor())
		if(is_mentor())//both are mentors
			to_chat(target, span_mentor("Сообщение от <b>Знатока [key_name_mentor(src, target, 1, 0, 0)]</b>: [msg]"))
			to_chat(src, span_mentor("Обращение <b>Знатока</b> к <b>[key_name_mentor(target, target, 1, 0, 0)]</b>: [msg]"))

		else		//recipient is a mentor but sender is not
			to_chat(target, span_mentor("Ответ от <b>[key_name_mentor(src, target, 1, 0, show_char)]</b>: [msg]"))
			to_chat(src, span_mentor("Ответ от <b>[key_name_mentor(target, target, 1, 0, 0)]</b>: [msg]"))

	else
		if(is_mentor())	//sender is a mentor but recipient is not.
			to_chat(target, span_mentor("Сообщение от <b>Знатока [key_name_mentor(src, target, 1, 0, 0)]</b>: [msg]"))
			to_chat(src, span_mentor("Обращение <b>Знатока</b> к <b>[key_name_mentor(target, target, 1, 0, show_char)]</b>: [msg]"))

	//we don't use message_Mentors here because the sender/receiver might get it too
	var/show_char_sender = !is_mentor() && CONFIG_GET(flag/mentors_mobname_only)
	var/show_char_recip = !target.is_mentor() && CONFIG_GET(flag/mentors_mobname_only)
	for(var/it in GLOB.mentors)
		var/client/mentor = it
		if(mentor.key!=key && mentor.key!=target.key)	//check client/X is an Mentor and isn't the sender or recipient
			to_chat(mentor, span_mentor("ЗНАТОК: [key_name_mentor(src, mentor, 0, 0, show_char_sender)]-&gt;[key_name_mentor(target, mentor, 0, 0, show_char_recip)]: [msg]"))

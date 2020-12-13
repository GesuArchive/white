/datum/major_mode
	var/name = "основной режим"
	var/required_players = 0
	var/announce_after 	 = 5 MINUTES
	var/fail_after 		 = 1 HOURS
	var/announce_type 	 = "announce"
	var/announce_text 	 = "Работать."

/datum/major_mode/proc/announce_mode()
	switch(announce_type)
		if("announce")
			print_command_report(announce_text, "Срочное задание", announce=FALSE)
			priority_announce("Станция, вам поручено задание особой важности. Постарайтесь выполнить его точно в срок. Требования распечатаны на всех коммуникационных консолях.", "Срочное задание", 'sound/ai/announcer/alert.ogg')
		if("message")
			print_command_report(announce_text, "Срочное задание", announce=FALSE)

/datum/major_mode/proc/generate_quest()
	announce_text = "Работать."
	return

/datum/major_mode/proc/check_completion()
	return TRUE

/datum/major_mode/proc/fail_completion()
	return

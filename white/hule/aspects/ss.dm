SUBSYSTEM_DEF(aspects)
	name = "Aspects"

	flags = SS_NO_FIRE //я блять это только сейчас заметил. Ну да ладно.
	init_order = -70

	runlevels = RUNLEVEL_GAME

	var/ca_name = "LOBBY"
	var/ca_desc = "Секрет."
	var/shown_desc = "Кря!" //Показываемое игрокам описание. Нужно только для того, чтобы в конце раунда показывалось нормальное описание

	var/list/aspects = list()
	var/list/forced_aspects = list()

	var/datum/round_aspect/current_aspect

/datum/controller/subsystem/aspects/Initialize(mapload)
	for(var/item in typesof(/datum/round_aspect))
		var/datum/round_aspect/A = new item()
		aspects[A] = A.weight

	return SS_INIT_SUCCESS

/datum/controller/subsystem/aspects/stat_entry(msg)
	msg = "CA:[ca_name]"
	return ..()

/datum/controller/subsystem/aspects/proc/run_aspect()
	if(forced_aspects.len)
		ca_name = ""
		ca_desc = ""
		for(var/datum/round_aspect/A in forced_aspects)
			A.run_aspect()
			ca_name += "[A.name] / "
			ca_desc += "[A.desc] / "
		ca_name = copytext_char(ca_name, 1, -2)
		ca_desc = copytext_char(ca_desc, 1, -2)
	else
		current_aspect = pick_weight(aspects)
		current_aspect.run_aspect()
		ca_name = current_aspect.name
		ca_desc = current_aspect.desc
		shown_desc = ca_desc
		if(current_aspect.hidden && prob(20))
			shown_desc = "Меня ждет сюрприз!"

	for(var/P in GLOB.mob_living_list)
		spawn(5 SECONDS)
			to_chat(P, "\n<span class='notice'><B>[gvorno(TRUE)]:</B> [shown_desc]</span>\n")

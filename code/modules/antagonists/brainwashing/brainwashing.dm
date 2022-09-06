/proc/brainwash(mob/living/L, directives)
	if(!L.mind)
		return
	if(!islist(directives))
		directives = list(directives)
	var/datum/mind/M = L.mind
	var/datum/antagonist/brainwashed/B = M.has_antag_datum(/datum/antagonist/brainwashed)
	if(B)
		for(var/O in directives)
			var/datum/objective/brainwashing/objective = new(O)
			B.objectives += objective
		B.greet()
	else
		B = new()
		for(var/O in directives)
			var/datum/objective/brainwashing/objective = new(O)
			B.objectives += objective
		M.add_antag_datum(B)

	var/begin_message = " has been brainwashed with the following objectives: "
	var/obj_message = english_list(directives)
	var/end_message = "."
	var/rendered = begin_message + obj_message + end_message
	deadchat_broadcast(rendered, "<b>[L]</b>", follow_target = L, turf_target = get_turf(L), message_type=DEADCHAT_ANNOUNCEMENT)
	if(prob(1) || SSevents.holidays && SSevents.holidays[APRIL_FOOLS])
		L.say("Ах ты сукин сын, я в деле!", forced = "Ах он сукин сын, он в деле!")

/datum/antagonist/brainwashed
	name = "Brainwashed Victim"
	job_rank = ROLE_BRAINWASHED
	roundend_category = "brainwashed victims"
	show_in_antagpanel = TRUE
	antag_hud_name = "brainwashed"
	antagpanel_category = "Other"
	show_name_in_check_antagonists = TRUE
	greentext_reward = 5

/datum/antagonist/brainwashed/greet()
	to_chat(owner, span_warning("Разум начинает фокусироваться на одной цели..."))
	to_chat(owner, "<big><span class='warning'><b>Выполнять Директивы любой ценой!</b></span></big>")
	var/i = 1
	for(var/X in objectives)
		var/datum/objective/O = X
		to_chat(owner, "<b>[i].</b> [O.explanation_text]")
		i++

/datum/antagonist/brainwashed/farewell()
	to_chat(owner, span_warning("Разум внезапно проясняется..."))
	to_chat(owner, "<big><span class='warning'><b>Тяжесть Директив исчезает! Больше не обязан им подчиняться.</b></span></big>")
	owner.announce_objectives()

/datum/antagonist/brainwashed/admin_add(datum/mind/new_owner,mob/admin)
	var/mob/living/carbon/C = new_owner.current
	if(!istype(C))
		return
	var/list/objectives = list()
	do
		var/objective = stripped_input(admin, "Добавьте цель или оставьте пустой для завершения.", "Промывка мозгов", null, MAX_MESSAGE_LEN)
		if(objective)
			objectives += objective
	while(tgui_alert(admin,"Ещё одно задание?","Больше промывки мозгов",list("Да","Нет")) == "Да")

	if(tgui_alert(admin,"Действительно ли вы хотите промыть мозги?","Вы уверены?",list("Да","Нет")) == "Нет")
		return

	if(!LAZYLEN(objectives))
		return

	if(QDELETED(C))
		to_chat(admin, "Mob doesn't exist anymore")
		return

	brainwash(C, objectives)
	var/obj_list = english_list(objectives)
	message_admins("[key_name_admin(admin)] has brainwashed [key_name_admin(C)] with the following objectives: [obj_list].")
	C.log_message("has been force-brainwashed with the objective '[obj_list]' by admin [key_name(admin)]", LOG_VICTIM, log_globally = FALSE)
	log_admin("[key_name(admin)] has brainwashed [key_name(C)] with the following objectives: [obj_list].")

/datum/antagonist/brainwashed/set_antag_skills()
	return

/datum/objective/brainwashing
	completed = TRUE

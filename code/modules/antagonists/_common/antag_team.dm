GLOBAL_LIST_EMPTY(antagonist_teams)

//A barebones antagonist team.
/datum/team
	var/list/datum/mind/members = list()
	var/name = "team"
	var/member_name = "Члены команды"
	var/list/objectives = list() //common objectives, these won't be added or removed automatically, subtypes handle this, this is here for bookkeeping purposes.
	var/show_roundend_report = TRUE

/datum/team/New(starting_members)
	. = ..()
	GLOB.antagonist_teams += src
	if(starting_members)
		if(islist(starting_members))
			for(var/datum/mind/M in starting_members)
				add_member(M)
		else
			add_member(starting_members)

/datum/team/Destroy(force, ...)
	GLOB.antagonist_teams -= src
	. = ..()

/datum/team/proc/is_solo()
	return members.len == 1

/datum/team/proc/add_member(datum/mind/new_member)
	members |= new_member

/datum/team/proc/remove_member(datum/mind/member)
	members -= member

//Display members/victory/failure/objectives for the team
/datum/team/proc/roundend_report()
	if(!show_roundend_report)
		return

	var/list/report = list()

	report += span_header("[name]:")
	report += "[member_name]:"
	report += printplayerlist(members)

	if(objectives.len)
		report += span_header("Команда имела следующие цели:")
		var/win = TRUE
		var/objective_count = 1
		for(var/datum/objective/objective in objectives)
			if(objective.check_completion())
				report += "<B>Цель #[objective_count]</B>: [objective.explanation_text] <span class='greentext'>Успех!</span>"
			else
				report += "<B>Цель #[objective_count]</B>: [objective.explanation_text] <span class='redtext'>Провал.</span>"
				win = FALSE
			objective_count++
		if(win)
			report += span_greentext("[name] успешны!")
		else
			report += span_redtext("[name] провалились!")


	return "<div class='panel redborder'>[report.Join("<br>")]</div>"

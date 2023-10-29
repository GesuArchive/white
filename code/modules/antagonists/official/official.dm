/datum/antagonist/official
	name = JOB_CENTCOM_OFFICIAL
	show_name_in_check_antagonists = TRUE
	show_in_antagpanel = FALSE
	can_elimination_hijack = ELIMINATION_PREVENT
	var/datum/objective/mission
	var/datum/team/ert/ert_team
	show_to_ghosts = TRUE
	greentext_reward = 20

/datum/antagonist/official/greet()
	to_chat(owner, "<B><font size=3 color=red>Вы представитель ЦК!</font></B>")
	if (ert_team)
		to_chat(owner, "Центральное Командование отправляет вас на станцию [station_name()] с заданием: [ert_team.mission.explanation_text]")
	else
		to_chat(owner, "Центральное Командование отправляет вас на станцию [station_name()] с заданием: [mission.explanation_text]")

/datum/antagonist/official/proc/equip_official()
	var/mob/living/carbon/human/H = owner.current
	if(!istype(H))
		return
	H.equipOutfit(/datum/outfit/centcom/centcom_official)

	if(CONFIG_GET(flag/enforce_human_authority))
		H.set_species(/datum/species/human)

/datum/antagonist/official/create_team(datum/team/new_team)
	if(istype(new_team))
		ert_team = new_team

/datum/antagonist/official/proc/forge_objectives()
	if (ert_team)
		objectives |= ert_team.objectives
	else if (!mission)
		var/datum/objective/missionobj = new
		missionobj.owner = owner
		missionobj.explanation_text = "Проведите плановый анализ эффективности работы станции [station_name()] и капитана."
		missionobj.completed = 1
		mission = missionobj
		objectives |= mission


/datum/antagonist/official/on_gain()
	forge_objectives()
	. = ..()
	equip_official()

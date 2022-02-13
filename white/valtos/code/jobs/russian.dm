/*
/datum/job/security_officer/omon
	title = "Russian Officer"
	ru_title = "Русский Офицер"
	total_positions = 1
	spawn_positions = 1
	outfit = /datum/outfit/job/security/omon
	assign_dep = FALSE

	exp_type = EXP_TYPE_CREW
	exp_requirements = 12000

	skills = list(/datum/skill/ranged = SKILL_EXP_EXPERT)
	minimal_skills = list(/datum/skill/ranged = SKILL_EXP_EXPERT)

/datum/job/security_officer/veteran
	title = "Veteran"
	ru_title = "Ветеран"
	total_positions = 1
	spawn_positions = 1
	minimal_player_age = 365
	exp_requirements = 24000
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY
	outfit = /datum/outfit/job/security/veteran
	assign_dep = FALSE

	skills = list(/datum/skill/ranged = SKILL_EXP_MASTER)
	minimal_skills = list(/datum/skill/ranged = SKILL_EXP_EXPERT)

*/
/datum/id_trim/job/omon
	assignment = "Russian Officer"
	trim_state = "trim_russianofficer"
	full_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_MAINT_TUNNELS, ACCESS_MECH_SECURITY, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_FORENSICS_LOCKERS, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_WEAPONS, ACCESS_MECH_SECURITY, ACCESS_MINERAL_STOREROOM)
	config_job = "russian_officer"
	template_access = list(ACCESS_CAPTAIN, ACCESS_HOS, ACCESS_CHANGE_IDS)
	trim_icon = 'white/valtos/icons/card.dmi'

/datum/id_trim/job/veteran
	assignment = "Veteran"
	trim_state = "trim_veteran"
	full_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_ARMORY, ACCESS_COURT, ACCESS_WEAPONS, ACCESS_MECH_SECURITY,
			            ACCESS_FORENSICS_LOCKERS, ACCESS_MORGUE, ACCESS_MAINT_TUNNELS, ACCESS_ALL_PERSONAL_LOCKERS,
			            ACCESS_RESEARCH, ACCESS_ENGINE, ACCESS_MINING, ACCESS_MEDICAL, ACCESS_CONSTRUCTION, ACCESS_MAILSORTING,
			            ACCESS_HEADS, ACCESS_HOS, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_GATEWAY, ACCESS_MAINT_TUNNELS, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_ARMORY, ACCESS_COURT, ACCESS_WEAPONS, ACCESS_MECH_SECURITY,
			            ACCESS_FORENSICS_LOCKERS, ACCESS_MORGUE, ACCESS_MAINT_TUNNELS, ACCESS_ALL_PERSONAL_LOCKERS,
			            ACCESS_RESEARCH, ACCESS_ENGINE, ACCESS_MINING, ACCESS_MEDICAL, ACCESS_CONSTRUCTION, ACCESS_MAILSORTING,
			            ACCESS_HEADS, ACCESS_HOS, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_GATEWAY, ACCESS_MAINT_TUNNELS, ACCESS_MINERAL_STOREROOM)
	config_job = "veteran"
	template_access = list(ACCESS_CAPTAIN, ACCESS_HOS, ACCESS_CHANGE_IDS)
	trim_icon = 'white/valtos/icons/card.dmi'

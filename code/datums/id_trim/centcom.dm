/// Trim for basic Centcom cards.
/datum/id_trim/centcom
	access = list(ACCESS_CENT_GENERAL)
	assignment = JOB_CENTCOM
	trim_state = "trim_centcom"

/// Trim for Centcom VIPs
/datum/id_trim/centcom/vip
	access = list(ACCESS_CENT_GENERAL)
	assignment = JOB_CENTCOM_VIP

/// Trim for Centcom Custodians.
/datum/id_trim/centcom/custodian
	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING, ACCESS_CENT_STORAGE)
	assignment = JOB_CENTCOM_CUSTODIAN

/// Trim for Centcom Thunderdome Overseers.
/datum/id_trim/centcom/thunderdome_overseer
	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_THUNDER)
	assignment = JOB_CENTCOM_THUNDERDOME_OVERSEER

/// Trim for Centcom Officials.
/datum/id_trim/centcom/official
	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING, ACCESS_WEAPONS)
	assignment = JOB_CENTCOM_OFFICIAL

/// Trim for Centcom Interns.
/datum/id_trim/centcom/intern
	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING, ACCESS_WEAPONS)
	assignment = "CentCom Intern"

/// Trim for Centcom Head Interns. Different assignment, common station access added on.
/datum/id_trim/centcom/intern/head
	assignment = "CentCom Head Intern"

/datum/id_trim/centcom/intern/head/New()
	. = ..()

	access |= SSid_access.get_flag_access_list(ACCESS_FLAG_COMMON)

/// Trim for Centcom Bartenders.
/datum/id_trim/centcom/bartender
	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING, ACCESS_CENT_BAR)
	assignment = JOB_CENTCOM_BARTENDER

/// Trim for Centcom Medical Officers.
/datum/id_trim/centcom/medical_officer
	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING, ACCESS_CENT_MEDICAL)
	assignment = JOB_CENTCOM_MEDICAL_DOCTOR

/// Trim for Centcom Research Officers.
/datum/id_trim/centcom/research_officer
	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_SPECOPS, ACCESS_CENT_MEDICAL, ACCESS_CENT_TELEPORTER, ACCESS_CENT_STORAGE)
	assignment = JOB_CENTCOM_RESEARCH_OFFICER

/// Trim for Centcom Specops Officers. All Centcom and Station Access.
/datum/id_trim/centcom/specops_officer
	assignment = JOB_CENTCOM_SPECIAL_OFFICER

/datum/id_trim/centcom/specops_officer/New()
	. = ..()

	access = SSid_access.get_region_access_list(list(REGION_CENTCOM, REGION_ALL_STATION))

/// Trim for Centcom (Soviet) Admirals. All Centcom and Station Access.
/datum/id_trim/centcom/admiral
	assignment = JOB_CENTCOM_ADMIRAL

/datum/id_trim/centcom/admiral/New()
	. = ..()

	access = SSid_access.get_region_access_list(list(REGION_CENTCOM, REGION_ALL_STATION))

/// Trim for Centcom Commanders. All Centcom and Station Access.
/datum/id_trim/centcom/commander
	assignment = JOB_CENTCOM_COMMANDER

/datum/id_trim/centcom/commander/New()
	. = ..()

	access = SSid_access.get_region_access_list(list(REGION_CENTCOM, REGION_ALL_STATION))

/// Trim for Deathsquad officers. All Centcom and Station Access.
/datum/id_trim/centcom/deathsquad
	assignment = JOB_ERT_DEATHSQUAD
	trim_state = "trim_ert_commander"

/datum/id_trim/centcom/deathsquad/New()
	. = ..()

	access = SSid_access.get_region_access_list(list(REGION_CENTCOM, REGION_ALL_STATION))

/// Trim for generic ERT interns. No universal ID card changing access.
/datum/id_trim/centcom/ert
	assignment = "Emergency Response Team Intern"

/datum/id_trim/centcom/ert/New()
	. = ..()

	access = list(ACCESS_CENT_GENERAL) | (SSid_access.get_region_access_list(list(REGION_ALL_STATION)) - ACCESS_CHANGE_IDS)

/// Trim for ERT Commanders. All station and centcom access.
/datum/id_trim/centcom/ert/commander
	assignment = JOB_ERT_COMMANDER
	trim_state = "trim_ert_commander"

/datum/id_trim/centcom/ert/commander/New()
	. = ..()

	access = SSid_access.get_region_access_list(list(REGION_CENTCOM, REGION_ALL_STATION))

/// Trim for generic ERT seccies. No universal ID card changing access.
/datum/id_trim/centcom/ert/security
	assignment = JOB_ERT_OFFICER
	trim_state = "trim_ert_security"

/datum/id_trim/centcom/ert/security/New()
	. = ..()

	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_SPECOPS, ACCESS_CENT_LIVING) | (SSid_access.get_region_access_list(list(REGION_ALL_STATION)) - ACCESS_CHANGE_IDS)

/// Trim for generic ERT engineers. No universal ID card changing access.
/datum/id_trim/centcom/ert/engineer
	assignment = JOB_ERT_ENGINEER
	trim_state = "trim_ert_engineering"

/datum/id_trim/centcom/ert/engineer/New()
	. = ..()

	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_SPECOPS, ACCESS_CENT_LIVING, ACCESS_CENT_STORAGE) | (SSid_access.get_region_access_list(list(REGION_ALL_STATION)) - ACCESS_CHANGE_IDS)

/// Trim for generic ERT medics. No universal ID card changing access.
/datum/id_trim/centcom/ert/medical
	assignment = JOB_ERT_MEDICAL_DOCTOR
	trim_state = "trim_ert_medical"

/datum/id_trim/centcom/ert/medical/New()
	. = ..()

	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_SPECOPS, ACCESS_CENT_MEDICAL, ACCESS_CENT_LIVING) | (SSid_access.get_region_access_list(list(REGION_ALL_STATION)) - ACCESS_CHANGE_IDS)

/// Trim for generic ERT chaplains. No universal ID card changing access.
/datum/id_trim/centcom/ert/chaplain
	assignment = JOB_ERT_CHAPLAIN
	trim_state = "trim_ert_religious"

/datum/id_trim/centcom/ert/chaplain/New()
	. = ..()

	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_SPECOPS, ACCESS_CENT_LIVING) | (SSid_access.get_region_access_list(list(REGION_ALL_STATION)) - ACCESS_CHANGE_IDS)

/// Trim for generic ERT janitors. No universal ID card changing access.
/datum/id_trim/centcom/ert/janitor
	assignment = JOB_ERT_JANITOR
	trim_state = "trim_ert_janitor"

/datum/id_trim/centcom/ert/janitor/New()
	. = ..()

	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING) | (SSid_access.get_region_access_list(list(REGION_ALL_STATION)) - ACCESS_CHANGE_IDS)

/// Trim for generic ERT clowns. No universal ID card changing access.
/datum/id_trim/centcom/ert/clown
	assignment = JOB_ERT_CLOWN
	trim_state = "trim_ert_entertainment"

/datum/id_trim/centcom/ert/clown/New()
	. = ..()

	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING) | (SSid_access.get_region_access_list(list(REGION_ALL_STATION)) - ACCESS_CHANGE_IDS)

/// СОБР
/datum/id_trim/centcom/omon/lieutenant
	assignment = "СОБР Лейтенант"

/datum/id_trim/centcom/omon/lieutenant/New()
	. = ..()

	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING, ACCESS_MAINT_TUNNELS, ACCESS_MECH_SECURITY, ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM)

/datum/id_trim/centcom/omon
	assignment = "СОБР"

/datum/id_trim/centcom/omon/New()
	. = ..()

	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING, ACCESS_MAINT_TUNNELS, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM)

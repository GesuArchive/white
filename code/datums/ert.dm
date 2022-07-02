/datum/ert
	var/mobtype = /mob/living/carbon/human
	var/team = /datum/team/ert
	var/opendoors = TRUE
	var/leader_role = /datum/antagonist/ert/commander
	var/enforce_human = TRUE
	var/roles = list(/datum/antagonist/ert/security, /datum/antagonist/ert/medic, /datum/antagonist/ert/engineer) //List of possible roles to be assigned to ERT members.
	var/rename_team
	var/code
	var/mission = "Помочь станции."
	var/teamsize = 5
	var/polldesc

/datum/ert/New()
	if (!polldesc)
		polldesc = "Специальном Отряде Быстрого Реагирования. Код: [code]"

/datum/ert/blue
	opendoors = FALSE
	code = "Синий"

/datum/ert/amber
	code = "Янтарный"

/datum/ert/red
	leader_role = /datum/antagonist/ert/commander/red
	roles = list(/datum/antagonist/ert/security/red, /datum/antagonist/ert/medic/red, /datum/antagonist/ert/engineer/red)
	code = "Красный"

/datum/ert/deathsquad
	roles = list(/datum/antagonist/ert/deathsquad)
	leader_role = /datum/antagonist/ert/deathsquad/leader
	rename_team = "Deathsquad"
	code = "Дельта"
	mission = "Не оставляйте свидетелей."
	polldesc = "элитной ударной команде NanoTrasen"

/datum/ert/marine
	leader_role = /datum/antagonist/ert/marine
	roles = list(/datum/antagonist/ert/marine/security, /datum/antagonist/ert/marine/engineer, /datum/antagonist/ert/marine/medic)
	rename_team = "Marine Squad"
	polldesc = "'элитной' ударной команде NanoTrasen"
	opendoors = FALSE

/datum/ert/centcom_official
	code = "Зелёный"
	teamsize = 1
	opendoors = FALSE
	leader_role = /datum/antagonist/official
	roles = list(/datum/antagonist/official)
	rename_team = "Инспектор ЦК"
	polldesc = "инспектором Центрального Командования"

/datum/ert/centcom_official/New()
	mission = "Проведите плановую проверку эффективности станции \"[station_name()]\" и её Капитана."

/datum/ert/inquisition
	roles = list(/datum/antagonist/ert/chaplain/inquisitor, /datum/antagonist/ert/security/inquisitor, /datum/antagonist/ert/medic/inquisitor)
	leader_role = /datum/antagonist/ert/commander/inquisitor
	rename_team = "Инквизиция"
	mission = "Уничтожьте все следы паранормальной активности на борту станции."
	polldesc = "группе реагирования на паранормальные явления NanoTrasen"

/datum/ert/janitor
	roles = list(/datum/antagonist/ert/janitor, /datum/antagonist/ert/janitor/heavy)
	leader_role = /datum/antagonist/ert/janitor/heavy
	teamsize = 4
	opendoors = FALSE
	rename_team = "Уборщик"
	mission = "Убери ВСЁ."
	polldesc = "группе специальных уборщиков NanoTrasen"

/datum/ert/intern
	roles = list(/datum/antagonist/ert/intern)
	leader_role = /datum/antagonist/ert/intern/leader
	teamsize = 7
	opendoors = FALSE
	rename_team = "Орда Интернов"
	mission = "Помочь в разрешении конфликтов."
	polldesc = "возможности неоплачиваемой стажировки в NanoTrasen"

/datum/ert/erp
	roles = list(/datum/antagonist/ert/security/party, /datum/antagonist/ert/clown/party, /datum/antagonist/ert/engineer/party, /datum/antagonist/ert/janitor/party)
	leader_role = /datum/antagonist/ert/commander/party
	opendoors = FALSE
	rename_team = "ЕРП"
	mission = "Создайте развлечение для экипажа."
	polldesc = "группе партийного реагирования NanoTrasen. Код: Радужный"
	code = "Радужный"


/datum/ert/guarded_official
	roles = list(/datum/antagonist/ert/sobr)
	leader_role = /datum/antagonist/official
	opendoors = FALSE
	rename_team = "Представитель ЦК и охрана"
	teamsize = 3
	polldesc = "инспектором центкома и его охраной"
	mission = "Решить проблемы станции."

/datum/ert/chrono_legion
	roles = list(/datum/antagonist/ert/chrono_legioner)
	opendoors = FALSE
	rename_team = "Хронолегионер"
	teamsize = 1
	polldesc = "хронолегионером"
	mission = "Устранить простраственно-временные аномалии из вселенной С-137."

/*
/datum/ert/pmc
	roles = list(/datum/outfit/pmc/armed)
	leader_role = /datum/antagonist/ert/pmc/gunner
	rename_team = "Штурмовая бригада"
	teamsize = 4
	polldesc = "в составе штурмовой группы"
	mission = "Разобраться с угрозой любым доступным способом"

/datum/ert/pmc_special
	roles = list(/datum/antagonist/ert/pmc/medic, /datum/antagonist/ert/pmc/gunner, /datum/antagonist/ert/pmc/techie, /datum/antagonist/ert/pmc/enforcer, /datum/antagonist/ert/pmc/solo)
	leader_role = /datum/antagonist/ert/pmc/leader
	rename_team = "Спецотряд"
	teamsize = 4
	polldesc = "бойцом группы особого назначения"
	mission = "Унитожить угрозы, избегать потери среди агентов"
	code = "Феникс"
*/

/datum/ert
	var/mobtype = /mob/living/carbon/human
	var/team = /datum/team/ert
	var/opendoors = TRUE
	var/leader_role = /datum/antagonist/ert/commander
	var/enforce_human = FALSE
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
	code = "Зеленый"

/datum/ert/amber
	code = "Синий"

/datum/ert/red
	leader_role = /datum/antagonist/ert/commander/red
	roles = list(/datum/antagonist/ert/security/red, /datum/antagonist/ert/medic/red, /datum/antagonist/ert/engineer/red)
	code = "Красный"

/datum/ert/deathsquad
	roles = list(/datum/antagonist/ert/deathsquad)
	leader_role = /datum/antagonist/ert/deathsquad/leader
	rename_team = "Эскадрон Смерти"
	code = "Дельта"
	mission = "Не оставляйте свидетелей."
	polldesc = "эскадроне смерти НаноТрейзен"

/datum/ert/marine
	leader_role = /datum/antagonist/ert/marine
	roles = list(/datum/antagonist/ert/marine/security, /datum/antagonist/ert/marine/engineer, /datum/antagonist/ert/marine/medic)
	rename_team = "Marine Squad"
	polldesc = "спецназе НаноТрейзен"
	opendoors = FALSE

/datum/ert/inquisition
	roles = list(/datum/antagonist/ert/chaplain/inquisitor, /datum/antagonist/ert/security/inquisitor, /datum/antagonist/ert/medic/inquisitor)
	leader_role = /datum/antagonist/ert/commander/inquisitor
	rename_team = "Инквизиция"
	mission = "Уничтожьте все следы паранормальной активности на борту станции."
	polldesc = "группе реагирования на паранормальные явления НаноТрейзен"

/datum/ert/centcom_official
	code = "Инспекция"
	teamsize = 1
	opendoors = FALSE
	leader_role = /datum/antagonist/official
	roles = list(/datum/antagonist/official)
	rename_team = "Инспектор ЦК"
	polldesc = "инспектором Центрального Командования"

/datum/ert/centcom_official/New()
	mission = "Проведите плановую проверку состояния станции \"[station_name()]\" и её экипажа."

/datum/ert/guarded_official
	leader_role = /datum/antagonist/official
	roles = list(/datum/antagonist/ert/sobr)
	opendoors = FALSE
	rename_team = "Представитель ЦК и охрана"
	teamsize = 3
	polldesc = "инспектором центкома и его охраной"
	mission = "Решить проблемы станции."

/datum/ert/intern
	leader_role = /datum/antagonist/ert/intern/leader
	roles = list(/datum/antagonist/ert/intern)
	teamsize = 5
	opendoors = FALSE
	rename_team = "Орда Интернов"
	mission = "Помочь в разрешении конфликтов."
	polldesc = "возможности неоплачиваемой стажировки в НаноТрейзен"

/datum/ert/engi
	leader_role = /datum/antagonist/ert/engineer
	roles = list(/datum/antagonist/ert/engineer)
	opendoors = FALSE
	rename_team = "Ремонтная бригада"
	teamsize = 3
	polldesc = "ремонтной бригаде"
	mission = "Восстановить станцию."

/datum/ert/janitor
	roles = list(/datum/antagonist/ert/janitor, /datum/antagonist/ert/janitor/heavy)
	leader_role = /datum/antagonist/ert/janitor/heavy
	teamsize = 4
	opendoors = FALSE
	rename_team = "Уборщик"
	mission = "Убери ВСЁ."
	polldesc = "группе специальных уборщиков НаноТрейзен"

/datum/ert/erp
	roles = list(/datum/antagonist/ert/security/party, /datum/antagonist/ert/clown/party, /datum/antagonist/ert/engineer/party, /datum/antagonist/ert/janitor/party)
	leader_role = /datum/antagonist/ert/commander/party
	opendoors = FALSE
	rename_team = "ЕРП"
	mission = "Создайте развлечение для экипажа."
	polldesc = "группе партийного реагирования НаноТрейзен. Код: Радужный"
	code = "Радужный"

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

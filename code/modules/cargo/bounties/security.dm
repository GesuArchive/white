/datum/bounty/item/security/riotshotgun
	name = "Штурмовой дробовик"
	description = "Хулиганы взошли на борт ЦК! Быстрее отправьте дробовики, иначе всё станет еще хуже."
	reward = CARGO_CRATE_VALUE * 10
	required_count = 2
	wanted_types = list(/obj/item/gun/ballistic/shotgun/riot)

/datum/bounty/item/security/recharger
	name = "Зарядные устройства"
	description = "Военная академия НТ проводит стрелковые учения. Они требуют, чтобы зарядные устройства были отправлены."
	reward = CARGO_CRATE_VALUE * 4
	required_count = 3
	wanted_types = list(/obj/machinery/recharger)

/datum/bounty/item/security/pepperspray
	name = "Перцовый балончик"
	description = "У нас было много беспорядков на космической станции 76. Нам бы не помешали новые перцовые баллончики."
	reward = CARGO_CRATE_VALUE * 6
	required_count = 4
	wanted_types = list(/obj/item/reagent_containers/spray/pepper)

/datum/bounty/item/security/prison_clothes
	name = "Тюремная форма"
	description = "ТерраГов не смогли получить новую форму для заключенных, поэтому, если у вас есть запасная форма, мы её заберем."
	reward = CARGO_CRATE_VALUE * 4
	required_count = 4
	wanted_types = list(/obj/item/clothing/under/rank/prisoner)

/datum/bounty/item/security/plates
	name = "Номерные знаки"
	description = "В результате автокатастрофы с участием клоуна мы могли бы использовать аванс на некоторые из номерных знаков вашего заключенного."
	reward = CARGO_CRATE_VALUE * 2
	required_count = 10
	wanted_types = list(/obj/item/stack/license_plates/filled)

/datum/bounty/item/security/earmuffs
	name = "Наушники"
	description = "Центральное Командование устало от сообщений вашей станции. Они приказали вам отправить наушники, чтобы уменьшить раздражение."
	reward = CARGO_CRATE_VALUE * 2
	wanted_types = list(/obj/item/clothing/ears/earmuffs)

/datum/bounty/item/security/handcuffs
	name = "Наручники"
	description = "В Центральное Командование прибыл большой поток беглых заключенных. Сейчас идеальное время для отправки запасных наручников (или удерживающих устройств)."
	reward = CARGO_CRATE_VALUE * 2
	required_count = 5
	wanted_types = list(/obj/item/restraints/handcuffs)


///Bounties that require you to perform documentation and inspection of your department to send to centcom.
/datum/bounty/item/security/paperwork
	name = "Routine Security Inspection"
	description = "Perform a routine security inspection using an in-spect scanner on the following general area on station:"
	required_count = 1
	wanted_types = list(/obj/item/report)
	reward = CARGO_CRATE_VALUE * 5
	var/area/demanded_area

/datum/bounty/item/security/paperwork/New()
	///list of areas for security to choose from to perform an inspection.
	var/static/list/possible_areas = list(\
		/area/maintenance,\
		/area/library,\
		/area/crew_quarters,\
		/area/hallway/primary,\
		/area/lawoffice,\
		/area/security/main,\
		/area/security/prison,\
		/area/security/range,\
		/area/security/checkpoint)
	demanded_area = pick(possible_areas)
	name = name + ": [initial(demanded_area.name)]"
	description = initial(description) + " [initial(demanded_area.name)]"

/datum/bounty/item/security/paperwork/applies_to(obj/O)
	. = ..()
	if(!istype(O, /obj/item/report))
		return FALSE
	var/obj/item/report/slip = O
	if(istype(slip.scanned_area, demanded_area))
		return TRUE
	return FALSE

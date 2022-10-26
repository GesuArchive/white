/datum/gear/dice
	display_name = "d20"
	path = /obj/item/dice/d20
	cost = 20

//LIGHTERS & CIGARETTES

/datum/gear/lighter
	display_name = "зажигалка Zippo"
	path = /obj/item/lighter
	cost = 90

/datum/gear/lighter/random
	display_name = "дешёвая зажигалка"
	path = /obj/item/lighter/greyscale
	cost = 20

/datum/gear/cigarettes
	display_name = "сигареты \"Space Cigarettes"
	path = /obj/item/storage/fancy/cigarettes
	cost = 40

/datum/gear/cigarettes/dromedaryco
	display_name = "сигареты \"DromedaryCo\""
	path = /obj/item/storage/fancy/cigarettes/dromedaryco

/datum/gear/cigarettes/cigpack_uplift
	display_name = "сигареты \"Uplift Smooth\""
	path = /obj/item/storage/fancy/cigarettes/cigpack_uplift

/datum/gear/cigarettes/cigpack_robust
	display_name = "сигареты \"Robust\""
	path = /obj/item/storage/fancy/cigarettes/cigpack_robust

/datum/gear/cigarettes/cigpack_carp
	display_name = "сигареты \"Carp Classic\""
	path = /obj/item/storage/fancy/cigarettes/cigpack_carp

/datum/gear/cigarettes/cigpack_cannabis
	display_name = "сигареты \"Freak Brothers' Special\""
	path = /obj/item/storage/fancy/cigarettes/cigpack_cannabis

/datum/gear/cigarettes/cohiba
	display_name = "сигара \"Cohiba Robusto\""
	path = /obj/item/clothing/mask/cigarette/cigar/cohiba
	cost = 195

/datum/gear/cigarettes/havana
	display_name = "сигара \"premium Havanian\""
	path = /obj/item/clothing/mask/cigarette/cigar/havana
	cost = 195

/datum/gear/auvtomat
	display_name = "Нанопистолет"
	path = /obj/item/storage/belt/holster/thermal
	allowed_roles = list(JOB_SECURITY_OFFICER, JOB_HEAD_OF_SECURITY)
	cost = 550

/datum/gear/assault_rifle
	display_name = "Штурмовой дробовик"
	path = /obj/item/gun/ballistic/automatic/evgenii
	allowed_roles = list(JOB_WARDEN)
	cost = 1750

/datum/gear/golden_id
	display_name = "Золотая ID-карта"
	description = "Мечта, которая никогда не сбудется. Наверное."
	path = /obj/item/card/id/advanced/gold
	allowed_roles = list(JOB_ASSISTANT)
	cost = 50000

/datum/gear/guitar
	display_name = "Гитара"
	description = "Хотите устроить рок-концерт или Вам нужно что-то крепкое в руках для потасовки? Возьмите с собой гитару!"
	path = /obj/item/instrument/guitar
	cost = 250

/datum/gear/cryokatana
	display_name = "Криокатана"
	description = "Криотехнологиченое устройство, которое замораживает преступников живьём. Удивительно!"
	path = /obj/item/storage/belt/sheath/security
	allowed_roles = list(JOB_SECURITY_OFFICER, JOB_HEAD_OF_SECURITY)
	cost = 350

/datum/gear/cryokatana/master
	display_name = "Криокатана мастера"
	description = "Криотехнологиченое устройство, которое замораживает преступников живьём. Удивительно!"
	path = /obj/item/storage/belt/sheath/security/hos
	allowed_roles = list(JOB_HEAD_OF_SECURITY)
	cost = 550

/datum/gear/surgerykit
	display_name = "Кейс полевого хирурга"
	description = "Набор хирургических инструментов для производимых хирургом хирургических операций."
	path = /obj/item/storage/briefcase/surgery
	allowed_roles = list(JOB_FIELD_MEDIC, JOB_PARAMEDIC, JOB_MEDICAL_DOCTOR, JOB_CHIEF_MEDICAL_OFFICER)
	cost = 350

/datum/gear/cash1000
	display_name = "1000 кредитов"
	description = "Бюджет на все первостепенные нужды."
	path = /obj/item/stack/spacecash/c1000
	cost = 900

/datum/gear/cash10000 // just because
	display_name = "10000 кредитов"
	description = "Объёмный вклад своих органов в будущее станции."
	path = /obj/item/stack/spacecash/c10000
	cost = 2000

/datum/gear/kinetic_shield
	display_name = "Кинетический щит"
	path = /obj/item/kinetic_shield
	allowed_roles = list(JOB_CAPTAIN, JOB_HEAD_OF_SECURITY, JOB_CHIEF_ENGINEER, JOB_CHIEF_MEDICAL_OFFICER, JOB_HEAD_OF_PERSONNEL, JOB_RESEARCH_DIRECTOR)
	cost = 800

/datum/gear/merchant_dope
	display_name = "Золотая цепочка"
	path = /obj/item/clothing/neck/necklace/dope/merchant
	allowed_roles = list(JOB_QUARTERMASTER)
	cost = 2500

/datum/gear/arab_book
	display_name = "Азбука Арабского"
	path = /obj/item/storage/book/arabic
	allowed_roles = list(JOB_SCIENTIST,JOB_CHEMIST)
	cost = 5000

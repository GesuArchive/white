/datum/gear/dice
	display_name = "d20"
	path = /obj/item/dice/d20
	cost = 200

//LIGHTERS & CIGARETTES

/datum/gear/lighter
	display_name = "зажигалка Zippo"
	path = /obj/item/lighter
	cost = 900

/datum/gear/lighter/random
	display_name = "дешёвая зажигалка"
	path = /obj/item/lighter/greyscale
	cost = 200

/datum/gear/cigarettes
	display_name = "сигареты \"Space Cigarettes"
	path = /obj/item/storage/fancy/cigarettes
	cost = 400

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
	cost = 950

/datum/gear/cigarettes/havana
	display_name = "сигара \"premium Havanian\""
	path = /obj/item/clothing/mask/cigarette/cigar/havana
	cost = 950

/datum/gear/auvtomat
	display_name = "Нанопистолет"
	path = /obj/item/storage/belt/holster/thermal
	allowed_roles = list("Security Officer", "Head of Security")
	cost = 5000

/datum/gear/assault_rifle
	display_name = "Штурмовой дробовик"
	path = /obj/item/gun/ballistic/automatic/evgenii
	allowed_roles = list("Warden")
	cost = 7500

/datum/gear/golden_id
	display_name = "Золотая ID-карта"
	description = "Мечта, которая никогда не сбудется. Наверное."
	path = /obj/item/card/id/advanced/gold
	allowed_roles = list("Assistant")
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
	allowed_roles = list("Security Officer", "Head of Security")
	cost = 900

/datum/gear/cryokatana/master
	display_name = "Криокатана мастера"
	description = "Криотехнологиченое устройство, которое замораживает преступников живьём. Удивительно!"
	path = /obj/item/storage/belt/sheath/security/hos
	allowed_roles = list("Head of Security")
	cost = 1250

/datum/gear/surgerykit
	display_name = "Кейс полевого хирурга"
	description = "Набор хирургических инструментов для производимых хирургом хирургических операций."
	path = /obj/item/storage/briefcase/surgery
	allowed_roles = list("Field Medic", "Paramedic", "Medical Doctor", "Chief Medical Officer")
	cost = 600

/datum/gear/cash1000
	display_name = "1000 кредитов"
	description = "Бюджет на все первостепенные нужды."
	path = /obj/item/stack/spacecash/c1000
	cost = 1250

/datum/gear/cash10000 // just because
	display_name = "10000 кредитов"
	description = "Объёмный вклад своих органов в будущее станции."
	path = /obj/item/stack/spacecash/c10000
	cost = 5250

/datum/gear/kinetic_shield
	display_name = "Кинетический щит"
	path = /obj/item/kinetic_shield
	allowed_roles = list("Captain", "Head of Security", "Chief Engineer", "Chief Medical Officer", "Head of Personnel", "Research Director")
	cost = 1500

/datum/gear/merchant_dope
	display_name = "Золотая цепочка"
	path = /obj/item/clothing/neck/necklace/dope/merchant
	allowed_roles = list("Quartermaster")
	cost = 5000

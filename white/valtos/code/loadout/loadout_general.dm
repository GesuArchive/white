/datum/gear/dice
	display_name = "d20"
	path = /obj/item/dice/d20
	cost = 20

//LIGHTERS & CIGARETTES

/datum/gear/lighter
	display_name = "зажигалка Zippo"
	path = /obj/item/lighter
	cost = 400

/datum/gear/lighter/random
	display_name = "дешёвая зажигалка"
	path = /obj/item/lighter/greyscale
	cost = 100

/datum/gear/cigarettes
	display_name = "сигареты \"Space Cigarettes"
	path = /obj/item/storage/fancy/cigarettes
	cost = 200

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
	cost = 350

/datum/gear/cigarettes/havana
	display_name = "сигара \"premium Havanian\""
	path = /obj/item/clothing/mask/cigarette/cigar/havana
	cost = 350

/datum/gear/auvtomat
	display_name = "WT-550"
	path = /obj/item/gun/ballistic/automatic/wt550
	allowed_roles = list("Veteran", "Security Officer", "Russian Officer", "Head of Security")
	cost = 500

/datum/gear/taser
	display_name = "Тазер"
	path = /obj/item/gun/ballistic/rifle/boltaction/taser
	allowed_roles = list("Veteran")
	cost = 2500

/datum/gear/assault_rifle
	display_name = "Штурмовой карабин"
	path = /obj/item/gun/ballistic/automatic/assault_rifle
	allowed_roles = list("Warden")
	cost = 5000

/datum/gear/spare_id
	display_name = "Золотая ID-карта капитана"
	description = "Мечта, которая никогда не сбудется. Наверное."
	path = /obj/item/card/id/advanced/gold/captains_spare
	allowed_roles = list("Assistant")
	cost = 100500

/datum/gear/guitar
	display_name = "Гитара"
	description = "Хотите устроить рок-концерт или Вам нужно что-то крепкое в руках для потасовки? Возьмите с собой гитару!"
	path = /obj/item/instrument/guitar
	cost = 100

/datum/gear/cryokatana
	display_name = "Криокатана"
	description = "Криотехнологиченое устройство, которое замораживает преступников живьём. Удивительно!"
	path = /obj/item/storage/belt/sheath/security
	allowed_roles = list("Veteran", "Security Officer", "Russian Officer", "Head of Security")
	cost = 150

/datum/gear/cryokatana/master
	display_name = "Криокатана мастера"
	description = "Криотехнологиченое устройство, которое замораживает преступников живьём. Удивительно!"
	path = /obj/item/storage/belt/sheath/security/hos
	allowed_roles = list("Head of Security")
	cost = 250

/datum/gear/surgerykit
	display_name = "Кейс полевого хирурга"
	description = "Набор хирургических инструментов для производимых хирургом хирургических операций."
	path = /obj/item/storage/briefcase/surgery
	allowed_roles = list("Field Medic", "Paramedic", "Medical Doctor", "Chief Medical Officer")
	cost = 100

/datum/gear/cash50
	display_name = "50 кредитов"
	description = "Бюджет на все первостепенные нужды."
	path = /obj/item/stack/spacecash/c50
	cost = 250

/datum/gear/cash500
	display_name = "500 кредитов"
	description = "Объёмный вклад своих органов в будущее станции."
	path = /obj/item/stack/spacecash/c500
	cost = 3200

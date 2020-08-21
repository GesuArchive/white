/datum/gear/dice
	display_name = "d20"
	path = /obj/item/dice/d20
	cost = 3

//LIGHTERS & CIGARETTES

/datum/gear/lighter
	display_name = "зажигалка Zippo"
	path = /obj/item/lighter
	cost = 150

/datum/gear/lighter/random
	display_name = "дешёвая зажигалка"
	path = /obj/item/lighter/greyscale
	cost = 100

/datum/gear/cigarettes
	display_name = "сигареты \"Space Cigarettes"
	path = /obj/item/storage/fancy/cigarettes
	cost = 80

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
	cost = 120

/datum/gear/cigarettes/havana
	display_name = "сигара \"premium Havanian\""
	path = /obj/item/clothing/mask/cigarette/cigar/havana
	cost = 120

/datum/gear/auvtomat
	display_name = "WT-550"
	path = /obj/item/gun/ballistic/automatic/wt550
	allowed_roles = list("Veteran", "International Officer", "Russian Officer", "Head of Security")
	cost = 250

/datum/gear/spare_id
	display_name = "Золотая ID-карта капитана"
	description = "Мечта, которая никогда не сбудется. Наверное."
	path = /obj/item/card/id/captains_spare
	allowed_roles = list("Assistant")
	cost = 20007

/datum/gear/guitar
	display_name = "Гитара"
	description = "Хотите устроить рок-концерт или Вам нужно что-то крепкое в руках для потасовки? Возьмите с собой гитару!"
	path = /obj/item/instrument/guitar
	cost = 50

/datum/gear/backup_circuit
	display_name = "Запасная микросхема"
	description = "Если каким-то образом на этой станции не оказалось консоли, а вы прибыли поздно, то всегда поможет запасная плата вызова шаттла."
	path = /obj/machinery/computer/shuttle/ferry/request/trader
	allowed_roles = list("Trader")
	cost = 50

/datum/gear/lvlonetrader
	display_name = "Карта расширения L1"
	description = "Для доступа к дополнительному отсеку."
	path = /obj/item/card/id/trader_ex
	allowed_roles = list("Trader")
	cost = 350

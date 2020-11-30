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

/datum/gear/spas12
	display_name = "SPAS-12"
	path = /obj/item/gun/ballistic/shotgun/spas12/rubber
	allowed_roles = list("Warden")
	cost = 2500

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
	cost = 100


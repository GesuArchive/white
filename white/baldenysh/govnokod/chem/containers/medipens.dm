/obj/item/reagent_containers/hypospray/medipen/susconc
	name = "resuscitation concoction"
	desc = "Медипен с приколом. Вкалывать в трупики не больше двух раз, хотя и одного вполне достаточно."
	icon_state = "atropen"
	inhand_icon_state = "atropen"
	volume = 60
	amount_per_transfer_from_this = 30
	list_reagents = list(
							/datum/reagent/inverse/penthrite = 8, //нооартриум
							/datum/reagent/medicine/epinephrine = 5,
							/datum/reagent/medicine/c2/helbital = 10,
							/datum/reagent/medicine/c2/hercuri = 10,
							/datum/reagent/medicine/sal_acid = 12,
							/datum/reagent/medicine/oxandrolone = 12,
							/datum/reagent/medicine/atropine = 3
						)

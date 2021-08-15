/datum/gas_recipe/crystallizer/felinid
	id = "felinid"
	name = "Фелинид"
	min_temp = 5000
	max_temp = 15000
	reaction_type = EXOTHERMIC_REACTION
	energy_release = 950000
	requirements = list(/datum/gas/miasma = 10, /datum/gas/bz = 50)
	products = list(/mob/living/carbon/human/species/felinid = 1)

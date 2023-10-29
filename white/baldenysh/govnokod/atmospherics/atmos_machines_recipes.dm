/datum/gas_recipe/crystallizer/felinid
	id = "felinid"
	name = "Фелинид"
	energy_release = 950000
	requirements = list(GAS_MIASMA = 10, GAS_BZ = 100, GAS_CO2 = 1000)
	products = list(/mob/living/carbon/human/species/felinid/atmos = 1)

/mob/living/carbon/human/species/felinid/atmos/Initialize(mapload)
	. = ..()
	if(prob(10))
		ai_controller = new /datum/ai_controller/raper/opyx(src)
		ADD_TRAIT(src, TRAIT_STUNIMMUNE, "sosi") //будет прикол если игруны пересадят себя в тело такого смешного моба
		ADD_TRAIT(src, TRAIT_STRONG_GRABBER, "sosi")


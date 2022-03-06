/datum/species/human/husk
	name = "хаск"
	id = "husk"
	species_traits = list(NOBLOOD,NOEYESPRITES,NO_DNA_COPY)
	inherent_traits = list(TRAIT_RADIMMUNE,TRAIT_VIRUSIMMUNE, TRAIT_STRONG_GRABBER, TRAIT_CAN_STRIP)
	changesource_flags = null
	mutanteyes = /obj/item/organ/eyes/night_vision
	meat = /obj/item/food/meat/slab/human/mutant/shadow
	inherent_factions = list("faithless", "cult")
	speedmod = 1.75
	toxic_food = NONE
	disliked_food = NONE
	liked_food = NONE
	brutemod = 1.5
	punchdamagehigh = 10
	punchdamagelow = 1
	punchstunthreshold = 0
	siemens_coeff = 10
	mutantheart = /obj/item/organ/heart/husk
	mutantbrain = /obj/item/organ/brain/husk
	mutantliver = /obj/item/organ/liver/fly/husk
	armor = 7.5

/obj/item/food/meat/slab/human/mutant/shadow
	icon_state = "golemmeat"

/obj/item/organ/liver/fly/husk
	color = "#808080"

/obj/item/organ/brain/husk
	color = "#808080"

/obj/item/organ/heart/husk
	color = "#808080"

/mob/living/carbon/human/husk
	name = "???"
	real_name = "???"
	type_of_meat = /obj/item/food/meat/slab/human/mutant/shadow
	faction = list("faithless")
	internal_organs = list(
		/obj/item/organ/eyes/night_vision,
		/obj/item/organ/brain/nightmare,
		/obj/item/organ/heart/nightmare,
		/obj/item/organ/liver/fly,
		/obj/item/organ/lungs)
	status_traits = list(
		baddna = list("adminabuse"),
		deaf = list("adminabuse"),
		disfigured = list("adminabuse"),
		dissected = list("adminabuse"),
		easy_dismember  = list("adminabuse"),
		emotemute = list("adminabuse"),
		fearless = list("adminabuse"),
		husk = list("adminabuse"),
		mute = list("adminabuse"),
		deaf = list("adminabuse"),
		no_breath = list("adminabuse"),
		no_hunger = list("adminabuse"),
		no_limb_disable = list("adminabuse"),
		nodeath = list("adminabuse"),
		ignoredamageslowdown = list("adminabuse"),
		no_metabolism = list("adminabuse"),
		rad_immunity = list("adminabuse"),
		noslip_all = list("adminabuse"),
		resist_cold = list("adminabuse"),
		resist_heat = list("adminabuse"),
		resist_heat_handsonly = list("adminabuse"),
		resist_low_pressure = list("adminabuse"),
		shock_immunity = list("adminabuse"),
		sixth_sence = list("adminabuse"),
		sleep_immunity = list("adminabuse"),
		stable_heart = list("adminabuse"),
		stun_immunity = list("adminabuse"),
		toxin_immune = list("adminabuse"),
		virus_immunity = list("adminabuse"))
	movespeed_modification = list (
		MOB_WALK_RUN = list(
			1 = 100,
			2 = 0,
			3 = 2.75,
			4 = 1.67772e+007,
			5 = 0,
			6 = 0))

/obj/item/bodypart/r_arm/h
	max_stamina_damage = 30
	max_damage = 25
	siemens_coefficient = 10

/obj/item/bodypart/l_arm/h
	max_stamina_damage = 30
	max_damage = 25
	siemens_coefficient = 10

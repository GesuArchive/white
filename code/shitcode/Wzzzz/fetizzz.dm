/datum/outfit/wzzzz/firstblood
	name = "First Blood"
	uniform = /obj/item/clothing/under/syndicate/wzzzz/combat/german
	suit = /obj/item/clothing/suit/space/hardsuit/syndi/elite/wzzzz/breacher
	glasses = /obj/item/clothing/glasses/hud/wzzzz/hacker_rig
	mask = /obj/item/clothing/mask/gas/wzzzz/germanfull
	head = /obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/wzzzz/breacher
	ears = /obj/item/radio/headset/heads/captain
	shoes = /obj/item/clothing/shoes/combat/wzzzz/blackger
	gloves = /obj/item/clothing/gloves/combat/wzzzz/arbiter/undertaker
	back = /obj/item/minigunpack
	l_pocket = /obj/item/tank/internals/emergency_oxygen/engi
	r_pocket = /obj/item/radio/headset/syndicate/alt/leader
	belt = /obj/item/storage/belt/military/wzzzz/vest/terr5
	implants = list(/obj/item/implant/explosive)
	suit_store = /obj/item/gun/ballistic/automatic/pistol
	

/obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/shadow/wzzzz
	icon_state = "golemmeat"

/datum/species/human/wzzzz/husk
	name = "husk"
	id = "husk"
	species_traits = list(NOBLOOD,NOEYESPRITES,NO_DNA_COPY,NOTRANSSTING)
	inherent_traits = list(TRAIT_RADIMMUNE,TRAIT_VIRUSIMMUNE,TRAIT_NOBREATH, TRAIT_NOFLASH, TRAIT_NOHUNGER)
	changesource_flags = null
	mutanteyes = /obj/item/organ/eyes/night_vision
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/shadow/wzzzz
	inherent_factions = list("faithless")
	//var/spee = rand(1.5, 2.25)
	speedmod = 1.75
	toxic_food = NONE
	disliked_food = NONE
	liked_food = NONE
	//coldmod = 0.5
	//burnmod = 0
	brutemod = 1.5
	punchdamagehigh = 10
	punchdamagelow = 1
	punchstunthreshold = 0
	siemens_coeff = 10
	mutant_heart = /obj/item/organ/heart/xyz
	mutant_brain = /obj/item/organ/brain/xyz
	mutantliver = /obj/item/organ/liver/fly/xyz
	//var/ara = rand(0, 15)
	armor = 7.5
	//changesource_flags = MIRROR_BADMIN | MIRROR_PRIDE | ERT_SPAWN
	//maxHealth = rand(50, 250)
	//should_have_brain = FALSE
	//should_have_heart = FALSE
	//should_have_lungs = FALSE
	//should_have_appendix = FALSE
	//should_have_eyes = FALSE
	//should_have_ears = FALSE
	//should_have_tongue = FALSE
	//should_have_liver = FALSE
	//should_have_stomach = FALSE
	//should_have_tail = FALSE
	//facialhair_hidden = TRUE
	//hair_hidden = TRUE
	
/obj/item/organ/liver/fly/xyz
	color = "#808080"
	
/obj/item/organ/brain/xyz
	color = "#808080"
	
/obj/item/organ/heart/xyz
	color = "#808080"
	
/mob/living/carbon/human/wzzzz/husk
	name = "???"
	real_name = "???"
	type_of_meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/shadow/wzzzz
//	inherent_factions = list(faithless)
//	toxic_food = null
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
//		unintelligible-speech = list("adminabuse"))
	movespeed_modification = list (
		MOB_WALK_RUN = list(
			1 = 100,
			2 = 0,
			3 = 2.75,
			4 = 1.67772e+007,
			5 = 0,
			6 = 0))
//	hand_bodyparts = list(
//		/obj/item/bodypart/l_arm/h,
//		/obj/item/bodypart/r_arm/h)
			
/obj/item/bodypart/r_arm/h
	max_stamina_damage = 30
	max_damage = 25
	siemens_coefficient = 10
	
/obj/item/bodypart/l_arm/h
	max_stamina_damage = 30
	max_damage = 25
	siemens_coefficient = 10
	
//		MOOD_SANITY = list(
//			1 = 100,
//			2 = 0,
//			3 = 2.75,
//			4 = 1.67772e+007,
//			5 = 0,
//			6 = 0}

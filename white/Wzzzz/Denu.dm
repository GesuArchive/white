/obj/item/clothing/suit/mob
	name = "mob suit"
	desc = "Looks like mob, feels like human."
	worn_icon = 'white/Wzzzz/Souls/souls.dmi'
	icon = 'white/Wzzzz/Souls/soultem.dmi'
	drop_sound = null
	pickup_sound =  null
	blood_overlay_type = null
	body_parts_covered = CHEST|GROIN|LEGS|ARMS|HEAD|FULL_BODY
	flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR|HIDEMASK|HIDEJUMPSUIT
	visor_flags_inv = HIDEEYES|HIDEFACE|HIDEFACIALHAIR|HIDEHAIR|HIDEEARS|HIDEJUMPSUIT|HIDENECK|FULL_BODY
	cold_protection = CHEST|GROIN|LEGS|ARMS|HEAD|FULL_BODY
	heat_protection = CHEST|GROIN|LEGS|ARMS|HEAD|FULL_BODY
	clothing_flags = BLOCKS_SHOVE_KNOCKDOWN|BLOCK_GAS_SMOKE_EFFECT
	resistance_flags = LAVA_PROOF|FIRE_PROOF|UNACIDABLE|FREEZE_PROOF
	w_class = 4
	flags_cover = HEADCOVERSMOUTH|PEPPERPROOF|HEADCOVERSEYES
	visor_flags_cover = HEADCOVERSEYES|HEADCOVERSMOUTH|PEPPERPROOF
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	
t/syndi/elite/null
/obj/item/clothing/suit/mob/faithless
	icon_state = "faithless"
	inhand_icon_state = "faithless"
	flags_1 = NONE

/obj/item/clothing/suit/mob/standing
	icon_state = "standing"
	inhand_icon_state = "standing"
	visor_flags_inv = NONE|HIDEHAIR
	flags_inv = NONE|HIDEHAIR
	flags_1 = NONE

/obj/item/clothing/suit/mob/ash_whelp
	icon_state = "ash_whelp"
	inhand_icon_state = "ash_whelp"
	flags_1 = NONE

/obj/item/food/meat/slab/human/mutant/shadow
	icon_state = "golemmeat"

/datum/species/human/husk
	name = "husk"
	id = "husk"
	species_traits = list(NOBLOOD,NOEYESPRITES,NO_DNA_COPY)
	inherent_traits = list(TRAIT_RADIMMUNE,TRAIT_VIRUSIMMUNE, TRAIT_STRONG_GRABBER)
	changesource_flags = null
	mutanteyes = /obj/item/organ/eyes/night_vision
	meat = /obj/item/food/meat/slab/human/mutant/shadow
	inherent_factions = list("faithless", "cult")
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
	mutantheart = /obj/item/organ/heart/xyz
	mutantbrain = /obj/item/organ/brain/xyz
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


/mob/living/carbon/human/husk
	name = "???"
	real_name = "???"
	type_of_meat = /obj/item/food/meat/slab/human/mutant/shadow
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
//		unintelligible-speech = list("adminabuse"))
	movespeed_modification = list (
		MOB_WALK_RUN = list(
			1 = 100,
			2 = 0,
			3 = 2.75,
			4 = 1.67772e+007,
			5 = 0,
			6 = 0))
	hand_bodyparts = list(
		/obj/item/bodypart/l_arm/h,
		/obj/item/bodypart/r_arm/h)

/obj/item/bodypart/r_arm/h
	max_stamina_damage = 30
	max_damage = 25
	siemens_coefficient = 10

/obj/item/bodypart/l_arm/h
	max_stamina_damage = 30
	max_damage = 25
	siemens_coefficient = 10

/obj/structure/closet/crate/coffin/blackcoffin/ambush
	desc = "It's watching you suspiciously."
	resistance_flags = FREEZE_PROOF|FIRE_PROOF

/obj/structure/closet/crate/coffin/blackcoffin/ambush/PopulateContents()
	new /mob/living/simple_animal/hostile/vanya/killermeat(src)

/mob/living/simple_animal/hostile/pirate/ranged/space
	icon = 'white/Wzzzz/icons/Ora/li/simple_human.dmi'

/mob/living/simple_animal/hostile/pirate/melee/space
	icon = 'white/Wzzzz/icons/Ora/li/simple_human.dmi'

/mob/living/simple_animal/hostile/russian/ranged/officer
	icon = 'white/Wzzzz/icons/Ora/li/simple_human.dmi'

/mob/living/simple_animal/hostile/russian
	icon = 'white/Wzzzz/icons/Ora/li/simple_human.dmi'

/mob/living/simple_animal/hostile/russian/ranged
	icon = 'white/Wzzzz/icons/Ora/li/simple_human.dmi'

/mob/living/simple_animal/hostile/syndicate
	icon = 'white/Wzzzz/icons/Ora/li/simple_human.dmi'

/mob/living/simple_animal/hostile/syndicate/melee/sword
	icon = 'white/Wzzzz/icons/Ora/li/simple_human.dmi'

/mob/living/simple_animal/hostile/syndicate/melee/sword/space
	icon = 'white/Wzzzz/icons/Ora/li/simple_human.dmi'

/mob/living/simple_animal/hostile/syndicate/ranged/smg
	icon = 'white/Wzzzz/icons/Ora/li/simple_human.dmi'

/mob/living/simple_animal/hostile/syndicate/ranged/smg/space
	icon = 'white/Wzzzz/icons/Ora/li/simple_human.dmi'

//mob/living/simple_animal/hostile/syndicate/ranged/shotgun/space/stormtrooper
//	icon = 'white/Wzzzz/icons/Ora/li/simple_human.dmi'

/mob/living/simple_animal/hostile/faithless
	icon = 'white/Wzzzz/icons/Ora/li/simple_human.dmi'
	maxHealth = 100
	melee_damage_lower = 20
	melee_damage_upper = 20
	unsuitable_atmos_damage = 5
	harm_intent_damage = 15

/obj/item/reagent_containers/food/drinks/bottle/molotov
	reagents = list(/datum/reagent/napalm = 100)

/obj/item/spear/explosive
	explosive = /obj/item/grenade/frag
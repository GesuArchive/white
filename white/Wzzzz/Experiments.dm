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

/obj/item/reagent_containers/food/drinks/bottle/molotov/napalm
	reagents = list(/datum/reagent/napalm = 100)

/obj/item/spear/explosive/granade
	explosive = /obj/item/grenade/frag

/*

/obj/machinery/vending/dude
	payment_department = null
	name = "Great feast"
	desc = "Only you can stop evil what lurks inside pedals."
	slogan_delay = 25000
	max_integrity = 750
	icon_state = "dude"
	product_slogans = "The earth is hungry, its heart shrinks and demands purification, the earth is thirsty.;Be blessed, the humble, for they are a convenient target.;The air smells of death and decay, the smell of victory.;Life is cheap, death is free. Hurry up, the offer is limited.;I will put the mutilated organs of my enemies on my head like a hat, and tie their guts like a tie. Oh, how good my dance will be.;Human garbage seeps through the clutching fingers of death.;Blood spatter everywhere. Like a river that flows around me and drags me into its flow.;The smell of dark skin seeps into my nostrils, followed by the smell of death. The human remains are stuck to my clothes like jewelry, and I'm still walking on bones, knee-deep in blood and guts.;Enjoy the frozen excrement of death machines relentlessly grinding flesh...;Who said they had fallen and could not be brought back to the right path?"
	product_ads = "The earth is hungry, its heart shrinks and demands purification, the earth is thirsty.;Be blessed, the humble, for they are a convenient target.;The air smells of death and decay, the smell of victory.;Life is cheap, death is free. Hurry up, the offer is limited.;I will put the mutilated organs of my enemies on my head like a hat, and tie their guts like a tie. Oh, how good my dance will be.;Human garbage seeps through the clutching fingers of death.;Blood spatter everywhere. Like a river that flows around me and drags me into its flow.;The smell of dark skin seeps into my nostrils, followed by the smell of death. The human remains are stuck to my clothes like jewelry, and I'm still walking on bones, knee-deep in blood and guts.;Enjoy the frozen excrement of death machines relentlessly grinding flesh...;Who said they had fallen and could not be brought back to the right path?"
	vend_reply = "Only my weapon undersrand me."
	circuit = /obj/item/circuitboard/machine/vending/donksofttoyvendor/wzzzz/dude
	resistance_flags = NONE|ACID_PROOF|FIRE_PROOF|FREEZE_PROOF
	icon = 'white/Wzzzz/icons/vera.dmi'
	armor = list("melee" = 30, "bullet" = 20, "laser" = 10, "energy" = 0, "bomb" = 30, "bio" = 30, "rad" = 0, "fire" = 80, "acid" = 50)
	refill_canister = /obj/item/vending_refill/custom
	default_price = 0
	extra_price = 0
	refill_canister = /obj/item/vending_refill/wzzzz/dude
	products = list(
		/obj/item/grenade/chem_grenade/incendiary = 1.#INF,
		/obj/item/kitchen/knife/free = 1.#INF,
		/obj/item/kitchen/knife/butcher/free = 1.#INF,
		/obj/item/kitchen/knife/german = 1.#INF,
		/obj/item/restraints/legcuffs/bola/tactical = 1.#INF,
		/obj/item/restraints/legcuffs/bola = 1.#INF,
		/obj/item/twohanded/required/chainsaw = 1.#INF,
		/obj/item/storage/belt/bandolier = 1.#INF,
		/obj/item/storage/backpack/fireproof = 1.#INF,
		/obj/item/clothing/shoes/jackboots = 1.#INF,
		/obj/item/clothing/glasses/sunglasses = 1.#INF,
		/obj/item/clothing/suit/jacket/leather/overcoat = 1.#INF,
		/obj/item/storage/pill_bottle/happy = 1.#INF,
		/obj/item/stack/medical/gauze/improvised/free = 1.#INF,
		/obj/item/storage/firstaid/advanced = 1.#INF,
		/obj/item/ammo_casing/shotgun/improvised = 1.#INF,
		/obj/item/gun/ballistic/shotgun/doublebarrel/improvised = 1.#INF,
		/obj/item/ammo_box/a357 = 1.#INF,
		/obj/item/gun/ballistic/revolver/mateba = 1.#INF,
		/obj/item/tank/internals/plasma/full = 1.#INF,
		/obj/item/flamethrower = 1.#INF,
		/obj/item/ammo_box/magazine/ak47mag = 1.#INF,
		/obj/item/gun/ballistic/automatic/ak47 = 1.#INF,
		/obj/item/gun/ballistic/crossbow/improv = 1.#INF,
		/obj/item/stack/rods/twentyfive = 1.#INF,
		/obj/item/gun/ballistic/crossbow = 1.#INF,
		/obj/item/grenade/iedcasing = 1.#INF,
		/obj/item/grenade/syndieminibomb/concussion/frag = 1.#INF,
		/obj/item/grenade/c4/x4 = 1.#INF,
		/obj/item/twohanded/spear = 1.#INF,
		/obj/item/gun/ballistic/automatic/wt550/german = 1.#INF,
		/obj/item/gun/ballistic/shotgun/doublebarrel = 1.#INF,
		/obj/item/ammo_casing/caseless/rocket = 1.#INF,
		/obj/item/ammo_casing/caseless/rocket/hedp = 1.#INF,
		/obj/item/gun/ballistic/rocketlauncher/unrestricted = 1.#INF,
		/obj/item/ammo_box/magazine/wt550m9/mc9mmt = 1.#INF,
		/obj/item/restraints/legcuffs/beartrap = 1.#INF,
		/obj/item/grenade/c4 = 1.#INF,
		/obj/item/storage/box/lethalshot = 1.#INF,
		/obj/item/ammo_box/magazine/m12g = 1.#INF,
		/obj/item/gun/ballistic/shotgun/bulldog/unrestricted = 1.#INF,
		/obj/item/twohanded/spear/explosive/grenade = 1.#INF,
		/obj/item/gun/ballistic/automatic/tommygun = 1.#INF,
		/obj/item/ammo_box/magazine/tommygunm45 = 1.#INF,
		/obj/item/gun/ballistic/shotgun/lethal = 1.#INF,
		/obj/item/ammo_box/magazine/uzim9mm = 1.#INF,
		/obj/item/gun/ballistic/automatic/mini_uzi = 1.#INF,
		/obj/item/gun/ballistic/automatic/pistol/APS = 1.#INF,
		/obj/item/ammo_box/magazine/pistolm9mm = 1.#INF,
		/obj/item/gun/ballistic/automatic/pistol/makarov = 1.#INF,
		/obj/item/gun/ballistic/revolver/grenadelauncher/unrestricted = 1.#INF,
		/obj/item/ammo_box/a40mm = 1.#INF,
		/obj/item/gun/ballistic/automatic/pistol/tanner = 1.#INF,
		/obj/item/ammo_box/magazine/m10mm = 1.#INF,
		/obj/item/reagent_containers/food/drinks/bottle/molotov/napalm = 1.#INF,
		/obj/item/switchblade = 1.#INF,
		/obj/item/lighter/greyscale/free = 1.#INF,
		/obj/item/kitchen/knife/butcher/machete = 1.#INF,
		/obj/item/ammo_box/magazine/assault_rifle = 1.#INF,
		/obj/item/gun/ballistic/automatic/assault_rifle = 1.#INF,
		/obj/item/storage/pill_bottle/soldier = 1.#INF,
		/obj/item/clothing/mask/gas/germanfull = 1.#INF,
		/obj/item/clothing/suit/armor/vest/leather/tailcoat/black = 1.#INF,
		/obj/item/gun/ballistic/automatic/pistol/mauser = 1.#INF,
		/obj/item/ammo_box/magazine/mauser/battle = 1.#INF,
		/obj/item/gun/ballistic/automatic/pistol/luger = 1.#INF,
		/obj/item/ammo_box/magazine/luger/battle = 1.#INF,
		/obj/item/gun/ballistic/automatic/pistol = 1.#INF,
		/obj/item/gun/ballistic/automatic/pistol/m1911 = 1.#INF,
		/obj/item/ammo_box/magazine/m45 = 1.#INF,
		/obj/item/gun/ballistic/automatic/pistol/deagle = 1.#INF,
		/obj/item/ammo_box/magazine/m50 = 1.#INF,
		/obj/item/gun/ballistic/rifle/boltaction/kar98k/scope = 1.#INF,
		/obj/item/gun/ballistic/rifle/boltaction/kar98k = 1.#INF,
		/obj/item/ammo_box/magazine/a792x57 = 1.#INF,
		/obj/item/gun/ballistic/automatic/c20r/unrestricted = 1.#INF,
		/obj/item/ammo_box/magazine/smgm45 = 1.#INF,
		/obj/item/gun/ballistic/automatic/gyropistol = 1.#INF,
		/obj/item/ammo_box/magazine/m75 = 1.#INF,
		/obj/item/gun/ballistic/automatic/surplus = 1.#INF,
		/obj/item/ammo_box/magazine/m10mm/rifle = 1.#INF,
		/obj/item/gun/ballistic/automatic/l6_saw/unrestricted/mg34 = 1.#INF,
		/obj/item/ammo_box/magazine/a762d = 1.#INF,
		/obj/item/gun/ballistic/automatic/l6_saw/unrestricted = 1.#INF,
		/obj/item/ammo_box/magazine/mm712x82 = 1.#INF,
		/obj/item/gun/ballistic/automatic/ar = 1.#INF,
		/obj/item/ammo_box/magazine/m556 = 1.#INF,
		/obj/item/gun/ballistic/automatic/ar = 1.#INF,
		/obj/item/ammo_box/magazine/m556/arg = 1.#INF,
		/obj/item/gun/ballistic/automatic/m90/unrestricted = 1.#INF,
		/obj/item/ammo_box/magazine/m556 = 1.#INF,
		/obj/item/gun/ballistic/automatic/proto/unrestricted = 1.#INF,
		/obj/item/ammo_box/magazine/smgm9mm = 1.#INF,
		/obj/item/gun/ballistic/automatic/mp40 = 1.#INF,
		/obj/item/ammo_box/magazine/mp40 = 1.#INF,
		/obj/item/gun/ballistic/automatic/g43 = 1.#INF,
		/obj/item/ammo_box/magazine/g43 = 1.#INF,
		/obj/item/gun/ballistic/automatic/stg = 1.#INF,
		/obj/item/ammo_box/magazine/stg = 1.#INF,
		/obj/item/gun/ballistic/shotgun/automatic/combat = 1.#INF,
		/obj/item/gun/ballistic/shotgun/doublebarrel/hook = 1.#INF,
		/obj/item/gun/ballistic/shotgun/sniper = 1.#INF,
		/obj/item/gun/ballistic/shotgun/automatic/dual_tube = 1.#INF,
		/obj/item/ammo_box/magazine/m12g/slug = 1.#INF,
		/obj/item/ammo_box/magazine/m12g/dragon = 1.#INF,
		/obj/item/gun/ballistic/rifle/boltaction = 1.#INF,
		/obj/item/clothing/suit/armor/vest = 1.#INF,
		/obj/item/clothing/suit/armor/opvest = 1.#INF,
		/obj/item/clothing/under/victorianvest/grey = 1.#INF,
		/obj/item/clothing/suit/hooded/chaplainsuit/star_traitor = 1.#INF,
		/obj/item/clothing/shoes/jackboots/fiendshoes = 1.#INF,
		/obj/item/clothing/suit/hooded/chaplainsuit/fiendcowl = 1.#INF,
		/obj/item/clothing/under/syndicate/fiendsuit = 1.#INF,
		/obj/item/shovel = 1.#INF,
		/obj/item/shovel/serrated = 1.#INF,
		/obj/item/pickaxe = 1.#INF,
		/obj/item/twohanded/fireaxe = 1.#INF,
		/obj/item/melee/sabre/german = 1.#INF,
		/obj/item/melee/club = 1.#INF,
		/obj/item/melee/classic_baton/german = 1.#INF,
		/obj/item/melee/sabre/marine = 1.#INF,
		/obj/item/gun/ballistic/automatic/ar/fg42 = 1.#INF,
		/obj/item/ammo_box/magazine/fg42 = 1.#INF,
		/obj/item/gun/ballistic/automatic/m90/unrestricted/z8 = 1.#INF,
		/obj/item/ammo_box/magazine/a556carbine = 1.#INF,
		/obj/item/gun/ballistic/automatic/carbine = 1.#INF,
		/obj/item/ammo_box/magazine/carbine = 1.#INF,
		/obj/item/suppressor = 1.#INF,
		/obj/item/clothing/suit/armor/vest/german/webvest = 1.#INF,
		/obj/item/clothing/suit/armor/vest/german/mercwebvest = 1.#INF,
		/obj/item/storage/toolbox/ammo/Kar98 = 1.#INF,
		/obj/item/storage/toolbox/ammo/STG = 1.#INF,
		/obj/item/storage/toolbox/ammo/MP40 = 1.#INF,
		/obj/item/storage/toolbox/ammo/G43 = 1.#INF,
		/obj/item/storage/toolbox/ammo/FG42 = 1.#INF,
		/obj/item/storage/toolbox/ammo/AK47 = 1.#INF,
		/obj/item/storage/toolbox/ammo/WT550 = 1.#INF,
		/obj/item/clothing/head/helmet/space/eva/black = 1.#INF)
	contraband = list(/obj/item/clothing/suit/armor/vest/swatarmor_german/grey = 1.#INF)


/obj/item/vending_refill/dude
	machine_name = "Great feast"
	icon_state = "refill_dude"
	icon = 'white/Wzzzz/icons/vera.dmi'

/obj/item/circuitboard/machine/vending/donksofttoyvendor/dude
	name = "Thirsty circuitboard"
	desc = "The earth is hungry, its heart shrinks and demands purification, the earth is thirsty."
*/

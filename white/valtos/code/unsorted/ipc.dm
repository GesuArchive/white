/datum/species/ipc // im fucking lazy mk2 and cant get sprites to normally work
	name = "IPC" //inherited from the real species, for health scanners and things
	id = "ipc"
	say_mod = "бип-бупает" //inherited from a user's real species
	sexes = FALSE
	species_traits = list(
		NOTRANSSTING,
		NOBLOOD,
		TRAIT_EASYDISMEMBER,
		NOEYESPRITES
	) //all of these + whatever we inherit from the real species
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_VIRUSIMMUNE,
		TRAIT_NOMETABOLISM,
		TRAIT_NOLIMBDISABLE,
		TRAIT_TOXIMMUNE,
		TRAIT_RESISTCOLD,
		TRAIT_GENELESS,
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_RESISTLOWPRESSURE,
		TRAIT_LIMBATTACHMENT,
		TRAIT_CAN_STRIP,
		TRAIT_NOHYDRATION,
		TRAIT_PIERCEIMMUNE
	)
	inherent_biotypes = MOB_ROBOTIC|MOB_HUMANOID
	meat = null
	exotic_blood = /datum/reagent/fuel/oil
	damage_overlay_type = "synth"
	limbs_id = "synth"
	mutant_bodyparts = list("ipc_screen" = "BSOD", "ipc_antenna" = "None")
	burnmod = 1.75
	heatmod = 1.6
	brutemod = 1.3
	mutantbrain = /obj/item/organ/brain // should be normal human brain
	mutanttongue = /obj/item/organ/tongue/robot
	mutanteyes = /obj/item/organ/eyes/robotic
	mutantears = /obj/item/organ/ears/cybernetic
	mutantliver = /obj/item/organ/liver/cybernetic
	mutantstomach = /obj/item/organ/stomach/cybernetic
	species_language_holder = /datum/language_holder/synthetic
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT

	///If your health becomes equal to or less than this value, your disguise is supposed to break. Unfortunately, that feature currently isn't implemented, so currently, all this threshold is used for is (I kid you not) determining whether or not your speech uses SPAN_CLOWN while you're disguised as a bananium golem. See the handle_speech() proc further down in this file for more information on that check.
	var/disguise_fail_health = 75
	var/datum/species/fake_species //a species to do most of our work for us, unless we're damaged
	var/list/initial_species_traits //for getting these values back for assume_disguise()
	var/list/initial_inherent_traits

	var/datum/action/innate/monitor_change/screen

/datum/species/ipc/New()
	initial_species_traits = species_traits.Copy()
	initial_inherent_traits = inherent_traits.Copy()
	..()

/datum/species/ipc/military
	name = "Corrupted IPC"
	id = "military_synth"
	armor = -25
	punchdamagelow = 2
	punchdamagehigh = 1
	punchstunthreshold = 0 //about 0% chance to stun
	disguise_fail_health = 50
	changesource_flags = MIRROR_BADMIN | WABBAJACK

/datum/species/ipc/on_species_gain(mob/living/carbon/human/H, datum/species/old_species)
	..()
	RegisterSignal(H, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	for(var/X in H.bodyparts)
		var/obj/item/bodypart/O = X
		O.should_draw_ipc = TRUE
		O.change_bodypart_status(BODYPART_ROBOTIC, FALSE, TRUE)
	H.set_safe_hunger_level()

/datum/species/ipc/on_species_loss(mob/living/carbon/human/H)
	. = ..()
	UnregisterSignal(H, COMSIG_MOB_SAY)
	for(var/X in H.bodyparts)
		var/obj/item/bodypart/O = X
		O.should_draw_ipc = FALSE
		O.change_bodypart_status(BODYPART_ORGANIC, FALSE, TRUE)

/datum/species/ipc/proc/assume_disguise(datum/species/S, mob/living/carbon/human/H)
	if(S && !istype(S, type))
		name = S.name
		say_mod = S.say_mod
		sexes = S.sexes
		species_traits = initial_species_traits.Copy()
		inherent_traits = initial_inherent_traits.Copy()
		species_traits |= S.species_traits
		inherent_traits |= S.inherent_traits
		attack_verb = S.attack_verb
		attack_effect = S.attack_effect
		attack_sound = S.attack_sound
		miss_sound = S.miss_sound
		meat = S.meat
		mutant_bodyparts = S.mutant_bodyparts.Copy()
		mutant_organs = S.mutant_organs.Copy()
		nojumpsuit = S.nojumpsuit
		no_equip = S.no_equip.Copy()
		limbs_id = S.limbs_id
		use_skintones = S.use_skintones
		fixed_mut_color = S.fixed_mut_color
		hair_color = S.hair_color
		fake_species = new S.type
	else
		name = initial(name)
		say_mod = initial(say_mod)
		species_traits = initial_species_traits.Copy()
		inherent_traits = initial_inherent_traits.Copy()
		attack_verb = initial(attack_verb)
		attack_effect = initial(attack_verb)
		attack_sound = initial(attack_sound)
		miss_sound = initial(miss_sound)
		mutant_bodyparts = list()
		nojumpsuit = initial(nojumpsuit)
		no_equip = list()
		qdel(fake_species)
		fake_species = null
		meat = initial(meat)
		limbs_id = "synth"
		use_skintones = 0
		sexes = 0
		fixed_mut_color = ""
		hair_color = ""

	for(var/X in H.bodyparts) //propagates the damage_overlay changes
		var/obj/item/bodypart/BP = X
		BP.update_limb()
	H.update_body_parts() //to update limb icon cache with the new damage overlays

/datum/species/ipc/proc/handle_speech(datum/source, list/speech_args)
	if (isliving(source)) // yeah it's gonna be living but just to be clean
		var/mob/living/L = source
		if(fake_species && L.health > disguise_fail_health)
			switch(fake_species.type)
				if (/datum/species/golem/bananium)
					speech_args[SPEECH_SPANS] |= SPAN_CLOWN

/datum/species/ipc/handle_hair(mob/living/carbon/human/H, forced_colour)
	if(fake_species)
		fake_species.handle_hair(H, forced_colour)
	else
		return ..()


/datum/species/ipc/handle_body(mob/living/carbon/human/H)
	if(fake_species)
		fake_species.handle_body(H)
	else
		return ..()

/datum/species/ipc/handle_mutant_bodyparts(mob/living/carbon/human/H, forced_colour)
	if(fake_species)
		fake_species.handle_mutant_bodyparts(H,forced_colour)
	else
		return ..()

/datum/species/ipc/random_name(gender,unique,lastname, en_lang)
	if(unique)
		return random_unique_ipc_name()

	var/randname = ipc_name()

	if(lastname)
		randname += " [lastname]"

	return randname

/datum/species/ipc/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H, delta_time, times_fired)
	if(chem.type == /datum/reagent/medicine/c2/synthflesh)
		chem.expose_mob(H, TOUCH, 2 * REAGENTS_EFFECT_MULTIPLIER * delta_time,0) //heal a little
		H.reagents.remove_reagent(chem.type, REAGENTS_METABOLISM * delta_time)
		return TRUE
	return ..()

/datum/species/ipc/on_species_gain(mob/living/carbon/human/C)
	if(is_ipc(C) && !is_military_ipc(C) && !screen)
		screen = new
		screen.Grant(C)
	..()

/datum/species/ipc/on_species_loss(mob/living/carbon/human/C)
	if(screen)
		screen.Remove(C)
	..()

/datum/action/innate/monitor_change
	name = "Сменить экран"
	check_flags = AB_CHECK_CONSCIOUS
	button_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "drone_vision"

/datum/action/innate/monitor_change/Activate()
	var/mob/living/carbon/human/H = owner
	var/new_ipc_screen = tgui_input_list(usr, "Выбираем:", "Смена экрана", GLOB.ipc_screens_list)
	if(!new_ipc_screen)
		return
	H.dna.features["ipc_screen"] = new_ipc_screen
	H.update_body()

/proc/ipc_name()
	return "[pick(GLOB.posibrain_names)]-[rand(100, 999)]"

/proc/random_unique_ipc_name(attempts_to_find_unique_name=10)
	for(var/i in 1 to attempts_to_find_unique_name)
		. = capitalize(ipc_name())

		if(!findname(.))
			break

// IPCs
/datum/sprite_accessory/screen
	icon = 'white/valtos/icons/ipc_screens.dmi'
	color_src = null

/datum/sprite_accessory/screen/blank
	name = "Blank"
	icon_state = "blank"

/datum/sprite_accessory/screen/pink
	name = "Pink"
	icon_state = "pink"

/datum/sprite_accessory/screen/green
	name = "Green"
	icon_state = "green"

/datum/sprite_accessory/screen/red
	name = "Red"
	icon_state = "red"

/datum/sprite_accessory/screen/blue
	name = "Blue"
	icon_state = "blue"

/datum/sprite_accessory/screen/yellow
	name = "Yellow"
	icon_state = "yellow"

/datum/sprite_accessory/screen/shower
	name = "Shower"
	icon_state = "shower"

/datum/sprite_accessory/screen/nature
	name = "Nature"
	icon_state = "nature"

/datum/sprite_accessory/screen/eight
	name = "Eight"
	icon_state = "eight"

/datum/sprite_accessory/screen/goggles
	name = "Goggles"
	icon_state = "goggles"

/datum/sprite_accessory/screen/heart
	name = "Heart"
	icon_state = "heart"

/datum/sprite_accessory/screen/monoeye
	name = "Mono eye"
	icon_state = "monoeye"

/datum/sprite_accessory/screen/breakout
	name = "Breakout"
	icon_state = "breakout"

/datum/sprite_accessory/screen/purple
	name = "Purple"
	icon_state = "purple"

/datum/sprite_accessory/screen/scroll
	name = "Scroll"
	icon_state = "scroll"

/datum/sprite_accessory/screen/console
	name = "Console"
	icon_state = "console"

/datum/sprite_accessory/screen/rgb
	name = "RGB"
	icon_state = "rgb"

/datum/sprite_accessory/screen/golglider
	name = "Gol Glider"
	icon_state = "golglider"

/datum/sprite_accessory/screen/rainbow
	name = "Rainbow"
	icon_state = "rainbow"

/datum/sprite_accessory/screen/sunburst
	name = "Sunburst"
	icon_state = "sunburst"

/datum/sprite_accessory/screen/statics
	name = "Static"
	icon_state = "static"

//Oracle Station sprites

/datum/sprite_accessory/screen/bsod
	name = "BSOD"
	icon_state = "m_ipc_screen_bsod_ADJ"

/datum/sprite_accessory/screen/redtext
	name = "Red Text"
	icon_state = "retext"

/datum/sprite_accessory/screen/sinewave
	name = "Sine wave"
	icon_state = "sinewave"

/datum/sprite_accessory/screen/squarewave
	name = "Square wave"
	icon_state = "squarwave"

/datum/sprite_accessory/screen/ecgwave
	name = "ECG wave"
	icon_state = "ecgwave"

/datum/sprite_accessory/screen/eyes
	name = "Eyes"
	icon_state = "eyes"

/datum/sprite_accessory/screen/textdrop
	name = "Text drop"
	icon_state = "textdrop"

/datum/sprite_accessory/screen/stars
	name = "Stars"
	icon_state = "stars"

// IPC Antennas

/datum/sprite_accessory/antenna
	icon = 'white/valtos/icons/ipc_antennas.dmi'
	color_src = MUTCOLORS

/datum/sprite_accessory/antenna/none
	name = "None"
	icon_state = "None"

/datum/sprite_accessory/antenna/antennae
	name = "Angled Antennae"
	icon_state = "antennae"

/datum/sprite_accessory/antenna/tvantennae
	name = "TV Antennae"
	icon_state = "tvantennae"

/datum/sprite_accessory/antenna/cyberhead
	name = "Cyberhead"
	icon_state = "cyberhead"

/datum/sprite_accessory/antenna/antlers
	name = "Antlers"
	icon_state = "antlers"

/datum/sprite_accessory/antenna/crowned
	name = "Crowned"
	icon_state = "crowned"


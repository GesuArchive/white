/datum/species/ipc // im fucking lazy mk2 and cant get sprites to normally work
	name = "IPC" //inherited from the real species, for health scanners and things
	id = "ipc"
	say_mod = "бип-бупает" //inherited from a user's real species
	sexes = 0
	species_traits = list(NOTRANSSTING,NOBLOOD,TRAIT_EASYDISMEMBER,TRAIT_NOFLASH) //all of these + whatever we inherit from the real species
	inherent_traits = list(TRAIT_VIRUSIMMUNE,TRAIT_NOLIMBDISABLE,TRAIT_NOHUNGER,TRAIT_NOBREATH,TRAIT_RADIMMUNE,TRAIT_LIMBATTACHMENT)
	inherent_biotypes = list(MOB_ROBOTIC, MOB_HUMANOID)
	meat = null
	exotic_blood = "oil"
	damage_overlay_type = "synth"
	limbs_id = "synth"
	mutant_bodyparts = list("ipc_screen" = "BSOD", "ipc_antenna" = "None")
	burnmod = 1.75
	heatmod = 1.6
	brutemod = 1.2
	var/list/initial_species_traits //for getting these values back for assume_disguise()
	var/list/initial_inherent_traits
	changesource_flags = MIRROR_BADMIN | WABBAJACK

	var/datum/action/innate/monitor_change/screen

/datum/species/ipc/check_roundstart_eligible()
	return TRUE

/datum/species/ipc/military/check_roundstart_eligible()
	return FALSE //yes

/datum/species/ipc/spec_attacked_by(obj/item/I, mob/living/user, obj/item/bodypart/affecting, intent, mob/living/carbon/human/H)
    if(I.tool_behaviour == TOOL_WELDER && intent != INTENT_HARM)
        if (!I.tool_start_check(user, amount=0))
            return
        else
            to_chat(user, "<span class='notice'>Начинаю чинить[H == user ? " свою" : ""] [affecting.name]...</span>")
            if(I.use_tool(src, user, 0, volume=40))
                if(H == user)
                    H.adjustBruteLoss(-3)
                else
                    H.adjustBruteLoss(-10)
                H.updatehealth()
                H.add_fingerprint(user)
                H.visible_message("<span class='notice'>[user] чинит [H == user ? "неряшливо " : ""]некоторые повреждения на [affecting.name].</span>")
        return
    else if(istype(I, /obj/item/stack/cable_coil))
        to_chat(user, "<span class='notice'>Начинаю чинить[H == user ? " свою" : ""] [affecting.name]...</span>")
        if(do_after(user, 30, target = H))
            var/obj/item/stack/cable_coil/C = I
            C.use(1)
            if(H == user)
                H.adjustFireLoss(-2)
                H.adjustToxLoss(-2)
            else
                H.adjustFireLoss(-10)
                H.adjustToxLoss(-10)
            H.updatehealth()
            H.visible_message("<span class='notice'>[user] чинит [H == user ? "неряшливо " : ""]обгоревшие части на [affecting.name].</span>")
        return
    else
        return ..()

/datum/species/ipc/random_name(gender,unique,lastname, en_lang)
	if(unique)
		return random_unique_ipc_name()

	var/randname = ipc_name()

	if(lastname)
		randname += " [lastname]"

	return randname

/datum/species/ipc/military
	name = "Military IPC"
	id = "military_synth"
	armor = 25
	punchdamagelow = 10
	punchdamagehigh = 19
	punchstunthreshold = 14 //about 50% chance to stun

/datum/species/ipc/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.type == /datum/reagent/medicine/c2/synthflesh)
		chem.expose_mob(H, TOUCH, 2 ,0) //heal a little
		H.reagents.remove_reagent(chem.type, REAGENTS_METABOLISM)
		return 1
	else
		return ..()

/datum/species/ipc/on_species_gain(mob/living/carbon/human/C)
	if(isIPC(C) && !screen)
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
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "drone_vision"

/datum/action/innate/monitor_change/Activate()
	var/mob/living/carbon/human/H = owner
	var/new_ipc_screen = input(usr, "Выбираем:", "Смена экрана") as null|anything in GLOB.ipc_screens_list
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


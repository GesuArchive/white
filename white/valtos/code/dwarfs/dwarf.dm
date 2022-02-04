////////////////////
/////BODYPARTS//////
////////////////////


/obj/item/bodypart/var/should_draw_hippie = FALSE

/mob/living/carbon/proc/draw_hippie_parts(undo = FALSE)
	if(!undo)
		for(var/O in bodyparts)
			var/obj/item/bodypart/B = O
			B.should_draw_hippie = TRUE
	else
		for(var/O in bodyparts)
			var/obj/item/bodypart/B = O
			B.should_draw_hippie = FALSE

/datum/species/proc/hippie_handle_hiding_bodyparts(list/bodyparts_adding, obj/item/bodypart/head/head, mob/living/carbon/human/human)
	if("ipc_screen" in mutant_bodyparts)
		if((human.wear_mask && (human.wear_mask.flags_inv & HIDEFACE)) || (human.head && (human.head.flags_inv & HIDEFACE)) || !head || head.status == BODYPART_ROBOTIC)
			bodyparts_adding -= "ipc_screen"

// To make dwarven only jumpsuits, add this species' path to the clothing's species_exception list. By default jumpsuits don't fit dwarven since they're big boned
/datum/species/dwarf
	name = "Dwarf"
	id = "dwarf"
	species_traits = list(EYECOLOR, HAIR, FACEHAIR, LIPS, NO_UNDERWEAR, TRAIT_ALCOHOL_TOLERANCE)
	mutant_bodyparts = list("mcolor" = "FFF", "wings" = "None")
	use_skintones = 1
	disliked_food = GROSS | RAW
	liked_food = JUNKFOOD | FRIED
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	offset_features = list(OFFSET_UNIFORM = list(0,0), OFFSET_ID = list(0,-3), OFFSET_GLOVES = list(0,-3), OFFSET_GLASSES = list(0,-3), OFFSET_EARS = list(0,-3), OFFSET_SHOES = list(0,0), OFFSET_S_STORE = list(0,-3), OFFSET_FACEMASK = list(0,-3), OFFSET_HEAD = list(0,-4), OFFSET_HAIR = list(0,-3), OFFSET_FACE = list(0,-3), OFFSET_BELT = list(0,-3), OFFSET_BACK = list(0,-4), OFFSET_SUIT = list(0,-3), OFFSET_NECK = list(0,-3))
	mutantlungs = /obj/item/organ/lungs/dwarven
	mutanttongue = /obj/item/organ/tongue/dwarven
	mutantliver = /obj/item/organ/liver/dwarven
	species_language_holder = /datum/language_holder/dwarf

/datum/species/dwarf/check_roundstart_eligible()
	return FALSE

/datum/species/dwarf/can_equip(obj/item/I, slot, disable_warning, mob/living/carbon/human/H, bypass_equip_delay_self = FALSE)
	if((slot == ITEM_SLOT_ICLOTHING) && !is_type_in_list(src, I.species_exception))
		return FALSE
	return ..()

/datum/species/dwarf/on_species_gain(mob/living/carbon/human/C, datum/species/old_species, pref_load)
	var/facial_dwarf_hair = pick("Beard (Full)", "Beard (Dwarf)", "Beard (Very Long)")
	C.facial_hairstyle = facial_dwarf_hair
	var/dwarf_hair = pick("Bald", "Skinhead", "Dandy Pompadour")
	var/dwarf_beard = pick("Beard (Dwarf)") // you know it'd be cool if this actually worked with more than one beard
	C.hairstyle = dwarf_hair
	C.facial_hairstyle = dwarf_beard
	C.draw_hippie_parts()
	C.update_body()
	C.update_hair()
	C.update_body_parts()
	GLOB.dwarf_list += C
	. = ..()
	spawn(5 SECONDS)
		var/area/A = get_area(C)
		A.Entered(C)
		C.mind.set_experience(/datum/skill/smithing, SKILL_EXP_APPRENTICE, FALSE)
		C.mind.set_experience(/datum/skill/mining,   SKILL_EXP_APPRENTICE, FALSE)

/datum/species/dwarf/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	C.draw_hippie_parts(TRUE)
	GLOB.dwarf_list -= C
	. = ..()

/datum/species/dwarf/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(!..())
		if(istype(chem, /datum/reagent/consumable/ethanol))
			H.heal_bodypart_damage(0.5,0.5,0.5)
			return FALSE

/datum/species/dwarf/random_name(gender,unique,lastname, en_lang = FALSE)
	return dwarf_name()

#undef DWARF_ALCOHOL_RATE

// Dwarven tongue, they only know their language.
/obj/item/organ/tongue/dwarven
	name = "nol"
	var/static/list/dwarvenLang = typecacheof(list(/datum/language/dwarven))

/obj/item/organ/tongue/dwarven/Initialize(mapload)
	. = ..()
	languages_possible = dwarvenLang

/obj/item/organ/lungs/dwarven
	name = "dwarven lungs"
	desc = "A pair of quite small lungs. They look different than normal human's ones."

/obj/item/organ/liver/dwarven
	name = "dwarven liver"
	desc = "It looks different than normal human's ones."
	alcohol_tolerance = 0

/datum/language/dwarven
	name = "Дварфийский"
	desc = "Старый язык, который до сих пор используется некоторыми представителями человеческого рода."
	key = "w"
	syllables = list(
		"етаг", "гекур", "тел", "гудос", "гетх", "удиз", "залуд", "шоветх", "вер", "зилир",
		"ешобак", "сарумак", "асдобак", "фозак", "шоветхак", "тангак", "догак", "ашокак", "гетхак", "слисак", "мулонак",
		"вадаг", "васаг", "удосаг", "лонгудосаг", "ванаг", "хиваг", "вилкаг", "нигаг",
		"асдоб", "нир", "ноб", "мез", "вор", "фим", "гäт", "зун", "åтт", "наг", "зез", "ешоб", "асдоб",
		"ог", "гет", "зал", "уд", "лок", "ад", "нат", "гат", "мит", "дес", "шуг", "кул", "гит", "гад", "зис",
		"деб", "кошмот", "легон", "размер", "ланзил", "гим", "гамил", "датлад", "тат", "гелут", "гакит", "томус", "тизöт", "рирнöл",
		"мед", "кулет", "нгалáк", "кутхдêнг", "ценäтх", "устос", "ошнïл", "нурал", "назуш"
	)
	space_chance = 35
	icon = 'white/valtos/icons/language.dmi'
	icon_state = "dwarf"

/datum/language_holder/dwarf
	understood_languages = list(/datum/language/dwarven = list(LANGUAGE_ATOM))
	spoken_languages = list(/datum/language/dwarven = list(LANGUAGE_ATOM))

/obj/item/clothing/mask/breath/dwarf
	name = "небольшая дыхательная маска"
	desc = "Загадочным образом исчезает при надевании."
	icon_state = "breath"
	inhand_icon_state = null

/datum/outfit/dwarf
	name = "Dwarf"
	uniform = /obj/item/clothing/under/dwarf
	shoes = /obj/item/clothing/shoes/dwarf

/datum/outfit/dwarf/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return
	H.set_species(/datum/species/dwarf)
	H.gender = MALE
	var/new_name = H.dna.species.random_name(H.gender, TRUE)
	H.fully_replace_character_name(H.real_name, new_name)
	H.regenerate_icons()

//Glasses
/obj/item/clothing/glasses
	name = "очки"
	icon = 'icons/obj/clothing/glasses.dmi'
	w_class = WEIGHT_CLASS_SMALL
	flags_cover = GLASSESCOVERSEYES
	slot_flags = ITEM_SLOT_EYES
	strip_delay = 20
	equip_delay_other = 25
	resistance_flags = NONE
	custom_materials = list(/datum/material/glass = 250)
	var/vision_flags = 0
	var/darkness_view = 2//Base human is 2
	var/invis_view = SEE_INVISIBLE_LIVING	//admin only for now
	var/invis_override = 0 //Override to allow glasses to set higher than normal see_invis
	var/lighting_alpha
	var/list/icon/current = list() //the current hud icons
	var/vision_correction = FALSE //does wearing these glasses correct some of our vision defects?
	var/glass_colour_type //colors your vision when worn
	/// Whether or not vision coloring is forcing
	var/forced_glass_color = FALSE

/obj/item/clothing/glasses/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] тычет <b>[src.name]</b> в [user.ru_ego()] глаза! Выглядит так, будто [user.p_theyre()] пытается покончить с собой!"))
	return BRUTELOSS

/obj/item/clothing/glasses/examine(mob/user)
	. = ..()
	. += "<hr>"
	if(glass_colour_type && !forced_glass_color && ishuman(user))
		. += span_notice("ПКМ, чтобы поменять их цвета.")

/obj/item/clothing/glasses/visor_toggling()
	..()
	if(visor_vars_to_toggle & VISOR_VISIONFLAGS)
		vision_flags ^= initial(vision_flags)
	if(visor_vars_to_toggle & VISOR_DARKNESSVIEW)
		darkness_view ^= initial(darkness_view)
	if(visor_vars_to_toggle & VISOR_INVISVIEW)
		invis_view ^= initial(invis_view)

/obj/item/clothing/glasses/weldingvisortoggle(mob/user)
	. = ..()
	if(. && user)
		user.update_sight()

//called when thermal glasses are emped.
/obj/item/clothing/glasses/proc/thermal_overload()
	if(ishuman(src.loc))
		var/mob/living/carbon/human/H = src.loc
		var/obj/item/organ/eyes/eyes = H.get_organ_slot(ORGAN_SLOT_EYES)
		if(!H.is_blind())
			if(H.glasses == src)
				to_chat(H, span_danger("[capitalize(src.name)] перегружается и... МОИ ГЛАЗА!"))
				H.flash_act(visual = 1)
				H.blind_eyes(3)
				H.blur_eyes(5)
				eyes.applyOrganDamage(5)

/obj/item/clothing/glasses/AltClick(mob/user)
	if(glass_colour_type && !forced_glass_color && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.client)
			if(H.client.prefs)
				if(src == H.glasses)
					H.client.prefs.uses_glasses_colour = !H.client.prefs.uses_glasses_colour
					if(H.client.prefs.uses_glasses_colour)
						to_chat(H, span_notice("Теперь вижу цвет очков."))
					else
						to_chat(H, span_notice("Теперь не вижу цвет очков."))
					H.update_glasses_color(src, 1)
	else
		return ..()

/obj/item/clothing/glasses/proc/change_glass_color(mob/living/carbon/human/H, datum/client_colour/glass_colour/new_color_type)
	var/old_colour_type = glass_colour_type
	if(!new_color_type || ispath(new_color_type)) //the new glass colour type must be null or a path.
		glass_colour_type = new_color_type
		if(H && H.glasses == src)
			if(old_colour_type)
				H.remove_client_colour(old_colour_type)
			if(glass_colour_type)
				H.update_glasses_color(src, 1)


/mob/living/carbon/human/proc/update_glasses_color(obj/item/clothing/glasses/G, glasses_equipped)
	if((client?.prefs.uses_glasses_colour || G.forced_glass_color) && glasses_equipped)
		add_client_colour(G.glass_colour_type)
	else
		remove_client_colour(G.glass_colour_type)


/obj/item/clothing/glasses/meson
	name = "мезонные очки"
	desc = "Используется инженерным и горнодобывающим персоналом для просмотра основных структурных и рельефных планировок сквозь стены независимо от условий освещения."
	icon_state = "meson"
	inhand_icon_state = "meson"
	clothing_traits = list(TRAIT_SUPERMATTER_MADNESS_IMMUNE)
	darkness_view = 2
	vision_flags = SEE_TURFS
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	glass_colour_type = /datum/client_colour/glass_colour/lightgreen

/obj/item/clothing/glasses/meson/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] приближает <b>[src.name]</b> к [user.ru_ego()] глазам и выкручивает яркость на полную! Похоже, что [user.p_theyre()] пытается убить себя!"))
	return BRUTELOSS

/obj/item/clothing/glasses/meson/night
	name = "мезонный сканер ночного видения"
	desc = "Оптический мезонный сканер с усиленным наложением спектра видимого света, обеспечивающий большую четкость изображения в темноте."
	icon_state = "nvgmeson"
	inhand_icon_state = "nvgmeson"
	darkness_view = 8
	flash_protect = FLASH_PROTECTION_SENSITIVE
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	glass_colour_type = /datum/client_colour/glass_colour/green

/obj/item/clothing/glasses/meson/gar
	name = "GAR мезоны"
	icon_state = "garm"
	inhand_icon_state = "garm"
	desc = "Сделай невозможное, увидь невидимое!"
	force = 10
	throwforce = 10
	throw_speed = 4
	attack_verb_continuous = list("режет")
	attack_verb_simple = list("режет")
	hitsound = 'sound/weapons/sword_kill_slash_01.ogg'
	sharpness = SHARP_EDGED

/obj/item/clothing/glasses/meson/prescription
	name = "мезонные очки по рецепту"
	desc = "Странная комбинация из обычных очков и мезонного сканера."
	icon_state = "prescmeson"
	inhand_icon_state = "glasses"
	vision_correction = TRUE

/obj/item/clothing/glasses/science
	name = "научные очки"
	desc = "Пара шикарных очков, используемых для защиты от химических разливов. Оснащен анализатором для сканирования предметов и реагентов."
	icon_state = "purple"
	inhand_icon_state = "glasses"
	glass_colour_type = /datum/client_colour/glass_colour/purple
	resistance_flags = ACID_PROOF
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 80, ACID = 100)
	clothing_traits = list(TRAIT_REAGENT_SCANNER, TRAIT_RESEARCH_SCANNER)

/obj/item/clothing/glasses/science/item_action_slot_check(slot)
	if(slot == ITEM_SLOT_EYES)
		return 1

/obj/item/clothing/glasses/science/night
	name = "научный HUD с ПНВ"
	desc = "Научный интерфейс химиков и ученых со встроенной подсветкой."
	icon_state = "scihudnight"
	inhand_icon_state = "glasses"
	darkness_view = 8
	flash_protect = FLASH_PROTECTION_SENSITIVE
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	glass_colour_type = /datum/client_colour/glass_colour/green

/obj/item/clothing/glasses/sunglasses/chemical
	name = "тактические научные очки"
	desc = "Тактические очки с научным интерфейсом и встроенным светофильтром, защищающим глаза от ярких вспышек."
	icon_state = "sunhudsci"
	clothing_traits = list(TRAIT_REAGENT_SCANNER, TRAIT_RESEARCH_SCANNER)

/obj/item/clothing/glasses/science/prescription
	name = "научные очки по рецепту"
	desc = "Странная комбинация из обычных очков и научного сканера."
	icon_state = "prescscihud"
	resistance_flags = NONE
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 20, "acid" = 40)
	vision_correction = 1

/obj/item/clothing/glasses/night
	name = "очки с ПНВ"
	desc = "Можно полностью видеть в темноте сейчас!"
	icon_state = "night"
	inhand_icon_state = "glasses"
	darkness_view = 8
	flash_protect = FLASH_PROTECTION_SENSITIVE
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	glass_colour_type = /datum/client_colour/glass_colour/green

/obj/item/clothing/glasses/science/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] затягивает ремешки <b>[src.name]</b> вокруг [user.ru_ego()] шеи! Похоже, что [user.p_theyre()] пытается убить себя!"))
	return OXYLOSS

/obj/item/clothing/glasses/eyepatch
	name = "повязка на глаз"
	desc = "Ярр."
	icon_state = "eyepatch"
	inhand_icon_state = "eyepatch"

/obj/item/clothing/glasses/monocle
	name = "монокль"
	desc = "Такой красивый окуляр!"
	icon_state = "monocle"
	inhand_icon_state = "headset" // lol

/obj/item/clothing/glasses/material
	name = "сканер оптических материалов"
	desc = "Очки очень запутанные."
	icon_state = "material"
	inhand_icon_state = "glasses"
	vision_flags = SEE_OBJS
	glass_colour_type = /datum/client_colour/glass_colour/lightblue

/obj/item/clothing/glasses/material/mining
	name = "сканер оптических материалов"
	desc = "Используется шахтерами для обнаружения руд глубоко в скале."
	icon_state = "material"
	inhand_icon_state = "glasses"
	darkness_view = 0

/obj/item/clothing/glasses/material/mining/gar
	name = "GAR сканер материалов"
	icon_state = "garm"
	inhand_icon_state = "garm"
	desc = "Сделай невозможное, увидь невидимое!"
	force = 10
	throwforce = 20
	throw_speed = 4
	attack_verb_continuous = list("режет")
	attack_verb_simple = list("режет")
	hitsound = 'sound/weapons/sword_kill_slash_01.ogg'
	sharpness = SHARP_EDGED
	glass_colour_type = /datum/client_colour/glass_colour/lightgreen

/obj/item/clothing/glasses/regular
	name = "очки по рецепту"
	desc = "Было изготовлено, собрано, доставлено и продано компанией Ботан-корп."
	icon_state = "glasses"
	inhand_icon_state = "glasses"
	vision_correction = TRUE //corrects nearsightedness

/obj/item/clothing/glasses/regular/jamjar
	name = "jamjar очки"
	desc = "Также известные как Защитники Девственности."
	icon_state = "jamjar_glasses"
	inhand_icon_state = "jamjar_glasses"

/obj/item/clothing/glasses/regular/hipster
	name = "очки по рецепту"
	desc = "Разработаны компанией НеКруто."
	icon_state = "hipster_glasses"
	inhand_icon_state = "hipster_glasses"

/obj/item/clothing/glasses/regular/circle
	name = "круглые очки"
	desc = "Почему вы носите что-то такое противоречивое, но такое смелое?"
	icon_state = "circle_glasses"
	inhand_icon_state = "circle_glasses"

//Here lies green glasses, so ugly they died. RIP

/obj/item/clothing/glasses/sunglasses
	name = "солнцезащитные очки"
	desc = "Как ни странно древняя технология используется, чтобы помочь обеспечить элементарное покрытие глаз. Неплохо глушит яркие вспышки."
	icon_state = "sun"
	inhand_icon_state = "sunglasses"
	darkness_view = 1
	flash_protect = FLASH_PROTECTION_FLASH
	tint = 1
	glass_colour_type = /datum/client_colour/glass_colour/gray
	dog_fashion = /datum/dog_fashion/head

/obj/item/clothing/glasses/sunglasses/reagent
	name = "пивные очки"
	icon_state = "sunhudbeer"
	desc = "Пара солнцезащитных очков оснащена аппаратом для сканирования реагентов, а также обеспечивает врожденное понимание вязкости жидкости во время движения."
	clothing_traits = list(TRAIT_BOOZE_SLIDER, TRAIT_REAGENT_SCANNER)

/obj/item/clothing/glasses/sunglasses/garb
	name = "чёрные гар очки"
	desc = "Выйди за пределы невозможного и пни здравый смысл на обочину."
	icon_state = "garb"
	inhand_icon_state = "garb"
	force = 10
	throwforce = 10
	throw_speed = 4
	attack_verb_continuous = list("режет")
	attack_verb_simple = list("режет")
	hitsound = 'sound/weapons/sword_kill_slash_01.ogg'
	sharpness = SHARP_EDGED

/obj/item/clothing/glasses/sunglasses/garb/supergarb
	name = "чёрные гига-гар очки"
	desc = "Поверьте в нас, людей."
	icon_state = "supergarb"
	inhand_icon_state = "garb"
	force = 12
	throwforce = 12

/obj/item/clothing/glasses/sunglasses/gar
	name = "гар очки"
	desc = "Ты за кого меня принимаешь?!"
	icon_state = "gar"
	inhand_icon_state = "gar"
	force = 10
	throwforce = 10
	throw_speed = 4
	attack_verb_continuous = list("режет")
	attack_verb_simple = list("режет")
	hitsound = 'sound/weapons/sword_kill_slash_01.ogg'
	sharpness = SHARP_EDGED
	glass_colour_type = /datum/client_colour/glass_colour/orange

/obj/item/clothing/glasses/sunglasses/gar/supergar
	name = "гига гар очки"
	desc = "Мы развиваемся. Каждый из нас — не тот, что был минуту назад! С каждым поворотом, пусть немного, но продвигаемся вперёд! Так действует спираль!"
	icon_state = "supergar"
	inhand_icon_state = "gar"
	force = 12
	throwforce = 12
	glass_colour_type = /datum/client_colour/glass_colour/red

/obj/item/clothing/glasses/welding
	name = "сварочные очки"
	desc = "Защищает глаза от ярких вспышек; одобрены ассоциацией безумных учёных."
	icon_state = "welding-g"
	inhand_icon_state = "welding-g"
	actions_types = list(/datum/action/item_action/toggle)
	flash_protect = FLASH_PROTECTION_WELDER
	custom_materials = list(/datum/material/iron = 250)
	tint = 2
	visor_vars_to_toggle = VISOR_FLASHPROTECT | VISOR_TINT
	flags_cover = GLASSESCOVERSEYES
	glass_colour_type = /datum/client_colour/glass_colour/gray

/obj/item/clothing/glasses/welding/attack_self(mob/user)
	weldingvisortoggle(user)


/obj/item/clothing/glasses/blindfold
	name = "повязка на глаза"
	desc = "Закрывает глаза, мешая видеть."
	icon_state = "blindfold"
	inhand_icon_state = "blindfold"
	flash_protect = FLASH_PROTECTION_WELDER
	tint = 3
	darkness_view = 1
	dog_fashion = /datum/dog_fashion/head

/obj/item/clothing/glasses/blindfold/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_EYES)
		user.become_blind("blindfold_[REF(src)]")

/obj/item/clothing/glasses/blindfold/dropped(mob/living/carbon/human/user)
	..()
	user.cure_blind("blindfold_[REF(src)]")

/obj/item/clothing/glasses/trickblindfold
	name = "повязка на глаза"
	desc = "Прозрачная повязка на глаза отлично подойдет для жульничества в играх, например приколоть шокер клоуну." //блять, чё
	icon_state = "trickblindfold"
	inhand_icon_state = "blindfold"

/obj/item/clothing/glasses/blindfold/white
	name = "повязка на глаза"
	desc = "Указывает, что владелец страдает от слепоты."
	icon_state = "blindfoldwhite"
	inhand_icon_state = "blindfoldwhite"
	var/colored_before = FALSE

/obj/item/clothing/glasses/blindfold/white/equipped(mob/living/carbon/human/user, slot)
	if(ishuman(user) && slot == ITEM_SLOT_EYES)
		update_icon(user)
		user.update_inv_glasses() //Color might have been changed by update_icon.
	..()

/obj/item/clothing/glasses/blindfold/white/update_icon(mob/living/carbon/human/user)
	. = ..()
	if(ishuman(user) && !colored_before)
		add_atom_colour("#[user.eye_color_left]", FIXED_COLOUR_PRIORITY)
		colored_before = TRUE

/obj/item/clothing/glasses/blindfold/white/worn_overlays(mutable_appearance/standing, isinhands = TRUE, icon_file)
	. = ..()
	if(!isinhands && ishuman(loc) && !colored_before)
		var/mob/living/carbon/human/H = loc
		var/mutable_appearance/M = mutable_appearance('icons/mob/clothing/eyes.dmi', "blindfoldwhite")
		M.appearance_flags |= RESET_COLOR
		M.color = "#[H.eye_color_left]"
		. += M

/obj/item/clothing/glasses/sunglasses/big
	desc = "Как ни странно древняя технология используется, чтобы помочь обеспечить элементарное покрытие глаз. Неплохо глушит яркие вспышки."
	icon_state = "bigsunglasses"
	inhand_icon_state = "bigsunglasses"

/obj/item/clothing/glasses/thermal
	name = "оптический тепловой сканер"
	desc = "Термические датчики в форме очков."
	icon_state = "thermal"
	inhand_icon_state = "glasses"
	vision_flags = SEE_MOBS
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	flash_protect = FLASH_PROTECTION_SENSITIVE
	glass_colour_type = /datum/client_colour/glass_colour/red

/obj/item/clothing/glasses/thermal/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	thermal_overload()

/obj/item/clothing/glasses/thermal/xray
	name = "рентгеновские очки синдиката"
	desc = "Пара рентгеновских очков, изготовленных Синдикатом."
	vision_flags = SEE_TURFS|SEE_MOBS|SEE_OBJS

/obj/item/clothing/glasses/thermal/syndi	//These are now a traitor item, concealed as mesons.	-Pete
	name = "хамелеонные тепловые очки"
	desc = "Пара термооптических очков с бортовым генератором хамелеона."

	var/datum/action/item_action/chameleon/change/chameleon_action

/obj/item/clothing/glasses/thermal/syndi/Initialize(mapload)
	. = ..()
	chameleon_action = new(src)
	chameleon_action.chameleon_type = /obj/item/clothing/glasses
	chameleon_action.chameleon_name = "Очки"
	chameleon_action.chameleon_blacklist = typecacheof(/obj/item/clothing/glasses/changeling, only_root_path = TRUE)
	chameleon_action.initialize_disguises()
	add_item_action(chameleon_action)

/obj/item/clothing/glasses/thermal/syndi/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	chameleon_action.emp_randomise()

/obj/item/clothing/glasses/thermal/monocle
	name = "термонокль"
	desc = "Никогда еще видение сквозь стены не чувствовалось так нежно."
	icon_state = "thermoncle"
	flags_1 = null //doesn't protect eyes because it's a monocle, duh

/obj/item/clothing/glasses/thermal/monocle/examine(mob/user) //Different examiners see a different description!
	if(user.gender == MALE)
		desc = replacetext(desc, "person", "мужчина")
	else if(user.gender == FEMALE)
		desc = replacetext(desc, "person", "женщина")
	. = ..()
	desc = initial(desc)

/obj/item/clothing/glasses/thermal/eyepatch
	name = "оптическая тепловая повязка"
	desc = "Повязка со встроенной термооптикой."
	icon_state = "eyepatch"
	inhand_icon_state = "eyepatch"

/obj/item/clothing/glasses/cold
	name = "холодные очки"
	desc = "Пара защитных очков предназначена для низких температур."
	icon_state = "cold"
	inhand_icon_state = "cold"

/obj/item/clothing/glasses/heat
	name = "тепловые очки"
	desc = "Пара защитных очков предназначена для высоких температур."
	icon_state = "heat"
	inhand_icon_state = "heat"

/obj/item/clothing/glasses/orange
	name = "оранжевые очки"
	desc = "Сладкая пара оранжевых оттенков."
	icon_state = "orangeglasses"
	inhand_icon_state = "orangeglasses"
	glass_colour_type = /datum/client_colour/glass_colour/lightorange

/obj/item/clothing/glasses/red
	name = "красные очки"
	desc = "Выглядишь круто, сенпай!"
	icon_state = "redglasses"
	inhand_icon_state = "redglasses"
	glass_colour_type = /datum/client_colour/glass_colour/red

/obj/item/clothing/glasses/geist_gazers
	name = "geist gazers"
	icon_state = "geist_gazers"
	worn_icon_state = "geist_gazers"
	glass_colour_type = /datum/client_colour/glass_colour/green

/obj/item/clothing/glasses/psych
	name = "psych glasses"
	icon_state = "psych_glasses"
	worn_icon_state = "psych_glasses"
	glass_colour_type = /datum/client_colour/glass_colour/red

/obj/item/clothing/glasses/debug
	name = "отладочные очки"
	desc = "Медицинский, охранный и диагностический HUD. Alt+лкм чтобы включить/выключить рентген."
	icon_state = "nvgmeson"
	inhand_icon_state = "nvgmeson"
	flags_cover = GLASSESCOVERSEYES
	darkness_view = 8
	flash_protect = FLASH_PROTECTION_WELDER
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	glass_colour_type = FALSE
	clothing_traits = list(TRAIT_REAGENT_SCANNER, TRAIT_RESEARCH_SCANNER)
	vision_flags = SEE_TURFS
	var/list/hudlist = list(DATA_HUD_MEDICAL_ADVANCED, DATA_HUD_DIAGNOSTIC_ADVANCED, DATA_HUD_SECURITY_ADVANCED)
	var/xray = FALSE

/obj/item/clothing/glasses/debug/equipped(mob/user, slot)
	. = ..()
	if(slot != ITEM_SLOT_EYES)
		return
	if(ishuman(user))
		for(var/hud in hudlist)
			var/datum/atom_hud/H = GLOB.huds[hud]
			H.show_to(user)
		ADD_TRAIT(user, TRAIT_MEDICAL_HUD, GLASSES_TRAIT)
		ADD_TRAIT(user, TRAIT_SECURITY_HUD, GLASSES_TRAIT)

/obj/item/clothing/glasses/debug/dropped(mob/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_MEDICAL_HUD, GLASSES_TRAIT)
	REMOVE_TRAIT(user, TRAIT_SECURITY_HUD, GLASSES_TRAIT)
	if(ishuman(user))
		for(var/hud in hudlist)
			var/datum/atom_hud/H = GLOB.huds[hud]
			H.hide_from(user)

/obj/item/clothing/glasses/debug/AltClick(mob/user)
	. = ..()
	if(ishuman(user))
		if(xray)
			vision_flags -= SEE_MOBS|SEE_OBJS
		else
			vision_flags += SEE_MOBS|SEE_OBJS
		xray = !xray
		var/mob/living/carbon/human/H = user
		H.update_sight()

/obj/item/clothing/glasses/osi
	name = "солнцезащитные очки O.S.I."
	desc = "У нас вообще нет хороших новостей! Только плохие... и ужасные.."
	icon_state = "osi_glasses"
	inhand_icon_state = "osi_glasses"

/obj/item/clothing/glasses/phantom
	name = "Phantom Thief Mask"
	desc = "Lookin' cool."
	icon_state = "phantom_glasses"
	inhand_icon_state = "phantom_glasses"

/obj/item/clothing/glasses/nightmare_vision
	name = "nightmare vision goggles"
	desc = "They give off a putrid stench. Seemingly no effect on anything."
	icon_state = "nightmare"
	inhand_icon_state = "glasses"
	glass_colour_type = /datum/client_colour/glass_colour/nightmare
	forced_glass_color = TRUE

/obj/item/clothing/glasses/regular/kim
	name = "binoclard lenses"
	desc = "Shows you know how to sew a lapel and center a back vent."
	icon_state = "binoclard_lenses"
	inhand_icon_state = "binoclard_lenses"

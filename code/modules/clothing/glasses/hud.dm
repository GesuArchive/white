/obj/item/clothing/glasses/hud
	name = "интерфейс"
	desc = "Главный экран, который предоставляет важную информацию в (почти) реальном времени."
	flags_1 = null //doesn't protect eyes because it's a monocle, duh
	var/hud_type = null
	///Used for topic calls. Just because you have a HUD display doesn't mean you should be able to interact with stuff.
	var/hud_trait = null


/obj/item/clothing/glasses/hud/equipped(mob/living/carbon/human/user, slot)
	..()
	if(slot != ITEM_SLOT_EYES)
		return
	if(hud_type)
		var/datum/atom_hud/H = GLOB.huds[hud_type]
		H.show_to(user)
	if(hud_trait)
		ADD_TRAIT(user, hud_trait, GLASSES_TRAIT)

/obj/item/clothing/glasses/hud/dropped(mob/living/carbon/human/user)
	..()
	if(!istype(user) || user.glasses != src)
		return
	if(hud_type)
		var/datum/atom_hud/H = GLOB.huds[hud_type]
		H.hide_from(user)
	if(hud_trait)
		REMOVE_TRAIT(user, hud_trait, GLASSES_TRAIT)

/obj/item/clothing/glasses/hud/emp_act(severity)
	. = ..()
	if(obj_flags & EMAGGED || . & EMP_PROTECT_SELF)
		return
	obj_flags |= EMAGGED
	desc = "[desc] Дисплей слегка мигает."

/obj/item/clothing/glasses/hud/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		return
	obj_flags |= EMAGGED
	to_chat(user, span_warning("ПЗЗЗЗЗТ"))
	desc = "[desc] Дисплей слегка мигает."

/obj/item/clothing/glasses/hud/health
	name = "медицинский HUD"
	desc = "Дисплей с заголовком, который сканирует гуманоидов и предоставляет точные данные о состоянии их здоровья."
	icon_state = "healthhud"
	hud_type = DATA_HUD_MEDICAL_ADVANCED
	hud_trait = TRAIT_MEDICAL_HUD
	glass_colour_type = /datum/client_colour/glass_colour/lightblue

/obj/item/clothing/glasses/hud/health/night
	name = "медицинский HUD с ПНВ"
	desc = "Усовершенствованный медицинский дисплей, позволяющий врачам находить пациентов в полной темноте."
	icon_state = "healthhudnight"
	inhand_icon_state = "glasses"
	darkness_view = 8
	flash_protect = FLASH_PROTECTION_SENSITIVE
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	glass_colour_type = /datum/client_colour/glass_colour/green

/obj/item/clothing/glasses/hud/health/sunglasses
	name = "Тактические медицинские очки"
	desc = "Тактические очки с медицинским интерфейсом и встроенным светофильтром, защищающим глаза от ярких вспышек."
	icon_state = "sunhudmed"
	darkness_view = 1
	flash_protect = FLASH_PROTECTION_FLASH
	tint = 1
	glass_colour_type = /datum/client_colour/glass_colour/blue

/obj/item/clothing/glasses/hud/diagnostic
	name = "диагностический HUD"
	desc = "Головной дисплей, способный анализировать целостность и состояние робототехники и экзокостюмов."
	icon_state = "diagnostichud"
	hud_type = DATA_HUD_DIAGNOSTIC_BASIC
	hud_trait = TRAIT_DIAGNOSTIC_HUD
	glass_colour_type = /datum/client_colour/glass_colour/lightorange

/obj/item/clothing/glasses/hud/diagnostic/night
	name = "диагностический HUD с ПНВ"
	desc = "Диагностический интерфейс робототехника со встроенной подсветкой."
	icon_state = "diagnostichudnight"
	inhand_icon_state = "glasses"
	darkness_view = 8
	flash_protect = FLASH_PROTECTION_SENSITIVE
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	glass_colour_type = /datum/client_colour/glass_colour/green

/obj/item/clothing/glasses/hud/diagnostic/sunglasses
	name = "Тактические диагностические очки"
	desc = "Тактические очки с диагностическим интерфейсом и встроенным светофильтром, защищающим глаза от ярких вспышек."
	icon_state = "sunhuddiag"
	inhand_icon_state = "glasses"
	flash_protect = FLASH_PROTECTION_FLASH
	tint = 1

/obj/item/clothing/glasses/hud/security
	name = "HUD офицера"
	desc = "Главный дисплей, который сканирует гуманоидов в поле зрения и предоставляет точные данные о состоянии их идентификатора и записях безопасности."
	icon_state = "securityhud"
	hud_type = DATA_HUD_SECURITY_ADVANCED
	hud_trait = TRAIT_SECURITY_HUD
	glass_colour_type = /datum/client_colour/glass_colour/red

/obj/item/clothing/glasses/hud/security/chameleon
	name = "хамелеонный HUD офицера"
	desc = "Украденный HUD офицера, интегрированный с технологией хамелеона Синдиката. Обеспечивает защиту от вспышек."
	flash_protect = FLASH_PROTECTION_FLASH

	// Yes this code is the same as normal chameleon glasses, but we don't
	// have multiple inheritance, okay?
	var/datum/action/item_action/chameleon/change/chameleon_action

/obj/item/clothing/glasses/hud/security/chameleon/Initialize(mapload)
	. = ..()
	chameleon_action = new(src)
	chameleon_action.chameleon_type = /obj/item/clothing/glasses
	chameleon_action.chameleon_name = "Очки"
	chameleon_action.chameleon_blacklist = typecacheof(/obj/item/clothing/glasses/changeling, only_root_path = TRUE)
	chameleon_action.initialize_disguises()
	add_item_action(chameleon_action)

/obj/item/clothing/glasses/hud/security/chameleon/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	chameleon_action.emp_randomise()


/obj/item/clothing/glasses/hud/security/sunglasses/eyepatch
	name = "повязка на глаз с HUD"
	desc = "Головной дисплей, который подключается непосредственно к оптическому нерву пользователя, заменяя необходимость в этом бесполезном глазном яблоке."
	icon_state = "hudpatch"

/obj/item/clothing/glasses/hud/security/sunglasses
	name = "Тактические очки офицера"
	desc = "Тактические очки с интерфейсом СБ и встроенным светофильтром, защищающим глаза от ярких вспышек."
	icon_state = "sunhudsec"
	darkness_view = 1
	flash_protect = FLASH_PROTECTION_FLASH
	tint = 1
	glass_colour_type = /datum/client_colour/glass_colour/darkred

/obj/item/clothing/glasses/hud/security/night
	name = "HUD офицера с ПНВ"
	desc = "Усовершенствованный головной дисплей, который обеспечивает идентификационные данные и видение в полной темноте."
	icon_state = "securityhudnight"
	darkness_view = 8
	flash_protect = FLASH_PROTECTION_SENSITIVE
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	glass_colour_type = /datum/client_colour/glass_colour/green

/obj/item/clothing/glasses/hud/security/sunglasses/gars
	name = "тактические GAR очки"
	desc = "GAR очки с HUD."
	icon_state = "gars"
	inhand_icon_state = "garb"
	force = 10
	throwforce = 10
	throw_speed = 4
	attack_verb_continuous = list("режет")
	attack_verb_simple = list("режет")
	hitsound = 'sound/weapons/stab1.ogg'
	sharpness = SHARP_EDGED

/obj/item/clothing/glasses/hud/security/sunglasses/gars/supergars
	name = "гига HUD GAR очки"
	desc = "GIGA GAR очки с HUD."
	icon_state = "supergars"
	inhand_icon_state = "garb"
	force = 12
	throwforce = 12

/obj/item/clothing/glasses/hud/toggle
	name = "Многофункциональный интерфейс"
	desc = "Интерфейс с несколькими функциями."
	actions_types = list(/datum/action/item_action/switch_hud)

/obj/item/clothing/glasses/hud/toggle/attack_self(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/wearer = user
	if (wearer.glasses != src)
		return

	if (hud_type)
		var/datum/atom_hud/H = GLOB.huds[hud_type]
		H.hide_from(user)

	if (hud_type == DATA_HUD_MEDICAL_ADVANCED)
		hud_type = null
	else if (hud_type == DATA_HUD_SECURITY_ADVANCED)
		hud_type = DATA_HUD_MEDICAL_ADVANCED
	else
		hud_type = DATA_HUD_SECURITY_ADVANCED

	if (hud_type)
		var/datum/atom_hud/H = GLOB.huds[hud_type]
		H.show_to(user)

/datum/action/item_action/switch_hud
	name = "Switch HUD"

/obj/item/clothing/glasses/hud/toggle/thermal
	name = "тепловой HUD"
	desc = "Тепловизор в форме очков."
	icon_state = "thermal"
	hud_type = DATA_HUD_SECURITY_ADVANCED
	vision_flags = SEE_MOBS
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	glass_colour_type = /datum/client_colour/glass_colour/red

/obj/item/clothing/glasses/hud/toggle/thermal/attack_self(mob/user)
	..()
	switch (hud_type)
		if (DATA_HUD_MEDICAL_ADVANCED)
			icon_state = "meson"
			change_glass_color(user, /datum/client_colour/glass_colour/green)
		if (DATA_HUD_SECURITY_ADVANCED)
			icon_state = "thermal"
			change_glass_color(user, /datum/client_colour/glass_colour/red)
		else
			icon_state = "purple"
			change_glass_color(user, /datum/client_colour/glass_colour/purple)
	user.update_inv_glasses()

/obj/item/clothing/glasses/hud/toggle/thermal/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	thermal_overload()

/obj/item/clothing/glasses/hud/spacecop
	name = "полицейские Авиаторы"
	desc = "Чтобы чуствовать себя круто во время жестокого обращения с протестующими и меньшинствами."
	icon_state = "bigsunglasses"
	darkness_view = 1
	flash_protect = FLASH_PROTECTION_FLASH
	tint = 1
	glass_colour_type = /datum/client_colour/glass_colour/gray


/obj/item/clothing/glasses/hud/spacecop/hidden // for the undercover cop
	name = "солнцезащитные очки"
	desc = "Эти очки особенные и позволяют увидеть потенциальных преступников."
	icon_state = "sun"
	inhand_icon_state = "sunglasses"

/obj/item/clothing/glasses/hud/health/prescription
	name = "медицинские очки по рецепту"
	desc = "Здесь встроен медицинский HUD."
	icon_state = "prescmedhud"
	vision_correction = TRUE

/obj/item/clothing/glasses/hud/diagnostic/prescription
	name = "диагностические очки по рецепту"
	desc = "Здесь встроен диагностический HUD."
	icon_state = "prescdiaghud"
	vision_correction = TRUE

/obj/item/clothing/glasses/hud/security/prescription
	name = "офицерские очки по рецепту"
	desc = "Здесь встроен офицерский HUD. Не защищают от ярких вспышек."
	icon_state = "prescsechud"
	vision_correction = TRUE

// Мутации

/datum/mutation/human/self_amputation
	name = "Аутотомия"
	desc = "Позволяет существу добровольно сбросить выбранную часть тела по своему желанию."
	quality = POSITIVE
	text_gain_indication = span_notice("У меня такое ощущение что моя рука вот-вот отвалится...")
	instability = 30
	power_path = /datum/action/cooldown/spell/self_amputation

	energy_coeff = 1
	synchronizer_coeff = 1

/datum/action/cooldown/spell/self_amputation
	name = "Сброс конечности"
	desc = "Благодаря геному ящера и позволяет сбросить конечность в случае опасности, а также вырастить новую."
	button_icon_state = "autotomy"

	cooldown_time = 10 SECONDS
	spell_requirements = NONE

/datum/action/cooldown/spell/self_amputation/is_valid_target(atom/cast_on)
	return iscarbon(cast_on)

// 	Получение и потеря сопровождаются трейтом иммунитета к кровотечению при потере конечности
/datum/mutation/human/self_amputation/on_acquiring(user)
	. = ..()
	var/mob/living/carbon/C = user
	C.dismember_bleed_block = TRUE

/datum/mutation/human/self_amputation/on_losing(user)
	. = ..()
	var/mob/living/carbon/C = user
	C.dismember_bleed_block = FALSE

// 	Последствия выростания
/datum/action/cooldown/spell/self_amputation/proc/grown(user)
	var/mob/living/carbon/C = user
	to_chat(C, span_notice("Конечность вырастает прямо на глазах, но это очень больно!"))
	playsound(C, 'sound/surgery/organ2.ogg', 100, TRUE)
	C.emote("agony")
	C.Knockdown(5 SECONDS)
	C.Paralyze(2 SECONDS)
	C.adjust_nutrition(-50)
	C.hydration = C.hydration - 50
	C.blood_volume = C.blood_volume - 25

/datum/action/cooldown/spell/self_amputation/cast(mob/living/carbon/cast_on)
	. = ..()
	if(!iscarbon(cast_on))
		return

	var/mob/living/carbon/C = cast_on

	var/static/list/choices = list(
			"Подсказка" 			= image(icon = 'icons/obj/bureaucracy.dmi', icon_state = "paper_stack_words"),
			"Левая рука" 			= image(icon = 'icons/mob/human_parts.dmi', icon_state = "default_human_l_arm"),
			"Левая нога" 			= image(icon = 'icons/mob/human_parts.dmi', icon_state = "default_human_l_leg"),
			"Правая нога" 			= image(icon = 'icons/mob/human_parts.dmi', icon_state = "default_human_r_leg"),
			"Правая рука" 			= image(icon = 'icons/mob/human_parts.dmi', icon_state = "default_human_r_arm")
			)
	var/choice = show_radial_menu(cast_on, cast_on, choices, tooltips = TRUE)
	if(!choice)
		return
	switch(choice)
		if("Подсказка")	//	На самом деле тут не нужна подсказка, просто я не знаю как повернуть это меню на 45 градусов
			to_chat(C, span_notice("Благодаря геному ящера и позволяет сбросить конечность в случае опасности, а также вырастить новую. Так же создает мембранные клапаны в системе кровообращения, предотвращающие кровотечение при потере конечностей. Для выращивания новой конечности требуется много сил, питательного материала и крови, а так же это весьма болезненно."))
	switch(choice)
		if("Правая рука")

			var/obj/item/bodypart/r_arm/part
			for(var/org in C.bodyparts)
				if(istype(org, /obj/item/bodypart/r_arm))
					part = org
					break

			if(!part)
				C.regenerate_limb(BODY_ZONE_R_ARM, 1)
				C.apply_damage(damage = 20, damagetype = BRUTE, def_zone = BODY_ZONE_R_ARM)
				grown(C)
				return

			part.dismember()

		if("Правая нога")

			var/obj/item/bodypart/r_leg/part
			for(var/org in C.bodyparts)
				if(istype(org, /obj/item/bodypart/r_leg))
					part = org
					break

			if(!part)
				C.regenerate_limb(BODY_ZONE_R_LEG, 1)
				C.apply_damage(damage = 20, damagetype = BRUTE, def_zone = BODY_ZONE_R_LEG)
				grown(C)
				return

			part.dismember()

		if("Левая нога")

			var/obj/item/bodypart/l_leg/part
			for(var/org in C.bodyparts)
				if(istype(org, /obj/item/bodypart/l_leg))
					part = org
					break

			if(!part)
				C.regenerate_limb(BODY_ZONE_L_LEG, 1)
				C.apply_damage(damage = 20, damagetype = BRUTE, def_zone = BODY_ZONE_L_LEG)
				grown(C)
				return

			part.dismember()

		if("Левая рука")

			var/obj/item/bodypart/l_arm/part
			for(var/org in C.bodyparts)
				if(istype(org, /obj/item/bodypart/l_arm))
					part = org
					break

			if(!part)
				C.regenerate_limb(BODY_ZONE_L_ARM, 1)
				C.apply_damage(damage = 20, damagetype = BRUTE, def_zone = BODY_ZONE_L_ARM)
				grown(C)
				return

			part.dismember()

	return TRUE

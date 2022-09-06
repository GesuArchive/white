/obj/effect/mob_spawn/human/donate
	name = "платно"
	desc = "ПЛАТНО - ЗНАЧИТ НУЖНО ПЛАТИТЬ!"
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "shiz"
	roundstart = FALSE
	death = FALSE
	var/req_sum = 500

/obj/effect/mob_spawn/human/donate/vv_edit_var(var_name, var_value)
	if (var_name == NAMEOF(src, req_sum))
		return FALSE
	. = ..()

/obj/effect/mob_spawn/human/donate/attack_ghost(mob/user)
	if(check_donations_avail(user?.ckey) >= req_sum)
		. = ..()
	else
		to_chat(user, span_warning("Эта роль требует <b>[req_sum]</b> донат-поинтов для доступа."))
		return

/obj/effect/mob_spawn/human/donate/yohei
	name = "Точка входа Йохеев"
	desc = "Чудесные технологии!"
	invisibility = 60
	density = FALSE
	icon_state = "yohei_spawn"
	short_desc = "Что-то интересное?"
	flavour_text = "Наёмник посреди открытого космоса, до чего жизнь довела!"
	outfit = /datum/outfit/yohei
	assignedrole = "Yohei"
	req_sum = 1250
	uses = 16
	radial_based = TRUE
	banType = ROLE_YOHEI

/obj/effect/mob_spawn/human/donate/yohei/attack_ghost(mob/user)
	if(GLOB.migger_alarm)
		to_chat(user, span_userdanger("Последнюю капсулу направлявшуюся сюда недавно сбили в этом секторе. Похоже, пока лететь точно не стоит."))
		return
	var/static/list/choices = list(
		"Медик" 	= image(icon = 'white/valtos/icons/objects.dmi', icon_state = "ymedic"),
		"Боевик" 	= image(icon = 'white/valtos/icons/objects.dmi', icon_state = "ycombatant"),
		"Взломщик" 	= image(icon = 'white/valtos/icons/objects.dmi', icon_state = "ybreaker"),
		"Разведчик" = image(icon = 'white/valtos/icons/objects.dmi', icon_state = "yprospector")
		)
	var/choice = show_radial_menu(user, src, choices, tooltips = TRUE)
	if(!choice)
		return
	switch(choice)
		if("Медик")
			outfit = /datum/outfit/yohei/medic
			assignedrole = "Yohei: Medic"
		if("Боевик")
			outfit = /datum/outfit/yohei/combatant
			assignedrole = "Yohei: Combatant"
		if("Взломщик")
			outfit = /datum/outfit/yohei/breaker
			assignedrole = "Yohei: Breaker"
		if("Разведчик")
			outfit = /datum/outfit/yohei/prospector
			assignedrole = "Yohei: Prospector"
	. = ..()

/obj/effect/mob_spawn/human/donate/yohei/special(mob/living/carbon/human/H)
	var/datum/donator/D = get_donator(H.ckey)
	if(D)
		D.money -= req_sum

	if(!H)
		return

	var/client/C = H?.client
	C?.prefs?.copy_to(H, TRUE, FALSE, FALSE, TRUE, TRUE)

	if(SSticker.mode.config_tag == "extended" || SSticker.mode.config_tag == "teaparty")
		to_chat(H, span_userdanger("Так как в этом мире насилия не существует, кодекс запрещает мне проявлять враждебность ко всем живым существам."))
		ADD_TRAIT(H, TRAIT_PACIFISM, "yohei")

	var/newname = sanitize_name(reject_bad_text(stripped_input(H, "Меня когда-то звали [H.name]. Пришло время снова сменить прозвище?", "Прозвище", H.name, MAX_NAME_LEN)))
	if (!newname)
		return
	H.fully_replace_character_name(H.name, newname)

	var/obj/item/book/B = locate(/obj/item/book/yohei_codex) in H
	B?.on_read(H)

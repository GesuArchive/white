#define CHALLENGE_TELECRYSTALS 30
#define CHALLENGE_TIME_LIMIT 3000
#define CHALLENGE_MIN_PLAYERS 20
#define CHALLENGE_SHUTTLE_DELAY 15000 // 25 minutes, so the ops have at least 5 minutes before the shuttle is callable.

/obj/item/nuclear_challenge
	name = "Объявление войны (Challenge Mode)"
	icon = 'icons/obj/device.dmi'
	icon_state = "gangtool-red"
	inhand_icon_state = "radio"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	desc = "Аппарат для объявления войны. Используйте его, чтобы объявить ваше намерение вести боевые действия на станции противника. \
			Это задержит ваш шаттл на 20 минут, давая экипажу время на подготовку, однако это привлечет внимание некоторых влиятельных фигур в Синдикате, которые поддержат вас большим количеством телекристаллов. \
			Должно быть использовано не позже, чем через 5 минут, иначе благодетели потеряют интерес."
	var/declaring_war = FALSE
	var/uplink_type = /obj/item/uplink/nuclear

/obj/item/nuclear_challenge/attack_self(mob/living/user)
	if(!check_allowed(user))
		return

	declaring_war = TRUE
	var/are_you_sure = tgui_alert(user, "Спросите своих товарищей по команде перед тем, как объявить войну [station_name()]]. Вы уверены в своем выборе? У вас осталось [DisplayTimeText(world.time-SSticker.round_start_time - CHALLENGE_TIME_LIMIT)] для решения.", "ОБЪЯВИТЬ ВОЙНУ?", list("Да", "Нет"))
	declaring_war = FALSE

	if(!check_allowed(user))
		return

	if(are_you_sure == "Нет")
		to_chat(user, "Какой же я трус...")
		return

	var/war_declaration = "Штурмовая боевая группа Синдиката объявляют о своем намерении полностью уничтожить [station_name()] с помощью ядерного устройства, и УМОЛЯЕТ членов экипажа остановить их."

	declaring_war = TRUE
	var/custom_threat = tgui_alert(user, "Хотите написать что-то свое?", "Кастомизируем?", list("Да", "Нет"))
	declaring_war = FALSE

	if(!check_allowed(user))
		return

	if(custom_threat == "Да")
		declaring_war = TRUE
		war_declaration = stripped_input(user, "Пишем!", "Объявление")
		declaring_war = FALSE

	if(!check_allowed(user) || !war_declaration)
		return

	priority_announce(war_declaration, title = "Объявление войны", sound = ANNOUNCER_WAR, has_important_message = TRUE, sender_override = "Синдикат")

	to_chat(user, "Вы привлекли внимание крайне могущественных фигур в Синдикате. Ваша команда получила бонусные телекристаллы. Великие вещи ждут вас после выполнения миссии.")

	for(var/V in GLOB.syndicate_shuttle_boards)
		var/obj/item/circuitboard/computer/syndicate_shuttle/board = V
		board.challenge = TRUE

	distribute_tc()

//	GLOB.shuttle_docking_jammed = TRUE

	CONFIG_SET(number/shuttle_refuel_delay, max(CONFIG_GET(number/shuttle_refuel_delay), CHALLENGE_SHUTTLE_DELAY))
	SSblackbox.record_feedback("amount", "nuclear_challenge_mode", 1)

	qdel(src)

///Admin only proc to bypass checks and force a war declaration. Button on antag panel.
/obj/item/nuclear_challenge/proc/force_war()
	var/are_you_sure = tgui_alert(usr, "Are you sure you wish to force a war declaration?", "Declare war?", list("Yes", "No"))

	if(are_you_sure != "Yes")
		return

	var/war_declaration = "A syndicate fringe group has declared their intent to utterly destroy [station_name()] with a nuclear device, and dares the crew to try and stop them."

	var/custom_threat = tgui_alert(usr, "Do you want to customize the declaration?", "Customize?", list("Yes", "No"))

	if(custom_threat == "Yes")
		war_declaration = stripped_input(usr, "Insert your custom declaration", "Declaration")

	if(!war_declaration)
		to_chat(usr, span_warning("Invalid war declaration."))
		return

	priority_announce(war_declaration, title = "Объявление войны", sound = sound('sound/machines/alarm.ogg'), has_important_message = TRUE)

	for(var/V in GLOB.syndicate_shuttle_boards)
		var/obj/item/circuitboard/computer/syndicate_shuttle/board = V
		board.challenge = TRUE

	distribute_tc()

//	GLOB.shuttle_docking_jammed = TRUE

	CONFIG_SET(number/shuttle_refuel_delay, max(CONFIG_GET(number/shuttle_refuel_delay), CHALLENGE_SHUTTLE_DELAY))

	qdel(src)

/obj/item/nuclear_challenge/proc/distribute_tc()
	var/list/orphans = list()
	var/list/uplinks = list()

	for (var/datum/mind/M in get_antag_minds(/datum/antagonist/nukeop))
		if (iscyborg(M.current))
			continue
		var/datum/component/uplink/uplink = M.find_syndicate_uplink()
		if (!uplink)
			orphans += M.current
			continue
		uplinks += uplink

	var/tc_to_distribute = CHALLENGE_TELECRYSTALS

	if(GLOB.player_list.len < CHALLENGE_MIN_PLAYERS)
		tc_to_distribute = CHALLENGE_TELECRYSTALS / 2

	var/tc_per_nukie = round(tc_to_distribute / (length(orphans)+length(uplinks)))

	for (var/datum/component/uplink/uplink in uplinks)
		uplink.telecrystals += tc_per_nukie
		tc_to_distribute -= tc_per_nukie

	for (var/mob/living/L in orphans)
		var/TC = new /obj/item/stack/telecrystal(L.drop_location(), tc_per_nukie)
		to_chat(L, span_warning("Your uplink could not be found so your share of the team's bonus telecrystals has been bluespaced to your [L.put_in_hands(TC) ? "hands" : "feet"]."))
		tc_to_distribute -= tc_per_nukie

	if (tc_to_distribute > 0) // What shall we do with the remainder...
		for (var/mob/living/simple_animal/hostile/carp/cayenne/C in GLOB.mob_living_list)
			if (C.stat != DEAD)
				var/obj/item/stack/telecrystal/TC = new(C.drop_location(), tc_to_distribute)
				TC.throw_at(get_step(C, C.dir), 3, 3)
				C.visible_message(span_notice("[C] вырыгивает телекристаллы!") ,span_notice("Вы вырыгиваете телекристаллы!"))
				break


/obj/item/nuclear_challenge/proc/check_allowed(mob/living/user)
	if(declaring_war)
		to_chat(user, span_boldwarning("Вы уже объявляете войну!"))
		return FALSE
	if(!user.onSyndieBase())
		to_chat(user, span_boldwarning("Требуется быть на своей базе для объявления войны."))
		return FALSE
	if(world.time-SSticker.round_start_time > CHALLENGE_TIME_LIMIT)
		to_chat(user, span_boldwarning("Слишком поздно. Ваши благодетели заняты уже другими вещами. Придётся обходиться с тем, что имеется под рукой."))
		return FALSE
	for(var/V in GLOB.syndicate_shuttle_boards)
		var/obj/item/circuitboard/computer/syndicate_shuttle/board = V
		if(board.moved)
			to_chat(user, span_boldwarning("Шаттл был перемещен! Вы потеряли свое право объявить войну!"))
			return FALSE
	return TRUE

/obj/item/nuclear_challenge/clownops
	uplink_type = /obj/item/uplink/clownop

#undef CHALLENGE_TELECRYSTALS
#undef CHALLENGE_TIME_LIMIT
#undef CHALLENGE_MIN_PLAYERS
#undef CHALLENGE_SHUTTLE_DELAY

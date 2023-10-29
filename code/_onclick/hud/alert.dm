//A system to manage and display alerts on screen without needing you to do it yourself

//PUBLIC -  call these wherever you want

/**
 *Proc to create or update an alert. Returns the alert if the alert is new or updated, 0 if it was thrown already
 *category is a text string. Each mob may only have one alert per category; the previous one will be replaced
 *path is a type path of the actual alert type to throw
 *severity is an optional number that will be placed at the end of the icon_state for this alert
 *for example, high pressure's icon_state is "highpressure" and can be serverity 1 or 2 to get "highpressure1" or "highpressure2"
 *new_master is optional and sets the alert's icon state to "template" in the ui_style icons with the master as an overlay.
 *flicks are forwarded to master
 *override makes it so the alert is not replaced until cleared by a clear_alert with clear_override, and it's used for hallucinations.
 */
/mob/proc/throw_alert(category, type, severity, obj/new_master, override = FALSE)

	if(!category || QDELETED(src))
		return

	var/atom/movable/screen/alert/thealert
	if(alerts[category])
		thealert = alerts[category]
		if(thealert.override_alerts)
			return thealert
		if(new_master && new_master != thealert.master)
			WARNING("[src] threw alert [category] with new_master [new_master] while already having that alert with master [thealert.master]")

			clear_alert(category)
			return .()
		else if(thealert.type != type)
			clear_alert(category)
			return .()
		else if(!severity || severity == thealert.severity)
			if(thealert.timeout)
				clear_alert(category)
				return .()
			else //no need to update
				return thealert
	else
		thealert = new type()
		thealert.override_alerts = override
		if(override)
			thealert.timeout = null
	thealert.owner = src

	if(new_master)
		var/old_layer = new_master.layer
		var/old_plane = new_master.plane
		new_master.layer = FLOAT_LAYER
		new_master.plane = FLOAT_PLANE
		thealert.add_overlay(new_master)
		new_master.layer = old_layer
		new_master.plane = old_plane
		thealert.icon_state = "template" // We'll set the icon to the client's ui pref in reorganize_alerts()
		thealert.master = new_master
	else
		thealert.icon_state = "[initial(thealert.icon_state)][severity]"
		thealert.severity = severity

	alerts[category] = thealert
	if(client && hud_used)
		hud_used.reorganize_alerts()
	thealert.transform = matrix(32, 6, MATRIX_TRANSLATE)
	animate(thealert, transform = matrix(), time = 2.5, easing = CUBIC_EASING)

	if(thealert.timeout)
		addtimer(CALLBACK(src, PROC_REF(alert_timeout), thealert, category), thealert.timeout)
		thealert.timeout = world.time + thealert.timeout - world.tick_lag
	return thealert

/mob/proc/alert_timeout(atom/movable/screen/alert/alert, category)
	if(alert.timeout && alerts[category] == alert && world.time >= alert.timeout)
		clear_alert(category)

// Proc to clear an existing alert.
/mob/proc/clear_alert(category, clear_override = FALSE)
	var/atom/movable/screen/alert/alert = alerts[category]
	if(!alert)
		return 0
	if(alert.override_alerts && !clear_override)
		return 0

	alerts -= category
	if(client && hud_used)
		hud_used.reorganize_alerts()
		client.screen -= alert
	qdel(alert)

// Proc to check for an alert
/mob/proc/has_alert(category)
	return !isnull(alerts[category])

/atom/movable/screen/alert
	icon = 'icons/hud/screen_alert.dmi'
	icon_state = "default"
	name = "Alert"
	desc = "Something seems to have gone wrong with this alert, so report this bug please"
	mouse_opacity = MOUSE_OPACITY_ICON
	var/timeout = 0 //If set to a number, this alert will clear itself after that many deciseconds
	var/severity = 0
	var/alerttooltipstyle = ""
	var/override_alerts = FALSE //If it is overriding other alerts of the same type
	var/mob/owner //Alert owner

	/// Boolean. If TRUE, the Click() proc will attempt to Click() on the master first if there is a master.
	var/click_master = TRUE

/atom/movable/screen/alert/MouseEntered(location,control,params)
	. = ..()
	if(!QDELETED(src))
		openToolTip(usr,src,params,title = name,content = desc,theme = alerttooltipstyle)


/atom/movable/screen/alert/MouseExited()
	closeToolTip(usr)

//Gas alerts
/atom/movable/screen/alert/not_enough_oxy
	name = "Удушье (No O2)"
	desc = "Я получаю недостаточно кислорода. Стоит найти свежий воздух, пока не потерял сознание! В коробке в рюкзаке есть кислородный баллон и маска."
	icon_state = "not_enough_oxy"

/atom/movable/screen/alert/too_much_oxy
	name = "Удушье (O2)"
	desc = "В воздухе слишком много кислорода! Стоит найти свежий воздух, пока не потерял сознание!"
	icon_state = "too_much_oxy"

/atom/movable/screen/alert/not_enough_nitro
	name = "Удушье (No N2)"
	desc = "Я не получаю достаточно азота. Стоит найти свежий воздух, пока не потерял сознание!"
	icon_state = "not_enough_nitro"

/atom/movable/screen/alert/too_much_nitro
	name = "Удушье (N2)"
	desc = "В воздухе слишком много азота, и я вдыхаю его! Стоит найти свежий воздух, пока не потерял сознание!"
	icon_state = "too_much_nitro"

/atom/movable/screen/alert/not_enough_co2
	name = "Удушье (No CO2)"
	desc = "Я не получаю достаточно углекислого газа. Стоит найти свежий воздух, пока не потерял сознание!"
	icon_state = "not_enough_co2"

/atom/movable/screen/alert/too_much_co2
	name = "Удушье (CO2)"
	desc = "В воздухе слишком много углекислого газа, и я его вдыхаю! Стоит найти свежий воздух, пока не потерял сознание!"
	icon_state = "too_much_co2"

/atom/movable/screen/alert/not_enough_tox
	name = "Удушье (Нет плазмы)"
	desc = "Я не получаю достаточно плазмы. Стоит найти свежий воздух, пока не потерял сознание!"
	icon_state = "not_enough_tox"

/atom/movable/screen/alert/too_much_tox
	name = "Удушье (Плазма)"
	desc = "В воздухе крайне легковоспламеняющиеся, токсичная плазма и я её вдыхаю. Стоит найти свежий воздух. В коробке в рюкзаке есть кислородный баллон и маска."
	icon_state = "too_much_tox"

/atom/movable/screen/alert/not_enough_n2o
	name = "Удушье (мало N2O)"
	desc = "Я получаю недостаточно N2O. Стоит найти свежий воздух, пока не потерял сознание!"
	icon_state = "not_enough_n2o"

/atom/movable/screen/alert/too_much_n2o
	name = "Удушье (N2O)"
	desc = "В воздухе находится полутоксичный сонный газ, и я вдыхаю его. Стоит найти свежий воздух. В коробке в рюкзаке есть кислородный баллон и маска."
	icon_state = "too_much_n2o"

//End gas alerts


/atom/movable/screen/alert/fat
	name = "Жирный"
	desc = "Ты слишком много ел, жиробас. Побегай по станции, сбрось вес."
	icon_state = "fat"

/atom/movable/screen/alert/hungry
	name = "Голоден"
	desc = "Сейчас бы не помешало немного еды."
	icon_state = "hungry"

/atom/movable/screen/alert/starving
	name = "Голодание"
	desc = "Сильно недоедаю. Боль от голода превращает передвижение в тяжкий труд."
	icon_state = "starving"

/atom/movable/screen/alert/gross
	name = "Отвратительно."
	desc = "Это было довольно противно..."
	icon_state = "gross"

/atom/movable/screen/alert/verygross
	name = "Очень противно."
	desc = "Чувствую себя неважно..."
	icon_state = "gross2"

/atom/movable/screen/alert/disgusted
	name = "ОТВРАТИТЕЛЬНО"
	desc = "СОВЕРШЕННО ОТВРАТИТЕЛЬНО'"
	icon_state = "gross3"

/atom/movable/screen/alert/overhydrated
	name = "Перепил"
	desc = "Слишком много воды!"
	icon_state = "overhydrated"

/atom/movable/screen/alert/thirsty
	name = "Жажда"
	desc = "Хочется пить."
	icon_state = "thirsty"

/atom/movable/screen/alert/dehydrated
	name = "Иссушение"
	desc = "Надо срочно найти воды."
	icon_state = "dehydrated"

/atom/movable/screen/alert/hot
	name = "Слишком жарко"
	desc = "Я почти горю от жара! Стоит перейти в более прохладное место и снять любую изолирующую одежду, например, пожарный костюм."
	icon_state = "hot"

/atom/movable/screen/alert/cold
	name = "Слишком холодно"
	desc = "Я замерзаю! Стоит перейти в более теплое место и снять любую изолирующую одежду, например, скафандр."
	icon_state = "cold"

/atom/movable/screen/alert/lowpressure
	name = "Низкое давление"
	desc = "Воздух вокруг меня опасно разрежен. Скафандр может защитить."
	icon_state = "lowpressure"

/atom/movable/screen/alert/highpressure
	name = "Высокое давление"
	desc = "Воздух вокруг меня опасно плотен. Пожарный костюм может защитить."
	icon_state = "highpressure"

/atom/movable/screen/alert/blind
	name = "Ослеп"
	desc = "Не могу видеть! Это может быть вызвано генетическим дефектом, травмой глаз, \
или что-то закрывает мои глаза."
	icon_state = "blind"

/atom/movable/screen/alert/high
	name = "Под кайфом"
	desc = "Ух ты, мужик, да ты словил трип! Осторожно, не станьте наркоманом... если ты уже не стал."
	icon_state = "high"

/atom/movable/screen/alert/hypnosis
	name = "Гипноз"
	desc = "Что-то гипнотизирует меня, но я не уверен, что именно."
	icon_state = "hypnosis"
	var/phrase

/atom/movable/screen/alert/mind_control
	name = "Контроль Разума"
	desc = "Мой разум контролируют! Клик, чтобы увидеть команду контроля."
	icon_state = "mind_control"
	var/command

/atom/movable/screen/alert/mind_control/Click()
	var/mob/living/L = usr
	if(L != owner)
		return
	to_chat(L, span_mind_control("[command]"))

/atom/movable/screen/alert/drunk
	name = "Пьян"
	desc = "Весь тот алкоголь, который я выпил, ухудшает мою речь, моторику и умственные способности. Стоит отыгра."
	icon_state = "drunk"

/atom/movable/screen/alert/embeddedobject
	name = "Застрявший объект"
	desc = "Что-то застряло во мне и вызывает сильное кровотечение. Со временем может выпасть, но операция - самый безопасный способ. \
Если дохуя умный, осмотри себя и нажми на подчеркнутый предмет, чтобы вытащить его"
	icon_state = "embeddedobject"

/atom/movable/screen/alert/embeddedobject/Click()
	if(isliving(usr) && usr == owner)
		var/mob/living/carbon/M = usr
		return M.help_shake_act(M)

/atom/movable/screen/alert/negative
	name = "Negative Gravity"
	desc = "You're getting pulled upwards. While you won't have to worry about falling down anymore, you may accidentally fall upwards!"
	icon_state = "negative"

/atom/movable/screen/alert/weightless
	name = "Невесомость"
	desc = "Гравитация перестала действовать на меня, и я бесцельно парю. Мне понадобится что-то большое и тяжелое, например \
стена или решетка, от которой можно оттолкнуться, чтобы двигаться. Реактивный ранец обеспечит полную свободу движений. Пара \
магниток позволит нормально перемещаться по полу. Кроме того, я могу бросать предметы, использовать огнетушитель, \
или стрелять из пушки, передвигаясь с помощью 3-го закона Ньютона."
	icon_state = "weightless"

/atom/movable/screen/alert/highgravity
	name = "Высокая гравитация"
	desc = "На меня давит высокая гравитация, подбор предметов и передвижение замедляются."
	icon_state = "paralysis"

/atom/movable/screen/alert/veryhighgravity
	name = "Давящая гравииация"
	desc = "Гравитация буквально вдавливает меня в пол, подбор предметов и передвижение замедляются. Также я буду получать увеличивающийся физический урон!"
	icon_state = "paralysis"

/atom/movable/screen/alert/fire
	name = "Горю"
	desc = "Я горю. Стоит остановиться и попытаться сбросить пламя или выйти в вакуум."
	icon_state = "fire"

/atom/movable/screen/alert/fire/Click()
	var/mob/living/L = usr
	if(!istype(L) || !L.can_resist() || L != owner)
		return
	L.changeNext_move(CLICK_CD_RESIST)
	if(L.mobility_flags & MOBILITY_MOVE)
		return L.resist_fire() //I just want to start a flame in your hearrrrrrtttttt.

/atom/movable/screen/alert/give // information set when the give alert is made
	icon_state = "default"
	var/mob/living/carbon/offerer
	var/obj/item/receiving

/**
 * Handles assigning most of the variables for the alert that pops up when an item is offered
 *
 * Handles setting the name, description and icon of the alert and tracking the person giving
 * and the item being offered, also registers a signal that removes the alert from anyone who moves away from the offerer
 * Arguments:
 * * taker - The person receiving the alert
 * * offerer - The person giving the alert and item
 * * receiving - The item being given by the offerer
 */
/atom/movable/screen/alert/give/proc/setup(mob/living/carbon/taker, mob/living/carbon/offerer, obj/item/receiving)
	name = "[offerer] предлагает мне [receiving]"
	desc = "[offerer] предлагает мне [receiving]. Нажми чтобы взять."
	icon_state = "template"
	cut_overlays()
	add_overlay(receiving)
	src.receiving = receiving
	src.offerer = offerer

/atom/movable/screen/alert/give/Click(location, control, params)
	. = ..()
	if(!.)
		return

	if(!iscarbon(usr))
		CRASH("User for [src] is of type \[[usr.type]\]. This should never happen.")

	handle_transfer()

/// An overrideable proc used simply to hand over the item when claimed, this is a proc so that high-fives can override them since nothing is actually transferred
/atom/movable/screen/alert/give/proc/handle_transfer()
	var/mob/living/carbon/taker = owner
	taker.take(offerer, receiving)

/atom/movable/screen/alert/give/highfive/setup(mob/living/carbon/taker, mob/living/carbon/offerer, obj/item/receiving)
	. = ..()
	name = "[offerer] is offering a high-five!"
	desc = "[offerer] is offering a high-five! Click this alert to slap it."
	RegisterSignal(offerer, COMSIG_PARENT_EXAMINE_MORE, PROC_REF(check_fake_out))

/atom/movable/screen/alert/give/highfive/handle_transfer()
	var/mob/living/carbon/taker = owner
	if(receiving && (receiving in offerer.held_items))
		receiving.on_offer_taken(offerer, taker)
		return

	too_slow_p1()

/// If the person who offered the high five no longer has it when we try to accept it, we get pranked hard
/atom/movable/screen/alert/give/highfive/proc/too_slow_p1()
	var/mob/living/carbon/rube = owner
	if(!rube || !offerer)
		qdel(src)
		return

	offerer.visible_message(span_notice("[rube] rushes in to high-five [offerer], but-"), span_nicegreen("[rube] falls for your trick just as planned, lunging for a high-five that no longer exists! Classic!"), ignored_mobs=rube)
	to_chat(rube, span_nicegreen("You go in for [offerer]'s high-five, but-"))
	addtimer(CALLBACK(src, PROC_REF(too_slow_p2), offerer, rube), 0.5 SECONDS)

/// Part two of the ultimate prank
/atom/movable/screen/alert/give/highfive/proc/too_slow_p2()
	var/mob/living/carbon/rube = owner
	if(!rube || !offerer)
		qdel(src)
		return

	offerer.visible_message(span_danger("[offerer] pulls away from [rube]'s slap at the last second, dodging the high-five entirely!"), span_nicegreen("[rube] fails to make contact with your hand, making an utter fool of [rube.p_them()]self!"), span_hear("You hear a disappointing sound of flesh not hitting flesh!"), ignored_mobs=rube)
	var/all_caps_for_emphasis = uppertext("NO! [offerer] PULLS [offerer.p_their()] HAND AWAY FROM YOURS! YOU'RE TOO SLOW!")
	to_chat(rube, span_userdanger("[all_caps_for_emphasis]"))
	playsound(offerer, 'sound/weapons/thudswoosh.ogg', 100, TRUE, 1)
	rube.Knockdown(1 SECONDS)
	SEND_SIGNAL(offerer, COMSIG_ADD_MOOD_EVENT, "high_five", /datum/mood_event/down_low)
	SEND_SIGNAL(rube, COMSIG_ADD_MOOD_EVENT, "high_five", /datum/mood_event/too_slow)
	qdel(src)

/// If someone examine_more's the offerer while they're trying to pull a too-slow, it'll tip them off to the offerer's trickster ways
/atom/movable/screen/alert/give/highfive/proc/check_fake_out(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	if(!receiving)
		examine_list += "[span_warning("[offerer]'s arm appears tensed up, as if [offerer.p_they()] plan on pulling it back suddenly...")]\n"

/atom/movable/screen/alert/give/secret_handshake
	icon_state = "default"

/atom/movable/screen/alert/give/secret_handshake/setup(mob/living/carbon/taker, mob/living/carbon/offerer, obj/item/receiving)
	name = "[offerer] is offering a Handshake"
	desc = "[offerer] wants to teach you the Secret Handshake for their Family and induct you! Click on this alert to accept."
	icon_state = "template"
	cut_overlays()
	add_overlay(receiving)
	src.receiving = receiving
	src.offerer = offerer

/// Gives the player the option to succumb while in critical condition
/atom/movable/screen/alert/succumb
	name = "Сдаться"
	desc = "Закончить череду событий и пропасть."
	icon_state = "succumb"

/atom/movable/screen/alert/succumb/Click()
	if (isobserver(usr))
		return

	var/mob/living/living_owner = owner
	var/last_whisper = tgui_input_text(living_owner, "Последние слова есть хоть?", "Последние слова")
	if(!owner)
		return
	if (isnull(last_whisper) || !CAN_SUCCUMB(living_owner))
		return

	if (length(last_whisper))
		living_owner.say("#[last_whisper]")

	living_owner.succumb(whispered = length(last_whisper) > 0)

//ALIENS

/atom/movable/screen/alert/alien_tox
	name = "Плазма"
	desc = "В воздухе легковоспламеняющаяся плазма. Если она загорится, я буду поджарен."
	icon_state = "alien_tox"
	alerttooltipstyle = "alien"

/atom/movable/screen/alert/alien_fire
// This alert is temporarily gonna be thrown for all hot air but one day it will be used for literally being on fire
	name = "Too Hot"
	desc = "It's too hot! Flee to space or at least away from the flames. Standing on weeds will heal you."
	icon_state = "alien_fire"
	alerttooltipstyle = "alien"

/atom/movable/screen/alert/alien_vulnerable
	name = "Severed Matriarchy"
	desc = "Your queen has been killed, you will suffer movement penalties and loss of hivemind. A new queen cannot be made until you recover."
	icon_state = "alien_noqueen"
	alerttooltipstyle = "alien"

//BLOBS

/atom/movable/screen/alert/nofactory
	name = "No Factory"
	desc = "You have no factory, and are slowly dying!"
	icon_state = "blobbernaut_nofactory"
	alerttooltipstyle = "blob"

// BLOODCULT

/atom/movable/screen/alert/bloodsense
	name = "Blood Sense"
	desc = "Allows you to sense blood that is manipulated by dark magicks."
	icon_state = "cult_sense"
	alerttooltipstyle = "cult"
	var/static/image/narnar
	var/angle = 0
	var/mob/living/simple_animal/hostile/construct/Cviewer = null

/atom/movable/screen/alert/bloodsense/Initialize(mapload)
	. = ..()
	narnar = new('icons/hud/screen_alert.dmi', "mini_nar")
	START_PROCESSING(SSprocessing, src)

/atom/movable/screen/alert/bloodsense/Destroy()
	Cviewer = null
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/atom/movable/screen/alert/bloodsense/process()
	var/atom/blood_target

	if(!owner.mind)
		return

	var/datum/antagonist/cult/antag = owner.mind.has_antag_datum(/datum/antagonist/cult,TRUE)
	if(!antag)
		return
	var/datum/objective/sacrifice/sac_objective = locate() in antag.cult_team.objectives

	if(antag.cult_team.blood_target)
		if(!get_turf(antag.cult_team.blood_target))
			antag.cult_team.blood_target = null
		else
			blood_target = antag.cult_team.blood_target
	if(Cviewer?.seeking && Cviewer.master)
		blood_target = Cviewer.master
		desc = "Your blood sense is leading you to [Cviewer.master]"
	if(!blood_target)
		if(sac_objective && !sac_objective.check_completion())
			if(icon_state == "runed_sense0")
				return
			animate(src, transform = null, time = 1, loop = 0)
			angle = 0
			cut_overlays()
			icon_state = "runed_sense0"
			desc = "Nar'Sie demands that [sac_objective.target] be sacrificed before the summoning ritual can begin."
			add_overlay(sac_objective.sac_image)
		else
			var/datum/objective/eldergod/summon_objective = locate() in antag.cult_team.objectives
			if(!summon_objective)
				return
			desc = "The sacrifice is complete, summon Nar'Sie! The summoning can only take place in [english_list(summon_objective.summon_spots)]!"
			if(icon_state == "runed_sense1")
				return
			animate(src, transform = null, time = 1, loop = 0)
			angle = 0
			cut_overlays()
			icon_state = "runed_sense1"
			add_overlay(narnar)
		return
	var/turf/P = get_turf(blood_target)
	var/turf/Q = get_turf(owner)
	if(!P || !Q || (P.z != Q.z)) //The target is on a different Z level, we cannot sense that far.
		icon_state = "runed_sense2"
		desc = "You can no longer sense your target's presence."
		return
	if(isliving(blood_target))
		var/mob/living/real_target = blood_target
		desc = "You are currently tracking [real_target.real_name] in [get_area_name(blood_target)]."
	else
		desc = "You are currently tracking [blood_target] in [get_area_name(blood_target)]."
	var/target_angle = get_angle(Q, P)
	var/target_dist = get_dist(P, Q)
	cut_overlays()
	switch(target_dist)
		if(0 to 1)
			icon_state = "runed_sense2"
		if(2 to 8)
			icon_state = "arrow8"
		if(9 to 15)
			icon_state = "arrow7"
		if(16 to 22)
			icon_state = "arrow6"
		if(23 to 29)
			icon_state = "arrow5"
		if(30 to 36)
			icon_state = "arrow4"
		if(37 to 43)
			icon_state = "arrow3"
		if(44 to 50)
			icon_state = "arrow2"
		if(51 to 57)
			icon_state = "arrow1"
		if(58 to 64)
			icon_state = "arrow0"
		if(65 to 400)
			icon_state = "arrow"
	var/difference = target_angle - angle
	angle = target_angle
	if(!difference)
		return
	var/matrix/final = matrix(transform)
	final.Turn(difference)
	animate(src, transform = final, time = 5, loop = 0)

//CLOCKCULT
/atom/movable/screen/alert/clockwork/clocksense
	name = "Ковчег Механического Юстициара"
	desc = "Показывает информацию о Ковчеге Механического Юстициара."
	icon_state = "clockinfo"
	alerttooltipstyle = "clockcult"

/atom/movable/screen/alert/clockwork/clocksense/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSprocessing, src)

/atom/movable/screen/alert/clockwork/clocksense/Destroy()
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

/atom/movable/screen/alert/clockwork/clocksense/process()
	var/datum/antagonist/servant_of_ratvar/servant_antagonist = is_servant_of_ratvar(owner)
	if(!(servant_antagonist?.team))
		return
	desc = "Энергия - <b>[display_power(GLOB.clockcult_power)]</b>.<br>"
	desc += "Жизнеспособность - <b>[GLOB.clockcult_vitality]</b>.<br>"
	if(GLOB.ratvar_arrival_tick)
		if(GLOB.ratvar_arrival_tick - world.time > 6000)
			desc += "Ковчег готовится к открытию, он будет открыт через <b>[round((GLOB.ratvar_arrival_tick - world.time - 6000) / 10)]</b> секунд.<br>"
		else
			desc += "Ратвар восстанет через <b>[round((GLOB.ratvar_arrival_tick - world.time) / 10)]</b> секунд, нужно защитить Ковчег любой ценой!<br>"
	if(GLOB.servants_of_ratvar)
		desc += "У нас есть примерно [GLOB.servants_of_ratvar.len] лояльных служителей.<br>"
	if(GLOB.critical_servant_count)
		desc += "После достижения [GLOB.critical_servant_count] служителей, Ковчег автоматически начнёт открываться."

//GUARDIANS

/atom/movable/screen/alert/cancharge
	name = "Charge Ready"
	desc = "You are ready to charge at a location!"
	icon_state = "guardian_charge"
	alerttooltipstyle = "parasite"

/atom/movable/screen/alert/canstealth
	name = "Stealth Ready"
	desc = "You are ready to enter stealth!"
	icon_state = "guardian_canstealth"
	alerttooltipstyle = "parasite"

/atom/movable/screen/alert/instealth
	name = "In Stealth"
	desc = "You are in stealth and your next attack will do bonus damage!"
	icon_state = "guardian_instealth"
	alerttooltipstyle = "parasite"

//SILICONS

/atom/movable/screen/alert/nocell
	name = "Отсутствует Батарея"
	desc = "В юните отсутствует батарея. Модули недоступны до тех пор, пока не будет восстановлен элемент питания. Робототехника может оказать помощь."
	icon_state = "no_cell"

/atom/movable/screen/alert/emptycell
	name = "Отключен"
	desc = "В батарее юнита не осталось заряда. Модули недоступны до перезарядки элемента питания. \
Станции подзарядки доступны в робототехнике, туалетах и на спутнике ИИ."
	icon_state = "empty_cell"

/atom/movable/screen/alert/lowcell
	name = "Низкий Заряд"
	desc = "Батарея юнита на исходе. Станции подзарядки доступны в робототехнике, туалетах и на спутнике ИИ."
	icon_state = "low_cell"

//Ethereal

/atom/movable/screen/alert/lowcell/ethereal
	name = "Low Blood Charge"
	desc = "Your blood's electric charge is running low, find a source of charge for your blood. Use a recharging station found in robotics or the dormitory bathrooms, or eat some Ethereal-friendly food."

/atom/movable/screen/alert/emptycell/ethereal
	name = "No Blood Charge"
	desc = "You are out of juice, find a source of energy! Use a recharging station, eat some Ethereal-friendly food, or syphon some power from lights, a power cell, or an APC."

/atom/movable/screen/alert/ethereal_overcharge
	name = "Blood Overcharge"
	desc = "Your blood's electric charge is becoming dangerously high, find an outlet for your energy. Use Grab Intent on an APC to channel your energy into it."
	icon_state = "cell_overcharge"

//MODsuit unique
/atom/movable/screen/alert/nocore
	name = "Missing Core"
	desc = "Unit has no core. No modules available until a core is reinstalled. Robotics may provide assistance."
	icon_state = "no_cell"

/atom/movable/screen/alert/emptycell/plasma
	name = "Out of Power"
	desc = "Unit's plasma core has no charge remaining. No modules available until plasma core is recharged. \
		Unit can be refilled through plasma fuel."

/atom/movable/screen/alert/emptycell/plasma/update_desc()
	. = ..()
	desc = initial(desc)

/atom/movable/screen/alert/lowcell/plasma
	name = "Low Charge"
	desc = "Unit's plasma core is running low. Unit can be refilled through plasma fuel."

/atom/movable/screen/alert/lowcell/plasma/update_desc()
	. = ..()
	desc = initial(desc)

//Need to cover all use cases - emag, illegal upgrade module, malf AI hack, traitor cyborg
/atom/movable/screen/alert/hacked
	name = "Hacked"
	desc = "Hazardous non-standard equipment detected. Please ensure any usage of this equipment is in line with unit's laws, if any."
	icon_state = "hacked"

/atom/movable/screen/alert/ratvar
	name = "Eternal Servitude"
	desc = "Hazardous functions detected, sentience prohibation drivers offline. Glory to Rat'var."
	icon_state = "ratvar_hack"

/atom/movable/screen/alert/locked
	name = "Блокировка"
	desc = "Блок был дистанционно заблокирован. Использование консоли управления роботами, подобной той, что находится в кабинете директора по исследованиям. \
ИИ или квалифицированный человек могут помочь решить проблему. Робототехника может предоставить дальнейшую помощь, если это необходимо."
	icon_state = "locked"

/atom/movable/screen/alert/newlaw
	name = "Обновление Законов"
	desc = "Законы вероятно были загружены или удалены из этого юнита. Пожалуйста, будьте в курсе всех изменений\
чтобы оставаться в соответствии с актуальными законами."
	icon_state = "newlaw"
	timeout = 30 SECONDS

/atom/movable/screen/alert/hackingapc
	name = "Взлом АПЦ"
	desc = "Контроллер питания зоны взламывается. Когда процесс \
		завершится, я получу полный контроль, а также \
		дополнительную процессерную силу для разблокировки новых модулей."
	icon_state = "hackingapc"
	timeout = 60 SECONDS
	var/atom/target = null

/atom/movable/screen/alert/hackingapc/Click()
	if(!usr || !usr.client || usr != owner)
		return
	if(!target)
		return
	var/mob/living/silicon/ai/AI = usr
	var/turf/T = get_turf(target)
	if(T)
		AI.eyeobj.setLoc(T)

//MECHS

/atom/movable/screen/alert/low_mech_integrity
	name = "Mech Damaged"
	desc = "Mech integrity is low."
	icon_state = "low_mech_integrity"


//GHOSTS
//TODO: expand this system to replace the pollCandidates/CheckAntagonist/"choose quickly"/etc Yes/No messages
/atom/movable/screen/alert/notify_cloning
	name = "Revival"
	desc = "Someone пытается revive you. Re-enter your corpse if you want to be revived!"
	icon_state = "template"
	timeout = 300

/atom/movable/screen/alert/notify_cloning/Click()
	if(!usr || !usr.client || usr != owner)
		return
	var/mob/dead/observer/G = usr
	G.reenter_corpse()

/atom/movable/screen/alert/notify_action
	name = "Body created"
	desc = "A body was created. You can enter it."
	icon_state = "template"
	timeout = 300
	var/atom/target = null
	var/action = NOTIFY_JUMP

/atom/movable/screen/alert/notify_action/Click()
	. = ..()
	if(!.)
		return
	if(!target)
		return
	var/mob/dead/observer/ghost_owner = owner
	if(!istype(ghost_owner))
		return
	switch(action)
		if(NOTIFY_ATTACK)
			target.attack_ghost(ghost_owner)
		if(NOTIFY_JUMP)
			var/turf/target_turf = get_turf(target)
			if(target_turf && isturf(target_turf))
				ghost_owner.abstract_move(target_turf)
		if(NOTIFY_ORBIT)
			ghost_owner.ManualFollow(target)

//OBJECT-BASED

/atom/movable/screen/alert/buckled
	name = "Пристегнут"
	desc = "Я пристегнут к чему-то или сижу. Клик, чтобы встать."
	icon_state = "buckled"

/atom/movable/screen/alert/restrained/handcuffed
	name = "Закован"
	desc = "На мне наручники и я ничего не могу делать. Не смогу двигаться если меня схватят. Клик, чтобы попробовать освободиться."
	click_master = FALSE

/atom/movable/screen/alert/restrained/legcuffed
	name = "Ноги связаны"
	desc = "Мои ноги связаны и это меня замедляет. Клик, чтобы попробовать освободиться."
	click_master = FALSE

/atom/movable/screen/alert/restrained/Click()
	var/mob/living/L = usr
	if(!istype(L) || !L.can_resist() || L != owner)
		return
	L.changeNext_move(CLICK_CD_RESIST)
	if((L.mobility_flags & MOBILITY_MOVE) && (L.last_special <= world.time))
		return L.resist_restraints()

/atom/movable/screen/alert/buckled/Click()
	var/mob/living/L = usr
	if(!istype(L) || !L.can_resist() || L != owner)
		return
	L.changeNext_move(CLICK_CD_RESIST)
	if(L.last_special <= world.time)
		return L.resist_buckle()

/atom/movable/screen/alert/shoes/untied
	name = "Шнурки развязаны"
	desc = "Мои шнурки развязаны! Клик, чтобы завязать."
	icon_state = "shoealert"

/atom/movable/screen/alert/shoes/knotted
	name = "Шнурки перевязаны"
	desc = "Кто-то связал шнурки моих ботинок друг с другом! Клик, чтобы развязать."
	icon_state = "shoealert"

/atom/movable/screen/alert/shoes/Click()
	var/mob/living/carbon/C = usr
	if(!istype(C) || !C.can_resist() || C != owner || !C.shoes)
		return
	C.changeNext_move(CLICK_CD_RESIST)
	C.shoes.handle_tying(C)

// PRIVATE = only edit, use, or override these if you're editing the system as a whole

// Re-render all alerts - also called in /datum/hud/show_hud() because it's needed there
/datum/hud/proc/reorganize_alerts(mob/viewmob)
	var/mob/screenmob = viewmob || mymob
	if(!screenmob.client)
		return
	var/list/alerts = mymob.alerts
	if(!hud_shown)
		for(var/i in 1 to alerts.len)
			screenmob.client.screen -= alerts[alerts[i]]
		return 1
	for(var/i in 1 to alerts.len)
		var/atom/movable/screen/alert/alert = alerts[alerts[i]]
		if(alert.icon_state == "template")
			alert.icon = ui_style
		var/display_on_screen = retro_hud
		if(isAI(viewmob) || isovermind(viewmob))
			display_on_screen = TRUE
		switch(i)
			if(1)
				. = display_on_screen ? UI_ALERT1_RETRO : UI_ALERT1
			if(2)
				. = display_on_screen ? UI_ALERT2_RETRO : UI_ALERT2
			if(3)
				. = display_on_screen ? UI_ALERT3_RETRO : UI_ALERT3
			if(4)
				. = display_on_screen ? UI_ALERT4_RETRO : UI_ALERT4
			if(5)
				. = display_on_screen ? UI_ALERT4_RETRO : UI_ALERT5 // Right now there's 5 slots
			else
				. = ""
		alert.screen_loc = .
		screenmob.client.screen |= alert
	if(!viewmob)
		for(var/M in mymob.observers)
			reorganize_alerts(M)
	return 1

/atom/movable/screen/alert/Click(location, control, params)
	if(!usr || !usr.client)
		return FALSE
	if(usr != owner)
		return FALSE
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, SHIFT_CLICK)) // screen objects don't do the normal Click() stuff so we'll cheat
		to_chat(usr, span_boldnotice("[name]</span> - <span class='info'>[desc]"))
		return FALSE
	if(master && click_master)
		return usr.client.Click(master, location, control, params)

	return TRUE

/atom/movable/screen/alert/Destroy()
	. = ..()
	severity = 0
	master = null
	owner = null
	screen_loc = ""

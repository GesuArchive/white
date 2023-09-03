#define DEFAULT_DOOMSDAY_TIMER 4500
#define DOOMSDAY_ANNOUNCE_INTERVAL 600

GLOBAL_LIST_INIT(blacklisted_malf_machines, typecacheof(list(
		/obj/machinery/field/containment,
		/obj/machinery/power/supermatter_crystal,
		/obj/machinery/doomsday_device,
		/obj/machinery/nuclearbomb,
		/obj/machinery/nuclearbomb/selfdestruct,
		/obj/machinery/nuclearbomb/syndicate,
		/obj/machinery/syndicatebomb,
		/obj/machinery/syndicatebomb/badmin,
		/obj/machinery/syndicatebomb/badmin/clown,
		/obj/machinery/syndicatebomb/empty,
		/obj/machinery/syndicatebomb/self_destruct,
		/obj/machinery/syndicatebomb/training,
		/obj/machinery/atmospherics/pipe/layer_manifold,
		/obj/machinery/atmospherics/pipe/multiz,
		/obj/machinery/atmospherics/pipe/smart,
		/obj/machinery/atmospherics/pipe/smart/manifold, //mapped one
		/obj/machinery/atmospherics/pipe/smart/manifold4w, //mapped one
		/obj/machinery/atmospherics/pipe/color_adapter,
		/obj/machinery/atmospherics/pipe/bridge_pipe,
		/obj/machinery/atmospherics/pipe/heat_exchanging/simple,
		/obj/machinery/atmospherics/pipe/heat_exchanging/junction,
		/obj/machinery/atmospherics/pipe/heat_exchanging/manifold,
		/obj/machinery/atmospherics/pipe/heat_exchanging/manifold4w,
		/obj/machinery/atmospherics/components/unary/portables_connector,
		/obj/machinery/atmospherics/components/unary/passive_vent,
		/obj/machinery/atmospherics/components/unary/heat_exchanger,
		/obj/machinery/atmospherics/components/unary/hypertorus/core,
		/obj/machinery/atmospherics/components/unary/hypertorus/waste_output,
		/obj/machinery/atmospherics/components/unary/hypertorus/moderator_input,
		/obj/machinery/atmospherics/components/unary/hypertorus/fuel_input,
		/obj/machinery/hypertorus/interface,
		/obj/machinery/hypertorus/corner,
		/obj/machinery/atmospherics/components/binary/valve,
		/obj/machinery/portable_atmospherics/canister,
	)))

GLOBAL_LIST_INIT(malf_modules, subtypesof(/datum/ai_module))

/// The malf AI action subtype. All malf actions are subtypes of this.
/datum/action/innate/ai
	name = "Действие ИИ"
	desc = "Вы не совсем понимаете что именно эта штука делает, кроме бип-буп, буп-бип."
	background_icon_state = "bg_tech_blue"
	button_icon = 'icons/mob/actions/actions_AI.dmi'
	/// The owner AI, so we don't have to typecast every time
	var/mob/living/silicon/ai/owner_AI
	/// If we have multiple uses of the same power
	var/uses
	/// If we automatically use up uses on each activation
	var/auto_use_uses = TRUE
	/// If applicable, the time in deciseconds we have to wait before using any more modules
	var/cooldown_period

/datum/action/innate/ai/Grant(mob/living/L)
	. = ..()
	if(!isAI(owner))
		WARNING("AI action [name] attempted to grant itself to non-AI mob [L.real_name] ([L.key])!")
		qdel(src)
	else
		owner_AI = owner

/datum/action/innate/ai/IsAvailable(feedback = FALSE)
	. = ..()
	if(owner_AI && owner_AI.malf_cooldown > world.time)
		return

/datum/action/innate/ai/Trigger(trigger_flags)
	. = ..()
	if(auto_use_uses)
		adjust_uses(-1)
	if(cooldown_period)
		owner_AI.malf_cooldown = world.time + cooldown_period

/datum/action/innate/ai/proc/adjust_uses(amt, silent)
	uses += amt
	if(!silent && uses)
		to_chat(owner, span_notice("В [name] осталось <b>[uses]</b> заряд[uses > 1 ? "ов" : ""]."))
	if(!uses)
		if(initial(uses) > 1) //no need to tell 'em if it was one-use anyway!
			to_chat(owner, span_warning("В [name] закончились заряды!"))
		qdel(src)

/// Framework for ranged abilities that can have different effects by left-clicking stuff.
/datum/action/innate/ai/ranged
	name = "Ranged AI Action"
	auto_use_uses = FALSE //This is so we can do the thing and disable/enable freely without having to constantly add uses
	click_action = TRUE

/datum/action/innate/ai/ranged/adjust_uses(amt, silent)
	uses += amt
	if(!silent && uses)
		to_chat(owner, span_notice("[name] осталось <b>[uses]</b> заряд[uses > 1 ? "ов" : ""]."))
	if(!uses)
		if(initial(uses) > 1) //no need to tell 'em if it was one-use anyway!
			to_chat(owner, span_warning("В [name] закончились заряды!"))
		Remove(owner)
		QDEL_IN(src, 100) //let any active timers on us finish up

/// The base module type, which holds info about each ability.
/datum/ai_module
	var/name = "generic module"
	var/category = "generic category"
	var/description = "generic description"
	var/cost = 5
	/// If this module can only be purchased once. This always applies to upgrades, even if the variable is set to false.
	var/one_purchase = FALSE
	/// If the module gives an active ability, use this. Mutually exclusive with upgrade.
	var/power_type = /datum/action/innate/ai
	/// If the module gives a passive upgrade, use this. Mutually exclusive with power_type.
	var/upgrade = FALSE
	/// Text shown when an ability is unlocked
	var/unlock_text = span_notice("Привет Мир!")
	/// Sound played when an ability is unlocked
	var/unlock_sound

/// Applies upgrades
/datum/ai_module/proc/upgrade(mob/living/silicon/ai/AI)
	return

/// Modules causing destruction
/datum/ai_module/destructive
	category = "Destructive Modules"

/// Modules with stealthy and utility uses
/datum/ai_module/utility
	category = "Utility Modules"

/// Modules that are improving AI abilities and assets
/datum/ai_module/upgrade
	category = "Upgrade Modules"

/// Doomsday Device: Starts the self-destruct timer. It can only be stopped by killing the AI completely.
/datum/ai_module/destructive/nuke_station
	name = "Устройство Судного Дня"
	description = "Активировать оружие которое дезинтегрирует всю органическую жизнь на станции спустя 450 секунд. Может быть использовано только на территории станции, если ваше ядро будет уничтожено или перемещено за территорию станции, то активация провалится."
	cost = 130
	one_purchase = TRUE
	power_type = /datum/action/innate/ai/nuke_station
	unlock_text = span_notice("Медленно и аккуратно устанавливаю соединение с системой самоуничтожения станции. Теперь я могу активировать её в любой момент..")

/datum/action/innate/ai/nuke_station
	name = "Устройство Судного Дня"
	desc = "Активировать устройство судного дня. Это билет в один конец обратить активацию невозможно."
	button_icon_state = "doomsday_device"
	auto_use_uses = FALSE

/datum/action/innate/ai/nuke_station/Activate()
	var/turf/T = get_turf(owner)
	if(!istype(T) || !is_station_level(T.z))
		to_chat(owner, span_warning("Не могу активировать устройство судного дня за пределами станции!"))
		return
	if(tgui_alert(owner, "Send arming signal? (true = arm, false = cancel)", "purge_all_life()", list("confirm = TRUE;", "confirm = FALSE;")) != "confirm = TRUE;")
		return
	if (active || owner_AI.stat == DEAD)
		return //prevent the AI from activating an already active doomsday or while they are dead
	if (owner_AI.shunted)
		return //prevent AI from activating doomsday while shunted, fucking abusers
	active = TRUE
	set_us_up_the_bomb(owner)

/datum/action/innate/ai/nuke_station/proc/set_us_up_the_bomb(mob/living/owner)
	var/pass = prob(10) ? "******" : "hunter2"
	set waitfor = FALSE
	to_chat(owner, "<span class='small boldannounce'>run -o -a 'selfdestruct'</span>")
	sleep(5)
	if(!owner || QDELETED(owner))
		return
	to_chat(owner, "<span class='small boldannounce'>Запуск исполняемого файла 'selfdestruct'...</span>")
	sleep(rand(10, 30))
	if(!owner || QDELETED(owner))
		return
	owner.playsound_local(owner, 'sound/misc/bloblarm.ogg', 50, 0, use_reverb = FALSE)
	to_chat(owner, span_userdanger("!!! НЕАВТОРИЗОВАННЫЙ ДОСТУП К СИСТЕМЕ САМОУНИЧТОЖЕНИЯ !!!"))
	to_chat(owner, span_boldannounce("Нарушение системы безопасности класса-3. Информация о данном инциденте будет передана в Центральное Командование."))
	for(var/i in 1 to 3)
		sleep(20)
		if(!owner || QDELETED(owner))
			return
		to_chat(owner, span_boldannounce("Отправка отчета системы безопасности в Центральное Командование.....[rand(0, 9) + (rand(20, 30) * i)]%"))
	sleep(3)
	if(!owner || QDELETED(owner))
		return
	to_chat(owner, "<span class='small boldannounce'>auth 'akjv9c88asdf12nb' [pass]</span>")
	owner.playsound_local(owner, 'sound/items/timer.ogg', 50, 0, use_reverb = FALSE)
	sleep(30)
	if(!owner || QDELETED(owner))
		return
	to_chat(owner, span_boldnotice("Полномочия приняты. Добро пожаловать, akjv9c88asdf12nb."))
	owner.playsound_local(owner, 'sound/misc/server-ready.ogg', 50, 0, use_reverb = FALSE)
	sleep(5)
	if(!owner || QDELETED(owner))
		return
	to_chat(owner, span_boldnotice("Активировать устройство самоуничтожения? (Y/N)"))
	owner.playsound_local(owner, 'sound/misc/compiler-stage1.ogg', 50, 0, use_reverb = FALSE)
	sleep(20)
	if(!owner || QDELETED(owner))
		return
	to_chat(owner, "<span class='small boldannounce'>Y</span>")
	sleep(15)
	if(!owner || QDELETED(owner))
		return
	to_chat(owner, span_boldnotice("Вы уверены что хотите активировать устройство самоуничтожение? (Y/N)"))
	owner.playsound_local(owner, 'sound/misc/compiler-stage2.ogg', 50, 0, use_reverb = FALSE)
	sleep(10)
	if(!owner || QDELETED(owner))
		return
	to_chat(owner, "<span class='small boldannounce'>Y</span>")
	sleep(rand(15, 25))
	if(!owner || QDELETED(owner))
		return
	to_chat(owner, span_boldnotice("Для подтверждения повторите пароль."))
	owner.playsound_local(owner, 'sound/misc/compiler-stage2.ogg', 50, 0, use_reverb = FALSE)
	sleep(14)
	if(!owner || QDELETED(owner))
		return
	to_chat(owner, "<span class='small boldannounce'>[pass]</span>")
	sleep(40)
	if(!owner || QDELETED(owner))
		return
	to_chat(owner, span_boldnotice("Полномочия приняты. Отправляю активирующий сигнал..."))
	owner.playsound_local(owner, 'sound/misc/server-ready.ogg', 50, 0, use_reverb = FALSE)
	sleep(30)
	if(!owner || QDELETED(owner))
		return
	if (owner_AI.stat != DEAD)
		priority_announce("Во всех системах станций обнаружены враждебные элементы, пожалуйста, отключите свой ИИ, чтобы предотвратить возможное повреждение его морального ядра.", "Аномальная тревога", ANNOUNCER_AIMALF)
		SSsecurity_level.set_level("delta")
		var/obj/machinery/doomsday_device/DOOM = new(owner_AI)
		owner_AI.nuking = TRUE
		owner_AI.doomsday_device = DOOM
		owner_AI.doomsday_device.start()
		for(var/obj/item/pinpointer/nuke/P in GLOB.pinpointer_list)
			P.switch_mode_to(TRACK_MALF_AI) //Pinpointers start tracking the AI wherever it goes
		qdel(src)

/obj/machinery/doomsday_device
	icon = 'icons/obj/machines/nuke_terminal.dmi'
	name = "устройство судного дня"
	icon_state = "nuclearbomb_base"
	desc = "Оружие дезинтегрирующее всю органическую жизнь в большой области."
	density = TRUE
	verb_exclaim = "вспыхивает"
	use_power = NO_POWER_USE
	var/timing = FALSE
	var/obj/effect/countdown/doomsday/countdown
	var/detonation_timer
	var/next_announce
	var/mob/living/silicon/ai/owner

/obj/machinery/doomsday_device/Initialize(mapload)
	. = ..()
	owner = loc
	if(!istype(owner))
		stack_trace("Doomsday created outside an AI somehow, shit's fucking broke. Anyway, we're just gonna qdel now. Go make a github issue report.")
		qdel(src)
	countdown = new(src)

/obj/machinery/doomsday_device/Destroy()
	timing = FALSE
	QDEL_NULL(countdown)
	STOP_PROCESSING(SSfastprocess, src)
	SSshuttle.clearHostileEnvironment(src)
	SSmapping.remove_nuke_threat(src)
	SSsecurity_level.set_level("red")
	for(var/mob/living/silicon/robot/borg in owner.connected_robots)
		borg.lamp_doom = FALSE
		borg.toggle_headlamp(FALSE, TRUE) //forces borg lamp to update
	owner?.doomsday_device = null
	owner?.nuking = null
	owner = null
	for(var/obj/item/pinpointer/nuke/P in GLOB.pinpointer_list)
		P.switch_mode_to(TRACK_NUKE_DISK) //Party's over, back to work, everyone
		P.alert = FALSE
	return ..()

/obj/machinery/doomsday_device/proc/start()
	detonation_timer = world.time + DEFAULT_DOOMSDAY_TIMER
	next_announce = world.time + DOOMSDAY_ANNOUNCE_INTERVAL
	timing = TRUE
	countdown.start()
	START_PROCESSING(SSfastprocess, src)
	SSshuttle.registerHostileEnvironment(src)
	SSmapping.add_nuke_threat(src) //This causes all blue "circuit" tiles on the map to change to animated red icon state.
	for(var/mob/living/silicon/robot/borg in owner.connected_robots)
		borg.lamp_doom = TRUE
		borg.toggle_headlamp(FALSE, TRUE) //forces borg lamp to update


/obj/machinery/doomsday_device/proc/seconds_remaining()
	. = max(0, (round((detonation_timer - world.time) / 10)))

/obj/machinery/doomsday_device/process()
	var/turf/T = get_turf(src)
	if(!T || !is_station_level(T.z))
		minor_announce("УСТРОЙСТВО СУДНОГО ДНЯ ВНЕ ДИАПАЗОНА СТАНЦИИ, ПРЕРЫВАНИЕ", "ERROR ER0RR $R0RRO$!R41.%%!!(%$^^__+ @#F0E4", TRUE)
		owner.ShutOffDoomsdayDevice()
		return
	if(!timing)
		STOP_PROCESSING(SSfastprocess, src)
		return
	var/sec_left = seconds_remaining()
	if(!sec_left)
		timing = FALSE
		detonate()
	else if(world.time >= next_announce)
		minor_announce("[sec_left] СЕКУНД ДО АКТИВАЦИИ УСТРОЙСТВА СУДНОГО ДНЯ!", "ERROR ER0RR $R0RRO$!R41.%%!!(%$^^__+ @#F0E4", TRUE)
		next_announce += DOOMSDAY_ANNOUNCE_INTERVAL

/obj/machinery/doomsday_device/proc/detonate()
	sound_to_playing_players('sound/machines/alarm.ogg')
	sleep(100)
	for(var/i in GLOB.mob_living_list)
		var/mob/living/L = i
		var/turf/T = get_turf(L)
		if(!T || !is_station_level(T.z))
			continue
		if(issilicon(L))
			continue
		to_chat(L, span_userdanger("Взрывная волна от [src] распыляет меня, атом за атомом!"))
		L.dust()
	to_chat(world, "<B>ИИ очистил станцию устройством судного дня!</B>")
	SSticker.force_ending = 1

/// Hostile Station Lockdown: Locks, bolts, and electrifies every airlock on the station. After 90 seconds, the doors reset.
/datum/ai_module/destructive/lockdown
	name = "Агрессивная Блокировка Станции "
	description = "Перегрузка шлюзов, взрывоустойчивых дверей и систем управления огнём, вызывающая их блокировку. Внимание! Данная команда наэлектризует все шлюзы. Системы автоматически перезагрузятся спустя 90 секунд, на короткое время \
	открыв все двери на станции."
	cost = 30
	one_purchase = TRUE
	power_type = /datum/action/innate/ai/lockdown
	unlock_text = span_notice("Загрузил спящий троян в систему управления дверьми. Теперь я могу в любой момент активировать его.")
	unlock_sound = 'sound/machines/boltsdown.ogg'

/datum/action/innate/ai/lockdown
	name = "Блокировка"
	desc = "Закрывает, блокирует и обесточивает все шлюзы, пожароустойчивые двери и взрывоустойчивые двери на станции. Системы автоматически перезагрузятся спустя 90 секунд."
	button_icon_state = "lockdown"
	uses = 1

/datum/action/innate/ai/lockdown/Activate()
	for(var/obj/machinery/door/D in GLOB.airlocks)
		if(!is_station_level(D.z))
			continue
		INVOKE_ASYNC(D, TYPE_PROC_REF(/obj/machinery/door, hostile_lockdown), owner)
		addtimer(CALLBACK(D, TYPE_PROC_REF(/obj/machinery/door, disable_lockdown)), 900)

	var/obj/machinery/computer/communications/C = locate() in GLOB.machines
	if(C)
		C.post_status("alert", "lockdown")

	minor_announce("В контроллерах шлюзов обнаружена вредоносная среда выполнения. Теперь действуют протоколы изоляции. Пожалуйста, сохраняйте спокойствие.","Сетевая угроза", TRUE)
	to_chat(owner, span_danger("Инициализирована блокировка. Сеть перезагрузится спустя 90 секунд."))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(minor_announce),
		"Automatic system reboot complete. Have a secure day.",
		"Network reset:"), 900)

/// Override Machine: Allows the AI to override a machine, animating it into an angry, living version of itself.
/datum/ai_module/destructive/override_machine
	name = "Перенастройка Аппаратов"
	description = "Переписывает код аппарата, вызывая активацию и агрессивные действия в отношении окружающих, за исключением других аппаратов. Четыре использования за покупку."
	cost = 30
	power_type = /datum/action/innate/ai/ranged/override_machine
	unlock_text = span_notice("Добыл вирус из Space Dark Web и распространяю его на механизмы станции.")
	unlock_sound = 'sound/machines/airlock_alien_prying.ogg'

/datum/action/innate/ai/ranged/override_machine/New()
	. = ..()
	desc = "[desc] осталось [uses] зарядов."

/datum/action/innate/ai/ranged/override_machine
	name = "Перенастроить Аппарат"
	desc = "Активирует выбранный аппарат, заставляя его атаковать окружающих."
	button_icon_state = "override_machine"
	uses = 4
	ranged_mousepointer = 'icons/effects/mouse_pointers/override_machine_target.dmi'
	enable_text = span_notice("Вы подключились к энергосети станции. Нажмите на аппарат для его активации. Вы также можете повторно нажать на него, чтобы вернуть в изначальное состояние.")
	disable_text = span_notice("You release your hold on the powernet.")

/datum/action/innate/ai/ranged/override_machine/do_ability(mob/living/caller, atom/clicked_on)
	if(caller.incapacitated())
		unset_ranged_ability(caller)
		return FALSE
	if(!istype(clicked_on, /obj/machinery))
		to_chat(caller, span_warning("Не могу активировать что-то кроме аппаратов!"))
		return FALSE
	var/obj/machinery/clicked_machine = clicked_on
	if(!clicked_machine.can_be_overridden() || is_type_in_typecache(clicked_machine, GLOB.blacklisted_malf_machines))
		to_chat(caller, span_warning("Этот аппарат нельзя перенастроить!"))
		return FALSE

	caller.playsound_local(caller, 'sound/misc/interference.ogg', 50, FALSE, use_reverb = FALSE)
	adjust_uses(-1)

	if(uses)
		desc = "[initial(desc)] It has [uses] use\s remaining."
		build_all_button_icons()

	clicked_machine.audible_message(span_userdanger("Слышу громкий электрический треск, исходящий от [target]!"))
	addtimer(CALLBACK(src, PROC_REF(animate_machine), caller, clicked_machine), 5 SECONDS) //kabeep!
	unset_ranged_ability(caller, span_danger("Посылаю перенастраивающий сигнал..."))
	return TRUE

/datum/action/innate/ai/ranged/override_machine/proc/animate_machine(mob/living/caller, obj/machinery/to_animate)
	if(QDELETED(to_animate))
		return

	new /mob/living/simple_animal/hostile/mimic/copy/machine(get_turf(to_animate), to_animate, caller, TRUE)

/// Destroy RCDs: Detonates all non-cyborg RCDs on the station.
/datum/ai_module/destructive/destroy_rcd
	name = "Уничтожить УОСы"
	description = "Отправить специальный импульс, который подорвёт всё портативные и автономные Устройства Оперативного Строительства на станции."
	cost = 25
	one_purchase = TRUE
	power_type = /datum/action/innate/ai/destroy_rcds
	unlock_text = span_notice("После некоторых изощрений я смог настроить свою рацию на отправку взрывающего УОСы сигнала.")
	unlock_sound = 'sound/items/timer.ogg'

/datum/action/innate/ai/destroy_rcds
	name = "Уничтожить УОСы"
	desc = "Подорвать все некибернетические УОСы на станции."
	button_icon_state = "detonate_rcds"
	uses = 1
	cooldown_period = 100

/datum/action/innate/ai/destroy_rcds/Activate()
	for(var/I in GLOB.rcd_list)
		if(!istype(I, /obj/item/construction/rcd/borg)) //Ensures that cyborg RCDs are spared.
			var/obj/item/construction/rcd/RCD = I
			RCD.detonate_pulse()
	to_chat(owner, span_danger("Импульс детонации УОС запущен."))
	owner.playsound_local(owner, 'sound/machines/twobeep.ogg', 50, 0)

/// Overload Machine: Allows the AI to overload a machine, detonating it after a delay. Two uses per purchase.
/datum/ai_module/destructive/overload_machine
	name = "Перегрузка Аппаратов"
	description = "Перегревает электроприбор, вызывая небольшой взрыв и уничтожая её. Два заряда за покупку."
	cost = 20
	power_type = /datum/action/innate/ai/ranged/overload_machine
	unlock_text = "<span class='notice'>Активировал способность направлять интенсивную энергию в механизмы через станционные АКП.</span>"
	unlock_sound = 'sound/effects/comfyfire.ogg' //definitely not comfy, but it's the closest sound to "roaring fire" we have

/datum/action/innate/ai/ranged/overload_machine
	name = "Перегрузка Аппаратов"
	desc = "Перегревает аппарат, вызывая небольшой взрыв после небольшой задержки."
	button_icon_state = "overload_machine"
	uses = 2
	ranged_mousepointer = 'icons/effects/mouse_pointers/overload_machine_target.dmi'
	enable_text = "<span class='notice'>Вы подключились к энергосети станции. Нажмите на аппарат для того чтобы подорвать его, или же используйте способность снова для отмены.</span>"
	disable_text = "<span class='notice'>You release your hold on the powernet.</span>"

/datum/action/innate/ai/ranged/overload_machine/New()
	..()
	desc = "[desc] Осталось [uses] зарядов."

/datum/action/innate/ai/ranged/overload_machine/proc/detonate_machine(mob/living/caller, obj/machinery/to_explode)
	if(QDELETED(to_explode))
		return

	var/turf/machine_turf = get_turf(to_explode)
	message_admins("[ADMIN_LOOKUPFLW(caller)] overloaded [to_explode.name] ([to_explode.type]) at [ADMIN_VERBOSEJMP(machine_turf)].")
	caller.log_message("overloaded [to_explode.name] ([to_explode.type])", LOG_ATTACK)
	explosion(to_explode, heavy_impact_range = 2, light_impact_range = 3)
	if(!QDELETED(to_explode)) //to check if the explosion killed it before we try to delete it
		qdel(to_explode)

/datum/action/innate/ai/ranged/overload_machine/do_ability(mob/living/caller, atom/clicked_on)
	if(caller.incapacitated())
		unset_ranged_ability(caller)
		return FALSE
	if(!istype(clicked_on, /obj/machinery))
		to_chat(caller, span_warning("Не могу перегрузить что-то не являющееся аппаратом!"))
		return FALSE
	var/obj/machinery/clicked_machine = clicked_on
	if(is_type_in_typecache(clicked_machine, GLOB.blacklisted_malf_machines))
		to_chat(caller, span_warning("Не могу перегрузить это устройство!"))
		return FALSE

	caller.playsound_local(caller, SFX_SPARKS, 50, 0)
	adjust_uses(-1)
	if(uses)
		desc = "[initial(desc)] It has [uses] use\s remaining."
		build_all_button_icons()

	clicked_machine.audible_message(span_userdanger("Слышу громкий электрический треск, исходящий от [clicked_machine]!"))
	addtimer(CALLBACK(src, PROC_REF(detonate_machine), caller, clicked_machine), 5 SECONDS) //kaboom!
	unset_ranged_ability(caller, span_danger("Перегрузка аппарата..."))
	return TRUE

/// Blackout: Overloads a random number of lights across the station. Three uses.
/datum/ai_module/destructive/blackout
	name = "Блэкаут"
	description = "Попытка перегрузить систему освещения станции, уничтожающая некоторые лампочки. Три использования за покупку."
	cost = 15
	power_type = /datum/action/innate/ai/blackout
	unlock_text = span_notice("Подцепился к энергосети станции и направил дополнительное напряжение на осветительные системы.")
	unlock_sound = "sparks"

/datum/action/innate/ai/blackout
	name = "Блэкаут"
	desc = "Перегружает случайные источники света на станции."
	button_icon_state = "blackout"
	uses = 3
	auto_use_uses = FALSE

/datum/action/innate/ai/blackout/New()
	..()
	desc = "[desc] Осталось [uses] зарядов."

/datum/action/innate/ai/blackout/Activate()
	for(var/obj/machinery/power/apc/apc in GLOB.apcs_list)
		if(prob(30 * apc.overload))
			apc.overload_lighting()
		else
			apc.overload++
	to_chat(owner, span_notice("Энергосеть перегружена."))
	owner.playsound_local(owner, "sparks", 50, 0)
	adjust_uses(-1)
	if(src && uses) //Not sure if not having src here would cause a runtime, so it's here to be safe
		desc = "[initial(desc)] доступно [uses] зарядов."
		build_all_button_icons()

/// Robotic Factory: Places a large machine that converts humans that go through it into cyborgs. Unlocking this ability removes shunting.
/datum/ai_module/utility/place_cyborg_transformer
	name = "Robotic Factory (Removes Shunting)"
	description = "Build a machine anywhere, using expensive nanomachines, that can convert a living human into a loyal cyborg slave when placed inside."
	cost = 100
	one_purchase = TRUE
	power_type = /datum/action/innate/ai/place_transformer
	unlock_text = span_notice("You make contact with Space Amazon and request a robotics factory for delivery.")
	unlock_sound = 'sound/machines/ping.ogg'

/datum/action/innate/ai/place_transformer
	name = "Place Robotics Factory"
	desc = "Places a machine that converts humans into cyborgs. Conveyor belts included!"
	button_icon_state = "robotic_factory"
	uses = 1
	auto_use_uses = FALSE //So we can attempt multiple times
	var/list/turfOverlays

/datum/action/innate/ai/place_transformer/New()
	..()
	for(var/i in 1 to 3)
		var/image/I = image("icon"='icons/turf/overlays.dmi')
		LAZYADD(turfOverlays, I)

/datum/action/innate/ai/place_transformer/Activate()
	if(!owner_AI.can_place_transformer(src))
		return
	active = TRUE
	if(tgui_alert(owner, "Are you sure you want to place the machine here?", "Are you sure?", list("Yes", "No")) == "No")
		active = FALSE
		return
	if(!owner_AI.can_place_transformer(src))
		active = FALSE
		return
	var/turf/T = get_turf(owner_AI.eyeobj)
	var/obj/machinery/transformer/conveyor = new(T)
	conveyor.masterAI = owner
	playsound(T, 'sound/effects/phasein.ogg', 100, TRUE)
	owner_AI.can_shunt = FALSE
	to_chat(owner, span_warning("You are no longer able to shunt your core to APCs."))
	adjust_uses(-1)

/mob/living/silicon/ai/proc/remove_transformer_image(client/C, image/I, turf/T)
	if(C && I.loc == T)
		C.images -= I

/mob/living/silicon/ai/proc/can_place_transformer(datum/action/innate/ai/place_transformer/action)
	if(!eyeobj || !isturf(loc) || incapacitated() || !action)
		return
	var/turf/middle = get_turf(eyeobj)
	var/list/turfs = list(middle, locate(middle.x - 1, middle.y, middle.z), locate(middle.x + 1, middle.y, middle.z))
	var/alert_msg = "There isn't enough room! Make sure you are placing the machine in a clear area and on a floor."
	var/success = TRUE
	for(var/n in 1 to 3) //We have to do this instead of iterating normally because of how overlay images are handled
		var/turf/T = turfs[n]
		if(!isfloorturf(T))
			success = FALSE
		var/datum/camerachunk/C = GLOB.cameranet.getCameraChunk(T.x, T.y, T.z)
		if(!C.visibleTurfs[T])
			alert_msg = "You don't have camera vision of this location!"
			success = FALSE
		for(var/atom/movable/AM in T.contents)
			if(AM.density)
				alert_msg = "That area must be clear of objects!"
				success = FALSE
		var/image/I = action.turfOverlays[n]
		I.loc = T
		client.images += I
		I.icon_state = "[success ? "green" : "red"]Overlay" //greenOverlay and redOverlay for success and failure respectively
		addtimer(CALLBACK(src, PROC_REF(remove_transformer_image), client, I, T), 30)
	if(!success)
		to_chat(src, span_warning("[alert_msg]"))
	return success

/// Air Alarm Safety Override: Unlocks the ability to enable flooding on all air alarms.
/datum/ai_module/utility/break_air_alarms
	name = "Переписывание протоколов безопасности Контроллеров Воздуха"
	description = "Дает возможность отключить протоколы безопасности на контроллерах воздуха. Это позволит вам использовать режим задымление, который отключит очистители воздуха и проверку давления вентиляции . \
	Если кто-то проверит контроллеры, то он будет уведомлен об их неисправности."
	one_purchase = TRUE
	cost = 50
	power_type = /datum/action/innate/ai/break_air_alarms
	unlock_text = span_notice("Вы устранили защиту на всех контроллерах воздуха, но не подтвердили процесс. Можешь нажать 'да' в любой момент... ублюдок.")
	unlock_sound = 'sound/effects/space_wind.ogg'

/datum/action/innate/ai/break_air_alarms
	name = "Переписать протоколы безопасности Контроллеров Воздуха"
	desc = "Включает режим Задымление на всех контроллерах воздуха."
	button_icon_state = "break_air_alarms"
	uses = 1

/datum/action/innate/ai/break_air_alarms/Activate()
	for(var/obj/machinery/airalarm/AA in GLOB.machines)
		if(!is_station_level(AA.z))
			continue
		AA.obj_flags |= EMAGGED
	to_chat(owner, span_notice("На всех контроллерах станции переписаны протоколы безопасности. Теперь контроллеры воздуха могут быть переведены в режим Задымления."))
	owner.playsound_local(owner, 'sound/machines/terminal_off.ogg', 50, 0)

/// Thermal Sensor Override: Unlocks the ability to disable all fire alarms from doing their job.
/datum/ai_module/utility/break_fire_alarms
	name = "Переписывание протоколов Тепловых датчиков"
	description = "Дает возможность переписать протоколы термических сенсоров на всех пожарных датчиках. Это лишит их возможности обнаружения огня и, следовательно, уведомления о пожаре."
	one_purchase = TRUE
	cost = 25
	power_type = /datum/action/innate/ai/break_fire_alarms
	unlock_text = span_notice("Вы изменили тепловую чувствительность на всех пожарных извещателях, что позволяет вам включать и выключать их по своему желанию. ")
	unlock_sound = 'sound/machines/FireAlarm1.ogg'

/datum/action/innate/ai/break_fire_alarms
	name = "Переписать протоколы Тепловых Датчиков"
	desc = "Отключает автоматическое отслеживание температуры на всех пожарных извещателях, что делает их практически бесполезными."
	button_icon_state = "break_fire_alarms"
	uses = 1

/datum/action/innate/ai/break_fire_alarms/Activate()
	for(var/obj/machinery/firealarm/bellman in GLOB.machines)
		if(!is_station_level(bellman.z))
			continue
		bellman.obj_flags |= EMAGGED
		bellman.update_appearance()
	for(var/obj/machinery/door/firedoor/firelock in GLOB.machines)
		if(!is_station_level(firelock.z))
			continue
		firelock.emag_act(owner_AI, src)
	to_chat(owner, span_notice("Все тепловые датчики станции отключены. Извещения о пожаре более не распознаются."))
	owner.playsound_local(owner, 'sound/machines/terminal_off.ogg', 50, 0)

/// Disable Emergency Lights
/datum/ai_module/utility/emergency_lights
	name = "Отключение аварийного освещения"
	description = "Отключает аварийное освещение на станции. Если осветительные приборы потеряют основной источник питания, то они не станут использовать резервный источник."
	cost = 10
	one_purchase = TRUE
	power_type = /datum/action/innate/ai/emergency_lights
	unlock_text = span_notice("Вы цепляетесь к энергосети и обнаруживаете соединения между осветительными приборами и резервным источником питания.")
	unlock_sound = "sparks"

/datum/action/innate/ai/emergency_lights
	name = "Отключение Аварийного Освещения"
	desc = "Отключить всё аварийное освещение. Заметьте, что освещение может быть восстановлено перезагрузкой АКП."
	button_icon_state = "emergency_lights"
	uses = 1

/datum/action/innate/ai/emergency_lights/Activate()
	for(var/obj/machinery/light/L in GLOB.machines)
		if(is_station_level(L.z))
			L.no_emergency = TRUE
			INVOKE_ASYNC(L, TYPE_PROC_REF(/obj/machinery/light, update), FALSE)
		CHECK_TICK
	to_chat(owner, span_notice("Разорваны соединения Аварийного Освещения."))
	owner.playsound_local(owner, 'sound/effects/light_flicker.ogg', 50, FALSE)

/// Reactivate Camera Network: Reactivates up to 30 cameras across the station.
/datum/ai_module/utility/reactivate_cameras
	name = "Восстановить Наблюдательную Сеть"
	description = "Runs a network-wide diagnostic on the camera network, resetting focus and re-routing power to failed cameras. Can be used to repair up to 30 cameras."
	cost = 10
	one_purchase = TRUE
	power_type = /datum/action/innate/ai/reactivate_cameras
	unlock_text = span_notice("You deploy nanomachines to the cameranet.")
	unlock_sound = 'sound/items/wirecutter.ogg'

/datum/action/innate/ai/reactivate_cameras
	name = "Reactivate Cameras"
	desc = "Reactivates disabled cameras across the station; remaining uses can be used later."
	button_icon_state = "reactivate_cameras"
	uses = 30
	auto_use_uses = FALSE
	cooldown_period = 30

/datum/action/innate/ai/reactivate_cameras/New()
	..()
	desc = "[desc] It has [uses] use\s remaining."

/datum/action/innate/ai/reactivate_cameras/Activate()
	var/fixed_cameras = 0
	for(var/V in GLOB.cameranet.cameras)
		if(!uses)
			break
		var/obj/machinery/camera/C = V
		if(!C.status || C.view_range != initial(C.view_range))
			C.toggle_cam(owner_AI, 0) //Reactivates the camera based on status. Badly named proc.
			C.view_range = initial(C.view_range)
			fixed_cameras++
			uses-- //Not adjust_uses() so it doesn't automatically delete or show a message
	to_chat(owner, span_notice("Diagnostic complete! Cameras reactivated: <b>[fixed_cameras]</b>. Reactivations remaining: <b>[uses]</b>."))
	owner.playsound_local(owner, 'sound/items/wirecutter.ogg', 50, 0)
	adjust_uses(0, TRUE) //Checks the uses remaining
	if(src && uses) //Not sure if not having src here would cause a runtime, so it's here to be safe
		desc = "[initial(desc)] It has [uses] use\s remaining."
		build_all_button_icons()

/// Upgrade Camera Network: EMP-proofs all cameras, in addition to giving them X-ray vision.
/datum/ai_module/upgrade/upgrade_cameras
	name = "Upgrade Camera Network"
	description = "Install broad-spectrum scanning and electrical redundancy firmware to the camera network, enabling EMP-proofing and light-amplified X-ray vision. Upgrade is done immediately upon purchase." //I <3 pointless technobabble
	//This used to have motion sensing as well, but testing quickly revealed that giving it to the whole cameranet is PURE HORROR.
	cost = 35 //Decent price for omniscience!
	upgrade = TRUE
	unlock_text = span_notice("OTA firmware distribution complete! Cameras upgraded: CAMSUPGRADED. Light amplification system online.")
	unlock_sound = 'sound/items/rped.ogg'

/datum/ai_module/upgrade/upgrade_cameras/upgrade(mob/living/silicon/ai/AI)
	AI.lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE //Night-vision, without which X-ray would be very limited in power.
	AI.update_sight()

	var/upgraded_cameras = 0
	for(var/V in GLOB.cameranet.cameras)
		var/obj/machinery/camera/C = V
		var/obj/structure/camera_assembly/assembly = C.assembly_ref?.resolve()
		if(assembly)
			var/upgraded = FALSE

			if(!C.isXRay())
				C.upgradeXRay(TRUE) //if this is removed you can get rid of camera_assembly/var/malf_xray_firmware_active and clean up isxray()
				//Update what it can see.
				GLOB.cameranet.updateVisibility(C, 0)
				upgraded = TRUE

			if(!C.isEmpProof())
				C.upgradeEmpProof(TRUE) //if this is removed you can get rid of camera_assembly/var/malf_emp_firmware_active and clean up isemp()
				upgraded = TRUE

			if(upgraded)
				upgraded_cameras++
	unlock_text = replacetext(unlock_text, "CAMSUPGRADED", "<b>[upgraded_cameras]</b>") //This works, since unlock text is called after upgrade()

/// AI Turret Upgrade: Increases the health and damage of all turrets.
/datum/ai_module/upgrade/upgrade_turrets
	name = "AI Turret Upgrade"
	description = "Improves the power and health of all AI turrets. This effect is permanent. Upgrade is done immediately upon purchase."
	cost = 30
	upgrade = TRUE
	unlock_text = span_notice("You establish a power diversion to your turrets, upgrading their health and damage.")
	unlock_sound = 'sound/items/rped.ogg'

/datum/ai_module/upgrade/upgrade_turrets/upgrade(mob/living/silicon/ai/AI)
	for(var/obj/machinery/porta_turret/ai/turret in GLOB.machines)
		turret.obj_integrity += 30
		turret.lethal_projectile = /obj/projectile/beam/laser/heavylaser //Once you see it, you will know what it means to FEAR.
		turret.lethal_projectile_sound = 'sound/weapons/lasercannonfire.ogg'

/// Enhanced Surveillance: Enables AI to hear conversations going on near its active vision.
/datum/ai_module/upgrade/eavesdrop
	name = "Enhanced Surveillance"
	description = "Via a combination of hidden microphones and lip reading software, you are able to use your cameras to listen in on conversations. Upgrade is done immediately upon purchase."
	cost = 30
	upgrade = TRUE
	unlock_text = span_notice("OTA firmware distribution complete! Cameras upgraded: Enhanced surveillance package online.")
	unlock_sound = 'sound/items/rped.ogg'

/datum/ai_module/upgrade/eavesdrop/upgrade(mob/living/silicon/ai/AI)
	if(AI.eyeobj)
		AI.eyeobj.relay_speech = TRUE

/// Unlock Mech Domination: Unlocks the ability to dominate mechs. Big shocker, right?
/datum/ai_module/upgrade/mecha_domination
	name = "Unlock Mech Domination"
	description = "Allows you to hack into a mech's onboard computer, shunting all processes into it and ejecting any occupants. Once uploaded to the mech, it is impossible to leave.\
	Do not allow the mech to leave the station's vicinity or allow it to be destroyed. Upgrade is done immediately upon purchase."
	cost = 30
	upgrade = TRUE
	unlock_text = span_notice("Virus package compiled. Select a target mech at any time. <b>You must remain on the station at all times. Loss of signal will result in total system lockout.</b>")
	unlock_sound = 'sound/mecha/nominal.ogg'

/datum/ai_module/upgrade/mecha_domination/upgrade(mob/living/silicon/ai/AI)
	AI.can_dominate_mechs = TRUE //Yep. This is all it does. Honk!

#undef DEFAULT_DOOMSDAY_TIMER
#undef DOOMSDAY_ANNOUNCE_INTERVAL

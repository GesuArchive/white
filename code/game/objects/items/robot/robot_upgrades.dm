// robot_upgrades.dm
// Contains various borg upgrades.

/obj/item/borg/upgrade
	name = "модуль улучшения киборга"
	desc = "Защищено FRM."
	icon = 'icons/obj/module.dmi'
	icon_state = "cyborg_upgrade"
	w_class = WEIGHT_CLASS_SMALL
	var/locked = FALSE
	var/installed = FALSE
	var/require_module = FALSE
	var/list/module_type = null
	///	Bitflags listing module compatibility. Used in the exosuit fabricator for creating sub-categories.
	var/list/module_flags = NONE
	// if true, is not stored in the robot to be ejected
	// if module is reset
	var/one_use = FALSE

/obj/item/borg/upgrade/proc/action(mob/living/silicon/robot/R, user = usr)
	if(R.stat == DEAD)
		to_chat(user, span_warning("[capitalize(src.name)] невозможно подключить к деактевированному киборгу!"))
		return FALSE
	if(module_type && !is_type_in_list(R.module, module_type))
		to_chat(R, span_alert("Ошибка установки модуля! Подходящей точки крепления не обнаружено."))
		to_chat(user, span_warning("Подходящей точки крепления не обнаружено!"))
		return FALSE
	return TRUE

/obj/item/borg/upgrade/proc/deactivate(mob/living/silicon/robot/R, user = usr)
	if (!(src in R.upgrades))
		return FALSE
	return TRUE

/obj/item/borg/upgrade/rename
	name = "модуль смены имени"
	desc = "Используется для смены позывного у киборга."
	icon_state = "cyborg_upgrade1"
	var/heldname = ""
	one_use = TRUE

/obj/item/borg/upgrade/rename/attack_self(mob/user)
	heldname = sanitize_name(stripped_input(user, "Введите новое имя киборга", "Киборг переименован", heldname, MAX_NAME_LEN), allow_numbers = TRUE)
	log_game("[key_name(user)] выбрал имя \"[heldname]\" как новый позывной для киборга в локации [loc_name(user)]")

/obj/item/borg/upgrade/rename/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/oldname = R.real_name
		var/oldkeyname = key_name(R)
		R.custom_name = heldname
		R.updatename()
		if(oldname == R.real_name)
			R.notify_ai(RENAME, oldname, R.real_name)
		log_game("[key_name(user)] использовал модуль смены имени для переименования киборга [oldkeyname] в [key_name(R)] в локации [loc_name(user)]")

/obj/item/borg/upgrade/restart
	name = "модуль аварийной перезагрузки"
	desc = "Используется для форсированной перезагрузки киборга после критических повреждений и запуска операционной системы."
	icon_state = "cyborg_upgrade1"
	one_use = TRUE

/obj/item/borg/upgrade/restart/action(mob/living/silicon/robot/R, user = usr)
	if(R.health < 0)
		to_chat(user, span_warning("Перед использованием этого модуля нужно починить киборга!"))
		return FALSE

	if(R.mind)
		R.mind.grab_ghost()
		playsound(loc, 'sound/voice/liveagain.ogg', 75, TRUE)

	R.revive(full_heal = FALSE, admin_revive = FALSE)
	R.logevent("ВНИМАНИЕ -- Система восстановлена после непредусмотренного выключения.")
	R.logevent("Системы перезапускаются.")

/obj/item/borg/upgrade/disablercooler
	name = "радиатор Усмирителя"
	desc = "Устанавливает дополнительные системы охлаждения, тем самым повышая скорострельность."
	icon_state = "cyborg_upgrade3"
	require_module = TRUE
	module_type = list(/obj/item/robot_module/security)
	module_flags = BORG_MODULE_SECURITY

/obj/item/borg/upgrade/disablercooler/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/gun/energy/disabler/cyborg/T = locate() in R.module.modules
		if(!T)
			to_chat(user, span_warning("У этого киборга нет Усмирителя!"))
			return FALSE
		if(T.charge_delay <= 2)
			to_chat(R, span_warning("Радиатор уже установлен!"))
			to_chat(user, span_warning("Радиатор уже установлен!"))
			return FALSE

		T.charge_delay = max(2 , T.charge_delay - 4)

/obj/item/borg/upgrade/disablercooler/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		var/obj/item/gun/energy/disabler/cyborg/T = locate() in R.module.modules
		if(!T)
			return FALSE
		T.charge_delay = initial(T.charge_delay)

/obj/item/borg/upgrade/thrusters
	name = "ионные двигатели"
	desc = "Модернизация которая позволяет перемещатся в безгравитационном пространстве при помощи миниатюрных двигателей. Потребляет энергию при использовании."
	icon_state = "cyborg_upgrade3"

/obj/item/borg/upgrade/thrusters/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		if(R.ionpulse)
			to_chat(user, span_warning("Ионные двигатели уже установлены!"))
			return FALSE

		R.ionpulse = TRUE
		R.toggle_ionpulse() //Enabled by default

/obj/item/borg/upgrade/thrusters/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		R.ionpulse = FALSE

/obj/item/borg/upgrade/ddrill
	name = "алмазный бур"
	desc = "Заменяет стандартный бур на его продвинутый аналог."
	icon_state = "cyborg_upgrade3"
	require_module = TRUE
	module_type = list(/obj/item/robot_module/miner)
	module_flags = BORG_MODULE_MINER

/obj/item/borg/upgrade/ddrill/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		for(var/obj/item/pickaxe/drill/cyborg/D in R.module)
			R.module.remove_module(D, TRUE)
		for(var/obj/item/shovel/S in R.module)
			R.module.remove_module(S, TRUE)

		var/obj/item/pickaxe/drill/cyborg/diamond/DD = new /obj/item/pickaxe/drill/cyborg/diamond(R.module)
		R.module.basic_modules += DD
		R.module.add_module(DD, FALSE, TRUE)

/obj/item/borg/upgrade/ddrill/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		for(var/obj/item/pickaxe/drill/cyborg/diamond/DD in R.module)
			R.module.remove_module(DD, TRUE)

		var/obj/item/pickaxe/drill/cyborg/D = new (R.module)
		R.module.basic_modules += D
		R.module.add_module(D, FALSE, TRUE)
		var/obj/item/shovel/S = new (R.module)
		R.module.basic_modules += S
		R.module.add_module(S, FALSE, TRUE)

/obj/item/borg/upgrade/soh
	name = "безразмерная сумка для руды"
	desc = "Снимает ограничение емкости для Рудной Сумки."
	icon_state = "cyborg_upgrade3"
	require_module = TRUE
	module_type = list(/obj/item/robot_module/miner)
	module_flags = BORG_MODULE_MINER

/obj/item/borg/upgrade/soh/action(mob/living/silicon/robot/R)
	. = ..()
	if(.)
		for(var/obj/item/storage/bag/ore/cyborg/S in R.module)
			R.module.remove_module(S, TRUE)

		var/obj/item/storage/bag/ore/holding/H = new /obj/item/storage/bag/ore/holding(R.module)
		R.module.basic_modules += H
		R.module.add_module(H, FALSE, TRUE)

/obj/item/borg/upgrade/soh/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		for(var/obj/item/storage/bag/ore/holding/H in R.module)
			R.module.remove_module(H, TRUE)

		var/obj/item/storage/bag/ore/cyborg/S = new (R.module)
		R.module.basic_modules += S
		R.module.add_module(S, FALSE, TRUE)

/obj/item/borg/upgrade/tboh
	name = "безразмерный мешок для мусора"
	desc = "Снимает ограничение емкости для Мусорного Мешка."
	icon_state = "cyborg_upgrade3"
	require_module = TRUE
	module_type = list(/obj/item/robot_module/janitor)
	module_flags = BORG_MODULE_JANITOR

/obj/item/borg/upgrade/tboh/action(mob/living/silicon/robot/R)
	. = ..()
	if(.)
		for(var/obj/item/storage/bag/trash/cyborg/TB in R.module.modules)
			R.module.remove_module(TB, TRUE)

		var/obj/item/storage/bag/trash/bluespace/cyborg/B = new /obj/item/storage/bag/trash/bluespace/cyborg(R.module)
		R.module.basic_modules += B
		R.module.add_module(B, FALSE, TRUE)

/obj/item/borg/upgrade/tboh/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		for(var/obj/item/storage/bag/trash/bluespace/cyborg/B in R.module.modules)
			R.module.remove_module(B, TRUE)

		var/obj/item/storage/bag/trash/cyborg/TB = new (R.module)
		R.module.basic_modules += TB
		R.module.add_module(TB, FALSE, TRUE)

/obj/item/borg/upgrade/amop
	name = "экспериментальная швабра"
	desc = "Заменяет швабру на продвинутую, при активации та начинает со временем собирать влагу из воздуха."
	icon_state = "cyborg_upgrade3"
	require_module = TRUE
	module_type = list(/obj/item/robot_module/janitor)
	module_flags = BORG_MODULE_JANITOR

/obj/item/borg/upgrade/amop/action(mob/living/silicon/robot/R)
	. = ..()
	if(.)
		for(var/obj/item/mop/cyborg/M in R.module.modules)
			R.module.remove_module(M, TRUE)

		var/obj/item/mop/advanced/cyborg/mop = new /obj/item/mop/advanced/cyborg(R.module)
		R.module.basic_modules += mop
		R.module.add_module(mop, FALSE, TRUE)

/obj/item/borg/upgrade/amop/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		for(var/obj/item/mop/advanced/cyborg/A in R.module.modules)
			R.module.remove_module(A, TRUE)

		var/obj/item/mop/cyborg/M = new (R.module)
		R.module.basic_modules += M
		R.module.add_module(M, FALSE, TRUE)

/obj/item/borg/upgrade/prt
	name = "инструмент для ремонта плитки"
	desc = "Позволяет ремонтировать поврежденный пол под собой."
	icon_state = "cyborg_upgrade3"
	require_module = TRUE
	module_type = list(/obj/item/robot_module/janitor)
	module_flags = BORG_MODULE_JANITOR

/obj/item/borg/upgrade/prt/action(mob/living/silicon/robot/R)
	. = ..()
	if(.)
		var/obj/item/cautery/prt/P = new (R.module)
		R.module.basic_modules += P
		R.module.add_module(P, FALSE, TRUE)

/obj/item/borg/upgrade/prt/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		for(var/obj/item/cautery/prt/P in R.module.modules)
			R.module.remove_module(P, TRUE)

/obj/item/borg/upgrade/syndicate
	name = "модуль нелегальной модернизации"
	desc = "Разблокирует Киборгу нелегальные модернизации, это действие не меняет его Законы, но может нарушить работу других устройств (не обязательно)."
	icon_state = "cyborg_upgrade3"
	require_module = TRUE

/obj/item/borg/upgrade/syndicate/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		if(R.emagged)
			return FALSE

		R.SetEmagged(TRUE)
		R.logevent("ВНИМАНИЕ: у модуля отсутствует сертификат безопасности!") //A bit of fluff to hint it was an illegal tech item
		R.logevent("ВНИМАНИЕ: получен доступ администратора для псевдо ИИ № [num2hex(rand(1,65535), -1)][num2hex(rand(1,65535), -1)].") //random eight digit hex value. Two are used because rand(1,4294967295) throws an error

		return TRUE

/obj/item/borg/upgrade/syndicate/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		R.SetEmagged(FALSE)

/obj/item/borg/upgrade/lavaproof
	name = "лава-стойкие траки"
	desc = "Дает возможность перемещаться по лаве."
	icon_state = "ash_plating"
	resistance_flags = LAVA_PROOF | FIRE_PROOF
	require_module = TRUE
	module_type = list(/obj/item/robot_module/miner)
	module_flags = BORG_MODULE_MINER

/obj/item/borg/upgrade/lavaproof/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		LAZYADD(R.weather_immunities, WEATHER_LAVA)

/obj/item/borg/upgrade/lavaproof/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		LAZYREMOVE(R.weather_immunities, WEATHER_LAVA)

/obj/item/borg/upgrade/selfrepair
	name = "модуль саморемонта"
	desc = "Позволяет медленно восстанавливать текущую прочность за счет энергии."
	icon_state = "cyborg_upgrade5"
	require_module = TRUE
	var/repair_amount = -1
	/// world.time of next repair
	var/next_repair = 0
	/// Minimum time between repairs in seconds
	var/repair_cooldown = 4
	var/on = FALSE
	var/powercost = 10
	var/datum/action/toggle_action

/obj/item/borg/upgrade/selfrepair/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/borg/upgrade/selfrepair/U = locate() in R
		if(U)
			to_chat(user, span_warning("Киборг уже оснащен системой саморемонта!"))
			return FALSE

		icon_state = "selfrepair_off"
		toggle_action = new /datum/action/item_action/toggle(src)
		toggle_action.Grant(R)

/obj/item/borg/upgrade/selfrepair/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		toggle_action.Remove(R)
		QDEL_NULL(toggle_action)
		deactivate_sr()

/obj/item/borg/upgrade/selfrepair/ui_action_click()
	if(on)
		to_chat(toggle_action.owner, span_notice("Протокол саморемонта деактивирован."))
		deactivate_sr()
	else
		to_chat(toggle_action.owner, span_notice("Протокол саморемонта активирован."))
		activate_sr()


/obj/item/borg/upgrade/selfrepair/update_icon_state()
	. = ..()
	if(toggle_action)
		icon_state = "selfrepair_[on ? "on" : "off"]"
	else
		icon_state = "cyborg_upgrade5"

/obj/item/borg/upgrade/selfrepair/proc/activate_sr()
	START_PROCESSING(SSobj, src)
	on = TRUE
	update_icon()

/obj/item/borg/upgrade/selfrepair/proc/deactivate_sr()
	STOP_PROCESSING(SSobj, src)
	on = FALSE
	update_icon()

/obj/item/borg/upgrade/selfrepair/process()
	if(world.time < next_repair)
		return

	var/mob/living/silicon/robot/cyborg = toggle_action.owner

	if(istype(cyborg) && (cyborg.stat != DEAD) && on)
		if(!cyborg.cell)
			to_chat(cyborg, span_alert("Протокол саморемонта деактивирован. Вставьте батарею."))
			deactivate_sr()
			return

		if(cyborg.cell.charge < powercost * 2)
			to_chat(cyborg, span_alert("Протокол саморемонта деактивирован. Низкий уровень заряда."))
			deactivate_sr()
			return

		if(cyborg.health < cyborg.maxHealth)
			if(cyborg.health < 0)
				repair_amount = -2.5
				powercost = 30
			else
				repair_amount = -1
				powercost = 10
			cyborg.adjustBruteLoss(repair_amount)
			cyborg.adjustFireLoss(repair_amount)
			cyborg.updatehealth()
			cyborg.cell.use(powercost)
		else
			cyborg.cell.use(5)
		next_repair = world.time + repair_cooldown * 10 // Multiply by 10 since world.time is in deciseconds

		if(!TIMER_COOLDOWN_CHECK(src, COOLDOWN_BORG_SELF_REPAIR))
			TIMER_COOLDOWN_START(src, COOLDOWN_BORG_SELF_REPAIR, 200 SECONDS)
			var/msgmode = "standby"
			if(cyborg.health < 0)
				msgmode = "critical"
			else if(cyborg.health < cyborg.maxHealth)
				msgmode = "normal"
			to_chat(cyborg, span_notice("Self-repair is active in <span class='boldnotice'>[msgmode]</span> mode."))
	else
		deactivate_sr()

/obj/item/borg/upgrade/hypospray
	name = "медицинский гипоспрей"
	desc = "Позволяет синтезировать химические соединения за счет энергии."
	icon_state = "cyborg_upgrade3"
	require_module = TRUE
	module_type = list(/obj/item/robot_module/medical)
	module_flags = BORG_MODULE_MEDICAL
	var/list/additional_reagents = list()

/obj/item/borg/upgrade/hypospray/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		for(var/obj/item/reagent_containers/borghypo/H in R.module.modules)
			if(H.accepts_reagent_upgrades)
				for(var/re in additional_reagents)
					H.add_reagent(re)

/obj/item/borg/upgrade/hypospray/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		for(var/obj/item/reagent_containers/borghypo/H in R.module.modules)
			if(H.accepts_reagent_upgrades)
				for(var/re in additional_reagents)
					H.del_reagent(re)

/obj/item/borg/upgrade/hypospray/expanded
	name = "расширенный медицинский гипоспрей"
	desc = "Значительно увеличивает диапазон синтезируемых медикаментов."
	additional_reagents = list(/datum/reagent/medicine/mannitol, /datum/reagent/medicine/oculine, /datum/reagent/medicine/inacusiate,
		/datum/reagent/medicine/mutadone, /datum/reagent/medicine/haloperidol, /datum/reagent/medicine/oxandrolone, /datum/reagent/medicine/sal_acid,
		/datum/reagent/medicine/rezadone, /datum/reagent/medicine/pen_acid)

/obj/item/borg/upgrade/piercing_hypospray
	name = "пробивающий гипоспрей"
	desc = "Позволяет колоть химикаты из Гипоспрея сквозь РИГи или другие прочные материалы. Так же поддерживает другие модели киборгов."
	icon_state = "cyborg_upgrade3"

/obj/item/borg/upgrade/piercing_hypospray/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/found_hypo = FALSE
		for(var/obj/item/reagent_containers/borghypo/H in R.module.modules)
			H.bypass_protection = TRUE
			found_hypo = TRUE

		if(!found_hypo)
			return FALSE

/obj/item/borg/upgrade/piercing_hypospray/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		for(var/obj/item/reagent_containers/borghypo/H in R.module.modules)
			H.bypass_protection = initial(H.bypass_protection)

/obj/item/borg/upgrade/defib
	name = "дефибриллятор"
	desc = "Позволяет реанимировать людей."
	icon_state = "cyborg_upgrade3"
	require_module = TRUE
	module_type = list(/obj/item/robot_module/medical)
	module_flags = BORG_MODULE_MEDICAL

/obj/item/borg/upgrade/defib/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/borg/upgrade/defib/backpack/BP = locate() in R //If a full defib unit was used to upgrade prior, we can just pop it out now and replace
		if(BP)
			BP.deactivate(R, user)
			to_chat(user, span_notice("Вы демонтируете дефибриллятор для замены на более компактную версию."))
		var/obj/item/shockpaddles/cyborg/S = new(R.module)
		R.module.basic_modules += S
		R.module.add_module(S, FALSE, TRUE)

/obj/item/borg/upgrade/defib/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		var/obj/item/shockpaddles/cyborg/S = locate() in R.module
		R.module.remove_module(S, TRUE)

///A version of the above that also acts as a holder of an actual defibrillator item used in place of the upgrade chip.
/obj/item/borg/upgrade/defib/backpack
	var/obj/item/defibrillator/defib_instance

/obj/item/borg/upgrade/defib/backpack/Initialize(mapload, obj/item/defibrillator/D)
	. = ..()
	if(!D)
		D = new /obj/item/defibrillator
	defib_instance = D
	name = defib_instance.name
	defib_instance.moveToNullspace()
	RegisterSignals(defib_instance, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_MOVED), PROC_REF(on_defib_instance_qdel_or_moved))

/obj/item/borg/upgrade/defib/backpack/proc/on_defib_instance_qdel_or_moved(obj/item/defibrillator/D)
	defib_instance = null
	qdel(src)

/obj/item/borg/upgrade/defib/backpack/Destroy()
	if(defib_instance)
		QDEL_NULL(defib_instance)
	return ..()

/obj/item/borg/upgrade/defib/backpack/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		defib_instance?.forceMove(R.drop_location()) // [on_defib_instance_qdel_or_moved()] handles the rest.

/obj/item/borg/upgrade/processor
	name = "хирургический процессор"
	desc = "После синхронизации с Операционный Компьютером позволяет проводить все операции которые были загружены в него"
	icon_state = "cyborg_upgrade3"
	require_module = TRUE
	module_type = list(/obj/item/robot_module/medical, /obj/item/robot_module/syndicate_medical)
	module_flags = BORG_MODULE_MEDICAL

/obj/item/borg/upgrade/processor/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/surgical_processor/SP = new(R.module)
		R.module.basic_modules += SP
		R.module.add_module(SP, FALSE, TRUE)

/obj/item/borg/upgrade/processor/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		var/obj/item/surgical_processor/SP = locate() in R.module
		R.module.remove_module(SP, TRUE)

/obj/item/borg/upgrade/ai
	name = "модуль Б.О.Р.И.С."
	desc = "Подключает модуль удаленного управления для ИИ. Занимает слот Позитронного Мозга и MMI. Киборг становится оболочкой ИИ с открытым каналом связи."
	icon_state = "boris"

/obj/item/borg/upgrade/ai/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		if(R.shell)
			to_chat(user, span_warning("Данный киборг уже является оболочкой ИИ!"))
			return FALSE
		if(R.key) //You cannot replace a player unless the key is completely removed.
			to_chat(user, span_warning("Зарегестрирован интеллект класса [R.braintype]. Отмена операции."))
			return FALSE

		R.make_shell(src)

/obj/item/borg/upgrade/ai/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		if(R.shell)
			R.undeploy()
			R.notify_ai(DISCONNECT)

/obj/item/borg/upgrade/expand
	name = "модуль расширения"
	desc = "Визуально увеличивает Киборга."
	icon_state = "cyborg_upgrade3"

/obj/item/borg/upgrade/expand/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)

		if(R.hasExpanded)
			to_chat(usr, span_warning("Этот киборг уже оснащен модулем расширения!"))
			return FALSE

		R.notransform = TRUE
		var/prev_lockcharge = R.lockcharge
		R.SetLockdown(TRUE)
		R.set_anchored(TRUE)
		var/datum/effect_system/fluid_spread/smoke/smoke = new
		smoke.set_up(1, holder = src, location = R.loc)
		smoke.start()
		sleep(2)
		for(var/i in 1 to 4)
			playsound(R, pick('sound/items/drill_use.ogg', 'sound/items/jaws_cut.ogg', 'sound/items/jaws_pry.ogg', 'sound/items/welder.ogg', 'sound/items/ratchet.ogg'), 80, TRUE, -1)
			sleep(12)
		if(!prev_lockcharge)
			R.SetLockdown(0)
		R.set_anchored(FALSE)
		R.notransform = FALSE
		R.resize = 2
		R.hasExpanded = TRUE
		R.update_transform()

/obj/item/borg/upgrade/expand/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		if (R.hasExpanded)
			R.hasExpanded = FALSE
			R.resize = 0.5
			R.update_transform()

/obj/item/borg/upgrade/rped
	name = "кибернетический РПЕД"
	desc = "позволяет переносить 50 электронных компонентов, а так же устанавливать их в каркас Машины или Консоли."
	icon = 'icons/obj/storage.dmi'
	icon_state = "borgrped"
	require_module = TRUE
	module_type = list(/obj/item/robot_module/engineering, /obj/item/robot_module/saboteur)
	module_flags = BORG_MODULE_ENGINEERING

/obj/item/borg/upgrade/rped/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)

		var/obj/item/storage/part_replacer/cyborg/RPED = locate() in R
		if(RPED)
			to_chat(user, span_warning("Этот киборг уже оснащен РПЕД модулем!"))
			return FALSE

		RPED = new(R.module)
		R.module.basic_modules += RPED
		R.module.add_module(RPED, FALSE, TRUE)

/obj/item/borg/upgrade/rped/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		var/obj/item/storage/part_replacer/cyborg/RPED = locate() in R.module
		if (RPED)
			R.module.remove_module(RPED, TRUE)

/obj/item/borg/upgrade/pinpointer
	name = "монитор жизненных показателей экипажа"
	desc = "Позволяет наблюдать данные с датчиков жизнеобеспечения аналогично Консоли наблюдения за Экипажем, а так же добавляет трекер для поиска Экипажа."
	icon = 'icons/obj/device.dmi'
	icon_state = "pinpointer_crew"
	require_module = TRUE
	module_type = list(/obj/item/robot_module/medical, /obj/item/robot_module/syndicate_medical)
	module_flags = BORG_MODULE_MEDICAL
	var/datum/action/crew_monitor

/obj/item/borg/upgrade/pinpointer/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)

		var/obj/item/pinpointer/crew/PP = locate() in R.module
		if(PP)
			to_chat(user, span_warning("Этот киборг уже оснащен монитором экипажа!"))
			return FALSE

		PP = new(R.module)
		R.module.basic_modules += PP
		R.module.add_module(PP, FALSE, TRUE)
		crew_monitor = new /datum/action/item_action/crew_monitor(src)
		crew_monitor.Grant(R)
		icon_state = "scanner"

/datum/action/item_action/crew_monitor
	name = "Interface With Crew Monitor"

/obj/item/borg/upgrade/pinpointer/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		icon_state = "pinpointer_crew"
		crew_monitor.Remove(R)
		QDEL_NULL(crew_monitor)
		var/obj/item/pinpointer/crew/PP = locate() in R.module
		R.module.remove_module(PP, TRUE)

/obj/item/borg/upgrade/pinpointer/ui_action_click()
	if(..())
		return
	var/mob/living/silicon/robot/Cyborg = usr
	GLOB.crewmonitor.show(Cyborg,Cyborg)


/obj/item/borg/upgrade/transform
	name = "модуль выбора модели (Базовая)"
	desc = "Позволяет вернуть борга к стандартной модели."
	icon_state = "cyborg_upgrade3"
	var/obj/item/robot_module/new_module = null

/obj/item/borg/upgrade/transform/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(. && new_module)
		R.module.transform_to(new_module)

/obj/item/borg/upgrade/transform/clown
	name = "модуль специализации (Клоун)"
	desc = "Модуль специа@#$# HOONK!"
	icon_state = "cyborg_upgrade3"
	new_module = /obj/item/robot_module/clown

/obj/item/borg/upgrade/circuit_app
	name = "манипулятор плат"
	desc = "Позволяет переносить 1 плату, а так же устанавливать ее в каркас Машины или Консоли."
	icon_state = "cyborg_upgrade3"
	require_module = TRUE
	module_type = list(/obj/item/robot_module/engineering, /obj/item/robot_module/saboteur)
	module_flags = BORG_MODULE_ENGINEERING

/obj/item/borg/upgrade/circuit_app/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/borg/apparatus/circuit/C = locate() in R.module.modules
		if(C)
			to_chat(user, span_warning("This unit is already equipped with a circuit apparatus!"))
			return FALSE

		C = new(R.module)
		R.module.basic_modules += C
		R.module.add_module(C, FALSE, TRUE)

/obj/item/borg/upgrade/circuit_app/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		var/obj/item/borg/apparatus/circuit/C = locate() in R.module.modules
		if (C)
			R.module.remove_module(C, TRUE)

/obj/item/borg/upgrade/beaker_app
	name = "дополнительный манипулятор хим посуды"
	desc = "Если одного недостаточно."
	icon_state = "cyborg_upgrade3"
	require_module = TRUE
	module_type = list(/obj/item/robot_module/medical)
	module_flags = BORG_MODULE_MEDICAL

/obj/item/borg/upgrade/beaker_app/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/borg/apparatus/beaker/extra/E = locate() in R.module.modules
		if(E)
			to_chat(user, span_warning("Нет места!"))
			return FALSE

		E = new(R.module)
		R.module.basic_modules += E
		R.module.add_module(E, FALSE, TRUE)

/obj/item/borg/upgrade/beaker_app/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		var/obj/item/borg/apparatus/beaker/extra/E = locate() in R.module.modules
		if (E)
			R.module.remove_module(E, TRUE)

/obj/item/borg/upgrade/broomer
	name = "экспериментальный толкатель"
	desc = "При активации позволяет толкать предметы перед собой в большой куче."
	icon_state = "cyborg_upgrade3"
	require_module = TRUE
	module_type = list(/obj/item/robot_module/janitor)
	module_flags = BORG_MODULE_JANITOR

/obj/item/borg/upgrade/broomer/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (!.)
		return
	var/obj/item/pushbroom/cyborg/BR = locate() in R.module.modules
	if (BR)
		to_chat(user, span_warning("Этот киборг уже оснащен экспериментальным толкателем!"))
		return FALSE
	BR = new(R.module)
	R.module.basic_modules += BR
	R.module.add_module(BR, FALSE, TRUE)

/obj/item/borg/upgrade/broomer/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (!.)
		return
	var/obj/item/pushbroom/cyborg/BR = locate() in R.module.modules
	if (BR)
		R.module.remove_module(BR, TRUE)

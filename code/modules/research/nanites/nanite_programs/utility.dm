//Programs that interact with other programs or nanites directly, or have other special purposes.
/datum/nanite_program/viral
	name = "Вирусное заражение"
	desc = "Наниты постоянно расслылают шифрованные сигналы, пытаясь насильно скопировать свои настройки в другие рои нанитов. Эта программа также установит ID облачного сохранения другого роя на установленный в программе."
	use_rate = 0.5
	rogue_types = list(/datum/nanite_program/toxic)
	var/pulse_cooldown = 0

/datum/nanite_program/viral/register_extra_settings()
	extra_settings[NES_PROGRAM_OVERWRITE] = new /datum/nanite_extra_setting/type("Add To", list("Overwrite", "Add To", "Ignore"))
	extra_settings[NES_CLOUD_OVERWRITE] = new /datum/nanite_extra_setting/number(0, 0, 100)

/datum/nanite_program/viral/active_effect()
	if(world.time < pulse_cooldown)
		return
	var/datum/nanite_extra_setting/program = extra_settings[NES_PROGRAM_OVERWRITE]
	var/datum/nanite_extra_setting/cloud = extra_settings[NES_CLOUD_OVERWRITE]
	for(var/mob/M in orange(host_mob, 5))
		if(SEND_SIGNAL(M, COMSIG_NANITE_IS_STEALTHY))
			continue
		switch(program.get_value())
			if("Overwrite")
				SEND_SIGNAL(M, COMSIG_NANITE_SYNC, nanites, TRUE)
			if("Add To")
				SEND_SIGNAL(M, COMSIG_NANITE_SYNC, nanites, FALSE)
		SEND_SIGNAL(M, COMSIG_NANITE_SET_CLOUD, cloud.get_value())
	pulse_cooldown = world.time + 75

/datum/nanite_program/monitoring
	name = "Отслеживание"
	desc = "Наниты отслеживают состояние и местоположение носителя, отправляя их в сеть медицинских сенсоров. Также добавляет иконку нанитового интерфейса для медицинских сканеров, осматривающих носителя."
	rogue_types = list(/datum/nanite_program/toxic)

/datum/nanite_program/monitoring/enable_passive_effect()
	. = ..()
	ADD_TRAIT(host_mob, TRAIT_NANITE_MONITORING, "nanites") //Shows up in diagnostic and medical HUDs as a small blinking icon
	if(ishuman(host_mob))
		GLOB.nanite_sensors_list |= host_mob
	host_mob.hud_set_nanite_indicator()

/datum/nanite_program/monitoring/disable_passive_effect()
	. = ..()
	REMOVE_TRAIT(host_mob, TRAIT_NANITE_MONITORING, "nanites")
	if(ishuman(host_mob))
		GLOB.nanite_sensors_list -= host_mob

	host_mob.hud_set_nanite_indicator()

/datum/nanite_program/self_scan
	name = "Сканирование носителя"
	desc = "Наниты выводят детальный отчет о сканировании тела носителя при активации. Можно выбирать между медицинским, химическим и нанитовым сканированием, а также сканированием травм."
	unique = FALSE
	can_trigger = TRUE
	trigger_cost = 3
	trigger_cooldown = 50
	rogue_types = list(/datum/nanite_program/toxic)

/datum/nanite_program/self_scan/register_extra_settings()
	extra_settings[NES_SCAN_TYPE] = new /datum/nanite_extra_setting/type("Здоровья", list("Здоровья", "Химикатов", "Ранений", "Нанитов"))

/datum/nanite_program/self_scan/on_trigger(comm_message)
	if(host_mob.stat == DEAD)
		return
	var/datum/nanite_extra_setting/NS = extra_settings[NES_SCAN_TYPE]
	switch(NS.get_value())
		if("Здоровья")
			healthscan(host_mob, host_mob)
		if("Химикатов")
			chemscan(host_mob, host_mob)
		if("Ранений")
			woundscan(host_mob, host_mob)
		if("Нанитов")
			SEND_SIGNAL(host_mob, COMSIG_NANITE_SCAN, host_mob, TRUE)

/datum/nanite_program/stealth
	name = "Скрытность"
	desc = "Наниты будут скрывать свою активность от поверхностного сканирования, становясь невидимыми для диагностических дисплеев и иммунными для Вирусных программ."
	rogue_types = list(/datum/nanite_program/toxic)
	use_rate = 0.2

/datum/nanite_program/stealth/enable_passive_effect()
	. = ..()
	nanites.stealth = TRUE

/datum/nanite_program/stealth/disable_passive_effect()
	. = ..()
	nanites.stealth = FALSE

/datum/nanite_program/nanite_debugging
	name = "Диагностика нанитов"
	desc = "Включает сложные диагностические программы для нанитов, позволяя им отправлять более детализированную информацию сканеру нанитов, это никак не влияет на стабильность программ и синхронизацию. Немного уменьшает скорость репликации нанитов."
	rogue_types = list(/datum/nanite_program/toxic)
	use_rate = 0.1

/datum/nanite_program/nanite_debugging/enable_passive_effect()
	. = ..()
	nanites.diagnostics = TRUE

/datum/nanite_program/nanite_debugging/disable_passive_effect()
	. = ..()
	nanites.diagnostics = FALSE

/datum/nanite_program/relay
	name = "Приемо-передатчик"
	desc = "Наниты принимают сигналы на огромных расстояниях. Необходимо настроить канал передатчика до передачи сигнала."
	rogue_types = list(/datum/nanite_program/toxic)

/datum/nanite_program/relay/register_extra_settings()
	extra_settings[NES_RELAY_CHANNEL] = new /datum/nanite_extra_setting/number(1, 1, 9999)

/datum/nanite_program/relay/enable_passive_effect()
	. = ..()
	SSnanites.nanite_relays |= src

/datum/nanite_program/relay/disable_passive_effect()
	. = ..()
	SSnanites.nanite_relays -= src

/datum/nanite_program/relay/proc/relay_signal(code, relay_code, source)
	if(!activated)
		return
	if(!host_mob)
		return
	var/datum/nanite_extra_setting/NS = extra_settings[NES_RELAY_CHANNEL]
	if(relay_code != NS.get_value())
		return
	SEND_SIGNAL(host_mob, COMSIG_NANITE_SIGNAL, code, source)

/datum/nanite_program/relay/proc/relay_comm_signal(comm_code, relay_code, comm_message)
	if(!activated)
		return
	if(!host_mob)
		return
	var/datum/nanite_extra_setting/NS = extra_settings[NES_RELAY_CHANNEL]
	if(relay_code != NS.get_value())
		return
	SEND_SIGNAL(host_mob, COMSIG_NANITE_COMM_SIGNAL, comm_code, comm_message)

/datum/nanite_program/metabolic_synthesis
	name = "Метаболический синтез"
	desc = "Наниты используют цикл метаболизма носителя для ускоренной репликации, перерабатывая лишнюю еду в топливо и ускоряя производство на +0,5 единиц. Носитель должен быть хорошо накормлен для работы программы."
	use_rate = -0.5 //generates nanites
	rogue_types = list(/datum/nanite_program/toxic)

/datum/nanite_program/metabolic_synthesis/check_conditions()
	if(!iscarbon(host_mob))
		return FALSE
	var/mob/living/carbon/C = host_mob
	if(C.nutrition <= NUTRITION_LEVEL_WELL_FED)
		return FALSE
	return ..()

/datum/nanite_program/metabolic_synthesis/active_effect()
	host_mob.adjust_nutrition(-0.5)

/datum/nanite_program/access
	name = "Подкожный ID"
	desc = "Наниты хранят доступы с карты носителя в магнитной ленте под кожей. Обновляется при активации, копируя текущий доступ носителя и стирая предидущий."
	can_trigger = TRUE
	trigger_cost = 3
	trigger_cooldown = 30
	rogue_types = list(/datum/nanite_program/skin_decay)
	var/access = list()

//Syncs the nanites with the cumulative current mob's access level. Can potentially wipe existing access.
/datum/nanite_program/access/on_trigger(comm_message)
	var/list/potential_items = list()

	potential_items += host_mob.get_active_held_item()
	potential_items += host_mob.get_inactive_held_item()
	potential_items += host_mob.pulling

	if(ishuman(host_mob))
		var/mob/living/carbon/human/H = host_mob
		potential_items += H.wear_id
	else if(isanimal(host_mob))
		var/mob/living/simple_animal/A = host_mob
		potential_items += A.access_card

	var/list/new_access = list()
	for(var/obj/item/I in potential_items)
		new_access += I.GetAccess()

	access = new_access

/datum/nanite_program/spreading
	name = "Аурное распространение"
	desc = "Наниты получают возможность существовать снаружи тела носителя на короткие периоды времени, и способность создавать новые рои без процесса внедрения; создавая невероятно заразный штамм нанитов."
	use_rate = 1.50
	rogue_types = list(/datum/nanite_program/aggressive_replication, /datum/nanite_program/necrotic)
	var/spread_cooldown = 0

/datum/nanite_program/spreading/active_effect()
	if(world.time < spread_cooldown)
		return
	spread_cooldown = world.time + 50
	var/list/mob/living/target_hosts = list()
	for(var/mob/living/L in oview(5, host_mob))
		if(!prob(25))
			continue
		if(!(L.mob_biotypes & (MOB_ORGANIC|MOB_UNDEAD)))
			continue
		target_hosts += L
	if(!target_hosts.len)
		return
	var/mob/living/infectee = pick(target_hosts)
	if(prob(100 - (infectee.getarmor(null, BIO) * 0.01 * 100)))
		//this will potentially take over existing nanites!
		infectee.AddComponent(/datum/component/nanites, 10)
		SEND_SIGNAL(infectee, COMSIG_NANITE_SYNC, nanites)
		SEND_SIGNAL(infectee, COMSIG_NANITE_SET_CLOUD, nanites.cloud_id)
		infectee.investigate_log("was infected by spreading nanites with cloud ID [nanites.cloud_id] by [key_name(host_mob)] at [AREACOORD(infectee)].", INVESTIGATE_NANITES)

/datum/nanite_program/nanite_sting
	name = "Нанитное жало"
	desc = "При активации жалит случайного не-носителя рядом с самим носителем едва заметным скоплением нанитов, делая его новым носителем. Новый носитель почувствует это. Если жало не находит рядом цель, то оно возвращается в рой, \"возвращая\" стоимость активации."
	can_trigger = TRUE
	trigger_cost = 5
	trigger_cooldown = 100
	rogue_types = list(/datum/nanite_program/glitch, /datum/nanite_program/toxic)

/datum/nanite_program/nanite_sting/on_trigger(comm_message)
	var/list/mob/living/target_hosts = list()
	for(var/mob/living/L in oview(1, host_mob))
		if(!(L.mob_biotypes & (MOB_ORGANIC|MOB_UNDEAD)) || SEND_SIGNAL(L, COMSIG_HAS_NANITES) || !L.Adjacent(host_mob))
			continue
		target_hosts += L
	if(!target_hosts.len)
		consume_nanites(-5)
		return
	var/mob/living/infectee = pick(target_hosts)
	if(prob(100 - (infectee.getarmor(null, BIO) * 0.01 * 100)))
		//unlike with Infective Exo-Locomotion, this can't take over existing nanites, because Nanite Sting only targets non-hosts.
		infectee.AddComponent(/datum/component/nanites, 5)
		SEND_SIGNAL(infectee, COMSIG_NANITE_SYNC, nanites)
		SEND_SIGNAL(infectee, COMSIG_NANITE_SET_CLOUD, nanites.cloud_id)
		infectee.investigate_log("was infected by a nanite cluster with cloud ID [nanites.cloud_id] by [key_name(host_mob)] at [AREACOORD(infectee)].", INVESTIGATE_NANITES)
		to_chat(infectee, span_warning("Что-то укололо меня."))

/datum/nanite_program/mitosis
	name = "Митоз"
	desc = "Наниты получают способность к саморепликации, используя блюспейс для этого процесса вместо метаболизма носителя. Это очень сильно повышает скорость появления нанитов, но вызывает случайные ошибки в программах из-за бракованных копий нанитов, делая эту программу очень опасной без облачного сохранения."
	use_rate = 0
	rogue_types = list(/datum/nanite_program/toxic)

/datum/nanite_program/mitosis/active_effect()
	var/rep_rate = round(nanites.nanite_volume / 50, 1) //0.5 per 50 nanite volume
	rep_rate *= 0.5
	nanites.adjust_nanites(null, rep_rate)
	if(prob(rep_rate))
		var/datum/nanite_program/fault = pick(nanites.programs)
		if(fault == src)
			return
		fault.software_error()
		host_mob.investigate_log("[fault] nanite program received a software error due to Mitosis program.", INVESTIGATE_NANITES)

/datum/nanite_program/dermal_button
	name = "Кнопка на коже"
	desc = "Наниты формируют кнопку на руке носителя, позволяя ему отправлять сигнал программам при нажатии. Кнопку нельзя нажать, если носитель находится без сознания."
	unique = FALSE
	var/datum/action/innate/nanite_button/button

/datum/nanite_program/dermal_button/register_extra_settings()
	extra_settings[NES_SENT_CODE] = new /datum/nanite_extra_setting/number(1, 1, 9999)
	extra_settings[NES_BUTTON_NAME] = new /datum/nanite_extra_setting/text("Button")
	extra_settings[NES_ICON] = new /datum/nanite_extra_setting/type("power", list("blank","one","two","three","four","five","plus","minus","exclamation","question","cross","info","heart","skull","brain","brain_damage","injection","blood","shield","reaction","network","power","radioactive","electricity","magnetism","scan","repair","id","wireless","say","sleep","bomb"))

/datum/nanite_program/dermal_button/enable_passive_effect()
	. = ..()
	var/datum/nanite_extra_setting/bn_name = extra_settings[NES_BUTTON_NAME]
	var/datum/nanite_extra_setting/bn_icon = extra_settings[NES_ICON]
	if(!button)
		button = new(src, bn_name.get_value(), bn_icon.get_value())
	button.target = host_mob
	button.Grant(host_mob)

/datum/nanite_program/dermal_button/disable_passive_effect()
	. = ..()
	if(button)
		button.Remove(host_mob)

/datum/nanite_program/dermal_button/on_mob_remove()
	. = ..()
	QDEL_NULL(button)

/datum/nanite_program/dermal_button/proc/press()
	if(activated)
		host_mob.visible_message(span_notice("[host_mob] нажимает кнопку на своей руке.") ,
								span_notice("Нажимаю кнопку на своей руке.") , null, 2)
		var/datum/nanite_extra_setting/sent_code = extra_settings[NES_SENT_CODE]
		SEND_SIGNAL(host_mob, COMSIG_NANITE_SIGNAL, sent_code.get_value(), "a [name] program")

/datum/action/innate/nanite_button
	name = "Кнопка"
	button_icon = 'icons/mob/actions/actions_items.dmi'
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_CONSCIOUS
	button_icon_state = "bci_power"
	var/datum/nanite_program/dermal_button/program

/datum/action/innate/nanite_button/New(datum/nanite_program/dermal_button/_program, _name, _icon)
	..()
	program = _program
	name = _name
	button_icon_state = "bci_[_icon]"

/datum/action/innate/nanite_button/Activate()
	program.press()

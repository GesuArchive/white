//Replication Protocols
/datum/nanite_program/protocol/kickstart
	name = "Протокол репликации: Быстрый старт"
	desc = "Наниты сосредатачиваются на репликации, сильно повышая темп прироста на +3.5 единиц в первые две минуты после внедрения роя."
	use_rate = 0
	rogue_types = list(/datum/nanite_program/necrotic)
	protocol_class = NANITE_PROTOCOL_REPLICATION
	var/boost_duration = 1200

/datum/nanite_program/protocol/kickstart/check_conditions()
	if(!(world.time < nanites.start_time + boost_duration))
		return FALSE
	return ..()

/datum/nanite_program/protocol/kickstart/active_effect()
	nanites.adjust_nanites(null, 3.5)

/datum/nanite_program/protocol/factory
	name = "Протокол репликации: Фабрика"
	desc = "Наниты создают матрицу фабрики репликации внутри носителя, медленно увеличивая скорость репликации. Фабрика выходит на максимальную мощность в +2 единиц через 16,4 минут. Фабрика распадается если протокол отключается, а так же может быть повреждена ЭМИ и ударами тока."
	use_rate = 0
	rogue_types = list(/datum/nanite_program/necrotic)
	protocol_class = NANITE_PROTOCOL_REPLICATION
	var/factory_efficiency = 0
	var/max_efficiency = 1000 //Goes up to 2 bonus regen per tick after 16 minutes and 40 seconds

/datum/nanite_program/protocol/factory/on_process()
	if(!activated || !check_conditions())
		factory_efficiency = max(0, factory_efficiency - 5)
	..()

/datum/nanite_program/protocol/factory/on_emp(severity)
	..()
	factory_efficiency = max(0, factory_efficiency - 300)

/datum/nanite_program/protocol/factory/on_shock(shock_damage)
	..()
	factory_efficiency = max(0, factory_efficiency - 200)

/datum/nanite_program/protocol/factory/on_minor_shock()
	..()
	factory_efficiency = max(0, factory_efficiency - 100)

/datum/nanite_program/protocol/factory/active_effect()
	factory_efficiency = min(factory_efficiency + 1, max_efficiency)
	nanites.adjust_nanites(null, round(0.002 * factory_efficiency, 0.1))

/datum/nanite_program/protocol/pyramid
	name = "Протокол репликации: Пирамида"
	desc = "Наниты реализуют альтернативный протокол совместной репликации, который является более эффективным, пока уровень насыщения превышает 80% ускоряет репликацию на +1,2 единиц."
	use_rate = 0
	rogue_types = list(/datum/nanite_program/necrotic)
	protocol_class = NANITE_PROTOCOL_REPLICATION
	var/boost = 1.2

/datum/nanite_program/protocol/pyramid/check_conditions()
	if((nanites.nanite_volume / nanites.max_nanites) < 0.8)
		return FALSE

	return ..()

/datum/nanite_program/protocol/pyramid/active_effect()
	nanites.adjust_nanites(null, boost)

/datum/nanite_program/protocol/offline
	name = "Протокол репликации: Затмение"
	desc = "Пока носитель спит или находится без сознания, использует освободившиеся ресурсы мозга для ускорения репликации на +3 единицы."
	use_rate = 0
	rogue_types = list(/datum/nanite_program/necrotic)
	protocol_class = NANITE_PROTOCOL_REPLICATION
	var/boost = 3


/datum/nanite_program/protocol/offline/check_conditions()
	if(nanites.host_mob.stat == CONSCIOUS)
		return FALSE
	return ..()


/datum/nanite_program/protocol/offline/active_effect()
	nanites.adjust_nanites(null, boost)

/datum/nanite_program/protocol/hive
	name = "Протокол хранения: Улей"
	desc = "Наниты реорганизуются в более упорядоченную структуру, увеличивая свою максимальную численность на +250 единиц, без каких либо негативных последствий."
	use_rate = 0
	rogue_types = list(/datum/nanite_program/necrotic)
	protocol_class = NANITE_PROTOCOL_STORAGE
	var/extra_volume = 250

/datum/nanite_program/protocol/hive/enable_passive_effect()
	. = ..()
	nanites.set_max_volume(null, nanites.max_nanites + extra_volume)

/datum/nanite_program/protocol/hive/disable_passive_effect()
	. = ..()
	nanites.set_max_volume(null, nanites.max_nanites - extra_volume)

/datum/nanite_program/protocol/zip
	name = "Протокол хранения: Архивация"
	desc = "Наниты уплотняются до более крупных массивов, тем самым увеличивая свою максимальную численность на +500 единиц, однако всвязи с сложностью процесса замедляют репликацию на -0.2 единиц."
	use_rate = 0.2
	rogue_types = list(/datum/nanite_program/necrotic)
	protocol_class = NANITE_PROTOCOL_STORAGE
	var/extra_volume = 500

/datum/nanite_program/protocol/zip/enable_passive_effect()
	. = ..()
	nanites.set_max_volume(null, nanites.max_nanites + extra_volume)

/datum/nanite_program/protocol/zip/disable_passive_effect()
	. = ..()
	nanites.set_max_volume(null, nanites.max_nanites - extra_volume)

/datum/nanite_program/protocol/free_range
	name = "Протокол хранения: Упрощение"
	desc = "Наниты отключают стандартные параметры структуризации, тем самым уменьшая свою максимальную численность на -250 единиц, однако увеличивая скорость репликации на +0.5 единиц."
	use_rate = 0
	rogue_types = list(/datum/nanite_program/necrotic)
	protocol_class = NANITE_PROTOCOL_STORAGE
	var/boost = 0.5
	var/extra_volume = -250

/datum/nanite_program/protocol/free_range/enable_passive_effect()
	. = ..()
	nanites.set_max_volume(null, nanites.max_nanites + extra_volume)

/datum/nanite_program/protocol/free_range/disable_passive_effect()
	. = ..()
	nanites.set_max_volume(null, nanites.max_nanites - extra_volume)

/datum/nanite_program/protocol/free_range/active_effect()
	nanites.adjust_nanites(null, boost)

/datum/nanite_program/protocol/unsafe_storage
	name = "Протокол хранения: Опасность"
	desc = "Наниты полностью отключают протоколы безопасности, тем самым увеличивая свою максимальную численность на +1500 единиц, однако это может оказывать серьезный вред внутренним органам носителя."
	use_rate = 0
	rogue_types = list(/datum/nanite_program/necrotic)
	protocol_class = NANITE_PROTOCOL_STORAGE
	var/extra_volume = 1500
	var/next_warning = 0
	var/min_warning_cooldown = 120
	var/max_warning_cooldown = 350
	var/volume_warnings_stage_1 = list(
		"Чувствую тупую боль в правом боку.",
		"Испытываю дискомфорт в правом боку."
	)
	var/volume_warnings_stage_2 = list(
		"Чувствую резкую боль в животе.",
		"Больно дышать.",
		"Живот болит.",
		"Испытываю дискомфорт в горле.",
		"Испытываю дискомфорт в животе.",
		"Испытываю дискомфорт в легких.",
		"Дыхание затруднено."
	)
	var/volume_warnings_stage_3 = list(
		"Чувствую резкую боль в груди.",
		"Слышу звон в ушах.",
		"В голове непрекращающийся звон.",
		"Голова раскалывается."
	)
	var/volume_warnings_stage_4 = list(
		"Чувствую резкую боль в глазах.",
		"Глаза режет.",
		"В ушах чудовищное эхо.",
		"Меня трясет.",
		"Глаза слезятся.",
		"Уши болят.",
		"Перед глазами какая-то серая пыль."
	)
	var/volume_warnings_stage_5 = list(
		"Мне плохо.",
		"Каждая клеточка моего тела ноет от боли.",
		"Меня сейчас вырвет."
	)
	var/volume_warnings_stage_6 = list(
		"Кожа чешется и горит.",
		"Мышцы болят.",
		"Я очень, очень устал.",
		"Такое ощущение, что под моей кожей что-то шевелится.",
	)

/datum/nanite_program/protocol/unsafe_storage/enable_passive_effect()
	. = ..()
	nanites.set_max_volume(null, nanites.max_nanites + extra_volume)

/datum/nanite_program/protocol/unsafe_storage/disable_passive_effect()
	. = ..()
	nanites.set_max_volume(null, nanites.max_nanites - extra_volume)

/datum/nanite_program/protocol/unsafe_storage/active_effect()
	if(!iscarbon(host_mob))
		if(prob(10))
			host_mob.adjustBruteLoss(((max(nanites.nanite_volume - 450, 0) / 450) ** 2 ) * 0.5) // 0.5 -> 2 -> 4.5 -> 8 damage per successful tick
		return

	var/mob/living/carbon/C = host_mob

	if(nanites.nanite_volume < 500)
		return

	var/current_stage = 0
	if(nanites.nanite_volume > 500) //Liver is the main hub of nanite replication and the first to be threatened by excess volume
		if(prob(10))
			var/obj/item/organ/liver/liver = C.get_organ_slot(ORGAN_SLOT_LIVER)
			if(liver)
				liver.applyOrganDamage(0.6)
		current_stage++
	if(nanites.nanite_volume > 750) //Extra volume spills out in other central organs
		if(prob(10))
			var/obj/item/organ/stomach/stomach = C.get_organ_slot(ORGAN_SLOT_STOMACH)
			if(stomach)
				stomach.applyOrganDamage(0.75)
		if(prob(10))
			var/obj/item/organ/lungs/lungs = C.get_organ_slot(ORGAN_SLOT_LUNGS)
			if(lungs)
				lungs.applyOrganDamage(0.75)
		current_stage++
	if(nanites.nanite_volume > 1000) //Extra volume spills out in more critical organs
		if(prob(10))
			var/obj/item/organ/heart/heart = C.get_organ_slot(ORGAN_SLOT_HEART)
			if(heart)
				heart.applyOrganDamage(0.75)
		if(prob(10))
			var/obj/item/organ/brain/brain = C.get_organ_slot(ORGAN_SLOT_BRAIN)
			if(brain)
				brain.applyOrganDamage(0.75)
		current_stage++
	if(nanites.nanite_volume > 1250) //Excess nanites start invading smaller organs for more space, including sensory organs
		if(prob(13))
			var/obj/item/organ/eyes/eyes = C.get_organ_slot(ORGAN_SLOT_EYES)
			if(eyes)
				eyes.applyOrganDamage(0.75)
		if(prob(13))
			var/obj/item/organ/ears/ears = C.get_organ_slot(ORGAN_SLOT_EARS)
			if(ears)
				ears.applyOrganDamage(0.75)
		current_stage++
	if(nanites.nanite_volume > 1500) //Nanites start spilling into the bloodstream, causing toxicity
		if(prob(15))
			C.adjustToxLoss(0.5, TRUE, forced = TRUE) //Not healthy for slimepeople either
		current_stage++
	if(nanites.nanite_volume > 1750) //Nanites have almost reached their physical limit, and the pressure itself starts causing tissue damage
		if(prob(15))
			C.adjustBruteLoss(0.75, TRUE)
		current_stage++

	volume_warning(current_stage)

/datum/nanite_program/protocol/unsafe_storage/proc/volume_warning(tier)
	if(world.time < next_warning)
		return

	var/list/main_warnings
	var/list/extra_warnings

	switch(tier)
		if(1)
			main_warnings = volume_warnings_stage_1
			extra_warnings = null
		if(2)
			main_warnings = volume_warnings_stage_2
			extra_warnings = volume_warnings_stage_1
		if(3)
			main_warnings = volume_warnings_stage_3
			extra_warnings = volume_warnings_stage_1 + volume_warnings_stage_2
		if(4)
			main_warnings = volume_warnings_stage_4
			extra_warnings = volume_warnings_stage_1 + volume_warnings_stage_2 + volume_warnings_stage_3
		if(5)
			main_warnings = volume_warnings_stage_5
			extra_warnings = volume_warnings_stage_1 + volume_warnings_stage_2 + volume_warnings_stage_3 + volume_warnings_stage_4
		if(6)
			main_warnings = volume_warnings_stage_6
			extra_warnings = volume_warnings_stage_1 + volume_warnings_stage_2 + volume_warnings_stage_3 + volume_warnings_stage_4 + volume_warnings_stage_5

	if(prob(35))
		to_chat(host_mob, span_warning("[pick(main_warnings)]"))
		next_warning = world.time + rand(min_warning_cooldown, max_warning_cooldown)
	else if(islist(extra_warnings))
		to_chat(host_mob, span_warning("[pick(extra_warnings)]"))
		next_warning = world.time + rand(min_warning_cooldown, max_warning_cooldown)

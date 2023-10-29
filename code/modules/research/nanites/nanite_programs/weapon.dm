//Programs specifically engineered to cause harm to either the user or its surroundings (as opposed to ones that only do it due to broken programming)
//Very dangerous!

/datum/nanite_program/flesh_eating
	name = "Клеточный распад"
	desc = "Наниты разрушают клеточные структуры в организме носителя, причиняя сильный физический урон."
	use_rate = 1.5
	rogue_types = list(/datum/nanite_program/necrotic)

/datum/nanite_program/flesh_eating/active_effect()
	if(iscarbon(host_mob))
		var/mob/living/carbon/C = host_mob
		C.take_bodypart_damage(1, 0, 0)
	else
		host_mob.adjustBruteLoss(1, TRUE)
	if(prob(3))
		to_chat(host_mob, span_warning("You feel a stab of pain from somewhere inside you."))

/datum/nanite_program/poison
	name = "Отравление"
	desc = "Наниты доставляют ядовитые химикаты во внутренние органы носителя, вызывая токсический урон и рвоту."
	use_rate = 1.5
	rogue_types = list(/datum/nanite_program/toxic)

/datum/nanite_program/poison/active_effect()
	host_mob.adjustToxLoss(1)
	if(prob(2))
		to_chat(host_mob, span_warning("You feel nauseous."))
		if(iscarbon(host_mob))
			var/mob/living/carbon/C = host_mob
			C.vomit(20)

/datum/nanite_program/memory_leak
	name = "Сбой базы данных"
	desc = "Эта программа внедряется в память, используемую другими программами, вызывая частые ошибки и глюки."
	use_rate = 0
	rogue_types = list(/datum/nanite_program/toxic)

/datum/nanite_program/memory_leak/active_effect()
	if(prob(6))
		var/datum/nanite_program/target = pick(nanites.programs)
		if(target == src)
			return
		target.software_error()
		host_mob.investigate_log("[target] nanite program received a software error due to Memory Leak program.", INVESTIGATE_NANITES)

/datum/nanite_program/aggressive_replication
	name = "Агрессивная репликация"
	desc = "Наниты поглощают органическую материю для ускорения процесса репликации, повреждая клетки носителя."
	use_rate = 1
	rogue_types = list(/datum/nanite_program/necrotic)

/datum/nanite_program/aggressive_replication/active_effect()
	var/extra_regen = round(nanites.nanite_volume / 200, 0.1)
	nanites.adjust_nanites(null, extra_regen)
	host_mob.adjustBruteLoss(extra_regen / 2, TRUE)

/datum/nanite_program/meltdown
	name = "Расплавление"
	desc = "Наниты начинают плавиться, вызывая внутренние ожоги и быстро уничтожая рой нанитов. Уменьшает порог безопасности нанитов до 0 при активации."
	use_rate = 10
	rogue_types = list(/datum/nanite_program/glitch)

/datum/nanite_program/meltdown/active_effect()
	host_mob.adjustFireLoss(3.5)

/datum/nanite_program/meltdown/enable_passive_effect()
	. = ..()
	to_chat(host_mob, span_userdanger("Your blood is burning!"))
	nanites.safety_threshold = 0

/datum/nanite_program/meltdown/disable_passive_effect()
	. = ..()
	to_chat(host_mob, span_warning("Your blood cools down, and the pain gradually fades."))

/datum/nanite_program/explosive
	name = "Цепная детонация"
	desc = "Взрывает все наниты в организме носителя при активации."
	can_trigger = TRUE
	trigger_cost = 25 //plus every idle nanite left afterwards
	trigger_cooldown = 100 //Just to avoid double-triggering
	rogue_types = list(/datum/nanite_program/toxic)

/datum/nanite_program/explosive/on_trigger(comm_message)
	host_mob.visible_message(span_warning("Кожа [host_mob] начинает светится в беспорядочном, но все более и более нарастающем темпе...") ,\
							span_userdanger("Моя кожа начинает светится в беспорядочном, но все более и более нарастающем темпе..."))
	addtimer(CALLBACK(src, PROC_REF(boom)), clamp((nanites.nanite_volume * 0.35), 25, 150))

/datum/nanite_program/explosive/proc/boom()
	dyn_explosion(host_mob, nanites.nanite_volume / 50)
	qdel(nanites)

//TODO make it defuse if triggered again

/datum/nanite_program/heart_stop
	name = "Остановка сердца"
	desc = "Останавливает сердце носителя, повторная активация запускает его вновь."
	can_trigger = TRUE
	trigger_cost = 12
	trigger_cooldown = 10
	rogue_types = list(/datum/nanite_program/nerve_decay)

/datum/nanite_program/heart_stop/on_trigger(comm_message)
	if(iscarbon(host_mob))
		var/mob/living/carbon/C = host_mob
		var/obj/item/organ/heart/heart = C.get_organ_slot(ORGAN_SLOT_HEART)
		if(heart)
			if(heart.beating)
				heart.Stop()
			else
				heart.Restart()

/datum/nanite_program/emp
	name = "Электромагнитный резонанс"
	desc = "Наниты вызывают электромагнитный импульс рядом с носителем. Может повредить другие программы!"
	can_trigger = TRUE
	trigger_cost = 10
	trigger_cooldown = 50
	program_flags = NANITE_EMP_IMMUNE
	rogue_types = list(/datum/nanite_program/toxic)

/datum/nanite_program/emp/on_trigger(comm_message)
	empulse(host_mob, 1, 2)

/datum/nanite_program/pyro
	name = "Подкожное возгорание"
	desc = "Наниты перестраивают жировые клетки в горючую жидкость под кожей носителя, а потом поджигают её."
	use_rate = 4
	rogue_types = list(/datum/nanite_program/skin_decay, /datum/nanite_program/cryo)

/datum/nanite_program/pyro/check_conditions()
	if(host_mob.fire_stacks >= 10 && host_mob.on_fire)
		return FALSE
	return ..()

/datum/nanite_program/pyro/active_effect()
	host_mob.adjust_fire_stacks(1)
	host_mob.ignite_mob()

/datum/nanite_program/cryo
	name = "Криогенная обработка"
	desc = "Наниты быстро выпускают тепло через кожу носителя, понижая свою температуру."
	use_rate = 1
	rogue_types = list(/datum/nanite_program/skin_decay, /datum/nanite_program/pyro)

/datum/nanite_program/cryo/check_conditions()
	if(host_mob.bodytemperature <= 70)
		return FALSE
	return ..()

/datum/nanite_program/cryo/active_effect()
	host_mob.adjust_bodytemperature(-rand(15,25), 50)

/datum/nanite_program/comm/mind_control
	name = "Контроль разума"
	desc = "Наниты впечатывают в мозг носителя абсолютную инструкцию на 60 секунд при активации. Можно использовать с пультом отправки сообщений."
	trigger_cost = 30
	trigger_cooldown = 1800
	rogue_types = list(/datum/nanite_program/brain_decay, /datum/nanite_program/brain_misfire)

/datum/nanite_program/comm/mind_control/register_extra_settings()
	. = ..()
	extra_settings[NES_DIRECTIVE] = new /datum/nanite_extra_setting/text("...")

/datum/nanite_program/comm/mind_control/on_trigger(comm_message)
	if(host_mob.stat == DEAD)
		return
	var/sent_directive = comm_message
	if(!comm_message)
		var/datum/nanite_extra_setting/ES = extra_settings[NES_DIRECTIVE]
		sent_directive = ES.get_value()
	brainwash(host_mob, sent_directive)
	log_game("A mind control nanite program brainwashed [key_name(host_mob)] with the objective '[sent_directive]'.")
	addtimer(CALLBACK(src, PROC_REF(end_brainwashing)), 600)

/datum/nanite_program/comm/mind_control/proc/end_brainwashing()
	if(host_mob.mind && host_mob.mind.has_antag_datum(/datum/antagonist/brainwashed))
		host_mob.mind.remove_antag_datum(/datum/antagonist/brainwashed)
	log_game("[key_name(host_mob)] is no longer brainwashed by nanites.")

/datum/nanite_program/comm/mind_control/disable_passive_effect()
	. = ..()
	end_brainwashing()

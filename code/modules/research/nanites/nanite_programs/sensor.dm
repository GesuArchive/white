/datum/nanite_program/sensor
	name = "Сенсор нанитов"
	desc = "Наниты отпраляют сигнал, когда выполняется определенное условие."
	unique = FALSE
	var/can_rule = FALSE

/datum/nanite_program/sensor/register_extra_settings()
	extra_settings[NES_SENT_CODE] = new /datum/nanite_extra_setting/number(0, 1, 9999)

/datum/nanite_program/sensor/proc/check_event()
	return FALSE

/datum/nanite_program/sensor/proc/send_code()
	if(activated)
		var/datum/nanite_extra_setting/ES = extra_settings[NES_SENT_CODE]
		SEND_SIGNAL(host_mob, COMSIG_NANITE_SIGNAL, ES.value, "a [name] program")

/datum/nanite_program/sensor/active_effect()
	if(check_event())
		send_code()

/datum/nanite_program/sensor/proc/make_rule(datum/nanite_program/target)
	return

/datum/nanite_program/sensor/repeat
	name = "Ретранслятор сигнала"
	desc = "При активации отправляет носителю сигнал, с настраиваемой задержкой. Используется при отправке нескольких кодов в одной программе."
	can_trigger = TRUE
	trigger_cost = 0
	trigger_cooldown = 10
	var/spent = FALSE

/datum/nanite_program/sensor/repeat/register_extra_settings()
	. = ..()
	extra_settings[NES_DELAY] = new /datum/nanite_extra_setting/number(0, 0, 3600, "s")

/datum/nanite_program/sensor/repeat/on_trigger(comm_message)
	var/datum/nanite_extra_setting/ES = extra_settings[NES_DELAY]
	addtimer(CALLBACK(src, PROC_REF(send_code)), ES.get_value() * 10)

/datum/nanite_program/sensor/relay_repeat
	name = "Ретранслятор - передатчик"
	desc = "При активации отправляет сигнал вовне по каналу передатчика, с настраиваемой задержкой."
	can_trigger = TRUE
	trigger_cost = 0
	trigger_cooldown = 10
	var/spent = FALSE

/datum/nanite_program/sensor/relay_repeat/register_extra_settings()
	. = ..()
	extra_settings[NES_RELAY_CHANNEL] = new /datum/nanite_extra_setting/number(1, 1, 9999)
	extra_settings[NES_DELAY] = new /datum/nanite_extra_setting/number(0, 0, 3600, "s")

/datum/nanite_program/sensor/relay_repeat/on_trigger(comm_message)
	var/datum/nanite_extra_setting/ES = extra_settings[NES_DELAY]
	addtimer(CALLBACK(src, PROC_REF(send_code)), ES.get_value() * 10)

/datum/nanite_program/sensor/relay_repeat/send_code()
	var/datum/nanite_extra_setting/relay = extra_settings[NES_RELAY_CHANNEL]
	if(activated && relay.get_value())
		for(var/X in SSnanites.nanite_relays)
			var/datum/nanite_program/relay/N = X
			var/datum/nanite_extra_setting/code = extra_settings[NES_SENT_CODE]
			N.relay_signal(code.get_value(), relay.get_value(), "a [name] program")

/datum/nanite_program/sensor/health
	name = "Сенсор здоровья"
	desc = "Наниты отправляют сигнал, когда здоровье носителя выше или ниже установленного процента (носитель в критическом состоянии расценивается как 0%)."
	can_rule = TRUE
	var/spent = FALSE

/datum/nanite_program/sensor/health/register_extra_settings()
	. = ..()
	extra_settings[NES_HEALTH_PERCENT] = new /datum/nanite_extra_setting/number(50, -99, 100, "%")
	extra_settings[NES_DIRECTION] = new /datum/nanite_extra_setting/boolean(TRUE, "Above", "Below")

/datum/nanite_program/sensor/health/check_event()
	var/health_percent = host_mob.health / host_mob.maxHealth * 100
	var/datum/nanite_extra_setting/percent = extra_settings[NES_HEALTH_PERCENT]
	var/datum/nanite_extra_setting/direction = extra_settings[NES_DIRECTION]
	var/detected = FALSE
	if(direction.get_value())
		if(health_percent >= percent.get_value())
			detected = TRUE
	else
		if(health_percent < percent.get_value())
			detected = TRUE

	if(detected)
		if(!spent)
			spent = TRUE
			return TRUE
		return FALSE
	else
		spent = FALSE
		return FALSE

/datum/nanite_program/sensor/health/make_rule(datum/nanite_program/target)
	var/datum/nanite_rule/health/rule = new(target)
	var/datum/nanite_extra_setting/direction = extra_settings[NES_DIRECTION]
	var/datum/nanite_extra_setting/percent = extra_settings[NES_HEALTH_PERCENT]
	rule.above = direction.get_value()
	rule.threshold = percent.get_value()
	return rule

/datum/nanite_program/sensor/crit
	name = "Сенсор критического состояния"
	desc = "Наниты отправляют сигнал, когда здоровье носителя достигает критического состояния."
	can_rule = TRUE
	var/spent = FALSE

/datum/nanite_program/sensor/crit/check_event()
	if(HAS_TRAIT(host_mob, TRAIT_CRITICAL_CONDITION))
		if(spent)
			return FALSE
		spent = TRUE
		return TRUE
	spent = FALSE
	return FALSE


/datum/nanite_program/sensor/crit/make_rule(datum/nanite_program/target)
	var/datum/nanite_rule/crit/rule = new(target)
	return rule

/datum/nanite_program/sensor/death
	name = "Сенсор смерти"
	desc = "Наниты отправляют сигнал при смерти носителя."
	can_rule = TRUE
	var/spent = FALSE

/datum/nanite_program/sensor/death/on_death()
	send_code()

/datum/nanite_program/sensor/death/make_rule(datum/nanite_program/target)
	var/datum/nanite_rule/death/rule = new(target)
	return rule

/datum/nanite_program/sensor/nanite_volume
	name = "Сенсор количества нанитов"
	desc = "Наниты отпраляют сигнал, когда их количество становится выше или ниже заданного процента, за 0% взят заданный порог безопасности."
	can_rule = TRUE
	var/spent = FALSE

/datum/nanite_program/sensor/nanite_volume/register_extra_settings()
	. = ..()
	extra_settings[NES_NANITE_PERCENT] = new /datum/nanite_extra_setting/number(50, -99, 100, "%")
	extra_settings[NES_DIRECTION] = new /datum/nanite_extra_setting/boolean(TRUE, "Above", "Below")

/datum/nanite_program/sensor/nanite_volume/check_event()
	var/nanite_percent = (nanites.nanite_volume - nanites.safety_threshold)/(nanites.max_nanites - nanites.safety_threshold)*100
	var/datum/nanite_extra_setting/percent = extra_settings[NES_NANITE_PERCENT]
	var/datum/nanite_extra_setting/direction = extra_settings[NES_DIRECTION]
	var/detected = FALSE
	if(direction.get_value())
		if(nanite_percent >= percent.get_value())
			detected = TRUE
	else
		if(nanite_percent < percent.get_value())
			detected = TRUE

	if(detected)
		if(!spent)
			spent = TRUE
			return TRUE
		return FALSE
	else
		spent = FALSE
		return FALSE

/datum/nanite_program/sensor/nanite_volume/make_rule(datum/nanite_program/target)
	var/datum/nanite_rule/nanites/rule = new(target)
	var/datum/nanite_extra_setting/direction = extra_settings[NES_DIRECTION]
	var/datum/nanite_extra_setting/percent = extra_settings[NES_NANITE_PERCENT]
	rule.above = direction.get_value()
	rule.threshold = percent.get_value()
	return rule

/datum/nanite_program/sensor/damage
	name = "Сенсор урона"
	desc = "Наниты отправляют сигнал, когда количество определенного типа уровна становится выше или ниже заданного значения."
	can_rule = TRUE
	var/spent = FALSE

/datum/nanite_program/sensor/damage/register_extra_settings()
	. = ..()
	extra_settings[NES_DAMAGE_TYPE] = new /datum/nanite_extra_setting/type(BRUTE, list(BRUTE, BURN, TOX, OXY, CLONE))
	extra_settings[NES_DAMAGE] = new /datum/nanite_extra_setting/number(50, 0, 500)
	extra_settings[NES_DIRECTION] = new /datum/nanite_extra_setting/boolean(TRUE, "Above", "Below")

/datum/nanite_program/sensor/damage/check_event()
	var/reached_threshold = FALSE
	var/datum/nanite_extra_setting/type = extra_settings[NES_DAMAGE_TYPE]
	var/datum/nanite_extra_setting/damage = extra_settings[NES_DAMAGE]
	var/datum/nanite_extra_setting/direction = extra_settings[NES_DIRECTION]
	var/check_above =  direction.get_value()
	var/damage_amt = 0
	switch(type.get_value())
		if(BRUTE)
			damage_amt = host_mob.getBruteLoss()
		if(BURN)
			damage_amt = host_mob.getFireLoss()
		if(TOX)
			damage_amt = host_mob.getToxLoss()
		if(OXY)
			damage_amt = host_mob.getOxyLoss()
		if(CLONE)
			damage_amt = host_mob.getCloneLoss()

	if(check_above)
		if(damage_amt >= damage.get_value())
			reached_threshold = TRUE
	else
		if(damage_amt < damage.get_value())
			reached_threshold = TRUE

	if(reached_threshold)
		if(!spent)
			spent = TRUE
			return TRUE
		return FALSE
	else
		spent = FALSE
		return FALSE

/datum/nanite_program/sensor/damage/make_rule(datum/nanite_program/target)
	var/datum/nanite_rule/damage/rule = new(target)
	var/datum/nanite_extra_setting/direction = extra_settings[NES_DIRECTION]
	var/datum/nanite_extra_setting/damage_type = extra_settings[NES_DAMAGE_TYPE]
	var/datum/nanite_extra_setting/damage = extra_settings[NES_DAMAGE]
	rule.above  =  direction.get_value()
	rule.threshold = damage.get_value()
	rule.damage_type = damage_type.get_value()
	return rule

/datum/nanite_program/sensor/voice
	name = "Сенсор голоса"
	desc = "Отправляет сигнал, когда наниты слышат заданную фразу или слово."

/datum/nanite_program/sensor/voice/register_extra_settings()
	. = ..()
	extra_settings[NES_SENTENCE] = new /datum/nanite_extra_setting/text("")
	extra_settings[NES_INCLUSIVE_MODE] = new /datum/nanite_extra_setting/boolean(TRUE, "Inclusive", "Exclusive")

/datum/nanite_program/sensor/voice/on_mob_add()
	. = ..()
	RegisterSignal(host_mob, COMSIG_MOVABLE_HEAR, PROC_REF(on_hear))

/datum/nanite_program/sensor/voice/on_mob_remove()
	UnregisterSignal(host_mob, COMSIG_MOVABLE_HEAR, PROC_REF(on_hear))

/datum/nanite_program/sensor/voice/proc/on_hear(datum/source, list/hearing_args)
	var/datum/nanite_extra_setting/sentence = extra_settings[NES_SENTENCE]
	var/datum/nanite_extra_setting/inclusive = extra_settings[NES_INCLUSIVE_MODE]
	if(!sentence.get_value())
		return
	if(inclusive.get_value())
		if(findtext(hearing_args[HEARING_RAW_MESSAGE], sentence.get_value()))
			send_code()
	else
		if(lowertext(hearing_args[HEARING_RAW_MESSAGE]) == lowertext(sentence.get_value()))
			send_code()

/datum/nanite_program/sensor/species
	name = "Сенсор вида"
	desc = "При активации, наниты сканируют носителя и отправляют сигнал, если вид носителя соответствует заданному в настройках."
	can_trigger = TRUE
	trigger_cost = 0
	trigger_cooldown = 5

	var/static/list/allowed_species = list(
		"Люди" = /datum/species/human,
		"Ящеры" = /datum/species/lizard,
		"Моли" = /datum/species/moth,
		"Этериалы" = /datum/species/ethereal,
		"Дендроиды" = /datum/species/pod,
		"Мухолюди" = /datum/species/fly,
		"Фелиниды" = /datum/species/human/felinid,
		"Слаймолюди" = /datum/species/jelly,
	)

/datum/nanite_program/sensor/species/register_extra_settings()
	. = ..()
	var/list/species_types = list()
	for(var/name in allowed_species)
		species_types += name
	species_types += "Other"
	extra_settings[NES_RACE] = new /datum/nanite_extra_setting/type("Human", species_types)
	extra_settings[NES_MODE] = new /datum/nanite_extra_setting/boolean(TRUE, "Is", "Is Not")

/datum/nanite_program/sensor/species/on_trigger(comm_message)
	var/datum/nanite_extra_setting/species_type = extra_settings[NES_RACE]
	var/species = allowed_species[species_type.get_value()]
	var/species_match = FALSE

	if(species)
		if(is_species(host_mob, species))
			species_match = TRUE
	else	//this is the check for the "Other" option
		species_match = TRUE
		for(var/name in allowed_species)
			var/species_other = allowed_species[name]
			if(is_species(host_mob, species_other))
				species_match = FALSE
				break

	var/datum/nanite_extra_setting/mode = extra_settings[NES_MODE]
	if(mode.get_value())
		if(species_match)
			send_code()
	else
		if(!species_match)
			send_code()

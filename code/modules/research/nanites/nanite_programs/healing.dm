//Programs that heal the host in some way.

/datum/nanite_program/regenerative
	name = "Ускоренная регенерация"
	desc = "Наниты ускоряют естественную регенерацию носителя, медленно исцеляя его (0.5 физического и термического урона). Не потребляет наниты, пока носитель не ранен."
	use_rate = 0.5
	rogue_types = list(/datum/nanite_program/necrotic)

/datum/nanite_program/regenerative/check_conditions()
	if(!host_mob.getBruteLoss() && !host_mob.getFireLoss())
		return FALSE
	if(iscarbon(host_mob))
		var/mob/living/carbon/C = host_mob
		var/list/parts = C.get_damaged_bodyparts(TRUE,TRUE, status = BODYPART_ORGANIC)
		if(!parts.len)
			return FALSE
	return ..()

/datum/nanite_program/regenerative/active_effect()
	if(iscarbon(host_mob))
		var/mob/living/carbon/C = host_mob
		var/list/parts = C.get_damaged_bodyparts(TRUE,TRUE, status = BODYPART_ORGANIC)
		if(!parts.len)
			return
		for(var/obj/item/bodypart/L in parts)
			if(L.heal_damage(0.5/parts.len, 0.5/parts.len, null, BODYPART_ORGANIC))
				host_mob.update_damage_overlays()
	else
		host_mob.adjustBruteLoss(-0.5, TRUE)
		host_mob.adjustFireLoss(-0.5, TRUE)

/datum/nanite_program/temperature
	name = "Регулировка температуры"
	desc = "Наниты регулируют температуру тела носителя до идеального уровня. Не потребляет наниты, пока температура на идеальном уровне."
	use_rate = 3.5
	rogue_types = list(/datum/nanite_program/skin_decay)

/datum/nanite_program/temperature/check_conditions()
	if(host_mob.bodytemperature > (host_mob.get_body_temp_normal(apply_change=FALSE) - 30) && host_mob.bodytemperature < (host_mob.get_body_temp_normal(apply_change=FALSE) + 30))
		return FALSE
	return ..()

/datum/nanite_program/temperature/active_effect()
	var/target_temp = host_mob.get_body_temp_normal(apply_change=FALSE)
	if(host_mob.bodytemperature > target_temp)
		host_mob.adjust_bodytemperature(-40 * TEMPERATURE_DAMAGE_COEFFICIENT, target_temp)
	else if(host_mob.bodytemperature < (target_temp + 1))
		host_mob.adjust_bodytemperature(40 * TEMPERATURE_DAMAGE_COEFFICIENT, 0, target_temp)

/datum/nanite_program/purging
	name = "Очистка крови"
	desc = "Наниты очищают кровь носителя на 1 единицу токсического урона и на 1 единицу всех химикатов в крови. Непрерывно расходует наниты пока включена."
	use_rate = 1
	rogue_types = list(/datum/nanite_program/suffocating, /datum/nanite_program/necrotic)

/datum/nanite_program/purging/check_conditions()
	. = ..()
	if(!. || !host_mob.reagents)
		return FALSE // No trying to purge simple mobs

/datum/nanite_program/purging/active_effect()
	host_mob.adjustToxLoss(-1)
	for(var/datum/reagent/R in host_mob.reagents.reagent_list)
		host_mob.reagents.remove_reagent(R.type,1)

/datum/nanite_program/brain_heal
	name = "Восстановление нейронов"
	desc = "Наниты исправляют нейронные соединения в мозге носителя, излечивая повреждения мозга и легкие мозговые травмы. Лечит 1 единицу повреждений мозга и имеет 10% шанс на исцеление небольших травм мозга. Не потребляет наниты, если мозг носителя цел."
	use_rate = 1.5
	rogue_types = list(/datum/nanite_program/brain_decay)

/datum/nanite_program/brain_heal/check_conditions()
	if(host_mob.getOrganLoss(ORGAN_SLOT_BRAIN) > 0)
		return ..()
	if(iscarbon(host_mob))
		var/mob/living/carbon/C = host_mob
		if ( C.has_trauma_type( resilience = TRAUMA_RESILIENCE_BASIC) )
			return ..()
	return FALSE

/datum/nanite_program/brain_heal/active_effect()
	host_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, -1)
	if(iscarbon(host_mob) && prob(10))
		var/mob/living/carbon/C = host_mob
		C.cure_trauma_type(resilience = TRAUMA_RESILIENCE_BASIC)

/datum/nanite_program/blood_restoring
	name = "Восстановление крови"
	desc = "Наниты ускоряют процесс создания кровяных клеток в организме носителя. Не потребляет наниты, если крови в теле носителя достаточно."
	use_rate = 1
	rogue_types = list(/datum/nanite_program/suffocating)

/datum/nanite_program/blood_restoring/check_conditions()
	if(iscarbon(host_mob))
		var/mob/living/carbon/C = host_mob
		if(C.blood_volume >= BLOOD_VOLUME_SAFE)
			return FALSE
	else
		return FALSE
	return ..()

/datum/nanite_program/blood_restoring/active_effect()
	if(iscarbon(host_mob))
		var/mob/living/carbon/C = host_mob
		C.blood_volume += 2

/datum/nanite_program/repairing
	name = "Реконструкция механики"
	desc = "Наниты чинят механические части тела носителя. Чинит 1 единицу физического и термического урона равномерно во всех конечностях. Не потребляет наниты, если конечности не повреждены."
	use_rate = 0.5
	rogue_types = list(/datum/nanite_program/necrotic)

/datum/nanite_program/repairing/check_conditions()
	if(!host_mob.getBruteLoss() && !host_mob.getFireLoss())
		return FALSE

	if(iscarbon(host_mob))
		var/mob/living/carbon/C = host_mob
		var/list/parts = C.get_damaged_bodyparts(TRUE, TRUE, status = BODYPART_ROBOTIC)
		if(!parts.len)
			return FALSE
	else
		if(!(host_mob.mob_biotypes & MOB_ROBOTIC))
			return FALSE
	return ..()

/datum/nanite_program/repairing/active_effect(mob/living/M)
	if(iscarbon(host_mob))
		var/mob/living/carbon/C = host_mob
		var/list/parts = C.get_damaged_bodyparts(TRUE, TRUE, status = BODYPART_ROBOTIC)
		if(!parts.len)
			return
		var/update = FALSE
		for(var/obj/item/bodypart/L in parts)
			if(L.heal_damage(1/parts.len, 1/parts.len, null, BODYPART_ROBOTIC)) //much faster than organic healing
				update = TRUE
		if(update)
			host_mob.update_damage_overlays()
	else
		host_mob.adjustBruteLoss(-1, TRUE)
		host_mob.adjustFireLoss(-1, TRUE)

/datum/nanite_program/purging_advanced
	name = "Выборочная очистка крови"
	desc = "Наниты лечат 1 единицу токсического урона и выводят 1 единицу токсичных реагентов из крови носителя, игнорируя нетоксичные вещества. Для анализа состава крови требуется дополнительная вычислительная мощность, что сильно повышает потребление нанитов."
	use_rate = 2
	rogue_types = list(/datum/nanite_program/suffocating, /datum/nanite_program/necrotic)

/datum/nanite_program/purging_advanced/check_conditions()
	. = ..()
	if(!. || !host_mob.reagents)
		return FALSE

/datum/nanite_program/purging_advanced/active_effect()
	host_mob.adjustToxLoss(-1)
	for(var/datum/reagent/toxin/R in host_mob.reagents.reagent_list)
		host_mob.reagents.remove_reagent(R.type,1)

/datum/nanite_program/regenerative_advanced
	name = "Био-реконструкция"
	desc = "Наниты вручную восстанавливают и заменяют клетки тела, делая это гораздо быстрее обычной регенерации. Лечит 2 физического и термического урона. Однако, эта программа не может отличить поврежденные клетки от неповрежденных, используя наниты, даже если организм цел."
	use_rate = 5.5
	rogue_types = list(/datum/nanite_program/suffocating, /datum/nanite_program/necrotic)

/datum/nanite_program/regenerative_advanced/active_effect()
	if(iscarbon(host_mob))
		var/mob/living/carbon/C = host_mob
		var/list/parts = C.get_damaged_bodyparts(TRUE,TRUE, status = BODYPART_ORGANIC)
		if(!parts.len)
			return
		var/update = FALSE
		for(var/obj/item/bodypart/L in parts)
			if(L.heal_damage(2/parts.len, 2/parts.len, null, BODYPART_ORGANIC))
				update = TRUE
		if(update)
			host_mob.update_damage_overlays()
	else
		host_mob.adjustBruteLoss(-2, TRUE)
		host_mob.adjustFireLoss(-2, TRUE)

/datum/nanite_program/brain_heal_advanced
	name = "Нейронная пересборка"
	desc = "Наниты становятся способны сохранять и восстанавливать нейронные соединения, теоретически даже восстанавливая отсутствующие или поврежденные участки мозга. Лечит 2 единицы урона мозгу и с 10% шансом могут исцелить даже самые тяжелые травмы мозга. Непрерывно расходует наниты пока включена."
	use_rate = 3
	rogue_types = list(/datum/nanite_program/brain_decay, /datum/nanite_program/brain_misfire)

/datum/nanite_program/brain_heal_advanced/active_effect()
	host_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, -2)
	if(iscarbon(host_mob) && prob(10))
		var/mob/living/carbon/C = host_mob
		C.cure_trauma_type(resilience = TRAUMA_RESILIENCE_LOBOTOMY)

/datum/nanite_program/defib
	name = "Дефибрилляция"
	desc = "При активации дает разряд тока в сердце носителя, запуская его, если тело может это выдержать. Реанимация такого плана имеет такие же требования, как и обычная дефибрилляция. Не вызывает удушье."
	can_trigger = TRUE
	trigger_cost = 25
	trigger_cooldown = 120
	rogue_types = list(/datum/nanite_program/shocking)

/datum/nanite_program/defib/on_trigger(comm_message)
	host_mob.notify_ghost_cloning("Мое сердце было запущено благодаря нанитам! Необходимо срочно вернуться в тело!")
	addtimer(CALLBACK(src, PROC_REF(zap)), 50)

/datum/nanite_program/defib/proc/check_revivable()
	if(!iscarbon(host_mob)) //nonstandard biology
		return FALSE
	var/mob/living/carbon/C = host_mob
	if(C.get_ghost())
		return FALSE
	return C.can_defib() == DEFIB_POSSIBLE

/datum/nanite_program/defib/proc/zap()
	var/mob/living/carbon/C = host_mob
	playsound(C, 'sound/machines/defib_charge.ogg', 50, FALSE)
	sleep(30)
	playsound(C, 'sound/machines/defib_zap.ogg', 50, FALSE)
	if(check_revivable())
		//copypaste from paddles code
		var/total_brute = C.getBruteLoss()
		var/total_burn = C.getFireLoss()

		//always setup health to be at least 5%, so you will get up by yourself in some time
		if (C.health > 5)
			C.adjustOxyLoss(C.health - 5, 0)
		else
			var/overall_damage = total_brute + total_burn + C.getToxLoss() + C.getOxyLoss()
			var/mobhealth = C.health
			C.adjustOxyLoss((mobhealth - 5) * (C.getOxyLoss() / overall_damage), 0)
			C.adjustToxLoss((mobhealth - 5) * (C.getToxLoss() / overall_damage), 0)
			C.adjustFireLoss((mobhealth - 5) * (total_burn / overall_damage), 0)
			C.adjustBruteLoss((mobhealth - 5) * (total_brute / overall_damage), 0)
		C.updatehealth() // Previous "adjust" procs don't update health, so we do it manually.
		playsound(C, 'sound/machines/defib_success.ogg', 50, FALSE)
		C.set_heartattack(FALSE)
		C.revive(full_heal = FALSE, admin_revive = FALSE)
		C.emote("gasp")
		C.Jitter(100)
		SEND_SIGNAL(C, COMSIG_LIVING_MINOR_SHOCK)
		log_game("[C] has been successfully defibrillated by nanites.")
	else
		playsound(C, 'sound/machines/defib_failed.ogg', 50, FALSE)


/obj/item/organ/cyberimp/chest
	name = "кибернетический имплант туловища"
	desc = "Импланты для органов туловища."
	icon_state = "chest_implant"
	implant_overlay = "chest_implant_overlay"
	zone = BODY_ZONE_CHEST

/obj/item/organ/cyberimp/chest/nutriment
	name = "имплант \"питательный насос\""
	desc = "Этот имплант синтезирует и закачаивает в ваш кровосток небольшое количество питательных веществ и жидкости если вы голодаете."
	icon_state = "chest_implant"
	implant_color = "#00AA00"
	var/hunger_threshold = NUTRITION_LEVEL_STARVING
	var/hydration_threshold = HYDRATION_LEVEL_THIRSTY
	var/synthesizing = 0
	var/poison_amount = 5
	slot = ORGAN_SLOT_STOMACH_AID

/obj/item/organ/cyberimp/chest/nutriment/on_life(delta_time, times_fired)
	if(synthesizing)
		return

	if(owner.nutrition <= hunger_threshold)
		synthesizing = TRUE
		to_chat(owner, span_notice("Чуство голода немного притупилось..."))
		owner.adjust_nutrition(25 * delta_time)
		addtimer(CALLBACK(src, PROC_REF(synth_cool)), 50)

	if(owner.hydration <= hydration_threshold)
		synthesizing = TRUE
		to_chat(owner, span_notice("Жажда мучает не так сильно..."))
		owner.hydration = owner.hydration + 20
		addtimer(CALLBACK(src, PROC_REF(synth_cool)), 50)

/obj/item/organ/cyberimp/chest/nutriment/proc/synth_cool()
	synthesizing = FALSE

/obj/item/organ/cyberimp/chest/nutriment/emp_act(severity)
	. = ..()
	if(!owner || . & EMP_PROTECT_SELF)
		return
	owner.reagents.add_reagent(/datum/reagent/toxin/bad_food, poison_amount / severity)
	to_chat(owner, span_warning("Чувствую будто мои внутренности горят."))


/obj/item/organ/cyberimp/chest/nutriment/plus
	name = "имплант \"питательный насос ПЛЮС\""
	desc = "Этот имплант полностью перекрывает все потребности в пище и жидкости."
	icon_state = "chest_implant"
	implant_color = "#006607"
	hunger_threshold = NUTRITION_LEVEL_HUNGRY
	hydration_threshold = HYDRATION_LEVEL_NORMAL
	poison_amount = 10

/obj/item/organ/cyberimp/chest/reviver
	name = "имплант \"Реаниматор\""
	desc = "Этот имплант постарается привести вас в чуство и исцелить если вы потеряете сознание. Для слабонервных!"
	icon_state = "chest_implant"
	implant_color = "#AD0000"
	slot = ORGAN_SLOT_HEART_AID
	var/revive_cost = 0
	var/reviving = FALSE
	COOLDOWN_DECLARE(reviver_cooldown)


/obj/item/organ/cyberimp/chest/reviver/on_life(delta_time, times_fired)
	if(reviving)
		switch(owner.stat)
			if(UNCONSCIOUS, HARD_CRIT)
				addtimer(CALLBACK(src, PROC_REF(heal)), 3 SECONDS)
			else
				COOLDOWN_START(src, reviver_cooldown, revive_cost)
				reviving = FALSE
				to_chat(owner, span_notice("Имплант \"Реаниматор\" выключается и начинает перезаряжаться. Он будет готов через [DisplayTimeText(revive_cost)]."))
		return

	if(!COOLDOWN_FINISHED(src, reviver_cooldown) || owner.suiciding)
		return

	switch(owner.stat)
		if(UNCONSCIOUS, HARD_CRIT)
			revive_cost = 0
			reviving = TRUE
			to_chat(owner, span_notice("Чувствую слабое жужжание, похоже имлант \"Реаниматор\" начал латать мои раны..."))


/obj/item/organ/cyberimp/chest/reviver/proc/heal()
	if(owner.getOxyLoss())
		owner.adjustOxyLoss(-5)
		revive_cost += 5
	if(owner.getBruteLoss())
		owner.adjustBruteLoss(-2)
		revive_cost += 40
	if(owner.getFireLoss())
		owner.adjustFireLoss(-2)
		revive_cost += 40
	if(owner.getToxLoss())
		owner.adjustToxLoss(-1)
		revive_cost += 40

/obj/item/organ/cyberimp/chest/reviver/emp_act(severity)
	. = ..()
	if(!owner || . & EMP_PROTECT_SELF)
		return

	if(reviving)
		revive_cost += 200
	else
		reviver_cooldown += 20 SECONDS

	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(H.stat != DEAD && prob(50 / severity) && H.can_heartattack())
			H.set_heartattack(TRUE)
			to_chat(H, span_userdanger("Чувствую ужасную боль в груди!"))
			addtimer(CALLBACK(src, PROC_REF(undo_heart_attack)), 600 / severity)

/obj/item/organ/cyberimp/chest/reviver/proc/undo_heart_attack()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return
	H.set_heartattack(FALSE)
	if(H.stat == CONSCIOUS)
		to_chat(H, span_notice("Чувствую, что мое сердце вновь забилось!"))

/obj/item/organ/cyberimp/chest/thrusters
	name = "комплект маневровых имплантов"
	desc = "Имлпантируевый набор маневровых портов. Они используют газ из окружения или внутренных органов субъекта для движения в условиях нулевой гравитации. \
	В отличии от обычных джетпаков, у данного устройства нет систем стабилизации."
	slot = ORGAN_SLOT_THRUSTERS
	icon_state = "imp_jetpack"
	implant_overlay = null
	implant_color = null
	actions_types = list(/datum/action/item_action/organ_action/toggle)
	w_class = WEIGHT_CLASS_NORMAL
	var/on = FALSE
	var/datum/effect_system/trail_follow/ion/ion_trail


/obj/item/organ/cyberimp/chest/thrusters/Insert(mob/living/carbon/M, special = 0)
	. = ..()
	if(!ion_trail)
		ion_trail = new
		ion_trail.auto_process = FALSE
	ion_trail.set_up(M)

/obj/item/organ/cyberimp/chest/thrusters/Remove(mob/living/carbon/M, special = 0)
	if(on)
		toggle(silent = TRUE)
	..()

/obj/item/organ/cyberimp/chest/thrusters/ui_action_click()
	toggle()

/obj/item/organ/cyberimp/chest/thrusters/proc/toggle(silent = FALSE)
	if(!on)
		if((organ_flags & ORGAN_FAILING))
			if(!silent)
				to_chat(owner, span_warning("Кажется мой маневровый набор сломался!"))
			return FALSE
		if(allow_thrust(0.01))
			on = TRUE
			ion_trail.start()
			RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(move_react))
			owner.add_movespeed_modifier(/datum/movespeed_modifier/jetpack/cybernetic)
			RegisterSignal(owner, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(pre_move_react))
			if(!silent)
				to_chat(owner, span_notice("Включаю маневровый набор."))
	else
		ion_trail.stop()
		UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
		owner.remove_movespeed_modifier(/datum/movespeed_modifier/jetpack/cybernetic)
		UnregisterSignal(owner, COMSIG_MOVABLE_PRE_MOVE)
		if(!silent)
			to_chat(owner, span_notice("Выключаю маневровый набор."))
		on = FALSE
	update_icon()

/obj/item/organ/cyberimp/chest/thrusters/update_icon_state()
	. = ..()
	if(on)
		icon_state = "imp_jetpack-on"
	else
		icon_state = "imp_jetpack"

/obj/item/organ/cyberimp/chest/thrusters/proc/move_react()
	if(!on)//If jet dont work, it dont work
		return
	if(!owner)//Don't allow jet self using
		return
	if(!isturf(owner.loc))//You can't use jet in nowhere or in mecha/closet
		return
	if(!(owner.movement_type & FLOATING) || owner.buckled)//You don't want use jet in gravity or while buckled.
		return
	if(owner.pulledby)//You don't must use jet if someone pull you
		return
	if(owner.throwing)//You don't must use jet if you thrown
		return
	if(length(owner.client.keys_held & owner.client.movement_keys))//You use jet when press keys. yes.
		allow_thrust(0.01)

/obj/item/organ/cyberimp/chest/thrusters/proc/pre_move_react()
	ion_trail.oldposition = get_turf(owner)

/obj/item/organ/cyberimp/chest/thrusters/proc/allow_thrust(num)
	if(!owner)
		return FALSE

	var/turf/T = get_turf(owner)
	if(!T) // No more runtimes from being stuck in nullspace.
		return FALSE

	// Priority 1: use air from environment.
	var/datum/gas_mixture/environment = T.return_air()
	if(environment && environment.return_pressure() > 30)
		ion_trail.generate_effect()
		return TRUE

	// Priority 2: use plasma from internal plasma storage.
	// (just in case someone would ever use this implant system to make cyber-alien ops with jetpacks and taser arms)
	if(owner.getPlasma() >= num*100)
		owner.adjustPlasma(-num*100)
		ion_trail.generate_effect()
		return TRUE

	// Priority 3: use internals tank.
	var/obj/item/tank/I = owner.internal
	if(I && I.air_contents && I.air_contents.total_moles() > num)
		var/datum/gas_mixture/removed = I.air_contents.remove(num)
		if(removed.total_moles() > 0.005)
			T.assume_air(removed)
			ion_trail.generate_effect()
			return TRUE
		else
			T.assume_air(removed)
			ion_trail.generate_effect()

	toggle(silent = TRUE)
	return FALSE

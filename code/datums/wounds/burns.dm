
/*
	Burn wounds
*/

// TODO: well, a lot really, but specifically I want to add potential fusing of clothing/equipment on the affected area, and limb infections, though those may go in body part code
/datum/wound/burn
	name = "Ожог"
	wound_type = WOUND_BURN
	processes = TRUE
	sound_effect = 'sound/effects/wounds/sizzle1.ogg'
	wound_flags = (FLESH_WOUND | ACCEPTS_GAUZE)

	treatable_by = list(/obj/item/stack/medical/ointment, /obj/item/stack/medical/mesh) // sterilizer and alcohol will require reagent treatments, coming soon

		// Flesh damage vars
	/// How much damage to our flesh we currently have. Once both this and infestation reach 0, the wound is considered healed
	var/flesh_damage = 5
	/// Our current counter for how much flesh regeneration we have stacked from regenerative mesh/synthflesh/whatever, decrements each tick and lowers flesh_damage
	var/flesh_healing = 0

		// Infestation vars (only for severe and critical)
	/// How quickly infection breeds on this burn if we don't have disinfectant
	var/infestation_rate = 0
	/// Our current level of infection
	var/infestation = 0
	/// Our current level of sanitization/anti-infection, from disinfectants/alcohol/UV lights. While positive, totally pauses and slowly reverses infestation effects each tick
	var/sanitization = 0

	/// Once we reach infestation beyond WOUND_INFESTATION_SEPSIS, we get this many warnings before the limb is completely paralyzed (you'd have to ignore a really bad burn for a really long time for this to happen)
	var/strikes_to_lose_limb = 3


/datum/wound/burn/handle_process(delta_time, times_fired)
	. = ..()
	if(strikes_to_lose_limb == 0) // we've already hit sepsis, nothing more to do
		victim.adjustToxLoss(0.25 * delta_time)
		if(DT_PROB(0.5, delta_time))
			victim.visible_message(span_danger("Инфекция [ru_gde_zone(limb.name)] <b>[victim]</b> двигается и булькает тошнотворно!") , span_warning("Инфекция на моей [ru_gde_zone(limb.name)] течет по моим венам!"))
		return

	if(victim.reagents)
		if(victim.reagents.has_reagent(/datum/reagent/medicine/spaceacillin))
			sanitization += 0.9
		if(victim.reagents.has_reagent(/datum/reagent/space_cleaner/sterilizine/))
			sanitization += 0.9
		if(victim.reagents.has_reagent(/datum/reagent/medicine/mine_salve))
			sanitization += 0.3
			flesh_healing += 0.5

	if(limb.current_gauze)
		limb.seep_gauze(WOUND_BURN_SANITIZATION_RATE * delta_time)

	if(flesh_healing > 0) // good bandages multiply the length of flesh healing
		var/bandage_factor = (limb.current_gauze ? limb.current_gauze.splint_factor : 1)
		flesh_damage = max(flesh_damage - (0.5 * delta_time), 0)
		flesh_healing = max(flesh_healing - (0.5 * bandage_factor * delta_time), 0) // good bandages multiply the length of flesh healing

	// if we have little/no infection, the limb doesn't have much burn damage, and our nutrition is good, heal some flesh
	if(infestation <= WOUND_INFECTION_MODERATE && (limb.burn_dam < 5) && (victim.nutrition >= NUTRITION_LEVEL_FED))
		flesh_healing += 0.2

	// here's the check to see if we're cleared up
	if((flesh_damage <= 0) && (infestation <= WOUND_INFECTION_MODERATE))
		to_chat(victim, span_green("Ожоги на моей [ru_gde_zone(limb.name)] пропадают!"))
		qdel(src)
		return

	// sanitization is checked after the clearing check but before the actual ill-effects, because we freeze the effects of infection while we have sanitization
	if(sanitization > 0)
		var/bandage_factor = (limb.current_gauze ? limb.current_gauze.splint_factor : 1)
		infestation = max(infestation - (WOUND_BURN_SANITIZATION_RATE * delta_time), 0)
		sanitization = max(sanitization - (WOUND_BURN_SANITIZATION_RATE * bandage_factor * delta_time), 0)
		return

	infestation += infestation_rate * delta_time
	switch(infestation)
		if(0 to WOUND_INFECTION_MODERATE)
		if(WOUND_INFECTION_MODERATE to WOUND_INFECTION_SEVERE)
			if(DT_PROB(15, delta_time))
				victim.adjustToxLoss(0.2)
				if(prob(6))
					to_chat(victim, span_warning("Волдыри на моей [ru_gde_zone(limb.name)] источают гной..."))
		if(WOUND_INFECTION_SEVERE to WOUND_INFECTION_CRITICAL)
			if(DT_PROB(1, delta_time))
				to_chat(victim, span_warning("<b>Моя [limb.name] немеет от инфекциии!</b>"))
				set_disabling(TRUE)
			else if(DT_PROB(4, delta_time))
				to_chat(victim, span_notice("Снова чувствую [ru_parse_zone(limb.name)], но она все еще в ужасном состоянии!"))
				set_disabling(FALSE)
				return

			if(DT_PROB(10, delta_time))
				victim.adjustToxLoss(0.5)

		if(WOUND_INFECTION_CRITICAL to WOUND_INFECTION_SEPTIC)
			if(!disabling)
				if(DT_PROB(1.5, delta_time))
					to_chat(victim, span_warning("<b>Перестаю чувствовать гнойную инфекцию в своей [ru_gde_zone(limb.name)]!</b>"))
					set_disabling(TRUE)
					return
			else if(DT_PROB(1.5, delta_time))
				to_chat(victim, span_notice("Едва чувствую свою [ru_parse_zone(limb.name)]!"))
				set_disabling(FALSE)
				return

			if(DT_PROB(2.48, delta_time))
				if(prob(20))
					to_chat(victim, span_warning("Обдумываю жизнь без своей [ru_gde_zone(limb.name)]..."))
					victim.adjustToxLoss(0.75)
				else
					victim.adjustToxLoss(1)

		if(WOUND_INFECTION_SEPTIC to INFINITY)
			if(DT_PROB(0.5 * infestation, delta_time))
				switch(strikes_to_lose_limb)
					if(3 to INFINITY)
						to_chat(victim, span_deadsay("Кожа на моей [ru_gde_zone(limb.name)] просто стекает вниз, это ужасно!"))
					if(2)
						to_chat(victim, span_deadsay("<b>Инфекция из моей [ru_gde_zone(limb.name)] просто стекает вниз, это ужасно!</b>"))
					if(1)
						to_chat(victim, span_deadsay("<b>Инфекция почти полностью завладела [ru_gde_zone(limb.name)]!</b>"))
					if(0)
						to_chat(victim, span_deadsay("<b>Последний из нервных окончаний в моей [ru_gde_zone(limb.name)] отмер...</b>"))
						threshold_penalty = 120 // piss easy to destroy
						var/datum/brain_trauma/severe/paralysis/sepsis = new (limb.body_zone)
						victim.gain_trauma(sepsis)
				strikes_to_lose_limb--

/datum/wound/burn/get_examine_description(mob/user)
	if(strikes_to_lose_limb <= 0)
		return span_deadsay("<B>[victim.ru_ego(TRUE)] [limb.name] выглядит мёртвой и не похожей на органическую.</B>")

	var/list/condition = list("[victim.ru_ego(TRUE)] [limb.name] [examine_desc]")
	if(limb.current_gauze)
		var/bandage_condition
		switch(limb.current_gauze.absorption_capacity)
			if(0 to 1.25)
				bandage_condition = "почти разрушен "
			if(1.25 to 2.75)
				bandage_condition = "сильно изношенный "
			if(2.75 to 4)
				bandage_condition = "слегка окрашенный гноем "
			if(4 to INFINITY)
				bandage_condition = "чистый "

		condition += " под повязкой [bandage_condition] [limb.current_gauze.name]"
	else
		switch(infestation)
			if(WOUND_INFECTION_MODERATE to WOUND_INFECTION_SEVERE)
				condition += ", <span class='deadsay'>с небольшими пятнами обесцвечивания вдоль соседних вен!</span>"
			if(WOUND_INFECTION_SEVERE to WOUND_INFECTION_CRITICAL)
				condition += ", <span class='deadsay'>с темными облаками, распространяющимися наружу под кожей!</span>"
			if(WOUND_INFECTION_CRITICAL to WOUND_INFECTION_SEPTIC)
				condition += ", <span class='deadsay'>с полосами гнилой инфекции, пульсирующей наружу!</span>"
			if(WOUND_INFECTION_SEPTIC to INFINITY)
				return span_deadsay("<B>[victim.ru_ego(TRUE)] [limb.name] просто гнилой кусок мяса, кожа буквально капает с костей вместе с инфекцией!</B>")
			else
				condition += "!"

	return "<B>[condition.Join()]</B>"

/datum/wound/burn/get_scanner_description(mob/user)
	if(strikes_to_lose_limb == 0)
		var/oopsie = "Тип: [name]\nТяжесть: [severity_text()]"
		oopsie += "<div class='ml-3'>Инфекция: <span class='deadsay'>Инфекция полная. Конечность потеряна. Ампутируйте или замените конечность немедленно.</span></div>"
		return oopsie

	. = ..()
	. += "<div class='ml-3'>"

	if(infestation <= sanitization && flesh_damage <= flesh_healing)
		. += "Дальнейшего лечения не требуется: ожоги скоро заживут."
	else
		switch(infestation)
			if(WOUND_INFECTION_MODERATE to WOUND_INFECTION_SEVERE)
				. += "Инфекция: Умеренная\n"
			if(WOUND_INFECTION_SEVERE to WOUND_INFECTION_CRITICAL)
				. += "Инфекция: Тяжёлая\n"
			if(WOUND_INFECTION_CRITICAL to WOUND_INFECTION_SEPTIC)
				. += "Инфекция: <span class='deadsay'>КРИТИЧЕСКАЯ</span>\n"
			if(WOUND_INFECTION_SEPTIC to INFINITY)
				. += "Инфекция: <span class='deadsay'>УГРОЗА ПОТЕРИ КОНЕЧНОСТИ</span>\n"
		if(infestation > sanitization)
			. += "\tХирургическая обработка, антибиотики/стерилизаторы, регенеративная сетка или ультрафиолетовый фонарик парамедика помогут избавиться от заразы.\n"

		if(flesh_damage > 0)
			. += "Обнаружены термические повреждения тканей: Пожалуйста, примените мазь или регенеративную сетку, чтобы восстановить ткани.\n"
	. += "</div>"

/*
	new burn common procs
*/

/// if someone is using ointment on our burns
/datum/wound/burn/proc/ointmentmesh(obj/item/stack/medical/I, mob/user)
	user.visible_message(span_notice("<b>[user]</b> начинает применять [I] на [ru_parse_zone(limb.name)] <b>[victim]</b>...") , span_notice("Начинаю применять [I] на[user == victim ? " мою" : ""] [ru_parse_zone(limb.name)][user == victim ? "" : " <b>[victim]</b>"]..."))
	if(!do_after(user, (user == victim ? I.self_delay : I.other_delay), extra_checks = CALLBACK(src, .proc/still_exists)))
		return

	limb.heal_damage(I.heal_brute, I.heal_burn)
	user.visible_message(span_green("<b>[user]</b> применяет [I] на [ru_parse_zone(limb.name)] <b>[victim]</b>.") , span_green("Применяю [I] на[user == victim ? " мою" : ""] [ru_parse_zone(limb.name)][user == victim ? "" : " <b>[victim]</b>"]."))
	I.use(1)
	sanitization += I.sanitization
	flesh_healing += I.flesh_regeneration

	if((infestation <= 0 || sanitization >= infestation) && (flesh_damage <= 0 || flesh_healing > flesh_damage))
		to_chat(user, span_notice("Сделал всё что мог при помощи [I], теперь надо подождать пока [limb.name] <b>[victim]</b> восстановится."))
	else
		try_treating(I, user)

/// Paramedic UV penlights
/datum/wound/burn/proc/uv(obj/item/flashlight/pen/paramedic/I, mob/user)
	if(!COOLDOWN_FINISHED(I, uv_cooldown))
		to_chat(user, span_notice("[I] всё ещё перезаряжается!"))
		return
	if(infestation <= 0 || infestation < sanitization)
		to_chat(user, span_notice("Здесь нет инфекции на [ru_gde_zone(limb.name)] <b>[victim]</b>!"))
		return

	user.visible_message(span_notice("<b>[user]</b> делает серию коротких вспышек на [ru_gde_zone(limb.name)] <b>[victim]</b> используя [I].") , span_notice("Начинаю зачищать инфекцию на [user == victim ? " моей" : ""] [ru_gde_zone(limb.name)][user == victim ? "" : " <b>[victim]</b>"] используя [I].") , vision_distance=COMBAT_MESSAGE_RANGE)
	sanitization += I.uv_power
	COOLDOWN_START(I, uv_cooldown, I.uv_cooldown_length)

/datum/wound/burn/treat(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/medical/ointment))
		ointmentmesh(I, user)
	else if(istype(I, /obj/item/stack/medical/mesh))
		var/obj/item/stack/medical/mesh/mesh_check = I
		if(!mesh_check.is_open)
			to_chat(user, span_warning("Нужно открыть [mesh_check] сначала."))
			return
		ointmentmesh(mesh_check, user)
	else if(istype(I, /obj/item/flashlight/pen/paramedic))
		uv(I, user)

// people complained about burns not healing on stasis beds, so in addition to checking if it's cured, they also get the special ability to very slowly heal on stasis beds if they have the healing effects stored
/datum/wound/burn/on_stasis(delta_time, times_fired)
	. = ..()
	if(flesh_healing > 0)
		flesh_damage = max(flesh_damage - (0.1 * delta_time), 0)
	if((flesh_damage <= 0) && (infestation <= 1))
		to_chat(victim, span_green("Ожоги на моей [limb.name] уходят!"))
		qdel(src)
		return
	if(sanitization > 0)
		infestation = max(infestation - (0.1 * WOUND_BURN_SANITIZATION_RATE * delta_time), 0)

/datum/wound/burn/on_synthflesh(amount)
	flesh_healing += amount * 0.5 // 20u patch will heal 10 flesh standard

// we don't even care about first degree burns, straight to second
/datum/wound/burn/moderate
	name = "Ожоги второй степени"
	skloname = "ожогов второй степени"
	desc = "Пациент страдает от значительных ожогов со слабым проникновением в кожу, нарушением целостности конечностей и повышенным ощущением жжения."
	treat_text = "Рекомендуется применение заживляющей мази или регенеративной сетки на пораженной области."
	examine_desc = "сильно обгорела и покрыта волдырями"
	occur_text = "вспыхивает с сильными красными ожогами"
	severity = WOUND_SEVERITY_MODERATE
	damage_mulitplier_penalty = 1.1
	threshold_minimum = 40
	threshold_penalty = 30 // burns cause significant decrease in limb integrity compared to other wounds
	status_effect_type = /datum/status_effect/wound/burn/moderate
	flesh_damage = 5
	scar_keyword = "burnmoderate"

/datum/wound/burn/severe
	name = "Ожоги третьей степени"
	skloname = "ожогов третьей степени"
	desc = "Пациент страдает от сильных ожогов с глубоким проникновением в кожу, что создает серьезный риск инфекции."
	treat_text = "Рекомендуется немедленная дезинфекция и удаление зараженной ткани, если таковая присутствует, с последующей перевязкой и применением заживляющей мази."
	examine_desc = "кажется серьезно обугленной, с агрессивными красными пятнами"
	occur_text = "быстро обугливается, обнажая разрушенную ткань и покрывается красными ожогами"
	severity = WOUND_SEVERITY_SEVERE
	damage_mulitplier_penalty = 1.2
	threshold_minimum = 80
	threshold_penalty = 40
	status_effect_type = /datum/status_effect/wound/burn/severe
	treatable_by = list(/obj/item/flashlight/pen/paramedic, /obj/item/stack/medical/ointment, /obj/item/stack/medical/mesh)
	infestation_rate = 0.07 // appx 9 minutes to reach sepsis without any treatment
	flesh_damage = 12.5
	scar_keyword = "burnsevere"

/datum/wound/burn/critical
	name = "Катастрофические ожоги"
	skloname = "катастрофических ожогов"
	desc = "Пациент страдает от крайне глубоких ожогов, доходящих до костей. Опасный для жизни риск инфекции."
	treat_text = "Немедленное хирургическое удаление любой инфицированной ткани с последующей перевязкой и применеием противоожоговых препаратов."
	examine_desc = "это испорченный беспорядок из бланшированной кости, расплавленного жира и обугленной ткани"
	occur_text = "испаряется, как плоть, кости и жир тают вместе в ужасном беспорядке"
	severity = WOUND_SEVERITY_CRITICAL
	damage_mulitplier_penalty = 1.3
	sound_effect = 'sound/effects/wounds/sizzle2.ogg'
	threshold_minimum = 140
	threshold_penalty = 80
	status_effect_type = /datum/status_effect/wound/burn/critical
	treatable_by = list(/obj/item/flashlight/pen/paramedic, /obj/item/stack/medical/ointment, /obj/item/stack/medical/mesh)
	infestation_rate = 0.075 // appx 4.33 minutes to reach sepsis without any treatment
	flesh_damage = 20
	scar_keyword = "burncritical"

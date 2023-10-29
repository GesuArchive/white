
/*
	Piercing wounds
*/

/datum/wound/pierce
	name = "Piercing Wound"
	sound_effect = 'sound/weapons/slice.ogg'
	processes = TRUE
	wound_type = WOUND_PIERCE
	treatable_by = list(/obj/item/stack/medical/suture)
	treatable_tool = TOOL_CAUTERY
	base_treat_time = 3 SECONDS
	wound_flags = (FLESH_WOUND | ACCEPTS_GAUZE)

	/// How much blood we start losing when this wound is first applied
	var/initial_flow
	/// If gauzed, what percent of the internal bleeding actually clots of the total absorption rate
	var/gauzed_clot_rate

	/// When hit on this bodypart, we have this chance of losing some blood + the incoming damage
	var/internal_bleeding_chance
	/// If we let off blood when hit, the max blood lost is this * the incoming damage
	var/internal_bleeding_coefficient

/datum/wound/pierce/wound_injury(datum/wound/old_wound = null, attack_direction = null)
	blood_flow = initial_flow
	if(attack_direction && victim.blood_volume > BLOOD_VOLUME_OKAY)
		victim.spray_blood(attack_direction, severity)

/datum/wound/pierce/receive_damage(wounding_type, wounding_dmg, wound_bonus)
	if(victim.stat == DEAD || wounding_dmg < 5)
		return
	if(victim.blood_volume && prob(internal_bleeding_chance + wounding_dmg))
		if(limb.current_gauze && limb.current_gauze.splint_factor)
			wounding_dmg *= (1 - limb.current_gauze.splint_factor)
		var/blood_bled = rand(1, wounding_dmg * internal_bleeding_coefficient) // 12 brute toolbox can cause up to 15/18/21 bloodloss on mod/sev/crit
		switch(blood_bled)
			if(1 to 6)
				victim.bleed(blood_bled, TRUE)
			if(7 to 13)
				victim.visible_message(span_smalldanger("Капельки крови вылетают из [ru_otkuda_zone(limb.name)] [victim]."), span_danger("Капельки крови выходят из моей [ru_otkuda_zone(limb.name)].") , vision_distance=COMBAT_MESSAGE_RANGE)
				victim.bleed(blood_bled, TRUE)
			if(14 to 19)
				victim.visible_message(span_smalldanger("Небольшая струйка крови начинает течь из [ru_otkuda_zone(limb.name)] [victim]!"), span_danger("Небольшая струйка крови начинает течь из моей [ru_otkuda_zone(limb.name)]!") , vision_distance=COMBAT_MESSAGE_RANGE)
				new /obj/effect/temp_visual/dir_setting/bloodsplatter(victim.loc, victim.dir)
				victim.bleed(blood_bled)
			if(20 to INFINITY)
				victim.visible_message(span_smalldanger("Неконтроллируемая струя крови начинает хлестать из [ru_otkuda_zone(limb.name)] [victim]!"), span_danger("<b>Из моей [ru_otkuda_zone(limb.name)] начинает выходить кровь ужасным темпом!</b>") , vision_distance=COMBAT_MESSAGE_RANGE)
				victim.bleed(blood_bled)
				new /obj/effect/temp_visual/dir_setting/bloodsplatter(victim.loc, victim.dir)
				victim.add_splatter_floor(get_step(victim.loc, victim.dir))

/datum/wound/pierce/get_bleed_rate_of_change()
	if(HAS_TRAIT(victim, TRAIT_BLOODY_MESS))
		return BLOOD_FLOW_INCREASING
	if(limb.current_gauze)
		return BLOOD_FLOW_DECREASING
	return BLOOD_FLOW_STEADY

/datum/wound/pierce/handle_process(delta_time, times_fired)
	blood_flow = min(blood_flow, WOUND_SLASH_MAX_BLOODFLOW)

	if(victim.bodytemperature < (BODYTEMP_NORMAL -  10))
		blood_flow -= 0.1 * delta_time
		if(DT_PROB(2.5, delta_time))
			to_chat(victim, span_notice("Ощущаю как кровь в моей [ru_gde_zone(limb.name)] начинает сгущаться от холода!"))

	if(HAS_TRAIT(victim, TRAIT_BLOODY_MESS))
		blood_flow += 0.25 * delta_time // old heparin used to just add +2 bleed stacks per tick, this adds 0.5 bleed flow to all open cuts which is probably even stronger as long as you can cut them first

	if(limb.current_gauze)
		blood_flow -= limb.current_gauze.absorption_rate * gauzed_clot_rate * delta_time
		limb.current_gauze.absorption_capacity -= limb.current_gauze.absorption_rate * delta_time

	if(blood_flow <= 0)
		qdel(src)

/datum/wound/pierce/on_stasis(delta_time, times_fired)
	. = ..()
	if(blood_flow <= 0)
		qdel(src)

/datum/wound/pierce/check_grab_treatments(obj/item/I, mob/user)
	if(I.get_temperature()) // if we're using something hot but not a cautery, we need to be aggro grabbing them first, so we don't try treating someone we're eswording
		return TRUE

/datum/wound/pierce/treat(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/medical/suture))
		suture(I, user)
	else if(I.tool_behaviour == TOOL_CAUTERY || I.get_temperature())
		tool_cauterize(I, user)

/datum/wound/pierce/on_xadone(power)
	. = ..()
	blood_flow -= 0.03 * power // i think it's like a minimum of 3 power, so .09 blood_flow reduction per tick is pretty good for 0 effort

/datum/wound/pierce/on_synthflesh(power)
	. = ..()
	blood_flow -= 0.025 * power // 20u * 0.05 = -1 blood flow, less than with slashes but still good considering smaller bleed rates

/// If someone is using a suture to close this puncture
/datum/wound/pierce/proc/suture(obj/item/stack/medical/suture/I, mob/user)
	var/self_penalty_mult = (user == victim ? 1.4 : 1)
	user.visible_message(span_notice("<b>[user]</b> начинает зашивать [ru_parse_zone(limb.name)] <b>[victim]</b> используя [I.name]...") , span_notice("Начинаю зашивать [ru_parse_zone(limb.name)] [user == victim ? "" : "<b>[victim]</b> "]используя [I.name]..."))
	if(!do_after(user, base_treat_time * self_penalty_mult, target=victim, extra_checks = CALLBACK(src, PROC_REF(still_exists))))
		return
	user.visible_message(span_green("<b>[user]</b> успешно замедляет кровотечение <b>[victim]</b>.") , span_green("Успешно зашиваю некоторые кровотечения на [ru_gde_zone(limb.name)][user == victim ? "" : " <b>[victim]</b>"]."))
	var/blood_sutured = I.stop_bleeding / self_penalty_mult
	blood_flow -= blood_sutured
	limb.heal_damage(I.heal_brute, I.heal_burn)
	I.use(1)

	if(blood_flow > 0)
		try_treating(I, user)
	else
		to_chat(user, span_green("Успешно останавливаю кровотечение на [ru_gde_zone(limb.name)][user == victim ? "" : " <b>[victim]</b>"]."))

/// If someone is using either a cautery tool or something with heat to cauterize this pierce
/datum/wound/pierce/proc/tool_cauterize(obj/item/I, mob/user)
	var/improv_penalty_mult = (I.tool_behaviour == TOOL_CAUTERY ? 1 : 1.25) // 25% longer and less effective if you don't use a real cautery
	var/self_penalty_mult = (user == victim ? 1.5 : 1) // 50% longer and less effective if you do it to yourself

	user.visible_message(span_smalldanger("<b>[user]</b> начинает прижигать [ru_parse_zone(limb.name)] <b>[victim]</b> используя [I.name]..."), span_danger("Начинаю прижигать [ru_parse_zone(limb.name)] [user == victim ? "" : "<b>[victim]</b> "]используя [I.name]..."))
	if(!do_after(user, base_treat_time * self_penalty_mult * improv_penalty_mult, target=victim, extra_checks = CALLBACK(src, PROC_REF(still_exists))))
		return

	user.visible_message(span_green("<b>[user]</b> успешно прижигает некоторые кровотечения <b>[victim]</b>.") , span_green("Успешно прижигаю некоторые кровотечения на [ru_gde_zone(limb.name)][user == victim ? "" : " <b>[victim]</b>"]."))
	limb.receive_damage(burn = 2 + severity, wound_bonus = CANT_WOUND)
	if(prob(30))
		victim.emote("agony")
	var/blood_cauterized = (0.6 / (self_penalty_mult * improv_penalty_mult))
	blood_flow -= blood_cauterized

	if(blood_flow > 0)
		try_treating(I, user)

/datum/wound/pierce/moderate
	name = "Незначительная колотая рана"
	desc = "Кожный покров пациента был проткнут, приводя к сильным кровоподтекам и незначительному внутреннему кровотечению в данной области."
	treat_text = "Приложить холод к поражённому участку либо наложение бинта. В случае дефицита медикаментов достаточно кратковременного воздействия вакуума." // space is cold in ss13, so it's like an ice pack!
	examine_desc = "имеет маленькое, слегка кровоточащее круглое отверстие,"
	occur_text = "выплескивает небольшой поток крови"
	sound_effect = 'sound/effects/wounds/pierce1.ogg'
	severity = WOUND_SEVERITY_MODERATE
	initial_flow = 1.5
	gauzed_clot_rate = 0.8
	internal_bleeding_chance = 30
	internal_bleeding_coefficient = 1.25
	threshold_minimum = 30
	threshold_penalty = 20
	status_effect_type = /datum/status_effect/wound/pierce/moderate
	scar_keyword = "piercemoderate"

/datum/wound/pierce/severe
	name = "открытая колотая рана"
	desc = "Пациент получил глубокую колотую рану, сопровождающуюся значительным кровотечением и сниженную целостность конечностей."
	treat_text = "Наложение шва на рану или прижигания, либо временная заморозка раны."
	examine_desc = "пробита насквозь, куски кожи закрывают отверстие"
	occur_text = "начинает сильно брызгать кровью, открывая колотую рану"
	sound_effect = 'sound/effects/wounds/pierce2.ogg'
	severity = WOUND_SEVERITY_SEVERE
	initial_flow = 2.25
	gauzed_clot_rate = 0.6
	internal_bleeding_chance = 60
	internal_bleeding_coefficient = 1.5
	threshold_minimum = 50
	threshold_penalty = 35
	status_effect_type = /datum/status_effect/wound/pierce/severe
	scar_keyword = "piercesevere"

/datum/wound/pierce/critical
	name = "Полостная рана"
	desc = "Внутренние ткани и система кровообращения пациента разорваны, что сопровождается значительным внутренним кровотечением. Высок риск повреждения внутренних органов."
	treat_text = "Срочное хирургическое вмешательство с последующим переливанием крови при тяжёлой потери крови."
	examine_desc = "разорвана насквозь, едва удерживаясь костями"
	occur_text = "разрывается на куски мяса, летящие во всех направлениях"
	sound_effect = 'sound/effects/wounds/pierce3.ogg'
	severity = WOUND_SEVERITY_CRITICAL
	initial_flow = 3
	gauzed_clot_rate = 0.4
	internal_bleeding_chance = 80
	internal_bleeding_coefficient = 1.75
	threshold_minimum = 100
	threshold_penalty = 50
	status_effect_type = /datum/status_effect/wound/pierce/critical
	scar_keyword = "piercecritical"
	wound_flags = (FLESH_WOUND | ACCEPTS_GAUZE | MANGLES_FLESH)


/*
	Pierce
*/

/datum/wound/pierce
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

/datum/wound/pierce/wound_injury(datum/wound/old_wound)
	blood_flow = initial_flow

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
				victim.visible_message("<span class='smalldanger'>Капельки крови вылетают из [ru_otkuda_zone(limb.name)] [victim].</span>", "<span class='danger'>Капельки крови выходят из моей [ru_otkuda_zone(limb.name)].</span>", vision_distance=COMBAT_MESSAGE_RANGE)
				victim.bleed(blood_bled, TRUE)
			if(14 to 19)
				victim.visible_message("<span class='smalldanger'>Небольшая струйка крови начинает течь из [ru_otkuda_zone(limb.name)] [victim]!</span>", "<span class='danger'>Небольшая струйка крови начинает течь из моей [ru_otkuda_zone(limb.name)]!</span>", vision_distance=COMBAT_MESSAGE_RANGE)
				new /obj/effect/temp_visual/dir_setting/bloodsplatter(victim.loc, victim.dir)
				victim.bleed(blood_bled)
			if(20 to INFINITY)
				victim.visible_message("<span class='danger'>Неконтроллируемая струя крови начинает хлестать из [ru_otkuda_zone(limb.name)] [victim]!</span>", "<span class='danger'><b>Из моей [ru_otkuda_zone(limb.name)] начинает выходить кровь ужасным темпом!</b></span>", vision_distance=COMBAT_MESSAGE_RANGE)
				victim.bleed(blood_bled)
				new /obj/effect/temp_visual/dir_setting/bloodsplatter(victim.loc, victim.dir)
				victim.add_splatter_floor(get_step(victim.loc, victim.dir))

/datum/wound/pierce/handle_process()
	blood_flow = min(blood_flow, WOUND_SLASH_MAX_BLOODFLOW)

	if(victim.bodytemperature < (BODYTEMP_NORMAL -  10))
		blood_flow -= 0.2
		if(prob(5))
			to_chat(victim, "<span class='notice'>Ощущаю как кровь в моей [ru_gde_zone(limb.name)] начинает загущаться от холода!</span>")

	if(victim.reagents?.has_reagent(/datum/reagent/toxin/heparin))
		blood_flow += 0.5 // old herapin used to just add +2 bleed stacks per tick, this adds 0.5 bleed flow to all open cuts which is probably even stronger as long as you can cut them first

	if(limb.current_gauze)
		blood_flow -= limb.current_gauze.absorption_rate * gauzed_clot_rate
		limb.current_gauze.absorption_capacity -= limb.current_gauze.absorption_rate

	if(blood_flow <= 0)
		qdel(src)

/datum/wound/pierce/on_stasis()
	. = ..()
	if(blood_flow <= 0)
		qdel(src)

/datum/wound/pierce/treat(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/medical/suture))
		suture(I, user)
	else if(I.tool_behaviour == TOOL_CAUTERY || I.get_temperature() > 300)
		tool_cauterize(I, user)

/datum/wound/pierce/on_xadone(power)
	. = ..()
	blood_flow -= 0.03 * power // i think it's like a minimum of 3 power, so .09 blood_flow reduction per tick is pretty good for 0 effort

/datum/wound/pierce/on_synthflesh(power)
	. = ..()
	blood_flow -= 0.05 * power // 20u * 0.05 = -1 blood flow, less than with slashes but still good considering smaller bleed rates

/// If someone is using a suture to close this cut
/datum/wound/pierce/proc/suture(obj/item/stack/medical/suture/I, mob/user)
	var/self_penalty_mult = (user == victim ? 1.4 : 1)
	user.visible_message("<span class='notice'><b>[user]</b> начинает зашивать [ru_parse_zone(limb.name)] <b>[victim]</b> используя [I.name]...</span>", "<span class='notice'>Начинаю зашивать [ru_parse_zone(limb.name)] [user == victim ? "" : "<b>[victim]</b> "]используя [I.name]...</span>")
	if(!do_after(user, base_treat_time * self_penalty_mult, target=victim, extra_checks = CALLBACK(src, .proc/still_exists)))
		return
	user.visible_message("<span class='green'><b>[user]</b> успешно зашивает некоторые кровотечения <b>[victim]</b>.</span>", "<span class='green'>Успешно зашиваю некоторые кровотечения на [ru_gde_zone(limb.name)][user == victim ? "" : " <b>[victim]</b>"].</span>")
	var/blood_sutured = I.stop_bleeding / self_penalty_mult * 0.5
	blood_flow -= blood_sutured
	limb.heal_damage(I.heal_brute, I.heal_burn)

	if(blood_flow > 0)
		try_treating(I, user)
	else
		to_chat(user, "<span class='green'>Успешно останавливаю кровотечение на [ru_gde_zone(limb.name)][user == victim ? "" : " <b>[victim]</b>"].</span>")

/// If someone is using either a cautery tool or something with heat to cauterize this pierce
/datum/wound/pierce/proc/tool_cauterize(obj/item/I, mob/user)
	var/self_penalty_mult = (user == victim ? 1.5 : 1)
	user.visible_message("<span class='danger'><b>[user]</b> начинает прижигать [ru_parse_zone(limb.name)] <b>[victim]</b> используя [I.name]...</span>", "<span class='danger'>Начинаю прижигать [ru_parse_zone(limb.name)] [user == victim ? "" : "<b>[victim]</b> "]используя [I.name]...</span>")
	if(!do_after(user, base_treat_time * self_penalty_mult, target=victim, extra_checks = CALLBACK(src, .proc/still_exists)))
		return

	user.visible_message("<span class='green'><b>[user]</b> успешно прижигает некоторые кровотечения <b>[victim]</b>.</span>", "<span class='green'>Успешно прижигаю некоторые кровотечения на [ru_gde_zone(limb.name)][user == victim ? "" : " <b>[victim]</b>"].</span>")
	limb.receive_damage(burn = 2 + severity, wound_bonus = CANT_WOUND)
	if(prob(30))
		victim.emote("scream")
	var/blood_cauterized = (0.6 / self_penalty_mult) * 0.5
	blood_flow -= blood_cauterized

	if(blood_flow > 0)
		try_treating(I, user)

/datum/wound/pierce/moderate
	name = "Незначительное проникновение"
	desc = "Кожа пациента была разорвана, что вызвало сильные кровоподтеки и незначительное внутреннее кровотечение в пораженной области."
	treat_text = "Обработать пораженный участок перевязкой или воздействием сильного холода. В тяжелых случаях кратковременного воздействия вакуума может быть достаточно." // space is cold in ss13, so it's like an ice pack!
	examine_desc = "имеет маленькое круглое отверстие, слегка кровоточащее"
	occur_text = "выплескивает небольшой поток крови"
	sound_effect = 'sound/effects/wounds/pierce1.ogg'
	severity = WOUND_SEVERITY_MODERATE
	initial_flow = 1.5
	gauzed_clot_rate = 0.8
	internal_bleeding_chance = 30
	internal_bleeding_coefficient = 1.25
	threshold_minimum = 30
	threshold_penalty = 15
	status_effect_type = /datum/status_effect/wound/pierce/moderate
	scar_keyword = "piercemoderate"

/datum/wound/pierce/severe
	name = "Открытый прокол"
	desc = "Внутренняя ткань пациента пробита, вызывая значительное внутреннее кровотечение и сниженную стабильность конечностей."
	treat_text = "Исправьте проколы на коже с помощью шва или прижигания, также можно заморозить раны."
	examine_desc = "пробита насквозь, куски кожи закрывают отверстие"
	occur_text = "начинает сильно брызгать кровью, открывая колотую рану"
	sound_effect = 'sound/effects/wounds/pierce2.ogg'
	severity = WOUND_SEVERITY_SEVERE
	initial_flow = 2.25
	gauzed_clot_rate = 0.6
	internal_bleeding_chance = 60
	internal_bleeding_coefficient = 1.5
	threshold_minimum = 50
	threshold_penalty = 25
	status_effect_type = /datum/status_effect/wound/pierce/severe
	scar_keyword = "piercesevere"

/datum/wound/pierce/critical
	name = "Разорванная полость"
	desc = "Внутренние ткани и система кровообращения пациента разрываются, вызывая значительное внутреннее кровотечение и повреждение внутренних органов."
	treat_text = "Хирургическое восстановление пункционной раны с последующим контролируемым обескровливанием."
	examine_desc = "разорвана насквозь, едва удерживаясь костями"
	occur_text = "разрывается на куски мяса, летящие во всех направлениях"
	sound_effect = 'sound/effects/wounds/pierce3.ogg'
	severity = WOUND_SEVERITY_CRITICAL
	initial_flow = 3
	gauzed_clot_rate = 0.4
	internal_bleeding_chance = 80
	internal_bleeding_coefficient = 1.75
	threshold_minimum = 100
	threshold_penalty = 40
	status_effect_type = /datum/status_effect/wound/pierce/critical
	scar_keyword = "piercecritical"
	wound_flags = (FLESH_WOUND | ACCEPTS_GAUZE | MANGLES_FLESH)

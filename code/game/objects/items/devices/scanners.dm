
/*

CONTAINS:
T-RAY
HEALTH ANALYZER
GAS ANALYZER
SLIME SCANNER
NANITE SCANNER
GENE SCANNER

*/

// Describes the three modes of scanning available for health analyzers
#define SCANMODE_HEALTH		0
#define SCANMODE_CHEMICAL 	1
#define SCANMODE_WOUND	 	2
#define SCANNER_CONDENSED 	0
#define SCANNER_VERBOSE 	1

/obj/item/t_scanner
	name = "терагерцовый сканер"
	desc = "Терагерцовый излучатель лучей и просто сканер, который подсвечивает провода и трубы под полом."
	custom_price = PAYCHECK_ASSISTANT * 0.7
	icon = 'icons/obj/device.dmi'
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	icon_state = "t-ray0"
	var/on = FALSE
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	inhand_icon_state = "electronic"
	worn_icon_state = "electronic"
	custom_materials = list(/datum/material/iron=150)

/obj/item/t_scanner/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] begins to emit terahertz-rays into [user.ru_ego()] brain with [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	return TOXLOSS

/obj/item/t_scanner/proc/toggle_on()
	on = !on
	icon_state = copytext_char(icon_state, 1, -1) + "[on]"
	if(on)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj, src)

/obj/item/t_scanner/attack_self(mob/user)
	toggle_on()

/obj/item/t_scanner/cyborg_unequip(mob/user)
	if(!on)
		return
	toggle_on()

/obj/item/t_scanner/process()
	if(!on)
		STOP_PROCESSING(SSobj, src)
		return null
	scan()

/obj/item/t_scanner/proc/scan()
	t_ray_scan(loc)

/proc/t_ray_scan(mob/viewer, flick_time = 8, distance = 6)
	if(!ismob(viewer) || !viewer.client)
		return
	var/list/t_ray_images = list()
	for(var/obj/O in orange(distance, viewer) )
		if(HAS_TRAIT(O, TRAIT_T_RAY_VISIBLE))
			var/image/I = new(loc = get_turf(O))
			var/mutable_appearance/MA = new(O)
			MA.alpha = 128
			MA.dir = O.dir
			I.appearance = MA
			t_ray_images += I
	if(t_ray_images.len)
		flick_overlay(t_ray_images, list(viewer.client), flick_time)

/obj/item/healthanalyzer
	name = "анализатор здоровья"
	icon = 'icons/obj/device.dmi'
	icon_state = "health"
	inhand_icon_state = "healthanalyzer"
	worn_icon_state = "healthanalyzer"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	desc = "Ручной медицинский сканер для определения жизненных показателей пациента."
	flags_1 = CONDUCT_1
	item_flags = NOBLUDGEON
	slot_flags = ITEM_SLOT_BELT
	throwforce = 3
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 7
	custom_materials = list(/datum/material/iron=200)
	var/mode = SCANNER_VERBOSE
	var/scanmode = SCANMODE_HEALTH
	var/advanced = FALSE
	custom_price = PAYCHECK_HARD
	var/works_from_distance = FALSE

/obj/item/healthanalyzer/Initialize(mapload)
	. = ..()
	register_item_context()

/obj/item/healthanalyzer/add_item_context(
	obj/item/source,
	list/context,
	atom/target,
)
	if (!isliving(target))
		return NONE

	switch (scanmode)
		if (SCANMODE_HEALTH)
			context[SCREENTIP_CONTEXT_LMB] = "Сканировать состояние"
		if (SCANMODE_WOUND)
			context[SCREENTIP_CONTEXT_LMB] = "Сканировать раны"
		if (SCANMODE_CHEMICAL)
			context[SCREENTIP_CONTEXT_LMB] = "Сканировать химикаты"

	return CONTEXTUAL_SCREENTIP_SET

/obj/item/healthanalyzer/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] begins to analyze [user.ru_na()]self with [src]! The display shows that [user.p_theyre()] dead!"))
	return BRUTELOSS

/obj/item/healthanalyzer/attack_self(mob/user)
	scanmode = (scanmode + 1) % 3
	switch(scanmode)
		if(SCANMODE_HEALTH)
			to_chat(user, span_notice("Переключаю анализатор в режим сканирования жизненных показателей."))
		if(SCANMODE_CHEMICAL)
			to_chat(user, span_notice("Переключаю анализатор в режим сканирования химикатов в крови."))
		if(SCANMODE_WOUND)
			to_chat(user, span_notice("Переключаю анализатор в режим сканирования травм."))

/obj/item/healthanalyzer/attack(mob/living/M, mob/living/carbon/human/user)
	flick("[icon_state]-scan", src)	//makes it so that it plays the scan animation upon scanning, including clumsy scanning

	// Clumsiness/brain damage check
	if ((HAS_TRAIT(user, TRAIT_CLUMSY) || HAS_TRAIT(user, TRAIT_DUMB)) && prob(50))
		user.visible_message(span_warning("[user] анализирует жизненные показатели пола!") , \
							span_notice("Глупо анализирую показатели пола!"))
		to_chat(user, "<span class='info'>Результаты анализа пола:\n\tОбщий статус: <b>Здоров</b></span>\
					\n<span class='info'>Тип: <font color='blue'>Удушение</font>/<font color='green'>Токсины</font>/<font color='#FF8000'>Ожоги</font>/<font color='red'>Травмы</font></span>\
					\n<span class='info'>\tПоказатели: <font color='blue'>0</font>-<font color='green'>0</font>-<font color='#FF8000'>0</font>-<font color='red'>0</font></span>\
					\n<span class='info'>Температура тела: ???</span>")
		return

	if(ispodperson(M) && !advanced)
		to_chat(user, "<span class='info'>Биологическая структура <b>[M]</b> слишком сложная для анализа.")
		return

	user.visible_message(span_notice("<b>[user]</b> анализирует жизненные показатели <b>[M]</b>.") , \
						span_notice("Анализирую жизненные показатели <b>[M]</b>."))

	if(scanmode == SCANMODE_HEALTH)
		healthscan(user, M, mode, advanced)
	else if(scanmode == SCANMODE_CHEMICAL)
		chemscan(user, M)
	else
		woundscan(user, M, src)

	add_fingerprint(user)

/obj/item/healthanalyzer/attack_secondary(mob/living/victim, mob/living/user, params)
	chemscan(user, victim)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

// Used by the PDA medical scanner too
/proc/healthscan(mob/user, mob/living/M, mode = SCANNER_VERBOSE, advanced = FALSE, tochat = TRUE)
	if(!M.get_organ_slot(ORGAN_SLOT_BRAIN_BIOMONITOR))
		if(user.incapacitated())
			return

		if(user.is_blind())
			to_chat(user, span_warning("Этот сканер не адаптирован для слепых! Я буду жаловаться в профсоюз!"))
			return

	// the final list of strings to render
	var/render_list = list()

	// Damage specifics
	var/oxy_loss = M.getOxyLoss()
	var/tox_loss = M.getToxLoss()
	var/fire_loss = M.getFireLoss()
	var/brute_loss = M.getBruteLoss()
	var/mob_status = (M.stat == DEAD ? span_alert("<b>Мёртв</b>")  : "<b>[round(M.health/M.maxHealth,0.01)*100]% здоров</b>")

	if(HAS_TRAIT(M, TRAIT_FAKEDEATH) && !advanced)
		mob_status = span_alert("<b>Мёртв</b>")
		oxy_loss = max(rand(1, 40), oxy_loss, (300 - (tox_loss + fire_loss + brute_loss))) // Random oxygen loss

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.undergoing_cardiac_arrest() && H.stat != DEAD)
			render_list += "<span class='alert'>У пациента сердечный приступ: срочно требуется дефибриллирование или удар током!</span>\n"
		if(H.has_reagent(/datum/reagent/inverse/technetium))
			advanced = TRUE

	SEND_SIGNAL(M, COMSIG_LIVING_HEALTHSCAN, render_list, advanced, user, mode)

	render_list += "<span class='info'>Результаты анализа [M]:</span>\n<span class='info ml-1'>Общий статус: [mob_status]</span>\n"

	// Husk detection
	if(advanced && HAS_TRAIT_FROM(M, TRAIT_HUSK, BURN))
		render_list += "<span class='alert ml-1'>Жертва была хаскирована из ожогов высшей степени тяжести.</span>\n"
	else if (advanced && HAS_TRAIT_FROM(M, TRAIT_HUSK, CHANGELING_DRAIN))
		render_list += "<span class='alert ml-1'>Жертва была хаскирована из за иссушения кровеносной и лимфатической системы.</span>\n"
	else if(HAS_TRAIT(M, TRAIT_HUSK))
		render_list += "<span class='alert ml-1'>Жертва была хаскирована.</span>\n"

	// Damage descriptions
	if(brute_loss > 10)
		render_list += "<span class='alert ml-1'>Обнаружены [brute_loss > 50 ? "Серьёзные" : "Небольшие"] физические раны.</span>\n"
	if(fire_loss > 10)
		render_list += "<span class='alert ml-1'>Обнаружены [fire_loss > 50 ? "Серьёзные" : "Небольшие"] ожоги.</span>\n"
	if(oxy_loss > 10)
		render_list += "<span class='info ml-1'><span class='alert'>Обнаружено [oxy_loss > 50 ? "Серьёзное" : "Небольшое"] удушье.</span>\n"
	if(tox_loss > 10)
		render_list += "<span class='alert ml-1'>Обнаружен [tox_loss > 50 ? "Серьёзный" : "Небольшой"] объём токсинов.</span>\n"
	if(M.getStaminaLoss())
		render_list += "<span class='alert ml-1'>Пациент страдает от переутомления.</span>\n"
		if(advanced)
			render_list += "<span class='info ml-1'>Уровень переутомления: [M.getStaminaLoss()]%.</span>\n"
	if (M.getCloneLoss())
		render_list += "<span class='alert ml-1'>Пациент имеет [M.getCloneLoss() > 30 ? "серьёзный" : "небольшой"] клеточный урон.</span>\n"
		if(advanced)
			render_list += "<span class='info ml-1'>Уровень клеточного урона: [M.getCloneLoss()].</span>\n"
	if (!M.get_organ_slot(ORGAN_SLOT_BRAIN)) // brain not added to carbon/human check because it's funny to get to bully simple mobs
		render_list += "<span class='alert ml-1'>У пациента отсутствует мозг.</span>\n"
	if(ishuman(M))
		var/mob/living/carbon/human/the_dude = M
		var/datum/species/the_dudes_species = the_dude.dna.species
		if (!(NOBLOOD in the_dudes_species.species_traits) && !the_dude.get_organ_slot(ORGAN_SLOT_HEART))
			render_list += "<span class='alert ml-1'>Нет сердца.</span>\n"
		if (!(TRAIT_NOBREATH in the_dudes_species.species_traits) && !the_dude.get_organ_slot(ORGAN_SLOT_LUNGS))
			render_list += "<span class='alert ml-1'>Нет лёгких.</span>\n"
		if (!(TRAIT_NOMETABOLISM in the_dudes_species.species_traits) && !the_dude.get_organ_slot(ORGAN_SLOT_LIVER))
			render_list += "<span class='alert ml-1'>Нет печени.</span>\n"
		if (!(NOSTOMACH in the_dudes_species.species_traits) && !the_dude.get_organ_slot(ORGAN_SLOT_STOMACH))
			render_list += "<span class='alert ml-1'>Нет желудка.</span>\n"

	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(LAZYLEN(C.get_traumas()))
			var/list/trauma_text = list()
			for(var/datum/brain_trauma/B in C.get_traumas())
				var/trauma_desc = ""
				switch(B.resilience)
					if(TRAUMA_RESILIENCE_SURGERY)
						trauma_desc += "серьёзного "
					if(TRAUMA_RESILIENCE_LOBOTOMY)
						trauma_desc += "глубокого "
					if(TRAUMA_RESILIENCE_WOUND)
						trauma_desc += "травматического "
					if(TRAUMA_RESILIENCE_MAGIC, TRAUMA_RESILIENCE_ABSOLUTE)
						trauma_desc += "вечного "
				trauma_desc += B.scan_desc
				trauma_text += trauma_desc
			render_list += "<span class='alert ml-1'>Церебральные травмы обнаружены: пациент страдает от [english_list(trauma_text)].</span>\n"
		if(C.roundstart_quirks.len)
			render_list += "<span class='info ml-1'>Пациент имеет серьёзные отклонения в виде: [C.get_quirk_string(FALSE, CAT_QUIRK_MAJOR_DISABILITY)].</span>\n"
			if(advanced)
				render_list += "<span class='info ml-1'>Пациент имеет незначительные отклонения в виде: [C.get_quirk_string(FALSE, CAT_QUIRK_MINOR_DISABILITY)].</span>\n"
	if(advanced)
		render_list += "<span class='info ml-1'>Уровень активности мозга: [(200 - M.getOrganLoss(ORGAN_SLOT_BRAIN))/2]%.</span>\n"

	if (M.radiation)
		render_list += "<span class='alert ml-1'>Обнаружено радиоактивное заражение.</span>\n"
		if(advanced)
			render_list += "<span class='info ml-1'>Уровень облучения: [M.radiation]%.</span>\n"
		else
			if(M.radiation>=0 && M.radiation<=100)
				render_list += "<span class='info ml-1'>Уровень облучения <b>низкий</b>.</span>\n"
			if(M.radiation>100 && M.radiation<=400)
				render_list += "<span class='info ml-1'>Уровень облучения <b>средний</b>.</span>\n"
			if(M.radiation>400 && M.radiation<=1500)
				render_list += "<span class='info ml-1'>Уровень облучения <b>высокий</b>.</span>\n"
			if(M.radiation>1500)
				render_list += "<span class='info ml-1'>Уровень облучения <b>критический</b>.</span>\n"

	if(advanced && M.hallucinating())
		render_list += "<span class='info ml-1'>Пациент под воздействием галлюциногенов.</span>\n"

	// Body part damage report
	if(iscarbon(M) && mode == SCANNER_VERBOSE)
		var/mob/living/carbon/C = M
		var/list/damaged = C.get_damaged_bodyparts(1,1)
		if(length(damaged)>0 || oxy_loss>0 || tox_loss>0 || fire_loss>0)
			var/dmgreport = "<span class='info ml-1'>Тело:</span>\
							<table class='ml-2'><tr><font face='Verdana'>\
							<td style='width:7em;'><font color='#7777CC'>Урон:</font></td>\
							<td style='width:5em;'><font color='red'><b>Травмы</b></font></td>\
							<td style='width:4em;'><font color='orange'><b>Ожоги</b></font></td>\
							<td style='width:4em;'><font color='green'><b>Токсины</b></font></td>\
							<td style='width:8em;'><font color='pink'><b>Удушье</b></font></td></tr>\
							<tr><td><font color='#7777CC'>Общий:</font></td>\
							<td><font color='red'>[CEILING(brute_loss,1)]</font></td>\
							<td><font color='orange'>[CEILING(fire_loss,1)]</font></td>\
							<td><font color='green'>[CEILING(tox_loss,1)]</font></td>\
							<td><font color='blue'>[CEILING(oxy_loss,1)]</font></td></tr>"

			for(var/o in damaged)
				var/obj/item/bodypart/org = o //head, left arm, right arm, etc.
				dmgreport += "<tr><td><font color='#7777CC'>[capitalize(org.name)]:</font></td>\
								<td><font color='red'>[(org.brute_dam > 0) ? "[CEILING(org.brute_dam,1)]" : "0"]</font></td>\
								<td><font color='orange'>[(org.burn_dam > 0) ? "[CEILING(org.burn_dam,1)]" : "0"]</font></td></tr>"
			dmgreport += "</font></table>"
			render_list += dmgreport // tables do not need extra linebreak

	//Eyes and ears
	if(advanced && iscarbon(M))
		var/mob/living/carbon/C = M

		// Ear status
		var/obj/item/organ/ears/ears = C.get_organ_slot(ORGAN_SLOT_EARS)
		var/message = "\n<span class='alert ml-2'>У пациента нет ушей.</span>"
		if(istype(ears))
			message = ""
			if(HAS_TRAIT_FROM(C, TRAIT_DEAF, GENETIC_MUTATION))
				message = "\n<span class='alert ml-2'>Пациент генетически глухой.</span>"
			else if(HAS_TRAIT_FROM(C, TRAIT_DEAF, EAR_DAMAGE))
				message = "\n<span class='alert ml-2'>Пациент глухой из-за повреждений ушей.</span>"
			else if(HAS_TRAIT(C, TRAIT_DEAF))
				message = "\n<span class='alert ml-2'>Пациент глухой.</span>"
			else
				if(ears.damage)
					message += "\n<span class='alert ml-2'>Пациент имеет [ears.damage > ears.maxHealth ? "вечный ": "временный "]ушной урон.</span>"
				if(ears.deaf)
					message += "\n<span class='alert ml-2'>Пациент [ears.damage > ears.maxHealth ? "вечно ": "временно "] глух.</span>"
		render_list += "<span class='info ml-1'>Состояние ушей:</span>[message == "" ? "\n<span class='info ml-2'>Здоровы.</span>" : message]\n"

		// Eye status
		var/obj/item/organ/eyes/eyes = C.get_organ_slot(ORGAN_SLOT_EYES)
		message = "\n<span class='alert ml-2'>У пациента нет глаз.</span>"
		if(istype(eyes))
			message = ""
			if(C.is_blind())
				message += "\n<span class='alert ml-2'>Пациент слепой.</span>"
			if(HAS_TRAIT(C, TRAIT_NEARSIGHT))
				message += "\n<span class='alert ml-2'>Пациент близорукий.</span>"
			if(eyes.damage > 30)
				message += "\n<span class='alert ml-2'>У пациента повреждены глаза.</span>"
			else if(eyes.damage > 20)
				message += "\n<span class='alert ml-2'>У пациента немного повреждены глаза.</span>"
			else if(eyes.damage)
				message += "\n<span class='alert ml-2'>У пациента почти нет повреждений глаз.</span>"
		render_list += "<span class='info ml-1'>Состояние глаз:</span>[message == "" ? "\n<span class='info ml-2'>Здоровы.</span>" : message]\n"

	if(ishuman(M))
		var/mob/living/carbon/human/H = M

		// Organ damage
		if (H.internal_organs && H.internal_organs.len)
			var/render = FALSE
			var/toReport = "<span class='info ml-1'>Органы:</span>\
				<table class='ml-2'><tr>\
				<td style='width:6em;'><font color='#7777CC'><b>Орган</b></font></td>\
				[advanced ? "<td style='width:3em;'><font color='#7777CC'><b>Урон</b></font></td>" : ""]\
				<td style='width:12em;'><font color='#7777CC'><b>Состояние</b></font></td>"

			for(var/obj/item/organ/organ in H.internal_organs)
				var/status = ""
				if(H.has_reagent(/datum/reagent/inverse/technetium))
					if(organ.damage)
						status = "<font color='#E42426'> Повреждён на [round((organ.damage/organ.maxHealth)*100, 1)]%.</font>"
				else
					if (organ.organ_flags & ORGAN_FAILING)
						status = "<font color='#cc3333'>Не работает</font>"
					else if (organ.damage > organ.high_threshold)
						status = "<font color='#ff9933'>Сильно повреждён</font>"
					else if (organ.damage > organ.low_threshold)
						status = "<font color='#ffcc33'>Повреждён</font>"
				if (status != "")
					render = TRUE
					toReport += "<tr><td><font color='#7777CC'>[organ.name]</font></td>\
						[advanced ? "<td><font color='#7777CC'>[CEILING(organ.damage,1)]</font></td>" : ""]\
						<td>[status]</td></tr>"

			if (render)
				render_list += toReport + "</table>" // tables do not need extra linebreak

		//Genetic damage
		if(advanced && H.has_dna())
			render_list += "<span class='info ml-1'>Генетическая стабильность: [H.dna.stability]%.</span>\n"

		// Species and body temperature
		var/datum/species/S = H.dna.species
		var/mutant = H.dna.check_mutation(HULK) \
			|| S.mutantlungs != initial(S.mutantlungs) \
			|| S.mutantbrain != initial(S.mutantbrain) \
			|| S.mutantheart != initial(S.mutantheart) \
			|| S.mutanteyes != initial(S.mutanteyes) \
			|| S.mutantears != initial(S.mutantears) \
			|| S.mutanthands != initial(S.mutanthands) \
			|| S.mutanttongue != initial(S.mutanttongue) \
			|| S.mutantliver != initial(S.mutantliver) \
			|| S.mutantstomach != initial(S.mutantstomach) \
			|| S.mutantappendix != initial(S.mutantappendix) \
			|| S.flying_species != initial(S.flying_species)

		render_list += "<span class='info ml-1'>Селекционный тип: [S.name][mutant ? "-мутант" : ""]</span>\n"
		render_list += "<span class='info ml-1'>Внутренняя температура: [round(H.coretemperature-T0C,0.1)] &deg;C ([round(H.coretemperature*1.8-459.67,0.1)] &deg;F)</span>\n"
	render_list += "<span class='info ml-1'>Внешняя температура: [round(M.bodytemperature-T0C,0.1)] &deg;C ([round(M.bodytemperature*1.8-459.67,0.1)] &deg;F)</span>\n"

	// Time of death
	if(M.tod && (M.stat == DEAD || ((HAS_TRAIT(M, TRAIT_FAKEDEATH)) && !advanced)))
		render_list += "<span class='info ml-1'>Время смерти: [M.tod]</span>\n"
		var/tdelta = round(world.time - M.timeofdeath)
		render_list += "<span class='alert ml-1'><b>Пациент умер [DisplayTimeText(tdelta)] назад.</b></span>\n"

	// Wounds
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		var/list/wounded_parts = C.get_wounded_bodyparts()
		for(var/i in wounded_parts)
			var/obj/item/bodypart/wounded_part = i
			render_list += "<span class='alert ml-1'><b>Внимание: [LAZYLEN(wounded_part.wounds) > 1? "Обнаружены физические травмы" : "Обнаружена физическая травма"] в [wounded_part.name]</b>"
			for(var/k in wounded_part.wounds)
				var/datum/wound/W = k
				render_list += "<div class='ml-2'>Тип: [W.name]\nТяжесть: [W.severity_text()]</div>\n" // \nRecommended Treatment: [W.treat_text] выкинул рекомендованное лечение - слишком громоздко,less lines than in woundscan() so we don't overload people trying to get basic med info
			render_list += "</span>"


// Застрявшие предметы, паралич и потерянные конечности
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		var/list/missing = list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)
		var/list/disabled = list()
		for(var/X in C.bodyparts)
			var/obj/item/bodypart/BP = X
			if(BP.bodypart_disabled)
				disabled += BP
			missing -= BP.body_zone
			for(var/obj/item/I in BP.embedded_objects)
				if(I.isEmbedHarmless())
					render_list += "<span class='alert ml-1'><b>Внимание: В [BP.name] пациента торчит [I].</b></span>\n"
				else
					render_list += "<span class='alert ml-1'><b>Внимание: В [BP.name] пациента застрял [I].</b></span>\n"
		for(var/X in disabled)
			var/obj/item/bodypart/BP = X
			if(!(BP.get_damage(include_stamina = FALSE) >= BP.max_damage)) //Stamina is disabling the limb
				render_list += "<span class='alert ml-1'><b>Внимание: [BP.name] парализована.</b></span>\n"

		for(var/t in missing)
			render_list += "<span class='alert ml-1'><b>Внимание: [parse_zone(t)] пациента отсутствует.</b></span>\n"
		render_list += "\n"


	// Болезни
	for(var/thing in M.diseases)
		var/datum/disease/D = thing
		if(!(D.visibility_flags & HIDDEN_SCANNER))
			render_list += "<span class='alert ml-1'><b>Внимание: [D.form] обнаружена</b>\n\
			<div class='ml-2'>Название: [D.name].\nТип: [D.spread_text].\nСтадия: [D.stage]/[D.max_stages].\nВозможное лекарство: [D.cure_text]</div>\
			</span>" // divs do not need extra linebreak


	// Blood Level
	if(M.has_dna())
		var/mob/living/carbon/C = M
		var/blood_id = C.get_blood_id()
		if(blood_id)
			if(ishuman(C))
				var/mob/living/carbon/human/H = C
				if(H.is_bleeding())
					render_list += "<span class='alert ml-1'><b>Пациент истекает кровью!</b></span>\n"
			var/blood_percent =  round((C.blood_volume / BLOOD_VOLUME_NORMAL)*100)
			var/blood_type = C.dna.blood_type
			if(blood_id != /datum/reagent/blood) // special blood substance
				var/datum/reagent/R = GLOB.chemical_reagents_list[blood_id]
				blood_type = R ? R.name : blood_id
			if(HAS_TRAIT(M, TRAIT_MASQUERADE)) //bloodsuckers
				render_list += "<span class='info ml-1'>Уровень крови: 100%, 560 cl, Тип: [blood_type]</span>\n"
			if(C.blood_volume <= BLOOD_VOLUME_SAFE && C.blood_volume > BLOOD_VOLUME_OKAY)
				render_list += "<span class='alert ml-1'>Уровень крови: НИЗКИЙ [blood_percent]%, [C.blood_volume] cl,</span> <span class='info'>Тип: [blood_type]</span>\n"
			else if(C.blood_volume <= BLOOD_VOLUME_OKAY)
				render_list += "<span class='alert ml-1'>Уровень крови: <b>КРИТИЧЕСКИЙ [blood_percent]%</b>, [C.blood_volume] cl,</span> <span class='info'>Тип: [blood_type]</span>\n"
			else
				render_list += "<span class='info ml-1'>Уровень крови: [blood_percent]%, [C.blood_volume] cl, Тип: [blood_type]</span>\n"

		var/cyberimp_detect
		for(var/obj/item/organ/cyberimp/CI in C.internal_organs)
			if(CI.status == ORGAN_ROBOTIC && !CI.syndicate_implant)
				cyberimp_detect += "[!cyberimp_detect ? "[CI.get_examine_string(user)]" : ", [CI.get_examine_string(user)]"]"
		if(cyberimp_detect)
			render_list += "<span class='notice ml-1'>Обнаружены кибернетические модификации:</span>\n"
			render_list += "<span class='notice ml-2'>[cyberimp_detect]</span>\n"

	SEND_SIGNAL(M, COMSIG_NANITE_SCAN, user, FALSE)
	if(tochat)
		to_chat(user, jointext(render_list, "")) // we handled the last <br> so we don't need handholding
	else
		return(jointext(render_list, ""))

/proc/chemscan(mob/living/user, mob/living/M)
	if(user.incapacitated())
		return

	if(user.is_blind())
		to_chat(user, span_warning("Я полностью слеп и не вижу показателей анализатора!"))
		return

	if(istype(M) && M.reagents)
		var/render_list = list()
		if(M.reagents.reagent_list.len)
			render_list += "<span class='notice ml-1'>В крови пациента обнаружены следующие химикаты:</span>\n"
			for(var/r in M.reagents.reagent_list)
				var/datum/reagent/reagent = r
				if(reagent.chemical_flags & REAGENT_INVISIBLE) //Don't show hidden chems on scanners
					continue
				render_list += "<span class='notice ml-2'>[round(reagent.volume, 0.001)] юнитов [reagent.name][reagent.overdosed ? "</span> - <span class='boldannounce'>ПЕРЕДОЗИРОВКА</span>" : ".</span>"]\n"
		else
			render_list += "<span class='notice ml-1'>Не обнаружено реагентов в крови.</span>\n"
		var/obj/item/organ/stomach/belly = M.get_organ_slot(ORGAN_SLOT_STOMACH)
		if(belly)
			if(belly.reagents.reagent_list.len)
				render_list += "<span class='notice ml-1'>В желудке пациента обнаружены следующие химикаты:</span>\n"
				for(var/bile in belly.reagents.reagent_list)
					var/datum/reagent/bit = bile
					if(bit.chemical_flags & REAGENT_INVISIBLE) //Don't show hidden chems on scanners
						continue
					if(!belly.food_reagents[bit.type])
						render_list += "<span class='notice ml-2'>[round(bit.volume, 0.001)] юнитов [bit.name][bit.overdosed ? "</span> - <span class='boldannounce'>ПЕРЕДОЗИРОВКА</span>" : ".</span>"]\n"
					else
						var/bit_vol = bit.volume - belly.food_reagents[bit.type]
						if(bit_vol > 0)
							render_list += "<span class='notice ml-2'>[round(bit_vol, 0.001)] юнитов [bit.name][bit.overdosed ? "</span> - <span class='boldannounce'>ПЕРЕДОЗИРОВКА</span>" : ".</span>"]\n"
			else
				render_list += "<span class='notice ml-1'>Не обнаружено реагентов в желудке.</span>\n"

		if(LAZYLEN(M?.mind?.active_addictions))
			render_list += "<span class='boldannounce ml-1'>У пациента есть зависимость от следующих химикатов:</span>\n"
			for(var/datum/addiction/addiction_type as anything in M.mind.active_addictions)
				render_list += "<span class='alert ml-2'>[initial(addiction_type.name)]</span>\n"
		else
			render_list += "<span class='notice ml-1'>У пациента нет зависимостей от химикатов.</span>\n"

		if(M.has_status_effect(/datum/status_effect/eigenstasium))
			render_list += "<span class='notice ml-1'>Subject is temporally unstable. Stabilising agent is recommended to reduce disturbances.</span>\n"

		to_chat(user, jointext(render_list, "")) // we handled the last <br> so we don't need handholding

/obj/item/healthanalyzer/verb/toggle_mode()
	set name = "Switch Verbosity"
	set category = "Объект"

	if(usr.incapacitated())
		return

	mode = !mode
	to_chat(usr, mode == SCANNER_VERBOSE ? "The scanner now shows specific limb damage." : "The scanner no longer shows limb damage.")

/obj/item/healthanalyzer/range
	name = "дистанционный анализатор здоровья"
	desc = "Ручной медицинский сканер для определения жизненных показателей пациента на расстоянии."
	icon_state = "health_range"
	works_from_distance = TRUE
	custom_premium_price = PAYCHECK_HARD * 2

/*
/obj/item/healthanalyzer/pre_attack(mob/living/M, mob/living/carbon/human/user, params)
	if(!istype(M))
		return ..()
	if(user.Adjacent(M)) // no TK upgrading.
		if(works_from_distance)
			user.Beam(M, icon_state = "med_scan", time = 5)
		attack(M, user)
		return TRUE
	return ..()
*/

/obj/item/healthanalyzer/afterattack(mob/living/M, mob/living/carbon/human/user, adjacent, params)
	if(adjacent || !istype(M))
		return ..()
	if(works_from_distance)
		M.Beam(user, icon_state = "med_scan", time = 5)
		attack(M, user)
		playsound(src, 'white/Feline/sounds/pip.ogg', 25, FALSE, 2)
		return
	return ..()

/obj/item/healthanalyzer/advanced
	name = "продвинутый анализатор здоровья"
	desc = "Ручной медицинский сканер для определения жизненных показателей пациента с более высокой точностью."
	icon_state = "health_adv"
	advanced = TRUE
	works_from_distance = TRUE

/// Displays wounds with extended information on their status vs medscanners
/proc/woundscan(mob/user, mob/living/carbon/patient, obj/item/healthanalyzer/wound/scanner)
	if(!istype(patient) || user.incapacitated())
		return

	if(user.is_blind())
		to_chat(user, span_warning("Этот сканер не адаптирован для слепых! Я буду жаловаться в профсоюз!"))
		return

	var/render_list = ""
	for(var/i in patient.get_wounded_bodyparts())
		var/obj/item/bodypart/wounded_part = i
		render_list += "<span class='alert ml-1'><b>Опасность: Физическ[LAZYLEN(wounded_part.wounds) > 1? "ие травмы" : "ая травма"] обнаружена в [ru_gde_zone(wounded_part.name)]</b>"
		for(var/k in wounded_part.wounds)
			var/datum/wound/W = k
			render_list += "<div class='ml-2'>[W.get_scanner_description()]</div>\n"
		render_list += "</span>"

	if(render_list == "")
		if(istype(scanner))
			// Only emit the cheerful scanner message if this scan came from a scanner
			playsound(scanner, 'sound/machines/ping.ogg', 50, FALSE)
			to_chat(user, span_notice("[capitalize(scanner)] издаёт радостный пинг и выводит смешную рожицу с тремя восклицательными знаками! Это невероятно приятный отчёт о том, что [patient] не имеет травм!"))
		else
			to_chat(user, "<span class='notice ml-1'>У пациента не найдено травм.</span>")
	else
		to_chat(user, jointext(render_list, ""))

/obj/item/healthanalyzer/wound
	name = "first aid analyzer"
	icon_state = "adv_spectrometer"
	desc = "A prototype MeLo-Tech medical scanner used to diagnose injuries and recommend treatment for serious wounds, but offers no further insight into the patient's health. You hope the final version is less annoying to read!"
	var/next_encouragement
	var/greedy

/obj/item/healthanalyzer/wound/attack_self(mob/user)
	if(next_encouragement < world.time)
		playsound(src, 'sound/machines/ping.ogg', 50, FALSE)
		var/list/encouragements = list("briefly displays a happy face, gazing emptily at you", "briefly displays a spinning cartoon heart", "displays an encouraging message about eating healthy and exercising", \
				"reminds you that everyone is doing their best", "displays a message wishing you well", "displays a sincere thank-you for your interest in first-aid", "formally absolves you of all your sins")
		to_chat(user, span_notice("<b>[capitalize(src)]</b> makes a happy ping and [pick(encouragements)]!"))
		next_encouragement = world.time + 10 SECONDS
		greedy = FALSE
	else if(!greedy)
		to_chat(user, span_warning("<b>[capitalize(src)]</b> displays an eerily high-definition frowny face, chastizing you for asking it for too much encouragement."))
		greedy = TRUE
	else
		playsound(src, 'white/valtos/sounds/error1.ogg', 50, FALSE)
		if(isliving(user))
			var/mob/living/L = user
			to_chat(L, span_warning("<b>[capitalize(src)]</b> makes a disappointed buzz and pricks your finger for being greedy. Ow!"))
			L.adjustBruteLoss(4)
			L.dropItemToGround(src)

/obj/item/healthanalyzer/wound/attack(mob/living/carbon/patient, mob/living/carbon/human/user)
	add_fingerprint(user)
	user.visible_message(span_notice("[user] scans [patient] for serious injuries.") , span_notice("You scan [patient] for serious injuries."))

	if(!istype(patient))
		playsound(src, 'white/valtos/sounds/error1.ogg', 30, TRUE)
		to_chat(user, span_notice("<b>[capitalize(src)]</b> makes a sad buzz and briefly displays a frowny face, indicating it can't scan [patient]."))
		return

	woundscan(user, patient, src)

/obj/item/analyzer
	name = "газоанализатор"
	desc = "Ручной анализатор, который сканирует состояние воздуха в помещении. ПКМ, чтобы использовать барометр."
	custom_price = PAYCHECK_ASSISTANT * 0.9
	icon = 'icons/obj/device.dmi'
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	icon_state = "analyzer"
	inhand_icon_state = "analyzer"
	w_class = WEIGHT_CLASS_SMALL
	flags_1 = CONDUCT_1
	item_flags = NOBLUDGEON
	slot_flags = ITEM_SLOT_BELT
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	tool_behaviour = TOOL_ANALYZER
	custom_materials = list(/datum/material/iron=30, /datum/material/glass=20)
	grind_results = list(/datum/reagent/mercury = 5, /datum/reagent/iron = 5, /datum/reagent/silicon = 5)
	var/cooldown = FALSE
	var/cooldown_time = 250
	var/accuracy // 0 is the best accuracy.
	var/list/last_gasmix_data

/obj/item/analyzer/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>ПКМ [src] для активации барометра.</span>"

/obj/item/analyzer/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] begins to analyze [user.ru_na()]self with [src]! The display shows that [user.p_theyre()] dead!"))
	return BRUTELOSS

/obj/item/analyzer/attackby(obj/O, mob/living/user)
	if(istype(O, /obj/item/bodypart/l_arm/robot) || istype(O, /obj/item/bodypart/r_arm/robot))
		to_chat(user, span_notice("Добавляю [O] к [src]."))
		qdel(O)
		qdel(src)
		user.put_in_hands(new /obj/item/bot_assembly/atmosbot)
	else
		..()

/obj/item/analyzer/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GasAnalyzer", "Gas Analyzer")
		ui.open()

/obj/item/analyzer/ui_static_data(mob/user)
	return return_atmos_handbooks()

/obj/item/analyzer/ui_data(mob/user)
	LAZYINITLIST(last_gasmix_data)
	return list("gasmixes" = last_gasmix_data)

/obj/item/analyzer/attack_self(mob/user, modifiers)
	if(user.stat != CONSCIOUS || !user.can_read(src) || user.is_blind())
		return
	atmos_scan(user=user, target=get_turf(src), silent=FALSE)
	on_analyze(source=src, target=get_turf(src))

/obj/item/analyzer/attack_self_secondary(mob/user, modifiers)
	if(user.stat != CONSCIOUS || !user.can_read(src) || user.is_blind())
		return

	ui_interact(user)

/// Called when our analyzer is used on something
/obj/item/analyzer/proc/on_analyze(datum/source, atom/target)
	SIGNAL_HANDLER
	var/mixture = target.return_analyzable_air()
	if(!mixture)
		return FALSE
	var/list/airs = islist(mixture) ? mixture : list(mixture)
	var/list/new_gasmix_data = list()
	for(var/datum/gas_mixture/air as anything in airs)
		var/mix_name = capitalize(lowertext(target.name))
		if(airs.len != 1) //not a unary gas mixture
			mix_name += " - Часть [airs.Find(air)]"
		new_gasmix_data += list(gas_mixture_parser(air, mix_name))
	last_gasmix_data = new_gasmix_data

/**
 * Outputs a message to the user describing the target's gasmixes.
 *
 * Gets called by analyzer_act, which in turn is called by tool_act.
 * Also used in other chat-based gas scans.
 */
/proc/atmos_scan(mob/user, atom/target, silent=FALSE)
	var/mixture = target.return_analyzable_air()
	if(!mixture)
		return FALSE

	var/icon = target
	var/message = list()
	if(!silent && isliving(user))
		user.visible_message(span_notice("[user] использует анализатор [icon2html(icon, viewers(user))] на [target]."), span_notice("Использую анализатор [icon2html(icon, user)] на [target]."))
	message += span_boldnotice("Результат анализа [icon2html(icon, user)] [target].")

	var/list/airs = islist(mixture) ? mixture : list(mixture)
	for(var/datum/gas_mixture/air as anything in airs)
		var/mix_name = capitalize(lowertext(target.name))
		if(airs.len > 1) //not a unary gas mixture
			var/mix_number = airs.Find(air)
			message += span_boldnotice("Часть [mix_number]")
			mix_name += " - Часть [mix_number]"

		var/total_moles = air.total_moles()
		var/pressure = air.return_pressure()
		var/volume = air.return_volume() //could just do mixture.volume... but safety, I guess?
		var/temperature = air.return_temperature()
		var/heat_capacity = air.heat_capacity()
		var/thermal_energy = air.thermal_energy()

		if(total_moles > 0)
			message += span_notice("Молей: [round(total_moles, 0.01)] моль")

			var/list/cached_gases = air.gases
			for(var/id in cached_gases)
				var/gas_concentration = cached_gases[id][MOLES]/total_moles
				message += span_notice("[cached_gases[id][GAS_META][META_GAS_NAME]]: [round(cached_gases[id][MOLES], 0.01)] моль ([round(gas_concentration*100, 0.01)] %)")
			message += span_notice("Температура: [round(temperature - T0C,0.01)] &deg;C ([round(temperature, 0.01)] K)")
			message += span_notice("Объём: [volume] Л")
			message += span_notice("Давление: [round(pressure, 0.01)] кПа")
			message += span_notice("Теплоёмкость: [display_joules(heat_capacity)] / K")
			message += span_notice("Термальная энергия: [display_joules(thermal_energy)]")
		else
			message += airs.len > 1 ? span_notice("Здесь вакуум!") : span_notice("[target] вакуумная!")
			message += span_notice("Объём: [volume] Л") // don't want to change the order volume appears in, suck it

	// we let the join apply newlines so we do need handholding
	to_chat(user, "<div class='examine_block'>[jointext(message, "\n")]</div>", type = MESSAGE_TYPE_INFO)
	return TRUE

/obj/item/analyzer/AltClick(mob/user) //Barometer output for measuring when the next storm happens
	..()

	if(user.canUseTopic(src, BE_CLOSE))
		if(cooldown)
			to_chat(user, span_warning("Барометр [src] перезаряжается."))
			return

		var/turf/T = get_turf(user)
		if(!T)
			return

		playsound(src, 'sound/effects/pop.ogg', 100)
		var/area/user_area = T.loc
		var/datum/weather/ongoing_weather = null

		if(!user_area.outdoors)
			to_chat(user, span_warning("Барометр [src] не работает внутри помещений!"))
			return

		for(var/V in SSweather.processing)
			var/datum/weather/W = V
			if(W.barometer_predictable && (T.z in W.impacted_z_levels) && W.area_type == user_area.type && !(W.stage == END_STAGE))
				ongoing_weather = W
				break

		if(ongoing_weather)
			if((ongoing_weather.stage == MAIN_STAGE) || (ongoing_weather.stage == WIND_DOWN_STAGE))
				to_chat(user, span_warning("Барометр [src] не может определить какая сейчас погода, ведь шторм ещё [ongoing_weather.stage == MAIN_STAGE ? "идёт!" : "утихает."]"))
				return

			to_chat(user, span_notice("Следующий [ongoing_weather] будет через [butchertime(ongoing_weather.next_hit_time - world.time)]."))
			if(ongoing_weather.aesthetic)
				to_chat(user, span_warning("Барометр [src] сообщает, что следующий шторм будет слабым."))
		else
			var/next_hit = SSweather.next_hit_by_zlevel["[T.z]"]
			var/fixed = next_hit ? timeleft(next_hit) : -1
			if(fixed < 0)
				to_chat(user, span_warning("Барометр [src] не может определить погоду в этой местности."))
			else
				to_chat(user, span_warning("Барометр [src] сообщает, что следующий шторм будет через [butchertime(fixed)]."))
		cooldown = TRUE
		addtimer(CALLBACK(src,/obj/item/analyzer/proc/ping), cooldown_time)

/obj/item/analyzer/proc/ping()
	if(isliving(loc))
		var/mob/living/L = loc
		to_chat(L, span_notice("Барометр [src] готов к работе!"))
	playsound(src, 'sound/machines/click.ogg', 100)
	cooldown = FALSE

/obj/item/analyzer/proc/butchertime(amount)
	if(!amount)
		return
	if(accuracy)
		var/inaccurate = round(accuracy*(1/3))
		if(prob(50))
			amount -= inaccurate
		if(prob(50))
			amount += inaccurate
	return DisplayTimeText(max(1,amount))

/proc/atmosanalyzer_scan(mob/user, atom/target, silent=FALSE)
	var/mixture = target.return_analyzable_air()
	if(!mixture)
		return FALSE

	var/icon = target
	var/render_list = list()
	if(!silent && isliving(user))
		user.visible_message(span_notice("[user] использует анализатор на [icon2html(icon, viewers(user))] [target].") , span_notice("Использую анализатор на [icon2html(icon, user)] [target]."))
	render_list += span_boldnotice("Результат анализа [icon2html(icon, user)] [target].")

	var/list/airs = islist(mixture) ? mixture : list(mixture)
	for(var/g in airs)
		if(airs.len > 1) //not a unary gas mixture
			render_list += span_boldnotice("Ячейка [airs.Find(g)]")
		var/datum/gas_mixture/air_contents = g

		var/total_moles = air_contents.total_moles()
		var/pressure = air_contents.return_pressure()
		var/volume = air_contents.return_volume() //could just do mixture.volume... but safety, I guess?
		var/temperature = air_contents.return_temperature()

		if(total_moles > 0)
			render_list += "<span class='notice'>Моли: [round(total_moles, 0.01)] моль</span>\
							\n<span class='notice'>Объём: [volume] Л</span>\
							\n<span class='notice'>Давление: [round(pressure,0.01)] кПа</span>\
							\n<span class='notice'>Т.Энергия: [display_joules(THERMAL_ENERGY(air_contents))]</span>"

			for(var/id in air_contents.get_gases())
				var/gas_concentration = air_contents.get_moles(id) / total_moles
				render_list += span_notice("[GLOB.meta_gas_info[id][META_GAS_NAME]]: [round(gas_concentration*100, 0.01)] % ([round(air_contents.get_moles(id), 0.01)] моль)")
			render_list += span_notice("Температура: [round(temperature - T0C,0.01)] &deg;C ([round(temperature, 0.01)] K)")
		else
			render_list += airs.len > 1 ? span_notice("Эта ячейка пуста!")  : span_notice("В [target] ничего нет!")

	to_chat(user, jointext(render_list, "\n")) // we let the join apply newlines so we do need handholding
	return TRUE

//slime scanner

/obj/item/slime_scanner
	name = "анализатор слаймов"
	desc = "Устройство, которое определяет состав и общие показатели слаймов."
	icon = 'icons/obj/device.dmi'
	icon_state = "adv_spectrometer"
	inhand_icon_state = "analyzer"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	flags_1 = CONDUCT_1
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	custom_materials = list(/datum/material/iron=30, /datum/material/glass=20)

/obj/item/slime_scanner/attack(mob/living/M, mob/living/user)
	if(user.stat || user.is_blind())
		return
	if (!isslime(M))
		to_chat(user, span_warning("Это устройство может сканировать только слаймов!"))
		return
	var/mob/living/simple_animal/slime/T = M
	slime_scan(T, user)

/proc/slime_scan(mob/living/simple_animal/slime/T, mob/living/user)
	var/to_render = "========================\
					\n<b>Результат сканирования слайма:</b>\
					\n<span class='notice'>[T.colour] [T.is_adult ? "взрослый" : "молодой"] слайм</span>\
					\nНасыщенность: [T.nutrition]/[T.get_max_nutrition()]"
	if (T.nutrition < T.get_starve_nutrition())
		to_render += span_warning("\nВнимание: слайм голодает!")
	else if (T.nutrition < T.get_hunger_nutrition())
		to_render += span_warning("\nВнимание: слайм хочет кушать")
	to_render += "\nШанс электрошока: [T.powerlevel]\nЗдоровье: [round(T.health/T.maxHealth,0.01)*100]%"
	if (T.slime_mutation[4] == T.colour)
		to_render += "\nЭтот слайм больше не хочет развиваться."
	else
		if (T.slime_mutation[3] == T.slime_mutation[4])
			if (T.slime_mutation[2] == T.slime_mutation[1])
				to_render += "\nВозможная мутация: [T.slime_mutation[3]]\
							\nНестабильность: [T.mutation_chance/2]% мутация при делении"
			else
				to_render += "\nВозможная мутация: [T.slime_mutation[1]], [T.slime_mutation[2]], [T.slime_mutation[3]] (x2)\
							\nНестабильность: [T.mutation_chance]% мутация при делении"
		else
			to_render += "\nВозможная мутация: [T.slime_mutation[1]], [T.slime_mutation[2]], [T.slime_mutation[3]], [T.slime_mutation[4]]\
						\nНестабильность: [T.mutation_chance]% мутация при делении"
	if (T.cores > 1)
		to_render += "\nОбнаружено несколько ядер"
	to_render += "\nРост: [T.amount_grown]/[SLIME_EVOLUTION_THRESHOLD]"
	if(T.effectmod)
		to_render += "\n<span class='notice'>Мутация ядер в процессе: [T.effectmod]</span>\
					\n<span class='notice'>Прогрмесс в мутации ядер: [T.applied] / [SLIME_EXTRACT_CROSSING_REQUIRED]</span>"
	to_chat(user, to_render + "\n========================")


/obj/item/nanite_scanner
	name = "анализатор нанитов"
	icon = 'icons/obj/device.dmi'
	icon_state = "nanite_scanner"
	inhand_icon_state = "electronic"
	worn_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	desc = "Устройство для определения нанитов и их особенностей."
	flags_1 = CONDUCT_1
	item_flags = NOBLUDGEON
	slot_flags = ITEM_SLOT_BELT
	throwforce = 3
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 7
	custom_materials = list(/datum/material/iron=200)

/obj/item/nanite_scanner/attack(mob/living/M, mob/living/carbon/human/user)
	user.visible_message(span_notice("[user] анализирует наниты [M].") , \
						span_notice("Анализирую наниты [M]."))

	add_fingerprint(user)

	var/response = SEND_SIGNAL(M, COMSIG_NANITE_SCAN, user, TRUE)
	if(!response)
		to_chat(user, span_info("Не обнаружено нанитов в пациенте."))

/obj/item/sequence_scanner
	name = "анализатор ДНК"
	icon = 'icons/obj/device.dmi'
	icon_state = "gene"
	inhand_icon_state = "healthanalyzer"
	worn_icon_state = "healthanalyzer"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	desc = "Позволяет проводить генетический анализ на лету. Если соединить это с консолью ДНК, то устройство будет получать новые данные о мутациях."
	flags_1 = CONDUCT_1
	item_flags = NOBLUDGEON
	slot_flags = ITEM_SLOT_BELT
	throwforce = 3
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 7
	custom_materials = list(/datum/material/iron=200)
	var/list/discovered = list() //hit a dna console to update the scanners database
	var/list/buffer
	var/ready = TRUE
	var/cooldown = 200

/obj/item/sequence_scanner/attack(mob/living/M, mob/living/carbon/human/user)
	add_fingerprint(user)
	if (!HAS_TRAIT(M, TRAIT_GENELESS) && !HAS_TRAIT(M, TRAIT_BADDNA)) //no scanning if its a husk or DNA-less Species
		user.visible_message(span_notice("[user] анализирует геном [M].") , \
							span_notice("Анализирую геном [M]."))
		gene_scan(M, user)

	else
		user.visible_message(span_notice("[user] не может проанализировать геном [M].") , span_warning("[M] не имеет считываемого генома!"))

/obj/item/sequence_scanner/afterattack(obj/O, mob/user, proximity)
	. = ..()
	if(!istype(O) || !proximity)
		return

	if(istype(O, /obj/machinery/computer/scan_consolenew))
		var/obj/machinery/computer/scan_consolenew/C = O
		if(C.stored_research)
			to_chat(user, span_notice("[name] подключено к исследовательской БД."))
			discovered = C.stored_research.discovered_mutations
		else
			to_chat(user,span_warning("Не обнаружено баз данных."))

/obj/item/sequence_scanner/proc/gene_scan(mob/living/carbon/C, mob/living/user)
	if(!iscarbon(C) || !C.has_dna())
		return

	to_chat(user, span_notice("Генетическая стабильность: [C.dna.stability]%."))

	buffer = C.dna.mutation_index
	to_chat(user, span_notice("ДНК пациента [C.name] сохранено в буффер."))
	if(LAZYLEN(buffer))
		for(var/A in buffer)
			to_chat(user, span_notice("[get_display_name(A)]"))


/obj/item/sequence_scanner/proc/display_sequence(mob/living/user)
	if(!LAZYLEN(buffer) || !ready)
		return
	var/list/options = list()
	for(var/A in buffer)
		options += get_display_name(A)

	var/answer = tgui_input_list(user, "Analyze Potential", "Sequence Analyzer", sort_list(options))
	if(answer && ready && user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		var/sequence
		for(var/A in buffer) //this physically hurts but i dont know what anything else short of an assoc list
			if(get_display_name(A) == answer)
				sequence = buffer[A]
				break

		if(sequence)
			var/display
			for(var/i in 0 to length_char(sequence) / DNA_MUTATION_BLOCKS-1)
				if(i)
					display += "-"
				display += copytext_char(sequence, 1 + i*DNA_MUTATION_BLOCKS, DNA_MUTATION_BLOCKS*(1+i) + 1)

			to_chat(user, "<span class='boldnotice'>[display]</span><br>")

		ready = FALSE
		icon_state = "[icon_state]_recharging"
		addtimer(CALLBACK(src, PROC_REF(recharge)), cooldown, TIMER_UNIQUE)

/obj/item/sequence_scanner/proc/recharge()
	icon_state = initial(icon_state)
	ready = TRUE

/obj/item/sequence_scanner/proc/get_display_name(mutation)
	var/datum/mutation/human/HM = GET_INITIALIZED_MUTATION(mutation)
	if(!HM)
		return "ERROR"
	if(mutation in discovered)
		return  "[HM.name] ([HM.alias])"
	else
		return HM.alias

/obj/item/scanner_wand
	name = "kiosk scanner wand"
	icon = 'icons/obj/device.dmi'
	icon_state = "scanner_wand"
	inhand_icon_state = "healthanalyzer"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	desc = "A wand for scanning someone else for a medical analysis. Insert into a kiosk is make the scanned patient the target of a health scan."
	force = 0
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	var/selected_target = null

/obj/item/scanner_wand/attack(mob/living/M, mob/living/carbon/human/user)
	flick("[icon_state]_active", src)	//nice little visual flash when scanning someone else.

	if((HAS_TRAIT(user, TRAIT_CLUMSY) || HAS_TRAIT(user, TRAIT_DUMB)) && prob(25))
		user.visible_message(span_warning("[user] targets himself for scanning.") , \
		to_chat(user, span_info("You try scanning [M], before realizing you're holding the scanner backwards. Whoops.")))
		selected_target = user
		return

	if(!ishuman(M))
		to_chat(user, span_info("You can only scan human-like, non-robotic beings."))
		selected_target = null
		return

	user.visible_message(span_notice("[user] targets [M] for scanning.") , \
						span_notice("You target [M] vitals."))
	selected_target = M
	return

/obj/item/scanner_wand/attack_self(mob/user)
	to_chat(user, span_info("You clear the scanner's target."))
	selected_target = null

/obj/item/scanner_wand/proc/return_patient()
	var/returned_target = selected_target
	return returned_target

#undef SCANMODE_HEALTH
#undef SCANMODE_CHEMICAL
#undef SCANMODE_WOUND
#undef SCANNER_CONDENSED
#undef SCANNER_VERBOSE

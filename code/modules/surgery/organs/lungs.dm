/obj/item/organ/lungs
	var/failed = FALSE
	var/operated = FALSE	//whether we can still have our damages fixed through surgery
	name = "лёгкие"
	icon_state = "lungs"
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_LUNGS
	gender = PLURAL
	w_class = WEIGHT_CLASS_SMALL

	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY * 0.9 // fails around 16.5 minutes, lungs are one of the last organs to die (of the ones we have)

	low_threshold_passed = span_warning("Трудно дышать...")
	high_threshold_passed = span_warning("Ощущаю какое-то сжатие вокруг груди, моё дыхание становится поверхностным и быстрым.")
	now_fixed = span_warning("Моим лёгким, похоже, стало легче.")
	low_threshold_cleared = span_info("Воздух начинает поступать в мои лёгкие. Благодать.")
	high_threshold_cleared = span_info("Давление вокруг моей груди ослабевает, дышать стало легче.")


	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/medicine/salbutamol = 5)

	//Breath damage

	var/breathing_class = BREATH_OXY // can be a gas instead of a breathing class
	var/safe_breath_min = 16
	var/safe_breath_max = 50
	var/safe_breath_dam_min = MIN_TOXIC_GAS_DAMAGE
	var/safe_breath_dam_max = MAX_TOXIC_GAS_DAMAGE
	var/safe_damage_type = OXY
	var/list/gas_min = list()
	var/list/gas_max = list(
		GAS_CO2 = 30, // Yes it's an arbitrary value who cares?
		GAS_PLASMA = MOLES_GAS_VISIBLE
	)
	var/list/gas_damage = list(
		"default" = list(
			min = MIN_TOXIC_GAS_DAMAGE,
			max = MAX_TOXIC_GAS_DAMAGE,
			damage_type = OXY
		),
		GAS_PLASMA = list(
			min = MIN_TOXIC_GAS_DAMAGE,
			max = MAX_TOXIC_GAS_DAMAGE,
			damage_type = TOX
		)
	)

	var/SA_para_min = 1 //nitrous values
	var/SA_sleep_min = 5
	var/BZ_trip_balls_min = 0.1 //BZ gas
	var/BZ_brain_damage_min = 1
	var/gas_stimulation_min = 0.002 //Nitryl and Stimulum

	var/cold_message = "как моё лицо мёрзнет и ледяной воздух поступает"
	var/cold_level_1_threshold = 260
	var/cold_level_2_threshold = 200
	var/cold_level_3_threshold = 120
	var/cold_level_1_damage = COLD_GAS_DAMAGE_LEVEL_1 //Keep in mind with gas damage levels, you can set these to be negative, if you want someone to heal, instead.
	var/cold_level_2_damage = COLD_GAS_DAMAGE_LEVEL_2
	var/cold_level_3_damage = COLD_GAS_DAMAGE_LEVEL_3
	var/cold_damage_type = BURN

	var/hot_message = "как моё лицо горит и горячий воздух поступает"
	var/heat_level_1_threshold = 360
	var/heat_level_2_threshold = 400
	var/heat_level_3_threshold = 1000
	var/heat_level_1_damage = HEAT_GAS_DAMAGE_LEVEL_1
	var/heat_level_2_damage = HEAT_GAS_DAMAGE_LEVEL_2
	var/heat_level_3_damage = HEAT_GAS_DAMAGE_LEVEL_3
	var/heat_damage_type = BURN

	var/crit_stabilizing_reagent = /datum/reagent/medicine/epinephrine

/obj/item/organ/lungs/New()
	. = ..()
	populate_gas_info()

/obj/item/organ/lungs/proc/populate_gas_info()
	gas_min[breathing_class] = safe_breath_min
	gas_max[breathing_class] = safe_breath_max
	gas_damage[breathing_class] = list(
		min = safe_breath_dam_min,
		max = safe_breath_dam_max,
		damage_type = safe_damage_type
	)

/obj/item/organ/lungs/proc/check_breath(datum/gas_mixture/breath, mob/living/carbon/human/H)
//TODO: add lung damage = less oxygen gains
	var/breathModifier = (5-(5*(damage/maxHealth)/2)) //range 2.5 - 5
	if(H.status_flags & GODMODE)
		return
	if(HAS_TRAIT(H, TRAIT_NOBREATH))
		return

	if(!breath || (breath.total_moles() == 0))
		if(H.reagents.has_reagent(crit_stabilizing_reagent))
			return
		if(H.health >= H.crit_threshold)
			H.adjustOxyLoss(HUMAN_MAX_OXYLOSS)
		else if(!HAS_TRAIT(H, TRAIT_NOCRITDAMAGE))
			H.adjustOxyLoss(HUMAN_CRIT_MAX_OXYLOSS)

		H.failed_last_breath = TRUE
		var/alert_category
		var/alert_type
		if(ispath(breathing_class))
			var/datum/breathing_class/class = GLOB.gas_data.breathing_classes[breathing_class]
			alert_category = class.low_alert_category
			alert_type = class.low_alert_datum
		else
			var/list/breath_alert_info = GLOB.gas_data.breath_alert_info
			if(breathing_class in breath_alert_info)
				var/list/alert = breath_alert_info[breathing_class]["not_enough_alert"]
				alert_category = alert["alert_category"]
				alert_type = alert["alert_type"]
		if(alert_category)
			H.throw_alert(alert_category, alert_type)
		return FALSE

	#define PP_MOLES(X) ((X / total_moles) * pressure)

	#define PP(air, gas) PP_MOLES(air.get_moles(gas))

	var/gas_breathed = 0

	var/pressure = breath.return_pressure()
	var/total_moles = breath.total_moles()
	var/list/breath_alert_info = GLOB.gas_data.breath_alert_info
	var/list/breath_results = GLOB.gas_data.breath_results
	var/list/breathing_classes = GLOB.gas_data.breathing_classes
	var/list/mole_adjustments = list()
	for(var/entry in gas_min)
		var/required_pp = 0
		var/required_moles = 0
		var/safe_min = gas_min[entry]
		var/alert_category = null
		var/alert_type = null
		if(ispath(entry))
			var/datum/breathing_class/class = breathing_classes[entry]
			var/list/gases = class.gases
			var/list/products = class.products
			alert_category = class.low_alert_category
			alert_type = class.low_alert_datum
			for(var/gas in gases)
				var/moles = breath.get_moles(gas)
				var/multiplier = gases[gas]
				mole_adjustments[gas] = (gas in mole_adjustments) ? mole_adjustments[gas] - moles : -moles
				required_pp += PP_MOLES(moles) * multiplier
				required_moles += moles
				if(multiplier > 0)
					var/to_add = moles * multiplier
					for(var/product in products)
						mole_adjustments[product] = (product in mole_adjustments) ? mole_adjustments[product] + to_add : to_add
		else
			required_moles = breath.get_moles(entry)
			required_pp = PP_MOLES(required_moles)
			if(entry in breath_alert_info)
				var/list/alert = breath_alert_info[entry]["not_enough_alert"]
				alert_category = alert["alert_category"]
				alert_type = alert["alert_type"]
			mole_adjustments[entry] = -required_moles
			mole_adjustments[breath_results[entry]] = required_moles
		if(required_pp < safe_min)
			var/multiplier = handle_too_little_breath(H, required_pp, safe_min, required_moles)
			if(required_moles > 0)
				multiplier /= required_moles
			for(var/adjustment in mole_adjustments)
				mole_adjustments[adjustment] *= multiplier
			if(alert_category)
				H.throw_alert(alert_category, alert_type)
		else
			H.failed_last_breath = FALSE
			if(H.health >= H.crit_threshold)
				H.adjustOxyLoss(-breathModifier)
			if(alert_category)
				H.clear_alert(alert_category)
	var/list/danger_reagents = GLOB.gas_data.breath_reagents_dangerous
	for(var/entry in gas_max)
		var/found_pp = 0
		var/datum/breathing_class/breathing_class = entry
		var/datum/reagent/danger_reagent = null
		var/alert_category = null
		var/alert_type = null
		if(ispath(breathing_class))
			breathing_class = breathing_classes[breathing_class]
			alert_category = breathing_class.high_alert_category
			alert_type = breathing_class.high_alert_datum
			danger_reagent = breathing_class.danger_reagent
			found_pp = breathing_class.get_effective_pp(breath)
		else
			danger_reagent = danger_reagents[entry]
			if(entry in breath_alert_info)
				var/list/alert = breath_alert_info[entry]["too_much_alert"]
				alert_category = alert["alert_category"]
				alert_type = alert["alert_type"]
			found_pp = PP(breath, entry)
		if(found_pp > gas_max[entry])
			if(istype(danger_reagent))
				H.reagents.add_reagent(danger_reagent,1)
			var/list/damage_info = (entry in gas_damage) ? gas_damage[entry] : gas_damage["default"]
			var/dam = found_pp / gas_max[entry] * 10
			H.apply_damage_type(clamp(dam, damage_info["min"], damage_info["max"]), damage_info["damage_type"])
			if(alert_category && alert_type)
				H.throw_alert(alert_category, alert_type)
		else if(alert_category)
			H.clear_alert(alert_category)
	var/list/breath_reagents = GLOB.gas_data.breath_reagents
	for(var/gas in breath.get_gases())
		if(gas in breath_reagents)
			var/datum/reagent/R = breath_reagents[gas]
			//H.reagents.add_reagent(R, breath.get_moles(gas) * R.molarity) // See next line
			H.reagents.add_reagent(R, breath.get_moles(gas) * 2) // 2 represents molarity of O2, we don't have citadel molarity
			mole_adjustments[gas] = (gas in mole_adjustments) ? mole_adjustments[gas] - breath.get_moles(gas) : -breath.get_moles(gas)

	for(var/gas in mole_adjustments)
		breath.adjust_moles(gas, mole_adjustments[gas])

	if(breath)	// If there's some other shit in the air lets deal with it here.

	// N2O

		var/SA_pp = PP(breath, GAS_NITROUS)
		if(SA_pp > SA_para_min) // Enough to make us stunned for a bit
			H.Unconscious(60) // 60 gives them one second to wake up and run away a bit!
			if(SA_pp > SA_sleep_min) // Enough to make us sleep as well
				H.Sleeping(max(H.AmountSleeping() + 40, 200))
		else if(SA_pp > 0.01)	// There is sleeping gas in their lungs, but only a little, so give them a bit of a warning
			if(prob(20))
				H.emote(pick("giggle", "laugh"))
				SEND_SIGNAL(owner, COMSIG_ADD_MOOD_EVENT, "chemical_euphoria", /datum/mood_event/chemical_euphoria)
		else
			SEND_SIGNAL(owner, COMSIG_CLEAR_MOOD_EVENT, "chemical_euphoria")

	// BZ

		var/bz_pp = PP(breath, GAS_BZ)
		if(bz_pp > BZ_brain_damage_min)
			H.hallucination += 10
			H.reagents.add_reagent(/datum/reagent/bz_metabolites,5)
			if(prob(33))
				H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 3, 150)

		else if(bz_pp > BZ_trip_balls_min)
			H.hallucination += 5
			H.reagents.add_reagent(/datum/reagent/bz_metabolites,1)

	// Nitryl
		var/nitryl_pp = PP(breath,GAS_NITRYL)
		if (prob(nitryl_pp))
			to_chat(H, "<span class='alert'>Глотка горит!</span>")
		if (nitryl_pp >40)
			H.emote("gasp")
			H.adjustFireLoss(10)
			if (prob(nitryl_pp/2))
				to_chat(H, "<span class='alert'>Сложно дышать!</span>")
				H.silent = max(H.silent, 3)
		else
			H.adjustFireLoss(nitryl_pp/4)
		gas_breathed = breath.get_moles(GAS_NITRYL)
		if (gas_breathed > gas_stimulation_min)
			H.reagents.add_reagent(/datum/reagent/nitryl,1)

		breath.adjust_moles(GAS_NITRYL, -gas_breathed)

	// Stimulum
		gas_breathed = PP(breath,GAS_STIMULUM)
		if (gas_breathed > gas_stimulation_min)
			var/existing = H.reagents.get_reagent_amount(/datum/reagent/stimulum)
			H.reagents.add_reagent(/datum/reagent/stimulum, max(0, 5 - existing))
		breath.adjust_moles(GAS_STIMULUM, -gas_breathed)

	// Miasma
		if (breath.get_moles(GAS_MIASMA))
			var/miasma_pp = PP(breath,GAS_MIASMA)
			if(miasma_pp > MINIMUM_MOLES_DELTA_TO_MOVE)

				//Miasma sickness
				if(prob(0.05 * miasma_pp))
					var/datum/disease/advance/miasma_disease = new /datum/disease/advance/random(TRUE, 2, 3)
					miasma_disease.name = "Неизвестно"
					miasma_disease.try_infect(owner)

				// Miasma side effects
				switch(miasma_pp)
					if(1 to 5)
						// At lower pp, give out a little warning
						SEND_SIGNAL(owner, COMSIG_CLEAR_MOOD_EVENT, "smell")
						if(prob(5))
							to_chat(owner, span_notice("Тошнотворный запах."))
					if(6 to 15)
						//At somewhat higher pp, warning becomes more obvious
						if(prob(15))
							to_chat(owner, span_warning("Здесь кто-то умер? Воняет ужасно..."))
							SEND_SIGNAL(owner, COMSIG_ADD_MOOD_EVENT, "smell", /datum/mood_event/disgust/bad_smell)
					if(16 to 30)
						//Small chance to vomit. By now, people have internals on anyway
						if(prob(5))
							to_chat(owner, span_warning("Вонь гниющих туш невыносима! Тошнит..."))
							SEND_SIGNAL(owner, COMSIG_ADD_MOOD_EVENT, "smell", /datum/mood_event/disgust/nauseating_stench)
							owner.vomit()
					if(31 to INFINITY)
						//Higher chance to vomit. Let the horror start
						if(prob(15))
							to_chat(owner, span_warning("Вонь гниющих туш невыносима! Сейчас блевану..."))
							SEND_SIGNAL(owner, COMSIG_ADD_MOOD_EVENT, "smell", /datum/mood_event/disgust/nauseating_stench)
							owner.vomit()
					else
						SEND_SIGNAL(owner, COMSIG_CLEAR_MOOD_EVENT, "smell")

				// In a full miasma atmosphere with 101.34 pKa, about 10 disgust per breath, is pretty low compared to threshholds
				// Then again, this is a purely hypothetical scenario and hardly reachable
				owner.adjust_disgust(0.1 * miasma_pp)

				breath.adjust_moles(GAS_MIASMA, -gas_breathed)

		// Clear out moods when no miasma at all
		else
			SEND_SIGNAL(owner, COMSIG_CLEAR_MOOD_EVENT, "smell")

	// Freon
		var/freon_pp = PP(breath, GAS_FREON)
		if (prob(freon_pp))
			to_chat(H, span_alert("Глотка горит!"))
		if (freon_pp > 40)
			H.emote("gasp")
			H.adjustFireLoss(15)
			if (prob(freon_pp / 2))
				to_chat(H, span_alert("Сложно дышать!"))
				H.silent = max(H.silent, 3)
		else
			H.adjustFireLoss(freon_pp / 4)
		gas_breathed = breath.get_moles(GAS_FREON)
		if (gas_breathed > gas_stimulation_min)
			H.reagents.add_reagent(/datum/reagent/freon, 1)
		breath.adjust_moles(GAS_FREON, -gas_breathed)

	// Healium
		var/healium_pp = PP(breath, GAS_HEALIUM)
		if(healium_pp > gas_stimulation_min)
			if(prob(15))
				to_chat(H, span_alert("Голова кружится, лёгкие горят!"))
				H.emote("gasp")

		if(healium_pp > 3)
			H.Unconscious(rand(30, 50))//not in seconds to have a much higher variation
			if(healium_pp > 6)
				var/existing = H.reagents.get_reagent_amount(/datum/reagent/healium)
				H.reagents.add_reagent(/datum/reagent/healium, max(0, 1 - existing))
		gas_breathed = breath.get_moles(GAS_HEALIUM)
		breath.adjust_moles(GAS_HEALIUM, -gas_breathed)

	// Zauker
		var/zauker_pp = PP(breath, GAS_ZAUKER)
		if(zauker_pp > gas_stimulation_min)
			var/existing = H.reagents.get_reagent_amount(/datum/reagent/zauker)
			H.reagents.add_reagent(/datum/reagent/zauker, max(0, 1 - existing))
		gas_breathed = breath.get_moles(GAS_ZAUKER)
		breath.adjust_moles(GAS_ZAUKER, -gas_breathed)

	// Halon
		var/halon_pp = PP(breath, GAS_HALON)
		if(halon_pp > gas_stimulation_min)
			H.adjustOxyLoss(5)
			var/existing = H.reagents.get_reagent_amount(/datum/reagent/halon)
			H.reagents.add_reagent(/datum/reagent/halon, max(0, 1 - existing))
		gas_breathed = breath.get_moles(GAS_HALON)
		breath.adjust_moles(GAS_HALON, -gas_breathed)

	// Hyper-Nob
		gas_breathed = breath.get_moles(GAS_HYPERNOB)
		if (gas_breathed > gas_stimulation_min)
			var/existing = H.reagents.get_reagent_amount(/datum/reagent/hypernoblium)
			H.reagents.add_reagent(/datum/reagent/hypernoblium, max(0, 1 - existing))
		breath.adjust_moles(GAS_HYPERNOB, -gas_breathed)

		handle_breath_temperature(breath, H)
	return TRUE

/obj/item/organ/lungs/proc/handle_too_little_breath(mob/living/carbon/human/H = null, breath_pp = 0, safe_breath_min = 0, true_pp = 0)
	. = 0
	if(!H || !safe_breath_min) //the other args are either: Ok being 0 or Specifically handled.
		return FALSE

	if(prob(20))
		H.emote("gasp")
	if(breath_pp > 0)
		var/ratio = safe_breath_min/breath_pp
		H.adjustOxyLoss(min(5*ratio, HUMAN_MAX_OXYLOSS)) // Don't fuck them up too fast (space only does HUMAN_MAX_OXYLOSS after all!
		H.failed_last_breath = TRUE
		. = true_pp*ratio/6
	else
		H.adjustOxyLoss(HUMAN_MAX_OXYLOSS)
		H.failed_last_breath = TRUE


/obj/item/organ/lungs/proc/handle_breath_temperature(datum/gas_mixture/breath, mob/living/carbon/human/H) // called by human/life, handles temperatures
	var/breath_temperature = breath.return_temperature()

	if(!HAS_TRAIT(H, TRAIT_RESISTCOLD)) // COLD DAMAGE
		var/cold_modifier = H.dna.species.coldmod
		if(breath_temperature < cold_level_3_threshold)
			H.apply_damage_type(cold_level_3_damage*cold_modifier, cold_damage_type)
		if(breath_temperature > cold_level_3_threshold && breath_temperature < cold_level_2_threshold)
			H.apply_damage_type(cold_level_2_damage*cold_modifier, cold_damage_type)
		if(breath_temperature > cold_level_2_threshold && breath_temperature < cold_level_1_threshold)
			H.apply_damage_type(cold_level_1_damage*cold_modifier, cold_damage_type)
		if(breath_temperature < cold_level_1_threshold)
			if(prob(20))
				to_chat(H, span_warning("Ощущаю [cold_message] в мои лёгкие!"))

	if(!HAS_TRAIT(H, TRAIT_RESISTHEAT)) // HEAT DAMAGE
		var/heat_modifier = H.dna.species.heatmod
		if(breath_temperature > heat_level_1_threshold && breath_temperature < heat_level_2_threshold)
			H.apply_damage_type(heat_level_1_damage*heat_modifier, heat_damage_type)
		if(breath_temperature > heat_level_2_threshold && breath_temperature < heat_level_3_threshold)
			H.apply_damage_type(heat_level_2_damage*heat_modifier, heat_damage_type)
		if(breath_temperature > heat_level_3_threshold)
			H.apply_damage_type(heat_level_3_damage*heat_modifier, heat_damage_type)
		if(breath_temperature > heat_level_1_threshold)
			if(prob(20))
				to_chat(H, span_warning("Ощущаю [hot_message] в мои лёгкие!"))

	// The air you breathe out should match your body temperature
	breath.set_temperature(H.bodytemperature)

/obj/item/organ/lungs/on_life(delta_time, times_fired)
	. = ..()
	if(failed && !(organ_flags & ORGAN_FAILING))
		failed = FALSE
		return
	if(damage >= low_threshold)
		var/do_i_cough = DT_PROB((damage < high_threshold) ? 2.5 : 5, delta_time) // between : past high
		if(do_i_cough)
			owner.emote("cough")
	if(organ_flags & ORGAN_FAILING && owner.stat == CONSCIOUS)
		owner.visible_message(span_danger("[owner] grabs [owner.ru_ego()] throat, struggling for breath!") , span_userdanger("You suddenly feel like you can't breathe!"))
		failed = TRUE

/obj/item/organ/lungs/get_availability(datum/species/S)
	return !(TRAIT_NOBREATH in S.inherent_traits)

/obj/item/organ/lungs/plasmaman
	name = "плазма-фильтр"
	desc = "Губчатая масса в форме ребра для фильтрации плазмы из дыхания."
	icon_state = "lungs-plasma"
	breathing_class = BREATH_PLASMA

	gas_damage = list(
		"default" = list(
			min = MIN_TOXIC_GAS_DAMAGE,
			max = MAX_TOXIC_GAS_DAMAGE,
			damage_type = OXY
		)
	)

	gas_max = list(
		GAS_PLASMA = 50,
		GAS_CO2 = 30
	)

/obj/item/organ/lungs/slime
	name = "вакуоль"
	desc = "Большая органелла, предназначенная для хранения кислорода и других важных газов."

/obj/item/organ/lungs/slime/check_breath(datum/gas_mixture/breath, mob/living/carbon/human/H)
	. = ..()
	if (breath)
		var/plasma_pp = breath.get_breath_partial_pressure(breath.get_moles(GAS_PLASMA))
		owner.blood_volume += (0.2 * plasma_pp) // 10/s when breathing literally nothing but plasma, which will suffocate you.

/obj/item/organ/lungs/cybernetic
	name = "базовые кибернетические лёгкие"
	desc = "Базовая кибернетическая версия легких, встречающаяся у традиционных гуманоидных существ."
	icon_state = "lungs-c"
	organ_flags = ORGAN_SYNTHETIC
	maxHealth = STANDARD_ORGAN_THRESHOLD * 0.5

	var/emp_vulnerability = 80	//Chance of permanent effects if emp-ed.

/obj/item/organ/lungs/cybernetic/tier2
	name = "кибернетические лёгкие"
	desc = "Кибернетическая версия легких традиционных гуманоидных существ. Позволяет потреблять больше кислорода, чем органические легкие, требуя немного меньшего давления."
	icon_state = "lungs-c-u"
	maxHealth = 1.5 * STANDARD_ORGAN_THRESHOLD
	safe_breath_min = 13
	safe_breath_max = 100

/obj/item/organ/lungs/cybernetic/tier3
	name = "продвинутые кибернетические лёгкие"
	desc = "Более продвинутая версия штатных кибернетических легких. Отличается способностью отфильтровывать более низкие уровни токсинов и углекислого газа."
	icon_state = "lungs-c-u2"
	safe_breath_min = 4
	safe_breath_max = 250
	gas_max = list(
		GAS_PLASMA = 30,
		GAS_CO2 = 30
	)
	maxHealth = 2 * STANDARD_ORGAN_THRESHOLD

	cold_level_1_threshold = 200
	cold_level_2_threshold = 140
	cold_level_3_threshold = 100

/obj/item/organ/lungs/cybernetic/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(!COOLDOWN_FINISHED(src, severe_cooldown)) //So we cant just spam emp to kill people.
		owner.losebreath += 20
		COOLDOWN_START(src, severe_cooldown, 30 SECONDS)
	if(prob(emp_vulnerability/severity))	//Chance of permanent effects
		organ_flags |= ORGAN_SYNTHETIC_EMP //Starts organ faliure - gonna need replacing soon.

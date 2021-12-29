#define FEVER_CHANGE "fever"

/*
//////////////////////////////////////

Fever

	No change to hidden.
	Increases resistance.
	Increases stage speed.
	Little transmittable.
	Low level.

Bonus
	Heats up your body.

//////////////////////////////////////
*/

/datum/symptom/fever
	name = "Жар"
	desc = "Вирус вызывает у хозяина лихорадочную реакцию, повышая температуру его тела."
	stealth = 0
	resistance = 3
	stage_speed = 3
	transmittable = 2
	level = 2
	severity = 2
	base_message_chance = 20
	symptom_delay_min = 10
	symptom_delay_max = 30
	var/unsafe = FALSE //over the heat threshold
	threshold_descs = list(
		"Сопротивление 5" = "Повышает интенсивность жара, жар может вызвать перегрев и навредить хозяину.",
		"Сопротивление 10" = "Еще больше увеличивает интенсивность лихорадки.",
	)

/datum/symptom/fever/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["resistance"] >= 5) //dangerous fever
		power = 1.5
		unsafe = TRUE
	if(A.properties["resistance"] >= 10)
		power = 2.5

/datum/symptom/fever/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/M = A.affected_mob
	if(!unsafe || A.stage < 4)
		to_chat(M, span_warning("[pick("Жарко.", "Горю.")]"))
	else
		to_chat(M, span_userdanger("[pick("Очень жарко.", "Кровь кипит.")]"))
	set_body_temp(A.affected_mob, A)

/**
 * set_body_temp Sets the body temp change
 *
 * Sets the body temp change to the mob based on the stage and resistance of the disease
 * arguments:
 * * mob/living/M The mob to apply changes to
 * * datum/disease/advance/A The disease applying the symptom
 */
/datum/symptom/fever/proc/set_body_temp(mob/living/M, datum/disease/advance/A)
	// Get the max amount of change allowed before going over heat damage limit, 5 under the heat damage limit
	var/change_limit = (BODYTEMP_HEAT_DAMAGE_LIMIT - 5) - M.get_body_temp_normal(apply_change=FALSE)
	if(unsafe) // when unsafe the fever can cause burn damage (not wounds)
		change_limit += 20
	M.add_body_temperature_change(FEVER_CHANGE, min((6 * power) * A.stage, change_limit))

/// Update the body temp change based on the new stage
/datum/symptom/fever/on_stage_change(datum/disease/advance/A)
	. = ..()
	if(.)
		set_body_temp(A.affected_mob, A)

/// remove the body temp change when removing symptom
/datum/symptom/fever/End(datum/disease/advance/A)
	var/mob/living/carbon/M = A.affected_mob
	if(M)
		M.remove_body_temperature_change(FEVER_CHANGE)

#undef FEVER_CHANGE

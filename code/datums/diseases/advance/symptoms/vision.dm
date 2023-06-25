/*
//////////////////////////////////////

Hyphema (Eye bleeding)

	Slightly noticable.
	Lowers resistance tremendously.
	Decreases stage speed tremendously.
	Decreases transmittablity.
	Critical Level.

Bonus
	Causes blindness.

//////////////////////////////////////
*/

/datum/symptom/visionloss

	name = "Гифема"
	desc = "Вирус вызывает воспаление сетчатки, что приводит к повреждению глаз и, в конечном итоге, к слепоте."
	stealth = -1
	resistance = -4
	stage_speed = -4
	transmittable = -3
	level = 5
	severity = 5
	base_message_chance = 50
	symptom_delay_min = 25
	symptom_delay_max = 80
	var/remove_eyes = FALSE
	threshold_descs = list(
		"Сопротивление 12" = "Ослабляет экстраокулярные мышцы, что в конечном итоге приводит к полному отслоению глаза.",
		"Скрытность 4" = "Симптом остается скрытым до тех пор, пока не станет активным.",
	)

/datum/symptom/visionloss/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["stealth"] >= 4)
		suppress_warning = TRUE
	if(A.properties["resistance"] >= 12) //goodbye eyes
		remove_eyes = TRUE

/datum/symptom/visionloss/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/M = A.affected_mob
	var/obj/item/organ/eyes/eyes = M.get_organ_slot(ORGAN_SLOT_EYES)
	if(eyes)
		switch(A.stage)
			if(1, 2)
				if(prob(base_message_chance) && !suppress_warning)
					to_chat(M, span_warning("Глаза чешутся."))
			if(3, 4)
				to_chat(M, span_warning("<b>ГЛАЗА ГОРЯТ!</b>"))
				M.blur_eyes(10)
				eyes.applyOrganDamage(1)
			else
				M.blur_eyes(20)
				eyes.applyOrganDamage(5)
				if(eyes.damage >= 10)
					M.become_nearsighted(EYE_DAMAGE)
				if(prob(eyes.damage - 10 + 1))
					if(!remove_eyes)
						if(!M.is_blind())
							to_chat(M, span_userdanger("Слепну!"))
							eyes.applyOrganDamage(eyes.maxHealth)
					else
						M.visible_message(span_warning("Глаза [M] выпадают!"), span_userdanger("Глаза выпадают из орбит!"))
						eyes.Remove(M)
						eyes.forceMove(get_turf(M))
				else
					to_chat(M, span_userdanger("ГЛАЗА УЖАСНО БОЛЯТ!"))

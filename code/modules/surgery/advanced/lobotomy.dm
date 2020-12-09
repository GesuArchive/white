/datum/surgery/advanced/lobotomy
	name = "Лоботомия"
	desc = "Инвазивная хирургическая процедура, которая гарантированно устраняет большинство травм мозга, но может привести к другому постоянному повреждению."
	steps = list(
	/datum/surgery_step/incise,
	/datum/surgery_step/retract_skin,
	/datum/surgery_step/saw,
	/datum/surgery_step/clamp_bleeders,
	/datum/surgery_step/lobotomize,
	/datum/surgery_step/close)

	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	possible_locs = list(BODY_ZONE_HEAD)
	requires_bodypart_type = 0

/datum/surgery/advanced/lobotomy/can_start(mob/user, mob/living/carbon/target)
	if(!..())
		return FALSE
	var/obj/item/organ/brain/B = target.getorganslot(ORGAN_SLOT_BRAIN)
	if(!B)
		return FALSE
	return TRUE

/datum/surgery_step/lobotomize
	name = "выполнить лоботомию"
	implements = list(TOOL_SCALPEL = 85, /obj/item/melee/transforming/energy/sword = 55, /obj/item/kitchen/knife = 35,
		/obj/item/shard = 25, /obj/item = 20)
	time = 100

/datum/surgery_step/lobotomize/tool_check(mob/user, obj/item/tool)
	if(implement_type == /obj/item && !tool.get_sharpness())
		return FALSE
	return TRUE

/datum/surgery_step/lobotomize/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>Начинаю проведение лоботомии на мозге [target]...</span>",
		"<span class='notice'>[user] начинает проведение лоботомии на мозге [target].</span>",
		"<span class='notice'>[user] начинает операцию на мозге [target].</span>")

/datum/surgery_step/lobotomize/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(user, target, "<span class='notice'>Успешно выполнил лоботомию [target].</span>",
			"<span class='notice'>[user] успешно выполнил лоботомию [target]!</span>",
			"<span class='notice'>[user] завершает операцию [target].</span>")
	target.cure_all_traumas(TRAUMA_RESILIENCE_LOBOTOMY)
	if(target.mind && target.mind.has_antag_datum(/datum/antagonist/brainwashed))
		target.mind.remove_antag_datum(/datum/antagonist/brainwashed)
	switch(rand(1,4))//Now let's see what hopefully-not-important part of the brain we cut off
		if(1)
			target.gain_trauma_type(BRAIN_TRAUMA_MILD, TRAUMA_RESILIENCE_MAGIC)
		if(2)
			if(HAS_TRAIT(target, TRAIT_SPECIAL_TRAUMA_BOOST) && prob(50))
				target.gain_trauma_type(BRAIN_TRAUMA_SPECIAL, TRAUMA_RESILIENCE_MAGIC)
			else
				target.gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_MAGIC)
		if(3)
			target.gain_trauma_type(BRAIN_TRAUMA_SPECIAL, TRAUMA_RESILIENCE_MAGIC)
	return ..()

/datum/surgery_step/lobotomize/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/organ/brain/B = target.getorganslot(ORGAN_SLOT_BRAIN)
	if(B)
		display_results(user, target, "<span class='warning'>Я извлек неверную часть, что привело к большим повреждениям!</span>",
			"<span class='notice'>[user] успешно выполнил лоботомию [target]!</span>",
			"<span class='notice'>[user] завершает операцию [target]'s brain.</span>")
		B.applyOrganDamage(80)
		switch(rand(1,3))
			if(1)
				target.gain_trauma_type(BRAIN_TRAUMA_MILD, TRAUMA_RESILIENCE_MAGIC)
			if(2)
				if(HAS_TRAIT(target, TRAIT_SPECIAL_TRAUMA_BOOST) && prob(50))
					target.gain_trauma_type(BRAIN_TRAUMA_SPECIAL, TRAUMA_RESILIENCE_MAGIC)
				else
					target.gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_MAGIC)
			if(3)
				target.gain_trauma_type(BRAIN_TRAUMA_SPECIAL, TRAUMA_RESILIENCE_MAGIC)
	else
		user.visible_message("<span class='warning'>[user] внезапно замечает что мозг [user.ru_who()] над которым работал [user.p_were()] исчез.</span>", "<span class='warning'>Вы внезапно обнаружили что мозг, над которым вы работали, исчез.</span>")
	return FALSE

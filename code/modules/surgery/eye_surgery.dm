/datum/surgery/eye_surgery
	name = "Глазная хирургия"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/retract_skin, /datum/surgery_step/clamp_bleeders, /datum/surgery_step/fix_eyes, /datum/surgery_step/close)
	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	possible_locs = list(BODY_ZONE_PRECISE_EYES)
	requires_bodypart_type = 0

//fix eyes
/datum/surgery_step/fix_eyes
	name = "исправвление глаз"
	implements = list(TOOL_HEMOSTAT = 100, TOOL_SCREWDRIVER = 45, /obj/item/pen = 25)
	time = 64

/datum/surgery/eye_surgery/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/eyes/E = target.getorganslot(ORGAN_SLOT_EYES)
	if(!E)
		to_chat(user, "<span class='warning'>Довольно сложно оперировать чьи-то глаза, если у н[target.ru_who()] их нет.</span>")
		return FALSE
	return TRUE

/datum/surgery_step/fix_eyes/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>Начинаю исправлять глаза [sklonenie(target, RODITELNI, target.gender)]...</span>",
		"<span class='notice'>[user] начинает исправлять [target.ru_who()] глаза.</span>",
		"<span class='notice'>[user] начинает операцию [target.ru_who()] на глазах.</span>")

/datum/surgery_step/fix_eyes/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/obj/item/organ/eyes/E = target.getorganslot(ORGAN_SLOT_EYES)
	user.visible_message("<span class='notice'>[user] успешно исправил [target.ru_who()] глаза!</span>", "<span class='notice'>Я успешно исправил глаз [sklonenie(target, RODITELNI, target.gender)].</span>")
	display_results(user, target, "<span class='notice'>Я успешно исправил глаза [target].</span>",
		"<span class='notice'>[user] успешно исправил [target.ru_who()] глаза!</span>",
		"<span class='notice'>[user] завершил операцию на [target.ru_who()] глазах.</span>")
	target.cure_blind(list(EYE_DAMAGE))
	target.set_blindness(0)
	target.cure_nearsighted(list(EYE_DAMAGE))
	target.blur_eyes(35)	//this will fix itself slowly.
	E.setOrganDamage(0)
	return ..()

/datum/surgery_step/fix_eyes/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(target.getorgan(/obj/item/organ/brain))
		display_results(user, target, "<span class='warning'>Я случайно уколол [sklonenie(target, RODITELNI, target.gender)] прямо в мозг!</span>",
			"<span class='warning'>[user] случайно уколол [target.ru_who()] прямо в мозг!</span>",
			"<span class='warning'>[user] случайно уколол [target.ru_who()] прямо в мозг!</span>")
		target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 70)
	else
		display_results(user, target, "<span class='warning'>Я случайно уколол [sklonenie(target, RODITELNI, target.gender)] прямо в мозг! Ну, точнее уколол бы, если бы у [target.ru_who()] был мозг.</span>",
			"<span class='warning'>[user] случайно уколол [target.ru_who()] прямо в мозг! Ну, точнее уколол бы, если бы у [target.ru_who()] был мозг.</span>",
			"<span class='warning'>[user] случайно уколол [target.ru_who()] прямо в мозг!</span>")
	return FALSE

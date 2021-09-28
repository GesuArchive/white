/datum/surgery/organ_manipulation_adv
	name = "Вскрытие"
	target_mobtypes = list(/mob/living/carbon)
	possible_locs = list(BODY_ZONE_CHEST, BODY_ZONE_HEAD, BODY_ZONE_PRECISE_GROIN, BODY_ZONE_PRECISE_EYES, BODY_ZONE_PRECISE_MOUTH)
	requires_real_bodypart = 1
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/manipulate_organs_adv,
		/datum/surgery_step/close
	)

/datum/surgery/organ_manipulation_adv/can_start(mob/user, mob/living/patient)
	if(locate(/atom/movable/organ_holder) in patient.contents)
		return TRUE

//////////////////////////////////////////////////////////////////////////////////

/datum/surgery_step/manipulate_organs_adv
	time = 0
	name = "вскрытие"
	repeatable = TRUE
	accept_hand = TRUE

/datum/surgery_step/manipulate_organs_adv/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/atom/movable/organ_holder/OH = locate() in target.contents
	if(!OH)
		to_chat(user, span_warning("У [target] отсутствует органовый костыль!!"))
		return -1

/datum/surgery_step/manipulate_organs_adv/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	var/atom/movable/organ_holder/OH = locate() in target.contents
	var/datum/component/storage/STR = OH.GetComponent(/datum/component/storage/concrete/multicompartment/organ_holder)
	STR.show_to(user, target_zone)
	return TRUE


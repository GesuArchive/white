/datum/surgery/advanced/wing_reconstruction
	name = "Восстановление Крыльев"
	desc = "Экспериментальная хирургическая процедура, которая восстанавливает поврежденные крылья мотыльков. Требует Синтплоть."
	steps = list(/datum/surgery_step/incise,
				/datum/surgery_step/retract_skin,
				/datum/surgery_step/clamp_bleeders,
				/datum/surgery_step/wing_reconstruction)
	possible_locs = list(BODY_ZONE_CHEST)
	target_mobtypes = list(/mob/living/carbon/human)

/datum/surgery/advanced/wing_reconstruction/can_start(mob/user, mob/living/carbon/target)
	if(!istype(target))
		return FALSE
	return ..() && target?.dna?.features["moth_wings"] == "Burnt Off" && ismoth(target)

/datum/surgery_step/wing_reconstruction
	name = "начать восстановление крыльев"
	implements = list(TOOL_HEMOSTAT = 85, TOOL_SCREWDRIVER = 35, /obj/item/pen = 15)
	time = 200
	chems_needed = list(/datum/reagent/medicine/c2/synthflesh)
	require_all_chems = FALSE

/datum/surgery_step/wing_reconstruction/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Начинаю восстанавливать обугленные мембраны крыльев [target]...") ,
		span_notice("[user] начал восстанавливать обугленные мембраны крыльев [target].") ,
		span_notice("[user] начал проведение операции на обугленных мембранах крыльев [target]."))

/datum/surgery_step/wing_reconstruction/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		display_results(user, target, span_notice("Успешно восстановил крылья [target].") ,
			span_notice("[user] успешно восстановил крылья [target]!") ,
			span_notice("[user] завершил операцию на крыльях [target]."))
		if(H.dna.features["original_moth_wings"] != null)
			H.dna.features["moth_wings"] = H.dna.features["original_moth_wings"]
		else
			H.dna.features["moth_wings"] = "Plain"
		H.update_mutant_bodyparts()
	return ..()

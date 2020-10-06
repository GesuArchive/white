/datum/surgery/advanced/bioware/cortex_imprint
	name = "Распрямление коры головного мозга"
	desc = "Хирургическая операция, которая модифицирует кору большого мозга в повторяющийся нейронный паттерн, позволяющая могзу справляться с трудностями, вызванными небольшими повреждениями мозга."
	steps = list(/datum/surgery_step/incise,
				/datum/surgery_step/retract_skin,
				/datum/surgery_step/clamp_bleeders,
				/datum/surgery_step/incise,
				/datum/surgery_step/incise,
				/datum/surgery_step/imprint_cortex,
				/datum/surgery_step/close)
	possible_locs = list(BODY_ZONE_HEAD)
	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	bioware_target = BIOWARE_CORTEX

/datum/surgery/advanced/bioware/cortex_imprint/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/brain/B = target.getorganslot(ORGAN_SLOT_BRAIN)
	if(!B)
		return FALSE
	return ..()

/datum/surgery_step/imprint_cortex
	name = "imprint cortex"
	accept_hand = TRUE
	time = 125

/datum/surgery_step/imprint_cortex/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>Я начинаю вырезать на коре большого мозга [target] само-импринтирующий паттерн.</span>",
		"<span class='notice'>[user] начинает вырезать на коре большого мозга [target]само-импринтирующий паттерн.</span>",
		"<span class='notice'>[user] начинает проводить операцию на мозге [target].</span>")

/datum/surgery_step/imprint_cortex/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(user, target, "<span class='notice'>Я изменил форму коры большого мозга [target] на само-импринтирующий паттерн!</span>",
		"<span class='notice'>[user] изменил форму коры большого мозга [target] на само-импринтирующий паттерн!</span>",
		"<span class='notice'>[user] завершил операцию на мозге [target].</span>")
	new /datum/bioware/cortex_imprint(target)
	return ..()

/datum/surgery_step/imprint_cortex/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(target.getorganslot(ORGAN_SLOT_BRAIN))
		display_results(user, target, "<span class='warning'>Я облажался, повредив мозг!</span>",
			"<span class='warning'>[user] облажался, повредив мозг!</span>",
			"<span class='notice'>[user] завершил операцию на мозге [target]</span>")
		target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 60)
		target.gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_LOBOTOMY)
	else
		user.visible_message("<span class='warning'>[user] внезапно замечает что мозг [user.p_they()] над которым работал [user.p_were()] исчез.</span>", "<span class='warning'>Вы внезапно обнаружили что мозг, над которым вы работали, исчез.</span>")
	return FALSE

/datum/bioware/cortex_imprint
	name = "Распрямленная кора"
	desc = "Кора большого мозга была переделана в повторяющийся нейронный паттерн, позволяющая могзу справляться с трудностями, вызванными небольшими повреждениями мозга.."
	mod_type = BIOWARE_CORTEX
	can_process = TRUE

/datum/bioware/cortex_imprint/process()
	owner.cure_trauma_type(resilience = TRAUMA_RESILIENCE_BASIC)

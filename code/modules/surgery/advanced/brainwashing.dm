/obj/item/disk/surgery/brainwashing
	name = "Хирургический диск для промывания мозгов"
	desc = "На диске содержатся инструкции по тому, как запечатлеть приказ в мозгу, делая его основной директивой пациента."
	surgeries = list(/datum/surgery/advanced/brainwashing)

/datum/surgery/advanced/brainwashing
	name = "Промывание мозгов"
	desc = "Хирургическая процедура, которая запечатляет приказ в мозге пациента, делая его основной директивой. Эту директиву можно отменить используя имплант защиты разума."
	steps = list(
	/datum/surgery_step/incise,
	/datum/surgery_step/retract_skin,
	/datum/surgery_step/saw,
	/datum/surgery_step/clamp_bleeders,
	/datum/surgery_step/brainwash,
	/datum/surgery_step/close)

	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_HEAD)

/datum/surgery/advanced/brainwashing/can_start(mob/user, mob/living/carbon/target)
	if(!..())
		return FALSE
	var/obj/item/organ/brain/B = target.getorganslot(ORGAN_SLOT_BRAIN)
	if(!B)
		return FALSE
	return TRUE

/datum/surgery_step/brainwash
	name = "промывание мозга"
	implements = list(TOOL_HEMOSTAT = 85, TOOL_WIRECUTTER = 50, /obj/item/stack/package_wrap = 35, /obj/item/stack/cable_coil = 15)
	time = 200
	var/objective

/datum/surgery_step/brainwash/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	objective = stripped_input(user, "Выберите директиву, которую хотите запечатлеть в мозге вашей жертвы", "Brainwashing", null, MAX_MESSAGE_LEN)
	if(!objective)
		return -1
	display_results(user, target, "<span class='notice'>Начинаю промывать мозги [target]...</span>",
		"<span class='notice'>[user] начинает исправлять мозг [target].</span>",
		"<span class='notice'>[user] начинает проводить операцию на мозге [target].</span>")

/datum/surgery_step/brainwash/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(!target.mind)
		to_chat(user, "<span class='warning'>[target] не реагирует на промывание мозга, кажется, что [target.ru_who()] лишился ума...</span>")
		return FALSE
	if(HAS_TRAIT(target, TRAIT_MINDSHIELD))
		to_chat(user, "<span class='warning'>Слышу слабое жужание устройства в мозгу [target] и новая директива стирается.</span>")
		return FALSE
	display_results(user, target, "<span class='notice'>Я успешно промыл мозг [target].</span>",
		"<span class='notice'>[user] успешно исправил мозг [target]!</span>",
		"<span class='notice'>[user] завершил операцию на мозге [target].</span>")
	to_chat(target, "<span class='userdanger'>Что-то заполняет ваш разум, принуждая вас... подчиниться!</span>")
	brainwash(target, objective)
	message_admins("[ADMIN_LOOKUPFLW(user)] surgically brainwashed [ADMIN_LOOKUPFLW(target)] with the objective '[objective]'.")
	log_game("[key_name(user)] surgically brainwashed [key_name(target)] with the objective '[objective]'.")
	return ..()

/datum/surgery_step/brainwash/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(target.getorganslot(ORGAN_SLOT_BRAIN))
		display_results(user, target, "<span class='warning'>Я облажалися, повредив мозговую ткань!</span>",
			"<span class='warning'>[user] облажался, нанеся урон мозгу!</span>",
			"<span class='notice'>[user] завершил операцию на мозге [target].</span>")
		target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 40)
	else
		user.visible_message("<span class='warning'>[user] внезапно замечает что мозг [user.ru_who()] над которым работал [user.p_were()] исчез.</span>", "<span class='warning'>Вы внезапно обнаружили что мозг, над которым вы работали, исчез.</span>")
	return FALSE

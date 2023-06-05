
/datum/component/ai_supported_combat
	dupe_mode = COMPONENT_DUPE_UNIQUE

	var/mob/living/owner
	var/atom/current_target

	var/active = FALSE
	var/precision = 75
	var/killerbot = FALSE

	var/datum/action/innate/toggle_aimbot/toggle_action
	var/image/cursor

/datum/component/ai_supported_combat/Initialize(_precision, _killerbot)
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	src.precision = _precision
	src.killerbot = _killerbot
	src.owner = parent

	toggle_action = new (src)
	toggle_action.Grant(owner)

/datum/component/ai_supported_combat/proc/toggle_combat_mode()
	active = !active
	to_chat(owner, span_info("[active ? "Включена" : "Отключена"] система ассистирования при наведении."))

	if(active)
		RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(on_clickon))
		START_PROCESSING(SSfastprocess, src)
	else
		UnregisterSignal(owner, COMSIG_MOB_CLICKON)
		STOP_PROCESSING(SSfastprocess, src)
		set_cursor(FALSE)
		current_target = null

/datum/component/ai_supported_combat/proc/set_cursor(enable)
	if(enable)
		cursor = image('white/valtos/icons/dz-031.dmi', owner, "node", ABOVE_MOB_LAYER)
		if(owner.client)
			owner.client.images += cursor
	else
		if(owner.client)
			owner.client.images -= cursor
		QDEL_NULL(cursor)

/datum/component/ai_supported_combat/process(delta_time)
	if(current_target && cursor)
		var/turf/T = get_turf(cursor)
		if(current_target in T)
			if(owner.next_move > world.time)
				return
			owner.changeNext_move(CLICK_CD_RAPID)
			if(prob(precision))
				if(isliving(current_target) && !killerbot)
					var/mob/living/L = current_target
					if(L.stat != CONSCIOUS)
						to_chat(owner, span_info("Цель поражена."))
						current_target = null
						set_cursor(FALSE)
						return
				current_target.attack_hand(owner)
		cursor.loc = get_turf(current_target)

/datum/component/ai_supported_combat/proc/on_clickon(mob/living/source, atom/A, params)
	SIGNAL_HANDLER

	if(current_target)
		current_target = null
		to_chat(owner, span_info("Отмена выбора цели."))
		set_cursor(FALSE)
		return TRUE

	if(isatom(A))
		current_target = A
		to_chat(owner, span_info("В качестве цели выбрано [current_target]."))
		set_cursor(TRUE)
	return TRUE

/datum/component/ai_supported_combat/Destroy(force, silent)
	QDEL_NULL(toggle_action)
	QDEL_NULL(cursor)
	return ..()

/atom/movable/screen/aimbot_cursor
	name = "КУРСОР"
	desc = "Нахуй ты это читаешь?"
	icon = 'white/valtos/icons/dz-031.dmi'
	icon_state = "node"

/datum/action/innate/toggle_aimbot
	name = "Переключить ИИ"
	desc = "Включает или выключает ассистирование при наведении."
	button_icon_state = "funk"
	icon_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	background_icon_state = "bg_tech_blue"

/datum/action/innate/toggle_aimbot/IsAvailable()
	return ..() && (owner.stat == CONSCIOUS)

/datum/action/innate/toggle_aimbot/Activate()

	if(owner.stat != CONSCIOUS)
		return

	var/datum/component/ai_supported_combat/aimbot = target
	aimbot.toggle_combat_mode()

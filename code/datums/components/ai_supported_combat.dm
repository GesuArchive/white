
/datum/component/ai_supported_combat
	dupe_mode = COMPONENT_DUPE_UNIQUE

	var/mob/living/owner
	var/atom/current_target

	var/active = FALSE

	var/datum/action/innate/toggle_aimbot/toggle_action
	var/image/cursor

/datum/component/ai_supported_combat/Initialize()
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE

	src.owner = parent

	toggle_action = new (src)
	toggle_action.Grant(owner)

/datum/component/ai_supported_combat/proc/toggle_combat_mode()
	active = !active
	to_chat(owner, span_info("[active ? "Включена" : "Отключена"] система ассистирования при наведении. СКМ для наведения."))

	if(active)
		RegisterSignal(owner, COMSIG_MOB_MIDDLECLICKON, PROC_REF(on_middle_clickon))
		START_PROCESSING(SSfastprocess, src)
	else
		UnregisterSignal(owner, COMSIG_MOB_CLICKON)
		UnregisterSignal(owner, COMSIG_MOB_MIDDLECLICKON)
		STOP_PROCESSING(SSfastprocess, src)
		set_cursor(FALSE)
		current_target = null

/datum/component/ai_supported_combat/proc/set_cursor(enable)
	if(enable)
		cursor = image('icons/effects/effects.dmi', owner, "aim_cursor", RIPPLE_LAYER)
		if(owner.client)
			owner.client.images += cursor
	else
		if(owner.client)
			owner.client.images -= cursor
		QDEL_NULL(cursor)

/datum/component/ai_supported_combat/process(delta_time)
	if(current_target && cursor)
		cursor.loc = get_turf(current_target)

/datum/component/ai_supported_combat/proc/on_clickon(mob/living/source, atom/A, params)
	SIGNAL_HANDLER

	var/list/modifiers = params2list(params)
	if(modifiers["alt"] || modifiers["shift"] || modifiers["ctrl"] || modifiers["middle"])
		return

	if(istype(A, /atom/movable/screen))
		return
	else if(isitem(A))
		var/obj/item/item_atom = A
		if(item_atom.item_flags & IN_INVENTORY)
			return

	if(current_target && cursor && owner?.client)
		var/turf/T = get_turf(cursor)
		if(current_target in T)
			spawn(-1)
				owner.process_ClickOn(current_target, params)
		else
			spawn(-1)
				owner.process_ClickOn(T, params)

	return COMSIG_MOB_CANCEL_CLICKON

/datum/component/ai_supported_combat/proc/on_middle_clickon(mob/living/source, atom/A, params)
	SIGNAL_HANDLER

	if(current_target)
		current_target = null
		to_chat(owner, span_info("Отмена выбора цели."))
		set_cursor(FALSE)
		UnregisterSignal(owner, COMSIG_MOB_CLICKON)
		return COMSIG_MOB_CANCEL_CLICKON

	if(isatom(A))
		current_target = A
		to_chat(owner, span_info("В качестве цели выбрано [current_target]."))
		set_cursor(TRUE)
		RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(on_clickon))
	return COMSIG_MOB_CANCEL_CLICKON

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
	button_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	background_icon_state = "bg_tech_blue"

/datum/action/innate/toggle_aimbot/IsAvailable(feedback = FALSE)
	return ..() && (owner.stat == CONSCIOUS)

/datum/action/innate/toggle_aimbot/Activate()

	if(owner.stat != CONSCIOUS)
		return

	var/datum/component/ai_supported_combat/aimbot = target
	aimbot.toggle_combat_mode()

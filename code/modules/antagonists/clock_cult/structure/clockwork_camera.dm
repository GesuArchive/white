/mob/camera/ai_eye/remote/ratvar
	visible_icon = TRUE
	icon = 'icons/mob/cameramob.dmi'
	icon_state = "generic_camera"
	use_static = USE_STATIC_NONE

/datum/action/innate/clockcult/warp
	name = "Переместиться"
	desc = "Прям туда, да."
	button_icon_state = "warp_down"
	var/warping = FALSE

/datum/action/innate/clockcult/warp/IsAvailable()
	if(!is_servant_of_ratvar(owner) || owner.incapacitated())
		return FALSE
	return ..()

/datum/action/innate/clockcult/warp/Activate()
	if(!isliving(owner))
		return
	if(GLOB.gateway_opening)
		to_chat(owner, span_brass("ВРАТА ОТКРЫВАЮТСЯ, НЕКОГДА!"))
		return
	if(warping)
		button_icon_state = "warp_down"
		owner.update_action_buttons_icon()
		warping = FALSE
		return
	var/mob/living/M = owner
	var/mob/camera/ai_eye/remote/ratvar/cam = M.remote_control
	var/target_loc = get_turf(cam)
	if(isclosedturf(target_loc))
		to_chat(owner, span_brass("Не могу вот прям сюда телепортироваться."))
		return
	do_sparks(5, TRUE, get_turf(cam))
	warping = TRUE
	button_icon_state = "warp_cancel"
	owner.update_action_buttons_icon()
	if(do_after(M, 50, target=target_loc, extra_checks=CALLBACK(src, .proc/special_check)))
		owner.update_action_buttons_icon()
		try_warp_servant(M, target_loc, 50, FALSE)
		var/obj/machinery/computer/camera_advanced/console = cam.origin
		console.remove_eye_control(M)
	button_icon_state = "warp_down"
	warping = FALSE

/datum/action/innate/clockcult/warp/proc/special_check()
	return warping

/obj/machinery/computer/camera_advanced/ratvar
	name = "пульт наблюдения Ратвара"
	desc = "Используется слугами Ратвара для проведения операций на собственности Нанотрейзена."
	icon_screen = "ratvar1"
	icon_keyboard = "ratvar_key1"
	icon_state = "ratvarcomputer1"
	lock_override = CAMERA_LOCK_STATION
	var/datum/action/innate/clockcult/warp/warp_action

/obj/machinery/computer/camera_advanced/ratvar/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
	warp_action = new
	icon_state = "ratvarcomputer[rand(1,4)]"

/obj/machinery/computer/camera_advanced/ratvar/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/machinery/computer/camera_advanced/ratvar/process()
	if(prob(3))
		new /obj/effect/temp_visual/steam_release(get_turf(src))
	if(prob(7))
		playsound(get_turf(src), 'sound/machines/beep.ogg', 20, TRUE)

/obj/machinery/computer/camera_advanced/ratvar/can_use(mob/living/user)
	. = ..()
	if(!is_servant_of_ratvar(user) || iscogscarab(user))
		return FALSE

/obj/machinery/computer/camera_advanced/ratvar/GrantActions(mob/living/user)
	. = ..()
	if(warp_action)
		warp_action.target = src
		warp_action.Grant(user)
		actions += warp_action

/obj/machinery/computer/camera_advanced/ratvar/CreateEye()
	eyeobj = new /mob/camera/ai_eye/remote/ratvar(get_turf(SSmapping.get_station_center()))
	eyeobj.origin = src
	eyeobj.visible_icon = TRUE
	eyeobj.icon = 'icons/mob/cameramob.dmi'
	eyeobj.icon_state = "ratvar_camera"

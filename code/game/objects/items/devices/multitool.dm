#define PROXIMITY_NONE ""
#define PROXIMITY_ON_SCREEN "_red"
#define PROXIMITY_NEAR "_yellow"

/**
 * Multitool -- A multitool is used for hacking electronic devices.
 *
 */

/obj/item/multitool
	name = "мультитул"
	desc = "Используется для прозвона проводов и подачи импульсов на них. Не рекомендуется врачами."
	icon = 'icons/obj/device.dmi'
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	icon_state = "multitool"
	inhand_icon_state = "multitool"
	force = 5
	w_class = WEIGHT_CLASS_SMALL
	tool_behaviour = TOOL_MULTITOOL
	throwforce = 0
	throw_range = 7
	throw_speed = 3
	drop_sound = 'sound/items/handling/multitool_drop.ogg'
	pickup_sound =  'sound/items/handling/multitool_pickup.ogg'
	custom_materials = list(/datum/material/iron=50, /datum/material/glass=20)
	custom_premium_price = PAYCHECK_HARD * 3
	toolspeed = 1
	usesound = 'sound/weapons/empty.ogg'
	var/obj/machinery/buffer // simple machine buffer for device linkage
	var/mode = 0

/obj/item/multitool/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/multitool/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>Буффер [buffer ? "содержит [buffer]." : "пуст."]</span>"

/obj/item/multitool/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] puts the [src] to [user.ru_ego()] chest. It looks like [user.p_theyre()] trying to pulse [user.ru_ego()] heart off!"))
	return OXYLOSS//theres a reason it wasn't recommended by doctors


/obj/item/multitool/update_overlays()
	. = ..()
	. += mutable_appearance(icon, "[icon_state]_[selected_io ? "red" : "green"]", layer, src)
	. += emissive_appearance(icon, "[icon_state]_[selected_io ? "red" : "green"]", src, alpha = src.alpha)

// Syndicate device disguised as a multitool; it will turn red when an AI camera is nearby.

/obj/item/multitool/ai_detect
	var/track_cooldown = 0
	var/track_delay = 10 //How often it checks for proximity
	var/detect_state = PROXIMITY_NONE
	var/rangealert = 8	//Glows red when inside
	var/rangewarning = 20 //Glows yellow when inside
	var/hud_type = DATA_HUD_AI_DETECT
	var/hud_on = FALSE
	var/mob/camera/ai_eye/remote/ai_detector/eye
	var/datum/action/item_action/toggle_multitool/toggle_action

/obj/item/multitool/ai_detect/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)
	eye = new /mob/camera/ai_eye/remote/ai_detector()
	toggle_action = new /datum/action/item_action/toggle_multitool(src)

/obj/item/multitool/ai_detect/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(hud_on && ismob(loc))
		remove_hud(loc)
	QDEL_NULL(toggle_action)
	QDEL_NULL(eye)
	return ..()

/obj/item/multitool/ai_detect/ui_action_click()
	return

/obj/item/multitool/ai_detect/equipped(mob/living/carbon/human/user, slot)
	..()
	if(hud_on)
		show_hud(user)

/obj/item/multitool/ai_detect/dropped(mob/living/carbon/human/user)
	..()
	if(hud_on)
		remove_hud(user)

/obj/item/multitool/ai_detect/process()
	if(track_cooldown > world.time)
		return
	detect_state = PROXIMITY_NONE
	if(eye.eye_user)
		eye.setLoc(get_turf(src))
	multitool_detect()
	update_icon()
	track_cooldown = world.time + track_delay

/obj/item/multitool/ai_detect/proc/toggle_hud(mob/user)
	hud_on = !hud_on
	if(user)
		to_chat(user, span_notice("You toggle the ai detection HUD on [src] [hud_on ? "on" : "off"]."))
	if(hud_on)
		show_hud(user)
	else
		remove_hud(user)

/obj/item/multitool/ai_detect/proc/show_hud(mob/user)
	if(user && hud_type)
		var/atom/movable/screen/plane_master/camera_static/PM = user.hud_used.get_plane_master(CAMERA_STATIC_PLANE)
		PM.alpha = 64
		var/datum/atom_hud/H = GLOB.huds[hud_type]
		if(!H.hud_users[user])
			H.show_to(user)
		eye.eye_user = user
		eye.setLoc(get_turf(src))

/obj/item/multitool/ai_detect/proc/remove_hud(mob/user)
	if(user && hud_type)
		var/atom/movable/screen/plane_master/camera_static/PM = user.hud_used.get_plane_master(CAMERA_STATIC_PLANE)
		PM.alpha = 255
		var/datum/atom_hud/H = GLOB.huds[hud_type]
		H.hide_from(user)
		if(eye)
			eye.setLoc(null)
			eye.eye_user = null

/obj/item/multitool/ai_detect/proc/multitool_detect()
	var/turf/our_turf = get_turf(src)
	for(var/mob/living/silicon/ai/AI in GLOB.ai_list)
		if(AI.cameraFollow == src)
			detect_state = PROXIMITY_ON_SCREEN
			break

	if(detect_state)
		return
	var/datum/camerachunk/chunk = GLOB.cameranet.chunkGenerated(our_turf.x, our_turf.y, our_turf.z)
	if(chunk?.seenby.len)
		for(var/mob/camera/ai_eye/A in chunk.seenby)
			if(!A.ai_detector_visible)
				continue
			var/turf/detect_turf = get_turf(A)
			if(get_dist(our_turf, detect_turf) < rangealert)
				detect_state = PROXIMITY_ON_SCREEN
				break
			if(get_dist(our_turf, detect_turf) < rangewarning)
				detect_state = PROXIMITY_NEAR
				break

/mob/camera/ai_eye/remote/ai_detector
	name = "AI detector eye"
	ai_detector_visible = FALSE
	visible_icon = FALSE

/datum/action/item_action/toggle_multitool
	name = "Toggle AI detector HUD"
	check_flags = NONE

/datum/action/item_action/toggle_multitool/Trigger(trigger_flags)
	if(!..())
		return FALSE
	if(target)
		var/obj/item/multitool/ai_detect/M = target
		M.toggle_hud(owner)
	return TRUE

/obj/item/multitool/abductor
	name = "инопланетный мультитул"
	desc = "Омни-технологический интерфейс."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "multitool"
	toolspeed = 0.1

/obj/item/multitool/cyborg
	name = "электромультитул"
	desc = "Оптимизированная версия обычного мультитула. Упрощает процессы, обрабатываемые его внутренним микрочипом."
	icon = 'white/Feline/icons/cyber_arm_tools.dmi'
	icon_state = "multitool"
	toolspeed = 0.5

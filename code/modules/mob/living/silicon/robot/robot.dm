/mob/living/silicon/robot
	name = JOB_CYBORG
	real_name = JOB_CYBORG
	icon = 'icons/mob/robots.dmi'
	icon_state = "robot"
	maxHealth = 100
	health = 100
	bubble_icon = "robot"
	designation = "Default" //used for displaying the prefix & getting the current module of cyborg
	has_limbs = 1
	hud_type = /datum/hud/robot

	radio = /obj/item/radio/borg

	blocks_emissive = EMISSIVE_BLOCK_UNIQUE
	light_system = MOVABLE_LIGHT_DIRECTIONAL
	light_on = FALSE

	var/custom_name = ""
	var/braintype = JOB_CYBORG
	var/obj/item/robot_suit/robot_suit = null //Used for deconstruction to remember what the borg was constructed out of..
	var/obj/item/mmi/mmi = null

	var/shell = FALSE
	var/deployed = FALSE
	var/mob/living/silicon/ai/mainframe = null
	var/datum/action/innate/undeployment/undeployment_action = new

	var/obj/item/clockwork/clockwork_slab/internal_clock_slab = null
	var/ratvar = FALSE

	/// the last health before updating - to check net change in health
	var/previous_health
//Hud stuff

	var/atom/movable/screen/inv1 = null
	var/atom/movable/screen/inv2 = null
	var/atom/movable/screen/inv3 = null
	var/atom/movable/screen/hands = null

	var/shown_robot_modules = 0	//Used to determine whether they have the module menu shown or not
	var/atom/movable/screen/robot_modules_background

//3 Modules can be activated at any one time.
	var/obj/item/robot_module/module = null
	var/obj/item/module_active = null
	held_items = list(null, null, null) //we use held_items for the module holding, because that makes sense to do!

	/// For checking which modules are disabled or not.
	var/disabled_modules

	var/mutable_appearance/eye_lights

	var/mob/living/silicon/ai/connected_ai = null
	var/obj/item/stock_parts/cell/cell = /obj/item/stock_parts/cell/high ///If this is a path, this gets created as an object in Initialize.

	var/opened = FALSE
	var/emagged = FALSE
	var/emag_cooldown = 0
	var/wiresexposed = FALSE

	/// Random serial number generated for each cyborg upon its initialization
	var/ident = 0
	var/locked = TRUE
	var/list/req_access = list(ACCESS_ROBOTICS)

	var/alarms = list("Motion"=list(), "Fire"=list(), "Atmosphere"=list(), "Power"=list(), "Camera"=list(), "Burglar"=list())

	var/ionpulse = FALSE // Jetpack-like effect.
	var/ionpulse_on = FALSE // Jetpack-like effect.
	var/datum/effect_system/trail_follow/ion/ion_trail // Ionpulse effect.

	var/low_power_mode = 0 //whether the robot has no charge left.
	var/datum/effect_system/spark_spread/spark_system // So they can initialize sparks whenever/N

	var/lawupdate = 1 //Cyborgs will sync their laws with their AI by default
	var/scrambledcodes = FALSE // Used to determine if a borg shows up on the robotics console.  Setting to TRUE hides them.
	var/lockcharge = FALSE //Boolean of whether the borg is locked down or not

	var/toner = 0
	var/tonermax = 40

	///If the lamp isn't broken.
	var/lamp_functional = TRUE
	///If the lamp is turned on
	var/lamp_enabled = FALSE
	///Set lamp color
	var/lamp_color = COLOR_WHITE
	///Set to true if a doomsday event is locking our lamp to on and RED
	var/lamp_doom = FALSE
	///Lamp brightness. Starts at 3, but can be 1 - 5.
	var/lamp_intensity = 3
	///Lamp button reference
	var/atom/movable/screen/robot/lamp/lampButton

	var/sight_mode = 0
	hud_possible = list(ANTAG_HUD, DIAG_STAT_HUD, DIAG_HUD, DIAG_BATT_HUD, DIAG_TRACK_HUD)

	///The reference to the built-in tablet that borgs carry.
	var/atom/movable/screen/robot/modpc/interfaceButton

	var/list/upgrades = list()

	var/hasExpanded = FALSE
	var/obj/item/hat
	var/hat_offset = -3

	can_buckle = TRUE
	buckle_lying = 0
	/// What types of mobs are allowed to ride/buckle to this mob
	var/static/list/can_ride_typecache = typecacheof(/mob/living/carbon/human)

	/// Station alert datum for showing alerts UI
	var/datum/station_alert/alert_control

/mob/living/silicon/robot/get_cell()
	return cell

/mob/living/silicon/robot/Initialize(mapload)
	spark_system = new /datum/effect_system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

	ADD_TRAIT(src, TRAIT_CAN_STRIP, INNATE_TRAIT)

	AddComponent(/datum/component/tippable, \
		tip_time = 3 SECONDS, \
		untip_time = 2 SECONDS, \
		self_right_time = 60 SECONDS, \
		post_tipped_callback = CALLBACK(src, PROC_REF(after_tip_over)))

	wires = new /datum/wires/robot(src)
	AddElement(/datum/element/empprotection, EMP_PROTECT_WIRES)
	AddElement(/datum/element/ridable, /datum/component/riding/creature/cyborg)
	RegisterSignal(src, COMSIG_PROCESS_BORGCHARGER_OCCUPANT, PROC_REF(charge))
	RegisterSignal(src, COMSIG_LIGHT_EATER_ACT, PROC_REF(on_light_eater))

	robot_modules_background = new()
	robot_modules_background.icon_state = "block"
	SET_PLANE_EXPLICIT(robot_modules_background, HUD_PLANE, src)

	inv1 = new /atom/movable/screen/robot/module1()
	inv2 = new /atom/movable/screen/robot/module2()
	inv3 = new /atom/movable/screen/robot/module3()

	ident = rand(1, 999)

	previous_health = health

	if(ispath(cell))
		cell = new cell(src)

	create_modularInterface()

	module = new /obj/item/robot_module(src)
	module.rebuild_modules()

	if(lawupdate)
		make_laws()
		if(!TryConnectToAI())
			lawupdate = FALSE

	if(!scrambledcodes && !builtInCamera)
		builtInCamera = new (src)
		builtInCamera.c_tag = real_name
		builtInCamera.network = list("ss13")
		builtInCamera.internal_light = FALSE
		if(wires.is_cut(WIRE_CAMERA))
			builtInCamera.status = 0
	update_icons()
	. = ..()

	//If this body is meant to be a borg controlled by the AI player
	if(shell)
		make_shell()

	//MMI stuff. Held togheter by magic. ~Miauw
	else if(!mmi || !mmi.brainmob)
		mmi = new (src)
		mmi.brain = new /obj/item/organ/brain(mmi)
		mmi.brain.organ_flags |= ORGAN_FROZEN
		mmi.brain.name = "[real_name] brain"
		mmi.name = "[initial(mmi.name)]: [real_name]"
		mmi.set_brainmob(new /mob/living/brain(mmi))
		mmi.brainmob.name = src.real_name
		mmi.brainmob.real_name = src.real_name
		mmi.brainmob.container = mmi
		mmi.update_icon()

	INVOKE_ASYNC(src, PROC_REF(updatename))

	playsound(loc, 'sound/effects/servitor.ogg', 70, TRUE)
	aicamera = new/obj/item/camera/siliconcam/robot_camera(src)
	toner = tonermax
	diag_hud_set_borgcell()

	logevent("System brought online.")
	alert_control = new(src, list(ALARM_ATMOS, ALARM_FIRE, ALARM_POWER, ALARM_CAMERA, ALARM_BURGLAR, ALARM_MOTION), list(z))
	RegisterSignal(alert_control.listener, COMSIG_ALARM_TRIGGERED, PROC_REF(alarm_triggered))
	RegisterSignal(alert_control.listener, COMSIG_ALARM_CLEARED, PROC_REF(alarm_cleared))
	alert_control.listener.RegisterSignal(src, COMSIG_LIVING_DEATH, TYPE_PROC_REF(/datum/alarm_listener, prevent_alarm_changes))
	alert_control.listener.RegisterSignal(src, COMSIG_LIVING_REVIVE, TYPE_PROC_REF(/datum/alarm_listener, allow_alarm_changes))

/mob/living/silicon/robot/modules/syndicate/Initialize(mapload)
	. = ..()
	laws = new /datum/ai_laws/syndicate_override()
	//addtimer(CALLBACK(src, PROC_REF(show_playstyle)), 5)

//If there's an MMI in the robot, have it ejected when the mob goes away. --NEO
/mob/living/silicon/robot/Destroy()
	var/atom/T = drop_location()//To hopefully prevent run time errors.
	if(mmi && mind)//Safety for when a cyborg gets dust()ed. Or there is no MMI inside.
		if(T)
			mmi.forceMove(T)
		if(mmi.brainmob)
			if(mmi.brainmob.stat == DEAD)
				mmi.brainmob.set_stat(CONSCIOUS)
			mind.transfer_to(mmi.brainmob)
			mmi.update_icon()
		else
			to_chat(src, span_boldannounce("Oops! Something went very wrong, your MMI was unable to receive your mind. You have been ghosted. Please make a bug report so we can fix this bug."))
			ghostize()
			stack_trace("Borg MMI lacked a brainmob")
		mmi = null
	if(modularInterface)
		QDEL_NULL(modularInterface)
	if(connected_ai)
		set_connected_ai(null)
	if(shell)
		GLOB.available_ai_shells -= src
	else
		if(T && istype(radio) && istype(radio.keyslot))
			radio.keyslot.forceMove(T)
			radio.keyslot = null
	QDEL_NULL(wires)
	QDEL_NULL(module)
	QDEL_NULL(eye_lights)
	QDEL_NULL(inv1)
	QDEL_NULL(inv2)
	QDEL_NULL(inv3)
	QDEL_NULL(spark_system)
	QDEL_NULL(alert_control)
	cell = null
	return ..()

/mob/living/silicon/robot/Topic(href, href_list)
	. = ..()
	//Show alerts window if user clicked on "Show alerts" in chat
	if(href_list["showalerts"])
		alert_control.ui_interact(src)

/mob/living/silicon/robot/shell/Topic(href, href_list)
	. = ..()
	if (href_list["track"])
		if(mainframe)
			var/mob/living/silicon/ai/AI = mainframe
			AI.Topic(href, href_list) // Spagetti!
		else if(connected_ai) // when you not in borg but still wanna follow
			var/mob/living/silicon/ai/AI = connected_ai
			AI.Topic(href, href_list) // More spagetti!
	return

/mob/living/silicon/robot/proc/pick_module()
	if(module.type != /obj/item/robot_module)
		return

	if(wires.is_cut(WIRE_RESET_MODULE))
		to_chat(src,span_userdanger("ERROR: Module installer reply timeout. Please check internal connections."))
		return

	var/list/modulelist = list("Engineering" = /obj/item/robot_module/engineering, \
	"Medical" = /obj/item/robot_module/medical, \
	"Miner" = /obj/item/robot_module/miner, \
	JOB_JANITOR = /obj/item/robot_module/janitor, \
	"Service" = /obj/item/robot_module/butler)
	if(!CONFIG_GET(flag/disable_peaceborg))
		modulelist["Peacekeeper"] = /obj/item/robot_module/peacekeeper
	if(!CONFIG_GET(flag/disable_secborg))
		modulelist["Security"] = /obj/item/robot_module/security

	// Create radial menu for choosing borg model
	var/list/model_icons = list()
	for(var/option in modulelist)
		var/obj/item/robot_module/module = modulelist[option]
		var/model_icon = initial(module.cyborg_base_icon)
		model_icons[option] = image(icon = 'icons/mob/robots.dmi', icon_state = model_icon)

	var/input_module = show_radial_menu(src, src, model_icons, radius = 42)
	if(!input_module || module.type != /obj/item/robot_module)
		return

	module.transform_to(modulelist[input_module])

/mob/living/silicon/robot/proc/updatename(client/C)
	if(shell)
		return
	if(!C)
		C = client
	var/changed_name = ""
	if(custom_name)
		changed_name = custom_name
	if(SSticker.anonymousnames) //only robotic renames will allow for anything other than the anonymous one
		changed_name = anonymous_ai_name(is_ai = FALSE)
	if(!changed_name && C && C.prefs.custom_names["cyborg"] != DEFAULT_CYBORG_NAME)
		apply_pref_name("cyborg", C)
		return //built in camera handled in proc
	if(!changed_name)
		changed_name = get_standard_name()

	real_name = changed_name
	name = real_name
	if(!QDELETED(builtInCamera))
		builtInCamera.c_tag = real_name	//update the camera name too

/mob/living/silicon/robot/proc/get_standard_name()
	return "[(designation ? "[designation] " : "")][mmi.braintype]-[ident]"

/mob/living/silicon/robot/proc/ionpulse()
	if(!ionpulse_on)
		return

	if(cell.charge <= 10)
		toggle_ionpulse()
		return

	cell.charge -= 10
	return TRUE

/mob/living/silicon/robot/proc/toggle_ionpulse()
	if(!ionpulse)
		to_chat(src, span_notice("No thrusters are installed!"))
		return

	if(!ion_trail)
		ion_trail = new
		ion_trail.set_up(src)

	ionpulse_on = !ionpulse_on
	to_chat(src, span_notice("You [ionpulse_on ? null :"de"]activate your ion thrusters."))
	if(ionpulse_on)
		ion_trail.start()
	else
		ion_trail.stop()

/mob/living/silicon/robot/get_status_tab_items()
	. = ..()
	. += ""
	if(cell)
		. += "Charge Left: [cell.charge]/[cell.maxcharge]"
	else
		. += "No Cell Inserted!"

	if(module)
		for(var/datum/robot_energy_storage/st in module.storages)
			. += "[st.name]: [st.energy]/[st.max_energy]"
	if(connected_ai)
		. += "Master AI: [connected_ai.name]"

/mob/living/silicon/robot/proc/alarm_triggered(datum/source, alarm_type, area/source_area)
	SIGNAL_HANDLER
	queueAlarm("--- [alarm_type] alarm detected in [source_area.name]!", alarm_type)

/mob/living/silicon/robot/proc/alarm_cleared(datum/source, alarm_type, area/source_area)
	SIGNAL_HANDLER
	queueAlarm("--- [alarm_type] alarm in [source_area.name] has been cleared.", alarm_type, FALSE)

/mob/living/silicon/robot/can_interact_with(atom/A)
	if (A == modularInterface)
		return TRUE //bypass for borg tablets
	if (low_power_mode)
		return FALSE
	var/turf/T0 = get_turf(src)
	var/turf/T1 = get_turf(A)
	if (!T0 || ! T1)
		return FALSE
	return ISINRANGE(T1.x, T0.x - interaction_range, T0.x + interaction_range) && ISINRANGE(T1.y, T0.y - interaction_range, T0.y + interaction_range)

/mob/living/silicon/robot/proc/after_tip_over(mob/user)
	if(hat)
		hat.forceMove(drop_location())
	unbuckle_all_mobs()

/mob/living/silicon/robot/proc/allowed(mob/M)
	//check if it doesn't require any access at all
	if(check_access(null))
		return TRUE
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		//if they are holding or wearing a card that has access, that works
		if(check_access(H.get_active_held_item()) || check_access(H.wear_id))
			return TRUE
	else if(isalien(M))
		var/mob/living/carbon/george = M
		//they can only hold things :(
		if(isitem(george.get_active_held_item()))
			return check_access(george.get_active_held_item())
	return FALSE

/mob/living/silicon/robot/proc/check_access(obj/item/card/id/I)
	if(!istype(req_access, /list)) //something's very wrong
		return TRUE

	var/list/L = req_access
	if(!L.len) //no requirements
		return TRUE

	if(!istype(I, /obj/item/card/id) && isitem(I))
		I = I.GetID()

	if(!I || !I.access) //not ID or no access
		return FALSE
	for(var/req in req_access)
		if(!(req in I.access)) //doesn't have this access
			return FALSE
	return TRUE

/mob/living/silicon/robot/regenerate_icons()
	return update_icons()

/mob/living/silicon/robot/update_icons()
	cut_overlays()
	SSvis_overlays.remove_vis_overlay(src, managed_vis_overlays)
	if(module)
		icon_state = module.cyborg_base_icon
	else
		icon_state = "robot"
	if(stat != DEAD && !(HAS_TRAIT(src, TRAIT_KNOCKEDOUT) || IsStun() || IsParalyzed() || low_power_mode)) //Not dead, not stunned.
		if(!eye_lights)
			eye_lights = new()
		if(lamp_enabled || lamp_doom)
			eye_lights.icon_state = "[module.special_light_key ? "[module.special_light_key]":"[module.cyborg_base_icon]"]_l"
			eye_lights.color = lamp_doom? COLOR_RED : lamp_color
			SET_PLANE_EXPLICIT(eye_lights, ABOVE_LIGHTING_PLANE, src) //glowy eyes
		else
			eye_lights.icon_state = "[module.special_light_key ? "[module.special_light_key]":"[module.cyborg_base_icon]"]_e[ratvar ? "_r" : ""]"
			eye_lights.color = COLOR_WHITE
			SET_PLANE_EXPLICIT(eye_lights, ABOVE_GAME_PLANE, src)
		eye_lights.icon = icon
		add_overlay(eye_lights)

	if(opened)
		if(wiresexposed)
			add_overlay("ov-opencover +w")
		else if(cell)
			add_overlay("ov-opencover +c")
		else
			add_overlay("ov-opencover -c")
	if(hat)
		var/mutable_appearance/head_overlay = hat.build_worn_icon(default_layer = 20, default_icon_file = 'icons/mob/clothing/head.dmi')
		head_overlay.pixel_y += hat_offset
		add_overlay(head_overlay)
	update_fire()

/mob/living/silicon/robot/on_changed_z_level(turf/old_turf, turf/new_turf, same_z_layer, notify_contents)
	if(same_z_layer)
		return ..()
	cut_overlay(eye_lights)
	SET_PLANE_EXPLICIT(eye_lights, PLANE_TO_TRUE(eye_lights.plane), src)
	add_overlay(eye_lights)
	return ..()

/mob/living/silicon/robot/proc/self_destruct()
	if(emagged)
		QDEL_NULL(mmi)
		explosion(src, devastation_range = 1, heavy_impact_range = 2, light_impact_range = 4, flame_range = 2)
	else
		explosion(src, devastation_range = -1, light_impact_range = 2)
	gib()

/mob/living/silicon/robot/proc/UnlinkSelf()
	set_connected_ai(null)
	lawupdate = FALSE
	set_lockcharge(FALSE)
	scrambledcodes = TRUE
	//Disconnect it's camera so it's not so easily tracked.
	if(!QDELETED(builtInCamera))
		QDEL_NULL(builtInCamera)
		// I'm trying to get the Cyborg to not be listed in the camera list
		// Instead of being listed as "deactivated". The downside is that I'm going
		// to have to check if every camera is null or not before doing anything, to prevent runtime errors.
		// I could change the network to null but I don't know what would happen, and it seems too hacky for me.

/mob/living/silicon/robot/mode()
	set name = "Использовать предмет в руке"
	set category = null
	set src = usr

	if(incapacitated())
		return
	var/obj/item/W = get_active_held_item()
	if(W)
		W.attack_self(src)


/mob/living/silicon/robot/proc/SetLockdown(state = TRUE)
	// They stay locked down if their wire is cut.
	if(wires.is_cut(WIRE_LOCKDOWN))
		state = TRUE
	if(state)
		throw_alert("locked", /atom/movable/screen/alert/locked)
	else
		clear_alert("locked")
	set_lockcharge(state)


///Reports the event of the change in value of the lockcharge variable.
/mob/living/silicon/robot/proc/set_lockcharge(new_lockcharge)
	if(new_lockcharge == lockcharge)
		return
	. = lockcharge
	lockcharge = new_lockcharge
	if(lockcharge)
		if(!.)
			ADD_TRAIT(src, TRAIT_IMMOBILIZED, LOCKED_BORG_TRAIT)
	else if(.)
		REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, LOCKED_BORG_TRAIT)
	logevent("System lockdown [lockcharge?"triggered":"released"].")


/mob/living/silicon/robot/proc/SetEmagged(new_state)
	emagged = new_state
	module.rebuild_modules()
	update_icons()
	if(emagged)
		throw_alert("hacked", /atom/movable/screen/alert/hacked)
	else
		clear_alert("hacked")

/mob/living/silicon/robot/proc/SetRatvar(new_state, rebuild=TRUE)
	ratvar = new_state
	if(rebuild)
		module.rebuild_modules()
	update_icons()
	if(ratvar)
		internal_clock_slab = new(src)
		throw_alert("ratvar", /atom/movable/screen/alert/ratvar)
	else
		qdel(internal_clock_slab)
		clear_alert("ratvar")

/// Special handling for getting hit with a light eater
/mob/living/silicon/robot/proc/on_light_eater(mob/living/silicon/robot/source, datum/light_eater)
	SIGNAL_HANDLER
	if(lamp_enabled)
		smash_headlamp()
	return COMPONENT_BLOCK_LIGHT_EATER


/**
 * Handles headlamp smashing
 *
 * When called (such as by the shadowperson lighteater's attack), this proc will break the borg's headlamp
 * and then call toggle_headlamp to disable the light. It also plays a sound effect of glass breaking, and
 * tells the borg what happened to its chat. Broken lights can be repaired by using a flashlight on the borg.
 */
/mob/living/silicon/robot/proc/smash_headlamp()
	if(!lamp_functional)
		return
	lamp_functional = FALSE
	playsound(src, 'sound/effects/glass_step.ogg', 50)
	toggle_headlamp(TRUE)
	to_chat(src, span_danger("Your headlamp is broken! You'll need a human to help replace it."))

/**
 * Handles headlamp toggling, disabling, and color setting.
 *
 * The initial if statment is a bit long, but the gist of it is that should the lamp be on AND the update_color
 * arg be true, we should simply change the color of the lamp but not disable it. Otherwise, should the turn_off
 * arg be true, the lamp already be enabled, any of the normal reasons the lamp would turn off happen, or the
 * update_color arg be passed with the lamp not on, we should set the lamp off. The update_color arg is only
 * ever true when this proc is called from the borg tablet, when the color selection feature is used.
 *
 * Arguments:
 * * arg1 - turn_off, if enabled will force the lamp into an off state (rather than toggling it if possible)
 * * arg2 - update_color, if enabled, will adjust the behavior of the proc to change the color of the light if it is already on.
 */
/mob/living/silicon/robot/proc/toggle_headlamp(turn_off = FALSE, update_color = FALSE)
	//if both lamp is enabled AND the update_color flag is on, keep the lamp on. Otherwise, if anything listed is true, disable the lamp.
	if(!(update_color && lamp_enabled) && (turn_off || lamp_enabled || update_color || !lamp_functional || stat || low_power_mode))
		set_light_on(lamp_functional && stat != DEAD && lamp_doom) //If the lamp isn't broken and borg isn't dead, doomsday borgs cannot disable their light fully.
		set_light_color(COLOR_RED) //This should only matter for doomsday borgs, as any other time the lamp will be off and the color not seen
		set_light_range(1) //Again, like above, this only takes effect when the light is forced on by doomsday mode.
		lamp_enabled = FALSE
		lampButton?.update_icon()
		update_icons()
		return
	set_light_range(lamp_intensity)
	set_light_color(lamp_doom? COLOR_RED : lamp_color) //Red for doomsday killborgs, borg's choice otherwise
	set_light_on(TRUE)
	lamp_enabled = TRUE
	lampButton?.update_icon()
	update_icons()

/mob/living/silicon/robot/proc/deconstruct()
	SEND_SIGNAL(src, COMSIG_BORG_SAFE_DECONSTRUCT)
	var/turf/T = get_turf(src)
	if (robot_suit)
		robot_suit.forceMove(T)
		robot_suit.l_leg.forceMove(T)
		robot_suit.l_leg = null
		robot_suit.r_leg.forceMove(T)
		robot_suit.r_leg = null
		new /obj/item/stack/cable_coil(T, robot_suit.chest.wired)
		robot_suit.chest.forceMove(T)
		robot_suit.chest.wired = FALSE
		robot_suit.chest = null
		robot_suit.l_arm.forceMove(T)
		robot_suit.l_arm = null
		robot_suit.r_arm.forceMove(T)
		robot_suit.r_arm = null
		robot_suit.head.forceMove(T)
		robot_suit.head.flash1.forceMove(T)
		robot_suit.head.flash1.burn_out()
		robot_suit.head.flash1 = null
		robot_suit.head.flash2.forceMove(T)
		robot_suit.head.flash2.burn_out()
		robot_suit.head.flash2 = null
		robot_suit.head = null
		robot_suit.update_icon()
	else
		new /obj/item/robot_suit(T)
		new /obj/item/bodypart/l_leg/robot(T)
		new /obj/item/bodypart/r_leg/robot(T)
		new /obj/item/stack/cable_coil(T, 1)
		new /obj/item/bodypart/chest/robot(T)
		new /obj/item/bodypart/l_arm/robot(T)
		new /obj/item/bodypart/r_arm/robot(T)
		new /obj/item/bodypart/head/robot(T)
		var/b
		for(b=0, b!=2, b++)
			var/obj/item/assembly/flash/handheld/F = new /obj/item/assembly/flash/handheld(T)
			F.burn_out()
	if (cell) //Sanity check.
		cell.forceMove(T)
		cell = null
	qdel(src)

///This is the subtype that gets created by robot suits. It's needed so that those kind of borgs don't have a useless cell in them
/mob/living/silicon/robot/nocell
	cell = null

/mob/living/silicon/robot/modules
	var/set_module = /obj/item/robot_module

/mob/living/silicon/robot/modules/Initialize(mapload)
	. = ..()
	module.transform_to(set_module)

/mob/living/silicon/robot/modules/medical
	set_module = /obj/item/robot_module/medical
	icon_state = "medical"

/mob/living/silicon/robot/modules/engineering
	set_module = /obj/item/robot_module/engineering
	icon_state = "engineer"

/mob/living/silicon/robot/modules/security
	set_module = /obj/item/robot_module/security
	icon_state = "sec"

/mob/living/silicon/robot/modules/clown
	set_module = /obj/item/robot_module/clown
	icon_state = "clown"

/mob/living/silicon/robot/modules/peacekeeper
	set_module = /obj/item/robot_module/peacekeeper
	icon_state = "peace"

/mob/living/silicon/robot/modules/miner
	set_module = /obj/item/robot_module/miner
	icon_state = "miner"

/mob/living/silicon/robot/modules/janitor
	set_module = /obj/item/robot_module/janitor
	icon_state = "janitor"

/mob/living/silicon/robot/modules/syndicate
	icon_state = "synd_sec"
	faction = list(ROLE_SYNDICATE)
	bubble_icon = "syndibot"
	req_access = list(ACCESS_SYNDICATE)
	lawupdate = FALSE
	scrambledcodes = TRUE // These are rogue borgs.
	ionpulse = TRUE
	var/playstyle_string = "<span class='big bold'>Я штурмовой киборг синдиката!</span><br>\
							<b>Мое предназночение это помочь штурмовому отряду синдиката заполучить диск ядерной аутентификации. \
							Your cyborg LMG will slowly produce ammunition from your power supply, and your operative pinpointer will find and locate fellow nuclear operatives. \
							<i>Help the operatives secure the disk at all costs!</i></b>"
	set_module = /obj/item/robot_module/syndicate
	cell = /obj/item/stock_parts/cell/hyper
	radio = /obj/item/radio/borg/syndicate

/mob/living/silicon/robot/modules/syndicate/Initialize(mapload)
	. = ..()
	laws = new /datum/ai_laws/syndicate_override()
	addtimer(CALLBACK(src, PROC_REF(show_playstyle)), 5)

/mob/living/silicon/robot/modules/syndicate/create_modularInterface()
	if(!modularInterface)
		modularInterface = new /obj/item/modular_computer/tablet/integrated/syndicate(src)
		modularInterface.saved_identification = real_name
		modularInterface.saved_job = JOB_CYBORG
	return ..()

/mob/living/silicon/robot/modules/syndicate/proc/show_playstyle()
	if(playstyle_string)
		to_chat(src, playstyle_string)

/mob/living/silicon/robot/modules/syndicate/ResetModule()
	return

/mob/living/silicon/robot/modules/syndicate/medical
	icon_state = "synd_medical"
	playstyle_string = "<span class='big bold'>You are a Syndicate medical cyborg!</span><br>\
						<b>You are armed with powerful medical tools to aid you in your mission: help the operatives secure the nuclear authentication disk. \
						Your hypospray will produce Restorative Nanites, a wonder-drug that will heal most types of bodily damages, including clone and brain damage. It also produces morphine for offense. \
						Your defibrillator paddles can revive operatives through their hardsuits, or can be used on harm intent to shock enemies! \
						Your energy saw functions as a circular saw, but can be activated to deal more damage, and your operative pinpointer will find and locate fellow nuclear operatives. \
						<i>Help the operatives secure the disk at all costs!</i></b>"
	set_module = /obj/item/robot_module/syndicate_medical

/mob/living/silicon/robot/modules/syndicate/saboteur
	icon_state = "synd_engi"
	playstyle_string = "<span class='big bold'>You are a Syndicate saboteur cyborg!</span><br>\
						<b>You are armed with robust engineering tools to aid you in your mission: help the operatives secure the nuclear authentication disk. \
						Your destination tagger will allow you to stealthily traverse the disposal network across the station \
						Your welder will allow you to repair the operatives' exosuits, but also yourself and your fellow cyborgs \
						Your cyborg chameleon projector allows you to assume the appearance and registered name of a Nanotrasen engineering borg, and undertake covert actions on the station \
						Be aware that almost any physical contact or incidental damage will break your camouflage \
						<i>Help the operatives secure the disk at all costs!</i></b>"
	set_module = /obj/item/robot_module/saboteur

/mob/living/silicon/robot/proc/notify_ai(notifytype, oldname, newname)
	if(!connected_ai)
		return
	switch(notifytype)
		if(NEW_BORG) //New Cyborg
			to_chat(connected_ai, "<br><br><span class='notice'>NOTICE - New cyborg connection detected: <a href='?src=[REF(connected_ai)];track=[html_encode(name)]'>[name]</a></span><br>")
		if(NEW_MODULE) //New Module
			to_chat(connected_ai, "<br><br><span class='notice'>NOTICE - Cyborg module change detected: [name] has loaded the [designation] module.</span><br>")
		if(RENAME) //New Name
			to_chat(connected_ai, "<br><br><span class='notice'>NOTICE - Cyborg reclassification detected: [oldname] is now designated as [newname].</span><br>")
		if(AI_SHELL) //New Shell
			to_chat(connected_ai, "<br><br><span class='notice'>NOTICE - New cyborg shell detected: <a href='?src=[REF(connected_ai)];track=[html_encode(name)]'>[name]</a></span><br>")
		if(DISCONNECT) //Tampering with the wires
			to_chat(connected_ai, "<br><br><span class='notice'>NOTICE - Remote telemetry lost with [name].</span><br>")

/mob/living/silicon/robot/canUseTopic(atom/movable/M, be_close=FALSE, no_dexterity=FALSE, no_tk=FALSE, need_hands = FALSE, floor_okay=FALSE)
	if(lockcharge || low_power_mode)
		to_chat(src, span_warning("Не могу сделать это сейчас!"))
		return FALSE
	return ..()

/mob/living/silicon/robot/updatehealth()
	..()
	if(!module.breakable_modules)
		return

	/// the current percent health of the robot (-1 to 1)
	var/percent_hp = health/maxHealth
	if(health <= previous_health) //if change in health is negative (we're losing hp)
		if(percent_hp <= 0.5)
			break_cyborg_slot(3)

		if(percent_hp <= 0)
			break_cyborg_slot(2)

		if(percent_hp <= -0.5)
			break_cyborg_slot(1)

	else //if change in health is positive (we're gaining hp)
		if(percent_hp >= 0.5)
			repair_cyborg_slot(3)

		if(percent_hp >= 0)
			repair_cyborg_slot(2)

		if(percent_hp >= -0.5)
			repair_cyborg_slot(1)

	previous_health = health

/mob/living/silicon/robot/update_sight()
	if(!client)
		return
	if(stat == DEAD)
		set_sight(SEE_TURFS|SEE_MOBS|SEE_OBJS)
		set_see_in_dark(8)
		set_invis_see(SEE_INVISIBLE_OBSERVER)
		return

	set_invis_see(initial(see_invisible))
	set_see_in_dark(initial(see_in_dark))
	var/new_sight = initial(sight)
	lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE

	if(client.eye != src)
		var/atom/A = client.eye
		if(A.update_remote_sight(src)) //returns 1 if we override all other sight updates.
			return

	if(sight_mode & BORGMESON)
		new_sight |= SEE_TURFS
		lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
		set_see_in_dark(1)

	if(sight_mode & BORGMATERIAL)
		new_sight |= SEE_OBJS
		lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
		set_see_in_dark(1)

	if(sight_mode & BORGXRAY)
		new_sight |= (SEE_TURFS|SEE_MOBS|SEE_OBJS)
		set_invis_see(SEE_INVISIBLE_LIVING)
		set_see_in_dark(8)

	if(sight_mode & BORGTHERM)
		new_sight |= SEE_MOBS
		lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
		set_invis_see(min(see_invisible, SEE_INVISIBLE_LIVING))
		set_see_in_dark(8)

	if(see_override)
		set_invis_see(see_override)

	set_sight(new_sight)
	return ..()

/mob/living/silicon/robot/update_stat()
	if(status_flags & GODMODE)
		return
	if(stat != DEAD)
		if(health <= -maxHealth) //die only once
			death()
			toggle_headlamp(1)
			return
		if(HAS_TRAIT(src, TRAIT_KNOCKEDOUT) || IsStun() || IsKnockdown() || IsParalyzed())
			set_stat(UNCONSCIOUS)
		else
			set_stat(CONSCIOUS)
	diag_hud_set_status()
	diag_hud_set_health()
	diag_hud_set_aishell()
	update_health_hud()

/mob/living/silicon/robot/revive(full_heal = FALSE, admin_revive = FALSE)
	if(..()) //successfully ressuscitated from death
		if(!QDELETED(builtInCamera) && !wires.is_cut(WIRE_CAMERA))
			builtInCamera.toggle_cam(src,0)
		if(admin_revive)
			locked = TRUE
		notify_ai(NEW_BORG)
		. = TRUE
		toggle_headlamp(FALSE, TRUE) //This will reenable borg headlamps if doomsday is currently going on still.

/mob/living/silicon/robot/fully_replace_character_name(oldname, newname)
	..()
	if(oldname != real_name)
		notify_ai(RENAME, oldname, newname)
	if(!QDELETED(builtInCamera))
		builtInCamera.c_tag = real_name
		modularInterface.saved_identification = real_name
	custom_name = newname


/mob/living/silicon/robot/proc/ResetModule()
	SEND_SIGNAL(src, COMSIG_BORG_SAFE_DECONSTRUCT)
	uneq_all()
	shown_robot_modules = FALSE
	if(hud_used)
		hud_used.update_robot_modules_display()

	if (hasExpanded)
		resize = 0.5
		hasExpanded = FALSE
		update_transform()
	logevent("Chassis configuration has been reset.")
	module.transform_to(/obj/item/robot_module)

	// Remove upgrades.
	for(var/obj/item/borg/upgrade/I in upgrades)
		I.forceMove(get_turf(src))

	ionpulse = FALSE
	revert_shell()

	return 1

/mob/living/silicon/robot/proc/has_module()
	if(!module || module.type == /obj/item/robot_module)
		. = FALSE
	else
		. = TRUE

/mob/living/silicon/robot/proc/update_module_innate()
	designation = module.name
	if(hands)
		hands.icon_state = module.moduleselect_icon

	REMOVE_TRAITS_IN(src, MODEL_TRAIT)
	if(module.module_traits)
		for(var/trait in module.module_traits)
			ADD_TRAIT(src, trait, MODEL_TRAIT)

	if(module.clean_on_move)
		AddElement(/datum/element/cleaning)
	else
		RemoveElement(/datum/element/cleaning)

	hat_offset = module.hat_offset

	INVOKE_ASYNC(src, PROC_REF(updatename))


/mob/living/silicon/robot/proc/place_on_head(obj/item/new_hat)
	if(hat)
		hat.forceMove(get_turf(src))
	hat = new_hat
	new_hat.forceMove(src)
	update_icons()

/**
	*Checking Exited() to detect if a hat gets up and walks off.
	*Drones and pAIs might do this, after all.
*/
/mob/living/silicon/robot/Exited(atom/A)
	if(hat && hat == A)
		hat = null
		if(!QDELETED(src)) //Don't update icons if we are deleted.
			update_icons()
	return ..()

///Use this to add upgrades to robots. It'll register signals for when the upgrade is moved or deleted, if not single use.
/mob/living/silicon/robot/proc/add_to_upgrades(obj/item/borg/upgrade/new_upgrade, mob/user)
	if(new_upgrade in upgrades)
		return FALSE
	if(!user.temporarilyRemoveItemFromInventory(new_upgrade)) //calling the upgrade's dropped() proc /before/ we add action buttons
		return FALSE
	if(!new_upgrade.action(src, user))
		to_chat(user, span_danger("Upgrade error."))
		new_upgrade.forceMove(loc) //gets lost otherwise
		return FALSE
	to_chat(user, span_notice("You apply the upgrade to [src]."))
	to_chat(src, "----------------\nNew hardware detected...Identified as \"<b>[new_upgrade]</b>\"...Setup complete.\n----------------")
	if(new_upgrade.one_use)
		logevent("Firmware [new_upgrade] run successfully.")
		qdel(new_upgrade)
		return FALSE
	upgrades += new_upgrade
	new_upgrade.forceMove(src)
	RegisterSignal(new_upgrade, COMSIG_MOVABLE_MOVED, PROC_REF(remove_from_upgrades))
	RegisterSignal(new_upgrade, COMSIG_PARENT_QDELETING, PROC_REF(on_upgrade_deleted))
	logevent("Hardware [new_upgrade] installed successfully.")

///Called when an upgrade is moved outside the robot. So don't call this directly, use forceMove etc.
/mob/living/silicon/robot/proc/remove_from_upgrades(obj/item/borg/upgrade/old_upgrade)
	SIGNAL_HANDLER
	if(loc == src)
		return
	old_upgrade.deactivate(src)
	upgrades -= old_upgrade
	UnregisterSignal(old_upgrade, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING))

///Called when an applied upgrade is deleted.
/mob/living/silicon/robot/proc/on_upgrade_deleted(obj/item/borg/upgrade/old_upgrade)
	SIGNAL_HANDLER
	if(!QDELETED(src))
		old_upgrade.deactivate(src)
	upgrades -= old_upgrade
	UnregisterSignal(old_upgrade, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING))

/**
 * make_shell: Makes an AI shell out of a cyborg unit
 *
 * Arguments:
 * * board - B.O.R.I.S. module board used for transforming the cyborg into AI shell
 */
/mob/living/silicon/robot/proc/make_shell(obj/item/borg/upgrade/ai/board)
	if(!board)
		upgrades |= new /obj/item/borg/upgrade/ai(src)
	shell = TRUE
	braintype = "AI Shell"
	name = "Empty AI Shell-[ident]"
	real_name = name
	GLOB.available_ai_shells |= src
	if(!QDELETED(builtInCamera))
		builtInCamera.c_tag = real_name	//update the camera name too
	diag_hud_set_aishell()

/**
 * revert_shell: Reverts AI shell back into a normal cyborg unit
 */
/mob/living/silicon/robot/proc/revert_shell()
	if(!shell)
		return
	undeploy()
	for(var/obj/item/borg/upgrade/ai/boris in src)
	//A player forced reset of a borg would drop the module before this is called, so this is for catching edge cases
		qdel(boris)
	shell = FALSE
	GLOB.available_ai_shells -= src
	name = "Unformatted Cyborg-[ident]"
	real_name = name
	if(!QDELETED(builtInCamera))
		builtInCamera.c_tag = real_name
	diag_hud_set_aishell()

/**
 * deploy_init: Deploys AI unit into AI shell
 *
 * Arguments:
 * * AI - AI unit that initiated the deployment into the AI shell
 */
/mob/living/silicon/robot/proc/deploy_init(mob/living/silicon/ai/AI)
	real_name = "[AI.real_name] [designation] Shell-[ident]"
	name = real_name
	if(!QDELETED(builtInCamera))
		builtInCamera.c_tag = real_name	//update the camera name too
	mainframe = AI
	deployed = TRUE
	set_connected_ai(mainframe)
	mainframe.connected_robots |= src
	lawupdate = TRUE
	lawsync()
	if(radio && AI.radio) //AI keeps all channels, including Syndie if it is a Traitor
		if(AI.radio.syndie)
			radio.make_syndie()
		radio.subspace_transmission = TRUE
		radio.channels = AI.radio.channels
		for(var/chan in radio.channels)
			radio.secure_radio_connections[chan] = add_radio(radio, GLOB.radiochannels[chan])

	diag_hud_set_aishell()
	undeployment_action.Grant(src)

/datum/action/innate/undeployment
	name = "Disconnect from shell"
	desc = "Stop controlling your shell and resume normal core operations."
	button_icon = 'icons/mob/actions/actions_AI.dmi'
	button_icon_state = "ai_core"

/datum/action/innate/undeployment/Trigger(trigger_flags)
	if(!..())
		return FALSE
	var/mob/living/silicon/robot/R = owner

	R.undeploy()
	return TRUE


/mob/living/silicon/robot/proc/undeploy()

	if(!deployed || !mind || !mainframe)
		return
	mainframe.redeploy_action.Grant(mainframe)
	mainframe.redeploy_action.last_used_shell = src
	mind.transfer_to(mainframe)
	deployed = FALSE
	mainframe.deployed_shell = null
	undeployment_action.Remove(src)
	if(radio) //Return radio to normal
		radio.recalculateChannels()
	if(!QDELETED(builtInCamera))
		builtInCamera.c_tag = real_name	//update the camera name too
	diag_hud_set_aishell()
	mainframe.diag_hud_set_deployed()
	if(mainframe.laws)
		mainframe.laws.show_laws(mainframe) //Always remind the AI when switching
	if(mainframe.eyeobj)
		mainframe.eyeobj.setLoc(loc)
	mainframe = null

/mob/living/silicon/robot/attack_ai(mob/user)
	if(shell && (!connected_ai || connected_ai == user))
		var/mob/living/silicon/ai/AI = user
		AI.deploy_to_shell(src)

/mob/living/silicon/robot/shell
	shell = TRUE
	cell = /obj/item/stock_parts/cell/high

/mob/living/silicon/robot/mouse_buckle_handling(mob/living/M, mob/living/user)
	//Don't try buckling on INTENT_HARM so that silicons can search people's inventories without loading them
	if(can_buckle && isliving(user) && isliving(M) && !(M in buckled_mobs) && ((user != src) || (a_intent != INTENT_HARM)))
		return user_buckle_mob(M, user, check_loc = FALSE)

/mob/living/silicon/robot/buckle_mob(mob/living/M, force = FALSE, check_loc = TRUE, buckle_mob_flags= RIDER_NEEDS_ARM)
	if(!is_type_in_typecache(M, can_ride_typecache))
		M.visible_message(span_warning("[M] really can't seem to mount [src]..."))
		return

	if(stat || incapacitated())
		return
	if(module && !module.allow_riding)
		M.visible_message(span_boldwarning("Unfortunately, [M] just can't seem to hold onto [src]!"))
		return

	buckle_mob_flags= RIDER_NEEDS_ARM // just in case
	return ..()

/mob/living/silicon/robot/resist()
	. = ..()
	if(!has_buckled_mobs())
		return
	for(var/i in buckled_mobs)
		var/mob/unbuckle_me_now = i
		unbuckle_mob(unbuckle_me_now, FALSE)


/mob/living/silicon/robot/proc/TryConnectToAI()
	set_connected_ai(select_active_ai_with_fewest_borgs(z))
	if(connected_ai)
		lawsync()
		lawupdate = TRUE
		return TRUE
	picturesync()
	return FALSE

/mob/living/silicon/robot/proc/picturesync()
	if(connected_ai?.aicamera && aicamera)
		for(var/i in aicamera.stored)
			connected_ai.aicamera.stored[i] = TRUE
		for(var/i in connected_ai.aicamera.stored)
			aicamera.stored[i] = TRUE

/mob/living/silicon/robot/proc/charge(datum/source, amount, repairs)
	if(module)
		module.respawn_consumable(src, amount * 0.005)
	if(cell)
		cell.charge = min(cell.charge + amount, cell.maxcharge)
	if(repairs)
		heal_bodypart_damage(repairs, repairs - 1)

/mob/living/silicon/robot/proc/set_connected_ai(new_ai)
	if(connected_ai == new_ai)
		return
	. = connected_ai
	connected_ai = new_ai
	if(.)
		var/mob/living/silicon/ai/old_ai = .
		old_ai.connected_robots -= src
	lamp_doom = FALSE
	if(connected_ai)
		connected_ai.connected_robots |= src
		lamp_doom = connected_ai.doomsday_device ? TRUE : FALSE
	toggle_headlamp(FALSE, TRUE)

/mob/living/silicon/robot/update_fire_overlay(stacks, on_fire, last_icon_state, suffix = "")
	var/fire_icon = "generic_fire[suffix]"

	if(!GLOB.fire_appearances[fire_icon])
		var/mutable_appearance/new_fire_overlay = mutable_appearance('icons/mob/onfire.dmi', fire_icon, -FIRE_LAYER)
		new_fire_overlay.appearance_flags = RESET_COLOR
		GLOB.fire_appearances[fire_icon] = new_fire_overlay

	if(stacks && on_fire)
		if(last_icon_state == fire_icon)
			return last_icon_state
		add_overlay(GLOB.fire_appearances[fire_icon])
		return fire_icon

	if(!last_icon_state)
		return last_icon_state

	cut_overlay(GLOB.fire_appearances[fire_icon])
	return null

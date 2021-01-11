/*
	New methods:
	pulse - sends a pulse into a wire for hacking purposes
	cut - cuts a wire and makes any necessary state changes
	mend - mends a wire and makes any necessary state changes
	canAIControl - 1 if the AI can control the airlock, 0 if not (then check canAIHack to see if it can hack in)
	canAIHack - 1 if the AI can hack into the airlock to recover control, 0 if not. Also returns 0 if the AI does not *need* to hack it.
	hasPower - 1 if the main or backup power are functioning, 0 if not.
	requiresIDs - 1 if the airlock is requiring IDs, 0 if not
	isAllPowerCut - 1 if the main and backup power both have cut wires.
	regainMainPower - handles the effect of main power coming back on.
	loseMainPower - handles the effect of main power going offline. Usually (if one isn't already running) spawn a thread to count down how long it will be offline - counting down won't happen if main power was completely cut along with backup power, though, the thread will just sleep.
	loseBackupPower - handles the effect of backup power going offline.
	regainBackupPower - handles the effect of main power coming back on.
	shock - has a chance of electrocuting its target.
*/

/// Overlay cache.  Why isn't this just in /obj/machinery/door/airlock?  Because its used just a
/// tiny bit in door_assembly.dm  Refactored so you don't have to make a null copy of airlock
/// to get to the damn thing
/// Someone, for the love of god, profile this.  Is there a reason to cache mutable_appearance
/// if so, why are we JUST doing the airlocks when we can put this in mutable_appearance.dm for
/// everything
/proc/get_airlock_overlay(icon_state, icon_file)
	var/static/list/airlock_overlays = list()
	var/iconkey = "[icon_state][icon_file]"
	if((!(. = airlock_overlays[iconkey])))
		. = airlock_overlays[iconkey] = mutable_appearance(icon_file, icon_state)
// Before you say this is a bad implmentation, look at what it was before then ask yourself
// "Would this be better with a global var"

// Wires for the airlock are located in the datum folder, inside the wires datum folder.

#define AIRLOCK_CLOSED	1
#define AIRLOCK_CLOSING	2
#define AIRLOCK_OPEN	3
#define AIRLOCK_OPENING	4
#define AIRLOCK_DENY	5
#define AIRLOCK_EMAG	6

#define AIRLOCK_SECURITY_NONE			0 //Normal airlock				//Wires are not secured
#define AIRLOCK_SECURITY_METAL			1 //Medium security airlock		//There is a simple metal over wires (use welder)
#define AIRLOCK_SECURITY_PLASTEEL_I_S	2 								//Sliced inner plating (use crowbar), jumps to 0
#define AIRLOCK_SECURITY_PLASTEEL_I		3 								//Removed outer plating, second layer here (use welder)
#define AIRLOCK_SECURITY_PLASTEEL_O_S	4 								//Sliced outer plating (use crowbar)
#define AIRLOCK_SECURITY_PLASTEEL_O		5 								//There is first layer of plasteel (use welder)
#define AIRLOCK_SECURITY_PLASTEEL		6 //Max security airlock		//Fully secured wires (use wirecutters to remove grille, that is electrified)

#define AIRLOCK_INTEGRITY_N			 300 // Normal airlock integrity
#define AIRLOCK_INTEGRITY_MULTIPLIER 1.5 // How much reinforced doors health increases
/// How much extra health airlocks get when braced with a seal
#define AIRLOCK_SEAL_MULTIPLIER		 2
#define AIRLOCK_DAMAGE_DEFLECTION_N  21  // Normal airlock damage deflection
#define AIRLOCK_DAMAGE_DEFLECTION_R  30  // Reinforced airlock damage deflection

#define AIRLOCK_DENY_ANIMATION_TIME (0.6 SECONDS) /// The amount of time for the airlock deny animation to show

#define DOOR_CLOSE_WAIT 60 /// Time before a door closes, if not overridden

/obj/machinery/door/airlock
	name = "шлюз"
	icon = 'icons/obj/doors/airlocks/station/public.dmi'
	icon_state = "closed"
	max_integrity = 300
	var/normal_integrity = AIRLOCK_INTEGRITY_N
	integrity_failure = 0.25
	damage_deflection = AIRLOCK_DAMAGE_DEFLECTION_N
	autoclose = TRUE
	secondsElectrified = MACHINE_NOT_ELECTRIFIED //How many seconds remain until the door is no longer electrified. -1/MACHINE_ELECTRIFIED_PERMANENT = permanently electrified until someone fixes it.
	assemblytype = /obj/structure/door_assembly
	normalspeed = 1
	explosion_block = 1
	hud_possible = list(DIAG_AIRLOCK_HUD)
	smoothing_groups = list(SMOOTH_GROUP_AIRLOCK)

	interaction_flags_machine = INTERACT_MACHINE_WIRES_IF_OPEN | INTERACT_MACHINE_ALLOW_SILICON | INTERACT_MACHINE_OPEN_SILICON | INTERACT_MACHINE_REQUIRES_SILICON | INTERACT_MACHINE_OPEN

	var/security_level = 0 //How much are wires secured
	var/aiControlDisabled = AI_WIRE_NORMAL //If 1, AI control is disabled until the AI hacks back in and disables the lock. If 2, the AI has bypassed the lock. If -1, the control is enabled but the AI had bypassed it earlier, so if it is disabled again the AI would have no trouble getting back in.
	var/hackProof = FALSE // if true, this door can't be hacked by the AI
	var/secondsMainPowerLost = 0 //The number of seconds until power is restored.
	var/secondsBackupPowerLost = 0 //The number of seconds until power is restored.
	var/spawnPowerRestoreRunning = FALSE
	var/lights = TRUE // bolt lights show by default
	var/aiDisabledIdScanner = FALSE
	var/aiHacking = FALSE
	var/closeOtherId //Cyclelinking for airlocks that aren't on the same x or y coord as the target.
	var/obj/machinery/door/airlock/closeOther
	var/obj/item/electronics/airlock/electronics
	COOLDOWN_DECLARE(shockCooldown)
	var/obj/item/note //Any papers pinned to the airlock
	/// The seal on the airlock
	var/obj/item/seal
	var/detonated = FALSE
	var/abandoned = FALSE
	var/cutAiWire = FALSE
	var/doorOpen = 'sound/machines/airlock.ogg'
	var/doorClose = 'sound/machines/airlockclose.ogg'
	var/doorDeni = 'sound/machines/deniedbeep.ogg' // i'm thinkin' Deni's
	var/boltUp = 'sound/machines/boltsup.ogg'
	var/boltDown = 'sound/machines/boltsdown.ogg'
	var/noPower = 'sound/machines/doorclick.ogg'
	var/previous_airlock = /obj/structure/door_assembly //what airlock assembly mineral plating was applied to
	var/airlock_material //material of inner filling; if its an airlock with glass, this should be set to "glass"
	var/overlays_file = 'icons/obj/doors/airlocks/station/overlays.dmi'
	var/note_overlay_file = 'icons/obj/doors/airlocks/station/overlays.dmi' //Used for papers and photos pinned to the airlock

	var/cyclelinkeddir = 0
	var/obj/machinery/door/airlock/cyclelinkedairlock
	var/shuttledocked = 0
	var/delayed_close_requested = FALSE // TRUE means the door will automatically close the next time it's opened.
	var/prying_so_hard = FALSE

	flags_1 = RAD_PROTECT_CONTENTS_1 | RAD_NO_CONTAMINATE_1
	rad_insulation = RAD_MEDIUM_INSULATION

	network_id = NETWORK_DOOR_AIRLOCKS

/obj/machinery/door/airlock/Initialize()
	. = ..()
	wires = set_wires()
	if(frequency)
		set_frequency(frequency)

	if(closeOtherId != null)
		addtimer(CALLBACK(.proc/update_other_id), 5)
	if(glass)
		airlock_material = "glass"
	if(security_level > AIRLOCK_SECURITY_METAL)
		obj_integrity = normal_integrity * AIRLOCK_INTEGRITY_MULTIPLIER
		max_integrity = normal_integrity * AIRLOCK_INTEGRITY_MULTIPLIER
	else
		obj_integrity = normal_integrity
		max_integrity = normal_integrity
	if(damage_deflection == AIRLOCK_DAMAGE_DEFLECTION_N && security_level > AIRLOCK_SECURITY_METAL)
		damage_deflection = AIRLOCK_DAMAGE_DEFLECTION_R
	prepare_huds()
	for(var/datum/atom_hud/data/diagnostic/diag_hud in GLOB.huds)
		diag_hud.add_to_hud(src)
	diag_hud_set_electrified()

	RegisterSignal(src, COMSIG_MACHINERY_BROKEN, .proc/on_break)
	RegisterSignal(src, COMSIG_COMPONENT_NTNET_RECEIVE, .proc/ntnet_receive)

	return INITIALIZE_HINT_LATELOAD

/obj/machinery/door/airlock/LateInitialize()
	. = ..()
	if (cyclelinkeddir)
		cyclelinkairlock()
	if(abandoned)
		var/outcome = rand(1,100)
		switch(outcome)
			if(1 to 9)
				var/turf/here = get_turf(src)
				for(var/turf/closed/T in range(2, src))
					here.PlaceOnTop(T.type)
					qdel(src)
					return
				here.PlaceOnTop(/turf/closed/wall)
				qdel(src)
				return
			if(9 to 11)
				lights = FALSE
				locked = TRUE
			if(12 to 15)
				locked = TRUE
			if(16 to 23)
				welded = TRUE
			if(24 to 30)
				panel_open = TRUE
	if(cutAiWire)
		wires.cut(WIRE_AI)
	update_icon()


/obj/machinery/door/airlock/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock)
	if(id_tag)
		id_tag = "[port.id]_[id_tag]"

/obj/machinery/door/airlock/proc/update_other_id()
	for(var/obj/machinery/door/airlock/A in GLOB.airlocks)
		if(A.closeOtherId == closeOtherId && A != src)
			closeOther = A
			break

/obj/machinery/door/airlock/proc/cyclelinkairlock()
	if (cyclelinkedairlock)
		cyclelinkedairlock.cyclelinkedairlock = null
		cyclelinkedairlock = null
	if (!cyclelinkeddir)
		return
	var/limit = world.view
	var/turf/T = get_turf(src)
	var/obj/machinery/door/airlock/FoundDoor
	do
		T = get_step(T, cyclelinkeddir)
		FoundDoor = locate() in T
		if (FoundDoor && FoundDoor.cyclelinkeddir != get_dir(FoundDoor, src))
			FoundDoor = null
		limit--
	while(!FoundDoor && limit)
	if (!FoundDoor)
		log_mapping("[src] at [AREACOORD(src)] failed to find a valid airlock to cyclelink with!")
		return
	FoundDoor.cyclelinkedairlock = src
	cyclelinkedairlock = FoundDoor

/obj/machinery/door/airlock/vv_edit_var(var_name)
	. = ..()
	switch (var_name)
		if (NAMEOF(src, cyclelinkeddir))
			cyclelinkairlock()

/obj/machinery/door/airlock/check_access_ntnet(datum/netdata/data)
	return !requiresID() || ..(data)

/obj/machinery/door/airlock/proc/ntnet_receive(datum/source, datum/netdata/data)
	// Check if the airlock is powered and can accept control packets.
	if(!hasPower() || !canAIControl())
		return

	// Handle received packet.
	var/command = data.data["data"]
	var/command_value = data.data["data_secondary"]
	switch(command)
		if("open")
			if(command_value == "on" && !density)
				return

			if(command_value == "off" && density)
				return

			if(density)
				INVOKE_ASYNC(src, .proc/open)
			else
				INVOKE_ASYNC(src, .proc/close)

		if("bolt")
			if(command_value == "on" && locked)
				return

			if(command_value == "off" && !locked)
				return

			if(locked)
				unbolt()
			else
				bolt()

		if("emergency")
			if(command_value == "on" && emergency)

				return

			if(command_value == "off" && !emergency)
				return

			emergency = !emergency
			update_icon()

/obj/machinery/door/airlock/lock()
	bolt()

/obj/machinery/door/airlock/proc/bolt()
	if(locked)
		return
	locked = TRUE
	playsound(src,boltDown,30,FALSE,3)
	audible_message("<span class='hear'>Слышу щелчок снизу шлюза.</span>", null,  1)
	update_icon()

/obj/machinery/door/airlock/unlock()
	unbolt()

/obj/machinery/door/airlock/proc/unbolt()
	if(!locked)
		return
	locked = FALSE
	playsound(src,boltUp,30,FALSE,3)
	audible_message("<span class='hear'>Слышу щелчок снизу шлюза.</span>", null,  1)
	update_icon()

/obj/machinery/door/airlock/narsie_act()
	var/turf/T = get_turf(src)
	var/obj/machinery/door/airlock/cult/A
	if(GLOB.cult_narsie)
		var/runed = prob(20)
		if(glass)
			if(runed)
				A = new/obj/machinery/door/airlock/cult/glass(T)
			else
				A = new/obj/machinery/door/airlock/cult/unruned/glass(T)
		else
			if(runed)
				A = new/obj/machinery/door/airlock/cult(T)
			else
				A = new/obj/machinery/door/airlock/cult/unruned(T)
		A.name = name
	else
		A = new /obj/machinery/door/airlock/cult/weak(T)
	qdel(src)

/obj/machinery/door/airlock/Destroy()
	QDEL_NULL(wires)
	QDEL_NULL(electronics)
	if (cyclelinkedairlock)
		if (cyclelinkedairlock.cyclelinkedairlock == src)
			cyclelinkedairlock.cyclelinkedairlock = null
		cyclelinkedairlock = null
	if(id_tag)
		for(var/obj/machinery/door_buttons/D in GLOB.machines)
			D.removeMe(src)
	QDEL_NULL(note)
	QDEL_NULL(seal)
	for(var/datum/atom_hud/data/diagnostic/diag_hud in GLOB.huds)
		diag_hud.remove_from_hud(src)
	return ..()

/obj/machinery/door/airlock/handle_atom_del(atom/A)
	if(A == note)
		note = null
		update_icon()
	if(A == seal)
		seal = null
		update_icon()

/obj/machinery/door/airlock/bumpopen(mob/living/user) //Airlocks now zap you when you 'bump' them open when they're electrified. --NeoFite
	if(!issilicon(usr))
		if(isElectrified() && shock(user, 100))
			return
		else if(user.hallucinating() && iscarbon(user) && prob(1) && !operating)
			var/mob/living/carbon/C = user
			if(!C.wearing_shock_proof_gloves())
				new /datum/hallucination/shock(C)
				return
	if (cyclelinkedairlock)
		if (!shuttledocked && !emergency && !cyclelinkedairlock.shuttledocked && !cyclelinkedairlock.emergency && allowed(user))
			if(cyclelinkedairlock.operating)
				cyclelinkedairlock.delayed_close_requested = TRUE
			else
				addtimer(CALLBACK(cyclelinkedairlock, .proc/close), 2)
	if(locked && allowed(user) && aac)
		aac.request_from_door(src)
		return
	..()

/obj/machinery/door/airlock/proc/isElectrified()
	return (secondsElectrified != MACHINE_NOT_ELECTRIFIED)

/obj/machinery/door/airlock/proc/canAIControl(mob/user)
	return ((aiControlDisabled != AI_WIRE_DISABLED) && !isAllPowerCut())

/obj/machinery/door/airlock/proc/canAIHack()
	return ((aiControlDisabled==AI_WIRE_DISABLED) && (!hackProof) && (!isAllPowerCut()));

/obj/machinery/door/airlock/hasPower()
	return ((!secondsMainPowerLost || !secondsBackupPowerLost) && !(machine_stat & NOPOWER))

/obj/machinery/door/airlock/requiresID()
	return !(wires.is_cut(WIRE_IDSCAN) || aiDisabledIdScanner)

/obj/machinery/door/airlock/proc/isAllPowerCut()
	if((wires.is_cut(WIRE_POWER1) || wires.is_cut(WIRE_POWER2)) && (wires.is_cut(WIRE_BACKUP1) || wires.is_cut(WIRE_BACKUP2)))
		return TRUE

/obj/machinery/door/airlock/proc/regainMainPower()
	if(secondsMainPowerLost > 0)
		secondsMainPowerLost = 0
	update_icon()

/obj/machinery/door/airlock/proc/handlePowerRestore()
	var/cont = TRUE
	while (cont)
		sleep(10)
		if(QDELETED(src))
			return
		cont = FALSE
		if(secondsMainPowerLost>0)
			if(!wires.is_cut(WIRE_POWER1) && !wires.is_cut(WIRE_POWER2))
				secondsMainPowerLost -= 1
				updateDialog()
			cont = TRUE
		if(secondsBackupPowerLost>0)
			if(!wires.is_cut(WIRE_BACKUP1) && !wires.is_cut(WIRE_BACKUP2))
				secondsBackupPowerLost -= 1
				updateDialog()
			cont = TRUE
	spawnPowerRestoreRunning = FALSE
	updateDialog()
	update_icon()

/obj/machinery/door/airlock/proc/loseMainPower()
	if(secondsMainPowerLost <= 0)
		secondsMainPowerLost = 60
		if(secondsBackupPowerLost < 10)
			secondsBackupPowerLost = 10
	if(!spawnPowerRestoreRunning)
		spawnPowerRestoreRunning = TRUE
	INVOKE_ASYNC(src, .proc/handlePowerRestore)
	update_icon()

/obj/machinery/door/airlock/proc/loseBackupPower()
	if(secondsBackupPowerLost < 60)
		secondsBackupPowerLost = 60
	if(!spawnPowerRestoreRunning)
		spawnPowerRestoreRunning = TRUE
	INVOKE_ASYNC(src, .proc/handlePowerRestore)
	update_icon()

/obj/machinery/door/airlock/proc/regainBackupPower()
	if(secondsBackupPowerLost > 0)
		secondsBackupPowerLost = 0
	update_icon()

// shock user with probability prb (if all connections & power are working)
// returns TRUE if shocked, FALSE otherwise
// The preceding comment was borrowed from the grille's shock script
/obj/machinery/door/airlock/proc/shock(mob/living/user, prb)
	if(!istype(user) || !hasPower())		// unpowered, no shock
		return FALSE
	if(!COOLDOWN_FINISHED(src, shockCooldown))
		return FALSE	//Already shocked someone recently?
	if(!prob(prb))
		return FALSE //you lucked out, no shock for you
	do_sparks(5, TRUE, src)
	var/check_range = TRUE
	if(electrocute_mob(user, get_area(src), src, 1, check_range))
		COOLDOWN_START(src, shockCooldown, 1 SECONDS)
		return TRUE
	else
		return FALSE

/obj/machinery/door/airlock/update_icon(state=0, override=0)
	if(operating && !override)
		return
	switch(state)
		if(0)
			if(density)
				state = AIRLOCK_CLOSED
			else
				state = AIRLOCK_OPEN
			icon_state = ""
		if(AIRLOCK_OPEN, AIRLOCK_CLOSED)
			icon_state = ""
		if(AIRLOCK_DENY, AIRLOCK_OPENING, AIRLOCK_CLOSING, AIRLOCK_EMAG)
			icon_state = "nonexistenticonstate" //MADNESS
	set_airlock_overlays(state)

/obj/machinery/door/airlock/proc/set_airlock_overlays(state)
	var/mutable_appearance/frame_overlay
	var/mutable_appearance/filling_overlay
	var/mutable_appearance/lights_overlay
	var/mutable_appearance/panel_overlay
	var/mutable_appearance/weld_overlay
	var/mutable_appearance/damag_overlay
	var/mutable_appearance/sparks_overlay
	var/mutable_appearance/note_overlay
	var/mutable_appearance/seal_overlay
	var/notetype = note_type()

	switch(state)
		if(AIRLOCK_CLOSED)
			frame_overlay = get_airlock_overlay("closed", icon)
			if(airlock_material)
				filling_overlay = get_airlock_overlay("[airlock_material]_closed", overlays_file)
			else
				filling_overlay = get_airlock_overlay("fill_closed", icon)
			if(panel_open)
				if(security_level)
					panel_overlay = get_airlock_overlay("panel_closed_protected", overlays_file)
				else
					panel_overlay = get_airlock_overlay("panel_closed", overlays_file)
			if(welded)
				weld_overlay = get_airlock_overlay("welded", overlays_file)
			if(seal)
				seal_overlay = get_airlock_overlay("sealed", overlays_file)
			if(obj_integrity < integrity_failure * max_integrity)
				damag_overlay = get_airlock_overlay("sparks_broken", overlays_file)
			else if(obj_integrity < (0.75 * max_integrity))
				damag_overlay = get_airlock_overlay("sparks_damaged", overlays_file)
			if(lights && hasPower())
				if(locked)
					lights_overlay = get_airlock_overlay("lights_bolts", overlays_file)
				else if(emergency)
					lights_overlay = get_airlock_overlay("lights_emergency", overlays_file)
			if(note)
				note_overlay = get_airlock_overlay(notetype, note_overlay_file)

		if(AIRLOCK_DENY)
			if(!hasPower())
				return
			frame_overlay = get_airlock_overlay("closed", icon)
			if(airlock_material)
				filling_overlay = get_airlock_overlay("[airlock_material]_closed", overlays_file)
			else
				filling_overlay = get_airlock_overlay("fill_closed", icon)
			if(panel_open)
				if(security_level)
					panel_overlay = get_airlock_overlay("panel_closed_protected", overlays_file)
				else
					panel_overlay = get_airlock_overlay("panel_closed", overlays_file)
			if(obj_integrity < integrity_failure * max_integrity)
				damag_overlay = get_airlock_overlay("sparks_broken", overlays_file)
			else if(obj_integrity < (0.75 * max_integrity))
				damag_overlay = get_airlock_overlay("sparks_damaged", overlays_file)
			if(welded)
				weld_overlay = get_airlock_overlay("welded", overlays_file)
			if(seal)
				seal_overlay = get_airlock_overlay("sealed", overlays_file)
			lights_overlay = get_airlock_overlay("lights_denied", overlays_file)
			if(note)
				note_overlay = get_airlock_overlay(notetype, note_overlay_file)

		if(AIRLOCK_EMAG)
			frame_overlay = get_airlock_overlay("closed", icon)
			sparks_overlay = get_airlock_overlay("sparks", overlays_file)
			if(airlock_material)
				filling_overlay = get_airlock_overlay("[airlock_material]_closed", overlays_file)
			else
				filling_overlay = get_airlock_overlay("fill_closed", icon)
			if(panel_open)
				if(security_level)
					panel_overlay = get_airlock_overlay("panel_closed_protected", overlays_file)
				else
					panel_overlay = get_airlock_overlay("panel_closed", overlays_file)
			if(obj_integrity < integrity_failure * max_integrity)
				damag_overlay = get_airlock_overlay("sparks_broken", overlays_file)
			else if(obj_integrity < (0.75 * max_integrity))
				damag_overlay = get_airlock_overlay("sparks_damaged", overlays_file)
			if(welded)
				weld_overlay = get_airlock_overlay("welded", overlays_file)
			if(seal)
				seal_overlay = get_airlock_overlay("sealed", overlays_file)
			if(note)
				note_overlay = get_airlock_overlay(notetype, note_overlay_file)

		if(AIRLOCK_CLOSING)
			frame_overlay = get_airlock_overlay("closing", icon)
			if(airlock_material)
				filling_overlay = get_airlock_overlay("[airlock_material]_closing", overlays_file)
			else
				filling_overlay = get_airlock_overlay("fill_closing", icon)
			if(lights && hasPower())
				lights_overlay = get_airlock_overlay("lights_closing", overlays_file)
			if(panel_open)
				if(security_level)
					panel_overlay = get_airlock_overlay("panel_closing_protected", overlays_file)
				else
					panel_overlay = get_airlock_overlay("panel_closing", overlays_file)
			if(note)
				note_overlay = get_airlock_overlay("[notetype]_closing", note_overlay_file)

		if(AIRLOCK_OPEN)
			frame_overlay = get_airlock_overlay("open", icon)
			if(airlock_material)
				filling_overlay = get_airlock_overlay("[airlock_material]_open", overlays_file)
			else
				filling_overlay = get_airlock_overlay("fill_open", icon)
			if(panel_open)
				if(security_level)
					panel_overlay = get_airlock_overlay("panel_open_protected", overlays_file)
				else
					panel_overlay = get_airlock_overlay("panel_open", overlays_file)
			if(obj_integrity < (0.75 * max_integrity))
				damag_overlay = get_airlock_overlay("sparks_open", overlays_file)
			if(note)
				note_overlay = get_airlock_overlay("[notetype]_open", note_overlay_file)

		if(AIRLOCK_OPENING)
			frame_overlay = get_airlock_overlay("opening", icon)
			if(airlock_material)
				filling_overlay = get_airlock_overlay("[airlock_material]_opening", overlays_file)
			else
				filling_overlay = get_airlock_overlay("fill_opening", icon)
			if(lights && hasPower())
				lights_overlay = get_airlock_overlay("lights_opening", overlays_file)
			if(panel_open)
				if(security_level)
					panel_overlay = get_airlock_overlay("panel_opening_protected", overlays_file)
				else
					panel_overlay = get_airlock_overlay("panel_opening", overlays_file)
			if(note)
				note_overlay = get_airlock_overlay("[notetype]_opening", note_overlay_file)

	cut_overlays()
	add_overlay(frame_overlay)
	add_overlay(filling_overlay)
	add_overlay(lights_overlay)
	add_overlay(panel_overlay)
	add_overlay(weld_overlay)
	add_overlay(sparks_overlay)
	add_overlay(damag_overlay)
	add_overlay(note_overlay)
	add_overlay(seal_overlay)
	check_unres()

/obj/machinery/door/airlock/proc/check_unres() //unrestricted sides. This overlay indicates which directions the player can access even without an ID
	if(hasPower() && unres_sides)
		if(unres_sides & NORTH)
			var/image/I = image(icon='icons/obj/doors/airlocks/station/overlays.dmi', icon_state="unres_n")
			I.pixel_y = 32
			set_light(l_range = 2, l_power = 1)
			add_overlay(I)
		if(unres_sides & SOUTH)
			var/image/I = image(icon='icons/obj/doors/airlocks/station/overlays.dmi', icon_state="unres_s")
			I.pixel_y = -32
			set_light(l_range = 2, l_power = 1)
			add_overlay(I)
		if(unres_sides & EAST)
			var/image/I = image(icon='icons/obj/doors/airlocks/station/overlays.dmi', icon_state="unres_e")
			I.pixel_x = 32
			set_light(l_range = 2, l_power = 1)
			add_overlay(I)
		if(unres_sides & WEST)
			var/image/I = image(icon='icons/obj/doors/airlocks/station/overlays.dmi', icon_state="unres_w")
			I.pixel_x = -32
			set_light(l_range = 2, l_power = 1)
			add_overlay(I)
	else
		set_light(0)

/obj/machinery/door/airlock/do_animate(animation)
	switch(animation)
		if("opening")
			update_icon(AIRLOCK_OPENING)
		if("closing")
			update_icon(AIRLOCK_CLOSING)
		if("deny")
			if(!machine_stat)
				update_icon(AIRLOCK_DENY)
				playsound(src,doorDeni,50,FALSE,3)
				addtimer(CALLBACK(src, /atom/proc/update_icon, AIRLOCK_CLOSED), AIRLOCK_DENY_ANIMATION_TIME)

/obj/machinery/door/airlock/examine(mob/user)
	. = ..()
	if(obj_flags & EMAGGED)
		. += "<hr><span class='warning'>Панель доступа слегка дымится.</span>"
	if(note)
		if(!in_range(user, src))
			. += "<hr>Здесь есть [note.name]. Надо бы подойти ближе, чтобы прочитать."
		else
			. += "<hr>Здесь есть [note.name]...\n"
			. += note.examine(user)
	if(seal)
		. += "Он закрыт пневматической заглушкой."
	if(panel_open)
		. += "<hr>"
		switch(security_level)
			if(AIRLOCK_SECURITY_NONE)
				. += "Провода видны!"
			if(AIRLOCK_SECURITY_METAL)
				. += "Провода закрыты металлическим щитком."
			if(AIRLOCK_SECURITY_PLASTEEL_I_S)
				. += "Куча кусков пластали внутри."
			if(AIRLOCK_SECURITY_PLASTEEL_I)
				. += "Провода закрыты листом пластали."
			if(AIRLOCK_SECURITY_PLASTEEL_O_S)
				. += "Куча кусков пластали внутри."
			if(AIRLOCK_SECURITY_PLASTEEL_O)
				. += "Провода закрыты листом пластали."
			if(AIRLOCK_SECURITY_PLASTEEL)
				. += "Здесь защитная сетка поверх панели."
	else if(security_level)
		if(security_level == AIRLOCK_SECURITY_METAL)
			. += "<hr>Выглядит достаточно крепким."
		else
			. += "<hr>Выглядит крепким."

	if(issilicon(user) && !(machine_stat & BROKEN))
		. += "<hr><span class='notice'>Shift-клик по [src], чтобы [ density ? "открыть" : "закрыть"] его.</span>\n"
		. += "<span class='notice'>Ctrl-клик по [src], чтобы [ locked ? "поднять" : "опустить"] его болты.</span>\n"
		. += "<span class='notice'>Alt-клик по [src], чтобы [ secondsElectrified ? "снять электризацию с н" : "электризовать "]его.</span>\n"
		. += "<span class='notice'>Ctrl-Shift-клик по [src], чтобы [ emergency ? "отключить" : "включить"] экстренный доступ.</span>"

/obj/machinery/door/airlock/attack_ai(mob/user)
	if(!canAIControl(user))
		if(canAIHack())
			hack(user)
			return
		else
			to_chat(user, "<span class='warning'>Управление шлюзом для ИИ заблокировано брандмауэром. Невозможно взломать.</span>")
	if(obj_flags & EMAGGED)
		to_chat(user, "<span class='warning'>Невозможно подключиться: Шлюз не отвечает.</span>")
		return
	if(detonated)
		to_chat(user, "<span class='warning'>Невозможно подключиться. Панель управления шлюзом повреждена.</span>")
		return

	ui_interact(user)

/obj/machinery/door/airlock/proc/hack(mob/user)
	set waitfor = 0
	if(!aiHacking)
		aiHacking = TRUE
		to_chat(user, "<span class='warning'>Управление шлюзом для ИИ заблокировано. Начато обнаружения неисправностей.</span>")
		sleep(50)
		if(canAIControl(user))
			to_chat(user, "<span class='notice'>Оповещение отменено. Управление шлюзом восстановлено без нашей помощи.</span>")
			aiHacking = FALSE
			return
		else if(!canAIHack())
			to_chat(user, "<span class='warning'>Соединение потеряно! Невозможно взломать шлюз.</span>")
			aiHacking = FALSE
			return
		to_chat(user, "<span class='notice'>Неисправность подтверждена: провод управления шлюзом отключен или оборван.</span>")
		sleep(20)
		to_chat(user, "<span class='notice'>Попытка взломать шлюз. Это может занять некоторое время.</span>")
		sleep(200)
		if(canAIControl(user))
			to_chat(user, "<span class='notice'>Оповещение отменено. Управление шлюзом восстановлено без нашей помощи.</span>")
			aiHacking = FALSE
			return
		else if(!canAIHack())
			to_chat(user, "<span class='warning'>Соединение потеряно! Невозможно взломать шлюз.</span>")
			aiHacking = FALSE
			return
		to_chat(user, "<span class='notice'>Доступ к загрузке подтвержден. Загрузка программы управления в программное обеспечение шлюза.</span>")
		sleep(170)
		if(canAIControl(user))
			to_chat(user, "<span class='notice'>Оповещение отменено. Управление шлюзом восстановлено без нашей помощи.</span>")
			aiHacking = FALSE
			return
		else if(!canAIHack())
			to_chat(user, "<span class='warning'>Соединение потеряно! Невозможно взломать шлюз.</span>")
			aiHacking = FALSE
			return
		to_chat(user, "<span class='notice'>Передача завершена. Принуждаем шлюз выполненить программу.</span>")
		sleep(50)
		//disable blocked control
		aiControlDisabled = AI_WIRE_HACKED
		to_chat(user, "<span class='notice'>Получение контрольной информации из шлюза.</span>")
		sleep(10)
		//bring up airlock dialog
		aiHacking = FALSE
		if(user)
			attack_ai(user)

/obj/machinery/door/airlock/attack_animal(mob/user)
	if(isElectrified() && shock(user, 100))
		return
	return ..()

/obj/machinery/door/airlock/attack_paw(mob/user)
	return attack_hand(user)

/obj/machinery/door/airlock/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(!(issilicon(user) || isAdminGhostAI(user)))
		if(isElectrified() && shock(user, 100))
			return

	if(ishuman(user) && prob(40) && density)
		var/mob/living/carbon/human/H = user
		if((HAS_TRAIT(H, TRAIT_DUMB)) && Adjacent(user))
			playsound(src, 'sound/effects/bang.ogg', 25, TRUE)
			if(!istype(H.head, /obj/item/clothing/head/helmet))
				H.visible_message("<span class='danger'>[user] быкует шлюз.</span>", \
									"<span class='userdanger'>Быкую шлюз!</span>")
				H.Paralyze(100)
				H.apply_damage(10, BRUTE, BODY_ZONE_HEAD)
			else
				visible_message("<span class='danger'>[user] быкует шлюз. Славно, что у н[user.ru_ego()] на голове шлем.</span>")

/obj/machinery/door/airlock/attempt_wire_interaction(mob/user)
	if(security_level)
		to_chat(user, "<span class='warning'>Провода защищены!</span>")
		return WIRE_INTERACTION_FAIL
	return ..()

/obj/machinery/door/airlock/proc/electrified_loop()
	while (secondsElectrified > MACHINE_NOT_ELECTRIFIED)
		sleep(10)
		if(QDELETED(src))
			return

		secondsElectrified--
		updateDialog()
	// This is to protect against changing to permanent, mid loop.
	if(secondsElectrified == MACHINE_NOT_ELECTRIFIED)
		set_electrified(MACHINE_NOT_ELECTRIFIED)
	else
		set_electrified(MACHINE_ELECTRIFIED_PERMANENT)
	updateDialog()

/obj/machinery/door/airlock/Topic(href, href_list, nowindow = 0)
	// If you add an if(..()) check you must first remove the var/nowindow parameter.
	// Otherwise it will runtime with this kind of error: null.Topic()
	if(!nowindow)
		..()
	if(!usr.canUseTopic(src) && !isAdminGhostAI(usr))
		return
	add_fingerprint(usr)

	if((in_range(src, usr) && isturf(loc)) && panel_open)
		usr.set_machine(src)

	add_fingerprint(usr)
	if(!nowindow)
		updateUsrDialog()
	else
		updateDialog()


/obj/machinery/door/airlock/attackby(obj/item/C, mob/user, params)
	if(!issilicon(user) && !isAdminGhostAI(user))
		if(isElectrified() && shock(user, 75))
			return
	add_fingerprint(user)

	if(panel_open)
		switch(security_level)
			if(AIRLOCK_SECURITY_NONE)
				if(istype(C, /obj/item/stack/sheet/metal))
					var/obj/item/stack/sheet/metal/S = C
					if(S.get_amount() < 2)
						to_chat(user, "<span class='warning'>Мне потребуется два листа металла для укрепления [src].</span>")
						return
					to_chat(user, "<span class='notice'>Начинает укреплять [src].</span>")
					if(do_after(user, 2 SECONDS, src))
						if(!panel_open || !S.use(2))
							return
						user.visible_message("<span class='notice'>[user] укрепляет [src] металлом.</span>",
											"<span class='notice'>Укрепляю [src] металлом.</span>")
						security_level = AIRLOCK_SECURITY_METAL
						update_icon()
					return
				else if(istype(C, /obj/item/stack/sheet/plasteel))
					var/obj/item/stack/sheet/plasteel/S = C
					if(S.get_amount() < 2)
						to_chat(user, "<span class='warning'>Мне потребуется два листа пластали для укрепления [src].</span>")
						return
					to_chat(user, "<span class='notice'>Начинает укреплять [src].</span>")
					if(do_after(user, 2 SECONDS, src))
						if(!panel_open || !S.use(2))
							return
						user.visible_message("<span class='notice'>[user] укрепляет [src] пласталью.</span>",
											"<span class='notice'>Укрепляю [src] пласталью.</span>")
						security_level = AIRLOCK_SECURITY_PLASTEEL
						modify_max_integrity(max_integrity * AIRLOCK_INTEGRITY_MULTIPLIER)
						damage_deflection = AIRLOCK_DAMAGE_DEFLECTION_R
						update_icon()
					return
			if(AIRLOCK_SECURITY_METAL)
				if(C.tool_behaviour == TOOL_WELDER)
					if(!C.tool_start_check(user, amount=2))
						return
					to_chat(user, "<span class='notice'>Начинаю разрезать экран панели...</span>")
					if(C.use_tool(src, user, 40, volume=50, amount = 2))
						if(!panel_open)
							return
						user.visible_message("<span class='notice'>[user] прорезается сквозь защитный экран [src].</span>",
										"<span class='notice'>Прорезаюсь сквозь защитный экран [src].</span>",
										"<span class='hear'>Слышу сварку.</span>")
						security_level = AIRLOCK_SECURITY_NONE
						spawn_atom_to_turf(/obj/item/stack/sheet/metal, user.loc, 2)
						update_icon()
					return
			if(AIRLOCK_SECURITY_PLASTEEL_I_S)
				if(C.tool_behaviour == TOOL_CROWBAR)
					var/obj/item/crowbar/W = C
					to_chat(user, "<span class='notice'>Начинаю снимать внутренний слой защиты...</span>")
					if(W.use_tool(src, user, 40, volume=100))
						if(!panel_open)
							return
						if(security_level != AIRLOCK_SECURITY_PLASTEEL_I_S)
							return
						user.visible_message("<span class='notice'>[user] снимает защитный экран [src].</span>",
											"<span class='notice'>Снимаю защитный экран [src].</span>")
						security_level = AIRLOCK_SECURITY_NONE
						modify_max_integrity(max_integrity / AIRLOCK_INTEGRITY_MULTIPLIER)
						damage_deflection = AIRLOCK_DAMAGE_DEFLECTION_N
						spawn_atom_to_turf(/obj/item/stack/sheet/plasteel, user.loc, 1)
						update_icon()
					return
			if(AIRLOCK_SECURITY_PLASTEEL_I)
				if(C.tool_behaviour == TOOL_WELDER)
					if(!C.tool_start_check(user, amount=2))
						return
					to_chat(user, "<span class='notice'>Начинаю резать внутренний слой защиты...</span>")
					if(C.use_tool(src, user, 40, volume=50, amount=2))
						if(!panel_open)
							return
						user.visible_message("<span class='notice'>[user] прорезается через защитный экран [src].</span>",
										"<span class='notice'>Прорезаюсь через защитный экран [src].</span>",
										"<span class='hear'>Слышу сварку.</span>")
						security_level = AIRLOCK_SECURITY_PLASTEEL_I_S
					return
			if(AIRLOCK_SECURITY_PLASTEEL_O_S)
				if(C.tool_behaviour == TOOL_CROWBAR)
					to_chat(user, "<span class='notice'>Начинаю снимать внешний слой защиты...</span>")
					if(C.use_tool(src, user, 40, volume=100))
						if(!panel_open)
							return
						if(security_level != AIRLOCK_SECURITY_PLASTEEL_O_S)
							return
						user.visible_message("<span class='notice'>[user] снимает защитный экран [src].</span>",
											"<span class='notice'>Снимаю защитный экран [src].</span>")
						security_level = AIRLOCK_SECURITY_PLASTEEL_I
						spawn_atom_to_turf(/obj/item/stack/sheet/plasteel, user.loc, 1)
					return
			if(AIRLOCK_SECURITY_PLASTEEL_O)
				if(C.tool_behaviour == TOOL_WELDER)
					if(!C.tool_start_check(user, amount=2))
						return
					to_chat(user, "<span class='notice'>Начинаю вырезать внешний слой защиты...</span>")
					if(C.use_tool(src, user, 40, volume=50, amount=2))
						if(!panel_open)
							return
						user.visible_message("<span class='notice'>[user] прорезается сквозь защитный экран [src].</span>",
										"<span class='notice'>Прорезаюсь сквозь защитный экран [src].</span>",
										"<span class='hear'>Слышу сварку.</span>")
						security_level = AIRLOCK_SECURITY_PLASTEEL_O_S
					return
			if(AIRLOCK_SECURITY_PLASTEEL)
				if(C.tool_behaviour == TOOL_WIRECUTTER)
					if(hasPower() && shock(user, 60)) // Protective grille of wiring is electrified
						return
					to_chat(user, "<span class='notice'>Начинаю прорезать внешнюю решетку.</span>")
					if(C.use_tool(src, user, 10, volume=100))
						if(!panel_open)
							return
						user.visible_message("<span class='notice'>[user] прорезает внешнюю защитную решётку [src].</span>",
											"<span class='notice'>Прорезаю внешнюю защитную решётку [src].</span>")
						security_level = AIRLOCK_SECURITY_PLASTEEL_O
					return
	if(C.tool_behaviour == TOOL_SCREWDRIVER)
		if(panel_open && detonated)
			to_chat(user, "<span class='warning'>[capitalize(src.name)] не имеет панели, собственно!</span>")
			return
		panel_open = !panel_open
		to_chat(user, "<span class='notice'>[panel_open ? "Открываю":"Закрываю"] техническую панель шлюза.</span>")
		C.play_tool_sound(src)
		update_icon()
	else if((C.tool_behaviour == TOOL_WIRECUTTER) && note)
		user.visible_message("<span class='notice'>[user] срезает [note] с [src].</span>", "<span class='notice'>Срезаю [note] с [src].</span>")
		C.play_tool_sound(src)
		note.forceMove(get_turf(user))
		note = null
		update_icon()
	else if(is_wire_tool(C) && panel_open)
		attempt_wire_interaction(user)
		return
	else if(istype(C, /obj/item/pai_cable))
		var/obj/item/pai_cable/cable = C
		cable.plugin(src, user)
	else if(istype(C, /obj/item/airlock_painter))
		change_paintjob(C, user)
	else if(istype(C, /obj/item/door_seal)) //adding the seal
		var/obj/item/door_seal/airlockseal = C
		if(!density)
			to_chat(user, "<span class='warning'>[capitalize(src.name)] должен быть закрыт, прежде чем запечатывать его!</span>")
			return
		if(seal)
			to_chat(user, "<span class='warning'>[capitalize(src.name)] уже запечатан!</span>")
			return
		user.visible_message("<span class='notice'>[user] начинает запечатывать [src].</span>", "<span class='notice'>Начинаю запечатывать [src].</span>")
		playsound(src, 'sound/items/jaws_pry.ogg', 30, TRUE)
		if(!do_after(user, airlockseal.seal_time, target = src))
			return
		if(!density)
			to_chat(user, "<span class='warning'>[capitalize(src.name)] должен быть закрыт, прежде чем запечатывать его!</span>")
			return
		if(seal)
			to_chat(user, "<span class='warning'>[capitalize(src.name)] уже запечатан!</span>")
			return
		if(!user.transferItemToLoc(airlockseal, src))
			to_chat(user, "<span class='warning'>Не могу запечатать [airlockseal]!</span>")
			return
		playsound(src, 'sound/machines/airlockforced.ogg', 30, TRUE)
		user.visible_message("<span class='notice'>[user] запечатывает [src].</span>", "<span class='notice'>Запечатываю [src].</span>")
		seal = airlockseal
		modify_max_integrity(max_integrity * AIRLOCK_SEAL_MULTIPLIER)
		update_icon()

	else if(istype(C, /obj/item/paper) || istype(C, /obj/item/photo))
		if(note)
			to_chat(user, "<span class='warning'>Здесь уже что-то приделано. Кусачками можно снять эту дрянь.</span>")
			return
		if(!user.transferItemToLoc(C, src))
			to_chat(user, "<span class='warning'>Не могу прикрепить [C]!</span>")
			return
		user.visible_message("<span class='notice'>[user] прикрепляет [C] к [src].</span>", "<span class='notice'>Прикрепляю [C] к [src].</span>")
		note = C
		update_icon()
	else
		return ..()


/obj/machinery/door/airlock/try_to_weld(obj/item/weldingtool/W, mob/user)
	if(!operating && density)
		if(seal)
			to_chat(user, "<span class='warning'>[capitalize(src.name)] запечатан!</span>")
			return
		if(user.a_intent != INTENT_HELP)
			if(!W.tool_start_check(user, amount=0))
				return
			user.visible_message("<span class='notice'>[user] начинает [welded ? "разваривать":"заваривать"] шлюз.</span>", \
							"<span class='notice'>Начинаю [welded ? "разваривать":"заваривать"] шлюз...</span>", \
							"<span class='hear'>Слышу сварку.</span>")
			if(W.use_tool(src, user, 40, volume=50, extra_checks = CALLBACK(src, .proc/weld_checks, W, user)))
				welded = !welded
				user.visible_message("<span class='notice'>[user] [welded? "заваривает":"разваривает"] [src].</span>", \
									"<span class='notice'>[welded ? "Завариваю":"Развариваю"] шлюз.</span>")
				log_game("[key_name(user)] [welded ? "welded":"unwelded"] airlock [src] with [W] at [AREACOORD(src)]")
				update_icon()
		else
			if(obj_integrity < max_integrity)
				if(!W.tool_start_check(user, amount=0))
					return
				user.visible_message("<span class='notice'>[user] начинает заваривать шлюз.</span>", \
								"<span class='notice'>Начинаю чинить шлюз...</span>", \
								"<span class='hear'>Слышу сварку.</span>")
				if(W.use_tool(src, user, 40, volume=50, extra_checks = CALLBACK(src, .proc/weld_checks, W, user)))
					obj_integrity = max_integrity
					set_machine_stat(machine_stat & ~BROKEN)
					user.visible_message("<span class='notice'>[user] заканчивает варить шлюз [src].</span>", \
										"<span class='notice'>Ремонт шлюза окончен.</span>")
					update_icon()
			else
				to_chat(user, "<span class='notice'>Шлюз не требует починки.</span>")

/obj/machinery/door/airlock/proc/weld_checks(obj/item/weldingtool/W, mob/user)
	return !operating && density

/**
 * Used when attempting to remove a seal from an airlock
 *
 * Called when attacking an airlock with an empty hand, returns TRUE (there was a seal and we removed it, or failed to remove it)
 * or FALSE (there was no seal)
 * Arguments:
 * * user - Whoever is attempting to remove the seal
 */
/obj/machinery/door/airlock/try_remove_seal(mob/living/user)
	if(!seal)
		return FALSE
	var/obj/item/door_seal/airlockseal = seal
	if(!ishuman(user))
		to_chat(user, text("<span class='warning'>У меня не хватает ловкости для снятия печати!</span>"))
		return TRUE
	user.visible_message("<span class='notice'>[user] начинает распечатывать [src].</span>", "<span class='notice'>Начинаю снимать пневматическую заглушку [src].</span>")
	playsound(src, 'sound/machines/airlockforced.ogg', 30, TRUE)
	if(!do_after(user, airlockseal.unseal_time, target = src))
		return TRUE
	if(!seal)
		return TRUE
	playsound(src, 'sound/items/jaws_pry.ogg', 30, TRUE)
	airlockseal.forceMove(get_turf(user))
	user.visible_message("<span class='notice'>[user] распечатывает [src].</span>", "<span class='notice'>Успешно снимаю пневматическую заглушку [src].</span>")
	seal = null
	modify_max_integrity(max_integrity / AIRLOCK_SEAL_MULTIPLIER)
	update_icon()
	return TRUE


/obj/machinery/door/airlock/try_to_crowbar(obj/item/I, mob/living/user, forced = FALSE)
	if(I)
		var/beingcrowbarred = (I.tool_behaviour == TOOL_CROWBAR)
		if(!security_level && (beingcrowbarred && panel_open && ((obj_flags & EMAGGED) || (density && welded && !operating && !hasPower() && !locked))))
			user.visible_message("<span class='notice'>[user] начинает извлекать плату из шлюза.</span>", \
				"<span class='notice'>Начинаю извлкать плату из шлюза...</span>")
			if(I.use_tool(src, user, 40, volume=100))
				deconstruct(TRUE, user)
				return
	if(seal)
		to_chat(user, "<span class='warning'>Нужно снять заглушку сначала!</span>")
		return
	if(locked)
		to_chat(user, "<span class='warning'>Шлюз не даёт себя открыть!</span>")
		return
	if(welded)
		to_chat(user, "<span class='warning'>Шлюз заварен и не поддаётся!</span>")
		return
	if(hasPower())
		if(forced)
			var/check_electrified = isElectrified() //setting this so we can check if the mob got shocked during the do_after below
			if(check_electrified && shock(user,100))
				return //it's like sticking a fork in a power socket

			if(!density)//already open
				return

			if(!prying_so_hard)
				var/time_to_open = 50
				playsound(src, 'sound/machines/airlock_alien_prying.ogg', 100, TRUE) //is it aliens or just the CE being a dick?
				prying_so_hard = TRUE
				if(do_after(user, time_to_open, src))
					if(check_electrified && shock(user,100))
						prying_so_hard = FALSE
						return
					open(2)
					take_damage(25, BRUTE, 0, 0) // Enough to sometimes spark
					if(density && !open(2))
						to_chat(user, "<span class='warning'>Несмотря на мои попытки, [src] отказывается открываться.</span>")
				prying_so_hard = FALSE
				return
		to_chat(user, "<span class='warning'>Мотор шлюза сопротивляется!</span>")
		return

	if(!operating)
		if(istype(I, /obj/item/fireaxe)) //being fireaxe'd
			var/obj/item/fireaxe/axe = I
			if(axe && !axe.wielded)
				to_chat(user, "<span class='warning'>Требуется держать [axe] в обеих руках для этого!</span>")
				return
		INVOKE_ASYNC(src, (density ? .proc/open : .proc/close), 2)


/obj/machinery/door/airlock/open(forced=0)
	if( operating || welded || locked || seal )
		return FALSE
	if(!forced)
		if(!hasPower() || wires.is_cut(WIRE_OPEN))
			return FALSE
	if(forced < 2)
		if(obj_flags & EMAGGED)
			return FALSE
		use_power(50)
		playsound(src, doorOpen, 30, TRUE)

		if(closeOther != null && istype(closeOther, /obj/machinery/door/airlock/) && !closeOther.density)
			closeOther.close()
	else
		playsound(src, 'sound/machines/airlockforced.ogg', 30, TRUE)

	if(autoclose)
		autoclose_in(normalspeed ? 150 : 15)

	if(!density)
		return TRUE
	SEND_SIGNAL(src, COMSIG_AIRLOCK_OPEN, forced)
	operating = TRUE
	update_icon(AIRLOCK_OPENING, 1)
	sleep(1)
	set_opacity(0)
	update_freelook_sight()
	sleep(4)
	density = FALSE
	flags_1 &= ~PREVENT_CLICK_UNDER_1
	air_update_turf(TRUE, FALSE)
	sleep(1)
	layer = OPEN_DOOR_LAYER
	update_icon(AIRLOCK_OPEN, 1)
	operating = FALSE
	if(delayed_close_requested)
		delayed_close_requested = FALSE
		addtimer(CALLBACK(src, .proc/close), 1)
	return TRUE


/obj/machinery/door/airlock/close(forced = FALSE, force_crush = FALSE)
	if(operating || welded || locked || seal)
		return
	if(density)
		return TRUE
	if(!forced)
		if(!hasPower() || wires.is_cut(WIRE_BOLTS))
			return

	var/dangerous_close = !safe || force_crush
	if(!dangerous_close)
		for(var/atom/movable/M in get_turf(src))
			if(M.density && M != src) //something is blocking the door
				autoclose_in(DOOR_CLOSE_WAIT)
				return
	if(forced < 2)
		if(obj_flags & EMAGGED)
			return
		use_power(50)
		playsound(src, doorClose, 30, TRUE)

	else
		playsound(src, 'sound/machines/airlockforced.ogg', 30, TRUE)

	var/obj/structure/window/killthis = (locate(/obj/structure/window) in get_turf(src))
	if(killthis)
		SSexplosions.med_mov_atom += killthis
	SEND_SIGNAL(src, COMSIG_AIRLOCK_CLOSE, forced)
	operating = TRUE
	update_icon(AIRLOCK_CLOSING, 1)
	layer = CLOSED_DOOR_LAYER
	if(air_tight)
		density = TRUE
		flags_1 |= PREVENT_CLICK_UNDER_1
		air_update_turf(TRUE, TRUE)
	sleep(1)
	if(!air_tight)
		density = TRUE
		flags_1 |= PREVENT_CLICK_UNDER_1
		air_update_turf(TRUE, TRUE)
	sleep(4)
	if(dangerous_close)
		crush()
	if(visible && !glass)
		set_opacity(1)
	update_freelook_sight()
	sleep(1)
	update_icon(AIRLOCK_CLOSED, 1)
	operating = FALSE
	delayed_close_requested = FALSE
	if(!dangerous_close)
		CheckForMobs()
	return TRUE

/obj/machinery/door/airlock/proc/prison_open()
	if(obj_flags & EMAGGED)
		return
	locked = FALSE
	open()
	locked = TRUE
	return

// gets called when a player uses an airlock painter on this airlock
/obj/machinery/door/airlock/proc/change_paintjob(obj/item/airlock_painter/painter, mob/user)
	if((!in_range(src, user) && loc != user) || !painter.can_use(user)) // user should be adjacent to the airlock, and the painter should have a toner cartridge that isn't empty
		return

	// reads from the airlock painter's `available paintjob` list. lets the player choose a paint option, or cancel painting
	var/current_paintjob = input(user, "Выбираем будущий образ шлюза.") as null|anything in sortList(painter.available_paint_jobs)
	if(!current_paintjob) // if the user clicked cancel on the popup, return
		return

	var/airlock_type = painter.available_paint_jobs["[current_paintjob]"] // get the airlock type path associated with the airlock name the user just chose
	var/obj/machinery/door/airlock/airlock = airlock_type // we need to create a new instance of the airlock and assembly to read vars from them
	var/obj/structure/door_assembly/assembly = initial(airlock.assemblytype)

	if(airlock_material == "glass" && initial(assembly.noglass)) // prevents painting glass airlocks with a paint job that doesn't have a glass version, such as the freezer
		to_chat(user, "<span class='warning'>Этот тип может быть использован только на обычных шлюзах.</span>")
		return

	// applies the user-chosen airlock's icon, overlays and assemblytype to the src airlock
	painter.use_paint(user)
	icon = initial(airlock.icon)
	overlays_file = initial(airlock.overlays_file)
	assemblytype = initial(airlock.assemblytype)
	update_icon()

/obj/machinery/door/airlock/CanAStarPass(obj/item/card/id/ID)
//Airlock is passable if it is open (!density), bot has access, and is not bolted shut or powered off)
	return !density || (check_access(ID) && !locked && hasPower())

/obj/machinery/door/airlock/emag_act(mob/user, obj/item/card/emag/doorjack/D)
	if(!operating && density && hasPower() && !(obj_flags & EMAGGED))
		if(istype(D, /obj/item/card/emag/doorjack))
			D.use_charge(user)
		operating = TRUE
		update_icon(AIRLOCK_EMAG, 1)
		sleep(6)
		if(QDELETED(src))
			return
		operating = FALSE
		if(!open())
			update_icon(AIRLOCK_CLOSED, 1)
		obj_flags |= EMAGGED
		lights = FALSE
		locked = TRUE
		loseMainPower()
		loseBackupPower()

/obj/machinery/door/airlock/attack_alien(mob/living/carbon/alien/humanoid/user)
	if(isElectrified() && shock(user, 100)) //Mmm, fried xeno!
		add_fingerprint(user)
		return
	if(!density) //Already open
		return ..()
	if(locked || welded || seal) //Extremely generic, as aliens only understand the basics of how airlocks work.
		if(user.a_intent == INTENT_HARM)
			return ..()
		to_chat(user, "<span class='warning'>[capitalize(src.name)] отказывается открываться!</span>")
		return
	add_fingerprint(user)
	user.visible_message("<span class='warning'>[user] начинает открывать [src].</span>",\
						"<span class='noticealien'>Впиваюсь своими когтями в [src] со всей своей мощью!</span>",\
						"<span class='warning'>Слышу рёв метала...</span>")
	var/time_to_open = 5 //half a second
	if(hasPower())
		time_to_open = 5 SECONDS //Powered airlocks take longer to open, and are loud.
		playsound(src, 'sound/machines/airlock_alien_prying.ogg', 100, TRUE)


	if(do_after(user, time_to_open, src))
		if(density && !open(2)) //The airlock is still closed, but something prevented it opening. (Another player noticed and bolted/welded the airlock in time!)
			to_chat(user, "<span class='warning'>Несмотря на мои старания, [src] умудряется сопротивиться открытию!</span>")

/obj/machinery/door/airlock/hostile_lockdown(mob/origin)
	// Must be powered and have working AI wire.
	if(canAIControl(src) && !machine_stat)
		locked = FALSE //For airlocks that were bolted open.
		safe = FALSE //DOOR CRUSH
		close()
		bolt() //Bolt it!
		set_electrified(MACHINE_ELECTRIFIED_PERMANENT)  //Shock it!
		if(origin)
			LAZYADD(shockedby, "\[[time_stamp()]\] [key_name(origin)]")


/obj/machinery/door/airlock/disable_lockdown()
	// Must be powered and have working AI wire.
	if(canAIControl(src) && !machine_stat)
		unbolt()
		set_electrified(MACHINE_NOT_ELECTRIFIED)
		open()
		safe = TRUE


/obj/machinery/door/airlock/proc/on_break()
	SIGNAL_HANDLER

	if(!panel_open)
		panel_open = TRUE
	wires.cut_all()

/obj/machinery/door/airlock/proc/set_electrified(seconds, mob/user)
	secondsElectrified = seconds
	diag_hud_set_electrified()
	if(secondsElectrified > MACHINE_NOT_ELECTRIFIED)
		INVOKE_ASYNC(src, .proc/electrified_loop)

	if(user)
		var/message
		switch(secondsElectrified)
			if(MACHINE_ELECTRIFIED_PERMANENT)
				message = "permanently shocked"
			if(MACHINE_NOT_ELECTRIFIED)
				message = "unshocked"
			else
				message = "temp shocked for [secondsElectrified] seconds"
		LAZYADD(shockedby, text("\[[time_stamp()]\] [key_name(user)] - ([uppertext(message)])"))
		log_combat(user, src, message)
		add_hiddenprint(user)

/obj/machinery/door/airlock/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	if((damage_amount >= obj_integrity) && (damage_flag == BOMB))
		flags_1 |= NODECONSTRUCT_1  //If an explosive took us out, don't drop the assembly
	. = ..()
	if(obj_integrity < (0.75 * max_integrity))
		update_icon()


/obj/machinery/door/airlock/deconstruct(disassembled = TRUE, mob/user)
	if(!(flags_1 & NODECONSTRUCT_1))
		var/obj/structure/door_assembly/A
		if(assemblytype)
			A = new assemblytype(loc)
		else
			A = new /obj/structure/door_assembly(loc)
			//If you come across a null assemblytype, it will produce the default assembly instead of disintegrating.
		A.heat_proof_finished = heat_proof //tracks whether there's rglass in
		A.set_anchored(TRUE)
		A.glass = glass
		A.state = AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS
		A.created_name = name
		A.previous_assembly = previous_airlock
		A.update_name()
		A.update_icon()

		if(!disassembled)
			if(A)
				A.obj_integrity = A.max_integrity * 0.5
		else if(obj_flags & EMAGGED)
			if(user)
				to_chat(user, "<span class='warning'>Вырываю остатки платы из шлюза.</span>")
		else
			if(user)
				to_chat(user, "<span class='notice'>Извлекаю плату из шлюза.</span>")

			var/obj/item/electronics/airlock/ae
			if(!electronics)
				ae = new/obj/item/electronics/airlock(loc)
				gen_access()
				if(req_one_access.len)
					ae.one_access = 1
					ae.accesses = req_one_access
				else
					ae.accesses = req_access
			else
				ae = electronics
				electronics = null
				ae.forceMove(drop_location())
	qdel(src)

/obj/machinery/door/airlock/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	switch(the_rcd.mode)
		if(RCD_DECONSTRUCT)
			if(seal)
				to_chat(user, "<span class='notice'>Печать [src] должна быть снята.</span>")
				return FALSE
			if(security_level != AIRLOCK_SECURITY_NONE)
				to_chat(user, "<span class='notice'>Укрепления [src] должны быть удалены для продолжения.</span>")
				return FALSE
			return list("mode" = RCD_DECONSTRUCT, "delay" = 50, "cost" = 32)
	return FALSE

/obj/machinery/door/airlock/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_DECONSTRUCT)
			to_chat(user, "<span class='notice'>Разбираю шлюз.</span>")
			qdel(src)
			return TRUE
	return FALSE

/obj/machinery/door/airlock/proc/note_type() //Returns a string representing the type of note pinned to this airlock
	if(!note)
		return
	else if(istype(note, /obj/item/paper))
		return "note"
	else if(istype(note, /obj/item/photo))
		return "photo"

/obj/machinery/door/airlock/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AiAirlock", name)
		ui.open()
	return TRUE

/obj/machinery/door/airlock/ui_data()
	var/list/data = list()

	var/list/power = list()
	power["main"] = secondsMainPowerLost ? 0 : 2 // boolean
	power["main_timeleft"] = secondsMainPowerLost
	power["backup"] = secondsBackupPowerLost ? 0 : 2 // boolean
	power["backup_timeleft"] = secondsBackupPowerLost
	data["power"] = power

	data["shock"] = secondsElectrified == MACHINE_NOT_ELECTRIFIED ? 2 : 0
	data["shock_timeleft"] = secondsElectrified
	data["id_scanner"] = !aiDisabledIdScanner
	data["emergency"] = emergency // access
	data["locked"] = locked // bolted
	data["lights"] = lights // bolt lights
	data["safe"] = safe // safeties
	data["speed"] = normalspeed // safe speed
	data["welded"] = welded // welded
	data["opened"] = !density // opened

	var/list/wire = list()
	wire["main_1"] = !wires.is_cut(WIRE_POWER1)
	wire["main_2"] = !wires.is_cut(WIRE_POWER2)
	wire["backup_1"] = !wires.is_cut(WIRE_BACKUP1)
	wire["backup_2"] = !wires.is_cut(WIRE_BACKUP2)
	wire["shock"] = !wires.is_cut(WIRE_SHOCK)
	wire["id_scanner"] = !wires.is_cut(WIRE_IDSCAN)
	wire["bolts"] = !wires.is_cut(WIRE_BOLTS)
	wire["lights"] = !wires.is_cut(WIRE_LIGHT)
	wire["safe"] = !wires.is_cut(WIRE_SAFETY)
	wire["timing"] = !wires.is_cut(WIRE_TIMING)

	data["wires"] = wire
	return data

/obj/machinery/door/airlock/ui_act(action, params)
	. = ..()
	if(.)
		return

	if(!user_allowed(usr))
		return
	switch(action)
		if("disrupt-main")
			if(!secondsMainPowerLost)
				loseMainPower()
				update_icon()
			else
				to_chat(usr, "<span class='warning'>Основное питание уже отключено.</span>")
			. = TRUE
		if("disrupt-backup")
			if(!secondsBackupPowerLost)
				loseBackupPower()
				update_icon()
			else
				to_chat(usr, "<span class='warning'>Запасное питание уже отключено.</span>")
			. = TRUE
		if("shock-restore")
			shock_restore(usr)
			. = TRUE
		if("shock-temp")
			shock_temp(usr)
			. = TRUE
		if("shock-perm")
			shock_perm(usr)
			. = TRUE
		if("idscan-toggle")
			aiDisabledIdScanner = !aiDisabledIdScanner
			. = TRUE
		if("emergency-toggle")
			toggle_emergency(usr)
			. = TRUE
		if("bolt-toggle")
			toggle_bolt(usr)
			. = TRUE
		if("light-toggle")
			lights = !lights
			update_icon()
			. = TRUE
		if("safe-toggle")
			safe = !safe
			. = TRUE
		if("speed-toggle")
			normalspeed = !normalspeed
			. = TRUE
		if("open-close")
			user_toggle_open(usr)
			. = TRUE

/obj/machinery/door/airlock/proc/user_allowed(mob/user)
	return (issilicon(user) && canAIControl(user)) || isAdminGhostAI(user)

/obj/machinery/door/airlock/proc/shock_restore(mob/user)
	if(!user_allowed(user))
		return
	if(wires.is_cut(WIRE_SHOCK))
		to_chat(user, "<span class='warning'>Невозможно снять электризацию с шлюза. Провод обрезан.</span>")
	else if(isElectrified())
		set_electrified(MACHINE_NOT_ELECTRIFIED, user)

/obj/machinery/door/airlock/proc/shock_temp(mob/user)
	if(!user_allowed(user))
		return
	if(wires.is_cut(WIRE_SHOCK))
		to_chat(user, "<span class='warning'>Провод электризации обрезан.</span>")
	else
		set_electrified(MACHINE_DEFAULT_ELECTRIFY_TIME, user)

/obj/machinery/door/airlock/proc/shock_perm(mob/user)
	if(!user_allowed(user))
		return
	if(wires.is_cut(WIRE_SHOCK))
		to_chat(user, "<span class='warning'>Провод электризации обрезан.</span>")
	else
		set_electrified(MACHINE_ELECTRIFIED_PERMANENT, user)

/obj/machinery/door/airlock/proc/toggle_bolt(mob/user)
	if(!user_allowed(user))
		return
	if(wires.is_cut(WIRE_BOLTS))
		to_chat(user, "<span class='warning'>Провода обрезаны, болты упали. Невозможно поднять болты.</span>")
		return
	if(locked)
		if(!hasPower())
			to_chat(user, "<span class='warning'>Шлюз не имеет питания. Отказ в поднятии болтов.</span>")
		else
			unbolt()
			log_combat(user, src, "unbolted")
	else
		bolt()
		log_combat(user, src, "bolted")

/obj/machinery/door/airlock/proc/toggle_emergency(mob/user)
	if(!user_allowed(user))
		return
	emergency = !emergency
	update_icon()

/obj/machinery/door/airlock/proc/user_toggle_open(mob/user)
	if(!user_allowed(user))
		return
	if(welded)
		to_chat(user, text("<span class='warning'>Шлюз заварен намертво!</span>"))
	else if(locked)
		to_chat(user, text("<span class='warning'>Болты шлюза упали!</span>"))
	else if(!density)
		close()
	else
		open()

/**
 *	Generates the airlock's wire layout based on the current area the airlock resides in.
 *
 * Returns a new /datum/wires/ with the appropriate wire layout based on the airlock_wires
 * of the area the airlock is in.
 */
/obj/machinery/door/airlock/proc/set_wires()
	var/area/source_area = get_area(src)
	return source_area?.airlock_wires ? new source_area.airlock_wires(src) : new /datum/wires/airlock(src)

#undef AIRLOCK_CLOSED
#undef AIRLOCK_CLOSING
#undef AIRLOCK_OPEN
#undef AIRLOCK_OPENING
#undef AIRLOCK_DENY
#undef AIRLOCK_EMAG

#undef AIRLOCK_SECURITY_NONE
#undef AIRLOCK_SECURITY_METAL
#undef AIRLOCK_SECURITY_PLASTEEL_I_S
#undef AIRLOCK_SECURITY_PLASTEEL_I
#undef AIRLOCK_SECURITY_PLASTEEL_O_S
#undef AIRLOCK_SECURITY_PLASTEEL_O
#undef AIRLOCK_SECURITY_PLASTEEL

#undef AIRLOCK_INTEGRITY_N
#undef AIRLOCK_INTEGRITY_MULTIPLIER
#undef AIRLOCK_SEAL_MULTIPLIER
#undef AIRLOCK_DAMAGE_DEFLECTION_N
#undef AIRLOCK_DAMAGE_DEFLECTION_R

#undef AIRLOCK_DENY_ANIMATION_TIME

#undef DOOR_CLOSE_WAIT

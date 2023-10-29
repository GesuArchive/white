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
/proc/get_airlock_overlay(icon_state, icon_file, atom/offset_spokesman, em_block)
	var/static/list/airlock_overlays = list()

	var/base_icon_key = "[icon_state][REF(icon_file)]"
	if(!(. = airlock_overlays[base_icon_key]))
		. = airlock_overlays[base_icon_key] = mutable_appearance(icon_file, icon_state)
	if(isnull(em_block))
		return

	var/turf/our_turf = get_turf(offset_spokesman)

	var/em_block_key = "[base_icon_key][em_block][GET_TURF_PLANE_OFFSET(our_turf)]"
	var/mutable_appearance/em_blocker = airlock_overlays[em_block_key]
	if(!em_blocker)
		em_blocker = airlock_overlays[em_block_key] = mutable_appearance(icon_file, icon_state, offset_spokesman = offset_spokesman, plane = EMISSIVE_PLANE, appearance_flags = EMISSIVE_APPEARANCE_FLAGS)
		em_blocker.color = em_block ? GLOB.em_block_color : GLOB.emissive_color

	return list(., em_blocker)

// Before you say this is a bad implmentation, look at what it was before then ask yourself
// "Would this be better with a global var"

// Wires for the airlock are located in the datum folder, inside the wires datum folder.

#define AIRLOCK_CLOSED	1
#define AIRLOCK_CLOSING	2
#define AIRLOCK_OPEN	3
#define AIRLOCK_OPENING	4
#define AIRLOCK_DENY	5
#define AIRLOCK_EMAG	6

#define AIRLOCK_FRAME_CLOSED "closed"
#define AIRLOCK_FRAME_CLOSING "closing"
#define AIRLOCK_FRAME_OPEN "open"
#define AIRLOCK_FRAME_OPENING "opening"

#define AIRLOCK_LIGHT_BOLTS "bolts"
#define AIRLOCK_LIGHT_EMERGENCY "emergency"
#define AIRLOCK_LIGHT_DENIED "denied"
#define AIRLOCK_LIGHT_CLOSING "closing"
#define AIRLOCK_LIGHT_OPENING "opening"

#define AIRLOCK_SECURITY_NONE			0 //Normal airlock				//Wires are not secured
#define AIRLOCK_SECURITY_IRON			1 //Medium security airlock		//There is a simple iron plate over wires (use welder)
#define AIRLOCK_SECURITY_PLASTEEL_I_S	2 								//Sliced inner plating (use crowbar), jumps to 0
#define AIRLOCK_SECURITY_PLASTEEL_I		3 								//Removed outer plating, second layer here (use welder)
#define AIRLOCK_SECURITY_PLASTEEL_O_S	4 								//Sliced outer plating (use crowbar)
#define AIRLOCK_SECURITY_PLASTEEL_O		5 								//There is first layer of plasteel (use welder)
#define AIRLOCK_SECURITY_PLASTEEL		6 //Max security airlock		//Fully secured wires (use wirecutters to remove grille, that is electrified)

#define AIRLOCK_INTEGRITY_N			 300 // Normal airlock integrity
#define AIRLOCK_INTEGRITY_MULTIPLIER 1.5 // How much reinforced doors health increases
/// How much extra health airlocks get when braced with a seal
#define AIRLOCK_SEAL_MULTIPLIER		 3
#define AIRLOCK_SEAL_ARMOR_MULT		 2
#define AIRLOCK_DAMAGE_DEFLECTION_N  21  // Normal airlock damage deflection
#define AIRLOCK_DAMAGE_DEFLECTION_R  42  // Reinforced airlock damage deflection

#define AIRLOCK_DENY_ANIMATION_TIME (0.6 SECONDS) /// The amount of time for the airlock deny animation to show

#define DOOR_CLOSE_WAIT 60 /// Time before a door closes, if not overridden

#define DOOR_VISION_DISTANCE 11 ///The maximum distance a door will see out to

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
	var/list/obj/machinery/door/airlock/close_others = list()
	var/obj/item/electronics/airlock/electronics
	COOLDOWN_DECLARE(shockCooldown)
	var/obj/item/note //Any papers pinned to the airlock
	/// The seal on the airlock
	var/obj/item/seal
	var/seal_sb_block = FALSE	// Шлюз заблокирован замком СБ с активированной блокировкой
	var/req_one_access_old = null // Старые параметры доступа при установке блока
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

	flags_1 = RAD_PROTECT_CONTENTS_1 | RAD_NO_CONTAMINATE_1 | HTML_USE_INITAL_ICON_1
	rad_insulation = RAD_MEDIUM_INSULATION

/obj/machinery/door/airlock/Initialize(mapload)
	. = ..()
	init_network_id(NETWORK_DOOR_AIRLOCKS)
	wires = set_wires()
	if(frequency)
		set_frequency(frequency)
	if(glass)
		airlock_material = "glass"
	if(security_level > AIRLOCK_SECURITY_IRON)
		obj_integrity = normal_integrity * AIRLOCK_INTEGRITY_MULTIPLIER
		max_integrity = normal_integrity * AIRLOCK_INTEGRITY_MULTIPLIER
	else
		obj_integrity = normal_integrity
		max_integrity = normal_integrity
	if(damage_deflection == AIRLOCK_DAMAGE_DEFLECTION_N && security_level > AIRLOCK_SECURITY_IRON)
		damage_deflection = AIRLOCK_DAMAGE_DEFLECTION_R

	prepare_huds()
	for(var/datum/atom_hud/data/diagnostic/diag_hud in GLOB.huds)
		diag_hud.add_atom_to_hud(src)

	diag_hud_set_electrified()

	RegisterSignal(src, COMSIG_MACHINERY_BROKEN, PROC_REF(on_break))
	RegisterSignal(src, COMSIG_COMPONENT_NTNET_RECEIVE, PROC_REF(ntnet_receive))

	// Click on the floor to close airlocks
	var/static/list/connections = list(
		COMSIG_ATOM_ATTACK_HAND = PROC_REF(on_attack_hand)
	)
	AddElement(/datum/element/connect_loc, connections)

	return INITIALIZE_HINT_LATELOAD

/obj/machinery/door/airlock/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock)
	if(id_tag)
		id_tag = "[port.id]_[id_tag]"

/obj/machinery/door/airlock/proc/update_other_id()
	for(var/obj/machinery/door/airlock/Airlock in GLOB.airlocks)
		if(Airlock.closeOtherId == closeOtherId && Airlock != src)
			if(!(Airlock in close_others))
				close_others += Airlock
			if(!(src in Airlock.close_others))
				Airlock.close_others += src

/obj/machinery/door/airlock/proc/cyclelinkairlock()
	if (cyclelinkedairlock)
		cyclelinkedairlock.cyclelinkedairlock = null
		cyclelinkedairlock = null
	if (!cyclelinkeddir)
		return
	var/limit = DOOR_VISION_DISTANCE
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
				INVOKE_ASYNC(src, PROC_REF(open))
			else
				INVOKE_ASYNC(src, PROC_REF(close))

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
			update_appearance()

		if("shock")

			if(isElectrified())
				set_electrified(MACHINE_NOT_ELECTRIFIED)
			else
				set_electrified(MACHINE_DEFAULT_ELECTRIFY_TIME)

/obj/machinery/door/airlock/lock()
	bolt()

/obj/machinery/door/airlock/proc/bolt()
	if(locked)
		return
	set_bolt(TRUE)
	playsound(src,boltDown,30,FALSE,3)
	audible_message(span_hear("Слышу щелчок снизу шлюза.") , null,  1)
	update_appearance()

/obj/machinery/door/airlock/proc/set_bolt(should_bolt)
	if(locked == should_bolt)
		return
	SEND_SIGNAL(src, COMSIG_AIRLOCK_SET_BOLT, should_bolt)
	. = locked
	locked = should_bolt

/obj/machinery/door/airlock/unlock()
	unbolt()

/obj/machinery/door/airlock/proc/unbolt()
	if(!locked)
		return
	set_bolt(FALSE)
	playsound(src,boltUp,30,FALSE,3)
	audible_message(span_hear("Слышу щелчок снизу шлюза.") , null,  1)
	update_appearance()

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

/obj/machinery/door/airlock/ratvar_act() //Airlocks become pinion airlocks that only allow servants
	var/obj/machinery/door/airlock/clockwork/A
	if(glass)
		A = new/obj/machinery/door/airlock/clockwork/glass(get_turf(src))
	else
		A = new/obj/machinery/door/airlock/clockwork(get_turf(src))
	A.name = name
	qdel(src)

/obj/machinery/door/airlock/Destroy()
	QDEL_NULL(wires)
	QDEL_NULL(electronics)
	if (cyclelinkedairlock)
		if (cyclelinkedairlock.cyclelinkedairlock == src)
			cyclelinkedairlock.cyclelinkedairlock = null
		cyclelinkedairlock = null
	if(close_others) //remove this airlock from the list of every linked airlock
		closeOtherId = null
		for(var/obj/machinery/door/airlock/otherlock as anything in close_others)
			otherlock.close_others -= src
		close_others.Cut()
	if(id_tag)
		for(var/obj/machinery/door_buttons/D in GLOB.machines)
			D.removeMe(src)
	QDEL_NULL(note)
	QDEL_NULL(seal)
	for(var/datum/atom_hud/data/diagnostic/diag_hud in GLOB.huds)
		diag_hud.remove_atom_from_hud(src)
	return ..()

/obj/machinery/door/airlock/handle_atom_del(atom/A)
	if(A == note)
		note = null
		update_appearance()
	if(A == seal)
		seal = null
		update_appearance()

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
				addtimer(CALLBACK(cyclelinkedairlock, PROC_REF(close)), 2)
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
	return !(wires?.is_cut(WIRE_IDSCAN) || aiDisabledIdScanner)

/obj/machinery/door/airlock/proc/isAllPowerCut()
	if((wires.is_cut(WIRE_POWER1) || wires.is_cut(WIRE_POWER2)) && (wires.is_cut(WIRE_BACKUP1) || wires.is_cut(WIRE_BACKUP2)))
		return TRUE

/obj/machinery/door/airlock/proc/regainMainPower()
	if(secondsMainPowerLost > 0)
		secondsMainPowerLost = 0
	update_appearance()

/obj/machinery/door/airlock/proc/handlePowerRestore()
	var/cont = TRUE
	while (cont)
		sleep(1 SECONDS)
		if(QDELETED(src))
			return
		cont = FALSE
		if(secondsMainPowerLost>0)
			if(!wires.is_cut(WIRE_POWER1) && !wires.is_cut(WIRE_POWER2))
				secondsMainPowerLost -= 1
			cont = TRUE
		if(secondsBackupPowerLost>0)
			if(!wires.is_cut(WIRE_BACKUP1) && !wires.is_cut(WIRE_BACKUP2))
				secondsBackupPowerLost -= 1
			cont = TRUE
	spawnPowerRestoreRunning = FALSE
	update_appearance()

/obj/machinery/door/airlock/proc/loseMainPower()
	if(secondsMainPowerLost <= 0)
		secondsMainPowerLost = 60
		if(secondsBackupPowerLost < 10)
			secondsBackupPowerLost = 10
	if(!spawnPowerRestoreRunning)
		spawnPowerRestoreRunning = TRUE
	INVOKE_ASYNC(src, PROC_REF(handlePowerRestore))
	update_appearance()

/obj/machinery/door/airlock/proc/loseBackupPower()
	if(secondsBackupPowerLost < 60)
		secondsBackupPowerLost = 60
	if(!spawnPowerRestoreRunning)
		spawnPowerRestoreRunning = TRUE
	INVOKE_ASYNC(src, PROC_REF(handlePowerRestore))
	update_appearance()

/obj/machinery/door/airlock/proc/regainBackupPower()
	if(secondsBackupPowerLost > 0)
		secondsBackupPowerLost = 0
	update_appearance()

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

/obj/machinery/door/airlock/update_icon(updates=ALL, state=0, override=FALSE)
	if(operating && !override)
		return

	if(!state)
		state = density ? AIRLOCK_CLOSED : AIRLOCK_OPEN
	airlock_state = state

	. = ..()

/obj/machinery/door/airlock/update_icon_state()
	. = ..()
	switch(airlock_state)
		if(AIRLOCK_OPEN, AIRLOCK_CLOSED)
			icon_state = ""
		if(AIRLOCK_DENY, AIRLOCK_OPENING, AIRLOCK_CLOSING, AIRLOCK_EMAG)
			icon_state = "nonexistenticonstate" //MADNESS

/obj/machinery/door/airlock/update_overlays()
	. = ..()

	var/frame_state
	var/light_state
	switch(airlock_state)
		if(AIRLOCK_CLOSED)
			frame_state = AIRLOCK_FRAME_CLOSED
			if(locked)
				light_state = AIRLOCK_LIGHT_BOLTS
			else if(emergency)
				light_state = AIRLOCK_LIGHT_EMERGENCY
		if(AIRLOCK_DENY)
			frame_state = AIRLOCK_FRAME_CLOSED
			light_state = AIRLOCK_LIGHT_DENIED
		if(AIRLOCK_EMAG)
			frame_state = AIRLOCK_FRAME_CLOSED
		if(AIRLOCK_CLOSING)
			frame_state = AIRLOCK_FRAME_CLOSING
			light_state = AIRLOCK_LIGHT_CLOSING
		if(AIRLOCK_OPEN)
			frame_state = AIRLOCK_FRAME_OPEN
		if(AIRLOCK_OPENING)
			frame_state = AIRLOCK_FRAME_OPENING
			light_state = AIRLOCK_LIGHT_OPENING

	. += get_airlock_overlay(frame_state, icon, src, em_block = TRUE)
	if(airlock_material)
		. += get_airlock_overlay("[airlock_material]_[frame_state]", overlays_file, src, em_block = TRUE)
	else
		. += get_airlock_overlay("fill_[frame_state]", icon, src, em_block = TRUE)

	if(lights && hasPower())
		. += get_airlock_overlay("lights_[light_state]", overlays_file, src, em_block = FALSE)

	if(panel_open)
		. += get_airlock_overlay("panel_[frame_state][security_level ? "_protected" : null]", overlays_file, src, em_block = TRUE)
	if(frame_state == AIRLOCK_FRAME_CLOSED && welded)
		. += get_airlock_overlay("welded", overlays_file, src, em_block = TRUE)

	if(airlock_state == AIRLOCK_EMAG)
		. += get_airlock_overlay("sparks", overlays_file, src, em_block = FALSE)

	if(hasPower())
		if(frame_state == AIRLOCK_FRAME_CLOSED)
			if(obj_integrity < integrity_failure * max_integrity)
				. += get_airlock_overlay("sparks_broken", overlays_file, src, em_block = FALSE)
			else if(obj_integrity < (0.75 * max_integrity))
				. += get_airlock_overlay("sparks_damaged", overlays_file, src, em_block = FALSE)
		else if(frame_state == AIRLOCK_FRAME_OPEN)
			if(obj_integrity < (0.75 * max_integrity))
				. += get_airlock_overlay("sparks_open", overlays_file, src, em_block = FALSE)

	if(note)
		. += get_airlock_overlay(get_note_state(frame_state), note_overlay_file, src, em_block = TRUE)

	if(frame_state == AIRLOCK_FRAME_CLOSED && seal)
		if(istype(seal, /obj/item/door_seal/sb))
			if(seal_sb_block)
				. += get_airlock_overlay("seal_locked", 'white/Feline/icons/door_seal.dmi', src, em_block = TRUE)
			else
				. += get_airlock_overlay("seal_open", 'white/Feline/icons/door_seal.dmi', src, em_block = TRUE)
		else
			. += get_airlock_overlay("sealed", overlays_file, src, em_block = TRUE)

	if(hasPower() && unres_sides)
		for(var/heading in list(NORTH,SOUTH,EAST,WEST))
			if(!(unres_sides & heading))
				continue
			var/mutable_appearance/floorlight = mutable_appearance('icons/obj/doors/airlocks/station/overlays.dmi', "unres_[heading]", FLOAT_LAYER, src, ABOVE_LIGHTING_PLANE)
			switch (heading)
				if (NORTH)
					floorlight.pixel_x = 0
					floorlight.pixel_y = 32
				if (SOUTH)
					floorlight.pixel_x = 0
					floorlight.pixel_y = -32
				if (EAST)
					floorlight.pixel_x = 32
					floorlight.pixel_y = 0
				if (WEST)
					floorlight.pixel_x = -32
					floorlight.pixel_y = 0
			. += floorlight

/obj/machinery/door/airlock/do_animate(animation)
	switch(animation)
		if("opening")
			update_icon(ALL, AIRLOCK_OPENING)
		if("closing")
			update_icon(ALL, AIRLOCK_CLOSING)
		if("deny")
			if(!machine_stat)
				update_icon(ALL, AIRLOCK_DENY)
				playsound(src,doorDeni,50,FALSE,3)
				addtimer(CALLBACK(src, /atom/proc/update_icon, ALL, AIRLOCK_CLOSED), AIRLOCK_DENY_ANIMATION_TIME)

/obj/machinery/door/airlock/examine(mob/user)
	. = ..()
	if(closeOtherId)
		. += span_warning("<hr>This airlock cycles on ID: [sanitize(closeOtherId)].")
	else if(!closeOtherId)
		. += span_warning("<hr>This airlock does not cycle.")
	if(obj_flags & EMAGGED)
		. += "<hr><span class='warning'>Панель доступа слегка дымится.</span>"
	if(note)
		if(!in_range(user, src))
			. += "<hr>Здесь есть [note.name]. Надо бы подойти ближе, чтобы прочитать."
		else
			. += "<hr>Здесь есть [note.name]...\n"
			. += note.examine(user)
	if(seal)
		. += "<hr>Он заблокирован пневматическим замком."
	if(panel_open)
		. += "<hr>"
		switch(security_level)
			if(AIRLOCK_SECURITY_NONE)
				. += "Провода видны!"
			if(AIRLOCK_SECURITY_IRON)
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
		if(security_level == AIRLOCK_SECURITY_IRON)
			. += "<hr>Выглядит достаточно крепким."
		else
			. += "<hr>Выглядит крепким."

	if(issilicon(user) && !(machine_stat & BROKEN))
		. += "<hr><span class='notice'>Shift-клик по [src], чтобы [ density ? "открыть" : "закрыть"] его.</span>\n"
		. += "<span class='notice'>Ctrl-клик по [src], чтобы [ locked ? "поднять" : "опустить"] его болты.</span>\n"
		. += "<span class='notice'>ПКМ по [src], чтобы [ secondsElectrified ? "снять электризацию с н" : "электризовать "]его.</span>\n"
		. += span_notice("Ctrl-Shift-клик по [src], чтобы [ emergency ? "отключить" : "включить"] экстренный доступ.")

/obj/machinery/door/airlock/attack_ai(mob/user)
	if(!canAIControl(user))
		if(canAIHack())
			hack(user)
			return
		else
			to_chat(user, span_warning("Управление шлюзом для ИИ заблокировано брандмауэром. Невозможно взломать."))
	if(obj_flags & EMAGGED)
		to_chat(user, span_warning("Невозможно подключиться: Шлюз не отвечает."))
		return
	if(detonated)
		to_chat(user, span_warning("Невозможно подключиться. Панель управления шлюзом повреждена."))
		return

	ui_interact(user)

/obj/machinery/door/airlock/proc/hack(mob/user)
	set waitfor = 0
	if(!aiHacking)
		aiHacking = TRUE
		to_chat(user, span_warning("Управление шлюзом для ИИ заблокировано. Начато обнаружения неисправностей."))
		sleep(50)
		if(canAIControl(user))
			to_chat(user, span_notice("Оповещение отменено. Управление шлюзом восстановлено без нашей помощи."))
			aiHacking = FALSE
			return
		else if(!canAIHack())
			to_chat(user, span_warning("Соединение потеряно! Невозможно взломать шлюз."))
			aiHacking = FALSE
			return
		to_chat(user, span_notice("Неисправность подтверждена: провод управления шлюзом отключен или оборван."))
		sleep(20)
		to_chat(user, span_notice("Попытка взломать шлюз. Это может занять некоторое время."))
		sleep(200)
		if(canAIControl(user))
			to_chat(user, span_notice("Оповещение отменено. Управление шлюзом восстановлено без нашей помощи."))
			aiHacking = FALSE
			return
		else if(!canAIHack())
			to_chat(user, span_warning("Соединение потеряно! Невозможно взломать шлюз."))
			aiHacking = FALSE
			return
		to_chat(user, span_notice("Доступ к загрузке подтвержден. Загрузка программы управления в программное обеспечение шлюза."))
		sleep(170)
		if(canAIControl(user))
			to_chat(user, span_notice("Оповещение отменено. Управление шлюзом восстановлено без нашей помощи."))
			aiHacking = FALSE
			return
		else if(!canAIHack())
			to_chat(user, span_warning("Соединение потеряно! Невозможно взломать шлюз."))
			aiHacking = FALSE
			return
		to_chat(user, span_notice("Передача завершена. Принуждаем шлюз выполненить программу."))
		sleep(50)
		//disable blocked control
		aiControlDisabled = AI_WIRE_HACKED
		to_chat(user, span_notice("Получение контрольной информации из шлюза."))
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

/obj/machinery/door/airlock/proc/on_attack_hand(atom/source, mob/user, list/modifiers)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, /atom/proc/attack_hand, user, modifiers)
	return COMPONENT_CANCEL_ATTACK_CHAIN

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
				H.visible_message(span_danger("[user] быкует шлюз.") , \
									span_userdanger("Быкую шлюз!"))
				H.Paralyze(100)
				H.apply_damage(10, BRUTE, BODY_ZONE_HEAD)
			else
				visible_message(span_danger("[user] быкует шлюз. Славно, что у н[user.ru_ego()] на голове шлем."))

/obj/machinery/door/airlock/attempt_wire_interaction(mob/user)
	if(security_level)
		to_chat(user, span_warning("Провода защищены!"))
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
				if(istype(C, /obj/item/stack/sheet/iron))
					var/obj/item/stack/sheet/iron/S = C
					if(S.get_amount() < 2)
						to_chat(user, span_warning("Мне потребуется два листа металла для укрепления [src]."))
						return
					to_chat(user, span_notice("Начинает укреплять [src]."))
					if(do_after(user, 2 SECONDS, src))
						if(!panel_open || !S.use(2))
							return
						user.visible_message(span_notice("[user] укрепляет [src] металлом.") ,
											span_notice("Укрепляю [src] металлом."))
						security_level = AIRLOCK_SECURITY_IRON
						update_appearance()
					return
				else if(istype(C, /obj/item/stack/sheet/plasteel))
					var/obj/item/stack/sheet/plasteel/S = C
					if(S.get_amount() < 2)
						to_chat(user, span_warning("Мне потребуется два листа пластали для укрепления [src]."))
						return
					to_chat(user, span_notice("Начинает укреплять [src]."))
					if(do_after(user, 2 SECONDS, src))
						if(!panel_open || !S.use(2))
							return
						user.visible_message(span_notice("[user] укрепляет [src] пласталью.") ,
											span_notice("Укрепляю [src] пласталью."))
						security_level = AIRLOCK_SECURITY_PLASTEEL
						modify_max_integrity(max_integrity * AIRLOCK_INTEGRITY_MULTIPLIER)
						damage_deflection = AIRLOCK_DAMAGE_DEFLECTION_R
						update_appearance()
					return
			if(AIRLOCK_SECURITY_IRON)
				if(C.tool_behaviour == TOOL_WELDER)
					if(!C.tool_start_check(user, amount=2))
						return
					to_chat(user, span_notice("Начинаю разрезать экран панели..."))
					if(C.use_tool(src, user, 40, volume=50, amount = 2))
						if(!panel_open)
							return
						user.visible_message(span_notice("[user] прорезается сквозь защитный экран [src].") ,
										span_notice("Прорезаюсь сквозь защитный экран [src].") ,
										span_hear("Слышу сварку."))
						security_level = AIRLOCK_SECURITY_NONE
						spawn_atom_to_turf(/obj/item/stack/sheet/iron, user.loc, 2)
						update_appearance()
					return
			if(AIRLOCK_SECURITY_PLASTEEL_I_S)
				if(C.tool_behaviour == TOOL_CROWBAR)
					var/obj/item/crowbar/W = C
					to_chat(user, span_notice("Начинаю снимать внутренний слой защиты..."))
					if(W.use_tool(src, user, 40, volume=100))
						if(!panel_open)
							return
						if(security_level != AIRLOCK_SECURITY_PLASTEEL_I_S)
							return
						user.visible_message(span_notice("[user] снимает защитный экран [src].") ,
											span_notice("Снимаю защитный экран [src]."))
						security_level = AIRLOCK_SECURITY_NONE
						modify_max_integrity(max_integrity / AIRLOCK_INTEGRITY_MULTIPLIER)
						damage_deflection = AIRLOCK_DAMAGE_DEFLECTION_N
						spawn_atom_to_turf(/obj/item/stack/sheet/plasteel, user.loc, 1)
						update_appearance()
					return
			if(AIRLOCK_SECURITY_PLASTEEL_I)
				if(C.tool_behaviour == TOOL_WELDER)
					if(!C.tool_start_check(user, amount=2))
						return
					to_chat(user, span_notice("Начинаю резать внутренний слой защиты..."))
					if(C.use_tool(src, user, 40, volume=50, amount=2))
						if(!panel_open)
							return
						user.visible_message(span_notice("[user] прорезается через защитный экран [src].") ,
										span_notice("Прорезаюсь через защитный экран [src].") ,
										span_hear("Слышу сварку."))
						security_level = AIRLOCK_SECURITY_PLASTEEL_I_S
					return
			if(AIRLOCK_SECURITY_PLASTEEL_O_S)
				if(C.tool_behaviour == TOOL_CROWBAR)
					to_chat(user, span_notice("Начинаю снимать внешний слой защиты..."))
					if(C.use_tool(src, user, 40, volume=100))
						if(!panel_open)
							return
						if(security_level != AIRLOCK_SECURITY_PLASTEEL_O_S)
							return
						user.visible_message(span_notice("[user] снимает защитный экран [src].") ,
											span_notice("Снимаю защитный экран [src]."))
						security_level = AIRLOCK_SECURITY_PLASTEEL_I
						spawn_atom_to_turf(/obj/item/stack/sheet/plasteel, user.loc, 1)
					return
			if(AIRLOCK_SECURITY_PLASTEEL_O)
				if(C.tool_behaviour == TOOL_WELDER)
					if(!C.tool_start_check(user, amount=2))
						return
					to_chat(user, span_notice("Начинаю вырезать внешний слой защиты..."))
					if(C.use_tool(src, user, 40, volume=50, amount=2))
						if(!panel_open)
							return
						user.visible_message(span_notice("[user] прорезается сквозь защитный экран [src].") ,
										span_notice("Прорезаюсь сквозь защитный экран [src].") ,
										span_hear("Слышу сварку."))
						security_level = AIRLOCK_SECURITY_PLASTEEL_O_S
					return
			if(AIRLOCK_SECURITY_PLASTEEL)
				if(C.tool_behaviour == TOOL_WIRECUTTER)
					if(hasPower() && shock(user, 60)) // Protective grille of wiring is electrified
						return
					to_chat(user, span_notice("Начинаю прорезать внешнюю решетку."))
					if(C.use_tool(src, user, 10, volume=100))
						if(!panel_open)
							return
						user.visible_message(span_notice("[user] прорезает внешнюю защитную решётку [src].") ,
											span_notice("Прорезаю внешнюю защитную решётку [src]."))
						security_level = AIRLOCK_SECURITY_PLASTEEL_O
					return
	if(C.tool_behaviour == TOOL_SCREWDRIVER)
		if(panel_open && detonated)
			to_chat(user, span_warning("[capitalize(src.name)] не имеет панели, собственно!"))
			return
		toggle_panel_open()
		to_chat(user, span_notice("[panel_open ? "Открываю":"Закрываю"] техническую панель шлюза."))
		C.play_tool_sound(src)
		update_appearance()
	else if((C.tool_behaviour == TOOL_WIRECUTTER) && note)
		user.visible_message(span_notice("[user] срезает [note] с [src].") , span_notice("Срезаю [note] с [src]."))
		C.play_tool_sound(src)
		note.forceMove(get_turf(user))
		note = null
		update_appearance()
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
			to_chat(user, span_warning("[capitalize(src.name)] должен быть закрыт, прежде чем блокировать его!"))
			return
		if(seal)
			to_chat(user, span_warning("[capitalize(src.name)] уже заблокирован!"))
			return
		user.visible_message(span_notice("[user] начинает блокировать [src].") , span_notice("Начинаю блокировать [src]..."))
		playsound(src, 'sound/items/jaws_pry.ogg', 30, TRUE)
		if(!do_after(user, airlockseal.seal_time, target = src))
			return
		if(!density)
			to_chat(user, span_warning("[capitalize(src.name)] должен быть закрыт, прежде чем запечатывать его!"))
			return
		if(seal)
			to_chat(user, span_warning("[capitalize(src.name)] уже заблокирован!"))
			return
		if(!user.transferItemToLoc(airlockseal, src))
			to_chat(user, span_warning("Не могу запечатать [airlockseal]!"))
			return
		playsound(src, 'sound/machines/airlockforced.ogg', 30, TRUE)
		user.visible_message(span_notice("[user] блокирует [src].") , span_notice("Блокирую [src]."))
		seal = airlockseal
		if(istype(airlockseal, /obj/item/door_seal/sb))
			if(req_access != null)
				req_one_access_old = req_one_access + req_access
			else
				req_one_access_old = req_one_access
			req_one_access = list(ACCESS_HEADS, ACCESS_SECURITY)
			req_access = null
			req_access_txt = null
		modify_max_integrity(max_integrity * AIRLOCK_SEAL_MULTIPLIER)
		damage_deflection = (damage_deflection * AIRLOCK_SEAL_ARMOR_MULT)
		update_appearance()

	else if(istype(C, /obj/item/paper) || istype(C, /obj/item/photo))
		if(note)
			to_chat(user, span_warning("Здесь уже что-то приделано. Кусачками можно снять эту дрянь."))
			return
		if(!user.transferItemToLoc(C, src))
			to_chat(user, span_warning("Не могу прикрепить [C]!"))
			return
		user.visible_message(span_notice("[user] прикрепляет [C] к [src].") , span_notice("Прикрепляю [C] к [src]."))
		note = C
		update_appearance()
	else if(istype(C, /obj/item/card/id/advanced) || istype(C, /obj/item/modular_computer/tablet/pda))
		if(seal)
			var/obj/item/door_seal/airlockseal = seal
			if(istype(airlockseal, /obj/item/door_seal/sb))
				if(isliving(user))
					var/mob/living/L = user
					if(!do_after(user, 1 SECONDS, src))
						return TRUE
					if(check_access(L.get_idcard()))
						seal_sb_block = !seal_sb_block
						to_chat(user, span_warning("[seal_sb_block ? "Блокирую" : "Разблокирую"] пневмозамок."))
						playsound(user, seal_sb_block ? 'sound/machines/boltsdown.ogg' : 'sound/machines/boltsup.ogg', 40, FALSE)
						update_appearance()
						return
					else
						playsound(src, 'sound/machines/scanbuzz.ogg', 100, FALSE)
						to_chat(user, span_warning("Доступ заблокирован! Для изменения статуса блокировки нужно провести по сканеру <b>ID-картой СБ</b> или <b>Командного состава</b>."))
						return
	else
		return ..()


/obj/machinery/door/airlock/try_to_weld(obj/item/weldingtool/W, mob/user)
	if(!operating && density)
		if(seal)
			to_chat(user, span_warning("[capitalize(src.name)] запечатан!"))
			return
		if(user.a_intent != INTENT_HELP)
			if(!W.tool_start_check(user, amount=0))
				return
			user.visible_message(span_notice("[user] начинает [welded ? "разваривать":"заваривать"] шлюз.") , \
							span_notice("Начинаю [welded ? "разваривать":"заваривать"] шлюз...") , \
							span_hear("Слышу сварку."))
			if(W.use_tool(src, user, 40, volume=50, extra_checks = CALLBACK(src, PROC_REF(weld_checks), W, user)))
				welded = !welded
				user.visible_message(span_notice("[user] [welded? "заваривает":"разваривает"] [src].") , \
									span_notice("[welded ? "Завариваю":"Развариваю"] шлюз."))
				log_game("[key_name(user)] [welded ? "welded":"unwelded"] airlock [src] with [W] at [AREACOORD(src)]")
				update_appearance()
		else
			if(obj_integrity < max_integrity)
				if(!W.tool_start_check(user, amount=0))
					return
				user.visible_message(span_notice("[user] начинает заваривать шлюз.") , \
								span_notice("Начинаю чинить шлюз...") , \
								span_hear("Слышу сварку."))
				if(W.use_tool(src, user, 40, volume=50, extra_checks = CALLBACK(src, PROC_REF(weld_checks), W, user)))
					obj_integrity = max_integrity
					set_machine_stat(machine_stat & ~BROKEN)
					user.visible_message(span_notice("[user] заканчивает варить шлюз [src].") , \
										span_notice("Ремонт шлюза окончен."))
					update_appearance()
			else
				to_chat(user, span_notice("Шлюз не требует починки."))

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
		to_chat(user, span_warning("Я не понимаю как это работает!"))
		return TRUE
	if(istype(airlockseal, /obj/item/door_seal/sb))
		if(seal_sb_block)
			playsound(src, 'sound/machines/scanbuzz.ogg', 100, FALSE)
			to_chat(user, span_warning("Шлюз заблокирован! Для снятия блокировки нужно провести по сканеру <b>ID-картой СБ</b> или <b>Командного состава</b>."))
			return TRUE

	user.visible_message(span_notice("[user] начинает разблокировать [src].") , span_notice("Начинаю снимать пневматический замок с [src]..."))
	playsound(src, 'sound/machines/airlockforced.ogg', 30, TRUE)
	if(!do_after(user, airlockseal.unseal_time, target = src))
		return TRUE
	if(!seal)
		return TRUE
	playsound(src, 'sound/items/jaws_pry.ogg', 30, TRUE)
	airlockseal.forceMove(get_turf(user))
	user.visible_message(span_notice("[user] разблокирует [src].") , span_notice("Снимаю пневматический замок с [src]."))
	if(istype(airlockseal, /obj/item/door_seal/sb))
		req_one_access = req_one_access_old
		req_one_access_old = null
	seal = null
	modify_max_integrity(max_integrity / AIRLOCK_SEAL_MULTIPLIER)
	damage_deflection = (damage_deflection / AIRLOCK_SEAL_ARMOR_MULT)
	update_appearance()
	return TRUE


/obj/machinery/door/airlock/try_to_crowbar(obj/item/I, mob/living/user, forced = FALSE)
	if(I)
		var/beingcrowbarred = (I.tool_behaviour == TOOL_CROWBAR)
		if(!security_level && (beingcrowbarred && panel_open && ((obj_flags & EMAGGED) || (density && welded && !operating && !hasPower() && !locked))))
			user.visible_message(span_notice("[user] начинает извлекать плату из шлюза.") , \
				span_notice("Начинаю извлкать плату из шлюза..."))
			if(I.use_tool(src, user, 40, volume=100))
				deconstruct(TRUE, user)
				return
	if(seal)
		to_chat(user, span_warning("Нужно снять заглушку сначала!"))
		return
	if(locked)
		to_chat(user, span_warning("Шлюз не даёт себя открыть!"))
		return
	if(welded)
		to_chat(user, span_warning("Шлюз заварен и не поддаётся!"))
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
						to_chat(user, span_warning("Несмотря на мои попытки, [src] отказывается открываться."))
				prying_so_hard = FALSE
				return
		to_chat(user, span_warning("Мотор шлюза сопротивляется!"))
		return

	if(!operating)
		if(istype(I, /obj/item/fireaxe)) //being fireaxe'd
			var/obj/item/fireaxe/axe = I
			if(axe && !axe.wielded)
				to_chat(user, span_warning("Требуется держать [axe] в обеих руках для этого!"))
				return
		INVOKE_ASYNC(src, (density ? PROC_REF(open) : PROC_REF(close)), 2)


/obj/machinery/door/airlock/open(forced=0)
	if( operating || welded || locked || seal )
		return FALSE
	if(!forced)
		if(!hasPower() || wires?.is_cut(WIRE_OPEN))
			return FALSE
	if(forced < 2)
		if(obj_flags & EMAGGED)
			return FALSE
		use_power(50)
		playsound(src, doorOpen, 30, TRUE)
	else
		playsound(src, 'sound/machines/airlockforced.ogg', 30, TRUE)

	if(autoclose)
		autoclose_in(normalspeed ? 8 SECONDS : 1.5 SECONDS)

	if(!density)
		return TRUE

	if(closeOther != null && istype(closeOther, /obj/machinery/door/airlock))
		addtimer(CALLBACK(closeOther, PROC_REF(close)), 2)

	if(close_others)
		for(var/obj/machinery/door/airlock/otherlock as anything in close_others)
			if(!shuttledocked && !emergency && !otherlock.shuttledocked && !otherlock.emergency)
				if(otherlock.operating)
					otherlock.delayed_close_requested = TRUE
				else
					addtimer(CALLBACK(otherlock, PROC_REF(close)), 2)

	SEND_SIGNAL(src, COMSIG_AIRLOCK_OPEN, forced)
	operating = TRUE
	update_icon(ALL, AIRLOCK_OPENING, TRUE)
	sleep(1)
	set_opacity(0)
	update_freelook_sight()
	sleep(4)
	set_density(FALSE)
	flags_1 &= ~PREVENT_CLICK_UNDER_1
	air_update_turf(TRUE)
	sleep(1)
	layer = OPEN_DOOR_LAYER
	update_icon(ALL, AIRLOCK_OPEN, TRUE)
	operating = FALSE
	if(delayed_close_requested)
		delayed_close_requested = FALSE
		addtimer(CALLBACK(src, PROC_REF(close)), 1)
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
	update_icon(ALL, AIRLOCK_CLOSING, TRUE)
	layer = CLOSED_DOOR_LAYER
	if(air_tight)
		set_density(TRUE)
		flags_1 |= PREVENT_CLICK_UNDER_1
		air_update_turf(TRUE)
	sleep(1)
	if(!air_tight)
		set_density(TRUE)
		flags_1 |= PREVENT_CLICK_UNDER_1
		air_update_turf(TRUE)
	sleep(4)
	if(dangerous_close)
		crush()
	if(visible && !glass)
		set_opacity(1)
	update_freelook_sight()
	sleep(1)
	update_icon(ALL, AIRLOCK_CLOSED, TRUE)
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
	var/current_paintjob = tgui_input_list(user, "Выбираем будущий образ шлюза.", null, sort_list(painter.available_paint_jobs))
	if(!current_paintjob) // if the user clicked cancel on the popup, return
		return

	var/airlock_type = painter.available_paint_jobs["[current_paintjob]"] // get the airlock type path associated with the airlock name the user just chose
	var/obj/machinery/door/airlock/airlock = airlock_type // we need to create a new instance of the airlock and assembly to read vars from them
	var/obj/structure/door_assembly/assembly = initial(airlock.assemblytype)

	if(airlock_material == "glass" && initial(assembly.noglass)) // prevents painting glass airlocks with a paint job that doesn't have a glass version, such as the freezer
		to_chat(user, span_warning("Этот тип может быть использован только на обычных шлюзах."))
		return

	// applies the user-chosen airlock's icon, overlays and assemblytype to the src airlock
	painter.use_paint(user)
	icon = initial(airlock.icon)
	overlays_file = initial(airlock.overlays_file)
	assemblytype = initial(airlock.assemblytype)
	update_appearance()

/obj/machinery/door/airlock/CanAStarPass(obj/item/card/id/ID, to_dir, atom/movable/caller, no_id)
	//Airlock is passable if it is open (!density), bot has access, and is not bolted shut or powered off)
	return !density || (check_access(ID) && !locked && hasPower())

/obj/machinery/door/airlock/emag_act(mob/user, obj/item/card/emag/doorjack/D)
	if(!operating && density && hasPower() && !(obj_flags & EMAGGED))
		if(istype(D, /obj/item/card/emag/doorjack))
			D.use_charge(user)
		operating = TRUE
		update_icon(ALL, AIRLOCK_EMAG, TRUE)
		sleep(6)
		if(QDELETED(src))
			return
		operating = FALSE
		if(!open())
			update_icon(ALL, AIRLOCK_CLOSED, TRUE)
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
		to_chat(user, span_warning("[capitalize(src.name)] отказывается открываться!"))
		return
	add_fingerprint(user)
	user.visible_message(span_warning("[user] начинает открывать [src].") ,\
						span_noticealien("Впиваюсь своими когтями в [src] со всей своей мощью!") ,\
						span_warning("Слышу рёв металла..."))
	var/time_to_open = 5 //half a second
	if(hasPower())
		time_to_open = 5 SECONDS //Powered airlocks take longer to open, and are loud.
		playsound(src, 'sound/machines/airlock_alien_prying.ogg', 100, TRUE)


	if(do_after(user, time_to_open, src))
		if(density && !open(2)) //The airlock is still closed, but something prevented it opening. (Another player noticed and bolted/welded the airlock in time!)
			to_chat(user, span_warning("Несмотря на мои старания, [src] умудряется сопротивиться открытию!"))

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

	set_panel_open(TRUE)
	wires.cut_all()

/obj/machinery/door/airlock/proc/set_electrified(seconds, mob/user)
	secondsElectrified = seconds
	diag_hud_set_electrified()
	if(secondsElectrified > MACHINE_NOT_ELECTRIFIED)
		INVOKE_ASYNC(src, PROC_REF(electrified_loop))

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
		update_appearance()

/obj/machinery/door/airlock/proc/prepare_deconstruction_assembly(obj/structure/door_assembly/assembly)
	assembly.heat_proof_finished = heat_proof //tracks whether there's rglass in
	assembly.set_anchored(TRUE)
	assembly.glass = glass
	assembly.state = AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS
	assembly.created_name = name
	assembly.previous_assembly = previous_airlock
	assembly.update_name()
	assembly.update_appearance()

/obj/machinery/door/airlock/deconstruct(disassembled = TRUE, mob/user)
	if(!(flags_1 & NODECONSTRUCT_1))
		var/obj/structure/door_assembly/A
		if(assemblytype)
			A = new assemblytype(loc)
		else
			A = new /obj/structure/door_assembly(loc)
			//If you come across a null assemblytype, it will produce the default assembly instead of disintegrating.
		prepare_deconstruction_assembly(A)

		if(!disassembled)
			if(A)
				A.obj_integrity = A.max_integrity * 0.5
		else if(obj_flags & EMAGGED)
			if(user)
				to_chat(user, span_warning("Вырываю остатки платы из шлюза."))
		else
			if(user)
				to_chat(user, span_notice("Извлекаю плату из шлюза."))

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
				to_chat(user, span_notice("Пневматический замок [src] должн быть снят."))
				return FALSE
			if(security_level != AIRLOCK_SECURITY_NONE)
				to_chat(user, span_notice("Укрепления [src] должны быть удалены для продолжения."))
				return FALSE
			return list("mode" = RCD_DECONSTRUCT, "delay" = 50, "cost" = 32)
	return FALSE

/obj/machinery/door/airlock/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_DECONSTRUCT)
			to_chat(user, span_notice("Разбираю шлюз."))
			qdel(src)
			return TRUE
	return FALSE

/**
 * Returns a string representing the type of note pinned to this airlock
 * Arguments:
 * * frame_state - The AIRLOCK_FRAME_ value, as used in update_overlays()
 **/
/obj/machinery/door/airlock/proc/get_note_state(frame_state)
	if(!note)
		return
	else if(istype(note, /obj/item/paper))
		var/obj/item/paper/pinned_paper = note
		if(pinned_paper.show_written_words)
			return "note_words_[frame_state]"
		else
			return "note_[frame_state]"

	else if(istype(note, /obj/item/photo))
		return "photo_[frame_state]"

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
				update_appearance()
			else
				to_chat(usr, span_warning("Основное питание уже отключено."))
			. = TRUE
		if("disrupt-backup")
			if(!secondsBackupPowerLost)
				loseBackupPower()
				update_appearance()
			else
				to_chat(usr, span_warning("Запасное питание уже отключено."))
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
			update_appearance()
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
		to_chat(user, span_warning("Невозможно снять электризацию с шлюза. Провод обрезан."))
	else if(isElectrified())
		set_electrified(MACHINE_NOT_ELECTRIFIED, user)

/obj/machinery/door/airlock/proc/shock_temp(mob/user)
	if(!user_allowed(user))
		return
	if(wires.is_cut(WIRE_SHOCK))
		to_chat(user, span_warning("Провод электризации обрезан."))
	else
		set_electrified(MACHINE_DEFAULT_ELECTRIFY_TIME, user)

/obj/machinery/door/airlock/proc/shock_perm(mob/user)
	if(!user_allowed(user))
		return
	if(wires.is_cut(WIRE_SHOCK))
		to_chat(user, span_warning("Провод электризации обрезан."))
	else
		set_electrified(MACHINE_ELECTRIFIED_PERMANENT, user)

/obj/machinery/door/airlock/proc/toggle_bolt(mob/user)
	if(!user_allowed(user))
		return
	if(wires.is_cut(WIRE_BOLTS))
		to_chat(user, span_warning("Провода обрезаны, болты упали. Невозможно поднять болты."))
		return
	if(locked)
		if(!hasPower())
			to_chat(user, span_warning("Шлюз не имеет питания. Отказ в поднятии болтов."))
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
	update_appearance()

/obj/machinery/door/airlock/proc/user_toggle_open(mob/user)
	if(!user_allowed(user))
		return
	if(welded)
		to_chat(user, span_warning("Шлюз заварен намертво!"))
	else if(locked)
		to_chat(user, span_warning("Болты шлюза упали!"))
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
#undef AIRLOCK_SECURITY_IRON
#undef AIRLOCK_SECURITY_PLASTEEL_I_S
#undef AIRLOCK_SECURITY_PLASTEEL_I
#undef AIRLOCK_SECURITY_PLASTEEL_O_S
#undef AIRLOCK_SECURITY_PLASTEEL_O
#undef AIRLOCK_SECURITY_PLASTEEL

#undef AIRLOCK_INTEGRITY_N
#undef AIRLOCK_INTEGRITY_MULTIPLIER
#undef AIRLOCK_SEAL_MULTIPLIER
#undef AIRLOCK_SEAL_ARMOR_MULT
#undef AIRLOCK_DAMAGE_DEFLECTION_N
#undef AIRLOCK_DAMAGE_DEFLECTION_R

#undef AIRLOCK_DENY_ANIMATION_TIME

#undef DOOR_CLOSE_WAIT

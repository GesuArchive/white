/***************** WELCOME TO MECHA.DM, ENJOY YOUR STAY *****************/

/**
 * Mechs are now (finally) vehicles, this means you can make them multicrew
 * They can also grant select ability buttons based on occupant bitflags
 *
 * Movement is handled through vehicle_move() which is called by relaymove
 * Clicking is done by way of signals registering to the entering mob
 * NOTE: MMIS are NOT mobs but instead contain a brain that is, so you need special checks
 * AI also has special checks becaus it gets in and out of the mech differently
 * Always call remove_occupant(mob) when leaving the mech so the mob is removed properly
 *
 * For multi-crew, you need to set how the occupants recieve ability bitflags corresponding to their status on the vehicle(i.e: driver, gunner etc)
 * Abilities can then be set to only apply for certain bitflags and are assigned as such automatically
 *
 * Clicks are wither translated into mech_melee_attack (see mech_melee_attack.dm)
 * Or are used to call action() on equipped gear
 * Cooldown for gear is on the mech because exploits
 */
/obj/vehicle/sealed/mecha
	name = "mecha"
	desc = "Exosuit"
	icon = 'icons/mecha/mecha.dmi'
	resistance_flags = FIRE_PROOF | ACID_PROOF
	max_integrity = 300
	armor = list(MELEE = 20, BULLET = 10, LASER = 0, ENERGY = 0, BOMB = 10, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	movedelay = 1 SECONDS
	move_force = MOVE_FORCE_VERY_STRONG
	move_resist = MOVE_FORCE_EXTREMELY_STRONG
	COOLDOWN_DECLARE(mecha_bump_smash)
	light_system = MOVABLE_LIGHT
	light_on = FALSE
	light_range = 4
	generic_canpass = FALSE
	hud_possible = list(DIAG_STAT_HUD, DIAG_BATT_HUD, DIAG_MECH_HUD, DIAG_TRACK_HUD)
	mouse_pointer = 'icons/effects/mouse_pointers/mecha_mouse.dmi'
	///What direction will the mech face when entered/powered on? Defaults to South.
	var/dir_in = SOUTH
	///How much energy the mech will consume each time it moves. This variable is a backup for when leg actuators affect the energy drain.
	var/normal_step_energy_drain = 10
	///How much energy the mech will consume each time it moves. this is the current active energy consumed
	var/step_energy_drain = 10
	///How much energy we drain each time we mechpunch someone
	var/melee_energy_drain = 15
	///The minimum amount of energy charge consumed by leg overload
	var/overload_step_energy_drain_min = 100
	///Modifiers for directional damage reduction
	var/list/facing_modifiers = list(MECHA_FRONT_ARMOUR = 0.5, MECHA_SIDE_ARMOUR = 1, MECHA_BACK_ARMOUR = 1.5)
	///if we cant use our equipment(such as due to EMP)
	var/equipment_disabled = FALSE
	/// Keeps track of the mech's cell
	var/obj/item/stock_parts/cell/cell
	/// Keeps track of the mech's scanning module
	var/obj/item/stock_parts/scanning_module/scanmod
	/// Keeps track of the mech's capacitor
	var/obj/item/stock_parts/capacitor/capacitor
	///Whether the mechs maintenance protocols are on or off
	var/construction_state = MECHA_LOCKED
	///Contains flags for the mecha
	var/mecha_flags = ADDING_ACCESS_POSSIBLE | CANSTRAFE | IS_ENCLOSED | HAS_LIGHTS
	///Stores the DNA enzymes of a carbon so tht only they can access the mech
	var/dna_lock
	///Spark effects are handled by this datum
	var/datum/effect_system/spark_spread/spark_system = new
	///How powerful our lights are
	var/lights_power = 6
	///Just stop the mech from doing anything
	var/completely_disabled = FALSE
	///Whether this mech is allowed to move diagonally
	var/allow_diagonal_movement = FALSE
	///Whether or not the mech destroys walls by running into it.
	var/bumpsmash = FALSE

	///////////ATMOS
	///Whether we are currrently drawing from the internal tank
	var/use_internal_tank = FALSE
	///The setting of the valve on the internal tank
	var/internal_tank_valve = ONE_ATMOSPHERE
	///The internal air tank obj of the mech
	var/obj/machinery/portable_atmospherics/canister/air/internal_tank
	///Internal air mix datum
	var/datum/gas_mixture/cabin_air
	///The connected air port, if we have one
	var/obj/machinery/atmospherics/components/unary/portables_connector/connected_port

	///Special version of the radio, which is unsellable
	var/obj/item/radio/mech/radio
	var/list/trackers = list()

	var/max_temperature = 25000

	///Bitflags for internal damage
	var/internal_damage = NONE
	/// damage amount above which we can take internal damages
	var/internal_damage_threshold = 15
	/// % chance for internal damage to occur
	var/internal_damage_probability = 20
	/// list of possibly dealt internal damage for this mech type
	var/possible_int_damage = MECHA_INT_FIRE|MECHA_INT_TEMP_CONTROL|MECHA_INT_TANK_BREACH|MECHA_INT_CONTROL_LOST|MECHA_INT_SHORT_CIRCUIT
	/// damage threshold above which we take component damage
	var/component_damage_threshold = 10

	///required access level for mecha operation
	var/list/operation_req_access = list()
	///required access to change internal components
	var/list/internals_req_access = list(ACCESS_MECH_ENGINE, ACCESS_MECH_SCIENCE)

	///Typepath for the wreckage it spawns when destroyed
	var/wreckage

	///assoc list: key-typepathlist before init, key-equipmentlist after
	var/list/equip_by_category = list(
		MECHA_L_ARM = null,
		MECHA_R_ARM = null,
		MECHA_UTILITY = list(),
		MECHA_POWER = list(),
		MECHA_ARMOR = list(),
	)
	///assoc list: max equips for non-arm modules key-count
	var/list/max_equip_by_category = list(
		MECHA_UTILITY = 0,
		MECHA_POWER = 1,
		MECHA_ARMOR = 0,
	)
	///flat equipment for iteration
	var/list/flat_equipment

	///Whether our steps are silent due to no gravity
	var/step_silent = FALSE
	///Sound played when the mech moves
	var/stepsound = 'sound/mecha/mechstep.ogg'
	///Sound played when the mech walks
	var/turnsound = 'sound/mecha/mechturn.ogg'

	///Cooldown duration between melee punches
	var/melee_cooldown = 10

	///TIme taken to leave the mech
	var/exit_delay = 2 SECONDS
	///Time you get slept for if you get forcible ejected by the mech exploding
	var/destruction_sleep_duration = 2 SECONDS
	///Whether outside viewers can see the pilot inside
	var/enclosed = TRUE
	///In case theres a different iconstate for AI/MMI pilot(currently only used for ripley)
	var/silicon_icon_state = null
	///Currently ejecting, and unable to do things
	var/is_currently_ejecting = FALSE
	///Safety for weapons. Won't fire if enabled, and toggled by middle click.
	var/weapons_safety = FALSE

	var/datum/effect_system/fluid_spread/smoke/smoke_system = new

	////Action vars
	///Ref to any active thrusters we might have
	var/obj/item/mecha_parts/mecha_equipment/thrusters/active_thrusters

	///Bool for energy shield on/off
	var/defense_mode = FALSE

	///Bool for leg overload on/off
	var/leg_overload_mode = FALSE
	///Energy use modifier for leg overload
	var/leg_overload_coeff = 100

	//Bool for zoom on/off
	var/zoom_mode = FALSE

	///Remaining smoke charges
	var/smoke_charges = 5
	///Cooldown between using smoke
	var/smoke_cooldown = 10 SECONDS

	///check for phasing, if it is set to text (to describe how it is phasing: "flying", "phasing") it will let the mech walk through walls.
	var/phasing = ""
	///Power we use every time we phaze through something
	var/phasing_energy_drain = 200
	///icon_state for flick() when phazing
	var/phase_state = ""

	///Wether we are strafing
	var/strafe = FALSE

	///Cooldown length between bumpsmashes
	var/smashcooldown = 3

	///Bool for whether this mech can only be used on lavaland
	var/lavaland_only = FALSE

	/// Ui size, so you can make the UI bigger if you let it load a lot of stuff
	var/ui_x = 1100
	/// Ui size, so you can make the UI bigger if you let it load a lot of stuff
	var/ui_y = 600
	/// ref to screen object that displays in the middle of the UI
	var/atom/movable/screen/map_view/ui_view

/obj/item/radio/mech //this has to go somewhere
	subspace_transmission = TRUE

/obj/vehicle/sealed/mecha/Initialize(mapload)
	. = ..()
	ui_view = new()
	ui_view.generate_view("mech_view_[REF(src)]")
	if(enclosed)
		internal_tank = new (src)
		RegisterSignal(src, COMSIG_MOVABLE_PRE_MOVE , PROC_REF(disconnect_air))
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(play_stepsound))
	RegisterSignal(src, COMSIG_LIGHT_EATER_ACT, PROC_REF(on_light_eater))
	spark_system.set_up(2, 0, src)
	spark_system.attach(src)

	smoke_system.set_up(3, location = src)
	smoke_system.attach(src)

	radio = new(src)
	radio.name = "[src] radio"

	cabin_air = new
	cabin_air.set_temperature(T20C)
	cabin_air.set_volume(200)
	cabin_air.set_moles(GAS_O2, O2STANDARD*cabin_air.return_volume()/(R_IDEAL_GAS_EQUATION*cabin_air.return_temperature()))
	cabin_air.set_moles(GAS_N2, N2STANDARD*cabin_air.return_volume()/(R_IDEAL_GAS_EQUATION*cabin_air.return_temperature()))

	add_cell()
	add_scanmod()
	add_capacitor()
	START_PROCESSING(SSobj, src)
	SSpoints_of_interest.make_point_of_interest(src)
	log_message("[src.name] created.", LOG_MECHA)
	GLOB.mechas_list += src //global mech list
	prepare_huds()
	for(var/datum/atom_hud/data/diagnostic/diag_hud in GLOB.huds)
		diag_hud.add_atom_to_hud(src)
	diag_hud_set_mechhealth()
	diag_hud_set_mechcell()
	diag_hud_set_mechstat()
	update_icon()

	AddElement(/datum/element/atmos_sensitive, mapload)
	become_hearing_sensitive(trait_source = ROUNDSTART_TRAIT)
	ADD_TRAIT(src, TRAIT_ASHSTORM_IMMUNE, ROUNDSTART_TRAIT) //protects pilots from ashstorms.
	for(var/key in equip_by_category)
		if(key == MECHA_L_ARM || key == MECHA_R_ARM)
			var/path = equip_by_category[key]
			if(!path)
				continue
			var/obj/item/mecha_parts/mecha_equipment/thing = new path
			thing.attach(src, key == MECHA_R_ARM)
			continue
		for(var/path in equip_by_category[key])
			var/obj/item/mecha_parts/mecha_equipment/thing = new path
			thing.attach(src, FALSE)
			equip_by_category[key] -= path

/obj/vehicle/sealed/mecha/Destroy()
	for(var/ejectee in occupants)
		mob_exit(ejectee, TRUE, TRUE)

	if(LAZYLEN(flat_equipment))
		for(var/obj/item/mecha_parts/mecha_equipment/equip as anything in flat_equipment)
			equip.detach(loc)
			qdel(equip)
	radio = null

	STOP_PROCESSING(SSobj, src)
	LAZYCLEARLIST(flat_equipment)

	QDEL_NULL(cell)
	QDEL_NULL(scanmod)
	QDEL_NULL(capacitor)
	QDEL_NULL(internal_tank)
	QDEL_NULL(cabin_air)
	QDEL_NULL(spark_system)
	QDEL_NULL(smoke_system)
	QDEL_NULL(ui_view)

	GLOB.mechas_list -= src //global mech list
	for(var/datum/atom_hud/data/diagnostic/diag_hud in GLOB.huds)
		diag_hud.remove_atom_from_hud(src) //YEET
	return ..()

/obj/vehicle/sealed/mecha/obj_destruction()
	loc.assume_air(cabin_air)
	air_update_turf()
	for(var/mob/living/occupant as anything in occupants)
		if(isAI(occupant))
			occupant.gib() //No wreck, no AI to recover
			continue
		mob_exit(occupant, FALSE, TRUE)
		occupant.SetSleeping(destruction_sleep_duration)
	return ..()


/obj/vehicle/sealed/mecha/update_icon_state()
	icon_state = get_mecha_occupancy_state()
	return ..()

/**
 * Toggles Weapons Safety
 *
 * Handles enabling or disabling the safety function.
 */
/obj/vehicle/sealed/mecha/proc/set_safety(mob/user)
	weapons_safety = !weapons_safety
	SEND_SOUND(user, sound('sound/machines/beep.ogg', volume = 25))
	balloon_alert(user, "equipment [weapons_safety ? "safe" : "ready"]")
	set_mouse_pointer()

/**
 * Updates the pilot's mouse cursor override.
 *
 * If the mech's weapons safety is enabled, there should be no override, and the user gets their regular mouse cursor. If safety
 * is off but the mech's equipment is disabled (such as by EMP), the cursor should be the red disabled version. Otherwise, if
 * safety is off and the equipment is functional, the cursor should be the regular green cursor. This proc sets the cursor.
 * correct and then updates it for each mob in the occupants list.
 */
/obj/vehicle/sealed/mecha/proc/set_mouse_pointer()
	if(weapons_safety)
		mouse_pointer = ""
	else
		if(equipment_disabled)
			mouse_pointer = 'icons/effects/mouse_pointers/mecha_mouse-disable.dmi'
		else
			mouse_pointer = 'icons/effects/mouse_pointers/mecha_mouse.dmi'

	for(var/mob/mob_occupant as anything in occupants)
		mob_occupant.update_mouse_pointer()

//override this proc if you need to split up mecha control between multiple people (see savannah_ivanov.dm)
/obj/vehicle/sealed/mecha/auto_assign_occupant_flags(mob/M)
	if(driver_amount() < max_drivers)
		add_control_flags(M, FULL_MECHA_CONTROL)

/obj/vehicle/sealed/mecha/proc/get_mecha_occupancy_state()
	if((mecha_flags & SILICON_PILOT) && silicon_icon_state)
		return silicon_icon_state
	if(LAZYLEN(occupants))
		return initial(icon_state)
	return "[initial(icon_state)]-open"

/obj/vehicle/sealed/mecha/CanPassThrough(atom/blocker, movement_dir, blocker_opinion)
	if(!phasing || get_charge() <= phasing_energy_drain || throwing)
		return ..()
	if(phase_state)
		flick(phase_state, src)
	var/turf/destination_turf = get_step(loc, movement_dir)
	var/area/destination_area = destination_turf.loc
	if(destination_area.area_flags & NOTELEPORT || SSmapping.level_trait(destination_turf.z, ZTRAIT_NOPHASE))
		return FALSE
	return TRUE

/obj/vehicle/sealed/mecha/get_cell()
	return cell

/obj/vehicle/sealed/mecha/rust_heretic_act()
	take_damage(500,  BRUTE)

/obj/vehicle/sealed/mecha/proc/restore_equipment()
	equipment_disabled = FALSE
	for(var/occupant in occupants)
		var/mob/mob_occupant = occupant
		SEND_SOUND(mob_occupant, sound('sound/items/timer.ogg', volume=50))
		to_chat(mob_occupant, "<span=notice>Оборудование перезагружено успешно.</span>")
	set_mouse_pointer()

/obj/vehicle/sealed/mecha/CheckParts(list/parts_list)
	. = ..()
	cell = locate(/obj/item/stock_parts/cell) in contents
	scanmod = locate(/obj/item/stock_parts/scanning_module) in contents
	capacitor = locate(/obj/item/stock_parts/capacitor) in contents
	update_part_values()

/obj/vehicle/sealed/mecha/proc/update_part_values() ///Updates the values given by scanning module and capacitor tier, called when a part is removed or inserted.
	if(scanmod)
		normal_step_energy_drain = 20 - (5 * scanmod.rating) //10 is normal, so on lowest part its worse, on second its ok and on higher its real good up to 0 on best
		step_energy_drain = normal_step_energy_drain
	else
		normal_step_energy_drain = 500
		step_energy_drain = normal_step_energy_drain
	if(capacitor)
		armor = armor.modifyRating(energy = (capacitor.rating * 5)) //Each level of capacitor protects the mech against emp by 5%
	else //because we can still be hit without a cap, even if we can't move
		armor = armor.setRating(energy = 0)


////////////////////////
////// Helpers /////////
////////////////////////

///Adds a cell, for use in Map-spawned mechs, Nuke Ops mechs, and admin-spawned mechs. Mechs built by hand will replace this.
/obj/vehicle/sealed/mecha/proc/add_cell(obj/item/stock_parts/cell/C=null)
	QDEL_NULL(cell)
	if(C)
		C.forceMove(src)
		cell = C
		return
	cell = new /obj/item/stock_parts/cell/high/plus(src)

///Adds a scanning module, for use in Map-spawned mechs, Nuke Ops mechs, and admin-spawned mechs. Mechs built by hand will replace this.
/obj/vehicle/sealed/mecha/proc/add_scanmod(obj/item/stock_parts/scanning_module/sm=null)
	QDEL_NULL(scanmod)
	if(sm)
		sm.forceMove(src)
		scanmod = sm
		return
	scanmod = new /obj/item/stock_parts/scanning_module(src)

///Adds a capacitor, for use in Map-spawned mechs, Nuke Ops mechs, and admin-spawned mechs. Mechs built by hand will replace this.
/obj/vehicle/sealed/mecha/proc/add_capacitor(obj/item/stock_parts/capacitor/cap=null)
	QDEL_NULL(capacitor)
	if(cap)
		cap.forceMove(src)
		capacitor = cap
	else
		capacitor = new /obj/item/stock_parts/capacitor(src)

////////////////////////////////////////////////////////////////////////////////

/obj/vehicle/sealed/mecha/examine(mob/user)
	. = ..()
	. += "<hr>"
	var/integrity = obj_integrity*100/max_integrity
	switch(integrity)
		if(85 to 100)
			. += "Полностью цел."
		if(65 to 85)
			. += "Немного повреждён."
		if(45 to 65)
			. += "Сильно повреждён."
		if(25 to 45)
			. += "Виднеется множество повреждений."
		else
			. += "Сейчас развалится."
	if(LAZYLEN(flat_equipment))
		. += "<hr>У него в руке:"
		for(var/obj/item/mecha_parts/mecha_equipment/ME as anything in flat_equipment)
			. += "\n[icon2html(ME, user)] [ME]."
	if(enclosed)
		return
	if(mecha_flags & SILICON_PILOT)
		. += "\n[src] похоже он управляется сам по себе..."
	else
		for(var/occupante in occupants)
			. += "\nВижу [occupante] внутри."
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			for(var/held_item in H.held_items)
				if(!isgun(held_item))
					continue
				. += span_warning("Похоже, что я смогу дать пилоту в табло, если буду бить по центру или в голову.")
				break //in case user is holding two guns

//processing internal damage, temperature, air regulation, alert updates, lights power use.
/obj/vehicle/sealed/mecha/process(delta_time)
	if(internal_damage)
		if(internal_damage & MECHA_INT_FIRE)
			if(!(internal_damage & MECHA_INT_TEMP_CONTROL) && DT_PROB(2.5, delta_time))
				clear_internal_damage(MECHA_INT_FIRE)
			if(internal_tank)
				var/datum/gas_mixture/int_tank_air = internal_tank.return_air()
				if(int_tank_air.return_pressure() > internal_tank.maximum_pressure && !(internal_damage & MECHA_INT_TANK_BREACH))
					set_internal_damage(MECHA_INT_TANK_BREACH)
				if(int_tank_air && int_tank_air.return_volume() > 0) //heat the air_contents
					int_tank_air.set_temperature(min(6000+T0C, int_tank_air.return_temperature()+rand(5,7.5)*delta_time))
			if(cabin_air && cabin_air.return_volume()>0)
				cabin_air.set_temperature(min(6000+T0C, cabin_air.return_temperature()+rand(5,7.5)*delta_time))
				if(cabin_air.return_temperature() > max_temperature/2)
					take_damage(delta_time*2/round(max_temperature/cabin_air.return_temperature(),0.1), BURN, 0, 0)


		if(internal_damage & MECHA_INT_TANK_BREACH) //remove some air from internal tank
			if(internal_tank)
				var/datum/gas_mixture/int_tank_air = internal_tank.return_air()
				var/datum/gas_mixture/leaked_gas = int_tank_air.remove_ratio(DT_PROB_RATE(0.05, delta_time))
				if(loc)
					loc.assume_air(leaked_gas)
					air_update_turf()
				else
					qdel(leaked_gas)

		if(internal_damage & MECHA_INT_SHORT_CIRCUIT)
			if(get_charge())
				spark_system.start()
				cell.charge -= min(10 * delta_time, cell.charge)
				cell.maxcharge -= min(10 * delta_time, cell.maxcharge)

	if(!(internal_damage & MECHA_INT_TEMP_CONTROL))
		if(cabin_air && cabin_air.return_volume() > 0)
			var/delta = cabin_air.return_temperature() - T20C
			cabin_air.set_temperature(cabin_air.return_temperature() - clamp(round(delta / 8, 0.1), -5, 5) * delta_time)

	if(internal_tank)
		var/datum/gas_mixture/tank_air = internal_tank.return_air()

		var/release_pressure = internal_tank_valve
		var/cabin_pressure = cabin_air.return_pressure()
		var/pressure_delta = min(release_pressure - cabin_pressure, (tank_air.return_pressure() - cabin_pressure)/2)
		var/transfer_moles = 0
		if(pressure_delta > 0) //cabin pressure lower than release pressure
			if(tank_air.return_temperature() > 0)
				transfer_moles = pressure_delta*cabin_air.return_volume()/(cabin_air.return_temperature() * R_IDEAL_GAS_EQUATION)
				var/datum/gas_mixture/removed = tank_air.remove(transfer_moles)
				cabin_air.merge(removed)
		else if(pressure_delta < 0) //cabin pressure higher than release pressure
			var/datum/gas_mixture/t_air = return_air()
			pressure_delta = cabin_pressure - release_pressure
			if(t_air)
				pressure_delta = min(cabin_pressure - t_air.return_pressure(), pressure_delta)
			if(pressure_delta > 0) //if location pressure is lower than cabin pressure
				transfer_moles = pressure_delta*cabin_air.return_volume()/(cabin_air.return_temperature() * R_IDEAL_GAS_EQUATION)
				var/datum/gas_mixture/removed = cabin_air.remove(transfer_moles)
				if(t_air)
					t_air.merge(removed)
				else //just delete the cabin gas, we're in space or some shit
					qdel(removed)

	for(var/mob/living/occupant as anything in occupants) //впрочем, это можно поменять если тебя всегда будет выкидывать
		if(occupant?.incapacitated()) //no sides mean it's easy to just sorta fall out if you're incapacitated.
			to_chat(occupant, span_warning("Пилот бессознания, автоматическое извлечение."))
			mob_exit(occupant) //bye bye
			continue
		if(cell)
			var/cellcharge = cell.charge/cell.maxcharge
			switch(cellcharge)
				if(0.75 to INFINITY)
					occupant.clear_alert("charge")
				if(0.5 to 0.75)
					occupant.throw_alert("charge", /atom/movable/screen/alert/lowcell, 1)
				if(0.25 to 0.5)
					occupant.throw_alert("charge", /atom/movable/screen/alert/lowcell, 2)
				if(0.01 to 0.25)
					occupant.throw_alert("charge", /atom/movable/screen/alert/lowcell, 3)
				else
					occupant.throw_alert("charge", /atom/movable/screen/alert/emptycell)

		var/integrity = obj_integrity/max_integrity*100
		switch(integrity)
			if(30 to 45)
				occupant.throw_alert("mech damage", /atom/movable/screen/alert/low_mech_integrity, 1)
			if(15 to 35)
				occupant.throw_alert("mech damage", /atom/movable/screen/alert/low_mech_integrity, 2)
			if(-INFINITY to 15)
				occupant.throw_alert("mech damage", /atom/movable/screen/alert/low_mech_integrity, 3)
			else
				occupant.clear_alert("mech damage")
		var/atom/checking = occupant.loc
		// recursive check to handle all cases regarding very nested occupants,
		// such as brainmob inside brainitem inside MMI inside mecha
		while(!isnull(checking))
			if(isturf(checking))
				// hit a turf before hitting the mecha, seems like they have been moved out
				occupant.clear_alert("charge")
				occupant.clear_alert("mech damage")
				occupant = null
				break
			else if (checking == src)
				break  // all good
			checking = checking.loc

	if(mecha_flags & LIGHTS_ON)
		use_power(2*delta_time)

//Diagnostic HUD updates
	diag_hud_set_mechhealth()
	diag_hud_set_mechcell()
	diag_hud_set_mechstat()

/obj/vehicle/sealed/mecha/fire_act() //Check if we should ignite the pilot of an open-canopy mech
	. = ..()
	if(enclosed || mecha_flags & SILICON_PILOT)
		return
	for(var/mob/living/cookedalive as anything in occupants)
		if(cookedalive.fire_stacks < 5)
			cookedalive.adjust_fire_stacks(1)
			cookedalive.ignite_mob()

///Displays a special speech bubble when someone inside the mecha speaks
/obj/vehicle/sealed/mecha/proc/display_speech_bubble(datum/source, list/speech_args)
	SIGNAL_HANDLER
	var/list/speech_bubble_recipients = get_hearers_in_view(7,src)
	for(var/mob/M in speech_bubble_recipients)
		if(M.client)
			speech_bubble_recipients.Add(M.client)
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(flick_overlay), image('icons/mob/talk.dmi', src, "machine[say_test(speech_args[SPEECH_MESSAGE])]",MOB_LAYER+1), speech_bubble_recipients, 30)

////////////////////////////
///// Action processing ////
////////////////////////////

///Called when a driver clicks somewhere. Handles everything like equipment, punches, etc.
/obj/vehicle/sealed/mecha/proc/on_mouseclick(mob/user, atom/target, params)
	SIGNAL_HANDLER

	var/list/modifiers = params2list(params)

	if(LAZYACCESS(modifiers, MIDDLE_CLICK))
		set_safety(user)
		return COMSIG_MOB_CANCEL_CLICKON
	if(weapons_safety)
		return
	if(isAI(user)) //For AIs: If safeties are off, use mech functions. If safeties are on, use AI functions.
		. = COMSIG_MOB_CANCEL_CLICKON
	if(modifiers[SHIFT_CLICK]) //Allows things to be examined.
		return
	if(!isturf(target) && !isturf(target.loc)) // Prevents inventory from being drilled
		return
	if(completely_disabled || is_currently_ejecting || (mecha_flags & CANNOT_INTERACT))
		return
	if(phasing)
		to_chat(occupants, "[icon2html(src, occupants)]<span class='warning'>Невозможно взаимодействие с чем-то в режиме фазирования.</span>")
		return
	if(user.incapacitated())
		return
	if(construction_state)
		to_chat(occupants, "[icon2html(src, occupants)]<span class='warning'>Технические протоколы активны.</span>")
		return
	if(!get_charge())
		return
	if(src == target)
		return
	var/dir_to_target = get_dir(src,target)
	if(dir_to_target && !(dir_to_target & dir))//wrong direction
		return
	if(internal_damage & MECHA_INT_CONTROL_LOST)
		target = pick(view(3,target))
	var/mob/living/livinguser = user
	if(!(livinguser in return_controllers_with_flag(VEHICLE_CONTROL_EQUIPMENT)))
		to_chat(livinguser, span_warning("Неправильное место для взаимодействия с оборудованием!"))
		return
	var/obj/item/mecha_parts/mecha_equipment/selected
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		selected = equip_by_category[MECHA_R_ARM]
	else
		selected = equip_by_category[MECHA_L_ARM]
	if(!selected)
		return
	if(!Adjacent(target) && (selected.range & MECHA_RANGED))
		if(HAS_TRAIT(livinguser, TRAIT_PACIFISM) && selected.harmful)
			to_chat(livinguser, span_warning("Не хочу вредить живым существам!"))
			return
		if(SEND_SIGNAL(src, COMSIG_MECHA_EQUIPMENT_CLICK, livinguser, target) & COMPONENT_CANCEL_EQUIPMENT_CLICK)
			return
		INVOKE_ASYNC(selected, TYPE_PROC_REF(/obj/item/mecha_parts/mecha_equipment, action), user, target, modifiers)
		return
	if((selected.range & MECHA_MELEE) && Adjacent(target))
		if(isliving(target) && selected.harmful && HAS_TRAIT(livinguser, TRAIT_PACIFISM))
			to_chat(livinguser, span_warning("Не хочу вредить живым существам!"))
			return
		if(SEND_SIGNAL(src, COMSIG_MECHA_EQUIPMENT_CLICK, livinguser, target) & COMPONENT_CANCEL_EQUIPMENT_CLICK)
			return
		INVOKE_ASYNC(selected, TYPE_PROC_REF(/obj/item/mecha_parts/mecha_equipment, action), user, target, modifiers)
		return
	if(!(livinguser in return_controllers_with_flag(VEHICLE_CONTROL_MELEE)))
		to_chat(livinguser, span_warning("Неправильное место для взаимодействия с оборудованием!"))
		return
	var/on_cooldown = TIMER_COOLDOWN_CHECK(src, COOLDOWN_MECHA_MELEE_ATTACK)
	var/adjacent = Adjacent(target)
	if(SEND_SIGNAL(src, COMSIG_MECHA_MELEE_CLICK, livinguser, target, on_cooldown, adjacent) & COMPONENT_CANCEL_MELEE_CLICK)
		return
	if(on_cooldown || !adjacent)
		return
	if(internal_damage & MECHA_INT_CONTROL_LOST)
		target = pick(oview(1,src))

	if(!has_charge(melee_energy_drain))
		return
	use_power(melee_energy_drain)

	if(force)
		target.mech_melee_attack(src, user)
		TIMER_COOLDOWN_START(src, COOLDOWN_MECHA_MELEE_ATTACK, melee_cooldown)

//////////////////////////////////
////////  Movement procs  ////////
//////////////////////////////////

///Plays the mech step sound effect. Split from movement procs so that other mechs (HONK) can override this one specific part.
/obj/vehicle/sealed/mecha/proc/play_stepsound()
	SIGNAL_HANDLER
	if(mecha_flags & QUIET_STEPS)
		return
	playsound(src, stepsound, 40, TRUE)

///Disconnects air tank- air port connection on mecha move
/obj/vehicle/sealed/mecha/proc/disconnect_air()
	SIGNAL_HANDLER
	if(internal_tank.disconnect()) // Something moved us and broke connection
		to_chat(occupants, "[icon2html(src, occupants)]<span class='warning'>Бак пробит!</span>")
		log_message("Lost connection to gas port.", LOG_MECHA)

// Do whatever you do to mobs to these fuckers too
/obj/vehicle/sealed/mecha/Process_Spacemove(movement_dir = 0, continuous_move = FALSE)
	. = ..()
	if(.)
		return TRUE

	var/atom/movable/backup = get_spacemove_backup(movement_dir, continuous_move)
	if(backup)
		if(!istype(backup) || !movement_dir || backup.anchored || continuous_move) //get_spacemove_backup() already checks if a returned turf is solid, so we can just go
			return TRUE
		last_pushoff = world.time
		if(backup.newtonian_move(turn(movement_dir, 180), instant = TRUE))
			backup.last_pushoff = world.time
			step_silent = TRUE
			if(return_drivers())
				to_chat(occupants, "[icon2html(src, occupants)]<span class='info'>[src] отталкивает [backup] для своего ускорения.</span>")
		return TRUE

	if(active_thrusters?.thrust(movement_dir))
		step_silent = TRUE
		return TRUE
	return FALSE

/obj/vehicle/sealed/mecha/relaymove(mob/living/user, direction)
	. = TRUE
	if(!canmove || !(user in return_drivers()))
		return
	vehicle_move(direction)

/obj/vehicle/sealed/mecha/vehicle_move(direction, forcerotate = FALSE)
	if(!COOLDOWN_FINISHED(src, cooldown_vehicle_move))
		return FALSE
	COOLDOWN_START(src, cooldown_vehicle_move, movedelay)
	if(completely_disabled)
		return FALSE
	if(!direction)
		return FALSE
	if(internal_tank?.connected_port)
		if(!TIMER_COOLDOWN_CHECK(src, COOLDOWN_MECHA_MESSAGE))
			to_chat(occupants, "[icon2html(src, occupants)]<span class='warning'>Невозможно движение, пока подключены к порту!</span>")
			TIMER_COOLDOWN_START(src, COOLDOWN_MECHA_MESSAGE, 2 SECONDS)
		return FALSE
	if(construction_state)
		if(!TIMER_COOLDOWN_CHECK(src, COOLDOWN_MECHA_MESSAGE))
			to_chat(occupants, "[icon2html(src, occupants)]<span class='danger'>Технические протоколы активны.</span>")
			TIMER_COOLDOWN_START(src, COOLDOWN_MECHA_MESSAGE, 2 SECONDS)
		return FALSE

	if(!Process_Spacemove(direction))
		return FALSE
	if(zoom_mode)
		if(!TIMER_COOLDOWN_CHECK(src, COOLDOWN_MECHA_MESSAGE))
			to_chat(occupants, "[icon2html(src, occupants)]<span class='warning'>Невозможно двигаться в режиме зума!</span>")
			TIMER_COOLDOWN_START(src, COOLDOWN_MECHA_MESSAGE, 2 SECONDS)
		return FALSE
	if(!cell)
		if(!TIMER_COOLDOWN_CHECK(src, COOLDOWN_MECHA_MESSAGE))
			to_chat(occupants, "[icon2html(src, occupants)]<span class='warning'>Не обнаружен аккумулятор.</span>")
			TIMER_COOLDOWN_START(src, COOLDOWN_MECHA_MESSAGE, 2 SECONDS)
		return FALSE
	if(!scanmod || !capacitor)
		if(!TIMER_COOLDOWN_CHECK(src, COOLDOWN_MECHA_MESSAGE))
			to_chat(occupants, "[icon2html(src, occupants)]<span class='warning'>Не обнаружен [scanmod? "конденсатор" : "модуль сканирования"].</span>")
			TIMER_COOLDOWN_START(src, COOLDOWN_MECHA_MESSAGE, 2 SECONDS)
		return FALSE
	if(!use_power(step_energy_drain))
		if(!TIMER_COOLDOWN_CHECK(src, COOLDOWN_MECHA_MESSAGE))
			to_chat(occupants, "[icon2html(src, occupants)]<span class='warning'>Недостаточно энергии для движения!</span>")
			TIMER_COOLDOWN_START(src, COOLDOWN_MECHA_MESSAGE, 2 SECONDS)
		return FALSE
	if(lavaland_only && is_mining_level(z))
		if(!TIMER_COOLDOWN_CHECK(src, COOLDOWN_MECHA_MESSAGE))
			to_chat(occupants, "[icon2html(src, occupants)]<span class='warning'>Неправильное окружение.</span>")
			TIMER_COOLDOWN_START(src, COOLDOWN_MECHA_MESSAGE, 2 SECONDS)
		return FALSE

	var/olddir = dir

	if(internal_damage & MECHA_INT_CONTROL_LOST)
		direction = pick(GLOB.alldirs)

	//only mechs with diagonal movement may move diagonally
	if(!allow_diagonal_movement && ISDIAGONALDIR(direction))
		return TRUE

	var/keyheld = FALSE
	if(strafe)
		for(var/mob/driver as anything in return_drivers())
			if(driver.client?.keys_held["Alt"])
				keyheld = TRUE
				break

	//if we're not facing the way we're going rotate us
	if(dir != direction && !strafe || forcerotate || keyheld)
		if(dir != direction && !(mecha_flags & QUIET_TURNS) && !step_silent)
			playsound(src,turnsound,40,TRUE)
		set_dir_mecha(direction)
		return TRUE

	set_glide_size(DELAY_TO_GLIDE_SIZE(movedelay))
	//Otherwise just walk normally
	. = step(src,direction, dir)
	if(phasing)
		use_power(phasing_energy_drain)
	if(strafe)
		set_dir_mecha(olddir)


/obj/vehicle/sealed/mecha/Bump(atom/obstacle)
	. = ..()
	if(phasing) //Theres only one cause for phasing canpass fails
		addtimer(VARSET_CALLBACK(src, movedelay, TRUE), movedelay*3)
		to_chat(occupants, "[icon2html(src, occupants)]<span class='warning'>Движение заблокировано, [phasing] дальше невозможно!</span>")
		spark_system.start()
		return
	if(.) //mech was thrown/door/whatever
		return
	if(bumpsmash) //Need a pilot to push the PUNCH button.
		if(COOLDOWN_FINISHED(src, mecha_bump_smash))
			obstacle.mech_melee_attack(src)
			COOLDOWN_START(src, mecha_bump_smash, smashcooldown)
			if(!obstacle || obstacle.CanPass(src, get_dir(obstacle, src) || dir)) // The else is in case the obstacle is in the same turf.
				step(src,dir)
	if(isobj(obstacle))
		var/obj/obj_obstacle = obstacle
		if(!obj_obstacle.anchored && obj_obstacle.move_resist <= move_force)
			step(obstacle, dir)
	else if(ismob(obstacle))
		var/mob/mob_obstacle = obstacle
		if(mob_obstacle.move_resist <= move_force)
			step(obstacle, dir)





///////////////////////////////////
////////  Internal damage  ////////
///////////////////////////////////

/// tries to repair any internal damage and plays fluff for it
/obj/vehicle/sealed/mecha/proc/try_repair_int_damage(mob/user, flag_to_heal)
	balloon_alert(user, get_int_repair_fluff_start(flag_to_heal))
	log_message("[key_name(user)] starting internal damage repair for flag [flag_to_heal]", LOG_MECHA)
	if(!do_after(user, 10 SECONDS, src))
		balloon_alert(user, get_int_repair_fluff_fail(flag_to_heal))
		log_message("Internal damage repair for flag [flag_to_heal] failed.", LOG_MECHA, color="red")
		return
	clear_internal_damage(flag_to_heal)
	balloon_alert(user, get_int_repair_fluff_end(flag_to_heal))
	log_message("Finished internal damage repair for flag [flag_to_heal]", LOG_MECHA)

///gets the starting balloon alert flufftext
/obj/vehicle/sealed/mecha/proc/get_int_repair_fluff_start(flag)
	switch(flag)
		if(MECHA_INT_FIRE)
			return "activating internal fire supression..."
		if(MECHA_INT_TEMP_CONTROL)
			return "resetting temperature module..."
		if(MECHA_INT_TANK_BREACH)
			return "activating tank sealant..."
		if(MECHA_INT_CONTROL_LOST)
			return "recalibrating coordination system..."

///gets the successful finish balloon alert flufftext
/obj/vehicle/sealed/mecha/proc/get_int_repair_fluff_end(flag)
	switch(flag)
		if(MECHA_INT_FIRE)
			return "internal fire supressed"
		if(MECHA_INT_TEMP_CONTROL)
			return "temperature chip reactivated"
		if(MECHA_INT_TANK_BREACH)
			return "air tank sealed"
		if(MECHA_INT_CONTROL_LOST)
			return "coordination re-established"

///gets the on-fail balloon alert flufftext
/obj/vehicle/sealed/mecha/proc/get_int_repair_fluff_fail(flag)
	switch(flag)
		if(MECHA_INT_FIRE)
			return "fire supression canceled"
		if(MECHA_INT_TEMP_CONTROL)
			return "reset aborted"
		if(MECHA_INT_TANK_BREACH)
			return "sealant deactivated"
		if(MECHA_INT_CONTROL_LOST)
			return "recalibration failed"

/obj/vehicle/sealed/mecha/proc/set_internal_damage(int_dam_flag)
	internal_damage |= int_dam_flag
	log_message("Internal damage of type [int_dam_flag].", LOG_MECHA)
	SEND_SOUND(occupants, sound('sound/machines/warning-buzzer.ogg',wait=0))
	diag_hud_set_mechstat()

/obj/vehicle/sealed/mecha/proc/clear_internal_damage(int_dam_flag)
	if(internal_damage & int_dam_flag)
		switch(int_dam_flag)
			if(MECHA_INT_TEMP_CONTROL)
				to_chat(occupants, "[icon2html(src, occupants)]<span class='boldnotice'>Система жизнеобеспечения перезагружена.</span>")
			if(MECHA_INT_FIRE)
				to_chat(occupants, "[icon2html(src, occupants)]<span class='boldnotice'>Внутренний пожар остановлен.</span>")
			if(MECHA_INT_TANK_BREACH)
				to_chat(occupants, "[icon2html(src, occupants)]<span class='boldnotice'>Внутренний бак был заизолирован.</span>")
	internal_damage &= ~int_dam_flag
	diag_hud_set_mechstat()

/////////////////////////////////////
//////////// AI piloting ////////////
/////////////////////////////////////

/obj/vehicle/sealed/mecha/attack_ai(mob/living/silicon/ai/user)
	if(!isAI(user))
		return
	//Allows the Malf to scan a mech's status and loadout, helping it to decide if it is a worthy chariot.
	if(user.can_dominate_mechs)
		examine(user) //Get diagnostic information!
		for(var/obj/item/mecha_parts/mecha_tracking/B in trackers)
			to_chat(user, span_danger("Внимание: Отслеживающий маячок обнаружен. Входить на свой страх и риск. Данные:"))
			to_chat(user, "[B.get_mecha_info()]")
			break
		//Nothing like a big, red link to make the player feel powerful!
		to_chat(user, "<a href='?src=[REF(user)];ai_take_control=[REF(src)]'><span class='userdanger'>ПРИНЯТЬ ПРЯМОЕ УПРАВЛЕНИЕ?</span></a><br>")
		return
	examine(user)
	if(length(return_drivers()) > 0)
		to_chat(user, span_warning("Этот мех уже имеет оператора, который не хочет отдавать управление."))
		return
	var/can_control_mech = FALSE
	for(var/obj/item/mecha_parts/mecha_tracking/ai_control/A in trackers)
		can_control_mech = TRUE
		to_chat(user, "<span class='notice'>[icon2html(src, user)] Состояние [name]:</span>\n[A.get_mecha_info()]")
		break
	if(!can_control_mech)
		to_chat(user, span_warning("Невозможно контролировать мех без специального маяка. Откат."))
		return
	to_chat(user, "<a href='?src=[REF(user)];ai_take_control=[REF(src)]'><span class='boldnotice'>Принять управление мехом?</span></a><br>")

/obj/vehicle/sealed/mecha/transfer_ai(interaction, mob/user, mob/living/silicon/ai/AI, obj/item/aicard/card)
	. = ..()
	if(!.)
		return

	//Transfer from core or card to mech. Proc is called by mech.
	switch(interaction)
		if(AI_TRANS_TO_CARD) //Upload AI from mech to AI card.
			if(!construction_state) //Mech must be in maint mode to allow carding.
				to_chat(user, span_warning("[name] должен иметь активные технические протоколы для входа."))
				return
			var/list/ai_pilots = list()
			for(var/mob/living/silicon/ai/aipilot in occupants)
				ai_pilots += aipilot
			if(!ai_pilots.len) //Mech does not have an AI for a pilot
				to_chat(user, span_warning("Не обнаружено ИИ в набортном компьютере [name]."))
				return
			if(ai_pilots.len > 1) //Input box for multiple AIs, but if there's only one we'll default to them.
				AI = tgui_input_list(user, "Какой ИИ должен управлять?", "Выбор ИИ", sort_list(ai_pilots))
			else
				AI = ai_pilots[1]
			if(!AI)
				return
			if(!(AI in occupants) || !user.Adjacent(src))
				return //User sat on the selection window and things changed.

			AI.ai_restore_power()//So the AI initially has power.
			AI.control_disabled = TRUE
			AI.radio_enabled = FALSE
			AI.disconnect_shell()
			remove_occupant(AI)
			mecha_flags  &= ~SILICON_PILOT
			AI.forceMove(card)
			card.AI = AI
			AI.controlled_equipment = null
			AI.remote_control = null
			to_chat(AI, span_notice("Меня загружают на карту. Беспроводное соединение отключено."))
			to_chat(user, "<span class='boldnotice'>Передача успешна</span>: [AI.name] ([rand(1000,9999)].exe) удалён из [name] и теперь хранится во внутренней памяти устройства.")
			return

		if(AI_MECH_HACK) //Called by AIs on the mech
			AI.linked_core = new /obj/structure/ai_core/deactivated(AI.loc)
			if(AI.can_dominate_mechs && LAZYLEN(occupants)) //Oh, I am sorry, were you using that?
				to_chat(AI, span_warning("Обнаружен пилот! Экстренное катапультирование активировано!"))
				to_chat(occupants, span_danger("Ух, ох!"))
				for(var/ejectee in occupants)
					mob_exit(ejectee, TRUE, TRUE) //IT IS MINE, NOW. SUCK IT, RD!
				AI.can_shunt = FALSE //ONE AI ENTERS. NO AI LEAVES.

		if(AI_TRANS_FROM_CARD) //Using an AI card to upload to a mech.
			AI = card.AI
			if(!AI)
				to_chat(user, span_warning("Здесь нет ИИ на карте."))
				return
			if(AI.deployed_shell) //Recall AI if shelled so it can be checked for a client
				AI.disconnect_shell()
			if(AI.stat || !AI.client)
				to_chat(user, span_warning("[AI.name] более не отвечает на запросы, выгрузка невозможна."))
				return
			if((LAZYLEN(occupants) >= max_occupants) || dna_lock) //Normal AIs cannot steal mechs!
				to_chat(user, span_warning("Доступ запрещён. [name] уже [LAZYLEN(occupants) >= max_occupants ? "полностью занят" : "заблокирован при помощи ДНК"]."))
				return
			AI.control_disabled = FALSE
			AI.radio_enabled = TRUE
			to_chat(user, "<span class='boldnotice'>Передача успешна</span>: [AI.name] ([rand(1000,9999)].exe) установлен и запущен успешно. Локальная копия удалена.")
			card.AI = null
	ai_enter_mech(AI)

///Hack and From Card interactions share some code, so leave that here for both to use.
/obj/vehicle/sealed/mecha/proc/ai_enter_mech(mob/living/silicon/ai/AI)
	AI.ai_restore_power()
	mecha_flags |= SILICON_PILOT
	moved_inside(AI)
	AI.eyeobj?.forceMove(src)
	AI.eyeobj?.RegisterSignal(src, COMSIG_MOVABLE_MOVED, /mob/camera/ai_eye/proc/update_visibility)
	AI.controlled_equipment = src
	AI.remote_control = src
	to_chat(AI, AI.can_dominate_mechs ? span_announce("Захват [name] успешен! Теперь я нахожусь в набортном компьютере. Что-то запрещает мне покидать станцию!")  :\
		span_notice("Меня загружают в набортный компьютер меха."))
	to_chat(AI, "<span class='reallybig boldnotice'>Используй СКМ для активации функций и оборудования. Кликай обычно для взаимодействия как ИИ.</span>")


///Handles an actual AI (simple_animal mecha pilot) entering the mech
/obj/vehicle/sealed/mecha/proc/aimob_enter_mech(mob/living/simple_animal/hostile/syndicate/mecha_pilot/pilot_mob)
	if(!pilot_mob?.Adjacent(src))
		return
	if(LAZYLEN(occupants))
		return
	LAZYSET(occupants, pilot_mob, NONE)
	pilot_mob.mecha = src
	pilot_mob.forceMove(src)
	update_icon()

///Handles an actual AI (simple_animal mecha pilot) exiting the mech
/obj/vehicle/sealed/mecha/proc/aimob_exit_mech(mob/living/simple_animal/hostile/syndicate/mecha_pilot/pilot_mob)
	LAZYREMOVE(occupants, pilot_mob)
	if(pilot_mob.mecha == src)
		pilot_mob.mecha = null
	pilot_mob.forceMove(get_turf(src))
	update_icon()



/obj/vehicle/sealed/mecha/mob_try_enter(mob/M)
	if(!ishuman(M)) // no silicons or drones in mechas.
		return
	if(HAS_TRAIT(M, TRAIT_PRIMITIVE)) //no lavalizards either.
		to_chat(M, span_warning("Что это такое?!"))
		return
	log_message("[M] tries to move into [src].", LOG_MECHA)
	if(dna_lock && M.has_dna())
		var/mob/living/carbon/entering_carbon = M
		if(entering_carbon.dna.unique_enzymes != dna_lock)
			to_chat(M, span_warning("Доступ запрещён. [name] заблокирован при помощи ДНК."))
			log_message("Permission denied (DNA LOCK).", LOG_MECHA)
			return
	if(!operation_allowed(M))
		to_chat(M, span_warning("Доступ запрещён. Недостаточно прав."))
		log_message("Permission denied (No keycode).", LOG_MECHA)
		return
	if(M.buckled)
		to_chat(M, span_warning("Да мне бы со стула встать сначала."))
		log_message("Permission denied (Buckled).", LOG_MECHA)
		return
	if(M.has_buckled_mobs()) //mob attached to us
		to_chat(M, span_warning("Не могу войти с кем-то внутрь!"))
		log_message("Permission denied (Attached mobs).", LOG_MECHA)
		return

	visible_message(span_notice("[M] начинает забираться в [name]."))

	if(do_after(M, enter_delay, target = src))
		if(obj_integrity <= 0)
			to_chat(M, span_warning("Не могу забраться в [name], ведь он уничтожен!"))
		else if(LAZYLEN(occupants) >= max_occupants)
			to_chat(M, span_danger("[occupants[occupants.len]] быстрее! Лузер..."))//get the last one that hopped in
		else if(M.buckled)
			to_chat(M, span_warning("Надо бы отстегнуться."))
		else if(M.has_buckled_mobs())
			to_chat(M, span_warning("Не могу войти с кем-то внутрь!"))
		else
			moved_inside(M)
			return ..()
	else
		to_chat(M, span_warning("Прекращаю вход в меха!"))


/obj/vehicle/sealed/mecha/generate_actions()
	initialize_passenger_action_type(/datum/action/vehicle/sealed/mecha/mech_eject)
	initialize_controller_action_type(/datum/action/vehicle/sealed/mecha/mech_toggle_internals, VEHICLE_CONTROL_SETTINGS)
	initialize_controller_action_type(/datum/action/vehicle/sealed/mecha/mech_toggle_lights, VEHICLE_CONTROL_SETTINGS)
	initialize_controller_action_type(/datum/action/vehicle/sealed/mecha/mech_view_stats, VEHICLE_CONTROL_SETTINGS)
	initialize_controller_action_type(/datum/action/vehicle/sealed/mecha/strafe, VEHICLE_CONTROL_DRIVE)

/obj/vehicle/sealed/mecha/proc/moved_inside(mob/living/newoccupant)
	if(!(newoccupant?.client))
		return FALSE
	if(ishuman(newoccupant) && !Adjacent(newoccupant))
		return FALSE
	add_occupant(newoccupant)
	newoccupant.forceMove(src)
	newoccupant.update_mouse_pointer()
	add_fingerprint(newoccupant)
	log_message("[newoccupant] moved in as pilot.", LOG_MECHA)
	set_dir_mecha(dir_in)
	playsound(src, 'sound/machines/windowdoor.ogg', 50, TRUE)
	set_mouse_pointer()
	if(!internal_damage)
		SEND_SOUND(newoccupant, sound('sound/mecha/nominal.ogg',volume=50))
	return TRUE

/obj/vehicle/sealed/mecha/proc/mmi_move_inside(obj/item/mmi/M, mob/user)
	if(!M.brain_check(user))
		return FALSE

	var/mob/living/brain/B = M.brainmob
	if(LAZYLEN(occupants) >= max_occupants)
		to_chat(user, span_warning("Полон!"))
		return FALSE
	if(dna_lock && (!B.stored_dna || (dna_lock != B.stored_dna.unique_enzymes)))
		to_chat(user, span_warning("Доступ запрещён. [name] заблокирован при помощи ДНК."))
		return FALSE

	visible_message(span_notice("[user] начинает вставлять MMI в [name]."))

	if(!do_after(user, 4 SECONDS, target = src))
		to_chat(user, span_notice("Прекращаю вставлять MMI."))
		return FALSE
	if(LAZYLEN(occupants) < max_occupants)
		return mmi_moved_inside(M, user)
	to_chat(user, span_warning("Внутри уже кто-то есть!"))
	return FALSE

/obj/vehicle/sealed/mecha/proc/mmi_moved_inside(obj/item/mmi/M, mob/user)
	if(!(Adjacent(M) && Adjacent(user)))
		return FALSE
	if(!M.brain_check(user))
		return FALSE

	var/mob/living/brain/B = M.brainmob
	if(!user.transferItemToLoc(M, src))
		to_chat(user, span_warning("[M] застрял в моей руке, я не могу просто взять и вставить его в <b>[src.name]</b>!"))
		return FALSE

	M.set_mecha(src)
	add_occupant(B)//Note this forcemoves the brain into the mech to allow relaymove
	mecha_flags |= SILICON_PILOT
	B.reset_perspective(src)
	B.remote_control = src
	B.update_mouse_pointer()
	set_dir_mecha(dir_in)
	log_message("[M] moved in as pilot.", LOG_MECHA)
	if(!internal_damage)
		SEND_SOUND(M, sound('sound/mecha/nominal.ogg',volume=50))
	log_game("[key_name(user)] has put the MMI/posibrain of [key_name(B)] into [src] at [AREACOORD(src)]")
	return TRUE

/obj/vehicle/sealed/mecha/container_resist_act(mob/living/user)
	if(isAI(user))
		var/mob/living/silicon/ai/AI = user
		if(!AI.can_shunt)
			to_chat(AI, span_notice("Я не могу вылезти из меха после доминации над ним!"))
			return FALSE
	to_chat(user, span_notice("Начинаю процедуру извлечения. Оборудование будет отключено на это время. Подождём."))
	is_currently_ejecting = TRUE
	if(do_after(user, has_gravity() ? exit_delay : 0 , target = src))
		to_chat(user, span_notice("Выхожу из меха."))
		mob_exit(user, TRUE)
	else
		to_chat(user, span_notice("Прекращаю выходить из меха. Пушки снова работают."))
	is_currently_ejecting = FALSE


/obj/vehicle/sealed/mecha/mob_exit(mob/M, silent, forced)
	var/atom/movable/mob_container
	var/turf/newloc = get_turf(src)
	if(ishuman(M))
		mob_container = M
	else if(isbrain(M))
		var/mob/living/brain/brain = M
		mob_container = brain.container
	else if(isAI(M))
		var/mob/living/silicon/ai/AI = M
		//stop listening to this signal, as the static update is now handled by the eyeobj's setLoc
		AI.eyeobj?.UnregisterSignal(src, COMSIG_MOVABLE_MOVED)
		AI.eyeobj?.forceMove(newloc) //kick the eye out as well
		if(forced)//This should only happen if there are multiple AIs in a round, and at least one is Malf.
			AI.gib()  //If one Malf decides to steal a mech from another AI (even other Malfs!), they are destroyed, as they have nowhere to go when replaced.
			AI = null
			mecha_flags &= ~SILICON_PILOT
			return
		else
			if(!AI.linked_core)
				if(!silent)
					to_chat(AI, span_userdanger("Ядро уничтожено. Возврат невозможен."))
				AI.linked_core = null
				return
			if(!silent)
				to_chat(AI, span_notice("Возвращаемся в ядро..."))
			AI.controlled_equipment = null
			AI.remote_control = null
			mob_container = AI
			newloc = get_turf(AI.linked_core)
			qdel(AI.linked_core)
	else
		return ..()
	var/mob/living/ejector = M
	mecha_flags  &= ~SILICON_PILOT
	mob_container.forceMove(newloc)//ejecting mob container
	log_message("[mob_container] moved out.", LOG_MECHA)
	SStgui.close_user_uis(M, src)
	if(istype(mob_container, /obj/item/mmi))
		var/obj/item/mmi/mmi = mob_container
		if(mmi.brainmob)
			ejector.forceMove(mmi)
			ejector.reset_perspective()
			remove_occupant(ejector)
		mmi.set_mecha(null)
		mmi.update_icon()
	set_dir_mecha(dir_in)
	return ..()


/obj/vehicle/sealed/mecha/add_occupant(mob/M, control_flags)
	RegisterSignal(M, COMSIG_LIVING_DEATH, PROC_REF(mob_exit))
	RegisterSignal(M, COMSIG_MOB_CLICKON, PROC_REF(on_mouseclick))
	RegisterSignal(M, COMSIG_MOB_SAY, PROC_REF(display_speech_bubble))
	. = ..()
	update_icon()

/obj/vehicle/sealed/mecha/remove_occupant(mob/M)
	UnregisterSignal(M, COMSIG_LIVING_DEATH)
	UnregisterSignal(M, COMSIG_MOB_CLICKON)
	UnregisterSignal(M, COMSIG_MOB_SAY)
	M.clear_alert("charge")
	M.clear_alert("mech damage")
	if(M.client)
		M.update_mouse_pointer()
		M.client.view_size.resetToDefault()
		zoom_mode = FALSE
	. = ..()
	update_icon()

/////////////////////////
////// Access stuff /////
/////////////////////////

/obj/vehicle/sealed/mecha/proc/operation_allowed(mob/M)
	req_access = operation_req_access
	req_one_access = list()
	return allowed(M)

/obj/vehicle/sealed/mecha/proc/internals_access_allowed(mob/M)
	req_one_access = internals_req_access
	req_access = list()
	return allowed(M)


///////////////////////
///// Power stuff /////
///////////////////////

/obj/vehicle/sealed/mecha/proc/has_charge(amount)
	return (get_charge()>=amount)

/obj/vehicle/sealed/mecha/proc/get_charge()
	return cell?.charge

/obj/vehicle/sealed/mecha/proc/use_power(amount)
	return (get_charge() && cell.use(amount))

/obj/vehicle/sealed/mecha/proc/give_power(amount)
	if(!isnull(get_charge()))
		cell.give(amount)
		return TRUE
	return FALSE



/////////////////////////////////////
////////  Atmospheric stuff  ////////
/////////////////////////////////////

/obj/vehicle/sealed/mecha/remove_air(amount)
	if(use_internal_tank)
		return cabin_air.remove(amount)
	return ..()

/obj/vehicle/sealed/mecha/return_air()
	if(use_internal_tank)
		return cabin_air
	return ..()

/obj/vehicle/sealed/mecha/return_analyzable_air()
	return cabin_air

///fetches pressure of the gas mixture we are using
/obj/vehicle/sealed/mecha/proc/return_pressure()
	var/datum/gas_mixture/air = return_air()
	return air?.return_pressure()

///fetches temp of the gas mixture we are using
/obj/vehicle/sealed/mecha/return_temperature()
	var/datum/gas_mixture/air = return_air()
	return air?.return_temperature()



///////////////////////
////// Ammo stuff /////
///////////////////////

/obj/vehicle/sealed/mecha/proc/ammo_resupply(obj/item/mecha_ammo/A, mob/user,fail_chat_override = FALSE)
	if(!A.rounds)
		if(!fail_chat_override)
			to_chat(user, span_warning("Коробка с патронами пустая!"))
		return FALSE
	var/ammo_needed
	var/found_gun
	for(var/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/gun in flat_equipment)
		ammo_needed = 0

		if(!istype(gun, /obj/item/mecha_parts/mecha_equipment/weapon/ballistic) && gun.ammo_type == A.ammo_type)
			continue
		found_gun = TRUE
		if(A.direct_load)
			ammo_needed = initial(gun.projectiles) - gun.projectiles
		else
			ammo_needed = gun.projectiles_cache_max - gun.projectiles_cache

		if(!ammo_needed)
			continue
		if(ammo_needed < A.rounds)
			if(A.direct_load)
				gun.projectiles = gun.projectiles + ammo_needed
			else
				gun.projectiles_cache = gun.projectiles_cache + ammo_needed
			playsound(get_turf(user),A.load_audio,50,TRUE)
			to_chat(user, span_notice("Загружаю [ammo_needed] [A.round_term][A.rounds > 1?"":"у"] в [gun.name]"))
			A.rounds = A.rounds - ammo_needed
			if(A.custom_materials)
				A.set_custom_materials(A.custom_materials, A.rounds / initial(A.rounds))
			A.update_name()
			return TRUE

		if(A.direct_load)
			gun.projectiles = gun.projectiles + A.rounds
		else
			gun.projectiles_cache = gun.projectiles_cache + A.rounds
		playsound(get_turf(user),A.load_audio,50,TRUE)
		to_chat(user, span_notice("Загружаю [A.rounds] [A.round_term][A.rounds > 1?"":"у"] в [gun.name]"))
		A.rounds = 0
		A.set_custom_materials(list(/datum/material/iron=2000))
		A.update_name()
		return TRUE
	if(!fail_chat_override)
		if(found_gun)
			to_chat(user, span_notice("Больше не помещается!"))
		else
			to_chat(user, span_notice("Эти патроны не подходят вообще!"))
	return FALSE


/// Special light eater handling
/obj/vehicle/sealed/mecha/proc/on_light_eater(obj/vehicle/sealed/source, datum/light_eater)
	SIGNAL_HANDLER
	if(mecha_flags & HAS_LIGHTS)
		visible_message(span_danger("[src] прощается с лампочками!"))
		mecha_flags &= ~HAS_LIGHTS
	set_light_on(FALSE)
	for(var/occupant in occupants)
		remove_action_type_from_mob(/datum/action/vehicle/sealed/mecha/mech_toggle_lights, occupant)
	return COMPONENT_BLOCK_LIGHT_EATER

/// Sets the direction of the mecha and all of its occcupents, required for FOV. Alternatively one could make a recursive contents registration and register topmost direction changes in the fov component
/obj/vehicle/sealed/mecha/proc/set_dir_mecha(new_dir)
	setDir(new_dir)
	for(var/mob/living/occupant as anything in occupants)
		occupant.setDir(new_dir)

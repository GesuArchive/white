/datum/dcm_net
	/*Hub machine
		The hub machine acts as the main container for the network.
		influences the following values through proc/UpdateNetwork():
	transfer_limit = max amount of each material transfered in any given push/pull
	max_connected = number of machines that can be connected at once
	*/
	var/obj/machinery/deepcore/hub/netHub
	var/transfer_limit = 0
	var/max_connected = 0
	// List of connected machines
	var/list/obj/machinery/deepcore/connected = list()

/datum/dcm_net/New(obj/machinery/deepcore/hub/source)
	if(!source)
		stack_trace("dcm_net created without a valid source!")
		qdel(src)
	netHub = source

// ** Machine handling procs **

/datum/dcm_net/Destroy()
	netHub.network = null
	if(connected)
		for (var/obj/machinery/deepcore/M in connected)
			M.network = null
	return ..()

/datum/dcm_net/proc/AddMachine(obj/machinery/deepcore/M)
	if(connected.len >= max_connected)
		playsound(M, 'sound/machines/buzz-sigh.ogg', 30)
		M.visible_message("<span class='warning'>[M] fails to connect! The display reads 'ERROR: Connection limit reached!'</span>")
		return FALSE
	if(!(M in connected))
		connected += M
		M.network = src
		return TRUE

/datum/dcm_net/proc/RemoveMachine(obj/machinery/deepcore/M)
	if(M in connected)
		connected -= M
		M.network = null
		//Destroys the network if there's no more machines attached
		if(!length(connected))
			connected = null
			qdel(src)
		return TRUE

/datum/dcm_net/proc/MergeWith(datum/dcm_net/net)
	for (var/obj/machinery/deepcore/M in net.connected)
		AddMachine(M)
	qdel(net)

// ** Ore handling procs **

/datum/dcm_net/proc/Push(var/datum/component/material_container/cont)
	for(var/O in cont.materials)
		var/datum/material/M = O
		cont.transer_amt_to(netHub.container, transfer_limit, M)

/datum/dcm_net/proc/Pull(var/datum/component/material_container/cont)
	for(var/O in netHub.container.materials)
		var/datum/material/M = O
		netHub.container.transer_amt_to(cont, transfer_limit, M)

GLOBAL_DATUM(dcm_net_default, /datum/dcm_net)
/obj/machinery/deepcore/hub
	name = "Deepcore Mining Control Hub"
	desc = "Houses the server which processes all connected mining equipment."
	icon_state = "hub"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/deepcore/hub

/obj/machinery/deepcore/hub/Initialize(mapload)
	. = ..()
	if(mapload)
		if(!GLOB.dcm_net_default)
			GLOB.dcm_net_default = new /datum/dcm_net(src)
		network = GLOB.dcm_net_default
	else if (!network)
		network = new /datum/dcm_net(src)
	RefreshParts()

/obj/machinery/deepcore/hub/Destroy()
	qdel(network)
	return ..()

/obj/machinery/deepcore/hub/examine(mob/user)
	. = ..()
	. += "<hr><span class='info'>Linked to [network.connected.len] machines.</span>"
	. += "\n<span class='notice'>Deep core mining equipment can be linked to [src.name] with a multitool.</span>"

/obj/machinery/deepcore/hub/RefreshParts()
	//Matter bins = size of container
	var/MB_value = 0
	for(var/obj/item/stock_parts/matter_bin/MB in component_parts)
		MB_value += MINERAL_MATERIAL_AMOUNT * 10 ** MB.rating
	container.max_amount = MB_value
	if(network)
		//Micro Laser = transfer limit
		var/ML_value = 0
		for(var/obj/item/stock_parts/micro_laser/ML in component_parts)
			ML_value += MINERAL_MATERIAL_AMOUNT * 5 ** ML.rating
		network.transfer_limit = ML_value
		//Micro Manipulator = connected limit
		var/MM_value = 0
		for(var/obj/item/stock_parts/manipulator/MM in component_parts)
			MM_value += 3 * MM.rating + 2
		network.max_connected = MM_value

/obj/machinery/deepcore/hub/multitool_act(mob/living/user, obj/item/multitool/I)
	. = ..()
	if (istype(I))
		to_chat(user, "<span class='notice'>You load the network data on to the multitool...</span>")
		I.buffer = network
		return TRUE

/obj/machinery/deepcore/hub/ui_interact(mob/user, datum/tgui/ui)
	user.set_machine(src)
	var/datum/browser/popup = new(user, "dcm_hub", null, 600, 550)
	popup.set_content(generate_ui())
	popup.open()

/obj/machinery/deepcore/hub/proc/generate_ui()
	var/dat = "<div class='statusDisplay'><h3>Deepcore Network Hub:</h3><br>"
	dat = "<h2>Connected to [network.connected.len] machines.</h4>"
	for(var/M in network.connected)
		var/obj/machinery/deepcore/D = M
		dat += "[D.x], [D.y], [D.z] : <b>[D.name]</b>"
		dat += "<br>"
	dat += "</div>"
	return dat

// DCM NETWORK LOGIC

/*\
	Crude Material Container - Subcomponent to support the transfer of unrefined ores
	Assumes ores are the same material value as sheets, because at the time of writing they in fact are.
\*/

//I know it still says sheets but bear with me here, it's ores now
/datum/component/material_container/crude/retrieve_sheets(sheet_amt, datum/material/M, target)
	if((!M.sheet_type) || (sheet_amt <= 0))
		return 0
	if(!target)
		target = get_turf(parent)
	if(materials[M] < (sheet_amt * MINERAL_MATERIAL_AMOUNT))
		sheet_amt = round(materials[M] / MINERAL_MATERIAL_AMOUNT)
	var/count = 0
	while(sheet_amt > MAX_STACK_SIZE)
		new M.sheet_type(target, MAX_STACK_SIZE)
		count += MAX_STACK_SIZE
		use_amount_mat(sheet_amt * MINERAL_MATERIAL_AMOUNT, M)
		sheet_amt -= MAX_STACK_SIZE
	if(sheet_amt >= 1)
		new M.sheet_type(target, sheet_amt)
		count += sheet_amt
		use_amount_mat(sheet_amt * MINERAL_MATERIAL_AMOUNT, M)
	return count

/*\
	Deepcore machines:
		network - The DCMnet itself
		container - The material container component used for those sweet mats
\*/
/obj/machinery/deepcore
	icon = 'white/valtos/icons/deepcore.dmi'
	var/datum/dcm_net/network
	var/datum/component/material_container/crude/container

/obj/machinery/deepcore/Initialize(mapload)
	. = ..()
	if(mapload && !network && GLOB.dcm_net_default)
		SetNetwork(GLOB.dcm_net_default)

/obj/machinery/deepcore/ComponentInitialize()
	. = ..()
	var/static/list/ores_list = list(
		/datum/material/iron,
		/datum/material/glass,
		/datum/material/silver,
		/datum/material/gold,
		/datum/material/diamond,
		/datum/material/plasma,
		/datum/material/uranium,
		/datum/material/bananium,
		/datum/material/titanium,
		/datum/material/bluespace
	)
	// container starts with 0 max amount
	container = AddComponent(/datum/component/material_container/crude, ores_list, 0, FALSE, null, null, null, TRUE)

/obj/machinery/deepcore/multitool_act(mob/living/user, obj/item/multitool/I)
	. = ..()
	if(!istype(I))
		return FALSE

	//Check if we would like to add a network
	if(istype(I.buffer, /datum/dcm_net))
		if(network)
			to_chat(user, "<span class='notice'>You move [src.name] onto the network saved in the multitool's buffer...</span>")
			ClearNetwork()
			SetNetwork(I.buffer)
			return TRUE
		else
			to_chat(user, "<span class='notice'>You load the saved network data into [src.name] and test the connection...</span>")
			SetNetwork(I.buffer)
			return TRUE

/obj/machinery/deepcore/examine(mob/user)
	. = ..()
	if(network)
		. += "<hr><span class='info'>This device is registered with a network connected to [length(network.connected)] devices.</span>"

/obj/machinery/deepcore/proc/SetNetwork(var/datum/dcm_net/net)
	return net.AddMachine(src)

/obj/machinery/deepcore/proc/ClearNetwork()
	return network.RemoveMachine(src)

/obj/machinery/deepcore/proc/MergeNetwork(var/datum/dcm_net/net)
	network.MergeWith(net)

/obj/machinery/deepcore/drill
	name = "Deep Core Bluespace Drill"
	desc = "Мощная машина, которая способна извлекать руду из недр планеты."
	icon = 'white/valtos/icons/drill.dmi'
	icon_state = "deep_core_drill"
	density = TRUE
	anchored = FALSE
	use_power = NO_POWER_USE
	pressure_resistance = 30
	max_integrity = 200
	integrity_failure = 0.3
	circuit = /obj/item/circuitboard/machine/deepcore/drill

	var/deployed = FALSE //If the drill is anchored and ready-to-mine
	var/active = FALSE //If the drill is activly mining ore
	var/obj/effect/landmark/ore_vein/active_vein //Ore vein currently set to be mined in

/obj/machinery/deepcore/drill/Initialize(mapload)
	. = ..()
	container.max_amount = 4000 //Give the drill some room to buffer mats, but not much

/obj/machinery/deepcore/drill/interact(mob/user, special_state)
	. = ..()
	if(machine_stat & BROKEN)
		return .
	if(deployed)
		if(active)
			active = FALSE
			to_chat(user, "<span class='notice'>Деактивирую [src.name].</span>")
		else
			active = TRUE
			to_chat(user, "<span class='notice'>Реактивирую [src.name].</span>")
		update_icon_state()
		update_overlays()
		return TRUE
	else
		var/obj/effect/landmark/ore_vein/O = scanArea()
		if(O)
			anchored = TRUE
			playsound(src, 'sound/machines/windowdoor.ogg', 50)
			flick("deep_core_drill-deploy", src)
			addtimer(CALLBACK(src, .proc/Deploy), 14)
			to_chat(user, "<span class='notice'>[capitalize(src.name)] обнаруживает [O.name] и начинает работу...</span>")
			return TRUE
		else
			to_chat(user, "<span class='warning'>[capitalize(src.name)] не может найти руду в зоне!</span>")

/obj/machinery/deepcore/drill/AltClick(mob/user)
	. = ..()
	if(active)
		to_chat(user, "<span class='warning'>Не могу выключить пока [src.name] активен!</span>")
		return
	else
		playsound(src, 'sound/machines/windowdoor.ogg', 50)
		flick("deep_core_drill-undeploy", src)
		addtimer(CALLBACK(src, .proc/Undeploy), 13)

/obj/machinery/deepcore/drill/process()
	if(machine_stat & BROKEN || (active && !active_vein))
		active = FALSE
		update_overlays()
		update_icon_state()
		return
	if(deployed && active)
		if(!mineOre())
			active = FALSE
			update_overlays()
			update_icon_state()
		if(network)
			network.Push(container)
		else //Dry deployment of ores
			dropOre()

/obj/machinery/deepcore/drill/proc/mineOre()
	var/list/extracted = active_vein.extract_ore()
	for(var/O in extracted)
		var/datum/material/M = O
		container.insert_amount_mat(extracted[M], M)
	return TRUE

/obj/machinery/deepcore/drill/proc/dropOre(datum/material/M, amount)
	return container.retrieve_all(get_step(src, SOUTH))

/obj/machinery/deepcore/drill/proc/scanArea()
	//Checks for ores and latches to an active vein if one is located.
	var/turf/deployed_zone = get_turf(src)
	var/obj/effect/landmark/ore_vein/vein = locate() in deployed_zone
	if(vein)
		active_vein = vein
		return vein
	else
		return FALSE

/obj/machinery/deepcore/drill/proc/Deploy()
	deployed = TRUE
	update_icon_state()
	playsound(src, 'sound/machines/boltsdown.ogg', 50)
	visible_message("<span class='notice'>[capitalize(src)] готов к работе!</span>")

/obj/machinery/deepcore/drill/proc/Undeploy()
	active_vein = null
	deployed = FALSE
	anchored = FALSE
	update_icon_state()
	playsound(src, 'sound/machines/boltsup.ogg', 50)
	visible_message("<span class='notice'>[capitalize(src)] готов к движению!</span>")

/obj/machinery/deepcore/drill/update_icon_state()
	if(deployed)
		if(machine_stat & BROKEN)
			icon_state = "deep_core_drill-deployed-broken"
			return
		if(active)
			icon_state = "deep_core_drill-active"
		else
			icon_state = "deep_core_drill-idle"
	else
		if(machine_stat & BROKEN)
			icon_state = "deep_core_drill-broken"
		else
			icon_state = "deep_core_drill"

/obj/machinery/deepcore/drill/update_overlays()
	. = ..()
	SSvis_overlays.remove_vis_overlay(src, managed_vis_overlays)
	//Cool beam of light ignores shadows.
	if(active && deployed)
		set_light(3, 1, "99FFFF")
		SSvis_overlays.add_vis_overlay(src, icon, "mining_beam-particles", layer, plane, dir)
		SSvis_overlays.add_vis_overlay(src, icon, "mining_beam-particles", layer, EMISSIVE_PLANE, dir)
	else
		set_light(0)

/obj/machinery/deepcore/drill/obj_break(damage_flag)
	. = ..()
	if(.)
		active = FALSE
		set_light(0)
		update_overlays()

/obj/machinery/deepcore/drill/can_be_unfasten_wrench(mob/user, silent)
	to_chat(user, "<span class='notice'>Мне потребуется гаечный ключ для установки [src.name]!</span>")
	return CANT_UNFASTEN

/obj/item/circuitboard/machine/deepcore/drill
	name = "Deep Core Bluespace Drill (Machine Board)"
	icon_state = "supply"
	build_path = /obj/machinery/deepcore/drill
	req_components = list(
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/matter_bin = 1)

/obj/item/circuitboard/machine/deepcore/hopper
	name = "Bluespace Material Hopper (Machine Board)"
	icon_state = "supply"
	build_path = /obj/machinery/deepcore/hopper
	req_components = list(
		/obj/item/stack/ore/bluespace_crystal = 2,
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/matter_bin = 2)
	def_components = list(/obj/item/stack/ore/bluespace_crystal = /obj/item/stack/ore/bluespace_crystal/artificial)

/obj/item/circuitboard/machine/deepcore/hub
	name = "Deepcore Mining Control Hub (Machine Board)"
	icon_state = "supply"
	build_path = /obj/machinery/deepcore/hub
	req_components = list(
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stock_parts/matter_bin = 3,
		/obj/item/stock_parts/manipulator = 2)

/obj/item/deepcorecapsule
	name = "deepcore drill deployment capsule"
	desc = "A deepcore mining drill compressed into an easy-to-deploy capsule."
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "capsule_dcm"
	w_class = WEIGHT_CLASS_TINY
	var/to_deploy = /obj/machinery/deepcore/drill

/obj/item/deepcorecapsule/attack_self()
	loc.visible_message("<span class='warning'>[capitalize(src.name)] begins to shake. Stand back!</span>")
	addtimer(CALLBACK(src, .proc/Deploy), 50)

/obj/item/deepcorecapsule/proc/Deploy()
	if(QDELETED(src) || !to_deploy)
		return
	playsound(src, 'sound/effects/phasein.ogg', 100, TRUE)
	var/turf/deploy_location = get_turf(src)
	new to_deploy(deploy_location)
	new /obj/effect/particle_effect/smoke(deploy_location)
	qdel(src)

/obj/item/pinpointer/deepcore
	name = "deep core pinpointer"
	desc = "A handheld dowsing utility for locating material deep beneath the surface."
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "miningpinpointing"
	custom_price = 300
	custom_premium_price = 300
	icon_suffix = "_mining"

/obj/item/pinpointer/deepcore/attack_self(mob/living/user)
	if(active)
		toggle_on()
		user.visible_message("<span class='notice'>[user] deactivates [user.p_their()] pinpointer.</span>", "<span class='notice'>You deactivate your pinpointer.</span>")
		return

	var/vein = LocateVein(user)
	if(!vein)
		user.visible_message("<span class='notice'>[user]'s pinpointer fails to detect any material.</span>", "<span class='notice'>Your pinpointer fails to detect any material.</span>")
		return

	target = vein
	toggle_on()
	user.visible_message("<span class='notice'>[user] activates [user.p_their()] pinpointer.</span>", "<span class='notice'>You activate your pinpointer.</span>")

/obj/item/pinpointer/deepcore/proc/LocateVein(mob/living/user)
	var/turf/here = get_turf(src)
	var/located_dist
	var/obj/effect/landmark/located_vein
	for(var/obj/effect/landmark/I in GLOB.ore_vein_landmarks)
		if(located_vein)
			var/new_dist = get_dist(here, get_turf(I))
			if(new_dist < located_dist)
				located_dist = new_dist
				located_vein = I
		else
			located_dist = get_dist(here, get_turf(I))
			located_vein = I
	return located_vein

/obj/item/pinpointer/deepcore/advanced
	name = "advanced deep core pinpointer"
	desc = "A sophisticated dowsing utility for locating specific materials at any depth."
	icon_state = "miningadvpinpointing"
	custom_price = 600
	custom_premium_price = 600

/obj/item/pinpointer/deepcore/advanced/LocateVein(mob/living/user)
	//Sorts vein artifacts by ore type
	var/viens_by_type = list()
	for(var/obj/effect/landmark/ore_vein/I in GLOB.ore_vein_landmarks)
		if(islist(viens_by_type[I.resource]))
			var/list/L = viens_by_type[I.resource]
			L += I
		else
			viens_by_type[I.resource] = list(I)
	var/A = input(user, "Type to locate", "DCM") in sortList(viens_by_type)
	if(!A || QDELETED(src) || !user || !user.is_holding(src) || user.incapacitated())
		return
	//Searches for nearest ore vein as usual
	var/turf/here = get_turf(src)
	var/located_dist
	var/obj/effect/landmark/located_vein
	for(var/obj/effect/landmark/I in viens_by_type[A])
		if(located_vein)
			var/new_dist = get_dist(here, get_turf(I))
			if(new_dist < located_dist)
				located_dist = new_dist
				located_vein = I
		else
			located_dist = get_dist(here, get_turf(I))
			located_vein = I
	return located_vein

GLOBAL_LIST_EMPTY(ore_vein_landmarks)

/obj/effect/landmark/ore_vein
	name = "ore vein"
	var/datum/material/resource
	var/material_rate = 0

/obj/effect/landmark/ore_vein/Initialize(mapload, var/datum/material/mat)
	. = ..()
	GLOB.ore_vein_landmarks += src
	// Key = Material path; Value = Material Rate
	//! Ensure material datum has an ore_type set
	var/static/list/ores_list = list(
		/datum/material/iron = 600,
		/datum/material/glass = 500,
		/datum/material/silver = 400,
		/datum/material/gold = 350,
		/datum/material/diamond = 100,
		/datum/material/plasma = 450,
		/datum/material/uranium = 200,
		/datum/material/titanium = 300,
		/datum/material/bluespace = 50
	)
	var/datum/material/M = resource
	if(mat)
		M = mat
	else if (!M)
		M = pick(ores_list) //random is default
	resource = M
	if((!material_rate) && ores_list[M])
		material_rate = ores_list[M]

/obj/effect/landmark/ore_vein/proc/extract_ore() //Called by deepcore drills, returns a list of keyed ore stacks by amount
	var/list/ores = list()
	ores[resource] = material_rate
	return ores

//Common ore prefabs

/obj/effect/landmark/ore_vein/iron
	resource = /datum/material/iron

/obj/effect/landmark/ore_vein/plasma
	resource = /datum/material/plasma

/obj/effect/landmark/ore_vein/silver
	resource = /datum/material/silver

/obj/effect/landmark/ore_vein/gold
	resource = /datum/material/gold

/obj/effect/landmark/ore_vein/glass
	resource = /datum/material/glass

/obj/effect/landmark/ore_vein/diamond
	resource = /datum/material/diamond

/obj/effect/landmark/ore_vein/uranium
	resource = /datum/material/uranium

/obj/effect/landmark/ore_vein/titanium
	resource = /datum/material/titanium

/obj/effect/landmark/ore_vein/bluespace
	resource = /datum/material/bluespace

/obj/effect/landmark/ore_vein/bananium
	resource = /datum/material/bananium
	material_rate = 10 //HONK HONK

/obj/machinery/deepcore/hopper
	name = "Bluespace Material Hopper"
	desc = "A machine designed to recieve the output of any bluespace drills connected to its network."
	icon_state = "hopper_off"
	density = TRUE
	idle_power_usage = 5
	active_power_usage = 50
	anchored = FALSE
	circuit = /obj/item/circuitboard/machine/deepcore/hopper

	var/active = FALSE
	var/eject_lim = 0 //Amount of ore stacks the hopper can eject each tick

/obj/machinery/deepcore/hopper/RefreshParts()
	// Material container size
	var/MB_value = 0
	for(var/obj/item/stock_parts/matter_bin/MB in component_parts)
		MB_value += 4 * MB.rating ** 2 // T1 = 8, T2 = 32, T3 = 72, T4 = 128
	container.max_amount = MB_value * MINERAL_MATERIAL_AMOUNT
	// Ejection limit per-tick
	var/MM_value = 0
	for(var/obj/item/stock_parts/manipulator/MM in component_parts)
		MM_value += MM.rating
	eject_lim = MM_value ** 2
	// Capacitor part function
	// lol there is none

/obj/machinery/deepcore/hopper/interact(mob/user, special_state)
	. = ..()
	if(active)
		active = FALSE
		use_power = 1 //Use idle power
		to_chat(user, "<span class='notice'>You deactiveate [src.name]</span>")
	else
		if(!network)
			to_chat(user, "<span class='warning'>Unable to activate [src.name]! No ore located for processing.</span>")
		else if(!powered(power_channel))
			to_chat(user, "<span class='warning'>Unable to activate [src.name]! Insufficient power.</span>")
		else
			active = TRUE
			use_power = 2 //Use active power
			to_chat(user, "<span class='notice'>You activeate \the [src.name]</span>")
	update_icon_state()

/obj/machinery/deepcore/hopper/process()
	if(!network || !anchored)
		active = FALSE
		update_icon_state()
	if(active)
		if(network)
			network.Pull(container)
			dropOre()

/obj/machinery/deepcore/hopper/proc/dropOre()
	var/eject_count = eject_lim
	for(var/I in container.materials)
		if(eject_count <= 0)
			return
		var/datum/material/M = I
		eject_count -= container.retrieve_sheets(eject_count, M, get_step(src, dir))

/obj/machinery/deepcore/hopper/update_icon_state()
	if(powered(power_channel) && anchored)
		if(active)
			icon_state = "hopper_on"
		else
			icon_state = "hopper_off"
	else
		icon_state = "hopper_nopower"

/obj/machinery/deepcore/hopper/can_be_unfasten_wrench(mob/user, silent)
	if(active)
		to_chat(user, "<span class='warning'>Turn \the [src.name] off first!</span>")
		return FAILED_UNFASTEN
	return ..()

/obj/machinery/deepcore/hopper/wrench_act(mob/living/user, obj/item/I)
	. = ..()
	if(default_unfasten_wrench(user, I))
		update_icon_state()
		return TRUE

/obj/machinery/deepcore/hopper/anchored
	anchored = 1

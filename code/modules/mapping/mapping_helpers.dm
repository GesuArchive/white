//Landmarks and other helpers which speed up the mapping process and reduce the number of unique instances/subtypes of items/turf/ect



/obj/effect/baseturf_helper //Set the baseturfs of every turf in the /area/ it is placed.
	name = "baseturf editor"
	icon = 'icons/effects/mapping_helpers.dmi'
	icon_state = ""

	var/list/baseturf_to_replace
	var/baseturf

	plane = POINT_PLANE

/obj/effect/baseturf_helper/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/baseturf_helper/LateInitialize()
	if(!baseturf_to_replace)
		baseturf_to_replace = typecacheof(list(/turf/open/space,/turf/baseturf_bottom))
	else if(!length(baseturf_to_replace))
		baseturf_to_replace = list(baseturf_to_replace = TRUE)
	else if(baseturf_to_replace[baseturf_to_replace[1]] != TRUE) // It's not associative
		var/list/formatted = list()
		for(var/i in baseturf_to_replace)
			formatted[i] = TRUE
		baseturf_to_replace = formatted

	var/area/our_area = get_area(src)
	for(var/i in get_area_turfs(our_area, z))
		replace_baseturf(i)

	qdel(src)

/obj/effect/baseturf_helper/proc/replace_baseturf(turf/thing)
	var/list/baseturf_cache = thing.baseturfs
	if(length(baseturf_cache))
		for(var/i in baseturf_cache)
			if(baseturf_to_replace[i])
				baseturf_cache -= i
		if(!baseturf_cache.len)
			thing.assemble_baseturfs(baseturf)
		else
			thing.PlaceOnBottom(null, baseturf)
	else if(baseturf_to_replace[thing.baseturfs])
		thing.assemble_baseturfs(baseturf)
	else
		thing.PlaceOnBottom(null, baseturf)

/obj/effect/baseturf_helper/space
	name = "space baseturf editor"
	baseturf = /turf/open/space

/obj/effect/baseturf_helper/asteroid
	name = "asteroid baseturf editor"
	baseturf = /turf/open/floor/plating/asteroid

/obj/effect/baseturf_helper/asteroid/airless
	name = "asteroid airless baseturf editor"
	baseturf = /turf/open/floor/plating/asteroid/airless

/obj/effect/baseturf_helper/asteroid/basalt
	name = "asteroid basalt baseturf editor"
	baseturf = /turf/open/floor/plating/asteroid/basalt

/obj/effect/baseturf_helper/asteroid/snow
	name = "asteroid snow baseturf editor"
	baseturf = /turf/open/floor/plating/asteroid/snow

/obj/effect/baseturf_helper/beach/sand
	name = "beach sand baseturf editor"
	baseturf = /turf/open/floor/plating/beach/sand

/obj/effect/baseturf_helper/beach/water
	name = "water baseturf editor"
	baseturf = /turf/open/floor/plating/beach/water

/obj/effect/baseturf_helper/lava
	name = "lava baseturf editor"
	baseturf = /turf/open/lava/smooth

/obj/effect/baseturf_helper/lava_land/surface
	name = "lavaland baseturf editor"
	baseturf = /turf/open/lava/smooth/lava_land_surface

/obj/effect/baseturf_helper/dune
	name = "dune baseturf editor"
	baseturf = /turf/open/floor/dune

/obj/effect/mapping_helpers
	icon = 'icons/effects/mapping_helpers.dmi'
	icon_state = ""
	var/late = FALSE

/obj/effect/mapping_helpers/Initialize(mapload)
	..()
	return late ? INITIALIZE_HINT_LATELOAD : INITIALIZE_HINT_QDEL

//airlock helpers
/obj/effect/mapping_helpers/airlock
	layer = DOOR_HELPER_LAYER
	late = TRUE

/obj/effect/mapping_helpers/airlock/Initialize(mapload)
	. = ..()
	if(!mapload)
		log_mapping("[src] spawned outside of mapload!")
		return

	var/obj/machinery/door/airlock/airlock = locate(/obj/machinery/door/airlock) in loc
	if(!airlock)
		log_mapping("[src] failed to find an airlock at [AREACOORD(src)]")
	else
		payload(airlock)

/obj/effect/mapping_helpers/airlock/LateInitialize()
	. = ..()
	var/obj/machinery/door/airlock/airlock = locate(/obj/machinery/door/airlock) in loc
	if(!airlock)
		qdel(src)
		return
	if(airlock.cyclelinkeddir)
		airlock.cyclelinkairlock()
	if(airlock.closeOtherId)
		airlock.update_other_id()
	if(airlock.abandoned)
		var/outcome = rand(1,100)
		switch(outcome)
			if(1 to 9)
				var/turf/here = get_turf(src)
				for(var/turf/closed/T in range(2, src))
					here.PlaceOnTop(T.type)
					qdel(src)
					return
				here.PlaceOnTop(/turf/closed/wall)
				qdel(airlock)
				return
			if(9 to 11)
				airlock.lights = FALSE
				airlock.locked = TRUE
			if(12 to 15)
				airlock.locked = TRUE
			if(16 to 23)
				airlock.welded = TRUE
			if(24 to 30)
				airlock.set_panel_open(TRUE)
	if(airlock.cutAiWire)
		airlock.wires.cut(WIRE_AI)
	if(airlock.name == initial(airlock.name))
		airlock.name = get_area_name(airlock, TRUE)
	airlock.update_appearance()
	qdel(src)

/obj/effect/mapping_helpers/airlock/proc/payload(obj/machinery/door/airlock/payload)
	return

/obj/effect/mapping_helpers/airlock/cyclelink_helper
	name = "airlock cyclelink helper"
	icon_state = "airlock_cyclelink_helper"

/obj/effect/mapping_helpers/airlock/cyclelink_helper/payload(obj/machinery/door/airlock/airlock)
	if(airlock.cyclelinkeddir)
		log_mapping("[src] at [AREACOORD(src)] tried to set [airlock] cyclelinkeddir, but it's already set!")
	else
		airlock.cyclelinkeddir = dir

/obj/effect/mapping_helpers/airlock/cyclelink_helper_multi
	name = "airlock multi-cyclelink helper"
	icon_state = "airlock_multicyclelink_helper"
	var/cycle_id

/obj/effect/mapping_helpers/airlock/cyclelink_helper_multi/payload(obj/machinery/door/airlock/airlock)
	if(airlock.closeOtherId)
		log_mapping("[src] at [AREACOORD(src)] tried to set [airlock] closeOtherId, but it's already set!")
	else if(!cycle_id)
		log_mapping("[src] at [AREACOORD(src)] doesn't have a cycle_id to assign to [airlock]!")
	else
		airlock.closeOtherId = cycle_id

/obj/effect/mapping_helpers/airlock/locked
	name = "airlock lock helper"
	icon_state = "airlock_locked_helper"

/obj/effect/mapping_helpers/airlock/locked/payload(obj/machinery/door/airlock/airlock)
	if(airlock.locked)
		log_mapping("[src] at [AREACOORD(src)] tried to bolt [airlock] but it's already locked!")
	else
		airlock.locked = TRUE

/obj/effect/mapping_helpers/airlock/unres
	name = "airlock unrestricted side helper"
	icon_state = "airlock_unres_helper"

/obj/effect/mapping_helpers/airlock/unres/payload(obj/machinery/door/airlock/airlock)
	airlock.unres_sides ^= dir
	airlock.unres_sensor = TRUE

/obj/effect/mapping_helpers/airlock/abandoned
	name = "airlock abandoned helper"
	icon_state = "airlock_abandoned"

/obj/effect/mapping_helpers/airlock/abandoned/payload(obj/machinery/door/airlock/airlock)
	if(airlock.abandoned)
		log_mapping("[src] at [AREACOORD(src)] tried to make [airlock] abandoned but it's already abandoned!")
	else
		airlock.abandoned = TRUE

/obj/effect/mapping_helpers/airlock/cutaiwire
	name = "airlock cut ai wire helper"
	icon_state = "airlock_cutaiwire"

/obj/effect/mapping_helpers/airlock/cutaiwire/payload(obj/machinery/door/airlock/airlock)
	if(airlock.cutAiWire)
		log_mapping("[src] at [AREACOORD(src)] tried to cut the ai wire on [airlock] but it's already cut!")
	else
		airlock.cutAiWire = TRUE

//needs to do its thing before spawn_rivers() is called
INITIALIZE_IMMEDIATE(/obj/effect/mapping_helpers/no_lava)

/obj/effect/mapping_helpers/no_lava
	icon_state = "no_lava"

/obj/effect/mapping_helpers/no_lava/Initialize(mapload)
	. = ..()
	var/turf/T = get_turf(src)
	T.turf_flags |= NO_LAVA_GEN

//This helper applies components to things on the map directly.
/obj/effect/mapping_helpers/component_injector
	name = "Component Injector"
	icon_state = "component"
	late = TRUE
	var/all = FALSE //Will inject into all fitting the criteria if true, otherwise first found
	var/target_type //Will inject into atoms of this type
	var/target_name //Will inject into atoms with this name
	var/component_type

//Late init so everything is likely ready and loaded (no warranty)
/obj/effect/mapping_helpers/component_injector/LateInitialize()
	if(!ispath(component_type,/datum/component))
		CRASH("Wrong component type in [type] - [component_type] is not a component")
	var/turf/T = get_turf(src)
	for(var/atom/A in T.get_all_contents())
		if(A == src)
			continue
		if(target_name && A.name != target_name)
			continue
		if(target_type && !istype(A,target_type))
			continue
		var/cargs = build_args()
		A._AddComponent(cargs)
		if(!all)
			qdel(src)
			return
	if(all)
		qdel(src)

/obj/effect/mapping_helpers/component_injector/proc/build_args()
	return list(component_type)

/obj/effect/mapping_helpers/component_injector/infective
	name = "Infective Injector"
	icon_state = "component_infective"
	component_type = /datum/component/infective
	var/disease_type

/obj/effect/mapping_helpers/component_injector/infective/build_args()
	if(!ispath(disease_type,/datum/disease))
		CRASH("Wrong disease type passed in.")
	var/datum/disease/D = new disease_type()
	return list(component_type,D)

/obj/effect/mapping_helpers/component_injector/areabound
	name = "Areabound Injector"
	icon_state = "component_areabound"
	component_type = /datum/component/areabound
	target_type = /atom/movable

/obj/effect/mapping_helpers/dead_body_placer
	name = "Dead Body placer"
	late = TRUE
	icon_state = "deadbodyplacer"
	var/bodycount = 2 //number of bodies to spawn

/obj/effect/mapping_helpers/dead_body_placer/LateInitialize()
	var/area/a = get_area(src)
	var/list/trays = list()
	for (var/i in a.contents)
		if (istype(i, /obj/structure/bodycontainer/morgue))
			trays += i
	if(!trays.len)
		log_mapping("[src] at [x],[y] could not find any morgues.")
		return
	for (var/i = 1 to bodycount)
		var/obj/structure/bodycontainer/morgue/j = pick(trays)
		var/mob/living/carbon/human/h = new /mob/living/carbon/human(j, 1)
		h.death()
		for (var/part in h.internal_organs) //randomly remove organs from each body, set those we keep to be in stasis
			if (prob(40))
				qdel(part)
			else
				var/obj/item/organ/O = part
				O.organ_flags |= ORGAN_FROZEN
		j.update_icon()
	qdel(src)


//On Ian's birthday, the hop's office is decorated.
/obj/effect/mapping_helpers/ianbirthday
	name = "Ian's Bday Helper"
	late = TRUE
	icon_state = "iansbdayhelper"
	var/balloon_clusters = 2

/obj/effect/mapping_helpers/ianbirthday/LateInitialize()
	if(locate(/datum/holiday/ianbirthday) in SSevents.holidays)
		birthday()
	qdel(src)

/obj/effect/mapping_helpers/ianbirthday/proc/birthday()
	var/area/a = get_area(src)
	var/list/table = list()//should only be one aka the front desk, but just in case...
	var/list/openturfs = list()

	//confetti and a corgi balloon! (and some list stuff for more decorations)
	for(var/thing in a.contents)
		if(istype(thing, /obj/structure/table/reinforced))
			table += thing
		if(isopenturf(thing))
			new /obj/effect/decal/cleanable/confetti(thing)
			if(locate(/obj/structure/bed/dogbed/ian) in thing)
				new /obj/item/toy/balloon/corgi(thing)
			else
				openturfs += thing
	//cake + knife to cut it!
	var/turf/food_turf = get_turf(pick(table))
	new /obj/item/kitchen/knife(food_turf)
	var/obj/item/food/cake/birthday/iancake = new(food_turf)
	iancake.desc = "Happy birthday, Ian!"
	//some balloons! this picks an open turf and pops a few balloons in and around that turf, yay.
	for(var/i in 1 to balloon_clusters)
		var/turf/clusterspot = pick_n_take(openturfs)
		new /obj/item/toy/balloon(clusterspot)
		var/balloons_left_to_give = 3 //the amount of balloons around the cluster
		var/list/dirs_to_balloon = GLOB.cardinals.Copy()
		while(balloons_left_to_give > 0)
			balloons_left_to_give--
			var/chosen_dir = pick_n_take(dirs_to_balloon)
			var/turf/balloonstep = get_step(clusterspot, chosen_dir)
			var/placed = FALSE
			if(isopenturf(balloonstep))
				var/obj/item/toy/balloon/B = new(balloonstep)//this clumps the cluster together
				placed = TRUE
				if(chosen_dir == NORTH)
					B.pixel_y -= 10
				if(chosen_dir == SOUTH)
					B.pixel_y += 10
				if(chosen_dir == EAST)
					B.pixel_x -= 10
				if(chosen_dir == WEST)
					B.pixel_x += 10
			if(!placed)
				new /obj/item/toy/balloon(clusterspot)
	//remind me to add wall decor!

/obj/effect/mapping_helpers/ianbirthday/admin//so admins may birthday any room
	name = "generic birthday setup"
	icon_state = "bdayhelper"

/obj/effect/mapping_helpers/ianbirthday/admin/LateInitialize()
	birthday()
	qdel(src)

//Ian, like most dogs, loves a good new years eve party.
/obj/effect/mapping_helpers/iannewyear
	name = "Ian's New Years Helper"
	late = TRUE
	icon_state = "iansnewyrshelper"

/obj/effect/mapping_helpers/iannewyear/LateInitialize()
	if(SSevents.holidays && SSevents.holidays[NEW_YEAR])
		fireworks()
	qdel(src)

/obj/effect/mapping_helpers/iannewyear/proc/fireworks()
	var/area/a = get_area(src)
	var/list/table = list()//should only be one aka the front desk, but just in case...
	var/list/openturfs = list()

	for(var/thing in a.contents)
		if(istype(thing, /obj/structure/table/reinforced))
			table += thing
		else if(isopenturf(thing))
			if(locate(/obj/structure/bed/dogbed/ian) in thing)
				new /obj/item/clothing/head/festive(thing)
				var/obj/item/reagent_containers/food/drinks/bottle/champagne/iandrink = new(thing)
				iandrink.name = "dog champagne"
				iandrink.pixel_y += 8
				iandrink.pixel_x += 8
			else
				openturfs += thing

	var/turf/fireworks_turf = get_turf(pick(table))
	var/obj/item/storage/box/matches/matchbox = new(fireworks_turf)
	matchbox.pixel_y += 8
	matchbox.pixel_x -= 3
	new /obj/item/storage/box/fireworks/dangerous(fireworks_turf) //dangerous version for extra holiday memes.

//lets mappers place notes on airlocks with custom info or a pre-made note from a path
/obj/effect/mapping_helpers/airlock_note_placer
	name = "Airlock Note Placer"
	late = TRUE
	icon_state = "airlocknoteplacer"
	var/note_info //for writing out custom notes without creating an extra paper subtype
	var/note_name //custom note name
	var/note_path //if you already have something wrote up in a paper subtype, put the path here

/obj/effect/mapping_helpers/airlock_note_placer/LateInitialize()
	var/turf/turf = get_turf(src)
	if(note_path && !istype(note_path, /obj/item/paper)) //don't put non-paper in the paper slot thank you
		log_mapping("[src] at [x],[y] had an improper note_path path, could not place paper note.")
		qdel(src)
		return
	if(locate(/obj/machinery/door/airlock) in turf)
		var/obj/machinery/door/airlock/found_airlock = locate(/obj/machinery/door/airlock) in turf
		if(note_path)
			found_airlock.note = note_path
			found_airlock.update_appearance()
			qdel(src)
			return
		if(note_info)
			var/obj/item/paper/paper = new /obj/item/paper(src)
			if(note_name)
				paper.name = note_name
			paper.info = "[note_info]"
			found_airlock.note = paper
			paper.forceMove(found_airlock)
			found_airlock.update_icon()
			qdel(src)
			return
		log_mapping("[src] at [x],[y] had no note_path or note_info, cannot place paper note.")
		qdel(src)
		return
	log_mapping("[src] at [x],[y] could not find an airlock on current turf, cannot place paper note.")
	qdel(src)

//This helper applies traits to things on the map directly.
/obj/effect/mapping_helpers/trait_injector
	name = "Trait Injector"
	icon_state = "trait"
	late = TRUE
	///Will inject into all fitting the criteria if false, otherwise first found.
	var/first_match_only = TRUE
	///Will inject into atoms of this type.
	var/target_type
	///Will inject into atoms with this name.
	var/target_name
	///Name of the trait, in the lower-case text (NOT the upper-case define) form.
	var/trait_name

//Late init so everything is likely ready and loaded (no warranty)
/obj/effect/mapping_helpers/trait_injector/LateInitialize()
	if(!GLOB.trait_name_map)
		GLOB.trait_name_map = generate_trait_name_map()
	if(!GLOB.trait_name_map.Find(trait_name))
		CRASH("Wrong trait in [type] - [trait_name] is not a trait")
	var/turf/target_turf = get_turf(src)
	var/matches_found = 0
	for(var/a in target_turf.get_all_contents())
		var/atom/atom_on_turf = a
		if(atom_on_turf == src)
			continue
		if(target_name && atom_on_turf.name != target_name)
			continue
		if(target_type && !istype(atom_on_turf,target_type))
			continue
		ADD_TRAIT(atom_on_turf, trait_name, MAPPING_HELPER_TRAIT)
		matches_found++
		if(first_match_only)
			qdel(src)
			return
	if(!matches_found)
		stack_trace("Trait mapper found no targets at ([x], [y], [z]). First Match Only: [first_match_only ? "true" : "false"] target type: [target_type] | target name: [target_name] | trait name: [trait_name]")
	qdel(src)

/**
 * ## trapdoor placer!
 *
 * This places an unlinked trapdoor in the tile its on (so someone with a remote needs to link it up first)
 * Pre-mapped trapdoors (unlike player-made ones) are not conspicuous by default so nothing stands out with them
 * Admins may spawn this in the round for additional trapdoors if they so desire
 * if YOU want to learn more about trapdoors, read about the component at trapdoor.dm
 * note: this is not a turf subtype because the trapdoor needs the type of the turf to turn back into
 */
/obj/effect/mapping_helpers/trapdoor_placer
	name = "trapdoor placer"
	late = TRUE
	icon_state = "trapdoor"

/obj/effect/mapping_helpers/trapdoor_placer/LateInitialize()
	var/turf/component_target = get_turf(src)
	component_target.AddComponent(/datum/component/trapdoor, starts_open = FALSE, conspicuous = FALSE)
	qdel(src)

/obj/effect/mapping_helpers/ztrait_injector
	name = "ztrait injector"
	icon_state = "ztrait"
	late = TRUE
	/// List of traits to add to this Z-level.
	var/list/traits_to_add = list()

/obj/effect/mapping_helpers/ztrait_injector/LateInitialize()
	var/datum/space_level/level = SSmapping.z_list[z]
	if(!level || !length(traits_to_add))
		return
	level.traits |= traits_to_add
	SSweather.update_z_level(level) //in case of someone adding a weather for the level, we want SSweather to update for that

/obj/effect/mapping_helpers/circuit_spawner
	name = "circuit spawner"
	icon_state = "circuit"
	/// The shell for the circuit.
	var/atom/movable/circuit_shell
	/// Capacity of the shell.
	var/shell_capacity = SHELL_CAPACITY_VERY_LARGE
	/// The url for the json. Example: "https://pastebin.com/raw/eH7VnP9d"
	var/json_url

/obj/effect/mapping_helpers/circuit_spawner/Initialize(mapload)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(spawn_circuit))

/obj/effect/mapping_helpers/circuit_spawner/proc/spawn_circuit()
	var/list/errors = list()
	var/obj/item/integrated_circuit/loaded/new_circuit = new(loc)
	var/json_data = load_data()
	new_circuit.load_circuit_data(json_data, errors)
	if(!circuit_shell)
		return
	circuit_shell = new(loc)
	var/datum/component/shell/shell_component = circuit_shell.GetComponent(/datum/component/shell)
	if(shell_component)
		shell_component.shell_flags |= SHELL_FLAG_CIRCUIT_UNMODIFIABLE|SHELL_FLAG_CIRCUIT_UNREMOVABLE
		shell_component.attach_circuit(new_circuit)
	else
		shell_component = circuit_shell.AddComponent(/datum/component/shell, \
			capacity = shell_capacity, \
			shell_flags = SHELL_FLAG_CIRCUIT_UNMODIFIABLE|SHELL_FLAG_CIRCUIT_UNREMOVABLE, \
			starting_circuit = new_circuit, \
			)

/obj/effect/mapping_helpers/circuit_spawner/proc/load_data()
	var/static/json_cache = list()
	var/static/query_in_progress = FALSE //We're using a single tmp file so keep it linear.
	if(query_in_progress)
		UNTIL(!query_in_progress)
	if(json_cache[json_url])
		return json_cache[json_url]
	log_asset("Circuit Spawner fetching json from: [json_url]")
	var/datum/http_request/request = new()
	request.prepare(RUSTG_HTTP_METHOD_GET, json_url, "")
	query_in_progress = TRUE
	request.begin_async()
	UNTIL(request.is_complete())
	var/datum/http_response/response = request.into_response()
	if(response.errored || response.status_code != 200)
		query_in_progress = FALSE
		CRASH("Failed to fetch mapped custom json from url [json_url], code: [response.status_code], error: [response.error]")
	var/json_data = response["body"]
	json_cache[json_url] = json_data
	query_in_progress = FALSE
	return json_data

/obj/effect/mapping_helpers/broken_floor
	name = "broken floor"
	icon = 'icons/turf/damaged.dmi'
	icon_state = "damaged1"
	late = TRUE
	layer = ABOVE_NORMAL_TURF_LAYER

/obj/effect/mapping_helpers/broken_floor/Initialize(mapload)
	.=..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/mapping_helpers/broken_floor/LateInitialize()
	var/turf/open/floor/floor = get_turf(src)
	floor.break_tile()
	qdel(src)

/obj/effect/mapping_helpers/burnt_floor
	name = "burnt floor"
	icon = 'icons/turf/damaged.dmi'
	icon_state = "floorscorched1"
	late = TRUE
	layer = ABOVE_NORMAL_TURF_LAYER

/obj/effect/mapping_helpers/burnt_floor/Initialize(mapload)
	.=..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/mapping_helpers/burnt_floor/LateInitialize()
	var/turf/open/floor/floor = get_turf(src)
	floor.burn_tile()
	qdel(src)

/obj/effect/mapping_helpers/plating_floor
	name = "plating floor"
	icon = 'icons/turf/damaged.dmi'
	icon_state = "plating_visible1"
	late = TRUE
	layer = ABOVE_NORMAL_TURF_LAYER

/obj/effect/mapping_helpers/plating_floor/Initialize(mapload)
	.=..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/mapping_helpers/plating_floor/LateInitialize()
	var/turf/open/floor/floor = get_turf(src)
	floor.plating_fucked = TRUE
	floor.update_appearance()
	qdel(src)

/obj/effect/mapping_helpers/turf_rotation
	name = "ротация турфов"
	icon_state = "turf_rotation"
	late = TRUE
	invisibility = INVISIBILITY_MAXIMUM
	var/timer = 15
	var/current_time = null
	var/current_turf_type = /turf/open/water/xen_acid

/obj/effect/mapping_helpers/turf_rotation/Initialize(mapload)
	.=..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/mapping_helpers/turf_rotation/process(delta_time)
	var/turf/open/floor/floor = get_turf(src)
	if(!floor)
		qdel(src)
		return PROCESS_KILL
	current_time--
	//floor.maptext = MAPTEXT_REALLYBIG_COLOR("[current_time]", "#d10404")
	if(current_time == 3)
		new /obj/effect/temp_visual/dz_effects/attention(floor)
	if(current_time >= 1)
		return
	current_time = timer
	var/old_turf_type = floor.type
	floor.ChangeTurf(current_turf_type)
	current_turf_type = old_turf_type

/obj/effect/mapping_helpers/turf_rotation/LateInitialize()
	current_time = timer
	START_PROCESSING(SSprocessing, src)

/obj/effect/mapping_helpers/turf_rotation/Destroy(force)
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

/obj/effect/mapping_helpers/auto_wrench
	name = "auto wrencher"
	icon_state = "auto_wrench"
	late = TRUE
	invisibility = INVISIBILITY_OBSERVER
	var/ignore_atmos_pipes = TRUE

/obj/effect/mapping_helpers/auto_wrench/LateInitialize()
	//Perform our duty and then delete
	//Give some time for pipenets to build
	sleep(50)
	function()
	return INITIALIZE_HINT_QDEL

/obj/effect/mapping_helpers/auto_wrench/proc/function()
	//Scuffed
	var/mob/temp = new(loc)
	var/obj/item/wrench/magic_wrench = new(loc)
	for(var/atom/A in loc)
		if(ignore_atmos_pipes && istype(A, /obj/machinery/atmospherics))
			continue
		//For some reason not everything uses wrench_act
		A.attackby(magic_wrench, temp)
	qdel(magic_wrench, TRUE)
	qdel(temp, TRUE)
	qdel(src, TRUE)

//air alarm helpers
/obj/effect/mapping_helpers/airalarm
	desc = "You shouldn't see this. Report it please."
	late = TRUE

/obj/effect/mapping_helpers/airalarm/Initialize(mapload)
	. = ..()
	if(!mapload)
		log_mapping("[src] spawned outside of mapload!")
		return INITIALIZE_HINT_QDEL

	var/obj/machinery/airalarm/target = locate(/obj/machinery/airalarm) in loc
	if(isnull(target))
		var/area/target_area = get_area(src)
		log_mapping("[src] failed to find an air alarm at [AREACOORD(src)] ([target_area.type]).")
	else
		payload(target)

	return INITIALIZE_HINT_LATELOAD

/obj/effect/mapping_helpers/airalarm/LateInitialize()
	. = ..()
	var/obj/machinery/airalarm/target = locate(/obj/machinery/airalarm) in loc

	if(isnull(target))
		qdel(src)
		return
	if(target.unlocked)
		target.unlock()

	if(target.tlv_cold_room)
		target.set_tlv_cold_room()
	if(target.tlv_no_checks)
		target.set_tlv_no_checks()
	if(target.tlv_no_checks && target.tlv_cold_room)
		CRASH("Tried to apply incompatible air alarm threshold helpers!")

	if(target.syndicate_access)
		target.give_syndicate_access()
	if(target.away_general_access)
		target.give_away_general_access()
	if(target.engine_access)
		target.give_engine_access()
	if(target.mixingchamber_access)
		target.give_mixingchamber_access()
	if(target.all_access)
		target.give_all_access()
	if(target.syndicate_access + target.away_general_access + target.engine_access + target.mixingchamber_access + target.all_access > 1)
		CRASH("Tried to combine incompatible air alarm access helpers!")

	if(target.air_sensor_chamber_id)
		target.setup_chamber_link()

	target.update_appearance()
	qdel(src)

/obj/effect/mapping_helpers/airalarm/proc/payload(obj/machinery/airalarm/target)
	return

/obj/effect/mapping_helpers/airalarm/unlocked
	name = "airalarm unlocked interface helper"
	icon_state = "airalarm_unlocked_interface_helper"

/obj/effect/mapping_helpers/airalarm/unlocked/payload(obj/machinery/airalarm/target)
	if(target.unlocked)
		var/area/area = get_area(target)
		log_mapping("[src] at [AREACOORD(src)] [(area.type)] tried to unlock the [target] but it's already unlocked!")
	target.unlocked = TRUE

/obj/effect/mapping_helpers/airalarm/syndicate_access
	name = "airalarm syndicate access helper"
	icon_state = "airalarm_syndicate_access_helper"

/obj/effect/mapping_helpers/airalarm/syndicate_access/payload(obj/machinery/airalarm/target)
	if(target.syndicate_access)
		var/area/area = get_area(target)
		log_mapping("[src] at [AREACOORD(src)] [(area.type)] tried to adjust [target]'s access to syndicate but it's already changed!")
	target.syndicate_access = TRUE

/obj/effect/mapping_helpers/airalarm/away_general_access
	name = "airalarm away access helper"
	icon_state = "airalarm_away_general_access_helper"

/obj/effect/mapping_helpers/airalarm/away_general_access/payload(obj/machinery/airalarm/target)
	if(target.away_general_access)
		var/area/area = get_area(target)
		log_mapping("[src] at [AREACOORD(src)] [(area.type)] tried to adjust [target]'s access to away_general but it's already changed!")
	target.away_general_access = TRUE

/obj/effect/mapping_helpers/airalarm/engine_access
	name = "airalarm engine access helper"
	icon_state = "airalarm_engine_access_helper"

/obj/effect/mapping_helpers/airalarm/engine_access/payload(obj/machinery/airalarm/target)
	if(target.engine_access)
		var/area/area = get_area(target)
		log_mapping("[src] at [AREACOORD(src)] [(area.type)] tried to adjust [target]'s access to engine_access but it's already changed!")
	target.engine_access = TRUE

/obj/effect/mapping_helpers/airalarm/mixingchamber_access
	name = "airalarm mixingchamber access helper"
	icon_state = "airalarm_mixingchamber_access_helper"

/obj/effect/mapping_helpers/airalarm/mixingchamber_access/payload(obj/machinery/airalarm/target)
	if(target.mixingchamber_access)
		var/area/area = get_area(target)
		log_mapping("[src] at [AREACOORD(src)] [(area.type)] tried to adjust [target]'s access to mixingchamber_access but it's already changed!")
	target.mixingchamber_access = TRUE

/obj/effect/mapping_helpers/airalarm/all_access
	name = "airalarm all access helper"
	icon_state = "airalarm_all_access_helper"

/obj/effect/mapping_helpers/airalarm/all_access/payload(obj/machinery/airalarm/target)
	if(target.all_access)
		var/area/area = get_area(target)
		log_mapping("[src] at [AREACOORD(src)] [(area.type)] tried to adjust [target]'s access to all_access but it's already changed!")
	target.all_access = TRUE

/obj/effect/mapping_helpers/airalarm/tlv_cold_room
	name = "airalarm cold room tlv helper"
	icon_state = "airalarm_tlv_cold_room_helper"

/obj/effect/mapping_helpers/airalarm/tlv_cold_room/payload(obj/machinery/airalarm/target)
	if(target.tlv_cold_room)
		var/area/area = get_area(target)
		log_mapping("[src] at [AREACOORD(src)] [(area.type)] tried to adjust [target]'s tlv to cold_room but it's already changed!")
	target.tlv_cold_room = TRUE

/obj/effect/mapping_helpers/airalarm/tlv_no_checks
	name = "airalarm no checks tlv helper"
	icon_state = "airalarm_tlv_no_checks_helper"

/obj/effect/mapping_helpers/airalarm/tlv_no_checks/payload(obj/machinery/airalarm/target)
	if(target.tlv_no_checks)
		var/area/area = get_area(target)
		log_mapping("[src] at [AREACOORD(src)] [(area.type)] tried to adjust [target]'s tlv to no_checks but it's already changed!")
	target.tlv_no_checks = TRUE

/obj/effect/mapping_helpers/airalarm/link
	name = "airalarm link helper"
	icon_state = "airalarm_link_helper"
	var/chamber_id = ""
	var/allow_link_change = FALSE

/obj/effect/mapping_helpers/airalarm/link/Initialize(mapload)
	. = ..()
	if(!mapload)
		log_mapping("[src] spawned outside of mapload!")
		return INITIALIZE_HINT_QDEL

	var/obj/machinery/airalarm/alarm = locate(/obj/machinery/airalarm) in loc
	if(!isnull(alarm))
		alarm.air_sensor_chamber_id = chamber_id
		alarm.allow_link_change = allow_link_change
	else
		log_mapping("[src] failed to find air alarm at [AREACOORD(src)].")
		return INITIALIZE_HINT_QDEL

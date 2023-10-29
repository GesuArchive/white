/obj/effect/oneway
	name = " Односторонний эффект"
	desc = "Принимает вещи только из одного направления."
	icon = 'icons/effects/mapping_helpers.dmi'
	icon_state = "field_dir"
	invisibility = INVISIBILITY_MAXIMUM
	anchored = TRUE

/obj/effect/oneway/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	return . && border_dir == dir


/obj/effect/wind
	name = "Воздушный эффект"
	desc = "Создает давление в своем направлении. Использовать осторожно"
	icon = 'icons/effects/mapping_helpers.dmi'
	icon_state = "field_dir"
	invisibility = INVISIBILITY_MAXIMUM
	var/strength = 30

/obj/effect/wind/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj,src)

/obj/effect/wind/process()
	var/turf/open/T = get_turf(src)
	if(istype(T))
		T.consider_pressure_difference(get_step(T,dir),strength)

//Keep these rare due to cost of doing these checks
/obj/effect/path_blocker
	name = "Магический барьер"
	desc = "Ты не пройдешь."
	icon = 'icons/effects/mapping_helpers.dmi'
	icon_state = "blocker" //todo make this actually look fine when visible
	anchored = TRUE
	var/list/blocked_types = list()
	var/reverse = FALSE //Block if path not present

/obj/effect/path_blocker/Initialize(mapload)
	. = ..()
	if(blocked_types.len)
		blocked_types = typecacheof(blocked_types)

/obj/effect/path_blocker/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(blocked_types.len)
		var/list/mover_contents = mover.get_all_contents()
		for(var/atom/movable/thing in mover_contents)
			if(blocked_types[thing.type])
				return reverse
	return !reverse

/obj/structure/pitgrate
	name = "Слив"
	icon = 'icons/obj/smooth_structures/lattice.dmi'
	icon_state = "lattice-255"
	plane = FLOOR_PLANE
	anchored = TRUE
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP
	var/id
	var/open = FALSE
	var/hidden = FALSE

/obj/structure/pitgrate/Initialize(mapload)
	. = ..()
	RegisterSignal(SSdcs,COMSIG_GLOB_BUTTON_PRESSED, PROC_REF(OnButtonPressed))
	if(hidden)
		update_openspace()

/obj/structure/pitgrate/proc/OnButtonPressed(datum/source,obj/machinery/button/button)
	SIGNAL_HANDLER

	if(button.id == id) //No range checks because this is admin abuse mostly.
		INVOKE_ASYNC(src, PROC_REF(toggle))

/obj/structure/pitgrate/proc/update_openspace()
	var/turf/open/openspace/T = get_turf(src)
	if(!istype(T))
		return
	//Simple way to keep plane conflicts away, could probably be upgraded to something less nuclear with 513
	T.invisibility = open ? 0 : INVISIBILITY_MAXIMUM

/obj/structure/pitgrate/proc/toggle()
	open = !open
	var/talpha
	if(open)
		talpha = 0
		obj_flags &= ~(BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP)
	else
		talpha = 255
		obj_flags |= BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP
	SET_PLANE_IMPLICIT(src, ABOVE_LIGHTING_PLANE) //What matters it's one above openspace, so our animation is not dependant on what's there. Up to revision with 513
	animate(src,alpha = talpha,time = 10)
	addtimer(CALLBACK(src,PROC_REF(reset_plane)),10)
	if(hidden)
		update_openspace()
	var/turf/T = get_turf(src)
	for(var/atom/movable/AM in T)
		if(!AM.currently_z_moving)
			T.zFall(AM)

/obj/structure/pitgrate/proc/reset_plane()
	SET_PLANE_IMPLICIT(src, FLOOR_PLANE)

/obj/structure/pitgrate/Destroy()
	if(hidden)
		open = TRUE
		update_openspace()
	. = ..()

/obj/structure/pitgrate/hidden
	name = "Пол"
	icon = DEFAULT_FLOORS_ICON
	icon_state = "floor"
	hidden = TRUE

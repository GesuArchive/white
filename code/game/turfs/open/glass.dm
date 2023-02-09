/turf/open/floor/glass
	name = "стеклянный пол"
	desc = "Не прыгай по нему! Или прыгай. Я не твоя мамаша."
	icon = 'icons/turf/floors/glass.dmi'
	icon_state = "glass-0"
	base_icon_state = "glass"
	baseturfs = /turf/open/openspace
	intact = FALSE //this means wires go on top
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_FLOOR_TRANSPARENT_GLASS)
	canSmoothWith = list(SMOOTH_GROUP_FLOOR_TRANSPARENT_GLASS)
	footstep = FOOTSTEP_PLATING
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	floor_tile = /obj/item/stack/tile/glass
	/// List of /atom/movable/render_step that are being used to make this glass floor glow
	/// These are OWNED by this floor, they delete when we delete them, not before not after
	var/list/glow_stuff
	/// How much alpha to leave when cutting away emissive blockers
	var/alpha_to_leave = 255
	/// Color of starlight to use
	var/starlight_color = COLOR_STARLIGHT

/turf/open/floor/glass/Initialize(mapload)
	icon_state = "" //Prevent the normal icon from appearing behind the smooth overlays
	..()
	return INITIALIZE_HINT_LATELOAD

/turf/open/floor/glass/LateInitialize()
	. = ..()
	AddElement(/datum/element/turf_z_transparency)
	setup_glow()

/turf/open/floor/glass/Destroy()
	. = ..()
	QDEL_LIST(glow_stuff)

/// If this turf is at the bottom of the local rendering stack
/// Then we're gonna make it emissive block so the space below glows
/turf/open/floor/glass/proc/setup_glow()
	if(GET_TURF_PLANE_OFFSET(src) != GET_LOWEST_STACK_OFFSET(z)) // We ain't the bottom brother
		return
	// We assume no parallax means no space means no light
	if(SSmapping.level_trait(z, ZTRAIT_NOPARALLAX))
		return

	glow_stuff = partially_block_emissives(src, alpha_to_leave)
	set_light(2, 0.75, starlight_color)

/turf/open/floor/glass/reinforced
	name = "армированный стеклянный пол"
	desc = "Не прыгай по нему! Он выдержит."
	icon = 'icons/turf/floors/reinf_glass.dmi'
	icon_state = "reinf_glass-0"
	base_icon_state = "reinf_glass"
	floor_tile = /obj/item/stack/tile/rglass
	alpha_to_leave = 206

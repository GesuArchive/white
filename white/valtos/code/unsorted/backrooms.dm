/turf/open/indestructible/backrooms
	name = "пол"
	icon = 'white/valtos/icons/backfloor.dmi'
	icon_state = "backfloor"
	bullet_bounce_sound = null
	footstep = FOOTSTEP_CARPET
	barefootstep = FOOTSTEP_CARPET_BAREFOOT
	clawfootstep = FOOTSTEP_CARPET_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/closed/indestructible/backrooms
	name = "стена"
	desc = null
	icon = 'white/valtos/icons/backwall.dmi'
	icon_state = "backwall-0"
	base_icon_state = "backwall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_BACKROOMS_WALL)
	canSmoothWith = list(SMOOTH_GROUP_BACKROOMS_WALL)
	bullet_bounce_sound = null

/area/backrooms
	name = "Закулисье"
	icon_state = "yellow"
	requires_power = FALSE
	static_lighting = FALSE
	base_lighting_color = COLOR_VERY_SOFT_YELLOW
	base_lighting_alpha = 255
	has_gravity = STANDARD_GRAVITY
	sound_environment = SOUND_ENVIRONMENT_CARPETED_HALLWAY
	flags_1 = NONE
	mood_bonus = -1
	mood_message = span_notice("Где я...\n")

// ещё один костыльный оверрайт
/area/backrooms/Entered(atom/movable/arrived, area/old_area)
	set waitfor = FALSE
	SEND_SIGNAL(src, COMSIG_AREA_ENTERED, arrived, old_area)
	if(!LAZYACCESS(arrived.important_recursive_contents, RECURSIVE_CONTENTS_AREA_SENSITIVE))
		return
	for(var/atom/movable/recipient as anything in arrived.important_recursive_contents[RECURSIVE_CONTENTS_AREA_SENSITIVE])
		SEND_SIGNAL(recipient, COMSIG_ENTER_AREA, src)

	if(isobserver(arrived))
		var/mob/dead/observer/O = arrived
		if(!O?.client?.holder)
			var/obj/effect/landmark/observer_start/OS = locate(/obj/effect/landmark/observer_start) in GLOB.landmarks_list
			O.forceMove(OS.loc)

	if(!isliving(arrived))
		return

	var/mob/living/L = arrived
	if(!L.ckey)
		return

	L?.hud_used?.update_parallax_pref(L)

	SEND_SOUND(L, sound('white/valtos/sounds/bbg.ogg', repeat = 1, wait = 0, volume = 100, channel = CHANNEL_BACKROOMS_HUM))

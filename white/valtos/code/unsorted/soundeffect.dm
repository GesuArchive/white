/obj/effect/temp_visual/soundwave
	name = "звук"
	icon = "white/valtos/icons/sw.dmi"
	icon_state = "wave"
	duration = 6
	randomdir = FALSE

/obj/effect/temp_visual/soundwave/Initialize(init_volume)
	. = ..()
	alpha = init_volume * 2

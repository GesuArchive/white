/particles/exp_emitter
	icon = 'white/valtos/icons/particles.dmi'
	icon_state = "exp_emitter"
	width = 100
	height = 500
	count = 1000
	spawning = 40
	lifespan = 15
	fade = 10
	grow = -0.01
	velocity = list(0, 0)
	position = generator("circle", 0, 16, NORMAL_RAND)
	drift = generator("vector", list(0, -0.2), list(0, 0.2))
	gravity = list(0, 0.95)
	scale = generator("vector", list(0.3, 0.3), list(1,1), NORMAL_RAND)
	rotation = 30
	spin = generator("num", -20, 20)

/obj/exp_emitter
	particles = new/particles/exp_emitter

//
// Music Notes, Sweet Sweet Music Notes
//
/particles/music
	width = 64
	height = 64
	count = 4
	spawning = 0.1
	bound1 = list(-1000, -240, -1000)
	lifespan = 2 SECONDS
	fade = 1.5 SECONDS
	#ifndef SPACEMAN_DMM // Waiting on next release of DreamChecker
	fadein = 5
	#endif
	// spawn within a certain x,y,z space
	icon = 'white/valtos/icons/particles.dmi'
	icon_state = list("quarter"=5, "beamed_eighth"=1, "eighth"=1)
	gradient = list(0, "#f00", 1, "#ff0", 2, "#0f0", 3, "#0ff", 4, "#00f", 5, "#f0f", 6, "#f00", "loop")
	color = generator("num", 0, 6)
	gravity = list(0, 0.5)
	friction = 0.4
	drift = generator("box", list(-1, -0.5, 0), list(1, 0.5, 0), LINEAR_RAND)

/obj/effect/music
	alpha = 200
	particles = new/particles/music

/obj/effect/music/New()
	..()
	add_filter("outline", 1, outline_filter(size=0.5, color="#444"))
	src.particles.lifespan = 0

/obj/effect/music/proc/is_playing()
	. = src.particles.lifespan == 2 SECONDS

/obj/effect/music/proc/play_notes()
	src.particles.lifespan = 2 SECONDS

/obj/effect/music/proc/stop_notes()
	src.particles.lifespan = 0

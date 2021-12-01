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
	layer = FLY_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	particles = new/particles/music

/obj/effect/music/New()
	..()
	add_filter("outline", 1, outline_filter(size=0.5, color="#444"))
	#ifndef SPACEMAN_DMM
	src.particles.lifespan = 0
	#endif

/obj/effect/music/proc/is_playing()
	#ifndef SPACEMAN_DMM
	. = src.particles.lifespan == 2 SECONDS
	#endif

/obj/effect/music/proc/play_notes()
	#ifndef SPACEMAN_DMM
	src.particles.lifespan = 2 SECONDS
	#endif

/obj/effect/music/proc/stop_notes()
	#ifndef SPACEMAN_DMM
	src.particles.lifespan = 0
	#endif

/particles/rain
	width = 672
	height = 480
	count = 2500    // 2500 particles
	spawning = 48
	bound1 = list(-1000, -240, -1000)   // end particles at Y=-240
	lifespan = 600  // live for 60s max
	fade = 35       // fade out over the last 3.5s if still on screen
	// spawn within a certain x,y,z space
	icon = 'white/valtos/icons/particles.dmi'
	icon_state = "starsmall"
	position = generator("box", list(-300,50,0), list(300,300,50))
	gravity = list(0, -3)
	friction = 0.05
	drift = generator("sphere", 0, 1)

/particles/rain/dense
	spawning = 60

/particles/rain/sideways
	rotation = generator("num", -10, -20 )
	gravity = list(0.4, -3)
	drift = generator("box", list(0.1, -1, 0), list(0.4, 0, 0))

/particles/rain/sideways/tile
	count = 5
	spawning = 1.1
	fade = 5
	lifespan = generator("num", 4, 6, LINEAR_RAND)
	position = generator("box", list(-96,32,0), list(300,64,50))
	bound1 = list(-32, -48, -1000)
	bound2 = list(32, 64, 1000)
	// Start up initial speed and gain for tile based emitter due to shorter travel (acceleration)
	gravity = list(0.4*3, -3*3)
	drift = generator("box", list(0.1, -1*2, 0), list(0.4*2, 0, 0))
	width = 96
	height = 96


/obj/effect/rain
	particles = new/particles/rain
	alpha = 200
	layer = FLY_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/static/list/particles/z_particles

/obj/effect/rain/client_attach
	screen_loc = "CENTER"

/obj/effect/rain/dense
	particles = new/particles/rain/dense

/obj/effect/rain/sideways
	particles = new/particles/rain/sideways

/obj/effect/rain/sideways/tile
	particles = null
	// Offset pixel position to align bounding boxes and visual area
	pixel_y = 16
	pixel_x = -16

/obj/effect/rain/sideways/tile/New()
	..()
	LAZYINITLIST(z_particles)
	var/z_level_str = "\"[src.loc.z]\""
	if(!z_particles[z_level_str])
		z_particles[z_level_str] = new/particles/rain/sideways/tile
	particles = z_particles[z_level_str]


/particles/snow
	width = 672
	height = 480
	count = 2500    // 2500 particles
	spawning = 12    // 12 new particles per 0.1s
	bound1 = list(-1000, -240, -1000)   // end particles at Y=-240
	lifespan = 600  // live for 60s max
	fade = 50       // fade out over the last 5s if still on screen
	// spawn within a certain x,y,z space
	position = generator("box", list(-350,50,0), list(300,350,50))
	// control how the snow falls
	gravity = list(0, -1)
	friction = 0.3  // shed 30% of velocity and drift every 0.1s
	drift = generator("sphere", 0, 2)

/particles/snow/dense
	spawning = 48

/particles/snow/mega_dense
	spawning = 100
	count = 5000

/particles/snow/grey
	color = generator("color", "#FFF", "#AAA")
	spawning = 100
	count = 5000

/particles/snow/grey/tile
	count = 5
	spawning = 1.1
	fade = 5
	lifespan = generator("num", 10, 30, LINEAR_RAND)
	position = generator("box", list(-96,32,0), list(96,64,50))
	bound1 = list(-32, -48, -500)
	bound2 = list(32, 64, 60)
	width = 96
	height = 96


/obj/effect/snow
	particles = new/particles/snow
	var/static/list/particles/z_particles
	layer = FLY_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/snow/client_attach
	screen_loc = "CENTER"

/obj/effect/snow/dense
	particles = new/particles/snow/dense

/obj/effect/snow/mega_dense
	particles = new/particles/snow/mega_dense

/obj/effect/snow/grey
	particles = new/particles/snow/grey

/obj/effect/snow/grey/tile
	particles = null

/obj/effect/snow/grey/tile/New()
	..()
	LAZYINITLIST(z_particles)
	var/z_level_str = "\"[src.loc.z]\""
	if(!z_particles[z_level_str])
		z_particles[z_level_str] = new/particles/snow/grey/tile
	particles = z_particles[z_level_str]


/datum/component/television
	var/viewsize = 3
	var/obj/machinery/camera/ourcam
	var/obj/ourthing // думаю ничего страшного не случится

/datum/component/television/Initialize(parent, newcam)
	ourthing = parent

	if(!newcam)
		for(var/obj/machinery/camera/cam in GLOB.cameranet.cameras)
			if(cam.c_tag == "Arena")
				newcam = cam
				break
	ourcam = newcam

	draw_picture()

/datum/component/television/proc/set_camera(newcam)
	ourcam = newcam

/datum/component/television/proc/draw_picture()
	var/list/visible_turfs = RANGE_TURFS(viewsize, ourcam)

	var/matrix/M = matrix()
	M.Translate((-16 * viewsize) - 8, (-16 * viewsize) - 8)
	M.Scale(0.5, 0.5)

	ourthing.transform = M
	ourthing.vis_contents = visible_turfs
	ourthing.icon_state = "clear"

/turf/closed/indestructible/black/television
	name = "Телевизор"
	layer = TURF_LAYER
	opacity = FALSE

/turf/closed/indestructible/black/television/main
	icon = 'white/valtos/icons/television.dmi'
	icon_state = "television"

/obj/effect/abstract/television
	name = "Телевизор"
	appearance_flags = KEEP_TOGETHER | TILE_BOUND
	layer = TURF_LAYER
	pixel_x = -64
	pixel_y = -64

/obj/effect/abstract/television/New()
	. = ..()
	AddComponent(/datum/component/television, src)

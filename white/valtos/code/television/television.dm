/datum/component/television
	var/viewsize = 3
	var/obj/machinery/camera/ourcam

/datum/component/television/Initialize(parent, newcam)
	if(!isturf(parent))
		return COMPONENT_INCOMPATIBLE

	if(!newcam)
		newcam = pick(GLOB.cameranet.cameras)
	ourcam = newcam

	draw_picture()

/datum/component/television/proc/set_camera(newcam)
	ourcam = newcam

/datum/component/television/proc/draw_picture()
	var/list/visible_turfs = RANGE_TURFS(viewsize, ourcam)

	parent.vis_contents = visible_turfs
	parent.icon_state = "clear"

/turf/closed/indestructible/black/television
	name = "ТЕЛЕВИЗОР"
	layer = TURF_LAYER

/turf/closed/indestructible/black/television/New()
	AddComponent(/datum/component/television)

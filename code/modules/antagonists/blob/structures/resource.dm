/obj/structure/blob/special/resource
	name = "ресурсная масса"
	icon = 'icons/mob/blob_64.dmi'
	icon_state = "resource"
	desc = "Огромная штука, которая заполнена чем-то."
	max_integrity = 60
	point_return = 15
	resistance_flags = LAVA_PROOF
	var/resource_delay = 0

/obj/structure/blob/special/resource/update_icon()
	. = ..()
	cut_overlays()
	color = null
	var/mutable_appearance/blob_overlay = mutable_appearance(icon, "strongpulse")
	if(overmind)
		blob_overlay.color = overmind.blobstrain.color
	color = overmind.blobstrain.color
	for(var/obj/structure/blob/B in orange(src,1))
		overlays += image(icon, "resourceconnect", dir = get_dir(src,B))
	add_overlay(blob_overlay)

	underlays.len = 0
	underlays += image(icon,"roots")

	update_health_overlay()

/obj/structure/blob/special/resource/scannerreport()
	return "Производит ресурсы для массы. Значительно ускоряет её рост."

/obj/structure/blob/special/resource/creation_action()
	if(overmind)
		overmind.resource_blobs += src

/obj/structure/blob/special/resource/Destroy()
	if(overmind)
		overmind.resource_blobs -= src
	return ..()

/obj/structure/blob/special/resource/Be_Pulsed()
	. = ..()
	if(resource_delay > world.time)
		return
	anim(target = loc, a_icon = icon, flick_anim = "resourcepulse", sleeptime = 15, lay = layer+0.5, offX = -16, offY = -16, alph = 220)
	if(overmind)
		overmind.add_points(BLOB_RESOURCE_GATHER_AMOUNT)
		resource_delay = world.time + BLOB_RESOURCE_GATHER_DELAY + overmind.resource_blobs.len * BLOB_RESOURCE_GATHER_ADDED_DELAY //4 seconds plus a quarter second for each resource blob the overmind has
	else
		resource_delay = world.time + BLOB_RESOURCE_GATHER_DELAY

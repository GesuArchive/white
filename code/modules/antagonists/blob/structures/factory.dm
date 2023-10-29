/obj/structure/blob/special/factory
	name = "производящая масса"
	icon = 'icons/mob/blob_64.dmi'
	icon_state = "factory"
	desc = "Узкая постройка..."
	max_integrity = BLOB_FACTORY_MAX_HP
	health_regen = BLOB_FACTORY_HP_REGEN
	point_return = BLOB_REFUND_FACTORY_COST
	resistance_flags = LAVA_PROOF
	max_spores = BLOB_FACTORY_MAX_SPORES

/obj/structure/blob/special/factory/update_icon()
	. = ..()
	cut_overlays()
	color = null
	var/mutable_appearance/blob_overlay = mutable_appearance(icon, "pulse")
	if(overmind)
		blob_overlay.color = overmind.blobstrain.color
	color = overmind.blobstrain.color
	for(var/obj/structure/blob/B in orange(src,1))
		overlays += image(icon, "factoryconnect", dir = get_dir(src,B))
	add_overlay(blob_overlay)

	underlays.len = 0
	underlays += image(icon,"roots")

	update_health_overlay()

/obj/structure/blob/special/factory/scannerreport()
	if(naut)
		return "На данный момент она занята Массанаутом. Производство спор приостановлено."
	return "Будет производить споры через каждые несколько секунд."

/obj/structure/blob/special/factory/creation_action()
	if(overmind)
		overmind.factory_blobs += src

/obj/structure/blob/special/factory/Destroy()
	for(var/mob/living/simple_animal/hostile/blob/blobspore/spore in spores)
		if(spore.factory == src)
			spore.factory = null
	if(naut)
		naut.factory = null
		to_chat(naut, span_userdanger("Завод уничтожен! ПОРА УМИРАТЬ!"))
		naut.throw_alert("nofactory", /atom/movable/screen/alert/nofactory)
	spores = null
	if(overmind)
		overmind.factory_blobs -= src
	return ..()

/obj/structure/blob/special/factory/Be_Pulsed()
	. = ..()
	if(produce_spores())
		anim(target = loc, a_icon = icon, flick_anim = "sporepulse", sleeptime = 15, lay = layer+0.5, offX = -16, offY = -16, alph = 220)
	else
		anim(target = loc, a_icon = icon, flick_anim = "factorypulse", sleeptime = 7, lay = layer+0.5, offX = -16, offY = -16, alph = 220)





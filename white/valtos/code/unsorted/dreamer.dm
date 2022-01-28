/datum/component/dreamer
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/mob/living/carbon/human/our_dreamer
	var/list/fucked_turfs = list()

/datum/component/dreamer/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	START_PROCESSING(SSobj, src)
	our_dreamer = parent

/datum/component/dreamer/RegisterWithParent()
	return

/datum/component/dreamer/UnregisterFromParent()
	return

/datum/component/dreamer/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/datum/component/dreamer/process(delta_time)

	var/list/fuckfloorlist = list()

	for(var/turf/T in view(15, our_dreamer))
		if(T in fucked_turfs)
			continue
		var/image/I = image(icon = T.icon, icon_state = T.icon_state, loc = T)

		I.alpha = rand(200, 255)
		I.plane = FLOOR_PLANE

		var/matrix/M = matrix()
		M.Translate(0, rand(-7, 7))

		animate(I, transform = M, time = rand(15, 35), loop = -1, easing = SINE_EASING)
		animate(transform = null, time = rand(15, 35), easing = SINE_EASING)

		fucked_turfs += T
		fuckfloorlist += I

	if(our_dreamer?.client)
		our_dreamer.client.images |= fuckfloorlist


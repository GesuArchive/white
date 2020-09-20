/obj/machinery/ai_slipper/smartfoam
	name = "умный пеномёт"
	desc = "На самом деле не очень. Активируется автоматически. Спасает зону от разгерметизации."
	uses = 3
	cooldown_time = 30 SECONDS
	req_access = list(ACCESS_AI_UPLOAD, ACCESS_ENGINE)

/obj/machinery/ai_slipper/smartfoam/process()
	var/turf/T = get_turf(src)
	if(!isopenturf(T))
		return
	var/turf/open/OT = T
	if(isspaceturf(T))
		emergency_foam_blast()
		return
	var/datum/gas_mixture/G = OT.return_air()
	if(G.return_pressure() < 0.01)
		emergency_foam_blast()
		return
	return

/obj/machinery/ai_slipper/smartfoam/emp_act(severity)
	. = ..()

	if(prob(50 / severity))
		emergency_foam_blast()

/obj/machinery/ai_slipper/smartfoam/proc/emergency_foam_blast()
	if(!uses || cooldown_time > world.time)
		return
	var/obj/item/grenade/smf = new /obj/item/grenade/clusterbuster/metalfoam/smart(loc)
	smf.prime()
	uses--
	cooldown = world.time + cooldown_time
	power_change()
	addtimer(CALLBACK(src, .proc/power_change), cooldown_time)

/obj/machinery/ai_slipper/smartfoam/interact(mob/user)
	if(!allowed(user))
		to_chat(user, "<span class='danger'>Доступ запрещён.</span>")
		return
	if(!uses)
		to_chat(user, "<span class='warning'>[capitalize(src.name)] полностью разряжен!</span>")
		return
	if(cooldown_time > world.time)
		to_chat(user, "<span class='warning'>[capitalize(src.name)] на перезарядке, осталось <b>[DisplayTimeText(world.time - cooldown_time)]</b>!</span>")
		return
	emergency_foam_blast()

/obj/item/grenade/clusterbuster/metalfoam/smart
	name = "Instant Smart Foam"
	payload = /obj/item/grenade/chem_grenade/smart_metal_foam

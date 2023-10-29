/**
 * Determines what happens to an atom when a swarmer interacts with it
 *
 * Determines behavior upon being interacted on by a swarmer.
 * Arguments:
 * * S - A reference to the swarmer doing the interaction
 */
#define DANGEROUS_DELTA_P 250	//Value in kPa where swarmers arent allowed to break a wall or window with this difference in pressure.

///Finds the greatest difference in pressure across a turf, only considers open turfs.
/turf/proc/return_turf_delta_p()
	var/pressure_greatest = 0
	var/pressure_smallest = INFINITY 					//Freaking terrified to use INFINITY, man
	for(var/t in RANGE_TURFS(1, src))			//Begin processing the delta pressure across the wall.
		var/turf/open/turf_adjacent = t
		if(!istype(turf_adjacent))
			continue
		pressure_greatest = max(pressure_greatest, turf_adjacent.air.return_pressure())
		pressure_smallest = min(pressure_smallest, turf_adjacent.air.return_pressure())

	return pressure_greatest - pressure_smallest

///Runs through all adjacent open turfs and checks if any are planetary_atmos returns true if even one passes.
/turf/proc/is_nearby_planetary_atmos()
	. = FALSE
	for(var/t in RANGE_TURFS(1, src))
		if(!isopenturf(t))
			continue
		var/turf/open/turf_adjacent = t
		if(turf_adjacent.planetary_atmos)
			return TRUE

/atom/proc/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	actor.dis_integrate(src)
	return TRUE //return TRUE/FALSE whether or not an AI swarmer should try this swarmer_act() again, NOT whether it succeeded.

/obj/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	if(resistance_flags & INDESTRUCTIBLE)
		return FALSE
	for(var/mob/living/living_content in contents)
		if(issilicon(living_content) || isbrain(living_content))
			continue
		to_chat(actor, span_warning("Внутри объекта обнаружен организм. Прерывание."))
		return FALSE
	return ..()

/obj/item/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	return actor.Integrate(src)

/**
 * Return used to determine how many resources a swarmer gains when consuming an object
 */
/obj/proc/integrate_amount()
	return 0

/obj/item/integrate_amount() //returns the amount of resources gained when eating this item
	var/list/mats = get_material_composition(ALL) // Ensures that items made from plasteel, and plas/titanium/plastitaniumglass get integrated correctly.
	if(length(mats) && (mats[GET_MATERIAL_REF(/datum/material/iron)] || mats[GET_MATERIAL_REF(/datum/material/glass)]))
		return 1
	return ..()



///obj/item/gun/swarmer_act()//Stops you from eating the entire armory
//	return FALSE

/turf/open/swarmer_act()//ex_act() on turf calls it on its contents, this is to prevent attacking mobs by DisIntegrate()'ing the floor
	return FALSE

/obj/structure/lattice/catwalk/swarmer_catwalk/swarmer_act()
	return FALSE

/obj/structure/swarmer/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	if(actor.AIStatus == AI_ON)
		return FALSE
	return ..()

/obj/effect/swarmer_act()
	return FALSE

/obj/effect/decal/cleanable/robot_debris/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	actor.dis_integrate(src)
	qdel(src)
	return TRUE

/obj/structure/swarmer_beacon/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	to_chat(actor, span_warning("Эта машина нужна для дальнейшего размножения роевиков. Прерывание."))
	return FALSE

/obj/structure/flora/swarmer_act()
	return FALSE

/turf/open/lava/swarmer_act()
	if(!is_safe())
		new /obj/structure/lattice/catwalk/swarmer_catwalk(src)
	return FALSE

/obj/machinery/atmospherics/swarmer_act()
	return FALSE

/obj/structure/disposalpipe/swarmer_act()
	return FALSE

/obj/machinery/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	actor.dismantle_machine(src)
	return TRUE

/obj/machinery/light/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	actor.dis_integrate(src)
	return TRUE

/obj/machinery/door/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	var/isonshuttle = istype(get_area(src), /area/shuttle)
	for(var/turf/turf_in_range in range(1, src))
		var/area/turf_area = get_area(turf_in_range)
		//Check for dangerous pressure differences
		if (turf_in_range.return_turf_delta_p() > DANGEROUS_DELTA_P)
			to_chat(actor, span_warning("Уничтожение этого объекта может вызвать взрывной сброс давления. Прерывание."))
			actor.target = null
			return TRUE
		//Check if breaking this door will expose the station to space/planetary atmos
		else if(turf_in_range.is_nearby_planetary_atmos() || isspaceturf(turf_in_range) || (!isonshuttle && (istype(turf_area, /area/shuttle) || istype(turf_area, /area/space))) || (isonshuttle && !istype(turf_area, /area/shuttle)))
			to_chat(actor, span_warning("Уничтожение этого объекта может привести к повреждению корпуса. Прерывание."))
			actor.target = null
			return FALSE
		//Check if this door is important in supermatter containment
		else if(istype(turf_area, /area/engineering/supermatter))
			to_chat(actor, span_warning("Нарушение условий содержания кристалла суперматериалы не пойдет нам на пользу. Прерывание."))
			actor.target = null
			return FALSE
	actor.dis_integrate(src)
	return TRUE

/obj/machinery/camera/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	actor.dis_integrate(src)
	if(!QDELETED(actor)) //If it got blown up no need to turn it off.
		toggle_cam(actor, FALSE)
	return TRUE

/obj/machinery/field/generator/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	actor.dis_integrate(src)
	return TRUE

/obj/machinery/gravity_generator/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	actor.dis_integrate(src)
	return TRUE

/obj/machinery/vending/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)//It's more visually interesting than dismantling the machine
	actor.dis_integrate(src)
	return TRUE

/obj/machinery/turretid/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	actor.dis_integrate(src)
	return TRUE

/obj/machinery/chem_dispenser/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	to_chat(actor, span_warning("Летучие химические вещества в этой машине уничтожат нас. Прерывание."))
	return FALSE

/obj/machinery/nuclearbomb/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	to_chat(actor, span_warning("Уничтожение этого устройства приведет к уничтожению всего в этом районе. Прерывание."))
	return FALSE

/obj/effect/rune/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	to_chat(actor, span_warning("Поиск... неисправность датчика! Цель потеряна. Прерывание."))
	return FALSE

/obj/structure/reagent_dispensers/fueltank/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	to_chat(actor, span_warning("Уничтожение этого объекта могло вызвать цепную реакцию. Прерывание."))
	return FALSE

/obj/structure/cable/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	to_chat(actor, span_warning("Нарушение энергосистемы не принесет нам пользы. Прерывание."))
	return FALSE

/obj/machinery/portable_atmospherics/canister/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	to_chat(actor, span_warning("В результате разрушения этого объекта может образоваться негостеприимный район. Прерывание."))
	return FALSE

/obj/machinery/telecomms/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	to_chat(actor, span_warning("Этот коммуникационный ретранслятор следует сохранить, он будет полезным ресурсом для наших мастеров в будущем. Прерывание."))
	return FALSE

/obj/machinery/deepfryer/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	to_chat(actor, span_warning("Этот кухонный агрегат подлежит сохранению,в будущем  он станет источником вкусной и нездоровой пищи для наших создателей. Прерывание."))
	return FALSE

/obj/machinery/power/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	to_chat(actor, span_warning("Нарушение энергосистемы не принесет нам пользы. Прерывание."))
	return FALSE

/obj/machinery/gateway/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	to_chat(actor, span_warning("Этот источник bluespace будет важен для нас позже. Прерывание."))
	return FALSE

/turf/closed/wall/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	var/isonshuttle = istype(loc, /area/shuttle)
	for(var/turf/turf_in_range in range(1, src))
		var/area/turf_area = get_area(turf_in_range)
		if (turf_in_range.return_turf_delta_p() > DANGEROUS_DELTA_P)
			to_chat(actor, span_warning("Уничтожение этого объекта может вызвать взрывной сброс давления. Прерывание."))
			actor.target = null
			return TRUE
		else if(turf_in_range.is_nearby_planetary_atmos() || isspaceturf(turf_area) || (!isonshuttle && (istype(turf_area, /area/shuttle) || istype(turf_area, /area/space))) || (isonshuttle && !istype(turf_area, /area/shuttle) ))
			to_chat(actor, span_warning("Уничтожение этого объекта может привести к повреждению корпуса. Прерывание."))
			actor.target = null
			return TRUE
		else if(istype(turf_area, /area/engineering/supermatter))
			to_chat(actor, span_warning("Нарушение условий содержания кристалла суперматериалы не пойдет нам на пользу. Прерывание."))
			actor.target = null
			return TRUE
	return ..()

/obj/structure/window/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	var/is_on_shuttle = istype(get_area(src), /area/shuttle)
	for(var/t in RANGE_TURFS(1, src))
		var/turf/turf_in_range = t
		var/area/turf_area = get_area(turf_in_range)
		if (turf_in_range.return_turf_delta_p() > DANGEROUS_DELTA_P)
			to_chat(actor, span_warning("Уничтожение этого объекта может вызвать взрывной сброс давления. Прерывание."))
			actor.target = null
			return TRUE
		else if(turf_in_range.is_nearby_planetary_atmos() || isspaceturf(turf_in_range) || (!is_on_shuttle && (istype(turf_area, /area/shuttle) || istype(turf_area, /area/space))) || (is_on_shuttle && !istype(turf_area, /area/shuttle)))
			to_chat(actor, span_warning("Уничтожение этого объекта может привести к повреждению корпуса. Прерывание."))
			actor.target = null
			return TRUE
		else if(istype(turf_area, /area/engineering/supermatter))
			to_chat(actor, span_warning("Нарушение условий содержания кристалла суперматериалы не пойдет нам на пользу. Прерывание."))
			actor.target = null
			return TRUE
	return ..()

/obj/item/stack/cable_coil/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)//Wiring would be too effective as a resource
	to_chat(actor, span_warning("Этот объект не содержит достаточно материалов для работы."))
	return FALSE

/obj/machinery/porta_turret/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	to_chat(actor, span_warning("Попытка демонтировать эту машину приведет к немедленной контратаке. Прерывание."))
	return FALSE

/obj/machinery/porta_turret_cover/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	to_chat(actor, span_warning("Попытка демонтировать эту машину приведет к немедленной контратаке. Прерывание."))
	return FALSE

/obj/structure/lattice/catwalk/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	var/turf/here = get_turf(src)
	for(var/a in here.contents)
		if(istype(a, /obj/structure/cable))
			to_chat(actor, span_warning("Нарушение энергосистемы не принесет нам пользы. Прерывание."))
			return FALSE
	return ..()

/obj/machinery/hydroponics/soil/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	to_chat(actor, span_warning("Этот объект не содержит достаточно материалов для работы."))
	return FALSE

/obj/machinery/field/generator/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	to_chat(actor, span_warning("Уничтожение этого объекта вызовет катастрофическую цепную реакцию. Прерывание."))
	return FALSE

/obj/machinery/field/containment/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	to_chat(actor, span_warning("Этот объект не содержит твердого вещества. Прерывание."))
	return FALSE

/obj/machinery/power/shieldwallgen/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	to_chat(actor, span_warning("Уничтожение этого объекта может непредсказуемо повлиять на целостность конструкции. Прерывание."))
	return FALSE

/obj/machinery/shieldwall/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	to_chat(actor, span_warning("Этот объект не содержит твердого вещества. Прерывание."))
	return FALSE

#undef DANGEROUS_DELTA_P

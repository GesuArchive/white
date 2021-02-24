/obj/item/circuitboard/machine/magnetic_concentrator
	name = "Магнитный Концентратор (Оборудование)"
	build_path = /obj/machinery/magnetic_concentrator
	req_components = list(/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/capacitor = 4,
		/obj/item/stock_parts/electrolite = 1)

/obj/machinery/magnetic_concentrator
	name = "магнитный концентратор"
	desc = "Если не вдаваться в технические подробности, то это самый обычный магнит. Требует излучатели для работы."
	icon = 'white/valtos/icons/power.dmi'
	icon_state = "magnetic_concentrator"

	density = TRUE
	anchored = FALSE

	circuit = /obj/item/circuitboard/machine/magnetic_concentrator

	var/magpower = 0
	var/maxmagpower = 120
	var/obj/singularity/hooked_singulo

	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	obj_flags = CAN_BE_HIT | DANGEROUS_POSSESSION

/obj/machinery/magnetic_concentrator/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>Сила магнитного притяжения [magpower]/[maxmagpower] единиц Теслы.</span>"
	if(hooked_singulo)
		. += "<hr><span class='notice'><b>Уровень сингулярности:</b> [hooked_singulo.current_size]/[hooked_singulo.allowed_size].</span>\n"
		. += "<hr><span class='notice'><b>Энергия:</b> [hooked_singulo.energy].</span>"

/obj/machinery/magnetic_concentrator/RefreshParts()
	var/t = 0
	for(var/obj/item/stock_parts/L in component_parts)
		t += L.rating * 20
	maxmagpower = t

/obj/machinery/magnetic_concentrator/update_icon_state()
	SSvis_overlays.remove_vis_overlay(src, managed_vis_overlays)
	luminosity = 0
	if(magpower > 1)
		luminosity = 1
		SSvis_overlays.add_vis_overlay(src, icon, "magnetic_concentrator_overlay", EMISSIVE_LAYER, ABOVE_LIGHTING_PLANE, dir, alpha)

/obj/machinery/magnetic_concentrator/bullet_act(obj/projectile/Proj)
	if(Proj.flag != BULLET)
		magpower = min(magpower + Proj.damage, maxmagpower)
		update_icon()
	. = ..()

/obj/machinery/magnetic_concentrator/attackby(obj/item/I, mob/living/user, params)
	if(I.tool_behaviour == TOOL_WRENCH)
		default_unfasten_wrench(user, I, time = 20)
	else
		. = ..()

/obj/machinery/magnetic_concentrator/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/machinery/magnetic_concentrator/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/machinery/magnetic_concentrator/singularity_pull(S, current_size)
	return

/obj/machinery/magnetic_concentrator/process()
	if(!hooked_singulo && magpower > 1)
		for(var/obj/singularity/S in orange(1, src))
			hooked_singulo = S
			hooked_singulo.forceMove(get_turf(src))
			hooked_singulo.alpha = 200
			visible_message("<span class='warning'>[capitalize(src.name)] цапает сингулярность!</span>")
			qdel(hooked_singulo.singularity_component)
	else if (hooked_singulo)
		if(magpower > 1)
			magpower -= hooked_singulo.current_size * 3
			hooked_singulo.forceMove(get_turf(src))
			for (var/_tile in spiral_range_turfs(hooked_singulo.current_size, src))
				var/turf/tile = _tile
				if (!tile || !isturf(loc))
					continue
				if(tile == get_turf(src))
					continue
				if (get_dist(tile, src) > 1)
					tile.singularity_pull(src, hooked_singulo.current_size)
				for (var/_thing in tile)
					var/atom/thing = _thing
					if (QDELETED(thing))
						continue
					if (isturf(loc) && thing != src && thing != hooked_singulo)
						var/atom/movable/movable_thing = thing
						if (get_dist(movable_thing, src) > 1)
							movable_thing.singularity_pull(src, hooked_singulo.current_size)
						else
							hooked_singulo.consume(movable_thing)
					CHECK_TICK
		else
			hooked_singulo.be_free()
			hooked_singulo.alpha = 255
			hooked_singulo = null

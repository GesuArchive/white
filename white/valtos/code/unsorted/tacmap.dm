/proc/gen_tacmap(map_z = 2)
	var/icon/tacmap_icon = new('white/valtos/icons/tacmap.dmi', "tacmap_base")
	// берём все турфы с нужного з-уровня и рисуем шедевр
	for(var/xx in 1 to world.maxx)
		for(var/yy in 1 to world.maxy)
			var/turf/T = locate(xx, yy, map_z)
			if(isspaceturf(T) || isopenspace(T))
				if(locate(/obj/structure/lattice) in T)
					tacmap_icon.DrawBox(rgb(143, 103, 175), xx, yy, xx, yy)
				continue
			if(isopenturf(T))
				if(isplatingturf(T))
					if(locate(/obj/structure/window) in T)
						tacmap_icon.DrawBox(rgb(0, 60, 255), xx, yy, xx, yy)
					else if(locate(/obj/machinery/door) in T)
						tacmap_icon.DrawBox(rgb(255, 0, 0), xx, yy, xx, yy)
					else
						tacmap_icon.DrawBox(rgb(109, 42, 128), xx, yy, xx, yy)
					continue
				tacmap_icon.DrawBox(rgb(220, 44, 255), xx, yy, xx, yy)
				continue
			if(isclosedturf(T))
				tacmap_icon.DrawBox(rgb(0, 195, 255), xx, yy, xx, yy)
	return tacmap_icon

/proc/gen_tacmap_areas(map_z = 2)
	var/icon/tacmap_icon = new('white/valtos/icons/tacmap.dmi', "tacmap_base")
	for(var/xx in 1 to world.maxx)
		for(var/yy in 1 to world.maxy)
			var/turf/T = locate(xx, yy, map_z)
			if(isspaceturf(T) || isopenspace(T))
				continue
			var/area/A = get_area(T)
			if(istype(A, /area/hallway))
				tacmap_icon.DrawBox(rgb(255, 255, 255), xx, yy, xx, yy)
				continue
			if(istype(A, /area/security))
				tacmap_icon.DrawBox(rgb(255, 0, 0), xx, yy, xx, yy)
				continue
			if(istype(A, /area/cargo))
				tacmap_icon.DrawBox(rgb(209, 101, 43), xx, yy, xx, yy)
				continue
			if(istype(A, /area/cargo))
				tacmap_icon.DrawBox(rgb(209, 101, 43), xx, yy, xx, yy)
				continue
			if(istype(A, /area/service/hydroponics) || istype(A, /area/service/chapel) || istype(A, /area/service/library) || istype(A, /area/commons))
				tacmap_icon.DrawBox(rgb(62, 209, 43), xx, yy, xx, yy)
				continue
			if(istype(A, /area/science))
				tacmap_icon.DrawBox(rgb(209, 43, 209), xx, yy, xx, yy)
				continue
			if(istype(A, /area/medical))
				tacmap_icon.DrawBox(rgb(0, 255, 229), xx, yy, xx, yy)
				continue
			if(istype(A, /area/ai_monitored) || istype(A, /area/command/teleporter) || istype(A, /area/command/gateway) || istype(A, /area/command))
				tacmap_icon.DrawBox(rgb(0, 60, 255), xx, yy, xx, yy)
				continue
			if(istype(A, /area/commons/storage) || istype(A, /area/maintenance))
				tacmap_icon.DrawBox(rgb(70, 70, 70), xx, yy, xx, yy)
				continue
			if(istype(A, /area/commons/vacant_room) || istype(A, /area/tcommsat) || istype(A, /area/comms) || istype(A, /area/server) || istype(A, /area/solar) || istype(A, /area/engineering))
				tacmap_icon.DrawBox(rgb(255, 145, 0), xx, yy, xx, yy)
				continue
	return tacmap_icon

/proc/gen_tacmap_full(map_z = 2)
	var/icon/mapofthemap   = gen_tacmap(map_z)
	var/icon/areasofthemap = gen_tacmap_areas(map_z)
	mapofthemap.Blend(areasofthemap, ICON_MULTIPLY)
	return mapofthemap

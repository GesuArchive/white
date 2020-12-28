/obj/effect/landmark/stationroom
	var/list/template_names = list()
	layer = BULLET_HOLE_LAYER

/obj/effect/landmark/stationroom/New()
	..()
	GLOB.stationroom_landmarks += src

/obj/effect/landmark/stationroom/Destroy()
	if(src in GLOB.stationroom_landmarks)
		GLOB.stationroom_landmarks -= src
	return ..()

/obj/effect/landmark/stationroom/proc/load(template_name)
	var/turf/T = get_turf(src)
	if(!T)
		return FALSE
	if(!template_name)
		for(var/t in template_names)
			if(!SSmapping.station_room_templates[t])
				log_world("Station room spawner placed at ([T.x], [T.y], [T.z]) has invalid ruin name of \"[t]\" in its list")
				template_names -= t
		template_name = pickweight(template_names)
	if(!template_name)
		GLOB.stationroom_landmarks -= src
		qdel(src)
		return FALSE
	var/datum/map_template/ruin/template = SSmapping.station_room_templates[template_name]
	if(!template)
		return FALSE
	testing("Station part \"[template_name]\" placed at ([T.x], [T.y], [T.z])")
	template.load(T, centered = FALSE)
	if(template.always_spawn_with)
		for(var/v in template.always_spawn_with)
			var/turf/LO = locate(T.x, T.y, T.z - 1)
			var/datum/map_template/MT = new v
			var/datum/map_template/ruin/below_temp = SSmapping.station_room_templates[MT.name]
			below_temp.load(LO, centered = FALSE)
			below_temp.loaded++
	template.loaded++
	GLOB.stationroom_landmarks -= src
	qdel(src)
	return TRUE

/obj/effect/landmark/stationroom/brig
	template_names = list("Default Brig" = 10, "Loose Brig" = 4, "Armored Brig" = 3)

/obj/effect/landmark/stationroom/bar
	template_names = list("Default Bar" = 10, "Neon Bar" = 4, "Lava Bar" = 3)

/obj/effect/landmark/stationroom/bridge
	template_names = list("Default Central" = 10, "Compact Central" = 4, "Interesting Central" = 3)

/obj/effect/landmark/stationroom/engine
	template_names = list("Supermatter" = 8, "Singulo or Tesla" = 10)

/obj/effect/landmark/stationroom/maint_sw
	template_names = list("Default Maint SW" = 10, "Arena Maint SW" = 4, "Chess Maint SW" = 3)

/obj/effect/landmark/stationroom/medbay
	template_names = list("Default Medbay" = 10, "Durka Medbay" = 2)

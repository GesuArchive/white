/datum/map_generator/dwarf_caves
	var/width = 100
	var/height = 250
	var/list/_map = list()

/datum/map_generator/dwarf_caves/proc/generate_map()
	for(var/y in 1 to height)
		for(var/x in 1 to width)
			var/v = rand(0,100) <=40 ? 1 : 0
			_map.Add(v)

/datum/map_generator/dwarf_caves/proc/iswall(n)
	if((n<=0)||(n>_map.len))
		return 1
	return _map[n]

/datum/map_generator/dwarf_caves/proc/willbewall(n, amount)
	var/walls = 0
	for(var/i in list(iswall(n-1), iswall(n+1), iswall(n-width), iswall(n+width), iswall(n+width+1), iswall(n+width-1), iswall(n-width-1), iswall(n-width+1)))
		if(i)
			walls++
	return walls>=amount

/datum/map_generator/dwarf_caves/proc/willbespace(n, amount)
	var/spaces = 0
	for(var/i in list(!iswall(n-1), !iswall(n+1), !iswall(n-width), !iswall(n+width), !iswall(n+width+1), !iswall(n+width-1), !iswall(n-width-1), !iswall(n-width+1)))
		if(i)
			spaces++
	return spaces>=amount

/datum/map_generator/dwarf_caves/proc/smooth()
	for(var/i in 1 to _map.len)
		var/ww = willbewall(i, 5)
		var/sw = willbewall(i, 6)
		if(ww&&iswall(i))
			_map[i] = 1
		else if(sw&&!iswall(i)||willbespace(i,6))
			_map[i] = 1

/datum/map_generator/dwarf_caves/proc/clean()
	for(var/i in 1 to _map.len)
		if(willbespace(i,6)&&iswall(i))
			_map[i] = 0

/datum/map_generator/dwarf_caves/proc/fauna(turf/T)
	if(prob(0.1))
		new /mob/living/simple_animal/hostile/asteroid/goliath/beast/ancient(T)
	else if(prob(2))
		new /mob/living/simple_animal/hostile/frogman(T)
	else if(prob(0.1))
		new /mob/living/simple_animal/hostile/froggernaut(T)

/datum/map_generator/dwarf_caves/proc/flora(turf/T)
	if(prob(0.7))
		new /obj/structure/flora/tree/boxplanet/glikodil(T)
	else if(prob(0.7))
		new /obj/structure/flora/tree/boxplanet/svetosvin(T)
	else if(prob(0.7))
		new /obj/structure/flora/tree/boxplanet/kartoshmel(T)


/datum/map_generator/dwarf_caves/generate_terrain(list/turfs)
	var/time = REALTIMEOFDAY
	generate_map()
	for(var/i in 1 to 5)
		smooth()
	for(var/i in 1 to 5)
		clean()
	for(var/i in turfs)
		var/turf/T = i
		var/n = T.x+T.y*width
		var/wall = iswall(n)
		if(wall)
			T.ChangeTurf(/turf/closed/mineral/random/dwarf_lustress)
		else
			T.ChangeTurf(/turf/open/floor/grass/gensgrass/dirty/stone/raw)
			fauna(T)
			flora(T)
	log_world("Generated dwarf caves in [(REALTIMEOFDAY-time)/10]s")



/area/awaymission/vietnam/dwarfgen
	name = "Тёмное подземелье"
	icon_state = "unexplored"
	outdoors = TRUE
	static_lighting = TRUE
	base_lighting_alpha = 0
	ambientsounds = AWAY_MISSION
	requires_power = FALSE
	sound_environment = SOUND_ENVIRONMENT_CAVE
	ambientsounds = list('white/valtos/sounds/lifeweb/caves8.ogg', 'white/valtos/sounds/lifeweb/caves_old.ogg')
	map_generator = /datum/map_generator/dwarf_caves

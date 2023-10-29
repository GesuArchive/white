//Causes fire damage to anyone not standing on a dense object.
/datum/weather/floor_is_lava
	name = "the floor is lava"
	desc = "Пол превращается в удивительно прохладную лаву, слегка повреждая что-либо на полу."

	telegraph_message = span_warning("Ощущаю, что земля под моими ногами становится горячей. Волны тепла искажают воздух.")
	telegraph_duration = 150

	weather_message = span_userdanger("Пол - лава! Нужно куда-то повыше!")
	weather_duration_lower = 300
	weather_duration_upper = 600
	weather_overlay = "lava"

	end_message = span_danger("Пол остывает и возвращается к своей обычной форме.")
	end_duration = 0

	area_type = /area
	protected_areas = list(/area/space)
	target_trait = ZTRAIT_STATION

	overlay_layer = ABOVE_OPEN_TURF_LAYER //Covers floors only
	overlay_plane = FLOOR_PLANE
	immunity_type = TRAIT_LAVA_IMMUNE


/datum/weather/floor_is_lava/weather_act(mob/living/L)
	if(issilicon(L))
		return
	if(istype(L.buckled, /obj/structure/bed))
		return
	for(var/obj/structure/O in L.loc)
		if(O.density)
			return
	if(L.loc.density)
		return
	if(!L.client) //Only sentient people are going along with it!
		return
	if(L.movement_type & FLYING)
		return
	L.adjustFireLoss(3)

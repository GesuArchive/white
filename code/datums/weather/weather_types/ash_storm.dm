//Ash storms happen frequently on lavaland. They heavily obscure vision, and cause high fire damage to anyone caught outside.
/datum/weather/ash_storm
	name = "ash storm"
	desc = "Интенсивная атмосферная буря поднимает пепел с поверхности планеты и вздымает его по всей области, нанося интенсивный урон от огня незащищенным."

	telegraph_message = span_boldwarning("Жуткий стон ветра слышен. Куски горящего пепла чернят горизонт. Пора искать убежище.")
	telegraph_duration = 300
	telegraph_overlay = "light_ash"

	weather_message = span_userdanger("<i>Тлеющие тучи палящего пепла вокруг меня! В УБЕЖИЩЕ!</i>")
	weather_duration_lower = 600
	weather_duration_upper = 1200
	weather_overlay = "ash_storm"

	end_message = span_boldannounce("Визжащий ветер смахивает остатки пепла и возвращает его обычный шум. Теперь должно быть безопасно выйти наружу.")
	end_duration = 300
	end_overlay = "light_ash"

	area_type = /area
	protect_indoors = TRUE
	target_trait = ZTRAIT_ASHSTORM

	immunity_type = WEATHER_ASH

	probability = 90

	barometer_predictable = TRUE
	var/list/weak_sounds = list()
	var/list/strong_sounds = list()

/datum/weather/ash_storm/telegraph()
	var/list/eligible_areas = list()
	for (var/z in impacted_z_levels)
		eligible_areas += SSmapping.areas_in_z["[z]"]
	for(var/i in 1 to eligible_areas.len)
		var/area/place = eligible_areas[i]
		if(place.outdoors)
			weak_sounds[place] = /datum/looping_sound/weak_outside_ashstorm
			strong_sounds[place] = /datum/looping_sound/active_outside_ashstorm
		else
			weak_sounds[place] = /datum/looping_sound/weak_inside_ashstorm
			strong_sounds[place] = /datum/looping_sound/active_inside_ashstorm
		CHECK_TICK

	//We modify this list instead of setting it to weak/stron sounds in order to preserve things that hold a reference to it
	//It's essentially a playlist for a bunch of components that chose what sound to loop based on the area a player is in
	GLOB.ash_storm_sounds += weak_sounds
	return ..()

/datum/weather/ash_storm/start()
	GLOB.ash_storm_sounds -= weak_sounds
	GLOB.ash_storm_sounds += strong_sounds
	return ..()

/datum/weather/ash_storm/wind_down()
	GLOB.ash_storm_sounds -= strong_sounds
	GLOB.ash_storm_sounds += weak_sounds
	return ..()

/datum/weather/ash_storm/end()
	GLOB.ash_storm_sounds -= weak_sounds
	return ..()

/datum/weather/ash_storm/proc/is_ash_immune(atom/L)
	while (L && !isturf(L))
		if(ismecha(L)) //Mechs are immune
			return TRUE
		if(ishuman(L)) //Are you immune?
			var/mob/living/carbon/human/H = L
			var/thermal_protection = H.get_thermal_protection()
			if(thermal_protection >= FIRE_IMMUNITY_MAX_TEMP_PROTECT)
				return TRUE
		if(isliving(L))// if we're a non immune mob inside an immune mob we have to reconsider if that mob is immune to protect ourselves
			var/mob/living/the_mob = L
			if((WEATHER_ASH in the_mob.weather_immunities) || (WEATHER_ALL in the_mob.weather_immunities))
				return TRUE
		if(istype(L, /obj/structure/closet))
			var/obj/structure/closet/the_locker = L
			if(the_locker.weather_protection)
				if((WEATHER_ASH in the_locker.weather_protection) || (WEATHER_ALL in the_locker.weather_protection))
					return TRUE
		L = L.loc //Check parent items immunities (recurses up to the turf)
	return FALSE //RIP you

/datum/weather/ash_storm/weather_act(mob/living/L)
	if(is_ash_immune(L))
		return
	L.adjustFireLoss(4)


//Emberfalls are the result of an ash storm passing by close to the playable area of lavaland. They have a 10% chance to trigger in place of an ash storm.
/datum/weather/ash_storm/emberfall
	name = "emberfall"
	desc = "Проходящий пепельный шторм покрывает область в безобидных углях."

	weather_message = span_notice("Нежные тлеющие угольки летят вокруг меня, как гротескный снег. Шторм, кажется, прошел мимо меня...")
	weather_overlay = "light_ash"

	end_message = span_notice("Пепельный шторм сначала замедляется, потом останавливается. Еще один слой отвердевшей сажи на базальте под ногами.")
	end_sound = null

	aesthetic = TRUE

	probability = 10

//Ash storms happen frequently on lavaland. They heavily obscure vision, and cause high fire damage to anyone caught outside.
/datum/weather/just_rain
	name = "just rain"
	desc = "Простой дождик. Что?"

	telegraph_message = span_notice("Кажется дождь начинается...")
	telegraph_duration = 300
	telegraph_overlay = "little_rain"
	telegraph_sound = 'sound/ambience/rain_startstop.ogg'

	weather_message = span_boldnotice("<i>Дождик начинает усиливаться!</i>")
	weather_duration_lower = 600
	weather_duration_upper = 1200
	weather_overlay = "just_rain"
	weather_sound = 'sound/ambience/rain_mid.ogg'

	end_message = span_notice("Дождь сбавляет свои обороты, похоже он начал успокаиваться...")
	end_duration = 300
	end_overlay = "little_rain"
	end_sound = 'sound/ambience/rain_startstop.ogg'

	area_type = /area
	protect_indoors = TRUE
	target_trait = ZTRAIT_STATION

	immunity_type = WEATHER_STORM

/datum/weather/just_rain/weather_act(mob/living/L)
	L.adjust_bodytemperature(-rand(5, 10))

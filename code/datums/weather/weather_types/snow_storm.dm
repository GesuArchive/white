/datum/weather/snow_storm
	name = "snow storm"
	desc = "Сильные снежные бури бродят по вершине этой арктической планеты, хороня любую область, достаточно неудачную, чтобы оказаться на ее пути."
	probability = 90

	telegraph_message = span_warning("Дрейфующие частицы снега начинают создавать пыль вокруг...")
	telegraph_duration = 300
	telegraph_overlay = "light_snow"

	weather_message = span_userdanger("<i>Резкий ветер усиливается, когда с неба начинает падать густой снег! В УБЕЖИЩЕ!</i>")
	weather_overlay = "snow_storm"
	weather_duration_lower = 600
	weather_duration_upper = 1500

	end_duration = 100
	end_message = span_boldannounce("Снегопад стихает, выходить на улицу снова безопасно.")

	area_type = /area
	protect_indoors = TRUE
	target_trait = ZTRAIT_SNOWSTORM

	immunity_type = WEATHER_SNOW

	barometer_predictable = TRUE


/datum/weather/snow_storm/weather_act(mob/living/L)
	L.adjust_bodytemperature(-rand(5,15))


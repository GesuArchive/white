/obj/item/firing_pin/off_station
	name = "внестанционный ударник"
	desc = "Разрешает стрелять из пушек, когда пушки не на станции. Полезно."
	fail_message = span_warning("ПРОТОКОЛЫ БЕЗОПАСНОСТИ В ДЕЙСТВИИ.")
	pin_removeable = TRUE

/obj/item/firing_pin/off_station/pin_auth(mob/living/user)
	if(!istype(user))
		return FALSE
	var/turf/T = get_turf(user)
	if(!T)
		return FALSE
	if(is_station_level(T.z))
		return FALSE
	return TRUE

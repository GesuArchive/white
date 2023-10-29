/obj/item/device/loic_remote
	name = "Пульт управления ионной пушкой LOIC"
	desc = "Пульт дистанционного управления, способный посылать сигнал на ближайший удаленный спутник Синдиката, оснащенный ионной пушкой."
	icon = 'icons/obj/device.dmi'
	icon_state = "batterer"
	w_class = WEIGHT_CLASS_SMALL
	/// How long until this can be used again?
	var/recharge_time = 20 MINUTES
	COOLDOWN_DECLARE(ion_cooldown)

/obj/item/device/loic_remote/New()
	..()
	START_PROCESSING(SSobj, src)

/obj/item/device/loic_remote/Destroy()
	STOP_PROCESSING(SSobj, src)
	..()

/obj/item/device/loic_remote/process()
	update_appearance(UPDATE_ICON)

/obj/item/device/loic_remote/update_icon(updates=ALL)
	. = ..()
	if(COOLDOWN_FINISHED(src, ion_cooldown))
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]burnt"

/obj/item/device/loic_remote/examine(mob/user)
	. = ..()
	if(COOLDOWN_FINISHED(src, ion_cooldown))
		. += "Устройство готово к использованию."
	else
		var/seconds_left = COOLDOWN_TIMELEFT(src, ion_cooldown)/10
		var/minutes_left_rounded = round(seconds_left/60, 0.1) // Don't want to deal with "1 minutes".
		if(minutes_left_rounded > 1)
			. += "Перезарядка через [minutes_left_rounded] минут."
		else
			. += "Перезарядка через [seconds_left] секунд."

/obj/item/device/loic_remote/attack_self(mob/user)
	if(!COOLDOWN_FINISHED(src, ion_cooldown))
		to_chat(user, span_notice("Устройство ещё не готово."))
		return
	if(!is_type_in_list(get_area(src), GLOB.the_station_areas))
		to_chat(user, span_notice("Пульт не может установить соединение. Вам необходимо находиться на станции."))
		return

	COOLDOWN_START(src, ion_cooldown, recharge_time)
	to_chat(user, span_notice("[src] мигает зеленым светом на мгновение."))

	var/datum/round_event/ion_storm/malicious/ion = new()
	ion.location_name = get_area_name(src, TRUE)

	message_admins("[key_name_admin(user)] сгенерировали ионный закон с помощью пульта LOIC.")
	log_admin("[key_name(user)] сгенерировали ионный закон с помощью пульта LOIC.")

/obj/item/radio/intercom
	name = "интерком"
	desc = "Говори в эту штуку."
	icon_state = "intercom"
	anchored = TRUE
	w_class = WEIGHT_CLASS_BULKY
	canhear_range = 2
	dog_fashion = null
	unscrewed = FALSE

/obj/item/radio/intercom/unscrewed
	unscrewed = TRUE

/obj/item/radio/intercom/Initialize(mapload, ndir, building)
	. = ..()
	if(building)
		setDir(ndir)
	var/area/current_area = get_area(src)
	if(!current_area)
		return
	RegisterSignal(current_area, COMSIG_AREA_POWER_CHANGE, PROC_REF(AreaPowerCheck), override = TRUE)

/obj/item/radio/intercom/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>Используй [MODE_TOKEN_INTERCOM], когда ты находишься рядом, чтобы говорить в него.</span>"
	if(!unscrewed)
		. += "<hr><span class='notice'>Это <b>прикручено</b> крепко к стене.</span>"
	else
		. += "<hr><span class='notice'>Это <i>откручено</i> от стены и может быть <b>отсоединено</b>.</span>"

/obj/item/radio/intercom/attackby(obj/item/I, mob/living/user, params)
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		if(unscrewed)
			user.visible_message(span_notice("[user] начинает затягивать винтики [src.name]...") , span_notice("Начинаю прикручивать [src.name]..."))
			if(I.use_tool(src, user, 30, volume=50))
				user.visible_message(span_notice("[user] затягивает винтики [src.name]!") , span_notice("Прикручиваю [src.name]."))
				unscrewed = FALSE
		else
			user.visible_message(span_notice("[user] начинает откручивать винтики [src.name]...") , span_notice("Начинаю откручивать [src.name]..."))
			if(I.use_tool(src, user, 40, volume=50))
				user.visible_message(span_notice("[user] откручивает винтики [src.name]!") , span_notice("Откручиваю [src.name] от стены."))
				unscrewed = TRUE
		return
	else if(I.tool_behaviour == TOOL_WRENCH)
		if(!unscrewed)
			to_chat(user, span_warning("Нужно открутить [src.name] от стены!"))
			return
		user.visible_message(span_notice("[user] начинает снимать [src.name]...") , span_notice("Начинаю снимать [src.name]..."))
		I.play_tool_sound(src)
		if(I.use_tool(src, user, 80))
			user.visible_message(span_notice("[user] снимает [src.name]!") , span_notice("Снимаю [src.name] со стены."))
			playsound(src, 'sound/items/deconstruct.ogg', 50, TRUE)
			new/obj/item/wallframe/intercom(get_turf(src))
			qdel(src)
		return
	return ..()

/**
 * Override attack_tk_grab instead of attack_tk because we actually want attack_tk's
 * functionality. What we DON'T want is attack_tk_grab attempting to pick up the
 * intercom as if it was an ordinary item.
 */
/obj/item/radio/intercom/attack_tk_grab(mob/user)
	interact(user)
	return COMPONENT_CANCEL_ATTACK_CHAIN


/obj/item/radio/intercom/attack_ai(mob/user)
	interact(user)

/obj/item/radio/intercom/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	interact(user)

/obj/item/radio/intercom/ui_state(mob/user)
	return GLOB.default_state

/obj/item/radio/intercom/can_receive(freq, list/levels)
	if(levels != RADIO_NO_Z_LEVEL_RESTRICTION)
		var/turf/position = get_turf(src)
		if(isnull(position) || !(position.z in levels))
			return FALSE
	if(freq == FREQ_SYNDICATE)
		if(!(syndie))
			return FALSE//Prevents broadcast of messages over devices lacking the encryption

	return TRUE


/obj/item/radio/intercom/Hear(message, atom/movable/speaker, message_langs, raw_message, radio_freq, list/spans, list/message_mods = list())
	if(message_mods[RADIO_EXTENSION] == MODE_INTERCOM)
		return  // Avoid hearing the same thing twice
	return ..()

/obj/item/radio/intercom/emp_act(severity)
	. = ..() // Parent call here will set `on` to FALSE.
	update_icon()

/obj/item/radio/intercom/end_emp_effect(curremp)
	. = ..()
	AreaPowerCheck() // Make sure the area/local APC is powered first before we actually turn back on.

/obj/item/radio/intercom/update_icon()
	. = ..()
	if(on)
		icon_state = initial(icon_state)
	else
		icon_state = "intercom-p"

/**
 * Proc called whenever the intercom's area loses or gains power. Responsible for setting the `on` variable and calling `update_icon()`.
 *
 * Normally called after the intercom's area recieves the `COMSIG_AREA_POWER_CHANGE` signal, but it can also be called directly.
 * Arguments:
 * * source - the area that just had a power change.
 */
/obj/item/radio/intercom/proc/AreaPowerCheck(datum/source)
	var/area/current_area = get_area(src)
	if(!current_area)
		set_on(FALSE)
	else
		set_on(current_area.powered(AREA_USAGE_EQUIP)) // set "on" to the equipment power status of our area.
	update_icon()

/obj/item/radio/intercom/add_blood_DNA(list/blood_dna)
	return FALSE

//Created through the autolathe or through deconstructing intercoms. Can be applied to wall to make a new intercom on it!
/obj/item/wallframe/intercom
	name = "каркас интеркома"
	desc = "Готовый интерком. Просто ударьте им по стене и прикрутите!"
	icon_state = "intercom"
	result_path = /obj/item/radio/intercom/unscrewed
	pixel_shift = 29
	inverse = TRUE
	custom_materials = list(/datum/material/iron = 75, /datum/material/glass = 25)

/obj/item/radio/intercom/chapel
	name = "Конфессиональный интерком"
	anonymize = TRUE

/obj/item/radio/intercom/chapel/Initialize(mapload, ndir, building)
	. = ..()
	set_frequency(1481)
	set_broadcasting(TRUE)

MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom, 26)
MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/prison, 26)
MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/chapel, 26)

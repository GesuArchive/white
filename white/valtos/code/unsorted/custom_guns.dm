// !скины на всякое
GLOBAL_LIST_INIT(custom_skin_donators, list("valtosss" = list("bullshit", "asiimov")))

/datum/element/decal/custom_skin

/datum/element/decal/custom_skin/Attach(datum/target, _icon, _icon_state, _dir, _plane, _layer, _alpha, _color, _smoothing, _cleanable=CLEAN_TYPE_PAINT, _description, mutable_appearance/_pic)
	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE

	. = ..()
	RegisterSignal(target, COMSIG_ATOM_GET_EXAMINE_NAME, .proc/get_examine_name, TRUE)

/datum/element/decal/custom_skin/generate_appearance(_icon, _icon_state, _dir, _plane, _layer, _color, _alpha, _smoothing, source)
	var/obj/item/I = source
	if(!_icon)
		_icon = 'white/valtos/icons/custom_guns.dmi'
	if(!_icon_state)
		_icon_state = "asiimov"
	var/icon = I.icon
	var/icon_state = I.icon_state
	if(!icon || !icon_state)
		icon = I.icon
		icon_state = I.icon_state
	var/static/list/skin_appearances = list()
	var/index = "[md5(I.name)]-[_icon_state]"
	pic = skin_appearances[index]

	if(!pic)
		var/icon/temp_icon = icon(I.icon, I.icon_state, , 1)
		temp_icon.Blend(icon(_icon, _icon_state), ICON_ADD)
		pic = mutable_appearance(temp_icon, I.icon_state)
		skin_appearances[index] = pic
	return TRUE

/datum/element/decal/custom_skin/Detach(atom/source)
	UnregisterSignal(source, COMSIG_ATOM_GET_EXAMINE_NAME)
	return ..()

/datum/element/decal/custom_skin/proc/get_examine_name(datum/source, mob/user, list/override)
	SIGNAL_HANDLER
	. = "<small class='his_grace'>[capitalize(source)]</small>"
	return COMPONENT_EXNAME_CHANGED

/obj/item/gun/proc/change_skin(datum/source, mob/user)
	if(ishuman(user) && (user?.ckey in GLOB.custom_skin_donators))
		var/list/possible_skins = GLOB.custom_skin_donators[user.ckey]
		var/list/choices = list()
		for(var/skin in possible_skins)
			choices[skin] = image(icon = 'white/valtos/icons/custom_guns.dmi', icon_state = skin)
		var/choice = show_radial_menu(user, src, choices, tooltips = TRUE)
		if(!choice)
			return
		AddElement(/datum/element/decal/custom_skin, _icon_state = choice)

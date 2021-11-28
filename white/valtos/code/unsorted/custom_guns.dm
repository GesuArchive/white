// !скины на всякое
GLOBAL_LIST_INIT(custom_skin_donators, list("valtosss" = list("bullshit", "asiimov")))

/datum/element/custom_skin
	element_flags = ELEMENT_BESPOKE|ELEMENT_DETACH
	id_arg_index = 2
	var/image/skin_overlay

/datum/element/custom_skin/Attach(atom/target, skin_icon = 'white/valtos/icons/custom_guns.dmi', skin_icon_state = "asiimov")
	. = ..()
	if(!isatom(target))
		return ELEMENT_INCOMPATIBLE
	if(!skin_overlay)
		var/icon/temp_icon = icon(target.icon, target.icon_state, , 1)
		temp_icon.Blend("#fff", ICON_ADD)
		temp_icon.Blend(icon(skin_icon, skin_icon_state), ICON_MULTIPLY)
		skin_overlay = mutable_appearance(temp_icon, target.icon_state)
	RegisterSignal(target, COMSIG_ATOM_UPDATE_OVERLAYS, .proc/apply_skin_overlay)
	RegisterSignal(target, COMSIG_ATOM_GET_EXAMINE_NAME, .proc/get_examine_name, TRUE)
	target.update_icon(UPDATE_OVERLAYS)

/datum/element/custom_skin/Detach(atom/source)
	. = ..()
	UnregisterSignal(source, COMSIG_ATOM_UPDATE_OVERLAYS)
	UnregisterSignal(source, COMSIG_ATOM_GET_EXAMINE_NAME)
	source.update_icon(UPDATE_OVERLAYS)

/datum/element/custom_skin/proc/get_examine_name(datum/source, mob/user, list/override)
	SIGNAL_HANDLER
	. = "<small class='his_grace'>[capitalize(source)]</small>"
	return COMPONENT_EXNAME_CHANGED

/datum/element/custom_skin/proc/apply_skin_overlay(atom/parent_atom, list/overlays)
	SIGNAL_HANDLER
	overlays |= skin_overlay

/obj/item/gun/proc/change_skin(datum/source, mob/user)
	if(ishuman(user) && (user?.ckey in GLOB.custom_skin_donators))
		var/list/possible_skins = GLOB.custom_skin_donators[user.ckey]
		var/list/choices = list()
		for(var/skin in possible_skins)
			choices[skin] = image(icon = 'white/valtos/icons/custom_guns.dmi', icon_state = "skin")
		var/choice = show_radial_menu(user, src, choices, tooltips = TRUE)
		if(!choice)
			return
		AddElement(/datum/element/custom_skin, skin_icon_state = choice)

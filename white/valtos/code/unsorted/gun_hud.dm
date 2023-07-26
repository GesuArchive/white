/datum/component/ammo_hud
	var/atom/movable/screen/ammo_counter/hud

/datum/component/ammo_hud/Initialize(mapload)
	. = ..()
	if(!istype(parent, /obj/item/gun) && !istype(parent, /obj/item/weldingtool))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(wake_up))

/datum/component/ammo_hud/Destroy()
	turn_off()
	return ..()

/datum/component/ammo_hud/proc/wake_up(datum/source, mob/user, slot)
	SIGNAL_HANDLER

	RegisterSignals(parent, list(COMSIG_PARENT_PREQDELETED, COMSIG_ITEM_DROPPED), PROC_REF(turn_off), override = TRUE)

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.is_holding(parent))
			if(H.hud_used)
				hud = H.hud_used.ammo_counter
				turn_on()
		else
			turn_off()

/datum/component/ammo_hud/proc/turn_on()
	SIGNAL_HANDLER

	RegisterSignal(parent, COMSIG_UPDATE_AMMO_HUD, PROC_REF(update_hud))

	hud.turn_on()
	update_hud()

/datum/component/ammo_hud/proc/turn_off()
	SIGNAL_HANDLER

	UnregisterSignal(parent, list(COMSIG_PARENT_PREQDELETED, COMSIG_ITEM_DROPPED, COMSIG_UPDATE_AMMO_HUD))

	if(hud)
		hud.turn_off()
		hud = null

/datum/component/ammo_hud/proc/update_hud()
	SIGNAL_HANDLER
	if(istype(parent, /obj/item/gun/ballistic))
		var/obj/item/gun/ballistic/pew = parent
		hud.maptext = null
		hud.icon_state = "backing"
		var/backing_color = COLOR_VERY_PALE_LIME_GREEN
		if(!pew.magazine)
			hud.set_hud(backing_color, "oe", "te", "he", "no_mag")
			return
		if(!pew.get_ammo())
			hud.set_hud(backing_color, "oe", "te", "he", "empty_flash")
			return

		var/indicator
		var/rounds = num2text(pew.get_ammo(TRUE))
		var/oth_o
		var/oth_t
		var/oth_h

		if(pew.semi_auto)
			indicator = "semi"
		else
			indicator = "burst"

		if(pew.GetComponent(/datum/component/jammed))
			indicator = "jam"

		switch(length(rounds))
			if(1)
				oth_o = "o[rounds[1]]"
			if(2)
				oth_o = "o[rounds[2]]"
				oth_t = "t[rounds[1]]"
			if(3)
				oth_o = "o[rounds[3]]"
				oth_t = "t[rounds[2]]"
				oth_h = "h[rounds[1]]"
			else
				oth_o = "o9"
				oth_t = "t9"
				oth_h = "h9"
		hud.set_hud(backing_color, oth_o, oth_t, oth_h, indicator)

	else if(istype(parent, /obj/item/gun/energy))
		var/obj/item/gun/energy/pew = parent
		hud.icon_state = "eammo_counter"
		hud.cut_overlays()
		hud.maptext_x = -12
		var/obj/item/ammo_casing/energy/shot = pew.ammo_type[pew.select]
		var/batt_percent = FLOOR(clamp(pew.cell.charge / pew.cell.maxcharge, 0, 1) * 100, 1)
		var/shot_cost_percent = FLOOR(clamp(shot.e_cost / pew.cell.maxcharge, 0, 1) * 100, 1)
		if(batt_percent > 99 || shot_cost_percent > 99)
			hud.maptext_x = -12
		else
			hud.maptext_x = -8
		if(!pew.can_shoot())
			hud.icon_state = "eammo_counter_empty"
			hud.maptext = span_maptext("<div align='center' valign='middle' style='position:relative'><font color='[COLOR_RED]'><b>[batt_percent]%</b></font><br><font color='[COLOR_VERY_PALE_LIME_GREEN]'>[shot_cost_percent]%</font></div>")
			return
		if(batt_percent <= 25)
			hud.maptext = span_maptext("<div align='center' valign='middle' style='position:relative'><font color='[COLOR_YELLOW]'><b>[batt_percent]%</b></font><br><font color='[COLOR_VERY_PALE_LIME_GREEN]'>[shot_cost_percent]%</font></div>")
			return
		hud.maptext = span_maptext("<div align='center' valign='middle' style='position:relative'><font color='[COLOR_VIBRANT_LIME]'><b>[batt_percent]%</b></font><br><font color='[COLOR_VERY_PALE_LIME_GREEN]'>[shot_cost_percent]%</font></div>")

	else if(istype(parent, /obj/item/weldingtool))
		var/obj/item/weldingtool/welder = parent
		hud.maptext = null
		var/backing_color = COLOR_THEME_GLASS
		hud.icon_state = "backing"

		if(welder.get_fuel() < 1)
			hud.set_hud(backing_color, "oe", "te", "he", "empty_flash")
			return

		var/indicator
		var/fuel = num2text(welder.get_fuel())
		var/oth_o
		var/oth_t
		var/oth_h

		if(welder.welding)
			indicator = "flame_on"
		else
			indicator = "flame_off"

		fuel = num2text(welder.get_fuel())

		switch(length(fuel))
			if(1)
				oth_o = "o[fuel[1]]"
			if(2)
				oth_o = "o[fuel[2]]"
				oth_t = "t[fuel[1]]"
			if(3)
				oth_o = "o[fuel[3]]"
				oth_t = "t[fuel[2]]"
				oth_h = "h[fuel[1]]"
			else
				oth_o = "o9"
				oth_t = "t9"
				oth_h = "h9"
		hud.set_hud(backing_color, oth_o, oth_t, oth_h, indicator)

/obj/item/gun/ballistic/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/ammo_hud)

/obj/item/gun/energy/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/ammo_hud)

/obj/item/weldingtool/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/ammo_hud)

/////////////////////////
//Customizable ammo hud//
/////////////////////////

/*
This hud is controlled namely by the ammo_hud component. Generally speaking this is inactive much like all other hud components until it's needed.
It does not do any calculations of it's own, you must do this externally.
If you wish to use this hud, use the ammo_hud component or create another one which interacts with it via the below procs.
proc/turn_off
proc/turn_on
proc/set_hud
Check the gun_hud.dmi for all available icons you can use.
*/

/atom/movable/screen/ammo_counter
	name = "счётчик"
	icon = 'icons/hud/gun_hud.dmi'
	icon_state = "backing"
	screen_loc = UI_AMMOCOUNTER
	invisibility = INVISIBILITY_ABSTRACT

	///This is the color assigned to the OTH backing, numbers and indicator.
	var/backing_color = COLOR_RED
	///This is the "backlight" of the numbers, and only the numbers. Generally you should leave this alone if you aren't making some mutant project.
	var/oth_backing = "oth_light"

	//Below are the OTH numbers, these are assigned by oX, tX and hX, x being the number you wish to display(0-9)
	///OTH position X00
	var/oth_o
	///OTH position 0X0
	var/oth_t
	///OTH position 00X
	var/oth_h
	///This is the custom indicator sprite that will appear in the box at the bottom of the ammo hud, use this for something like semi/auto toggle on a gun.
	var/indicator

///This proc simply resets the hud to standard and removes it from the players visible hud.
/atom/movable/screen/ammo_counter/proc/turn_off()
	invisibility = INVISIBILITY_ABSTRACT
	maptext = null
	backing_color = COLOR_RED
	oth_backing = ""
	oth_o = ""
	oth_t = ""
	oth_h = ""
	indicator = ""
	update_appearance()

///This proc turns the hud on, but does not set it to anything other than the currently set values
/atom/movable/screen/ammo_counter/proc/turn_on()
	invisibility = 0

///This is the main proc for altering the hud's appeareance, it controls the setting of the overlays. Use the OTH and below variables to set it accordingly.
/atom/movable/screen/ammo_counter/proc/set_hud(_backing_color, _oth_o, _oth_t, _oth_h, _indicator, _oth_backing = "oth_light")
	backing_color = _backing_color
	oth_backing = _oth_backing
	oth_o = _oth_o
	oth_t = _oth_t
	oth_h = _oth_h
	indicator = _indicator

	update_appearance()

/atom/movable/screen/ammo_counter/update_overlays()
	. = ..()
	if(oth_backing)
		var/mutable_appearance/oth_backing_overlay = mutable_appearance(icon, oth_backing)
		oth_backing_overlay.color = backing_color
		. += oth_backing_overlay
	if(oth_o)
		var/mutable_appearance/o_overlay = mutable_appearance(icon, oth_o)
		o_overlay.color = backing_color
		. += o_overlay
	if(oth_t)
		var/mutable_appearance/t_overlay = mutable_appearance(icon, oth_t)
		t_overlay.color = backing_color
		. += t_overlay
	if(oth_h)
		var/mutable_appearance/h_overlay = mutable_appearance(icon, oth_h)
		h_overlay.color = backing_color
		. += h_overlay
	if(indicator)
		var/mutable_appearance/indicator_overlay = mutable_appearance(icon, indicator)
		indicator_overlay.color = backing_color
		. += indicator_overlay


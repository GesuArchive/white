/// The light switch. Can have multiple per area.
/obj/machinery/light_switch
	name = "переключатель света"
	icon = 'white/valtos/icons/power.dmi'
	icon_state = "light0"
	base_icon_state = "light"
	desc = "Делает тьму или свет."
	power_channel = AREA_USAGE_LIGHT
	use_power = NO_POWER_USE
	/// Set this to a string, path, or area instance to control that area
	/// instead of the switch's location.
	var/area/area = null

/obj/machinery/light_switch/directional/north
	dir = SOUTH
	pixel_y = 26

/obj/machinery/light_switch/directional/south
	dir = NORTH
	pixel_y = -26

/obj/machinery/light_switch/directional/east
	dir = WEST
	pixel_x = 26

/obj/machinery/light_switch/directional/west
	dir = EAST
	pixel_x = -26

/obj/machinery/light_switch/Initialize(mapload)
	. = ..()
	if(istext(area))
		area = text2path(area)
	if(ispath(area))
		area = GLOB.areas_by_type[area]
	if(!area)
		area = get_area(src)

	if(!name)
		name = "переключатель света ([area.name])"

	if(area.lightswitch && !istype(area, /area/shuttle))
		area.lightswitch = FALSE
		area.power_change()

	update_icon()

/obj/machinery/light_switch/update_icon_state()
	. = ..()
	luminosity = 0
	if(machine_stat & NOPOWER)
		icon_state = "light-p"
	else
		luminosity = 1
		if(area.lightswitch)
			icon_state = "light1"
		else
			icon_state = "light0"

/obj/machinery/light_switch/update_overlays()
	. = ..()
	if(!(machine_stat & NOPOWER))
		. += mutable_appearance(icon, "[base_icon_state]-glow[area.lightswitch]", src)
		. += emissive_appearance(icon, "[base_icon_state]-glow[area.lightswitch]", src, alpha = src.alpha)

/obj/machinery/light_switch/examine(mob/user)
	. = ..()
	. += "<hr>Он [area.lightswitch ? "включен" : "выключен"]."

/obj/machinery/light_switch/interact(mob/user)
	. = ..()

	playsound(get_turf(src), 'white/valtos/sounds/switch_click.wav', 50, TRUE)

	area.lightswitch = !area.lightswitch
	area.update_icon()

	for(var/obj/machinery/light_switch/L in area)
		L.update_icon()

	area.power_change()

/obj/machinery/light_switch/power_change()
	SHOULD_CALL_PARENT(FALSE)
	if(area == get_area(src))
		return ..()

/obj/machinery/light_switch/emp_act(severity)
	. = ..()
	if (. & EMP_PROTECT_SELF)
		return
	if(!(machine_stat & (BROKEN|NOPOWER)))
		power_change()

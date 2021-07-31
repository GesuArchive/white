/datum/component/human_rocket
	var/datum/component/funny_movement/mymovement

/datum/component/human_rocket/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/human_rocket/RegisterWithParent()
	mymovement = parent.AddComponent(/datum/component/funny_movement)
	RegisterSignal(parent, COMSIG_MOB_CLICKON, .proc/on_click)

/datum/component/human_rocket/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_MOB_CLICKON)
	qdel(mymovement)

/datum/component/human_rocket/proc/on_click(mob/living/pilot, atom/A, params)
	SIGNAL_HANDLER

	var/list/modifiers = params2list(params)
	if(modifiers["ctrl"])
		mymovement.user_thrust_dir = 1
	else
		mymovement.user_thrust_dir = 0

	if(pilot?.client)
		var/list/sl_list = splittext(modifiers["screen-loc"],",")
		var/list/sl_x_list = splittext(sl_list[1], ":")
		var/list/sl_y_list = splittext(sl_list[2], ":")
		var/list/view_list = isnum(pilot.client.view) ? list("[pilot.client.view*2+1]","[pilot.client.view*2+1]") : splittext(pilot.client.view, "x")
		var/dx = text2num(sl_x_list[1]) + (text2num(sl_x_list[2]) / world.icon_size) - 1 - text2num(view_list[1]) / 2
		var/dy = text2num(sl_y_list[1]) + (text2num(sl_y_list[2]) / world.icon_size) - 1 - text2num(view_list[2]) / 2
		if(sqrt(dx*dx+dy*dy) > 1)
			mymovement.desired_angle = 90 - ATAN2(dx, dy)
		else
			mymovement.desired_angle = null





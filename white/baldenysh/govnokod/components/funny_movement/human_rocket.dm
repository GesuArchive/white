/datum/component/human_rocket
	var/datum/component/funny_movement/mymovement

/datum/component/human_rocket/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/human_rocket/RegisterWithParent()
	mymovement = parent.AddComponent(/datum/component/funny_movement)
	mymovement.maxthrust_forward = 3
	RegisterSignal(parent, COMSIG_MOB_CLICKON, .proc/on_click)

/datum/component/human_rocket/UnregisterFromParent()
	qdel(mymovement)
	UnregisterSignal(parent, COMSIG_MOB_CLICKON)

/datum/component/human_rocket/proc/on_click(mob/living/pilot, atom/A, params)
	SIGNAL_HANDLER
	if(!mymovement)
		qdel(src)
		return

	var/list/modifiers = params2list(params)
	if(modifiers["ctrl"])
		mymovement.desired_thrust_dir = 0
		mymovement.brakes = 1
	else
		mymovement.desired_thrust_dir = 1
		mymovement.brakes = 0

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

////////////////////////////////////////////////////// tank controls

/datum/component/human_rocket/tank_controls/RegisterWithParent()
	mymovement = parent.AddComponent(/datum/component/funny_movement)
	mymovement.maxthrust_forward = 3
	RegisterSignal(mymovement, COMSIG_FUNNY_MOVEMENT_PROCESSING_START, .proc/premove)
	RegisterSignal(mymovement, COMSIG_FUNNY_MOVEMENT_PROCESSING_FINISH, .proc/moved)

/datum/component/human_rocket/tank_controls/UnregisterFromParent()
	UnregisterSignal(mymovement, COMSIG_FUNNY_MOVEMENT_PROCESSING_START)
	UnregisterSignal(mymovement, COMSIG_FUNNY_MOVEMENT_PROCESSING_FINISH)
	var/mob/living/L = parent
	if(L.client)
		L.client.movement_locked = FALSE
	qdel(mymovement)

/datum/component/human_rocket/tank_controls
	var/rotation = 25

/datum/component/human_rocket/tank_controls/proc/premove()
	var/mob/living/L = parent
	var/movement_dir = NONE
	if(L.client)
		L.client.movement_locked = TRUE
		for(var/_key in L.client.keys_held)
			movement_dir = movement_dir | L.client.movement_keys[_key]
		if((movement_dir & NORTH) && (movement_dir & SOUTH))
			movement_dir &= ~(NORTH|SOUTH)
		if((movement_dir & EAST) && (movement_dir & WEST))
			movement_dir &= ~(EAST|WEST)

	if(movement_dir & NORTH)
		mymovement.desired_thrust_dir |= NORTH
	if(movement_dir & SOUTH)
		mymovement.desired_thrust_dir |= SOUTH
	if(movement_dir & WEST)
		mymovement.desired_angle -= rotation
	if(movement_dir & EAST)
		mymovement.desired_angle += rotation

/datum/component/human_rocket/tank_controls/proc/moved()
	mymovement.desired_thrust_dir = 0

////////////////////////////////////////////////////// smites

/datum/smite/human_rocket_click
	name = "Human Rocket (Point&Click)"

/datum/smite/human_rocket_click/effect(client/user, mob/living/target)
	. = ..()
	target.AddComponent(/datum/component/human_rocket)


/datum/smite/human_rocket_tank_controls
	name = "Human Rocket (Tank Controls)"

/datum/smite/human_rocket_tank_controls/effect(client/user, mob/living/target)
	. = ..()
	target.AddComponent(/datum/component/human_rocket/tank_controls)

/client/MouseMove(object, location, control, params)
	. = ..()
	if(mob)
		SEND_SIGNAL(mob, COMSIG_MOB_CLIENT_MOUSE_MOVE, object, location, control, params)

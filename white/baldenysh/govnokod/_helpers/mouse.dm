/client/MouseEntered(object, location, control, params)
	. = ..()
	if(mob)
		SEND_SIGNAL(mob, COMSIG_MOB_CLIENT_MOUSE_ENTERED, object, location, control, params)

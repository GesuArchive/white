#define CLIENT_MOB_SEND_MOUSE_ENTERED (1<<0)
#define CLIENT_MOB_SEND_MOUSE_MOVE (1<<1)

/mob
	var/client_mouse_signal_flags = 0

/client/MouseEntered(object, location, control, params)
	. = ..()
	if(mob && mob.client_mouse_signal_flags & CLIENT_MOB_SEND_MOUSE_ENTERED)
		SEND_SIGNAL(mob, COMSIG_MOB_CLIENT_MOUSE_ENTERED, object, location, control, params)

/client/MouseMove(object, location, control, params)
	. = ..()
	if(mob && mob.client_mouse_signal_flags & CLIENT_MOB_SEND_MOUSE_MOVE)
		SEND_SIGNAL(mob, COMSIG_MOB_CLIENT_MOUSE_MOVE, object, location, control, params)

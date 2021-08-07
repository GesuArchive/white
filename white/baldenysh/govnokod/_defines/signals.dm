
//mob signals
#define COMSIG_MOB_CLIENT_MOUSE_ENTERED "client_mob_mouse_entered"
#define COMSIG_MOB_CLIENT_MOUSE_MOVE "client_mob_mouse_move"

//funny movement signals

#define COMSIG_FUNNY_MOVEMENT_AVADJ "funny_movement_angular_velocity_adjustment"
	#define COMPONENT_FUNNY_MOVEMENT_BLOCK_AVADJ (1<<0)

#define COMSIG_FUNNY_MOVEMENT_DRAG "funny_movement_drag"
	#define COMPONENT_FUNNY_MOVEMENT_BLOCK_DRAG (1<<0)

#define COMSIG_FUNNY_MOVEMENT_THRUST "funny_movement_thrust"
	#define COMPONENT_FUNNY_MOVEMENT_BLOCK_THRUST (1<<0)

	#define COMSIG_FUNNY_MOVEMENT_ACCELERATION "funny_movement_acceleration"
		#define COMPONENT_FUNNY_MOVEMENT_BLOCK_ACCELERATION (1<<0)

#define COMSIG_FUNNY_MOVEMENT_PROCESSING_START "funny_movement_processing_start"
#define COMSIG_FUNNY_MOVEMENT_PROCESSING_FINISH "funny_movement_processing_finish"

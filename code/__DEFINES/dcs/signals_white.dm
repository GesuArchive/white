///from [/obj/item/extinguisher/proc/babah]:
#define COMSIG_EXTINGUISHER_BOOM "extinguisherboom"


//COMSIG_GUN_FIRED
	#define COMSIG_GUN_FIRED_CANCEL (1<<0)

/*
#define COMSIG_ATOM_UPDATE_ICON "atom_update_icon"
	#define COMSIG_ATOM_NO_UPDATE_ICON_STATE	(1<<0)
	#define COMSIG_ATOM_NO_UPDATE_OVERLAYS		(1<<1)
*/


/////////////////////////////////////////////////////////////////////////////////////////////////редфоks

// ---- MechComp signals - Content signals - Use these in your MechComp compatible devices ----

/// Add an input chanel for a device to send into
#define COMSIG_MECHCOMP_ADD_INPUT "mechcomp_add_input"
/// Connect two mechcomp devices together
#define COMSIG_MECHCOMP_ADD_CONFIG "mechcomp_add_config"
/// Connect two mechcomp devices together
#define COMSIG_MECHCOMP_ALLOW_MANUAL_SIGNAL "mechcomp_allow_manual_sigset"
/// Remove all connected devices
#define COMSIG_MECHCOMP_RM_ALL_CONNECTIONS "mechcomp_remove_all_connections"
/// Passing the signal of a message to all connected mechcomp devices for handling (message will be instatiated by the component)
#define COMSIG_MECHCOMP_TRANSMIT_SIGNAL "mechcomp_transmit_signal"
/// Passing a message to all connected mechcomp devices for handling
#define COMSIG_MECHCOMP_TRANSMIT_MSG "mechcomp_transmit_message"
/// Passing the stored message to all connected mechcomp devices for handling
#define COMSIG_MECHCOMP_TRANSMIT_DEFAULT_MSG "mechcomp_transmit_default_message"

// ---- MechComp signals - Internal signals - Do not use these ----

/// Receiving a message from a mechcomp device for handling
#define _COMSIG_MECHCOMP_RECEIVE_MSG "_mechcomp_receive_message"
/// Remove {the caller} from the list of transmitting devices
#define _COMSIG_MECHCOMP_RM_INCOMING "_mechcomp_remove_incoming"
/// Remove {the caller} from the list of receiving devices
#define _COMSIG_MECHCOMP_RM_OUTGOING "_mechcomp_remove_outgoing"
/// Return the component's outgoing connections
#define _COMSIG_MECHCOMP_GET_OUTGOING "_mechcomp_get_outgoing_connections"
/// Return the component's incoming connections
#define _COMSIG_MECHCOMP_GET_INCOMING "_mechcomp_get_incoming_connections"
/// Begin to connect two mechcomp devices together
#define _COMSIG_MECHCOMP_DROPCONNECT "_mechcomp_drop_connect"
/// Connect one MechComp compatible device as a receiver to a trigger. (This is meant to be a private method)
#define _COMSIG_MECHCOMP_LINK "_mechcomp_link_devices"
/// Returns 1
#define _COMSIG_MECHCOMP_COMPATIBLE "_mechcomp_check_compatibility"

// ---- MechComp Dispatch signals - Niche signals - You probably don't want to use these. ----
/// Add a filtered connection, getting user input on the filter
#define _COMSIG_MECHCOMP_DISPATCH_ADD_FILTER "_mechcomp_dispatch_add_filter"
/// Remove a filtered connection
#define _COMSIG_MECHCOMP_DISPATCH_RM_OUTGOING "_mechcomp_dispatch_remove_filter"
/// Test a signal to be sent to a connection
#define _COMSIG_MECHCOMP_DISPATCH_VALIDATE "_mechcomp_dispatch_run_filter"



/////////////////////////////////////////////////////////////////////////////////////////////////вырезанное или измененное тгшниками

//старые сигналы вайрмода??? разобраться и позже удалить
// Component signals
/// From /datum/port/output/set_output: (output_value)
#define COMSIG_PORT_SET_OUTPUT "port_set_output"
/// From /datum/port/input/set_input: (input_value)
#define COMSIG_PORT_SET_INPUT "port_set_input"
/// Sent on the output port when an input port registers on it: (datum/port/input/registered_port)
#define COMSIG_PORT_OUTPUT_CONNECT "port_output_connect"


// /datum/component/clockwork_trap signals
#define COMSIG_CLOCKWORK_SIGNAL_RECEIVED "clock_recieved"			//! When anything the trap is attatched to is triggered
//from base of atom/ratvar_act(): ()
#define COMSIG_ATOM_RATVAR_ACT "atom_ratvar_act"
//from base of atom/eminence_act(): ()
#define COMSIG_ATOM_EMINENCE_ACT "atom_eminence_act"

#define COMSIG_MOVABLE_CROSSED "movable_crossed" //оставил эту хуйню чисто чтоб щиткодоговно компилилось, выпилить везде где используеца и заменить коннект локом

//нахуй бы этих нанитов, говнокод лютого говна неэстетичный
//Nanites

///() returns TRUE if nanites are found
#define COMSIG_HAS_NANITES "has_nanites" //<------------ сука?
///() returns TRUE if nanites have stealth
#define COMSIG_NANITE_IS_STEALTHY "nanite_is_stealthy"
///() deletes the nanite component
#define COMSIG_NANITE_DELETE "nanite_delete"
///(list/nanite_programs) - makes the input list a copy the nanites' program list
#define COMSIG_NANITE_GET_PROGRAMS	"nanite_get_programs"
///(amount) Returns nanite amount
#define COMSIG_NANITE_GET_VOLUME "nanite_get_volume"
///(amount) Sets current nanite volume to the given amount
#define COMSIG_NANITE_SET_VOLUME "nanite_set_volume"
///(amount) Adjusts nanite volume by the given amount
#define COMSIG_NANITE_ADJUST_VOLUME "nanite_adjust"
///(amount) Sets maximum nanite volume to the given amount
#define COMSIG_NANITE_SET_MAX_VOLUME "nanite_set_max_volume"
///(amount(0-100)) Sets cloud ID to the given amount
#define COMSIG_NANITE_SET_CLOUD "nanite_set_cloud"
///(method) Modify cloud sync status. Method can be toggle, enable or disable
#define COMSIG_NANITE_SET_CLOUD_SYNC "nanite_set_cloud_sync"
///(amount) Sets safety threshold to the given amount
#define COMSIG_NANITE_SET_SAFETY "nanite_set_safety"
///(amount) Sets regeneration rate to the given amount
#define COMSIG_NANITE_SET_REGEN "nanite_set_regen"
///(code(1-9999)) Called when sending a nanite signal to a mob.
#define COMSIG_NANITE_SIGNAL "nanite_signal"
///(comm_code(1-9999), comm_message) Called when sending a nanite comm signal to a mob.
#define COMSIG_NANITE_COMM_SIGNAL "nanite_comm_signal"
///(mob/user, full_scan) - sends to chat a scan of the nanites to the user, returns TRUE if nanites are detected
#define COMSIG_NANITE_SCAN "nanite_scan"
///(list/data, scan_level) - adds nanite data to the given data list - made for ui_data procs
#define COMSIG_NANITE_UI_DATA "nanite_ui_data"
///(datum/nanite_program/new_program, datum/nanite_program/source_program) Called when adding a program to a nanite component
#define COMSIG_NANITE_ADD_PROGRAM "nanite_add_program"
	///Installation successful
	#define COMPONENT_PROGRAM_INSTALLED		(1<<0)
	///Installation failed, but there are still nanites
	#define COMPONENT_PROGRAM_NOT_INSTALLED	(1<<1)
///(datum/component/nanites, full_overwrite, copy_activation) Called to sync the target's nanites to a given nanite component
#define COMSIG_NANITE_SYNC "nanite_sync"

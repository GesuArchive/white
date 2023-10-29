//Компонент со всем функционалом mechcomp. В теории может цеплятся вообще на что угодно, не только на специальные компоненты типа /obj/item/mechcomp/...
//В основном тупая копипаста гунокода с попутным фиксом возникающих багов.
//Так же были выпилены какие-то датафайлы, поскольку их у нас нет (даже аналога), и используются они только стрёмными гуновскими фичами.


#define DC_ALL "Disconnect All"
#define SET_SEND "Set Send-Signal"
#define TOGGLE_MATCH "Toggle Exact Match"
#define MECHFAILSTRING "You must be holding a special linking tool to change connections or configuration."

#define MECHCORP_RADMENU_ICONFILE 'white/RedFoxIV/icons/mechcomp/connection.dmi'

#define _MECHCOMP_VALIDATE_RESPONSE_GOOD 0
#define _MECHCOMP_VALIDATE_RESPONSE_BAD 1
#define _MECHCOMP_VALIDATE_RESPONSE_HALT 2
#define _MECHCOMP_VALIDATE_RESPONSE_HALT_AFTER 3
#define COMSIG_MECHCOMP_ASSBLAST "mechcomp_assblast"



/*
/datum/signal_data
	var/data_type = "default"
	var/data = ""
*/


/datum/mechcompMessage
	///the main data stuff to pass around
	var/signal = "1"
	///i dunno lol
	var/list/nodes = list()
	///additional data stuff that is separate from signals
	var/data = null

/*
/datum/mechcompMessage/Initialize(mapload)
	. = ..()
	signal_data = new/datum/signal_data
*/


/datum/mechcompMessage/proc/addNode(var/atom/A)
	nodes.Add(A)

/datum/mechcompMessage/proc/getNode(var/atom/A)
	return (A in nodes)

/datum/mechcompMessage/proc/isTrue() //Thanks for having less iq than a household mouse , gooncoders..
	if(istext(signal)) // text passes as TRUE if it's not an empty string, just as in BYOND.
		if(signal != "")
			return TRUE
	else if (isnum(signal))
		if(signal) // so we don't return 4 instead of TRUE if signal is not 0
			return TRUE
	return FALSE

//????
/*
/datum/mechcompMessage/proc/isTrue() //Thanks for not having bools , byond.
	if(istext(signal))
		if(lowertext(signal) == "true" || lowertext(signal) == "1" || lowertext(signal) == "one") return 1
	else if (isnum(signal))
		if(signal == 1) return 1
	return 0
*/

//-----------------------------------------------------------------------------------------------------------------------------//
//DOCUMENTATION DOCUMENTATION DOCUMENTATION DOCUMENTATION DOCUMENTATION DOCUMENTATION DOCUMENTATION DOCUMENTATION DOCUMENTATION//
//DOCUMENTATION DOCUMENTATION DOCUMENTATION DOCUMENTATION DOCUMENTATION DOCUMENTATION DOCUMENTATION DOCUMENTATION DOCUMENTATION//
//DOCUMENTATION DOCUMENTATION DOCUMENTATION DOCUMENTATION DOCUMENTATION DOCUMENTATION DOCUMENTATION DOCUMENTATION DOCUMENTATION//
//-----------------------------------------------------------------------------------------------------------------------------//

/*
* Component for handling MechComp-signals
* Add this component to any object if you'd like it to send and or receive MechComp-messages (often called signals)
* There are are three "setup" COMSIGs you may want, and a few transmission COMSIGs.
*
*      ------  SETUP COMSIGS  ------
* COMSIG_MECHCOMP_ADD_INPUT, display_name, proc_name
*    Registers a custom input for your device. When connecting devices, the user can select "display_name" as an input.
*    Your device will need an associated proc/proc_name that handles receiving messages.
*    If your device is purely a sensor, it does not need any inputs.
*
* COMSIG_MECHCOMP_ADD_CONFIG, display_name, proc_name
*    Registers a custom configuration for your device. It is similar to  COMSIG_MECHCOMP_ADD_INPUT.
*
* COMSIG_MECHCOMP_ALLOW_MANUAL_SIGNAL
*    Adds the "Set Send-Signal" config-option to your device.
*    Use this with COMSIG_MECHCOMP_TRANSMIT_DEFAULT_MSG detailed below
*
* COMSIG_MECHCOMP_RM_ALL_CONNECTIONS
*    Removes all MechComp connections to and from the device.
*    This is the "Disconnect All" config-option, but you may want to call it after certain events,
*    such as unwelding a sensor-pipe in a loafer, or deconstructing a vending machine.
*    As a game-balance rule: devices should break connections when they move / are picked up.
*
*
*      ------  TRANSMISSION COMSIGS  ------
* A note on MechComp messages:
//Please try to always re-use incoming signals for your outgoing signals.
//Just modify the message of the incoming signal and send it along.
//This is important because each message keeps track of which nodes it traveled trough.
//It's through that list that we can prevent infinite loops. Or at least try to.
//(People can probably still create infinite loops somehow. They always manage)
*
* COMSIG_MECHCOMP_TRANSMIT_SIGNAL, signal_data, file
*    Creates a new message containing the signal_data and optional file. Fires this message to all connected outputs.
*    Use this for sensors and other devices that can create messages without having received one.
*
* COMSIG_MECHCOMP_TRANSMIT_DEFAULT_MSG, reusable_msg
*    Transmits the stored signal from COMSIG_MECHCOMP_ALLOW_MANUAL_SIGNAL.
*    If a reusable_msg is passed in, it will be reused, otherwise a fresh message will be created.
*
* COMSIG_MECHCOMP_TRANSMIT_MSG, msg
*    Transmits the msg to all connected outputs. Does not modify the signal of msg.
*/

/datum/component/mechanics_holder
	var/list/connected_outgoing
	var/list/connected_incoming
	var/list/inputs
	var/list/configs

	var/defaultSignal = "1"

	var/last_edited_configs_by = list("user" = null, "action" = null)
	var/last_edited_inputs_by = list("user" = null, "action" = null)


/datum/component/mechanics_holder/Initialize(can_manually_set_signal = 0)
	src.connected_outgoing = list()
	src.connected_incoming = list()
	src.inputs = list()
	src.configs = list()

	src.configs.Add(list(DC_ALL))
	if(can_manually_set_signal)
		allowManualSingalSetting()
	..()

/datum/component/mechanics_holder/RegisterWithParent()
	//все эти ебучие сигналы почему-то были в виде LIST(COMSIG_SIGNAL_BLA_BLA_BLA) и я не ебу, почему.
	RegisterSignal(parent, COMSIG_MECHCOMP_ADD_INPUT, PROC_REF(addInput))
	RegisterSignal(parent, _COMSIG_MECHCOMP_RECEIVE_MSG, PROC_REF(fireInput))
	RegisterSignal(parent, COMSIG_MECHCOMP_TRANSMIT_SIGNAL, PROC_REF(fireOutSignal))
	RegisterSignal(parent, COMSIG_MECHCOMP_TRANSMIT_MSG, PROC_REF(fireOutgoing))
	RegisterSignal(parent, COMSIG_MECHCOMP_TRANSMIT_DEFAULT_MSG, PROC_REF(fireDefault)) //Only use this when also using COMSIG_MECHCOMP_ALLOW_MANUAL_SIGNAL
	RegisterSignal(parent, _COMSIG_MECHCOMP_RM_INCOMING, PROC_REF(removeIncoming))
	RegisterSignal(parent, _COMSIG_MECHCOMP_RM_OUTGOING, PROC_REF(removeOutgoing))
	RegisterSignal(parent, COMSIG_MECHCOMP_RM_ALL_CONNECTIONS, PROC_REF(WipeConnections))
	RegisterSignal(parent, _COMSIG_MECHCOMP_GET_OUTGOING, PROC_REF(getOutgoing))
	RegisterSignal(parent, _COMSIG_MECHCOMP_GET_INCOMING, PROC_REF(getIncoming))

	//zloebuchiy kostil
	RegisterSignal(parent, COMSIG_MOUSEDROP_ONTO, PROC_REF(dropm))
	RegisterSignal(parent, _COMSIG_MECHCOMP_DROPCONNECT, PROC_REF(dropConnect))
	RegisterSignal(parent, _COMSIG_MECHCOMP_LINK, PROC_REF(link_devices))
	RegisterSignal(parent, COMSIG_MECHCOMP_ADD_CONFIG, PROC_REF(addConfig))
	RegisterSignal(parent, COMSIG_MECHCOMP_ALLOW_MANUAL_SIGNAL, PROC_REF(allowManualSingalSetting)) //Only use this when also using COMSIG_MECHCOMP_TRANSMIT_DEFAULT_MSG

	RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, PROC_REF(attackby))
	RegisterSignal(parent, _COMSIG_MECHCOMP_COMPATIBLE, PROC_REF(compatible))//Better that checking GetComponent()?

	RegisterSignal(parent, COMSIG_MECHCOMP_ASSBLAST, PROC_REF(assblast))

	return  //No need to ..()

/datum/component/mechanics_holder/UnregisterFromParent()
	var/list/signals = list(\
	COMSIG_MECHCOMP_ADD_INPUT,\
	_COMSIG_MECHCOMP_RECEIVE_MSG,\
	COMSIG_MECHCOMP_TRANSMIT_SIGNAL,\
	COMSIG_MECHCOMP_TRANSMIT_MSG,\
	COMSIG_MECHCOMP_TRANSMIT_DEFAULT_MSG,\
	_COMSIG_MECHCOMP_RM_INCOMING,\
	_COMSIG_MECHCOMP_RM_OUTGOING,\
	COMSIG_MECHCOMP_RM_ALL_CONNECTIONS,\
	_COMSIG_MECHCOMP_GET_OUTGOING,\
	_COMSIG_MECHCOMP_GET_INCOMING,\
	_COMSIG_MECHCOMP_DROPCONNECT,\
	_COMSIG_MECHCOMP_LINK,\
	COMSIG_MECHCOMP_ADD_CONFIG,\
	COMSIG_MECHCOMP_ALLOW_MANUAL_SIGNAL,\
	COMSIG_PARENT_ATTACKBY)
	UnregisterSignal(parent, signals)
	WipeConnections()
	src.configs.Cut()
	src.inputs.Cut()
	return  //No need to ..()

//Delete all connections. (Often caused by DC_ALL user command, and unwrenching MechComp devices.)
/datum/component/mechanics_holder/proc/WipeConnections()
	SIGNAL_HANDLER

	for(var/atom/A in src.connected_incoming)
		SEND_SIGNAL(A, _COMSIG_MECHCOMP_RM_OUTGOING, parent)
	for(var/atom/A in src.connected_outgoing)
		SEND_SIGNAL(A, _COMSIG_MECHCOMP_RM_INCOMING, parent)
	src.connected_incoming.Cut()
	src.connected_outgoing.Cut()
	return

//Remove a device from our list of transitting devices.
/datum/component/mechanics_holder/proc/removeIncoming(var/comsig_target, var/atom/A)
	SIGNAL_HANDLER

	src.connected_incoming.Remove(A)
	return

//Remove a device from our list of receiving devices.
/datum/component/mechanics_holder/proc/removeOutgoing(var/comsig_target, var/atom/A)
	SIGNAL_HANDLER

	src.connected_outgoing.Remove(A)
	SEND_SIGNAL(parent,_COMSIG_MECHCOMP_DISPATCH_RM_OUTGOING, A)
	return

//Give the caller a copied list of our outgoing connections.
/datum/component/mechanics_holder/proc/getOutgoing(var/comsig_target, var/list/outout)
	SIGNAL_HANDLER

	outout[1] = src.connected_outgoing
	return

//Give the caller a copied list of our incoming connections.
/datum/component/mechanics_holder/proc/getIncoming(var/comsig_target, var/list/outin)
	SIGNAL_HANDLER

	outin[1] = src.connected_incoming
	return

//Fire the stored default signal.
/datum/component/mechanics_holder/proc/fireDefault(var/comsig_target, var/datum/mechcompMessage/msg = null)
	SIGNAL_HANDLER

	if(isnull(msg))
		msg = newSignal(defaultSignal, null)
	else
		msg.signal = defaultSignal
	fireOutgoing(null, msg)
	return

//Fire a message with a simple signal (no file). Expected to be called from signal "sources" (first nodes)
/datum/component/mechanics_holder/proc/fireOutSignal(var/comsig_target, var/signal, var/data = null)
	SIGNAL_HANDLER

	fireOutgoing(null, newSignal(signal, data))
	return

//Adds an input "slot" to the holder w/ a proc mapping.
/datum/component/mechanics_holder/proc/addInput(var/comsig_target, var/name, var/toCall)
	SIGNAL_HANDLER

	if(name in src.inputs) src.inputs.Remove(name)
	src.inputs.Add(name)
	src.inputs[name] = toCall
	return

//Fire given input by names with the message as argument.
/datum/component/mechanics_holder/proc/fireInput(var/comsig_target, var/name, var/datum/mechcompMessage/msg)
	SIGNAL_HANDLER

	if(!(name in src.inputs))
		return
	var/path = src.inputs[name]
	//original line:
	//SPAWN_DBG(1 DECI SECOND) call(parent, path)(msg)
	spawn(1)
		call(parent, path)(msg)
	return

//Fire an outgoing connection with given value. Try to re-use incoming messages for outgoing signals whenever possible!
//This reduces load AND preserves the node list which prevents infinite loops.
/datum/component/mechanics_holder/proc/fireOutgoing(var/comsig_target, var/datum/mechcompMessage/msg)
	SIGNAL_HANDLER

	//If we're already in the node list we will not send the signal on.
	if(msg.getNode(parent))
		return 0
	msg.addNode(parent)


	//Cannot fire a message if unanchored. It's a subject to change.
	if(ismovable(parent))
		var/atom/movable/AMparent = parent
		if (!AMparent.anchored)
			return

	var/fired = 0
	for(var/atom/A in src.connected_outgoing)
		//Note: a target not handling a signal returns 0.
		var/validated = SEND_SIGNAL(parent,_COMSIG_MECHCOMP_DISPATCH_VALIDATE, A, msg.signal)
		if(validated == _MECHCOMP_VALIDATE_RESPONSE_HALT) //The component wants signal processing to stop NOW
			return fired
		if(validated == _MECHCOMP_VALIDATE_RESPONSE_BAD) //The component wants this signal to be skipped
			continue
		SEND_SIGNAL(A, _COMSIG_MECHCOMP_RECEIVE_MSG, src.connected_outgoing[A], cloneMessage(msg))
		fired = 1
		if(validated == _MECHCOMP_VALIDATE_RESPONSE_HALT_AFTER) //The component wants signal processing to stop AFTER this signal
			return fired
	return fired

//упс, я выпиливаю датафайлы нахуй потому что они никому нахуй не нужны. Too bad!
//Used to copy a message because we don't want to pass a single message to multiple components which might end up modifying it both at the same time.
/datum/component/mechanics_holder/proc/cloneMessage(var/datum/mechcompMessage/msg)
	SIGNAL_HANDLER

	var/datum/mechcompMessage/msg2
	msg2 = newSignal(msg.signal, msg.data)
	msg2.nodes = msg.nodes.Copy()
	return msg2

//ALWAYS use this to create new messages!!!
/datum/component/mechanics_holder/proc/newSignal(var/sig, var/_data=null)
	SIGNAL_HANDLER

	var/datum/mechcompMessage/ret = new/datum/mechcompMessage
	ret.signal = sig
	ret.data = _data
	return ret

/datum/component/mechanics_holder/proc/dropm(var/comsig_target, obj/over, mob/user)
	SEND_SIGNAL(over, _COMSIG_MECHCOMP_DROPCONNECT, parent, user)

//Called when a component is dragged onto another one.
// /datum/component/mechanics_holder/proc/dropConnect(atom/comsig_target, atom/A, mob/user)

/datum/component/mechanics_holder/proc/dropConnect(var/comsig_target, obj/over, mob/user)
	//SIGNAL_HANDLER_DOES_SLEEP

	if(!over || over == parent || user.stat || !isliving(user) || (SEND_SIGNAL(over,_COMSIG_MECHCOMP_COMPATIBLE) != 1))  //ZeWaka: Fix for null.mechanics
		return

	//сука?
	//if (!user.find_tool_in_hand(TOOL_PULSING))
	var/obj/item/I = user.held_items[user.active_hand_index]

	if (I?.tool_behaviour != TOOL_MECHCOMP)
		if(istype(parent, /obj/item/mechcomp)) //to avoid outputting error messages where their origin is not obvious.
			to_chat(user, span_alert("[MECHFAILSTRING]"))
		return

	//что-то про кабинеты для мехкомпа. нахуй.
	/*
	//Need to use comsig_target instead of parent, to access .loc
	if(A.loc != comsig_target.loc) //If these aren't sharing a container
		var/obj/item/storage/mechanics/cabinet = null
		if(istype(comsig_target.loc, /obj/item/storage/mechanics))
			cabinet = comsig_target.loc
		if(istype(A.loc, /obj/item/storage/mechanics))
			cabinet = A.loc
		if(cabinet)
			if(!cabinet.anchored)
				to_chat(user,span_alert("Cannot create connection through an unsecured component housing"))
				return
	*/

	if(get_dist(parent, over) > 15)
		to_chat(user, span_alert("Components need to be within a range of 14 meters to connect!"))
		return



	var/typecon = list("Trigger", "Receiver")
	typecon["Trigger"] = image(icon = MECHCORP_RADMENU_ICONFILE, icon_state = "trigger")
	typecon["Receiver"] = image(icon = MECHCORP_RADMENU_ICONFILE, icon_state = "receiver")

	//typesel += list("Trigger") = image(icon = 'white/RedFoxIV/icons/mechcomp/connection.dmi', icon_state = "trigger")
	//typesel += list("Receiver") = image(icon = 'white/RedFoxIV/icons/mechcomp/connection.dmi', icon_state = "receiver")

	var/typesel = show_radial_menu(user, parent, typecon)



	//typesel = input(user, "Use [parent] as:", "Connection Type") in list("Trigger", "Receiver", "*CANCEL*")
	switch(typesel)
		if("Trigger")
			SEND_SIGNAL(over, _COMSIG_MECHCOMP_LINK, parent, user)
		if("Receiver")
			link_devices(null, over, user) //What do you want, an invitation? No signal needed!
		if("*CANCEL*")
			return
	return


//We are in the scope of the receiver-component, our argument is the trigger
//This feels weird/backwards, but it results in fewer SEND_SIGNALS & var/lists
/datum/component/mechanics_holder/proc/link_devices(var/comsig_target, atom/trigger, mob/user)
	//SIGNAL_HANDLER_DOES_SLEEP

	var/atom/receiver = parent
	if(trigger in src.connected_outgoing)
		to_chat(user, span_alert("Can not create a direct loop between 2 components."))
		return
	if(!src.inputs.len)
		to_chat(user, span_alert("[receiver.name] has no input slots. Can not connect [trigger.name] as Trigger."))
		return

	var/pointer_container[1] //A list of size 1, to store the address of the list we want
	SEND_SIGNAL(trigger, _COMSIG_MECHCOMP_GET_OUTGOING, pointer_container)
	var/list/trg_outgoing = pointer_container[1]

	var/list/choices = list()
	for(var/i in inputs)
		var/image/img = image(icon = MECHCORP_RADMENU_ICONFILE, icon_state = "io")
		img.maptext_width = 64
		img.maptext_x = -16
		img.maptext = "<text align=center valign=bottom>[MAPTEXT("[i]")]"
		choices.Add("[i]")
		choices["[i]"] = img
	var/selected_input = show_radial_menu(user, parent, choices, tooltips = TRUE, radius = 48)
	//var/selected_input = input(user, "Select \"[receiver.name]\" Input", "Input Selection") in inputs + "*CANCEL*"
	if(!selected_input)
		to_chat(user,span_notice("You decide against connecting [trigger.name] and [receiver.name]."))
		return

	trg_outgoing |= receiver //Let's not allow making many of the same connection.
	trg_outgoing[receiver] = selected_input
	src.connected_incoming |= trigger //Let's not allow making many of the same connection.
	last_edited_inputs_by["user"] = user
	last_edited_inputs_by["action"] = "connected [trigger.name] to [receiver.name] ([selected_input])"
	to_chat(user, span_success("You connect the [trigger.name] to the [receiver.name]."))
	//logTheThing("station", user, null, "connects a <b>[trigger.name]</b> to a <b>[receiver.name]</b>.")
	SEND_SIGNAL(trigger,_COMSIG_MECHCOMP_DISPATCH_ADD_FILTER, receiver, user)
	return

//Adds a config to the holder w/ a proc mapping.
/datum/component/mechanics_holder/proc/addConfig(var/comsig_target, var/name, var/toCall)
	SIGNAL_HANDLER

	if(name in src.configs) src.configs.Remove(name)
	src.configs.Add(name)
	src.configs[name] = toCall
	return

/datum/component/mechanics_holder/proc/allowManualSingalSetting()
	SIGNAL_HANDLER

	if(!(list(SET_SEND) in src.configs))
		src.configs.Add(list(SET_SEND))
	return

//If it's a multi-tool, let the user configure the device.
/datum/component/mechanics_holder/proc/attackby(var/comsig_target, obj/item/W /*as obj*/ /*НАХУЯ???*/, mob/user)
	//SIGNAL_HANDLER_DOES_SLEEP

	if(W.tool_behaviour != TOOL_MECHCOMP || !isliving(user) || user.stat)
		return FALSE

	if(length(src.configs))
		var/list/choices = list()
		for(var/i in src.configs)
			var/image/img
			switch(i)
				if(SET_SEND)
					img = image(icon = 'white/RedFoxIV/icons/mechcomp/connection.dmi', icon_state = "signal")
				if(DC_ALL)
					img = image(icon = 'white/RedFoxIV/icons/mechcomp/connection.dmi', icon_state = "disconnect")
				else
					img = image(icon = 'white/RedFoxIV/icons/mechcomp/connection.dmi', icon_state = "config")
			img.maptext_width = 64
			img.maptext_x = -16
			img.maptext = "<text align=center valign=bottom>[MAPTEXT("[i]")]"
			choices.Add("[i]")
			choices["[i]"] = img
		var/selected_config = show_radial_menu(user, parent, choices, tooltips = TRUE, require_near = TRUE, radius = 48)
		if(selected_config && in_range(parent, user))
			switch(selected_config)
				if(SET_SEND)
					var/inp = tgui_input_text(user,"Please enter Signal:","Signal setting", "[defaultSignal]")

					if(!in_range(parent, user) || user.stat)
						return

					inp = trim(strip_html(inp))
					if(length(inp))
						last_edited_configs_by["user"] = user
						last_edited_configs_by["action"] = "changed default signal from [defaultSignal] to [inp]"
						defaultSignal = inp
						to_chat(user, "Signal set to [inp]")
				if(DC_ALL)
					WipeConnections()
					if(istype(parent, /atom))
						var/atom/AP = parent
						last_edited_inputs_by["user"] = user
						last_edited_inputs_by["action"] = "wiped all connections"
						to_chat(user, span_notice("You disconnect [AP.name]."))
				else
					//must be a custom config specific to the device, so let the device handle it
					var/path = src.configs[selected_config]
					call(parent, path)(W, user)
					last_edited_configs_by["user"] = user
					last_edited_configs_by["action"] = "called config \"[selected_config]\""
//If it's a multi-tool, let the user configure the device.
/datum/component/mechanics_holder/proc/compatible()
	SIGNAL_HANDLER

	return 1

/datum/component/mechanics_holder/proc/assblast(obj/over, mob/user)
	qdel(parent)

#undef DC_ALL
#undef SET_SEND
#undef TOGGLE_MATCH

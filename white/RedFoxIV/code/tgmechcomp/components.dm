/*
/obj/item/mechcomp/debugspawn
/obj/item/mechcomp/debugspawn/Initialize(mapload)
	. = ..()
	for(var/i in typesof(/obj/item/mechcomp))
		if(istype(i, /obj/item/mechcomp/debugspawn) || istype(i, /obj/item/mechcomp))
			continue
		new i(src.loc)
	qdel(src)
*/


//copypaste of a goon component, thankfully it somehow just works.
//Still probably should be at least reviewed.
/obj/item/mechcomp/math
	name = "Arithmetic Component"
	desc = "Do number things! Component list<br>\
	rng: Generates a random number from A to B<br>\
	add: Adds A + B<br>\
	sub: Subtracts A - B<br>\
	mul: Multiplies A * B<br>\
	div: Divides A / B<br>\
	pow: Power of A ^ B<br>\
	mod: Modulos A % B<br>\
	sin, cos, tg, ctg, sec, cosec - All trigonometric functions use A for degrees. B is unused.<br>\
	eq, neq, gt, lt, gte, lte - Equal, NotEqual, GreaterThan, LessThan, GreaterEqual, LessEqual - will output 1 if true. Example: \"A GT B\" is basically \"1 if A is larger than B\""
	icon_state = "comp_arith"
	part_icon_state = "comp_arith"
	has_anchored_icon_state = TRUE
	var/A = 1
	var/B = 1

	var/mode = "add"

/obj/item/mechcomp/math/examine(mob/user)
		. = ..() // Please don't remove this again, thanks. //i have no fucking idea why gooncoders would do this lol
		. += "<br><span class='notice'>Current Mode: [mode] | A = [A] | B = [B]</span>"

/obj/item/mechcomp/math/Initialize(mapload)
		. = ..()

		SEND_SIGNAL(src,COMSIG_MECHCOMP_ADD_INPUT,"Set A", "setA")
		SEND_SIGNAL(src,COMSIG_MECHCOMP_ADD_INPUT,"Set B", "setB")
		SEND_SIGNAL(src,COMSIG_MECHCOMP_ADD_INPUT,"Evaluate", "evaluate")
		SEND_SIGNAL(src,COMSIG_MECHCOMP_ADD_CONFIG,"Set A Manually","setAManually")
		SEND_SIGNAL(src,COMSIG_MECHCOMP_ADD_CONFIG,"Set B Manually","setBManually")
		SEND_SIGNAL(src,COMSIG_MECHCOMP_ADD_CONFIG,"Set Mode","setMode")

/obj/item/mechcomp/math/proc/setAManually(obj/item/W as obj, mob/user as mob)
	var/input = input("Set A to what?", "A", A) as num
	if(!in_range(src, user) || user.stat || isnull(input))
		return 0
	A = input
	//tooltip_rebuild = 1 //something goon tooltip related. dunno.
	return 1

/obj/item/mechcomp/math/proc/setBManually(obj/item/W as obj, mob/user as mob)
	var/input = input("Set B to what?", "B", B) as num
	if(!in_range(src, user) || user.stat || isnull(input))
		return 0
	B = input
	//tooltip_rebuild = 1
	return 1

/obj/item/mechcomp/math/proc/setMode(obj/item/W as obj, mob/user as mob)
	mode = tgui_input_list(usr, "Set the math mode to what?", "Mode Selector", list("add","mul","div","sub","mod","pow","rng","eq","neq","gt","lt","gte","lte","sin","cos","tg","ctg","sec","cosec"), mode)
	//tooltip_rebuild = 1
	return 1

/obj/item/mechcomp/math/proc/setA(var/datum/mechcompMessage/input)
	if (!isnull(text2num(input.signal)))
		A = text2num(input.signal)
		//tooltip_rebuild = 1

/obj/item/mechcomp/math/proc/setB(var/datum/mechcompMessage/input)
	if (!isnull(text2num(input.signal)))
		B = text2num(input.signal)
		//tooltip_rebuild = 1

/obj/item/mechcomp/math/proc/evaluate()
	switch(mode) //what the fuck
		if("add")
			. = A + B
		if("sub")
			. = A - B
		if("div")
			if (B == 0)
				src.visible_message("<span class='game say'><span class='name'>[src]</span> beeps, \"Attempted division by zero!\"</span>")
				return
			. = A / B
		if("mul")
			. = A * B
		if("mod")
			. = A % B
		if("pow")
			. = A ** B
		if("rng")
			. = rand(A, B)
		if("gt")
			. = A > B
		if("lt")
			. = A < B
		if("gte")
			. = A >= B
		if("lte")
			. = A <= B
		if("eq")
			. = A == B
		if("neq")
			. = A != B
		if("sin")
			. = (sin(A))
		if("cos")
			. = (cos(A))
		if("tg")
			. = (tan(A))
		if("ctg")
			. = 1/(tan(A))
		if("sec")
			. = 1/(cos(A))
		if("cosec")
			. = 1/(sin(A))

		else
			return
	if(. == .) //wtf???
		SEND_SIGNAL(src,COMSIG_MECHCOMP_TRANSMIT_SIGNAL,"[.]")





//should be replaced by a proper led with actual light and stuff, not just a stub with 2 sprites for true/false input.
/*
/obj/item/mechcomp/test_led
	name = "Test LED"
	desc = "Lights up if anything other than zero or an empty string is passed."
	part_icon_state = "comp_led"
	has_anchored_icon_state = TRUE

/obj/item/mechcomp/test_led/Initialize(mapload)
		. = ..()

		SEND_SIGNAL(src,COMSIG_MECHCOMP_ADD_INPUT,"Activate", "activateproc")

/obj/item/mechcomp/test_led/proc/activateproc(var/datum/mechcompMessage/msg)
	if(msg.isTrue())
		update_icon_state("comp_led_on")
	else
		update_icon_state("comp_led")
*/





/obj/item/mechcomp/button
	name = "mechcomp Button"
	desc = "What does it do? Only one way to find out!"
	icon_state = "comp_button"
	part_icon_state = "comp_button"
	active_icon_state = "comp_button1"

/obj/item/mechcomp/button/Initialize(mapload)
	. = ..()
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ALLOW_MANUAL_SIGNAL)

/obj/item/mechcomp/button/interact_by_hand(mob/user)
	if(active)
		return
	activate_for(1 SECONDS)
	SEND_SIGNAL(src, COMSIG_MECHCOMP_TRANSMIT_DEFAULT_MSG)
	log_action("pressed by [user.ckey ? "[user.ckey]" : "[user.name] without a ckey. Check more logs, this should not happen"].")

/obj/item/mechcomp/speaker
	name = "mechcomp speaker"
	desc = "Speaks whatever it is told to speak."
	icon_state = "comp_synth"
	part_icon_state = "comp_synth"
	active_icon_state = "comp_synth1"
	var/cd = 3 SECONDS

/obj/item/mechcomp/speaker/Initialize(mapload)
	. = ..()
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_INPUT, "speak", "activateproc")

/obj/item/mechcomp/speaker/proc/activateproc(var/datum/mechcompMessage/msg)
	if(active)
		return
	if(isnull(msg.signal))
		return
	activate_for(cd)
	say(msg.signal)
	log_action("said [msg.signal]")
/obj/item/mechcomp/speaker/debug
	name = "Special Ops Speaker"
	cd = 0
/obj/item/mechcomp/textpad
	name = "mechcomp textpad"
	desc = "Text goes here. Strangely similiar to a numpad, while also being better than a numpad."
	icon_state = "comp_buttpanel"
	part_icon_state = "comp_buttpanel"
	active_icon_state = "comp_buttpanel1"

/obj/item/mechcomp/textpad/interact_by_hand()
	var/inp = tgui_input_text(usr, "What text would you like to input?", "Oh, the possibilities!", null)
	if(isnull(inp))
		return

	SEND_SIGNAL(src,COMSIG_MECHCOMP_TRANSMIT_SIGNAL,"[inp]")
	flick(active_icon_state, src)
	log_action("inputted \"[inp]\".")



/obj/item/mechcomp/pressurepad
	name = "mechcomp pressure pad"
	desc = "Senses people walking over it."
	icon_state = "comp_pressure"
	part_icon_state = "comp_pressure"
	has_anchored_icon_state = TRUE
	var/sensitive = FALSE

/obj/item/mechcomp/pressurepad/Initialize(mapload)
	. = ..()
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ALLOW_MANUAL_SIGNAL)
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_CONFIG, "Fine tuning", "finetune")

	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(pad_triggered),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/item/mechcomp/pressurepad/proc/pad_triggered(datum/self, atom/movable/AM)
	SIGNAL_HANDLER
	if(anchored)
		if( sensitive || isliving(AM))
			SEND_SIGNAL(src, COMSIG_MECHCOMP_TRANSMIT_DEFAULT_MSG)
			if(isliving(AM))
				var/mob/living/L = AM
				log_action("triggered by [L.ckey] as [L.name]")
			else
				log_action("triggered by [AM.name], last touched by [AM.fingerprintslast]")

/obj/item/mechcomp/pressurepad/proc/finetune(obj/item/W, mob/user)
	sensitive = !sensitive
	if(sensitive)
		to_chat(user, span_alert("You tune the [src.name] to be more sensitive, allowing it to sense not just living creatures, but objects passing by."))
	else
		to_chat(user, span_alert("You tune the [src.name] to be less sensitive, so it can only sense creatures passing by."))

/obj/item/mechcomp/delay
	name = "mechcomp timer"
	desc = "Relays signals with a configurable delay from 0.1 to 10 seconds."
	icon_state = "comp_wait"
	part_icon_state = "comp_wait"
	active_icon_state = "comp_wait1"
	has_anchored_icon_state = TRUE
	var/delay = 10

/obj/item/mechcomp/delay/examine(mob/user)
	. = ..()
	. += "It is currently set to delay incoming messages by [delay/10] seconds."


/obj/item/mechcomp/delay/Initialize(mapload)
	. = ..()
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_CONFIG, "Set Delay" , "setdelaymanually")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_INPUT, "Incoming", "incoming")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_INPUT, "Delay", "setdelay")

/obj/item/mechcomp/delay/proc/setdelaymanually(obj/item/W, mob/user)
	var/input = input("Enter new time in deciseconds Current delay is [delay/10]s.", "Delay", null) as num
	if(!in_range(src, user) || user.stat || isnull(input))
		to_chat(user, span_notice("You leave the delay on [src.name] alone."))
		return FALSE
	delay = clamp(input, 1, 100)
	to_chat(user, span_notice("You change the delay on [src.name] to [delay/10] seconds."))
	return TRUE


/obj/item/mechcomp/delay/proc/setdelay(var/datum/mechcompMessage/msg)
	var/t = text2num(msg.signal)
	if (!isnull(t) && t > 0 && t<100)
		delay = t



//This mechcomp component handles active flag by itself because it can have several different messages waiting to be sent,
//and active flag should not be set to FALSE untill all of the messages were sent.
//This is probably not good and stuff regarting active-inactive states should be rewritten to be more flexible.
/obj/item/mechcomp/delay/proc/incoming(var/datum/mechcompMessage/msg)
	addtimer(CALLBACK(src, PROC_REF(sendmessage), msg), delay, TIMER_STOPPABLE | TIMER_DELETE_ME)
	active = TRUE
	update_icon()



/obj/item/mechcomp/delay/proc/sendmessage(var/datum/mechcompMessage/msg)
	SEND_SIGNAL(src,COMSIG_MECHCOMP_TRANSMIT_MSG, msg)
	if(!_active_timers.len)
		_deactivate()

/obj/item/mechcomp/delay/unanchor()
	. = ..()
	remove_all_pending_messages()

/obj/item/mechcomp/delay/proc/remove_all_pending_messages()
	for(var/timer in _active_timers)
		deltimer(timer)


/obj/item/mechcomp/grav_accelerator
	name = "mechcomp graviton accelerator"
	desc = "The bread and butter of any self-respecting mechanic, able to launch anyone willing (and unwilling!) in a fixed direction."
	icon_state = "comp_accel"
	part_icon_state = "comp_accel"
	//active_icon_state = "comp_accel1"
	var/power = 3
	has_anchored_icon_state = TRUE
	only_one_per_tile = TRUE

/obj/item/mechcomp/grav_accelerator/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/simple_rotation, ROTATION_ALTCLICK | ROTATION_CLOCKWISE, CALLBACK(src, PROC_REF(can_user_rotate)),CALLBACK(src, PROC_REF(can_be_rotated)),null)

/obj/item/mechcomp/grav_accelerator/Initialize(mapload)
	. = ..()
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_INPUT, "Activate", "activateproc")
	//SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_INPUT, "Power", "setpower") //maybe later
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_CONFIG, "Set power Manually", "setpowermanually")

/obj/item/mechcomp/grav_accelerator/proc/can_be_rotated(mob/user)
	return !anchored

//stolen from chair code
/obj/item/mechcomp/grav_accelerator/proc/can_user_rotate(mob/user)
	var/mob/living/L = user

	if(istype(L))
		if(!user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE, !iscyborg(user)))
			return FALSE
		else
			return TRUE
	else if(isobserver(user) && CONFIG_GET(flag/ghost_interaction))
		return TRUE
	return FALSE
/obj/item/mechcomp/grav_accelerator/proc/activateproc(datum/mechcompMessage/msg)
	if(active)
		return
	var/thrown_AM = 0
	var/list/thrown_mobs = list()
	for(var/atom/movable/AM in range(0, src))
		if(isliving(AM) || istype(AM, /obj/item) || istype(AM, /obj/structure) || istype(AM, /obj/machinery))
			if(AM.anchored || AM == src)
				continue
			var/throwtarget = get_edge_target_turf(AM, src.dir)
			AM.safe_throw_at(throwtarget, power, 1, force = MOVE_FORCE_STRONG, spin = TRUE)
			if(isliving(AM))
				var/mob/living/L = AM
				thrown_mobs.Add("[L.ckey ? "[L.ckey] as " : ""][L.name]")
			thrown_AM++
	activate_for((power + 2) SECONDS)
	log_action("sent [thrown_AM] objects flying[thrown_mobs.len ? ", including following mobs: [jointext(thrown_mobs, ", ")]" : ""]")

/obj/item/mechcomp/grav_accelerator/proc/setpowermanually(obj/item/W, mob/user)
	var/input = input("Enter new power setting.", "Power", null) as num
	if(!in_range(src, user) || user.stat || isnull(input))
		to_chat(user, span_notice("You leave the power setting on [src.name] alone."))
		return FALSE

	power = clamp(round(input), 1, 7)
	to_chat(user, span_notice("You change the power setting on [src.name] to [power]."))
	return TRUE

/obj/item/mechcomp/grav_accelerator/update_overlays()
	. = ..()
	if(active)
		. += "accel_overlay_active"


/obj/item/mechcomp/egunholder
	name = "mechcomp energy gun fixture"
	desc = "Self-explanatory."
	icon_state = "comp_egun"
	part_icon_state = "comp_egun"
	only_one_per_tile = TRUE
	///from 0 to 360
	var/angle = 0
	var/obj/item/gun/energy/gun
	var/obj/machinery/recharger/recharger //lmfao


/obj/item/mechcomp/egunholder/Initialize(mapload)
	. = ..()
	recharger = new(src)
	recharger.recharge_coeff = 0.25 //4 times slower more inefficient than a regular weapon recharger
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_INPUT, "Fire!", "fire")
	//SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_CONFIG, "Angle", "rotate") //Would this make the gun component too OP? :thinking:

/obj/item/mechcomp/egunholder/Destroy()
	qdel(recharger)
	. = ..()

/obj/item/mechcomp/egunholder/proc/fire(var/datum/mechcompMessage/msg)
	if(isnull(gun))
		playsound(src, 'white/RedFoxIV/sounds/mechcomp/generic_energy_dryfire.ogg', 75, FALSE)
		activate_for(0.5 SECONDS)
		return

	var/obj/item/stock_parts/cell/gun_cell = gun.cell
	var/obj/item/ammo_casing/energy/casing = gun.ammo_type[gun.select]

	if(gun_cell.use(casing.e_cost))
		var/obj/projectile/proj = new casing.projectile_type(get_turf(src))
		proj.fire(angle, null)
		playsound(src, casing.fire_sound, 50, TRUE, -1)
		//probably should implement an override for flick() in obj/item/mechcomp
		//to handle different states correctly.
		flick("comp_egun_firing",src)
		activate_for(1 SECONDS)
		log_action("fired [initial(gun.name)] ([casing.projectile_type]) at [angle] degrees. Gun installed by [gun.fingerprintslast]")
	else
		playsound(src, gun.dry_fire_sound, 50, TRUE)


	activate_for(1 SECONDS)


/obj/item/mechcomp/egunholder/interact_by_item(obj/item/I, mob/user)
	. = ..()
	if(!istype(I,/obj/item/gun/energy) && istype(I,/obj/item/gun/))
		to_chat(user, span_notice("[src.name] accepts only energy-based weaponry!."))
		return

	if(istype(I,/obj/item/gun/energy))
		if(isnull(gun))
			user.transferItemToLoc(I,src)
			gun = I
			to_chat(user, span_notice("You slide [gun] into the [src.name]."))
			playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
			if(gun.can_charge)
				recharger.setCharging(gun)
			return
		else
			to_chat(user, span_notice("There's already a weapon installed in [src.name]!."))
			return

	if(I.tool_behaviour == TOOL_CROWBAR && !isnull(gun))
		gun.forceMove(drop_location())
		gun = null
		playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
		to_chat(user, span_notice("You pop [gun] out of the [src.name]."))
		recharger.setCharging(null)
		return

//recycled from reflector code
/obj/item/mechcomp/egunholder/proc/rotate(mob/user)
	var/new_angle = input(user, "Input a new angle for [src.name].", "[src.name]'s angle", angle) as null|num
	if(!user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE, !iscyborg(user)))
		return
	if(!isnull(new_angle))
		src.transform = matrix()
		src.transform = turn(src.transform, new_angle)
		angle = SIMPLIFY_DEGREES(new_angle)
	return TRUE

/obj/item/mechcomp/egunholder/proc/debugrotate(var/new_angle)
	if(new_angle>0 && new_angle < 360)
		src.transform = matrix()
		src.transform = turn(src.transform, new_angle)
		angle = SIMPLIFY_DEGREES(new_angle)
		addtimer(src, CALLBACK(src, PROC_REF(debugrotate), angle+1), 1)

/obj/item/mechcomp/egunholder/AltClick(mob/user)
	if(!user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE, !iscyborg(user)))
		return
	rotate(user)



/obj/item/mechcomp/list_packer
	name = "mechcomp List Packer"
	desc = "Packs a bunch of input data into compact list-like form. Will skip over null data inputs and will not output anything at all if all data inputs are null."
	icon_state = "comp_list_packer"
	part_icon_state = "comp_list_packer"
	//lol
	var/A
	var/B
	var/C
	var/D
	var/E
	var/F
	var/G
	var/H
	var/glue = "&"
/obj/item/mechcomp/list_packer/examine(mob/user)
	. = ..()
	//lolol
	if(in_range(src,user))
		. += "<br>It currently holds the following data:<br>"
		. += "A = [isnull(A) ? "<i><b>null</b></i>" : "[sanitize(A)]" ]<br>"
		. += "B = [isnull(B) ? "<i><b>null</b></i>" : "[sanitize(B)]" ]<br>"
		. += "C = [isnull(C) ? "<i><b>null</b></i>" : "[sanitize(C)]" ]<br>"
		. += "D = [isnull(D) ? "<i><b>null</b></i>" : "[sanitize(D)]" ]<br>"
		. += "E = [isnull(E) ? "<i><b>null</b></i>" : "[sanitize(E)]" ]<br>"
		. += "F = [isnull(F) ? "<i><b>null</b></i>" : "[sanitize(F)]" ]<br>"
		. += "G = [isnull(G) ? "<i><b>null</b></i>" : "[sanitize(G)]" ]<br>"
		. += "H = [isnull(H) ? "<i><b>null</b></i>" : "[sanitize(H)]" ]<br>"
	else
		. += "<i>You will have to get closer to get a better look at it's data inputs.</i>"


/obj/item/mechcomp/list_packer/Initialize(mapload)
	. = ..()
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_INPUT, "Build list", "build")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_INPUT, "Input A", "update_A")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_INPUT, "Input B", "update_B")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_INPUT, "Input C", "update_C")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_INPUT, "Input D", "update_D")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_INPUT, "Input E", "update_E")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_INPUT, "Input F", "update_F")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_INPUT, "Input G", "update_G")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_INPUT, "Input H", "update_H")

	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_CONFIG, "Set A", "set_A")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_CONFIG, "Set B", "set_B")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_CONFIG, "Set C", "set_C")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_CONFIG, "Set D", "set_D")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_CONFIG, "Set E", "set_E")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_CONFIG, "Set F", "set_F")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_CONFIG, "Set G", "set_G")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_CONFIG, "Set H", "set_H")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_CONFIG, "Set glue", "set_glue")



//lololol
/obj/item/mechcomp/list_packer/proc/update_A(var/datum/mechcompMessage/msg)
	A = msg.signal

/obj/item/mechcomp/list_packer/proc/update_B(var/datum/mechcompMessage/msg)
	B = msg.signal

/obj/item/mechcomp/list_packer/proc/update_C(var/datum/mechcompMessage/msg)
	C = msg.signal

/obj/item/mechcomp/list_packer/proc/update_D(var/datum/mechcompMessage/msg)
	D = msg.signal

/obj/item/mechcomp/list_packer/proc/update_E(var/datum/mechcompMessage/msg)
	E = msg.signal

/obj/item/mechcomp/list_packer/proc/update_F(var/datum/mechcompMessage/msg)
	F = msg.signal

/obj/item/mechcomp/list_packer/proc/update_G(var/datum/mechcompMessage/msg)
	G = msg.signal

/obj/item/mechcomp/list_packer/proc/update_H(var/datum/mechcompMessage/msg)
	H = msg.signal

/obj/item/mechcomp/list_packer/proc/prompt_update(var/varname, var/v)
	var/input = tgui_input_text(usr, "Set [varname] to what? Careful, empty input will erase what's currently stored in [varname]!", "[varname]", v)
	return input

//fucking kill me
/obj/item/mechcomp/list_packer/proc/set_A(obj/item/I, mob/user)
	var/p = prompt_update("A", A)
	if(in_range(src, user) && user.stat)
		A = p

/obj/item/mechcomp/list_packer/proc/set_B(obj/item/I, mob/user)
	var/p = prompt_update("B", B)
	if(in_range(src, user) && user.stat)
		B = p

/obj/item/mechcomp/list_packer/proc/set_C(obj/item/I, mob/user)
	var/p = prompt_update("C", C)
	if(in_range(src, user) && user.stat)
		C = p

/obj/item/mechcomp/list_packer/proc/set_D(obj/item/I, mob/user)
	var/p = prompt_update("D", D)
	if(in_range(src, user) && user.stat)
		D = p

/obj/item/mechcomp/list_packer/proc/set_E(obj/item/I, mob/user)
	var/p = prompt_update("E", E)
	if(in_range(src, user) && user.stat)
		E = p

/obj/item/mechcomp/list_packer/proc/set_F(obj/item/I, mob/user)
	var/p = prompt_update("F", F)
	if(in_range(src, user) && user.stat)
		F = p

/obj/item/mechcomp/list_packer/proc/set_G(obj/item/I, mob/user)
	var/p = prompt_update("G", G)
	if(in_range(src, user) && user.stat)
		G = p

/obj/item/mechcomp/list_packer/proc/set_H(obj/item/I, mob/user)
	var/p = prompt_update("H", H)
	if(in_range(src, user) && user.stat)
		H = p

/obj/item/mechcomp/list_packer/proc/set_glue(obj/item/I, mob/user)
	var/input = tgui_input_text(user, "Set glue to what? Glue is used to \"glue\" lists together into a single string. Default glue for most cases is \"&\", but you can use another one if you want to use lists of lists. You can even use multiple symbols as glue!", "glue", glue)
	if(!isnull(input))
		glue = input
		to_chat(user, span_notice("You set [src.name]'s glue to \"[glue]\""))

/obj/item/mechcomp/list_packer/proc/build(var/datum/mechcompMessage/msg)
	var/list/l = list()
	//lol
	if(!isnull(A))
		l.Add(A)
	if(!isnull(B))
		l.Add(B)
	if(!isnull(C))
		l.Add(C)
	if(!isnull(D))
		l.Add(D)
	if(!isnull(E))
		l.Add(E)
	if(!isnull(F))
		l.Add(F)
	if(!isnull(G))
		l.Add(G)
	if(!isnull(H))
		l.Add(H)

	var/result = jointext(l, glue)
	if(length(result))
		SEND_SIGNAL(src, COMSIG_MECHCOMP_TRANSMIT_SIGNAL, result)

/obj/item/mechcomp/list_extractor
	name = "mechcomp list Extractor"
	desc = "Takes a numerical index and outputs a value from a given list with that index. It's that simple. Refuses lists with a single element (i.e. no \"&\" dividers.). If not a number value is passed to it as an index, it will return the first item of the list."
	var/list/memory = list()
	var/glue = "&"
	icon_state = "comp_list_unpacker"
	part_icon_state = "comp_list_unpacker"
	has_anchored_icon_state = TRUE

/obj/item/mechcomp/list_extractor/Initialize(mapload)
	. = ..()
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_INPUT, "List in", "updatelist")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_INPUT, "Extract from list", "extract")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_CONFIG, "Set Glue", "set_glue")

/obj/item/mechcomp/list_extractor/proc/updatelist(var/datum/mechcompMessage/msg)
	var/list/l = splittext(msg.signal, glue)
	if (length(l)<2)
		return
	memory = l

/obj/item/mechcomp/list_extractor/proc/extract(var/datum/mechcompMessage/msg)
	var/index = text2num(msg.signal)
	if(isnull(index))//return the first item if the message doesn't have a numerical index
		SEND_SIGNAL(src, COMSIG_MECHCOMP_TRANSMIT_SIGNAL, memory[1])
		return
	if(index >= 1 && index <= length(memory))//return eat shit if it's an invalid number tho
		SEND_SIGNAL(src, COMSIG_MECHCOMP_TRANSMIT_SIGNAL, memory[index])

/obj/item/mechcomp/list_extractor/proc/set_glue(obj/item/I, mob/user)
	var/input = tgui_input_text(user, "Set glue to what? Glue is used to \"glue\" lists together into a single string. Default glue for most cases is \"&\", but you can use another one if you want to use lists of lists. You can even use multiple symbols as glue! Make sure the list you pass to [src.name] uses the same glue!", "Glue", glue)
	if(!isnull(input))
		glue = input
		to_chat(user, span_notice("You set [src.name]'s glue to \"[glue]\""))




/obj/item/mechcomp/find_regex
	name = "mechcomp Regex text finder"
	desc = "Uses the black Regex magic to find specific data in a given string."
	icon_state = "comp_regfind"
	part_icon_state = "comp_regfind"
	has_anchored_icon_state = TRUE
	var/regex/reg
	var/glue = "&"
	var/group_glue = ";"
	//global search flag
	var/g = TRUE
	//case insensitive flag
	var/i = TRUE

/obj/item/mechcomp/find_regex/examine(mob/user)
	. = ..()
	. += "<br><i>Currently the regex expression is [reg ? "\"<font color='orange'>[reg.name]</font>\"[i||g? " with flag[g&&i?"s":""] [g ? "g":""][i ? "i":""]." : "."]" : "<font color='orange'>not set!</font>"]</i>"

/obj/item/mechcomp/find_regex/Initialize(mapload)
	. = ..()
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_INPUT, "String to search", "find")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_CONFIG, "Set the Regex pattern", "setpattern")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_CONFIG, "Set Result Glue", "set_glue")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_CONFIG, "Set Group Glue", "set_group_glue")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_CONFIG, "Toggle case insensitivity", "toggle_case")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_CONFIG, "Toggle global search", "toggle_global")


/obj/item/mechcomp/find_regex/proc/setpattern(obj/item/I, mob/user)
	var/input = tgui_input_text(user, "Input your regex pattern.", "[pick(80;"Regex", 5;"Reg-ekhs?", 5;"what the fuck is a regex", 5;"if you have a problem you want to solve with regex, you have 2 problems.", 5;"the regex is outlawed in 48 US states")]", reg?.name)
	if(!isnull(input))
		reg = regex(input, "[g ? "g":""][i ? "i":""]")
		to_chat(user, span_notice("You set [src.name]'s pattern to \"[reg?.name]\""))

/obj/item/mechcomp/find_regex/proc/find(var/datum/mechcompMessage/msg)
	if(isnull(reg))
		say("Warning, the regex expression is not set[prob(4) ? ", you fucking retard!" : "!"]")
	var/haystack = msg.signal

	//var/len = length(haystack)
	var/list/result = list()
	for(var/i=0, i<1000, i++)
		//i am afraid to use infinite loops even though it should never go into one
		if(i==999)

			//oh god what have you done
			say("Critical error: Approached limit of 1000 iterations of regex search for given text. Report to NanoTrasen Mechanical division.")
			CRASH("A mechcomp regex searcher went over 1000 iterations of searching through text and is shutting down. Please ask whoever set up this shite how did they achieve this.")

		var/index = reg.Find(haystack)
		if(!index)
			break
		if(reg.group)
			result.Add(jointext(reg.group,group_glue))
		else
			result.Add(reg.match)
	if(result)
		SEND_SIGNAL(src, COMSIG_MECHCOMP_TRANSMIT_SIGNAL, jointext(result, glue))
	//reg = regex(reg)//reset the regex expression vars, just in case


/obj/item/mechcomp/find_regex/proc/set_group_glue(obj/item/I, mob/user)
	var/input = tgui_input_text(user, "Set group glue to what? Group glue for regex is used to glue together all the capture groups from the single search. It is heavily recommended to keep different from result glue which is used to glue together all search results.", "Glue", glue)
	if(!isnull(input))
		glue = input
		to_chat(user, span_notice("You set [src.name]'s group glue to \"[glue]\""))

/obj/item/mechcomp/find_regex/proc/set_glue(obj/item/I, mob/user)
	var/input = tgui_input_text(usr, "Set result glue to what? Glue is used to \"glue\" lists together into a single string. Default glue for most cases is \"&\", but you can use another one if you want to use lists of lists. You can even use multiple symbols as glue! Make sure to use a unique symbol or group or symbols, or else extracting data will be stupidly complicated!", "Glue", glue)
	if(!isnull(input))
		glue = input
		to_chat(user, span_notice("You set [src.name]'s result glue to \"[glue]\""))

/obj/item/mechcomp/find_regex/proc/toggle_case(obj/item/I, mob/user)
	i = !i
	reg = regex(reg?.name, "[g ? "g":""][i ? "i":""]")

/obj/item/mechcomp/find_regex/proc/toggle_global(obj/item/I, mob/user)
	g = !g
	reg = regex(reg?.name, "[g ? "g":""][i ? "i":""]")



/obj/item/mechcomp/timer
	name = "mechcomp Timer"
	desc = "Sends out a set signal every time period. Can be set to periods from 0.1 to 10 seconds."
	icon_state = "comp_timer"
	part_icon_state = "comp_timer"
	has_anchored_icon_state = TRUE
	var/time = 10
	var/timer_id
/obj/item/mechcomp/timer/examine(mob/user)
	. = ..()
	. += "<i>Currently set to <font color='orange'>[time/10]</font> seconds. [active ? "<font color='orange'>[timeleft(timer_id)]</font> seconds left until the next activation." : "It is deactivated."]</i>"

/obj/item/mechcomp/timer/Initialize(mapload)
	. = ..()
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_INPUT, "Toggle state", "toggle")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_INPUT, "Set state", "setstate")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_CONFIG, "Toggle state manually", "togglemanual")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_CONFIG, "Set time", "set_time")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ALLOW_MANUAL_SIGNAL)

/obj/item/mechcomp/timer/proc/set_time(obj/item/I, mob/user)
	if(active)
		to_chat(user, span_alert("Deactivate the [src.name] first!"))
		return FALSE
	var/input = input("Enter new time in deciseconds. Currently the [src.name] will activate every [time/10] seconds.", "Time", time) as num
	if(!in_range(src, user) || user.stat || isnull(input))
		return FALSE
	time = clamp(input, 1, 100)
	to_chat(user, span_notice("You change the time on [src.name] to [time/10] seconds."))
	return TRUE

/obj/item/mechcomp/timer/proc/toggle(var/datum/mechcompMessage/msg)
	if(!timer_id)
		active = TRUE
		start_ticking()
	else
		deltimer(timer_id)
		timer_id = null
		active = FALSE

/obj/item/mechcomp/timer/proc/togglemanual(obj/item/I, mob/user)
	toggle()
	to_chat(user, "You [active ? "activate": "deactivate"] the [src.name]")



//will do nothing on trying to enable an active timer or disable an inactive one.
/obj/item/mechcomp/timer/proc/setstate(var/datum/mechcompMessage/msg)
	if(msg.isTrue())
		if(!timer_id)
			start_ticking()
			active = TRUE
	else
		if(timer_id)
			deltimer(timer_id)
			timer_id = null
			active = FALSE

/obj/item/mechcomp/timer/proc/start_ticking()
	timer_id = addtimer(CALLBACK(src, PROC_REF(fire)), time, TIMER_STOPPABLE | TIMER_LOOP | TIMER_DELETE_ME)

/obj/item/mechcomp/timer/proc/fire()
	if(active) //just in case...
		SEND_SIGNAL(src, COMSIG_MECHCOMP_TRANSMIT_DEFAULT_MSG)
		//can't be active while unanchored so fuck it.
		flick("ucomp_timer_flash", src)
	else
		//whoops, this timer shouldn't exist
		deltimer(timer_id)
		timer_id = null

/obj/item/mechcomp/timer/can_unanchor(mob/user)
	. = ..()
	if(timer_id || active)
		to_chat(user, span_alert("The timer still running! Disable it first!"))
		return FALSE

/obj/item/mechcomp/microphone
	name = "mechcomp Microphone"
	desc = "Would be pretty useful for spying on people, but it's just too big for this job. Comically oversized, even."
	icon_state = "comp_mic"
	part_icon_state = "comp_mic"
	has_anchored_icon_state = TRUE
	var/ignore_mechcomp = TRUE
	var/ignore_radios = TRUE

/obj/item/mechcomp/microphone/Initialize(mapload)
	. = ..()
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_CONFIG, "Toggle ignoring mechcomp devices", "togglemechcomp")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_CONFIG, "Toggle ignoring radios", "toggleradio")



/obj/item/mechcomp/microphone/proc/togglemechcomp(obj/item/I, mob/user)
	ignore_mechcomp = !ignore_mechcomp
	if(ignore_mechcomp)
		to_chat(user, span_notice("The [src.name] will now filter out other mechcomp components."))
	else
		to_chat(user, span_notice("The [src.name] will now pick up what other mechcomp components say."))


/obj/item/mechcomp/microphone/proc/toggleradio(obj/item/I, mob/user)
	ignore_radios = !ignore_radios
	if(ignore_radios)
		to_chat(user, span_notice("The [src.name] will filter out speech from nearby radios and intercomms."))
	else
		to_chat(user, span_notice("The [src.name] will pick up speech from a radio or an intercomm, if one is nearby."))


/obj/item/mechcomp/microphone/Hear(message, atom/movable/speaker, message_language, raw_message)
	. = ..()
	if(istype(speaker, /obj/item/mechcomp) && ignore_mechcomp)
		return
	if(istype(speaker, /obj/item/radio) && ignore_radios)
		return
	SEND_SIGNAL(src, COMSIG_MECHCOMP_TRANSMIT_SIGNAL, "[message]&[speaker.GetVoice()]")

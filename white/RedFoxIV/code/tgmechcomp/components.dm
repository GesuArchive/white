/*
/obj/item/mechcomp/debugspawn
/obj/item/mechcomp/debugspawn/Initialize()
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
	desc = "Do number things! Component list<br/>rng: Generates a random number from A to B<br/>add: Adds A + B<br/>sub: Subtracts A - B<br/>mul: Multiplies A * B<br/>div: Divides A / B<br/>pow: Power of A ^ B<br/>mod: Modulos A % B<br/>eq|neq|gt|lt|gte|lte: Equal/NotEqual/GreaterThan/LessThan/GreaterEqual/LessEqual -- will output 1 if true. Example: A GT B = 1 if A is larger than B"
	part_icon_state = "comp_arith"
	has_anchored_icon_state = TRUE
	var/A = 1
	var/B = 1

	var/mode = "add"

/obj/item/mechcomp/math/examine(mob/user)
		. = ..() // Please don't remove this again, thanks. //i have no fucking idea why gooncoders would do this lol
		. += "<br><span class='notice'>Current Mode: [mode] | A = [A] | B = [B]</span>"

/obj/item/mechcomp/math/Initialize()
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
	mode = input("Set the math mode to what?", "Mode Selector", mode) in list("add","mul","div","sub","mod","pow","rng","eq","neq","gt","lt","gte","lte")
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
		else
			return
	if(. == .) //wtf???
		SEND_SIGNAL(src,COMSIG_MECHCOMP_TRANSMIT_SIGNAL,"[.]")





//should be replaced by a proper led with actual light and stuff, not just a stub with 2 sprites for true/false input.
/obj/item/mechcomp/test_led
	name = "Test LED"
	desc = "Lights up if anything other than zero or an empty string is passed."
	part_icon_state = "comp_led"
	has_anchored_icon_state = TRUE

/obj/item/mechcomp/test_led/Initialize()
		. = ..()

		SEND_SIGNAL(src,COMSIG_MECHCOMP_ADD_INPUT,"Activate", "activateproc")

/obj/item/mechcomp/test_led/proc/activateproc(datum/mechcompMessage/msg)
	if(msg.isTrue())
		update_icon_state("comp_led_on")
	else
		update_icon_state("comp_led")






/obj/item/mechcomp/button
	name = "mechcomp Button"
	desc = "What does it do? Only one way to find out!"
	part_icon_state = "comp_button"

/obj/item/mechcomp/button/Initialize()
	. = ..()
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ALLOW_MANUAL_SIGNAL)

/obj/item/mechcomp/button/interact_by_hand()
	if(active)
		return
	activate_for(1 SECONDS)
	update_icon_state("comp_button1")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_TRANSMIT_DEFAULT_MSG)
	spawn(1 SECONDS)
		update_icon_state("comp_button")
		active = FALSE






//Changes it's description to whatever is passed to it's speak input. SHOULD ACTUALLY SAY IT INSTEAD OF THIS SHITE
/obj/item/mechcomp/speaker
	name = "mechcomp speaker"
	desc = "Speaks whatever it is told to speak."
	part_icon_state = "comp_synth"
	active_icon_state = "comp_synth1"

/obj/item/mechcomp/speaker/Initialize()
	. = ..()
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_INPUT, "speak", "activateproc")

/obj/item/mechcomp/speaker/proc/activateproc(datum/mechcompMessage/msg)
	if(active)
		return
	activate_for(3 SECONDS)
	say(msg.signal)




//probably useless
/obj/item/mechcomp/numpad
	name = "mechcomp numpad"
	desc = "Enter numbers in infinitely different ways! Infinitely inferior to the chad textpanel."
	part_icon_state = "comp_buttpanel"
	active_icon_state = "comp_buttpanel1"

/obj/item/mechcomp/numpad/interact_by_hand()
	var/inp = text2num(input("What number would you like to input?", "Oh, the possibilities!", null))
	if(isnull(inp))
		return

	SEND_SIGNAL(src,COMSIG_MECHCOMP_TRANSMIT_SIGNAL,"[inp]")
	activate_for(0.1 SECONDS)




/obj/item/mechcomp/textpad
	name = "mechcomp textpad"
	desc = "Text goes here. Strangely similiar to a numpad, while also being better than a numpad."
	part_icon_state = "comp_buttpanel"
	active_icon_state = "comp_buttpanel1"

/obj/item/mechcomp/textpad/interact_by_hand()
	var/inp = input("What text would you like to input?", "Oh, the possibilities!", null)
	if(isnull(inp))
		return

	SEND_SIGNAL(src,COMSIG_MECHCOMP_TRANSMIT_SIGNAL,"[inp]")
	activate_for(0.1 SECONDS)




/obj/item/mechcomp/pressurepad
	name = "mechcomp pressure pad"
	desc = "Senses people walking over it."
	part_icon_state = "comp_pressure"
	has_anchored_icon_state = TRUE
	var/sensitive = FALSE

/obj/item/mechcomp/pressurepad/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_MOVABLE_CROSSED, .proc/pad_triggered)
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ALLOW_MANUAL_SIGNAL)
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_CONFIG, "Fine tuning", "finetune")

/obj/item/mechcomp/pressurepad/proc/pad_triggered(datum/self, atom/movable/AM)
	SIGNAL_HANDLER
	if(anchored)
		if( sensitive || isliving(AM))
			SEND_SIGNAL(src, COMSIG_MECHCOMP_TRANSMIT_DEFAULT_MSG)



/obj/item/mechcomp/pressurepad/proc/finetune(obj/item/W, mob/user)
	sensitive = !sensitive
	if(sensitive)
		to_chat(user, "<span class='alert'>You tune the [src.name] to be more sensitive, allowing it to sense not just living creatures, but objects passing by.</span>")
	else
		to_chat(user, "<span class='alert'>You tune the [src.name] to be less sensitive, so it can only sense creatures passing by.</span>")

/obj/item/mechcomp/delay
	name = "mechcomp timer"
	desc = "Relays signals with a configurable delay from 0 to 10 seconds."
	part_icon_state = "comp_wait"
	active_icon_state = "comp_wait1"
	has_anchored_icon_state = TRUE
	var/delay = 10
	var/list/pending_messages = list()

/obj/item/mechcomp/delay/examine(mob/user)
	. = ..()
	. += "It is currently set to delay incoming messages by [delay] deciseconds."


/obj/item/mechcomp/delay/Initialize()
	. = ..()
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_CONFIG, "Set Delay" , "setdelaymanually")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_INPUT, "Incoming", "incoming")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_INPUT, "Delay", "setdelay")

/obj/item/mechcomp/delay/proc/setdelaymanually(obj/item/W, mob/user)
	var/input = input("Enter new time in deciseconds Current delay is [delay]ds.", "Delay", null) as num
	if(!in_range(src, user) || user.stat || isnull(input))
		to_chat(user, "<span class='notice'>You leave the delay on [src.name] alone.</span>")
		return FALSE
	delay = clamp(input, 0, 100)
	to_chat(user, "<span class='notice'>You change the delay on [src.name] to [delay] deciseconds.</span>")
	return TRUE


/obj/item/mechcomp/delay/proc/setdelay(var/datum/mechcompMessage/msg)
	var/t = text2num(msg.signal)
	if (!isnull(t) && t > 0 && t<100)
		delay = t



//This mechcomp component handles active flag by itself because it can have several different messages waiting to be sent,
//and active flag should not be set to FALSE untill all of the messages were sent.
//This is probably not good and stuff regarting active-inactive states should be rewritten to be more flexible.
/obj/item/mechcomp/delay/proc/incoming(var/datum/mechcompMessage/msg)
	pending_messages += list(addtimer(CALLBACK(src, .proc/sendmessage, msg), delay))
	active = TRUE
	update_icon_state(active_icon_state)



/obj/item/mechcomp/delay/proc/sendmessage(var/datum/mechcompMessage/msg)
	SEND_SIGNAL(src,COMSIG_MECHCOMP_TRANSMIT_MSG, msg)
	if(!pending_messages.len)
		active = FALSE
		update_icon_state(part_icon_state)

/obj/item/mechcomp/delay/unanchor()
	remove_all_pending_messages()
	..()

/obj/item/mechcomp/delay/proc/remove_all_pending_messages()
	for(var/timer in pending_messages)
		deltimer(timer)
	pending_messages = list()


/obj/item/mechcomp/grav_accelerator
	name = "mechcomp graviton accelerator"
	desc = "The bread and butter of any self-respecting mechanic, able to launch anyone willing (and unwilling!) in a fixed direction."
	part_icon_state = "comp_accel"
	active_icon_state = "comp_accel1"
	var/power = 3
	has_anchored_icon_state = TRUE
	only_one_per_tile = TRUE

/obj/item/mechcomp/grav_accelerator/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/simple_rotation, ROTATION_ALTCLICK | ROTATION_CLOCKWISE, CALLBACK(src, .proc/can_user_rotate),CALLBACK(src, .proc/can_be_rotated),null)

/obj/item/mechcomp/grav_accelerator/Initialize()
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

	for(var/atom/movable/AM in range(0, src))
		if(AM.anchored || AM == src)
			continue
		var/throwtarget = get_edge_target_turf(AM, src.dir)
		AM.safe_throw_at(throwtarget, power, 1, force = MOVE_FORCE_STRONG, spin = TRUE)
	activate_for((power+2) SECONDS)

/obj/item/mechcomp/grav_accelerator/proc/setpowermanually(obj/item/W, mob/user)
	var/input = input("Enter new power setting.", "Power", null) as num
	if(!in_range(src, user) || user.stat || isnull(input))
		to_chat(user, "<span class='notice'>You leave the power setting on [src.name] alone.</span>")
		return FALSE

	power = clamp(round(input), 1, 7)
	to_chat(user, "<span class='notice'>You change the power setting on [src.name] to [power].</span>")
	return TRUE

/obj/item/mechcomp/egunholder
	name = "mechcomp energy gun fixture"
	desc = "Warcrimes, warcrimes!"
	part_icon_state = "comp_egun"
	only_one_per_tile = TRUE
	///from 0 to 360
	var/angle = 0
	var/obj/item/gun/energy/gun


/obj/item/mechcomp/egunholder/Initialize()
	. = ..()
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_INPUT, "Fire!", "fire")
	//SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_CONFIG, "Angle", "rotate") //Would this make the gun component too OP? :thinking:

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
	else
		playsound(src, gun.dry_fire_sound, 50, TRUE)


	activate_for(1 SECONDS)


/obj/item/mechcomp/egunholder/interact_by_item(obj/item/I, mob/user)
	. = ..()
	if(!istype(I,/obj/item/gun/energy) && istype(I,/obj/item/gun/))
		to_chat(user, "<span class='notice'>[src.name] accepts only energy-based weaponry!.</span>")
		return

	if(istype(I,/obj/item/gun/energy))
		if(isnull(gun))
			user.transferItemToLoc(I,src)
			gun = I
			to_chat(user, "<span class='notice'>You slide \the [gun] into the [src.name].</span>")
			playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
			return
		else
			to_chat(user, "<span class='notice'>There's already a weapon installed in [src.name]!.</span>")
			return

	if(I.tool_behaviour == TOOL_CROWBAR && !isnull(gun))
		gun.forceMove(drop_location())
		gun = null
		playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
		to_chat(user, "<span class='notice'>You pop \the [gun] out of the [src.name].</span>")
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
		addtimer(src, CALLBACK(src, .proc/debugrotate, angle+1), 1)

/obj/item/mechcomp/egunholder/AltClick(mob/user)
	if(!user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE, !iscyborg(user)))
		return
	rotate(user)

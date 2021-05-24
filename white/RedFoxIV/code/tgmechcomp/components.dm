//copypaste of a goon component, thankfully it somehow just works.
//Still probably should be at least reviewed. 
/obj/item/mechcomp/math
	name = "Arithmetic Component"
	desc = "Do number things! Component list<br/>rng: Generates a random number from A to B<br/>add: Adds A + B<br/>sub: Subtracts A - B<br/>mul: Multiplies A * B<br/>div: Divides A / B<br/>pow: Power of A ^ B<br/>mod: Modulos A % B<br/>eq|neq|gt|lt|gte|lte: Equal/NotEqual/GreaterThan/LessThan/GreaterEqual/LessEqual -- will output 1 if true. Example: A GT B = 1 if A is larger than B"
	part_icon_state = "comp_arith"
	has_compact_icon_state = TRUE
	var/A = 1
	var/B = 1

	var/mode = "rng"

/obj/item/mechcomp/math/examine(mob/user)
		. = ..() // Please don't remove this again, thanks. //i have no fucking idea why gooncoders would do this lol
		. += "<br><span class='notice'>Current Mode: [mode] | A = [A] | B = [B]</span>"

/obj/item/mechcomp/math/Initialize()
		. = ..()

		SEND_SIGNAL(src,COMSIG_MECHCOMP_ADD_INPUT,"Set A", "setA")
		SEND_SIGNAL(src,COMSIG_MECHCOMP_ADD_INPUT,"Set B", "setB")
		SEND_SIGNAL(src,COMSIG_MECHCOMP_ADD_INPUT,"Evaluate", "evaluate")
		SEND_SIGNAL(src,COMSIG_MECHCOMP_ADD_CONFIG,"Set A","setAManually")
		SEND_SIGNAL(src,COMSIG_MECHCOMP_ADD_CONFIG,"Set B","setBManually")
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
	if(. == .)
		SEND_SIGNAL(src,COMSIG_MECHCOMP_TRANSMIT_SIGNAL,"[.]")





//should be replaced by a proper led with actual light and stuff, not just a stub with 2 sprites for true/false input.
/obj/item/mechcomp/test_led
	name = "Test LED"
	desc = "Lights up if anything other than zero or an empty string is passed."
	part_icon_state = "comp_led"

/obj/item/mechcomp/test_led/Initialize()
		. = ..()

		SEND_SIGNAL(src,COMSIG_MECHCOMP_ADD_INPUT,"Activate", "activate")

/obj/item/mechcomp/test_led/proc/activate(var/datum/mechcompMessage/msg)
	if(msg.isTrue())
		update_icon_state("comp_led_on")
	else
		update_icon_state("comp_led")






/obj/item/mechcomp/button
	name = "mechcorp Button"
	desc = "What does it do? Only one way to find out!"
	part_icon_state = "comp_button"

/obj/item/mechcomp/button/Initialize()
	. = ..()
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ALLOW_MANUAL_SIGNAL)

/obj/item/mechcomp/button/interact_by_hand()
	update_icon_state("comp_button1")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_TRANSMIT_DEFAULT_MSG)
	spawn(1 SECONDS)
		update_icon_state("comp_button")
		active = FALSE






//Changes it's description to whatever is passed to it's speak input. SHOULD ACTUALLY SAY IT INSTEAD OF THIS SHITE
/obj/item/mechcomp/speaker
	name = "mechcorp speaker"
	desc = "Speaks whatever it is told to speak."
	part_icon_state = "comp_synth"

/obj/item/mechcomp/speaker/Initialize()
	. = ..()
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_INPUT, "speak", "activateproc")

/obj/item/mechcomp/speaker/proc/activateproc(var/datum/mechcompMessage/msg)
	if(active)
		return
	active = TRUE
	update_icon_state("comp_synth1")
	desc = msg.signal //i have brain damage
	spawn(3 SECONDS)
		update_icon_state("comp_synth")
		active = FALSE

/obj/item/multitool/mechcomp
	name = "MechComp™  Connector Utility Mechanism"
	desc = "The MechComp brand Connector Utility Mechanism used in construction and usage of MechComp brand mechanical components."
	icon = 'white/RedFoxIV/icons/mechcomp/connection.dmi'
	icon_state = "linker_multitool"
	var/mechcomp_enabled = FALSE


/obj/item/multitool/mechcomp/attack_self(mob/user)
	. = ..()
	mechcomp_enabled = !mechcomp_enabled
	if(mechcomp_enabled)
		to_chat(user, "<span class='notice'>You slide out the mechcomp control panel on the \"C.U.M.\", allowing you to connect, disconnect mechcomp parts and configure them.<span>") // haha funni
		icon_state = "linker_mechcomp"
		tool_behaviour = TOOL_MECHCOMP
	else
		to_chat(user, "<span class='notice'>You slide in the mechcomp control panel on the \"C.U.M.\", making it function like a regular multitool.</span>")
		icon_state = "linker_multitool"
		tool_behaviour = TOOL_MULTITOOL
	//So, apparently tool behaviours are not bitflags and are instead just plain strings with some #defines sprinkled over.
	//So, yeah, this is fucking cringe
	//at least i got to make "cool" sprites
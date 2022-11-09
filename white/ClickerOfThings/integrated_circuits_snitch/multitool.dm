//SPEESZHENO S HIPPIE STATION CODE BY CLICKER

/obj/item/multitool/var/datum/integrated_io/selected_io = null  //functional for integrated circuits.

/obj/item/multitool/attack_self(mob/user)
	if(selected_io)
		selected_io = null
		to_chat(user, span_notice("You clear the wired connection from the multitool."))
	update_icon()

/obj/item/multitool/proc/wire(var/datum/integrated_io/io, mob/user)
	if(!io.holder.assembly)
		to_chat(user, span_warning("<b>[capitalize(io.holder)]</b> needs to be secured inside an assembly first."))
		return

	if(selected_io)
		if(io == selected_io)
			to_chat(user, span_warning("Wiring [selected_io.holder] [selected_io.name] into itself is rather pointless."))
			return
		if(io.io_type != selected_io.io_type)
			to_chat(user, "<span class='warning'>Those two types of channels are incompatible.  The first is a [selected_io.io_type], \
			while the second is a [io.io_type].</span>")
			return
		if(io.holder.assembly && io.holder.assembly != selected_io.holder.assembly)
			to_chat(user, span_warning("Both [io.holder] and [selected_io.holder] need to be inside the same assembly."))
			return
		io.connect_pin(selected_io)

		to_chat(user, span_notice("You connect [selected_io.holder] [selected_io.name] to [io.holder] [io.name]."))
		selected_io.holder.interact(user) // This is to update the UI.
		selected_io = null

	else
		selected_io = io
		to_chat(user, span_notice("You link multitool to [selected_io.holder] [selected_io.name] data channel."))

	update_icon()


/obj/item/multitool/proc/unwire(var/datum/integrated_io/io1, var/datum/integrated_io/io2, mob/user)
	if(!io1.linked.len || !io2.linked.len)
		to_chat(user, span_warning("There is nothing connected to the data channel."))
		return

	if(!(io1 in io2.linked) || !(io2 in io1.linked) )
		to_chat(user, span_warning("These data pins aren't connected!"))
		return
	else
		io1.disconnect_pin(io2)
		to_chat(user, "<span class='notice'>You clip the data connection between the [io1.holder.displayed_name] \
		[io1.name] and the [io2.holder.displayed_name] [io2.name].</span>")
		io1.holder.interact(user) // This is to update the UI.
		update_icon()

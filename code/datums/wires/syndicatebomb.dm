/datum/wires/syndicatebomb
	holder_type = /obj/machinery/syndicatebomb
	proper_name = "Syndicate Explosive Device"
	randomize = TRUE

/datum/wires/syndicatebomb/New(atom/holder)
	wires = list(
		WIRE_BOOM, WIRE_UNBOLT,
		WIRE_ACTIVATE, WIRE_DELAY, WIRE_PROCEED
	)
	..()

/datum/wires/syndicatebomb/interactable(mob/user)
	var/obj/machinery/syndicatebomb/P = holder
	if(P.open_panel)
		return TRUE

/datum/wires/syndicatebomb/on_pulse(wire)
	var/obj/machinery/syndicatebomb/B = holder
	switch(wire)
		if(WIRE_BOOM)
			if(B.active)
				holder.visible_message(span_danger("[icon2html(B, viewers(holder))] Издаёт сигнал тревоги! Кажется сей-"))
				B.explode_now = TRUE
				tell_admins(B)
			else
				holder.visible_message(span_notice("[icon2html(B, viewers(holder))] Ничего не происходит."))
		if(WIRE_UNBOLT)
			holder.visible_message(span_notice("[icon2html(B, viewers(holder))] Болты начинают крутиться."))
		if(WIRE_DELAY)
			if(B.delayedbig)
				holder.visible_message(span_notice("[icon2html(B, viewers(holder))] Ничего не происходит."))
			else
				holder.visible_message(span_notice("[icon2html(B, viewers(holder))] Щебечет что-то."))
				playsound(B, 'sound/machines/chime.ogg', 30, TRUE)
				B.detonation_timer += 300
				if(B.active)
					B.delayedbig = TRUE
		if(WIRE_PROCEED)
			holder.visible_message(span_danger("[icon2html(B, viewers(holder))] Зловеще гудит!"))
			playsound(B, 'white/valtos/sounds/error1.ogg', 30, TRUE)
			var/seconds = B.seconds_remaining()
			if(seconds >= 61) // Long fuse bombs can suddenly become more dangerous if you tinker with them.
				B.detonation_timer = world.time + 600
			else if(seconds >= 21)
				B.detonation_timer -= 100
			else if(seconds >= 11) // Both to prevent negative timers and to have a little mercy.
				B.detonation_timer = world.time + 100
		if(WIRE_ACTIVATE)
			if(!B.active)
				holder.visible_message(span_danger("[icon2html(B, viewers(holder))] Начинает тикать!"))
				B.activate()
				B.update_icon()
			else if(B.delayedlittle)
				holder.visible_message(span_notice("[icon2html(B, viewers(holder))] Ничего не происходит."))
			else
				holder.visible_message(span_notice("[icon2html(B, viewers(holder))] Кажется, колеблется на мгновение."))
				B.detonation_timer += 100
				B.delayedlittle = TRUE

/datum/wires/syndicatebomb/on_cut(wire, mend)
	var/obj/machinery/syndicatebomb/B = holder
	switch(wire)
		if(WIRE_BOOM)
			if(!mend && B.active)
				holder.visible_message(span_danger("[icon2html(B, viewers(holder))] Издаёт сигнал тревоги! Кажется сей-"))
				B.explode_now = TRUE
				tell_admins(B)
		if(WIRE_UNBOLT)
			if(!mend && B.anchored)
				holder.visible_message(span_notice("[icon2html(B, viewers(holder))] Болты начинают подниматься!"))
				playsound(B, 'sound/effects/stealthoff.ogg', 30, TRUE)
				B.set_anchored(FALSE)
		if(WIRE_PROCEED)
			if(!mend && B.active)
				holder.visible_message(span_danger("[icon2html(B, viewers(holder))] Издаёт сигнал тревоги! Кажется сей-"))
				B.explode_now = TRUE
				tell_admins(B)
		if(WIRE_ACTIVATE)
			if(!mend && B.active)
				holder.visible_message(span_notice("[icon2html(B, viewers(holder))] Таймер останавливается! Бомба обезврежена!"))
				B.active = FALSE
				B.delayedlittle = FALSE
				B.delayedbig = FALSE
				B.update_icon()

/datum/wires/syndicatebomb/proc/tell_admins(obj/machinery/syndicatebomb/B)
	if(istype(B, /obj/machinery/syndicatebomb/training))
		return
	var/turf/T = get_turf(B)
	log_game("\A [B] was detonated via boom wire at [AREACOORD(T)].")
	message_admins("A [B.name] was detonated via boom wire at [ADMIN_VERBOSEJMP(T)].")

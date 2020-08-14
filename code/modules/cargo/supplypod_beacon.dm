/obj/item/supplypod_beacon
	name = "Маяк для сброса груза"
	desc = "Устройство, которое можно подключить к экспрес консоли для точной доставки груза."
	icon = 'icons/obj/device.dmi'
	icon_state = "supplypod_beacon"
	inhand_icon_state = "radio"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	var/obj/machinery/computer/cargo/express/express_console
	var/linked = FALSE
	var/ready = FALSE
	var/launched = FALSE

/obj/item/supplypod_beacon/proc/update_status(consoleStatus)
	switch(consoleStatus)
		if (SP_LINKED)
			linked = TRUE
			playsound(src,'sound/machines/twobeep.ogg',50,FALSE)
		if (SP_READY)
			ready = TRUE
		if (SP_LAUNCH)
			launched = TRUE
			playsound(src,'sound/machines/triple_beep.ogg',50,FALSE)
			playsound(src,'sound/machines/warning-buzzer.ogg',50,FALSE)
			addtimer(CALLBACK(src, .proc/endLaunch), 33)//wait 3.3 seconds (time it takes for supplypod to land), then update icon
		if (SP_UNLINK)
			linked = FALSE
			playsound(src,'sound/machines/synth_no.ogg',50,FALSE)
		if (SP_UNREADY)
			ready = FALSE
	update_icon()

/obj/item/supplypod_beacon/update_overlays()
	. = ..()
	if (launched)
		. += "sp_green"
	else if (ready)
		. += "sp_yellow"
	else if (linked)
		. += "sp_orange"

/obj/item/supplypod_beacon/proc/endLaunch()
	launched = FALSE
	update_status()

/obj/item/supplypod_beacon/examine(user)
	. = ..()
	if(!express_console)
		. += "<span class='notice'>[src] в настоящее время не подключён к экспресс консоли.</span>"
	else
		. += "<hr><span class='notice'>Альт + Клик чтобы чтобы прекратить подключение с экспресс консолью.</span>"

/obj/item/supplypod_beacon/Destroy()
	if(express_console)
		express_console.beacon = null
	return ..()

/obj/item/supplypod_beacon/proc/unlink_console()
	if(express_console)
		express_console.beacon = null
		express_console = null
	update_status(SP_UNLINK)
	update_status(SP_UNREADY)

/obj/item/supplypod_beacon/proc/link_console(obj/machinery/computer/cargo/express/C, mob/living/user)
	if (C.beacon)//if new console has a beacon, then...
		C.beacon.unlink_console()//unlink the old beacon from new console
	if (express_console)//if this beacon has an express console
		express_console.beacon = null//remove the connection the expressconsole has from beacons
	express_console = C//set the linked console var to the console
	express_console.beacon = src//out with the old in with the news
	update_status(SP_LINKED)
	if (express_console.usingBeacon)
		update_status(SP_READY)
	to_chat(user, "<span class='notice'>[src] подключён к [C].</span>")

/obj/item/supplypod_beacon/AltClick(mob/user)
	if (!user.canUseTopic(src, !issilicon(user)))
		return
	if (express_console)
		unlink_console()
	else
		to_chat(user, "<span class='alert'>Нет подключённой консоли.</span>")

/obj/item/supplypod_beacon/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/pen)) //give a tag that is visible from the linked express console
		var/new_beacon_name = stripped_input(user, "Каким должен быть тег??")
		if(!user.canUseTopic(src, BE_CLOSE))
			return
		if(new_beacon_name)
			name += " ([tag])"
		return
	else
		return ..()

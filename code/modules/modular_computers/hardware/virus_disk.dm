/obj/item/computer_hardware/hard_drive/portable/virus
	name = "\improper generic virus disk"
	icon_state = "virusdisk"
	var/charges = 5

/obj/item/computer_hardware/hard_drive/portable/virus/proc/send_virus(obj/item/modular_computer/tablet/target, mob/living/user)
	return

/obj/item/computer_hardware/hard_drive/portable/virus/clown
	name = "\improper H.O.N.K. disk"

/obj/item/computer_hardware/hard_drive/portable/virus/clown/send_virus(obj/item/modular_computer/tablet/target, mob/living/user)
	if(charges <= 0)
		to_chat(user, span_notice("ERROR: Out of charges."))
		return

	if(target)
		user.show_message(span_notice("Success!"))
		charges--
		target.honkamnt = rand(15, 25)
	else
		to_chat(user, span_notice("ERROR: Could not find device."))

/obj/item/computer_hardware/hard_drive/portable/virus/mime
	name = "\improper sound of silence disk"

/obj/item/computer_hardware/hard_drive/portable/virus/mime/send_virus(obj/item/modular_computer/tablet/target, mob/living/user)
	if(charges <= 0)
		to_chat(user, span_notice("ERROR: Out of charges."))
		return

	if(target)
		user.show_message(span_notice("Success!"))
		charges--

		var/obj/item/computer_hardware/hard_drive/drive = target.all_components[MC_HDD]

		for(var/datum/computer_file/program/messenger/app in drive.stored_files)
			app.ringer_status = FALSE
			app.ringtone = ""
	else
		to_chat(user, span_notice("ERROR: Could not find device."))

/obj/item/computer_hardware/hard_drive/portable/virus/deto
	name = "\improper D.E.T.O.M.A.T.I.X. disk"
	charges = 6

/obj/item/computer_hardware/hard_drive/portable/virus/deto/send_virus(obj/item/modular_computer/tablet/target, mob/living/user)
	if(charges <= 0)
		to_chat(user, span_notice("ERROR: Out of charges."))
		return

	var/difficulty = target.get_detomatix_difficulty()
	if(SEND_SIGNAL(target, COMSIG_TABLET_CHECK_DETONATE) & COMPONENT_TABLET_NO_DETONATE || prob(difficulty * 15))
		user.show_message(span_danger("ERROR: Target could not be bombed."), MSG_VISUAL)
		charges--
		return

	var/original_host = holder
	var/fakename = sanitize_name(tgui_input_text(user, "Enter a name for the rigged message.", "Forge Message", max_length = MAX_NAME_LEN), allow_numbers = TRUE)
	if(!fakename || holder != original_host || !user.canUseTopic(holder, BE_CLOSE))
		return
	var/fakejob = sanitize_name(tgui_input_text(user, "Enter a job for the rigged message.", "Forge Message", max_length = MAX_NAME_LEN), allow_numbers = TRUE)
	if(!fakejob || holder != original_host || !user.canUseTopic(holder, BE_CLOSE))
		return

	var/obj/item/computer_hardware/hard_drive/drive = holder.all_components[MC_HDD]

	for(var/datum/computer_file/program/messenger/app in drive.stored_files)
		if(charges > 0 && app.send_message(user, list(target), rigged = REF(user), fake_name = fakename, fake_job = fakejob))
			charges--
			user.show_message(span_notice("Success!"))
			var/reference = REF(src)
			ADD_TRAIT(target, TRAIT_PDA_CAN_EXPLODE, reference)
			ADD_TRAIT(target, TRAIT_PDA_MESSAGE_MENU_RIGGED, reference)
			addtimer(TRAIT_CALLBACK_REMOVE(target, TRAIT_PDA_MESSAGE_MENU_RIGGED, reference), 10 SECONDS)

/obj/item/computer_hardware/hard_drive/portable/virus/frame
	name = "\improper F.R.A.M.E. disk"

	var/telecrystals = 0
	var/current_progression = 0

/obj/item/computer_hardware/hard_drive/portable/virus/frame/send_virus(obj/item/modular_computer/tablet/target, mob/living/user)
	if(charges <= 0)
		to_chat(user, span_notice("ERROR: Out of charges."))
		return

	if(target)
		charges--
		var/lock_code = "[rand(100,999)] [pick(GLOB.phonetic_alphabet)]"
		to_chat(user, span_notice("Success! The unlock code to the target is: [lock_code]"))
		var/datum/component/uplink/hidden_uplink = target.GetComponent(/datum/component/uplink)
		if(!hidden_uplink)
			hidden_uplink = target.AddComponent(/datum/component/uplink)
			hidden_uplink.unlock_code = lock_code
		else
			hidden_uplink.hidden_crystals += hidden_uplink.telecrystals //Temporarially hide the PDA's crystals, so you can't steal telecrystals.
		hidden_uplink.telecrystals = telecrystals
		telecrystals = 0
		hidden_uplink.locked = FALSE
		hidden_uplink.active = TRUE
	else
		to_chat(user, span_notice("ERROR: Could not find device."))

/obj/item/computer_hardware/hard_drive/portable/virus/frame/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(istype(I, /obj/item/stack/telecrystal))
		if(!charges)
			to_chat(user, span_notice("[src] is out of charges, it's refusing to accept [I]."))
			return
		var/obj/item/stack/telecrystal/telecrystalStack = I
		telecrystals += telecrystalStack.amount
		to_chat(user, span_notice("You slot [telecrystalStack] into [src]. The next time it's used, it will also give telecrystals."))
		telecrystalStack.use(telecrystalStack.amount)

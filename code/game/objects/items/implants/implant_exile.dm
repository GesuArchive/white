//Exile implants will allow you to use the station gate, but not return home.
//This will allow security to exile badguys/for badguys to exile their kill targets

/obj/item/implant/exile
	name = "exile implant"
	desc = "Prevents you from returning from away missions."
	activated = FALSE
	actions_types = null

/obj/item/implant/exile/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> Nanotrasen Employee Exile Implant<BR>
				<b>Implant Details:</b> The onboard gateway system has been modified to reject entry by individuals containing this implant.<BR>"}
	return dat

/obj/item/implant/exile/removed(mob/living/target, silent = FALSE, special = FALSE)
	. = ..()
	ADD_TRAIT(target, TRAIT_PACIFISM, "sosi")
	target.visible_message(span_danger("Имплант разрывается и испускает гигансткое облако из наном~- <big>ААААААААААААААААААААААААА!!!</big>") , \
		span_userdanger("$*$(*@%@!^&за мир во всём мире!") , vision_distance = 2)
	for(var/mob/living/carbon/human/H in view(1, get_turf(target)))
		H.adjustBruteLoss(49)
		H.adjustFireLoss(49)
		for(var/_limb in H.bodyparts)
			var/obj/item/bodypart/limb = _limb
			var/type_wound = pick(list(/datum/wound/blunt/critical, /datum/wound/blunt/severe, /datum/wound/blunt/critical, /datum/wound/blunt/severe, /datum/wound/blunt/moderate))
			limb.force_wound_upwards(type_wound, smited = TRUE)

///Used to help the staff of the space hotel resist the urge to use the space hotel's incredibly alluring roundstart teleporter to ignore their flavor/greeting text and come to the station.
/obj/item/implant/exile/noteleport
	name = "anti-teleportation implant"
	desc = "Uses impressive bluespace grounding techniques to deny the person implanted by this implant the ability to teleport (or be teleported). Used by certain slavers (or particularly strict employers) to keep their slaves from using teleporters to escape their grasp."

/obj/item/implant/exile/noteleport/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> Anti-Teleportation Implant<BR>
				<b>Implant Details:</b> Keeps the implantee from using most teleportation devices. In addition, it spoofs the implant signature of an exile implant to keep the implantee from using certain gateway systems.<BR>"}
	return dat

/obj/item/implant/exile/noteleport/implant(mob/living/target, mob/user, silent = FALSE, force = FALSE)
	. = ..()
	if(!. || !isliving(target))
		return FALSE
	var/mob/living/living_target = target
	ADD_TRAIT(living_target, TRAIT_NO_TELEPORT, "implant")
	START_PROCESSING(SSprocessing, src)
	return TRUE

/obj/item/implant/exile/noteleport/removed(mob/target, silent = FALSE, special = FALSE)
	. = ..()
	if(!. || !isliving(target))
		return FALSE
	var/mob/living/living_target = target
	REMOVE_TRAIT(living_target, TRAIT_NO_TELEPORT, "implant")
	STOP_PROCESSING(SSprocessing, src)
	return TRUE

/obj/item/implant/exile/noteleport/process(delta_time)
	. = ..()
	if(is_station_level(imp_in.z))
		if(imp_in.mind)
			spawn(1 SECONDS)
				imp_in.gib(TRUE, TRUE, TRUE)

/obj/item/implanter/exile
	name = "implanter (exile)"
	imp_type = /obj/item/implant/exile

/obj/item/implanter/exile/noteleport
	name = "implanter (anti-teleportation)"
	imp_type = /obj/item/implant/exile/noteleport

/obj/item/implantcase/exile
	name = "implant case - 'Exile'"
	desc = "A glass case containing an exile implant."
	imp_type = /obj/item/implant/exile

/obj/item/implantcase/exile/noteleport
	name = "implant case - 'Anti-Teleportation'"
	desc = "A glass case containing an anti-teleportation implant."
	imp_type = /obj/item/implant/exile/noteleport

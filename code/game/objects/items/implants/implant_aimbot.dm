
/obj/item/implant/aimbot
	name = "имплант боевого ассистента"
	desc = "Когда уж очень хочется попасть в цель."
	actions_types = null
	activated = FALSE

/obj/item/implant/aimbot/implant(mob/living/target, mob/user, silent = FALSE, force = FALSE)
	. = ..()
	if(!. || !ismob(target))
		return FALSE

	target.AddComponent(/datum/component/ai_supported_combat)

	return TRUE

/obj/item/implant/aimbot/removed(mob/target, silent = FALSE, special = 0)
	. = ..()
	if(!. || !ismob(target))
		return FALSE

	var/datum/component/C = target.GetComponent(/datum/component/ai_supported_combat)
	if(C)
		qdel(C)

	return TRUE

/obj/item/implant/aimbot/can_be_implanted_in(mob/living/target)
	return TRUE

/obj/item/implantcase/aimbot
	name = "микроимплант - 'Ассистирование в бою'"
	desc = "Помогает при наведении."
	imp_type = /obj/item/implant/aimbot

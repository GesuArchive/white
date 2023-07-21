/obj/item/implant/mindshield
	name = "микроимплант щита разума"
	desc = "Защищает от промывки мозгов при помощи сертефицированной НТ промывкой мозгов."
	activated = 0
	actions_types = null

/obj/item/implant/mindshield/get_data()
	var/dat = {"<b>Спецификация импланта:</b><BR>
				<b>Название:</b> Имплантат лояльности сотрудника НаноТрейзен<BR>
				<b>Срок службы:</b> 10 лет.<BR>
				<b>Важные замечания:</b> Персонал, которому вводится это устройство, гораздо более устойчив к промыванию мозгов.<BR>
				<HR>
				<b>Детали имплантации:</b><BR>
				<b>Техническое описание:</b> Содержит небольшой набор наноботов, который защищает психические функции хозяина от манипуляций.<BR>
				<b>Спец свойства:</b> Предотвратит и вылечит большинство форм промывания мозгов.<BR>
				<b>Целостность:</b> Имплантат прослужит до тех пор, пока нанороботы находятся в кровотоке."}
	return dat


/obj/item/implant/mindshield/implant(mob/living/target, mob/user, silent = FALSE, force = FALSE)
	if(..())
		if(!target.mind)
			ADD_TRAIT(target, TRAIT_MINDSHIELD, "implant")
			target.sec_hud_set_implants()
			return TRUE
		var/deconverted = FALSE
		if(target.mind.has_antag_datum(/datum/antagonist/brainwashed))
			target.mind.remove_antag_datum(/datum/antagonist/brainwashed)
			deconverted = TRUE

		if(target.mind.has_antag_datum(/datum/antagonist/rev/head)|| target.mind.unconvertable)
			if(!silent)
				target.visible_message(span_warning("[target] сопротивляется воздействию импланта!") , span_warning("Чувствую, что что-то пытается вмешаться в мое подсознание, но я сопротивляетесь этому!"))
			removed(target, 1)
			qdel(src)
			return TRUE //the implant is still used

		var/datum/antagonist/rev/rev = target.mind.has_antag_datum(/datum/antagonist/rev)
		if(rev)
			deconverted = TRUE
			rev.remove_revolutionary(FALSE, user)
		if(!silent)
			if(target.mind in SSticker.mode.cult)
				to_chat(target, span_warning("Чувствую, что что-то пытается вмешаться в мое подсознание, но я сопротивляетесь этому!"))
			else
				to_chat(target, span_notice("Я испытываю чувство покоя и безопасности. Теперь я защищен от промывания мозгов."))
		ADD_TRAIT(target, TRAIT_MINDSHIELD, "implant")
		target.sec_hud_set_implants()
		if(deconverted)
			if(prob(1) || SSevents.holidays && SSevents.holidays[APRIL_FOOLS])
				target.say("Только не по почкам!", forced = "Только не по почкам!")
		return TRUE
	return FALSE

/obj/item/implant/mindshield/removed(mob/target, silent = FALSE, special = 0)
	if(..())
		if(isliving(target))
			var/mob/living/L = target
			REMOVE_TRAIT(L, TRAIT_MINDSHIELD, "implant")
			L.sec_hud_set_implants()
		if(target.stat != DEAD && !silent)
			to_chat(target, span_boldnotice("Мой разум внезапно чувствует себя ужасно уязвимым. Я больше не застрахован от промывания мозгов!"))
		return TRUE
	return FALSE

/obj/item/implanter/mindshield
	name = "имплантер щита разума"
	desc = "Защищает от промывки мозгов при помощи сертефицированной НТ промывкой мозгов."
	imp_type = /obj/item/implant/mindshield

/obj/item/implantcase/mindshield
	name = "футляр микроимпланта щита разума"
	desc = "Защищает от промывки мозгов при помощи сертефицированной НТ промывкой мозгов."
	imp_type = /obj/item/implant/mindshield

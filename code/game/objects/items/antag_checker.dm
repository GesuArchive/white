/obj/item/antag_checker
	name = "Анализатор инокомсыслия"
	desc = "Новейшая разработка НаноТрэйзен по борьбе с вражескими агентами. Позволяет узнать преданность человека корпорации на основе хитрой стимуляции коры мозга."
	icon = 'icons/obj/antag_checker.dmi'
	icon_state = "antagchecker"

/obj/item/antag_checker/attack(mob/living/H, mob/user)
	if(!iscarbon(H))
		return

	if(!H.stat == DEAD)
		to_chat(user, span_notice("Цель слишком живая для такого 'анализа'."))
		return

	flick("[icon_state]-scan", src)
	playsound(src, 'sound/items/drill_use.ogg', 100)
	if(do_after(user, 5 SECONDS, H))
		H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 50) //сверлим мозг
		playsound(src, 'sound/machines/ping.ogg', 100)
		if(H?.mind?.has_antag_datum(/datum/antagonist, TRUE))
			to_chat(user, span_warning("ОБНАРУЖЕНО ОТКЛОНЕНИЕ ОТ ОБЩЕСТВЕННЫХ НОРМ."))
		else
			to_chat(user, span_notice("ЦЕЛЬ СОЦИАЛЬНО СТАБИЛЬНА."))

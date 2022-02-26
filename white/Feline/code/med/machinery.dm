//	Устройство добавляющее ремни к стазисной кровати
//	Улучшение стазиса ремнями

/obj/item/handbeltsmodif
	name = "Комплект модернизации: Энергетические ремни"
	desc = "Комплект для установки генератора силового поля на стазисную кровать. Прожекторы создают энергетические ремни, фиксирующие пациента на стазис-кровати и не дающие ему встать, пока лечащий врач не разрешит. Или пока энергия не закончится."
	icon = 'icons/obj/module.dmi'
	icon_state = "holodisk"

/obj/machinery/stasis/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/handbeltsmodif))
		if(!handbeltsmod)
			handbeltsmod = TRUE
			add_overlay(handbeltsmod_overlay)
			to_chat(user, span_notice("Устанавливаю генератор силового поля на стазис-кровать, теперь на ней можно фиксировать пациентов."))
			playsound(src.loc, 'sound/machines/click.ogg', 50, TRUE)
			qdel(W)
		else
			to_chat(user, span_warning("Здесь уже устанавлена эта модификация."))

//	Освобождение

/obj/machinery/stasis/user_unbuckle_mob(mob/living/buckled_mob, mob/living/user)
	if(has_buckled_mobs())
		for(var/buck in buckled_mobs)
			var/mob/living/M = buck

			if(M != user)
				M.visible_message(span_notice("[user.name] отстегивает [skloname(M.name, VINITELNI, M.gender)] от удерживающих ремней.") ,\
					span_notice("[user.name] освобождает меня."))
			else
				if(handbeltsmod)
					if(handbeltsmod_active)
						M.visible_message(span_warning("[M.name] пытается вырваться из удерживающих его ремней!") ,\
							span_notice("Пытаюсь освободиться от удерживающих меня ремней!"))
						if(!do_after(M, 60 SECONDS, target = src))
							if(M?.buckled)
								to_chat(M, span_warning("Не получается!"))
							return
						if(!M.buckled)
							return
						M.visible_message(span_warning("[M.name] вырватается из удерживающих его ремней!") ,\
							span_notice("У меня получилось освободиться!"))

			unbuckle_mob(M)
			if(handbeltsmod_active)
				playsound(src.loc, 'sound/weapons/saberoff.ogg', 50, TRUE)
			handbeltsmod_active = FALSE
			M.layer = initial(M.layer)	//	Возвращение отображения космонавтика к изначальным параметрам
			M.plane = initial(M.plane)
			cut_overlay(handbeltsmod_active_overlay)

// Активация ремней
/obj/machinery/stasis/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	var/mob/living/carbon/human/victim = occupant
	if(handbeltsmod)
		if(occupant)
			if(ishuman(occupant))
				if(!handbeltsmod_active)
					user.visible_message(span_alert("Пытается включить энергетические ремни, чтобы зафиксировать [skloname(victim.name, DATELNI, victim.gender)]!"),\
										span_notice("Включаю энергетические ремни..."))
					if(!do_after(user, 2 SECONDS, target = victim))
						return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
					if(occupant != victim)
						to_chat(user, span_notice("Ой, а куда он делся?.."))
						return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
					to_chat(user, span_warning("[src.name] проецирует вокруг [skloname(victim.name, VINITELNI, victim.gender)] энергетические ремни, надёжно фиксируя его!"))
					log_combat(src, victim, "handcuffed", src.name)
					playsound(src.loc, 'sound/weapons/saberon.ogg', 50, TRUE)
					victim.layer = BELOW_MOB_LAYER
					victim.plane = GAME_PLANE	//	Изменение отображения космонавтика на -6
					add_overlay(handbeltsmod_active_overlay)
					handbeltsmod_active = TRUE
				else
					to_chat(user, span_noticeital("Энергетические ремни рассеиваются, и более не удерживают [skloname(victim.name, VINITELNI, victim.gender)]."))
					log_combat(src, victim, "handcuffed", src.name)
					playsound(src.loc, 'sound/weapons/saberoff.ogg', 50, TRUE)
					handbeltsmod_active = FALSE
					victim.layer = initial(victim.layer)	//	Возвращение отображения космонавтика к изначальным параметрам
					victim.plane = initial(victim.plane)
					cut_overlay(handbeltsmod_active_overlay)
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
		else
			to_chat(user, span_notice("Некого фиксировать! Уложите пациента на стазис-кровать и потом включайте ремни."))
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

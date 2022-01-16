//	Устройство добавляющее ремни к стазисной кровати
//	Улучшение стазиса ремнями

/obj/item/handbeltsmodif
	name = "Комплект модернизации: Энергетические ремни"
	desc = "Добавляет к стазисной кровати энергетические плети хватающие добычу и удерживающие ее в различных интересных позах, кажется вы уже видели что-то подобное в каком-то древнем анимационном журнале с девочками-волшебницами..."
	icon = 'icons/obj/module.dmi'
	icon_state = "holodisk"

/obj/machinery/stasis/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/handbeltsmodif))
		if(!handbeltsmod)
			handbeltsmod = TRUE
			to_chat(user, span_notice("Устанавливаю програмное обеспечение для модификации энергетических захватов."))
			playsound(src.loc, 'sound/machines/click.ogg', 50, TRUE)
			qdel(W)
		else
			to_chat(user, span_warning("Здесь уже устанавлена эта модификация."))

//	Освобождение

/obj/machinery/stasis/user_unbuckle_mob(mob/living/buckled_mob, mob/living/user)
	if(has_buckled_mobs())
		for(var/buck in buckled_mobs) //breaking a nest releases all the buckled mobs, because the nest isn't holding them down anymore
			var/mob/living/M = buck

			if(M != user)
				M.visible_message(span_notice("[user.name] отстегивает [skloname(M.name, VINITELNI, M.gender)] от удерживающих ремней.") ,\
					span_notice("[user.name] освобождает меня."))
			else
				if(handbeltsmod)
					if(handbeltsmod_active)
						M.visible_message(span_warning("[M.name] пытается вырваться из удерживающих его ремней!") ,\
							span_notice("Пытаюсь освободиться от удерживающих меня ремней!"))
						if(!do_after(M, 600, target = src))
							if(M?.buckled)
								to_chat(M, span_warning("Не получается!"))
							return
						if(!M.buckled)
							return
						M.visible_message(span_warning("[M.name] вырватается из удерживающих его ремней!") ,\
							span_notice("У меня получилось освободиться!"))

			unbuckle_mob(M)
			handbeltsmod_active = FALSE

//	Активация

/obj/machinery/stasis/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	var/mob/living/carbon/human/victim = occupant
	if(handbeltsmod)
		if(occupant)
			if(ishuman(occupant))
				if(!handbeltsmod_active)
					to_chat(user, span_warning("Из боковых разъемов выскальзывают энергетические ремни и надежно фиксируют [skloname(victim.name, VINITELNI, victim.gender)]!"))
					log_combat(src, victim, "handcuffed")
					playsound(src.loc, 'sound/weapons/whipgrab.ogg', 50, TRUE)
					handbeltsmod_active = TRUE
				else
					to_chat(user, span_warning("Ремни уже оплели тело [skloname(victim.name, RODITELNI, victim.gender)], пациент надежно зафиксирован!"))
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
		else
			to_chat(user, span_notice("Из боковых разъемов выскальзывают энергетические ремни, но порыскав в поисках жертвы никого не обнаруживают!"))
			playsound(src.loc, 'sound/weapons/whip.ogg', 50, TRUE)
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

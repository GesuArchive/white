/**********************Lazarus Injector**********************/
/obj/item/lazarus_injector
	name = "инъектор Лазаря"
	desc = "Инъектор с коктейлем из наномашин и химических веществ. Он может воскрешать животных из мертвых, заставляя их становиться дружелюбными по отношению к пользователю. К сожалению, этот процесс бесполезен для высших форм жизни и невероятно дорог, поэтому эти инъекторы лежали на складе, пока один из руководителей не решил, что они станут отличной мотивацией для некоторых сотрудников."
	icon = 'icons/obj/syringe.dmi'
	icon_state = "lazarus_hypo"
	inhand_icon_state = "hypo"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 5
	var/loaded = 1
	var/malfunctioning = 0
	var/revive_type = SENTIENCE_ORGANIC //So you can't revive boss monsters or robots with it

/obj/item/lazarus_injector/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(!loaded)
		return
	if(isliving(target) && proximity_flag)
		if(isanimal(target))
			var/mob/living/simple_animal/M = target
			if(M.sentience_type != revive_type)
				to_chat(user, span_info("[capitalize(src.name)] не действует на данный вид существ."))
				return
			if(M.stat == DEAD)
				M.faction = list("neutral")
				M.revive(full_heal = TRUE, admin_revive = TRUE)
				if(ishostile(target))
					var/mob/living/simple_animal/hostile/H = M
					if(malfunctioning)
						H.faction |= list("lazarus", "[REF(user)]")
						H.robust_searching = 1
						H.friends += user
						H.attack_same = 1
						log_game("[key_name(user)] has revived hostile mob [key_name(target)] with a malfunctioning lazarus injector")
					else
						H.attack_same = 0
				loaded = 0
				user.visible_message(span_notice("[user] производит инъекцию препарата в [M], воскрешая его."))
				SSblackbox.record_feedback("tally", "lazarus_injector", 1, M.type)
				playsound(src,'sound/effects/refill.ogg',50,TRUE)
				icon_state = "lazarus_empty"
				return
			else
				to_chat(user, span_info("[capitalize(src.name)] работает только на мертвых существ."))
				return
		else
			to_chat(user, span_info("[capitalize(src.name)] работает только на примитивных существ."))
			return

/obj/item/lazarus_injector/emp_act()
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(!malfunctioning)
		malfunctioning = 1

/obj/item/lazarus_injector/examine(mob/user)
	. = ..()
	if(!loaded)
		. += "<hr><span class='info'>[capitalize(src.name)] пуст.</span>"
	if(malfunctioning)
		. += "<hr><span class='info'>Дисплей мигает и сбоит.</span>"

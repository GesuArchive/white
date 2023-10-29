///////////////////////////////////
////////  Mecha wreckage   ////////
///////////////////////////////////


/obj/structure/mecha_wreckage
	name = "остов экзокостюма"
	desc = "Остатки какого-то полностью уничтоженного экзокостюма. Абсолютно неремонтопригоден, но, возможно, удастся спасти пару деталей."
	icon = 'icons/mecha/mecha.dmi'
	density = TRUE
	anchored = FALSE
	opacity = FALSE
	var/list/welder_salvage = list(/obj/item/stack/sheet/plasteel, /obj/item/stack/sheet/iron, /obj/item/stack/rods)
	var/salvage_num = 5
	var/list/crowbar_salvage = list()
	var/wires_removed = FALSE
	var/mob/living/silicon/ai/AI //AIs to be salvaged
	var/list/parts

/obj/structure/mecha_wreckage/Initialize(mapload, mob/living/silicon/ai/AI_pilot)
	. = ..()
	if(parts)
		for(var/i in 1 to 2)
			if(!parts.len)
				break
			if(prob(60))
				continue
			var/part = pick(parts)
			welder_salvage += part
		parts = null
	if(!AI_pilot) //Type-checking for this is already done in mecha/Destroy()
		return
	AI = AI_pilot
	AI.apply_damage(150, BURN) //Give the AI a bit of damage from the "shock" of being suddenly shut down
	INVOKE_ASYNC(AI, TYPE_PROC_REF(/mob/living/silicon, death)) //The damage is not enough to kill the AI, but to be 'corrupted files' in need of repair.
	AI.forceMove(src) //Put the dead AI inside the wreckage for recovery
	add_overlay(mutable_appearance('icons/obj/projectiles.dmi', "green_laser")) //Overlay for the recovery beacon
	AI.controlled_equipment = null
	AI.remote_control = null

/obj/structure/mecha_wreckage/Destroy()
	if(AI)
		QDEL_NULL(AI)
	QDEL_LIST(crowbar_salvage)
	return ..()

/obj/structure/mecha_wreckage/examine(mob/user)
	. = ..()
	if(!AI)
		return
	. += "<hr><span class='notice'>Черный ящик восстановления ИИ активен.</span>"

/obj/structure/mecha_wreckage/welder_act(mob/living/user, obj/item/I)
	..()
	. = TRUE
	if(salvage_num <= 0 || !length(welder_salvage))
		to_chat(user, span_notice("Не видижу ничего, что можно было бы вырезать из [I]!"))
		return
	if(!I.use_tool(src, user, 0, volume=50))
		return
	if(prob(30))
		to_chat(user, span_notice("Не удалось спасти ничего ценного из [src]!"))
		return
	var/type = pick(welder_salvage)
	var/N = new type(get_turf(user))
	user.visible_message(span_notice("[user] вырезает [N] из [src].") , span_notice("Вырезаю [N] из [src]."))
	if(!istype(N, /obj/item/stack))
		welder_salvage -= type
	salvage_num--

/obj/structure/mecha_wreckage/wirecutter_act(mob/living/user, obj/item/I)
	..()
	. = TRUE
	if(wires_removed)
		to_chat(user, span_notice("Не вижу ничего ценного, что можно было бы отсоединить от [I]!"))
		return
	var/N = new /obj/item/stack/cable_coil(get_turf(user), rand(1,3))
	user.visible_message(span_notice("[user] отсоединяет [N] от [src].") , span_notice("Отсоединяю [N] от [src]."))
	wires_removed = TRUE

/obj/structure/mecha_wreckage/crowbar_act(mob/living/user, obj/item/I)
	..()
	. = TRUE
	if(crowbar_salvage.len)
		var/obj/S = pick(crowbar_salvage)
		S.forceMove(user.drop_location())
		user.visible_message(span_notice("[user] выламывает [S] из [src].") , span_notice("Выламываю [S] из [src]."))
		crowbar_salvage -= S
		return
	to_chat(user, span_notice("Не вижу ничего ценного, что можно было бы отсоединить от [I]!"))

/obj/structure/mecha_wreckage/transfer_ai(interaction, mob/user, null, obj/item/aicard/card)
	if(!..())
		return

	//Proc called on the wreck by the AI card.
	if(interaction != AI_TRANS_TO_CARD) //AIs can only be transferred in one direction, from the wreck to the card.
		return
	if(!AI) //No AI in the wreck
		to_chat(user, span_warning("Черный ящик пуст."))
		return
	cut_overlays() //Remove the recovery beacon overlay
	AI.forceMove(card) //Move the dead AI to the card.
	card.AI = AI
	if(AI.client) //AI player is still in the dead AI and is connected
		to_chat(AI, span_notice("Остатки вашей файловой системы были восстановлены на мобильном устройстве хранения данных."))
	else //Give the AI a heads-up that it is probably going to get fixed.
		AI.notify_ghost_cloning("Вас извлекли из-под обломков!", source = card)
	to_chat(user, "<span class='boldnotice'>Восстановленные файлы резервных копий</span>: [AI.name] ([rand(1000,9999)].exe) извлечены из [name] и сохранены в локальной памяти.")
	AI = null

/obj/structure/mecha_wreckage/gygax
	name = "остов Гигакса"
	icon_state = "gygax-broken"
	parts = list(
				/obj/item/mecha_parts/part/gygax_torso,
				/obj/item/mecha_parts/part/gygax_head,
				/obj/item/mecha_parts/part/gygax_left_arm,
				/obj/item/mecha_parts/part/gygax_right_arm,
				/obj/item/mecha_parts/part/gygax_left_leg,
				/obj/item/mecha_parts/part/gygax_right_leg
				)

/obj/structure/mecha_wreckage/gygax/dark
	name = "остов темного Гигакса"
	icon_state = "darkgygax-broken"

/obj/structure/mecha_wreckage/marauder
	name = "остов Марадера"
	icon_state = "marauder-broken"

/obj/structure/mecha_wreckage/mauler
	name = "остов Маулера"
	icon_state = "mauler-broken"
	desc = "Руководство Синдиката не обрадуется..."

/obj/structure/mecha_wreckage/seraph
	name = "остов Серафима"
	icon_state = "seraph-broken"

/obj/structure/mecha_wreckage/reticence
	name = "Reticence wreckage"
	icon_state = "reticence-broken"
	color = "#87878715"
	desc = "..."

/obj/structure/mecha_wreckage/ripley
	name = "остов Рипли"
	icon_state = "ripley-broken"
	parts = list(
				/obj/item/mecha_parts/part/ripley_torso,
				/obj/item/mecha_parts/part/ripley_left_arm,
				/obj/item/mecha_parts/part/ripley_right_arm,
				/obj/item/mecha_parts/part/ripley_left_leg,
				/obj/item/mecha_parts/part/ripley_right_leg)

/obj/structure/mecha_wreckage/ripley/mk2
	name = "остов Рипли МК-II"
	icon_state = "ripleymkii-broken"

/obj/structure/mecha_wreckage/clarke
	name = "остов Кларка"
	icon_state = "clarke-broken"
	parts = list(
				/obj/item/mecha_parts/part/clarke_torso,
				/obj/item/mecha_parts/part/clarke_head,
				/obj/item/mecha_parts/part/clarke_left_arm,
				/obj/item/mecha_parts/part/clarke_right_arm,
				/obj/item/stack/conveyor)

/obj/structure/mecha_wreckage/ripley/deathripley
	name = "остов Рипера"
	icon_state = "deathripley-broken"
	parts = null

/obj/structure/mecha_wreckage/honker
	name = "остов Х.О.Н.К.а"
	icon_state = "honker-broken"
	desc = "All is right in the universe."
	parts = list(
				/obj/item/mecha_parts/part/honker_torso,
				/obj/item/mecha_parts/part/honker_head,
				/obj/item/mecha_parts/part/honker_left_arm,
				/obj/item/mecha_parts/part/honker_right_arm,
				/obj/item/mecha_parts/part/honker_left_leg,
				/obj/item/mecha_parts/part/honker_right_leg)

/obj/structure/mecha_wreckage/durand
	name = "остов Дюранда"
	icon_state = "durand-broken"
	parts = list(
			/obj/item/mecha_parts/part/durand_torso,
			/obj/item/mecha_parts/part/durand_head,
			/obj/item/mecha_parts/part/durand_left_arm,
			/obj/item/mecha_parts/part/durand_right_arm,
			/obj/item/mecha_parts/part/durand_left_leg,
			/obj/item/mecha_parts/part/durand_right_leg)

/obj/structure/mecha_wreckage/phazon
	name = "остов Фазона"
	icon_state = "phazon-broken"
	parts = list(
		/obj/item/mecha_parts/part/phazon_torso,
		/obj/item/mecha_parts/part/phazon_head,
		/obj/item/mecha_parts/part/phazon_left_arm,
		/obj/item/mecha_parts/part/phazon_right_arm,
		/obj/item/mecha_parts/part/phazon_left_leg,
		/obj/item/mecha_parts/part/phazon_right_leg)

/obj/structure/mecha_wreckage/savannah_ivanov
	name = "остов Саванна-Иванова"
	icon = 'icons/mecha/coop_mech.dmi'
	icon_state = "savannah_ivanov-broken"
	parts = list(
		/obj/item/mecha_parts/part/savannah_ivanov_torso,
		/obj/item/mecha_parts/part/savannah_ivanov_head,
		/obj/item/mecha_parts/part/savannah_ivanov_left_arm,
		/obj/item/mecha_parts/part/savannah_ivanov_right_arm,
		/obj/item/mecha_parts/part/savannah_ivanov_left_leg,
		/obj/item/mecha_parts/part/savannah_ivanov_right_leg)

/obj/structure/mecha_wreckage/odysseus
	name = "остов Одиссея"
	icon_state = "odysseus-broken"
	parts = list(
			/obj/item/mecha_parts/part/odysseus_torso,
			/obj/item/mecha_parts/part/odysseus_head,
			/obj/item/mecha_parts/part/odysseus_left_arm,
			/obj/item/mecha_parts/part/odysseus_right_arm,
			/obj/item/mecha_parts/part/odysseus_left_leg,
			/obj/item/mecha_parts/part/odysseus_right_leg)

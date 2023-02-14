/obj/structure/ai_core
	density = TRUE
	anchored = FALSE
	name = "ядро ИИ"
	icon = 'icons/mob/ai.dmi'
	icon_state = "0"
	desc = "The framework for an artificial intelligence core."
	max_integrity = 500
	var/state = EMPTY_CORE
	var/datum/ai_laws/laws
	var/obj/item/circuitboard/aicore/circuit
	var/obj/item/mmi/brain
	var/can_deconstruct = TRUE

/obj/structure/ai_core/Initialize(mapload)
	. = ..()
	laws = new
	laws.set_laws_config()

/obj/structure/ai_core/handle_atom_del(atom/A)
	if(A == circuit)
		circuit = null
		if((state != GLASS_CORE) && (state != AI_READY_CORE))
			state = EMPTY_CORE
			update_icon()
	if(A == brain)
		brain = null
	return ..()


/obj/structure/ai_core/Destroy()
	QDEL_NULL(circuit)
	QDEL_NULL(brain)
	QDEL_NULL(laws)
	return ..()

/obj/structure/ai_core/deactivated
	name = "неактивный ИИ"
	icon_state = "ai-empty"
	anchored = TRUE
	state = AI_READY_CORE

/obj/structure/ai_core/deactivated/Initialize(mapload)
	. = ..()
	circuit = new(src)

/obj/structure/ai_core/latejoin_inactive
	name = "ядро ИИ в режиме ожидания"
	desc = "Этот ИИ находится в режиме обновления и самодиагностики, полоска загрузки стоит на месте. Этот процесс может длится как минуту, так и несколько лет."
	can_deconstruct = FALSE
	icon_state = "ai-empty"
	anchored = TRUE
	state = AI_READY_CORE
	var/available = TRUE
	var/safety_checks = TRUE
	var/active = TRUE

/obj/structure/ai_core/latejoin_inactive/Initialize(mapload)
	. = ..()
	circuit = new(src)
	GLOB.latejoin_ai_cores += src

/obj/structure/ai_core/latejoin_inactive/Destroy()
	GLOB.latejoin_ai_cores -= src
	return ..()

/obj/structure/ai_core/latejoin_inactive/examine(mob/user)
	. = ..()
	. += "<hr>Питание <b>[active? "включено" : "выключено"]</b>."
	. += "<hr><span class='notice'>Думаю я смогу [active? "выключить" : "включить"] его при помощи мультитула.</span>"

/obj/structure/ai_core/latejoin_inactive/proc/is_available()			//If people still manage to use this feature to spawn-kill AI latejoins ahelp them.
	if(!available)
		return FALSE
	if(!safety_checks)
		return TRUE
	if(!active)
		return FALSE
	var/turf/T = get_turf(src)
	var/area/A = get_area(src)
	if(!(A.area_flags & BLOBS_ALLOWED))
		return FALSE
	if(!A.power_equip)
		return FALSE
	if(!SSmapping.level_trait(T.z,ZTRAIT_STATION))
		return FALSE
	if(!istype(T, /turf/open/floor))
		return FALSE
	return TRUE

/obj/structure/ai_core/latejoin_inactive/attackby(obj/item/P, mob/user, params)
	if(P.tool_behaviour == TOOL_MULTITOOL)
		active = !active
		to_chat(user, span_notice("[active? "Активирую" : "Деактивирую"] питание <b>[src.name]</b>."))
		return
	return ..()

/obj/structure/ai_core/attackby(obj/item/P, mob/user, params)
	if(P.tool_behaviour == TOOL_WRENCH)
		return default_unfasten_wrench(user, P, 20)
	if(!anchored)
		if(P.tool_behaviour == TOOL_WELDER && can_deconstruct)
			if(state != EMPTY_CORE)
				to_chat(user, span_warning("Для разборки ядро должно быть пустым!"))
				return

			if(!P.tool_start_check(user, amount=0))
				return

			to_chat(user, span_notice("Начинаю разбирать раму..."))
			if(P.use_tool(src, user, 20, volume=50) && state == EMPTY_CORE)
				to_chat(user, span_notice("Разбираю раму."))
				deconstruct(TRUE)
			return
	else
		switch(state)
			if(EMPTY_CORE)
				if(istype(P, /obj/item/circuitboard/aicore))
					if(!user.transferItemToLoc(P, src))
						return
					playsound(loc, 'sound/items/deconstruct.ogg', 50, TRUE)
					to_chat(user, span_notice("Помещаю внутрь незакрепленную плату."))
					update_icon()
					state = CIRCUIT_CORE
					circuit = P
					return
			if(CIRCUIT_CORE)
				if(P.tool_behaviour == TOOL_SCREWDRIVER)
					P.play_tool_sound(src)
					to_chat(user, span_notice("Прикручиваю плату на место."))
					state = SCREWED_CORE
					update_icon()
					return
				if(P.tool_behaviour == TOOL_CROWBAR)
					P.play_tool_sound(src)
					to_chat(user, span_notice("Извлекаю плату."))
					state = EMPTY_CORE
					update_icon()
					circuit.forceMove(loc)
					circuit = null
					return
			if(SCREWED_CORE)
				if(P.tool_behaviour == TOOL_SCREWDRIVER && circuit)
					P.play_tool_sound(src)
					to_chat(user, span_notice("Откручиваю плату."))
					state = CIRCUIT_CORE
					update_icon()
					return
				if(istype(P, /obj/item/stack/cable_coil))
					var/obj/item/stack/cable_coil/C = P
					if(C.get_amount() >= 5)
						playsound(loc, 'sound/items/deconstruct.ogg', 50, TRUE)
						to_chat(user, span_notice("Начинаю добавлять провода..."))
						if(do_after(user, 20, target = src) && state == SCREWED_CORE && C.use(5))
							to_chat(user, span_notice("Добавляю провода."))
							state = CABLED_CORE
							update_icon()
					else
						to_chat(user, span_warning("Мне понадобится по крайней мере 5 метров кабеля для этого!"))
					return
			if(CABLED_CORE)
				if(P.tool_behaviour == TOOL_WIRECUTTER)
					if(brain)
						to_chat(user, span_warning("Сначала извлеките носитель с [brain.name]!"))
					else
						P.play_tool_sound(src)
						to_chat(user, span_notice("Удаляю провода."))
						state = SCREWED_CORE
						update_icon()
						new /obj/item/stack/cable_coil(drop_location(), 5)
					return

				if(istype(P, /obj/item/stack/sheet/rglass))
					var/obj/item/stack/sheet/rglass/G = P
					if(G.get_amount() >= 2)
						playsound(loc, 'sound/items/deconstruct.ogg', 50, TRUE)
						to_chat(user, span_notice("Начинаю устанавливать бронестекло..."))
						if(do_after(user, 20, target = src) && state == CABLED_CORE && G.use(2))
							to_chat(user, span_notice("Устанавливаю бронестекло на свое место."))
							state = GLASS_CORE
							update_icon()
					else
						to_chat(user, span_warning("Мне понадобится по крайней мере 2 листа бронестекла!"))
					return

				if(istype(P, /obj/item/ai_module))
					if(brain && brain.laws.id != DEFAULT_AI_LAWID)
						to_chat(user, span_warning("Носитель с [brain.name] уже имеет записанные законы!"))
						return
					var/obj/item/ai_module/module = P
					module.install(laws, user)
					return

				if(istype(P, /obj/item/mmi) && !brain)
					var/obj/item/mmi/M = P
					if(!M.brain_check(user))
						return

					var/mob/living/brain/B = M.brainmob
					if(!CONFIG_GET(flag/allow_ai) || (is_banned_from(B.ckey, JOB_AI) && !QDELETED(src) && !QDELETED(user) && !QDELETED(M) && !QDELETED(user) && Adjacent(user)))
						if(!QDELETED(M))
							to_chat(user, span_warning("Беспорядочные нейронные импульсы [M.name] вызовут помехи в работе ИИ! Кажется этот носитель не подходит для этой роли!"))
						return
					if(!user.transferItemToLoc(M,src))
						return

					brain = M
					to_chat(user, span_notice("Помещаю носитель с [M.name] в корпус."))
					update_icon()
					return

				if(P.tool_behaviour == TOOL_CROWBAR && brain)
					P.play_tool_sound(src)
					to_chat(user, span_notice("Извлекаю носитель."))
					brain.forceMove(loc)
					brain = null
					update_icon()
					return

			if(GLASS_CORE)
				if(P.tool_behaviour == TOOL_CROWBAR)
					P.play_tool_sound(src)
					to_chat(user, span_notice("Извлекаю бронестекло."))
					state = CABLED_CORE
					update_icon()
					new /obj/item/stack/sheet/rglass(loc, 2)
					return

				if(P.tool_behaviour == TOOL_SCREWDRIVER)
					P.play_tool_sound(src)
					to_chat(user, span_notice("Подключаю монитор."))
					if(brain)
						var/mob/living/brain/B = brain.brainmob
						SSticker.mode.remove_antag_for_borging(B.mind)

						var/mob/living/silicon/ai/A = null

						if (brain.overrides_aicore_laws)
							A = new /mob/living/silicon/ai(loc, brain.laws, B)
							brain.laws = null //Brain's law datum is being donated, so we need the brain to let it go or the GC will eat it
						else
							A = new /mob/living/silicon/ai(loc, laws, B)
							laws = null //we're giving the new AI this datum, so let's not delete it when we qdel(src) 5 lines from now

						if(brain.force_replace_ai_name)
							A.fully_replace_character_name(A.name, brain.replacement_ai_name())
						SSblackbox.record_feedback("amount", "ais_created", 1)
						deadchat_broadcast(" включается в зоне <b>[get_area_name(A, TRUE)]</b>.", span_name("[A]") , follow_target=A, message_type=DEADCHAT_ANNOUNCEMENT)
						qdel(src)
					else
						state = AI_READY_CORE
						update_icon()
					return

			if(AI_READY_CORE)
				if(istype(P, /obj/item/aicard))
					return //handled by /obj/structure/ai_core/transfer_ai()

				if(P.tool_behaviour == TOOL_SCREWDRIVER)
					P.play_tool_sound(src)
					to_chat(user, span_notice("Отключаю монитор."))
					state = GLASS_CORE
					update_icon()
					return
	return ..()

/obj/structure/ai_core/update_icon_state()
	. = ..()
	switch(state)
		if(EMPTY_CORE)
			icon_state = "0"
		if(CIRCUIT_CORE)
			icon_state = "1"
		if(SCREWED_CORE)
			icon_state = "2"
		if(CABLED_CORE)
			if(brain)
				icon_state = "3b"
			else
				icon_state = "3"
		if(GLASS_CORE)
			icon_state = "4"
		if(AI_READY_CORE)
			icon_state = "ai-empty"

/obj/structure/ai_core/deconstruct(disassembled = TRUE)
	if(state == GLASS_CORE)
		new /obj/item/stack/sheet/rglass(loc, 2)
	if(state >= CABLED_CORE)
		new /obj/item/stack/cable_coil(loc, 5)
	if(circuit)
		circuit.forceMove(loc)
		circuit = null
	new /obj/item/stack/sheet/plasteel(loc, 4)
	qdel(src)

/*
This is a good place for AI-related object verbs so I'm sticking it here.
If adding stuff to this, don't forget that an AI need to cancel_camera() whenever it physically moves to a different location.
That prevents a few funky behaviors.
*/
//The type of interaction, the player performing the operation, the AI itself, and the card object, if any.


/atom/proc/transfer_ai(interaction, mob/user, mob/living/silicon/ai/AI, obj/item/aicard/card)
	if(istype(card))
		if(card.flush)
			to_chat(user, span_alert("ERROR: AI flush is in progress, cannot execute transfer protocol."))
			return FALSE
	return TRUE

/obj/structure/ai_core/transfer_ai(interaction, mob/user, mob/living/silicon/ai/AI, obj/item/aicard/card)
	if(state != AI_READY_CORE || !..())
		return
	//Transferring a carded AI to a core.
	if(interaction == AI_TRANS_FROM_CARD)
		AI.control_disabled = FALSE
		AI.radio_enabled = TRUE
		AI.forceMove(loc) // to replace the terminal.
		to_chat(AI, span_notice("You have been uploaded to a stationary terminal. Remote device connection restored."))
		to_chat(user, "<span class='boldnotice'>Transfer successful</span>: [AI.name] ([rand(1000,9999)].exe) installed and executed successfully. Local copy has been removed.")
		card.AI = null
		AI.battery = circuit.battery
		qdel(src)
	else //If for some reason you use an empty card on an empty AI terminal.
		to_chat(user, span_alert("There is no AI loaded on this terminal."))

/obj/item/circuitboard/aicore
	name = "плата ядра ИИ"
	desc = "Плата помещаемая в корпус будущего ИИ в процессе строительства."
	var/battery = 500 //backup battery for when the AI loses power. Copied to/from AI mobs when carding, and placed here to avoid recharge via deconning the core

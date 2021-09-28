// Used for translating channels to tokens on examination
GLOBAL_LIST_INIT(channel_tokens, list(
	RADIO_CHANNEL_COMMON = RADIO_KEY_COMMON,
	RADIO_CHANNEL_SCIENCE = RADIO_TOKEN_SCIENCE,
	RADIO_CHANNEL_COMMAND = RADIO_TOKEN_COMMAND,
	RADIO_CHANNEL_MEDICAL = RADIO_TOKEN_MEDICAL,
	RADIO_CHANNEL_ENGINEERING = RADIO_TOKEN_ENGINEERING,
	RADIO_CHANNEL_SECURITY = RADIO_TOKEN_SECURITY,
	RADIO_CHANNEL_CENTCOM = RADIO_TOKEN_CENTCOM,
	RADIO_CHANNEL_SYNDICATE = RADIO_TOKEN_SYNDICATE,
	RADIO_CHANNEL_SUPPLY = RADIO_TOKEN_SUPPLY,
	RADIO_CHANNEL_EXPLORATION = RADIO_TOKEN_EXPLORATION,
	RADIO_CHANNEL_SERVICE = RADIO_TOKEN_SERVICE,
	MODE_BINARY = MODE_TOKEN_BINARY,
	RADIO_CHANNEL_AI_PRIVATE = RADIO_TOKEN_AI_PRIVATE
))

/obj/item/radio/headset
	name = "гарнитура"
	desc = "Обновленный, модульный интерком, который располагается над головой. Принимает ключи шифрования."
	icon_state = "headset"
	inhand_icon_state = "headset"
	worn_icon_state = null
	custom_materials = list(/datum/material/iron=75)
	subspace_transmission = TRUE
	canhear_range = 0 // can't hear headsets from very far away

	slot_flags = ITEM_SLOT_EARS
	var/obj/item/encryptionkey/keyslot2 = null
	dog_fashion = null
	var/radiosound = 'white/valtos/sounds/radio/common.ogg'

/obj/item/radio/headset/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] begins putting <b>[src.name]</b>'s antenna up [user.ru_ego()] nose! It looks like [user.p_theyre()] trying to give [user.ru_na()]self cancer!"))
	return TOXLOSS

/obj/item/radio/headset/examine(mob/user)
	. = ..()

	if(item_flags & IN_INVENTORY && loc == user)
		// construction of frequency description
		var/list/avail_chans = list("Используй [RADIO_KEY_COMMON] для текущей настроенной частоты.")
		if(translate_binary)
			avail_chans += "Используй [MODE_TOKEN_BINARY] для [MODE_BINARY]"
		if(length(channels))
			for(var/i in 1 to length(channels))
				if(i == 1)
					avail_chans += "Используй [MODE_TOKEN_DEPARTMENT] или [GLOB.channel_tokens[channels[i]]] для [lowertext(channels[i])]"
				else
					avail_chans += "Используй [GLOB.channel_tokens[channels[i]]] для [lowertext(channels[i])]"
		. += "<hr><span class='notice'>На небольшом экране гарнитуры отображаются следующие доступные частоты:\n[english_list(avail_chans)].</span>"

		if(command)
			. += "<hr><span class='info'>ПКМ для переключения режима высокой громкости вещания.</span>"
	else
		. += "<hr><span class='notice'>На гарнитуре мигает маленький экран, он слишком мал для чтения без удержания или ношения гарнитуры.</span>"

/obj/item/radio/headset/Initialize()
	. = ..()
	recalculateChannels()

/obj/item/radio/headset/Destroy()
	QDEL_NULL(keyslot2)
	return ..()

/obj/item/radio/headset/talk_into(mob/living/M, message, channel, list/spans, datum/language/language, list/message_mods)
	if (!listening)
		return ITALICS | REDUCE_RANGE
	if(ishuman(M) && radiosound)
		playsound(M, radiosound, rand(10, 20), 0, 0, 0)
	return ..()

/obj/item/radio/headset/can_receive(freq, level, AIuser)
	if(ishuman(src.loc))
		var/mob/living/carbon/human/H = src.loc
		if(H.ears == src)
			return ..(freq, level)
	else if(AIuser)
		return ..(freq, level)
	return FALSE

/obj/item/radio/headset/ui_data(mob/user)
	. = ..()
	.["headset"] = TRUE

/obj/item/radio/headset/syndicate //disguised to look like a normal headset for stealth ops
	radiosound = 'white/valtos/sounds/radio/syndie.ogg'

/obj/item/radio/headset/syndicate/alt //undisguised bowman with flash protection
	name = "гарнитура синдиката"
	desc = "Гарнитура, которая может использоваться для прослушивания всех радиочастот. Защищает уши от светошумовых гранат."
	icon_state = "syndie_headset"
	inhand_icon_state = "syndie_headset"

/obj/item/radio/headset/syndicate/alt/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))

/obj/item/radio/headset/syndicate/alt/leader
	name = "гарнитура лидера команды"
	command = TRUE

/obj/item/radio/headset/syndicate/Initialize()
	. = ..()
	make_syndie()

/obj/item/radio/headset/binary
/obj/item/radio/headset/binary/Initialize()
	. = ..()
	qdel(keyslot)
	keyslot = new /obj/item/encryptionkey/binary
	recalculateChannels()

/obj/item/radio/headset/headset_sec
	name = "гарнитура офицера"
	desc = "Это используется вашими элитными силами безопасности."
	icon_state = "sec_headset"
	keyslot = new /obj/item/encryptionkey/headset_sec
	radiosound = 'white/valtos/sounds/radio/security.ogg'

/obj/item/radio/headset/headset_sec/alt
	name = "гарнитура-бабочка офицера"
	desc = "Это используется вашими элитными силами безопасности. Защищает уши от светошумовых гранат."
	icon_state = "sec_headset_alt"
	inhand_icon_state = "sec_headset_alt"

/obj/item/radio/headset/headset_sec/alt/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))

/obj/item/radio/headset/headset_eng
	name = "инженерная гарнитура"
	desc = "Когда инженеры хотят поболтать, как девочки."
	icon_state = "eng_headset"
	keyslot = new /obj/item/encryptionkey/headset_eng

/obj/item/radio/headset/headset_rob
	name = "гарнитура роботехника"
	desc = "Сделано специально для робототехников, которые не могут выбирать между отделами."
	icon_state = "rob_headset"
	keyslot = new /obj/item/encryptionkey/headset_rob

/obj/item/radio/headset/headset_med
	name = "гарнитура медотсека"
	desc = "Гарнитура для обученного персонала медотсека."
	icon_state = "med_headset"
	keyslot = new /obj/item/encryptionkey/headset_med

/obj/item/radio/headset/headset_medsec
	name = "гарнитура полевого медика"
	desc = "Гарнитура для обученного персонала медотсека. С доступом к каналу охраны."
	icon_state = "med_headset"
	keyslot = new /obj/item/encryptionkey/headset_medsec

/obj/item/radio/headset/headset_sci
	name = "научная гарнитура"
	desc = "Научная гарнитура. Как обычно."
	icon_state = "sci_headset"
	keyslot = new /obj/item/encryptionkey/headset_sci

/obj/item/radio/headset/headset_medsci
	name = "гарнитура мед-исследователя"
	desc = "Гарнитура, которая является результатом спаривания медицины и науки."
	icon_state = "medsci_headset"
	keyslot = new /obj/item/encryptionkey/headset_medsci

/obj/item/radio/headset/headset_srvsec
	name = "гарнитура закона и порядка"
	desc = "В гарнитуре системы уголовного правосудия ключ шифрования представляет собой две отдельные, но не менее важные группы. Служба безопасности, которая расследует преступления, и секьюрити, которые предоставляют услуги. Это их связь."
	icon_state = "srvsec_headset"
	keyslot = new /obj/item/encryptionkey/headset_srvsec

/obj/item/radio/headset/headset_srvmed
	name = "psychology headset"
	desc = "A headset allowing the wearer to communicate with medbay and service."
	icon_state = "med_headset"
	keyslot = new /obj/item/encryptionkey/headset_srvmed

/obj/item/radio/headset/headset_com
	name = "гарнитура командования"
	desc = "Гарнитура с доступом к каналу командования."
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/headset_com

/obj/item/radio/headset/heads
	command = TRUE

/obj/item/radio/headset/heads/captain
	name = "капитанская гарнитура"
	desc = "Гарнитура короля или королевы."
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/heads/captain

/obj/item/radio/headset/heads/captain/alt
	name = "капитанская гарнитура-бабочка"
	desc = "Гарнитура босса. Защищает уши от светошумовых гранат."
	icon_state = "com_headset_alt"
	inhand_icon_state = "com_headset_alt"

/obj/item/radio/headset/heads/captain/alt/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))

/obj/item/radio/headset/heads/rd
	name = "гарнитура научного руководителя"
	desc = "Гарнитура того, кто держит общество в движении к технологической сингулярности."
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/heads/rd

/obj/item/radio/headset/heads/hos
	name = "гарнитура главы безопасности"
	desc = "Гарнитура человека, отвечающего за поддержание порядка и охрану станции."
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/heads/hos

/obj/item/radio/headset/heads/hos/alt
	name = "гарнитура-бабочка главы безопасности"
	desc = "Гарнитура человека, отвечающего за поддержание порядка и охрану станции. Защищает уши от светошумовых гранат."
	icon_state = "com_headset_alt"
	inhand_icon_state = "com_headset_alt"

/obj/item/radio/headset/heads/hos/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))

/obj/item/radio/headset/heads/ce
	name = "гарнитура старшего инженера"
	desc = "Гарнитура парня, отвечающего за поддержание станции в рабочем состоянии и неповрежденной."
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/heads/ce

/obj/item/radio/headset/heads/cmo
	name = "гарнитура главврача"
	desc = "Гарнитура высококвалифицированного медицинского руководителя."
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/heads/cmo

/obj/item/radio/headset/heads/hop
	name = "гарнитура главы персонала"
	desc = "Гарнитура парня, который однажды станет капитаном."
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/heads/hop

/obj/item/radio/headset/headset_cargo
	name = "гарнитура снабжения"
	desc = "Гарнитура, используемая завхозом и его подчиненными."
	icon_state = "cargo_headset"
	keyslot = new /obj/item/encryptionkey/headset_cargo

/obj/item/radio/headset/headset_cargo/mining
	name = "шахтёрская гарнитура"
	desc = "Гарнитура, используемая шахтерами."
	icon_state = "mine_headset"
	keyslot = new /obj/item/encryptionkey/headset_mining

/obj/item/radio/headset/headset_quartermaster
	name = "гарнитура завхоза"
	desc = "Гарнитура почти знатного господина."
	icon_state = "cargo_headset"
	keyslot = new /obj/item/encryptionkey/headset_exp
	keyslot2 = new /obj/item/encryptionkey/headset_cargo

/obj/item/radio/headset/headset_exploration
	name = "рейнджерская гарнитура"
	desc = "Используется рейнджерами не по назначению."
	icon_state = "exploration_headset"
	keyslot = new /obj/item/encryptionkey/headset_expteam

/obj/item/radio/headset/headset_srv
	name = "гарнитура обслуги"
	desc = "Гарнитура, используемая обслуживающим персоналом, призванная поддерживать станцию полной, счастливой и чистой."
	icon_state = "srv_headset"
	keyslot = new /obj/item/encryptionkey/headset_service

/obj/item/radio/headset/headset_curator
	name = "гарнитура куратор"
	desc = "Специальная гарнитура, которая позволяет зачитывать порно прямо в канал рейнджеров."
	icon_state = "srv_headset"
	keyslot = new /obj/item/encryptionkey/headset_curator

/obj/item/radio/headset/headset_cent
	name = "гарнитура ЦентКома"
	desc = "Гарнитура, используемая в высших эшелонах Нанотрейзена."
	icon_state = "cent_headset"
	keyslot = new /obj/item/encryptionkey/headset_com
	keyslot2 = new /obj/item/encryptionkey/headset_cent

/obj/item/radio/headset/headset_cent/empty
	keyslot = null
	keyslot2 = null

/obj/item/radio/headset/headset_cent/commander
	keyslot = new /obj/item/encryptionkey/heads/captain

/obj/item/radio/headset/headset_cent/alt
	name = "гарнитура-бабочка ЦентКома"
	desc = "Гарнитура, специально предназначенная для персонала аварийно-спасательных служб. Защищает уши от светошумовых гранат."
	icon_state = "cent_headset_alt"
	inhand_icon_state = "cent_headset_alt"
	keyslot = null

/obj/item/radio/headset/headset_cent/alt/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))

/obj/item/radio/headset/silicon/pai
	name = "\proper mini Integrated Subspace Transceiver "
	subspace_transmission = FALSE


/obj/item/radio/headset/silicon/ai
	name = "\proper Integrated Subspace Transceiver "
	keyslot2 = new /obj/item/encryptionkey/ai
	command = TRUE

/obj/item/radio/headset/silicon/can_receive(freq, level)
	return ..(freq, level, TRUE)

/obj/item/radio/headset/attackby(obj/item/W, mob/user, params)
	user.set_machine(src)

	if(W.tool_behaviour == TOOL_SCREWDRIVER)
		if(keyslot || keyslot2)
			for(var/ch_name in channels)
				SSradio.remove_object(src, GLOB.radiochannels[ch_name])
				secure_radio_connections[ch_name] = null

			if(keyslot)
				user.put_in_hands(keyslot)
				keyslot = null
			if(keyslot2)
				user.put_in_hands(keyslot2)
				keyslot2 = null

			recalculateChannels()
			to_chat(user, span_notice("Вытаскиваю ключи шифрования из гарнитуры."))

		else
			to_chat(user, span_warning("У этой гарнитуры нет уникальных ключей шифрования! Как бесполезно...."))

	else if(istype(W, /obj/item/encryptionkey))
		if(keyslot && keyslot2)
			to_chat(user, span_warning("Гарнитура не может держать другой ключ!"))
			return

		if(!keyslot)
			if(!user.transferItemToLoc(W, src))
				return
			keyslot = W

		else
			if(!user.transferItemToLoc(W, src))
				return
			keyslot2 = W


		recalculateChannels()
	else
		return ..()


/obj/item/radio/headset/recalculateChannels()
	..()
	if(keyslot2)
		for(var/ch_name in keyslot2.channels)
			if(!(ch_name in src.channels))
				channels[ch_name] = keyslot2.channels[ch_name]

		if(keyslot2.translate_binary)
			translate_binary = TRUE
		if(keyslot2.syndie)
			syndie = TRUE
		if (keyslot2.independent)
			independent = TRUE

	for(var/ch_name in channels)
		secure_radio_connections[ch_name] = add_radio(src, GLOB.radiochannels[ch_name])

/obj/item/radio/headset/AltClick(mob/living/user)
	if(!istype(user) || !Adjacent(user) || user.incapacitated())
		return
	if (command)
		use_command = !use_command
		to_chat(user, span_notice("[use_command ? "Громкоговоритель включен." : "Громкоговоритель выключен."]."))

//defines the drill hat's yelling setting
#define DRILL_DEFAULT	"default"
#define DRILL_SHOUTING	"shouting"
#define DRILL_YELLING	"yelling"
#define DRILL_CANADIAN	"canadian"

//Chef
/obj/item/clothing/head/chefhat
	name = "шапочка шэф-повара"
	inhand_icon_state = "chef"
	icon_state = "chef"
	desc = "Командир в головном уборе шеф-повара."
	strip_delay = 10
	equip_delay_other = 10
	dynamic_hair_suffix = ""
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/chefhat
	dog_fashion = /datum/dog_fashion/head/chef
	///the chance that the movements of a mouse inside of this hat get relayed to the human wearing the hat
	var/mouse_control_probability = 20

/obj/item/clothing/head/chefhat/i_am_assuming_direct_control
	desc = "The commander in chef's head wear. Upon closer inspection, there seem to be dozens of tiny levers, buttons, dials, and screens inside of this hat. What the hell...?"
	mouse_control_probability = 100

/obj/item/clothing/head/chefhat/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] надевает [src]! Похоже, что [user.p_theyre()] пытается стать шеф-поваром."))
	user.say("Bork Bork Bork!", forced = "chef hat suicide")
	sleep(20)
	user.visible_message(span_suicide("[user] залезает в воображаемую печку!"))
	user.say("BOOORK!", forced = "chef hat suicide")
	playsound(user, 'sound/machines/ding.ogg', 50, TRUE)
	return(FIRELOSS)

/obj/item/clothing/head/chefhat/relaymove(mob/living/user, direction)
	if(!istype(user, /mob/living/simple_animal/mouse) || !isliving(loc) || !prob(mouse_control_probability))
		return
	var/mob/living/L = loc
	if(L.incapacitated(TRUE)) //just in case
		return
	step_towards(L, get_step(L, direction))

//Captain
/obj/item/clothing/head/caphat
	name = "капитанская шляпа"
	desc = "Пахнет благородством."
	icon_state = "captain"
	inhand_icon_state = "that"
	flags_inv = 0
	armor = list(MELEE = 25, BULLET = 15, LASER = 25, ENERGY = 35, BOMB = 25, BIO = 0, RAD = 0, FIRE = 50, ACID = 50, WOUND = 5)
	strip_delay = 60
	dog_fashion = /datum/dog_fashion/head/captain

//Captain: This is no longer space-worthy
/obj/item/clothing/head/caphat/parade
	name = "парадная шляпа капитана"
	desc = "Их носят только капитаны с изобилием класса."
	icon_state = "capcap"

	dog_fashion = null

/obj/item/clothing/head/caphat/beret
	name = "капитанский берет"
	desc = "Для модного капитана."
	icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#0070B7#FFCE5B"


//Head of Personnel
/obj/item/clothing/head/hopcap
	name = "шапочка главы персонала"
	icon_state = "hopcap"
	desc = "Символ истинного бюрократического микроменеджмента."
	armor = list(MELEE = 25, BULLET = 15, LASER = 25, ENERGY = 35, BOMB = 25, BIO = 0, RAD = 0, FIRE = 50, ACID = 50)
	dog_fashion = /datum/dog_fashion/head/hop

//Chaplain
/obj/item/clothing/head/nun_hood
	name = "монашеский капюшон"
	desc = "Максимальное благочестие в этой звездной системе."
	icon_state = "nun_hood"
	flags_inv = HIDEHAIR
	flags_cover = HEADCOVERSEYES

/obj/item/clothing/head/bishopmitre
	name = "митра епископа"
	desc = "Роскошная шляпа, которая работает как радио для Бога. Или как громоотвод, в зависимости от того, кого вы спросите."
	icon_state = "bishopmitre"

//Detective
/obj/item/clothing/head/fedora/det_hat
	name = "шляпа детектива"
	desc = "Есть только один человек, который может нюхать грязную вонь преступности, и он, вероятно, носит эту шляпу."
	armor = list(MELEE = 25, BULLET = 5, LASER = 25, ENERGY = 35, BOMB = 0, BIO = 0, RAD = 0, FIRE = 30, ACID = 50, WOUND = 5)
	icon_state = "detective"
	var/candy_cooldown = 0
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/small/fedora/detective
	dog_fashion = /datum/dog_fashion/head/detective

/obj/item/clothing/head/fedora/det_hat/Initialize()
	. = ..()
	new /obj/item/reagent_containers/food/drinks/flask/det(src)

/obj/item/clothing/head/fedora/det_hat/examine(mob/user)
	. = ..()
	. += "<hr>"
	. += span_notice("ПКМ, чтобы достать кукурузную конфету.")

/obj/item/clothing/head/fedora/det_hat/AltClick(mob/user)
	. = ..()
	if(loc != user || !user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE, TRUE))
		return
	if(candy_cooldown < world.time)
		var/obj/item/food/candy_corn/CC = new /obj/item/food/candy_corn(src)
		user.put_in_hands(CC)
		to_chat(user, span_notice("Достаю кукурузную конфету из своей шляпы."))
		candy_cooldown = world.time+1200
	else
		to_chat(user, span_warning("Только что взял кукурузную конфету! Надо подождать пару минут, чтобы не истратить заначку."))


//Mime
/obj/item/clothing/head/beret
	name = "берет"
	desc = "Берет, любимый головной убор мима."
	icon_state = "beret"
	dog_fashion = /datum/dog_fashion/head/beret
	dynamic_hair_suffix = ""
	greyscale_config = /datum/greyscale_config/beret
	greyscale_config_worn = /datum/greyscale_config/beret/worn
	greyscale_colors = "#972A2A"
	flags_1 = IS_PLAYER_COLORABLE_1

//Security

/obj/item/clothing/head/hos
	name = "шапочка главы безопасности"
	desc = "Прочная стандартная крышка главы службы безопасности. За то, что показал офицерам, кто здесь главный."
	icon_state = "hoscap"
	armor = list(MELEE = 40, BULLET = 30, LASER = 25, ENERGY = 35, BOMB = 25, BIO = 10, RAD = 0, FIRE = 50, ACID = 60, WOUND = 10)
	strip_delay = 80
	dynamic_hair_suffix = ""

/obj/item/clothing/head/hos/syndicate
	name = "синдишляпа"
	desc = "Черная шапочка подходит для высокопоставленного офицера синдиката."

/obj/item/clothing/head/hos/beret
	name = "берет начальника охраны"
	desc = "Прочный берет для главы службы безопасности, выглядит стильно, не жертвуя при этом защитой."
	icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#3F3C40#FFCE5B"

/obj/item/clothing/head/hos/beret/navyhos
	name = "берет начальника охраны"
	desc = "Особый берет с вышитой на нем эмблемой начальника службы безопасности. Символ превосходства, знак отваги, знак отличия."
	greyscale_colors = "#3C485A#FFCE5B"

/obj/item/clothing/head/hos/beret/syndicate
	name = "берет синдиката"
	desc = "Черный берет с толстой подкладкой изнутри. Стильный и прочный."

/obj/item/clothing/head/warden
	name = "полицейская шляпа надзирателя"
	desc = "Это специальная бронированная шляпа, выданная начальнику службы безопасности. Защищает голову от ударов."
	icon_state = "policehelm"
	armor = list(MELEE = 40, BULLET = 30, LASER = 30, ENERGY = 40, BOMB = 25, BIO = 0, RAD = 0, FIRE = 30, ACID = 60, WOUND = 6)
	strip_delay = 60
	dog_fashion = /datum/dog_fashion/head/warden

/obj/item/clothing/head/warden/drill
	name = "предвыборная шапка надзирателя"
	desc = "Специальная броневая шапка с эмблемой безопасности, украшенная эмблемой кампании. Использует армированную ткань для обеспечения достаточной защиты."
	icon_state = "wardendrill"
	inhand_icon_state = "wardendrill"
	dog_fashion = null
	var/mode = DRILL_DEFAULT

/obj/item/clothing/head/warden/drill/screwdriver_act(mob/living/carbon/human/user, obj/item/I)
	if(..())
		return TRUE
	switch(mode)
		if(DRILL_DEFAULT)
			to_chat(user, span_notice("You set the voice circuit to the middle position."))
			mode = DRILL_SHOUTING
		if(DRILL_SHOUTING)
			to_chat(user, span_notice("You set the voice circuit to the last position."))
			mode = DRILL_YELLING
		if(DRILL_YELLING)
			to_chat(user, span_notice("You set the voice circuit to the first position."))
			mode = DRILL_DEFAULT
		if(DRILL_CANADIAN)
			to_chat(user, span_danger("You adjust voice circuit but nothing happens, probably because it's broken."))
	return TRUE

/obj/item/clothing/head/warden/drill/wirecutter_act(mob/living/user, obj/item/I)
	..()
	if(mode != DRILL_CANADIAN)
		to_chat(user, span_danger("You broke the voice circuit!"))
		mode = DRILL_CANADIAN
	return TRUE

/obj/item/clothing/head/warden/drill/equipped(mob/M, slot)
	. = ..()
	if (slot == ITEM_SLOT_HEAD)
		RegisterSignal(M, COMSIG_MOB_SAY, .proc/handle_speech)
	else
		UnregisterSignal(M, COMSIG_MOB_SAY)

/obj/item/clothing/head/warden/drill/dropped(mob/M)
	. = ..()
	UnregisterSignal(M, COMSIG_MOB_SAY)

/obj/item/clothing/head/warden/drill/proc/handle_speech(datum/source, mob/speech_args)
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		switch (mode)
			if(DRILL_SHOUTING)
				message += "!"
			if(DRILL_YELLING)
				message += "!!"
			if(DRILL_CANADIAN)
				message = " [message]"
				var/list/canadian_words = strings("canadian_replacement.json", "canadian")

				for(var/key in canadian_words)
					var/value = canadian_words[key]
					if(islist(value))
						value = pick(value)

					message = replacetextEx(message, " [uppertext(key)]", " [uppertext(value)]")
					message = replacetextEx(message, " [capitalize(key)]", " [capitalize(value)]")
					message = replacetextEx(message, " [key]", " [value]")

				if(prob(30))
					message += pick(", eh?", ", EH?")
		speech_args[SPEECH_MESSAGE] = message

/obj/item/clothing/head/beret/sec
	name = "офицерский берет"
	desc = "Крепкий берет с эмблемой безопасности на нем. Использует армированную ткань для обеспечения достаточной защиты."
	icon_state = "beret_badge"
	armor = list(MELEE = 40, BULLET = 30, LASER = 30, ENERGY = 40, BOMB = 25, BIO = 0, RAD = 0, FIRE = 20, ACID = 50, WOUND = 4)
	strip_delay = 60
	dog_fashion = null
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#972A2A#F2F2F2"
	flags_1 = NONE

/obj/item/clothing/head/beret/sec/navywarden
	name = "берет надзирателя"
	desc = "Специальный берет с эмблемой начальника тюрьмы, украшенный знаком отличия. Для модных надзирателей."
	greyscale_colors = "#3C485A#00AEEF"
	armor = list(MELEE = 40, BULLET = 30, LASER = 30, ENERGY = 40, BOMB = 25, BIO = 0, RAD = 0, FIRE = 30, ACID = 50, WOUND = 6)
	strip_delay = 60

/obj/item/clothing/head/beret/sec/navyofficer
	desc = "Специальный берет с эмблемой безопасности на нем. Для модных офицеров."
	greyscale_colors = "#3C485A#FF0000"

//Science

/obj/item/clothing/head/beret/science
	name = "научный берет"
	desc = "Берет, раскраска которого посвящена нашим усердно работающим учёным."
	greyscale_colors = "#8D008F"
	flags_1 = NONE

/obj/item/clothing/head/beret/science/fancy
	desc = "Берет на научную тематику для наших трудолюбивых ученых. У этого есть необычный значок!"
	icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#8D008F#FFFFFF"


//Medical

/obj/item/clothing/head/beret/medical
	name = "берет медика"
	desc = "Берет с лечебным вкусом для доктора в тебе!"
	greyscale_colors = "#FFFFFF"
	flags_1 = NONE

/obj/item/clothing/head/beret/medical/paramedic
	name = "берет парамедика"
	desc = "Для стильного поиска трупов!"
	greyscale_colors = "#16313D"


//Engineering

/obj/item/clothing/head/beret/engi
	name = "берет инженера"
	desc = "Не защитит от радиации, но точно защитит от немодной внешности!"
	greyscale_colors = "#FFBC30"
	flags_1 = NONE

/obj/item/clothing/head/beret/atmos
	name = "берет атмостеха"
	desc = "Хотя \"трубы\" и \"стиль\" могут не рифмовать, этот берет наверняка заставит вас почувствовать, что они должны!"
	greyscale_colors = "#FFDE15"
	flags_1 = NONE


//Cargo

/obj/item/clothing/head/beret/cargo
	name = "берет грузчика"
	desc = "Зачем комплексовать, когда можно носить этот берет!"
	greyscale_colors = "#ECCA30"
	flags_1 = NONE

//Curator
/obj/item/clothing/head/fedora/curator
	name = "фетровая шляпа охотника за сокровищами"
	desc = "Ты получил красное сообщение сегодня, парень, но это не значит, что тебе это должно нравиться."
	icon_state = "curator"

//Miscellaneous

/obj/item/clothing/head/beret/black
	name = "чёрный берет"
	desc = "Черный берет, идеально подходит для ветеранов войны и темных, задумчивых, антигеройских мимов."
	icon_state = "beret"
	greyscale_config = /datum/greyscale_config/beret
	greyscale_config_worn = /datum/greyscale_config/beret/worn
	greyscale_colors = "#3f3c40"

/obj/item/clothing/head/beret/durathread
	name = "дюратканевый берет"
	desc =  "Берет из дюраткани, эластичные волокна которого обеспечивают некоторую защиту головы владельца."
	icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#C5D4F3#ECF1F8"
	armor = list(MELEE = 15, BULLET = 5, LASER = 15, ENERGY = 25, BOMB = 10, BIO = 0, RAD = 0, FIRE = 30, ACID = 5, WOUND = 4)

/obj/item/clothing/head/beret/highlander
	desc = "Это была белая ткань. <i>Была</i>."
	dog_fashion = null //THIS IS FOR SLAUGHTER, NOT PUPPIES

/obj/item/clothing/head/beret/highlander/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, HIGHLANDER)


//CentCom

/obj/item/clothing/head/beret/centcom_formal
	name = "берет офицера центрального командования"
	desc = "Иногда приходится идти на компромисс между модой и защитой. Благодаря последним усовершенствованиям наноткани от ЦК на этот раз дело обстоит не так."
	icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#397F3F#FFCE5B"
	armor = list(MELEE = 80, BULLET = 80, LASER = 50, ENERGY = 50, BOMB = 100, BIO = 100, RAD = 90, FIRE = 100, ACID = 90, WOUND = 10)
	strip_delay = 10 SECONDS

#undef DRILL_DEFAULT
#undef DRILL_SHOUTING
#undef DRILL_YELLING
#undef DRILL_CANADIAN

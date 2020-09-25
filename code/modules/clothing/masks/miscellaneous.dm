/obj/item/clothing/mask/muzzle
	name = "muzzle"
	desc = "To stop that awful noise."
	icon_state = "muzzle"
	inhand_icon_state = "blindfold"
	flags_cover = MASKCOVERSMOUTH
	w_class = WEIGHT_CLASS_SMALL
	gas_transfer_coefficient = 0.9
	equip_delay_other = 20

/obj/item/clothing/mask/muzzle/attack_paw(mob/user)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(src == C.wear_mask)
			to_chat(user, "<span class='warning'>Мне понадобиться помощь для того чтобы это снять!</span>")
			return
	..()

/obj/item/clothing/mask/surgical
	name = "стерильная маска"
	desc = "Стерильная маска создана для предотвращения распространения болезней."
	icon_state = "sterile"
	inhand_icon_state = "sterile"
	w_class = WEIGHT_CLASS_TINY
	flags_inv = HIDEFACE
	flags_cover = MASKCOVERSMOUTH
	visor_flags_inv = HIDEFACE
	visor_flags_cover = MASKCOVERSMOUTH
	gas_transfer_coefficient = 0.9
	permeability_coefficient = 0.01
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 25, RAD = 0, FIRE = 0, ACID = 0)
	actions_types = list(/datum/action/item_action/adjust)

/obj/item/clothing/mask/surgical/attack_self(mob/user)
	adjustmask(user)

/obj/item/clothing/mask/fakemoustache
	name = "фальшивые усы"
	desc = "Внимание: усы фальшивые."
	icon_state = "fake-moustache"
	flags_inv = HIDEFACE

/obj/item/clothing/mask/fakemoustache/italian
	name = "итальянские усы"
	desc = "Сделаны из настоящих итальянских усов. Передает носителю дитое желание сильно жестикулировать."
	modifies_speech = TRUE

/obj/item/clothing/mask/fakemoustache/italian/handle_speech(datum/source, list/speech_args)
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		message = " [message]"
		var/list/italian_words = strings("italian_replacement.json", "italian")

		for(var/key in italian_words)
			var/value = italian_words[key]
			if(islist(value))
				value = pick(value)

			message = replacetextEx(message, " [uppertext(key)]", " [uppertext(value)]")
			message = replacetextEx(message, " [capitalize(key)]", " [capitalize(value)]")
			message = replacetextEx(message, " [key]", " [value]")

		if(prob(3))
			message += pick(" Ravioli, ravioli, give me the formuoli!"," Mamma-mia!"," Mamma-mia! That's a spicy meat-ball!", " La la la la la funiculi funicula!")
	speech_args[SPEECH_MESSAGE] = trim(message)

/obj/item/clothing/mask/joy
	name = "маска радости"
	desc = "Выразите своё счастье или скройте печали с этой маской смеющегося лица с вырезанными на ним слезами радости."
	icon_state = "joy"

/obj/item/clothing/mask/pig
	name = "маска свиньи"
	desc = "Резиновая маска свиньи со встроенным модулятором голоса."
	icon_state = "pig"
	inhand_icon_state = "pig"
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	clothing_flags = VOICEBOX_TOGGLABLE
	w_class = WEIGHT_CLASS_SMALL
	modifies_speech = TRUE

/obj/item/clothing/mask/pig/handle_speech(datum/source, list/speech_args)
	if(!(clothing_flags & VOICEBOX_DISABLED))
		speech_args[SPEECH_MESSAGE] = pick("Oink!","Squeeeeeeee!","Oink Oink!")

/obj/item/clothing/mask/pig/cursed
	name = "свинное лицо"
	desc = "Похоже на маску, но если присмотреться получше то видно что она пришита к лицу этого человека!"
	flags_inv = HIDEFACIALHAIR
	clothing_flags = NONE

/obj/item/clothing/mask/pig/cursed/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_MASK_TRAIT)
	playsound(get_turf(src), 'sound/magic/pighead_curse.ogg', 50, TRUE)

///frog mask - reeee!!
/obj/item/clothing/mask/frog
	name = "маска лягушки"
	desc = "Древняя маска вырезанная в фолме лягушки.<br> Рассудок подобен гравитации, все что ему нужно — толчок."
	icon_state = "frog"
	inhand_icon_state = "frog"
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	w_class = WEIGHT_CLASS_SMALL
	clothing_flags = VOICEBOX_TOGGLABLE
	modifies_speech = TRUE

/obj/item/clothing/mask/frog/handle_speech(datum/source, list/speech_args) //whenever you speak
	if(!(clothing_flags & VOICEBOX_DISABLED))
		if(prob(5)) //sometimes, the angry spirit finds others words to speak.
			speech_args[SPEECH_MESSAGE] = pick("HUUUUU!!","SMOOOOOKIN'!!","Hello my baby, hello my honey, hello my rag-time gal.", "Feels bad, man.", "GIT DIS GUY OFF ME!!" ,"SOMEBODY STOP ME!!", "NORMIES, GET OUT!!")
		else
			speech_args[SPEECH_MESSAGE] = pick("Ree!!", "Reee!!","REEE!!","REEEEE!!") //but its usually just angry gibberish,

/obj/item/clothing/mask/frog/cursed
	clothing_flags = NONE

/obj/item/clothing/mask/frog/cursed/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_MASK_TRAIT)

/obj/item/clothing/mask/frog/cursed/equipped(mob/user, slot)
	var/mob/living/carbon/C = user
	if(C.wear_mask == src && HAS_TRAIT_FROM(src, TRAIT_NODROP, CURSED_MASK_TRAIT))
		to_chat(user, "<span class='userdanger'>[src] был проклят! Рее!!</span>")
	return ..()

/obj/item/clothing/mask/cowmask
	name = "маска коровы"
	icon_state = "cowmask"
	inhand_icon_state = "cowmask"
	clothing_flags = VOICEBOX_TOGGLABLE
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	w_class = WEIGHT_CLASS_SMALL
	modifies_speech = TRUE

/obj/item/clothing/mask/cowmask/handle_speech(datum/source, list/speech_args)
	if(!(clothing_flags & VOICEBOX_DISABLED))
		speech_args[SPEECH_MESSAGE] = pick("Moooooooo!","Moo!","Moooo!")

/obj/item/clothing/mask/cowmask/cursed
	name = "коровье лицо"
	desc = "Выглядит как коровья маска, но при ближайшем рассмотрении видно, что она пришита к лицу этого человека!"
	flags_inv = HIDEFACIALHAIR
	clothing_flags = NONE

/obj/item/clothing/mask/cowmask/cursed/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_MASK_TRAIT)
	playsound(get_turf(src), 'sound/magic/cowhead_curse.ogg', 50, TRUE)

/obj/item/clothing/mask/horsehead
	name = "маска в виде лошадиной головы"
	desc = "Маска из мягкого винила и латекса в виде лошадиной головы."
	icon_state = "horsehead"
	inhand_icon_state = "horsehead"
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDEEYES|HIDEEARS
	w_class = WEIGHT_CLASS_SMALL
	clothing_flags = VOICEBOX_TOGGLABLE

/obj/item/clothing/mask/horsehead/handle_speech(datum/source, list/speech_args)
	if(!(clothing_flags & VOICEBOX_DISABLED))
		speech_args[SPEECH_MESSAGE] = pick("NEEIIGGGHHHH!", "NEEEIIIIGHH!", "NEIIIGGHH!", "HAAWWWWW!", "HAAAWWW!")

/obj/item/clothing/mask/horsehead/cursed
	name = "лошадиное лицо"
	desc = "Поначалу кажется что это маска, но она пришита к лицу этого бедолаги."
	clothing_flags = NONE
	flags_inv = HIDEFACIALHAIR

/obj/item/clothing/mask/horsehead/cursed/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_MASK_TRAIT)
	playsound(get_turf(src), 'sound/magic/horsehead_curse.ogg', 50, TRUE)

/obj/item/clothing/mask/rat
	name = "маска крысы"
	desc = "Маска из мягкого винила и латекса в виде крысиной головы."
	icon_state = "rat"
	inhand_icon_state = "rat"
	flags_inv = HIDEFACE
	flags_cover = MASKCOVERSMOUTH

/obj/item/clothing/mask/rat/fox
	name = "маска лисы"
	desc = "Маска из мягкого винила и латекса в виде лисьей головы."
	icon_state = "fox"
	inhand_icon_state = "fox"

/obj/item/clothing/mask/rat/bee
	name = "маска пчелы"
	desc = "Маска из мягкого винила и латекса в виде пчелиной головы."
	icon_state = "bee"
	inhand_icon_state = "bee"

/obj/item/clothing/mask/rat/bear
	name = "маска медведя"
	desc = "Маска из мягкого винила и латекса в виде медвежьей головы."
	icon_state = "bear"
	inhand_icon_state = "bear"

/obj/item/clothing/mask/rat/bat
	name = "маска летучей мыши"
	desc = "Маска из мягкого винила и латекса в виде головы летучей мыши."
	icon_state = "bat"
	inhand_icon_state = "bat"

/obj/item/clothing/mask/rat/raven
	name = "маска ворона"
	desc = "Маска из мягкого винила и латекса в виде вороньей головы."
	icon_state = "raven"
	inhand_icon_state = "raven"

/obj/item/clothing/mask/rat/jackal
	name = "маска шакала"
	desc = "Маска из мягкого винила и латекса в виде шакальей головы."
	icon_state = "jackal"
	inhand_icon_state = "jackal"

/obj/item/clothing/mask/rat/tribal
	name = "маска племени"
	desc = "Маска вырезанная из дерева с тщательной ручной детализацией."
	icon_state = "bumba"
	inhand_icon_state = "bumba"

/obj/item/clothing/mask/bandana
	name = "бандана ботаника"
	desc = "Отличная бандана с нанотехнологичной подкладкой и узором гидропоники."
	w_class = WEIGHT_CLASS_TINY
	flags_cover = MASKCOVERSMOUTH
	flags_inv = HIDEFACE|HIDEFACIALHAIR
	visor_flags_inv = HIDEFACE|HIDEFACIALHAIR
	visor_flags_cover = MASKCOVERSMOUTH | PEPPERPROOF
	slot_flags = ITEM_SLOT_MASK
	adjusted_flags = ITEM_SLOT_HEAD
	icon_state = "bandbotany"

/obj/item/clothing/mask/bandana/attack_self(mob/user)
	adjustmask(user)

/obj/item/clothing/mask/bandana/AltClick(mob/user)
	. = ..()
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if((C.get_item_by_slot(ITEM_SLOT_HEAD == src)) || (C.get_item_by_slot(ITEM_SLOT_MASK) == src))
			to_chat(user, "<span class='warning'>You can't tie [src] while wearing it!</span>")
			return
	if(slot_flags & ITEM_SLOT_HEAD)
		to_chat(user, "<span class='warning'>You must undo [src] before you can tie it into a neckerchief!</span>")
	else
		if(user.is_holding(src))
			var/obj/item/clothing/neck/neckerchief/nk = new(src)
			nk.name = "[name] neckerchief"
			nk.desc = "[desc] It's tied up like a neckerchief."
			nk.icon_state = icon_state
			nk.worn_icon = 'icons/misc/hidden.dmi' //hide underlying neckerchief object while it applies its own mutable appearance
			nk.sourceBandanaType = src.type
			var/currentHandIndex = user.get_held_index_of_item(src)
			user.transferItemToLoc(src, null)
			user.put_in_hand(nk, currentHandIndex)
			user.visible_message("<span class='notice'>You tie [src] up like a neckerchief.</span>", "<span class='notice'>[user] ties [src] up like a neckerchief.</span>")
			qdel(src)
		else
			to_chat(user, "<span class='warning'>You must be holding [src] in order to tie it!</span>")

/obj/item/clothing/mask/bandana/red
	name = "красная бандана"
	desc = "Неплохая красная бандана с нанотехнологичной подкладкой."
	icon_state = "bandred"

/obj/item/clothing/mask/bandana/blue
	name = "синяя бандана"
	desc = "Неплохая синяя бандана с нанотехнологичной подкладкой."
	icon_state = "bandblue"

/obj/item/clothing/mask/bandana/green
	name = "зелёная бандана"
	desc = "Неплохая зеленая бандана с нанотехнологичной подкладкой."
	icon_state = "bandgreen"

/obj/item/clothing/mask/bandana/gold
	name = "золотая бандана"
	desc = "Неплохая золотая бандана с нанотехнологичной подкладкой."
	icon_state = "bandgold"

/obj/item/clothing/mask/bandana/black
	name = "черная бандана"
	desc = "Неплохая черная бандана с нанотехнологичной подкладкой."
	icon_state = "bandblack"

/obj/item/clothing/mask/bandana/skull
	name = "бандана с черепом"
	desc = "Неплохая бандана с нанотехнологичной подкладкой и рисунком черепа."
	icon_state = "bandskull"

/obj/item/clothing/mask/bandana/durathread
	name = "дюратканевая бандана"
	desc =  "Бандана из дюраткани, вы хотели бы чтобы она предоставляла хоть какую-то защиту, но она слишком тонкая..."
	icon_state = "banddurathread"

/obj/item/clothing/mask/mummy
	name = "маска мумии"
	desc = "Древние бинты."
	icon_state = "mummy_mask"
	inhand_icon_state = "mummy_mask"
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR

/obj/item/clothing/mask/scarecrow
	name = "маска из мешка"
	desc = "Мешок из мешковины с прорезями для глаз."
	icon_state = "scarecrow_sack"
	inhand_icon_state = "scarecrow_sack"
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR

/obj/item/clothing/mask/gondola
	name = "Маска гондолы"
	desc = "Из настоящего гондольего меха "
	icon_state = "gondola"
	inhand_icon_state = "gondola"
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	w_class = WEIGHT_CLASS_SMALL
	modifies_speech = TRUE

/obj/item/clothing/mask/gondola/handle_speech(datum/source, list/speech_args)
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		message = " [message]"
		var/list/spurdo_words = strings("spurdo_replacement.json", "spurdo")
		for(var/key in spurdo_words)
			var/value = spurdo_words[key]
			if(islist(value))
				value = pick(value)
			message = replacetextEx(message,regex(uppertext(key),"g"), "[uppertext(value)]")
			message = replacetextEx(message,regex(capitalize(key),"g"), "[capitalize(value)]")
			message = replacetextEx(message,regex(key,"g"), "[value]")
	speech_args[SPEECH_MESSAGE] = trim(message)

/obj/item/clothing/mask/muzzle
	name = "кляп"
	desc = "Чтобы прекратить этот мерзкий звук."
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
			to_chat(user, span_warning("Мне понадобиться помощь для того чтобы это снять!"))
			return
	..()

/obj/item/clothing/mask/surgical
	name = "стерильная маска"
	desc = "Стерильная маска создана для предотвращения распространения болезней."
	icon_state = "sterile"
	inhand_icon_state = "sterile"
	w_class = WEIGHT_CLASS_TINY
	flags_inv = HIDEFACE|HIDESNOUT
	flags_cover = MASKCOVERSMOUTH
	visor_flags_inv = HIDEFACE|HIDESNOUT
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
	species_exception = list(/datum/species/golem)

/obj/item/clothing/mask/fakemoustache/italian
	name = "итальянские усы"
	desc = "Сделаны из настоящих итальянских усов. Передает носителю дикое желание сильно жестикулировать."
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
	name = "маска эмоций"
	desc = "Выразите своё счастье или скройте печали с этой маской смеющегося лица с вырезанными на нём слезами радости."
	icon_state = "joy"
	clothing_flags = MASKINTERNALS
	flags_inv = HIDESNOUT
	unique_reskin = list(
			"Joy" = "joy",
			"Flushed" = "flushed",
			"Pensive" = "pensive",
			"Angry" = "angry",
	)

/obj/item/clothing/mask/joy/reskin_obj(mob/user)
	. = ..()
	user.update_inv_wear_mask()
	current_skin = null//so we can infinitely reskin

/obj/item/clothing/mask/bandana
	name = "бандана ботаника"
	desc = "Отличная бандана с нанотехнологичной подкладкой и узором гидропоники."
	w_class = WEIGHT_CLASS_TINY
	flags_cover = MASKCOVERSMOUTH
	flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	visor_flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	visor_flags_cover = MASKCOVERSMOUTH
	slot_flags = ITEM_SLOT_MASK
	adjusted_flags = ITEM_SLOT_HEAD
	icon_state = "bandbotany"
	species_exception = list(/datum/species/golem)
	dying_key = DYE_REGISTRY_BANDANA
	flags_1 = IS_PLAYER_COLORABLE_1
	name = "bandana"
	desc = "A fine bandana with nanotech lining."
	icon_state = "bandana"
	worn_icon_state = "bandana_worn"
	greyscale_config = /datum/greyscale_config/bandana
	greyscale_config_worn = /datum/greyscale_config/bandana_worn
	var/greyscale_config_up = /datum/greyscale_config/bandana_up
	var/greyscale_config_worn_up = /datum/greyscale_config/bandana_worn_up
	greyscale_colors = "#2e2e2e"

/obj/item/clothing/mask/bandana/attack_self(mob/user)
	if(slot_flags & ITEM_SLOT_NECK)
		to_chat(user, span_warning("You must undo [src] in order to push it into a hat!"))
		return
	adjustmask(user)
	if(greyscale_config == initial(greyscale_config) && greyscale_config_worn == initial(greyscale_config_worn))
		worn_icon_state += "_up"
		undyeable = TRUE
		set_greyscale(
			new_config = greyscale_config_up,
			new_worn_config = greyscale_config_worn_up
		)
	else
		worn_icon_state = initial(worn_icon_state)
		undyeable = initial(undyeable)
		set_greyscale(
			new_config = initial(greyscale_config),
			new_worn_config = initial(greyscale_config_worn)
		)

/obj/item/clothing/mask/bandana/AltClick(mob/user)
	. = ..()
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		var/matrix/widen = matrix()
		if(!user.is_holding(src))
			to_chat(user, span_warning("You must be holding [src] in order to tie it!"))
			return
		if((C.get_item_by_slot(ITEM_SLOT_HEAD == src)) || (C.get_item_by_slot(ITEM_SLOT_MASK) == src))
			to_chat(user, span_warning("You can't tie [src] while wearing it!"))
			return
		if(slot_flags & ITEM_SLOT_HEAD)
			to_chat(user, span_warning("You must undo [src] before you can tie it into a neckerchief!"))
			return
		if(slot_flags & ITEM_SLOT_MASK)
			undyeable = TRUE
			slot_flags = ITEM_SLOT_NECK
			worn_y_offset = -3
			widen.Scale(1.25, 1)
			transform = widen
			user.visible_message(span_notice("[user] ties [src] up like a neckerchief."), span_notice("You tie [src] up like a neckerchief."))
		else
			undyeable = initial(undyeable)
			slot_flags = initial(slot_flags)
			worn_y_offset = initial(worn_y_offset)
			transform = initial(transform)
			user.visible_message(span_notice("[user] unties the neckercheif."), span_notice("You untie the neckercheif."))

/obj/item/clothing/mask/bandana/red
	name = "красная бандана"
	desc = "Неплохая красная бандана с нанотехнологичной подкладкой."
	greyscale_colors = "#A02525"
	flags_1 = NONE

/obj/item/clothing/mask/bandana/blue
	name = "синяя бандана"
	desc = "Неплохая синяя бандана с нанотехнологичной подкладкой."
	greyscale_colors = "#294A98"
	flags_1 = NONE

/obj/item/clothing/mask/bandana/purple
	name = "фиолетовая бандана"
	desc = "Неплохая фиолетовая бандана с нанотехнологичной подкладкой."
	greyscale_colors = "#9900CC"
	flags_1 = NONE

/obj/item/clothing/mask/bandana/green
	name = "зелёная бандана"
	desc = "Неплохая зеленая бандана с нанотехнологичной подкладкой."
	greyscale_colors = "#3D9829"
	flags_1 = NONE

/obj/item/clothing/mask/bandana/gold
	name = "золотая бандана"
	desc = "Неплохая золотая бандана с нанотехнологичной подкладкой."
	greyscale_colors = "#DAC20E"
	flags_1 = NONE

/obj/item/clothing/mask/bandana/orange
	name = "оранжевая бандана"
	desc = "Неплохая золотая бандана с нанотехнологичной подкладкой."
	greyscale_colors = "#da930e"
	flags_1 = NONE

/obj/item/clothing/mask/bandana/black
	name = "черная бандана"
	desc = "Неплохая черная бандана с нанотехнологичной подкладкой."
	greyscale_colors = "#2e2e2e"
	flags_1 = NONE

/obj/item/clothing/mask/bandana/white
	name = "белая бандана"
	desc = "Неплохая белая бандана с нанотехнологичной подкладкой."
	greyscale_colors = "#DCDCDC"
	flags_1 = NONE

/obj/item/clothing/mask/bandana/durathread
	name = "дюратканевая бандана"
	desc =  "Бандана из дюраткани, вы хотели бы чтобы она предоставляла хоть какую-то защиту, но она слишком тонкая..."
	greyscale_colors = "#5c6d80"
	flags_1 = NONE

/obj/item/clothing/mask/mummy
	name = "маска мумии"
	desc = "Древние бинты."
	icon_state = "mummy_mask"
	inhand_icon_state = "mummy_mask"
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/mask/scarecrow
	name = "маска из мешка"
	desc = "Мешок из мешковины с прорезями для глаз."
	icon_state = "scarecrow_sack"
	inhand_icon_state = "scarecrow_sack"
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/mask/gondola
	name = "Маска гондолы"
	desc = "Из настоящего гондольего меха."
	icon_state = "gondola"
	inhand_icon_state = "gondola"
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
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

/obj/item/clothing/mask/bandana/striped
	name = "полосатая бандана"
	desc = "Отличная бандана с нанотехнологичной подкладкой и еле заметным узором."
	icon_state = "bandstriped"
	worn_icon_state = "bandstriped_worn"
	greyscale_config = /datum/greyscale_config/bandstriped
	greyscale_config_worn = /datum/greyscale_config/bandstriped_worn
	greyscale_config_up = /datum/greyscale_config/bandstriped_up
	greyscale_config_worn_up = /datum/greyscale_config/bandstriped_worn_up
	greyscale_colors = "#2e2e2e#C6C6C6"
	undyeable = TRUE

/obj/item/clothing/mask/bandana/striped/black
	name = "полосатая чёрная бандана"
	desc = "Отличная бандана с нанотехнологичной подкладкой и черно-белым узором."
	greyscale_colors = "#2e2e2e#C6C6C6"
	flags_1 = NONE

/obj/item/clothing/mask/bandana/striped/security
	name = "бандана офицера"
	desc = "Отличная бандана с нанотехнологичной подкладкой и узором службы безопасности."
	greyscale_colors = "#A02525#2e2e2e"
	flags_1 = NONE

/obj/item/clothing/mask/bandana/striped/science
	name = "бандана учёного"
	desc = "Отличная бандана с нанотехнологичной подкладкой и узором научного отдела."
	greyscale_colors = "#DCDCDC#8019a0"
	flags_1 = NONE

/obj/item/clothing/mask/bandana/striped/engineering
	name = "бандана инженера"
	desc = "Отличная бандана с нанотехнологичной подкладкой и узором инженерного отдела."
	greyscale_colors = "#dab50e#ec7404"
	flags_1 = NONE

/obj/item/clothing/mask/bandana/striped/medical
	name = "бандана врача"
	desc = "Отличная бандана с нанотехнологичной подкладкой и узором медбея."
	greyscale_colors = "#DCDCDC#5995BA"
	flags_1 = NONE

/obj/item/clothing/mask/bandana/striped/cargo
	name = "бандана грузчика"
	desc = "Отличная бандана с нанотехнологичной подкладкой и узором снабжения."
	greyscale_colors = "#967032#5F350B"
	flags_1 = NONE

/obj/item/clothing/mask/bandana/striped/botany
	name = "бандана ботаника"
	desc = "Отличная бандана с нанотехнологичной подкладкой и узором гидропоники."
	greyscale_colors = "#3D9829#294A98"
	flags_1 = NONE

/obj/item/clothing/mask/bandana/skull
	name = "бандана с черепом"
	desc = "Неплохая бандана с нанотехнологичной подкладкой и рисунком черепа."
	icon_state = "bandskull"
	worn_icon_state = "bandskull_worn"
	greyscale_config = /datum/greyscale_config/bandskull
	greyscale_config_worn = /datum/greyscale_config/bandskull_worn
	greyscale_config_up = /datum/greyscale_config/bandskull_up
	greyscale_config_worn_up = /datum/greyscale_config/bandskull_worn_up
	greyscale_colors = "#2e2e2e#C6C6C6"
	undyeable = TRUE

/obj/item/clothing/mask/bandana/skull/black
	desc = "Неплохая чёрная бандана с нанотехнологичной подкладкой и рисунком черепа."
	greyscale_colors = "#2e2e2e#C6C6C6"
	flags_1 = NONE

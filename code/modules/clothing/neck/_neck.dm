/obj/item/clothing/neck
	name = "ожерелье"
	icon = 'icons/obj/clothing/neck.dmi'
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_NECK
	strip_delay = 40
	equip_delay_other = 40

/obj/item/clothing/neck/worn_overlays(mutable_appearance/standing, isinhands = TRUE, icon_file)
	. = ..()
	if(!isinhands)
		if(body_parts_covered & HEAD)
			if(damaged_clothes)
				. += mutable_appearance('icons/effects/item_damage.dmi', "damagedmask")
			if(GET_ATOM_BLOOD_DNA_LENGTH(src))
				. += mutable_appearance('icons/effects/blood.dmi', "maskblood")

/obj/item/clothing/neck/tie
	name = "галстук"
	desc = "Привязной галстук из неоткани."
	icon = 'icons/obj/clothing/neck.dmi'
	icon_state = "tie_greyscale_tied"
	inhand_icon_state = "" //no inhands
	w_class = WEIGHT_CLASS_SMALL
	custom_price = PAYCHECK_EASY
	greyscale_config = /datum/greyscale_config/ties
	greyscale_config_worn = /datum/greyscale_config/ties_worn
	greyscale_colors = "#4d4e4e"
	flags_1 = IS_PLAYER_COLORABLE_1
	/// All ties start untied unless otherwise specified
	var/is_tied = FALSE
	/// How long it takes to tie the tie
	var/tie_timer = 4 SECONDS
	/// Is this tie a clip-on, meaning it does not have an untied state?
	var/clip_on = FALSE

/obj/item/clothing/neck/tie/Initialize(mapload)
	. = ..()
	if(clip_on)
		return
	update_appearance(UPDATE_ICON)
	register_context()

/obj/item/clothing/neck/tie/examine(mob/user)
	. = ..()
	if(clip_on)
		. += span_notice("Looking closely, you can see that it's actually a cleverly disguised clip-on.")
	else if(!is_tied)
		. += span_notice("The tie can be tied with Alt-Click.")
	else
		. += span_notice("The tie can be untied with Alt-Click.")

/obj/item/clothing/neck/tie/AltClick(mob/user)
	. = ..()
	if(clip_on)
		return
	to_chat(user, span_notice("You concentrate as you begin [is_tied ? "untying" : "tying"] [src]..."))
	var/tie_timer_actual = tie_timer
	// Mirrors give you a boost to your tying speed. I realize this stacks and I think that's hilarious.
	for(var/obj/structure/mirror/reflection in view(2, user))
		tie_timer_actual /= 1.25
	// Tie/Untie our tie
	if(!do_after(user, tie_timer_actual))
		to_chat(user, span_notice("Your fingers fumble away from [src] as your concentration breaks."))
		return
	// Clumsy & Dumb people have trouble tying their ties.
	if((HAS_TRAIT(user, TRAIT_CLUMSY) || HAS_TRAIT(user, TRAIT_DUMB)) && prob(50))
		to_chat(user, span_notice("You just can't seem to get a proper grip on [src]!"))
		return
	// Success!
	is_tied = !is_tied
	user.visible_message(
		span_notice("[user] adjusts [user.p_their()] tie[HAS_TRAIT(user, TRAIT_BALD) ? "" : " and runs a hand across [user.p_their()] head"]."),
		span_notice("You successfully [is_tied ? "tied" : "untied"] [src]!"),
	)
	update_appearance(UPDATE_ICON)
	user.update_clothing(ITEM_SLOT_NECK)

/obj/item/clothing/neck/tie/update_icon()
	. = ..()
	// Normal strip & equip delay, along with 2 second self equip since you need to squeeze your head through the hole.
	if(is_tied)
		icon_state = "tie_greyscale_tied"
		strip_delay = 4 SECONDS
		equip_delay_other = 4 SECONDS
		equip_delay_self = 2 SECONDS
	else // Extremely quick strip delay, it's practically a ribbon draped around your neck
		icon_state = "tie_greyscale_untied"
		strip_delay = 1 SECONDS
		equip_delay_other = 1 SECONDS
		equip_delay_self = 0

/obj/item/clothing/neck/tie/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	if(clip_on)
		return
	if(is_tied)
		context[SCREENTIP_CONTEXT_ALT_LMB] = "Развязать"
	else
		context[SCREENTIP_CONTEXT_ALT_LMB] = "Завязать"
	return CONTEXTUAL_SCREENTIP_SET

/obj/item/clothing/neck/tie/blue
	name = "синий галстук"
	icon_state = "tie_greyscale_untied"
	greyscale_colors = "#5275b6ff"

/obj/item/clothing/neck/tie/red
	name = "красный галстук"
	icon_state = "tie_greyscale_untied"
	greyscale_colors = "#c23838ff"

/obj/item/clothing/neck/tie/red/tied
	is_tied = TRUE

/obj/item/clothing/neck/tie/red/hitman
	desc = "This is a $47,000 custom-tailored Référence Du Tueur À Gages tie. The clot is from neosilkworms raised at a tie microfarm in Cookwell, from a secret pattern passed down by monk tailors since the twenty-first century!"
	icon_state = "tie_greyscale_untied"
	tie_timer = 1 SECONDS // You're a professional.

/obj/item/clothing/neck/tie/red/hitman/tied
	is_tied = TRUE

/obj/item/clothing/neck/tie/black
	name = "чёрный галстук"
	icon_state = "tie_greyscale_untied"
	greyscale_colors = "#151516ff"

/obj/item/clothing/neck/tie/black/tied
	is_tied = TRUE

/obj/item/clothing/neck/tie/horrible
	name = "ужасный галстук"
	desc = "Привязной галстук из неоткани. Выглядит отвратительно."
	icon_state = "horribletie"
	clip_on = TRUE
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_colors = null

/obj/item/clothing/neck/tie/disco
	name = "horrific necktie"
	icon_state = "eldritch_tie"
	desc = "The necktie is adorned with a garish pattern. It's disturbingly vivid. Somehow you feel as if it would be wrong to ever take it off. It's your friend now. You will betray it if you change it for some boring scarf."
	clip_on = TRUE
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_colors = null

/obj/item/clothing/neck/tie/detective
	name = "провисший галстук"
	desc = "Свободно связанный галстук, идеальный аксессуар для переутомленного детектива."
	icon_state = "detective"
	clip_on = TRUE
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_colors = null

/obj/item/clothing/neck/maid
	name = "кружевной воротничок служанки"
	desc = "Кружевной воротничок для форменной одежды служанки."
	icon_state = "maid_neck"

/obj/item/clothing/neck/stethoscope
	name = "стетоскоп"
	desc = "Устаревший медицинский аппарат для прослушивания звуков человеческого тела. Это также заставляет вас выглядеть так, как будто вы знаете, что делаете."
	icon_state = "stethoscope"
	w_class = WEIGHT_CLASS_TINY

/obj/item/clothing/neck/stethoscope/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] puts <b>[src.name]</b> to [user.ru_ego()] chest! It looks like [user.ru_who()] won't hear much!"))
	return OXYLOSS

/obj/item/clothing/neck/stethoscope/attack(mob/living/carbon/human/M, mob/living/user)
	if(ishuman(M) && isliving(user))
		if(user.a_intent == INTENT_HELP)
			var/body_part = parse_zone(user.zone_selected)

			var/heart_strength = span_danger("отсутствие")
			var/lung_strength = span_danger("отсутствие")

			var/obj/item/organ/heart/heart = M.get_organ_slot(ORGAN_SLOT_HEART)
			var/obj/item/organ/lungs/lungs = M.get_organ_slot(ORGAN_SLOT_LUNGS)

			if(!(M.stat == DEAD || (HAS_TRAIT(M, TRAIT_FAKEDEATH))))
				if(heart && istype(heart))
					heart_strength = span_danger("нестабильность")
					if(heart.beating)
						heart_strength = "здоровый звук"
				if(lungs && istype(lungs))
					lung_strength = span_danger("напряженно")
					if(!(M.failed_last_breath || M.losebreath))
						lung_strength = "здоровый звук"

			var/diagnosis = (body_part == BODY_ZONE_CHEST ? "Слышу [heart_strength] пульса и [lung_strength] дыхания." : "Я еле слышу [heart_strength] пульса.")
			user.visible_message(span_notice("[user] пристраивает [src] в [ru_exam_parse_zone(body_part)] [M] и слушает внимательно.") , span_notice("Прикладываю [src] к [ru_exam_parse_zone(body_part)] [M]. [diagnosis]"))
			return
	return ..(M,user)

///////////
//SCARVES//
///////////

/obj/item/clothing/neck/scarf //Default white color, same functionality as beanies.
	name = "белый шарф"
	icon_state = "scarf"
	icon_preview = 'icons/obj/previews.dmi'
	icon_state_preview = "scarf_cloth"
	desc = "Стильный шарф. Идеальный зимний аксессуар для тех, у кого острое чувство моды, и для тех, кто просто не может справиться с холодным бризом на шеях."
	w_class = WEIGHT_CLASS_TINY
	dog_fashion = /datum/dog_fashion/head
	custom_price = PAYCHECK_EASY
	greyscale_colors = "#EEEEEE#EEEEEE"
	greyscale_config = /datum/greyscale_config/scarf
	greyscale_config_worn = /datum/greyscale_config/scarf_worn
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/neck/scarf/black
	name = "чёрный шарф"
	greyscale_colors = "#4A4A4B#4A4A4B"

/obj/item/clothing/neck/scarf/pink
	name = "розовый шарф"
	greyscale_colors = "#F699CD#F699CD"

/obj/item/clothing/neck/scarf/red
	name = "красный шарф"
	greyscale_colors = "#D91414#D91414"

/obj/item/clothing/neck/scarf/green
	name = "зелёный шарф"
	greyscale_colors = "#5C9E54#5C9E54"

/obj/item/clothing/neck/scarf/darkblue
	name = "тёмно-синий шарф"
	greyscale_colors = "#1E85BC#1E85BC"

/obj/item/clothing/neck/scarf/purple
	name = "фиолетовый шарф"
	greyscale_colors = "#9557C5#9557C5"

/obj/item/clothing/neck/scarf/yellow
	name = "жёлтый шарф"
	greyscale_colors = "#E0C14F#E0C14F"

/obj/item/clothing/neck/scarf/orange
	name = "оранжевый шарф"
	greyscale_colors = "#C67A4B#C67A4B"

/obj/item/clothing/neck/scarf/cyan
	name = "голубой шарф"
	greyscale_colors = "#54A3CE#54A3CE"


//Striped scarves get their own icons

/obj/item/clothing/neck/scarf/zebra
	name = "зебровый шарф"
	greyscale_colors = "#333333#EEEEEE"

/obj/item/clothing/neck/scarf/christmas
	name = "рождественский шарф"
	greyscale_colors = "#038000#960000"

//The three following scarves don't have the scarf subtype
//This is because Ian can equip anything from that subtype
//However, these 3 don't have corgi versions of their sprites
/obj/item/clothing/neck/stripedredscarf
	name = "полосатый красный шарф"
	icon_state = "stripedredscarf"
	custom_price = PAYCHECK_ASSISTANT * 0.2
	w_class = WEIGHT_CLASS_SMALL

/obj/item/clothing/neck/stripedgreenscarf
	name = "полосатый зелёный шарф"
	icon_state = "stripedgreenscarf"
	custom_price = PAYCHECK_ASSISTANT * 0.2
	w_class = WEIGHT_CLASS_SMALL

/obj/item/clothing/neck/stripedbluescarf
	name = "полосатый синий шарф"
	icon_state = "stripedbluescarf"
	custom_price = PAYCHECK_ASSISTANT * 0.2
	w_class = WEIGHT_CLASS_SMALL

/obj/item/clothing/neck/petcollar
	name = "ошейник"
	desc = "Для домашних животных."
	icon_state = "petcollar"
	var/tagname = null

/obj/item/clothing/neck/large_scarf
	name = "огромный шарф"
	icon_state = "large_scarf"
	w_class = WEIGHT_CLASS_TINY
	custom_price = PAYCHECK_EASY
	greyscale_colors = "#C6C6C6#EEEEEE"
	greyscale_config = /datum/greyscale_config/large_scarf
	greyscale_config_worn = /datum/greyscale_config/large_scarf_worn
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/neck/large_scarf/red
	name = "огромный красный шарф"
	greyscale_colors = "#8A2908#A06D66"

/obj/item/clothing/neck/large_scarf/green
	name = "огромный зелёный шарф"
	greyscale_colors = "#525629#888674"

/obj/item/clothing/neck/large_scarf/blue
	name = "огромный синий шарф"
	greyscale_colors = "#20396C#6F7F91"

/obj/item/clothing/neck/large_scarf/syndie
	name = "подозрительный огромный шарф"
	desc = "Готов к операции."
	greyscale_colors = "#B40000#545350"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 50, ACID = 40)

/obj/item/clothing/neck/infinity_scarf
	name = "бесконечный шарф"
	icon_state = "infinity_scarf"
	w_class = WEIGHT_CLASS_TINY
	custom_price = PAYCHECK_EASY
	greyscale_colors = "#EEEEEE"
	greyscale_config = /datum/greyscale_config/infinity_scarf
	greyscale_config_worn = /datum/greyscale_config/infinity_scarf_worn
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/neck/petcollar/attack_self(mob/user)
	tagname = stripped_input(user, "Хотите изменить имя на теге?", "Назовите своего нового питомца", "Шепард", MAX_NAME_LEN)
	name = "[initial(name)] - [tagname]"

//////////////
//DOPE BLING//
//////////////

/obj/item/clothing/neck/necklace/dope
	name = "золотая цепочка"
	desc = "Как же чётко быть гангстером."
	icon = 'icons/obj/clothing/neck.dmi'
	icon_state = "bling"

/obj/item/clothing/neck/necklace/dope/merchant
	desc = "Не спрашивай меня как это работает, важно то, что эта штука делает голочипы!"
	/// scales the amount received in case an admin wants to emulate taxes/fees.
	var/profit_scaling = 0.9
	/// toggles between sell (TRUE) and get price post-fees (FALSE)
	var/selling = FALSE
	var/sell_mom = FALSE

/obj/item/clothing/neck/necklace/dope/merchant/attack_self(mob/user)
	. = ..()
	selling = !selling
	to_chat(user, span_notice("[capitalize(src.name)] теперь в режиме [selling ? "'ПРОДАВАТЬ'" : "'УЗНАТЬ ЦЕНУ'"]."))

/obj/item/clothing/neck/necklace/dope/merchant/afterattack(obj/item/I, mob/user, proximity)
	. = ..()
	if(!proximity)
		return

	if(ismob(I) && !sell_mom)
		return

	var/datum/export_report/ex = export_item_and_contents(I, dry_run=TRUE, delete_unsold = FALSE)
	var/price = 0
	for(var/x in ex.total_amount)
		price += ex.total_value[x]

	if(price)
		var/true_price = round(price*profit_scaling)
		to_chat(user, span_notice("[selling ? "Продаём" : "Оцениваем"] [I], стоимость: <b>[true_price]</b> кредитов[I.contents.len ? " (содержимое включено)" : ""].[profit_scaling < 1 && selling ? "<b>[round(price-true_price)]</b> кредитов было взято как процент." : ""]"))
		if(selling)
			new /obj/item/holochip(get_turf(user),true_price)
			for(var/i in ex.exported_atoms_ref)
				if(ismob(i) && !sell_mom)
					continue
				var/atom/movable/AM = i
				if(QDELETED(AM))
					continue
				qdel(AM)
	else
		to_chat(user, span_warning("[capitalize(I.name)] ничего не стоит."))

/obj/item/clothing/neck/beads
	name = "пластиковые бусы"
	desc = "Дешевые бусы из пластика. Прояви командный дух! Собери их! Раскидай их! Возможности безграничны!"
	icon = 'icons/obj/clothing/neck.dmi'
	icon_state = "beads"
	color = "#ffffff"
	custom_price = PAYCHECK_ASSISTANT * 0.2
	custom_materials = (list(/datum/material/plastic = 500))

/obj/item/clothing/neck/beads/Initialize(mapload)
	. = ..()
	color = color = pick("#ff0077","#d400ff","#2600ff","#00ccff","#00ff2a","#e5ff00","#ffae00","#ff0000", "#ffffff")

/obj/item/clothing/neck/christ
	name = "Крестик"
	desc = "Он наполняет тебя надеждой, что бог защитит тебя на этой непредсказуемой станции"
	icon = 'white/IvanDog11/clothing/neck.dmi'
	worn_icon = 'white/IvanDog11/clothing/mob/neck.dmi'
	icon_state = "christ"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/christ/equipped(mob/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_NECK)
		if(user.mind)
			SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "christ", /datum/mood_event/christ)

/obj/item/clothing/neck/christ/dropped(mob/user)
	. = ..()
	if(user.mind)
		SEND_SIGNAL(user, COMSIG_CLEAR_MOOD_EVENT, "christ")


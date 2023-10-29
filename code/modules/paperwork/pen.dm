/*	Pens!
 *	Contains:
 *		Pens
 *		Sleepy Pens
 *		Parapens
 *		Edaggers
 */


/*
 * Pens
 */
/obj/item/pen
	desc = "Обычная ручка с черными чернилами."
	name = "ручка"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "pen"
	inhand_icon_state = "pen"
	worn_icon_state = "pen"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_EARS
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 7
	custom_materials = list(/datum/material/iron=10)
	pressure_resistance = 2
	grind_results = list(/datum/reagent/iron = 2, /datum/reagent/iodine = 1)
	var/colour = "black"	//what colour the ink is!
	var/degrees = 0
	var/font = PEN_FONT
	embedding = list()
	sharpness = SHARP_POINTY
	hitsound = 'sound/weapons/stab1.ogg'

/obj/item/pen/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is scribbling numbers all over [user.ru_na()]self with [src]! It looks like [user.p_theyre()] trying to commit sudoku..."))
	return(BRUTELOSS)

/obj/item/pen/blue
	desc = "Обычная ручка с синими чернилами."
	icon_state = "pen_blue"
	colour = "blue"

/obj/item/pen/red
	desc = "Обычная ручка с красными чернилами."
	icon_state = "pen_red"
	colour = "red"
	throw_speed = 4 // red ones go faster (in this case, fast enough to embed!)

/obj/item/pen/invisible
	desc = "Ручка с невидимыми чернилами."
	icon_state = "pen"
	colour = "white"

/obj/item/pen/fourcolor
	desc = "Модная ручка с четырехцветными чернилами, выбран черный цвет."
	name = "четырехцветная ручка"
	colour = "черный"

/obj/item/pen/fourcolor/attack_self(mob/living/carbon/user)
	switch(colour)
		if("черный")
			colour = "красный"
			throw_speed++
		if("красный")
			colour = "зеленый"
			throw_speed = initial(throw_speed)
		if("зеленый")
			colour = "синий"
		else
			colour = "черный"
	to_chat(user, span_notice("Для <b>четырёхцветной ручки</b> выбран <b>[colour]</b> цвет."))
	desc = "Модная ручка с четырехцветными чернилами, выбран [colour] цвет."

/obj/item/pen/fountain
	name = "перьевая ручка"
	desc = "Обычная перьевая ручка с корпусом под дерево."
	icon_state = "pen-fountain"
	font = FOUNTAIN_PEN_FONT

/obj/item/pen/charcoal
	name = "пишущий уголек"
	desc = "Деревянная палочка с небольшим количеством пепла на конце. Пишет и ладно."
	icon_state = "pen-charcoal"
	colour = "dimgray"
	font = CHARCOAL_FONT
	custom_materials = null
	grind_results = list(/datum/reagent/ash = 5, /datum/reagent/cellulose = 10)

/datum/crafting_recipe/charcoal_stylus
	name = "Пишущий уголек"
	result = /obj/item/pen/charcoal
	reqs = list(/obj/item/stack/sheet/mineral/wood = 1, /datum/reagent/ash = 30)
	time = 30
	category = CAT_TOOLS

/obj/item/pen/fountain/captain
	name = "капитанская авторучка"
	desc = "Дорогая перьевая ручка с дубовыми вставкам. Перо заточено довольно остро."
	icon_state = "pen-fountain-o"
	force = 5
	throwforce = 5
	throw_speed = 4
	colour = "crimson"
	custom_materials = list(/datum/material/gold = 750)
	sharpness = SHARP_EDGED
	resistance_flags = FIRE_PROOF
	unique_reskin = list(
		"с дубовыми вставками" = "pen-fountain-o",
		"с золотыми вставками" = "pen-fountain-g",
		"с палисандровыми вставками" = "pen-fountain-r",
		"с чёрными и серебряными вставками" = "pen-fountain-b",
		", выполнена в цветах руководящего состава" = "pen-fountain-cb"
	)
	embedding = list("embed_chance" = 75)

/obj/item/pen/fountain/captain/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, 200, 115) //the pen is mightier than the sword

/obj/item/pen/fountain/captain/reskin_obj(mob/M)
	..()
	if(current_skin)
		desc = "Дорогая перьевая ручка [current_skin]. Перо заточено довольно остро."

/obj/item/pen/attack_self(mob/living/carbon/user)
	. = ..()
	if(.)
		return

	var/deg = input(user, "На какой угол вы хотели бы повернуть ручку? (1-360)", "Повернуть ручку") as null|num
	if(deg && (deg > 0 && deg <= 360))
		degrees = deg
		//Добавлено склонение
		var/degreeStr = ""
		if(degrees % 100 >= 10 && degrees % 100 <= 20)
			degreeStr = "градусов"
		else
			switch(degrees % 10)
				if(1)
					degreeStr = "градус"
				if(2 to 4)
					degreeStr = "градуса"
				else
					degreeStr = "градусов"

		to_chat(user, span_notice("Поворачиваю ручку на [degrees] [degreeStr]."))
		SEND_SIGNAL(src, COMSIG_PEN_ROTATED, deg, user)

/obj/item/pen/attack(mob/living/M, mob/user,stealth)
	if(!istype(M))
		return

	if(force)
		return . = ..()

	if(user.zone_selected == BODY_ZONE_HEAD)
		var/input = tgui_input_text(usr, "Что бы ты хотел написать у [M] на лбу?", "Засранец...", M.headstamp)
		if(!input || length(input) >= 30)
			to_chat(user, span_warning("Не хочу писать..."))
			return
		M.visible_message(user, span_danger("[user] начинает писать что-то на лбу <b>[M]</b>."))
		var/speedofwriting = 40
		if((HAS_TRAIT(user, TRAIT_CLUMSY)))
			speedofwriting = 15
		if(!use_tool(M, user, speedofwriting, volume=50))
			to_chat(user, span_warning("Не хочу писать..."))
			return
		M.visible_message(user, span_danger("[user] пишет <big>[input]</big> на лбу <b>[M]</b>."))
		M.headstamp = input
		return

	if(M.try_inject(user, injection_flags = INJECT_TRY_SHOW_ERROR_MESSAGE))
		to_chat(user, span_warning("Тыкаю [M] ручкой."))
		if(!stealth)
			to_chat(M, span_danger("Что-то укололо меня!"))
		. = 1

	log_combat(user, M, "втыкает", src)

/obj/item/pen/afterattack(obj/O, mob/living/user, proximity)
	. = ..()
	//Changing name/description of items. Only works if they have the UNIQUE_RENAME object flag set
	if(isobj(O) && proximity && (O.obj_flags & UNIQUE_RENAME))
		var/penchoice = tgui_input_list(user, "Что вы хотите изменить?", "Переименовать, изменить описание или сбросить?", list("Переименовать","Изменить описание","Сбросить"))
		if(QDELETED(O) || !user.canUseTopic(O, BE_CLOSE))
			return
		if(penchoice == "Переименовать")
			var/input = stripped_input(user,"Как хотите назвать? [O]?", ,"[O.name]", MAX_NAME_LEN)
			var/oldname = O.name
			if(QDELETED(O) || !user.canUseTopic(O, BE_CLOSE))
				return
			if(oldname == input || input == "")
				to_chat(user, span_notice("Я изменил [O] на... ну... [O]."))
			else
				O.name = input
				var/datum/component/label/label = O.GetComponent(/datum/component/label)
				if(label)
					label.remove_label()
					label.apply_label()
				to_chat(user, span_notice("Я переименовал [oldname] в [O]."))
				O.renamedByPlayer = TRUE

		if(penchoice == "Изменить описание")
			var/input = stripped_input(user,"Опишите [O] здесь:", ,"[O.desc]", 140)
			var/olddesc = O.desc
			if(QDELETED(O) || !user.canUseTopic(O, BE_CLOSE))
				return
			if(olddesc == input || input == "")
				to_chat(user, span_notice("Я передумал менять описание [O]."))
			else
				O.desc = input
				to_chat(user, span_notice("Я изменил описание [O]."))
				O.renamedByPlayer = TRUE

		if(penchoice == "Сбросить")
			if(QDELETED(O) || !user.canUseTopic(O, BE_CLOSE))
				return
			O.desc = initial(O.desc)
			O.name = initial(O.name)
			var/datum/component/label/label = O.GetComponent(/datum/component/label)
			if(label)
				label.remove_label()
				label.apply_label()
			to_chat(user, span_notice("Возвращаю [O] прежнее название и описание."))
			O.renamedByPlayer = FALSE

/*
 * Sleepypens
 */

/obj/item/pen/sleepy/attack(mob/living/M, mob/user)
	if(!istype(M))
		return

	if(..())
		if(reagents.total_volume)
			if(M.reagents)

				reagents.trans_to(M, reagents.total_volume, transfered_by = user, methods = INJECT)


/obj/item/pen/sleepy/Initialize(mapload)
	. = ..()
	create_reagents(45, OPENCONTAINER)
	reagents.add_reagent(/datum/reagent/toxin/chloralhydrate, 20)
	reagents.add_reagent(/datum/reagent/toxin/mutetoxin, 15)
	reagents.add_reagent(/datum/reagent/toxin/staminatoxin, 10)

/*
 * (Alan) Edaggers
 */
/obj/item/pen/edagger
	attack_verb_continuous = list("рубит", "втыкает", "разрезает", "кромсает", "разрывает", "нарезает", "режет") //these won't show up if the pen is off
	attack_verb_simple = list("рубит", "втыкает", "разрезает", "кромсает", "разрывает", "нарезает", "режет")
	sharpness = SHARP_EDGED
	/// The real name of our item when extended.
	var/hidden_name = "energy dagger"
	/// Whether or pen is extended
	var/extended = FALSE

/obj/item/pen/edagger/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, _speed = 6 SECONDS, _butcher_sound = 'sound/weapons/blade1.ogg')
	AddComponent(/datum/component/transforming, \
		force_on = 18, \
		throwforce_on = 35, \
		throw_speed_on = 4, \
		sharpness_on = SHARP_EDGED, \
		w_class_on = WEIGHT_CLASS_NORMAL)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/obj/item/pen/edagger/suicide_act(mob/user)
	. = BRUTELOSS
	if(extended)
		user.visible_message(span_suicide("[user] засовывает ручку в свой рот!"))
	else
		user.visible_message(span_suicide("[user] держит ручку у рта! Похоже, [user.p_theyre()] пытается совершить суицид!"))
		attack_self(user)

/*
 * Signal proc for [COMSIG_TRANSFORMING_ON_TRANSFORM].
 *
 * Handles swapping their icon files to edagger related icon files -
 * as they're supposed to look like a normal pen.
 */
/obj/item/pen/edagger/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	extended = active
	if(active)
		name = hidden_name
		icon_state = "edagger"
		inhand_icon_state = "edagger"
		lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
		righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
		embedding = list(embed_chance = 100) // Rule of cool
	else
		name = initial(name)
		icon_state = initial(icon_state)
		inhand_icon_state = initial(inhand_icon_state)
		lefthand_file = initial(lefthand_file)
		righthand_file = initial(righthand_file)
		embedding = list(embed_chance = EMBED_CHANCE)

	updateEmbedding()
	balloon_alert(user, "[hidden_name] [active ? "active":"concealed"]")
	playsound(user ? user : src, active ? 'sound/weapons/saberon.ogg' : 'sound/weapons/saberoff.ogg', 5, TRUE)
	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/pen/survival
	name = "ручка выживальщика"
	desc = "Новейшая разработка в сфере выживания! Ручка разработана в виде миниатюрной алмазной кирки."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "digging_pen"
	inhand_icon_state = "pen"
	worn_icon_state = "pen"
	force = 3
	w_class = WEIGHT_CLASS_TINY
	custom_materials = list(/datum/material/iron=10, /datum/material/diamond=100, /datum/material/titanium = 10)
	pressure_resistance = 2
	grind_results = list(/datum/reagent/iron = 2, /datum/reagent/iodine = 1)
	tool_behaviour = TOOL_MINING //For the classic "digging out of prison with a spoon but you're in space so this analogy doesn't work" situation.
	toolspeed = 10 //You will never willingly choose to use one of these over a shovel.

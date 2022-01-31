/obj/item/wirecutters
	name = "кусачки"
	desc = "Чтобы резать кабели."
	icon = 'white/valtos/icons/items.dmi'
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	icon_state = "cutters_map"
	inhand_icon_state = "cutters"
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	force = 6
	throw_speed = 3
	throw_range = 7
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/iron=80)
	attack_verb_continuous = list("кусает", "прокусывает")
	attack_verb_simple = list("кусает", "прокусывает")
	hitsound = 'sound/items/wirecutter.ogg'
	usesound = 'sound/items/wirecutter.ogg'
	drop_sound = 'sound/items/handling/wirecutter_drop.ogg'
	pickup_sound =  'sound/items/handling/wirecutter_pickup.ogg'

	tool_behaviour = TOOL_WIRECUTTER
	toolspeed = 1
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 30)
	var/random_color = TRUE
	var/static/list/wirecutter_colors = list(
		"blue" = "#1861d5",
		"red" = "#951710",
		"pink" = "#d5188d",
		"brown" = "#a05212",
		"green" = "#0e7f1b",
		"cyan" = "#18a2d5",
		"yellow" = "#d58c18"
	)


/obj/item/wirecutters/Initialize()
	. = ..()
	if(random_color) //random colors!
		icon_state = "cutters"
		var/our_color = pick(wirecutter_colors)
		add_atom_colour(wirecutter_colors[our_color], FIXED_COLOUR_PRIORITY)
		update_icon()

/obj/item/wirecutters/update_overlays()
	. = ..()
	if(!random_color) //icon override
		return
	var/mutable_appearance/base_overlay = mutable_appearance(icon, "cutters_cutty_thingy")
	base_overlay.appearance_flags = RESET_COLOR
	. += base_overlay

/obj/item/wirecutters/attack(mob/living/carbon/C, mob/user)
	if(tearoutteeth(C, user)) // hippie start -- adds teeth code
		return FALSE // hippie end
	if(istype(C) && C.handcuffed && istype(C.handcuffed, /obj/item/restraints/handcuffs/cable))
		user.visible_message(span_notice("[user] перекусывает наручи [C] используя [src]!"))
		qdel(C.handcuffed)
		return
	else if(istype(C) && C.has_status_effect(STATUS_EFFECT_CHOKINGSTRAND))
		to_chat(C, span_notice("Пытаюсь снять прядь дюраткани с шеи."))
		if(do_after(user, 1.5 SECONDS, C))
			to_chat(C, span_notice("Успешно снимаю прядь дюраткани."))
			C.remove_status_effect(STATUS_EFFECT_CHOKINGSTRAND)
	else
		..()

/obj/item/wirecutters/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is cutting at [user.ru_ego()] arteries with [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	playsound(loc, usesound, 50, TRUE, -1)
	return (BRUTELOSS)

/obj/item/wirecutters/abductor
	name = "инопланетные кусачки"
	desc = "Очень острые канаторезы, изготовленные из серебристо-зеленого металла."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "cutters"
	toolspeed = 0.1
	random_color = FALSE

/obj/item/wirecutters/cyborg
	name = "механизированные кусачки"
	desc = "Обрезает провода силой ЭЛЕКТРИЧЕСКОсти. Быстрее, чем обычные канаторезы."
	icon = 'white/Feline/icons/cyber_arm_tools.dmi'
	icon_state = "wirecutters_cyborg"
	worn_icon_state = "cutters"
	toolspeed = 0.5
	random_color = FALSE

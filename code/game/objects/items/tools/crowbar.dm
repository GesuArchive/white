/obj/item/crowbar
	name = "карманный лом"
	desc = "Маленький ломик. Этот удобный инструмент полезен для многих вещей, например, для снятия напольной плитки или открывания дверей без электропитания."
	icon = 'white/valtos/icons/items.dmi'
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	icon_state = "crowbar"
	usesound = 'sound/items/crowbar.ogg'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	force = 5
	throwforce = 7
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/iron=50)
	drop_sound = 'sound/items/handling/crowbar_drop.ogg'
	pickup_sound =  'sound/items/handling/crowbar_pickup.ogg'

	attack_verb_continuous = list("атакует", "колотит", "бьёт", "ударяет", "вмазывает")
	attack_verb_simple = list("атакует", "колотит", "бьёт", "ударяет", "вмазывает")
	tool_behaviour = TOOL_CROWBAR
	toolspeed = 1
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 30)
	var/force_opens = FALSE

/obj/item/crowbar/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is beating [user.ru_na()]self to death with [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	playsound(loc, 'sound/weapons/genhit.ogg', 50, TRUE, -1)
	return (BRUTELOSS)

/obj/item/crowbar/red
	icon_state = "crowbar_red"
	force = 8

/obj/item/crowbar/abductor
	name = "инопланетный лом"
	desc = "Жесткий лёгкий ломик. Похоже, он работает сам по себе, даже не нужно прилагать никаких усилий."
	icon = 'icons/obj/abductor.dmi'
	usesound = 'sound/weapons/sonic_jackhammer.ogg'
	icon_state = "crowbar"
	toolspeed = 0.1


/obj/item/crowbar/large
	name = "лом"
	desc = "Это большой ломик. Он не помещается в карманы, потому что он большой."
	force = 12
	w_class = WEIGHT_CLASS_NORMAL
	throw_speed = 3
	throw_range = 3
	custom_materials = list(/datum/material/iron=70)
	icon_state = "crowbar_large"
	inhand_icon_state = "crowbar"
	worn_icon_state = "crowbar"
	toolspeed = 0.7

/obj/item/crowbar/power
	name = "гидравлические ножницы"
	desc = "Спасательный инструмент для выламывания и перекусывания конструкций, форсированного открытия шлюзов и демонтажа оборудования."
	icon_state = "jaws"
	inhand_icon_state = "jawsoflife"
	worn_icon_state = "jawsoflife"
	icon = 'white/valtos/icons/items.dmi'
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	custom_materials = list(/datum/material/iron=150,/datum/material/silver=50,/datum/material/titanium=25)
	usesound = 'sound/items/jaws_pry.ogg'
	force = 15
	toolspeed = 0.7
	force_opens = TRUE

/obj/item/crowbar/power/get_belt_overlay()
	return mutable_appearance('white/valtos/icons/belt_overlays.dmi', icon_state)

/obj/item/crowbar/power/Initialize()
	. = ..()
	AddComponent(/datum/component/transforming, \
		force_on = force, \
		throwforce_on = throwforce, \
		hitsound_on = hitsound, \
		w_class_on = w_class, \
		clumsy_check = FALSE)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, .proc/on_transform)


/*
 * Signal proc for [COMSIG_TRANSFORMING_ON_TRANSFORM].
 *
 * Toggles between crowbar and wirecutters and gives feedback to the user.
 */
/obj/item/crowbar/power/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	tool_behaviour = (active ? TOOL_WIRECUTTER : TOOL_CROWBAR)
	balloon_alert(user, "ставлю [active ? "кусаку" : "открываку"]")
	playsound(user ? user : src, 'sound/items/change_jaws.ogg', 50, TRUE)
	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/crowbar/power/syndicate
	name = "гидравлические ножницы Синдиката"
	desc = "Переработанная версия гидравлических ножниц Нанотрейзен. Как и оригинал может использоваться для форсированного открытия воздушных шлюзов."
	icon_state = "jaws_syndie"
	toolspeed = 0.5
	force_opens = TRUE

/obj/item/crowbar/power/examine()
	. = ..()
	. += "<hr>На конце установлен [tool_behaviour == TOOL_CROWBAR ? "открывака" : "кусака"]."

/obj/item/crowbar/power/suicide_act(mob/user)
	if(tool_behaviour == TOOL_CROWBAR)
		user.visible_message(span_suicide("[user] is putting [user.ru_ego()] head in [src], it looks like [user.p_theyre()] trying to commit suicide!"))
		playsound(loc, 'sound/items/jaws_pry.ogg', 50, TRUE, -1)
	else
		user.visible_message(span_suicide("[user] is wrapping <b>[src.name]</b> around [user.ru_ego()] neck. It looks like [user.p_theyre()] trying to rip [user.ru_ego()] head off!"))
		playsound(loc, 'sound/items/jaws_cut.ogg', 50, TRUE, -1)
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			var/obj/item/bodypart/BP = C.get_bodypart(BODY_ZONE_HEAD)
			if(BP)
				BP.drop_limb()
				playsound(loc, "desecration", 50, TRUE, -1)
	return (BRUTELOSS)

/obj/item/crowbar/power/attack(mob/living/carbon/C, mob/user)
	if(istype(C) && C.handcuffed && tool_behaviour == TOOL_WIRECUTTER)
		user.visible_message(span_notice("[user] перекусывает наручи [C] используя [src]!"))
		qdel(C.handcuffed)
		return
	else
		..()

/obj/item/crowbar/cyborg
	name = "гидравлический лом"
	desc = "Гидравлический инструмент, простой, но мощный."
	icon = 'white/Feline/icons/cyber_arm_tools.dmi'
	icon_state = "crowbar_cyborg"
	worn_icon_state = "crowbar"
	usesound = 'sound/items/jaws_pry.ogg'
	force = 10
	toolspeed = 0.5

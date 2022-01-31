/obj/item/wrench
	name = "гаечный ключ"
	desc = "Ключ общего назначения. Его можно найти в твоей руке."
	icon = 'white/valtos/icons/items.dmi'
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	icon_state = "wrench"
	worn_icon_state = "wrench"
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	force = 5
	throwforce = 7
	w_class = WEIGHT_CLASS_SMALL
	usesound = 'sound/items/ratchet.ogg'
	custom_materials = list(/datum/material/iron=150)
	drop_sound = 'sound/items/handling/wrench_drop.ogg'
	pickup_sound =  'sound/items/handling/wrench_pickup.ogg'

	attack_verb_continuous = list("колотит", "бьёт", "ударяет", "вмазывает")
	attack_verb_simple = list("колотит", "бьёт", "ударяет", "вмазывает")
	tool_behaviour = TOOL_WRENCH
	toolspeed = 1
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 30)

/obj/item/wrench/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is beating [user.ru_na()]self to death with [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	playsound(loc, 'sound/weapons/genhit.ogg', 50, TRUE, -1)
	return (BRUTELOSS)

/obj/item/wrench/abductor
	name = "инопланетный гаечный ключ"
	desc = "Поляризованный ключ. Это приводит к тому, что все, что находится между полюсами, поворачивается."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "wrench"
	usesound = 'sound/effects/empulse.ogg'
	toolspeed = 0.1


/obj/item/wrench/medical
	name = "медицинский гаечный ключ"
	desc = "Медицинский ключ с обычным (медицинским?) использованием. Его можно найти в твоей руке."
	icon_state = "wrench_medical"
	force = 2 //MEDICAL
	throwforce = 4
	attack_verb_continuous = list("крутит", "лечит", "стукает", "тычет", "вмазывает") //"cobbyed"
	attack_verb_simple = list("крутит", "лечит", "стукает", "тычет", "вмазывает")
	///var to hold the name of the person who suicided
	var/suicider

/obj/item/wrench/medical/examine(mob/user)
	. = ..()
	if(suicider)
		. += "<hr><span class='notice'>По какой-то причине, это напоминает мне о [suicider].</span>"

/obj/item/wrench/medical/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] is praying to the medical wrench to take [user.ru_ego()] soul. It looks like [user.p_theyre()] trying to commit suicide!"))
	user.Stun(100, ignore_canstun = TRUE)// Stun stops them from wandering off
	user.set_light_color(COLOR_VERY_SOFT_YELLOW)
	user.set_light(2)
	user.add_overlay(mutable_appearance('icons/effects/genetics.dmi', "servitude", -MUTATIONS_LAYER))
	playsound(loc, 'sound/effects/pray.ogg', 50, TRUE, -1)

	// Let the sound effect finish playing
	add_fingerprint(user)
	sleep(20)
	if(!user)
		return
	for(var/obj/item/W in user)
		user.dropItemToGround(W)
	suicider = user.real_name
	user.dust()
	return OXYLOSS

/obj/item/wrench/cyborg
	name = "гидравлический гаечный ключ"
	desc = "Усовершенствованный роботизированный ключ, приводимый в действие внутренней гидравликой. В два раза быстрее, чем версия для портативных устройств."
	icon = 'white/Feline/icons/cyber_arm_tools.dmi'
	icon_state = "wrench_cyborg"
	toolspeed = 0.5

/obj/item/wrench/combat
	name = "combat wrench"
	desc = "It's like a normal wrench but edgier. Can be found on the battlefield."
	icon_state = "wrench_combat"
	belt_icon_state = "wrench_combat"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	attack_verb_continuous = list("devastates", "brutalizes", "commits a war crime against", "obliterates", "humiliates")
	attack_verb_simple = list("devastate", "brutalize", "commit a war crime against", "obliterate", "humiliate")
	tool_behaviour = null
	toolspeed = null

/obj/item/wrench/combat/Initialize()
	. = ..()
	AddComponent(/datum/component/transforming, \
		force_on = 6, \
		throwforce_on = 8, \
		hitsound_on = hitsound, \
		w_class_on = WEIGHT_CLASS_NORMAL, \
		clumsy_check = FALSE)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, .proc/on_transform)

/*
 * Signal proc for [COMSIG_TRANSFORMING_ON_TRANSFORM].
 *
 * Gives it wrench behaviors when active.
 */
/obj/item/wrench/combat/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	if(active)
		tool_behaviour = TOOL_WRENCH
		toolspeed = 1
	else
		tool_behaviour = initial(tool_behaviour)
		toolspeed = initial(toolspeed)

	balloon_alert(user, "[name] [active ? "active, woe!":"restrained"]")
	playsound(user ? user : src, active ? 'sound/weapons/saberon.ogg' : 'sound/weapons/saberoff.ogg', 5, TRUE)
	return COMPONENT_NO_DEFAULT_MESSAGE

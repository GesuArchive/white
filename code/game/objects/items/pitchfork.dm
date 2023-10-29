/obj/item/pitchfork
	icon_state = "pitchfork0"
	lefthand_file = 'icons/mob/inhands/weapons/polearms_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/polearms_righthand.dmi'
	name = "pitchfork"
	desc = "A simple tool used for moving hay."
	force = 7
	throwforce = 15
	w_class = WEIGHT_CLASS_BULKY
	attack_verb_continuous = list("attacks", "impales", "pierces")
	attack_verb_simple = list("attack", "impale", "pierce")
	hitsound = 'sound/weapons/sword_kill_slash_01.ogg'
	sharpness = SHARP_EDGED
	max_integrity = 200
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 30)
	resistance_flags = FIRE_PROOF
	var/wielded = FALSE // track wielded status on item

/obj/item/pitchfork/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_TWOHANDED_WIELD, PROC_REF(on_wield))
	RegisterSignal(src, COMSIG_TWOHANDED_UNWIELD, PROC_REF(on_unwield))

/obj/item/pitchfork/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=7, force_wielded=15, icon_wielded="pitchfork1")

/// triggered on wield of two handed item
/obj/item/pitchfork/proc/on_wield(obj/item/source, mob/user)
	SIGNAL_HANDLER

	wielded = TRUE

/// triggered on unwield of two handed item
/obj/item/pitchfork/proc/on_unwield(obj/item/source, mob/user)
	SIGNAL_HANDLER

	wielded = FALSE

/obj/item/pitchfork/update_icon_state()
	. = ..()
	icon_state = "pitchfork0"

/obj/item/pitchfork/demonic
	name = "demonic pitchfork"
	desc = "A red pitchfork, it looks like the work of the devil."
	force = 19
	throwforce = 24
	light_system = MOVABLE_LIGHT
	light_range = 3
	light_power = 6
	light_color = COLOR_SOFT_RED


/obj/item/pitchfork/demonic/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=19, force_wielded=25)

/obj/item/pitchfork/demonic/greater
	force = 24
	throwforce = 50

/obj/item/pitchfork/demonic/greater/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=24, force_wielded=34)

/obj/item/pitchfork/demonic/ascended
	force = 100
	throwforce = 100

/obj/item/pitchfork/demonic/ascended/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=100, force_wielded=500000) // Kills you DEAD

/obj/item/pitchfork/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] impales [user.p_them()]self in [user.p_their()] abdomen with [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	return (BRUTELOSS)

/obj/item/pitchfork/demonic/ascended/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity || !wielded)
		return
	if(iswallturf(target))
		var/turf/closed/wall/W = target
		user.visible_message(span_danger("[user] blasts [target] with [src]!"))
		playsound(target, 'sound/magic/disintegrate.ogg', 100, TRUE)
		W.break_wall()
		W.ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
		return

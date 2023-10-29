/*
 * Fireaxe
 */
/obj/item/fireaxe  // DEM AXES MAN, marker -Agouri
	icon_state = "fireaxe0"
	lefthand_file = 'icons/mob/inhands/weapons/axes_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/axes_righthand.dmi'
	name = "пожарный топор"
	desc = "Воистину, оружие сумасшедшего. Кто бы мог подумать, что можно бороться с огнем топором?"
	force = 5
	throwforce = 15
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	attack_verb_continuous = list("attacks", "chops", "cleaves", "tears", "lacerates", "cuts")
	attack_verb_simple = list("attack", "chop", "cleave", "tear", "lacerate", "cut")
	hitsound = 'sound/weapons/axehit.ogg'
	sharpness = SHARP_EDGED
	max_integrity = 200
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 30)
	resistance_flags = FIRE_PROOF
	wound_bonus = -15
	bare_wound_bonus = 20
	var/wielded = FALSE // track wielded status on item

/obj/item/fireaxe/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_TWOHANDED_WIELD, PROC_REF(on_wield))
	RegisterSignal(src, COMSIG_TWOHANDED_UNWIELD, PROC_REF(on_unwield))

/obj/item/fireaxe/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/butchering, 100, 80, 0 , hitsound) //axes are not known for being precision butchering tools
	AddComponent(/datum/component/two_handed, force_unwielded=5, force_wielded=24, icon_wielded="fireaxe1")

/// triggered on wield of two handed item
/obj/item/fireaxe/proc/on_wield(obj/item/source, mob/user)
	SIGNAL_HANDLER

	wielded = TRUE

/// triggered on unwield of two handed item
/obj/item/fireaxe/proc/on_unwield(obj/item/source, mob/user)
	SIGNAL_HANDLER

	wielded = FALSE

/obj/item/fireaxe/update_icon_state()
	. = ..()
	icon_state = "fireaxe0"

/obj/item/fireaxe/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] axes [user.ru_na()]self from head to toe! It looks like [user.p_theyre()] trying to commit suicide!"))
	return (BRUTELOSS)

/obj/item/fireaxe/afterattack(atom/A, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	if(wielded) //destroys windows and grilles in one hit
		if(istype(A, /obj/structure/window) || istype(A, /obj/structure/grille))
			var/obj/structure/W = A
			W.obj_destruction("fireaxe")

/*
 * Bone Axe
 */
/obj/item/fireaxe/boneaxe  // Blatant imitation of the fireaxe, but made out of bone.
	icon_state = "bone_axe0"
	name = "костяной топор"
	desc = "Большой злобный топор, сложенный из нескольких заостренных костных пластин и грубо связанный вместе. Сделано из монстров, убивая монстров, для убийства монстров."

/obj/item/fireaxe/boneaxe/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=5, force_wielded=23, icon_wielded="bone_axe1")

/obj/item/fireaxe/boneaxe/update_icon_state()
	. = ..()
	icon_state = "bone_axe0"

/*
 * Metal Hydrogen Axe
 */
/obj/item/fireaxe/metal_h2_axe  // Blatant imitation of the fireaxe, but made out of metallic hydrogen
	icon_state = "metalh2_axe0"
	name = "metallic hydrogen axe"
	desc = "A large, menacing axe made of an unknown substance that the eldest atmosians call Metallic Hydrogen. Truly an otherworldly weapon."

/obj/item/fireaxe/metal_h2_axe/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=5, force_wielded=23, icon_wielded="metalh2_axe1")

/obj/item/fireaxe/metal_h2_axe/update_icon_state()
	. = ..()
	icon_state = "metalh2_axe0"

/obj/item/fireaxe/elder_atmosian_fireaxe
	icon_state = "elder_axe0"
	name = "eldest fireaxe"
	desc = "Upgrade of the metallic hydrogen axe; created by some madman with mysterious powers"

/obj/item/fireaxe/elder_atmosian_fireaxe/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=7, force_wielded=25, icon_wielded="elder_axe1")
	AddElement(/datum/element/lifesteal, 5)

/obj/item/fireaxe/elder_atmosian_fireaxe/update_icon_state()
	. = ..()
	icon_state = "elder_axe0"

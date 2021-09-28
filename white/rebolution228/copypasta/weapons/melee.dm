//this one is from hippie

/obj/item/melee/butterfly
	name = "нож-бабочка"
	desc = "Нож скрытного ношения, широко использующийся различными шпионскими организациями. Имеет возможность пробивать броню и наносить огромный урон при ударе со спины с интентом <b>HARM</b>."
	flags_1 = CONDUCT_1
	force = 0
	icon = 'white/rebolution228/icons/weapons/melee.dmi'
	icon_state = "butterfly"
	lefthand_file = 'white/rebolution228/icons/weapons/melee_inhand_left.dmi'
	righthand_file = 'white/rebolution228/icons/weapons/melee_inhand_right.dmi'
	throwforce = 0
	armour_penetration = 20
	w_class = WEIGHT_CLASS_SMALL
	sharpness = SHARP_EDGED
	custom_materials = list(/datum/material/iron=12000)
	var/sharpness_on = SHARP_POINTY
	var/backstabforce = 30
	var/extended = FALSE

/obj/item/melee/butterfly/Initialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	AddComponent(/datum/component/butchering, 7 SECONDS, 100)
	AddComponent(/datum/component/transforming, \
		force_on = 10, \
		throwforce_on = 10, \
		throw_speed_on = throw_speed, \
		sharpness_on = SHARP_EDGED, \
		clumsy_check = TRUE, \
		hitsound_on = 'white/rebolution228/sounds/weapons/knife.ogg', \
		w_class_on = WEIGHT_CLASS_NORMAL, \
		attack_verb_continuous_on = list("slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts"), \
		attack_verb_simple_on = list("slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut"))

/obj/item/melee/butterfly/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	extended = active
	to_chat(user, "[active ? "Раскладываю" : "Складываю"] [src]")
	playsound(user ? user : src, 'sound/weapons/batonextend.ogg', 50, TRUE)
	update_icon_state()
	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/melee/butterfly/update_icon_state()
	if(extended == TRUE)
		inhand_icon_state = "butterfly_on"
	else
		inhand_icon_state = null

/obj/item/melee/butterfly/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(check_target_facings(user, M) == FACING_SAME_DIR && user.a_intent == INTENT_HARM && ishuman(M))
		var/mob/living/carbon/human/U = M
		return backstab(U,user,backstabforce)

	return ..()

/obj/item/melee/butterfly/proc/backstab(mob/living/carbon/human/U, mob/living/carbon/user, damage)
	var/obj/item/bodypart/affecting = U.get_bodypart("chest")

	if(!affecting || U == user || U.stat == DEAD) //no chest???!!!!
		return

	U.visible_message("<span class='danger'>[user] наносит удар в спину [U] при помощи [src]!</span>", \
						"<span class='userdanger'>[user] наносит мне удар в спину при помощи [src]!</span>")

	src.add_fingerprint(user)
	playsound(loc,'white/rebolution228/sounds/weapons/knifecrit.ogg', 40, 1, -1)
	user.do_attack_animation(U)
	U.apply_damage(damage, BRUTE, affecting, U.getarmor(affecting, "melee"))
	U.dropItemToGround(U.get_active_held_item())

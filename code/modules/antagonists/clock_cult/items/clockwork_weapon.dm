/obj/item/clockwork
	name = "Clockwork Weapon"
	desc = "Something"
	icon = 'icons/obj/clockwork_objects.dmi'
	lefthand_file = 'icons/mob/inhands/antag/clockwork_lefthand.dmi';
	righthand_file = 'icons/mob/inhands/antag/clockwork_righthand.dmi'
	force = 15
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	throwforce = 20
	throw_speed = 4
	armour_penetration = 10
	custom_materials = list(/datum/material/iron=1150, /datum/material/gold=2750)
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_simple = list("атакует", "тычет", "накалывает", "рвёт", "насаживает")
	sharpness = SHARP_EDGED
	max_integrity = 200
	var/clockwork_hint = ""
	var/obj/effect/proc_holder/spell/targeted/summon_spear/SS

/obj/item/clockwork/pickup(mob/user)
	. = ..()
	user.mind.RemoveSpell(SS)
	if(is_servant_of_ratvar(user))
		SS = new
		SS.marked_item = src
		user.mind.AddSpell(SS)


/obj/item/clockwork/examine(mob/user)
	. = ..()
	if(is_servant_of_ratvar(user) && clockwork_hint)
		. += clockwork_hint

/obj/item/clockwork/attack(mob/living/target, mob/living/user)
	. = ..()
	if(!is_reebe(user.z))
		return
	if(!QDELETED(target) && target.stat != DEAD && !is_servant_of_ratvar(target))
		hit_effect(target, user)

/obj/item/clockwork/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(!is_reebe(z))
		return
	if(isliving(hit_atom))
		var/mob/living/target = hit_atom
		if(!.)
			if(!target.anti_magic_check() && !is_servant_of_ratvar(target))
				hit_effect(target, throwingdatum.thrower, TRUE)

/obj/item/clockwork/proc/hit_effect(mob/living/target, mob/living/user, thrown=FALSE)
	return

/obj/item/clockwork/brass_spear
	name = "латунное копье"
	desc = "Острое, как бритва, копье из латуни. Он гудит от едва сдерживаемой энергии."
	icon_state = "ratvarian_spear"
	embedding = list("embedded_impact_pain_multiplier" = 3)
	force = 24
	throwforce = 36
	armour_penetration = 24
	pickup_sound = 'white/valtos/sounds/brasssneath1.ogg'
	clockwork_hint = "Бросок копья нанесет дополнительный урон, пока находится на Риби."

/obj/item/clockwork/brass_battlehammer
	name = "латунный боевой молот"
	desc = "Латунный молот, светящийся энергией."
	icon_state = "ratvarian_hammer"
	force = 25
	throwforce = 25
	armour_penetration = 6
	sharpness = NONE
	pickup_sound = 'white/valtos/sounds/brasssneath1.ogg'
	attack_verb_simple = list("лупит", "дубасит", "бьёт", "хуячит")
	clockwork_hint = "Враги, пораженные этим, будут отброшены, пока молот находится на Риби."

/obj/item/clockwork/brass_battlehammer/hit_effect(mob/living/target, mob/living/user, thrown=FALSE)
	var/atom/throw_target = get_edge_target_turf(target, get_dir(src, get_step_away(target, src)))
	target.throw_at(throw_target, thrown ? 2 : 1, 4)

/obj/item/clockwork/brass_sword
	name = "латунный длинный меч"
	desc = "Большой меч из латуни."
	icon_state = "ratvarian_sword"
	force = 26
	throwforce = 20
	armour_penetration = 12
	pickup_sound = 'white/valtos/sounds/brasssneath2.ogg'
	attack_verb_simple = list("атакует", "рубит", "режет", "рвёт", "протыкает")
	clockwork_hint = "Находясь на Риби, цели будут поражены мощным электромагнитным импульсом."
	var/emp_cooldown = 0

/obj/item/clockwork/brass_sword/hit_effect(mob/living/target, mob/living/user, thrown)
	if(world.time > emp_cooldown)
		target.emp_act(EMP_LIGHT)
		emp_cooldown = world.time + 300
		addtimer(CALLBACK(src, .proc/send_message, user), 300)
		to_chat(user, span_brass("Попадаю по [target] мощным электромагнитным импульсом!"))
		playsound(user, 'sound/magic/lightningshock.ogg', 40)

/obj/item/clockwork/brass_sword/proc/send_message(mob/living/target)
	to_chat(target, span_brass("[capitalize(src.name)] светится, сообщая о готовности следующего электромагнитного удара."))

/obj/item/gun/energy/kinetic_accelerator/crossbow/clockwork
	name = "латунный лук"
	desc = "Лук из латуни и других деталей, которые вы не совсем понимаете. Он светится глубокой энергией и сам по себе дробит стрелы."
	icon = 'icons/obj/guns/projectile.dmi'
	icon_state = "bow_clockwork"
	ammo_type = list(/obj/item/ammo_casing/energy/bolt/clockbolt)

/obj/item/gun/energy/kinetic_accelerator/crossbow/clockwork/update_icon()
	. = ..()
	if(!can_shoot())
		icon_state = "bow_clockwork_unloaded"
	else
		icon_state = "bow_clockwork_loaded"

/obj/item/ammo_casing/energy/bolt/clockbolt
	name = "энергетическая стрела"
	desc = "Стрела из странной энергии."
	icon_state = "arrow_redlight"
	projectile_type = /obj/projectile/energy/clockbolt

/obj/projectile/energy/clockbolt
	name = "энергетическая стрела"
	icon_state = "arrow_energy"
	damage = 4
	damage_type = BURN
	nodamage = FALSE

/datum/action/cooldown/spell/touch/flesh_to_stone
	name = "Flesh to Stone"
	desc = "This spell charges your hand with the power to turn victims into inert statues for a long period of time."
	button_icon_state = "statue"
	sound = 'sound/magic/fleshtostone.ogg'

	school = SCHOOL_TRANSMUTATION
	cooldown_time = 1 MINUTES
	cooldown_reduction_per_rank = 10 SECONDS

	invocation = "STAUN EI!!"

	hand_path = /obj/item/melee/touch_attack/flesh_to_stone

/datum/action/cooldown/spell/touch/flesh_to_stone/cast_on_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/caster)
	if(!isliving(victim))
		return FALSE

	var/mob/living/living_victim = victim
	if(living_victim.can_block_magic(antimagic_flags))
		to_chat(caster, span_warning("The spell can't seem to affect [victim]!"))
		to_chat(victim, span_warning("You feel your flesh turn to stone for a moment, then revert back!"))
		return TRUE

	living_victim.Stun(4 SECONDS)
	living_victim.petrify()
	return TRUE

/obj/item/melee/touch_attack/flesh_to_stone
	name = "\improper petrifying touch"
	desc = "That's the bottom line, because flesh to stone said so!"
	icon_state = "fleshtostone"
	inhand_icon_state = "fleshtostone"

/datum/action/cooldown/spell/touch/flesh_to_stone/midas
	name = "Мидас"
	desc = "Это заклинание на время превращает руку в руку Мидаса, которая способна превращать живых существ в золото."
	hand_path = /obj/item/melee/touch_attack/flesh_to_stone/midas
	icon_icon = 'white/valtos/icons/actions.dmi'
	button_icon_state = "midas"
	sound = 'white/valtos/sounds/midas.ogg'

	invocation = "PO F'ARM'U CH'EMP'ION!!"

/datum/action/cooldown/spell/touch/flesh_to_stone/midas/cast_on_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/caster)
	. = ..()
	if(!victim)
		return FALSE

	var/obj/statue = locate(/obj/structure/statue/petrified) in get_turf(victim)
	if(statue)
		statue.color = "#ff9900"
		statue.desc = "Невероятно реалистичное золотое сечение."
		statue.custom_materials = list(/datum/material/gold = 10000)
	return TRUE

/obj/item/melee/touch_attack/flesh_to_stone/midas
	name = "рука мидаса"
	desc = "То, что превратит существо в золото!"
	color = "#ff9900"

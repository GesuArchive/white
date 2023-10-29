//вызывается при инишалайзе пушки, переписывать этот прок для особых видов заклинивания или его отсутствия
/obj/item/gun/proc/make_jamming()
	return

//как етой хуйней пользоваца написана в компоненте заклинивания
/datum/element/jamming
	element_flags = ELEMENT_BESPOKE
	argument_hash_start_idx = 2
	var/jamming_chance
	var/jammed_component_type = /datum/component/jammed

/datum/element/jamming/Attach(datum/target, chance, type_override)
	. = ..()
	if(!isgun(target) || GLOB.is_tournament_rules)
		return ELEMENT_INCOMPATIBLE
	if(chance <= 0)
		stack_trace("Заклиниевое сосание")
		return ELEMENT_INCOMPATIBLE
	jamming_chance = chance
	if(type_override)
		jammed_component_type = type_override
	RegisterSignal(target, COMSIG_GUN_TRY_FIRE, PROC_REF(on_fire))

/datum/element/jamming/Detach(datum/target)
	UnregisterSignal(target, COMSIG_GUN_TRY_FIRE)
	return ..()

/datum/element/jamming/proc/on_fire(obj/item/gun/source, mob/living/user, atom/target)
	SIGNAL_HANDLER
	var/datum/component/jammed/J = source.GetComponent(jammed_component_type)
	if(J)
		return
	if(prob(jamming_chance))
		source.AddComponent(jammed_component_type)
		INVOKE_ASYNC(src, PROC_REF(on_jammed), source, user)
		return COMPONENT_CANCEL_GUN_FIRE

/datum/element/jamming/proc/on_jammed(obj/item/gun/source, mob/living/user)
	to_chat(user, span_userdanger("ЗАКЛИНИЛО!"))
	source.shoot_with_empty_chamber(user)

//импостер
/datum/element/jamming/energy/on_jammed(obj/item/gun/source, mob/living/user)
	to_chat(user, span_userdanger("КРИТИЧЕСКАЯ ОШИБКА!"))
	playsound(get_turf(source), 'sound/weapons/gun/general/empty_alarm.ogg', 100)

//для етого компонента создавать подтип для каждой пушки с кастомным заклиниванием как у райдинг компонента примерно
//сделано компоненом, а не елементом, в надежде в будущем впилить более смешной механ
/datum/component/jammed
	var/fix_on_move = TRUE
	var/fixing_time = 1 SECONDS

/datum/component/jammed/Initialize(mapload)
	if(!isgun(parent) || GLOB.is_tournament_rules)
		return COMPONENT_INCOMPATIBLE

/datum/component/jammed/RegisterWithParent()
	RegisterSignal(parent, COMSIG_GUN_TRY_FIRE, PROC_REF(on_gun_fired))
	RegisterSignal(parent, COMSIG_ATOM_ATTACK_HAND_SECONDARY, PROC_REF(try_fix))
	RegisterSignal(parent, COMSIG_ITEM_ATTACK_SELF_SECONDARY, PROC_REF(try_fix))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

/datum/component/jammed/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_GUN_TRY_FIRE)
	UnregisterSignal(parent, COMSIG_ATOM_ATTACK_HAND_SECONDARY)
	UnregisterSignal(parent, COMSIG_ITEM_ATTACK_SELF_SECONDARY)
	UnregisterSignal(parent, COMSIG_PARENT_EXAMINE)

/datum/component/jammed/proc/on_examine(atom/A, mob/user, list/examine_list)
	SIGNAL_HANDLER
	examine_list += "<hr>"
	examine_list += span_danger("<big>СТВОЛ ЗАКЛИНИЛО!</big>")
	examine_list += span_info("\nМожно попытаться починить его используя ПКМ.")

/datum/component/jammed/proc/on_gun_fired(obj/item/gun/source, mob/living/user, atom/target)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(jammed_fire), source, user)
	return COMPONENT_CANCEL_GUN_FIRE

/datum/component/jammed/proc/try_fix(obj/item/gun/source, mob/user, list/modifiers)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(start_fixing), source, user)
	return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/component/jammed/proc/jammed_fire(obj/item/gun/source, mob/user)
	to_chat(user, span_userdanger("ЗАКЛИНИЛО!"))
	source.shoot_with_empty_chamber(user)

/datum/component/jammed/proc/start_fixing(obj/item/gun/jammed_gun, mob/user)
	to_chat(user, span_notice("Начинаю чинить [jammed_gun]."))
	if(do_after(user, fixing_time, jammed_gun, timed_action_flags = (fix_on_move ? IGNORE_USER_LOC_CHANGE : null)))
		to_chat(user, span_notice("Удалось починить [jammed_gun]."))
		on_fix(jammed_gun, user)
		qdel(src)

/datum/component/jammed/proc/on_fix(obj/item/gun/fixed_gun, mob/user)
	fixed_gun.process_chamber()
	playsound(get_turf(fixed_gun), 'sound/weapons/gun/general/slide_lock_1.ogg', 100)

//пример с кастомным заклиниванием для енергооружия
/datum/component/jammed/energy
	fixing_time = 1.5 SECONDS

/datum/component/jammed/energy/on_fix(obj/item/gun/fixed_gun, mob/user)
	return //не передергивание затвора же у енергооружия проигрываца будет

/datum/component/jammed/energy/jammed_fire(obj/item/gun/source, mob/user)
	var/obj/item/gun/energy/E = source
	if(prob(15))
		if(prob(5))
			user.visible_message(span_danger("[user] совершает глупую ошибку!"))
			playsound(get_turf(E), 'white/valtos/sounds/explo.ogg', 80) //лол валера че за звуки из аниме библиотек
			spawn(1 SECONDS)
				empulse(get_turf(E), rand(1, 4), rand(4, 8))
				explosion(src, devastation_range = -1, light_impact_range = 1)
				qdel(E)
		else
			electrocute_mob(user, E.cell, E) // а ето неработает

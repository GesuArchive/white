/datum/component/reactive_defense
	var/balance_main = 0
	var/balance_sides = 0

/datum/component/reactive_defense/Initialize(mapload)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/reactive_defense/RegisterWithParent()
	if(iscarbon(parent))
		RegisterSignal(parent, COMSIG_HUMAN_DISARM_HIT, PROC_REF(onDisarm))

/datum/component/reactive_defense/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_HUMAN_DISARM_HIT)


/datum/component/reactive_defense/proc/onDisarm(mob/living/carbon/disarmed, mob/living/attacker, zone_targeted)
	SIGNAL_HANDLER
	apply_impulse(get_angle(disarmed, attacker), 10)


/datum/component/reactive_defense/proc/apply_impulse(angle, amount)
	balance_main += round(amount*cos(90 - angle), 0.01)
	balance_sides += round(amount*sin(90 - angle), 0.01)

/datum/component/reactive_defense/proc/regain_balance(amount)
	if(balance_main == 0 && balance_sides == 0)
		return FALSE
	var/mag = sqrt(balance_main**2 + balance_sides**2)
	if(balance_main != 0)
		var/angleCos = balance_main/mag
		balance_main = round(balance_main > 0 ? max(0, angleCos*amount) : min(0, angleCos*amount), 0.01)
	if(balance_sides != 0)
		var/angleSin = balance_sides/mag
		balance_sides = round(balance_sides > 0 ? max(0, angleSin*amount) : min(0, angleSin*amount), 0.01)
	return TRUE

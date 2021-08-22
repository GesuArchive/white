/datum/component/melee_defense
	var/balance_x = 0
	var/balance_y = 0

/datum/component/melee_defense/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/melee_defense/RegisterWithParent()
	if(iscarbon(parent))
		RegisterSignal(parent, COMSIG_HUMAN_DISARM_HIT, .proc/onDisarm)

/datum/component/melee_defense/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_HUMAN_DISARM_HIT)


/datum/component/melee_defense/proc/onDisarm(mob/living/carbon/disarmed, mob/living/attacker, zone_targeted)
	SIGNAL_HANDLER
	apply_impulse(Get_Angle(disarmed, attacker), 10)


/datum/component/melee_defense/proc/apply_impulse(angle, amount)
	balance_x += round(amount*cos(90 - angle), 0.01)
	balance_y += round(amount*sin(90 - angle), 0.01)

/datum/component/melee_defense/proc/regain_balance(amount)
	if(balance_x == 0 && balance_y == 0)
		return FALSE
	var/mag = sqrt(balance_x**2 + balance_y**2)
	if(balance_x != 0)
		var/angleCos = balance_x/mag
		balance_x = round(balance_x > 0 ? max(0, angleCos*amount) : min(0, angleCos*amount), 0.01)
	if(balance_y != 0)
		var/angleSin = balance_y/mag
		balance_y = round(balance_y > 0 ? max(0, angleSin*amount) : min(0, angleSin*amount), 0.01)
	return TRUE

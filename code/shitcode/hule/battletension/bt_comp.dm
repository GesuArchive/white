PROCESSING_SUBSYSTEM_DEF(btension)
	name = "Battle Tension"
	priority = 15
	flags = SS_NO_INIT
	wait = 10

/datum/component/battletension
	var/mob/living/owner

	var/tension = 0
	var/sound/bm

/datum/component/battletension/Initialize()
	START_PROCESSING(SSbtension, src)

	if(isliving(parent))
		owner = parent

/datum/component/battletension/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATOM_BULLET_ACT, .proc/bulletact_react)
	RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, .proc/attackby_react)
	RegisterSignal(parent, COMSIG_MOVABLE_IMPACT_ZONE, .proc/throw_react)

/datum/component/battletension/UnregisterFromParent()
	UnregisterSignal(parent, list(	COMSIG_ATOM_BULLET_ACT,
									COMSIG_PARENT_ATTACKBY,
									COMSIG_MOVABLE_IMPACT_ZONE
									))

/datum/component/battletension/Destroy()
	STOP_PROCESSING(SSbtension, src)
	owner = null
	return ..()

/datum/component/battletension/process()

/datum/component/battletension/proc/bulletact_react(obj/item/projectile/P, def_zone)
	if(P.firer == owner)
		return

	if(P.damage_type == STAMINA)
		create_tension(P.damage)
	else
		create_tension(P.damage/4)

	var/datum/component/battletension/BT = P.firer.GetComponent(/datum/component/battletension)

	if(BT)
		if(P.damage_type == STAMINA)
			BT.create_tension(P.damage)
		else
			BT.create_tension(P.damage/4)


/datum/component/battletension/proc/attackby_react(obj/item/I, mob/living/attacker, params)
	create_tension(I.force * 1.2)

	var/datum/component/battletension/BT = attacker.GetComponent(/datum/component/battletension)

	if(BT)
		BT.create_tension(I.force * 1.2)

/datum/component/battletension/proc/throw_react(mob/living/target, hit_zone)

/datum/component/battletension/proc/create_tension(amount)
	tension += amount

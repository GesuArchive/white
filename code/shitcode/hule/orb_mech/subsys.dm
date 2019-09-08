SUBSYSTEM_DEF(orb_mech)
	name = "Orbital Mechanics"
	priority = FIRE_PRIORITY_SPACEDRIFT
	wait = 600
//	flags = SS_NO_TICK_CHECK|SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/processing = list()

/datum/controller/subsystem/orb_mech/PreInit()


/datum/controller/subsystem/orb_mech/fire()

SUBSYSTEM_DEF(dungeon_keeper)
	name = "Хранители Подземелий"
	init_order = INIT_ORDER_DUNGEONS
	flags = SS_NO_FIRE

	wait = 2.5 SECONDS

	var/multiplier = 1
	var/max_magic_income = 500
	var/list/active_masters = list()
	var/list/dead_masters = list()

/datum/controller/subsystem/dungeon_keeper/Initialize(timeofday)
	return ..()

/datum/controller/subsystem/dungeon_keeper/process(delta_time)
	. = ..()
	for(var/datum/dungeon_keeper_master/D in active_masters)
		D.magic = min(D.calc_magic_income() * multiplier, max_magic_income)


/datum/controller/subsystem/dungeon_keeper/stat_entry(msg)
	msg = "P:[length(active_masters)]|D:[length(dead_masters)]"
	return ..()

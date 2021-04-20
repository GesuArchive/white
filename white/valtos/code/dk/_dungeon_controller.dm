SUBSYSTEM_DEF(dungeon_keeper)
	name = "Хранители Подземелий"
	init_order = INIT_ORDER_DUNGEONS

	wait = 1 SECONDS

	var/multiplier = 1
	var/max_magic_income = 500
	var/list/active_masters = list()
	var/list/dead_masters = list()

/datum/controller/subsystem/dungeon_keeper/Initialize(timeofday)
	return ..()

/datum/controller/subsystem/dungeon_keeper/stat_entry(msg)
	msg = "P:[length(active_masters)]|D:[length(dead_masters)]"
	return ..()

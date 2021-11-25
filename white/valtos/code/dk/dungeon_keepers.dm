/datum/dungeon_keeper_master
	var/name = "Randy"
	var/buff = NONE
	var/color = "#FFFFFF"

	var/magic = 0

	var/mob/camera/dungeon_keeper/cameramob

	var/list/captured_turfs = list()
	var/list/controlled_units = list()
	var/list/controlled_imps = list()

/datum/dungeon_keeper_master/New()
	. = ..()
	SSdungeon_keeper.active_masters += src

/datum/dungeon_keeper_master/Destroy(force, ...)
	SSdungeon_keeper.active_masters -= src
	. = ..()

/datum/dungeon_keeper_master/proc/calc_magic_income()
	return captured_turfs.len + 100

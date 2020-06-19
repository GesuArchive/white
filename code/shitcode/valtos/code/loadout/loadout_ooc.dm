/datum/gear/ooc/char_slot_new
	display_name = "Дополнительный слот персонажа"
	sort_category = "OOC"
	description = "Дополнительный слот. Что тут ещё сказать, а?"
	cost = 50

/datum/gear/ooc/char_slot_new/purchase(var/client/C)
	C?.prefs?.max_slots += 1
	C?.prefs?.max_save_slots += 1

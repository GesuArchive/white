/datum/gear/ooc/char_slot
	display_name = "Дополнительный слот персонажа"
	sort_category = "OOC"
	description = "Дополнительный слот. Что тут ещё сказать, а?"
	cost = 500

/datum/gear/ooc/char_slot/purchase(var/client/C)
	C?.prefs?.max_save_slots += 1

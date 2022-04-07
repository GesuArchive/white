GLOBAL_LIST_EMPTY(violence_players)

/datum/violence_player
	var/money = 0
	var/team = "white"
	var/role_name = null
	var/kills = 0
	var/deaths = 0
	var/list/loadout_items = list()
	var/list/saved_items = list()

/datum/violence_player/proc/equip_everything(mob/living/carbon/human/H)
	var/list/full_of_items = list()
	for(var/datum/violence_gear/VG as anything in loadout_items)
		for(var/item in VG.items)
			LAZYADD(full_of_items, item)
	LAZYADD(full_of_items, saved_items)
	for(var/item in full_of_items)
		var/obj/item/O = new item(get_turf(H))
		if(H.equip_to_appropriate_slot(O, FALSE))
			continue
		if(H.put_in_hands(item))
			continue
		var/obj/item/storage/B = (locate() in H)
		if(B && O)
			O.forceMove(B)
	saved_items = list()
	loadout_items = list()

/proc/vp_get_player(suggested_ckey)
	if(!suggested_ckey)
		return null
	var/datum/violence_player/VP = GLOB.violence_players?[suggested_ckey]
	if(!VP)
		VP = GLOB.violence_players[suggested_ckey] = new /datum/violence_player
	return VP

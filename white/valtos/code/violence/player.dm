GLOBAL_LIST_EMPTY(violence_players)

/datum/violence_player
	// деньги игрока, может быть отрицательное значение
	var/money = 0
	// команда игрока
	var/team = "white"
	// название роли, которую вам выбрала игра
	var/role_name = null
	// убийства, может быть отрицательное значение
	var/kills = 0
	// смерти, НЕ может быть отрицательное значение
	var/deaths = 0
	// купленные предметы, которые будут выданы при появлении
	var/list/loadout_items = list()
	// предметы из прошлого раунда переносятся в следующий, если игрок выжил
	var/list/saved_items = list()

/datum/violence_player/proc/equip_everything(mob/living/carbon/human/H)
	var/list/full_of_items = list()
	for(var/datum/violence_gear/VG as anything in loadout_items)
		if(VG.random_type)
			LAZYADD(full_of_items, pick(subtypesof(VG.random_type)))
		// возможно тут нужен else, но по идее оставим так как фичу
		for(var/item in VG.items)
			LAZYADD(full_of_items, item)
	LAZYADD(full_of_items, saved_items)
	for(var/item in full_of_items)
		var/obj/item/O = new item(get_turf(H))
		if(H.equip_to_appropriate_slot(O, FALSE, TRUE))
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


/datum/team/violence
	name = "Боевики: Белые"

/datum/team/violence/red
	name = "Боевики: Красные"
	member_name = "Боевики красных"

/datum/team/violence/blue
	name = "Боевики: Синие"
	member_name = "Боевики синих"

/datum/antagonist/combatant
	name = "Боевик белых"

// добавляем худ в зависимости от команды
/datum/antagonist/combatant/apply_innate_effects(mob/living/mob_override)
	add_team_hud(mob_override || owner.current)

/datum/antagonist/combatant/red
	name = "Боевик красных"
	antag_hud_name = "hog-red-2"

/datum/antagonist/combatant/red/get_team()
	return GLOB.violence_red_datum

/datum/antagonist/combatant/red/on_gain()
	. = ..()
	LAZYREMOVE(GLOB.violence_blue_team, owner)
	LAZYOR(GLOB.violence_red_team, owner)
	var/datum/team/T = GLOB.violence_red_datum
	if(T)
		T.add_member(owner)

/datum/antagonist/combatant/blue
	name = "Боевик синих"
	antag_hud_name = "hog-blue-2"

/datum/antagonist/combatant/blue/get_team()
	return GLOB.violence_blue_datum

/datum/antagonist/combatant/blue/on_gain()
	. = ..()
	LAZYREMOVE(GLOB.violence_red_team, owner)
	LAZYOR(GLOB.violence_blue_team, owner)
	var/datum/team/T = GLOB.violence_blue_datum
	if(T)
		T.add_member(owner)

/datum/job/combantant
	title = "Combantant"
	faction = "Violence"
	total_positions = 0
	spawn_positions = 0
	supervisors = "практически всем"
	selection_color = "#dddddd"
	outfit = /datum/outfit/job/combantant
	antag_rep = 0

/datum/job/combantant/red
	title = JOB_COMBATANT_RED
	faction = "Violence"
	supervisors = "красным"
	selection_color = "#dd0000"
	outfit = /datum/outfit/job/combantant/red

/datum/job/combantant/red/after_spawn(mob/living/H, mob/M, latejoin)
	. = ..()
	var/datum/antagonist/combatant/red/comb = new
	H.mind.add_antag_datum(comb)
	H.faction = list("combatant_red")

/datum/job/combantant/blue
	title = JOB_COMBATANT_BLUE
	faction = "Violence"
	supervisors = "синим"
	selection_color = "#0000dd"
	outfit = /datum/outfit/job/combantant/blue

/datum/job/combantant/blue/after_spawn(mob/living/H, mob/M, latejoin)
	. = ..()
	var/datum/antagonist/combatant/blue/comb = new
	H.mind.add_antag_datum(comb)
	H.faction = list("combatant_blue")

/datum/id_trim/combatant
	assignment = "white"
	access = list(ACCESS_CENT_SPECOPS)

/datum/id_trim/combatant/red
	assignment = "red"

/datum/id_trim/combatant/blue
	assignment = "blue"

/datum/outfit/job/combantant
	name = "Combantant"
	jobtype = /datum/job/combantant
	uniform = /obj/item/clothing/under/syndicate/camo
	shoes = /obj/item/clothing/shoes/jackboots
	l_pocket = null
	r_pocket = null
	id = null
	belt = null
	ears = /obj/item/radio/headset
	box = null
	var/team = "white"

/datum/outfit/job/combantant/red
	name = JOB_COMBATANT_RED
	jobtype = /datum/job/combantant/red
	uniform = /obj/item/clothing/under/color/red
	id = /obj/item/card/id/red
	team = "red"

/datum/outfit/job/combantant/blue
	name = JOB_COMBATANT_BLUE
	jobtype = /datum/job/combantant/blue
	uniform = /obj/item/clothing/under/color/blue
	id = /obj/item/card/id/blue
	team = "blue"

/datum/outfit/job/combantant/pre_equip(mob/living/carbon/human/H)
	..()

	if(GLOB.violence_playmode == VIOLENCE_PLAYMODE_TAG)
		ADD_TRAIT(H, TRAIT_CORPSELOCKED, "violence")

	if(GLOB.violence_playmode != VIOLENCE_PLAYMODE_TAG)
		implants = list(/obj/item/implant/explosive/disintegrate)

	switch(GLOB.violence_theme)
		if("katana")
			if(GLOB.violence_current_round >= 6) // no chronos before
				uniform = /obj/item/clothing/under/chronos
				neck = /obj/item/clothing/neck/cape/chronos
				head = /obj/item/clothing/head/beret/chronos
		if("portal")
			r_hand = /obj/item/gun/energy/wormhole_projector/core_inserted
			if(GLOB.violence_current_round >= 2)
				uniform = /obj/item/clothing/under/costume/maid
				neck = /obj/item/clothing/neck/maid
				head = /obj/item/clothing/head/maidheadband
				gloves = /obj/item/clothing/gloves/maid
	// something

	if(GLOB.violence_friendlyfire)
		return

	RegisterSignal(H, COMSIG_MOB_EQUIPPED_ITEM, .proc/factionee_projectiles)

/datum/outfit/job/combantant/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	var/obj/item/card/id/W = H.wear_id
	if(W)
		W.registered_name = H.real_name
		W.update_label()
	var/obj/item/radio/R = H.ears
	if(R)
		switch(team)
			if("red")
				R.set_frequency(FREQ_CTF_RED)
				SSid_access.apply_trim_to_card(W, /datum/id_trim/combatant/red)
			if("blue")
				R.set_frequency(FREQ_CTF_BLUE)
				SSid_access.apply_trim_to_card(W, /datum/id_trim/combatant/blue)
		R.AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))
		R.freqlock = TRUE
		R.independent = TRUE
	H.sec_hud_set_ID()
	// экипируем штуки спустя секунду, чтобы некоторый стаф не падал в нуллспейс случайно
	spawn(1 SECONDS)
		if(GLOB.violence_players[H?.ckey])
			var/datum/violence_player/VP = GLOB.violence_players[H.ckey]
			VP.equip_everything(H)
			VP.team = team
	// запрет на снятие ID и униформы
	ADD_TRAIT(W, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)
	ADD_TRAIT(H.w_uniform, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)

/datum/outfit/job/combantant/proc/factionee_projectiles(mob/living/source, obj/item/equipped_item, slot)
	SIGNAL_HANDLER

	var/actual_faction = source?.faction

	if(!actual_faction)
		return

	if(ismag(equipped_item))
		for(var/obj/item/ammo_casing/AC as() in equipped_item)
			AC?.loaded_projectile?.ignored_factions = actual_faction
	else if(isballisticgun(equipped_item))
		var/obj/item/gun/ballistic/G = equipped_item
		if(!G?.magazine)
			return
		for(var/obj/item/ammo_casing/AC as() in G.magazine)
			AC?.loaded_projectile?.ignored_factions = actual_faction

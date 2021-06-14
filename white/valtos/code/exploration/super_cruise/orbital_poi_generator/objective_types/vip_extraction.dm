/datum/orbital_objective/vip_recovery
	name = "VIP эвакуация"
	var/generated = FALSE
	var/death_caring = TRUE
	var/mob/mob_to_recover
	var/tracked_diary
	//Relatively easy mission.
	min_payout = 1000
	max_payout = 4000

/datum/orbital_objective/vip_recovery/get_text()
	return "Кто-то, представляющий особый интерес, находится по адресу [station_name]. Мы требуем его немедленно спасти. \
		Мы предполагаем, что эта VIP-персона всё ещё жива, однако, если мертва, то диск-дневник с историей личной жизни был бы \
		тем, что нам могло бы понадобиться. Также, возможно вам понадобится помощь местного отряда службы безопасности, так как \
		вероятно вы встретите неприятеля. Верните этого человека на станции и задание будет выполнено."

//If nobody takes up the ghost role, then we dont care if they died.
//I know, its a bit sad.
/datum/orbital_objective/vip_recovery/check_failed()
	if(generated)
		if(QDELETED(mob_to_recover))
			return TRUE
		if(mob_to_recover.stat == DEAD)
			if(mob_to_recover.key && death_caring)
				return TRUE
			if(!mob_to_recover.key)
				if(death_caring)
					//Spawn in a diary
					var/obj/item/disk/record/diary = new(get_turf(mob_to_recover))
					diary.setup_recover(src)
					tracked_diary = diary
					priority_announce("Сенсоры сообщают о том, что VIP, которого мы хотели достать, внезапно скончался, однако \
						его дневник поможет нам восстановить произошедшие события. Найдите его.")
				death_caring = FALSE
		else if(is_station_level(mob_to_recover.z))
			complete_objective()
		if(death_caring)
			return TRUE
	return FALSE

/datum/orbital_objective/vip_recovery/generate_objective_stuff(turf/chosen_turf)
	var/mob/living/carbon/human/created_human = new(chosen_turf)
	//Maybe polling ghosts would be better than the shintience code
	created_human.ice_cream_mob = TRUE
	ADD_TRAIT(created_human, TRAIT_CLIENT_LEAVED, "ice_cream")
	notify_ghosts("VIP-персона может быть занята.", source = created_human, action = NOTIFY_ORBIT, flashwindow = FALSE, ignore_key = POLL_IGNORE_SPLITPERSONALITY, notify_suiciders = FALSE)
	death_caring = FALSE
	created_human.AddElement(/datum/element/point_of_interest)
	created_human.mind_initialize()
	//Remove nearby dangers
	for(var/mob/living/simple_animal/hostile/SA in view(10, created_human))
		qdel(SA)
	//Give them a space worthy suit
	var/turf/open/T = locate() in shuffle(view(1, created_human))
	if(T)
		new /obj/item/clothing/suit/space/hardsuit/ancient(T)
		new /obj/item/tank/internals/oxygen(T)
		new /obj/item/clothing/mask/gas(T)
		new /obj/item/storage/belt/utility/full(T)
	var/antag_elligable = FALSE
	switch(pickweight(list("centcom_official" = 4, "dictator" = 1, "greytide" = 3)))
		if("centcom_official")
			//created_human.flavor_text = "You are centcom official on board a badly damaged station. Making your way back to the station to uncover the secrets you hold is
			//	your top priority as far as Nanotrasen is concerned, but just surviving 1 more day is all you can ask for."
			created_human.equipOutfit(/datum/outfit/centcom_official_vip)
			antag_elligable = TRUE
		if("dictator")
			//created_human.flavor_text = "It has been months since your regime fell. Once a hero, now just someone wishing that they will see the next sunrise. You know those
			//	Nanotrasen pigs are after you, and will stop at nothing to capture you. All you want at this point is to get out and survive, however it is likely you will never leave
			//	without being captured."
			created_human.equipOutfit(/datum/outfit/vip_dictator)
			created_human.mind.add_antag_datum(/datum/antagonist/vip_dictator)
		if("greytide")
			//created_human.flavor_text = "You are just a lonely assistant, on a lonely derelict station. You dream of going home,
			//	but it would take another one of the miracles that kept you alive to get you home."
			created_human.equipOutfit(/datum/outfit/greytide)
			antag_elligable = TRUE
	if(antag_elligable)
		if(prob(7))
			created_human.mind.make_Traitor()
		else if(prob(8))
			created_human.mind.make_Changeling()
	mob_to_recover = created_human
	generated = TRUE

/obj/item/disk/record
	name = "Диск-дневник"
	desc = "Диск, который содержит интересную информацию."

/obj/item/disk/record/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/gps, "LOG[rand(1000, 9999)]", TRUE)

/obj/item/disk/record/proc/setup_recover(linked_mission)
	AddComponent(/datum/component/recoverable, linked_mission)

/obj/item/disk/record/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>Активируй это в руке <b>на мостике</b> станции, чтобы отправить Нанотрейзен нужные данные и завершить контракт.</span>"


//=====================
// Centcom Official
//=====================

/datum/outfit/centcom_official_vip
	name = "Centcom VIP"

	uniform = /obj/item/clothing/under/rank/centcom/officer
	shoes = /obj/item/clothing/shoes/sneakers/black
	gloves = /obj/item/clothing/gloves/color/black
	ears = /obj/item/radio/headset/headset_cent/empty
	glasses = /obj/item/clothing/glasses/sunglasses
	belt = /obj/item/gun/energy/e_gun
	l_pocket = /obj/item/pen
	back = /obj/item/storage/backpack/satchel
	r_pocket = /obj/item/pda/heads
	l_hand = /obj/item/clipboard
	r_hand = /obj/item/gps
	id = /obj/item/card/id/away/old

//=====================
// Matryr Dictator
//=====================

/datum/antagonist/vip_dictator
	name = "Insane VIP"
	show_in_antagpanel = TRUE
	roundend_category = "Ruin VIPs"
	antagpanel_category = "Other"

/datum/outfit/vip_dictator
	name = "Dictator VIP"

	uniform = /obj/item/clothing/under/rank/security/head_of_security
	suit = /obj/item/clothing/suit/armor/hos
	suit_store = /obj/item/gun/ballistic/automatic/pistol/m1911
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/combat
	ears = /obj/item/radio/headset
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses/eyepatch
	belt = /obj/item/storage/belt/sabre
	l_pocket = /obj/item/ammo_box/magazine/m45
	r_pocket = /obj/item/grenade/smokebomb
	id = /obj/item/card/id/away/old
	neck = /obj/item/clothing/neck/necklace/dope
	head = /obj/item/clothing/head/hos/beret/syndicate
	r_hand = /obj/item/gps

//=====================
// Greytide
//=====================

/datum/outfit/greytide
	name = "Greytide"

	uniform = /obj/item/clothing/under/color/random
	suit = /obj/item/clothing/suit/armor/vest
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/color/yellow
	ears = /obj/item/radio/headset
	glasses = /obj/item/clothing/glasses/sunglasses
	belt = /obj/item/storage/belt/utility/full/engi
	id = /obj/item/card/id
	head = /obj/item/clothing/head/helmet
	l_hand = /obj/item/melee/baton/loaded
	r_hand = /obj/item/gps

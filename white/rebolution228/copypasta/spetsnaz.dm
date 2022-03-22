/datum/ert/sobr
	roles = list(/datum/antagonist/ert/sobr, /datum/antagonist/ert/sobr/grenadier, /datum/antagonist/ert/sobr/specialist)
	leader_role = /datum/antagonist/ert/sobr/leader
	teamsize = 5
	opendoors = FALSE
	rename_team = "Спецназ"
	mission = "Уничтожить особо опасных террористов на станции."
	polldesc = "группе специального назначения"

/datum/antagonist/ert/sobr/New()
	. = ..()
	name_source = GLOB.last_names_slavic

/datum/antagonist/ert/sobr/greet()
	if(!ert_team)
		return

	owner.current.playsound_local(get_turf(owner.current), 'white/rebolution228/sounds/spetsnaz_spawn.ogg',100,0, use_reverb = FALSE)
	to_chat(owner, "<B><font size=3 color=red>Я РОССИЙСКИЙ СПЕЦНАЗ!</font></B>")
	to_chat(owner, "Вы входите в состав спецподразделения <B>'Оборотень'</B>, отправленный на станцию <B>'[station_name()]'</B> с заданием от <B>Российского Отдела Службы Безопасности NanoTrasen.</B>")
	to_chat(owner, "ПОМНИТЕ! Ваше тело имеет <B>иммунитет к вакууму и не требует кислорода.</B>")
	if(leader)
		to_chat(owner, "Являясь главой отряда, требуется руководить своим составом, чтобы обеспечить выполнение миссии. Отправьтесь на станцию при помощи шаттла, когда вы будете готовы.")
	else
		to_chat(owner, "Следуйте приказам командира отряда.")
	if(!rip_and_tear)
		to_chat(owner, "По возможности <B>избегайте</B> жертв среди гражданского населения.")
	to_chat(owner, "<BR><B>МИССИЯ:</B> [ert_team.mission.explanation_text]")

/datum/antagonist/ert/sobr/on_gain()
	. = ..()
	givespaceproof()

/datum/antagonist/ert/sobr/proc/givespaceproof()
	var/mob/living/carbon/human/H = owner.current
	if(!istype(H))
		return
	H.dna.add_mutation(/datum/mutation/human/spaceproof)

/datum/antagonist/ert/sobr
	name = "СОБР"
	outfit = /datum/outfit/sobr
	random_names = TRUE
	role = "СОБР"
	greentext_reward = 15

/datum/antagonist/ert/sobr/grenadier
	outfit = /datum/outfit/sobr/grenadier

/datum/antagonist/ert/sobr/specialist
	outfit = /datum/outfit/sobr/cqc

/datum/antagonist/ert/sobr/leader
	name = "Лидер СОБР"
	outfit = /datum/outfit/sobr/leader
	role = "Лидер СОБР"
	leader = TRUE
	greentext_reward = 20

/datum/antagonist/ert/sobr/update_name()
	if(owner.current.gender == FEMALE)
		owner.current.fully_replace_character_name(owner.current.real_name,"[pick("Капитан", "Майор", "Подполковник")] [pick(name_source)]а")
	else
		owner.current.fully_replace_character_name(owner.current.real_name,"[pick("Капитан", "Майор", "Подполковник")] [pick(name_source)]")

/datum/antagonist/ert/sobr/leader/update_name()
	if(owner.current.gender == FEMALE)
		owner.current.fully_replace_character_name(owner.current.real_name,"Полковник [pick(name_source)]а")
	else
		owner.current.fully_replace_character_name(owner.current.real_name,"Полковник [pick(name_source)]")


////////////////OUTFITS//////////////////////

/datum/outfit/sobr
	name = "СОБР-стрелок"

	uniform = /obj/item/clothing/under/rank/sobr
	suit = /obj/item/clothing/suit/armor/opvest/sobr
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat/sobr
	ears = /obj/item/radio/headset/headset_cent/alt
	belt = /obj/item/storage/belt/military/assault/sobr/laser
	id = /obj/item/card/id/advanced/centcom/spetsnaz
	id_trim = /datum/id_trim/centcom/spetsnaz
	r_pocket = /obj/item/kitchen/knife/combat
	l_pocket = /obj/item/flashlight/seclite
	head = null
	mask = null
	back = /obj/item/storage/backpack/security
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
							/obj/item/storage/box/handcuffs=1,\
							/obj/item/melee/classic_baton/german=1,\
							/obj/item/crowbar/red=1,\
							/obj/item/storage/firstaid/regular=1)

/datum/outfit/sobr/pre_equip(mob/living/carbon/human/H)
	suit_store = /obj/item/gun/ballistic/automatic/laser/sar62l
	var/randomhelmet = pick(/obj/item/clothing/head/helmet/maska, \
						/obj/item/clothing/head/helmet/maska/black, \
						/obj/item/clothing/head/helmet/maska/altyn, \
						/obj/item/clothing/head/helmet/maska/altyn/black)
	if(prob(40))
		mask = /obj/item/clothing/mask/gas/heavy/m40
	else if(prob(30))
		mask = /obj/item/clothing/mask/rag
	else
		mask = /obj/item/clothing/mask/balaclava/swat

	if(prob(3))
		head = /obj/item/clothing/head/helmet/maska/adidas
	else
		head = randomhelmet

/datum/outfit/sobr/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/radio/R = H.ears
	R.keyslot = new /obj/item/encryptionkey/headset_sec
	R.recalculateChannels()

	var/obj/item/card/id/W = H.wear_id
	W.assignment = "Оперативник СОБР"
	W.registered_name = H.real_name
	W.update_label()

	var/obj/item/implant/mindshield/L = new/obj/item/implant/mindshield(H)
	L.implant(H, null, 1)

/datum/outfit/sobr/grenadier
	name = "СОБР-гранатометчик"

	belt = /obj/item/storage/belt/military/assault/sobr/laser/grenadier

/datum/outfit/sobr/grenadier/pre_equip(mob/living/carbon/human/H)
	suit_store = /obj/item/gun/ballistic/automatic/laser/sar62l/gp
	var/randomhelmet = pick(/obj/item/clothing/head/helmet/maska, \
						/obj/item/clothing/head/helmet/maska/black, \
						/obj/item/clothing/head/helmet/maska/altyn, \
						/obj/item/clothing/head/helmet/maska/altyn/black)
	if(prob(33))
		mask = /obj/item/clothing/mask/gas/heavy/m40
	if(prob(10))
		mask = /obj/item/clothing/mask/rag
	else
		mask = /obj/item/clothing/mask/balaclava/swat

	if(prob(3))
		head = /obj/item/clothing/head/helmet/maska/adidas
	else
		head = randomhelmet

/datum/outfit/sobr/grenadier/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/radio/R = H.ears
	R.keyslot = new /obj/item/encryptionkey/headset_sec
	R.recalculateChannels()

	var/obj/item/card/id/W = H.wear_id
	W.assignment = "Оперативник СОБР"
	W.registered_name = H.real_name
	W.update_label()

	var/obj/item/implant/mindshield/L = new/obj/item/implant/mindshield(H)
	L.implant(H, null, 1)


/datum/outfit/sobr/cqc
	name = "СОБР-специалист"

	suit = /obj/item/clothing/suit/armor/heavysobr
	belt = /obj/item/storage/belt/military/assault/sobr/specialist
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
							/obj/item/storage/box/handcuffs=1,\
							/obj/item/melee/classic_baton/german=1,\
							/obj/item/crowbar/power=1,\
							/obj/item/storage/firstaid/regular=1,)

/datum/outfit/sobr/cqc/pre_equip(mob/living/carbon/human/H)
	suit_store = /obj/item/gun/ballistic/shotgun/saiga
	var/randomhelmet_black = pick(/obj/item/clothing/head/helmet/maska/black, \
								/obj/item/clothing/head/helmet/maska/altyn/black)

	if(prob(44))
		mask = /obj/item/clothing/mask/gas/heavy/m40
	else
		mask = /obj/item/clothing/mask/balaclava/swat

	if(prob(1))
		head = /obj/item/clothing/head/helmet/maska/adidas
	else
		head = randomhelmet_black

/datum/outfit/sobr/cqc/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/radio/R = H.ears
	R.keyslot = new /obj/item/encryptionkey/headset_sec
	R.recalculateChannels()

	var/obj/item/card/id/W = H.wear_id
	W.assignment = "Специалист СОБР"
	W.registered_name = H.real_name
	W.update_label()

	var/obj/item/implant/mindshield/L = new/obj/item/implant/mindshield(H)
	L.implant(H, null, 1)


/datum/outfit/sobr/leader
	name = "СОБР-лидер☆"

	uniform = /obj/item/clothing/under/rank/sobr
	suit = /obj/item/clothing/suit/armor/opvest/sobr
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat/sobr
	ears = /obj/item/radio/headset/headset_cent/alt
	head = /obj/item/clothing/head/hos/beret/sobr
	mask = null
	glasses = /obj/item/clothing/glasses/sunglasses
	belt =/obj/item/storage/belt/military/assault/sobr/leader
	id = /obj/item/card/id/advanced/centcom/spetsnaz/leader
	id_trim = /datum/id_trim/centcom/spetsnaz/leader
	r_pocket = /obj/item/kitchen/knife/combat
	l_pocket = /obj/item/flashlight/seclite
	back = /obj/item/storage/backpack/satchel/sec
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
							/obj/item/storage/box/handcuffs=1,\
							/obj/item/melee/classic_baton/german=1,\
							/obj/item/crowbar/red=1,\
							/obj/item/storage/firstaid/regular=1)

/datum/outfit/sobr/leader/pre_equip(mob/living/carbon/human/H)
	suit_store = /obj/item/gun/ballistic/automatic/asval

/datum/outfit/sobr/leader/post_equip(mob/living/carbon/human/H, visualsOnly)
	var/obj/item/radio/R = H.ears
	R.keyslot = new /obj/item/encryptionkey/heads/hos
	R.recalculateChannels()

	var/obj/item/card/id/W = H.wear_id
	W.assignment = "Лидер СОБР"
	W.registered_name = H.real_name
	W.update_label()

	var/obj/item/implant/mindshield/L = new/obj/item/implant/mindshield(H)
	L.implant(H, null, 1)

////////////////////ITEMS//////////////////////

/obj/item/storage/belt/military/assault/sobr
	name = "штурмовой пояс"
	desc = "Тактический штурмовой пояс, которые носят некоторые вооруженные отряды."

/obj/item/storage/belt/military/assault/sobr/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 7

/obj/item/storage/belt/military/assault/sobr/PopulateContents()
		new /obj/item/ammo_box/magazine/ak74m(src)
		new /obj/item/ammo_box/magazine/ak74m(src)
		new /obj/item/ammo_box/magazine/ak74m(src)
		new /obj/item/ammo_box/magazine/ak74m(src)
		new /obj/item/grenade/stingbang(src)

/obj/item/storage/belt/military/assault/sobr/laser
/obj/item/storage/belt/military/assault/sobr/laser/PopulateContents()
		new /obj/item/ammo_box/magazine/recharge/sar62l(src)
		new /obj/item/ammo_box/magazine/recharge/sar62l(src)
		new /obj/item/ammo_box/magazine/recharge/sar62l(src)
		new /obj/item/ammo_box/magazine/recharge/sar62l(src)
		new /obj/item/grenade/stingbang(src)

/obj/item/storage/belt/military/assault/sobr/laser/grenadier
/obj/item/storage/belt/military/assault/sobr/laser/grenadier/PopulateContents()
		new /obj/item/ammo_box/magazine/recharge/sar62l(src)
		new /obj/item/ammo_box/magazine/recharge/sar62l(src)
		new /obj/item/ammo_box/magazine/recharge/sar62l(src)
		new /obj/item/ammo_box/magazine/recharge/sar62l(src)
		new /obj/item/ammo_casing/a40mm/vg240(src)
		new /obj/item/grenade/stingbang(src)

/obj/item/storage/belt/military/assault/sobr/grenadier
/obj/item/storage/belt/military/assault/sobr/grenadier/PopulateContents()
		new /obj/item/ammo_box/magazine/ak74m(src)
		new /obj/item/ammo_box/magazine/ak74m(src)
		new /obj/item/ammo_box/magazine/ak74m(src)
		new /obj/item/ammo_box/magazine/ak74m(src)
		new /obj/item/ammo_casing/a40mm/vog25(src)
		new /obj/item/grenade/stingbang(src)

/obj/item/storage/belt/military/assault/sobr/specialist
/obj/item/storage/belt/military/assault/sobr/specialist/PopulateContents()
		new /obj/item/ammo_box/magazine/saiga(src)
		new /obj/item/ammo_box/magazine/saiga(src)
		new /obj/item/ammo_box/magazine/saiga(src)
		new /obj/item/ammo_box/magazine/saiga(src)
		new /obj/item/ammo_box/magazine/saiga(src)
		new /obj/item/grenade/c4(src)
		new /obj/item/grenade/c4(src)

/obj/item/storage/belt/military/assault/sobr/leader
/obj/item/storage/belt/military/assault/sobr/leader/PopulateContents()
		new /obj/item/ammo_box/magazine/asval(src)
		new /obj/item/ammo_box/magazine/asval(src)
		new /obj/item/ammo_box/magazine/asval(src)
		new /obj/item/ammo_box/magazine/asval(src)
		new /obj/item/grenade/stingbang(src)
		new /obj/item/grenade/frag(src)

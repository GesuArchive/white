/datum/ert/spetsnaz
	roles = list(/datum/antagonist/ert/spetsnaz, /datum/antagonist/ert/spetsnaz/grenadier)
	leader_role = /datum/antagonist/ert/spetsnaz/leader
	teamsize = 5
	opendoors = FALSE
	rename_team = "Спецназ"
	mission = "Уничтожить особо опасных террористов на станции."
	polldesc = "отряде специального назначения"

/datum/antagonist/ert/spetsnaz/greet()
	if(!ert_team)
		return

	owner.current.playsound_local(get_turf(owner.current), 'white/rebolution228/sounds/spetsnaz_spawn.ogg',100,0, use_reverb = FALSE)
	to_chat(owner, "<B><font size=3 color=red>Я [name].</font></B>")
	var/missiondesc = "Мой отряд был отправлен на станцию [station_name()] с миссией от Отдела Безопасности Нанотрейсен ."
	if(leader)
		missiondesc += "Ведите свой отряд чтобы обеспечить выполнение миссии. Садитесь на шаттл, когда ваша команда будет готова."
	else
		missiondesc += "Следуйте приказам командира отряда."
	if(!rip_and_tear)
		missiondesc += "По возможности избегайте жертв среди гражданского населения."

	missiondesc += "<BR><B>Ваша миссия</B>: [ert_team.mission.explanation_text]"
	to_chat(owner,missiondesc)

/datum/antagonist/ert/spetsnaz/on_gain()
	. = ..()
	huivanus()

/datum/antagonist/ert/spetsnaz/proc/huivanus()
	var/mob/living/carbon/C = owner.current
	if(!istype(C))
		return
	C.dna.add_mutation(/datum/mutation/human/spaceproof)

/datum/antagonist/ert/spetsnaz
	name = "Спецназ"
	outfit = /datum/outfit/spetsnaz
	random_names = TRUE
	role = "Спецназовец"

/datum/antagonist/ert/spetsnaz/grenadier
	outfit = /datum/outfit/spetsnaz/grenadier

/datum/antagonist/ert/spetsnaz/leader
	name = "Лидер отряда"
	outfit = /datum/outfit/spetsnaz/leader
	role = "Лидер отряда спецназа"

/datum/antagonist/ert/spetsnaz/update_name()
	if(owner.current.gender == FEMALE)
		owner.current.fully_replace_character_name(owner.current.real_name,"[pick("Ефрейтор", "Сержант")] [pick(name_source)]а")
	else
		owner.current.fully_replace_character_name(owner.current.real_name,"[pick("Ефрейтор", "Сержант")] [pick(name_source)]")

/datum/antagonist/ert/spetsnaz/leader/update_name()
	if(owner.current.gender == FEMALE)
		owner.current.fully_replace_character_name(owner.current.real_name,"Лейтенант [pick(name_source)]а")
	else
		owner.current.fully_replace_character_name(owner.current.real_name,"Лейтенант [pick(name_source)]")


//

/datum/outfit/spetsnaz
	name = "Спецназовец"

	uniform = /obj/item/clothing/under/rank/omon/green
	suit = /obj/item/clothing/suit/armor/wzzzz/opvest/spetsnaz
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	ears = /obj/item/radio/headset/headset_cent/alt
	head = /obj/item/clothing/head/helmet/maskasch
	mask = /obj/item/clothing/mask/balaclava/wzzzz/swatclava/grey
	belt = /obj/item/storage/belt/military/spetsnaz
	id = /obj/item/card/id/advanced/centcom
	r_pocket = /obj/item/kitchen/knife/combat

/datum/outfit/spetsnaz/pre_equip(mob/living/carbon/human/H)
	back = /obj/item/gun/ballistic/automatic/ak74m

/datum/outfit/spetsnaz/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/radio/R = H.ears
	R.keyslot = new /obj/item/encryptionkey/headset_sec
	R.recalculateChannels()

	var/obj/item/card/id/W = H.wear_id
	W.access += ACCESS_WEAPONS
	W.access += ACCESS_MAINT_TUNNELS
	W.assignment = name
	W.registered_name = H.real_name
	W.update_label()

/datum/outfit/spetsnaz/grenadier
	belt = /obj/item/storage/belt/military/spetsnaz/grenadier

/datum/outfit/spetsnaz/pre_equip(mob/living/carbon/human/H)
	back = /obj/item/gun/ballistic/automatic/ak74m/gp25

/datum/outfit/spetsnaz/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/radio/R = H.ears
	R.keyslot = new /obj/item/encryptionkey/headset_sec
	R.recalculateChannels()

	var/obj/item/card/id/W = H.wear_id
	W.access += ACCESS_WEAPONS
	W.access += ACCESS_MAINT_TUNNELS
	W.assignment = name
	W.registered_name = H.real_name
	W.update_label()

/datum/outfit/spetsnaz/leader
	name = "Лидер Спецназа"

	uniform = /obj/item/clothing/under/rank/omon/green
	suit = /obj/item/clothing/suit/armor/wzzzz/opvest/spetsnaz
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	ears = /obj/item/radio/headset/headset_cent/alt
	head = /obj/item/clothing/head/beret/sec
	mask = null
	glasses = /obj/item/clothing/glasses/sunglasses
	belt = /obj/item/storage/belt/military/spetsnaz/leader
	id = /obj/item/card/id/advanced/centcom
	r_pocket = /obj/item/kitchen/knife/combat

/datum/outfit/spetsnaz/leader/pre_equip(mob/living/carbon/human/H)
	back = /obj/item/gun/ballistic/automatic/asval

/datum/outfit/spetsnaz/leader/post_equip(mob/living/carbon/human/H, visualsOnly)
	var/obj/item/radio/R = H.ears
	R.keyslot = new /obj/item/encryptionkey/heads/hos
	R.recalculateChannels()
	var/obj/item/card/id/W = H.wear_id
	W.access += ACCESS_WEAPONS
	W.access += ACCESS_MAINT_TUNNELS
	W.assignment = name
	W.registered_name = H.real_name
	W.update_label()

//

/obj/item/storage/belt/military/spetsnaz
	desc = "Набор тактических ремней, которые носят некоторые вооруженные отряды."

/obj/item/storage/belt/military/spetsnaz/grenadier

/obj/item/storage/belt/military/spetsnaz/leader

/obj/item/storage/belt/military/spetsnaz/PopulateContents()
		new /obj/item/ammo_box/magazine/ak74m(src)
		new /obj/item/ammo_box/magazine/ak74m(src)
		new /obj/item/ammo_box/magazine/ak74m(src)
		new /obj/item/ammo_box/magazine/ak74m(src)
		new /obj/item/reagent_containers/hypospray/medipen/stimpack/traitor(src)
		new /obj/item/grenade/stingbang(src)

/obj/item/storage/belt/military/spetsnaz/grenadier/PopulateContents()
		new /obj/item/ammo_box/magazine/ak74m(src)
		new /obj/item/ammo_box/magazine/ak74m(src)
		new /obj/item/ammo_box/magazine/ak74m(src)
		new /obj/item/ammo_casing/a40mm/vog25(src)
		new /obj/item/reagent_containers/hypospray/medipen/stimpack/traitor(src)
		new /obj/item/grenade/stingbang(src)

/obj/item/storage/belt/military/spetsnaz/leader/PopulateContents()
		new /obj/item/ammo_box/magazine/asval(src)
		new /obj/item/ammo_box/magazine/asval(src)
		new /obj/item/ammo_box/magazine/asval(src)
		new /obj/item/ammo_box/magazine/asval(src)
		new /obj/item/reagent_containers/hypospray/medipen/stimpack/traitor(src)
		new /obj/item/reagent_containers/hypospray/medipen/stimpack/traitor(src)

/obj/item/clothing/suit/armor/wzzzz/opvest/spetsnaz
	armor = list(MELEE = 60, BULLET = 80, LASER = 60, ENERGY = 60, BOMB = 50, BIO = 20, RAD = 20, WOUND = 10)
	strip_delay = 100

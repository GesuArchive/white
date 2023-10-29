/datum/outfit/pmc
	name = "ЧВК в одежде"

	uniform = /obj/item/clothing/under/syndicate/camo
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	ears = /obj/item/radio/headset/headset_cent/alt
	head = /obj/item/clothing/head/helmet/rus_ushanka
	glasses = /obj/item/clothing/glasses/sunglasses/big
	id = /obj/item/card/id/advanced/centcom/ert
	back = /obj/item/storage/backpack/ert
	box = /obj/item/storage/box/survival/syndie
	r_pocket = /obj/item/restraints/handcuffs
	suit = /obj/item/clothing/suit/armor/vest/blueshirt

	backpack_contents = list(	/obj/item/storage/mre/protein = 1
	)
	implants = list(/obj/item/implant/sound_implant, /obj/item/implant/mindshield, /obj/item/implant/aimbot)

/datum/outfit/pmc/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/radio/R = H.ears
	R.keyslot = new /obj/item/encryptionkey/headset_sec
	R.recalculateChannels()

	var/obj/item/card/id/W = H.wear_id
	W.assignment = name
	W.registered_name = H.real_name
	W.update_label()

/datum/outfit/pmc/armed
	name = "ЧВК с пушкой"
	l_pocket = /obj/item/ammo_box/magazine/smgm9mm
	suit_store = /obj/item/gun/ballistic/automatic/proto/unrestricted/suppressed
	backpack_contents = list(/obj/item/ammo_box/magazine/smgm9mm = 2,
								/obj/item/storage/firstaid/regular = 1)
/datum/outfit/pmc/leader
	name = "Лидер ЧВК"
	mask = /obj/item/clothing/mask/bandana/skull/black
	belt = /obj/item/melee/baseball_bat/hos/hammer/pmc
	backpack_contents = list(/obj/item/storage/mre/protein = 1,
								/obj/item/storage/firstaid/regular = 1,
								/obj/item/ammo_box/fallout/sks = 2
								)
	l_pocket = /obj/item/ammo_box/fallout/sks
	suit_store = /obj/item/gun/ballistic/shotgun/automatic/fallout/battle/sks


/datum/outfit/pmc/leader/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(!visualsOnly)	//Позаимствуем костыль
		var/obj/item/organ/cyberimp/brain/anti_stun/L = new/obj/item/organ/cyberimp/brain/anti_stun
		L.Insert(H, null, 1)


/datum/outfit/pmc/medic
	name = "Медик ЧВК"
	id = /obj/item/card/id/advanced/centcom/ert/medical
	suit = /obj/item/clothing/suit/armor/vest/fieldmedic/med
	backpack_contents = list(/obj/item/storage/firstaid/medical/field_surgery = 1,
							/obj/item/optable = 1,
							/obj/item/modular_computer/laptop/preset/medical = 1,
							/obj/item/storage/belt/medipenal/field_med = 1)

	glasses = /obj/item/clothing/glasses/hud/health/sunglasses
	gloves = /obj/item/clothing/gloves/color/latex/nitrile
	belt =  /obj/item/defibrillator/compact/combat/loaded
	back = /obj/item/storage/backpack/ert/medical

/datum/outfit/pmc/medic/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(!visualsOnly)	//Позаимствуем костыль
		var/obj/item/organ/cyberimp/arm/surgery/L = new/obj/item/organ/cyberimp/arm/surgery
		L.Insert(H, null, 1)
/datum/outfit/pmc/gunner
	name = "Стрелок ЧВК"
	id = /obj/item/card/id/advanced/centcom/ert/security
	suit = /obj/item/clothing/suit/armor/vest/marine/security
	head = /obj/item/clothing/head/helmet/swat/nanotrasen
	belt = /obj/item/storage/belt/military/smg
	back = /obj/item/storage/backpack/duffelbag/syndie
	backpack_contents = list(/obj/item/storage/mre/protein = 1,
								 /obj/item/gun/ballistic/automatic/pistol/suppressed = 1,
								 /obj/item/ammo_box/c9mm = 5,
								 /obj/item/ammo_box/magazine/m9mm = 2,

								 )
	suit_store = /obj/item/gun/ballistic/automatic/proto/unrestricted/suppressed

/datum/outfit/pmc/techie
	name = "Техник ЧВК"

	id = /obj/item/card/id/advanced/centcom/ert/engineer
	suit = /obj/item/clothing/suit/armor/vest/alt
	suit_store = /obj/item/flashlight/seclite
	back = /obj/item/storage/backpack/ert/engineer
	backpack_contents = list(
		/obj/item/storage/mre/protein = 1,
		/obj/item/quikdeploy/cade/plasteel = 3,
		/obj/item/crowbar/power = 1,
		/obj/item/grenade/antigravity/heavy = 2)
	belt = /obj/item/construction/rcd/arcd
	glasses =  /obj/item/clothing/glasses/meson/night
	l_pocket = /obj/item/rcd_ammo/large
	r_pocket = /obj/item/rcd_ammo/large
	skillchips = list(/obj/item/skillchip/job/engineer)

/datum/outfit/pmc/techie/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(!visualsOnly)	//Позаимствуем костыль
		var/obj/item/organ/cyberimp/arm/toolset/L = new/obj/item/organ/cyberimp/arm/toolset
		L.Insert(H, null, 1)

/datum/outfit/pmc/enforcer
	name = "Силовик ЧВК"
	id = /obj/item/card/id/advanced/centcom/ert/security
	suit = /obj/item/clothing/suit/armor/vest/marine
	head = /obj/item/clothing/head/helmet/marine
	suit_store = /obj/item/gun/ballistic/shotgun/fallout/lever
	belt = /obj/item/storage/belt/bandolier/double/mixed
	l_hand = /obj/item/shield/riot/military/tactical
	l_pocket = /obj/item/stack/medical/gauze
	r_pocket = /obj/item/reagent_containers/hypospray/medipen
	mask = /obj/item/clothing/mask/gas/syndicate
	back = /obj/item/storage/backpack/satchel




/datum/outfit/pmc/solo
	name = "Специалист ЧВК"
	id = /obj/item/card/id/advanced/centcom/ert/security
	suit = /obj/item/clothing/suit/armor/vest
	head = /obj/item/clothing/head/hos/dermal
	suit_store = /obj/item/gun/ballistic/automatic/proto/unrestricted/suppressed
	belt = /obj/item/storage/belt/military/smg
	l_pocket = /obj/item/ammo_box/magazine/m9mm/fire
	r_pocket = /obj/item/extinguisher/mini //Oh no!
	back = /obj/item/storage/backpack/ert
	backpack_contents = list(/obj/item/storage/mre/protein = 1,
							/obj/item/storage/box/flashbangs = 1,
							/obj/item/grenade/c4 = 4)
	var/list/organs = list(/obj/item/organ/cyberimp/chest/reviver,
							/obj/item/organ/eyes/robotic/xray,
							/obj/item/organ/ears/cybernetic/upgraded)

/datum/outfit/pmc/solo/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	for (var/i in organs)
		var/obj/item/organ/L = new i()
		L.Insert(H, TRUE, FALSE)

/obj/item/storage/belt/bandolier/double/mixed/PopulateContents()
	for(var/i in 1 to 36)
		new /obj/item/ammo_casing/shotgun/buckshot(src)


/obj/item/shield/riot/military/tactical
	desc = "Очень крепкий и очень тяжёлый.<hr>У него есть крепления для ношения на спине."
	slot_flags = ITEM_SLOT_BACK
/obj/item/melee/baseball_bat/hos/hammer/pmc
	desc = "Этой штукой совершали военные преступления, жесточайше вышибая коленки. Не хватает только напалма..."
	reskinned = TRUE


/obj/item/storage/belt/military/smg
	desc = "Тактикульненько."

/obj/item/storage/belt/military/smg/PopulateContents()
	for (var/i in 1 to 4)
		new  /obj/item/ammo_box/magazine/smgm9mm(src)
	new /obj/item/grenade/frag(src)
	new /obj/item/grenade/frag(src)
	new /obj/item/kitchen/knife/combat/survival(src)


/obj/item/gun/ballistic/automatic/proto/unrestricted/suppressed/Initialize(mapload)
	. = ..()
	var/obj/item/suppressor/S = new(src)
	install_suppressor(S)

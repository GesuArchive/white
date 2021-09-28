/datum/outfit/centcom
	implants = list(/obj/item/implant/sound_implant)

/datum/outfit/centcom/ert
	name = "ERT Common"

	mask = /obj/item/clothing/mask/gas/sechailer
	uniform = /obj/item/clothing/under/rank/centcom/officer
	shoes = /obj/item/clothing/shoes/combat/swat
	gloves = /obj/item/clothing/gloves/combat
	ears = /obj/item/radio/headset/headset_cent/alt

/datum/outfit/centcom/ert/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/radio/R = H.ears
	R.set_frequency(FREQ_CENTCOM)
	R.freqlock = TRUE

	var/obj/item/card/id/W = H.wear_id
	if(W)
		W.registered_name = H.real_name
		W.update_label()
		W.update_icon()
	return ..()

/datum/outfit/centcom/ert/commander
	name = "ERT Commander"

	id = /obj/item/card/id/advanced/centcom/ert
	suit = /obj/item/clothing/suit/space/hardsuit/ert
	suit_store = /obj/item/gun/energy/e_gun
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	back = /obj/item/storage/backpack/ert
	belt = /obj/item/storage/belt/security/full
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1)
	l_pocket = /obj/item/switchblade
	skillchips = list(/obj/item/skillchip/disk_verifier)

/datum/outfit/centcom/ert/commander/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return
	var/obj/item/radio/R = H.ears
	R.keyslot = new /obj/item/encryptionkey/heads/captain
	R.recalculateChannels()

/datum/outfit/centcom/ert/commander/alert
	name = "ERT Commander - High Alert"

	mask = /obj/item/clothing/mask/gas/sechailer/swat
	glasses = /obj/item/clothing/glasses/thermal/eyepatch
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
		/obj/item/gun/energy/pulse/pistol/loyalpin=1)
	l_pocket = /obj/item/melee/energy/sword/saber

/datum/outfit/centcom/ert/security
	name = "ERT Security"

	id = /obj/item/card/id/advanced/centcom/ert/security
	suit = /obj/item/clothing/suit/space/hardsuit/ert/sec
	suit_store = /obj/item/gun/energy/e_gun/stun
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	back = /obj/item/storage/backpack/ert/security
	belt = /obj/item/storage/belt/security/full
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
		/obj/item/storage/box/handcuffs=1)

/datum/outfit/centcom/ert/security/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	var/obj/item/radio/R = H.ears
	R.keyslot = new /obj/item/encryptionkey/heads/hos
	R.recalculateChannels()

/datum/outfit/centcom/ert/security/alert
	name = "ERT Security - High Alert"

	mask = /obj/item/clothing/mask/gas/sechailer/swat
	belt = /obj/item/gun/energy/pulse/carbine/loyalpin
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
		/obj/item/storage/box/handcuffs=1)


/datum/outfit/centcom/ert/medic
	name = "ERT Medic"

	id = /obj/item/card/id/advanced/centcom/ert/medical
	suit = /obj/item/clothing/suit/space/hardsuit/ert/med
	suit_store = /obj/item/gun/energy/e_gun
	glasses = /obj/item/clothing/glasses/hud/health
	back = /obj/item/storage/backpack/ert/medical
	belt = /obj/item/storage/belt/medical
	l_hand = /obj/item/storage/firstaid/regular
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
		/obj/item/reagent_containers/hypospray/combat=1,\
		/obj/item/gun/medbeam=1)
	skillchips = list(/obj/item/skillchip/entrails_reader)

/datum/outfit/centcom/ert/medic/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()


	if(visualsOnly)
		return

	var/obj/item/radio/R = H.ears
	R.keyslot = new /obj/item/encryptionkey/heads/cmo
	R.recalculateChannels()

/datum/outfit/centcom/ert/medic/alert
	name = "ERT Medic - High Alert"

	mask = /obj/item/clothing/mask/gas/sechailer/swat
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
		/obj/item/gun/energy/pulse/pistol/loyalpin=1,\
		/obj/item/reagent_containers/hypospray/combat/nanites=1,\
		/obj/item/gun/medbeam=1)

/datum/outfit/centcom/ert/engineer
	name = "ERT Engineer"

	id = /obj/item/card/id/advanced/centcom/ert/engineer
	suit = /obj/item/clothing/suit/space/hardsuit/ert/engi
	suit_store = /obj/item/gun/energy/e_gun
	glasses =  /obj/item/clothing/glasses/meson/engine
	back = /obj/item/storage/backpack/ert/engineer
	belt = /obj/item/storage/belt/utility/full
	l_pocket = /obj/item/rcd_ammo/large
	l_hand = /obj/item/storage/firstaid/regular
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
		/obj/item/construction/rcd/loaded=1)
	skillchips = list(/obj/item/skillchip/job/engineer)


/datum/outfit/centcom/ert/engineer/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	var/obj/item/radio/R = H.ears
	R.keyslot = new /obj/item/encryptionkey/heads/ce
	R.recalculateChannels()

/datum/outfit/centcom/ert/engineer/alert
	name = "ERT Engineer - High Alert"

	mask = /obj/item/clothing/mask/gas/sechailer/swat
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
		/obj/item/gun/energy/pulse/pistol/loyalpin=1,\
		/obj/item/construction/rcd/combat=1)


/datum/outfit/centcom/centcom_official
	name = "CentCom Official"

	uniform = /obj/item/clothing/under/rank/centcom/officer
	shoes = /obj/item/clothing/shoes/sneakers/black
	gloves = /obj/item/clothing/gloves/color/black
	ears = /obj/item/radio/headset/headset_cent
	glasses = /obj/item/clothing/glasses/sunglasses
	belt = /obj/item/gun/energy/e_gun
	l_pocket = /obj/item/pen
	back = /obj/item/storage/backpack/satchel
	r_pocket = /obj/item/pda/heads
	l_hand = /obj/item/clipboard
	id = /obj/item/card/id/advanced/centcom
	backpack_contents = list(/obj/item/stamp/centcom=1)
	id_trim = /datum/id_trim/centcom/official

/datum/outfit/centcom/centcom_official/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/pda/heads/pda = H.r_store
	pda.owner = H.real_name
	pda.ownjob = "CentCom Official"
	pda.update_label()

	var/obj/item/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.update_label()
	W.update_icon()
	return ..()

/datum/outfit/centcom/ert/commander/inquisitor
	name = "Капитан Инквизиторов"
	l_hand = /obj/item/nullrod/scythe/talking/chainsword
	suit = /obj/item/clothing/suit/space/hardsuit/ert/paranormal
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1)

/datum/outfit/centcom/ert/security/inquisitor
	name = "Охранник Инвизиторов"

	suit = /obj/item/clothing/suit/space/hardsuit/ert/paranormal/inquisitor
	suit_store = /obj/item/gun/energy/e_gun/stun

	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,
		/obj/item/storage/box/handcuffs=1,
		/obj/item/construction/rcd/loaded=1)

/datum/outfit/centcom/ert/medic/inquisitor
	name = "Медик Инвизиторов"

	suit = /obj/item/clothing/suit/space/hardsuit/ert/paranormal/inquisitor

	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,
		/obj/item/reagent_containers/hypospray/combat=1,
		/obj/item/reagent_containers/hypospray/combat/heresypurge=1,
		/obj/item/gun/medbeam=1)

/datum/outfit/centcom/ert/chaplain
	name = "Капеллан ERT"

	suit = /obj/item/clothing/suit/space/hardsuit/ert/paranormal/inquisitor // Chap role always gets this suit
	suit_store = /obj/item/gun/energy/e_gun
	id = /obj/item/card/id/advanced/centcom/ert/chaplain
	glasses = /obj/item/clothing/glasses/hud/health
	back = /obj/item/storage/backpack/cultpack
	belt = /obj/item/storage/belt/soulstone
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,
		/obj/item/nullrod=1,
		)

/datum/outfit/centcom/ert/chaplain/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return
	var/obj/item/radio/R = H.ears
	R.keyslot = new /obj/item/encryptionkey/heads/hop
	R.recalculateChannels()

/datum/outfit/centcom/ert/chaplain/inquisitor
	name = "Капеллан Инквизиторов"

	belt = /obj/item/storage/belt/soulstone/full/chappy
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,
		/obj/item/grenade/chem_grenade/holy=1,
		/obj/item/nullrod=1
		)

/datum/outfit/centcom/ert/janitor
	name = "Уборщик ERT"

	id = /obj/item/card/id/advanced/centcom/ert/janitor
	suit = /obj/item/clothing/suit/space/hardsuit/ert/jani
	glasses = /obj/item/clothing/glasses/night
	back = /obj/item/storage/backpack/ert/janitor
	belt = /obj/item/storage/belt/janitor/full
	r_pocket = /obj/item/grenade/chem_grenade/cleaner
	l_pocket = /obj/item/grenade/chem_grenade/cleaner
	l_hand = /obj/item/storage/bag/trash/bluespace
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
		/obj/item/storage/box/lights/mixed=1,\
		/obj/item/mop/advanced=1,\
		/obj/item/reagent_containers/glass/bucket=1,\
		/obj/item/grenade/clusterbuster/cleaner=1)

/datum/outfit/centcom/ert/janitor/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	var/obj/item/radio/R = H.ears
	R.keyslot = new /obj/item/encryptionkey/headset_service
	R.recalculateChannels()

/datum/outfit/centcom/ert/janitor/heavy
	name = "Уборщик ERT - сверхмощный"

	mask = /obj/item/clothing/mask/gas/sechailer/swat
	l_hand = /obj/item/reagent_containers/spray/chemsprayer/janitor
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
		/obj/item/storage/box/lights/mixed=1,\
		/obj/item/grenade/clusterbuster/cleaner=3)

/datum/outfit/centcom/ert/clown
	name = "Клоун ERT"

	suit = /obj/item/clothing/suit/space/hardsuit/ert/clown
	mask = /obj/item/clothing/mask/gas/clown_hat
	id = /obj/item/card/id/advanced/centcom/ert/clown
	glasses = /obj/item/clothing/glasses/godeye
	back = /obj/item/storage/backpack/ert/clown
	backpack_contents = list(
		/obj/item/gun/ballistic/revolver/reverse = 1,
		/obj/item/melee/energy/sword/bananium = 1,
		/obj/item/shield/energy/bananium = 1,
		/obj/item/storage/box/survival/engineer = 1,
)
	belt = /obj/item/storage/belt/champion
	glasses = /obj/item/clothing/glasses/trickblindfold
	mask = /obj/item/clothing/mask/gas/clown_hat
	shoes = /obj/item/clothing/shoes/clown_shoes/combat
	r_pocket = /obj/item/bikehorn/golden
	l_pocket = /obj/item/food/grown/banana
	backpack_contents = list(/obj/item/storage/box/hug/survival=1,\
		/obj/item/melee/energy/sword/bananium=1,\
		/obj/item/shield/energy/bananium=1,\
		/obj/item/gun/ballistic/revolver/reverse=1)

/datum/outfit/centcom/ert/clown/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return
	var/obj/item/radio/R = H.ears
	R.keyslot = new /obj/item/encryptionkey/headset_service
	R.recalculateChannels()
	ADD_TRAIT(H, TRAIT_NAIVE, INNATE_TRAIT)
	H.dna.add_mutation(CLOWNMUT)
	for(var/datum/mutation/human/clumsy/M in H.dna.mutations)
		M.mutadone_proof = TRUE

/datum/outfit/centcom/centcom_intern
	name = "Интерн ЦентКома"

	uniform = /obj/item/clothing/under/rank/centcom/intern
	shoes = /obj/item/clothing/shoes/sneakers/black
	gloves = /obj/item/clothing/gloves/color/black
	ears = /obj/item/radio/headset/headset_cent
	glasses = /obj/item/clothing/glasses/sunglasses
	belt = /obj/item/melee/classic_baton
	l_hand = /obj/item/gun/ballistic/rifle/boltaction
	back = /obj/item/storage/backpack/satchel
	l_pocket = /obj/item/ammo_box/a762
	r_pocket = /obj/item/ammo_box/a762
	id = /obj/item/card/id/advanced/centcom
	backpack_contents = list(/obj/item/storage/box/survival = 1)
	id_trim = /datum/id_trim/centcom/intern

/datum/outfit/centcom/centcom_intern/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.update_label()
	W.update_icon()
	return ..()

/datum/outfit/centcom/centcom_intern/leader
	name = "Старший Интерн ЦентКома"
	belt = /obj/item/melee/baton/loaded
	suit = /obj/item/clothing/suit/armor/vest
	suit_store = /obj/item/gun/ballistic/rifle/boltaction
	l_hand = /obj/item/megaphone
	head = /obj/item/clothing/head/intern

/datum/outfit/centcom/ert/janitor/party
	name = "Клининговая Компания ERT"

	uniform = /obj/item/clothing/under/misc/overalls
	mask = /obj/item/clothing/mask/bandana/blue
	suit = /obj/item/clothing/suit/apron
	suit_store = null
	glasses = /obj/item/clothing/glasses/meson
	belt = /obj/item/storage/belt/janitor/full
	r_pocket = /obj/item/grenade/chem_grenade/cleaner
	l_pocket = /obj/item/grenade/chem_grenade/cleaner
	l_hand = /obj/item/storage/bag/trash
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
		/obj/item/storage/box/lights/mixed=1,\
		/obj/item/mop/advanced=1,\
		/obj/item/reagent_containers/glass/bucket=1)

/datum/outfit/centcom/ert/security/party
	name = "Вышибала ERP"

	uniform = /obj/item/clothing/under/misc/bouncer
	suit = /obj/item/clothing/suit/armor/vest
	suit_store = null
	belt = /obj/item/melee/classic_baton/telescopic
	l_pocket = /obj/item/assembly/flash
	r_pocket = /obj/item/storage/wallet
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
		/obj/item/clothing/head/helmet/police=1,\
		/obj/item/storage/box/handcuffs=1)


/datum/outfit/centcom/ert/engineer/party
	name = "Строитель ERP"

	uniform = /obj/item/clothing/under/rank/engineering/engineer/hazard
	mask = /obj/item/clothing/mask/gas/atmos
	head = /obj/item/clothing/head/hardhat/weldhat
	suit = /obj/item/clothing/suit/hazardvest
	suit_store = null
	l_hand = /obj/item/areaeditor/blueprints
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
		/obj/item/stack/sheet/iron/fifty=1,\
		/obj/item/stack/sheet/glass/fifty=1,\
		/obj/item/stack/sheet/plasteel/twenty=1,\
		/obj/item/etherealballdeployer=1,\
		/obj/item/stack/light_w/thirty=1,\
		/obj/item/construction/rcd/loaded=1)

/datum/outfit/centcom/ert/clown/party
	name = "Комедиант ERP"

	uniform = /obj/item/clothing/under/rank/civilian/clown
	head = /obj/item/clothing/head/chameleon
	suit = /obj/item/clothing/suit/chameleon
	suit_store = null
	glasses = /obj/item/clothing/glasses/chameleon
	backpack_contents = list(/obj/item/storage/box/hug/survival=1,\
		/obj/item/shield/energy/bananium=1,\
		/obj/item/instrument/piano_synth=1)

/datum/outfit/centcom/ert/commander/party
	name = "Распорядитель Вечеринок ERP"

	uniform = /obj/item/clothing/under/misc/coordinator
	head = /obj/item/clothing/head/coordinator
	suit = /obj/item/clothing/suit/coordinator
	suit_store = null
	belt = /obj/item/storage/belt/sabre
	l_hand = /obj/item/toy/balloon

/datum/outfit/centcom/death_commando
	name = "Death Commando"

	id = /obj/item/card/id/advanced/black/deathsquad
	id_trim = /datum/id_trim/centcom/deathsquad
	uniform = /obj/item/clothing/under/rank/centcom/commander
	suit = /obj/item/clothing/suit/space/hardsuit/deathsquad
	suit_store = /obj/item/tank/internals/emergency_oxygen/double
	back = /obj/item/storage/backpack/security
	backpack_contents = list(
		/obj/item/ammo_box/a357 = 1,
		/obj/item/flashlight = 1,
		/obj/item/grenade/c4/x4 = 1,
		/obj/item/storage/box/flashbangs = 1,
		/obj/item/storage/box/survival/engineer = 1,
		/obj/item/storage/firstaid/regular = 1,
)
	belt = /obj/item/gun/ballistic/revolver/mateba
	ears = /obj/item/radio/headset/headset_cent/alt
	glasses = /obj/item/clothing/glasses/hud/toggle/thermal
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	shoes = /obj/item/clothing/shoes/combat/swat
	l_pocket = /obj/item/melee/energy/sword/saber
	r_pocket = /obj/item/shield/energy
	l_hand = /obj/item/gun/energy/pulse/loyalpin

	skillchips = list(
		/obj/item/skillchip/disk_verifier,
)

/datum/outfit/centcom/death_commando/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/radio/R = H.ears
	R.set_frequency(FREQ_CENTCOM)
	R.freqlock = TRUE
	var/obj/item/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.update_label()
	W.update_icon()
	..()

/datum/outfit/centcom/death_commando/officer
	name = "Death Commando Officer"

	head = /obj/item/clothing/head/helmet/space/beret

/datum/outfit/centcom/ert/marine
	name = "Marine Commander"

	id = /obj/item/card/id/advanced/centcom/ert
	suit = /obj/item/clothing/suit/armor/vest/marine
	suit_store = /obj/item/gun/ballistic/automatic/wt550
	back = /obj/item/shield/riot
	belt = /obj/item/storage/belt/military/assault/full
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses/eyepatch
	l_pocket = /obj/item/kitchen/knife/combat
	r_pocket = /obj/item/lighter
	uniform = /obj/item/clothing/under/syndicate/combat
	mask = /obj/item/clothing/mask/cigarette/robustgold
	head = /obj/item/clothing/head/helmet/marine

/datum/outfit/centcom/ert/marine/post_equip(mob/living/carbon/human/equipper, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return
	var/obj/item/radio/headset = equipper.ears
	headset.keyslot = new /obj/item/encryptionkey/heads/captain
	headset.recalculateChannels()

/datum/outfit/centcom/ert/marine/security
	name = "Marine Heavy"

	id = /obj/item/card/id/advanced/centcom/ert/security
	suit = /obj/item/clothing/suit/armor/vest/marine/security
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	r_pocket = /obj/item/grenade/smokebomb
	mask = /obj/item/clothing/mask/gas/sechailer
	head = /obj/item/clothing/head/helmet/marine/security

/datum/outfit/centcom/ert/marine/security/post_equip(mob/living/carbon/human/equipper, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	var/obj/item/radio/headset = equipper.ears
	headset.keyslot = new /obj/item/encryptionkey/heads/hos
	headset.recalculateChannels()

/datum/outfit/centcom/ert/marine/medic
	name = "Marine Medic"

	id = /obj/item/card/id/advanced/centcom/ert/medical
	suit = /obj/item/clothing/suit/armor/vest/marine/medic
	suit_store = /obj/item/storage/belt/holster/detective/full/ert
	back = /obj/item/storage/backpack/ert/medical
	r_pocket = /obj/item/healthanalyzer
	mask = /obj/item/food/chewable/lollipop
	head = /obj/item/clothing/head/helmet/marine/medic
	backpack_contents = list(
		/obj/item/reagent_containers/hypospray/combat = 1,
		/obj/item/storage/firstaid/regular = 1,
		/obj/item/storage/firstaid/advanced = 1,
)
	uniform = /obj/item/clothing/under/syndicate/camo
	belt = /obj/item/storage/belt/medical/paramedic
	glasses = /obj/item/clothing/glasses/hud/health/sunglasses

/datum/outfit/centcom/ert/marine/medic/post_equip(mob/living/carbon/human/equipper, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	var/obj/item/radio/headset = equipper.ears
	headset.keyslot = new /obj/item/encryptionkey/heads/cmo
	headset.recalculateChannels()

/datum/outfit/centcom/ert/marine/engineer
	name = "Marine Engineer"

	id = /obj/item/card/id/advanced/centcom/ert/engineer
	suit = /obj/item/clothing/suit/armor/vest/marine/engineer
	suit_store = /obj/item/gun/ballistic/shotgun/lethal
	mask = /obj/item/clothing/mask/cigarette/robustgold
	head = /obj/item/clothing/head/helmet/marine/engineer
	back = /obj/item/storage/backpack/ert/engineer
	backpack_contents = list(
		/obj/item/construction/rcd/combat = 1,
		/obj/item/pipe_dispenser = 1,
		/obj/item/storage/box/lethalshot = 1,
		/obj/item/grenade/c4 = 3,
)
	uniform = /obj/item/clothing/under/syndicate/camo
	belt = /obj/item/storage/belt/utility/full/engi
	glasses =  /obj/item/clothing/glasses/welding
	r_pocket = /obj/item/rcd_ammo/large
	r_hand = /obj/item/deployable_turret_folded

/datum/outfit/centcom/ert/marine/engineer/post_equip(mob/living/carbon/human/equipper, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	var/obj/item/radio/headset = equipper.ears
	headset.keyslot = new /obj/item/encryptionkey/heads/ce
	headset.recalculateChannels()

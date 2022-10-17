/datum/outfit/centcom/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/implant/mindshield/L = new/obj/item/implant/mindshield(H)//hmm lets have centcom officials become revs
	L.implant(H, null, 1)

/datum/outfit/centcom/spec_ops
	name = "Офицер Спецназа"

	uniform = /obj/item/clothing/under/syndicate
	suit = /obj/item/clothing/suit/space/officer
	shoes = /obj/item/clothing/shoes/combat/swat
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	glasses = /obj/item/clothing/glasses/thermal/eyepatch
	ears = /obj/item/radio/headset/headset_cent/commander
	mask = /obj/item/clothing/mask/cigarette/cigar/havana
	head = /obj/item/clothing/head/helmet/space/beret
	belt = /obj/item/gun/energy/pulse/pistol/m1911
	r_pocket = /obj/item/lighter
	back = /obj/item/storage/backpack/satchel/leather
	id = /obj/item/card/id/advanced/centcom
	id_trim = /datum/id_trim/centcom/specops_officer

/datum/outfit/centcom/spec_ops/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.update_label()
	W.update_icon()

	var/obj/item/radio/headset/R = H.ears
	R.set_frequency(FREQ_CENTCOM)
	R.freqlock = TRUE
	..()

/datum/outfit/space
	name = "Стандартное космическое снаряжение"

	uniform = /obj/item/clothing/under/color/grey
	shoes = /obj/item/clothing/shoes/sneakers/black
	suit = /obj/item/clothing/suit/space
	head = /obj/item/clothing/head/helmet/space
	back = /obj/item/tank/jetpack/oxygen
	mask = /obj/item/clothing/mask/breath

/datum/outfit/tournament
	name = "турнирный красный"

	uniform = /obj/item/clothing/under/color/red
	shoes = /obj/item/clothing/shoes/sneakers/black
	suit = /obj/item/clothing/suit/armor/vest
	head = /obj/item/clothing/head/helmet/thunderdome
	l_hand = /obj/item/gun/energy/pulse/destroyer
	l_hand = /obj/item/kitchen/knife
	r_pocket = /obj/item/grenade/smokebomb

/datum/outfit/tournament/green
	name = "турнирный зеленый"

	uniform = /obj/item/clothing/under/color/green

/datum/outfit/tournament/gangster
	name = "турнирный гангстер"

	uniform = /obj/item/clothing/under/rank/security/detective
	suit = /obj/item/clothing/suit/det_suit
	glasses = /obj/item/clothing/glasses/thermal/monocle
	head = /obj/item/clothing/head/fedora/det_hat
	l_hand = /obj/item/gun/ballistic
	l_hand = null
	r_pocket = /obj/item/ammo_box/c10mm

/datum/outfit/tournament/janitor
	name = "турнирный уборщик"

	uniform = /obj/item/clothing/under/rank/civilian/janitor
	back = /obj/item/storage/backpack
	suit = null
	head = null
	r_hand = /obj/item/mop
	l_hand = /obj/item/reagent_containers/glass/bucket
	r_pocket = /obj/item/grenade/chem_grenade/cleaner
	l_pocket = /obj/item/grenade/chem_grenade/cleaner
	backpack_contents = list(/obj/item/stack/tile/plasteel=6)

/datum/outfit/tournament/janitor/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/reagent_containers/glass/bucket/bucket = H.get_item_for_held_index(1)
	bucket.reagents.add_reagent(/datum/reagent/water,70)

/datum/outfit/laser_tag
	name = "Красный Лазертаг"

	uniform = /obj/item/clothing/under/color/red
	shoes = /obj/item/clothing/shoes/sneakers/red
	head = /obj/item/clothing/head/helmet/redtaghelm
	gloves = /obj/item/clothing/gloves/color/red
	ears = /obj/item/radio/headset
	suit = /obj/item/clothing/suit/redtag
	back = /obj/item/storage/backpack
	suit_store = /obj/item/gun/energy/laser/redtag
	backpack_contents = list(/obj/item/storage/box=1)

/datum/outfit/laser_tag/blue
	name = "Синий Лазертаг"
	uniform = /obj/item/clothing/under/color/blue
	shoes = /obj/item/clothing/shoes/sneakers/blue
	head = /obj/item/clothing/head/helmet/bluetaghelm
	gloves = /obj/item/clothing/gloves/color/blue
	suit = /obj/item/clothing/suit/bluetag
	suit_store = /obj/item/gun/energy/laser/bluetag

/datum/outfit/pirate
	name = "Космический Пират"

	uniform = /obj/item/clothing/under/costume/pirate
	shoes = /obj/item/clothing/shoes/sneakers/brown
	suit = /obj/item/clothing/suit/pirate/armored
	head = /obj/item/clothing/head/bandana/armored
	ears = /obj/item/radio/headset/syndicate
	glasses = /obj/item/clothing/glasses/eyepatch

/datum/outfit/pirate/post_equip(mob/living/carbon/human/equipped)
	equipped.faction |= "pirate"

	var/obj/item/radio/outfit_radio = equipped.ears
	if(outfit_radio)
		outfit_radio.set_frequency(FREQ_SYNDICATE)
		outfit_radio.freqlock = TRUE

	var/obj/item/card/id/outfit_id = equipped.wear_id
	if(outfit_id)
		outfit_id.registered_name = equipped.real_name
		outfit_id.update_label()
		outfit_id.update_icon()

	var/obj/item/clothing/under/pirate_uniform = equipped.w_uniform
	if(pirate_uniform)
		pirate_uniform.has_sensor = NO_SENSORS
		pirate_uniform.sensor_mode = SENSOR_OFF
		equipped.update_suit_sensors()

/datum/outfit/pirate/captain
	name = "Space Pirate Captain"

	head = /obj/item/clothing/head/pirate/armored

/datum/outfit/pirate/space
	name = "Space Pirate (EVA)"
	suit = /obj/item/clothing/suit/space/pirate
	head = /obj/item/clothing/head/helmet/space/pirate/bandana
	mask = /obj/item/clothing/mask/breath
	suit_store = /obj/item/tank/internals/oxygen
	id = /obj/item/card/id/advanced

/datum/outfit/pirate/space/captain
	name = "Space Pirate Captain (EVA)"

	head = /obj/item/clothing/head/helmet/space/pirate

/datum/outfit/pirate/silverscale
	name = "Silver Scale Member"

	head = /obj/item/clothing/head/collectable/tophat
	glasses = /obj/item/clothing/glasses/monocle
	uniform = /obj/item/clothing/under/suit/charcoal
	shoes = /obj/item/clothing/shoes/laceup
	suit = /obj/item/clothing/suit/armor/vest/alt
	gloves = /obj/item/clothing/gloves/color/black
	id_trim = /datum/id_trim/pirate/silverscale
	id = /obj/item/card/id/advanced/silver

/datum/outfit/pirate/silverscale/captain
	mask = /obj/item/clothing/mask/cigarette/cigar/havana
	l_pocket = /obj/item/lighter
	head = /obj/item/clothing/head/crown
	id_trim = /datum/id_trim/pirate/silverscale/captain

/datum/outfit/tunnel_clown
	name = "Тунельный Клоун"

	uniform = /obj/item/clothing/under/rank/civilian/clown
	shoes = /obj/item/clothing/shoes/clown_shoes
	gloves = /obj/item/clothing/gloves/color/black
	mask = /obj/item/clothing/mask/gas/clown_hat
	ears = /obj/item/radio/headset
	glasses = /obj/item/clothing/glasses/thermal/monocle
	suit = /obj/item/clothing/suit/hooded/chaplain_hoodie
	l_pocket = /obj/item/food/grown/banana
	r_pocket = /obj/item/bikehorn
	id = /obj/item/card/id/advanced/gold
	l_hand = /obj/item/fireaxe
	id_trim = /datum/id_trim/tunnel_clown

/datum/outfit/tunnel_clown/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.update_label()
	W.update_icon()

/datum/outfit/psycho
	name = "Убийца в Маске"

	uniform = /obj/item/clothing/under/misc/overalls
	shoes = /obj/item/clothing/shoes/sneakers/white
	gloves = /obj/item/clothing/gloves/color/latex
	mask = /obj/item/clothing/mask/surgical
	head = /obj/item/clothing/head/welding
	ears = /obj/item/radio/headset
	glasses = /obj/item/clothing/glasses/thermal/monocle
	suit = /obj/item/clothing/suit/apron
	l_pocket = /obj/item/kitchen/knife
	r_pocket = /obj/item/scalpel
	l_hand = /obj/item/fireaxe

/datum/outfit/psycho/post_equip(mob/living/carbon/human/H)
	for(var/obj/item/carried_item in H.get_equipped_items(TRUE))
		carried_item.add_mob_blood(H)//Oh yes, there will be blood...
	for(var/obj/item/I in H.held_items)
		I.add_mob_blood(H)
	H.regenerate_icons()

/datum/outfit/assassin
	name = "Ассасин"

	uniform = /obj/item/clothing/under/suit/black
	shoes = /obj/item/clothing/shoes/sneakers/black
	gloves = /obj/item/clothing/gloves/color/black
	ears = /obj/item/radio/headset
	glasses = /obj/item/clothing/glasses/sunglasses
	shoes = /obj/item/clothing/shoes/sneakers/black
	l_pocket = /obj/item/melee/energy/sword/saber
	l_hand = /obj/item/storage/secure/briefcase
	id = /obj/item/card/id/advanced/chameleon/black
	belt = /obj/item/modular_computer/tablet/pda/heads
	id_trim = /datum/id_trim/reaper_assassin

/datum/outfit/assassin/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	var/obj/item/clothing/under/U = H.w_uniform
	U.attach_accessory(new /obj/item/clothing/accessory/waistcoat(H))

	if(visualsOnly)
		return

	//Could use a type
	var/obj/item/storage/secure/briefcase/sec_briefcase = H.get_item_for_held_index(1)
	for(var/obj/item/briefcase_item in sec_briefcase)
		qdel(briefcase_item)
	for(var/i = 3 to 0 step -1)
		sec_briefcase.contents += new /obj/item/stack/spacecash/c1000
	sec_briefcase.contents += new /obj/item/gun/energy/kinetic_accelerator/crossbow
	sec_briefcase.contents += new /obj/item/gun/ballistic/revolver/mateba
	sec_briefcase.contents += new /obj/item/ammo_box/a357
	sec_briefcase.contents += new /obj/item/grenade/c4/x4

	var/obj/item/modular_computer/tablet/pda/heads/pda = H.belt
	pda.saved_identification = H.real_name
	pda.saved_job = "Reaper"

	var/obj/item/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.update_label()
	W.update_icon()

/datum/outfit/centcom/commander
	name = "Командующий ЦК"

	suit = /obj/item/clothing/suit/toggle/armor/vest/centcom_formal
	shoes = /obj/item/clothing/shoes/combat/swat
	gloves = /obj/item/clothing/gloves/color/captain/centcom
	ears = /obj/item/radio/headset/headset_cent/commander
	glasses = /obj/item/clothing/glasses/sunglasses
	mask = /obj/item/clothing/mask/cigarette/cigar/cohiba
	head = /obj/item/clothing/head/centcom_cap
	belt = /obj/item/gun/ballistic/automatic/pistol/deagle
	neck = /obj/item/clothing/neck/cloak/cape
	r_pocket = /obj/item/lighter
	l_pocket = /obj/item/ammo_box/magazine/m50
	back = /obj/item/storage/backpack/satchel/leather
	id = /obj/item/card/id/advanced/centcom
	id_trim = /datum/id_trim/centcom/commander
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
							/obj/item/ammo_box/magazine/m50=2,\
							/obj/item/stamp/centcom=1,\
							/obj/item/clipboard=1)

/datum/outfit/centcom/commander/mod
	name = "Командующий ЦК (MODsuit)"

	suit_store = /obj/item/tank/internals/oxygen
	suit = null
	head = null
	mask = /obj/item/clothing/mask/gas/sechailer
	back = /obj/item/mod/control/pre_equipped/corporate
	internals_slot = ITEM_SLOT_SUITSTORE

/datum/outfit/centcom/commander/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.jumpsuit_style == PREF_SUIT)
		uniform = /obj/item/clothing/under/rank/centcom/commander
	else
		uniform = /obj/item/clothing/under/rank/centcom/centcom_skirt

/datum/outfit/centcom/commander/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.update_label()
	W.update_icon()
	..()


/datum/outfit/centcom/grand_admiral
	name = "Гранд-адмирал ЦК"

	uniform = /obj/item/clothing/under/rank/centcom/commander/grand
	suit = null
	shoes = /obj/item/clothing/shoes/combat/swat
	gloves = /obj/item/clothing/gloves/color/captain/centcom/admiral
	ears = /obj/item/radio/headset/headset_cent/commander
	glasses = /obj/item/clothing/glasses/sunglasses
	mask = /obj/item/clothing/mask/cigarette/cigar/havana
	head = /obj/item/clothing/head/centhat/admiral/grand
	neck = /obj/item/clothing/neck/cloak/cape/grand
	belt = /obj/item/gun/energy/pulse/pistol
	r_pocket = /obj/item/lighter
	l_pocket = /obj/item/melee/energy/sword/saber/green
	back = /obj/item/storage/backpack/satchel/leather
	id = /obj/item/card/id/advanced/centcom
	id_trim = /datum/id_trim/centcom/commander
	backpack_contents = list(/obj/item/restraints/handcuffs/cable/zipties=1)

/datum/outfit/centcom/grand_admiral/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.update_label()
	W.update_icon()
	..()

/datum/outfit/ghost_cultist
	name = "Призрак Культиста"

	uniform = /obj/item/clothing/under/color/black/ghost
	suit = /obj/item/clothing/suit/hooded/cultrobes/alt/ghost
	shoes = /obj/item/clothing/shoes/cult/alt/ghost
	l_hand = /obj/item/melee/cultblade/ghost

/datum/outfit/wizard
	name = "Синий Маг"

	uniform = /obj/item/clothing/under/color/lightpurple
	suit = /obj/item/clothing/suit/wizrobe
	shoes = /obj/item/clothing/shoes/sandal/magic
	ears = /obj/item/radio/headset
	head = /obj/item/clothing/head/wizard
	r_pocket = /obj/item/teleportation_scroll
	r_hand = /obj/item/spellbook
	l_hand = /obj/item/staff
	back = /obj/item/storage/backpack
	backpack_contents = list(/obj/item/storage/box/survival=1)

/datum/outfit/wizard/apprentice
	name = "Wizard Apprentice"
	r_hand = null
	l_hand = null
	r_pocket = /obj/item/teleportation_scroll/apprentice

/datum/outfit/wizard/red
	name = "Red Wizard"

	suit = /obj/item/clothing/suit/wizrobe/red
	head = /obj/item/clothing/head/wizard/red

/datum/outfit/wizard/weeb
	name = "Marisa Wizard"

	suit = /obj/item/clothing/suit/wizrobe/marisa
	shoes = /obj/item/clothing/shoes/sandal/marisa
	head = /obj/item/clothing/head/wizard/marisa

/datum/outfit/centcom/soviet
	name = "Soviet Admiral"

	uniform = /obj/item/clothing/under/costume/soviet
	head = /obj/item/clothing/head/pirate/captain
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	ears = /obj/item/radio/headset/headset_cent
	glasses = /obj/item/clothing/glasses/thermal/eyepatch
	suit = /obj/item/clothing/suit/pirate/captain
	back = /obj/item/storage/backpack/satchel/leather
	belt = /obj/item/gun/ballistic/revolver/mateba

	id = /obj/item/card/id/advanced/centcom
	id_trim = /datum/id_trim/centcom/admiral

/datum/outfit/centcom/soviet/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/card/id/W = H.wear_id

	W.registered_name = H.real_name
	W.update_label()
	W.update_icon()
	..()

/datum/outfit/mobster
	name = "Mobster"

	uniform = /obj/item/clothing/under/suit/black_really
	head = /obj/item/clothing/head/fedora
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/color/black
	ears = /obj/item/radio/headset
	glasses = /obj/item/clothing/glasses/sunglasses
	l_hand = /obj/item/gun/ballistic/automatic/tommygun
	id = /obj/item/card/id/advanced
	id_trim = /datum/id_trim/mobster

/datum/outfit/mobster/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.update_label()
	W.update_icon()

/datum/outfit/plasmaman
	name = "Plasmaman"

	head = /obj/item/clothing/head/helmet/space/plasmaman
	uniform = /obj/item/clothing/under/plasmaman
	r_hand= /obj/item/tank/internals/plasmaman/belt/full
	mask = /obj/item/clothing/mask/breath
	gloves = /obj/item/clothing/gloves/color/plasmaman
/*

/datum/outfit/centcom/death_commando
	name = JOB_ERT_DEATHSQUAD

	uniform = /obj/item/clothing/under/rank/centcom/commander
	suit = /obj/item/clothing/suit/space/hardsuit/deathsquad
	shoes = /obj/item/clothing/shoes/combat/swat
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	glasses = /obj/item/clothing/glasses/hud/toggle/thermal
	back = /obj/item/storage/backpack/security
	l_pocket = /obj/item/melee/energy/sword/saber
	r_pocket = /obj/item/shield/energy
	suit_store = /obj/item/tank/internals/emergency_oxygen/double
	belt = /obj/item/gun/ballistic/revolver/mateba
	l_hand = /obj/item/gun/energy/pulse/loyalpin
	id = /obj/item/card/id/advanced/black/deathsquad
	ears = /obj/item/radio/headset/headset_cent/alt

	skillchips = list(/obj/item/skillchip/disk_verifier)

	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
		/obj/item/ammo_box/a357=1,\
		/obj/item/storage/firstaid/regular=1,\
		/obj/item/storage/box/flashbangs=1,\
		/obj/item/flashlight=1,\
		/obj/item/grenade/c4/x4=1)

	id_trim = /datum/id_trim/centcom/deathsquad

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
*/
/datum/outfit/chrono_agent
	name = "Timeline Eradication Agent"

	uniform = /obj/item/clothing/under/color/white
	suit_store = /obj/item/tank/internals/oxygen
	mask = /obj/item/clothing/mask/breath
	back = /obj/item/mod/control/pre_equipped/chrono

/datum/outfit/chrono_agent/post_equip(mob/living/carbon/human/agent, visualsOnly)
	. = ..()
	var/obj/item/mod/control/mod = agent.back
	if(!istype(mod))
		return
	var/obj/item/mod/module/eradication_lock/lock = locate(/obj/item/mod/module/eradication_lock) in mod.modules
	lock.true_owner_ckey = agent.ckey

/datum/outfit/debug //Debug objs plus MODsuit
	name = "Debug outfit"

	id = /obj/item/card/id/advanced/debug
	uniform = /obj/item/clothing/under/misc/patriotsuit
	suit_store = /obj/item/tank/internals/oxygen
	back = /obj/item/mod/control/pre_equipped/debug
	backpack_contents = list(
		/obj/item/melee/energy/axe = 1,
		/obj/item/storage/part_replacer/bluespace/tier4 = 1,
		/obj/item/gun/magic/wand/resurrection/debug = 1,
		/obj/item/gun/magic/wand/death/debug = 1,
		/obj/item/debug/human_spawner = 1,
		/obj/item/debug/omnitool = 1,
	)
	belt = /obj/item/storage/belt/utility/chief/full
	ears = /obj/item/radio/headset/headset_cent/commander
	glasses = /obj/item/clothing/glasses/debug
	gloves = /obj/item/clothing/gloves/combat
	mask = /obj/item/clothing/mask/gas/welding/up
	shoes = /obj/item/clothing/shoes/magboots/advance

	box = /obj/item/storage/box/debugtools
	internals_slot = ITEM_SLOT_SUITSTORE

/datum/outfit/debug/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	var/obj/item/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.update_label()
	W.update_icon()

/datum/outfit/admin //for admeem shenanigans and testing things that arent related to equipment, not a subtype of debug just in case debug changes things
	name = "Admin outfit"

	id = /obj/item/card/id/advanced/debug
	uniform = /obj/item/clothing/under/misc/patriotsuit
	suit_store = /obj/item/tank/internals/oxygen
	back = /obj/item/mod/control/pre_equipped/administrative
	backpack_contents = list(
		/obj/item/melee/energy/axe = 1,
		/obj/item/storage/part_replacer/bluespace/tier4 = 1,
		/obj/item/gun/magic/wand/resurrection/debug = 1,
		/obj/item/gun/magic/wand/death/debug = 1,
		/obj/item/debug/human_spawner = 1,
		/obj/item/debug/omnitool = 1,
		/obj/item/storage/box/stabilized = 1,
	)
	belt = /obj/item/storage/belt/utility/chief/full
	ears = /obj/item/radio/headset/headset_cent/commander
	glasses = /obj/item/clothing/glasses/debug
	gloves = /obj/item/clothing/gloves/combat
	mask = /obj/item/clothing/mask/gas/welding/up
	shoes = /obj/item/clothing/shoes/magboots/advance

	box = /obj/item/storage/box/debugtools
	internals_slot = ITEM_SLOT_SUITSTORE

/datum/outfit/admin/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	var/obj/item/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.update_label()
	W.update_icon()

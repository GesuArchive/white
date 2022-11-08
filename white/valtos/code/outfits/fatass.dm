/datum/outfit/centcom/spec_ops_v2
	name = "Офицер Спецназа V2"

	uniform = /obj/item/clothing/under/rank/centcom/officer
	suit = /obj/item/clothing/suit/toggle/armor/vest/centcom_formal
	shoes = /obj/item/clothing/shoes/sneakers/black
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	glasses = /obj/item/clothing/glasses/thermal/eyepatch
	ears = /obj/item/radio/headset/headset_cent/commander
	mask = /obj/item/clothing/mask/cigarette/cigar/havana
	belt = /obj/item/vibro_weapon/butcher
	suit_store = /obj/item/gun/ballistic/automatic/fallout/railgun
	r_pocket = /obj/item/lighter
	back = /obj/item/storage/backpack/satchel/leather
	id = /obj/item/card/id/advanced/centcom
	id_trim = /datum/id_trim/centcom/specops_officer

/datum/outfit/centcom/spec_ops_v2/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.update_label()
	W.update_icon()

	var/obj/item/radio/headset/R = H.ears
	R.set_frequency(FREQ_CENTCOM)
	R.freqlock = TRUE

	H.revive(full_heal = TRUE, admin_revive = TRUE)
	ADD_TRAIT(H, TRAIT_STUNIMMUNE, "fuck_you")
	H.status_flags |= GODMODE

	H.AddElement(/datum/element/phantom, 0.5 SECONDS)

	..()

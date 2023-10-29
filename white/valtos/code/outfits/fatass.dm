/datum/outfit/centcom/spec_ops_v2
	name = "Офицер Спецназа V2"

	head = /obj/item/clothing/head/beret/centcom_formal/specops
	uniform = /obj/item/clothing/under/rank/centcom/military
	suit = /obj/item/clothing/suit/toggle/armor/vest/centcom_formal/specops
	shoes = /obj/item/clothing/shoes/sneakers/black
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	glasses = /obj/item/clothing/glasses/thermal/eyepatch
	ears = /obj/item/radio/headset/headset_cent/commander
	mask = /obj/item/clothing/mask/cigarette/cigar/havana
	suit_store = /obj/item/gun/ballistic/automatic/fallout/railgun
	l_pocket = /obj/item/grenade/antigravity/heavy
	r_pocket = /obj/item/grenade/antigravity/heavy
	back = /obj/item/vibro_weapon/butcher
	id = /obj/item/card/id/advanced/black/deathsquad
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

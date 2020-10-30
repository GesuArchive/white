/obj/item/clothing/head
	name = BODY_ZONE_HEAD
	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "tophat"
	inhand_icon_state = "that"
	body_parts_covered = HEAD
	slot_flags = ITEM_SLOT_HEAD
	var/blockTracking = 0 //For AI tracking
	var/can_toggle = null
	dynamic_hair_suffix = "+generic"

/obj/item/clothing/head/Initialize()
	. = ..()
	if(ishuman(loc) && dynamic_hair_suffix)
		var/mob/living/carbon/human/H = loc
		H.update_hair()

///Special throw_impact for hats to frisbee hats at people to place them on their heads/attempt to de-hat them.
/obj/item/clothing/head/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	. = ..()
	///if the thrown object's target zone isn't the head
	if(thrownthing.target_zone != BODY_ZONE_HEAD)
		return
	///ignore any hats with the tinfoil counter-measure enabled
	if(clothing_flags & ANTI_TINFOIL_MANEUVER)
		return
	///if the hat happens to be capable of holding contents and has something in it. mostly to prevent super cheesy stuff like stuffing a mini-bomb in a hat and throwing it
	if(LAZYLEN(contents))
		return
	if(iscarbon(hit_atom))
		var/mob/living/carbon/H = hit_atom
		if(istype(H.head, /obj/item))
			var/obj/item/WH = H.head
			///check if the item has NODROP
			if(HAS_TRAIT(WH, TRAIT_NODROP))
				H.visible_message("<span class='warning'>[capitalize(src.name)] отскакивает от [H]'s [WH.name]!</span>", "<span class='warning'>[capitalize(src.name)] отскакивает от твоей [WH.name] и падает на пол.</span>")
				return
			///check if the item is an actual clothing head item, since some non-clothing items can be worn
			if(istype(WH, /obj/item/clothing/head))
				var/obj/item/clothing/head/WHH = WH
				///SNUG_FIT hats are immune to being knocked off
				if(WHH.clothing_flags & SNUG_FIT)
					H.visible_message("<span class='warning'>[capitalize(src.name)] отскакивает от [H]'s [WHH.name]!</span>", "<span class='warning'>[capitalize(src.name)] отскакивает от твоей [WHH.name] и падает на пол.</span>")
					return
			///if the hat manages to knock something off
			if(H.dropItemToGround(WH))
				H.visible_message("<span class='warning'>[capitalize(src.name)] сбита с  [WH] [H]'s головы!</span>", "<span class='warning'>[WH] была внезапно сбита с моей головы [src]!</span>")
		if(H.equip_to_slot_if_possible(src, ITEM_SLOT_HEAD, 0, 1, 1))
			H.visible_message("<span class='notice'>[capitalize(src.name)] приземляется аккурат на [H]'s!</span>", "<span class='notice'>[capitalize(src.name)] приземляется прямо на мою голову!</span>")
		return
	if(iscyborg(hit_atom))
		var/mob/living/silicon/robot/R = hit_atom
		///hats in the borg's blacklist bounce off
		if(is_type_in_typecache(src, GLOB.blacklisted_borg_hats))
			R.visible_message("<span class='warning'>[capitalize(src.name)] отлетает от [R]!</span>", "<span class='warning'>[capitalize(src.name)] отлетает от меня, падая на пол.</span>")
			return
		else
			R.visible_message("<span class='notice'>[capitalize(src.name)] приземляется аккурат на [R]!</span>", "<span class='notice'>[capitalize(src.name)] приземляется аккурат на мой верх.</span>")
			R.place_on_head(src) //hats aren't designed to snugly fit borg heads or w/e so they'll always manage to knock eachother off




/obj/item/clothing/head/worn_overlays(isinhands = FALSE)
	. = list()
	if(!isinhands)
		if(damaged_clothes)
			. += mutable_appearance('icons/effects/item_damage.dmi', "damagedhelmet")
		if(HAS_BLOOD_DNA(src))
			if(clothing_flags & LARGE_WORN_ICON)
				. += mutable_appearance('icons/effects/64x64.dmi', "helmetblood_large")
			else
				. += mutable_appearance('icons/effects/blood.dmi', "helmetblood")

/obj/item/clothing/head/update_clothes_damaged_state(damaged_state = CLOTHING_DAMAGED)
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_head()

/*
 * The 'fancy' path is for objects like donut boxes that show how many items are in the storage item on the sprite itself
 * .. Sorry for the shitty path name, I couldnt think of a better one.
 *
 * WARNING: var/icon_type is used for both examine text and sprite name. Please look at the procs below and adjust your sprite names accordingly
 *		TODO: Cigarette boxes should be ported to this standard
 *
 * Contains:
 *		Donut Box
 *		Egg Box
 *		Candle Box
 *		Cigarette Box
 *		Cigar Case
 *		Heart Shaped Box w/ Chocolates
 */

/obj/item/storage/fancy
	icon = 'icons/obj/food/containers.dmi'
	resistance_flags = FLAMMABLE
	custom_materials = list(/datum/material/cardboard = 2000)
	var/icon_type = "donut"
	var/spawn_type = null
	/// How many of the things to fill this storage with.
	var/spawn_count = 0
	var/fancy_open = FALSE
	var/obj/fold_result = /obj/item/stack/sheet/cardboard

/obj/item/storage/fancy/Initialize()
	. = ..()

	atom_storage.max_slots = spawn_count

/obj/item/storage/fancy/PopulateContents()
	for(var/i = 1 to spawn_count)
		new spawn_type(src)

/obj/item/storage/fancy/update_icon_state()
	if(fancy_open)
		icon_state = "[icon_type]box[contents.len]"
	else
		icon_state = "[icon_type]box"

/obj/item/storage/fancy/examine(mob/user)
	. = ..()
	. += "<hr>"
	if(fancy_open)
		if(length(contents) == 1)
			. += "Тут не осталось [icon_type]."
		else
			. += "Тут осталось [contents.len <= 0 ? "no" : "[contents.len]"] [icon_type]."

/obj/item/storage/fancy/attack_self(mob/user)
	fancy_open = !fancy_open
	update_icon()
	. = ..()
	if(!contents.len)
		new fold_result(user.drop_location())
		to_chat(user, span_notice("Складываю [src] в [initial(fold_result.name)]."))
		user.put_in_active_hand(fold_result)
		qdel(src)

/obj/item/storage/fancy/Exited()
	. = ..()
	fancy_open = TRUE
	update_icon()

/obj/item/storage/fancy/Entered()
	. = ..()
	fancy_open = TRUE
	update_icon()

#define DONUT_INBOX_SPRITE_WIDTH 3

/*
 * Donut Box
 */

/obj/item/storage/fancy/donut_box
	name = "коробка с пончиками"
	desc = "Ммм. Пончики."
	icon = 'icons/obj/food/donuts.dmi'
	icon_state = "donutbox_inner"
	icon_type = "donut"
	spawn_type = /obj/item/food/donut
	spawn_count = 6
	fancy_open = TRUE
	appearance_flags = KEEP_TOGETHER|LONG_GLIDE
	custom_premium_price = PAYCHECK_HARD * 1.75

/obj/item/storage/fancy/donut_box/choco
	name = "коробка с пончиками (шоколад)"
	spawn_type = /obj/item/food/donut/choco

/obj/item/storage/fancy/donut_box/caramel
	name = "коробка с пончиками (карамель)"
	spawn_type = /obj/item/food/donut/caramel

/obj/item/storage/fancy/donut_box/Initialize()
	. = ..()
	atom_storage.set_holdable(list(/obj/item/food/donut))

/obj/item/storage/fancy/donut_box/PopulateContents()
	. = ..()
	update_icon()

/obj/item/storage/fancy/donut_box/update_icon_state()
	if(fancy_open)
		icon_state = "donutbox_inner"
	else
		icon_state = "donutbox"

/obj/item/storage/fancy/donut_box/update_overlays()
	. = ..()

	if (!fancy_open)
		return

	var/donuts = 0

	for (var/_donut in contents)
		var/obj/item/food/donut/donut = _donut
		if (!istype(donut))
			continue

		. += image(icon = initial(icon), icon_state = donut.in_box_sprite(), pixel_x = donuts * DONUT_INBOX_SPRITE_WIDTH)
		donuts += 1

	. += image(icon = initial(icon), icon_state = "donutbox_top")

#undef DONUT_INBOX_SPRITE_WIDTH

/*
 * Egg Box
 */

/obj/item/storage/fancy/egg_box
	icon = 'icons/obj/food/containers.dmi'
	inhand_icon_state = "eggbox"
	icon_state = "eggbox"
	icon_type = "egg"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	name = "коробка для яиц"
	desc = "Картонная упаковка для яиц."
	spawn_type = /obj/item/food/egg
	spawn_count = 12

/obj/item/storage/fancy/egg_box/Initialize()
	. = ..()
	atom_storage.set_holdable(list(/obj/item/food/egg))

/*
 * Candle Box
 */

/obj/item/storage/fancy/candle_box
	name = "упаковка свечей"
	desc = "Упаковка с красными свечами."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candlebox5"
	icon_type = "candle"
	inhand_icon_state = "candlebox5"
	worn_icon_state = "cigpack"
	throwforce = 2
	slot_flags = ITEM_SLOT_BELT
	spawn_type = /obj/item/candle
	spawn_count = 5
	fancy_open = TRUE

/obj/item/storage/fancy/candle_box/attack_self(mob/user)
	if(!contents.len)
		new fold_result(user.drop_location())
		to_chat(user, span_notice("Складываю [src] в [initial(fold_result.name)]."))
		user.put_in_active_hand(fold_result)
		qdel(src)

////////////
//CIG PACK//
////////////
/obj/item/storage/fancy/cigarettes
	name = "\improper пачка космических сигарет"
	desc = "Самый популярный бренд сигарет, спонсор Космической Олимпиады."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cig"
	inhand_icon_state = "cigpacket"
	worn_icon_state = "cigpack"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	slot_flags = ITEM_SLOT_BELT
	icon_type = "cigarette"
	spawn_type = /obj/item/clothing/mask/cigarette/space_cigarette
	spawn_count = 6
	custom_price = PAYCHECK_MEDIUM
	age_restricted = TRUE
	///for cigarette overlay
	var/candy = FALSE
	/// Does this cigarette packet come with a coupon attached?
	var/spawn_coupon = TRUE
	/// For VV'ing, set this to true if you want to force the coupon to give an omen
	var/rigged_omen = FALSE

/obj/item/storage/fancy/cigarettes/attack_self(mob/user)
	if(contents.len == 0 && spawn_coupon)
		to_chat(user, span_notice("Разрываю заднюю часть [src] и достаю купон!"))
		var/obj/item/coupon/attached_coupon = new
		user.put_in_hands(attached_coupon)
		attached_coupon.generate(rigged_omen)
		attached_coupon = null
		spawn_coupon = FALSE
		name = "выброшенная пачка сигарет"
		desc = "Старая пачка сигарет с оторванной спинкой, которая сейчас стоит меньше, чем ничего."
		atom_storage.max_slots = 0
		return
	return ..()

/obj/item/storage/fancy/cigarettes/Initialize()
	. = ..()
	atom_storage.quickdraw = TRUE
	atom_storage.set_holdable(list(/obj/item/clothing/mask/cigarette, /obj/item/lighter))

/obj/item/storage/fancy/cigarettes/examine(mob/user)
	. = ..()

	. += "<hr><span class='notice'>ПКМ чтобы извлечь содержимое.</span>"
	if(spawn_coupon)
		. += span_notice("\nНа обратной стороне упаковки есть купон! Можно оторвать его, когда содержимое пачки станет пустым.")

/obj/item/storage/fancy/cigarettes/update_icon_state()
	if(fancy_open || !contents.len)
		if(!contents.len)
			icon_state = "[initial(icon_state)]_empty"
		else
			icon_state = initial(icon_state)

/obj/item/storage/fancy/cigarettes/update_overlays()
	. = ..()
	if(fancy_open && contents.len)
		. += "[icon_state]_open"
		var/cig_position = 1
		for(var/C in contents)
			var/mutable_appearance/inserted_overlay = mutable_appearance(icon)

			if(istype(C, /obj/item/lighter/greyscale))
				inserted_overlay.icon_state = "lighter_in"
			else if(istype(C, /obj/item/lighter))
				inserted_overlay.icon_state = "zippo_in"
			else if(candy)
				inserted_overlay.icon_state = "candy"
			else
				inserted_overlay.icon_state = "cigarette"

			inserted_overlay.icon_state = "[inserted_overlay.icon_state]_[cig_position]"
			. += inserted_overlay
			cig_position++

/obj/item/storage/fancy/cigarettes/dromedaryco
	name = "DromedaryCo packet"
	desc = "A packet of six imported DromedaryCo cancer sticks. A label on the packaging reads, \"Wouldn't a slow death make a change?\""
	icon_state = "dromedary"
	spawn_type = /obj/item/clothing/mask/cigarette/dromedary

/obj/item/storage/fancy/cigarettes/cigpack_uplift
	name = "\improper Uplift Smooth packet"
	desc = "Your favorite brand, now menthol flavored."
	icon_state = "uplift"
	spawn_type = /obj/item/clothing/mask/cigarette/uplift

/obj/item/storage/fancy/cigarettes/cigpack_robust
	name = "\improper Robust packet"
	desc = "Smoked by the robust."
	icon_state = "robust"
	spawn_type = /obj/item/clothing/mask/cigarette/robust

/obj/item/storage/fancy/cigarettes/cigpack_robustgold
	name = "\improper Robust Gold packet"
	desc = "Smoked by the truly robust."
	icon_state = "robustg"
	spawn_type = /obj/item/clothing/mask/cigarette/robustgold

/obj/item/storage/fancy/cigarettes/cigpack_carp
	name = "\improper Carp Classic packet"
	desc = "Since 2313."
	icon_state = "carp"
	spawn_type = /obj/item/clothing/mask/cigarette/carp

/obj/item/storage/fancy/cigarettes/cigpack_syndicate
	name = "cigarette packet"
	desc = "An obscure brand of cigarettes."
	icon_state = "syndie"
	spawn_type = /obj/item/clothing/mask/cigarette/syndicate

/obj/item/storage/fancy/cigarettes/cigpack_midori
	name = "\improper Midori Tabako packet"
	desc = "You can't understand the runes, but the packet smells funny."
	icon_state = "midori"
	spawn_type = /obj/item/clothing/mask/cigarette/rollie/nicotine

/obj/item/storage/fancy/cigarettes/cigpack_candy
	name = "\improper Timmy's First Candy Smokes packet"
	desc = "Unsure about smoking? Want to bring your children safely into the family tradition? Look no more with this special packet! Includes 100%* Nicotine-Free candy cigarettes."
	icon_state = "candy"
	icon_type = "candy cigarette"
	spawn_type = /obj/item/clothing/mask/cigarette/candy
	candy = TRUE
	age_restricted = FALSE

/obj/item/storage/fancy/cigarettes/cigpack_candy/Initialize(mapload)
	. = ..()
	if(prob(7))
		spawn_type = /obj/item/clothing/mask/cigarette/candy/nicotine //uh oh!

/obj/item/storage/fancy/cigarettes/cigpack_shadyjims
	name = "\improper Shady Jim's Super Slims packet"
	desc = "Is your weight slowing you down? Having trouble running away from gravitational singularities? Can't stop stuffing your mouth? Smoke Shady Jim's Super Slims and watch all that fat burn away. Guaranteed results!"
	icon_state = "shadyjim"
	spawn_type = /obj/item/clothing/mask/cigarette/shadyjims

/obj/item/storage/fancy/cigarettes/cigpack_xeno
	name = "\improper Xeno Filtered packet"
	desc = "Loaded with 100% pure slime. And also nicotine."
	icon_state = "slime"
	spawn_type = /obj/item/clothing/mask/cigarette/xeno

/obj/item/storage/fancy/cigarettes/cigpack_cannabis
	name = "\improper Freak Brothers' Special packet"
	desc = "A label on the packaging reads, \"Endorsed by Phineas, Freddy and Franklin.\""
	icon_state = "midori"
	spawn_type = /obj/item/clothing/mask/cigarette/rollie/cannabis

/obj/item/storage/fancy/cigarettes/cigpack_mindbreaker
	name = "\improper Leary's Delight packet"
	desc = "Banned in over 36 galaxies."
	icon_state = "shadyjim"
	spawn_type = /obj/item/clothing/mask/cigarette/rollie/mindbreaker

/obj/item/storage/fancy/rollingpapers
	name = "rolling paper pack"
	desc = "A pack of Nanotrasen brand rolling papers."
	w_class = WEIGHT_CLASS_TINY
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cig_paper_pack"
	///The value in here has NOTHING to do with icons. It needs to be this for the proper examine.
	icon_type = "rolling paper"
	spawn_type = /obj/item/rollingpaper
	custom_price = PAYCHECK_PRISONER

/obj/item/storage/fancy/rollingpapers/Initialize()
	. = ..()
	atom_storage.max_slots = 10
	atom_storage.set_holdable(list(/obj/item/rollingpaper))

///Overrides to do nothing because fancy boxes are fucking insane.
/obj/item/storage/fancy/rollingpapers/update_icon_state()
	return

/obj/item/storage/fancy/rollingpapers/update_overlays()
	. = ..()
	if(!contents.len)
		. += "[icon_state]_empty"

/////////////
//CIGAR BOX//
/////////////

/obj/item/storage/fancy/cigarettes/cigars
	name = "\improper premium cigar case"
	desc = "A case of premium cigars. Very expensive."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigarcase"
	w_class = WEIGHT_CLASS_NORMAL
	icon_type = "premium cigar"
	spawn_type = /obj/item/clothing/mask/cigarette/cigar
	spawn_count = 5
	spawn_coupon = FALSE

/obj/item/storage/fancy/cigarettes/cigars/Initialize()
	. = ..()
	atom_storage.set_holdable(list(/obj/item/clothing/mask/cigarette/cigar))

/obj/item/storage/fancy/cigarettes/cigars/update_icon_state()
	if(fancy_open)
		icon_state = "[initial(icon_state)]_open"
	else
		icon_state = "[initial(icon_state)]"

/obj/item/storage/fancy/cigarettes/cigars/update_overlays()
	. = ..()
	if(fancy_open)
		var/cigar_position = 1 //generate sprites for cigars in the box
		for(var/obj/item/clothing/mask/cigarette/cigar/smokes in contents)
			var/mutable_appearance/cigar_overlay = mutable_appearance(icon, "[smokes.icon_off]_[cigar_position]")
			. += cigar_overlay
			cigar_position++

/obj/item/storage/fancy/cigarettes/cigars/cohiba
	name = "\improper Cohiba Robusto cigar case"
	desc = "A case of imported Cohiba cigars, renowned for their strong flavor."
	icon_state = "cohibacase"
	spawn_type = /obj/item/clothing/mask/cigarette/cigar/cohiba

/obj/item/storage/fancy/cigarettes/cigars/havana
	name = "\improper premium Havanian cigar case"
	desc = "A case of classy Havanian cigars."
	icon_state = "cohibacase"
	spawn_type = /obj/item/clothing/mask/cigarette/cigar/havana

/*
 * Heart Shaped Box w/ Chocolates
 */

/obj/item/storage/fancy/heart_box
	name = "heart-shaped box"
	desc = "A heart-shaped box for holding tiny chocolates."
	icon = 'icons/obj/food/containers.dmi'
	inhand_icon_state = "chocolatebox"
	icon_state = "chocolatebox"
	icon_type = "chocolate"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	spawn_type = /obj/item/food/tinychocolate
	spawn_count = 8

/obj/item/storage/fancy/heart_box/Initialize()
	. = ..()
	atom_storage.set_holdable(list(/obj/item/food/tinychocolate))


/obj/item/storage/fancy/nugget_box
	name = "nugget box"
	desc = "A cardboard box used for holding chicken nuggies."
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "nuggetbox"
	icon_type = "nugget"
	spawn_type = /obj/item/food/nugget
	spawn_count = 6

/obj/item/storage/fancy/nugget_box/Initialize()
	. = ..()
	atom_storage.set_holdable(list(/obj/item/food/nugget))

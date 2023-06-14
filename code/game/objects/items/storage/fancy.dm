/*
 * The 'fancy' path is for objects like donut boxes that show how many items are in the storage item on the sprite itself
 * .. Sorry for the shitty path name, I couldnt think of a better one.
 *
 * Contains:
 * Donut Box
 * Egg Box
 * Candle Box
 * Cigarette Box
 * Rolling Paper Pack
 * Cigar Case
 * Heart Shaped Box w/ Chocolates
 */

/obj/item/storage/fancy
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "donutbox"
	base_icon_state = "donutbox"
	resistance_flags = FLAMMABLE
	custom_materials = list(/datum/material/cardboard = 2000)
	/// Used by examine to report what this thing is holding.
	var/contents_tag = "ошибок"
	/// What type of thing to fill this storage with.
	var/spawn_type = null
	/// How many of the things to fill this storage with.
	var/spawn_count = 0
	/// Whether the container is open or not
	var/is_open = FALSE
	/// What this container folds up into when it's empty.
	var/obj/fold_result = /obj/item/stack/sheet/cardboard
	/// Whether it supports open and closed state icons.
	var/has_open_closed_states = TRUE

/obj/item/storage/fancy/Initialize()
	. = ..()

	atom_storage.max_slots = spawn_count

/obj/item/storage/fancy/PopulateContents()
	for(var/i = 1 to spawn_count)
		new spawn_type(src)

/obj/item/storage/fancy/update_icon_state()
	icon_state = "[base_icon_state][has_open_closed_states && is_open ? contents.len : null]"
	return ..()

/obj/item/storage/fancy/examine(mob/user)
	. = ..()
	if(!is_open)
		return
	. += "<hr>"
	if(length(contents) == 1)
		. += "Это последняя!"
	else
		. += "Внутри <b>[contents.len <= 0 ? "НОЛЬ" : "[contents.len]"]</b> [contents_tag]."

/obj/item/storage/fancy/attack_self(mob/user)
	is_open = !is_open
	update_icon()
	. = ..()
	if(!contents.len)
		new fold_result(user.drop_location())
		to_chat(user, span_notice("Складываю [src] в [initial(fold_result.name)]."))
		user.put_in_active_hand(fold_result)
		qdel(src)

/obj/item/storage/fancy/Exited()
	. = ..()
	is_open = TRUE
	update_icon()

/obj/item/storage/fancy/Entered()
	. = ..()
	is_open = TRUE
	update_icon()

#define DONUT_INBOX_SPRITE_WIDTH 3

/*
 * Donut Box
 */

/obj/item/storage/fancy/donut_box
	name = "коробка с пончиками"
	desc = "Ммм. Пончики."
	icon = 'icons/obj/food/donuts.dmi'
	icon_state = "donutbox_open" //composite image used for mapping
	base_icon_state = "donutbox"
	spawn_type = /obj/item/food/donut
	spawn_count = 6
	is_open = TRUE
	appearance_flags = KEEP_TOGETHER|LONG_GLIDE
	custom_premium_price = PAYCHECK_HARD * 1.75
	contents_tag = "пончиков"

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
	update_appearance()

/obj/item/storage/fancy/donut_box/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][is_open ? "_inner" : null]"

/obj/item/storage/fancy/donut_box/update_overlays()
	. = ..()
	if(!is_open)
		return

	var/donuts = 0
	for(var/_donut in contents)
		var/obj/item/food/donut/donut = _donut
		if (!istype(donut))
			continue

		. += image(icon = initial(icon), icon_state = donut.in_box_sprite(), pixel_x = donuts * DONUT_INBOX_SPRITE_WIDTH)
		donuts += 1

	. += image(icon = initial(icon), icon_state = "[base_icon_state]_top")

#undef DONUT_INBOX_SPRITE_WIDTH

/*
 * Egg Box
 */

/obj/item/storage/fancy/egg_box
	icon = 'icons/obj/food/containers.dmi'
	inhand_icon_state = "eggbox"
	icon_state = "eggbox"
	base_icon_state = "eggbox"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	name = "коробка для яиц"
	desc = "Картонная упаковка для яиц."
	spawn_type = /obj/item/food/egg
	spawn_count = 12
	contents_tag = "яиц"

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
	base_icon_state = "candlebox"
	inhand_icon_state = null
	worn_icon_state = "cigpack"
	throwforce = 2
	slot_flags = ITEM_SLOT_BELT
	spawn_type = /obj/item/candle
	spawn_count = 5
	is_open = TRUE
	contents_tag = "свечей"

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
	base_icon_state = "cig"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	slot_flags = ITEM_SLOT_BELT
	spawn_type = /obj/item/clothing/mask/cigarette/space_cigarette
	spawn_count = 6
	custom_price = PAYCHECK_MEDIUM
	age_restricted = TRUE
	contents_tag = "сигарет"
	///for cigarette overlay
	var/candy = FALSE
	/// Does this cigarette packet come with a coupon attached?
	var/spawn_coupon = TRUE
	/// For VV'ing, set this to true if you want to force the coupon to give an omen
	var/rigged_omen = FALSE
	///Do we not have our own handling for cig overlays?
	var/display_cigs = TRUE

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
	. = ..()
	icon_state = "[base_icon_state][contents.len ? null : "_empty"]"

/obj/item/storage/fancy/cigarettes/update_overlays()
	. = ..()
	if(!is_open || !contents.len)
		return

	. += "[icon_state]_open"

	if(!display_cigs)
		return

	var/cig_position = 1
	for(var/C in contents)
		var/use_icon_state = ""

		if(istype(C, /obj/item/lighter/greyscale))
			use_icon_state = "lighter_in"
		else if(istype(C, /obj/item/lighter))
			use_icon_state = "zippo_in"
		else if(candy)
			use_icon_state = "candy"
		else
			use_icon_state = "cigarette"

		. += "[use_icon_state]_[cig_position]"
		cig_position++

/obj/item/storage/fancy/cigarettes/dromedaryco
	name = "DromedaryCo packet"
	desc = "A packet of six imported DromedaryCo cancer sticks. A label on the packaging reads, \"Wouldn't a slow death make a change?\""
	icon_state = "dromedary"
	base_icon_state = "dromedary"
	spawn_type = /obj/item/clothing/mask/cigarette/dromedary

/obj/item/storage/fancy/cigarettes/cigpack_uplift
	name = "\improper Uplift Smooth packet"
	desc = "Your favorite brand, now menthol flavored."
	icon_state = "uplift"
	base_icon_state = "uplift"
	spawn_type = /obj/item/clothing/mask/cigarette/uplift

/obj/item/storage/fancy/cigarettes/cigpack_robust
	name = "\improper Robust packet"
	desc = "Smoked by the robust."
	icon_state = "robust"
	base_icon_state = "robust"
	spawn_type = /obj/item/clothing/mask/cigarette/robust

/obj/item/storage/fancy/cigarettes/cigpack_robustgold
	name = "\improper Robust Gold packet"
	desc = "Smoked by the truly robust."
	icon_state = "robustg"
	base_icon_state = "robustg"
	spawn_type = /obj/item/clothing/mask/cigarette/robustgold

/obj/item/storage/fancy/cigarettes/cigpack_carp
	name = "\improper Carp Classic packet"
	desc = "Since 2313."
	icon_state = "carp"
	base_icon_state = "carp"
	spawn_type = /obj/item/clothing/mask/cigarette/carp

/obj/item/storage/fancy/cigarettes/cigpack_syndicate
	name = "cigarette packet"
	desc = "An obscure brand of cigarettes."
	icon_state = "syndie"
	base_icon_state = "syndie"
	spawn_type = /obj/item/clothing/mask/cigarette/syndicate

/obj/item/storage/fancy/cigarettes/cigpack_midori
	name = "\improper Midori Tabako packet"
	desc = "You can't understand the runes, but the packet smells funny."
	icon_state = "midori"
	base_icon_state = "midori"
	spawn_type = /obj/item/clothing/mask/cigarette/rollie/nicotine

/obj/item/storage/fancy/cigarettes/cigpack_candy
	name = "\improper Timmy's First Candy Smokes packet"
	desc = "Unsure about smoking? Want to bring your children safely into the family tradition? Look no more with this special packet! Includes 100%* Nicotine-Free candy cigarettes."
	icon_state = "candy"
	base_icon_state = "candy"
	spawn_type = /obj/item/clothing/mask/cigarette/candy
	candy = TRUE
	age_restricted = FALSE
	contents_tag = "конфеток"

/obj/item/storage/fancy/cigarettes/cigpack_candy/Initialize(mapload)
	. = ..()
	if(prob(7))
		spawn_type = /obj/item/clothing/mask/cigarette/candy/nicotine //uh oh!

/obj/item/storage/fancy/cigarettes/cigpack_shadyjims
	name = "\improper Shady Jim's Super Slims packet"
	desc = "Is your weight slowing you down? Having trouble running away from gravitational singularities? Can't stop stuffing your mouth? Smoke Shady Jim's Super Slims and watch all that fat burn away. Guaranteed results!"
	icon_state = "shadyjim"
	base_icon_state = "shadyjim"
	spawn_type = /obj/item/clothing/mask/cigarette/shadyjims

/obj/item/storage/fancy/cigarettes/cigpack_xeno
	name = "\improper Xeno Filtered packet"
	desc = "Loaded with 100% pure slime. And also nicotine."
	icon_state = "slime"
	base_icon_state = "slime"
	spawn_type = /obj/item/clothing/mask/cigarette/xeno

/obj/item/storage/fancy/cigarettes/cigpack_cannabis
	name = "\improper Freak Brothers' Special packet"
	desc = "A label on the packaging reads, \"Endorsed by Phineas, Freddy and Franklin.\""
	icon_state = "midori"
	base_icon_state = "midori"
	spawn_type = /obj/item/clothing/mask/cigarette/rollie/cannabis

/obj/item/storage/fancy/cigarettes/cigpack_mindbreaker
	name = "\improper Leary's Delight packet"
	desc = "Banned in over 36 galaxies."
	icon_state = "shadyjim"
	base_icon_state = "shadyjim"
	spawn_type = /obj/item/clothing/mask/cigarette/rollie/mindbreaker

/obj/item/storage/fancy/rollingpapers
	name = "упаковка папиросной бумаги"
	desc = "Тонкий лист бумаги, используемый для приготовления сигаретных изделий."
	w_class = WEIGHT_CLASS_TINY
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cig_paper_pack"
	base_icon_state = "cig_paper_pack"
	spawn_type = /obj/item/rollingpaper
	spawn_count = 10
	custom_price = PAYCHECK_PRISONER
	has_open_closed_states = FALSE
	contents_tag = "бумажек"

/obj/item/storage/fancy/rollingpapers/Initialize()
	. = ..()
	atom_storage.max_slots = 10
	atom_storage.set_holdable(list(/obj/item/rollingpaper))

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
	base_icon_state = "cigarcase"
	w_class = WEIGHT_CLASS_NORMAL
	spawn_type = /obj/item/clothing/mask/cigarette/cigar
	spawn_count = 5
	spawn_coupon = FALSE
	contents_tag = "сигар"

/obj/item/storage/fancy/cigarettes/cigars/Initialize()
	. = ..()
	atom_storage.set_holdable(list(/obj/item/clothing/mask/cigarette/cigar))

/obj/item/storage/fancy/cigarettes/cigars/update_icon_state()
	. = ..()
	//reset any changes the parent call may have made
	icon_state = base_icon_state

/obj/item/storage/fancy/cigarettes/cigars/update_overlays()
	. = ..()
	if(!is_open)
		return
	var/cigar_position = 1 //generate sprites for cigars in the box
	for(var/obj/item/clothing/mask/cigarette/cigar/smokes in contents)
		. += "[smokes.icon_off]_[cigar_position]"
		cigar_position++

/obj/item/storage/fancy/cigarettes/cigars/cohiba
	name = "\improper Cohiba Robusto cigar case"
	desc = "A case of imported Cohiba cigars, renowned for their strong flavor."
	icon_state = "cohibacase"
	base_icon_state = "cohibacase"
	spawn_type = /obj/item/clothing/mask/cigarette/cigar/cohiba

/obj/item/storage/fancy/cigarettes/cigars/havana
	name = "\improper premium Havanian cigar case"
	desc = "A case of classy Havanian cigars."
	icon_state = "cohibacase"
	base_icon_state = "cohibacase"
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
	base_icon_state = "chocolatebox"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	spawn_type = /obj/item/food/tinychocolate
	spawn_count = 8
	contents_tag = "шоколадок"

/obj/item/storage/fancy/heart_box/Initialize()
	. = ..()
	atom_storage.set_holdable(list(/obj/item/food/tinychocolate))


/obj/item/storage/fancy/nugget_box
	name = "nugget box"
	desc = "A cardboard box used for holding chicken nuggies."
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "nuggetbox"
	base_icon_state = "nuggetbox"
	spawn_type = /obj/item/food/nugget
	spawn_count = 6
	contents_tag = "наггетсов"

/obj/item/storage/fancy/nugget_box/Initialize()
	. = ..()
	atom_storage.set_holdable(list(/obj/item/food/nugget))

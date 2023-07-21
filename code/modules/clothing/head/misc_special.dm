/*
 * Contents:
 *		Welding mask
 *		Cakehat
 *		Ushanka
 *		Pumpkin head
 *		Kitty ears
 *		Cardborg disguise
 *		Wig
 *		Bronze hat
 */

/*
 * Welding mask
 */
/obj/item/clothing/head/welding
	name = "сварочная маска"
	desc = "Закрепляемый на голове лицевой щиток, предназначеннай для полной защиты пользователя от космической дуги."
	icon_state = "welding"
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	inhand_icon_state = "welding"
	custom_materials = list(/datum/material/iron=1750, /datum/material/glass=400)
	flash_protect = FLASH_PROTECTION_WELDER
	tint = 2
	armor = list(MELEE = 10, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 60)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDESNOUT
	actions_types = list(/datum/action/item_action/toggle)
	visor_flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDESNOUT
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	resistance_flags = FIRE_PROOF
	clothing_flags = SNUG_FIT

/obj/item/clothing/head/welding/attack_self(mob/user)
	weldingvisortoggle(user)

/obj/item/clothing/head/welding/open/Initialize(mapload)
	. = ..()
	visor_toggling()

/*
 * Cakehat
 */
/obj/item/clothing/head/hardhat/cakehat
	name = "тортошляпа"
	desc = "Ты кладешь торт себе на голову. Блестяще."
	icon_state = "hardhat0_cakehat"
	inhand_icon_state = "hardhat0_cakehat"
	hat_type = "cakehat"
	lefthand_file = 'icons/mob/inhands/clothing_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/clothing_righthand.dmi'
	hitsound = 'sound/weapons/tap.ogg'
	var/hitsound_on = 'sound/weapons/sear.ogg' //so we can differentiate between cakehat and energyhat
	var/hitsound_off = 'sound/weapons/tap.ogg'
	var/force_on = 15
	var/throwforce_on = 15
	var/damtype_on = BURN
	flags_inv = HIDEEARS|HIDEHAIR
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)
	light_range = 2 //luminosity when on
	light_system = MOVABLE_LIGHT
	flags_cover = HEADCOVERSEYES
	heat = 999

	dog_fashion = /datum/dog_fashion/head

/obj/item/clothing/head/hardhat/cakehat/process()
	var/turf/location = src.loc
	if(ishuman(location))
		var/mob/living/carbon/human/M = location
		if(M.is_holding(src) || M.head == src)
			location = M.loc

	if(isturf(location))
		location.hotspot_expose(700, 1)

/obj/item/clothing/head/hardhat/cakehat/turn_on(mob/living/user)
	..()
	force = force_on
	throwforce = throwforce_on
	damtype = damtype_on
	hitsound = hitsound_on
	START_PROCESSING(SSobj, src)

/obj/item/clothing/head/hardhat/cakehat/turn_off(mob/living/user)
	..()
	force = 0
	throwforce = 0
	damtype = BRUTE
	hitsound = hitsound_off
	STOP_PROCESSING(SSobj, src)

/obj/item/clothing/head/hardhat/cakehat/get_temperature()
	return on * heat

/obj/item/clothing/head/hardhat/cakehat/energycake
	name = "энергетический торт"
	desc = "Ты положил энергетический меч на свой торт. Блестяще."
	icon_state = "hardhat0_energycake"
	inhand_icon_state = "hardhat0_energycake"
	hat_type = "energycake"
	hitsound = 'sound/weapons/tap.ogg'
	hitsound_on = 'sound/weapons/blade1.ogg'
	hitsound_off = 'sound/weapons/tap.ogg'
	damtype_on = BRUTE
	force_on = 18 //same as epen (but much more obvious)
	light_range = 3 //ditto
	heat = 0

/obj/item/clothing/head/hardhat/cakehat/energycake/turn_on(mob/living/user)
	playsound(user, 'sound/weapons/saberon.ogg', 5, TRUE)
	to_chat(user, span_warning("Ты включаешь <b>[src.name]</b>."))
	..()

/obj/item/clothing/head/hardhat/cakehat/energycake/turn_off(mob/living/user)
	playsound(user, 'sound/weapons/saberoff.ogg', 5, TRUE)
	to_chat(user, span_warning("Ты выключаешь <b>[src.name]</b>."))
	..()

/*
 * Ushanka
 */
/obj/item/clothing/head/ushanka
	name = "ушанка"
	desc = "Идеально подходит для зимы в Сибири, да?"
	icon_state = "ushankadown"
	inhand_icon_state = "ushankadown"
	flags_inv = HIDEEARS
	var/earflaps = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_HELM_MIN_TEMP_PROTECT

	dog_fashion = /datum/dog_fashion/head/ushanka

/obj/item/clothing/head/ushanka/attack_self(mob/user)
	if(earflaps)
		icon_state = "ushankaup"
		inhand_icon_state = "ushankaup"
		to_chat(user, span_notice("Поднимаю ушки на Ушанке."))
	else
		icon_state = "ushankadown"
		inhand_icon_state = "ushankadown"
		to_chat(user, span_notice("Опускаю ушки на Ушанке."))
	earflaps = !earflaps

/*
 * Pumpkin head
 */
/obj/item/clothing/head/hardhat/pumpkinhead
	name = "резная тыква"
	desc = "Домкрат фонаря! Верующий в отпугивание злых духов."
	icon_state = "hardhat0_pumpkin"
	inhand_icon_state = "hardhat0_pumpkin"
	hat_type = "pumpkin"
	clothing_flags = SNUG_FIT
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)
	light_range = 2 //luminosity when on
	flags_cover = HEADCOVERSEYES

/*
 * Kitty ears
 */
/obj/item/clothing/head/kitty
	name = "котоушки"
	desc = "Пара кошачьих ушей. Мяу!"
	icon_state = "kitty"
	color = "#999999"
	dynamic_hair_suffix = ""

	dog_fashion = /datum/dog_fashion/head/kitty

/obj/item/clothing/head/kitty/equipped(mob/living/carbon/human/user, slot)
	if(ishuman(user) && slot == ITEM_SLOT_HEAD)
		update_icon(ALL, user)
		user.update_inv_head() //Color might have been changed by update_icon.
	..()

/obj/item/clothing/head/kitty/update_icon(updates=ALL, mob/living/carbon/human/user)
	. = ..()
	if(ishuman(user))
		add_atom_colour("#[user.hair_color]", FIXED_COLOUR_PRIORITY)

/obj/item/clothing/head/kitty/fox
	name = "ушки лисы"
	desc = "Пара лисьих ушей. Ня!"
	icon_state = "fox"

/obj/item/clothing/head/kitty/genuine
	desc = "Пара кошачьих ушей. На бирке внутри написано: \"Сделано вручную из настоящих кошек.\"."

/obj/item/clothing/head/hardhat/reindeer
	name = "оригинальная оленья шапка"
	desc = "Пара поддельных рогов и крайне фальшивый красный нос."
	icon_state = "hardhat0_reindeer"
	inhand_icon_state = "hardhat0_reindeer"
	hat_type = "reindeer"
	flags_inv = 0
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)
	light_range = 1 //luminosity when on
	dynamic_hair_suffix = ""

	dog_fashion = /datum/dog_fashion/head/reindeer

/obj/item/clothing/head/cardborg
	name = "шлем картонного киборга"
	desc = "Шлем, сделанный из коробки."
	icon_state = "cardborg_h"
	inhand_icon_state = "cardborg_h"
	clothing_flags = SNUG_FIT
	flags_cover = HEADCOVERSEYES
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

	dog_fashion = /datum/dog_fashion/head/cardborg

/obj/item/clothing/head/cardborg/equipped(mob/living/user, slot)
	..()
	if(ishuman(user) && slot == ITEM_SLOT_HEAD)
		var/mob/living/carbon/human/H = user
		if(istype(H.wear_suit, /obj/item/clothing/suit/cardborg))
			var/obj/item/clothing/suit/cardborg/CB = H.wear_suit
			CB.disguise(user, src)

/obj/item/clothing/head/cardborg/dropped(mob/living/user)
	..()
	user.remove_alt_appearance("standard_borg_disguise")

/obj/item/clothing/head/wig
	name = "парик"
	desc = "Куча волос без головы."
	icon = 'icons/mob/human_face.dmi'	  // default icon for all hairs
	icon_state = "hair_vlong"
	inhand_icon_state = "pwig"
	worn_icon_state = "wig"
	flags_inv = HIDEHAIR | HIDEHEADGEAR
	color = "#000"
	var/hairstyle = "Very Long Hair"
	var/adjustablecolor = TRUE //can color be changed manually?

/obj/item/clothing/head/wig/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/clothing/head/wig/update_icon_state()
	var/datum/sprite_accessory/hair_style = GLOB.hairstyles_list[hairstyle]
	if(hair_style)
		icon_state = hair_style.icon_state
	return ..()

/obj/item/clothing/head/wig/worn_overlays(mutable_appearance/standing, isinhands = TRUE, icon_file)
	. = ..()

	if(isinhands)
		return

	var/datum/sprite_accessory/hair = GLOB.hairstyles_list[hairstyle]

	if(!hair)
		return

	var/mutable_appearance/hair_overlay = mutable_appearance(hair.icon, hair.icon_state, layer = -HAIR_LAYER, appearance_flags = RESET_COLOR)
	hair_overlay.color = color
	. += hair_overlay

	// So that the wig actually blocks emissives.
	var/mutable_appearance/hair_blocker = mutable_appearance(hair.icon, hair.icon_state, plane = EMISSIVE_PLANE, appearance_flags = KEEP_APART)
	hair_blocker.color = GLOB.em_block_color
	hair_overlay.overlays += hair_blocker

/obj/item/clothing/head/wig/attack_self(mob/user)
	var/new_style = tgui_input_list(user, "Выберите прическу", "Wig Styling", (GLOB.hairstyles_list - "Bald"))
	var/newcolor = adjustablecolor ? input(usr,"","Choose Color",color) as color|null : null
	if(!user.canUseTopic(src, BE_CLOSE))
		return
	if(new_style && new_style != hairstyle)
		hairstyle = new_style
		user.visible_message(span_notice("[user] меняет прическу [src] на [new_style].") , span_notice("Изменил прическу [src] на [new_style]."))
	if(newcolor && newcolor != color) // only update if necessary
		add_atom_colour(newcolor, FIXED_COLOUR_PRIORITY)
	update_icon()

/obj/item/clothing/head/wig/afterattack(mob/living/carbon/human/target, mob/user)
	. = ..()
	if (istype(target) && (HAIR in target.dna.species.species_traits) && target.hairstyle != "Bald")
		to_chat(user, span_notice("Подстриг [src] под [target.name] [target.hairstyle]."))
		add_atom_colour("#[target.hair_color]", FIXED_COLOUR_PRIORITY)
		hairstyle = target.hairstyle
		update_icon()

/obj/item/clothing/head/wig/random/Initialize(mapload)
	hairstyle = pick(GLOB.hairstyles_list - "Bald") //Don't want invisible wig
	add_atom_colour("#[random_short_color()]", FIXED_COLOUR_PRIORITY)
	. = ..()

/obj/item/clothing/head/wig/natural
	name = "натуральный парик"
	desc = "Куча волос без головы. Он меняет цвет в соответствии с волосами владельца. В этом нет ничего естественного."
	color = "#FFF"
	adjustablecolor = FALSE
	custom_price = PAYCHECK_HARD

/obj/item/clothing/head/wig/natural/Initialize(mapload)
	hairstyle = pick(GLOB.hairstyles_list - "Bald")
	. = ..()

/obj/item/clothing/head/wig/natural/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(ishuman(user) && slot == ITEM_SLOT_HEAD)
		if (color != "#[user.hair_color]") // only update if necessary
			add_atom_colour("#[user.hair_color]", FIXED_COLOUR_PRIORITY)
			update_icon()
		user.update_inv_head()

/obj/item/clothing/head/bronze
	name = "латунный шлем"
	desc = "Необработанный шлем из латунных пластин. Она предлагает очень мало возможностей для защиты."
	icon = 'icons/obj/clothing/clockwork_garb.dmi'
	icon_state = "clockwork_helmet_old"
	clothing_flags = SNUG_FIT
	flags_inv = HIDEEARS|HIDEHAIR
	armor = list(MELEE = 5, BULLET = 0, LASER = -5, ENERGY = -15, BOMB = 10, BIO = 0, RAD = 0, FIRE = 20, ACID = 20)

/obj/item/clothing/head/fancy
	name = "fancy hat"
	icon_state = "fancy_hat"
	greyscale_colors = "#E3C937#782A81"
	greyscale_config = /datum/greyscale_config/fancy_hat
	greyscale_config_worn = /datum/greyscale_config/fancy_hat_worn
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/head/football_helmet
	name = "football helmet"
	icon_state = "football_helmet"
	greyscale_colors = "#D74722"
	greyscale_config = /datum/greyscale_config/football_helmet
	greyscale_config_worn = /datum/greyscale_config/football_helmet_worn
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/head/tv_head
	name = "television helmet"
	desc = "A mysterious headgear made from the hollowed out remains of a status display. How very retro-retro-futuristic of you."
	icon_state = "IPC_helmet"
	inhand_icon_state = "syringe_kit"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi' //Grandfathered in from the wallframe for status displays.
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	clothing_flags = SNUG_FIT
	flash_protect = FLASH_PROTECTION_SENSITIVE
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	var/has_fov = TRUE

/obj/item/clothing/head/tv_head/Initialize(mapload)
	. = ..()
	if(has_fov)
		AddComponent(/datum/component/clothing_fov_visor, FOV_90_DEGREES)

/obj/item/clothing/head/tv_head/fov_less
	desc = "A mysterious headgear made from the hollowed out remains of a status display. How very retro-retro-futuristic of you. It's very easy to see out of this one."
	has_fov = FALSE

/obj/item/clothing/head/foilhat
	name = "шапочка из фольги"
	desc = "Думаю, контрольные лучи, психотроническое сканирование. Не обращай внимания, я защищена, потому что я сделала эту шляпу."
	icon_state = "foilhat"
	inhand_icon_state = "foilhat"
	armor = list(MELEE = 0, BULLET = 0, LASER = -5,ENERGY = -15, BOMB = 0, BIO = 0, RAD = -5, FIRE = 0, ACID = 0)
	equip_delay_other = 140
	clothing_flags = ANTI_TINFOIL_MANEUVER
	var/datum/brain_trauma/mild/phobia/conspiracies/paranoia
	var/warped = FALSE

/obj/item/clothing/head/foilhat/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot != ITEM_SLOT_HEAD || warped)
		return
	if(paranoia)
		QDEL_NULL(paranoia)
	paranoia = new()

	user.gain_trauma(paranoia, TRAUMA_RESILIENCE_MAGIC)
	to_chat(user, span_warning("Как только вы надеваете расклеенную шляпу, в ваш разум вдруг врывается целый мир конспирологических теорий и, казалось бы, безумных идей. То, что ты когда-то считал невероятным... внезапно кажется неоспоримым. Все взаимосвязано и ничего не происходит случайно. Ты слишком много знаешь, и теперь они хотят забрать тебя."))

/obj/item/clothing/head/foilhat/MouseDrop(atom/over_object)
	//God Im sorry
	if(!warped && iscarbon(usr))
		var/mob/living/carbon/C = usr
		if(src == C.head)
			to_chat(C, span_userdanger("Зачем тебе это снимать? Ты хочешь, чтобы они проникли в твой разум?!"))
			return
	return ..()

/obj/item/clothing/head/foilhat/dropped(mob/user)
	. = ..()
	if(paranoia)
		QDEL_NULL(paranoia)

/obj/item/clothing/head/foilhat/proc/warp_up()
	name = "выжженная шапка из фольги"
	desc = "Плохо деформированная шляпа. Весьма невероятно, что это все еще будет работать против вымышленных и современных опасностей, к которым он привык."
	warped = TRUE
	clothing_flags &= ~ANTI_TINFOIL_MANEUVER
	if(!isliving(loc) || !paranoia)
		return
	var/mob/living/target = loc
	if(target.get_item_by_slot(ITEM_SLOT_HEAD) != src)
		return
	QDEL_NULL(paranoia)
	if(target.stat < UNCONSCIOUS)
		to_chat(target, span_warning("Мой ревностный заговор быстро рассеивается по мере того, как надетая шляпа погружается в разрушенный беспорядок. Все эти теории начинают звучать как просто смешная фанфара."))

/obj/item/clothing/head/foilhat/attack_hand(mob/user)
	if(!warped && iscarbon(user))
		var/mob/living/carbon/C = user
		if(src == C.head)
			to_chat(user, span_userdanger("Зачем тебе это снимать? Ты хочешь, чтобы они проникли в твой разум?!"))
			return
	return ..()

/obj/item/clothing/head/foilhat/microwave_act(obj/machinery/microwave/M)
	. = ..()
	if(!warped)
		warp_up()

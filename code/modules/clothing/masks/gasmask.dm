/obj/item/clothing/mask/gas
	name = "противогаз"
	desc = "Маска для лица, которая может быть подключена к источнику воздуха. Хотя это и скрывает вашу личность, это не очень то и блокирует потоки газа." //More accurate
	icon_state = "gas_alt"
	clothing_flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS | GAS_FILTERING
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	w_class = WEIGHT_CLASS_NORMAL
	inhand_icon_state = "gas_alt"
	gas_transfer_coefficient = 0.01
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 100, FIRE = 0, ACID = 0)
	flags_cover = MASKCOVERSEYES | MASKCOVERSMOUTH | PEPPERPROOF
	resistance_flags = NONE
	///Max numbers of installable filters
	var/max_filters = 1
	///List to keep track of each filter
	var/list/gas_filters
	///Does the mask have an FOV?
	var/has_fov = FALSE

/obj/item/clothing/mask/gas/Initialize(mapload)
	. = ..()
	init_fov()
	if(!max_filters)
		return
	for(var/i in 1 to max_filters)
		var/obj/item/gas_filter/filter = new(src)
		LAZYADD(gas_filters, filter)
	has_filter = TRUE

/obj/item/clothing/mask/gas/Destroy()
	QDEL_LAZYLIST(gas_filters)
	return..()

/obj/item/clothing/mask/gas/examine(mob/user)
	. = ..()
	if(max_filters > 0)
		. += span_notice("[src] has [max_filters] slot\s for filters.")
	if(LAZYLEN(gas_filters) > 0)
		. += span_notice("Currently there [LAZYLEN(gas_filters) == 1 ? "is" : "are"] [LAZYLEN(gas_filters)] filter\s with [get_filter_durability()]% durability.")

/obj/item/clothing/mask/gas/attackby(obj/item/filter, mob/user)
	if(!istype(filter, /obj/item/gas_filter))
		return ..()
	if(LAZYLEN(gas_filters) >= max_filters)
		return ..()
	if(!user.transferItemToLoc(filter, src))
		return ..()
	LAZYADD(gas_filters, filter)
	has_filter = TRUE
	return TRUE

///Check _masks.dm for this one
/obj/item/clothing/mask/gas/consume_filter(datum/gas_mixture/breath)
	if(LAZYLEN(gas_filters) <= 0 || max_filters == 0)
		return breath
	var/obj/item/gas_filter/gas_filter = pick(gas_filters)
	var/datum/gas_mixture/filtered_breath = gas_filter.reduce_filter_status(breath)
	if(gas_filter.filter_status <= 0)
		LAZYREMOVE(gas_filters, gas_filter)
		qdel(gas_filter)
	if(LAZYLEN(gas_filters) <= 0)
		has_filter = FALSE
	return filtered_breath

/// Initializes the FoV component for the gas mask
/obj/item/clothing/mask/gas/proc/init_fov()
	if(has_fov)
		AddComponent(/datum/component/clothing_fov_visor, FOV_90_DEGREES)

/**
 * Getter for overall filter durability, takes into consideration all filters filter_status
 */
/obj/item/clothing/mask/gas/proc/get_filter_durability()
	var/max_filters_durability = LAZYLEN(gas_filters) * 100
	var/current_filters_durability
	for(var/obj/item/gas_filter/gas_filter as anything in gas_filters)
		current_filters_durability += gas_filter.filter_status
	var/durability = (current_filters_durability / max_filters_durability) * 100
	return durability

/obj/item/clothing/mask/gas/atmos
	name = "противогаз атмостеха"
	desc = "Улучшенный противогаз, используемый специалистами по атмосферным условиям. Все еще не блокирует потоки газа, но он взрывобезопасен!"
	icon_state = "gas_atmos"
	inhand_icon_state = "gas_atmos"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 100, RAD = 10, FIRE = 20, ACID = 10)
	w_class = WEIGHT_CLASS_SMALL
	gas_transfer_coefficient = 0.001 //cargo cult time, this var does nothing but just in case someone actually makes it do something
	resistance_flags = FIRE_PROOF
	max_filters = 3

/obj/item/clothing/mask/gas/atmos/captain
	name = "противогаз капитана"
	desc = "NanoTrasen срезал углы и перекрасил запасной противогаз, но никому не говори."
	icon_state = "gas_cap"
	inhand_icon_state = "gas_cap"
	resistance_flags = FIRE_PROOF | ACID_PROOF

// **** Welding gas mask ****

/obj/item/clothing/mask/gas/welding
	name = "продвинутая сварочная маска"
	desc = "Противогаз со встроенными сварочными очками и защитной маской. Выглядит как череп разработанный задротом."
	icon_state = "weldingmask"
	inhand_icon_state = "weldingmask"
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	flash_protect = FLASH_PROTECTION_WELDER
	custom_materials = list(/datum/material/iron=4000, /datum/material/glass=2000)
	tint = 2
	armor = list(MELEE = 10, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 55)
	actions_types = list(/datum/action/item_action/toggle)
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE|HIDESNOUT
	flags_cover = MASKCOVERSEYES
	visor_flags_inv = HIDEEYES
	visor_flags_cover = MASKCOVERSEYES
	resistance_flags = FIRE_PROOF

/obj/item/clothing/mask/gas/welding/attack_self(mob/user)
	weldingvisortoggle(user)

/obj/item/clothing/mask/gas/welding/up

/obj/item/clothing/mask/gas/welding/up/Initialize(mapload)
	. = ..()
	visor_toggling()

// ********************************************************************

//Plague Dr suit can be found in clothing/suits/bio.dm
/obj/item/clothing/mask/gas/plaguedoctor
	name = "маска чумного доктора"
	desc = "Модернизированная версия классического дизайна, эта маска не только отфильтровывает токсины, но также может быть подключена к источнику воздуха."
	icon_state = "plaguedoctor"
	inhand_icon_state = "gas_mask"
	armor = list(MELEE = 0, BULLET = 0, LASER = 2,ENERGY = 2, BOMB = 0, BIO = 75, FIRE = 0, ACID = 0)
	has_fov = FALSE
	flags_cover = MASKCOVERSEYES

/obj/item/clothing/mask/gas/syndicate
	name = "тактическая маска"
	desc = "Обтягивающая тактическая маска, которая может быть подключена к источнику воздуха."
	icon_state = "syndicate"
	inhand_icon_state = "gas_mask"
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	strip_delay = 60
	w_class = WEIGHT_CLASS_SMALL
	has_fov = FALSE

/obj/item/clothing/mask/gas/clown_hat
	name = "парик клоуна и маска"
	desc = "Лицо истинного шутника. Клоун неполон без своего парика и маски."
	clothing_flags = MASKINTERNALS
	icon_state = "clown"
	inhand_icon_state = "clown_hat"
	dye_color = DYE_CLOWN
	w_class = WEIGHT_CLASS_SMALL
	flags_cover = MASKCOVERSEYES
	resistance_flags = FLAMMABLE
	actions_types = list(/datum/action/item_action/adjust)
	dog_fashion = /datum/dog_fashion/head/clown
	species_exception = list(/datum/species/golem/bananium)
	var/list/clownmask_designs = list()
	has_fov = FALSE

/obj/item/clothing/mask/gas/clown_hat/Initialize(mapload)
	. = ..()
	clownmask_designs = list(
		"True Form" = image(icon = src.icon, icon_state = "clown"),
		"The Feminist" = image(icon = src.icon, icon_state = "sexyclown"),
		"The Jester" = image(icon = src.icon, icon_state = "chaos"),
		"The Madman" = image(icon = src.icon, icon_state = "joker"),
		"The Rainbow Color" = image(icon = src.icon, icon_state = "rainbow")
		)
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_CLOWN, CELL_VIRUS_TABLE_GENERIC, rand(2,3), 0)

/obj/item/clothing/mask/gas/clown_hat/ui_action_click(mob/user)
	if(!istype(user) || user.incapacitated())
		return

	var/list/options = list()
	options["True Form"] = "clown"
	options["The Feminist"] = "sexyclown"
	options["The Madman"] = "joker"
	options["The Rainbow Color"] ="rainbow"
	options["The Jester"] ="chaos" //Nepeta33Leijon is holding me captive and forced me to help with this please send help

	var/choice = show_radial_menu(user,src, clownmask_designs, custom_check = FALSE, radius = 36, require_near = TRUE)
	if(!choice)
		return FALSE

	if(src && choice && !user.incapacitated() && in_range(user,src))
		icon_state = options[choice]
		user.update_inv_wear_mask()
		update_item_action_buttons()
		to_chat(user, span_notice("Маска клоуна превратилась в [choice], слава Хонкоматери!"))
		return TRUE

/obj/item/clothing/mask/gas/sexyclown
	name = "сексуальный парик клоуна и маска"
	desc = "Женская маска клоуна для маленьких трансвеститов или артистов-женщин."
	clothing_flags = MASKINTERNALS
	icon_state = "sexyclown"
	inhand_icon_state = "sexyclown"
	flags_cover = MASKCOVERSEYES
	resistance_flags = FLAMMABLE
	species_exception = list(/datum/species/golem/bananium)
	has_fov = FALSE

/obj/item/clothing/mask/gas/mime
	name = "маска мима"
	desc = "Традиционная маска мима. У него жуткая поза лица."
	clothing_flags = MASKINTERNALS
	icon_state = "mime"
	inhand_icon_state = "mime"
	w_class = WEIGHT_CLASS_SMALL
	flags_cover = MASKCOVERSEYES
	resistance_flags = FLAMMABLE
	actions_types = list(/datum/action/item_action/adjust)
	species_exception = list(/datum/species/golem)
	var/list/mimemask_designs = list()
	has_fov = FALSE

/obj/item/clothing/mask/gas/mime/Initialize(mapload)
	. = ..()
	mimemask_designs = list(
		"Blanc" = image(icon = src.icon, icon_state = "mime"),
		"Excité" = image(icon = src.icon, icon_state = "sexymime"),
		"Triste" = image(icon = src.icon, icon_state = "sadmime"),
		"Effrayé" = image(icon = src.icon, icon_state = "scaredmime")
		)

/obj/item/clothing/mask/gas/mime/ui_action_click(mob/user)
	if(!istype(user) || user.incapacitated())
		return

	var/list/options = list()
	options["Blanc"] = "mime"
	options["Triste"] = "sadmime"
	options["Effrayé"] = "scaredmime"
	options["Excité"] ="sexymime"

	var/choice = show_radial_menu(user,src, mimemask_designs, custom_check = FALSE, radius = 36, require_near = TRUE)
	if(!choice)
		return FALSE

	if(src && choice && !user.incapacitated() && in_range(user,src))
		icon_state = options[choice]
		user.update_inv_wear_mask()
		update_item_action_buttons()
		to_chat(user, span_notice("Маска Мима теперь превратилась в [choice]!"))
		return TRUE

/obj/item/clothing/mask/gas/monkeymask
	name = "маска обезьяны"
	desc = "Ау-кау-ау-ау? УКУУ-УАКААААА-КУААА!!!"
	clothing_flags = MASKINTERNALS
	icon_state = "monkeymask"
	inhand_icon_state = "monkeymask"
	flags_cover = MASKCOVERSEYES
	resistance_flags = FLAMMABLE
	has_fov = FALSE

/obj/item/clothing/mask/gas/sexymime
	name = "сексуальная маска мима"
	desc = "Традиционная женская мимовская маска."
	clothing_flags = MASKINTERNALS
	icon_state = "sexymime"
	inhand_icon_state = "sexymime"
	flags_cover = MASKCOVERSEYES
	resistance_flags = FLAMMABLE
	species_exception = list(/datum/species/golem)
	has_fov = FALSE

/obj/item/clothing/mask/gas/cyborg
	name = "забрало киборга"
	desc = "Бип буп."
	icon_state = "death"
	resistance_flags = FLAMMABLE
	has_fov = FALSE
	flags_cover = MASKCOVERSEYES

/obj/item/clothing/mask/gas/owl_mask
	name = "маска совы"
	desc = "У-УУУ!"
	icon_state = "owl"
	clothing_flags = MASKINTERNALS
	flags_cover = MASKCOVERSEYES
	resistance_flags = FLAMMABLE
	has_fov = FALSE

/obj/item/clothing/mask/gas/carp
	name = "маска карпа"
	desc = "Кусь-кусь."
	icon_state = "carp_mask"
	has_fov = FALSE
	flags_cover = MASKCOVERSEYES

/obj/item/clothing/mask/gas/tiki_mask
	name = "маска тики"
	desc = "Жуткая деревянная маска. Удивительно выразительно для плохо вырезанного куска дерева."
	icon_state = "tiki_eyebrow"
	inhand_icon_state = "tiki_eyebrow"
	custom_materials = list(/datum/material/wood = MINERAL_MATERIAL_AMOUNT * 1.25)
	resistance_flags = FLAMMABLE
	has_fov = FALSE
	flags_cover = MASKCOVERSEYES
	max_integrity = 100
	actions_types = list(/datum/action/item_action/adjust)
	dog_fashion = null
	species_exception = list(/datum/species/golem/wood)
	var/list/tikimask_designs = list()

/obj/item/clothing/mask/gas/tiki_mask/Initialize(mapload)
	. = ..()
	tikimask_designs = list(
		"Original Tiki" = image(icon = src.icon, icon_state = "tiki_eyebrow"),
		"Happy Tiki" = image(icon = src.icon, icon_state = "tiki_happy"),
		"Confused Tiki" = image(icon = src.icon, icon_state = "tiki_confused"),
		"Angry Tiki" = image(icon = src.icon, icon_state = "tiki_angry")
		)

/obj/item/clothing/mask/gas/tiki_mask/ui_action_click(mob/user)
	var/mob/M = usr
	var/list/options = list()
	options["Original Tiki"] = "tiki_eyebrow"
	options["Happy Tiki"] = "tiki_happy"
	options["Confused Tiki"] = "tiki_confused"
	options["Angry Tiki"] ="tiki_angry"

	var/choice = show_radial_menu(user,src, tikimask_designs, custom_check = FALSE, radius = 36, require_near = TRUE)
	if(!choice)
		return FALSE

	if(src && choice && !M.stat && in_range(M,src))
		icon_state = options[choice]
		user.update_inv_wear_mask()
		update_item_action_buttons()
		to_chat(M, span_notice("Маска Тики теперь выглядит как маска [choice]!"))
		return 1

/obj/item/clothing/mask/gas/tiki_mask/yalp_elor
	icon_state = "tiki_yalp"
	actions_types = list()

/obj/item/clothing/mask/gas/hunter
	name = "маска педераста"
	desc = "Тактическая маска с добавленными отличительными знаками."
	icon_state = "hunter"
	inhand_icon_state = "hunter"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	flags_inv = HIDEFACIALHAIR|HIDEFACE|HIDEEYES|HIDEEARS|HIDEHAIR|HIDESNOUT
	has_fov = FALSE

/obj/item/clothing/mask/gas/driscoll
	name = "driscoll mask"
	desc = "Great for train hijackings. Works like a normal full face gas mask, but won't conceal your identity."
	icon_state = "driscoll_mask"
	flags_inv = HIDEFACIALHAIR
	w_class = WEIGHT_CLASS_NORMAL
	inhand_icon_state = "driscoll_mask"

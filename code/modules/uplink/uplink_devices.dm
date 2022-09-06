// A collection of pre-set uplinks, for admin spawns.

// Radio-like uplink; not an actual radio because this uplink is most commonly
// used for nuke ops, for whom opening the radio GUI and the uplink GUI
// simultaneously is an annoying distraction.
/obj/item/uplink
	name = "старое радио"
	icon = 'icons/obj/radio.dmi'
	icon_state = "radio"
	inhand_icon_state = "walkietalkie"
	worn_icon_state = "radio"
	desc = "Базовая портативное радио, обеспечивающее связь с местными телекоммуникационными сетями."
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	dog_fashion = /datum/dog_fashion/back

	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	throw_speed = 3
	throw_range = 7
	w_class = WEIGHT_CLASS_SMALL

	/// The uplink flag for this type.
	/// See [`code/__DEFINES/uplink.dm`]
	var/uplink_flag = UPLINK_TRAITORS

/obj/item/uplink/Initialize(mapload, owner, tc_amount = 20)
	. = ..()
	AddComponent(/datum/component/uplink, owner, FALSE, TRUE, uplink_flag, tc_amount)

/obj/item/uplink/debug
	name = "debug uplink"

/obj/item/uplink/debug/Initialize(mapload, owner, tc_amount = 9000)
	. = ..()
	var/datum/component/uplink/hidden_uplink = GetComponent(/datum/component/uplink)
	hidden_uplink.name = "debug uplink"
	hidden_uplink.debug = TRUE

/obj/item/uplink/nuclear
	uplink_flag = UPLINK_NUKE_OPS

/obj/item/uplink/nuclear/locked
	name = "защищённый аплинк"
	var/lock_code

/obj/item/uplink/nuclear/locked/Initialize(mapload, owner, tc_amount)
	. = ..()
	var/datum/component/uplink/hidden_uplink = GetComponent(/datum/component/uplink)
	hidden_uplink.active = FALSE
	hidden_uplink.locked = TRUE
	// ну давай, налетай, у тебя всего лишь одна попытка
	if(GLOB.round_id)
		lock_code = ROUND_UP(ROOT(INVERSE_SQUARE(ROOT(text2num(GLOB.round_id) * rand(1, 10), 3), 10, 4), 9))

/obj/item/uplink/nuclear/locked/attack_self(mob/user, modifiers)
	. = ..()

	var/datum/component/uplink/hidden_uplink = GetComponent(/datum/component/uplink)

	if(hidden_uplink?.active)
		return

	var/solution = input(user, null, "Ответ?") as num|null

	if(!solution)
		return

	if(solution != lock_code)
		to_chat(user, span_info("Ответ неверный."))
		if(isliving(user))
			var/mob/living/L = user
			L.gib()
		else
			qdel(user)
		return

	hidden_uplink.active = TRUE
	hidden_uplink.locked = FALSE

	to_chat(user, span_info("Ответ верный."))

/obj/item/uplink/nuclear/debug
	name = "debug nuclear uplink"
	uplink_flag = UPLINK_NUKE_OPS

/obj/item/uplink/nuclear/debug/Initialize(mapload, owner, tc_amount = 9000)
	. = ..()
	var/datum/component/uplink/hidden_uplink = GetComponent(/datum/component/uplink)
	hidden_uplink.name = "debug nuclear uplink"
	hidden_uplink.debug = TRUE

/obj/item/uplink/nuclear_restricted
	uplink_flag = UPLINK_NUKE_OPS

/obj/item/uplink/nuclear_restricted/Initialize(mapload)
	. = ..()
	var/datum/component/uplink/hidden_uplink = GetComponent(/datum/component/uplink)
	hidden_uplink.allow_restricted = FALSE

/obj/item/uplink/clownop
	uplink_flag = UPLINK_CLOWN_OPS

/obj/item/uplink/old
	name = "пыльное радио"
	desc = "Пыльный радиоприемник."

/obj/item/uplink/old/Initialize(mapload, owner, tc_amount = 10)
	. = ..()
	var/datum/component/uplink/hidden_uplink = GetComponent(/datum/component/uplink)
	hidden_uplink.name = "dusty radio"

// Multitool uplink
/obj/item/multitool/uplink/Initialize(mapload, owner, tc_amount = 20)
	. = ..()
	AddComponent(/datum/component/uplink, owner, FALSE, TRUE, UPLINK_TRAITORS, tc_amount)

// Pen uplink
/obj/item/pen/uplink/Initialize(mapload, owner, tc_amount = 20)
	. = ..()
	AddComponent(/datum/component/uplink, owner, TRUE, FALSE, UPLINK_TRAITORS, tc_amount)

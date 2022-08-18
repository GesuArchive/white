/datum/action/item_action/toggle

/datum/action/item_action/toggle/New(Target)
	..()
	var/obj/item/item_target = target
	name = "Переключить [item_target.name]"

/datum/action/item_action/toggle_light
	name = "Переключить Свет"

/datum/action/item_action/toggle_computer_light
	name = "Переключить Фонарик"

/datum/action/item_action/toggle_hood
	name = "Переключить Капюшон"

/datum/action/item_action/toggle_firemode
	name = "Переключить Режим огня"

/datum/action/item_action/toggle_gunlight
	name = "Переключить Фонарик"

/datum/action/item_action/toggle_mode
	name = "Переключить Режим"

/datum/action/item_action/toggle_barrier_spread
	name = "Переключить Распространение Барьера"

/datum/action/item_action/toggle_paddles
	name = "Переключить Лопасти"

/datum/action/item_action/toggle_mister
	name = "Toggle Mister"

/datum/action/item_action/toggle_helmet_light
	name = "Переключить Фонарик"

/datum/action/item_action/toggle_welding_screen
	name = "Переключить Сварочную Маску"

/datum/action/item_action/toggle_spacesuit
	name = "Переключить Терморегулятор костюма"
	icon_icon = 'icons/mob/actions/actions_spacesuit.dmi'
	button_icon_state = "thermal_off"

/datum/action/item_action/toggle_spacesuit/UpdateButton(atom/movable/screen/movable/action_button/button, status_only = FALSE, force)
	var/obj/item/clothing/suit/space/suit = target
	if(istype(suit))
		button_icon_state = "thermal_[suit.thermal_on ? "on" : "off"]"

	return ..()

/datum/action/item_action/toggle_helmet_flashlight
	name = "Переключить Фонарик Шлема"

/datum/action/item_action/toggle_helmet_mode
	name = "Переключить Режим Шлема"

/datum/action/item_action/toggle_voice_box
	name = "Toggle Voice Box"

/datum/action/item_action/toggle_human_head
	name = "Toggle Human Head"

/datum/action/item_action/toggle_helmet
	name = "Переключить Шлем"

/datum/action/item_action/toggle_seclight
	name = "Переключить Фонарик"

/datum/action/item_action/toggle_jetpack
	name = "Переключить Реактивный Ранец"

/datum/action/item_action/jetpack_stabilization
	name = "Переключить Стабилизаторы Реактивного Ранца"

/datum/action/item_action/jetpack_stabilization/IsAvailable()
	var/obj/item/tank/jetpack/linked_jetpack = target
	if(!istype(linked_jetpack) || !linked_jetpack.on)
		return FALSE
	return ..()

/datum/action/item_action/wheelys
	name = "Toggle Wheels"
	desc = "Pops out or in your shoes' wheels."
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "wheelys"

/datum/action/item_action/kindle_kicks
	name = "Activate Kindle Kicks"
	desc = "Kick you feet together, activating the lights in your Kindle Kicks."
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "kindleKicks"

/datum/action/item_action/storage_gather_mode
	name = "Сменить режим подбора"
	desc = "Переключает режим подбора сумки."
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "storage_gather_switch"

/datum/action/item_action/storage_gather_mode/ApplyIcon(atom/movable/screen/movable/action_button/current_button)
	. = ..()
	var/obj/item/item_target = target
	var/old_layer = item_target.layer
	var/old_plane = item_target.plane
	item_target.layer = FLOAT_LAYER //AAAH
	item_target.plane = FLOAT_PLANE //^ what that guy said
	current_button.cut_overlays()
	current_button.add_overlay(target)
	item_target.layer = old_layer
	item_target.plane = old_plane
	current_button.appearance_cache = item_target.appearance

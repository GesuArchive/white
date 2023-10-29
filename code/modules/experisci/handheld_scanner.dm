/**
 * # Experi-Scanner
 *
 * Handheld scanning unit to perform scanning experiments
 */
/obj/item/experi_scanner
	name = "Экспериментальный сканер"
	desc = "Позволяет анализировать и фиксировать данные полученные из результатов экспериментов."
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/obj/device.dmi'
	icon_state = "experiscanner"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'

/obj/item/experi_scanner/Initialize(mapload)
	..()
	return INITIALIZE_HINT_LATELOAD

// Late initialize to allow for the rnd servers to initialize first
/obj/item/experi_scanner/LateInitialize()
	. = ..()
	AddComponent(/datum/component/experiment_handler, \
		allowed_experiments = list(/datum/experiment/scanning, /datum/experiment/physical),\
		disallowed_traits = EXPERIMENT_TRAIT_DESTRUCTIVE)

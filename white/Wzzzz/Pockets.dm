/datum/component/storage/concrete/pockets/hunter/Initialize()
	. = ..()
	max_items = 3
	max_combined_w_class = 5
	max_w_class = WEIGHT_CLASS_NORMAL

/datum/component/storage/concrete/pockets/webvest/Initialize()
	. = ..()
	max_items = 5
	max_combined_w_class = 10
	max_w_class = WEIGHT_CLASS_NORMAL

/datum/component/storage/concrete/pockets/swatarmor/Initialize()
	. = ..()
	max_items = 3
	max_combined_w_class = 6
	max_w_class = WEIGHT_CLASS_NORMAL

/datum/component/storage/concrete/pockets/tailcoat/Initialize()
	. = ..()
	max_items = 2
	max_combined_w_class = 5
	max_w_class = WEIGHT_CLASS_NORMAL

/datum/component/storage/concrete/pockets/watcher/Initialize()
	. = ..()
	max_items = 15
	max_combined_w_class = 100
	max_w_class = WEIGHT_CLASS_HUGE

/datum/component/storage/concrete/pockets/tac_hazmat/Initialize()
	. = ..()
	max_items = 6
	max_combined_w_class = 10
	max_w_class = WEIGHT_CLASS_NORMAL

/datum/component/storage/concrete/pockets/opvest/Initialize()
	. = ..()
	set_holdable(GLOB.security_vest_allowed)
	max_items = 7
	max_combined_w_class = 13

/datum/component/storage/concrete/pockets/webvest/Initialize()
	. = ..()
	max_items = 5

	max_w_class = WEIGHT_CLASS_NORMAL
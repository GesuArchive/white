// Reels

/obj/item/fishing_line
	name = "катушка для рыболовной лески"
	desc = "Простая рыболовная леска"
	icon = 'icons/obj/fishing.dmi'
	icon_state = "reel_blue"
	var/fishing_line_traits = NONE
	/// Color of the fishing line
	var/line_color = "#808080"

/obj/item/fishing_line/reinforced
	name = "усиленная катушка для лески"
	desc = "Незаменим для рыбалки в экстремальных условиях"
	icon_state = "reel_green"
	fishing_line_traits = FISHING_LINE_REINFORCED
	line_color = "#2b9c2b"

/obj/item/fishing_line/cloaked
	name = "катушка для скрытой лески"
	desc = "Эту леску еще труднее заметить, чем обычную разновидность"
	icon_state = "reel_white"
	fishing_line_traits = FISHING_LINE_CLOAKED
	line_color = "#82cfdd"

/obj/item/fishing_line/bouncy
	name = "катушка для гибкой лески"
	desc = "Эту специализированную леску гораздо сложнее оборвать"
	icon_state = "reel_red"
	fishing_line_traits = FISHING_LINE_BOUNCY
	line_color = "#99313f"

/obj/item/fishing_line/sinew
	name = "рыболовное сухожилие"
	desc = "Полностью натуральная леска, изготовленная из растянутого сухожилия"
	icon = 'icons/obj/fishing.dmi'
	icon_state = "reel_sinew"
	line_color = "#d1cca3"

/datum/crafting_recipe/sinew_line
	name = "Катушка для ловли на сухожильную леску"
	result = /obj/item/fishing_line/sinew
	reqs = list(/obj/item/stack/sheet/sinew = 2)
	time = 2 SECONDS
	category = CAT_TOOLS

// Hooks

/obj/item/fishing_hook
	name = "простой рыболовный крючок"
	desc = "Самый обычный рыболовный крючок."
	icon = 'icons/obj/fishing.dmi'
	icon_state = "hook"
	w_class = WEIGHT_CLASS_TINY

	var/fishing_hook_traits = NONE
	// icon state added to main rod icon when this hook is equipped
	var/rod_overlay_icon_state = "hook_overlay"

/obj/item/fishing_hook/magnet
	name = "магнитный крючок"
	desc = "Это не облегчит ловлю рыбы, но может помочь в поиске других вещей"
	icon_state = "treasure"
	fishing_hook_traits = FISHING_HOOK_MAGNETIC
	rod_overlay_icon_state = "hook_treasure_overlay"

/obj/item/fishing_hook/shiny
	name = "блестящий крючок для приманки"
	icon_state = "gold_shiny"
	fishing_hook_traits = FISHING_HOOK_SHINY
	rod_overlay_icon_state = "hook_shiny_overlay"

/obj/item/fishing_hook/weighted
	name = "утяжеленный крюк"
	icon_state = "weighted"
	fishing_hook_traits = FISHING_HOOK_WEIGHTED
	rod_overlay_icon_state = "hook_weighted_overlay"

/obj/item/fishing_hook/bone
	name = "костяной крючок"
	desc = "простой крючок, вырезанный из заостренной кости"
	icon_state = "hook_bone"

/datum/crafting_recipe/bone_hook
	name = "Костяной крючок из кости Голиафа"
	result = /obj/item/fishing_hook/bone
	reqs = list(/obj/item/stack/sheet/bone = 1)
	time = 2 SECONDS
	category = CAT_TOOLS

/obj/item/storage/toolbox/fishing
	name = "Ящик для рыбных принадлежностей"
	desc = "содержит все, что вам нужно для вашей поездки на рыбалку"
	icon_state = "fishing"
	inhand_icon_state = "artistic_toolbox"
	material_flags = NONE

/obj/item/storage/toolbox/Initialize()
	. = ..()
	// Can hold fishing rod despite the size
	var/static/list/exception_cache = typecacheof(/obj/item/fishing_rod)
	atom_storage.exception_hold = exception_cache

/obj/item/storage/toolbox/fishing/PopulateContents()
	new /obj/item/bait_can/worm(src)
	new /obj/item/fishing_rod(src)
	new /obj/item/fishing_hook(src)
	new /obj/item/fishing_line(src)

/obj/item/storage/box/fishing_hooks
	name = "Набор рыболовных крючков"
	desc = "Набор различных рыболовных крючков."

/obj/item/storage/box/fishing_hooks/PopulateContents()
	. = ..()
	new /obj/item/fishing_hook/magnet(src)
	new /obj/item/fishing_hook/shiny(src)
	new /obj/item/fishing_hook/weighted(src)

/obj/item/storage/box/fishing_lines
	name = "Набор рыболовных лесок"
	desc = "Набор различных рыболовных лесок."

/obj/item/storage/box/fishing_lines/PopulateContents()
	. = ..()
	new /obj/item/fishing_line/bouncy(src)
	new /obj/item/fishing_line/reinforced(src)
	new /obj/item/fishing_line/cloaked(src)

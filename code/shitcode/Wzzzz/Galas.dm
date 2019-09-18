//clothing

/obj/item/clothing/glasses/zw
	name = "Glasses"
	desc = "Очко/и"
	icon = 'code/shitcode/Wzzzz/icons/clothing/glasses.dmi'
	mob_overlay_icon = 'code/shitcode/Wzzzz/icons/clothing/mob1/eyes.dmi'
	icon_state = "googless"
	item_state = "googless"

/obj/item/clothing/glasses/zw/leforge
	name = "Le forge"
	desc = "Аля форж"
	icon = 'code/shitcode/Wzzzz/icons/clothing/glasses.dmi'
	mob_overlay_icon = 'code/shitcode/Wzzzz/icons/clothing/mob1/eyes.dmi'
	icon_state = "leforge"
	item_state = "leforge"

/obj/item/clothing/glasses/zw/denight
	name = "denight vision goggles"
	desc = "Not night, just denight"
	icon = 'code/shitcode/Wzzzz/icons/clothing/glasses.dmi'
	mob_overlay_icon = 'code/shitcode/Wzzzz/icons/clothing/mob1/eyes.dmi'
	icon_state = "denight"
	item_state = "denight"

/obj/item/clothing/glasses/zw/jensenshades
	name = "Jensenshades"
	desc = "Дженсен Стэтхем"
	icon = 'code/shitcode/Wzzzz/icons/clothing/glasses.dmi'
	mob_overlay_icon = 'code/shitcode/Wzzzz/icons/clothing/mob1/eyes.dmi'
	icon_state = "jensenshades"
	item_state = "jensenshades"
	
/obj/item/clothing/glasses/zw/goggless
	name = "Dark gogles"
	desc = "Something familiar, but dark"
	icon = 'code/shitcode/Wzzzz/icons/clothing/glasses.dmi'
	mob_overlay_icon = 'code/shitcode/Wzzzz/icons/clothing/mob1/eyes.dmi'
	icon_state = "goggless"
	item_state = "goggless"

/obj/item/clothing/glasses/zw/sec_flash
	name = "Security glasses"
	desc = "New style, maybe"
	icon = 'code/shitcode/Wzzzz/icons/clothing/glasses.dmi'
	mob_overlay_icon = 'code/shitcode/Wzzzz/icons/clothing/mob1/eyes.dmi'
	icon_state = "sec_flash"
	item_state = "sec_flash"
	
/obj/item/clothing/glasses/zw/rwelding
	name = "New welding goggles"
	desc = "Protects the eyes from bright flashes; approved by the mad scientist association."
	icon = 'code/shitcode/Wzzzz/icons/clothing/glasses.dmi'
	mob_overlay_icon = 'code/shitcode/Wzzzz/icons/clothing/mob1/eyes.dmi'
	icon_state = "rwelding-g"
	item_state = "rwelding-g"
	actions_types = list(/datum/action/item_action/toggle)
	materials = list(/datum/material/iron = 250)
	flash_protect = 2
	tint = 2
	visor_vars_to_toggle = VISOR_FLASHPROTECT | VISOR_TINT
	flags_cover = GLASSESCOVERSEYES
	glass_colour_type = /datum/client_colour/glass_colour/green
/obj/item/melee/zwei
	name = "цвай"
	desc = "вхен зе претендер ис мислидинг."

	icon = 'white/baldenysh/icons/obj/weapons/melee.dmi'
	icon_state = "gs_zwei"

	lefthand_file = 'white/baldenysh/icons/mob/inhands/weapons/melee64x64_lefthand.dmi'
	righthand_file = 'white/baldenysh/icons/mob/inhands/weapons/melee64x64_righthand.dmi'
	inhand_icon_state = "gs_zwei_inhand"
	inhand_x_dimension = 64
	inhand_y_dimension = 64

	worn_icon = 'white/baldenysh/icons/mob/worn/weapons/melee.dmi' //выглядит уебищно, но лучше не получилось чет
	worn_icon_state = "gs_zwei_worn"

	greyscale_colors = "#bdc9ff#ffbb00#1d1550"
	greyscale_config = /datum/greyscale_config/zwei
	greyscale_config_worn = /datum/greyscale_config/zwei_worn
	greyscale_config_inhand_left = /datum/greyscale_config/zwei_inhand_left
	greyscale_config_inhand_right = /datum/greyscale_config/zwei_inhand_right

	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_HUGE
	force = 5
	throwforce = 15
	hitsound = 'sound/weapons/stab1.ogg'
	attack_verb_simple = list("атакует", "рубит", "втыкает", "разрубает", "кромсает", "разрывает", "нарезает", "режет")
	block_chance = 30
	sharpness = SHARP_EDGED
	max_integrity = 150
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 50)
	resistance_flags = FIRE_PROOF
	reach = 2
	custom_materials = list(/datum/material/iron = 10000)

/obj/item/melee/zwei/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_TWOHANDED_WIELD, .proc/on_wield)
	RegisterSignal(src, COMSIG_TWOHANDED_UNWIELD, .proc/on_unwield)

/obj/item/melee/zwei/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=5, force_wielded=40)

/obj/item/melee/zwei/proc/rebuild_icon(wielded = FALSE)
	inhand_icon_state = "gs_zwei_inhand[wielded ? "_wielded" : ""]"
	update_icon()

/obj/item/melee/zwei/proc/on_wield(obj/item/source, mob/user)
	block_chance = 30
	wound_bonus = 30
	rebuild_icon(TRUE)

/obj/item/melee/zwei/proc/on_unwield(obj/item/source, mob/user)
	block_chance = 0
	wound_bonus = 0
	rebuild_icon(FALSE)

/obj/item/melee/zwei/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	user.changeNext_move(3 SECONDS)

/datum/greyscale_config/zwei
	name = "Zwei"
	icon_file = 'white/baldenysh/icons/obj/weapons/melee.dmi'
	json_config = 'white/baldenysh/govnokod/items/melee/zwei/zwei.json'

/datum/greyscale_config/zwei_worn
	name = "Worn Zwei"
	icon_file = 'white/baldenysh/icons/mob/worn/weapons/melee.dmi'
	json_config = 'white/baldenysh/govnokod/items/melee/zwei/zwei_worn.json'

/datum/greyscale_config/zwei_inhand_left
	name = "Held Zwei, Left"
	icon_file = 'white/baldenysh/icons/mob/inhands/weapons/melee64x64_lefthand.dmi'
	json_config = 'white/baldenysh/govnokod/items/melee/zwei/zwei_inhand.json'

/datum/greyscale_config/zwei_inhand_right
	name = "Held Zwei, Right"
	icon_file = 'white/baldenysh/icons/mob/inhands/weapons/melee64x64_righthand.dmi'
	json_config = 'white/baldenysh/govnokod/items/melee/zwei/zwei_inhand.json'

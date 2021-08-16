/obj/item/gun/energy/e_gun/advtaser/mounted
	name = "монтированный тазер"
	desc = "Двухрежимное оружие на руку, которое запускает электроды и останавливающие выстрелы."
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "taser"
	inhand_icon_state = "armcannonstun4"
	force = 5
	selfcharge = 1
	can_flashlight = FALSE
	trigger_guard = TRIGGER_GUARD_ALLOW_ALL // Has no trigger at all, uses neural signals instead
	jam_chance = 0

/obj/item/gun/energy/e_gun/advtaser/mounted/dropped()//if somebody manages to drop this somehow...
	..()

/obj/item/gun/energy/laser/mounted
	name = "монтированный лазер"
	desc = "Орудие, установленное на руку, которое запускает смертельные лазеры."
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "laser"
	inhand_icon_state = "armcannonlase"
	force = 5
	selfcharge = 1
	trigger_guard = TRIGGER_GUARD_ALLOW_ALL
	jam_chance = 0

/obj/item/gun/energy/laser/mounted/dropped()
	..()

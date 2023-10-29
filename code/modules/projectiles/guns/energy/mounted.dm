/obj/item/gun/energy/e_gun/advtaser/mounted
	name = "монтированный тазер"
	desc = "Двухрежимное оружие на руку, которое запускает электроды и останавливающие выстрелы."
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "taser"
	inhand_icon_state = "armcannonstun4"
	force = 5
	selfcharge = 1
	trigger_guard = TRIGGER_GUARD_ALLOW_ALL // Has no trigger at all, uses neural signals instead

/obj/item/gun/energy/e_gun/advtaser/mounted/add_seclight_point()
	return

/obj/item/gun/energy/e_gun/advtaser/mounted/make_jamming()
	return

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

/obj/item/gun/energy/e_gun/advtaser/mounted/make_jamming()
	return

/obj/item/gun/energy/laser/mounted/dropped()
	..()

/obj/item/gun/energy/laser/mounted/augment
	icon = 'icons/obj/surgery.dmi'
	icon_state = "arm_laser"

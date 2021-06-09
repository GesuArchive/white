// маска нихуевая 1щ

/obj/item/clothing/head/helmet/maskasch
	name = "Маска 1Щ"
	desc = "Рейд окончен: голова, глаза."
	icon = 'white/rebolution228/clothing/hats.dmi'
	worn_icon = 'white/rebolution228/clothing/hats_mob.dmi'
	icon_state = "maska1sch"
	inhand_icon_state = "helmet"
	toggle_message = "Опускаю забрало"
	alt_toggle_message = "Поднимаю забрало"
	can_toggle = 1
	armor = list(MELEE = 100, BULLET = 80, LASER = 50, ENERGY = 50, BOMB = 60, BIO = 0, RAD = 0, FIRE = 60, ACID = 80, WOUND = 15)
	flags_inv = HIDEEARS|HIDEFACE|HIDESNOUT
	strip_delay = 100
	actions_types = list(/datum/action/item_action/toggle)
	visor_flags_inv = HIDEFACE|HIDESNOUT
	toggle_cooldown = 0
	flags_cover = HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSMOUTH | PEPPERPROOF
	dog_fashion = null
	flash_protect = FLASH_PROTECTION_FLASH

/obj/item/clothing/head/helmet/maskasch/attack_self(mob/user)
	if(can_toggle && !user.incapacitated())
		if(world.time > cooldown + toggle_cooldown)
			cooldown = world.time
			up = !up
			flags_1 ^= visor_flags
			flags_inv ^= visor_flags_inv
			flags_cover ^= visor_flags_cover
			icon_state = "[initial(icon_state)][up ? "up" : ""]"
			to_chat(user, "<span class='notice'>[up ? alt_toggle_message : toggle_message] [src].</span>")

			user.update_inv_head()
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.head_update(src, forced = 1)

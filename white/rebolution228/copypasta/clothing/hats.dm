// маска 1щ

/obj/item/clothing/head/helmet/maska
	name = "Маска 1Щ"
	desc = "Тяжелый штурмовой шлем, используемый специальными подразделениями Новой России, входящие в отдел NanoTrasen. Хорошо защищает от ударов и пуль, но имеет посредственную защиту от лазерных лучей. Напоминает вам о окончании рейда."
	icon = 'white/rebolution228/icons/clothing/hats.dmi'
	worn_icon = 'white/rebolution228/icons/clothing/mob/hats_mob.dmi'
	icon_state = "maska1sch"
	lefthand_file = 'white/rebolution228/icons/clothing/inhand_clothing_left.dmi'
	righthand_file = 'white/rebolution228/icons/clothing/inhand_clothing_right.dmi'
	inhand_icon_state = "maska1sch"
	toggle_message = "Опускаю забрало"
	alt_toggle_message = "Поднимаю забрало"
	force = 15
	can_toggle = 1
	armor = list(MELEE = 90, BULLET = 80, LASER = 50, ENERGY = 50, BOMB = 80, BIO = 0, RAD = 0, FIRE = 70, WOUND = 20)
	strip_delay = 100
	actions_types = list(/datum/action/item_action/toggle)
	flags_inv = HIDEEARS|HIDEHAIR|HIDESNOUT
	visor_flags_inv = HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	dog_fashion = null
	toggle_cooldown = 0.5
	flash_protect = FLASH_PROTECTION_FLASH

/obj/item/clothing/head/helmet/maska/attack_self(mob/user)
	if(can_toggle && !user.incapacitated())
		if(world.time > cooldown + toggle_cooldown)
			cooldown = world.time
			up = !up
			flags_1 ^= visor_flags
			flags_inv ^= visor_flags_inv
			flags_cover ^= visor_flags_cover
			icon_state = "[initial(icon_state)][up ? "up" : ""]"
			to_chat(user, span_notice("[up ? alt_toggle_message : toggle_message] [src]."))

			user.update_inv_head()
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.head_update(src, forced = 1)

/obj/item/clothing/head/helmet/maska/black
	icon_state = "bmaska1sch"

/obj/item/clothing/head/helmet/maska/adidas
	desc = "Тяжелый штурмовой шлем, используемый специальными подразделениями Новой России, входящие в отдел NanoTrasen. Этот шлем был раскрашен в темный цвет с нанесенными тремя белыми полосками. Похоже, что он крепче обычных шлемов."
	icon_state = "tpmaska1sch"
	armor = list(MELEE = 100, BULLET = 100, LASER = 70, ENERGY = 70, BOMB = 80, BIO = 0, RAD = 0, FIRE = 70, WOUND = 20)

//алтын

/obj/item/clothing/head/helmet/maska/altyn
	name = "Шлем 'Алтын'"
	desc = "Штурмовой шлем, используемый российским спецназом. Надежно защищает от удара баллоном или пули, но плохо защищает от лазерных лучей."
	inhand_icon_state = "altyn"
	icon_state = "altyn"
	armor = list(MELEE = 60, BULLET = 70, LASER = 30, ENERGY = 30, BOMB = 80, BIO = 0, RAD = 0, FIRE = 70, WOUND = 15)

/obj/item/clothing/head/helmet/maska/altyn/black
	icon_state = "baltyn"


// field medic helmet

/obj/item/clothing/head/soft/sec/fieldmedic
	name = "кепка полевого медика"
	desc = "Прочная кепка с блестящим белым крестом. Выполни свой долг - спаси жизнь."
	icon = 'white/rebolution228/icons/clothing/hats.dmi'
	worn_icon = 'white/rebolution228/icons/clothing/mob/hats_mob.dmi'
	icon_state = "secmedsoft"
	soft_type = "secmed"

// синий берет

/obj/item/clothing/head/beret/blue
	name = "синий берет"
	desc = "Простой синий берет. На деле он голубой, но кого это волнует?"
	icon = 'white/rebolution228/icons/clothing/hats.dmi'
	icon_state = "blueberet"
	worn_icon = 'white/rebolution228/icons/clothing/mob/hats_mob.dmi'
	worn_icon_state = "blueberet"
	greyscale_colors = "#3f3c40"

/obj/item/clothing/head/beret/airborne
	name = "берет десанта"
	desc = "Голубой берет воздушно-десантных войск с красной звездой в венке из колосьев. ВДВ, с неба привет, ультрамариновый на бок берет!"
	icon = 'white/rebolution228/icons/clothing/hats.dmi'
	icon_state = "vdv_beret"
	worn_icon = 'white/rebolution228/icons/clothing/mob/hats_mob.dmi'
	worn_icon_state = "vdv_beret"
	greyscale_colors = null //yeah so whaT?
	armor = list(MELEE = 10, BULLET = 10, LASER = 15, ENERGY = 20, BOMB = 10, BIO = 0, RAD = 0, FIRE = 90, ACID = 5, WOUND = 4)

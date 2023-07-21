/obj/item/clothing/mask/breath
	name = "дыхательная маска"
	desc = "Плотно прилегающая маска, которая может быть подключена к источнику воздуха."
	icon_state = "breath"
	inhand_icon_state = "m_mask"
	body_parts_covered = 0
	clothing_flags = MASKINTERNALS
	visor_flags = MASKINTERNALS
	w_class = WEIGHT_CLASS_SMALL
	gas_transfer_coefficient = 0.1
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 50, FIRE = 0, ACID = 0)
	actions_types = list(/datum/action/item_action/adjust)
	flags_cover = MASKCOVERSMOUTH
	visor_flags_cover = MASKCOVERSMOUTH
	resistance_flags = NONE

/obj/item/clothing/mask/breath/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] затягивает трубки [src.name] вокруг [user.ru_ego()] шеи! Похоже, что [user.p_theyre()] пытается убить себя!"))
	return OXYLOSS

/obj/item/clothing/mask/breath/attack_self(mob/user)
	adjustmask(user)

/obj/item/clothing/mask/breath/AltClick(mob/user)
	..()
	if(!user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE, !iscyborg(user)))
		adjustmask(user)

/obj/item/clothing/mask/breath/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>ПКМ [src.name] для настройки.</span>"

/obj/item/clothing/mask/breath/medical
	desc = "Обтягивающая стерильная маска, которая может быть подключена к источнику воздуха."
	name = "медицинская дыхательная маска"
	icon_state = "medical"
	inhand_icon_state = "m_mask"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 100, FIRE = 0, ACID = 0)
	equip_delay_other = 10

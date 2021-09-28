//Переноска для Медботов

#define ismedbot(A) (istype(A, /mob/living/simple_animal/bot/medbot))

/obj/item/medbot_carrier
	name = "Переноска для медботов"
	desc = "Набор специальных ремней для комфортной транспортировки медицинских ботов на спине. Крепления подходят к медицинской верхней одежде. При экипированном медботе невозможно убрать в сумку. Медбот не может лечить пока сидит в переноске."
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BACK
	icon = 'white/Feline/icons/medbot_carrier.dmi'
	icon_state = "medbot_carrier_empty"
	worn_icon = 'white/Feline/icons/medbot_carrier_back.dmi'
	worn_icon_state = "carrier_empty"

/obj/item/medbot_carrier/attack(mob/living/M, mob/user, params)
	var/mob/living/simple_animal/bot/medbot/bot = M
	if(length(contents))
		to_chat(user, span_warning("Переноска уже занята."))
		return
	if(!ismedbot(M))
		to_chat(user, span_warning("В переноску можно поместить только медицинских ботов!"))
		return
	to_chat(user, span_notice("Помещаю [M] в переноску, он довольно виляет лапками."))
	store(M)
	if(bot.damagetype_healer == "all")
		icon_state = "medbot_carrier_all"
	if(bot.damagetype_healer == "brute")
		icon_state = "medbot_carrier_brute"
	if(bot.damagetype_healer == "burn")
		icon_state = "medbot_carrier_burn"
	if(bot.damagetype_healer == "toxin")
		icon_state = "medbot_carrier_toxin"
	if(bot.damagetype_healer == "oxygen")
		icon_state = "medbot_carrier_oxygen"
	w_class = WEIGHT_CLASS_BULKY
	worn_icon_state = "carrier_full"

/obj/item/medbot_carrier/attack_self(mob/user)
	if(contents.len)
		to_chat(user, span_notice("Выпускаю медбота на пол"))
		release()
		icon_state = "medbot_carrier_empty"
		w_class = WEIGHT_CLASS_NORMAL
		worn_icon_state = "carrier_empty"
	else
		to_chat(user, span_warning("В переноске ничего нет..."))

/obj/item/medbot_carrier/proc/store(mob/living/M)
	M.forceMove(src)

/obj/item/medbot_carrier/proc/release()
	for(var/atom/movable/M in contents)
		M.forceMove(get_turf(loc))

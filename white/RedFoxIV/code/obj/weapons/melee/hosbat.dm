/obj/item/melee/baseball_bat/hos
	name = "ассбольная бита"
	desc = "Рукоятка обтянута кожей ассистентов. Элегантно и практично."
	icon = 'white/RedFoxIV/icons/obj/weapons/melee/hosbat/hosbat.dmi'
	slot_flags = ITEM_SLOT_BELT
	icon_state = "falloutbat"
	lefthand_file = 'white/RedFoxIV/icons/obj/weapons/melee/hosbat/hosbat_lefthand.dmi'
	righthand_file = 'white/RedFoxIV/icons/obj/weapons/melee/hosbat/hosbat_righthand.dmi'
	force = 25
	worn_icon_state = "katana" //временное решение, пока я не найду силы заспрайтить в себе ещё 9 бит блять
	unique_reskin = list("Ассбольная бита" = "falloutbat",
						"Световая бита" = "laserbat",
						"\"Поддай леща\"" = "holymackerel",
						"Кирпич" = "brick",
						"Дорожный знак" = "stopsign",
						"Костяная бита" = "bonebat",
						"AK-47" = "74ka",
						"Молот" = "hammer"
						)
	custom_materials = list(/datum/material/iron = MINERAL_MATERIAL_AMOUNT * 3.5)


/obj/item/melee/baseball_bat/hos/reskin_obj(mob/M)
	if (M.ckey == "sranklin") // хрюкни
		unique_reskin = list("Ассбольная бита" = "falloutbat",
						"Световая бита" = "laserbat",
						"\"Поддай леща\"" = "holymackerel",
						"Кирпич" = "brick",
						"Дорожный знак" = "stopsign",
						"Костяная бита" = "bonebat",
						"AK-47" = "74ka",
						"Молот" = "hammer",
						"Сранклин" = "hrukni"
						)
	. = ..()
	inhand_icon_state = icon_state
	unique_reskin = initial(unique_reskin)
	switch(icon_state)
		if("laserbat")
			name = "световая бита"
			desc = "<span class='danger'>Бита элитного бойца</span><font color = 'gray'><br>Вас переполняет сила!<br>Разнесите врагов на мелкие кусочки!"
			hitsound = 'sound/weapons/blade1.ogg'

		if("holymackerel")
			name = "\"Поддай леща\""
			desc = "Убийство рыбой - самое унизительное наказание для вашего врага."
			hitsound = 'white/RedFoxIV/sounds/weapons/holy_mackerel.ogg'

		if("brick")
			name = "кирпич"
			desc = "Необычайно тяжёлый кирпич. Удобно сидит в вашей руке."

		if("stopsign")
			name = "дорожный знак" 
			desc = "Где ты его вообще достал? В космосе ведь нет дорог."

		if("bonebat")
			name = "костяная бита"
			desc = "Не имеет никакого отношения к Костяну. Сделана из костей ассистентов."

		if("74ka")
			name = "AK-47"
			desc = "Отрывает лицо с очереди. Использует противотанковый калибр 7.62."

		if("hammer")
			name = "молот"
			desc = "То же самое, что и обычный молоток, только в два раза больше (и в два раза больнее!)"

		if("hrukni")
			name = "сранклин"
			desc = "Хрюкни."
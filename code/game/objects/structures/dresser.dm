/obj/structure/dresser
	name = "шкафчик"
	desc = "Красивый деревянный шкаф с одеждой."
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "dresser"
	density = TRUE
	anchored = TRUE

/obj/structure/dresser/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_WRENCH)
		to_chat(user, span_notice("Начинаю [anchored ? "откручивать" : "прикручивать"] [src.name]."))
		if(I.use_tool(src, user, 20, volume=50))
			to_chat(user, span_notice("Успешно [anchored ? "откручиваю" : "прикручиваю"] [src.name]."))
			set_anchored(!anchored)
	else
		return ..()

/obj/structure/dresser/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new /obj/item/stack/sheet/mineral/wood(drop_location(), 10)
	qdel(src)

/obj/structure/dresser/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(!Adjacent(user))//no tele-grooming
		return
	if(ishuman(user))
		var/mob/living/carbon/human/H = user

		if(H.dna && H.dna.species && (NO_UNDERWEAR in H.dna.species.species_traits))
			to_chat(user, span_warning("Да мне и носить это негде."))
			return

		var/choice = tgui_input_list(user, "Нижнее белье, рубаха, или носочки?", "Changing", list("Нижнее бельё","Цвет нижнего белья","Рубаха","Носочки"))

		if(!Adjacent(user))
			return
		switch(choice)
			if("Нижнее бельё")
				var/new_undies = tgui_input_list(user, "Выбираем нижнее бельё", "Смена белья", GLOB.underwear_list)
				if(new_undies)
					H.underwear = new_undies
			if("Цвет нижнего белья")
				var/new_underwear_color = input(H, "Выбираем цвет нижнего белья", "Цвет нижнего белья","#"+H.underwear_color) as color|null
				if(new_underwear_color)
					H.underwear_color = sanitize_hexcolor(new_underwear_color)
			if("Рубаха")
				var/new_undershirt = tgui_input_list(user, "Выбираем рубаху", "Смена белья", GLOB.undershirt_list)
				if(new_undershirt)
					H.undershirt = new_undershirt
			if("Носочки")
				var/new_socks = tgui_input_list(user, "Выбираем носочки", "Смена белья", GLOB.socks_list)
				if(new_socks)
					H.socks= new_socks

		add_fingerprint(H)
		H.update_body()

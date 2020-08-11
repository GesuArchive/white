/obj/structure/dresser
	name = "шкафчик"
	desc = "Красивый деревянный шкаф с одеждой."
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "dresser"
	density = TRUE
	anchored = TRUE

/obj/structure/dresser/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_WRENCH)
		to_chat(user, "<span class='notice'>Начинаю [anchored ? "откручивать" : "прикручивать"] [src.name].</span>")
		if(I.use_tool(src, user, 20, volume=50))
			to_chat(user, "<span class='notice'>Успешно [anchored ? "откручиваю" : "прикручиваю"] [src.name].</span>")
			set_anchored(!anchored)
	else
		return ..()

/obj/structure/dresser/deconstruct(disassembled = TRUE)
	new /obj/item/stack/sheet/mineral/wood(drop_location()[1], 10)
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
			to_chat(user, "<span class='warning'>Да мне и носить это негде.</span>")
			return

		var/choice = input(user, "Нижнее белье, рубаха, или носочки?", "Changing") as null|anything in list("Нижнее бельё","Цвет нижнего белья","Рубаха","Носочки")

		if(!Adjacent(user))
			return
		switch(choice)
			if("Нижнее бельё")
				var/new_undies = input(user, "Выбираем нижнее бельё", "Смена белья")  as null|anything in GLOB.underwear_list
				if(new_undies)
					H.underwear = new_undies
			if("Цвет нижнего белья")
				var/new_underwear_color = input(H, "Выбираем цвет нижнего белья", "Цвет нижнего белья","#"+H.underwear_color) as color|null
				if(new_underwear_color)
					H.underwear_color = sanitize_hexcolor(new_underwear_color)
			if("Рубаха")
				var/new_undershirt = input(user, "Выбираем рубаху", "Смена белья") as null|anything in GLOB.undershirt_list
				if(new_undershirt)
					H.undershirt = new_undershirt
			if("Носочки")
				var/new_socks = input(user, "Выбираем носочки", "Смена белья") as null|anything in GLOB.socks_list
				if(new_socks)
					H.socks= new_socks

		add_fingerprint(H)
		H.update_body()

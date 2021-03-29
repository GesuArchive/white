/obj/structure/sign/decksign
	name = "дисплей"
	desc = "Покажет какой здесь этаж. Да?"
	icon = 'white/valtos/icons/decksign.dmi'
	icon_state = "sign"
	light_color = LIGHT_COLOR_ORANGE
	var/cur_deck = 0

/obj/structure/sign/decksign/Initialize()
	. = ..()
	add_overlay("deck-[cur_deck]")

/obj/structure/sign/decksign/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_MULTITOOL)
		if(icon_state = "sign")
			icon_state = "sign-off"
			set_light(0)
			cut_overlays()
			playsound(get_turf(src), I.usesound, 60)
		else
			var/in = input(user, "Какой этаж это тогда?", "Ммм?", "0") as num|null
			if(!in)
				return
			cur_deck = in
			icon_state = "sign"
			set_light(1)
			add_overlay("deck-[cur_deck]")
			playsound(get_turf(src), I.usesound, 60)

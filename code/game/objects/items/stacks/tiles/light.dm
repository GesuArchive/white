/obj/item/stack/tile/light
	name = "световая плитка"
	singular_name = "световая напольная плитка"
	desc = "Плитка для пола сделанная из стекла. Она излучает свет."
	icon_state = "tile_e"
	flags_1 = CONDUCT_1
	attack_verb_continuous = list("лупит", "бьёт", "разбивает", "вмазывает", "атакует")
	attack_verb_simple = list("лупит", "бьёт", "разбивает", "вмазывает", "атакует")
	turf_type = /turf/open/floor/light
	merge_type = /obj/item/stack/tile/light
	var/state = 0

/obj/item/stack/tile/light/attackby(obj/item/O, mob/user, params)
	if(O.tool_behaviour == TOOL_CROWBAR)
		new/obj/item/stack/sheet/iron(user.loc)
		amount--
		new/obj/item/stack/light_w(user.loc)
		if(amount <= 0)
			qdel(src)
	else
		return ..()

/obj/item/stack/tile/light/place_tile(turf/open/T)
	. = ..()
	var/turf/open/floor/light/F = .
	F?.state = state

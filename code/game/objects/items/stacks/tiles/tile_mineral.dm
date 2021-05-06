/obj/item/stack/tile/mineral/plasma
	name = "плазменная плитка"
	singular_name = "плазменная напольная плитка"
	desc = "Плитка сделанная из легковоспламеняющейся плащмы. Что может пойти не так?"
	icon_state = "tile_plasma"
	inhand_icon_state = "tile-plasma"
	turf_type = /turf/open/floor/mineral/plasma
	mineralType = "plasma"
	mats_per_unit = list(/datum/material/plasma=500)
	merge_type = /obj/item/stack/tile/mineral/plasma

/obj/item/stack/tile/mineral/uranium
	name = "урановая плитка"
	singular_name = "урановая напольная плитка"
	desc = "Плитка сделанная из урана. Вы чувствуете небольшое головокружение."
	icon_state = "tile_uranium"
	inhand_icon_state = "tile-uranium"
	turf_type = /turf/open/floor/mineral/uranium
	mineralType = "uranium"
	mats_per_unit = list(/datum/material/uranium=500)
	merge_type = /obj/item/stack/tile/mineral/uranium

/obj/item/stack/tile/mineral/gold
	name = "золотая плитка"
	singular_name = "золотая напольная плитка"
	desc = "Плитка сделанная из золота, выглядит богато."
	icon_state = "tile_gold"
	inhand_icon_state = "tile-gold"
	turf_type = /turf/open/floor/mineral/gold
	mineralType = "gold"
	mats_per_unit = list(/datum/material/gold=500)
	merge_type = /obj/item/stack/tile/mineral/gold

/obj/item/stack/tile/mineral/silver
	name = "серебряная плитка"
	singular_name = "серебряная напольная плитка"
	desc = "Плитка из серебра, её сияние ослепляет."
	icon_state = "tile_silver"
	inhand_icon_state = "tile-silver"
	turf_type = /turf/open/floor/mineral/silver
	mineralType = "silver"
	mats_per_unit = list(/datum/material/silver=500)
	merge_type = /obj/item/stack/tile/mineral/silver

/obj/item/stack/tile/mineral/diamond
	name = "алмазная плитка"
	singular_name = "алмазная напольная плитка"
	desc = "Плитка из алмазов. Офигеть можно."
	icon_state = "tile_diamond"
	inhand_icon_state = "tile-diamond"
	turf_type = /turf/open/floor/mineral/diamond
	mineralType = "diamond"
	mats_per_unit = list(/datum/material/diamond=500)
	merge_type = /obj/item/stack/tile/mineral/diamond

/obj/item/stack/tile/mineral/bananium
	name = "бананиумная плитка"
	singular_name = "бананиумная напольная плитка"
	desc = "Плитка из бананиума, ХОООООООООООНК!"
	icon_state = "tile_bananium"
	inhand_icon_state = "tile-bananium"
	turf_type = /turf/open/floor/mineral/bananium
	mineralType = "bananium"
	mats_per_unit = list(/datum/material/bananium=500)
	merge_type = /obj/item/stack/tile/mineral/bananium

/obj/item/stack/tile/mineral/abductor
	name = "инопланетная напольная плитка"
	singular_name = "инопланетная напольная плитка"
	desc = "Плитка из инопланнетного сплава."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "tile_abductor"
	inhand_icon_state = "tile-abductor"
	mats_per_unit = list(/datum/material/alloy/alien=MINERAL_MATERIAL_AMOUNT*0.25)
	turf_type = /turf/open/floor/mineral/abductor
	mineralType = "abductor"
	merge_type = /obj/item/stack/tile/mineral/abductor

/obj/item/stack/tile/mineral/titanium
	name = "титановая плитка"
	singular_name = "титановая напольная плитка"
	desc = "Плитка из титана, используется в шатлах."
	icon_state = "tile_shuttle"
	inhand_icon_state = "tile-shuttle"
	turf_type = /turf/open/floor/mineral/titanium
	mineralType = "titanium"
	mats_per_unit = list(/datum/material/titanium=500)
	merge_type = /obj/item/stack/tile/mineral/titanium
	tile_reskin_types = list(
		/obj/item/stack/tile/mineral/titanium,
		/obj/item/stack/tile/mineral/titanium/yellow,
		/obj/item/stack/tile/mineral/titanium/blue,
		/obj/item/stack/tile/mineral/titanium/white,
		/obj/item/stack/tile/mineral/titanium/purple,
		/obj/item/stack/tile/mineral/titanium/tiled,
		/obj/item/stack/tile/mineral/titanium/tiled/yellow,
		/obj/item/stack/tile/mineral/titanium/tiled/blue,
		/obj/item/stack/tile/mineral/titanium/tiled/white,
		/obj/item/stack/tile/mineral/titanium/tiled/purple,
		)

/obj/item/stack/tile/mineral/titanium/yellow
	name = "желтая титановая плитка"
	singular_name = "yellow titanium floor tile"
	desc = "Гладкая желтая титановая плитка. Используйте её когда она находится у вас руке, чтобы изменить на тот тип титановой плитки, которую вы хотите."
	turf_type = /turf/open/floor/mineral/titanium/yellow
	icon_state = "tile_titanium_yellow"
	merge_type = /obj/item/stack/tile/mineral/titanium/yellow

/obj/item/stack/tile/mineral/titanium/blue
	name = "синяя титановая плитка"
	singular_name = "blue titanium floor tile"
	desc = "Гладкая желтая титановая плитка. Используйте её когда она находится у вас руке, чтобы изменить на тот тип титановой плитки, которую вы хотите."
	turf_type = /turf/open/floor/mineral/titanium/blue
	icon_state = "tile_titanium_blue"
	merge_type = /obj/item/stack/tile/mineral/titanium/blue

/obj/item/stack/tile/mineral/titanium/white
	name = "белая титановая плитка"
	singular_name = "white titanium floor tile"
	desc = "Гладкая желтая титановая плитка. Используйте её когда она находится у вас руке, чтобы изменить на тот тип титановой плитки, которую вы хотите."
	turf_type = /turf/open/floor/mineral/titanium/white
	icon_state = "tile_titanium_white"
	merge_type = /obj/item/stack/tile/mineral/titanium/white

/obj/item/stack/tile/mineral/titanium/purple
	name = "фиолетовая титановая плитка"
	singular_name = "purple titanium floor tile"
	desc = "Гладкая желтая титановая плитка. Используйте её когда она находится у вас руке, чтобы изменить на тот тип титановой плитки, которую вы хотите."
	turf_type = /turf/open/floor/mineral/titanium/purple
	icon_state = "tile_titanium_purple"
	merge_type = /obj/item/stack/tile/mineral/titanium/purple

/obj/item/stack/tile/mineral/titanium/tiled
	name = "кафельная титановая плитка"
	singular_name = "tiled titanium floor tile"
	desc = "Напольная плитка из титана. Используйте её когда она находится у вас руке, чтобы изменить на тот тип титановой плитки, которую вы хотите."
	turf_type = /turf/open/floor/mineral/titanium/tiled
	icon_state = "tile_titanium_tiled"
	merge_type = /obj/item/stack/tile/mineral/titanium/tiled

/obj/item/stack/tile/mineral/titanium/tiled/yellow
	name = "желтая титановая плитка"
	singular_name = "yellow titanium floor tile"
	desc = "Желтая титановая плитка. Используйте её когда она находится у вас руке, чтобы изменить на тот тип титановой плитки, которую вы хотите."
	turf_type = /turf/open/floor/mineral/titanium/tiled/yellow
	icon_state = "tile_titanium_tiled_yellow"
	merge_type = /obj/item/stack/tile/mineral/titanium/tiled/yellow

/obj/item/stack/tile/mineral/titanium/tiled/blue
	name = "синяя титановая плитка"
	singular_name = "blue titanium floor tile"
	desc = "Синяя титановая плитка. Используйте её когда она находится у вас руке, чтобы изменить на тот тип титановой плитки, которую вы хотите."
	turf_type = /turf/open/floor/mineral/titanium/tiled/blue
	icon_state = "tile_titanium_tiled_blue"
	merge_type = /obj/item/stack/tile/mineral/titanium/tiled/blue

/obj/item/stack/tile/mineral/titanium/tiled/white
	name = "белая титановая плитка"
	singular_name = "white titanium floor tile"
	desc = "Белая титановая плитка. Используйте её когда она находится у вас руке, чтобы изменить на тот тип титановой плитки, которую вы хотите."
	turf_type = /turf/open/floor/mineral/titanium/tiled/white
	icon_state = "tile_titanium_tiled_white"
	merge_type = /obj/item/stack/tile/mineral/titanium/tiled/white

/obj/item/stack/tile/mineral/titanium/tiled/purple
	name = "фиолетовая титановая плитка"
	singular_name = "purple titanium floor tile"
	desc = "Фиолетовая титановая плитка. Используйте её когда она находится у вас руке, чтобы изменить на тот тип титановой плитки, которую вы хотите."
	turf_type = /turf/open/floor/mineral/titanium/tiled/purple
	icon_state = "tile_titanium_tiled_purple"
	merge_type = /obj/item/stack/tile/mineral/titanium/tiled/purple

/obj/item/stack/tile/mineral/plastitanium
	name = "пластитановая плитка"
	singular_name = "пластитановая напольная плитка"
	desc = "Плитка из пластитана, используется в очень злобных шаттлах."
	icon_state = "tile_darkshuttle"
	inhand_icon_state = "tile-darkshuttle"
	turf_type = /turf/open/floor/mineral/plastitanium
	mineralType = "plastitanium"
	mats_per_unit = list(/datum/material/alloy/plastitanium=MINERAL_MATERIAL_AMOUNT*0.25)
	material_flags = MATERIAL_NO_EFFECTS
	merge_type = /obj/item/stack/tile/mineral/plastitanium

/obj/item/stack/tile/mineral/snow
	name = "снежная плитка"
	singular_name = "снежная плитка"
	desc = "Слой снега."
	icon_state = "tile_snow"
	inhand_icon_state = "tile-silver"
	turf_type = /turf/open/floor/grass/snow/safe
	mineralType = "snow"
	merge_type = /obj/item/stack/tile/mineral/snow

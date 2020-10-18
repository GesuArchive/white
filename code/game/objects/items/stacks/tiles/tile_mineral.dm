/obj/item/stack/tile/mineral/plasma
	name = "плазменная плитка"
	singular_name = "плазменная напольная плитка"
	desc = "Плитка сделанная из легковоспламеняющейся плащмы. Что может пойти не так?"
	icon_state = "tile_plasma"
	inhand_icon_state = "tile-plasma"
	turf_type = /turf/open/floor/mineral/plasma
	mineralType = "plasma"
	custom_materials = list(/datum/material/plasma=500)

/obj/item/stack/tile/mineral/uranium
	name = "урановая плитка"
	singular_name = "урановая напольная плитка"
	desc = "Плитка сделанная из урана. Вы чувствуете небольшое головокружение."
	icon_state = "tile_uranium"
	inhand_icon_state = "tile-uranium"
	turf_type = /turf/open/floor/mineral/uranium
	mineralType = "uranium"
	custom_materials = list(/datum/material/uranium=500)

/obj/item/stack/tile/mineral/gold
	name = "золотая плитка"
	singular_name = "золотая напольная плитка"
	desc = "Плитка сделанная из золота, выглядит богато."
	icon_state = "tile_gold"
	inhand_icon_state = "tile-gold"
	turf_type = /turf/open/floor/mineral/gold
	mineralType = "gold"
	custom_materials = list(/datum/material/gold=500)

/obj/item/stack/tile/mineral/silver
	name = "серебряная плитка"
	singular_name = "серебряная напольная плитка"
	desc = "Плитка из серебра, её сияние ослепляет."
	icon_state = "tile_silver"
	inhand_icon_state = "tile-silver"
	turf_type = /turf/open/floor/mineral/silver
	mineralType = "silver"
	custom_materials = list(/datum/material/silver=500)

/obj/item/stack/tile/mineral/diamond
	name = "алмазная плитка"
	singular_name = "алмазная напольная плитка"
	desc = "Плитка из алмазов. Офигеть можно."
	icon_state = "tile_diamond"
	inhand_icon_state = "tile-diamond"
	turf_type = /turf/open/floor/mineral/diamond
	mineralType = "diamond"
	custom_materials = list(/datum/material/diamond=500)

/obj/item/stack/tile/mineral/bananium
	name = "бананиумная плитка"
	singular_name = "бананиумная напольная плитка"
	desc = "Плитка из бананиума, ХОООООООООООНК!"
	icon_state = "tile_bananium"
	inhand_icon_state = "tile-bananium"
	turf_type = /turf/open/floor/mineral/bananium
	mineralType = "bananium"
	custom_materials = list(/datum/material/bananium=500)

/obj/item/stack/tile/mineral/abductor
	name = "инопланетная напольная плитка"
	singular_name = "инопланетная напольная плитка"
	desc = "Плитка из инопланнетного сплава."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "tile_abductor"
	inhand_icon_state = "tile-abductor"
	turf_type = /turf/open/floor/mineral/abductor
	mineralType = "abductor"

/obj/item/stack/tile/mineral/titanium
	name = "титановая плитка"
	singular_name = "титановая напольная плитка"
	desc = "Плитка из титана, используется в шатлах."
	icon_state = "tile_shuttle"
	inhand_icon_state = "tile-shuttle"
	turf_type = /turf/open/floor/mineral/titanium
	mineralType = "titanium"
	custom_materials = list(/datum/material/titanium=500)

/obj/item/stack/tile/mineral/plastitanium
	name = "пластитановая плитка"
	singular_name = "пластитановая напольная плитка"
	desc = "Плитка из пластитана, используется в очень злобных шаттлах."
	icon_state = "tile_darkshuttle"
	inhand_icon_state = "tile-darkshuttle"
	turf_type = /turf/open/floor/mineral/plastitanium
	mineralType = "plastitanium"
	custom_materials = list(/datum/material/titanium=250, /datum/material/plasma=250)
	material_flags = MATERIAL_NO_EFFECTS

/obj/item/stack/tile/mineral/snow
	name = "снежная плитка"
	singular_name = "снежная плитка"
	desc = "Слой снега."
	icon_state = "tile_snow"
	inhand_icon_state = "tile-silver"
	turf_type = /turf/open/floor/grass/snow/safe
	mineralType = "snow"

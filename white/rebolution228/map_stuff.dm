/* Objects */

//Flora
/obj/structure/flora/cataclysmdda/decoration
	name = "кустик"
	desc = null
	icon = null
	icon_state = "plant"

/obj/structure/flora/cataclysmdda/decoration/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(I.sharpness == SHARP_EDGED)
		new /obj/item/stack/sheet/cloth(get_turf(src))
		user.visible_message(span_notice("<b>[user]</b> нарезает <b>[src]</b> на нитки и быстро сплетает из него куски ткани при помощи <b>[I]</b>.") , \
			span_notice("Нарезаю <b>[src]</b> на нитки и быстро сплетаю из него куски ткани при помощи <b>[I]</b>.") , \
			span_hear("Слышу как что-то режет ткань."))
		qdel(src)

//Trees

/obj/structure/flora/tree/cataclysmdda
	name = "КОДЕР"
	desc = "МУДАК"
	icon = 'icons/obj/flora/cata_trees.dmi'
	pixel_x = -16
	density = TRUE
	icon_state = "els1"
	base_icon_state = "els"
	// living variations
	var/lv = 1
	// dead variations
	var/dv = 1
	// productive variations
	var/pv = 0

/obj/structure/flora/tree/cataclysmdda/Initialize(mapload)
	if(dv && prob(5))
		icon_state = "[base_icon_state]d[rand(1, dv)]"
	else if (pv && prob(1))
		icon_state = "[base_icon_state]p[rand(1, pv)]"
	else
		icon_state = "[base_icon_state][rand(1, lv)]"
	. = ..()

/obj/structure/flora/tree/cataclysmdda/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(!. && istype(mover, /obj/projectile))
		return prob(30)

/obj/structure/flora/tree/cataclysmdda/iva
	name = "ива"
	desc = "Род древесных растений семейства Ивовые (Salicaceae). В русском языке по отношению к видам ивы используется также много других названий — ветла́, раки́та, лоза́, лози́на, ве́рба́, тальник."
	icon_state = "iva1"
	base_icon_state = "iva"
	lv = 8
	dv = 0

/obj/structure/flora/tree/cataclysmdda/cash
	name = "каштан"
	desc = "Небольшой род деревьев семейства Буковые (Fagaceae). Каштан — дерево тёплого умеренного климата. Произрастает по склонам гор, как правило, на затенённых склонах с бурыми средневлажными почвами, залегающими на безызвестковых горных породах; сухих и заболоченных почв не переносит."
	icon_state = "cash1"
	base_icon_state = "cash"
	lv = 19
	dv = 2
	pv = 6

/obj/structure/flora/tree/cataclysmdda/yabl
	name = "яблоня"
	desc = "Род листопадных деревьев и кустарников семейства Розовые (Rosaceae) с шаровидными сладкими или кисло-сладкими плодами. Происходит из зон умеренного климата Северного полушария."
	icon_state = "yabl1"
	base_icon_state = "yabl"
	lv = 25
	dv = 2
	pv = 8

/obj/structure/flora/tree/cataclysmdda/topol
	name = "тополь"
	desc = "Род двудомных (редко однодомных) листопадных быстрорастущих деревьев семейства Ивовые (Salicaceae). Лес с преобладанием тополей называют тополёвником."
	icon_state = "topol1"
	base_icon_state = "topol"
	lv = 21
	dv = 4
	pv = 3

/obj/structure/flora/tree/cataclysmdda/el
	name = "ель"
	desc = "Род хвойных вечнозелёных деревьев семейства Сосновые (Pinaceae). Вечнозелёные деревья. Корневая система первые 10—15 лет стержневая, затем поверхностная (главный корень отмирает). Дерево слабо ветроустойчиво, часто ветровально."
	icon_state = "el1"
	base_icon_state = "el"
	lv = 10
	dv = 1

/obj/structure/flora/tree/cataclysmdda/el/small
	name = "маленькая ель"
	icon_state = "els1"
	base_icon_state = "els"

/obj/structure/flora/tree/cataclysmdda/oreh
	name = "орех"
	desc = "Род растений семейства Ореховые (Juglandaceae), включающий в себя более 20 видов, произрастающих в теплоумеренных районах Евразии, Северной Америки и в горах Южной Америки."
	icon_state = "oreh1"
	base_icon_state = "oreh"
	lv = 8
	dv = 2
	pv = 3

/obj/structure/flora/tree/cataclysmdda/kedr
	name = "кедр"
	desc = "Олиготипный род деревьев семейства Сосновые (Pinaceae). Представители рода однодомные, вечнозелёные деревья высотой до 40—50 метров, с раскидистой кроной. Кора тёмно-серая, на молодых стволах гладкая, на старых растрескивающаяся, чешуйчатая. Побеги укороченные и удлинённые, последние несут спирально расположенную хвою."
	icon_state = "kedr1"
	base_icon_state = "kedr"
	lv = 4
	dv = 3

/obj/structure/flora/tree/cataclysmdda/sosna
	name = "сосна"
	desc = "Типовой род хвойных деревьев, кустарников или стлаников семейства Сосновые (Pinaceae). Одна из двух версий производит латинское название дерева от кельтского слова pin, что означает скала, гора, то есть растущее на скалах, другая — от латинских слов pix, picis, что означает смола, то есть смолистое дерево."
	icon_state = "sosna1"
	base_icon_state = "sosna"
	lv = 3
	dv = 3

/obj/structure/flora/tree/cataclysmdda/dub
	name = "дуб"
	desc = "Род деревьев и кустарников семейства Буковые (Fagaceae). Род объединяет около 600 видов. Естественным ареалом дуба являются регионы Северного полушария с умеренным климатом. Южной границей распространения являются тропические высокогорья; несколько видов встречаются и южнее экватора."
	icon_state = "dub1"
	base_icon_state = "dub"
	lv = 9
	dv = 11 // suka

/obj/structure/flora/tree/cataclysmdda/ht
	name = "дерево"
	desc = "Данное дерево ничем не примечательно."
	icon_state = "ht1"
	base_icon_state = "ht"
	lv = 7
	dv = 7

/obj/structure/flora/tree/cataclysmdda/mt
	name = "большое дерево"
	desc = "Данное дерево ничем не примечательно. Это выглядит больше."
	icon_state = "mt1"
	base_icon_state = "mt"
	lv = 3
	dv = 3


/turf/open/floor/engine/hull/shipceiling
	name = "обшивка шаттла"
	var/old_turf_type

/turf/open/floor/engine/hull/shipceiling/AfterChange(flags, oldType)
	. = ..()
	old_turf_type = oldType

/obj/effect/turf_decal/weather/side // запилите сами мне похуй
	name = "side"
	icon_state = "side"
	mouse_opacity = 0

/obj/effect/turf_decal/weather/side/corner
	icon_state = "sidecorn"

/obj/effect/turf_decal/dust
	name = "dust"
	mouse_opacity = 0

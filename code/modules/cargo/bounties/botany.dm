/datum/bounty/item/botany
	reward = CARGO_CRATE_VALUE * 10
	var/datum/bounty/item/botany/multiplier = 0 //adds bonus reward money; increased for higher tier or rare mutations
	var/datum/bounty/item/botany/bonus_desc //for adding extra flavor text to bounty descriptions
	var/datum/bounty/item/botany/foodtype = "еду" //same here

/datum/bounty/item/botany/New()
	..()
	description = "Шеф-повар ЦК хочет приготовить [foodtype] из [name]. [bonus_desc]»"
	reward += multiplier * (CARGO_CRATE_VALUE * 2)
	required_count = rand(5, 10)

/datum/bounty/item/botany/ambrosia_vulgaris
	name = "листьев Амброзии Вулгарис"
	wanted_types = list(/obj/item/food/grown/ambrosia/vulgaris)
	foodtype = "вкусное рагу"

/datum/bounty/item/botany/ambrosia_gaia
	name = "листьев Амброзии Гайи"
	wanted_types = list(/obj/item/food/grown/ambrosia/gaia)
	multiplier = 4
	foodtype = "вкусное рагу"

/datum/bounty/item/botany/apple_golden
	name = "золотых яблок"
	wanted_types = list(/obj/item/food/grown/apple/gold)
	multiplier = 4
	foodtype = "вкусный дессерт"

/datum/bounty/item/botany/banana
	name = "бананов"
	wanted_types = list(/obj/item/food/grown/banana)
	exclude_types = list(/obj/item/food/grown/banana/bluespace)
	foodtype = "вкусный банановый сплит"

/datum/bounty/item/botany/banana_bluespace
	name = "блюспейс бананов"
	wanted_types = list(/obj/item/food/grown/banana/bluespace)
	multiplier = 2
	foodtype = "вкусный банановый сплит."

/datum/bounty/item/botany/beans_koi
	name = "бобов кои"
	wanted_types = list(/obj/item/food/grown/koibeans)
	multiplier = 2

/datum/bounty/item/botany/berries_death
	name = "ягод смерти"
	wanted_types = list(/obj/item/food/grown/berries/death)
	multiplier = 2
	bonus_desc = "Он утверждает \"что он знает что он делает\"."
	foodtype = "вкусный сорбет"

/datum/bounty/item/botany/berries_glow
	name = "свето-ягод"
	wanted_types = list(/obj/item/food/grown/berries/glow)
	multiplier = 2
	foodtype = "вкусный сорбет"

/datum/bounty/item/botany/cannabis
	name = "листьев каннабиса"
	wanted_types = list(/obj/item/food/grown/cannabis)
	exclude_types = list(/obj/item/food/grown/cannabis/white, /obj/item/food/grown/cannabis/death, /obj/item/food/grown/cannabis/ultimate)
	multiplier = 4 //hush money
	bonus_desc = "Не говорите СБ про эту доставку."
	foodtype = "вкусную партию \"маффинов\""

/datum/bounty/item/botany/cannabis_white
	name = "листьев растения жизни"
	wanted_types = list(/obj/item/food/grown/cannabis/white)
	multiplier = 6
	bonus_desc = "Не говорите СБ про эту доставку."
	foodtype = "вкусную \"еду\""

/datum/bounty/item/botany/cannabis_death
	name = "листьев растения смерти"
	wanted_types = list(/obj/item/food/grown/cannabis/death)
	multiplier = 6
	bonus_desc = "Не говорите СБ про эту доставку."
	foodtype = "вкусную \"еду\""

/datum/bounty/item/botany/cannabis_ultimate
	name = "листьев омега растения"
	wanted_types = list(/obj/item/food/grown/cannabis/ultimate)
	multiplier = 6
	bonus_desc = "Ни при каких обстоятельствах не упоминайте эту отправку СБ."
	foodtype = "вкусную партию \"кексов\""

/datum/bounty/item/botany/wheat
	name = "зерна пшеницы"
	wanted_types = list(/obj/item/food/grown/wheat)

/datum/bounty/item/botany/rice
	name = "зерна риса"
	wanted_types = list(/obj/item/food/grown/rice)

/datum/bounty/item/botany/chili
	name = "перца чили"
	wanted_types = list(/obj/item/food/grown/chili)

/datum/bounty/item/botany/ice_chili
	name = "морозного перца чили"
	wanted_types = list(/obj/item/food/grown/icepepper)
	multiplier = 2

/datum/bounty/item/botany/ghost_chili
	name = "призрачного перца чили"
	wanted_types = list(/obj/item/food/grown/ghost_chili)
	multiplier = 2

/datum/bounty/item/botany/citrus_lime
	name = "лайма"
	wanted_types = list(/obj/item/food/grown/citrus/lime)
	foodtype = "вкусный сорбет"

/datum/bounty/item/botany/citrus_lemon
	name = "лемона"
	wanted_types = list(/obj/item/food/grown/citrus/lemon)
	foodtype = "вкусный сорбет"

/datum/bounty/item/botany/citrus_oranges
	name = "апельсина"
	wanted_types = list(/obj/item/food/grown/citrus/orange)
	bonus_desc = "Не отправлять лемоны и лаймы." //I vanted orahnge!
	foodtype = "вкусный сорбет"

/datum/bounty/item/botany/eggplant
	name = "баклажана"
	wanted_types = list(/obj/item/food/grown/eggplant)
	bonus_desc = "Не путать с egg-plants."

/datum/bounty/item/botany/eggplant_eggy
	name = "растения-яйцо"
	wanted_types = list(/obj/item/food/grown/shell/eggy)
	bonus_desc = "Не путать с eggplants."
	multiplier = 2

/datum/bounty/item/botany/kudzu
	name = "стручков кудзу"
	wanted_types = list(/obj/item/food/grown/kudzupod)
	bonus_desc = "Хранить в сухом темном месте.."
	multiplier = 4

/datum/bounty/item/botany/watermelon
	name = "арбуза"
	wanted_types = list(/obj/item/food/grown/watermelon)
	foodtype = "вкусный дессерт"

/datum/bounty/item/botany/watermelon_holy
	name = "святого арбуза"
	wanted_types = list(/obj/item/food/grown/holymelon)
	multiplier = 2
	foodtype = "вкусный дессерт"

/datum/bounty/item/botany/glowshroom
	name = "светящегося гриба"
	wanted_types = list(/obj/item/food/grown/mushroom/glowshroom)
	exclude_types = list(/obj/item/food/grown/mushroom/glowshroom/glowcap, /obj/item/food/grown/mushroom/glowshroom/shadowshroom)
	foodtype = "вкусный омлет"

/datum/bounty/item/botany/glowshroom_cap
	name = "светящейся шапки" // надо что-то оригинальней
	wanted_types = list(/obj/item/food/grown/mushroom/glowshroom/glowcap)
	multiplier = 2
	foodtype = "вкусный омлет"

/datum/bounty/item/botany/glowshroom_shadow
	name = "теневого гриба"
	wanted_types = list(/obj/item/food/grown/mushroom/glowshroom/shadowshroom)
	multiplier = 2
	foodtype = "вкусный омлет"

/datum/bounty/item/botany/nettles_death
	name = "крапивы смерти"
	wanted_types = list(/obj/item/food/grown/nettle/death)
	multiplier = 2
	bonus_desc = "Носите защиту при обращении с ними."
	foodtype = "вкусный сыр"

/datum/bounty/item/botany/pineapples
	name = "ананаса"
	wanted_types = list(/obj/item/food/grown/pineapple)
	bonus_desc = "Не для потребления человеком."
	foodtype = "ashtray"

/datum/bounty/item/botany/tomato
	name = "помидора"
	wanted_types = list(/obj/item/food/grown/tomato)
	exclude_types = list(/obj/item/food/grown/tomato/blue)

/datum/bounty/item/botany/tomato_bluespace
	name = "блюспейс помидора"
	wanted_types = list(/obj/item/food/grown/tomato/blue/bluespace)
	multiplier = 4

/datum/bounty/item/botany/oatz
	name = "овса"
	wanted_types = list(/obj/item/food/grown/oat)
	multiplier = 2
	foodtype = "партия овсянки"
//	bonus_desc = "Squats and oats. We're all out of oats."

/*
/datum/bounty/item/botany/bonfire
	name = "зажженный костер"
	description = "Обогреватели помещений неисправны, и экипаж Центрального Командования начинает мерзнуть. Вырастите дерево и сделайте зажженный костер, чтобы согреть их."
	wanted_types = list(/obj/structure/bonfire)

/datum/bounty/item/botany/bonfire/applies_to(obj/O)
	if(!..())
		return FALSE
	var/obj/structure/bonfire/B = O
	return !!B.burning
*/

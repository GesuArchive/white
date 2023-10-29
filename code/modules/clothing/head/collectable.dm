
//Hat Station 13

/obj/item/clothing/head/collectable
	name = "коллекционная шляпа"
	desc = "Редкая коллекционная шляпа."
	icon_state = null

/obj/item/clothing/head/collectable/petehat
	name = "супер редкая шляпа Пита!"
	desc = "Пахнет плазмой."
	icon_state = "petehat"

/obj/item/clothing/head/collectable/xenom
	name = "коллекционный шлем ксеноморфа!"
	desc = "Хисс хисс хисс!"
	clothing_flags = SNUG_FIT
	icon_state = "xenom"

/obj/item/clothing/head/collectable/chef
	name = "коллекционная шапочка шэф-повара"
	desc = "Редкий поварской колпак, предназначенный для коллекционеров колпаков!"
	icon_state = "chef"
	inhand_icon_state = "chef"
	dynamic_hair_suffix = ""

	dog_fashion = /datum/dog_fashion/head/chef

/obj/item/clothing/head/collectable/paper
	name = "коллекционная бумажная шляпа"
	desc = "То, что выглядит как обычная бумажная шапка, на самом деле является редкой и ценной коллекционной бумажной шапкой. Держитесь подальше от воды, огня и кураторов."
	icon_state = "paper"

	dog_fashion = /datum/dog_fashion/head

/obj/item/clothing/head/collectable/tophat
	name = "коллекционная топ-шляпа"
	desc = "Верхнюю шляпу носят только самые престижные коллекционеры шляп."
	icon_state = "tophat"
	inhand_icon_state = "that"

/obj/item/clothing/head/collectable/captain
	name = "коллекционная капитанская шляпа"
	desc = "Коллекционная шляпа, которая заставит вас выглядеть как настоящий комдом!"
	icon_state = "captain"
	inhand_icon_state = "caphat"

	dog_fashion = /datum/dog_fashion/head/captain

/obj/item/clothing/head/collectable/police
	name = "коллекционная шляпа офицера полиции"
	desc = "Коллекционная полицейская шляпа. Эта шляпа подчеркивает, что ты - ЗАКОН."
	icon_state = "policehelm"
	dynamic_hair_suffix = ""

	dog_fashion = /datum/dog_fashion/head/warden

/obj/item/clothing/head/collectable/beret
	name = "коллекционный берет"
	desc = "Коллекционный красный берет. Пахнет чуть-чуть чесноком."
	icon_state = "beret"
	greyscale_config = /datum/greyscale_config/beret
	greyscale_config_worn = /datum/greyscale_config/beret/worn
	greyscale_colors = "#972A2A"

	dog_fashion = /datum/dog_fashion/head/beret

/obj/item/clothing/head/collectable/welding
	name = "коллекционный сварочный шлем"
	desc = "Коллекционный сварочный шлем. Теперь на 80% меньше свинца! Не для реальной сварки. Любая сварка, выполняемая во время ношения шлема, выполняется на собственный страх и риск владельца!"
	icon_state = "welding"
	inhand_icon_state = "welding"
	clothing_flags = SNUG_FIT

/obj/item/clothing/head/collectable/slime
	name = "коллекционный слаймовый шлем"
	desc = "Прямо как настоящая мозговая пуля!"
	icon_state = "headslime"
	inhand_icon_state = "headslime"
	clothing_flags = SNUG_FIT
	dynamic_hair_suffix = ""

/obj/item/clothing/head/collectable/flatcap
	name = "коллекционный кепарик"
	desc = "Коллекционная колпачок крестьянина!"
	icon_state = "beret_flat"
	greyscale_config = /datum/greyscale_config/beret
	greyscale_config_worn = /datum/greyscale_config/beret/worn
	greyscale_colors = "#8F7654"
	inhand_icon_state = "detective"

/obj/item/clothing/head/collectable/pirate
	name = "коллекционная пиратская шляпа"
	desc = "Из меня получился бы отличный Дредовый Синди Робертс!"
	icon_state = "pirate"
	inhand_icon_state = "pirate"

	dog_fashion = /datum/dog_fashion/head/pirate

/obj/item/clothing/head/collectable/kitty
	name = "коллекционные котоушки"
	desc = "Мех кажется... слишком реалистичным."
	icon_state = "kitty"
	inhand_icon_state = "kitty"
	dynamic_hair_suffix = ""

	dog_fashion = /datum/dog_fashion/head/kitty

/obj/item/clothing/head/collectable/rabbitears
	name = "коллекционные кроличьи ушки"
	desc = "Не так повезло, как ногам!"
	icon_state = "bunny"
	inhand_icon_state = "bunny"
	dynamic_hair_suffix = ""

	dog_fashion = /datum/dog_fashion/head/rabbit

/obj/item/clothing/head/collectable/wizard
	name = "коллекционная шляпа волшебника"
	desc = "ПРИМЕЧАНИЕ: Любая магическая сила, полученная от ношения этой шляпы, совершенно случайна."
	icon_state = "wizard"

	dog_fashion = /datum/dog_fashion/head/blue_wizard

/obj/item/clothing/head/collectable/hardhat
	name = "коллекционная каска"
	desc = "ВНИМАНИЕ! Не предлагает никакой реальной защиты, или яркости, но черт возьми, это так причудливо!"
	clothing_flags = SNUG_FIT
	icon_state = "hardhat0_yellow"
	inhand_icon_state = "hardhat0_yellow"

	dog_fashion = /datum/dog_fashion/head

/obj/item/clothing/head/collectable/hos
	name = "коллекционная шляпа главы безопасности"
	desc = "Теперь вы тоже можете бить заключенных, выносить глупые приговоры и арестовывать без всякой причины!"
	icon_state = "hoscap"
	dynamic_hair_suffix = ""

/obj/item/clothing/head/collectable/hop
	name = "коллекционная шляпа главы персонала"
	desc = "Теперь ваша очередь требовать чрезмерной бумажной работы, подписей, штампов и нанимать больше клоунов! Документы, пожалуйста!"
	icon_state = "hopcap"
	dog_fashion = /datum/dog_fashion/head/hop

/obj/item/clothing/head/collectable/thunderdome
	name = "коллекционный шлем 'купола грома'"
	desc = "НА КРАСНУЮ! Я ИМЕЛ В ВИДУ ЗЕЛЁНУЮ! Я ИМЕЛ В ВИДУ КРАСНУЮ! НЕ ЗЕЛЕНУЮ!"
	icon_state = "thunderdome"
	inhand_icon_state = "thunderdome"
	clothing_flags = SNUG_FIT
	flags_inv = HIDEHAIR

/obj/item/clothing/head/collectable/swat
	name = "коллекционный шлем спецназа"
	desc = "Это не настоящая кровь. Это красная краска." //Reference to the actual description
	icon_state = "swat"
	inhand_icon_state = "swat"
	clothing_flags = SNUG_FIT
	flags_inv = HIDEHAIR

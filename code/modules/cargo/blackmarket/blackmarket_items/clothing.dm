/datum/blackmarket_item/clothing
	category = "Одежда"

/datum/blackmarket_item/clothing/ninja_mask
	name = "Маска космического ниндзи"
	desc = "Маска сделанная со стилем"
	item = /obj/item/clothing/mask/gas/space_ninja

	price_min = 200
	price_max = 5000
	stock_max = 1
	availability_prob = 40

/datum/blackmarket_item/clothing/durathread_vest
	name = "Дюрасталевый бронежилет"
	desc = "Don't let them tell you this stuff is \"Like asbestos\" or \"Pulled from the market for safety concerns\". It could be the difference between a robusting and a retaliation."
	item = /obj/item/clothing/suit/armor/vest/durathread

	price_min = 200
	price_max = 400
	stock_max = 4
	availability_prob = 50

/datum/blackmarket_item/clothing/durathread_helmet
	name = "Дюратсалевый шлем"
	desc = "Customers ask why it's called a helmet when it's just made from armoured fabric and I always say the same thing: No refunds."
	item = /obj/item/clothing/head/helmet/durathread

	price_min = 100
	price_max = 200
	stock_max = 4
	availability_prob = 50

/datum/blackmarket_item/clothing/full_spacesuit_set
	name = "Устаревший космический костюм НТ"
	desc = "Космический костюм НТ устаревшего вида"
	item = /obj/item/storage/box

	price_min = 1500
	price_max = 4000
	stock_max = 3
	availability_prob = 30

/datum/blackmarket_item/clothing/full_spacesuit_set/spawn_item(loc)
	var/obj/item/storage/box/B = ..()
	B.name = "Коробка с космическим костюмом"
	B.desc = "На коробке надпись НТ"
	new /obj/item/clothing/suit/space(B)
	new /obj/item/clothing/head/helmet/space(B)
	return B

/datum/blackmarket_item/clothing/chameleon_hat
	name = "Шляпа-Хамелеон"
	desc = "Очень модная шляпа"
	item = /obj/item/clothing/head/chameleon/broken

	price_min = 100
	price_max = 2000
	stock_min = 1
	stock_max = 10
	availability_prob = 70

/datum/blackmarket_item/clothing/combatmedic_suit
	name = "Скафандр Боевого медика"
	desc = "Этот скафандр был найден в уничтоженном гнезде ксеноморфов. Судьба носителя неизвестна, но этот скафандр до сих пор соответсвует стандартам боевых скафандров"
	item = /obj/item/clothing/suit/space/hardsuit/combatmedic

	price_min = 5500
	price_max = 7000
	stock_max = 1
	availability_prob = 10

/datum/bounty/item/mining/goliath_steaks
	name = "Приготовленные на лаве стейки голиафа"
	description = "Адмирал Павлов объявил голодовку с тех пор, как в столовой начали обслуживать только обезьяну и побочные продукты обезьяны. Он требует вареных лавой стейков Голиафа."
	reward = CARGO_CRATE_VALUE * 150
	required_count = 3
	wanted_types = list(/obj/item/food/meat/steak/goliath)

/datum/bounty/item/mining/goliath_boat
	name = "Лодка из кожи голиафа"
	description = "Командующий Меньков хочет участвовать в ежегодной регате Лаваланда. Он просит ваших работников построить самую быструю лодку, известную человеку."
	reward = CARGO_CRATE_VALUE * 200
	wanted_types = list(/obj/vehicle/ridden/lavaboat)

/datum/bounty/item/mining/bone_oar
	name = "Костяные весла"
	description = "Командующий Меньков требует весла для участия в ежегодной регате Лаваленда. Отправь пару."
	reward = CARGO_CRATE_VALUE * 100
	required_count = 2
	wanted_types = list(/obj/item/oar)

/datum/bounty/item/mining/bone_axe
	name = "Костяной топор"
	description = "У станции 12 были похищены пожарные топоры клоунами-мародерами. Доставьте им костяной топор в качестве замены."
	reward = CARGO_CRATE_VALUE * 150
	wanted_types = list(/obj/item/fireaxe/boneaxe)

/datum/bounty/item/mining/bone_armor
	name = "Костяная броня"
	description = "Станция 14 вызвала их команду ящериц для испытания баллистической брони. Отправьте им костяную броню."
	reward = CARGO_CRATE_VALUE * 145
	wanted_types = list(/obj/item/clothing/suit/armor/bone)

/datum/bounty/item/mining/skull_helmet
	name = "Костяной шлем"
	description = "У ХОСа станции 42 завтра день рождения! Мы хотим удивить его с модным черепом."
	reward = CARGO_CRATE_VALUE * 120
	wanted_types = list(/obj/item/clothing/head/helmet/skull)

/datum/bounty/item/mining/bone_talisman
	name = "Костяной талисман"
	description = "Директор исследования станции 14 утверждает, что талисманы язычников из костей защищают своего владельца. Отправьте несколько, чтобы они могли начать тестирование."
	reward = CARGO_CRATE_VALUE * 100
	required_count = 3
	wanted_types = list(/obj/item/clothing/accessory/talisman)

/datum/bounty/item/mining/bone_dagger
	name = "Костяные кинжалы"
	description = "Столовая ЦК подвергается сокращению бюджета. Отправьте несколько костяных кинжалов, чтобы наш шеф-повар продолжал работать."
	reward = CARGO_CRATE_VALUE * 60
	required_count = 3
	wanted_types = list(/obj/item/kitchen/knife/combat/bone)

/datum/bounty/item/mining/polypore_mushroom
	name = "Грибная миска"
	description = "Лейтенант Джеб уронил свою любимую миску с грибами. Ободри его, отправив новую, ладно?"
	reward = CARGO_CRATE_VALUE * 60
	wanted_types = list(/obj/item/reagent_containers/glass/bowl/mushroom_bowl)

/datum/bounty/item/mining/inocybe_mushroom
	name = "Грибные Inocybe"
	description = "Наш ботаник утверждает, что может отогнать вкусный ликер абсолютно с любого растения. Посмотрим, что он будет делать с грибными шапочками."
	reward = CARGO_CRATE_VALUE * 45
	required_count = 3
	wanted_types = list(/obj/item/food/grown/ash_flora/mushroom_cap)

/datum/bounty/item/mining/porcini_mushroom
	name = "Грибы Porcini"
	description = "По слухам, белые грибы обладают целебными свойствами. Наши исследователи хотят проверить это."
	reward = CARGO_CRATE_VALUE * 90
	required_count = 3
	wanted_types = list(/obj/item/food/grown/ash_flora/mushroom_leaf)

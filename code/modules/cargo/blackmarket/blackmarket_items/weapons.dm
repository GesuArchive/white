/datum/blackmarket_item/weapon
	category = "Оружия"

/datum/blackmarket_item/weapon/bear_trap
	name = "Медвежий капкан"
	desc = "Ловушка уборщика"
	item = /obj/item/restraints/legcuffs/beartrap

	price_min = 300
	price_max = 550
	stock_max = 3
	availability_prob = 40

/datum/blackmarket_item/weapon/shotgun_dart
	name = "Дарт для дробовика"
	desc = "Аналог шприца только для дробовика"
	item = /obj/item/ammo_casing/shotgun/dart

	price_min = 10
	price_max = 50
	stock_min = 10
	stock_max = 60
	availability_prob = 40

/datum/blackmarket_item/weapon/bone_spear
	name = "Костяное копьё"
	desc = "Любимое копьё пещерных людей"
	item = /obj/item/spear/bonespear

	price_min = 200
	price_max = 300
	stock_max = 3
	availability_prob = 60

/datum/blackmarket_item/weapon/emp_grenade
	name = "EMP граната"
	desc = "Бахает красиво а бесит ещё больше"
	item = /obj/item/grenade/empgrenade

	price_min = 100
	price_max = 400
	stock_max = 2
	availability_prob = 50

/datum/blackmarket_item/weapon/reverse_bear_trap
	name = "Сломанная медвежья ловушка"
	desc = "Ловушка для уборщика"
	item = /obj/item/reverse_bear_trap

	price_min = 500
	price_max = 950
	stock_max = 4
	availability_prob = 30

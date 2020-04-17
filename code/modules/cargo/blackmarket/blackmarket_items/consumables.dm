/datum/blackmarket_item/consumable
	category = "Consumables"

/datum/blackmarket_item/consumable/clown_tears
	name = "Bowl of Clown's Tears"
	desc = "Guaranteed fresh from Weepy Boggins Tragic Kitchen"
	item = /obj/item/reagent_containers/food/snacks/soup/clownstears
	stock = 1

	price_min = 520
	price_max = 600
	availability_prob = 10

/datum/blackmarket_item/consumable/donk_pocket_box
	name = "Box of Donk Pockets"
	desc = "A well packaged box containing the favourite snack of every spacefarer."
	item = /obj/item/storage/box/donkpockets

	stock_min = 1
	stock_max = 10
	price_min = 100
	price_max = 500
	availability_prob = 100
	
	/datum/blackmarket_item/consumable/donk_pocket_box/spawn_item(loc)
		var/donkpockets = pick(list(/obj/item/storage/box/donkpockets,
				/obj/item/storage/box/donkpockets/donkpocketspicy,
				/obj/item/storage/box/donkpockets/donkpocketteriyaki,
				/obj/item/storage/box/donkpockets/donkpocketpizza,
				/obj/item/storage/box/donkpockets/donkpocketgondola, //Превращает в гондолу
				/obj/item/storage/box/donkpockets/donkpocketberry,
				/obj/item/storage/box/donkpockets/donkpockethonk))
		return new donkpockets(loc)

/datum/blackmarket_item/consumable/suspicious_pills
	name = "Bottle of Suspicious Pills"
	desc = "A random cocktail of luxury drugs that are sure to put a smile on your face!"
	item = /obj/item/storage/pill_bottle

	stock_min = 1
	stock_max = 20
	price_min = 400
	price_max = 700
	availability_prob = 100

/datum/blackmarket_item/consumable/suspicious_pills/spawn_item(loc)
	var/pillbottle = pick(list(/obj/item/storage/pill_bottle/zoom,
				/obj/item/storage/pill_bottle/happy,
				/obj/item/storage/pill_bottle/cyanide,
				/obj/item/storage/pill_bottle/crank,
				/obj/item/storage/pill_bottle/bath_salts,
				/obj/item/storage/pill_bottle/lsd,
				/obj/item/storage/pill_bottle/aranesp,
				/obj/item/storage/pill_bottle/krokodil,
				/obj/item/storage/pill_bottle/happiness,
				/obj/item/storage/pill_bottle/modafinil,
				/obj/item/storage/pill_bottle/methamphetamine,
				/obj/item/storage/pill_bottle/floorpill/full,
				/obj/item/storage/pill_bottle/psicodine,
				/obj/item/storage/pill_bottle/C2/probital,
				/obj/item/storage/pill_bottle/stimulant))
	return new pillbottle(loc)

/datum/blackmarket_item/consumable/floor_pill
	name = "Strange Pill"
	desc = "The Russian Roulette of the Maintenance Tunnels."
	item = /obj/item/reagent_containers/pill/floorpill

	stock_min = 1
	stock_max = 100
	price_min = 10
	price_max = 60
	availability_prob = 100

/datum/blackmarket_item/consumable/pumpup
	name = "Maintenance Pump-Up"
	desc = "Resist any Baton stun with this handy device!"
	item = /obj/item/reagent_containers/hypospray/medipen/pumpup

	stock_max = 3
	price_min = 50
	price_max = 150
	availability_prob = 90

/datum/blackmarket_item/consumable/labebium
	name = "Бутылочка правды"
	desc = "Заставит поглотившего это познать правду."
	item = /obj/item/storage/pill_bottle/labebium

	stock_min = 1
	stock_max = 5
	price_min = 250
	price_max = 550
	availability_prob = 30

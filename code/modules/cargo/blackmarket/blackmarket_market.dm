/datum/blackmarket_market
	/// Name for the market.
	var/name = "huh?"

	/// Available shipping methods and prices, just leave the shipping method out that you don't want to have.
	var/list/shipping

	/// Amount of time before the market is repopulated
	var/time_left = 0

	// Automatic vars, do not touch these.
	/// Items available from this market, populated by SSblackmarket on initialization.
	var/list/available_items = list()
	/// Item categories available from this market, only items which are in these categories can be gotten from this market.
	var/list/categories	= list()

/// Adds item to the available items and add it's category if it is not in categories yet.
/datum/blackmarket_market/proc/add_item(datum/blackmarket_item/item)
	if(!prob(initial(item.availability_prob)))
		return FALSE

	if(ispath(item))
		item = new item()

	if(!(item.category in categories))
		categories += item.category
		available_items[item.category] = list()

	available_items[item.category] += item
	return TRUE

/// Handles buying the item, this is mainly for future use and moving the code away from the uplink.
/datum/blackmarket_market/proc/purchase(item, category, method, obj/item/blackmarket_uplink/uplink, user)
	if(!istype(uplink) || !(method in shipping))
		return FALSE

	for(var/datum/blackmarket_item/I in available_items[category])
		if(I.type != item)
			continue
		var/price = I.price + shipping[method]
		// I can't get the price of the item and shipping in a clean way to the UI, so I have to do this.
		if(uplink.money < price)
			to_chat(span_warning("Недостаточно кредитов в [uplink] для [I] с [method] доставки."))
			return FALSE

		if(I.buy(uplink, user, method))
			uplink.money -= price
			return TRUE
		return FALSE

/datum/blackmarket_market/blackmarket
	name = "Чёрный Рынок"
	shipping = list(SHIPPING_METHOD_LTSRBT	=50,
					SHIPPING_METHOD_LAUNCH	=10,
					SHIPPING_METHOD_TELEPORT=75)

/datum/blackmarket_market/syndiemarket
	name = "Синди Маркет"
	shipping = list(SHIPPING_METHOD_LTSRBT	=50,
				SHIPPING_METHOD_LAUNCH	=10,
				SHIPPING_METHOD_TELEPORT=75)

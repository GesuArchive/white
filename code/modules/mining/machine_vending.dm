/**********************Mining Equipment Vendor**************************/

/obj/machinery/vendor
	name = "equipment vendor"
	processing_flags = START_PROCESSING_MANUALLY
	subsystem_type = /datum/controller/subsystem/processing/fastprocess
	density = TRUE
	var/icon_deny
	var/obj/item/card/id/inserted_id
	var/list/prize_list = list()

/obj/machinery/vendor/Initialize()
	. = ..()
	build_inventory()

/obj/machinery/vendor/proc/build_inventory()
	for(var/p in prize_list)
		var/datum/data/vendor_equipment/M = p
		GLOB.vending_products[M.equipment_path] = 1

/obj/machinery/vendor/update_icon_state()
	if(powered())
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-off"

/obj/machinery/vendor/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/vending),
	)

/obj/machinery/vendor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MiningVendor", name)
		ui.open()

/obj/machinery/vendor/ui_static_data(mob/user)
	. = list()
	.["product_records"] = list()
	for(var/datum/data/vendor_equipment/prize in prize_list)
		var/list/product_data = list(
			path = replacetext(replacetext("[prize.equipment_path]", "/obj/item/", ""), "/", "-"),
			name = prize.equipment_name,
			price = prize.cost,
			ref = REF(prize)
		)
		.["product_records"] += list(product_data)

/obj/machinery/vendor/ui_data(mob/user)
	. = list()
	var/obj/item/card/id/C
	if(isliving(user))
		var/mob/living/L = user
		C = L.get_idcard(TRUE)
	if(C)
		.["user"] = list()
		.["user"]["points"] = get_points(C)
		if(C.registered_account)
			.["user"]["name"] = C.registered_account.account_holder
			if(C.registered_account.account_job)
				.["user"]["job"] = C.registered_account.account_job.title
			else
				.["user"]["job"] = "No Job"

/obj/machinery/vendor/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("purchase")
			var/obj/item/card/id/I
			if(isliving(usr))
				var/mob/living/L = usr
				I = L.get_idcard(TRUE)
			if(!istype(I))
				to_chat(usr, span_alert("Error: An ID is required!"))
				flick(icon_deny, src)
				return
			var/datum/data/vendor_equipment/prize = locate(params["ref"]) in prize_list
			if(!prize || !(prize in prize_list))
				to_chat(usr, span_alert("Error: Invalid choice!"))
				flick(icon_deny, src)
				return
			if(prize.cost > get_points(I))
				to_chat(usr, span_alert("Error: Insufficient points for [prize.equipment_name] on [I]!"))
				flick(icon_deny, src)
				return
			subtract_points(I, prize.cost)
			to_chat(usr, span_notice("[capitalize(src.name)] clanks to life briefly before vending [prize.equipment_name]!"))
			new prize.equipment_path(loc)
			SSblackbox.record_feedback("nested tally", "vendor_equipment_bought", 1, list("[type]", "[prize.equipment_path]"))
			. = TRUE

/obj/machinery/vendor/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user, "mining-open", "mining", I))
		return
	if(default_deconstruction_crowbar(I))
		return
	return ..()

/obj/machinery/vendor/ex_act(severity, target)
	do_sparks(5, TRUE, src)
	if(prob(50 / severity) && severity < 3)
		qdel(src)

/obj/machinery/vendor/proc/subtract_points(obj/item/card/id/I, amount)
	I.mining_points -= amount

/obj/machinery/vendor/proc/get_points(obj/item/card/id/I)
	return I.mining_points

/obj/machinery/vendor/mining
	name = "mining equipment vendor"
	desc = "An equipment vendor for miners, points collected at an ore redemption machine can be spent here."
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "mining"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/mining_equipment_vendor

	icon_deny = "mining-deny"
	prize_list = list( //if you add something to this, please, for the love of god, sort it by price/type. use tabs and not spaces.
		new /datum/data/vendor_equipment("1 Marker Beacon",				/obj/item/stack/marker_beacon,										10),
		new /datum/data/vendor_equipment("10 Marker Beacons",			/obj/item/stack/marker_beacon/ten,									100),
		new /datum/data/vendor_equipment("30 Marker Beacons",			/obj/item/stack/marker_beacon/thirty,								300),
		new /datum/data/vendor_equipment("Whiskey",						/obj/item/reagent_containers/food/drinks/bottle/whiskey,			100),
		new /datum/data/vendor_equipment("Absinthe",					/obj/item/reagent_containers/food/drinks/bottle/absinthe/premium,	100),
		new /datum/data/vendor_equipment("Bubblegum Gum Packet",		/obj/item/storage/box/gum/bubblegum,								100),
		new /datum/data/vendor_equipment("Cigar",						/obj/item/clothing/mask/cigarette/cigar/havana,						150),
		new /datum/data/vendor_equipment("Soap",						/obj/item/soap/nanotrasen,											200),
		new /datum/data/vendor_equipment("ИРП-4",						/obj/item/storage/mre,												215),
		new /datum/data/vendor_equipment("ИРП-6",						/obj/item/storage/mre/protein,										235),
		new /datum/data/vendor_equipment("ИРП-47",						/obj/item/storage/mre/vegan,										290),
		new /datum/data/vendor_equipment("Laser Pointer",				/obj/item/laser_pointer,											300),
		new /datum/data/vendor_equipment("Alien Toy",					/obj/item/clothing/mask/facehugger/toy,								300),
		new /datum/data/vendor_equipment("Stabilizing Serum",			/obj/item/hivelordstabilizer,										400),
		new /datum/data/vendor_equipment("Fulton Beacon",				/obj/item/fulton_core,												400),
		new /datum/data/vendor_equipment("Shelter Capsule",				/obj/item/survivalcapsule,											400),
		new /datum/data/vendor_equipment("GAR Meson Scanners",			/obj/item/clothing/glasses/meson/gar,								500),
		new /datum/data/vendor_equipment("Explorer's Webbing",			/obj/item/storage/belt/mining,										500),
		new /datum/data/vendor_equipment("Point Transfer Card",			/obj/item/card/mining_point_card,									500),
		new /datum/data/vendor_equipment("Survival Medipen",			/obj/item/reagent_containers/hypospray/medipen/survival,			500),
		new /datum/data/vendor_equipment("Brute First-Aid Kit",			/obj/item/storage/firstaid/brute,									600),
		new /datum/data/vendor_equipment("Tracking Implant Kit", 		/obj/item/storage/box/minertracker,									600),
		new /datum/data/vendor_equipment("Jaunter",						/obj/item/wormhole_jaunter,											750),
		new /datum/data/vendor_equipment("Kinetic Crusher",				/obj/item/kinetic_crusher,											750),
		new /datum/data/vendor_equipment("Kinetic Accelerator",			/obj/item/gun/energy/kinetic_accelerator,							750),
		new /datum/data/vendor_equipment("Advanced Scanner",			/obj/item/t_scanner/adv_mining_scanner,								800),
		new /datum/data/vendor_equipment("Deepcore Pointer",			/obj/item/pinpointer/deepcore,										200),		// WS edit - Deepcore
		new /datum/data/vendor_equipment("Advanced Pointer",			/obj/item/pinpointer/deepcore/advanced,								800),		// WS edit - Deepcore
		new /datum/data/vendor_equipment("Drill Deployment Capsule",	/obj/item/deepcorecapsule,											2000),		// WS edit - Deepcore
		new /datum/data/vendor_equipment("Resonator",					/obj/item/resonator,												800),
		new /datum/data/vendor_equipment("Luxury Medipen",				/obj/item/reagent_containers/hypospray/medipen/survival/luxury,		1000),
		new /datum/data/vendor_equipment("Fulton Pack",					/obj/item/extraction_pack,											1000),
		new /datum/data/vendor_equipment("Lazarus Injector",			/obj/item/lazarus_injector,											1000),
		new /datum/data/vendor_equipment("Silver Pickaxe",				/obj/item/pickaxe/silver,											1000),
		new /datum/data/vendor_equipment("Mining Conscription Kit",		/obj/item/storage/backpack/duffelbag/mining_conscript,				1500),
		new /datum/data/vendor_equipment("Jetpack Upgrade",				/obj/item/tank/jetpack/suit,										2000),
		new /datum/data/vendor_equipment("Space Cash",					/obj/item/stack/spacecash/c1000,									2000),
		new /datum/data/vendor_equipment("Mining Hardsuit",				/obj/item/clothing/suit/space/hardsuit/mining,						2000),
		new /datum/data/vendor_equipment("Diamond Pickaxe",				/obj/item/pickaxe/diamond,											2000),
		new /datum/data/vendor_equipment("Super Resonator",				/obj/item/resonator/upgraded,										2500),
		new /datum/data/vendor_equipment("Jump Boots",					/obj/item/clothing/shoes/bhop,										2500),
		new /datum/data/vendor_equipment("Luxury Shelter Capsule",		/obj/item/survivalcapsule/luxury,									3000),
		new /datum/data/vendor_equipment("Super Kinetic Accelerator",	/obj/item/gun/energy/kinetic_accelerator/super_kinetic_accelerator,	4000),
		new /datum/data/vendor_equipment("Luxury Bar Capsule",			/obj/item/survivalcapsule/luxuryelite,								10000),
		new /datum/data/vendor_equipment("Nanotrasen Minebot",			/mob/living/simple_animal/hostile/mining_drone,						800),
		new /datum/data/vendor_equipment("Minebot Melee Upgrade",		/obj/item/mine_bot_upgrade,											400),
		new /datum/data/vendor_equipment("Minebot Armor Upgrade",		/obj/item/mine_bot_upgrade/health,									400),
		new /datum/data/vendor_equipment("Minebot Cooldown Upgrade",	/obj/item/borg/upgrade/modkit/cooldown/minebot,						600),
		new /datum/data/vendor_equipment("Minebot AI Upgrade",			/obj/item/slimepotion/slime/sentience/mining,						1000),
		new /datum/data/vendor_equipment("KA Minebot Passthrough",		/obj/item/borg/upgrade/modkit/minebot_passthrough,					100),
		new /datum/data/vendor_equipment("KA White Tracer Rounds",		/obj/item/borg/upgrade/modkit/tracer,								100),
		new /datum/data/vendor_equipment("KA Adjustable Tracer Rounds",	/obj/item/borg/upgrade/modkit/tracer/adjustable,					150),
		new /datum/data/vendor_equipment("KA Super Chassis",			/obj/item/borg/upgrade/modkit/chassis_mod,							250),
		new /datum/data/vendor_equipment("KA Hyper Chassis",			/obj/item/borg/upgrade/modkit/chassis_mod/orange,					300),
		new /datum/data/vendor_equipment("KA Range Increase",			/obj/item/borg/upgrade/modkit/range,								1000),
		new /datum/data/vendor_equipment("KA Damage Increase",			/obj/item/borg/upgrade/modkit/damage,								1000),
		new /datum/data/vendor_equipment("KA Cooldown Decrease",		/obj/item/borg/upgrade/modkit/cooldown,								1000),
		new /datum/data/vendor_equipment("KA AoE Damage",				/obj/item/borg/upgrade/modkit/aoe/mobs,								2000)
	)
/datum/data/vendor_equipment
	var/equipment_name = "generic"
	var/equipment_path = null
	var/cost = 0

/datum/data/vendor_equipment/New(name, path, cost)
	src.equipment_name = name
	src.equipment_path = path
	src.cost = cost

/obj/machinery/vendor/mining/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/mining_voucher))
		RedeemVoucher(I, user)
		return
	return ..()

/obj/machinery/vendor/proc/RedeemVoucher(obj/item/mining_voucher/voucher, mob/redeemer)
	var/items = list("Survival Capsule and Explorer's Webbing", "Resonator Kit", "Minebot Kit", "Extraction and Rescue Kit", "Crusher Kit", "Mining Conscription Kit")

	var/selection = input(redeemer, "Pick your equipment", "Mining Voucher Redemption") as null|anything in sortList(items)
	if(!selection || !Adjacent(redeemer) || QDELETED(voucher) || voucher.loc != redeemer)
		return
	var/drop_location = drop_location()
	switch(selection)
		if("Survival Capsule and Explorer's Webbing")
			new /obj/item/storage/belt/mining/vendor(drop_location)
		if("Resonator Kit")
			new /obj/item/extinguisher/mini(drop_location)
			new /obj/item/resonator(drop_location)
		if("Minebot Kit")
			new /mob/living/simple_animal/hostile/mining_drone(drop_location)
			new /obj/item/weldingtool/hugetank(drop_location)
			new /obj/item/clothing/head/welding(drop_location)
			new /obj/item/borg/upgrade/modkit/minebot_passthrough(drop_location)
		if("Extraction and Rescue Kit")
			new /obj/item/extraction_pack(drop_location)
			new /obj/item/fulton_core(drop_location)
			new /obj/item/stack/marker_beacon/thirty(drop_location)
		if("Crusher Kit")
			new /obj/item/extinguisher/mini(drop_location)
			new /obj/item/kinetic_crusher(drop_location)
		if("Mining Conscription Kit")
			new /obj/item/storage/backpack/duffelbag/mining_conscript(drop_location)

	SSblackbox.record_feedback("tally", "mining_voucher_redeemed", 1, selection)
	qdel(voucher)

/****************Golem Point Vendor**************************/

/obj/machinery/vendor/golem
	name = "golem ship equipment vendor"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "mining"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/mining_equipment_vendor/golem

/obj/machinery/vendor/golem/Initialize()
	desc += "\nIt seems a few selections have been added."
	prize_list += list(
		new /datum/data/vendor_equipment("Extra Id",       				/obj/item/card/id/advanced/mining, 				           		250),
		new /datum/data/vendor_equipment("Science Goggles",       		/obj/item/clothing/glasses/science,								250),
		new /datum/data/vendor_equipment("Monkey Cube",					/obj/item/food/monkeycube,        								300),
		new /datum/data/vendor_equipment("Toolbelt",					/obj/item/storage/belt/utility,	    							350),
		new /datum/data/vendor_equipment("Royal Cape of the Liberator", /obj/item/bedsheet/rd/royal_cape, 								500),
		new /datum/data/vendor_equipment("Grey Slime Extract",			/obj/item/slime_extract/grey,									1000),
		new /datum/data/vendor_equipment("Modification Kit",    		/obj/item/borg/upgrade/modkit/trigger_guard,					1700),
		new /datum/data/vendor_equipment("The Liberator's Legacy",  	/obj/item/storage/box/rndboards,								2000)
		)
	return ..()

/**********************Mining Equipment Vendor Items**************************/

/**********************Mining Equipment Voucher**********************/

/obj/item/mining_voucher
	name = "mining voucher"
	desc = "A token to redeem a piece of equipment. Use it on a mining equipment vendor."
	icon = 'icons/obj/mining.dmi'
	icon_state = "mining_voucher"
	w_class = WEIGHT_CLASS_TINY

/**********************Mining Point Card**********************/

/obj/item/card/mining_point_card
	name = "mining points card"
	desc = "A small card preloaded with mining points. Swipe your ID card over it to transfer the points, then discard."
	icon_state = "data_1"
	var/points = 500

/obj/item/card/mining_point_card/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/card/id))
		if(points)
			var/obj/item/card/id/C = I
			C.mining_points += points
			to_chat(user, span_info("You transfer [points] points to [C]."))
			points = 0
		else
			to_chat(user, span_alert("There's no points left on [src]."))
	..()

/obj/item/card/mining_point_card/examine(mob/user)
	..()
	to_chat(user, span_alert("There's [points] point\s on the card."))

/obj/item/storage/backpack/duffelbag/mining_conscript
	name = "mining conscription kit"
	desc = "A kit containing everything a crewmember needs to support a shaft miner in the field."

/obj/item/storage/backpack/duffelbag/mining_conscript/PopulateContents()
	new /obj/item/clothing/glasses/meson(src)
	new /obj/item/t_scanner/adv_mining_scanner/lesser(src)
	new /obj/item/storage/bag/ore(src)
	new /obj/item/clothing/suit/hooded/explorer(src)
	new /obj/item/encryptionkey/headset_mining(src)
	new /obj/item/clothing/mask/gas/explorer(src)
	new /obj/item/card/id/advanced/mining(src)
	new /obj/item/gun/energy/kinetic_accelerator(src)
	new /obj/item/kitchen/knife/combat/survival(src)
	new /obj/item/flashlight/seclite(src)

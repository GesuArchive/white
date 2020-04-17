/datum/blackmarket_item/implants
	category = "Implants"

/datum/blackmarket_item/implants/autosurgeon
	name = "Empty Autosurgeon"
	desc = "Empty Autosurgeon"
	item = /obj/item/autosurgeon
	stock_min = 1
	stock_max = 5

	price_min = 100
	price_max = 500
	availability_prob = 100

	/datum/blackmarket_item/implants/autosurgeon/spawn_item(loc)
		var/autosurgeon = pick(list(/obj/item/autosurgeon,
				/obj/item/autosurgeon/syndicate))
		return new autosurgeon(loc)

/datum/blackmarket_item/implants/autosurgeon/thermal_eyes
	name = "Thermal Eye's"
	desc = "This autosurgeon contains Thermal Eye's"
	item = /obj/item/autosurgeon/syndicate/thermal_eyes
	stock_min = 1
	stock_max = 5

	price_min = 1000
	price_max = 5000
	availability_prob = 50

/datum/blackmarket_item/implants/autosurgeon/xray_eyes
	name = "Xray Eye's"
	desc = "This autosurgeon contains Xray Eye's"
	item = /obj/item/autosurgeon/syndicate/xray_eyes
	stock_min = 1
	stock_max = 5

	price_min = 5000
	price_max = 10000
	availability_prob = 50

/datum/blackmarket_item/implants/autosurgeon/anti_stun
	name = "Anti Stun Implant"
	desc = "This autosurgeon contains Anti Stun Implant"
	item = /obj/item/autosurgeon/syndicate/anti_stun
	stock_min = 1
	stock_max = 5

	price_min = 500
	price_max = 1500
	availability_prob = 70

/datum/blackmarket_item/implants/autosurgeon/reviver
	name = "Reviver Implant"
	desc = "This autosurgeon contains Reviver Implant"
	item = /obj/item/autosurgeon/syndicate/reviver
	stock_min = 1
	stock_max = 5

	price_min = 5000
	price_max = 10000
	availability_prob = 50

/datum/blackmarket_item/implants/autosurgeon/breathing_tube
	name = "Breathing Tube Implant"
	desc = "This autosurgeon contains Breathing Tube Implant"
	item = /obj/item/autosurgeon/breathing_tube
	stock_min = 1
	stock_max = 5

	price_min = 1000
	price_max = 5000
	availability_prob = 50

/datum/blackmarket_item/implants/autosurgeon/hud/medical
	name = "Medical HUD implant"
	desc = "This autosurgeon contains Medical HUD implant"
	item = /obj/item/autosurgeon/hud/medical
	stock_min = 1
	stock_max = 5

	price_min = 500
	price_max = 1000
	availability_prob = 50

/datum/blackmarket_item/implants/autosurgeon/hud/security
	name = "Security HUD implant"
	desc = "This autosurgeon contains Security HUD implant"
	item = /obj/item/autosurgeon/hud/security
	stock_min = 1
	stock_max = 5

	price_min = 500
	price_max = 1000
	availability_prob = 50

/datum/blackmarket_item/implants/autosurgeon/hud/diagnostic
	name = "Diagnostic HUD implant"
	desc = "This autosurgeon contains Diagnostic HUD implant"
	item = /obj/item/autosurgeon/hud/diagnostic
	stock_min = 1
	stock_max = 5

	price_min = 500
	price_max = 1000
	availability_prob = 50

/datum/blackmarket_item/implants/autosurgeon/nutriment
	name = "Nutriment pump implant"
	desc = "This autosurgeon contains Nutriment pump implant"
	item = /obj/item/autosurgeon/nutriment
	stock_min = 1
	stock_max = 5

	price_min = 1000
	price_max = 5000
	availability_prob = 50

/datum/blackmarket_item/implants/autosurgeon/nutriment/plus
	name = "Nutriment pump implant PLUS"
	desc = "This autosurgeon contains Nutriment pump implant PLUS"
	item = /obj/item/autosurgeon/nutriment/plus
	stock_min = 1
	stock_max = 5

	price_min = 5000
	price_max = 10000
	availability_prob = 50

/datum/blackmarket_item/implants/autosurgeon/thrusters
	name = "Thrusters Implant"
	desc = "This autosurgeon contains Thrusters Implant"
	item = /obj/item/autosurgeon/thrusters
	stock_min = 1
	stock_max = 5

	price_min = 1000
	price_max = 5000
	availability_prob = 50

/datum/blackmarket_item/implants/autosurgeon/toolset
	name = "Engineering Toolset Implant"
	desc = "This autosurgeon contains Toolset Implant"
	item = /obj/item/autosurgeon/arm/toolset
	stock_min = 1
	stock_max = 5

	price_min = 100
	price_max = 500
	availability_prob = 50

/datum/blackmarket_item/implants/autosurgeon/medibeam
	name = "Medibeam Implant"
	desc = "This autosurgeon contains Medibeam Implant"
	item = /obj/item/autosurgeon/arm/medibeam
	stock_min = 1
	stock_max = 5

	price_min = 5000
	price_max = 10000
	availability_prob = 50

/datum/blackmarket_item/implants/autosurgeon/surgery
	name = "Surgery Toolset Implant"
	desc = "This autosurgeon contains Surgery Toolset Implant"
	item = /obj/item/autosurgeon/arm/surgery
	stock_min = 1
	stock_max = 5

	price_min = 100
	price_max = 5000
	availability_prob = 50






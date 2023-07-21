/datum/export/bounty_box
	cost = 0.1
	k_elasticity = 0 //Bounties are non-elastic funds.
	unit_name = "Куб с Данными"
	export_types = list(/obj/item/bounty_cube)

/datum/export/bounty_box/get_cost(obj/item/bounty_cube/cube, apply_elastic)
	return cube.bounty_value

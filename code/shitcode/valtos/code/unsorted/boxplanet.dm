/area/boxplanet
	icon_state = "mining"
	has_gravity = STANDARD_GRAVITY
	flags_1 = NONE
	flora_allowed = TRUE
	blob_allowed = FALSE

/area/boxplanet/surface
	name = "Поверхность"
	outdoors = TRUE
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	icon_state = "explored"
	always_unpowered = TRUE
	poweralm = FALSE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	requires_power = TRUE
	ambientsounds = MINING

/area/boxplanet/underground
	name = "Пещеры"
	outdoors = TRUE
	always_unpowered = TRUE
	requires_power = TRUE
	poweralm = FALSE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	ambientsounds = MINING
	mob_spawn_allowed = FALSE
	megafauna_spawn_allowed = FALSE

/area/boxplanet/underground/unexplored
	icon_state = "unexplored"
	tunnel_allowed = TRUE

/area/boxplanet/underground/explored
	name = "Подземелье"
	flora_allowed = FALSE

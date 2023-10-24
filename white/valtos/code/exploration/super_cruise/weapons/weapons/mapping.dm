	/*
 * Just for you beauitful mappers.
 *
 * These are the mapping spawners for shuttles, on spawn depending on the difficulty of the area weapons will by dynamically applied.
 * Thats literally it, it's not a helper, it's required unless you want your ship to have static weapons.
*/

/obj/effect/landmark/exploration_weapon_spawner
	name = "ship weapon spawner up"
	icon = 'icons/effects/mapping_arrows.dmi'
	icon_state = "blue_up"
	var/side_to_spawn = WEAPON_SIDE_NONE

/obj/effect/landmark/exploration_weapon_spawner/Initialize()
	. = ..()
	//TODO
	do_weapon_spawn(rand(0, 100))

/obj/effect/landmark/exploration_weapon_spawner/proc/do_weapon_spawn(shuttle_strength)
	//Pick a weapon type
	var/list/valid_weapon_types = list()
	for (var/obj/machinery/shuttle_weapon/shuttle_weapon_type as() in subtypesof(/obj/machinery/shuttle_weapon))
		valid_weapon_types[shuttle_weapon_type] = 100 - abs(initial(shuttle_weapon_type.strength_rating) - shuttle_strength)
	spawn_weapon(pick_weight(valid_weapon_types))
	qdel(src)

/obj/effect/landmark/exploration_weapon_spawner/proc/spawn_weapon(weapon_type)
	var/obj/machinery/shuttle_weapon/spawned_weapon = new weapon_type(get_turf(src))
	spawned_weapon.side = side_to_spawn
	spawned_weapon.dir = dir
	spawned_weapon.set_directional_offset(dir)

/obj/effect/landmark/exploration_weapon_spawner/left
	name = "ship weapon spawner left"
	side_to_spawn = WEAPON_SIDE_LEFT

/obj/effect/landmark/exploration_weapon_spawner/right
	name = "ship weapon spawner right"
	side_to_spawn = WEAPON_SIDE_RIGHT

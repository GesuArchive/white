
/obj/machinery/armament_station/yohei
	name = "ЙохейКинг"
	desc = "Здесь обязательно можно найти то, что нужно."
	icon_state = "yohei"
	required_access = list(ACCESS_YOHEI)
	armament_type = /datum/armament_entry/yohei

/obj/item/armament_points_card/yohei
	name = "продовольственный талон"
	desc = "Очки можно потратить в специальном раздатчике, пополняется путём выполнения заданий."
	points = 10

/datum/armament_entry/yohei
	var/mags_to_spawn = 1

/datum/armament_entry/yohei/after_equip(turf/safe_drop_location, obj/item/item_to_equip)
	if(istype(item_to_equip, /obj/item/gun/ballistic))
		var/obj/item/gun/ballistic/spawned_ballistic_gun = item_to_equip
		if(spawned_ballistic_gun.magazine && !istype(spawned_ballistic_gun.magazine, /obj/item/ammo_box/magazine/internal))
			var/obj/item/storage/box/ammo_box/spawned_box = new(safe_drop_location)
			spawned_box.name = "аммуниция - [spawned_ballistic_gun.name]"
			for(var/i in 1 to mags_to_spawn)
				new spawned_ballistic_gun.mag_type (spawned_box)

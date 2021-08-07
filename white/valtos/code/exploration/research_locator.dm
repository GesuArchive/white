
/obj/item/research_disk_pinpointer
	name = "пеленгатор"
	desc = "Небольшое устройство для поиска дисков с полезной информацией. Даже учитывая его невероятную чувствительность, искать диски с исследованиями он сможет лишь только в небольшом радиусе."
	icon = 'icons/obj/device.dmi'
	icon_state = "researchlocator"
	var/next_use_time = 0
	var/range = 30

/obj/item/research_disk_pinpointer/attack_self(mob/user)
	if(world.time < next_use_time)
		to_chat(user, "<span class='notice'>Конденсаторы перезаряжаются...</span>")
		return
	to_chat(user, "<span class='notice'>Нажимаю кнопку...</span>")
	pulse_effect(get_turf(src), 6)
	next_use_time = world.time + 10 SECONDS
	for(var/obj/item/disk/tech_disk/research/research_disk in SSorbits.research_disks)
		var/dist = get_dist(user, research_disk)
		if(dist <= range)
			var/direction = get_dir(user, research_disk)
			dir = direction
			say("Обнаружен сигнал в направлении [uppertext(dir2ru_text(direction))], на расстоянии [dist] метров.")
			return

/proc/gen_tacmap(map_z = 2)
	var/icon/tacmap_icon = new('white/valtos/icons/tacmap.dmi', "tacmap_base")
	// берём все турфы с нужного з-уровня и рисуем шедевр
	for(var/xx in 1 to world.maxx)
		for(var/yy in 1 to world.maxy)
			var/turf/T = locate(xx, yy, map_z)
			if(isspaceturf(T))
				tacmap_icon.DrawBox(rgb(22, 22, 22), xx, yy, xx, yy)
				continue
			if(isopenturf(T))
				if(isplatingturf(T))
					if(locate(/obj/structure/window) in T)
						tacmap_icon.DrawBox(rgb(150, 150, 255), xx, yy, xx, yy)
					else
						tacmap_icon.DrawBox(rgb(150, 150, 150), xx, yy, xx, yy)
					continue
				tacmap_icon.DrawBox(rgb(225, 225, 225), xx, yy, xx, yy)
				continue
			if(isclosedturf(T))
				tacmap_icon.DrawBox(rgb(100, 100, 100), xx, yy, xx, yy)
	return tacmap_icon

/client/proc/get_tacmap_for_test()
	set name = " ? Generate TacMap"
	set category = "Дбг"

	var/fuckz = input("З-уровень") as num

	if(!fuckz || fuckz >= world.maxz)
		to_chat(usr, "<span class='adminnotice'> !! RETARD !! </span>")
		return

	message_admins("[ADMIN_LOOKUPFLW(usr)] запустил генерацию миникарты Z-уровня [fuckz].")
	log_admin("[key_name(usr)] запустил генерацию миникарты Z-уровня [fuckz].")

	spawn(0)
		var/icon/I = gen_tacmap(fuckz)
		to_chat(usr, "<span class='adminnotice'>Ваша овсянка, сер:</span>")
		to_chat(usr, "[icon2html(I, usr)]")


/obj/item/camera/siliconcam
	name = "камера синтетика"
	var/in_camera_mode = FALSE
	var/list/datum/picture/stored = list()

/obj/item/camera/siliconcam/ai_camera
	name = "камера ИИ"
	flash_enabled = FALSE

/obj/item/camera/siliconcam/proc/toggle_camera_mode(mob/user)
	if(in_camera_mode)
		camera_mode_off(user)
	else
		camera_mode_on(user)

/obj/item/camera/siliconcam/proc/camera_mode_off(mob/user)
	in_camera_mode = FALSE
	to_chat(user, "<B>Режим камеры деактивирован!</B>")

/obj/item/camera/siliconcam/proc/camera_mode_on(mob/user)
	in_camera_mode = TRUE
	to_chat(user, "<B>Режим камеры активирован!</B>")

/obj/item/camera/siliconcam/proc/selectpicture(mob/user)
	var/list/nametemp = list()
	if(!stored.len)
		to_chat(usr, "<span class='boldannounce'>Не сохранено изображений</span>")
		return
	var/list/temp = list()
	for(var/i in stored)
		var/datum/picture/p = i
		nametemp += p.picture_name
		temp[p.picture_name] = p
	var/find = tgui_input_list(user, "Выберите изображение", "Хранилище", nametemp)
	if(isnull(find))
		return
	if(isnull(temp[find]))
		return
	return temp[find]

/obj/item/camera/siliconcam/proc/viewpictures(mob/user)
	var/datum/picture/selection = selectpicture(user)
	if(istype(selection))
		show_picture(user, selection)

/obj/item/camera/siliconcam/ai_camera/after_picture(mob/user, datum/picture/picture)
	var/number = stored.len
	picture.picture_name = "Изображение [number] (снято в [loc.name])"
	stored[picture] = TRUE
	to_chat(usr, "<span class='unconscious'>Изображение сохранено</span>")

/obj/item/camera/siliconcam/robot_camera
	name = "камера киборга"
	var/printcost = 2

/obj/item/camera/siliconcam/robot_camera/after_picture(mob/user, datum/picture/picture)
	var/mob/living/silicon/robot/C = loc
	if(istype(C) && istype(C.connected_ai))
		var/number = C.connected_ai.aicamera.stored.len
		picture.picture_name = "Изображение [number] (снято в [loc.name])"
		C.connected_ai.aicamera.stored[picture] = TRUE
		to_chat(usr, "<span class='unconscious'>Изображение записано в базе данных.</span>")
	else
		var/number = stored.len
		picture.picture_name = "Изображение [number] (снято в [loc.name])"
		stored[picture] = TRUE
		to_chat(usr, "<span class='unconscious'>Изображение записано в локальной базе данных. Выгрузка будет произведена при подключении и синхронизации с ИИ.</span>")

/obj/item/camera/siliconcam/robot_camera/selectpicture(mob/user)
	var/mob/living/silicon/robot/R = loc
	if(istype(R) && R.connected_ai)
		R.picturesync()
		return R.connected_ai.aicamera.selectpicture(user)
	else
		return ..()

/obj/item/camera/siliconcam/robot_camera/proc/borgprint(mob/user)
	var/mob/living/silicon/robot/C = loc
	if(!istype(C) || C.toner < 20)
		to_chat(user, "<span class='warning'>Недостаточно тонера.</span>")
		return
	var/datum/picture/selection = selectpicture(user)
	if(!istype(selection))
		to_chat(user, "<span class='warning'>Неправильное изображение.</span>")
		return
	var/obj/item/photo/p = new /obj/item/photo(C.loc, selection)
	p.pixel_x = p.base_pixel_x + rand(-10, 10)
	p.pixel_y = p.base_pixel_y + rand(-10, 10)
	C.toner -= printcost	 //All fun allowed.
	visible_message("<span class='notice'>[C.name] выплёвывает фотографию из под своего днища.</span>")
	to_chat(usr, "<span class='notice'>Печатаю фотографию.</span>")

/obj/item/camera/siliconcam/proc/paiprint(mob/user)
	var/mob/living/silicon/pai/paimob = loc
	var/datum/picture/selection = selectpicture(user)
	if(!istype(selection))
		to_chat(user, "<span class='warning'>Invalid Image.</span>")
		return
	printpicture(user,selection)
	user.visible_message("<span class='notice'>A picture appears on top of the chassis of [paimob.name]!</span>", "<span class='notice'>You print a photograph.</span>")

#define INFINITE -1

/obj/item/autosurgeon
	name = "автохирург"
	desc = "Устройство с помощью которого можно автоматически ставить импланты, чипы скиллов, органы в пациента без проведения операций. \
	 		Нажми отверткой чтобы вытащить случайно вставленные предметы."
	icon = 'icons/obj/device.dmi'
	icon_state = "autoimplanter"
	inhand_icon_state = "nothing"
	w_class = WEIGHT_CLASS_SMALL

	var/uses = INFINITE

/obj/item/autosurgeon/attack_self_tk(mob/user)
	return //stops TK fuckery

/obj/item/autosurgeon/organ
	name = "имплант автохирурга"
	desc = "Устройство с помощью которого можно автоматически ставить импланты, чипы скиллов, органы в пациента без проведения операций.\
	 		Нажми отверткой чтобы вытащить случайно вставленные предметы."

	var/organ_type = /obj/item/organ
	var/starting_organ
	var/obj/item/organ/storedorgan

/obj/item/autosurgeon/organ/syndicate
	name = "подозрительный имплант автохирурга"
	icon_state = "syndicate_autoimplanter"

/obj/item/autosurgeon/organ/Initialize(mapload)
	. = ..()
	if(starting_organ)
		insert_organ(new starting_organ(src))

/obj/item/autosurgeon/organ/proc/insert_organ(obj/item/I)
	storedorgan = I
	I.forceMove(src)
	name = "[initial(name)] ([storedorgan.name])"

/obj/item/autosurgeon/organ/attack_self(mob/user)//when the object it used...
	if(!uses)
		to_chat(user, "<span class='alert'>[capitalize(src.name)] уже использован. Инструменты повисли и не включаются .</span>")
		return
	else if(!storedorgan)
		to_chat(user, "<span class='alert'>[capitalize(src.name)] внутри нет имплантов.</span>")
		return
	storedorgan.Insert(user)//insert stored organ into the user
	user.visible_message("<span class='notice'>[user] нажимает кнопку [src], слышен короткий механический писк.</span>", "<span class='notice'>Ты чувствуешь резкий укол когда [src] втыкается в твое тело.</span>")
	playsound(get_turf(user), 'sound/weapons/circsawhit.ogg', 50, TRUE)
	storedorgan = null
	name = initial(name)
	if(uses != INFINITE)
		uses--
	if(!uses)
		desc = "[initial(desc)] Кажется этим уже пользовались."

/obj/item/autosurgeon/organ/attackby(obj/item/I, mob/user, params)
	if(istype(I, organ_type))
		if(storedorgan)
			to_chat(user, "<span class='alert'>[capitalize(src.name)] внутри уже есть имплант.</span>")
			return
		else if(!uses)
			to_chat(user, "<span class='alert'>[capitalize(src.name)] уже был использован.</span>")
			return
		if(!user.transferItemToLoc(I, src))
			return
		storedorgan = I
		to_chat(user, "<span class='notice'>Ты кладешь [I] в [src].</span>")
	else
		return ..()

/obj/item/autosurgeon/organ/screwdriver_act(mob/living/user, obj/item/I)
	if(..())
		return TRUE
	if(!storedorgan)
		to_chat(user, "<span class='warning'>Внутри [src] нет импланта который я могу извлечь!</span>")
	else
		var/atom/drop_loc = user.drop_location()
		for(var/J in src)
			var/atom/movable/AM = J
			AM.forceMove(drop_loc)

		to_chat(user, "<span class='notice'>Я извлек [storedorgan] из [src].</span>")
		I.play_tool_sound(src)
		storedorgan = null
		if(uses != INFINITE)
			uses--
		if(!uses)
			desc = "[initial(desc)] Кажется им уже воспользовались."
	return TRUE

/obj/item/autosurgeon/organ/cmo
	desc = "Одноразовый автохирург с имплантом медицинского дисплея. Из него можно вытащить импланты отвёрткой, но обратно их уже не вставить."
	uses = 1
	starting_organ = /obj/item/organ/cyberimp/eyes/hud/medical

/obj/item/autosurgeon/organ/syndicate/laser_arm
	desc = "Одноразовый автохирург с имплантом боевого лазера. Из него можно вытащить импланты отвёрткой, но обратно их уже не вставить"
	uses = 1
	starting_organ = /obj/item/organ/cyberimp/arm/gun/laser

/obj/item/autosurgeon/organ/syndicate/thermal_eyes
	starting_organ = /obj/item/organ/eyes/robotic/thermals

/obj/item/autosurgeon/organ/syndicate/xray_eyes
	starting_organ = /obj/item/organ/eyes/robotic/xray

/obj/item/autosurgeon/organ/syndicate/anti_stun
	starting_organ = /obj/item/organ/cyberimp/brain/anti_stun

/obj/item/autosurgeon/organ/syndicate/reviver
	starting_organ = /obj/item/organ/cyberimp/chest/reviver

/obj/item/autosurgeon/skillchip
	name = "автохирург чипов навыков"
	desc = "Устройство которое автоматически вживляет чипы умений в мозг цели, без необходимости проводить операцию. \
	 		В нем есть слот под чип навыка, используй отвертку чтобы вытащить случайно вставленные предметы."
	var/skillchip_type = /obj/item/skillchip
	var/starting_skillchip
	var/obj/item/skillchip/stored_skillchip

/obj/item/autosurgeon/skillchip/syndicate
	name = "подозрительный автохирург чипов навыков"
	icon_state = "syndicate_autoimplanter"

/obj/item/autosurgeon/skillchip/Initialize(mapload)
	. = ..()
	if(starting_skillchip)
		insert_skillchip(new starting_skillchip(src))

/obj/item/autosurgeon/skillchip/proc/insert_skillchip(obj/item/skillchip/skillchip)
	if(!istype(skillchip))
		return
	stored_skillchip = skillchip
	skillchip.forceMove(src)
	name = "[initial(name)] ([stored_skillchip.name])"

/obj/item/autosurgeon/skillchip/attack_self(mob/living/carbon/user)//when the object it used...
	if(!uses)
		to_chat(user, "<span class='alert'>[capitalize(src.name)] уже был использован. Инструменты висят и не включаются..</span>")
		return

	if(!stored_skillchip)
		to_chat(user, "<span class='alert'>Внутри [capitalize(src.name)]  нет чипа навыков.</span>")
		return

	if(!istype(user))
		to_chat(user, "<span class='alert'>В мозг [user] нельзя установить чип навыков..</span>")
		return

	// Try implanting.
	var/implant_msg = user.implant_skillchip(stored_skillchip)
	if(implant_msg)
		user.visible_message("<span class='notice'>[user] нажимает кнопку на [src], но ничего не происходит.</span>", "<span class='notice'> [src] издаёт тихий писк, означающий какую-то ошибку.</span>")
		to_chat(user, "<span class='alert'>[stored_skillchip] нельзя вживить. [implant_msg]</span>")
		return

	// Clear the stored skillchip, it's technically not in this machine anymore.
	var/obj/item/skillchip/implanted_chip = stored_skillchip
	stored_skillchip = null

	user.visible_message("<span class='notice'>[user] нажимает кнопку на [src], и слышится короткий механический звук.</span>", "<span class='notice'>Ты чувствуешь резкий укол, когда [src] втыкается в твой мозг.</span>")
	playsound(get_turf(user), 'sound/weapons/circsawhit.ogg', 50, TRUE)

	to_chat(user,"<span class='notice'Операция завершена! [implanted_chip] успешно вживлен! Попытка автоматической активации...</span>")

	// If implanting succeeded, try activating - Although activating isn't required, so don't early return if it fails.
	// The user can always go activate it at a skill station.
	var/activate_msg = implanted_chip.try_activate_skillchip(FALSE, FALSE)
	if(activate_msg)
		to_chat(user, "<span class='alert'>[implanted_chip] нельзя активировать. [activate_msg]</span>")

	name = initial(name)

	if(uses != INFINITE)
		uses--

	if(!uses)
		desc = "[initial(desc)] Хирургические инструменты выглядят слишком затупленными чтобы пробить череп. Похоже ими уже воспользовались."

/obj/item/autosurgeon/skillchip/attackby(obj/item/I, mob/user, params)
	if(!istype(I, skillchip_type))
		return ..()

	if(stored_skillchip)
		to_chat(user, "<span class='alert'>Внутри [capitalize(src.name)] уже есть чип навыка.</span>")
		return

	if(!uses)
		to_chat(user, "<span class='alert'>[capitalize(src.name)] уже использован.</span>")
		return

	if(!user.transferItemToLoc(I, src))
		to_chat(user, "<span class='alert'>У меня не получилось вставить чип в [src]. Кажется он застрял у меня в руке.</span>")
		return

	stored_skillchip = I
	to_chat(user, "<span class='notice'>Я вставил [I] в [src].</span>")

/obj/item/autosurgeon/skillchip/screwdriver_act(mob/living/user, obj/item/I)
	. = ..()
	if(.)
		return

	if(!stored_skillchip)
		to_chat(user, "<span class='warning'>Внутри [src] нет чипа который я могу извлечь!</span>")
		return TRUE

	var/atom/drop_loc = user.drop_location()
	for(var/thing in contents)
		var/atom/movable/movable_content = thing
		movable_content.forceMove(drop_loc)

	to_chat(user, "<span class='notice'>Успешно извлек [stored_skillchip] из [src].</span>")
	I.play_tool_sound(src)
	stored_skillchip = null

	if(uses != INFINITE)
		uses--

	if(!uses)
		desc = "[initial(desc)] Кажется им уже пользовались."

	return TRUE

/obj/item/autosurgeon/skillchip/syndicate/chameleon_chip
	desc = "Одноразовый авто хирург с Синдикатовским чипом навыков. Используй отвертку чтобы вытащить чип, но назад вставить его уже нельзя будет."
	uses = 1
	starting_skillchip = /obj/item/skillchip/chameleon

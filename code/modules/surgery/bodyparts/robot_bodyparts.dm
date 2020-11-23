#define ROBOTIC_LIGHT_BRUTE_MSG "поврежденная"
#define ROBOTIC_MEDIUM_BRUTE_MSG "помятая"
#define ROBOTIC_HEAVY_BRUTE_MSG "разваливающийся"

#define ROBOTIC_LIGHT_BURN_MSG "обгоревшая"
#define ROBOTIC_MEDIUM_BURN_MSG "обугленная"
#define ROBOTIC_HEAVY_BURN_MSG "тлеющая"

//For ye whom may venture here, split up arm / hand sprites are formatted as "l_hand" & "l_arm".
//The complete sprite (displayed when the limb is on the ground) should be named "borg_l_arm".
//Failure to follow this pattern will cause the hand's icons to be missing due to the way get_limb_icon() works to generate the mob's icons using the aux_zone var.

/obj/item/bodypart/l_arm/robot
	name = "левая рука киборга"
	desc = "Скелетная конечность, обернутая в псевдомышцы с низкопроводимостью."
	attack_verb_continuous = list("шлёпает", "бьёт")
	attack_verb_simple = list("шлёпает", "бьёт")
	inhand_icon_state = "buildpipe"
	icon = 'icons/mob/augmentation/augments.dmi'
	flags_1 = CONDUCT_1
	icon_state = "borg_l_arm"
	status = BODYPART_ROBOTIC
	disable_threshold = 1

	brute_reduction = 5
	burn_reduction = 4

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

/obj/item/bodypart/r_arm/robot
	name = "правая рука киборга"
	desc = "Скелетная конечность, обернутая в псевдомышцы с низкопроводимостью."
	attack_verb_continuous = list("шлёпает", "бьёт")
	attack_verb_simple = list("шлёпает", "бьёт")
	inhand_icon_state = "buildpipe"
	icon = 'icons/mob/augmentation/augments.dmi'
	flags_1 = CONDUCT_1
	icon_state = "borg_r_arm"
	status = BODYPART_ROBOTIC
	disable_threshold = 1

	brute_reduction = 5
	burn_reduction = 4

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

/obj/item/bodypart/l_leg/robot
	name = "левая нога киборга"
	desc = "Скелетная конечность, обернутая в псевдомышцы с низкопроводимостью."
	attack_verb_continuous = list("пинает", "давит")
	attack_verb_simple = list("пинает", "давит")
	inhand_icon_state = "buildpipe"
	icon = 'icons/mob/augmentation/augments.dmi'
	flags_1 = CONDUCT_1
	icon_state = "borg_l_leg"
	status = BODYPART_ROBOTIC
	disable_threshold = 1

	brute_reduction = 5
	burn_reduction = 4

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

/obj/item/bodypart/r_leg/robot
	name = "правая нога киборга"
	desc = "Скелетная конечность, обернутая в псевдомышцы с низкопроводимостью."
	attack_verb_continuous = list("пинает", "давит")
	attack_verb_simple = list("пинает", "давит")
	inhand_icon_state = "buildpipe"
	icon = 'icons/mob/augmentation/augments.dmi'
	flags_1 = CONDUCT_1
	icon_state = "borg_r_leg"
	status = BODYPART_ROBOTIC
	disable_threshold = 1

	brute_reduction = 5
	burn_reduction = 4

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

/obj/item/bodypart/chest/robot
	name = "туловище киборга"
	desc = "Тяжело укрепленный корпус, содержащий логические платы киборга, с отверстием под стандартную ячейку питания."
	inhand_icon_state = "buildpipe"
	icon = 'icons/mob/augmentation/augments.dmi'
	flags_1 = CONDUCT_1
	icon_state = "borg_chest"
	status = BODYPART_ROBOTIC

	brute_reduction = 5
	burn_reduction = 4

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	var/wired = FALSE
	var/obj/item/stock_parts/cell/cell = null

/obj/item/bodypart/chest/robot/get_cell()
	return cell

/obj/item/bodypart/chest/robot/handle_atom_del(atom/A)
	if(A == cell)
		cell = null
	return ..()

/obj/item/bodypart/chest/robot/Destroy()
	QDEL_NULL(cell)
	return ..()

/obj/item/bodypart/chest/robot/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/stock_parts/cell))
		if(cell)
			to_chat(user, "<span class='warning'>Я уже вставил ячейку питания!</span>")
			return
		else
			if(!user.transferItemToLoc(W, src))
				return
			cell = W
			to_chat(user, "<span class='notice'>Я вставил ячейку питания.</span>")
	else if(istype(W, /obj/item/stack/cable_coil))
		if(wired)
			to_chat(user, "<span class='warning'>Я уже вставил провод!</span>")
			return
		var/obj/item/stack/cable_coil/coil = W
		if (coil.use(1))
			wired = TRUE
			to_chat(user, "<span class='notice'>Я вставил провод.</span>")
		else
			to_chat(user, "<span class='warning'>Мне нужен 1 кусок провода, чтобы присоединить его сюда!</span>")
	else
		return ..()

/obj/item/bodypart/chest/robot/wirecutter_act(mob/living/user, obj/item/I)
	. = ..()
	if(!wired)
		return
	. = TRUE
	I.play_tool_sound(src)
	to_chat(user, "<span class='notice'>Я отрезаю провода в [src].</span>")
	new /obj/item/stack/cable_coil(drop_location(), 1)
	wired = FALSE

/obj/item/bodypart/chest/robot/screwdriver_act(mob/living/user, obj/item/I)
	..()
	. = TRUE
	if(!cell)
		to_chat(user, "<span class='warning'>В [src] не установлен источник питания!</span>")
		return
	I.play_tool_sound(src)
	to_chat(user, "<span class='notice'>Извлечь [cell] из [src].</span>")
	cell.forceMove(drop_location())
	cell = null


/obj/item/bodypart/chest/robot/examine(mob/user)
	. = ..()
	if(cell)
		. += {"<hr>Имеет вставленный [cell].\n
		<span class='info'>Вы можете использовать <b>отвертку</b> чтобы извлечь [cell].</span>"}
	else
		. += "<hr><span class='info'>Имеет пустой слот для <b>ячейки питания</b>.</span>"
	if(wired)
		. += "<hr>Всё подключено [cell ? " и готово для использования" : ""].\n"+\
		"<span class='info'>Вы можете использовать <b>кусачки</b> чтобы извлечь проводку.</span>"
	else
		. += "<hr><span class='info'>Имеет пару гнезд, которые необходимо <b>подключить</b>.</span>"

/obj/item/bodypart/chest/robot/drop_organs(mob/user, violent_removal)
	if(wired)
		new /obj/item/stack/cable_coil(drop_location(), 1)
		wired = FALSE
	if(cell)
		cell.forceMove(drop_location())
		cell = null
	..()


/obj/item/bodypart/head/robot
	name = "голова киборга"
	desc = "Стандартная укрепленная черепная коробка, с подключаемой к позвоночнику нейронным сокетом и сенсорными стыковочными узлами."
	inhand_icon_state = "buildpipe"
	icon = 'icons/mob/augmentation/augments.dmi'
	flags_1 = CONDUCT_1
	icon_state = "borg_head"
	status = BODYPART_ROBOTIC

	brute_reduction = 5
	burn_reduction = 4

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	var/obj/item/assembly/flash/handheld/flash1 = null
	var/obj/item/assembly/flash/handheld/flash2 = null


/obj/item/bodypart/head/robot/handle_atom_del(atom/A)
	if(A == flash1)
		flash1 = null
	if(A == flash2)
		flash2 = null
	return ..()

/obj/item/bodypart/head/robot/Destroy()
	QDEL_NULL(flash1)
	QDEL_NULL(flash2)
	return ..()

/obj/item/bodypart/head/robot/examine(mob/user)
	. = ..()
	if(!flash1 && !flash2)
		. += "<hr><span class='info'>Имеет два свободных глазных слота для <b>вспышек</b>.</span>"
	else
		var/single_flash = FALSE
		if(!flash1 || !flash2)
			single_flash = TRUE
			. += {"<hr>Один из глазных разъемов на данный момент занят вспышкой.\n
			<span class='info'>В нем есть еще один свободный разъем под <b>вспышку</b>.</span>"}
		else
			. += "<hr>Оба глазных разъема заняты вспышками."
		. += "\n<span class='notice'>Я могу извлечь установленную [single_flash ? "вспышку":"вспышки"] при помощи <b>ломика</b>.</span>"

/obj/item/bodypart/head/robot/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/assembly/flash/handheld))
		var/obj/item/assembly/flash/handheld/F = W
		if(flash1 && flash2)
			to_chat(user, "<span class='warning'>Я уже вставил глаза!</span>")
			return
		else if(F.burnt_out)
			to_chat(user, "<span class='warning'>Я не могу использовать сломанную вспышку!</span>")
			return
		else
			if(!user.transferItemToLoc(F, src))
				return
			if(flash1)
				flash2 = F
			else
				flash1 = F
			to_chat(user, "<span class='notice'>Я вставил вспышку в глазной разъем.</span>")
			return
	return ..()

/obj/item/bodypart/head/robot/crowbar_act(mob/living/user, obj/item/I)
	..()
	if(flash1 || flash2)
		I.play_tool_sound(src)
		to_chat(user, "<span class='notice'>Я извлек вспышку из [src].</span>")
		if(flash1)
			flash1.forceMove(drop_location())
			flash1 = null
		if(flash2)
			flash2.forceMove(drop_location())
			flash2 = null
	else
		to_chat(user, "<span class='warning'>В [src] нет вспышки которую можно извлечь.</span>")
	return TRUE


/obj/item/bodypart/head/robot/drop_organs(mob/user, violent_removal)
	if(flash1)
		flash1.forceMove(user.loc)
		flash1 = null
	if(flash2)
		flash2.forceMove(user.loc)
		flash2 = null
	..()




/obj/item/bodypart/l_arm/robot/surplus
	name = "бюджетный протез левой руки"
	desc = "Скелетная робото-конечность. Устаревшая и хрупкая, но всё же лучше чем ничего."
	icon = 'icons/mob/augmentation/surplus_augments.dmi'
	brute_reduction = 0
	burn_reduction = 0
	max_damage = 20

/obj/item/bodypart/r_arm/robot/surplus
	name = "бюджетный протез правой руки"
	desc = "Скелетная робото-конечность. Устаревшая и хрупкая, но всё же лучше чем ничего."
	icon = 'icons/mob/augmentation/surplus_augments.dmi'
	brute_reduction = 0
	burn_reduction = 0
	max_damage = 20

/obj/item/bodypart/l_leg/robot/surplus
	name = "бюджетный протез левой ноги"
	desc = "Скелетная робото-конечность. Устаревшая и хрупкая, но всё же лучше чем ничего."
	icon = 'icons/mob/augmentation/surplus_augments.dmi'
	brute_reduction = 0
	burn_reduction = 0
	max_damage = 20

/obj/item/bodypart/r_leg/robot/surplus
	name = "бюджетный протез правой ноги"
	desc = "Скелетная робото-конечность. Устаревшая и хрупкая, но всё же лучше чем ничего."
	icon = 'icons/mob/augmentation/surplus_augments.dmi'
	brute_reduction = 0
	burn_reduction = 0
	max_damage = 20


#undef ROBOTIC_LIGHT_BRUTE_MSG
#undef ROBOTIC_MEDIUM_BRUTE_MSG
#undef ROBOTIC_HEAVY_BRUTE_MSG

#undef ROBOTIC_LIGHT_BURN_MSG
#undef ROBOTIC_MEDIUM_BURN_MSG
#undef ROBOTIC_HEAVY_BURN_MSG

//Bot Construction

/obj/item/bot_assembly
	icon = 'icons/mob/aibots.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	force = 3
	throw_speed = 2
	throw_range = 5
	var/created_name
	var/build_step = ASSEMBLY_FIRST_STEP
	var/robot_arm = /obj/item/bodypart/r_arm/robot

/obj/item/bot_assembly/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/pen))
		rename_bot()
		return

/obj/item/bot_assembly/proc/rename_bot()
	var/t = sanitize_name(stripped_input(usr, "Новое имя робота", name, created_name,MAX_NAME_LEN), allow_numbers = TRUE)
	if(!t)
		return
	if(!in_range(src, usr) && loc != usr)
		return
	created_name = t

/**
 * Checks if the user can finish constructing a bot with a given item.
 *
 * Arguments:
 * * I - Item to be used
 * * user - Mob doing the construction
 * * drop_item - Whether or no the item should be dropped; defaults to 1. Should be set to 0 if the item is a tool, stack, or otherwise doesn't need to be dropped. If not set to 0, item must be deleted afterwards.
 */
/obj/item/bot_assembly/proc/can_finish_build(obj/item/I, mob/user, drop_item = 1)
	if(istype(loc, /obj/item/storage/backpack))
		to_chat(user, span_warning("Не получится собрать [src.name] в [loc]!"))
		return FALSE
	if(!I || !user || (drop_item && !user.temporarilyRemoveItemFromInventory(I)))
		return FALSE
	return TRUE

//Cleanbot assembly
/obj/item/bot_assembly/cleanbot
	name = "неполная сборка клинбота"
	desc = "Простое ведёрко с сенсором движения."
	icon_state = "bucket_proxy"
	throwforce = 5
	created_name = "Клинбот"

/obj/item/bot_assembly/cleanbot/attackby(obj/item/W, mob/user, params)
	..()
	if(istype(W, /obj/item/bodypart/l_arm/robot) || istype(W, /obj/item/bodypart/r_arm/robot))
		if(!can_finish_build(W, user))
			return
		var/mob/living/simple_animal/bot/cleanbot/A = new(drop_location())
		A.name = created_name
		A.robot_arm = W.type
		to_chat(user, span_notice("Добавляю [W] к [src.name]. Бип буп!"))
		qdel(W)
		qdel(src)


//Edbot Assembly
/obj/item/bot_assembly/ed209
	name = "Эндоскелет ED-209"
	desc = "Какая-то причудливая конструкция."
	icon_state = "ed209_frame"
	inhand_icon_state = "ed209_frame"
	created_name = "ED-209 Боевой Робот" //To preserve the name if it's a unique securitron I guess
	var/lasercolor = ""
	var/vest_type = /obj/item/clothing/suit/armor/vest

/obj/item/bot_assembly/ed209/attackby(obj/item/W, mob/user, params)
	..()
	switch(build_step)
		if(ASSEMBLY_FIRST_STEP, ASSEMBLY_SECOND_STEP)
			if(istype(W, /obj/item/bodypart/l_leg/robot) || istype(W, /obj/item/bodypart/r_leg/robot))
				if(!user.temporarilyRemoveItemFromInventory(W))
					return
				to_chat(user, span_notice("Добавляю [W] к [src.name]."))
				qdel(W)
				name = "эндоскелет ED-209"
				if(build_step == ASSEMBLY_FIRST_STEP)
					inhand_icon_state = "ed209_leg"
					icon_state = "ed209_leg"
				else
					inhand_icon_state = "ed209_legs"
					icon_state = "ed209_legs"
				build_step++

		if(ASSEMBLY_THIRD_STEP)
			if(istype(W, /obj/item/clothing/suit/armor/vest))
				if(!user.temporarilyRemoveItemFromInventory(W))
					return
				to_chat(user, span_notice("Добавляю [W] к [src.name]."))
				qdel(W)
				name = "эндоскелет ED-209 c бронежилетом"
				inhand_icon_state = "ed209_shell"
				icon_state = "ed209_shell"
				build_step++

		if(ASSEMBLY_FOURTH_STEP)
			if(W.tool_behaviour == TOOL_WELDER)
				if(W.use_tool(src, user, 0, volume=40))
					name = "эндоскелет ED-209 c приваренным бронежилетом"
					to_chat(user, span_notice("Привариваю бронежилет к [src.name]."))
					build_step++

		if(ASSEMBLY_FIFTH_STEP)
			if(istype(W, /obj/item/clothing/head/helmet))
				if(!user.temporarilyRemoveItemFromInventory(W))
					return
				to_chat(user, span_notice("Добавляю [W] к [src.name]."))
				qdel(W)
				name = "эндоскелет ED-209 с приваренным бронежилетом и шлемом"
				inhand_icon_state = "ed209_hat"
				icon_state = "ed209_hat"
				build_step++

		if(5)
			if(isprox(W))
				if(!user.temporarilyRemoveItemFromInventory(W))
					return
				build_step++
				to_chat(user, span_notice("Добавляю [W] к [src.name]."))
				qdel(W)
				name = "Почти готовый ED-209"
				inhand_icon_state = "ed209_prox"
				icon_state = "ed209_prox"

		if(6)
			if(istype(W, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/coil = W
				if(coil.get_amount() < 1)
					to_chat(user, span_warning("Мне потребуется кабель для сборки ED-209!"))
					return
				to_chat(user, span_notice("Подключаю сенсоры ED-209..."))
				if(do_after(user, 40, target = src))
					if(coil.get_amount() >= 1 && build_step == 6)
						coil.use(1)
						to_chat(user, span_notice("Подключил сенсоры ED-209."))
						name = "Собранный ED-209 без оружия"
						build_step++

		if(7)
			if(istype(W, /obj/item/gun/energy/disabler))
				if(!user.temporarilyRemoveItemFromInventory(W))
					return
				name = "ED-209 с неприкрученным [W.name]"
				to_chat(user, span_notice("Добавляю [W] к [src.name]."))
				inhand_icon_state = "ed209_taser"
				icon_state = "ed209_taser"
				qdel(W)
				build_step++

		if(8)
			if(W.tool_behaviour == TOOL_SCREWDRIVER)
				to_chat(user, span_notice("Начинаю прикручивать дизейблер к роботу..."))
				if(W.use_tool(src, user, 40, volume=100))
					var/mob/living/simple_animal/bot/secbot/ed209/B = new(drop_location())
					B.name = created_name
					to_chat(user, span_notice("Завершаю сборку робота ED-209."))
					qdel(src)

//Floorbot assemblies
/obj/item/bot_assembly/floorbot
	name = "плитка в ящике с инструментами"
	desc = "Ящик для инструментов с торчащими сверху плитками."
	icon_state = "toolbox_tiles"
	throwforce = 10
	created_name = "Флурбот"
	var/toolbox = /obj/item/storage/toolbox/mechanical
	var/toolbox_color = "" //Blank for blue, r for red, y for yellow, etc.

/obj/item/bot_assembly/floorbot/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/bot_assembly/floorbot/update_icon()
	..()
	switch(build_step)
		if(ASSEMBLY_FIRST_STEP)
			desc = initial(desc)
			name = initial(name)
			icon_state = "[toolbox_color]toolbox_tiles"

		if(ASSEMBLY_SECOND_STEP)
			name = "ящик для инструментов с плиткой и датчиком"
			desc = "Странная конструкция из ящика для инструментов, плитки и универсального датчика."
			icon_state = "[toolbox_color]toolbox_tiles_sensor"

/obj/item/bot_assembly/floorbot/attackby(obj/item/W, mob/user, params)
	..()
	switch(build_step)
		if(ASSEMBLY_FIRST_STEP)
			if(isprox(W))
				if(!user.temporarilyRemoveItemFromInventory(W))
					return
				to_chat(user, span_notice("Добавляю [W] к [src.name]."))
				qdel(W)
				build_step++
				update_icon()

		if(ASSEMBLY_SECOND_STEP)
			if(istype(W, /obj/item/bodypart/l_arm/robot) || istype(W, /obj/item/bodypart/r_arm/robot))
				if(!can_finish_build(W, user))
					return
				var/mob/living/simple_animal/bot/floorbot/A = new(drop_location(), toolbox_color)
				A.name = created_name
				A.robot_arm = W.type
				A.toolbox = toolbox
				to_chat(user, span_notice("Добавляю [W] к [src.name]. Boop beep!"))
				qdel(W)
				qdel(src)


//Medbot Assembly
/obj/item/bot_assembly/medbot
	name = "разобранный медбот"
	desc = "Аптечка с прикреплённой рукой робота."
	icon_state = "firstaid_arm"
	created_name = "Медбот" //To preserve the name if it's a unique medbot I guess
	var/skin = null //Same as medbot, set to tox or ointment for the respective kits.
	var/healthanalyzer = /obj/item/healthanalyzer
	var/firstaid = /obj/item/storage/firstaid

/obj/item/bot_assembly/medbot/proc/set_skin(skin)
	src.skin = skin
	if(skin)
		add_overlay("kit_skin_[skin]")

/obj/item/bot_assembly/medbot/attackby(obj/item/W, mob/user, params)
	..()
	switch(build_step)
		if(ASSEMBLY_FIRST_STEP)
			if(istype(W, /obj/item/healthanalyzer))
				if(!user.temporarilyRemoveItemFromInventory(W))
					return
				healthanalyzer = W.type
				to_chat(user, span_notice("Добавляю [W] к [src.name]."))
				qdel(W)
				name = "аптечка с прикреплённой рукой робота и медицинским анализатором "
				add_overlay("na_scanner")
				build_step++

		if(ASSEMBLY_SECOND_STEP)
			if(isprox(W))
				if(!can_finish_build(W, user))
					return
				qdel(W)
				var/mob/living/simple_animal/bot/medbot/S = new(drop_location(), skin)
				to_chat(user, span_notice("Завершаю сборку Медбота. Бип буп!"))
				S.name = created_name
				S.firstaid = firstaid
				S.robot_arm = robot_arm
				S.healthanalyzer = healthanalyzer
				var/obj/item/storage/firstaid/FA = firstaid
				S.damagetype_healer = initial(FA.damagetype_healed) ? initial(FA.damagetype_healed) : BRUTE
				qdel(src)


//Honkbot Assembly
/obj/item/bot_assembly/honkbot
	name = "разобранный хонкбот"
	desc = "Преступление против человечества в процессе..."
	icon_state = "honkbot_arm"
	created_name = "Хонкбот"

/obj/item/bot_assembly/honkbot/attackby(obj/item/I, mob/user, params)
	..()
	switch(build_step)
		if(ASSEMBLY_FIRST_STEP)
			if(isprox(I))
				if(!user.temporarilyRemoveItemFromInventory(I))
					return
				to_chat(user, span_notice("Добавляю [I] к [src.name]!"))
				icon_state = "honkbot_proxy"
				name = "разобранный хонкбот"
				qdel(I)
				build_step++

		if(ASSEMBLY_SECOND_STEP)
			if(istype(I, /obj/item/bikehorn))
				if(!can_finish_build(I, user))
					return
				to_chat(user, span_notice("Добавляю [I] к [src.name]! Хонк!"))
				var/mob/living/simple_animal/bot/honkbot/S = new(drop_location())
				S.name = created_name
				S.limiting_spam = TRUE // only long enough to hear the first ping.
				addtimer(CALLBACK (S, .mob/living/simple_animal/bot/honkbot/proc/react_ping), 5)
				S.bikehorn = I.type
				qdel(I)
				qdel(src)


//Secbot Assembly
/obj/item/bot_assembly/secbot
	name = "каркас секьюритрона"
	desc = "Gричудливая сборка из датчика движения, шлема и сигналлера."
	icon_state = "helmet_signaler"
	inhand_icon_state = "helmet"
	created_name = "Секьюритрон" //To preserve the name if it's a unique securitron I guess
	var/swordamt = 0 //If you're converting it into a grievousbot, how many swords have you attached
	var/toyswordamt = 0 //honk

/obj/item/bot_assembly/secbot/attackby(obj/item/I, mob/user, params)
	..()
	var/atom/Tsec = drop_location()
	switch(build_step)
		if(ASSEMBLY_FIRST_STEP)
			if(I.tool_behaviour == TOOL_WELDER)
				if(I.use_tool(src, user, 0, volume=40))
					add_overlay("hs_hole")
					to_chat(user, span_notice("Завариваю дырку в [src.name]!"))
					build_step++

			else if(I.tool_behaviour == TOOL_SCREWDRIVER) //deconstruct
				new /obj/item/assembly/signaler(Tsec)
				new /obj/item/clothing/head/helmet/sec(Tsec)
				to_chat(user, span_notice("Отключаю радио."))
				qdel(src)

		if(ASSEMBLY_SECOND_STEP)
			if(isprox(I))
				if(!user.temporarilyRemoveItemFromInventory(I))
					return
				to_chat(user, span_notice("Добавляю [I] к [src.name]!"))
				add_overlay("hs_eye")
				name = "каркас секьюритрона с сигналлером и сенсором"
				qdel(I)
				build_step++

			else if(I.tool_behaviour == TOOL_WELDER) //deconstruct
				if(I.use_tool(src, user, 0, volume=40))
					cut_overlay("hs_hole")
					to_chat(user, span_notice("Завариваю дырку в [src.name]!"))
					build_step--

		if(ASSEMBLY_THIRD_STEP)
			if((istype(I, /obj/item/bodypart/l_arm/robot)) || (istype(I, /obj/item/bodypart/r_arm/robot)))
				if(!user.temporarilyRemoveItemFromInventory(I))
					return
				to_chat(user, span_notice("Добавляю [I] к [src.name]!"))
				name = "каркас секьюритрона с сигналлером, сенсором и рукой робота"
				add_overlay("hs_arm")
				robot_arm = I.type
				qdel(I)
				build_step++

			else if(I.tool_behaviour == TOOL_SCREWDRIVER) //deconstruct
				cut_overlay("hs_eye")
				new /obj/item/assembly/prox_sensor(Tsec)
				to_chat(user, span_notice("Отсоединяю датчик движения от [src.name]."))
				build_step--

		if(ASSEMBLY_FOURTH_STEP)
			if(istype(I, /obj/item/melee/baton))
				if(!can_finish_build(I, user))
					return
				to_chat(user, span_notice("Завершаю сборку секьюритрона! Бип буп."))
				var/mob/living/simple_animal/bot/secbot/S = new(Tsec)
				S.name = created_name
				S.baton_type = I.type
				S.robot_arm = robot_arm
				qdel(I)
				qdel(src)
			if(I.tool_behaviour == TOOL_WRENCH)
				to_chat(user, span_notice("Перепрограммирую руку [src.name] на использование оружия."))
				build_step ++
				return
			if(istype(I, /obj/item/toy/sword))
				if(toyswordamt < 3 && swordamt <= 0)
					if(!user.temporarilyRemoveItemFromInventory(I))
						return
					created_name = "Генерал Бипскай"
					name = "каркас секьюритрона с сигналлером, сенсором, рукой робота и игрушечным мечом"
					icon_state = "grievous_assembly"
					to_chat(user, span_notice("Прикрепляю [I] к одной из рук [src.name]."))
					qdel(I)
					toyswordamt ++
				else
					if(!can_finish_build(I, user))
						return
					to_chat(user, span_notice("Завершаю сборку секьюритрона... Кажется, что-то пошло не так..."))
					var/mob/living/simple_animal/bot/secbot/grievous/toy/S = new(Tsec)
					S.name = created_name
					S.robot_arm = robot_arm
					qdel(I)
					qdel(src)

			else if(I.tool_behaviour == TOOL_SCREWDRIVER) //deconstruct
				cut_overlay("hs_arm")
				var/obj/item/bodypart/dropped_arm = new robot_arm(Tsec)
				robot_arm = null
				to_chat(user, span_notice("Убираю [dropped_arm] из [src.name]."))
				build_step--
				if(toyswordamt > 0 || toyswordamt)
					toyswordamt = 0
					icon_state = initial(icon_state)
					to_chat(user, span_notice("Прикленные к [src.name] игрушечные мечи отваливаются!"))
					for(var/IS in 1 to toyswordamt)
						new /obj/item/toy/sword(Tsec)

		if(ASSEMBLY_FIFTH_STEP)
			if(istype(I, /obj/item/melee/energy/sword/saber))
				if(swordamt < 3)
					if(!user.temporarilyRemoveItemFromInventory(I))
						return
					created_name = "Генерал Бипскай"
					name = "каркас секьюритрона с сигналлером, сенсором, рукой робота и энергомечом" //не нашёл места, куда можно было бы вклеить шутку про тобi пiзда
					icon_state = "grievous_assembly"
					to_chat(user, span_notice("Прикрепляю [I] к одной из рук [src.name]."))
					qdel(I)
					swordamt ++
				else
					if(!can_finish_build(I, user))
						return
					to_chat(user, span_notice("Завершаю сборку Секьюритрона!... Возможно, стоит отойти подальше."))
					var/mob/living/simple_animal/bot/secbot/grievous/S = new(Tsec)
					S.name = created_name
					S.robot_arm = robot_arm
					qdel(I)
					qdel(src)
			else if(I.tool_behaviour == TOOL_SCREWDRIVER) //deconstruct
				build_step--
				swordamt = 0
				icon_state = initial(icon_state)
				to_chat(user, span_notice("Откручиваю энергомечи [src.name]."))
				for(var/IS in 1 to swordamt)
					new /obj/item/melee/energy/sword/saber(Tsec)


//Firebot Assembly
/obj/item/bot_assembly/firebot
	name = "каркас пожарного бота"
	desc = "Огнетушитель с прикрепленной к нему рукой. Интересно."
	icon_state = "firebot_arm"
	created_name = "пожарный бот"

/obj/item/bot_assembly/firebot/attackby(obj/item/I, mob/user, params)
	..()
	switch(build_step)
		if(ASSEMBLY_FIRST_STEP)
			if(istype(I, /obj/item/clothing/head/hardhat/red))
				if(!user.temporarilyRemoveItemFromInventory(I))
					return
				to_chat(user,span_notice("Добавляю [I] к [src.name]!"))
				icon_state = "firebot_helmet"
				desc = "Огнетушитель с робо-рукой и пожарным шлемом."
				qdel(I)
				build_step++

		if(ASSEMBLY_SECOND_STEP)
			if(isprox(I))
				if(!can_finish_build(I, user))
					return
				to_chat(user, span_notice("Добавляю [I] к [src.name], завершая сборку пожарный бота."))
				var/mob/living/simple_animal/bot/firebot/F = new(drop_location())
				F.name = created_name
				qdel(I)
				qdel(src)

//Get cleaned
/obj/item/bot_assembly/hygienebot
	name = "каркас гигиенобота"
	desc = "Очистить болото раз и навсегда."
	icon_state = "hygienebot"
	created_name = "Гигиенобот"

/obj/item/bot_assembly/hygienebot/attackby(obj/item/I, mob/user, params)
	. = ..()
	var/atom/Tsec = drop_location()
	switch(build_step)
		if(ASSEMBLY_FIRST_STEP)
			if(I.tool_behaviour == TOOL_WELDER) //Construct
				if(I.use_tool(src, user, 0, volume=40))
					to_chat(user, span_notice("Проделываю отверстие для воды в [src.name]!"))
					build_step++
					return
			if(I.tool_behaviour == TOOL_WRENCH) //Deconstruct
				if(I.use_tool(src, user, 0, volume=40))
					new /obj/item/stack/sheet/iron(Tsec, 2)
					to_chat(user, span_notice("Разбираю каркас гигиенобота."))
					qdel(src)

		if(ASSEMBLY_SECOND_STEP)
			if(isprox(I)) //Construct
				if(!user.temporarilyRemoveItemFromInventory(I))
					return
				build_step++
				to_chat(user, span_notice("Добавляю [I] к [src.name]."))
				qdel(I)
			if(I.tool_behaviour == TOOL_WELDER) //Deconstruct
				if(I.use_tool(src, user, 0, volume=30))
					to_chat(user, span_notice("Завариваю дырку в [src.name]!"))
					build_step--
					return

		if(ASSEMBLY_THIRD_STEP)
			if(!can_finish_build(I, user, 0))
				return
			if(istype(I, /obj/item/stack/ducts)) //Construct
				var/obj/item/stack/ducts/D = I
				if(D.get_amount() < 1)
					to_chat(user, span_warning("Мне нужна один кусок трубы, чтобы завершить сборку [src.name]"))
					return
				to_chat(user, span_notice("Начинаю подключать систему орошения [src.name]..."))
				if(do_after(user, 40, target = src) && D.use(1))
					to_chat(user, span_notice("Подключаю систему орошения [src.name]."))
					var/mob/living/simple_animal/bot/hygienebot/H = new(drop_location())
					H.name = created_name
					qdel(src)
			if(I.tool_behaviour == TOOL_SCREWDRIVER) //deconstruct
				new /obj/item/assembly/prox_sensor(Tsec)
				to_chat(user, span_notice("Отключаю датчик движения от [src.name]."))
				build_step--

//Atmosbot Assembly
/obj/item/bot_assembly/atmosbot
	name = "каркас атмосбота"
	desc = "Здесь уже есть анализатор"
	icon_state = "atmosbot_assembly"
	created_name = "Atmosbot"

/obj/item/bot_assembly/atmosbot/attackby(obj/item/I, mob/user, params)
	..()
	switch(build_step)
		if(ASSEMBLY_FIRST_STEP)
			if(istype(I, /obj/item/tank/internals))
				if(!user.temporarilyRemoveItemFromInventory(I))
					return
				to_chat(user,span_notice("Добавляю [I] к [src]!"))
				icon_state = "atmosbot_assembly_tank"
				desc = "Здесь уже есть баллон с газом."
				qdel(I)
				build_step++

		if(ASSEMBLY_SECOND_STEP)
			if(isprox(I))
				if(!can_finish_build(I, user))
					return
				to_chat(user, span_notice("Добавляю [I] к [src]! Бип-буп!"))
				var/mob/living/simple_animal/bot/atmosbot/A = new(drop_location())
				A.name = created_name
				qdel(I)
				qdel(src)

//Vim Assembly
/obj/item/bot_assembly/vim
	name = "каркас вима"
	desc = "Космошлем с ножками. Нужна вторая нога, похоже."
	icon_state = "vim_0"
	created_name = "Vim"

/obj/item/bot_assembly/vim/attackby(obj/item/part, mob/user, params)
	. = ..()
	if(.)
		return
	switch(build_step)
		if(ASSEMBLY_FIRST_STEP)
			if(istype(part, /obj/item/bodypart/l_leg/robot) || istype(part, /obj/item/bodypart/r_leg/robot))
				if(!user.temporarilyRemoveItemFromInventory(part))
					return
				balloon_alert(user, "нога установлена")
				icon_state = "vim_1"
				desc = "Незавершённый механизм. Нет фонарика."
				qdel(part)
				build_step++

		if(ASSEMBLY_SECOND_STEP)
			if(istype(part, /obj/item/flashlight))
				if(!user.temporarilyRemoveItemFromInventory(part))
					return
				balloon_alert(user, "фонарик установлен")
				icon_state = "vim_2"
				desc = "Незавершённый механизм. Фонарик не прикручен."
				qdel(part)
				build_step++

		if(ASSEMBLY_THIRD_STEP)
			if(part.tool_behaviour == TOOL_SCREWDRIVER)
				balloon_alert(user, "прикручиваем...")
				if(!part.use_tool(src, user, 4 SECONDS, volume=100))
					return
				balloon_alert(user, "фонарик прикручен")
				icon_state = "vim_3"
				desc = "Незавершённый механизм. Почти всё готово, осталось добавить голосовой модуль."
				build_step++

		if(ASSEMBLY_FOURTH_STEP)
			if(istype(part, /obj/item/assembly/voice))
				if(!can_finish_build(part, user))
					return
				balloon_alert(user, "сборка завершена")
				var/obj/vehicle/sealed/car/vim/new_vim = new(drop_location())
				new_vim.name = created_name
				qdel(part)
				qdel(src)

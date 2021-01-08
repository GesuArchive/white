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
		to_chat(user, "<span class='warning'>Не получится собрать [src.name] в [loc]!</span>")
		return FALSE
	if(!I || !user || (drop_item && !user.temporarilyRemoveItemFromInventory(I)))
		return FALSE
	return TRUE

//Cleanbot assembly
/obj/item/bot_assembly/cleanbot
	desc = "Это ведёрко с сенсором движения."
	name = "неполная сборка клинбота"
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
		to_chat(user, "<span class='notice'>Добавляю [W] к [src.name]. Бип буп!</span>")
		qdel(W)
		qdel(src)


//Edbot Assembly
/obj/item/bot_assembly/ed209
	name = "неполная сборка ED-209"
	desc = "Какая-то причудливая сборка."
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
				to_chat(user, "<span class='notice'>Добавляю [W] к [src.name].</span>")
				qdel(W)
				name = "ноги/рама сборка"
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
				to_chat(user, "<span class='notice'>Добавляю [W] к [src.name].</span>")
				qdel(W)
				name = "жилет/ноги/рама сборка"
				inhand_icon_state = "ed209_shell"
				icon_state = "ed209_shell"
				build_step++

		if(ASSEMBLY_FOURTH_STEP)
			if(W.tool_behaviour == TOOL_WELDER)
				if(W.use_tool(src, user, 0, volume=40))
					name = "почти готовая сборка"
					to_chat(user, "<span class='notice'>Привариваю бронежилет к [src.name].</span>")
					build_step++

		if(ASSEMBLY_FIFTH_STEP)
			if(istype(W, /obj/item/clothing/head/helmet))
				if(!user.temporarilyRemoveItemFromInventory(W))
					return
				to_chat(user, "<span class='notice'>Добавляю [W] к [src.name].</span>")
				qdel(W)
				name = "защищённая и почти готовая сборка"
				inhand_icon_state = "ed209_hat"
				icon_state = "ed209_hat"
				build_step++

		if(5)
			if(isprox(W))
				if(!user.temporarilyRemoveItemFromInventory(W))
					return
				build_step++
				to_chat(user, "<span class='notice'>Добавляю [W] к [src.name].</span>")
				qdel(W)
				name = "закрытая, защищённая, с сенсорами и почти готовая сборка"
				inhand_icon_state = "ed209_prox"
				icon_state = "ed209_prox"

		if(6)
			if(istype(W, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/coil = W
				if(coil.get_amount() < 1)
					to_chat(user, "<span class='warning'>Мне потребуется кабель для сборки ED-209!</span>")
					return
				to_chat(user, "<span class='notice'>Начинаю делать проводку [src.name]...</span>")
				if(do_after(user, 40, target = src))
					if(coil.get_amount() >= 1 && build_step == 6)
						coil.use(1)
						to_chat(user, "<span class='notice'>Добавляю проводку в [src.name].</span>")
						name = "совершенно точно почти готовая сборка ED-209"
						build_step++

		if(7)
			if(istype(W, /obj/item/gun/energy/disabler))
				if(!user.temporarilyRemoveItemFromInventory(W))
					return
				name = "[W.name] ED-209 сборка"
				to_chat(user, "<span class='notice'>Добавляю [W] к [src.name].</span>")
				inhand_icon_state = "ed209_taser"
				icon_state = "ed209_taser"
				qdel(W)
				build_step++

		if(8)
			if(W.tool_behaviour == TOOL_SCREWDRIVER)
				to_chat(user, "<span class='notice'>Начинаю прикреплять пушку к роботу...</span>")
				if(W.use_tool(src, user, 40, volume=100))
					var/mob/living/simple_animal/bot/secbot/ed209/B = new(drop_location())
					B.name = created_name
					to_chat(user, "<span class='notice'>Завершаю сборку робота ED-209.</span>")
					qdel(src)

//Floorbot assemblies
/obj/item/bot_assembly/floorbot
	desc = "Это ящик для инструментов с торчащими сверху плитками."
	name = "плитка и ящик с инструментами"
	icon_state = "toolbox_tiles"
	throwforce = 10
	created_name = "Флурбот"
	var/toolbox = /obj/item/storage/toolbox/mechanical
	var/toolbox_color = "" //Blank for blue, r for red, y for yellow, etc.

/obj/item/bot_assembly/floorbot/Initialize()
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
			desc = "Это ящик для инструментов с торчащими сверху плитками и прикрепленным датчиком."
			name = "неполная сборка флурбота"
			icon_state = "[toolbox_color]toolbox_tiles_sensor"

/obj/item/bot_assembly/floorbot/attackby(obj/item/W, mob/user, params)
	..()
	switch(build_step)
		if(ASSEMBLY_FIRST_STEP)
			if(isprox(W))
				if(!user.temporarilyRemoveItemFromInventory(W))
					return
				to_chat(user, "<span class='notice'>Добавляю [W] к [src.name].</span>")
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
				to_chat(user, "<span class='notice'>Добавляю [W] к [src.name]. Boop beep!</span>")
				qdel(W)
				qdel(src)


//Medbot Assembly
/obj/item/bot_assembly/medbot
	name = "неполная сборка медбота"
	desc = "Аптечка с привитой рукой робота."
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
				to_chat(user, "<span class='notice'>Добавляю [W] к [src.name].</span>")
				qdel(W)
				name = "аптечка/рука/анализатор сборка"
				add_overlay("na_scanner")
				build_step++

		if(ASSEMBLY_SECOND_STEP)
			if(isprox(W))
				if(!can_finish_build(W, user))
					return
				qdel(W)
				var/mob/living/simple_animal/bot/medbot/S = new(drop_location(), skin)
				to_chat(user, "<span class='notice'>Завершаю сборку Медбота. Бип буп!</span>")
				S.name = created_name
				S.firstaid = firstaid
				S.robot_arm = robot_arm
				S.healthanalyzer = healthanalyzer
				var/obj/item/storage/firstaid/FA = firstaid
				S.damagetype_healer = initial(FA.damagetype_healed) ? initial(FA.damagetype_healed) : BRUTE
				qdel(src)


//Honkbot Assembly
/obj/item/bot_assembly/honkbot
	name = "неполная сборка хонкбота"
	desc = "Клоун снова не смог пошутить. Поможет ли эта штука?"
	icon_state = "honkbot_arm"
	created_name = "Хонкбот"

/obj/item/bot_assembly/honkbot/attackby(obj/item/I, mob/user, params)
	..()
	switch(build_step)
		if(ASSEMBLY_FIRST_STEP)
			if(isprox(I))
				if(!user.temporarilyRemoveItemFromInventory(I))
					return
				to_chat(user, "<span class='notice'>Добавляю [I] к [src.name]!</span>")
				icon_state = "honkbot_proxy"
				name = "неполная сборка хонкбота"
				qdel(I)
				build_step++

		if(ASSEMBLY_SECOND_STEP)
			if(istype(I, /obj/item/bikehorn))
				if(!can_finish_build(I, user))
					return
				to_chat(user, "<span class='notice'>Добавляю [I] к [src.name]! Хонк!</span>")
				var/mob/living/simple_animal/bot/honkbot/S = new(drop_location())
				S.name = created_name
				S.limiting_spam = TRUE // only long enough to hear the first ping.
				addtimer(CALLBACK (S, .mob/living/simple_animal/bot/honkbot/proc/react_ping), 5)
				S.bikehorn = I.type
				qdel(I)
				qdel(src)


//Secbot Assembly
/obj/item/bot_assembly/secbot
	name = "неполная сборка секьюритрона"
	desc = "Какая-то причудливая сборка из датчика приближения, шлема и сигнализатора."
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
					to_chat(user, "<span class='notice'>Завариваю дырку в [src.name]!</span>")
					build_step++

			else if(I.tool_behaviour == TOOL_SCREWDRIVER) //deconstruct
				new /obj/item/assembly/signaler(Tsec)
				new /obj/item/clothing/head/helmet/sec(Tsec)
				to_chat(user, "<span class='notice'>Отключаю радио от шлема.</span>")
				qdel(src)

		if(ASSEMBLY_SECOND_STEP)
			if(isprox(I))
				if(!user.temporarilyRemoveItemFromInventory(I))
					return
				to_chat(user, "<span class='notice'>Добавляю [I] к [src.name]!</span>")
				add_overlay("hs_eye")
				name = "шлем/сигналлер/сенсор сборка"
				qdel(I)
				build_step++

			else if(I.tool_behaviour == TOOL_WELDER) //deconstruct
				if(I.use_tool(src, user, 0, volume=40))
					cut_overlay("hs_hole")
					to_chat(user, "<span class='notice'>Завариваю дырку в [src.name] полностью!</span>")
					build_step--

		if(ASSEMBLY_THIRD_STEP)
			if((istype(I, /obj/item/bodypart/l_arm/robot)) || (istype(I, /obj/item/bodypart/r_arm/robot)))
				if(!user.temporarilyRemoveItemFromInventory(I))
					return
				to_chat(user, "<span class='notice'>Добавляю [I] к [src.name]!</span>")
				name = "шлем/сигналлер/сенсор/рука робота сборка"
				add_overlay("hs_arm")
				robot_arm = I.type
				qdel(I)
				build_step++

			else if(I.tool_behaviour == TOOL_SCREWDRIVER) //deconstruct
				cut_overlay("hs_eye")
				new /obj/item/assembly/prox_sensor(Tsec)
				to_chat(user, "<span class='notice'>Отсоединяю сенсор движения от [src.name].</span>")
				build_step--

		if(ASSEMBLY_FOURTH_STEP)
			if(istype(I, /obj/item/melee/baton))
				if(!can_finish_build(I, user))
					return
				to_chat(user, "<span class='notice'>Завершаю сборку Секьюритрона! Бип буп.</span>")
				var/mob/living/simple_animal/bot/secbot/S = new(Tsec)
				S.name = created_name
				S.baton_type = I.type
				S.robot_arm = robot_arm
				qdel(I)
				qdel(src)
			if(I.tool_behaviour == TOOL_WRENCH)
				to_chat(user, "<span class='notice'>Настраиваю руку [src.name], для возможности носить оружие.</span>")
				build_step ++
				return
			if(istype(I, /obj/item/toy/sword))
				if(toyswordamt < 3 && swordamt <= 0)
					if(!user.temporarilyRemoveItemFromInventory(I))
						return
					created_name = "Генерал Бипскай"
					name = "шлем/сигналлер/сенсор/рука робота/игрушечный меч сборка"
					icon_state = "grievous_assembly"
					to_chat(user, "<span class='notice'>Приклеиваю [I] к одной из рук [src.name].</span>")
					qdel(I)
					toyswordamt ++
				else
					if(!can_finish_build(I, user))
						return
					to_chat(user, "<span class='notice'>Завершаю сборку Секьюритрона!...Что-то с ним не так..?</span>")
					var/mob/living/simple_animal/bot/secbot/grievous/toy/S = new(Tsec)
					S.name = created_name
					S.robot_arm = robot_arm
					qdel(I)
					qdel(src)

			else if(I.tool_behaviour == TOOL_SCREWDRIVER) //deconstruct
				cut_overlay("hs_arm")
				var/obj/item/bodypart/dropped_arm = new robot_arm(Tsec)
				robot_arm = null
				to_chat(user, "<span class='notice'>Убираю [dropped_arm] из [src.name].</span>")
				build_step--
				if(toyswordamt > 0 || toyswordamt)
					toyswordamt = 0
					icon_state = initial(icon_state)
					to_chat(user, "<span class='notice'>Прикленные к [src.name] игрушечные мечи отваливаются!</span>")
					for(var/IS in 1 to toyswordamt)
						new /obj/item/toy/sword(Tsec)

		if(ASSEMBLY_FIFTH_STEP)
			if(istype(I, /obj/item/melee/transforming/energy/sword/saber))
				if(swordamt < 3)
					if(!user.temporarilyRemoveItemFromInventory(I))
						return
					created_name = "Генерал Бипскай"
					name = "шлем/сигналлер/сенсор/рука робота/энергомеч сборка"
					icon_state = "grievous_assembly"
					to_chat(user, "<span class='notice'>Прикручиваю [I] к одной из рук [src.name].</span>")
					qdel(I)
					swordamt ++
				else
					if(!can_finish_build(I, user))
						return
					to_chat(user, "<span class='notice'>Завершаю сборку Секьюритрона!...Что-то с ним не так..?</span>")
					var/mob/living/simple_animal/bot/secbot/grievous/S = new(Tsec)
					S.name = created_name
					S.robot_arm = robot_arm
					qdel(I)
					qdel(src)
			else if(I.tool_behaviour == TOOL_SCREWDRIVER) //deconstruct
				build_step--
				swordamt = 0
				icon_state = initial(icon_state)
				to_chat(user, "<span class='notice'>Откручиваю энергомечи [src.name].</span>")
				for(var/IS in 1 to swordamt)
					new /obj/item/melee/transforming/energy/sword/saber(Tsec)


//Firebot Assembly
/obj/item/bot_assembly/firebot
	name = "неполная сборка файрбота"
	desc = "Огнетушитель с прикрепленной к нему рукой."
	icon_state = "firebot_arm"
	created_name = "Файрбот"

/obj/item/bot_assembly/firebot/attackby(obj/item/I, mob/user, params)
	..()
	switch(build_step)
		if(ASSEMBLY_FIRST_STEP)
			if(istype(I, /obj/item/clothing/head/hardhat/red))
				if(!user.temporarilyRemoveItemFromInventory(I))
					return
				to_chat(user,"<span class='notice'>Добавляю [I] к [src.name]!</span>")
				icon_state = "firebot_helmet"
				desc = "Неполная сборка файрбота с пожарным шлемом."
				qdel(I)
				build_step++

		if(ASSEMBLY_SECOND_STEP)
			if(isprox(I))
				if(!can_finish_build(I, user))
					return
				to_chat(user, "<span class='notice'>Добавляю [I] к [src.name]! Бип буп!</span>")
				var/mob/living/simple_animal/bot/firebot/F = new(drop_location())
				F.name = created_name
				qdel(I)
				qdel(src)

//Get cleaned
/obj/item/bot_assembly/hygienebot
	name = "неполная сборка гигиенобота"
	desc = "Очистить болото раз и навсегда"
	icon_state = "hygienebot"
	created_name = "Гигиенобот"

/obj/item/bot_assembly/hygienebot/attackby(obj/item/I, mob/user, params)
	. = ..()
	var/atom/Tsec = drop_location()
	switch(build_step)
		if(ASSEMBLY_FIRST_STEP)
			if(I.tool_behaviour == TOOL_WELDER) //Construct
				if(I.use_tool(src, user, 0, volume=40))
					to_chat(user, "<span class='notice'>Вывариваю отверстие для воды в [src.name]!</span>")
					build_step++
					return
			if(I.tool_behaviour == TOOL_WRENCH) //Deconstruct
				if(I.use_tool(src, user, 0, volume=40))
					new /obj/item/stack/sheet/metal(Tsec, 2)
					to_chat(user, "<span class='notice'>Разбираю сборку гигиенобота.</span>")
					qdel(src)

		if(ASSEMBLY_SECOND_STEP)
			if(isprox(I)) //Construct
				if(!user.temporarilyRemoveItemFromInventory(I))
					return
				build_step++
				to_chat(user, "<span class='notice'>Добавляю [I] к [src.name].</span>")
				qdel(I)
			if(I.tool_behaviour == TOOL_WELDER) //Deconstruct
				if(I.use_tool(src, user, 0, volume=30))
					to_chat(user, "<span class='notice'>Завариваю дырку в [src.name]!</span>")
					build_step--
					return

		if(ASSEMBLY_THIRD_STEP)
			if(!can_finish_build(I, user, 0))
				return
			if(istype(I, /obj/item/stack/ducts)) //Construct
				var/obj/item/stack/ducts/D = I
				if(D.get_amount() < 1)
					to_chat(user, "<span class='warning'>Мне нужна одна труба для жидкости, чтобы завершить [src.name]</span>")
					return
				to_chat(user, "<span class='notice'>Начинаю добавлять трубу к [src.name]...</span>")
				if(do_after(user, 40, target = src) && D.use(1))
					to_chat(user, "<span class='notice'>Добавляю трубу к [src.name].</span>")
					var/mob/living/simple_animal/bot/hygienebot/H = new(drop_location())
					H.name = created_name
					qdel(src)
			if(I.tool_behaviour == TOOL_SCREWDRIVER) //deconstruct
				new /obj/item/assembly/prox_sensor(Tsec)
				to_chat(user, "<span class='notice'>Отсоединяю сенсор движения от [src.name].</span>")
				build_step--

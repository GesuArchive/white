// Предметы для Робаст-феста, космо-карта

/datum/outfit/whiterobust/ass/spaceman_green
	name = "Космонавтик Зеленый"

	suit = /obj/item/clothing/suit/space/hardsuit/shielded/ctf/green/robast
	gloves = /obj/item/clothing/gloves/combat

	belt = /obj/item/gun/energy/laser/rangers/robast
	r_pocket = /obj/item/melee/energy/sword/saber/green/robast

/datum/outfit/whiterobust/ass/spaceman_red
	name = "Космонавтик Красный"

	suit = /obj/item/clothing/suit/space/hardsuit/shielded/ctf/red/robast
	gloves = /obj/item/clothing/gloves/combat

	belt = /obj/item/gun/energy/laser/rangers/robast
	r_pocket = /obj/item/melee/energy/sword/saber/red/robast


/obj/item/clothing/head/helmet/space/hardsuit/shielded/ctf/green/robast
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 50, "bio" = 100, "rad" = 50, "fire" = 50, "acid" = 75, "wound" = 20)


/obj/item/clothing/head/helmet/space/hardsuit/shielded/ctf/red/robast
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 50, "bio" = 100, "rad" = 50, "fire" = 50, "acid" = 75, "wound" = 20)

/obj/item/clothing/suit/space/hardsuit/shielded/ctf/green/robast
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 50, "bio" = 100, "rad" = 50, "fire" = 50, "acid" = 75, "wound" = 20)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/shielded/ctf/green/robast
	max_charges = 4
	recharge_rate = 3 SECONDS
	recharge_delay = 30 SECONDS

/obj/item/clothing/suit/space/hardsuit/shielded/ctf/red/robast
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 50, "bio" = 100, "rad" = 50, "fire" = 50, "acid" = 75, "wound" = 20)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/shielded/ctf/red/robast
	max_charges = 4
	recharge_rate = 3 SECONDS
	recharge_delay = 30 SECONDS


/obj/item/gun/energy/laser/rangers/robast
	name = "военная лазерная пушка"
	desc = "Боезапас 30 выстрелов, урон 40 единиц."
	pin = /obj/item/firing_pin
	ammo_type = list(/obj/item/ammo_casing/energy/laser/robast30)

/obj/projectile/beam/laser/heavylaser/robast
	name = "тяжелый луч"
	icon_state = "heavylaser"
	damage = 40

/obj/projectile/beam/laser/heavylaser/robast/on_hit(atom/target, blocked)
	damage = initial(damage)
	if(isobj(target))
		damage = 70
	else if(istype(target, /turf/closed/mineral))
		var/turf/closed/mineral/T = target
		T.gets_drilled()
	. = ..()

/obj/item/ammo_casing/energy/laser/robast30
	projectile_type = /obj/projectile/beam/laser/heavylaser/robast
	select_name = "убить"
	e_cost = 40


/obj/item/melee/energy/sword/saber/red/robast
	name = "военный лазерный меч"
	desc = "Урон 60 единиц, шанс блока 50%."
	active_force = 60

/obj/item/melee/energy/sword/saber/green/robast
	name = "военный лазерный меч"
	desc = "Урон 60 единиц, шанс блока 50%."
	active_force = 60

/obj/projectile/bullet/robast
	name = "ядро"
	damage = 110
	icon_state = "fireball"
	speed = 8

/obj/projectile/bullet/robast/on_hit(atom/target, blocked)
	damage = initial(damage)
	if(isobj(target))
		damage = 70
	else if(istype(target, /turf/closed/mineral))
		var/turf/closed/mineral/T = target
		T.gets_drilled()
	. = ..()


/obj/machinery/porta_turret/syndicate/robast
	icon_state = "falconet_patina_off"
	base_icon_state = "falconet_patina"
	scan_range = 9
	lethal_projectile = /obj/projectile/bullet/robast
	lethal_projectile_sound = 'sound/weapons/gun/hmg/hmg.ogg'
	shot_delay = 40
	max_integrity = 500


// 	Создание бронежилетов

/obj/item/armor_preassembly
	name = "раскройка бронежилета"
	desc = "Вырезанная из дюраткани раскройка будущего бронежилета, осталось добавить по <b>1 штуке всех видов бронепластин</b> и немного <b>проводов</b>."
	icon = 'white/Feline/icons/armor_craft.dmi'
	icon_state = "st1"
	var/ap_step2 = FALSE
	var/ap_plasteel = FALSE
	var/ap_ceramic = FALSE
	var/ap_ablative = FALSE

/obj/item/armor_preassembly/examine(mob/user)
	. = ..()
	if(ap_plasteel)
		. += "<hr><span class='notice'><b>Пласталевая бронепластина </b> закреплена.</span>"
	else
		. += "<hr><span class='notice'>Пласталевая бронепластина не закреплена.</span>"
	if(ap_ceramic)
		. += "<hr><span class='notice'><b>Керамическая бронепластина </b> закреплена.</span>"
	else
		. += "<hr><span class='notice'>Керамическая бронепластина не закреплена.</span>"
	if(ap_ablative)
		. += "<hr><span class='notice'><b>Зеркальная бронепластина </b> закреплена.</span>"
	else
		. += "<hr><span class='notice'>Зеркальная бронепластина не закреплена.</span>"

/obj/item/armor_preassembly/proc/ap_add(obj/item/W, mob/user)
	var/obj/item/stack/sheet/armor_plate/plasteel/S = W
	to_chat(user, span_notice("Закрепляю [S] на дюраткани."))
	playsound(user, 'sound/items/handling/cloth_pickup.ogg', 100, TRUE)
	if(!do_after(user, 2 SECONDS, src))
		return TRUE
	playsound(user, 'sound/items/handling/cloth_drop.ogg', 100, TRUE)
	if(S.amount == 1)
		qdel(S)
	else
		S.amount = S.amount - 1
		S.update_icon()

/obj/item/armor_preassembly/attackby(obj/item/W, mob/user, params)

	if(istype(W, /obj/item/stack/sheet/armor_plate/plasteel))
		if(!ap_plasteel)
			ap_add(W, user)
			ap_plasteel = TRUE
		else
			to_chat(user, span_warning("На заготовке уже закреплена [W]."))

	if(istype(W, /obj/item/stack/sheet/armor_plate/ceramic))
		if(!ap_ceramic)
			ap_add(W, user)
			ap_ceramic = TRUE
		else
			to_chat(user, span_warning("На заготовке уже закреплена [W]."))

	if(istype(W, /obj/item/stack/sheet/armor_plate/ablative))
		if(!ap_ablative)
			ap_add(W, user)
			ap_ablative = TRUE
		else
			to_chat(user, span_warning("На заготовке уже закреплена [W]."))

	if(ap_plasteel && ap_ceramic && ap_ablative)
		ap_step2 = TRUE
		icon_state = "st2"
		desc = "Вырезанная из дюраткани раскройка будущего бронежилета, осталось добавить немного <b>проводов</b>."


	if(istype(W, /obj/item/stack/cable_coil))
		if(ap_step2)
			var/obj/item/stack/cable_coil/S = W
			if(S.amount >= 15)
				to_chat(user, span_notice("Добавляю провода для скрепления конструкции."))
				playsound(user, 'sound/items/handling/tape_pickup.ogg', 100, TRUE)
				if(!do_after(user, 2 SECONDS, src))
					return TRUE
				playsound(user, 'sound/items/handling/tape_drop.ogg', 100, TRUE)
				if(S.amount == 15)
					qdel(S)
				else
					S.amount = S.amount - 15
				new /obj/item/armor_disassembly	(src.drop_location())
				qdel(src)
			else
				to_chat(user, span_warning("Для создания заготовки бронежилета необходимо по крайней мере 15 метров кабеля."))
		else
			to_chat(user, span_warning("Сначала необходимо закрепить все бронелисты."))

/obj/item/armor_disassembly
	name = "заготовка бронежилета"
	desc = "Все застежки и швы расслаблены, в слоях дюраткани видны бронелисты. Теперь можно <b>кусачками</b> перерезать швы или присоединить к заготовке что то еще. А можно вообще ничего не добавлять и при помощи <b>отвертки</b> попытаться собрать стандартный образец. <hr><span class='info'>Для создания <b>пуленепробиваемого бронежилета</b> добавьте <b>керамическую бронепластину</b>.<hr>Для создания <b>брони антибунт</b> добавьте <b>дюраткань</b>, а затем <b>пласталевую бронепластину</b>.<hr>Для создания <b>лабораторной брони</b> добавьте <b>лабораторный халат</b>.</span>"
	icon = 'white/Feline/icons/armor_craft.dmi'
	icon_state = "st3"

/obj/item/armor_disassembly/attackby(obj/item/W, mob/user, params)
// 	Стандартная броня - отвертка
	if(W.tool_behaviour == TOOL_SCREWDRIVER)
		to_chat(user, span_notice("Распределяю бронепластины по стандартной схеме и закручиваю заклепки."))
		playsound(user, 'sound/items/screwdriver.ogg', 100, TRUE)
		if(!do_after(user, 2 SECONDS, src))
			return TRUE
		playsound(user, 'sound/items/zip.ogg', 100, TRUE)
		new /obj/item/clothing/suit/armor/vest(src.drop_location())
		qdel(src)
// 	Разборка заготовки на компоненты - кусачки
	if(W.tool_behaviour == TOOL_WIRECUTTER)
		to_chat(user, span_notice("Перекусываю скрепляющие швы на заготовке."))
		playsound(user, 'sound/items/wirecutter.ogg', 100, TRUE)
		if(!do_after(user, 2 SECONDS, src))
			return TRUE
		playsound(user, 'sound/items/handling/cloth_pickup.ogg', 100, TRUE)
		new /obj/item/stack/cable_coil/fifteen(src.drop_location())
		new /obj/item/stack/sheet/armor_plate/plasteel(src.drop_location())
		new /obj/item/stack/sheet/armor_plate/ceramic(src.drop_location())
		new /obj/item/stack/sheet/armor_plate/ablative(src.drop_location())
		new /obj/item/stack/sheet/durathread/ten(src.drop_location())
		qdel(src)
// 	Пуленепробиваемая броня - Керамическая
	if(istype(W, /obj/item/stack/sheet/armor_plate/ceramic))
		var/obj/item/stack/sheet/armor_plate/ceramic/S = W
		to_chat(user, span_notice("Прикрепляю дополнительную бронепластину к раскройке и перераспределяю уже установленные, теперь бронежилет будет лучше защищать от пуль."))
		playsound(user, 'sound/items/handling/toolbelt_pickup.ogg', 100, TRUE)
		if(!do_after(user, 2 SECONDS, src))
			return TRUE
		playsound(user, 'sound/items/zip.ogg', 100, TRUE)
		if(S.amount > 1)
			S.amount = S.amount - 1
			S.update_icon()
		else
			qdel(S)
		new /obj/item/clothing/suit/armor/bulletproof(src.drop_location())
		qdel(src)
// 	Антибунт броня - Дюраткань + Пласталевая
	if(istype(W, /obj/item/stack/sheet/durathread))
		var/obj/item/stack/sheet/durathread/S = W
		if(S.amount >= 6)
			to_chat(user, span_notice("Добавляю еще несколько слоев дюраткани, а так же распределяю бронепластины таким образом, чтобы они закрывали все тело, однако мне понадобится еще как минимум одна бронепластина."))
			playsound(user, 'sound/items/handling/cloth_pickup.ogg', 100, TRUE)
			if(!do_after(user, 2 SECONDS, src))
				return TRUE
			playsound(user, 'sound/items/zip.ogg', 100, TRUE)
			if(S.amount == 6)
				qdel(S)
			else
				S.amount = S.amount - 6
	//		new /obj/item/armor_disassembly_riot(src.drop_location())
			var/obj/item/armor_disassembly_riot/I = new()
			user.put_in_hands(I)
			qdel(src)
		else
			to_chat(user, span_warning("Для создания брони антибунт необходимо по крайней мере 6 отрезов дюраткани."))
			/*
// 	Зеркальная броня - Пласталь
	if(istype(W, /obj/item/stack/sheet/durathread))
		var/obj/item/stack/sheet/durathread/S = W
		if(S.amount >= 6)
			to_chat(user, span_notice("Добавляю еще несколько слоев дюраткани, а так же распределяю бронепластины таким образом, чтобы они закрывали все тело, теперь бронежилет будет лучше защищать от ударов."))
			playsound(user, 'sound/items/handling/cloth_pickup.ogg', 100, TRUE)
			if(!do_after(user, 2 SECONDS, src))
				return TRUE
			playsound(user, 'sound/items/zip.ogg', 100, TRUE)
			if(S.amount == 6)
				qdel(S)
			else
				S.amount = S.amount - 6
			new /obj/item/clothing/suit/armor/riot(src.drop_location())
			qdel(src)
		else
			to_chat(user, span_warning("Для создания брони антибунт необходимо по крайней мере 6 отрезов дюраткани."))
			*/
// 	Лабораторная броня
	if(istype(W, /obj/item/clothing/suit/toggle/labcoat))
		to_chat(user, span_notice("Закрепляю раскройку на лабораторном халате. Теперь у бронежилета повышеная защита от кислот и биоугроз, а так же есть крепления как для боевого снаряжения, так и медицинского."))
		playsound(user, 'sound/items/equip/toolbelt_equip.ogg', 100, TRUE)
		if(!do_after(user, 2 SECONDS, src))
			return TRUE
		playsound(user, 'sound/items/zip.ogg', 100, TRUE)

		if(istype(W, /obj/item/clothing/suit/toggle/labcoat/cmo))
			new /obj/item/clothing/suit/armor/vest/fieldmedic/cmo(src.drop_location())
		else if(istype(W, /obj/item/clothing/suit/toggle/labcoat/chemist))
			new /obj/item/clothing/suit/armor/vest/fieldmedic/chemist(src.drop_location())
		else if(istype(W, /obj/item/clothing/suit/toggle/labcoat/paramedic))
			new /obj/item/clothing/suit/armor/vest/fieldmedic/paramedic(src.drop_location())
		else if(istype(W, /obj/item/clothing/suit/toggle/labcoat/virologist))
			new /obj/item/clothing/suit/armor/vest/fieldmedic/virologist(src.drop_location())
		else if(istype(W, /obj/item/clothing/suit/toggle/labcoat/science))
			new /obj/item/clothing/suit/armor/vest/fieldmedic/science(src.drop_location())
		else if(istype(W, /obj/item/clothing/suit/toggle/labcoat/roboticist))
			new /obj/item/clothing/suit/armor/vest/fieldmedic/roboticist(src.drop_location())
		else if(istype(W, /obj/item/clothing/suit/toggle/labcoat/genetics))
			new /obj/item/clothing/suit/armor/vest/fieldmedic/genetics(src.drop_location())
		else
			new /obj/item/clothing/suit/armor/vest/fieldmedic/med(src.drop_location())

		qdel(W)
		qdel(src)

	. = ..()

// 	Риот броня 2 шаг
/obj/item/armor_disassembly_riot
	name = "заготовка брони антибунт"
	desc = "Осталось закрепить пласталевую бронепластину"
	icon = 'white/Feline/icons/armor_craft.dmi'
	icon_state = "st3"

/obj/item/armor_disassembly_riot/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(istype(W, /obj/item/stack/sheet/armor_plate/plasteel))
		var/obj/item/stack/sheet/armor_plate/plasteel/S = W
		to_chat(user, span_notice("Прикрепляю дополнительную демпферную бронепластину, теперь бронежилет будет лучше защищать от ударов."))
		playsound(user, 'sound/items/handling/toolbelt_pickup.ogg', 100, TRUE)
		if(!do_after(user, 2 SECONDS, src))
			return TRUE
		playsound(user, 'sound/items/zip.ogg', 100, TRUE)
		if(S.amount > 1)
			S.amount = S.amount - 1
			S.update_icon()
		else
			qdel(S)
	//	new /obj/item/clothing/suit/armor/riot(src.drop_location())
		var/obj/item/clothing/suit/armor/riot/I = new()
		user.put_in_hands(I)
		qdel(src)

/datum/crafting_recipe/armor_default
	name = "Стандартный бронежилет"
	result = /obj/item/clothing/suit/armor/vest
	time = 30 SECONDS
	reqs = list(/obj/item/stack/sheet/armor_plate/plasteel = 1, /obj/item/stack/sheet/armor_plate/ceramic = 1, /obj/item/stack/sheet/armor_plate/ablative = 1, /obj/item/stack/sheet/durathread = 10, /obj/item/stack/cable_coil = 15)
	tool_behaviors = list(TOOL_WELDER, TOOL_WIRECUTTER, TOOL_SCREWDRIVER)
	category = CAT_ARMOR

/datum/crafting_recipe/armor_bulletproof
	name = "Пуленепробиваемый бронежилет"
	result = /obj/item/clothing/suit/armor/bulletproof
	time = 30 SECONDS
	reqs = list(/obj/item/stack/sheet/armor_plate/plasteel = 1, /obj/item/stack/sheet/armor_plate/ceramic = 2, /obj/item/stack/sheet/armor_plate/ablative = 1, /obj/item/stack/sheet/durathread = 10, /obj/item/stack/cable_coil = 15)
	tool_behaviors = list(TOOL_WELDER, TOOL_WIRECUTTER, TOOL_SCREWDRIVER)
	category = CAT_ARMOR

/datum/crafting_recipe/armor_riot
	name = "Броня антибунт"
	result = /obj/item/clothing/suit/armor/riot
	time = 30 SECONDS
	reqs = list(/obj/item/stack/sheet/armor_plate/plasteel = 2, /obj/item/stack/sheet/armor_plate/ceramic = 1, /obj/item/stack/sheet/armor_plate/ablative = 1, /obj/item/stack/sheet/durathread = 16, /obj/item/stack/cable_coil = 15)
	tool_behaviors = list(TOOL_WELDER, TOOL_WIRECUTTER, TOOL_SCREWDRIVER)
	category = CAT_ARMOR

/obj/item/clothing/suit/armor/vest/fieldmedic
	name = "бронекуртка полевого медика"
	desc = "Бронекуртка полевого врача фронтира. Тот кто по настоящему желает спасать жизни не сидит в госпитале, а работает на поле боя. Но иногда единственный способ спасти жизнь -  это забрать другую."
	icon = 'white/Feline/icons/lab_armor_front.dmi'
	worn_icon = 'white/Feline/icons/lab_armor_body.dmi'
	icon_state = "fieldmed"
	allowed = list(/obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/flashlight, /obj/item/gun/ballistic, /obj/item/gun/energy, /obj/item/gun/grenadelauncher,
			/obj/item/kitchen/knife/combat, /obj/item/melee/baton, /obj/item/melee/classic_baton, /obj/item/reagent_containers/spray/pepper,
			/obj/item/restraints/handcuffs, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman, /obj/item/tank/internals/tactical,
			/obj/item/storage/belt/holster/detective, /obj/item/storage/belt/holster/thermal, /obj/item/storage/belt/holster/nukie,
			/obj/item/tank/internals/emergency_oxygen, /obj/item/healthanalyzer, /obj/item/medbot_carrier, /obj/item/gun/syringe, /obj/item/solnce)
	armor = list(MELEE = 35, BULLET = 30, LASER = 30, ENERGY = 40, BOMB = 25, BIO = 70, RAD = 30, FIRE = 50, ACID = 70, WOUND = 20)

/obj/item/clothing/suit/armor/vest/fieldmedic/med
	name = "лабораторный бронежилет врача"
	desc = "Бронированный лабораторный халат военного врача фронтира. Оперировать под свистом пуль ваша ежедневная рутина. Лекарства закончились, инструменты потеряны, раненный истекает кровью, но все же он везунчик, ведь его закрывает собой врач."
	icon = 'white/Feline/icons/lab_armor_front.dmi'
	worn_icon = 'white/Feline/icons/lab_armor_body.dmi'
	icon_state = "med"

/obj/item/clothing/suit/armor/vest/fieldmedic/paramedic
	name = "бронекуртка парамедика"
	desc = "Бронекуртка санитара фронтира. Настоящая смелость это не марш с оружием на врага. Настоящая смелость это вытаскивание раненного из под огня противника, когда у тебя даже нет оружия."
	icon = 'white/Feline/icons/lab_armor_front.dmi'
	worn_icon = 'white/Feline/icons/lab_armor_body.dmi'
	icon_state = "paramedic"

/obj/item/clothing/suit/armor/vest/fieldmedic/chemist
	name = "лабораторный бронежилет химика"
	desc = "Бронированный лабораторный халат подпольного химика фронтира. Кислотные подпалены беспорядочно обрамлены осколками взрывов. <BR>И греет мятежную душу<BR> последний подарок врагу,<BR> месть в облике пламенной смерти<BR> и сердце держит чеку."
	icon = 'white/Feline/icons/lab_armor_front.dmi'
	worn_icon = 'white/Feline/icons/lab_armor_body.dmi'
	icon_state = "chemist"

/obj/item/clothing/suit/armor/vest/fieldmedic/virologist
	name = "лабораторный бронежилет вирусолога"
	desc = "Бронированный лабораторный халат эпидемиолога фронтира. Адаптивность боевых вирусов поражает. Порой пуля в голову агонизирующей жертвы это милосердие, но для вас это всего лишь интересный случай."
	icon = 'white/Feline/icons/lab_armor_front.dmi'
	worn_icon = 'white/Feline/icons/lab_armor_body.dmi'
	icon_state = "virologist"

/obj/item/clothing/suit/armor/vest/fieldmedic/cmo
	name = "лабораторный бронежилет главврача"
	desc = "Бронированный лабораторный халат госпительера фронтира. Иногда кто-то должен принимать тяжелые решения, резать ли ногу, проводить ли лоботомию или же вооружать врачей и защищать жизнь пациентов ценой своей собственной."
	icon = 'white/Feline/icons/lab_armor_front.dmi'
	worn_icon = 'white/Feline/icons/lab_armor_body.dmi'
	icon_state = "cmo"

/obj/item/clothing/suit/armor/vest/fieldmedic/science
	name = "лабораторный бронежилет ученого"
	desc = "Бронированный лабораторный халат непризнанного гения фронтира. Наука это темная богиня, которая дарует тайные знания, но каждый раз требует все больше и больше человеческих жертв. И вы как ее преданный слуга, их предоставите."
	icon = 'white/Feline/icons/lab_armor_front.dmi'
	worn_icon = 'white/Feline/icons/lab_armor_body.dmi'
	icon_state = "science"

/obj/item/clothing/suit/armor/vest/fieldmedic/roboticist
	name = "лабораторный бронежилет робототехника"
	desc = "Бронированный лабораторный халат военного кибернетика фронтира. Поле боя это ад. От выстрелов лазеров сгорает плоть, под стопами экзокостюма трескаются кости, а за всем происходящим следит холодный взгляд кибероптики. Это вы принесли сюда ад."
	icon = 'white/Feline/icons/lab_armor_front.dmi'
	worn_icon = 'white/Feline/icons/lab_armor_body.dmi'
	icon_state = "roboticist"

/obj/item/clothing/suit/armor/vest/fieldmedic/genetics
	name = "лабораторный бронежилет генетика"
	desc = "Бронированный лабораторный халат вивисектора фронтира. У вас интересная методика - вы разделяете людей на два типа. Те кто кричит в ужасе увидев вашу работу - подопытные, те же кто молчит - значит они такие же как вы, и связывать их нужно тщательнее."
	icon = 'white/Feline/icons/lab_armor_front.dmi'
	worn_icon = 'white/Feline/icons/lab_armor_body.dmi'
	icon_state = "genetics"

/datum/crafting_recipe/lab_armor_paramedic
	name = "Бронекуртка парамедика"
	result = /obj/item/clothing/suit/armor/vest/fieldmedic/paramedic
	time = 80
	reqs = list(/obj/item/clothing/suit/toggle/labcoat/paramedic = 1, /obj/item/stack/sheet/armor_plate/plasteel = 1, /obj/item/stack/sheet/armor_plate/ceramic = 1, /obj/item/stack/sheet/armor_plate/ablative = 1, /obj/item/stack/sheet/durathread = 10, /obj/item/stack/cable_coil = 15)
	tool_behaviors = list(TOOL_WELDER, TOOL_WIRECUTTER, TOOL_SCREWDRIVER)
	category = CAT_ARMOR

/datum/crafting_recipe/lab_armor_med
	name = "Лабораторный бронежилет врача"
	result = /obj/item/clothing/suit/armor/vest/fieldmedic/med
	time = 30 SECONDS
	reqs = list(/obj/item/clothing/suit/toggle/labcoat = 1, /obj/item/stack/sheet/armor_plate/plasteel = 1, /obj/item/stack/sheet/armor_plate/ceramic = 1, /obj/item/stack/sheet/armor_plate/ablative = 1, /obj/item/stack/sheet/durathread = 10, /obj/item/stack/cable_coil = 15)
	tool_behaviors = list(TOOL_WELDER, TOOL_WIRECUTTER, TOOL_SCREWDRIVER)
	category = CAT_ARMOR

/datum/crafting_recipe/lab_armor_chemist
	name = "Лабораторный бронежилет химика"
	result = /obj/item/clothing/suit/armor/vest/fieldmedic/chemist
	time = 30 SECONDS
	reqs = list(/obj/item/clothing/suit/toggle/labcoat/chemist = 1, /obj/item/stack/sheet/armor_plate/plasteel = 1, /obj/item/stack/sheet/armor_plate/ceramic = 1, /obj/item/stack/sheet/armor_plate/ablative = 1, /obj/item/stack/sheet/durathread = 10, /obj/item/stack/cable_coil = 15)
	tool_behaviors = list(TOOL_WELDER, TOOL_WIRECUTTER, TOOL_SCREWDRIVER)
	category = CAT_ARMOR

/datum/crafting_recipe/lab_armor_virologist
	name = "Лабораторный бронежилет вирусолога"
	result = /obj/item/clothing/suit/armor/vest/fieldmedic/virologist
	time = 30 SECONDS
	reqs = list(/obj/item/clothing/suit/toggle/labcoat/virologist = 1, /obj/item/stack/sheet/armor_plate/plasteel = 1, /obj/item/stack/sheet/armor_plate/ceramic = 1, /obj/item/stack/sheet/armor_plate/ablative = 1, /obj/item/stack/sheet/durathread = 10, /obj/item/stack/cable_coil = 15)
	tool_behaviors = list(TOOL_WELDER, TOOL_WIRECUTTER, TOOL_SCREWDRIVER)
	category = CAT_ARMOR

/datum/crafting_recipe/lab_armor_cmo
	name = "Лабораторный бронежилет главврача"
	result = /obj/item/clothing/suit/armor/vest/fieldmedic/cmo
	time = 30 SECONDS
	reqs = list(/obj/item/clothing/suit/toggle/labcoat/cmo = 1, /obj/item/stack/sheet/armor_plate/plasteel = 1, /obj/item/stack/sheet/armor_plate/ceramic = 1, /obj/item/stack/sheet/armor_plate/ablative = 1, /obj/item/stack/sheet/durathread = 10, /obj/item/stack/cable_coil = 15)
	tool_behaviors = list(TOOL_WELDER, TOOL_WIRECUTTER, TOOL_SCREWDRIVER)
	category = CAT_ARMOR

/datum/crafting_recipe/lab_armor_science
	name = "Лабораторный бронежилет ученого"
	result = /obj/item/clothing/suit/armor/vest/fieldmedic/science
	time = 30 SECONDS
	reqs = list(/obj/item/clothing/suit/toggle/labcoat/science = 1, /obj/item/stack/sheet/armor_plate/plasteel = 1, /obj/item/stack/sheet/armor_plate/ceramic = 1, /obj/item/stack/sheet/armor_plate/ablative = 1, /obj/item/stack/sheet/durathread = 10, /obj/item/stack/cable_coil = 15)
	tool_behaviors = list(TOOL_WELDER, TOOL_WIRECUTTER, TOOL_SCREWDRIVER)
	category = CAT_ARMOR

/datum/crafting_recipe/lab_armor_roboticist
	name = "Лабораторный бронежилет робототехника"
	result = /obj/item/clothing/suit/armor/vest/fieldmedic/roboticist
	time = 30 SECONDS
	reqs = list(/obj/item/clothing/suit/toggle/labcoat/roboticist = 1, /obj/item/stack/sheet/armor_plate/plasteel = 1, /obj/item/stack/sheet/armor_plate/ceramic = 1, /obj/item/stack/sheet/armor_plate/ablative = 1, /obj/item/stack/sheet/durathread = 10, /obj/item/stack/cable_coil = 15)
	tool_behaviors = list(TOOL_WELDER, TOOL_WIRECUTTER, TOOL_SCREWDRIVER)
	category = CAT_ARMOR

/datum/crafting_recipe/lab_armor_genetics
	name = "Лабораторный бронежилет генетика"
	result = /obj/item/clothing/suit/armor/vest/fieldmedic/genetics
	time = 30 SECONDS
	reqs = list(/obj/item/clothing/suit/toggle/labcoat/genetics = 1, /obj/item/stack/sheet/armor_plate/plasteel = 1, /obj/item/stack/sheet/armor_plate/ceramic = 1, /obj/item/stack/sheet/armor_plate/ablative = 1, /obj/item/stack/sheet/durathread = 10, /obj/item/stack/cable_coil = 15)
	tool_behaviors = list(TOOL_WELDER, TOOL_WIRECUTTER, TOOL_SCREWDRIVER)
	category = CAT_ARMOR

// 	Бронепластины

/datum/crafting_recipe/plasteel_armor_plate
	name = "Пласталевая бронепластина"
	result =  /obj/item/stack/sheet/armor_plate/plasteel
	time = 80
	reqs = list(/obj/item/stack/sheet/plasteel = 10,
				/obj/item/stack/sheet/mineral/titanium = 1)
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER)
	category = CAT_ARMOR

/datum/crafting_recipe/ceramic_armor_plate
	name = "Керамическая бронепластина"
	result =  /obj/item/stack/sheet/armor_plate/ceramic
	time = 80
	reqs = list(/obj/item/stack/sheet/plasmarglass = 10,
				/obj/item/stack/sheet/iron = 10)
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER)
	category = CAT_ARMOR

/datum/crafting_recipe/ablative_armor_plate
	name = "зеркальная бронепластина"
	result =  /obj/item/stack/sheet/armor_plate/ablative
	time = 80
	reqs = list(/obj/item/stack/sheet/mineral/plastitanium = 10)
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER)
	category = CAT_ARMOR

/obj/item/stack/sheet/armor_plate
	icon = 'white/Feline/icons/armor_plate.dmi'
	max_amount = 3
	merge_type = /obj/item/stack/sheet/armor_plate
	var/armor_type = MELEE

/obj/item/stack/sheet/armor_plate/plasteel
	name = "пласталевая бронепластина"
	singular_name = "пласталевая бронепластина"
	desc = "Ударостойкий броневой лист с демпферным подбоем. При закреплении на <B>бронежилетах</B> или <B>скафандрах</B> предоставляет дополнительную защиту от атак в <B>ближнем бою</B>. Особо эффективна на слабозащищенных комплектах."
	icon_state = "plasteel_armor_plate"
	merge_type = /obj/item/stack/sheet/armor_plate/plasteel
	armor = list(MELEE = 12, WOUND = 10)
	armor_type = MELEE

/obj/item/stack/sheet/armor_plate/ceramic
	name = "керамическая бронепластина"
	singular_name = "керамическая бронепластина"
	desc = "Керамическая чешуя закрепленная на пуленепробиваемой основе. При закреплении на <B>бронежилетах</B> или <B>скафандрах</B> предоставляет дополнительную защиту от <B>пуль и взрывов</B>. Особо эффективна на слабозащищенных комплектах."
	icon_state = "ceramic_armor_plate"
	merge_type = /obj/item/stack/sheet/armor_plate/ceramic
	armor = list(BULLET = 10, BOMB = 10)
	armor_type = BULLET

/obj/item/stack/sheet/armor_plate/ablative
	name = "зеркальная бронепластина"
	singular_name = "зеркальная бронепластина"
	desc = "Блестящая зеркальная рефракционная сетка с радиаторами. При закреплении на <B>бронежилетах</B> или <B>скафандрах</B> предоставляет дополнительную защиту от <B>лазеров и парализаторов</B>. Особо эффективна на слабозащищенных комплектах."
	icon_state = "ablative_armor_plate"
	merge_type = /obj/item/stack/sheet/armor_plate/ablative
	armor = list(LASER = 10, ENERGY = 13)
	armor_type = LASER

/obj/item/stack/sheet/armor_plate/plasteel/three
	amount = 3

/obj/item/stack/sheet/armor_plate/ceramic/three
	amount = 3

/obj/item/stack/sheet/armor_plate/ablative/three
	amount = 3
/datum/crafting_recipe/full_armor_upgrade
	name = "Комплект защиты рук и ног"
	result =  /obj/item/full_armor_upgrade
	time = 80
	reqs = list(/obj/item/stack/sheet/armor_plate/plasteel = 4, /obj/item/stack/sheet/durathread = 12, /obj/item/stack/sheet/cloth = 4, /obj/item/stack/cable_coil = 20)
	tool_behaviors = list(TOOL_WELDER, TOOL_WIRECUTTER, TOOL_SCREWDRIVER)
	category = CAT_ARMOR

/obj/item/full_armor_upgrade
	name = "комплект защиты рук и ног"
	desc = "Набор из поножей, наручей, налокотников и наколенников для дополнительной защиты конечностей. Прикрепляется к бронежилетам."
	icon = 'white/Feline/icons/armor_upgrade.dmi'
	icon_state = "full_armor_upgrade"


// Мини-патронташ

/obj/item/storage/belt/shotgun
	name = "патронташ"
	desc = "Компактный и очень удобный подсумок на 7 патронов 12 калибра, специальная клипса позволяет закрепить его на карманах или поясе."
	icon = 'white/Feline/icons/patron.dmi'
	icon_state = "patron"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	equip_sound = 'sound/items/equip/toolbelt_equip.ogg'

/obj/item/storage/belt/shotgun/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 7
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.pocket_belt = TRUE
	STR.rustle_sound = FALSE
	STR.max_combined_w_class = 14
	STR.set_holdable(list(
		/obj/item/ammo_casing/shotgun
		))

/obj/item/storage/belt/shotgun/update_icon_state()
	icon_state = initial(icon_state)
	worn_icon_state = initial(worn_icon_state)
	if(length(contents))
		icon_state = "patron[length(contents)]"

/obj/item/storage/belt/shotgun/attack_hand(mob/user, list/modifiers)
	if(loc == user)
		if((user.get_item_by_slot(ITEM_SLOT_BELT) == src) || (user.get_item_by_slot(ITEM_SLOT_LPOCKET) == src) || (user.get_item_by_slot(ITEM_SLOT_RPOCKET) == src))
			if(!user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE, TRUE))
				return
			if(length(contents))
				var/obj/item/I = contents[1]
				playsound(user, 'white/Feline/sounds/bag_1.ogg', 100, TRUE)
				user.put_in_hands(I)
				update_appearance()
			else
				to_chat(user, span_warning("[capitalize(src.name)] пустой!"))
	else ..()
	return

/obj/item/storage/belt/shotgun/rubbershot	//	Резиновая дробь
	name = "патронташ - резиновая дробь"

/obj/item/storage/belt/shotgun/rubbershot/Initialize(mapload)
	. = ..()
	add_overlay("riot")

/obj/item/storage/belt/shotgun/rubbershot/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/ammo_casing/shotgun/rubbershot(src)

/obj/item/storage/belt/shotgun/beanbag	//	Резиновая пуля
	name = "патронташ - резиновая пуля"

/obj/item/storage/belt/shotgun/beanbag/Initialize(mapload)
	. = ..()
	add_overlay("riot")

/obj/item/storage/belt/shotgun/beanbag/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/ammo_casing/shotgun/beanbag(src)

/obj/item/storage/belt/shotgun/buckshot	//	Боевая картечь
	name = "патронташ - картечь"

/obj/item/storage/belt/shotgun/buckshot/Initialize(mapload)
	. = ..()
	add_overlay("battle")

/obj/item/storage/belt/shotgun/buckshot/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/ammo_casing/shotgun/buckshot(src)

/obj/item/storage/belt/shotgun/bullet	//	Боевая пуля
	name = "патронташ - пулевой"

/obj/item/storage/belt/shotgun/bullet/Initialize(mapload)
	. = ..()
	add_overlay("battle")

/obj/item/storage/belt/shotgun/bullet/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/ammo_casing/shotgun(src)


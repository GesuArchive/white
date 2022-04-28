//Тактический Кислородный Баллон

/obj/item/tank/internals/tactical
	name = "Тактический кислородный баллон"
	desc = "Кислородный баллон военно-космического назначения. Конструкция весьма массивна и может быть закреплена только на скафандрах и тяжелой верхней одежде. Представляет собой систему магнитных креплений и стабилизирующих ремней для фиксации большинства стандартных видов вооружения. В комплект также входит универсальный оружейный кейс для нестандартных образцов."
	icon = 'white/Feline/icons/tank_tactical.dmi'
	icon_state = "tank"
	worn_icon = 'white/Feline/icons/tank_tactical_back.dmi'
	worn_icon_state = "empty"
	tank_holder_icon_state = null
	distribute_pressure = TANK_DEFAULT_RELEASE_PRESSURE
	force = 15
	dog_fashion = null
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_SUITSTORE
	equip_sound = 'sound/items/equip/toolbelt_equip.ogg'
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/tactical
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals/emergency_oxygen)

//Наполнение баллона воздухом (стандарт)
/obj/item/tank/internals/tactical/populate_gas()
	air_contents.set_moles(GAS_O2, (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))


//Параметры кармана
/datum/component/storage/concrete/pockets/tactical
	max_items = 1
	max_w_class = WEIGHT_CLASS_BULKY
	rustle_sound = FALSE
	attack_hand_interact = TRUE

//Загрузка кармана
/obj/item/tank/internals/tactical/Initialize()
	. = ..()
	if(ispath(pocket_storage_component_path))
		LoadComponent(pocket_storage_component_path)

//Тип хранимого
/datum/component/storage/concrete/pockets/tactical/Initialize()
	. = ..()
	set_holdable(list(/obj/item/gun/ballistic,
					  /obj/item/gun/energy)
					  )

//Спавн оружия в чехле, так можно задать пресеты, по умолчанию /obj/item/tank/internals/tactical/ должен быть пуст, а пресеты устанавливаются через наследников
/obj/item/tank/internals/tactical/Initialize()			//Эскадрон Смерти, Шатл Рейнджеров, Лазутчик Синдиката (корабль), Syndicate Operative - Full Kit (Лонер)
	. = ..()
	update_appearance()

/obj/item/tank/internals/tactical/wt550/Initialize()
	. = ..()
	new /obj/item/gun/ballistic/automatic/wt550(src)
	update_appearance()

/obj/item/tank/internals/tactical/pulse/Initialize()
	. = ..()
	new /obj/item/gun/energy/pulse(src)
	update_appearance()

/obj/item/tank/internals/tactical/e_gun/Initialize()	//ERT Commander, ERT Medic, ERT Engineer,
	. = ..()
	new /obj/item/gun/energy/e_gun(src)
	update_appearance()

/obj/item/tank/internals/tactical/e_gun_taser/Initialize()	//ERT Security, Охранник Инвизиторов
	. = ..()
	new /obj/item/gun/energy/e_gun/stun(src)
	update_appearance()

//Быстрое извлечение через ЛКМ, быстрое разоружение через "E" тут code\modules\mob\inventory.dm
/obj/item/tank/internals/tactical/attack_hand(mob/user)
	if(loc == user)
		if(user.get_item_by_slot(ITEM_SLOT_SUITSTORE) == src)
			if(!user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE, TRUE))
				return
			if(length(contents))
				var/obj/item/I = contents[1]
				user.visible_message(span_notice("[user] достаёт [I] из [src]."), span_notice("Достаю [I] из [src]."))
				user.put_in_hands(I)
				update_appearance()
			else
				to_chat(user, span_warning("Крепления расстегнуты, [capitalize(src.name)] пуст."))
				..()
		else ..()
	else ..()
	return

//Изменение картинки в зависимости от содержания, прародители должны быть в списке до наследников, если моделька не прописана, то будет стоять коробка
/obj/item/tank/internals/tactical/update_icon_state()
	icon_state = initial(icon_state)
	worn_icon_state = initial(worn_icon_state)
	if(length(contents))
		var/obj/item/I = contents[1]
		worn_icon_state = "full"
		playsound(I, 'sound/items/equip/toolbelt_equip.ogg', 25, TRUE)
		if(istype(I,/obj/item/gun))
			icon_state = "box"
		if(istype(I,/obj/item/gun/ballistic/automatic/pistol))
			icon_state = "pistol"
		if(istype(I,/obj/item/gun/ballistic/revolver))
			icon_state = "pistol"
		if(istype(I,/obj/item/gun/ballistic/automatic/wt550))
			icon_state = "wt550"
		if(istype(I,/obj/item/gun/ballistic/automatic/M41A))
			icon_state = "m41a"
		if(istype(I,/obj/item/gun/ballistic/automatic/ak))
			icon_state = "ak"
		if(istype(I,/obj/item/gun/ballistic/automatic/ak47))
			icon_state = "ak"
		if(istype(I,/obj/item/gun/ballistic/automatic/assault_rifle))
			icon_state = "ar"
		if(istype(I,/obj/item/gun/ballistic/automatic/c20r))
			icon_state = "c20"
		if(istype(I,/obj/item/gun/ballistic/automatic/m90))
			icon_state = "m90"
		if(istype(I,/obj/item/gun/ballistic/rocketlauncher))
			icon_state = "rocket"
		if(istype(I,/obj/item/gun/ballistic/shotgun/bulldog))
			icon_state = "bulldog"
		if(istype(I,/obj/item/gun/energy/kinetic_accelerator))
			icon_state = "kinetic"
		if(istype(I,/obj/item/gun/energy/laser))
			icon_state = "laser"
		if(istype(I,/obj/item/gun/energy/laser/rangers))
			icon_state = "rangerlaser"
		if(istype(I,/obj/item/gun/energy/laser/captain))
			icon_state = "cap"
		if(istype(I,/obj/item/gun/energy/e_gun))
			icon_state = "egun"
		if(istype(I,/obj/item/gun/energy/e_gun/nuclear))
			icon_state = "nuke"
		if(istype(I,/obj/item/gun/energy/e_gun/hos))
			icon_state = "hos"
		if(istype(I,/obj/item/gun/energy/e_gun/stun))
			icon_state = "egun_taser"
		if(istype(I,/obj/item/gun/energy/xray))
			icon_state = "xray"
		if(istype(I,/obj/item/gun/energy/e_gun/mini))
			icon_state = "pistol"
		if(istype(I,/obj/item/gun/energy/pulse))
			icon_state = "pulse"
		if(istype(I,/obj/item/gun/energy/pulse/pistol))
			icon_state = "pistol"
	return ..()


//	Торговый автомат продукция
/obj/item/clothing/shoes/magboots/ranger
	name = "военные магнитные ботинки"
	desc = "Магнитные ботинки военного образца, используются для фиксации пользователя к корпусам вражеских кораблей и космических станций. Замедляют пользователя не так сильно в отличии от гражданского образца."
	slowdown_active = 1.5

//	Хранилище с антипаразитами
/obj/item/storage/secure/safe/rangers
	name = "чрезвычайное хранилище"
	desc = "Содержит в себе несколько доз препаратов от паразитов таких как Раккун-2 и Ностромо-7, способных обратить процесс заражения ксеноугрозой."
	icon = 'white/Feline/icons/safe.dmi'
	icon_state = "rangers"

/obj/item/storage/secure/safe/rangers/PopulateContents()
	new /obj/item/reagent_containers/hypospray/medipen/raccoon(src)
	new /obj/item/reagent_containers/hypospray/medipen/nostromo(src)
	new /obj/item/paper/rangers(src)

/obj/item/paper/rangers
	name = "отказ от претензий"
	info = "<center>Инструкция по применению</center><BR><BR>Перед использованием препаратов Раккун-2 и Ностромо-7 рекомендуется:<BR>1) Составить завещание<BR>* Решить вопросы опекунства над детьми (при их наличии)<BR>* Решить вопросы наследования<BR>2) Надежно зафиксировать пациента любыми доступными способами, рекомендуется смирительная рубашка и кляп<BR>* Вколоть пациенту обезболивающее<BR>* Вколоть пациенту седативные средства<BR>* Вколоть пациенту противошоковое<BR>3) Произнести молитву о здравии и за упокой души пациента любому богу из одобренного компанией списка. Список одобренных богов:<BR>* Нанотрейзен<BR>* Космический Иисус<BR>* Верховная Кошка<BR>* Великий Ящер<BR>* <font color=#006699><i>Капитан</i></font><BR>Компания Нанотрейзен не несет никакой ответственности за последствия использования препарата<BR>В случае получения в процессе необратимых случайных мутаций каких либо сверхъестественных сил, вы ОБЯЗАНЫ составить рапорт и самолично явиться в лабораторию для продления текущего контракта до пожизненного статуса.<BR><BR> Удачной миссии! Компания Нанотрейзен всегда готова поддержать вас в трудную минуту!"


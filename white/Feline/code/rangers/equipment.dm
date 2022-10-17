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
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals/emergency_oxygen)
	var/static/list/holdable_weapons_list = list(
		/obj/item/kinetic_crusher = "crusher",
		/obj/item/gun/ballistic/shotgun/automatic/combat = "auto_shotgun",
		/obj/item/gun/ballistic/shotgun/riot = "shotgun",
		/obj/item/gun/ballistic/shotgun/doublebarrel = "doublebarrel",
		/obj/item/gun/grenadelauncher = "grenadelauncher",
		/obj/item/gun/ballistic/automatic/pistol = "pistol",
		/obj/item/gun/ballistic/automatic/pistol/nail_gun = "nail_gun",
		/obj/item/gun/ballistic/revolver = "pistol",
		/obj/item/gun/ballistic/automatic/wt550 = "wt550",
		/obj/item/gun/ballistic/automatic/M41A = "m41a",
		/obj/item/gun/ballistic/automatic/ak = "ak",
		/obj/item/gun/ballistic/automatic/ak47 = "ak",
		/obj/item/gun/ballistic/automatic/assault_rifle = "ar",
		/obj/item/gun/ballistic/automatic/c20r = "c20",
		/obj/item/gun/ballistic/automatic/m90 = "m90",
		/obj/item/gun/ballistic/rocketlauncher = "rocket",
		/obj/item/gun/ballistic/shotgun/bulldog = "bulldog",
		/obj/item/gun/energy/kinetic_accelerator = "kinetic",
		/obj/item/gun/energy/laser = "laser",
		/obj/item/gun/energy/laser/rangers = "rangerlaser",
		/obj/item/gun/energy/laser/captain = "cap",
		/obj/item/gun/energy/e_gun = "egun",
		/obj/item/gun/energy/e_gun/nuclear = "nuke",
		/obj/item/gun/energy/e_gun/hos = "hos",
		/obj/item/gun/energy/e_gun/stun = "egun_taser",
		/obj/item/gun/energy/xray = "xray",
		/obj/item/gun/energy/e_gun/mini = "pistol",
		/obj/item/gun/energy/pulse = "pulse",
		/obj/item/gun/energy/pulse/pistol = "pistol",
	)

/obj/item/tank/internals/tactical/Initialize(mapload)
	. = ..()
	create_storage(type = /datum/storage/pockets/tactical)

//Наполнение баллона воздухом (стандарт)
/obj/item/tank/internals/tactical/populate_gas()
	air_contents.set_moles(GAS_O2, (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))


//Параметры кармана
/datum/storage/pockets/tactical
	max_slots = 1
	max_specific_storage = WEIGHT_CLASS_BULKY
	rustle_sound = FALSE
	attack_hand_interact = TRUE

//Тип хранимого
/datum/storage/pockets/tactical/New(atom/parent, max_slots, max_specific_storage, max_total_storage, numerical_stacking, allow_quick_gather, allow_quick_empty, collection_mode, attack_hand_interact)
	. = ..()
	set_holdable(list(
		/obj/item/gun/ballistic,
		/obj/item/gun/energy,
		/obj/item/kinetic_crusher,
		/obj/item/gun/grenadelauncher
	))

//Спавн оружия в чехле, так можно задать пресеты, по умолчанию /obj/item/tank/internals/tactical/ должен быть пуст, а пресеты устанавливаются через наследников
/obj/item/tank/internals/tactical/Initialize(mapload)			//Эскадрон Смерти, шаттл Рейнджеров, Лазутчик Синдиката (корабль), Syndicate Operative - Full Kit (Лонер)
	. = ..()
	update_appearance()

/obj/item/tank/internals/tactical/wt550/Initialize(mapload)
	. = ..()
	new /obj/item/gun/ballistic/automatic/wt550(src)
	update_appearance()

/obj/item/tank/internals/tactical/pulse/Initialize(mapload)
	. = ..()
	new /obj/item/gun/energy/pulse(src)
	update_appearance()

/obj/item/tank/internals/tactical/e_gun/Initialize(mapload)	//ERT Commander, ERT Medic, ERT Engineer,
	. = ..()
	new /obj/item/gun/energy/e_gun(src)
	update_appearance()

/obj/item/tank/internals/tactical/e_gun_taser/Initialize(mapload)	//ERT Security, Охранник Инвизиторов
	. = ..()
	new /obj/item/gun/energy/e_gun/stun(src)
	update_appearance()

/obj/item/tank/internals/tactical/nail_gun/Initialize(mapload)	//VIP Инженер
	. = ..()
	new /obj/item/gun/ballistic/automatic/pistol/nail_gun(src)
	update_appearance()

//Быстрое извлечение через ЛКМ, быстрое разоружение через "E" тут code\modules\mob\inventory.dm
/obj/item/tank/internals/tactical/attack_hand(mob/user)
	if(loc != user || user.get_item_by_slot(ITEM_SLOT_SUITSTORE) != src || !user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE, TRUE))
		return ..()

	if(length(contents))
		var/obj/item/I = contents[1]
		user.visible_message(span_notice("[user] достаёт [I] из [src]."), span_notice("Достаю [I] из [src]."))
		user.put_in_hands(I)
		update_appearance()
		user.update_inv_s_store()
	else
		to_chat(user, span_warning("Крепления расстегнуты, [capitalize(src.name)] пуст."))

	return ..()

//Изменение картинки в зависимости от содержания
/obj/item/tank/internals/tactical/update_icon_state()
	icon_state = initial(icon_state)
	worn_icon_state = initial(worn_icon_state)
	if(!length(contents))
		cut_overlays()
		return ..()
	var/obj/item/I = contents[1]
	worn_icon_state = "full"
	playsound(I, 'sound/items/equip/toolbelt_equip.ogg', 25, TRUE)

	if(I.type in holdable_weapons_list)
		icon_state = holdable_weapons_list[I.type]
	else
		var/mutable_appearance/gun_overlay = mutable_appearance(I.icon, I.icon_state)
		var/matrix/M = matrix()
		M.Turn(-90)
		M.Translate(-4, 0)
		gun_overlay.transform = M
		add_overlay(gun_overlay)
		icon_state = "box"

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


/obj/item/gun/ballistic/automatic/pistol/nail_gun
	name = "гвоздомет"
	desc = "Промышленный гвоздомет для монтажа всего до чего дотянутся очумелые ручки. Оснащен специальным формовщиком для производства <B>гвоздей</B> из <B>металических стержней</B>. Ударная пружина заменена на более мощную, при выстрелах лягается как мул и его приходится <B>держать двумя руками</B> - это немного не соответствует техники безопасности, однако теперь возвращаться по техам в каюту после смены не так страшно."
	icon_state = "m1911"
	icon = 'white/Feline/icons/nail_gun.dmi'
	icon_state = "nail_gun"
	w_class = WEIGHT_CLASS_BULKY
	mag_type = /obj/item/ammo_box/magazine/nails
	can_suppress = FALSE
	fire_sound = 'white/Feline/sounds/nail_gun_2.ogg'
	rack_sound = 'sound/weapons/gun/sniper/rack.ogg'
	lock_back_sound = 'sound/weapons/gun/pistol/slide_lock.ogg'
	bolt_drop_sound = 'sound/weapons/gun/general/bolt_drop.ogg'

/obj/item/gun/ballistic/automatic/pistol/nail_gun/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/stack/rods))	// 	Боеприпасы для гвоздомета
		var/obj/item/stack/rods/R = W
		playsound(user, 'white/Feline/sounds/nail_drop.ogg', 100, TRUE)
		if(R.amount > 1)
			R.amount = R.amount - 1
			update_icon()
		else
			qdel(W)
		new /obj/item/ammo_casing/nail(user.drop_location())
		new /obj/item/ammo_casing/nail(user.drop_location())
	. = ..()

/obj/item/ammo_box/magazine/nails
	name = "магазин гвоздомета"
	desc = "Жесткий коробчатый магазин для промышленного инструмента, вмещает до 16 крупных гвоздей."
	icon = 'white/Feline/icons/nail_gun.dmi'
	icon_state = "nail_gun_magasine"
	ammo_type = /obj/item/ammo_casing/nail
	caliber = "100x4"
	max_ammo = 16

/obj/item/ammo_box/magazine/nails/pve
	name = "магазин гвоздомета"
	desc = "Жесткий коробчатый магазин для промышленного инструмента, вмещает до 16 крупных гвоздей. Внутри находятся гвозди из странного синего металла."
	ammo_type = /obj/item/ammo_casing/nail/pve

/obj/item/ammo_box/nail
	name = "коробка гвоздей"
	desc = "Коробка вмещающая приличное количество самых обычных строительных гвоздей."
	icon = 'white/Feline/icons/nail_gun.dmi'
	icon_state = "nail_box"
	ammo_type = /obj/item/ammo_casing/nail
	max_ammo = 64

/obj/item/ammo_box/nail/pve
	name = "коробка синих гвоздей"
	desc = "Внутри находятся гвозди из странного синего металла, кажется примитивным тварям он не очень нравится."
	icon = 'white/Feline/icons/nail_gun.dmi'
	icon_state = "nail_box"
	ammo_type = /obj/item/ammo_casing/nail/pve
	max_ammo = 64

/obj/item/ammo_casing/nail
	name = "гвоздь"
	desc = "Гвоздь сотка. Насколько бы далеко не зашел технологический прогресс, держаться он будет только на гвоздях, изоленте и честном слове."
	icon = 'white/Feline/icons/nail_gun.dmi'
	icon_state = "nail"
	caliber = "100x4"
	projectile_type = /obj/projectile/bullet/nail

/obj/projectile/bullet/nail
	name = "гвоздь"
	damage = 20
	wound_bonus = -10
	wound_falloff_tile = -10

/obj/item/ammo_casing/nail/update_icon()
	. = ..()
	if(!loaded_projectile)
		qdel(src)

/obj/item/ammo_casing/nail/pve
	name = "синий гвоздь"
	desc = "Странный гвоздь из металла синего цвета. Созданный от безвыходности, он оказывает на удивление убойный эффект на примитивных тварей, что тут обитают."
	icon = 'white/Feline/icons/nail_gun.dmi'
	icon_state = "nail_blue"
	caliber = "100x4"
	projectile_type = /obj/projectile/bullet/nail/pve

/obj/projectile/bullet/nail/pve
	name = "синий гвоздь"

/obj/projectile/bullet/nail/on_hit(atom/target, blocked = FALSE)

	if(iscarbon(target))
		damage = 7
	if(issilicon(target))
		damage = 7
	if(isalienadult(target))
		damage = 20

/obj/projectile/bullet/nail/pve/on_hit(atom/target, blocked = FALSE)

	if(iscarbon(target))
		damage = 7
	if(issilicon(target))
		damage = 7
	if(isalienadult(target))
		damage = 25
/*
	if(isstunmob(target))
		var/mob/living/simple_animal/Z = target
		Z.AIStatus = AI_OFF
		addtimer(CALLBACK(Z, /mob/living/simple_animal/proc/re_ai), 1 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
*/
// 	Протонник

/obj/item/gun/energy/laser/rangers/sci
	name = "протонный пистолет"
	desc = "Прототип оружия с протоплазменной батареей. Он довольно эффективно проявил себя в отстреле тварей с полигона, однако расчеты показывают, что против людей он будет заметно слабее."
	icon = 'white/Feline/icons/weapon_rangers.dmi'
	icon_state = "proton_pistol"
	pin = /obj/item/firing_pin
	ammo_type = list(/obj/item/ammo_casing/energy/laser/pve)

	w_class = WEIGHT_CLASS_SMALL
	cell_type = /obj/item/stock_parts/cell/mini_egun
	charge_sections = 3
	dual_wield_spread = 10

	ammo_x_offset = 1
	shaded_charge = 1

/obj/item/gun/energy/laser/rangers/sci/add_seclight_point()
	AddComponent(/datum/component/seclite_attachable, \
		starting_light = new /obj/item/flashlight/seclite(src), \
		is_light_removable = FALSE, \
		light_overlay_icon = 'icons/obj/weapons/guns/flashlights.dmi', \
		light_overlay = "mini-light", \
		overlay_x = 19, \
		overlay_y = 13)

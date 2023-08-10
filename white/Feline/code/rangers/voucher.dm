//Ваучер на экипировку

/obj/item/rangers_voucher
	name = "рейнджерский ваучер"
	desc = "Талончик, который вы можете обменять на согласованные с ЦК наборы снаряжения. Для использования вставьте его в приемник рейнджерского торгового автомата."
	icon = 'white/Feline/icons/voucher_duffelbag.dmi'
	icon_state = "rangers_voucher"
	w_class = WEIGHT_CLASS_TINY

//Использование ваучера

/obj/machinery/vendor/exploration/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/rangers_voucher))
		RedeemVoucherRanger(I, user)
		return
	return ..()

/obj/machinery/vendor/proc/RedeemVoucherRanger(obj/item/rangers_voucher/voucher, mob/redeemer)
	var/items = list("Набор экипировки рейнджера-медика", "Набор экипировки рейнджера-инженера", "Набор экипировки рейнджера-боевика")

	var/selection = tgui_input_list(redeemer, "Выберите специализацию", "Ваучер будет погашен", sort_list(items))
	if(!selection || !Adjacent(redeemer) || QDELETED(voucher) || voucher.loc != redeemer)
		return
	var/drop_location = drop_location()
	switch(selection)
		if("Набор экипировки рейнджера-медика")
			new /obj/item/storage/backpack/duffelbag/rangers/med(drop_location)
		if("Набор экипировки рейнджера-инженера")
			new /obj/item/storage/backpack/duffelbag/rangers/engi(drop_location)
		if("Набор экипировки рейнджера-боевика")
			new /obj/item/storage/backpack/duffelbag/rangers/gunner(drop_location)

	SSblackbox.record_feedback("tally", "rangers_voucher_redeemed", 1, selection)
	qdel(voucher)



//Наборы

/obj/item/storage/backpack/duffelbag/rangers
	name = "сумка рейнджера"
	desc = "Объемная сумка для рейнджеров."
	icon = 'white/Feline/icons/voucher_duffelbag.dmi'
	icon_state = "leader"
	inhand_icon_state = "duffel-captain"
	worn_icon = 'icons/mob/clothing/back.dmi'
	worn_icon_state = "duffel-captain"

//Медицинский Набор

/obj/item/storage/backpack/duffelbag/rangers/med
	name = "набор экипировки рейнджера-медика"
	desc = "Огромная сумка с медицинскими инструментами для полевой хирургии, медикаментами экстренной помощи и оборудованием для поиска и мониторинга здоровья экипажа. Позволяет спасать жизни, даже находясь в десятках тысяч километров от цивилизации."
	icon_state = "med"
	inhand_icon_state = "duffel-med"
	worn_icon = 'icons/mob/clothing/back.dmi'
	worn_icon_state = "duffel-med"

/obj/item/storage/backpack/duffelbag/rangers/med/PopulateContents()
	new /obj/item/defibrillator/loaded(src)
	new /obj/item/storage/firstaid/medical/field_surgery(src)
	new /obj/item/clothing/gloves/color/latex/nitrile(src)
	new /obj/item/roller(src)
	new /obj/item/pinpointer/crew(src)
	new /obj/item/sensor_device(src)
	new /obj/item/clothing/glasses/hud/health(src)
	new /obj/item/reagent_containers/medigel/sterilizine(src)
	new /obj/item/reagent_containers/medigel/libital(src)
	new /obj/item/storage/belt/medipenal/rangers(src)
	new /obj/item/skillchip/job/medic/advanced(src)



/obj/item/storage/firstaid/medical/field_surgery
	name = "укладка полевого хирурга"
	desc = "Компактный набор самых необходимых медицинских инструментов для неотложного хирургического вмешательства в полевых условиях."

/obj/item/storage/firstaid/medical/field_surgery/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/stack/medical/gauze/twelve = 1,
		/obj/item/stack/medical/suture/medicated = 1,
		/obj/item/stack/medical/mesh/advanced = 1,
		/obj/item/reagent_containers/hypospray/medipen = 1,
		/obj/item/surgical_drapes = 1,
		/obj/item/scalpel = 1,
		/obj/item/hemostat = 1,
		/obj/item/retractor = 1,
		/obj/item/circular_saw = 1,
		/obj/item/bonesetter = 1,
		/obj/item/blood_filter = 1,
		/obj/item/cautery = 1,
		/obj/item/healthanalyzer/range = 1)
	generate_items_inside(items_inside,src)

//Инженерный Набор

/obj/item/storage/backpack/duffelbag/rangers/engi
	name = "набор экипировки рейнджера-инженера"
	desc = "Сумка инженера-бортмеханика, содержит инструменты для залатывания своего корпуса и создания дыр в чужом."
	icon_state = "engi"
	inhand_icon_state = "duffel-eng"
	worn_icon = 'icons/mob/clothing/back.dmi'
	worn_icon_state = "duffel-eng"

/obj/item/storage/backpack/duffelbag/rangers/engi/PopulateContents()
	new /obj/item/storage/box/demolition(src)
	new /obj/item/stack/sheet/iron/fifty(src)
	new /obj/item/stack/sheet/glass/fifty(src)
	new /obj/item/storage/belt/utility/full/engi(src)
	new /obj/item/gun/energy/plasmacutter/adv/rangers(src)
	new /obj/item/inducer(src)
	new /obj/item/storage/part_replacer/bluespace/tier2(src)
	new /obj/item/stock_parts/cell/hyper(src)
	new /obj/item/clothing/glasses/meson(src)
	new /obj/item/clothing/gloves/color/chief_engineer(src)
	new /obj/item/holosign_creator/atmos(src)
	new /obj/item/sbeacondrop/exploration(src)
	new /obj/item/research_disk_pinpointer(src)
	new /obj/item/skillchip/job/engineer(src)

/obj/item/storage/box/demolition
	name = "боеукладка разрушителя"
	desc = "Для организации прохода туда, куда вас не хотели пускать по хорошему."
	icon_state = "plasticbox"

/obj/item/storage/box/demolition/PopulateContents()
	new /obj/item/grenade/exploration(src)
	new /obj/item/grenade/exploration(src)
	new /obj/item/grenade/exploration(src)
	new /obj/item/grenade/exploration(src)
	new /obj/item/grenade/exploration(src)
	new /obj/item/exploration_detonator(src)

/obj/item/gun/energy/plasmacutter/adv/rangers
	name = "плазменный резак \"Термит\""
	desc = "Тяжелая версия плазменного резака адаптированная для быстрого вскрытия обшивки. Батарея адаптирована под питание от стандартных оружейных зарядников. Так же в корпус встроен миниатюрный генератор гамма излучения."
	icon = 'white/Feline/icons/rangers_engi.dmi'
	icon_state = "termit"
	inhand_icon_state = "plasmacutter_mega"
	can_charge = TRUE
	w_class = WEIGHT_CLASS_BULKY
	ammo_type = list(/obj/item/ammo_casing/energy/plasma/adv/pve)

//Боевой Набор

/obj/item/storage/backpack/duffelbag/rangers/gunner
	name = "набор экипировки рейнджера-боевика"
	desc = "Продвинутое снаряжение для зачистки реликтов в глубоком космосе, поможет сохранить социальную дистанцию и ясность сознания."
	icon_state = "gunner"
	inhand_icon_state = "duffel-sec"
	worn_icon = 'icons/mob/clothing/back.dmi'
	worn_icon_state = "duffel-sec"

/obj/item/storage/backpack/duffelbag/rangers/gunner/PopulateContents()
	new /obj/item/gun/energy/laser/rangers(src)
	new /obj/item/storage/belt/avangard_belt(src)
	new /obj/item/forcefield_projector(src)
	new /obj/item/clothing/glasses/night(src)
	new /obj/item/storage/pill_bottle/saver(src)
	new /obj/item/shield/riot/tele(src)
	new /obj/item/reagent_containers/hypospray/medipen/salacid(src)

/obj/item/gun/energy/laser/rangers
	name = "экспериментальная лазерная винтовка"
	desc = "Неожиданный результат экспериментов Нанотрейзен в области увеличения энергоячеек. Боезапас винтовки был удвоен, но из за особенностей энергораспределения поражающая мощность понизилась. Однако был обнаружен полезный побочный эффект: нестабильное излучение оказывает чрезвычайно разрушительный эффект на нервную систему примитивных форм жизни. Предоставлена корпусу рейнджеров на полевые испытания."
	icon = 'white/Feline/icons/weapon_rangers.dmi'
	icon_state = "rangerlaser"
	charge_sections = 8
	pin = /obj/item/firing_pin/off_station
	ammo_type = list(/obj/item/ammo_casing/energy/laser/pve)
	cell_type = /obj/item/stock_parts/cell/hos_gun

////	Протонный резак		////

/obj/item/melee/sabre/proton_cutter
	name = "протонный резак"
	desc = "Массивный абордажный палаш оснащенный генератором гамма излучения, которое негативно сказывается на нервной системе примитивных форм жизни. Так же можно дополнительно форсировать генератор для полной парализации. Эффект на разумные формы жизни значительно снижен. Из-за массивного лезвия его можно использовать как лом для отжимания пожарных шлюзов и обесточенных дверей."

	force = 15
	block_chance = 45
	armour_penetration = 10
	wound_bonus = 0
	bare_wound_bonus = 5

	icon = 'white/Feline/icons/proton_cutter.dmi'
	icon_state = "proton"
	lefthand_file = 'white/Feline/icons/proton_cutter_left.dmi'
	righthand_file = 'white/Feline/icons/proton_cutter_right.dmi'
	inhand_icon_state = "proton"
	light_color = "#41f4e5"
	light_power = 2
	light_range = 3
	light_on = FALSE
	light_system = MOVABLE_LIGHT
	tool_behaviour = TOOL_SAW

	var/amplification = FALSE
	var/last_activation = 0
	var/recharge = 10 SECONDS
	var/static/mutable_appearance/stun_overlay = mutable_appearance('white/Feline/icons/proton_cutter_stun.dmi', "stun", LYING_MOB_LAYER)

	var/datum/effect_system/spark_spread/sparks

/obj/item/melee/sabre/proton_cutter/Initialize(mapload)	// 	Искры
	. = ..()
	sparks = new
	sparks.set_up(5, 0, src)
	sparks.attach(src)

/obj/item/melee/sabre/proton_cutter/Destroy()
	if(sparks)
		qdel(sparks)
	sparks = null
	. = ..()

/obj/item/melee/sabre/proton_cutter/on_exit_storage(datum/storage/S)		//	Выхватывание из ножен, звуки
	var/obj/item/storage/belt/avangard_belt/B = S.real_location?.resolve()
	if(istype(B))
		playsound(B, 'sound/items/unsheath.ogg', 25, TRUE)

/obj/item/melee/sabre/proton_cutter/on_enter_storage(datum/storage/S)
	var/obj/item/storage/belt/avangard_belt/B = S.real_location?.resolve()
	if(istype(B))
		playsound(B, 'sound/items/sheath.ogg', 25, TRUE)
		if(amplification)
			proton_off()
			playsound(B, 'white/Feline/sounds/proton_cutter_off.ogg', 100, TRUE)

/datum/movespeed_modifier/proton_cutter		//	Контроль
	multiplicative_slowdown = 1

/datum/movespeed_modifier/proton_cutter_heavy
	multiplicative_slowdown = 2

/obj/item/melee/sabre/proton_cutter/attack_self(mob/user)	//	Зарядка
	if(!amplification)
		if(last_activation + recharge < world.time)
			icon_state = "proton-on"
			inhand_icon_state = "proton-on"
			light_range = 3
			playsound(user, 'white/Feline/sounds/proton_cutter.ogg', 100, TRUE)
			user.visible_message(span_warning("Протонный резак в руках [user] выплескивает шквал искр!"), span_notice("Форсирую генератор гамма излучения. Протонный резак выплескивает шквал искр!"))
			sparks.start()
			amplification = TRUE
			set_light_on(amplification)
		else
			to_chat(user, span_warning("Генератор перегружен! Необходимо охлаждение перед повторным применением."))
	else
		proton_off()
		playsound(user, 'white/Feline/sounds/proton_cutter_off.ogg', 100, TRUE)
		to_chat(user, span_notice("Приглушаю генератор гамма излучения!"))

// 	Список разрешенных мобов
//#define isstunmob(A) (istype(A, /mob/living/simple_animal/hostile/zombie) || istype(A, /mob/living/simple_animal/hostile/alien) || istype(A, /mob/living/simple_animal/hostile/giant_spider) || istype(A, /mob/living/simple_animal/hostile/netherworld) || istype(A, /mob/living/simple_animal/hostile/blob) || istype(A, /mob/living/simple_animal/hostile/ratvar))

/mob/living/simple_animal/proc/re_ai()
	AIStatus = AI_ON

/obj/item/melee/sabre/proton_cutter/proc/proton_off()	//	Стандартное выключение
	amplification = FALSE
	set_light_on(amplification)
	icon_state = "proton"
	inhand_icon_state = "proton"
	light_range = 0

/obj/item/melee/sabre/proton_cutter/proc/proton_attack(mob/living/M, mob/living/user, var/T)	// 	+ После удара
	M.add_overlay(stun_overlay)
	addtimer(CALLBACK(M, /atom/proc/cut_overlay, stun_overlay), T SECONDS)
	last_activation = world.time
	if(prob(50))
		playsound(user, 'white/Feline/sounds/proton_cutter_amp_hit_1.ogg', 100, TRUE)
	else
		playsound(user, 'white/Feline/sounds/proton_cutter_amp_hit_2.ogg', 100, TRUE)


/obj/item/melee/sabre/proton_cutter/attack(mob/living/M, mob/living/user)	// 	Атака
// 	Мобы
	if(!iscarbon(M) && !iscyborg(M))
		if(amplification)

			if(isstunmob(M))
				var/mob/living/simple_animal/Z = M
				Z.AIStatus = AI_OFF
				addtimer(CALLBACK(Z, /mob/living/simple_animal/proc/re_ai), 5 SECONDS)

			force = 60
			M.Paralyze(5 SECONDS, ignore_canstun = TRUE)
			M.Jitter(5 SECONDS)
			proton_off()
			proton_attack(M, user, 5)
		else
			force = 30
		..()
		return
// 	Киборги
	if(iscyborg(M))
		if(amplification)
			force = 30
			M.Paralyze(5 SECONDS)
			proton_off()
			proton_attack(M, user, 5)
		else
			force = 15
		..()
		return
// 	Космонавтики
	if(iscarbon(M) && !isalien(M) && !ismonkey(M))
		if(amplification)
			if(iszombie(M))
				force = 60
				M.Paralyze(5 SECONDS, ignore_canstun = TRUE)
			else
				force = 25
				M.add_movespeed_modifier(/datum/movespeed_modifier/proton_cutter_heavy)
				addtimer(CALLBACK(M, /mob/proc/remove_movespeed_modifier, /datum/movespeed_modifier/proton_cutter_heavy), 5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
			proton_off()
			proton_attack(M, user, 5)
		else
			if(iszombie(M))
				force = 30
			else
				force = 15
		..()
		return
// 	Чужие
	if(isalienadult(M) || ismonkey(M))
		if(amplification)
			force = 60

			if(ismonkey(M))
				M.Paralyze(5 SECONDS, ignore_canstun = TRUE)

			if(isstunmob(M) && !isalienroyal(M))
				var/mob/living/simple_animal/hostile/alien/Z = M
				Z.AIStatus = AI_OFF
				addtimer(CALLBACK(Z, /mob/living/simple_animal/proc/re_ai), 5 SECONDS)
				addtimer(CALLBACK(M, /atom/proc/cut_overlay, stun_overlay), 5 SECONDS)

			if(!isalienroyal(M))
				M.Paralyze(5 SECONDS, ignore_canstun = TRUE)
			else
				M.add_movespeed_modifier(/datum/movespeed_modifier/proton_cutter_heavy)
				addtimer(CALLBACK(M, /mob/proc/remove_movespeed_modifier, /datum/movespeed_modifier/proton_cutter_heavy), 5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)

			proton_off()
			proton_attack(M, user, 5)
		else
			force = 30
		..()
		return

/obj/item/melee/sabre/proton_cutter/attack_obj(obj/O, mob/living/user)
	force = 20
	..()
	return

/obj/item/storage/belt/avangard_belt
	name = "пояс авангарда рейнджеров"
	desc = "Специальные тактические ножны для протонного резака оснащенные удобными карманами для снаряжения."
	icon = 'white/Feline/icons/rangers_belt.dmi'
	icon_state = "avangard"
	inhand_icon_state = "security"
	worn_icon = 'white/Feline/icons/rangers_belt_back.dmi'
	worn_icon_state = "avangard"
	content_overlays = FALSE
	w_class = WEIGHT_CLASS_BULKY

/obj/item/storage/belt/avangard_belt/update_icon_state()
	if(locate(/obj/item/melee/sabre/proton_cutter) in contents)
		icon_state = "avangard-on"
		worn_icon_state = "avangard-on"
	else
		icon_state = "avangard"
		worn_icon_state = "avangard"
	return ..()

/obj/item/storage/belt/avangard_belt/examine(mob/user)
	. = ..()
	. += "<hr>"
	if(length(contents))
		. += span_notice("ЛКМ, чтобы мгновенно выхватить резак. ПКМ, для доступа к кармашкам.")

/obj/item/storage/belt/avangard_belt/attack_hand(mob/user, list/modifiers)

	if(loc == user)
		if(user.get_item_by_slot(ITEM_SLOT_BELT) == src)
			if(!user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE, TRUE, FLOOR_OKAY))
				return
			for(var/i in contents)
				if(istype(i, /obj/item/melee/sabre/proton_cutter))
					user.visible_message(span_notice("[user] достаёт из ножен [i]."), span_notice("Достаю [i] из ножен."))
					user.put_in_hands(i)
					update_appearance()
					playsound(user, 'sound/items/unsheath.ogg', 40, TRUE)
					return
	else ..()
	return

/obj/item/storage/belt/avangard_belt/Initialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	atom_storage.max_slots = 5
	atom_storage.max_total_storage = 30
	atom_storage.max_specific_storage = WEIGHT_CLASS_BULKY
	atom_storage.silent = TRUE
	atom_storage.set_holdable(list(
		/obj/item/melee/sabre/proton_cutter,
		/obj/item/melee/classic_baton,
		/obj/item/gun/ballistic/automatic/pistol,
		/obj/item/gun/ballistic/revolver,
		/obj/item/gun/energy/e_gun/mini,
		/obj/item/kitchen/knife,
		/obj/item/ammo_box,
		/obj/item/ammo_casing/shotgun,
		/obj/item/grenade,
		/obj/item/forcefield_projector,
		/obj/item/shield/riot/tele,
		/obj/item/clothing/glasses,
		/obj/item/clothing/gloves,
		/obj/item/gps,
		/obj/item/healthanalyzer,
		/obj/item/storage/pill_bottle,
		/obj/item/reagent_containers/pill,
		/obj/item/reagent_containers/hypospray,
		/obj/item/reagent_containers/medigel,
		/obj/item/stack/medical,
		/obj/item/reagent_containers/food/drinks
		))

/obj/item/storage/belt/avangard_belt/PopulateContents()
	new /obj/item/melee/sabre/proton_cutter(src)
	update_appearance()


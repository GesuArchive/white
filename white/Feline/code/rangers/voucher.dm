//Ваучер на экипировку

/obj/item/rangers_voucher
	name = "Рейнджерский ваучер"
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

	var/selection = input(redeemer, "Выберите специализацию", "Ваучер будет погашен") as null|anything in sortList(items)
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
	name = "Сумка Рейнджера"
	desc = "Объемная сумка для рейнджеров."
	icon = 'white/Feline/icons/voucher_duffelbag.dmi'
	icon_state = "leader"

//Медицинский Набор

/obj/item/storage/backpack/duffelbag/rangers/med
	name = "Набор экипировки рейнджера-медика"
	desc = "Огромная сумка с медицинскими инструментами для полевой хирургии, медикаментами экстренной помощи и оборудованием для поиска и мониторинга здоровья экипажа. Позволяет спасать жизни, даже находясь в десятках тысяч километров от цивилизации."
	icon_state = "med"

/obj/item/storage/backpack/duffelbag/rangers/med/PopulateContents()
	new /obj/item/defibrillator/loaded(src)
	new /obj/item/storage/firstaid/medical/field_surgery(src)
	new /obj/item/clothing/gloves/color/latex/nitrile(src)
	new /obj/item/roller(src)
	new /obj/item/pinpointer/crew(src)
	new /obj/item/sensor_device(src)
	new /obj/item/clothing/glasses/hud/health(src)
	new /obj/item/healthanalyzer(src)
	new /obj/item/reagent_containers/medigel/libital(src)
	new /obj/item/reagent_containers/hypospray/medipen/salacid(src)
	new /obj/item/reagent_containers/hypospray/medipen/penacid(src)



/obj/item/storage/firstaid/medical/field_surgery
	name = "Укладка полевого хирурга"
	desc = "Компактный набор самых необходимых медицинских инструментов для неотложного хирургического вмешательства в полевых условиях."

/obj/item/storage/firstaid/medical/field_surgery/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/stack/medical/gauze/twelve = 1,
		/obj/item/stack/medical/suture/medicated = 1,
		/obj/item/stack/medical/mesh/advanced = 1,
		/obj/item/reagent_containers/hypospray/medipen = 1,
		/obj/item/reagent_containers/medigel/sterilizine = 1,
		/obj/item/surgical_drapes = 1,
		/obj/item/scalpel = 1,
		/obj/item/hemostat = 1,
		/obj/item/retractor = 1,
		/obj/item/circular_saw = 1,
		/obj/item/bonesetter = 1,
		/obj/item/cautery = 1)
	generate_items_inside(items_inside,src)

//Инженерный Набор

/obj/item/storage/backpack/duffelbag/rangers/engi
	name = "Набор экипировки рейнджера-инженера"
	desc = "Сумка инженера-бортмеханика, содержит инструменты для залатывания своего корпуса и создания дыр в чужом."
	icon_state = "engi"

/obj/item/storage/backpack/duffelbag/rangers/engi/PopulateContents()
	new /obj/item/storage/box/demolition(src)
	new /obj/item/stack/sheet/iron/fifty(src)
	new /obj/item/stack/sheet/glass/fifty(src)
	new /obj/item/storage/belt/utility/full/engi(src)
	new /obj/item/gun/energy/plasmacutter(src)
	new /obj/item/inducer(src)
	new /obj/item/stock_parts/cell/hyper(src)
	new /obj/item/clothing/glasses/meson(src)
	new /obj/item/sbeacondrop/exploration(src)
	new /obj/item/research_disk_pinpointer(src)

/obj/item/storage/box/demolition
	name = "Боеукладка разрушителя"
	desc = "Для организации прохода туда, куда вас не хотели пускать по хорошему."
	icon_state = "plasticbox"

/obj/item/storage/box/demolition/PopulateContents()
	new /obj/item/grenade/exploration(src)
	new /obj/item/grenade/exploration(src)
	new /obj/item/grenade/exploration(src)
	new /obj/item/grenade/exploration(src)
	new /obj/item/grenade/exploration(src)
	new /obj/item/exploration_detonator(src)


//Боевой Набор

/obj/item/storage/backpack/duffelbag/rangers/gunner
	name = "Набор экипировки рейнджера-боевика"
	desc = "Продвинутое снаряжение для зачистки реликтов в глубоком космосе, поможет сохранить социальную дистанцию и ясность сознания."
	icon_state = "gunner"

/obj/item/storage/backpack/duffelbag/rangers/gunner/PopulateContents()
	new /obj/item/gun/energy/laser/rangers(src)
	new /obj/item/forcefield_projector(src)
	new /obj/item/clothing/glasses/night(src)
	new /obj/item/storage/pill_bottle/psicodine(src)
	new /obj/item/shield/riot/tele(src)
	new /obj/item/reagent_containers/hypospray/medipen/salacid(src)

/obj/item/gun/energy/laser/rangers
	name = "Экспериментальная лазерная пушка"
	desc = "Неожиданный результат экспериментов НТ в области увеличения энергоячеек. Боезапас винтовки был удвоен, но из за особенностей энергораспределения поражающая мощность понизилась. Однако был обнаружен полезный побочный эффект: нестабильное излучение оказывает чрезвычайно разрушительный эффект на нервную систему примитивных форм жизни. Предоставлена корпусу рейнджеров на полевые испытания."
	icon = 'white/Feline/icons/weapon_rangers.dmi'
	icon_state = "rangerlaser"
	charge_sections = 8
	pin = /obj/item/firing_pin/off_station
	ammo_type = list(/obj/item/ammo_casing/energy/laser/pve)
	cell_type = /obj/item/stock_parts/cell/hos_gun



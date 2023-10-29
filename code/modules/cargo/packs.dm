/datum/supply_pack
	var/name = "Crate"
	var/group = ""
	var/hidden = FALSE
	var/contraband = FALSE
	/// Cost of the crate. DO NOT GO ANY LOWER THAN X1.4 the "BUY_CRATE_VALUE" value if using regular crates, or infinite profit will be possible!
	var/cost = BUY_CRATE_VALUE * 1.4
	var/access = FALSE
	var/access_view = FALSE
	var/access_any = FALSE
	var/list/contains = null
	var/crate_name = "crate"
	var/desc = ""//no desc by default
	var/crate_type = /obj/structure/closet/crate
	var/dangerous = FALSE // Should we message admins?
	var/special = FALSE //Event/Station Goals/Admin enabled packs
	var/special_enabled = FALSE
	var/DropPodOnly = FALSE //only usable by the Bluespace Drop Pod via the express cargo console
	var/special_pod //If this pack comes shipped in a specific pod when launched from the express console
	var/admin_spawned = FALSE
	var/goody = FALSE //Goodies can only be purchased by private accounts and can have coupons apply to them. They also come in a lockbox instead of a full crate, so the 700 min doesn't apply

/datum/supply_pack/proc/generate(atom/A, datum/bank_account/paying_account)
	var/obj/structure/closet/crate/C
	if(paying_account)
		C = new /obj/structure/closet/crate/secure/owned(A, paying_account)
		C.name = "[crate_name] - Куплено [paying_account.account_holder]"
	else
		C = new crate_type(A)
		C.name = crate_name
	if(access)
		C.req_access = list(access)
	if(access_any)
		C.req_one_access = access_any

	fill(C)
	return C

/datum/supply_pack/proc/get_cost()
	. = cost
	. *= SSeconomy.pack_price_modifier

/datum/supply_pack/proc/fill(obj/structure/closet/crate/C)
	if (admin_spawned)
		for(var/item in contains)
			var/atom/A = new item(C)
			A.flags_1 |= ADMIN_SPAWNED_1
	else
		for(var/item in contains)
			if(GLOB.is_cargo_sabotaged && prob(25))
				var/datum/supply_pack/SP = pick(subtypesof(/datum/supply_pack/service))
				item = pick(SP.contains)
			new item(C)

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Emergency ///////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/emergency
	group = "Аварийное"

/datum/supply_pack/emergency/bio
	name = "Комплект биологической защиты"
	desc = "Содержит два комплекта биологической защиты с сопутствующим снаряжением и лекарствами."
	cost = BUY_CRATE_VALUE * 2
	contains = list(
		/obj/item/clothing/head/bio_hood,
		/obj/item/clothing/head/bio_hood,
		/obj/item/clothing/suit/bio_suit,
		/obj/item/clothing/suit/bio_suit,
		/obj/item/tank/internals/emergency_oxygen/engi,
		/obj/item/tank/internals/emergency_oxygen/engi,
		/obj/item/clothing/mask/breath/medical,
		/obj/item/clothing/mask/breath/medical,
		/obj/item/storage/bag/bio,
		/obj/item/storage/bag/bio,
		/obj/item/reagent_containers/syringe/antiviral,
		/obj/item/reagent_containers/syringe/antiviral,
		/obj/item/clothing/gloves/color/latex/nitrile,
		/obj/item/clothing/gloves/color/latex/nitrile,
		/obj/item/storage/pill_bottle/saver
		)
	crate_name = "ящик с биозащитой"

/datum/supply_pack/emergency/radiation
	name = "Комплект противорадиационной защиты"
	desc = "Содержит два комплекта противорадиационной защиты с сопутствующим снаряжением и лекарствами."
	cost = BUY_CRATE_VALUE * 2
	contains = list(
		/obj/item/clothing/head/radiation,
		/obj/item/clothing/head/radiation,
		/obj/item/clothing/suit/radiation,
		/obj/item/clothing/suit/radiation,
		/obj/item/geiger_counter,
		/obj/item/geiger_counter,
		/obj/item/reagent_containers/syringe/seiver_cold,
		/obj/item/reagent_containers/syringe/seiver_cold,
		/obj/item/reagent_containers/food/drinks/bottle/vodka,
		/obj/item/reagent_containers/food/drinks/drinkingglass/shotglass,
		/obj/item/reagent_containers/food/drinks/drinkingglass/shotglass
		)
	crate_name = "ящик с противорадиационной защитой"
	crate_type = /obj/structure/closet/crate/radiation

/datum/supply_pack/emergency/firefighting
	name = "Комплект противопожарной защиты"
	desc = "Содержит два комплекта противопожарной защиты с сопутствующим снаряжением и лекарствами."
	cost = BUY_CRATE_VALUE * 2
	contains = list(
		/obj/item/clothing/suit/fire/atmos,
		/obj/item/clothing/suit/fire/atmos,
		/obj/item/clothing/head/hardhat/red,
		/obj/item/clothing/head/hardhat/red,
		/obj/item/clothing/mask/gas/atmos,
		/obj/item/clothing/mask/gas/atmos,
		/obj/item/tank/internals/oxygen/red,
		/obj/item/tank/internals/oxygen/red,
		/obj/item/extinguisher/advanced,
		/obj/item/extinguisher/advanced,
		/obj/item/reagent_containers/syringe/leporazine,
		/obj/item/reagent_containers/syringe/leporazine,
		)
	crate_name = "ящик с противопожарной защитой"

/datum/supply_pack/emergency/bomb
	name = "Комплект сапера"
	desc = "Содержит в себе взрывостойкий костюм и разгрузку сапера. Станьте Героем посмертно! (дополнительное время в комплект поставки не входит)"
	cost = BUY_CRATE_VALUE * 2
	contains = list(
		/obj/item/clothing/head/bomb_hood,
		/obj/item/clothing/suit/bomb_suit,
		/obj/item/clothing/mask/gas,
		/obj/item/storage/belt/grenade/sapper,
		/obj/item/screwdriver,
		/obj/item/wirecutters,
		/obj/item/multitool,
		/obj/item/clothing/accessory/medal/bronze_heart
		)
	crate_name = "ящик с костюмом сапера"

/datum/supply_pack/emergency/internals
	name = "Комплект защиты при разгерметизации"
	desc = "Содержит в себе три комплекта индивидуальной самоспасательной экипировки ."
	cost = BUY_CRATE_VALUE * 2
	contains = list(
		/obj/item/emergency_shield/adv,
		/obj/item/emergency_shield/adv,
		/obj/item/emergency_shield/adv,
		/obj/item/clothing/mask/breath,
		/obj/item/clothing/mask/breath,
		/obj/item/clothing/mask/breath,
		/obj/item/tank/internals/emergency_oxygen/engi,
		/obj/item/tank/internals/emergency_oxygen/engi,
		/obj/item/tank/internals/emergency_oxygen/engi,
		/obj/item/tank/internals/oxygen,
		/obj/item/tank/internals/oxygen,
		/obj/item/tank/internals/oxygen)
	crate_name = "ящик самоспасения"
	crate_type = /obj/structure/closet/crate/internals

/datum/supply_pack/emergency/syndicate
	name = "ДАННЫЕ_УДАЛЕНЫ"
	desc = "(#@&^$В ЭТОЙ ПОСЫЛКЕ СОДЕРЖИТСЯ КАКОЕ-ТО СЛУЧАЙНОЕ СНАРЯЖЕНИЕ СИНДИКАТА ОБЩЕЙ СТОИМОСТЬЮ 30 ТК, КОТОРОЕ ВАЛЯЛОСЬ У НАС НА СКЛАДЕ. ЗАДАЙ ИМ ЖАРУ, ОПЕРАТИВНИК@&!*() "
	hidden = TRUE
	cost = BUY_CRATE_VALUE * 2000
	contains = list()
	crate_name = "ящик самоспасения"
	crate_type = /obj/structure/closet/crate/internals
	dangerous = TRUE

/datum/supply_pack/emergency/syndicate/fill(obj/structure/closet/crate/C)
	var/crate_value = 30
	var/list/uplink_items = get_uplink_items(UPLINK_TRAITORS)
	while(crate_value)
		var/category = pick(uplink_items)
		var/item = pick(uplink_items[category])
		var/datum/uplink_item/I = uplink_items[category][item]
		if(!I.surplus_nullcrates || prob(100 - I.surplus_nullcrates))
			continue
		if(crate_value < I.cost)
			continue
		crate_value -= I.cost
		new I.item(C)

/datum/supply_pack/emergency/plasmaman
	name = "Комплект снаряжения плазмамена"
	desc = "Содержит в себе всю жизненно важную экипировку плазмоменов - от перчаток до скафандра."
	cost = BUY_CRATE_VALUE * 3
	contains = list(
		/obj/item/clothing/under/plasmaman,
		/obj/item/clothing/under/plasmaman,
		/obj/item/tank/internals/plasmaman/belt/full,
		/obj/item/tank/internals/plasmaman/belt/full,
		/obj/item/clothing/head/helmet/space/plasmaman,
		/obj/item/clothing/head/helmet/space/plasmaman,
		/obj/item/clothing/gloves/color/plasmaman,
		/obj/item/clothing/gloves/color/plasmaman,
		/obj/item/clothing/suit/space/eva/plasmaman,
		/obj/item/clothing/suit/space/eva/plasmaman,
		/obj/item/clothing/head/helmet/space/plasmaman,
		/obj/item/clothing/head/helmet/space/plasmaman
		)
	crate_name = "ящик плазмамена"

/datum/supply_pack/emergency/spacesuit
	name = "Комплект скафандра"
	desc = "Содержит один скафандр и реактивный ранец."
	cost = BUY_CRATE_VALUE * 3
	access = ACCESS_EVA
	contains = list(
		/obj/item/clothing/suit/space,
		/obj/item/clothing/head/helmet/space,
		/obj/item/clothing/mask/breath,
		/obj/item/tank/jetpack/carbondioxide
		)
	crate_name = "ящик со скафандром"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/emergency/specialops
	name = "Комплект для спецопераций"
	desc = "(*!&@#РАССТРОИЛИСЬ ИЗ-ЗА ЭТОГО @#ДАННЫЕ_УДАЛЕНЫ!&, ДА, ОПЕРАТИВНИК? ЧТО Ж, ЭТОТ НЕБОЛЬШОЙ ЗАКАЗ ВСЕ ЕЩЕ МОЖЕТ ВЫРУЧИТЬ ВАС В ТРУДНУЮ МИНУТУ. СОДЕРЖИТ КОРОБКУ С ПЯТЬЮ ЭЛЕКТРОМАГНИТНЫМИ ГРАНАТАМИ, ТРЕМЯ ДЫМОВЫМИ ШАШКАМИ, ЗАЖИГАТЕЛЬНОЙ ГРАНАТОЙ И \"СОННОЙ РУЧКОЙ\", ПОЛНОЙ ПРИЯТНЫХ ТОКСИНОВ!#@*$"
	hidden = TRUE
	cost = BUY_CRATE_VALUE * 4
	contains = list(
		/obj/item/storage/box/emps,
		/obj/item/grenade/smokebomb,
		/obj/item/grenade/smokebomb,
		/obj/item/grenade/smokebomb,
		/obj/item/pen/sleepy,
		/obj/item/grenade/chem_grenade/incendiary
		)
	crate_name = "ящик самоспасения"
	crate_type = /obj/structure/closet/crate/internals

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Security ////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/security
	group = "Охрана"
	access = ACCESS_SECURITY
	crate_type = /obj/structure/closet/crate/secure/gear

/datum/supply_pack/security/armor
	name = "Комплект стандартной брони"
	desc = "Содержит три комплекта стандартной брони."
	cost = BUY_CRATE_VALUE * 2
	access_view = ACCESS_SECURITY
	contains = list(
		/obj/item/clothing/suit/armor/vest,
		/obj/item/clothing/suit/armor/vest,
		/obj/item/clothing/suit/armor/vest,
		/obj/item/clothing/head/helmet/sec,
		/obj/item/clothing/head/helmet/sec,
		/obj/item/clothing/head/helmet/sec,
		)
	crate_name = "ящик с стандартной броней"

/datum/supply_pack/security/bulletarmor
	name = "Комплект пуленепробиваемой брони"
	desc = "Содержит три комплекта пуленепробиваемой брони с шлемом."
	cost = BUY_CRATE_VALUE * 3
	contains = list(
		/obj/item/clothing/suit/armor/bulletproof,
		/obj/item/clothing/suit/armor/bulletproof,
		/obj/item/clothing/suit/armor/bulletproof,
		/obj/item/clothing/head/helmet/alt,
		/obj/item/clothing/head/helmet/alt,
		/obj/item/clothing/head/helmet/alt
		)
	crate_name = "ящик с пуленепробиваемой броней"

/datum/supply_pack/security/riotarmor
	name = "Комплект брони антибунт"
	desc = "Содержит три комплекта брони антибунт с шлемом."
	cost = BUY_CRATE_VALUE * 3
	contains = list(
		/obj/item/clothing/suit/armor/riot,
		/obj/item/clothing/suit/armor/riot,
		/obj/item/clothing/suit/armor/riot,
		/obj/item/clothing/head/helmet/riot,
		/obj/item/clothing/head/helmet/riot,
		/obj/item/clothing/head/helmet/riot
		)
	crate_name = "ящик с броней антибунт"

/datum/supply_pack/security/laserarmor
	name = "Комплект зеркальной брони"
	desc = "Содержит три комплекта зеркальной брони."
	cost = BUY_CRATE_VALUE * 4
	contains = list(
		/obj/item/clothing/suit/armor/laserproof,
		/obj/item/clothing/suit/armor/laserproof,
		/obj/item/clothing/suit/armor/laserproof
		)
	crate_name = "ящик с зеркальной броней"
	crate_type = /obj/structure/closet/crate/secure/plasma

/datum/supply_pack/security/riotshields
	name = "Комплект щитов антибунт"
	desc = "Содержит 3 щита антибунт и ремонтные материалы для них."
	cost = BUY_CRATE_VALUE * 3
	contains = list(/obj/item/shield/riot,
					/obj/item/shield/riot,
					/obj/item/shield/riot,
					/obj/item/stack/sheet/rglass/thirty,
					/obj/item/weldingtool/mini
					)
	crate_name = "ящик с щитами"

/datum/supply_pack/security/armor_plate
	name = "Комплект бронепластин"
	desc = "Содержит все виды бронепластин, по три единицы каждой."
	cost = BUY_CRATE_VALUE * 2
	contains = list(
		/obj/item/stack/sheet/armor_plate/plasteel/three,
		/obj/item/stack/sheet/armor_plate/ceramic/three,
		/obj/item/stack/sheet/armor_plate/ablative/three
		)
	crate_name = "ящик бронепластин"

/datum/supply_pack/security/forensics
	name = "Комплект спецснаряжения детектива"
	desc = "Идите по горячим следам преступника с помощью Набора Детектива НаноТрейзен(тм). Содержит криминалистический сканер, шесть пакетов для улик, фотоаппарат, магнитофон, белый карандаш и, конечно же, фетровую шляпу. Требуется безопасный доступ для открытия."
	cost = BUY_CRATE_VALUE * 2.5
	access_view = ACCESS_MORGUE
	contains = list(
		/obj/item/detective_scanner,
		/obj/item/storage/box/evidence,
		/obj/item/camera,
		/obj/item/taperecorder,
		/obj/item/toy/crayon/white,
		/obj/item/clothing/head/fedora/det_hat
		)
	crate_name = "ящик детектива"

/datum/supply_pack/security/securityclothes
	name = "Комплект одежды СБ"
	desc = "Содержит соответствующую экипировку для личного состава сил безопасности станции. Содержит одежду для надзирателя, начальника службы безопасности и двух офицеров службы безопасности. К каждому комплекту прилагается соответствующий рангу комбинезон, костюм и берет."
	cost = BUY_CRATE_VALUE * 3
	access_view = ACCESS_SECURITY
	contains = list(
		/obj/item/clothing/under/rank/security/officer/formal,
		/obj/item/clothing/under/rank/security/officer/formal,
		/obj/item/clothing/suit/security/officer,
		/obj/item/clothing/suit/security/officer,
		/obj/item/clothing/head/beret/sec/navyofficer,
		/obj/item/clothing/head/beret/sec/navyofficer,
		/obj/item/clothing/under/rank/security/warden/formal,
		/obj/item/clothing/suit/security/warden,
		/obj/item/clothing/head/beret/sec/navywarden,
		/obj/item/clothing/under/rank/security/head_of_security/formal,
		/obj/item/clothing/suit/security/hos,
		/obj/item/clothing/head/hos/beret/navyhos
		)
	crate_name = "ящик с одеждой СБ"

/datum/supply_pack/security/fortification
	name = "Комплект для фортификации"
	desc = "Содержит заготовки для развертывания полевых укреплений. Стробоскопы, пневматические замки, К.У.Р.С.К.и, пласталь и набор инструментов."
	cost = BUY_CRATE_VALUE * 3
	contains = list(
		/obj/item/flasher_portable_item,
		/obj/item/flasher_portable_item,
		/obj/item/flasher_portable_item,
		/obj/item/door_seal/sb,
		/obj/item/door_seal/sb,
		/obj/item/door_seal/sb,
		/obj/item/quikdeploy/cade/plasteel,
		/obj/item/quikdeploy/cade/plasteel,
		/obj/item/quikdeploy/cade/plasteel,
		/obj/item/storage/toolbox/mechanical,
		/obj/item/stack/sheet/plasteel/x10
		)
	crate_name = "фортификационный ящик"

/datum/supply_pack/security/securitybarriers
	name = "Комплект фортификационных гранат"
	desc = "Применяется для создания полевого укрепления. Содержит барьерные и заградительные гранаты."
	access_view = ACCESS_BRIG
	contains = list(
		/obj/item/storage/box/barrier,
		/obj/item/storage/box/barbed_wire,
		)
	cost = BUY_CRATE_VALUE * 2
	crate_name = "ящик фортификационных гранат"

/datum/supply_pack/security/stingpack
	name = "Комплект гранат антибунт"
	desc = "Используется для подавления беспорядков. Содержит травматические и газовые гранаты."
	cost = BUY_CRATE_VALUE * 3
	access_view = ACCESS_ARMORY
	contains = list(
		/obj/item/storage/box/stingbangs,
		/obj/item/storage/box/teargas,
		)
	crate_name = "ящик с травматическими гранатами"

/datum/supply_pack/security/flashbangs
	name = "Комплект светошумовых гранат"
	desc = "Используется для дезориентации и задержания. Содержит две коробки светошумовых гранат."
	cost = BUY_CRATE_VALUE * 3.5
	access_view = ACCESS_ARMORY
	contains = list(
		/obj/item/storage/box/flashbangs,
		/obj/item/storage/box/flashbangs,
		)
	crate_name = "ящик со светошумовыми гранатами"

/datum/supply_pack/security/supplies
	name = "Комплект припасов СБ"
	desc = "Contains seven flashbangs, seven teargas grenades, six flashes, and seven handcuffs. Requires Security access to open."
	cost = BUY_CRATE_VALUE * 3.5
	access_view = ACCESS_ARMORY
	contains = list(
		/obj/item/storage/fancy/donut_box/choco,
		/obj/item/storage/box/flare,
		/obj/item/storage/box/deputy,
		/obj/item/storage/box/energy_bola,
		/obj/item/radio/off,
		/obj/item/radio/off,
		/obj/item/storage/box/flashes,
		/obj/item/storage/box/handcuffs)
	crate_name = "ящик с припасами СБ"

/datum/supply_pack/security/firingpins
	name = "Комплект бойков"
	desc = "Содержит три набора по семь штук: стандартные, платные и внестанционные бойки."
	cost = BUY_CRATE_VALUE * 4
	access_view = ACCESS_ARMORY
	contains = list(
		/obj/item/storage/box/firingpins,
		/obj/item/storage/box/firingpins/paywall,
		/obj/item/storage/box/firingpins/off_station,
		)
	crate_name = "ящик с бойками"

/datum/supply_pack/security/baton
	name = "Комплект электрошоковых дубинок"
	desc = "Содержит электрошокеры для выведения людей из строя. <i>Не рекомендуется для плотских утех!</i>"
	cost = BUY_CRATE_VALUE * 4
	access_view = ACCESS_SECURITY
	contains = list(/obj/item/melee/baton/loaded,
					/obj/item/melee/baton/loaded,
					/obj/item/melee/baton/loaded)
	crate_name = "ящик с электрошоковыми дубинками"

/datum/supply_pack/security/wall_flash
	name = "Комплект сборки настенной вспышки"
	desc = "Содержит все необходимое для создания настенной вспышки."
	cost = BUY_CRATE_VALUE * 2
	contains = list(/obj/item/storage/box/wall_flash,
					/obj/item/storage/box/wall_flash,
					/obj/item/storage/box/wall_flash,
					/obj/item/storage/box/wall_flash)
	crate_name = "ящик с настенными вспышками"

/datum/supply_pack/security/baton
	name = "Комплект портативного оружейного зарядника"
	desc = "Переносной двухпортовый оружейный зарядник. Питание осуществляется от станционной сети. В качестве резервного источника питания используется встроенная батарея. Для начала работы необходимо разложить в любом подходящем месте."
	cost = BUY_CRATE_VALUE * 4
	access_view = ACCESS_SECURITY
	contains = list(/obj/item/recharger_item)
	crate_name = "ящик с оружейным зарядником"

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Armory //////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/security/armory
	group = "Арсенал"
	access = ACCESS_ARMORY
	access_view = ACCESS_ARMORY
	crate_type = /obj/structure/closet/crate/secure/weapon

/datum/supply_pack/security/armory/ammo
	name = "Комплект боеприпасов"
	desc = "Содержит боеприпасы к большинству видов огнестрельного оружия службы безопасности. Заблокирован доступом Арсенала."
	cost = BUY_CRATE_VALUE * 2
	access_view = ACCESS_ARMORY
	contains = list(
		/obj/item/storage/box/beanbag,
		/obj/item/storage/box/beanbag,
		/obj/item/storage/box/rubbershot,
		/obj/item/storage/box/rubbershot,
		/obj/item/storage/box/s12_bullet,
		/obj/item/storage/box/s12_bullet,
		/obj/item/storage/box/lethalshot,
		/obj/item/storage/box/lethalshot,
		/obj/item/ammo_box/c9mm,
		/obj/item/ammo_box/c9mm,
		/obj/item/ammo_box/c10mm,
		/obj/item/ammo_box/c45,
		/obj/item/ammo_box/a50ae,
		/obj/item/storage/toolbox/ammo/wt550,
		/obj/item/ammo_box/c38/trac,
		/obj/item/ammo_box/c38/hotshot,
		/obj/item/ammo_box/c38/iceblox
		)
	crate_name = "ящик с боеприпасами"

/datum/supply_pack/security/armory/combatknives
	name = "Комплект боевых ножей"
	desc = "Содержит три заточенных боевых ножа. Каждый нож гарантированно плотно поместится в любом стандартном ботинке НаноТрейзен. Требуется доступ к оружейной, чтобы открыть."
	cost = BUY_CRATE_VALUE * 3
	contains = list(
		/obj/item/kitchen/knife/combat,
		/obj/item/kitchen/knife/combat,
		/obj/item/kitchen/knife/combat
		)
	crate_name = "ящик с ножами"

/datum/supply_pack/security/armory/disabler
	name = "Комплект усмирителей"
	desc = "Содержит три усмирителя для нелетального задержания правонарушителей."
	cost = BUY_CRATE_VALUE * 3
	access_view = ACCESS_SECURITY
	contains = list(
		/obj/item/gun/energy/disabler,
		/obj/item/gun/energy/disabler,
		/obj/item/gun/energy/disabler
		)
	crate_name = "ящик с усмирителями"

/datum/supply_pack/security/armory/laser
	name = "Комплект лазеров"
	desc = "Содержит три боевых лазера. Обладают лишь одним режимом стрельбы - летальным, однако батареи при этом хватает на 50% дольше."
	cost = BUY_CRATE_VALUE * 6
	access_view = ACCESS_ARMORY
	contains = list(
		/obj/item/gun/energy/laser,
		/obj/item/gun/energy/laser,
		/obj/item/gun/energy/laser
		)
	crate_name = "ящик с лазерами"

/datum/supply_pack/security/armory/energy
	name = "Комплект Е-ганов"
	desc = "Содержит три энергетические пушки, способные стрелять как несмертельными, так и смертельными световыми разрядами. Для открытия требуется доступ к оружейной."
	cost = BUY_CRATE_VALUE * 6
	contains = list(
		/obj/item/gun/energy/e_gun,
		/obj/item/gun/energy/e_gun,
		/obj/item/gun/energy/e_gun,
		)
	crate_name = "ящик с Е-ганами"
	crate_type = /obj/structure/closet/crate/secure/plasma

/datum/supply_pack/security/armory/thermal
	name = "Комплект нанопистолетов"
	desc = "Содержит пару кобур, в каждой из которых по два экспериментальных тепловых пистолета, использующих наниты в качестве основы для своих боеприпасов. Для открытия требуется доступ к оружейной."
	cost = BUY_CRATE_VALUE * 6
	contains = list(
		/obj/item/storage/belt/holster/thermal,
		/obj/item/storage/belt/holster/thermal
		)
	crate_name = "ящик с нанопистолетами"

/datum/supply_pack/security/armory/traumat
	name = "Комплект Блюстителя T46"
	desc = "Современный пистолет используемый частными охранными компаниями для задержания преступников. Обычно снаряжается травматическими боеприпасами."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(
		/obj/item/gun/ballistic/automatic/pistol/traumatic,
		/obj/item/ammo_box/c9mm_traumatic,
		/obj/item/ammo_box/c9mm_traumatic,
		/obj/item/ammo_box/magazine/traumatic,
		/obj/item/ammo_box/magazine/traumatic)

/datum/supply_pack/security/armory/fire
	name = "Комплект зажигательного вооружения"
	desc = "Гори, детка, гори. Содержит три зажигательные гранаты, три бака с плазмой и огнемет. Для открытия требуется доступ к оружейной."
	cost = BUY_CRATE_VALUE * 4
	contains = list(
		/obj/item/flamethrower/full,
		/obj/item/tank/internals/plasma,
		/obj/item/tank/internals/plasma,
		/obj/item/tank/internals/plasma,
		/obj/item/grenade/chem_grenade/incendiary,
		/obj/item/grenade/chem_grenade/incendiary,
		/obj/item/grenade/chem_grenade/incendiary
		)
	crate_name = "ящик с огнеметом"
	crate_type = /obj/structure/closet/crate/secure/plasma
	dangerous = TRUE

/datum/supply_pack/security/armory/mars_single
	name = "Комплект кольта детектива"
	desc = "Классическое, пусть и немного устаревшее, но верное правоохранительное оружие. Использует .38 спецпатроны."
	cost = PAYCHECK_HARD * 4
	access_view = ACCESS_FORENSICS_LOCKERS
	contains = list(
		/obj/item/gun/ballistic/revolver/detective,
		/obj/item/ammo_box/c38/dumdum,
		/obj/item/ammo_box/c38/match,
		/obj/item/ammo_box/c38/match/bouncy,
		/obj/item/ammo_box/c38,
		/obj/item/ammo_box/c38,
		/obj/item/ammo_box/c38,
		)

/datum/supply_pack/security/armory/shotgun
	name = "Комплект дробовиков охраны"
	desc = "Старая школа. Содержит три дробовика охраны, три патронташа, и три бандольера для дробовиков. Для открытия требуется доступ к оружейной."
	cost = BUY_CRATE_VALUE * 10
	contains = list(
		/obj/item/gun/ballistic/shotgun/riot,
		/obj/item/gun/ballistic/shotgun/riot,
		/obj/item/gun/ballistic/shotgun/riot,
		/obj/item/storage/belt/bandolier,
		/obj/item/storage/belt/bandolier,
		/obj/item/storage/belt/bandolier,
		/obj/item/storage/belt/shotgun,
		/obj/item/storage/belt/shotgun,
		/obj/item/storage/belt/shotgun,
		)
	crate_name = "ящик с дробовиками охраны"

/datum/supply_pack/security/armory/ballistic
	name = "Комплект боевых дробовиков"
	desc = "Для тех случаев, когда врага абсолютно необходимо заменить свинцом. Содержит три боевых дробовика, три патронташа, и три бандольера для дробовиков. Для открытия требуется доступ к оружейной."
	cost = BUY_CRATE_VALUE * 15
	contains = list(
		/obj/item/gun/ballistic/shotgun/automatic/combat,
		/obj/item/gun/ballistic/shotgun/automatic/combat,
		/obj/item/gun/ballistic/shotgun/automatic/combat,
		/obj/item/storage/belt/bandolier,
		/obj/item/storage/belt/bandolier,
		/obj/item/storage/belt/bandolier,
		/obj/item/storage/belt/shotgun,
		/obj/item/storage/belt/shotgun,
		/obj/item/storage/belt/shotgun,
		)
	crate_name = "ящик с боевыми дробовиками"

/datum/supply_pack/security/armory/dragnet
	name = "Комплект ЦАПсетей"
	desc = "Содержит три боломета. Для открытия требуется доступ к оружейной."
	cost = BUY_CRATE_VALUE * 5
	contains = list(/obj/item/gun/energy/e_gun/dragnet,
					/obj/item/gun/energy/e_gun/dragnet,
					/obj/item/gun/energy/e_gun/dragnet)
	crate_name = "Ящик ЦАПсетей"

/datum/supply_pack/security/armory/chemimp
	name = "Комплект набора микроимплантов"
	desc = "Содержит три комплекта по пять штук. Следящие, химические и изгоняющие."
	cost = BUY_CRATE_VALUE * 4
	contains = list(
		/obj/item/storage/box/chemimp,
		/obj/item/storage/box/trackimp,
		/obj/item/storage/box/exileimp,
		/obj/item/ammo_box/c38/trac,
		/obj/item/ammo_box/c38/trac,
		/obj/item/ammo_box/c38/trac
		)
	crate_name = "ящик с микроимплантами"

/datum/supply_pack/security/armory/mindshield
	name = "Комплект микроимплантов с щитами разума"
	desc = "Защищает от промывки мозгов при помощи сертефицированной НТ промывкой мозгов."
	cost = BUY_CRATE_VALUE * 6
	contains = list(/obj/item/storage/lockbox/loyalty)
	crate_name = "ящик с щитами разума"

/datum/supply_pack/security/armory/swat
	name = "Комплект скафандров спецназа МК-I"
	desc = "Содержит два полных комплекта тяжелых, но прочных, огнеупорных костюмов для работы в космосе разработанных совместными усилиями ISERI и НаноТрейзен. Каждый комплект содержит костюм, шлем, маску, боевой пояс и боевые перчатки. Для открытия требуется доступ к оружейной."
	cost = BUY_CRATE_VALUE * 12
	contains = list(
		/obj/item/clothing/head/helmet/swat/nanotrasen,
		/obj/item/clothing/head/helmet/swat/nanotrasen,
		/obj/item/clothing/suit/space/swat,
		/obj/item/clothing/suit/space/swat,
		/obj/item/clothing/mask/gas/sechailer/swat,
		/obj/item/clothing/mask/gas/sechailer/swat,
		/obj/item/storage/belt/military/assault,
		/obj/item/storage/belt/military/assault,
		/obj/item/clothing/gloves/tackler/combat,
		/obj/item/clothing/gloves/tackler/combat
		)
	crate_name = "ящик с скафандрами МК-I"

/datum/supply_pack/security/armory/swat2
	name = "Комплект скафандров спецназа МК-II"
	desc = "Содержит два полных комплекта продвинутых скафандов с лучшими показаелями защиты и скорости перемещения. Каждый комплект содержит костюм, шлем, маску, боевой пояс и боевые перчатки. Для открытия требуется доступ к оружейной."
	cost = BUY_CRATE_VALUE * 20
	contains = list(
		/obj/item/clothing/suit/space/hardsuit/swat,
		/obj/item/clothing/suit/space/hardsuit/swat,
		/obj/item/clothing/mask/gas/sechailer/swat,
		/obj/item/clothing/mask/gas/sechailer/swat,
		/obj/item/storage/belt/military/assault,
		/obj/item/storage/belt/military/assault,
		/obj/item/clothing/gloves/tackler/combat,
		/obj/item/clothing/gloves/tackler/combat
		)
	crate_name = "ящик с скафандрами МК-II"

/datum/supply_pack/security/armory/kinetic_shields
	name = "Комплект кинетических щитов"
	desc = "Содержит три кинетических щита, которые способны отражать снаряды летящие с большой скоростью. ВНИМАНИЕ! Не включать одновременно два и более щита. Только для службы безопасности."
	cost = BUY_CRATE_VALUE * 9
	contains = list(
		/obj/item/kinetic_shield,
		/obj/item/kinetic_shield,
		/obj/item/kinetic_shield
		)
	crate_name = "ящик с кинетическими щитами"

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Engineering /////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/engineering
	group = "Инженерия"
	crate_type = /obj/structure/closet/crate/engineering

/datum/supply_pack/engineering/tools
	name = "Комплект ящиков для инструментов"
	desc = "Любой робастный космонавт никогда не бывает далеко от своего надежного набора инструментов. Содержит три электрических ящика для инструментов и три механических ящика для инструментов."
	access_view = ACCESS_ENGINE_EQUIP
	contains = list(
		/obj/item/storage/toolbox/electrical,
		/obj/item/storage/toolbox/electrical,
		/obj/item/storage/toolbox/electrical,
		/obj/item/storage/toolbox/mechanical,
		/obj/item/storage/toolbox/mechanical,
		/obj/item/storage/toolbox/mechanical
		)
	cost = BUY_CRATE_VALUE * 5
	crate_name = "ящик с инструментами"

/datum/supply_pack/engineering/powergamermitts
	name = "Комплект резиновых перчаток"
	desc = "Содержит три пары перчаток защищающих пользователя от поражения электрическим током. Очень толстые, пострелять с такими не получится."
	cost = BUY_CRATE_VALUE * 8	//Made of pure-grade bullshittinium
	access_view = ACCESS_ENGINE_EQUIP
	contains = list(
		/obj/item/clothing/gloves/color/yellow,
		/obj/item/clothing/gloves/color/yellow,
		/obj/item/clothing/gloves/color/yellow
		)
	crate_name = "ящик изоляшек"
	crate_type = /obj/structure/closet/crate/engineering/electrical

/datum/supply_pack/engineering/inducers
	name = "Комплект индукторов"
	desc = "Содержит три инструмента для индуктивной зарядки элементов питания, позволяя заряжать их без необходимости извлечения."
	cost = BUY_CRATE_VALUE * 4
	contains = list(
		/obj/item/inducer {cell_type = /obj/item/stock_parts/cell/super; opened = 0},
		/obj/item/inducer {cell_type = /obj/item/stock_parts/cell/super; opened = 0},
		/obj/item/inducer {cell_type = /obj/item/stock_parts/cell/super; opened = 0})
	crate_name = "ящик с индукторами"
	crate_type = /obj/structure/closet/crate/engineering/electrical

/datum/supply_pack/engineering/power
	name = "Комплект батарей гиперувеличенной емкости"
	desc = "Содержит пять усовершенстованных перезаряжаемых электрохимических элементов питания, вмещающих до 30 МДж энергии."
	cost = BUY_CRATE_VALUE * 3
	contains = list(
		/obj/item/stock_parts/cell/hyper,
		/obj/item/stock_parts/cell/hyper,
		/obj/item/stock_parts/cell/hyper,
		/obj/item/stock_parts/cell/hyper,
		/obj/item/stock_parts/cell/hyper
		)
	crate_name = "ящик батарей"
	crate_type = /obj/structure/closet/crate/engineering/electrical

/datum/supply_pack/engineering/pacman
	name = "Комплект П.А.К.М.А.Н.а"
	desc = "Содержит портативный генератор для аварийного резервного питания. Работает на плазме."
	cost = BUY_CRATE_VALUE * 5
	access_view = ACCESS_ENGINE
	contains = list(
		/obj/machinery/power/port_gen/pacman,
		/obj/item/stack/sheet/mineral/plasma/ten,
		/obj/item/storage/toolbox/electrical)
	crate_name = "ящик П.А.К.М.А.Н.а"
	crate_type = /obj/structure/closet/crate/engineering/electrical

/datum/supply_pack/engineering/rped
	name = "Комплект РПЕДа"
	desc = "Специальный механический модуль, предназначенный для хранения, сортировки и монтажа стандартных деталей машин. Вмещает 50 деталей."
	cost = BUY_CRATE_VALUE * 3
	access_view = FALSE
	contains = list(/obj/item/storage/part_replacer/tier2)
	crate_name = "ящик с РПЕДом"

/datum/supply_pack/engineering/shieldgen
	name = "Комплект щитогенераторов"
	desc = "Используется для оперативного перекрытия средних по размеру пробоин в обшивке."
	cost = BUY_CRATE_VALUE * 3
	access_view = ACCESS_ENGINE_EQUIP
	contains = list(
		/obj/machinery/shieldgen,
		/obj/machinery/shieldgen,
		/obj/machinery/shieldgen,
		/obj/machinery/shieldgen,
		)
	crate_name = "ящик щитогенераторов"

/datum/supply_pack/engineering/shieldwalls
	name = "Комплект генераторов силового щита"
	desc = "Эти мощные генераторы защитных стен гарантированно удержат любые нежелательные формы жизни снаружи, там, где им самое место! Содержит четыре генератора защитных стен. Для открытия требуется доступ к телепорту."
	cost = BUY_CRATE_VALUE * 4
	access = ACCESS_TELEPORTER
	access_view = ACCESS_TELEPORTER
	contains = list(
		/obj/machinery/power/shieldwallgen,
		/obj/machinery/power/shieldwallgen,
		/obj/machinery/power/shieldwallgen,
		/obj/machinery/power/shieldwallgen
		)
	crate_name = "ящик с силовыми щитами"
	crate_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/engineering/port_atmos
	name = "Комплект фильтров и насосов"
	desc = "Содержит 2 атмосферных фильтра и 2 насоса."
	cost = BUY_CRATE_VALUE * 3
	access_view = ACCESS_ATMOSPHERICS
	contains = list(
		/obj/machinery/portable_atmospherics/pump,
		/obj/machinery/portable_atmospherics/pump,
		/obj/machinery/portable_atmospherics/scrubber,
		/obj/machinery/portable_atmospherics/scrubber,
		/obj/item/storage/toolbox/mechanical
		)
	crate_name = "ящик с фильтрами и насосами"

/datum/supply_pack/engineering/hugescrubber
	name = "Комплект промышленного газоочистителя"
	desc = "Тяжелая мобильная платформа для быстрой и оперативной очистки помещений от загрязнения."
	cost = BUY_CRATE_VALUE * 5
	access_view = ACCESS_ATMOSPHERICS
	contains = list(/obj/machinery/portable_atmospherics/scrubber/huge/movable/cargo)
	crate_name = "ящик с промышленным газоочистителем"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/engineering/conveyor
	name = "Комплект конвейерных линий"
	desc = "Поддерживайте движение производства с помощью стадвадцати конвейерных лент. Два переключателя конвейера включены в комплект поставки. Если у вас есть какие-либо вопросы, ознакомьтесь с прилагаемой инструкцией."
	cost = BUY_CRATE_VALUE * 3.5
	contains = list(
		/obj/item/stack/conveyor/thirty,
		/obj/item/stack/conveyor/thirty,
		/obj/item/stack/conveyor/thirty,
		/obj/item/stack/conveyor/thirty,
		/obj/item/conveyor_switch_construct,
		/obj/item/conveyor_switch_construct,
		/obj/item/paper/guides/conveyor
		)
	crate_name = "ящик с конвейерами"

/datum/supply_pack/engineering/engiequipment // #rework
	name = "Комплект инженерной экипировки"
	desc = "Содержит три комплекта защитной одежды, включая ремни, сварочные шлемы и очки."
	cost = BUY_CRATE_VALUE * 4
	access_view = ACCESS_ENGINE
	contains = list(
		/obj/item/storage/belt/utility,
		/obj/item/storage/belt/utility,
		/obj/item/storage/belt/utility,
		/obj/item/clothing/suit/hazardvest,
		/obj/item/clothing/suit/hazardvest,
		/obj/item/clothing/suit/hazardvest,
		/obj/item/clothing/head/welding,
		/obj/item/clothing/head/welding,
		/obj/item/clothing/head/welding,
		/obj/item/clothing/head/hardhat,
		/obj/item/clothing/head/hardhat,
		/obj/item/clothing/head/hardhat,
		/obj/item/clothing/glasses/meson/engine,
		/obj/item/clothing/glasses/meson/engine,
		/obj/item/clothing/glasses/meson/engine
		)
	crate_name = "ящик инженерной экипировки"

/datum/supply_pack/engineering/atmostank
	name = "Комплект рюкзака огнеборца"
	desc = "Содержит в себе два рюкзака огнеборца и несколько противопожарных гранат."
	cost = BUY_CRATE_VALUE * 1.8
	contains = list(
		/obj/item/watertank/atmos,
		/obj/item/watertank/atmos,
		/obj/item/grenade/chem_grenade/resin_foam,
		/obj/item/grenade/chem_grenade/resin_foam,
		/obj/item/grenade/chem_grenade/resin_foam,
		/obj/item/grenade/chem_grenade/resin_foam,
		)
	crate_name = "ящик с рюкзаком огнеборца"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/engineering/metalfoam
	name = "Комплект гранат с металлопеной"
	desc = "Используется для быстрого закрытия пробоин в корпусе."
	cost = BUY_CRATE_VALUE * 2.4
	contains = list(
		/obj/item/storage/box/metalfoam,
		/obj/item/storage/box/metalfoam
		)
	crate_name = "ящик гранат с металлопеной"

/datum/supply_pack/engineering/resin_foam
	name = "Комплект противопожарных гранат"
	desc = "Используется для быстрого тушения пожаров."
	cost = BUY_CRATE_VALUE * 2.4
	contains = list(
		/obj/item/storage/box/resin_foam,
		/obj/item/storage/box/resin_foam
		)
	crate_name = "ящик противопожарных гранат"

/datum/supply_pack/engineering/graviton_beacon
	name = "Комплект гравитоновых маяков"
	desc = "Используются для создания гравитации в небольшой зоне."
	cost = BUY_CRATE_VALUE * 1.2
	contains = list(
		/obj/item/graviton_beacon,
		/obj/item/graviton_beacon,
		/obj/item/graviton_beacon,
		/obj/item/graviton_beacon,
		/obj/item/graviton_beacon
		)
	crate_name = "ящик с гравитоновыми мяками"

/datum/supply_pack/engineering/shuttle_construction
	name = "Комплект сделай сам - \"шаттлостроение\""
	desc = "Набор \"сделай сам\" для создания своего собственного шаттла! Поставляется со всеми необходимыми деталями, чтобы доставить ваших людей к звездам!"
	cost = BUY_CRATE_VALUE * 20
	contains = list(
		/obj/machinery/portable_atmospherics/canister/plasma,
		/obj/item/construction/rcd/loaded,
		/obj/item/rcd_ammo/large,
		/obj/item/rcd_ammo/large,
		/obj/item/shuttle_creator,
		/obj/item/pipe_dispenser,
		/obj/item/storage/toolbox/mechanical,
		/obj/item/storage/toolbox/electrical,
		/obj/item/circuitboard/computer/shuttle/flight_control,
		/obj/item/circuitboard/machine/shuttle/engine/plasma,
		/obj/item/circuitboard/machine/shuttle/engine/plasma,
		/obj/item/circuitboard/machine/shuttle/heater,
		/obj/item/circuitboard/machine/shuttle/heater
		)
	crate_name = "shuttle construction crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/engineering/shuttle_engine
	name = "Комплект двигателей шаттла"
	desc = "Благодаря передовым блюспейс разработкам нашим инженерам удалось поместить целый двигатель шаттла в один крошечный ящик."
	cost = BUY_CRATE_VALUE * 6
	contains = list(/obj/structure/shuttle/engine/propulsion/burst/cargo)
	crate_name = "ящик с двигателем"
	crate_type = /obj/structure/closet/crate/secure/engineering
	special = TRUE

/datum/supply_pack/engineering/bsa
	name = "Комплект деталей блюспейс артилерии"
	desc = "Гордость военно-космического командования \"Нанотразен\". Легендарное блюспейс орудие - это сокрушительный подвиг человеческой инженерии и свидетельство решимости военного времени. Для правильного строительства требуются самые передовые исследования."
	cost = BUY_CRATE_VALUE * 30
	special = TRUE
	access_view = ACCESS_HEADS
	contains = list(
		/obj/item/circuitboard/machine/bsa/front,
		/obj/item/circuitboard/machine/bsa/middle,
		/obj/item/circuitboard/machine/bsa/back,
		/obj/item/circuitboard/computer/bsa_control
		)
	crate_name= "bluespace artillery parts crate"

/datum/supply_pack/engineering/dna_vault
	name = "Комплект банка ДНК"
	desc = "Обеспечьте долговечность нынешнего состояния генетического фонда человечества с помощью этой огромной библиотеки научных знаний, способной наделить сверхчеловеческими силами и способностями. Для правильного строительства требуются самые передовые исследования. Также содержит пять ДНК-зондов."
	cost = BUY_CRATE_VALUE * 10
	special = TRUE
	access_view = ACCESS_HEADS
	contains = list(
		/obj/item/circuitboard/machine/dna_vault,
		/obj/item/dna_probe,
		/obj/item/dna_probe,
		/obj/item/dna_probe,
		/obj/item/dna_probe,
		/obj/item/dna_probe
		)
	crate_name= "ящик с банком ДНК"

/datum/supply_pack/engineering/dna_probes
	name = "Комплект дополнительных ДНК зондов"
	desc = "Содержит еще пять зондов если все прошлые спасители человечества пропали без вести."
	cost = BUY_CRATE_VALUE * 5
	special = TRUE
	access_view = ACCESS_HEADS
	contains = list(
		/obj/item/dna_probe,
		/obj/item/dna_probe,
		/obj/item/dna_probe,
		/obj/item/dna_probe,
		/obj/item/dna_probe
		)
	crate_name= "ящик с ДНК зондами"

/datum/supply_pack/engineering/shield_sat_control
	name = "Комплект управления спутниками ПКО"
	desc = "Содержит консоль управления и пять защитных спутников."
	cost = BUY_CRATE_VALUE * 5
	special = TRUE
	contains = list(
		/obj/item/circuitboard/computer/sat_control,
		/obj/machinery/satellite/meteor_shield,
		/obj/machinery/satellite/meteor_shield,
		/obj/machinery/satellite/meteor_shield,
		/obj/machinery/satellite/meteor_shield,
		/obj/machinery/satellite/meteor_shield
		)
	crate_name= "ящик с консолью ПКО"

/datum/supply_pack/engineering/shield_sat
	name = "Комплект дополнительных спутников ПКО"
	desc = "Защитите само существование этой станции с помощью этих противометеоритных средств защиты. Содержит пять дополнительных защитных спутников."
	cost = BUY_CRATE_VALUE * 2
	special = TRUE
	contains = list(
		/obj/machinery/satellite/meteor_shield,
		/obj/machinery/satellite/meteor_shield,
		/obj/machinery/satellite/meteor_shield,
		/obj/machinery/satellite/meteor_shield,
		/obj/machinery/satellite/meteor_shield
		)
	crate_name= "ящик с спутниками ПКО"

//////////////////////////////////////////////////////////////////////////////
//////////////////////// Engine Construction /////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/engine
	group = "Создание генератора"
	access_view = ACCESS_ENGINE
	crate_type = /obj/structure/closet/crate/engineering

/datum/supply_pack/engine/emitter
	name = "Комплект излучателей"
	desc = "Содержит четыре мощных промышленных лазера, часто используемых в области силовых полей и производства электроэнергии."
	cost = BUY_CRATE_VALUE * 4
	contains = list(
		/obj/machinery/power/emitter,
		/obj/machinery/power/emitter,
		/obj/machinery/power/emitter,
		/obj/machinery/power/emitter,
		)
	crate_name = "ящик с излучателями"
	crate_type = /obj/structure/closet/crate/secure/engineering
	dangerous = TRUE

/datum/supply_pack/engine/field_gen
	name = "Комплект генераторов полей"
	desc = "Содержит четыре огромных машины, которые создают защитное поле за счёт поступающей на нех энергии."
	cost = BUY_CRATE_VALUE * 3
	contains = list(
		/obj/machinery/field/generator,
		/obj/machinery/field/generator,
		/obj/machinery/field/generator,
		/obj/machinery/field/generator,
		)
	crate_name = "ящик с генераторами поля"

/datum/supply_pack/engine/grounding_rods
	name = "Комплект заземлителей"
	desc = "Содержит четыре устройства которые защищают окружающее оборудование и людей от поджаривания Проклятием Эдисона."
	cost = BUY_CRATE_VALUE * 3
	contains = list(/obj/machinery/power/grounding_rod,
					/obj/machinery/power/grounding_rod,
					/obj/machinery/power/grounding_rod,
					/obj/machinery/power/grounding_rod)
	crate_name = "ящик с заземлителями"
	crate_type = /obj/structure/closet/crate/engineering/electrical

/datum/supply_pack/engine/collector
	name = "Комплект радколлекторных массивов"
	desc = "Содержит шесть устройств, которые использует излучение Хокинга и плазму для производства энергии."
	cost = BUY_CRATE_VALUE * 4
	contains = list(
		/obj/machinery/power/rad_collector,
		/obj/machinery/power/rad_collector,
		/obj/machinery/power/rad_collector,
		/obj/machinery/power/rad_collector,
		/obj/machinery/power/rad_collector,
		/obj/machinery/power/rad_collector
		)
	crate_name = "ящик радколлекторных массивов"

/datum/supply_pack/engine/tesla_coils
	name = "Комплект катушек Теслы"
	desc = "Содержит шесть устройств, которые преобразуют удары шаровой молнии в энергию. Используйте отвертку для переключения между режимами производства электроэнергии и очков исследования. За союз!"
	cost = BUY_CRATE_VALUE * 4
	contains = list(
		/obj/machinery/power/tesla_coil,
		/obj/machinery/power/tesla_coil,
		/obj/machinery/power/tesla_coil,
		/obj/machinery/power/tesla_coil,
		/obj/machinery/power/tesla_coil,
		/obj/machinery/power/tesla_coil
		)
	crate_name = "ящик катушек Теслы"
	crate_type = /obj/structure/closet/crate/engineering/electrical

/datum/supply_pack/engine/solar
	name = "Комплект солнечных панелей"
	desc = "Содержит 21 раму для создания солнечной панели. При подключении к ней платы отслеживания так же выполняет функцию солнечного отслеживателя."
	cost = BUY_CRATE_VALUE * 5
	contains  = list(
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/circuitboard/computer/solar_control,
		/obj/item/electronics/tracker,
		/obj/item/paper/guides/jobs/engi/solars
		)
	crate_name = "ящик с солнечными панелями"
	crate_type = /obj/structure/closet/crate/engineering/electrical

/datum/supply_pack/engine/particle
	name = "Комплект ускорителя частиц"
	desc = "Сверхмассивная черная дыра или сверхмощная шаровая молния - идеальный способ оживить любую вечеринку! Входит в набор \"Мой первый апокалипсис\" и содержит все необходимое для создания вашего собственного ускорителя частиц! Возраст от 10 лет и старше."
	cost = BUY_CRATE_VALUE * 6
	contains = list(
		/obj/structure/particle_accelerator/fuel_chamber,
		/obj/machinery/particle_accelerator/control_box,
		/obj/structure/particle_accelerator/particle_emitter/center,
		/obj/structure/particle_accelerator/particle_emitter/left,
		/obj/structure/particle_accelerator/particle_emitter/right,
		/obj/structure/particle_accelerator/power_box,
		/obj/structure/particle_accelerator/end_cap
		)
	crate_name = "ящик с ускорителем частиц"

/datum/supply_pack/engine/tesla_gen
	name = "Комплект инициатора Тесла-аномалии"
	desc = "При облучении излучателем частиц порождает огромную высоковольтную шаровую молнию, сдержать которую может только силовое поле."
	cost = BUY_CRATE_VALUE * 15
	contains = list(/obj/machinery/the_singularitygen/tesla)
	crate_name = "ящик инициатора Теслы"

/datum/supply_pack/engine/singulo_gen
	name = "Комплект инициатора сингулярности"
	desc = "Странное устройство, которое при облучении ускорителем частиц создаёт Гравитационную Сингулярность, сдержать которую может только силовое поле."
	cost = BUY_CRATE_VALUE * 20
	contains = list(/obj/machinery/the_singularitygen)
	crate_name = "ящик инициатора Сингулярности"

/datum/supply_pack/engine/supermatter_shard
	name = "Комплект осколока суперматерии"
	desc = "Странный, полупрозрачный и переливающийся кристалл, который выглядит так, будто раньше был частью большой структуры."
	cost = BUY_CRATE_VALUE * 20
	access = ACCESS_CE
	contains = list(/obj/machinery/power/supermatter_crystal/shard)
	crate_name = "ящик с осколком суперматерии"
	crate_type = /obj/structure/closet/crate/secure/engineering
	dangerous = TRUE

/datum/supply_pack/engine/am_jar
	name = "Комплект сосудов антивещества"
	desc = "Хранит в себе антивещество - редкое топливо необходимое для работы двигателя на антиматерии."
	cost = BUY_CRATE_VALUE * 2
	contains = list(
		/obj/item/am_containment,
		/obj/item/am_containment
		)
	crate_name = "ящик антивещества"

/datum/supply_pack/engine/am_core
	name = "Комплект управляющего блока АМ"
	desc = "Это устройство вводит антивещество в подключенные экранирующие устройства, чем больше антивещества вводится, тем больше вырабатывается энергии."
	cost = BUY_CRATE_VALUE * 5
	contains = list(/obj/machinery/power/am_control_unit)
	crate_name = "ящик управляющего блока АМ"

/datum/supply_pack/engine/am_shielding
	name = "Комплект экранирующих блоков АМ"
	desc = "Небольшой модуль, содержащий секцию реактора антиматерии. Устанавливается рядом с блоком управления антивеществом или другим экранирующим блоком."
	cost = BUY_CRATE_VALUE * 3
	contains = list(
		/obj/item/am_shielding_container,
		/obj/item/am_shielding_container,
		/obj/item/am_shielding_container,
		/obj/item/am_shielding_container,
		/obj/item/am_shielding_container,
		/obj/item/am_shielding_container,
		/obj/item/am_shielding_container,
		/obj/item/am_shielding_container,
		/obj/item/am_shielding_container,
		) //9 shields: 3x3 containment and a core
	crate_name = "ящик экранирующих блоков АМ"

//////////////////////////////////////////////////////////////////////////////
/////////////////////// Canisters & Materials ////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/materials
	group = "Материалы и Канистры"

/datum/supply_pack/materials/iron50
	name = "Комплект железа"
	desc = "Содержит 50 единиц железа."
	cost = BUY_CRATE_VALUE * 2
	contains = list(
		/obj/item/stack/sheet/iron/fifty,
		/obj/item/stack/sheet/iron/fifty,
		/obj/item/stack/sheet/iron/fifty,
		/obj/item/stack/sheet/iron/fifty,
		)
	crate_name = "ящик с железом"

/datum/supply_pack/materials/glass50
	name = "Комплект стекла"
	desc = "Содержит 200 единиц стекла."
	cost = BUY_CRATE_VALUE * 2
	contains = list(
		/obj/item/stack/sheet/glass/fifty,
		/obj/item/stack/sheet/glass/fifty,
		/obj/item/stack/sheet/glass/fifty,
		/obj/item/stack/sheet/glass/fifty,
		)
	crate_name = "ящик со стеклом"

/datum/supply_pack/materials/plastic50
	name = "Комплект пластика"
	desc = "Содержит 100 единиц пластика"
	cost = BUY_CRATE_VALUE * 2
	contains = list(
		/obj/item/stack/sheet/plastic/fifty,
		/obj/item/stack/sheet/plastic/fifty
		)
	crate_name = "ящик с пластиком"

/datum/supply_pack/materials/gold_20
	name = "Комплект золота"
	desc = "Содержит 20 единиц золота"
	cost = BUY_CRATE_VALUE * 3
	contains = list(
		/obj/item/stack/sheet/mineral/gold/twenty
		)
	crate_name = "ящик с золотом"

/datum/supply_pack/materials/silver_20
	name = "Комплект серебра"
	desc = "Содержит 20 единиц серебра"
	cost = BUY_CRATE_VALUE * 3
	contains = list(
		/obj/item/stack/sheet/mineral/silver/twenty
		)
	crate_name = "ящик с серебром"

/datum/supply_pack/materials/uranium_20
	name = "Комплект урана"
	desc = "Содержит 20 единиц урана"
	cost = BUY_CRATE_VALUE * 6
	contains = list(
		/obj/item/stack/sheet/mineral/uranium/twenty
		)
	crate_name = "ящик с ураном"

/datum/supply_pack/materials/titanium_20
	name = "Комплект титана"
	desc = "Содержит 20 единиц титана"
	cost = BUY_CRATE_VALUE * 6
	contains = list(
		/obj/item/stack/sheet/mineral/titanium/twenty
		)
	crate_name = "ящик с титаном"

/datum/supply_pack/materials/plasteel50
	name = "Комплект пластали"
	desc = "Содержит 50 единиц пластали."
	cost = BUY_CRATE_VALUE * 5
	contains = list(/obj/item/stack/sheet/plasteel/fifty)
	crate_name = "ящик"

/datum/supply_pack/materials/cardboard50
	name = "Комплект картона"
	desc = "Содержит 50 больших листов картона, выглядящих как плоские коробки."
	cost = BUY_CRATE_VALUE * 2
	contains = list(/obj/item/stack/sheet/cardboard/fifty)
	crate_name = "cardboard sheets crate"

/datum/supply_pack/materials/license50
	name = "Комплект номерных знаков"
	desc = "Зэкам тоже надо чем-то заняться."
	cost = BUY_CRATE_VALUE * 2  // 50 * 25 + 700 - 1000 = 950 credits profit
	access_view = ACCESS_SEC_DOORS
	contains = list(/obj/item/stack/license_plates/empty/fifty)
	crate_name = "ящик с номерными знаками"

/datum/supply_pack/materials/sandstone30
	name = "Комплект песчаника"
	desc = "Содержит 30 единиц песчаника."
	cost = BUY_CRATE_VALUE * 2
	contains = list(/obj/item/stack/sheet/mineral/sandstone/thirty)
	crate_name = "sandstone blocks crate"

/datum/supply_pack/materials/wood50
	name = "Комплект древесины"
	desc = "Содержит 50 единиц древесины."
	cost = BUY_CRATE_VALUE * 2
	contains = list(/obj/item/stack/sheet/mineral/wood/fifty)
	crate_name = "ящик с древесиной"

/datum/supply_pack/materials/watertank
	name = "Бак с водой"
	desc = "Содержит баллон с монооксидом дигидрогена... звучит опасно."
	cost = BUY_CRATE_VALUE * 1.2
	contains = list(/obj/structure/reagent_dispensers/watertank)
	crate_name = "ящик с водой"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials/hightank
	name = "Бак с водой (большой)"
	desc = "Содержит резервуар для воды большой емкости. Полезно для ботаники или других служебных работ."
	cost = BUY_CRATE_VALUE * 2.4
	contains = list(/obj/structure/reagent_dispensers/watertank/high)
	crate_name = "ящик с водой"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials/fueltank
	name = "Бак с топливом"
	desc = "Содержит сварочный топливный бак. Осторожно, легко воспламеняется."
	cost = BUY_CRATE_VALUE * 1.6
	contains = list(/obj/structure/reagent_dispensers/fueltank)
	crate_name = "ящик с топливом"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials/hightankfuel
	name = "Бак с топливом (большой)"
	desc = "Содержит высокоемкий сварочный топливный бак. Осторожно, легко воспламеняется."
	cost = BUY_CRATE_VALUE * 3
	access_view = ACCESS_ENGINE
	contains = list(/obj/structure/reagent_dispensers/fueltank/large)
	crate_name = "ящик с топливом"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials/foamtank
	name = "Бак с пеной для огнетушителя"
	desc = "Содержит один бак с противопожарной пеной так же известной как \"бич плазмена\"."
	cost = BUY_CRATE_VALUE * 3
	contains = list(/obj/structure/reagent_dispensers/foamtank)
	crate_name = "ящик с пеной для огнетушителя"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials/oxygen
	name = "Канистра с кислородом"
	desc = "Кислород. Необходим для жизни человека."
	cost = BUY_CRATE_VALUE * 3
	contains = list(/obj/machinery/portable_atmospherics/canister/oxygen)
	crate_name = "ящик с кислородом"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials/nitrogen
	name = "Канистра с азотом"
	desc = "Газообразный азот. Якобы полезно для чего-то."
	cost = BUY_CRATE_VALUE * 4
	contains = list(/obj/machinery/portable_atmospherics/canister/nitrogen)
	crate_name = "ящик с азотом"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials/nitrous_oxide_canister
	name = "Канистра с закисью азота"
	desc = "Закись азота. Вызывает сонливость. Заблокирован"
	cost = BUY_CRATE_VALUE * 6
	access = ACCESS_ATMOSPHERICS
	access_view = ACCESS_ATMOSPHERICS
	contains = list(/obj/machinery/portable_atmospherics/canister/nitrous_oxide)
	crate_name = "ящик с закисью азота"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/materials/carbon_dio
	name = "Канистра с угарным газом"
	desc = "Углекислый газ. Что за хрень этот углекислый газ?"
	cost = BUY_CRATE_VALUE * 6
	access_view = ACCESS_ATMOSPHERICS
	contains = list(/obj/machinery/portable_atmospherics/canister/carbon_dioxide)
	crate_name = "ящик с угарным газом"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials/bz
	name = "Канистра с БЗ"
	desc = "БЗ, сильнодействующее галлюциногенное нервно-паралитическое средство. Заблокирован"
	cost = BUY_CRATE_VALUE * 16
	access = ACCESS_TOXINS
	access_view = ACCESS_ATMOSPHERICS
	contains = list(/obj/machinery/portable_atmospherics/canister/bz)
	crate_name = "ящик с БЗ"
	crate_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/materials/water_vapor
	name = "Канистра с паром"
	desc = "Водяной пар. Мы поняли, ты вейпер."
	cost = BUY_CRATE_VALUE * 4
	contains = list(/obj/machinery/portable_atmospherics/canister/water_vapor)
	crate_name = "ящик с паром"
	crate_type = /obj/structure/closet/crate/large

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Medical /////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/medical
	group = "Медицина"
	access_view = ACCESS_MEDICAL
	crate_type = /obj/structure/closet/crate/medical

/datum/supply_pack/medical/supplies
	name = "Комплект аптечных припасов"
	desc = "Содержит аптечки и некоторые прочие химикаты."
	cost = BUY_CRATE_VALUE * 5
	contains = list(
		/obj/item/reagent_containers/glass/bottle/multiver,
		/obj/item/reagent_containers/glass/bottle/epinephrine,
		/obj/item/reagent_containers/glass/bottle/morphine,
		/obj/item/reagent_containers/pill/insulin,
		/obj/item/storage/pill_bottle/sens,
		/obj/item/storage/pill_bottle/psicodine,
		/obj/item/storage/pill_bottle/neurine,
		/obj/item/storage/pill_bottle/mannitol,
		/obj/item/storage/box/beakers,
		/obj/item/storage/box/syringes,
		/obj/item/storage/box/bodybags,
		/obj/item/storage/firstaid/regular,
		/obj/item/storage/firstaid/regular,
		/obj/item/storage/firstaid/o2,
		/obj/item/storage/firstaid/o2,
		/obj/item/storage/firstaid/toxin,
		/obj/item/storage/firstaid/toxin,
		/obj/item/storage/firstaid/brute,
		/obj/item/storage/firstaid/brute,
		/obj/item/storage/firstaid/fire,
		/obj/item/storage/firstaid/fire,
		/obj/item/reagent_containers/blood/o_minus,
		/obj/item/reagent_containers/blood/o_minus,
		/obj/item/reagent_containers/pill/neurine,
		/obj/item/stack/medical/bone_gel/four,
		)
	crate_name = "ящик аптечных припасов"

/datum/supply_pack/medical/medipen_variety
	name = "Комплект медипенов"
	desc = "Содержит очень широкий спектр медипенов на все случаи жизни и два пенала для медипенов."
	cost = BUY_CRATE_VALUE * 3
	contains = list(
		/obj/item/reagent_containers/hypospray/medipen,
		/obj/item/reagent_containers/hypospray/medipen,
		/obj/item/reagent_containers/hypospray/medipen/blood_loss,
		/obj/item/reagent_containers/hypospray/medipen/blood_loss,
		/obj/item/reagent_containers/hypospray/medipen/blood_boost,
		/obj/item/reagent_containers/hypospray/medipen/blood_boost,
		/obj/item/reagent_containers/hypospray/medipen/atropine,
		/obj/item/reagent_containers/hypospray/medipen/atropine,
		/obj/item/reagent_containers/hypospray/medipen/salacid,
		/obj/item/reagent_containers/hypospray/medipen/super_brute,
		/obj/item/reagent_containers/hypospray/medipen/oxandrolone,
		/obj/item/reagent_containers/hypospray/medipen/super_burn,
		/obj/item/reagent_containers/hypospray/medipen/penacid,
		/obj/item/reagent_containers/hypospray/medipen/penacid,
		/obj/item/reagent_containers/hypospray/medipen/salbutamol,
		/obj/item/reagent_containers/hypospray/medipen/salbutamol,
		/obj/item/reagent_containers/hypospray/medipen/morphine,
		/obj/item/reagent_containers/hypospray/medipen/sputnik_lite,
		/obj/item/storage/belt/medipenal,
		/obj/item/storage/belt/medipenal
		)
	crate_name = "ящик с медипенами"

/datum/supply_pack/medical/surgery
	name = "Комплект хирургических пренадлежностей"
	desc = "Вы хотите сделать операцию, но у вас нет ни одной из этих модных докторских степеней? Просто начните с этого ящика, содержащего медицинскую сумку, комплект операционных спрейев и складную кровать на колесиках."
	cost = BUY_CRATE_VALUE * 3
	contains = list(
		/obj/item/storage/backpack/duffelbag/med/surgery,
		/obj/item/reagent_containers/medigel/sterilizine,
		/obj/item/reagent_containers/medigel/formaldehyde,
		/obj/item/reagent_containers/medigel/epinephrine,
		/obj/item/reagent_containers/medigel/multiver,
		/obj/item/stack/medical/bone_gel/four,
		/obj/item/roller
		)
	crate_name = "ящик с хирургией"

/datum/supply_pack/medical/defibs
	name = "Комплект дефибрилляторов"
	desc = "Содержит два дефибриллятора для возвращения мертвых к жизни."
	cost = BUY_CRATE_VALUE * 3
	contains = list(/obj/item/defibrillator/loaded,
					/obj/item/defibrillator/loaded)
	crate_name = "ящик с дефибрилляторами"

/datum/supply_pack/medical/bloodpacks
	name = "Комплект донорской крови"
	desc = "Содержит двенадцать различных емкостей для введения крови пациентам и две капельницы."
	cost = BUY_CRATE_VALUE * 3
	contains = list(
		/obj/item/reagent_containers/blood,
		/obj/item/reagent_containers/blood,
		/obj/item/reagent_containers/blood/a_plus,
		/obj/item/reagent_containers/blood/a_minus,
		/obj/item/reagent_containers/blood/b_plus,
		/obj/item/reagent_containers/blood/b_minus,
		/obj/item/reagent_containers/blood/o_plus,
		/obj/item/reagent_containers/blood/o_minus,
		/obj/item/reagent_containers/blood/lizard,
		/obj/item/reagent_containers/blood/ethereal,
		/obj/item/reagent_containers/blood/universal,
		/obj/item/reagent_containers/blood/universal,
		/obj/item/iv_drip_item,
		/obj/item/iv_drip_item,
		)
	crate_name = "холодильник с кровью"
	crate_type = /obj/structure/closet/crate/freezer

/datum/supply_pack/medical/salglucanister
	name = "Комплект бака с физраствором"
	desc = "Канистра с физиологическим раствором, предназначенная для снабжения целого госпиталя, с устрашающего вида насосом, приспособленным для впрыскивания физиологического раствора в контейнеры. Подключать людей к нему напрямую явно не стоит."
	cost = BUY_CRATE_VALUE * 4
	access = ACCESS_MEDICAL
	contains = list(/obj/machinery/iv_drip/saline)

/datum/supply_pack/medical/chemical
	name = "Комплект портативного химмастера"
	desc = "Портативное устройство для хранения и смешивания химикатов. Изначально пуст и все необходимые вещества необходимо помещать внутрь при помощи хим-стаканов. В инструкции написано, что для получения доступа к химическому банку необходима отвертка. Переносится на поясе. На внутренней стороне виден логотип S&T."
	cost = BUY_CRATE_VALUE * 2.6
	contains = list(
		/obj/item/storage/portable_chem_mixer,
		/obj/item/reagent_containers/glass/bottle/hydrogen,
		/obj/item/reagent_containers/glass/bottle/carbon,
		/obj/item/reagent_containers/glass/bottle/nitrogen,
		/obj/item/reagent_containers/glass/bottle/oxygen,
		/obj/item/reagent_containers/glass/bottle/fluorine,
		/obj/item/reagent_containers/glass/bottle/phosphorus,
		/obj/item/reagent_containers/glass/bottle/silicon,
		/obj/item/reagent_containers/glass/bottle/chlorine,
		/obj/item/reagent_containers/glass/bottle/radium,
		/obj/item/reagent_containers/glass/bottle/sacid,
		/obj/item/reagent_containers/glass/bottle/ethanol,
		/obj/item/reagent_containers/glass/bottle/potassium,
		/obj/item/reagent_containers/glass/bottle/sugar,
		/obj/item/clothing/glasses/science,
		/obj/item/reagent_containers/dropper,
		/obj/item/storage/box/beakers
		)
	crate_name = "ящик портативного химмастера"

/datum/supply_pack/medical/chem_canister
	name = "Комплект химических компонентов"
	desc = "Содержит восемь канистр с основными химическими полуфабрикатами. Включает в себя: Диэтиламин, Фторовую пену, Аммиак, Ацетон, Масло, Фенол и два химических буфера."
	cost = BUY_CRATE_VALUE * 3
	access = ACCESS_MEDICAL
	contains = list(
		/obj/item/reagent_containers/glass/chem_canister/diethylamine,
		/obj/item/reagent_containers/glass/chem_canister/fluorosurfactant,
		/obj/item/reagent_containers/glass/chem_canister/ammonia,
		/obj/item/reagent_containers/glass/chem_canister/acetone,
		/obj/item/reagent_containers/glass/chem_canister/oil,
		/obj/item/reagent_containers/glass/chem_canister/phenol,
		/obj/item/reagent_containers/glass/chem_canister/basic_buffer,
		/obj/item/reagent_containers/glass/chem_canister/acidic_buffer
		)

/datum/supply_pack/medical/chem_glass
	name = "Комплект химических емкостей"
	desc = "Содержит в себе комплект малых, больших и метаматериальных химстаканов, аэрозолей, комплект таблетниц и одну химическую канистру."
	cost = BUY_CRATE_VALUE * 2
	access = ACCESS_MEDICAL
	contains = list(
		/obj/item/reagent_containers/glass/chem_canister,
		/obj/item/storage/box/beakers,
		/obj/item/storage/box/beakers/large_beakers,
		/obj/item/storage/box/meta_beakers,
		/obj/item/storage/box/medigels,
		/obj/item/storage/box/pillbottlesbig,
		/obj/item/storage/box/pillbottles,
		/obj/item/storage/pill_bottle/ultra
		)

/datum/supply_pack/medical/syringe_gun
	name = "Комплект шприцемётов"
	desc = "Пружинное оружие сконструированное для заряда шприцов, используется для выведения неуправляемых пациентов на расстоянии."
	cost = BUY_CRATE_VALUE * 5
	access = ACCESS_MEDICAL
	contains = list(
		/obj/item/gun/syringe,
		/obj/item/gun/syringe
		)
	crate_name = "ящик с шприцеметами"
	crate_type = /obj/structure/closet/crate/secure/plasma
	dangerous = TRUE

/datum/supply_pack/medical/virus
	name = "Комплект вирусолога"
	desc = "Содержит двенадцать различных флаконов, содержащих несколько образцов вирусов для вирусологических исследований. Также в комплект входят химстаканы, шприцы, обезьяньи кубики и все необходимые химикаты для мутации вирусов."
	cost = BUY_CRATE_VALUE * 3
	access = ACCESS_MEDICAL
	contains = list(
		/obj/item/reagent_containers/syringe/antiviral,
		/obj/item/reagent_containers/glass/bottle/mutagen,
		/obj/item/reagent_containers/glass/bottle/mutagen,
		/obj/item/reagent_containers/glass/bottle/sugar,
		/obj/item/reagent_containers/glass/bottle/plasma,
		/obj/item/reagent_containers/glass/bottle/plasma,
		/obj/item/reagent_containers/glass/bottle/plasma,
		/obj/item/reagent_containers/glass/bottle/synaptizine,
		/obj/item/reagent_containers/glass/bottle/formaldehyde,
		/obj/item/storage/box/syringes,
		/obj/item/storage/box/beakers,
		/obj/item/storage/box/monkeycubes,
		/obj/item/reagent_containers/glass/chem_canister/virus_food,
		/obj/item/storage/briefcase/surgery/virus
		)
	crate_name = "ящик вирусолога"
	crate_type = /obj/structure/closet/crate/secure/plasma
	dangerous = TRUE

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Science /////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/science
	group = "Наука"
	access_view = ACCESS_RESEARCH
	crate_type = /obj/structure/closet/crate/science

/datum/supply_pack/science/mod_core
	name = "Комплект ядер для МОД-Скафов"
	desc = "Содержит три ядра для сборки модульных скафандров."
	cost = BUY_CRATE_VALUE * 3
	access = ACCESS_ROBOTICS
	access_view = ACCESS_ROBOTICS
	contains = list(
		/obj/item/mod/core/standard,
		/obj/item/mod/core/standard,
		/obj/item/mod/core/standard
		)
	crate_name = "ящик с МОД ядрами"
	crate_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/science/robotics
	name = "Комплект для сборки ботов"
	desc = "Содержит в себе детали для сборки большого количества ботов всех возможных видов."
	cost = BUY_CRATE_VALUE * 2
	access = ACCESS_ROBOTICS
	access_view = ACCESS_ROBOTICS
	contains = list(
		/obj/item/assembly/prox_sensor,
		/obj/item/assembly/prox_sensor,
		/obj/item/assembly/prox_sensor,
		/obj/item/assembly/prox_sensor,
		/obj/item/storage/firstaid,
		/obj/item/storage/firstaid,
		/obj/item/healthanalyzer,
		/obj/item/healthanalyzer,
		/obj/item/clothing/head/hardhat/red,
		/obj/item/clothing/head/hardhat/red,
		/obj/item/storage/toolbox/mechanical,
		/obj/item/storage/toolbox/mechanical,
		/obj/item/bot_assembly/cleanbot,
		/obj/item/bot_assembly/cleanbot,
		)
	crate_name = "ящик с деталями ботов"
	crate_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/science/bots
	name = "Комплект с аварийными ботами"
	desc = "Содержит комплект из 6 собранных ботов для чрезвычайных ситуаций."
	cost = BUY_CRATE_VALUE * 4
	contains = list(
		/mob/living/simple_animal/bot/floorbot,
		/mob/living/simple_animal/bot/floorbot,
		/mob/living/simple_animal/bot/medbot,
		/mob/living/simple_animal/bot/medbot,
		/mob/living/simple_animal/bot/firebot,
		/mob/living/simple_animal/bot/firebot
		)
	crate_name = "ящик с ботами"
	crate_type = /obj/structure/closet/crate/internals

/datum/supply_pack/science/ripley
	name = "Комплект сборки АПЛУ MK-I \"Рипли\""
	desc = "Набор \"Сделай сам\" для сборки АПЛУ MK-I \"Рипли\", предназначенного для подъема и переноски тяжелого оборудования и других станционных задач."
	cost = BUY_CRATE_VALUE * 10
	access_view = ACCESS_ROBOTICS
	contains = list(
		/obj/item/mecha_parts/chassis/ripley,
		/obj/item/mecha_parts/part/ripley_torso,
		/obj/item/mecha_parts/part/ripley_right_arm,
		/obj/item/mecha_parts/part/ripley_left_arm,
		/obj/item/mecha_parts/part/ripley_right_leg,
		/obj/item/mecha_parts/part/ripley_left_leg,
		/obj/item/stock_parts/capacitor/adv,
		/obj/item/stock_parts/scanning_module/adv,
		/obj/item/stock_parts/cell/super,
		/obj/item/circuitboard/mecha/ripley/main,
		/obj/item/circuitboard/mecha/ripley/peripherals,
		/obj/item/mecha_parts/mecha_equipment/drill,
		/obj/item/mecha_parts/mecha_equipment/hydraulic_clamp,
		/obj/item/stack/sheet/iron/five,
		/obj/item/stack/rods/ten
		)
	crate_name= "ящик с деталями Рипли"

/datum/supply_pack/science/clarke
	name = "Комплект сборки \"Кларк\""
	desc = "Набор \"Сделай сам\" для сборки \"Кларк\", предназначенного для горного дела и других внестанционных задач."
	cost = BUY_CRATE_VALUE * 20
	access_view = ACCESS_ROBOTICS
	contains = list(
		/obj/item/mecha_parts/chassis/clarke,
		/obj/item/mecha_parts/part/clarke_torso,
		/obj/item/mecha_parts/part/clarke_left_arm,
		/obj/item/mecha_parts/part/clarke_right_arm,
		/obj/item/mecha_parts/part/clarke_head,
		/obj/item/stack/conveyor/four,
		/obj/item/stock_parts/capacitor/adv,
		/obj/item/stock_parts/scanning_module/adv,
		/obj/item/stock_parts/cell/super,
		/obj/item/circuitboard/mecha/clarke/main,
		/obj/item/circuitboard/mecha/clarke/peripherals,
		/obj/item/mecha_parts/mecha_equipment/weapon/energy/plasma,
		/obj/item/mecha_parts/mecha_equipment/weapon/energy/mecha_kineticgun,
		/obj/item/stack/sheet/mineral/gold/five,
		/obj/item/stack/sheet/plasteel/five
		)
	crate_name= "ящик с деталями кларка"

/datum/supply_pack/science/odysseus
	name = "Комплект сборки \"Одисей\""
	desc = "Набор \"Сделай сам\" для сборки \"Одисей\", предназначенного для полевой медицины, эвакуации раненых и других станционных задач."
	cost = BUY_CRATE_VALUE * 20
	access_view = ACCESS_ROBOTICS
	contains = list(
		/obj/item/mecha_parts/chassis/odysseus,
		/obj/item/mecha_parts/part/odysseus_head,
		/obj/item/mecha_parts/part/odysseus_torso,
		/obj/item/mecha_parts/part/odysseus_left_arm,
		/obj/item/mecha_parts/part/odysseus_right_arm,
		/obj/item/mecha_parts/part/odysseus_left_leg,
		/obj/item/mecha_parts/part/odysseus_right_leg,
		/obj/item/stock_parts/capacitor/adv,
		/obj/item/stock_parts/scanning_module/adv,
		/obj/item/stock_parts/cell/super,
		/obj/item/circuitboard/mecha/odysseus/main,
		/obj/item/circuitboard/mecha/odysseus/peripherals,
		/obj/item/mecha_parts/mecha_equipment/medical/mechmedbeam,
		/obj/item/mecha_parts/mecha_equipment/medical/sleeper,
		/obj/item/stack/sheet/iron/five,
		/obj/item/stack/sheet/plasteel/five
		)
	crate_name= "ящик с деталями одисея"

/datum/supply_pack/science/raw_flux_anomaly
	name = "Комплект электромагнитной аномалии"
	desc = "Слегка потрескивает энергией."
	cost = BUY_CRATE_VALUE * 3
	access = ACCESS_TOXINS
	access_view = ACCESS_TOXINS
	contains = list(/obj/item/raw_anomaly_core/flux)
	crate_type = /obj/structure/closet/crate/secure/science
	crate_name = "ящик электромагнитной аномалии"

/datum/supply_pack/science/raw_grav_anomaly
	name = "Комплект гравитационной аномалии"
	desc = "Воздух, кажется, притягивается к нему."
	cost = BUY_CRATE_VALUE * 3
	access = ACCESS_TOXINS
	access_view = ACCESS_TOXINS
	contains = list(/obj/item/raw_anomaly_core/grav)
	crate_type = /obj/structure/closet/crate/secure/science
	crate_name = "ящик гравитационной аномалии"

/datum/supply_pack/science/raw_vortex_anomaly
	name = "Комплект вихревой аномалии"
	desc = "Слегка вибрирует."
	cost = BUY_CRATE_VALUE * 3
	access = ACCESS_TOXINS
	access_view = ACCESS_TOXINS
	contains = list(/obj/item/raw_anomaly_core/vortex)
	crate_type = /obj/structure/closet/crate/secure/science
	crate_name = "ящик вихревой аномалии"

/datum/supply_pack/science/raw_bluespace_anomaly
	name = "Комплект блюспейс аномалии"
	desc = "Сияет скрытым потенциалом."
	cost = BUY_CRATE_VALUE * 3
	access = ACCESS_TOXINS
	access_view = ACCESS_TOXINS
	contains = list(/obj/item/raw_anomaly_core/bluespace)
	crate_type = /obj/structure/closet/crate/secure/science
	crate_name = "ящик блюспейс аномалии"

/datum/supply_pack/science/raw_pyro_anomaly
	name = "Комплект пирокластерной аномалии"
	desc = "Оно теплое на ощупь."
	cost = BUY_CRATE_VALUE * 3
	access = ACCESS_TOXINS
	access_view = ACCESS_TOXINS
	contains = list(/obj/item/raw_anomaly_core/pyro)
	crate_type = /obj/structure/closet/crate/secure/science
	crate_name = "ящик пирокластерной аномалии"

/datum/supply_pack/science/raw_hallucination_anomaly
	name = "Комплект галюциногенной аномалии"
	desc = "Ядро галюциногенной аномалии, от которого кружится голова."
	cost = BUY_CRATE_VALUE * 3
	access = ACCESS_TOXINS
	access_view = ACCESS_TOXINS
	contains = list(/obj/item/raw_anomaly_core/hallucination)
	crate_type = /obj/structure/closet/crate/secure/science
	crate_name = "ящик галюциногенной аномалии"

/datum/supply_pack/science/raw_bioscrambler_anomaly
	name = "Комплект биоконверсионной аномалии"
	desc = "Необработанное ядро биоконверсионной аномалии, оно извивается."
	cost = BUY_CRATE_VALUE * 3
	access = ACCESS_TOXINS
	access_view = ACCESS_TOXINS
	contains = list(/obj/item/raw_anomaly_core/bioscrambler)
	crate_type = /obj/structure/closet/crate/secure/science
	crate_name = "ящик биоконверсионной аномалии"

/datum/supply_pack/science/raw_dimensional_anomaly
	name = "Комплект пространственной аномалии"
	desc = "Необработанное ядро пространственной аномалии, вибрирующее с бесконечным потенциалом."
	cost = BUY_CRATE_VALUE * 3
	access = ACCESS_TOXINS
	access_view = ACCESS_TOXINS
	contains = list(/obj/item/raw_anomaly_core/dimensional)
	crate_type = /obj/structure/closet/crate/secure/science
	crate_name = "ящик пространственной аномалии"

/datum/supply_pack/science/transfer_valves
	name = "Комплект газовых вентилей"
	desc = "Имеет два разъема для газовых баллонов и клапан между ними. При открытии вентиля газы смешиваются и, если разница температур газов была достаточно велика, происходит взрыв."
	cost = BUY_CRATE_VALUE * 8
	access = ACCESS_TOXINS
	contains = list(
		/obj/item/transfer_valve,
		/obj/item/transfer_valve,
		/obj/item/transfer_valve,
		)
	crate_name = "ящик с газовыми вентилями"
	crate_type = /obj/structure/closet/crate/secure/science
	dangerous = TRUE

/datum/supply_pack/science/plasma
	name = "Комплект газовых мин"
	desc = "Все, что вам нужно, чтобы воплотить что-то в жизнь, - это три комплекта для сборки плазменных мин. Каждый набор содержит плазменный бак, воспламенитель, датчик приближения и таймер! Гарантия аннулируется при воздействии высоких температур. Для открытия требуется доступ к взрывотехнике."
	cost = BUY_CRATE_VALUE * 2
	access = ACCESS_TOXINS
	access_view = ACCESS_TOXINS
	contains = list(
		/obj/item/tank/internals/plasma,
		/obj/item/tank/internals/plasma,
		/obj/item/tank/internals/plasma,
		/obj/item/assembly/igniter,
		/obj/item/assembly/igniter,
		/obj/item/assembly/igniter,
		/obj/item/assembly/prox_sensor,
		/obj/item/assembly/prox_sensor,
		/obj/item/assembly/prox_sensor,
		/obj/item/assembly/timer,
		/obj/item/assembly/timer,
		/obj/item/assembly/timer
		)
	crate_name = "ящик с плазменными минами"
	crate_type = /obj/structure/closet/crate/secure/plasma
	dangerous = TRUE

/datum/supply_pack/science/scrapyard
	name = "Комплект аномальных объектов"
	desc = "Возможно РНД сможет разобраться что же это такое. Содержит десять образцов."
	cost = BUY_CRATE_VALUE * 4
	contains = list(
		/obj/item/relic,
		/obj/item/relic,
		/obj/item/relic,
		/obj/item/relic,
		/obj/item/relic,
		/obj/item/relic,
		/obj/item/relic,
		/obj/item/relic,
		/obj/item/relic,
		/obj/item/relic,
		)
	crate_name = "ящик с аномальными объектами"

/datum/supply_pack/science/monkey_helmets
	name = "Комплект для увеличения интеллекта обезьян"
	desc = "Хрупкий шлем со встроенными микросхемами, предназначенный для повышения уровня IQ обезьян."
	cost = BUY_CRATE_VALUE * 3
	contains = list(
		/obj/item/clothing/head/helmet/monkey_sentience,
		/obj/item/clothing/head/helmet/monkey_sentience,
		/obj/item/clothing/head/helmet/monkey_sentience
		)
	crate_name = "ящик для увеличения интеллекта обезьян"

/datum/supply_pack/science/cytology
	name = "Комплект цитологии"
	desc = "На случай если вышедшие из-под контроля образцы стерли ксенобиологию в порошок. Вот еще несколько расходных материалов для дальнейшего тестирования."
	cost = BUY_CRATE_VALUE * 3
	access_view = ACCESS_XENOBIOLOGY
	contains = list(
		/obj/structure/microscope,
		/obj/item/biopsy_tool,
		/obj/item/storage/box/petridish,
		/obj/item/storage/box/petridish,
		/obj/item/storage/box/swab,
		/obj/item/construction/plumbing/research
		)
	crate_name = "ящик цитологии"

/datum/supply_pack/science/reserve
	name = "Комплект резервных плат РНД"
	desc = "Предназначены для тех случаев, когда нет возможности воспроизвести новые."
	cost = BUY_CRATE_VALUE * 4
	access_view = ACCESS_CAPTAIN
	contains = list(
		/obj/item/circuitboard/computer/aifixer,
		/obj/item/circuitboard/machine/rdserver,
		/obj/item/circuitboard/machine/mechfab,
		/obj/item/circuitboard/machine/circuit_imprinter,
		/obj/item/circuitboard/machine/destructive_analyzer,
		/obj/item/circuitboard/computer/rdconsole,
		/obj/item/circuitboard/machine/mechfab/sci,
		/obj/item/reagent_containers/glass/beaker/large,
		/obj/item/reagent_containers/glass/beaker/large
		)
	crate_name = "ящик с платами РНД"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/science/spaceminer
	name = "Комплект стоек для майнинга"
	desc = "Стойка для установки специального \"оборудования\" по созданию денег из нервных клеток пользователей игровых ПК."
	cost = BUY_CRATE_VALUE * 1.5
	contains = list(/obj/machinery/power/mining_rack)
	crate_name = "ящик стойки для майнинга"

//////////////////////////////////////////////////////////////////////////////
/////////////////////////////// Service //////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/service
	group = "Карго и Сервис"

/datum/supply_pack/service/cargo_supples
	name = "Комплект карготехника"
	desc = "Есть талант к продаже всего, что не было прикручено болтами? Вы можете сразу же приступить к работе с этим ящиком, содержащим марки, сканер для экспорта, устройство для определения места назначения, ручную этикетировочную машину и упаковку для посылок."
	cost = BUY_CRATE_VALUE * 1.75
	contains = list(
		/obj/item/stamp,
		/obj/item/stamp/denied,
		/obj/item/export_scanner,
		/obj/item/dest_tagger,
		/obj/item/hand_labeler,
		/obj/item/stack/package_wrap
		)
	crate_name = "ящик карготехника"

/datum/supply_pack/service/minerkit
	name = "Комплект шахтера"
	desc = "Все шахтеры умерли слишком быстро? Ассистент хочет почувствовать вкус жизни за пределами станции? В любом случае, этот набор - лучший способ превратить обычного члена экипажа в машину для добычи руды и уничтожения монстров. Содержит мезонные очки, кирку, усовершенствованный шахтерский сканер, грузовую гарнитуру, подушку безопасности, противогаз, костюм исследователя и обновление удостоверения шахтера. Для открытия требуется доступ Квартермействера."
	cost = BUY_CRATE_VALUE * 3
	access = ACCESS_QM
	access_view = ACCESS_MINING_STATION
	contains = list(
		/obj/item/storage/backpack/duffelbag/mining_conscript,
		/obj/item/storage/backpack/duffelbag/mining_conscript,
		/obj/item/storage/backpack/duffelbag/mining_conscript
		)
	crate_name = "ящик шахтера"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/service/mule
	name = "Комплект с МУЛ-ботом"
	desc = "Компактная транспортная платформа с встроенным базовым навигационным протоколом."
	cost = BUY_CRATE_VALUE * 4
	contains = list(/mob/living/simple_animal/bot/mulebot)
	crate_name = "ящик МУЛ-бота"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/service/farmbox
	name = "Комплект денежной груши"
	desc = "Странным образом трансформирует силу киннетических ударов в деньги."
	cost = BUY_CRATE_VALUE * 25
	contains = list(/obj/structure/punching_bag/pizdul)
	crate_name = "farmbox"
	crate_type = /obj/structure/closet/crate/large
	dangerous = TRUE

/datum/supply_pack/service/exploration_drone
	name = "Комплект с исследовательским дроном"
	desc = "Сменный разведывательный беспилотник дальнего действия."
	cost = BUY_CRATE_VALUE * 2
	contains = list(/obj/item/exodrone)
	crate_name = "ящик с исследовательским дроном"

/datum/supply_pack/service/janitor
	name = "Комплект снаряжения уборщика"
	desc = "Боритесь с грязью и копотью с помощью средств для уборки НаноТрейзен(ТМ)! Содержит ведра, знаки предостережения и очистительные гранаты. В комплект так же входят швабра, щетка, аэрозольное чистящее средство, тряпка и мешок для мусора."
	cost = BUY_CRATE_VALUE * 2
	contains = list(
		/obj/item/reagent_containers/glass/bucket,
		/obj/item/reagent_containers/glass/bucket,
		/obj/item/reagent_containers/glass/bucket,
		/obj/item/mop,
		/obj/item/pushbroom,
		/obj/item/clothing/suit/caution,
		/obj/item/clothing/suit/caution,
		/obj/item/clothing/suit/caution,
		/obj/item/storage/bag/trash,
		/obj/item/reagent_containers/spray/cleaner,
		/obj/item/reagent_containers/glass/rag,
		/obj/item/grenade/chem_grenade/cleaner,
		/obj/item/grenade/chem_grenade/cleaner,
		/obj/item/grenade/chem_grenade/cleaner
		)
	crate_name = "ящик уборщика"

/datum/supply_pack/service/janicart
	name = "Комплект тележки уборщика"
	desc = "Краеугольный камень любого успешного уборщика. Позволяет хранить в себе практически весь уборочный инвентарь. В комплект так же входят галоши."
	cost = BUY_CRATE_VALUE * 2
	contains = list(
		/obj/structure/janitorialcart,
		/obj/item/clothing/shoes/galoshes
		)
	crate_name = "ящик с тележкой уборщика"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/service/janitank
	name = "Комплект с заспинным моющим распылителем"
	desc = "Огромный танк с моющим средством, раствора хватит на очистку помещения даже после трехчасовой рабочей смены. В комплект входит спецодежда"
	cost = BUY_CRATE_VALUE * 2
	contains = list(
		/obj/item/watertank/janitor,
		/obj/item/clothing/suit/hazardvest/janitor
		)
	crate_name = "ящик с моющим распылителем"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/service/cleaner
	name = "Комплект очистительных гранат"
	desc = "Убер гранаты от компании Космочист. Является товарной маркой - все права защищены."
	cost = BUY_CRATE_VALUE * 2.4
	contains = list(
		/obj/item/storage/box/cleaner,
		/obj/item/storage/box/cleaner
		)
	crate_name = "ящик очистительных гранат"

/datum/supply_pack/service/lights
	name = "Комплект с осветительным набором"
	desc = "Содержит три коробки лампочек, 2 коробки анкерных каркасов ламп, коробку сигнальных шашек и лампозаменитель."
	cost = BUY_CRATE_VALUE * 3.5
	contains = list(
		/obj/item/storage/box/autobuild_lights,
		/obj/item/storage/box/autobuild_lights/small,
		/obj/item/storage/box/lights/mixed,
		/obj/item/storage/box/lights/mixed,
		/obj/item/storage/box/lights/mixed,
		/obj/item/storage/box/flare,
		/obj/item/lightreplacer
		)
	crate_name = "ящик с осветительным набором"

/datum/supply_pack/service/noslipfloor
	name = "Комплект противоскользящей напольной плитки"
	desc = "Благодаря хорошему сцеплению с поверхностью на этой плитке невозможно подскользнуться. Так же незначительно повышает скорость перемещения. На ощупь кажется немного резиновой."
	cost = BUY_CRATE_VALUE * 2
	access_view = ACCESS_JANITOR
	contains = list(
		/obj/item/stack/tile/noslip/fifty,
		/obj/item/stack/tile/noslip/fifty,
		/obj/item/stack/tile/noslip/fifty,
		/obj/item/stack/tile/noslip/fifty,
		)
	crate_name = "ящик с противоскользящей напольной плиткой"

/datum/supply_pack/service/carpet
	name = "Комплект премиум ковров"
	desc = "Надоела пласталь? Эти рулоны сверхмягкого ковра облагородят любое помещение."
	cost = BUY_CRATE_VALUE * 2
	contains = list(
		/obj/item/stack/tile/carpet/fifty,
		/obj/item/stack/tile/carpet/fifty,
		/obj/item/stack/tile/carpet/black/fifty,
		/obj/item/stack/tile/carpet/black/fifty
		)
	crate_name = "ящик с коврами"

/datum/supply_pack/service/carpet_exotic
	name = "Комплект экзотических ковров"
	desc = "Экзотические ковры прямо из Космической России для любых ваших потребностей в декорировании. Содержит по 100 квадратных метров, в восьми различных вариациях напольного покрытия."
	cost = BUY_CRATE_VALUE * 4
	contains = list(
		/obj/item/stack/tile/carpet/blue/fifty,
		/obj/item/stack/tile/carpet/blue/fifty,
		/obj/item/stack/tile/carpet/cyan/fifty,
		/obj/item/stack/tile/carpet/cyan/fifty,
		/obj/item/stack/tile/carpet/green/fifty,
		/obj/item/stack/tile/carpet/green/fifty,
		/obj/item/stack/tile/carpet/orange/fifty,
		/obj/item/stack/tile/carpet/orange/fifty,
		/obj/item/stack/tile/carpet/purple/fifty,
		/obj/item/stack/tile/carpet/purple/fifty,
		/obj/item/stack/tile/carpet/red/fifty,
		/obj/item/stack/tile/carpet/red/fifty,
		/obj/item/stack/tile/carpet/royalblue/fifty,
		/obj/item/stack/tile/carpet/royalblue/fifty,
		/obj/item/stack/tile/carpet/royalblack/fifty,
		/obj/item/stack/tile/carpet/royalblack/fifty
		)
	crate_name = "ящик с коврами"

/datum/supply_pack/service/grill
	name = "Комплект гриля"
	desc = "Эй, папа, я проголодался! Привет голодающим! Я - НОВЫЙ СТАРТОВЫЙ НАБОР ДЛЯ ПРИГОТОВЛЕНИЯ НА ГРИЛЕ, КОТОРЫЙ МОЖНО ПРИОБРЕСТИ ВСЕГО ЗА 4000 БАКСОВ ПРЯМО СЕЙЧАС! Содержит гриль и топливо."
	cost = BUY_CRATE_VALUE * 4
	crate_type = /obj/structure/closet/crate
	contains = list(
		/obj/machinery/grill/unwrenched,
		/obj/item/stack/sheet/mineral/coal/ten,
		/obj/item/stack/sheet/mineral/coal/ten,
		/obj/item/reagent_containers/food/drinks/soda_cans/monkey_energy,
		/obj/item/reagent_containers/food/drinks/soda_cans/monkey_energy
		)
	crate_name = "ящик с грилем"

/datum/supply_pack/service/beekeeping_suits
	name = "Комплект пчеловода"
	desc = "Пчелиный бизнес процветает? Лучше проявите великодушие и поддержите ботанику, подарив костюмы би-пчеловода! Содержит два костюма пчеловода и соответствующие головные уборы."
	cost = BUY_CRATE_VALUE * 2
	contains = list(
		/obj/structure/beebox/unwrenched,
		/obj/structure/beebox/unwrenched,
		/obj/item/honey_frame,
		/obj/item/honey_frame,
		/obj/item/honey_frame,
		/obj/item/honey_frame,
		/obj/item/honey_frame,
		/obj/item/honey_frame,
		/obj/item/queen_bee/bought,
		/obj/item/queen_bee/bought,
		/obj/item/clothing/head/beekeeper_head,
		/obj/item/clothing/suit/beekeeper_suit,
		/obj/item/clothing/head/beekeeper_head,
		/obj/item/clothing/suit/beekeeper_suit,
		/obj/item/melee/flyswatter
		)
	crate_name = "ящик пчеловода"
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/service/hydroponics
	name = "Комплект ботаника"
	desc = "Принадлежности для выращивания великолепного сада! Содержит два флакона с аммиаком, два распылителя для защиты растений, топор, культиватор, анализатор растений, а также пару кожаных перчаток и фартук ботаника."
	cost = BUY_CRATE_VALUE * 3
	contains = list(
		/obj/item/reagent_containers/spray/plantbgone,
		/obj/item/reagent_containers/spray/plantbgone,
		/obj/item/reagent_containers/glass/bottle/ammonia,
		/obj/item/reagent_containers/glass/bottle/ammonia,
		/obj/item/hatchet,
		/obj/item/cultivator,
		/obj/item/plant_analyzer,
		/obj/item/clothing/gloves/botanic_leather,
		/obj/item/clothing/suit/apron,
		/obj/item/watertank
		)
	crate_name = "ящик ботаника"
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/service/seeds
	name = "Комплект базовых семян"
	desc = "Большие дела начинаются с малого. Содержит четырнадцать различных семян."
	cost = BUY_CRATE_VALUE * 2
	contains = list(
		/obj/item/seeds/chili,
		/obj/item/seeds/cotton,
		/obj/item/seeds/berry,
		/obj/item/seeds/corn,
		/obj/item/seeds/eggplant,
		/obj/item/seeds/tomato,
		/obj/item/seeds/soya,
		/obj/item/seeds/wheat,
		/obj/item/seeds/wheat/rice,
		/obj/item/seeds/carrot,
		/obj/item/seeds/sunflower,
		/obj/item/seeds/rose,
		/obj/item/seeds/chanter,
		/obj/item/seeds/potato,
		/obj/item/seeds/sugarcane
		)
	crate_name = "ящик с семенами"
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/service/exoticseeds
	name = "Комплект экзотических семян"
	desc = "Мечта любого начинающего ботаника. Содержит огромное количество различных семян!"
	cost = BUY_CRATE_VALUE * 3
	access_view = ACCESS_HYDROPONICS
	contains = list(
		/obj/item/seeds/replicapod,
		/obj/item/seeds/replicapod,
		/obj/item/seeds/plump,
		/obj/item/seeds/plump,
		/obj/item/seeds/amanita,
		/obj/item/seeds/amanita,
		/obj/item/seeds/bamboo,
		/obj/item/seeds/bamboo,
		/obj/item/seeds/rainbow_bunch,
		/obj/item/seeds/rainbow_bunch,
		/obj/item/seeds/shrub,
		/obj/item/seeds/shrub,
		/obj/item/seeds/nettle,
		/obj/item/seeds/nettle,
		/obj/item/seeds/liberty,
		/obj/item/seeds/liberty,
		/obj/item/seeds/reishi,
		/obj/item/seeds/reishi,
		/obj/item/seeds/eggplant/eggy,
		/obj/item/seeds/eggplant/eggy,
		/obj/item/seeds/random,
		/obj/item/seeds/random,
		/obj/item/seeds/random,
		/obj/item/seeds/random,
		/obj/item/seeds/random,
		/obj/item/seeds/random,
		/obj/item/seeds/random,
		/obj/item/seeds/random,
		/obj/item/seeds/random
		)
	crate_name = "ящик с семенами"
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/service/weedcontrol
	name = "Комплект гербицидов"
	desc = "Используется для очистки больших площадей от паразитических видов растений. Так же содержит косу для ручной уборки растений."
	cost = BUY_CRATE_VALUE * 2.5
	access = ACCESS_HYDROPONICS
	contains = list(
		/obj/item/scythe,
		/obj/item/clothing/mask/gas,
		/obj/item/grenade/chem_grenade/antiweed,
		/obj/item/grenade/chem_grenade/antiweed,
		/obj/item/reagent_containers/spray/weedspray,
		/obj/item/reagent_containers/spray/weedspray
		)
	crate_name = "ящик с гербицидами"
	crate_type = /obj/structure/closet/crate/secure/hydroponics

/datum/supply_pack/service/shrubbery
	name = "Комплект живой изгороди"
	desc = "Ящик, полный кустов живой изгороди."
	cost = BUY_CRATE_VALUE * 3
	crate_name = "ящик с кустарниками"
	var/shrub_amount = 8

/datum/supply_pack/service/shrubbery/fill(obj/structure/closet/crate/C)
	for(var/i in 1 to shrub_amount)
		new /obj/item/grown/shrub(C)

/datum/supply_pack/service/religious_supplies
	name = "Комплект священника"
	desc = "Позаботьтесь о том, чтобы ваш местный капеллан был доволен и хорошо обеспечен, чтобы они не осудили ваш грузовой отсек. Содержит две бутылки святой воды, библии, мантии капеллана и погребальные одежды."
	cost = BUY_CRATE_VALUE * 3
	access_view = ACCESS_CHAPEL_OFFICE
	contains = list(
		/obj/item/reagent_containers/food/drinks/bottle/holywater,
		/obj/item/reagent_containers/food/drinks/bottle/holywater,
		/obj/item/storage/book/bible/booze,
		/obj/item/storage/book/bible/booze,
		/obj/item/clothing/suit/hooded/chaplain_hoodie,
		/obj/item/clothing/suit/hooded/chaplain_hoodie
		)
	crate_name = "ящик священника"

/datum/supply_pack/service/holy_grenades
	name = "Комплект освящающих гранат"
	desc = "Граната для быстрого освящения больших помещений."
	cost = BUY_CRATE_VALUE * 4
	access_view = ACCESS_CHAPEL_OFFICE
	contains = list(
		/obj/item/reagent_containers/food/drinks/bottle/holywater,
		/obj/item/storage/box/holy_pena_grenades
		)
	crate_name = "ящик святых гранат"

/datum/supply_pack/service/funeral
	name = "Комплект для похорон"
	desc = "В конце дня, обычно кто-то всегда захочет чьей-то смерти. Устройте им достойные проводы с этими похоронными принадлежностями! Содержит гроб с погребальными одеждами и цветами."
	cost = BUY_CRATE_VALUE * 1.6
	access_view = ACCESS_CHAPEL_OFFICE
	contains = list(
		/obj/item/clothing/under/misc/burial,
		/obj/item/food/grown/harebell,
		/obj/item/food/grown/poppy/geranium
		)
	crate_name = "гроб"
	crate_type = /obj/structure/closet/crate/coffin

/datum/supply_pack/service/wedding
	name = "Комплект для свадьбы"
	desc = "Все, что вам нужно для проведения свадьбы! Осталось найти священника."
	cost = BUY_CRATE_VALUE * 3
	contains = list(
		/obj/item/clothing/under/dress/wedding_dress,
		/obj/item/clothing/under/suit/tuxedo,
		/obj/item/storage/belt/cummerbund,
		/obj/item/clothing/head/weddingveil,
		/obj/item/bouquet,
		/obj/item/bouquet/sunflower,
		/obj/item/bouquet/poppy,
		/obj/item/reagent_containers/food/drinks/bottle/champagne
		)
	crate_name = "свадебный ящик"

/// Box of 7 grey IDs.
/datum/supply_pack/service/greyidbox
	name = "Комплект серых ID-карт"
	desc = "Удобный ящик, содержащий коробку дешевых удостоверений личности в удобном форм-факторе размером с бумажник. Удостоверения бывают любого цвета, который вы только можете себе представить, главное, чтобы они были серыми."
	cost = BUY_CRATE_VALUE * 3
	contains = list(/obj/item/storage/box/ids)
	crate_name = "ящик с серыми ID картами"

/// Single silver ID.
/datum/supply_pack/service/silverid
	name = "Комплект с серебряной ID-картой"
	desc = "Неужели мы забыли нанять кого-нибудь из руководителей? Набирайте своих сотрудников с помощью этой ценной идентификационной карты, обеспечивающей расширенный уровень доступа в удобном форм-факторе размером с бумажник."
	cost = BUY_CRATE_VALUE * 7
	contains = list(/obj/item/card/id/advanced/silver)
	crate_name = "ящик с серебряной ID картой"

/datum/supply_pack/service/emptycrate
	name = "Пустой ящик"
	desc = "Это пустой ящик для всех ваших запросов в хранении."
	cost = BUY_CRATE_VALUE * 1.4 //Net Zero Profit.
	contains = list()
	crate_name = "ящик"

/datum/supply_pack/service/empty
	name = "почтовая капсула"
	desc = "Представляем современнейшую систему доставки НаноТрейзен! Перевозите грузы с изяществом и легкостью! Позвоните сегодня, и мы снимем демо-версию всего за 300 кредитов!"
	cost = 300 //Empty pod, so no crate refund
	contains = list()
	DropPodOnly = TRUE
	crate_type = null
	special_pod = /obj/structure/closet/supplypod/bluespacepod

/datum/supply_pack/service/empty/generate()
	return null

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Organic /////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/organic
	group = "Еда"
	crate_type = /obj/structure/closet/crate/freezer

/datum/supply_pack/organic/randomized/donkpockets
	name = "Комплект Донк-пакетов в ассортименте"
	desc = "Представлена линейка самых популярных кондитерских изделий Донк Ко!"
	cost = BUY_CRATE_VALUE * 4
	contains = list(
		/obj/item/storage/box/donkpockets/donkpocketspicy,
		/obj/item/storage/box/donkpockets/donkpocketteriyaki,
		/obj/item/storage/box/donkpockets/donkpocketpizza,
		/obj/item/storage/box/donkpockets/donkpocketberry,
		/obj/item/storage/box/donkpockets/donkpockethonk
		)
	crate_name = "ящик с Донк-пакетами"

/datum/supply_pack/organic/randomized/donkpockets/fill(obj/structure/closet/crate/C)
	for(var/i in 1 to 6)
		var/item = pick(contains)
		new item(C)

/datum/supply_pack/organic/randomized/ready_donk
	name = "Комплект готовых Донк-пакетов"
	desc = "Представлена линейка самых популярных кондитерских изделий Donk Co.!"
	cost = BUY_CRATE_VALUE * 3
	contains = list(
		/obj/item/food/ready_donk,
		/obj/item/food/ready_donk/mac_n_cheese,
		/obj/item/food/ready_donk/donkhiladas
		)
	crate_name = "ящик с готовыми Донк-пакетами"

/datum/supply_pack/organic/randomized/ready_donk/fill(obj/structure/closet/crate/C)
	for(var/i in 1 to 6)
		var/item = pick(contains)
		new item(C)

/datum/supply_pack/organic/pizza
	name = "Комплект пиццы в ассортименте"
	desc = "Лучшие цены на этой стороне галактики. Все поставки гарантированно на 99% не содержат аномалий!"
	cost = BUY_CRATE_VALUE * 10 // Best prices this side of the galaxy.
	contains = list(
		/obj/item/pizzabox/margherita,
		/obj/item/pizzabox/mushroom,
		/obj/item/pizzabox/meat,
		/obj/item/pizzabox/vegetable,
		/obj/item/pizzabox/pineapple
		)
	crate_name = "ящик с пиццей"
	var/static/anomalous_box_provided = FALSE

/datum/supply_pack/organic/pizza/fill(obj/structure/closet/crate/C)
	. = ..()
	if(!anomalous_box_provided)
		for(var/obj/item/pizzabox/P in C)
			if(prob(1)) //1% chance for each box, so 4% total chance per order
				var/obj/item/pizzabox/infinite/fourfiveeight = new(C)
				fourfiveeight.boxtag = P.boxtag
				fourfiveeight.boxtag_set = TRUE
				fourfiveeight.update_appearance()
				qdel(P)
				anomalous_box_provided = TRUE
				log_game("An anomalous pizza box was provided in a pizza crate at during cargo delivery")
				if(prob(50))
					addtimer(CALLBACK(src, PROC_REF(anomalous_pizza_report)), rand(300, 1800))
				else
					message_admins("An anomalous pizza box was silently created with no command report in a pizza crate delivery.")
				break

/datum/supply_pack/organic/pizza/proc/anomalous_pizza_report()
	print_command_report("[station_name()], наш отдел аномальных материалов сообщил об пропавшем предмете, который, скорее всего, был отправлен на вашу станцию во время обычной доставки груза. \
	Пожалуйста, обыщите все ящики и манифесты, поставляемые с доставкой, и верните объект, если он найден. Объект напоминает стандартный <b>\[ДАННЫЕ УДАЛЕНЫ\]</b> и должен быть \
	<b>\[ДАННЫЕ УДАЛЕНЫ\]</b> и возвращён как будет время. Обратите внимание, что объекты, создаваемые аномалией, специально настроены именно на человека, открывающего аномалию; независимо от вида, \
	человек сочтет объект съедобным, и он будет иметь прекрасный вкус в соответствии с его личными определениями, которые значительно различаются в зависимости от человека и вида.")

/datum/supply_pack/organic/catering
	name = "Комплект сэндвичей"
	desc = "Нет повара? Не беда! Сейчас папа нарубает! Папа может!"
	cost = BUY_CRATE_VALUE * 5
	contains = list(/obj/item/food/sandwich,
					/obj/item/food/sandwich,
					/obj/item/food/sandwich,
					/obj/item/food/sandwich,
					/obj/item/food/grilled_cheese_sandwich,
					/obj/item/food/grilled_cheese_sandwich,
					/obj/item/food/notasandwich,
					/obj/item/food/cheese_sandwich,
					/obj/item/food/cheese_sandwich,
					/obj/item/food/jellysandwich,
					/obj/item/food/jellysandwich,
					)
	crate_name = "ящик сэндвичей"

/datum/supply_pack/organic/food
	name = "Комплект припасов для кухни"
	desc = "Приготовьте что-нибудь вкусненькое с помощью этого ящика, полного полезных ингредиентов! Содержит дюжину яиц, три банана, немного муки, рис, молоко, соевое молоко, соль, перец, фермент, сахар и мясо обезьяны."
	cost = BUY_CRATE_VALUE * 2
	contains = list(
		/obj/item/reagent_containers/food/condiment/flour,
		/obj/item/reagent_containers/food/condiment/flour,
		/obj/item/reagent_containers/food/condiment/rice,
		/obj/item/reagent_containers/food/condiment/rice,
		/obj/item/reagent_containers/food/condiment/milk,
		/obj/item/reagent_containers/food/condiment/milk,
		/obj/item/reagent_containers/food/condiment/soymilk,
		/obj/item/reagent_containers/food/condiment/soymilk,
		/obj/item/reagent_containers/food/condiment/saltshaker,
		/obj/item/reagent_containers/food/condiment/peppermill,
		/obj/item/storage/fancy/egg_box,
		/obj/item/storage/fancy/egg_box,
		/obj/item/reagent_containers/food/condiment/enzyme,
		/obj/item/reagent_containers/food/condiment/sugar,
		/obj/item/food/meat/slab/monkey,
		/obj/item/food/meat/slab/monkey,
		/obj/item/food/grown/banana,
		/obj/item/food/grown/banana,
		/obj/item/food/grown/banana
		)
	crate_name = "ящик с припасами для кухни"

/datum/supply_pack/organic/fruits
	name = "Комплект фруктов"
	desc = "Богат витаминами, может содержать цитрусовые."
	cost = BUY_CRATE_VALUE * 2
	contains = list(
		/obj/item/food/grown/citrus/lime,
		/obj/item/food/grown/citrus/lime,
		/obj/item/food/grown/citrus/lime,
		/obj/item/food/grown/citrus/orange,
		/obj/item/food/grown/citrus/orange,
		/obj/item/food/grown/citrus/orange,
		/obj/item/food/grown/watermelon,
		/obj/item/food/grown/watermelon,
		/obj/item/food/grown/watermelon,
		/obj/item/food/grown/apple,
		/obj/item/food/grown/apple,
		/obj/item/food/grown/apple,
		/obj/item/food/grown/berries,
		/obj/item/food/grown/berries,
		/obj/item/food/grown/berries,
		/obj/item/food/grown/citrus/lemon,
		/obj/item/food/grown/citrus/lemon,
		/obj/item/food/grown/citrus/lemon,
		)
	crate_name = "ящик с фруктами"

/datum/supply_pack/organic/vegetables
	name = "Комплект овощей"
	desc = "Выращивается в чанах."
	cost = BUY_CRATE_VALUE * 2
	contains = list(
		/obj/item/food/grown/chili,
		/obj/item/food/grown/chili,
		/obj/item/food/grown/chili,
		/obj/item/food/grown/corn,
		/obj/item/food/grown/corn,
		/obj/item/food/grown/corn,
		/obj/item/food/grown/tomato,
		/obj/item/food/grown/tomato,
		/obj/item/food/grown/tomato,
		/obj/item/food/grown/potato,
		/obj/item/food/grown/potato,
		/obj/item/food/grown/potato,
		/obj/item/food/grown/carrot,
		/obj/item/food/grown/carrot,
		/obj/item/food/grown/carrot,
		/obj/item/food/grown/mushroom/chanterelle,
		/obj/item/food/grown/mushroom/chanterelle,
		/obj/item/food/grown/mushroom/chanterelle,
		/obj/item/food/grown/onion,
		/obj/item/food/grown/onion,
		/obj/item/food/grown/onion,
		/obj/item/food/grown/pumpkin,
		/obj/item/food/grown/pumpkin,
		/obj/item/food/grown/pumpkin,
		)
	crate_name = "ящик с овощами"

/datum/supply_pack/organic/chef
	name = "Комплект мясного ассорти"
	desc = "Лучшие нарезки во всей галактике."
	cost = BUY_CRATE_VALUE * 2
	contains = list(
		/obj/item/food/meat/slab/human/mutant/slime,
		/obj/item/food/meat/slab/human/mutant/slime,
		/obj/item/food/meat/slab/human/mutant/slime,
		/obj/item/food/meat/slab/killertomato,
		/obj/item/food/meat/slab/killertomato,
		/obj/item/food/meat/slab/killertomato,
		/obj/item/food/meat/slab/bear,
		/obj/item/food/meat/slab/bear,
		/obj/item/food/meat/slab/bear,
		/obj/item/food/meat/slab/xeno,
		/obj/item/food/meat/slab/xeno,
		/obj/item/food/meat/slab/xeno,
		/obj/item/food/meat/slab/spider,
		/obj/item/food/meat/slab/spider,
		/obj/item/food/meat/slab/spider,
		/obj/item/food/meat/rawbacon,
		/obj/item/food/meat/rawbacon,
		/obj/item/food/meat/rawbacon,
		/obj/item/food/meat/slab/penguin,
		/obj/item/food/meat/slab/penguin,
		/obj/item/food/meat/slab/penguin,
		/obj/item/food/spiderleg,
		/obj/item/food/spiderleg,
		/obj/item/food/spiderleg,
		/obj/item/food/fishmeat/carp,
		/obj/item/food/fishmeat/carp,
		/obj/item/food/fishmeat/carp,
		/obj/item/food/meat/slab/human,
		/obj/item/food/meat/slab/human,
		/obj/item/food/meat/slab/human,
		)
	crate_name = "ящик с мясом"

/datum/supply_pack/organic/party
	name = "Комплект бухла для вечеринок"
	desc = "Отпразднуйте свою жизнь и смерть на станции!"
	cost = BUY_CRATE_VALUE * 2
	contains = list(
		/obj/item/storage/box/drinkingglasses,
		/obj/item/reagent_containers/food/drinks/shaker,
		/obj/item/reagent_containers/food/drinks/bottle/patron,
		/obj/item/reagent_containers/food/drinks/bottle/goldschlager,
		/obj/item/reagent_containers/food/drinks/ale,
		/obj/item/reagent_containers/food/drinks/bottle/rum,
		/obj/item/reagent_containers/food/drinks/bottle/vodka/badminka,
		/obj/item/reagent_containers/food/drinks/bottle/candycornliquor,
		/obj/item/reagent_containers/food/drinks/bottle/whiskey,
		/obj/item/storage/cans/sixbeer,
		/obj/item/storage/cans/sixsoda,
		/obj/item/flashlight/glowstick,
		/obj/item/flashlight/glowstick/red,
		/obj/item/flashlight/glowstick/blue,
		/obj/item/flashlight/glowstick/cyan,
		/obj/item/flashlight/glowstick/orange,
		/obj/item/flashlight/glowstick/yellow,
		/obj/item/flashlight/glowstick/pink
		)
	crate_name = "ящик для вечеринок"

/datum/supply_pack/organic/mothic_rations
	name = "Комплект рационов для молей"
	desc = "Команда голодает? Шеф-повар расслабляется? Обеспечьте всех самым минимальным количеством того, что можно считать едой, с помощью упаковок с излишками рациона, прямо из автопарка Mothic! Упаковка включает в себя 3 упаковки по 3 батончика в каждой."
	cost = BUY_CRATE_VALUE * 3
	contains = list(
		/obj/item/storage/box/mothic_rations,
		/obj/item/storage/box/mothic_rations,
		/obj/item/storage/box/mothic_rations,
		)
	crate_name = "ящик рационов для молей"
	crate_type = /obj/structure/closet/crate/cardboard/mothic

/datum/supply_pack/organic/coffee_cartridge
	name = "Комплект картриджей для кофеварки"
	desc = "Содержит ассорти кофейных картриджей. Каждого хватит на 4 полных кофейника."
	cost = BUY_CRATE_VALUE * 1.5
	contains = list(
		/obj/item/coffee_cartridge,
		/obj/item/coffee_cartridge,
		/obj/item/coffee_cartridge/fancy,
		/obj/item/coffee_cartridge/fancy,
		/obj/item/coffee_cartridge/decaf,
		/obj/item/coffee_cartridge/bootleg
		)

//////////////////////////////////////////////////////////////////////////////
////////////////////////////// Livestock /////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/critter
	group = "Живность"
	crate_type = /obj/structure/closet/crate/critter

/datum/supply_pack/critter/parrot
	name = "Попугай"
	desc = "Содержит пять разбирающихся телекоммуникационных серверах птиц. В этот раз вы точно все настроете правильно."
	cost = BUY_CRATE_VALUE * 3
	access_view = ACCESS_CE
	contains = list(/mob/living/simple_animal/parrot)
	crate_name = "ящик с попугаями"

/datum/supply_pack/critter/parrot/generate()
	. = ..()
	for(var/i in 1 to 4)
		new /mob/living/simple_animal/parrot(.)

/datum/supply_pack/critter/cat
	name = "Кошка"
	desc = "Кошка мяукает! Поставляется с ошейником и милой игрушкой для кошки!"
	cost = BUY_CRATE_VALUE * 3
	access_view = ACCESS_MEDICAL
	contains = list(
		/mob/living/simple_animal/pet/cat,
		/obj/item/clothing/neck/petcollar,
		/obj/item/toy/cattoy
		)
	crate_name = "ящик с кошкой"

/datum/supply_pack/critter/cat/generate()
	. = ..()
	if(prob(50))
		var/mob/living/simple_animal/pet/cat/C = locate() in .
		qdel(C)
		new /mob/living/simple_animal/pet/cat/_proc(.)

/datum/supply_pack/critter/chick
	name = "Ципленок"
	desc = "Курица кукарекает!"
	cost = BUY_CRATE_VALUE * 2
	access_view = ACCESS_KITCHEN
	contains = list(/mob/living/simple_animal/chick)
	crate_name = "ящик с ципленком"

/datum/supply_pack/critter/corgi
	name = "Корги"
	desc = "Тысячи ученых-исследователей считают эту корги оптимальной породой собак, но она всего лишь одна из миллионов представителей благородной родословной Яна. Поставляется с симпатичным ошейником!"
	cost = BUY_CRATE_VALUE * 3
	access_view = ACCESS_HOP
	contains = list(
		/mob/living/simple_animal/pet/dog/corgi,
		/obj/item/clothing/neck/petcollar
		)
	crate_name = "ящик с корги"

/datum/supply_pack/critter/corgi/generate()
	. = ..()
	if(prob(50))
		var/mob/living/simple_animal/pet/dog/corgi/D = locate() in .
		if(D.gender == FEMALE)
			qdel(D)
			new /mob/living/simple_animal/pet/dog/corgi/lisa(.)

/datum/supply_pack/critter/corgis/exotic
	name = "Экзотический корги"
	desc = "Корги, достойные короля, эти корги имеют уникальный окрас, подчеркивающий их превосходство. Поставляется с симпатичным ошейником!"
	cost = BUY_CRATE_VALUE * 5
	contains = list(
		/mob/living/simple_animal/pet/dog/corgi/exoticcorgi,
		/obj/item/clothing/neck/petcollar
		)
	crate_name = "ящик с корги"

/datum/supply_pack/critter/cow
	name = "Корова"
	desc = "У-у-у коровы нет других забот! Ест траву и молоко дает! А для кого она старается? А для меня, для меня, для меня!"
	cost = BUY_CRATE_VALUE * 3
	access_view = ACCESS_HYDROPONICS
	contains = list(/mob/living/simple_animal/cow)
	crate_name = "ящик с коровой"

/datum/supply_pack/critter/crab
	name = "Краб"
	desc = "РАКЕТА КРААААААБ. РАК-КРАБ. РАК-КРАБ. КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ РАКЕТЫ. ремесло. ракета. покупать. КРАФТ-РАКЕТА. РАК-КРАБ. КРАБОВЫЙ РУЛЕТ. КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ КРАБ OOOOOOOOOOOOOOOOOOOOOOOK EEEEEEEEEEEEEEEEEEEEEEEEE EEEETTTTTTTTTTTTAAAAAAAAA AAAHHHHHHHHHHHHH. РАК-КРАБ. КРАААБ РОКЕЕЕЕЕЕЕЕЕГГГГХХХХХТ КРАБ КРАБ РАКЕТА КРАБ РОКЕЕЕЕТ."//fun fact: i actually spent like 10 minutes and transcribed the entire video.
	cost = BUY_CRATE_VALUE * 4
	access_view = ACCESS_HOS
	contains = list(/mob/living/simple_animal/crab)
	crate_name = "look sir free crabs"
	DropPodOnly = TRUE

/datum/supply_pack/critter/crab/generate()
	. = ..()
	for(var/i in 1 to 49)
		new /mob/living/simple_animal/crab(.)

/datum/supply_pack/critter/fox
	name = "Лиса"
	desc = "Лиса лает! Поставляется с милым ошейником!"
	cost = BUY_CRATE_VALUE * 4
	access_view = ACCESS_CAPTAIN
	contains = list(
		/mob/living/simple_animal/pet/fox,
		/obj/item/clothing/neck/petcollar
		)
	crate_name = "ящик с лисой"

/datum/supply_pack/critter/goat
	name = "Козёл"
	desc = "На случай если дикий Пит таки довел повора до мясорубки."
	cost = BUY_CRATE_VALUE * 2
	access_view = ACCESS_KITCHEN
	contains = list(/mob/living/simple_animal/hostile/retaliate/goat)
	crate_name = "ящик с козлом"

/datum/supply_pack/critter/monkey
	name = "Обезьянки в кубиках"
	desc = "Хватит обезьянничать! Содержит семь кубиков с обезьянками. Просто добавьте воды!"
	cost = BUY_CRATE_VALUE * 2
	contains = list (/obj/item/storage/box/monkeycubes)
	crate_type = /obj/structure/closet/crate
	crate_name = "ящик с обезьянками"

/datum/supply_pack/critter/pug
	name = "Мопс"
	desc = "Как обычная собака, но... сдувшаяся. Поставляется с красивым ошейником!"
	cost = BUY_CRATE_VALUE * 2
	contains = list(
		/mob/living/simple_animal/pet/dog/pug,
		/obj/item/clothing/neck/petcollar
		)
	crate_name = "ящик с мопсом"

/datum/supply_pack/critter/bullterrier
	name = "Бультерьер"
	desc = "Как обычная собака, но с головой в форме яйца. Поставляется с красивым ошейником!"
	cost = BUY_CRATE_VALUE * 2
	contains = list(
		/mob/living/simple_animal/pet/dog/bullterrier,
		/obj/item/clothing/neck/petcollar
		)
	crate_name = "ящик с бультерьером"

/datum/supply_pack/critter/dhund
	name = "Такса"
	desc = "Как обычная собака, только длинная. Поставляется с красивым ошейником!"
	cost = BUY_CRATE_VALUE * 2
	contains = list(
		/mob/living/simple_animal/pet/dog/dhund,
		/obj/item/clothing/neck/petcollar
		)
	crate_name = "ящик с таксой"

/datum/supply_pack/critter/shepherd
	name = "Немецкая овчарка"
	desc = "Как обычная собака, только лучше. Поставляется с красивым ошейником!"
	cost = BUY_CRATE_VALUE * 2
	contains = list(
		/mob/living/simple_animal/pet/dog/shepherd,
		/obj/item/clothing/neck/petcollar)
	crate_name = "ящик с овчаркой"

/datum/supply_pack/critter/jack
	name = "Джек рассел терьер"
	desc = "Как обычная собака, только маленькая. Поставляется с красивым ошейником!"
	cost = BUY_CRATE_VALUE * 2
	contains = list(
		/mob/living/simple_animal/pet/dog/jack,
		/obj/item/clothing/neck/petcollar
		)
	crate_name = "ящик с джек рассел терьером"

/datum/supply_pack/critter/chi
	name = "Чихуахуа"
	desc = "Как обычная собака, только бесит. Поставляется с красивым ошейником!"
	cost = BUY_CRATE_VALUE * 2
	contains = list(
		/mob/living/simple_animal/pet/dog/pug/chi,
		/obj/item/clothing/neck/petcollar
		)
	crate_name = "ящик с чихуахуа"

/datum/supply_pack/critter/snake
	name = "Змея"
	desc = "Устали от этих гребаных змей на этой гребаной космической станции? Тогда этот ящик не для тебя. Содержит трех ядовитых змей."
	cost = BUY_CRATE_VALUE * 2
	access_view = ACCESS_SECURITY
	contains = list(
		/mob/living/simple_animal/hostile/retaliate/poison/snake,
		/mob/living/simple_animal/hostile/retaliate/poison/snake,
		/mob/living/simple_animal/hostile/retaliate/poison/snake
		)
	crate_name = "ящик со змеями"

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Costumes & Toys /////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/costumes_toys
	group = "Костюмы и игрушки"

/datum/supply_pack/costumes_toys/randomised
	name = "Комплект коллекционных шляп"
	desc = "Продемонстрируйте свой стиль при помощи этих коллекционных шляп!"
	cost = BUY_CRATE_VALUE * 3
	contains = list(
		/obj/item/clothing/head/collectable/chef,
		/obj/item/clothing/head/collectable/paper,
		/obj/item/clothing/head/collectable/tophat,
		/obj/item/clothing/head/collectable/captain,
		/obj/item/clothing/head/collectable/beret,
		/obj/item/clothing/head/collectable/welding,
		/obj/item/clothing/head/collectable/flatcap,
		/obj/item/clothing/head/collectable/pirate,
		/obj/item/clothing/head/collectable/kitty,
		/obj/item/clothing/head/collectable/rabbitears,
		/obj/item/clothing/head/collectable/wizard,
		/obj/item/clothing/head/collectable/hardhat,
		/obj/item/clothing/head/collectable/hos,
		/obj/item/clothing/head/collectable/hop,
		/obj/item/clothing/head/collectable/thunderdome,
		/obj/item/clothing/head/collectable/swat,
		/obj/item/clothing/head/collectable/slime,
		/obj/item/clothing/head/collectable/police,
		/obj/item/clothing/head/collectable/slime,
		/obj/item/clothing/head/collectable/xenom,
		/obj/item/clothing/head/collectable/petehat
		)
	crate_name = "ящик с шляпами"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/foamforce
	name = "Комплект пенных вооруженных сил"
	desc = "Уходя гасите всех!"
	cost = BUY_CRATE_VALUE * 2
	contains = list(
		/obj/item/gun/ballistic/shotgun/toy,
		/obj/item/gun/ballistic/shotgun/toy,
		/obj/item/gun/ballistic/shotgun/toy,
		/obj/item/gun/ballistic/automatic/pistol/toy,
		/obj/item/gun/ballistic/automatic/pistol/toy,
		/obj/item/gun/ballistic/automatic/pistol/toy,
		/obj/item/gun/ballistic/automatic/toy,
		/obj/item/gun/ballistic/automatic/toy,
		/obj/item/gun/ballistic/automatic/toy,
		/obj/item/gun/ballistic/shotgun/toy/crossbow,
		/obj/item/gun/ballistic/shotgun/toy/crossbow,
		/obj/item/gun/ballistic/shotgun/toy/crossbow,
		/obj/item/gun/ballistic/automatic/c20r/toy/unrestricted,
		/obj/item/gun/ballistic/automatic/c20r/toy/unrestricted,
		/obj/item/gun/ballistic/automatic/c20r/toy/unrestricted,
		/obj/item/gun/ballistic/automatic/l6_saw/toy/unrestricted,
		/obj/item/gun/ballistic/automatic/l6_saw/toy/unrestricted,
		/obj/item/gun/ballistic/automatic/l6_saw/toy/unrestricted,
		)
	crate_name = "ящик с игрушечным оружием"

/datum/supply_pack/costumes_toys/formalwear
	name = "Комплект высокой моды"
	desc = "Тебе понравится, как ты выглядишь, я это гарантирую. Содержит коллекцию модной одежды."
	cost = BUY_CRATE_VALUE * 4 //Lots of very expensive items. You gotta pay up to look good!
	contains = list(
		/obj/item/clothing/under/dress/blacktango,
		/obj/item/clothing/under/misc/assistantformal,
		/obj/item/clothing/under/misc/assistantformal,
		/obj/item/clothing/under/rank/civilian/lawyer/bluesuit,
		/obj/item/clothing/suit/toggle/lawyer,
		/obj/item/clothing/under/rank/civilian/lawyer/purpsuit,
		/obj/item/clothing/suit/toggle/lawyer/purple,
		/obj/item/clothing/suit/toggle/lawyer/black,
		/obj/item/clothing/accessory/waistcoat,
		/obj/item/clothing/neck/tie/blue,
		/obj/item/clothing/neck/tie/red,
		/obj/item/clothing/neck/tie/black,
		/obj/item/clothing/head/bowler,
		/obj/item/clothing/head/fedora,
		/obj/item/clothing/head/flatcap,
		/obj/item/clothing/head/beret,
		/obj/item/clothing/head/that,
		/obj/item/clothing/shoes/laceup,
		/obj/item/clothing/shoes/laceup,
		/obj/item/clothing/shoes/laceup,
		/obj/item/clothing/under/suit/charcoal,
		/obj/item/clothing/under/suit/navy,
		/obj/item/clothing/under/suit/burgundy,
		/obj/item/clothing/under/suit/checkered,
		/obj/item/clothing/under/suit/tan,
		/obj/item/lipstick/random
		)
	crate_name = "ящик с одеждой"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/lasertag
	name = "Комплект для лазертага"
	desc = "Пенчики это для мальчиков. Лазертаг предназначен для мужчин. Содержит три комплекта красных костюмов, синих костюмов, соответствующих шлемов и соответствующих лазертаг-пистолетов."
	cost = BUY_CRATE_VALUE * 2
	contains = list(
		/obj/item/gun/energy/laser/redtag,
		/obj/item/gun/energy/laser/redtag,
		/obj/item/gun/energy/laser/redtag,
		/obj/item/gun/energy/laser/bluetag,
		/obj/item/gun/energy/laser/bluetag,
		/obj/item/gun/energy/laser/bluetag,
		/obj/item/clothing/suit/redtag,
		/obj/item/clothing/suit/redtag,
		/obj/item/clothing/suit/redtag,
		/obj/item/clothing/suit/bluetag,
		/obj/item/clothing/suit/bluetag,
		/obj/item/clothing/suit/bluetag,
		/obj/item/clothing/head/helmet/redtaghelm,
		/obj/item/clothing/head/helmet/redtaghelm,
		/obj/item/clothing/head/helmet/redtaghelm,
		/obj/item/clothing/head/helmet/bluetaghelm,
		/obj/item/clothing/head/helmet/bluetaghelm,
		/obj/item/clothing/head/helmet/bluetaghelm
		)
	crate_name = "ящик лазертага"

/datum/supply_pack/costumes_toys/costume_original
	name = "Комплект оригинальных костюмов"
	desc = "Воссоздайте шекспировские пьесы с помощью этого ассортимента нарядов. Содержит восемь различных костюмов!"
	cost = BUY_CRATE_VALUE * 2
	contains = list(
		/obj/item/clothing/head/snowman,
		/obj/item/clothing/suit/snowman,
		/obj/item/clothing/head/chicken,
		/obj/item/clothing/suit/chickensuit,
		/obj/item/clothing/mask/gas/monkeymask,
		/obj/item/clothing/suit/monkeysuit,
		/obj/item/clothing/head/cardborg,
		/obj/item/clothing/suit/cardborg,
		/obj/item/clothing/head/xenos,
		/obj/item/clothing/suit/xenos,
		/obj/item/clothing/suit/hooded/ian_costume,
		/obj/item/clothing/suit/hooded/carp_costume,
		/obj/item/clothing/suit/hooded/bee_costume
		)
	crate_name = "ящик с костюмами"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/costume
	name = "Комплект одежды Мима и Клоуна"
	desc = "Клоун раздел мима и скормил его одежду медсестричке-моли за которой тот ухлестывал? Не Беда! Данный комплект содержит полный костюм клоуна и мима, а также велосипедный гудок и бутылку ничего."
	cost = BUY_CRATE_VALUE * 2
	access = ACCESS_THEATRE
	contains = list(
		/obj/item/storage/backpack/clown,
		/obj/item/clothing/shoes/clown_shoes,
		/obj/item/clothing/mask/gas/clown_hat,
		/obj/item/clothing/under/rank/civilian/clown,
		/obj/item/bikehorn,
		/obj/item/clothing/under/rank/civilian/mime,
		/obj/item/clothing/shoes/sneakers/black,
		/obj/item/clothing/gloves/color/white,
		/obj/item/clothing/mask/gas/mime,
		/obj/item/clothing/head/frenchberet,
		/obj/item/clothing/suit/toggle/suspenders,
		/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing,
		/obj/item/storage/backpack/mime
		)
	crate_name = "ящик с одеждой мима и клоуна"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/lube
	name = "Комплект скользких гранат"
	desc = "Гранаты созданные лучшими учеными Хонк Ко в качестве протеста против военных преступлений компании Космочист."
	cost = BUY_CRATE_VALUE * 3
	access = ACCESS_THEATRE
	contains = list(/obj/item/storage/box/lube)
	crate_name = "ящик скользких гранат"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/costumes_toys/randomised/toys
	name = "Комплект игрушек"
	desc = "Кого волнуют гордость и достижения? Пропустите игры и сразу переходите к сладким наградам с этим продуктом! Содержит пять случайных игрушек. Гарантия аннулируется, если используется для розыгрыша руководителей исследований."
	cost = BUY_CRATE_VALUE * 3
	var/num_contained = 5
	contains = list()
	crate_name = "ящик с игрушками"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/randomised/toys/fill(obj/structure/closet/crate/C)
	var/the_toy
	for(var/i in 1 to num_contained)
		if(prob(50))
			the_toy = pick_weight(GLOB.arcade_prize_pool)
		else
			the_toy = pick(subtypesof(/obj/item/toy/plush))
		new the_toy(C)

/datum/supply_pack/costumes_toys/wizard
	name = "Комплект одежды мага"
	desc = "Притворись, что вступаешь в Федерацию волшебников в этом полном костюме волшебника! НаноТрейзен хотела бы напомнить своим сотрудникам, что фактическое вступление в Федерацию волшебников влечет за собой увольнение с работы и пожизненное заключение."
	cost = BUY_CRATE_VALUE * 3
	contains = list(
		/obj/item/staff,
		/obj/item/clothing/suit/wizrobe/fake,
		/obj/item/clothing/shoes/sandal,
		/obj/item/clothing/head/wizard/fake,
		/obj/item/clothing/head/wizard/marisa/fake,
		/obj/item/clothing/suit/wizrobe/marisa/fake,
		)
	crate_name = "ящик с одеждой мага"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/randomised/tcg
	name = "Комплект Бустеров Жопонадирателей"
	desc = "Огромная партия бустерных комплектов NT TCG различных серий. Собери их все!"
	cost = BUY_CRATE_VALUE * 10
	contains = list()
	crate_name = "ящик с бустерами"

/datum/supply_pack/costumes_toys/randomised/tcg/fill(obj/structure/closet/crate/C)
	var/cardpacktype
	for(var/i in 1 to 10)
		cardpacktype = pick(subtypesof(/obj/item/cardpack))
		new cardpacktype(C)

/datum/supply_pack/costumes_toys/stickers
	name = "Комплект стикеров"
	desc = "Полный ящик стикеров."
	cost = CARGO_CRATE_VALUE * 3
	contains = list()

/datum/supply_pack/costumes_toys/stickers/fill(obj/structure/closet/crate/crate)
	for(var/i in 1 to rand(1,2))
		new /obj/item/storage/box/stickers(crate)
	if(prob(30)) // a pair of googly eyes because funny
		new /obj/item/storage/box/stickers/googly(crate)

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Miscellaneous ///////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/misc
	group = "Прочее"

/datum/supply_pack/misc/potted_plants
	name = "Комплект растений в горшках"
	desc = "Украсьте станцию этими прекрасными растениями! Содержит случайный набор из пяти растений в горшках из исследовательского подразделения НаноТрейзен по выращиванию растений в горшках. Гарантия аннулируется, если ее выбросить."
	cost = BUY_CRATE_VALUE * 1.5
	contains = list(
		/obj/item/kirbyplants/random,
		/obj/item/kirbyplants/random,
		/obj/item/kirbyplants/random,
		/obj/item/kirbyplants/random,
		/obj/item/kirbyplants/random
		)
	crate_name = "ящик с растениями в горшках"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/misc/aquarium_kit
	name = "Комплект с аквариумом"
	desc = "Все, что вам нужно для создания собственного аквариума. Содержит набор для строительства аквариума, каталог рыб, банку с кормом и трех пресноводных рыбок из нашей коллекции."
	cost = BUY_CRATE_VALUE * 4
	contains = list(
		/obj/item/book/fish_catalog,
		/obj/item/storage/fish_case/random/freshwater,
		/obj/item/storage/fish_case/random/freshwater,
		/obj/item/storage/fish_case/random/freshwater,
		/obj/item/fish_feed,
		/obj/item/storage/box/aquarium_props,
		/obj/item/aquarium_kit
		)
	crate_name = "ящик с аквариумом"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/misc/aquarium_fish
	name = "Комплект аквариумных рыбок"
	desc = "Набор из трех случайных рыбок."
	cost = BUY_CRATE_VALUE * 2
	contains = list(
		/obj/item/storage/fish_case/random,
		/obj/item/storage/fish_case/random,
		/obj/item/storage/fish_case/random,
		)
	crate_name = "ящик с аквариумными рыбками"

/datum/supply_pack/misc/artsupply
	name = "Комплект художественных принадлежностей"
	desc = "Устройте несколько маленьких счастливых случайностей с помощью средства ниток для плетения, баллончиков с краской и большого количества цветных карандашей!"
	cost = BUY_CRATE_VALUE * 1.8
	contains = list(
		/obj/item/rcl,
		/obj/item/storage/toolbox/artistic,
		/obj/item/toy/crayon/spraycan,
		/obj/item/toy/crayon/spraycan,
		/obj/item/toy/crayon/spraycan,
		/obj/item/storage/crayons,
		/obj/item/toy/crayon/white,
		/obj/item/toy/crayon/rainbow,
		/obj/item/canvas/nineteen_nineteen,
		/obj/item/canvas/nineteen_nineteen,
		/obj/item/canvas/twentythree_nineteen,
		/obj/item/canvas/twentythree_nineteen,
		/obj/item/canvas/twentythree_twentythree,
		/obj/item/canvas/twentythree_twentythree,
		/obj/item/canvas/twentyfour_twentyfour
		)
	crate_name = "ящик для рисования"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/misc/bicycle
	name = "Комплект с велосипедом"
	desc = "НаноТрейзен напоминает всем сотрудникам, чтобы они никогда не играли с силами, находящимися вне их контроля."
	cost = BUY_CRATE_VALUE * 2
	contains = list(/obj/vehicle/ridden/bicycle)
	crate_name = "ящик с велосипедом"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/misc/driftcar
	name = "Комплект дрифткара"
	desc = "Содержит целую машину."
	cost = BUY_CRATE_VALUE * 10
	contains = list(/obj/vehicle/sealed/car/driftcar)
	crate_name = "блюспейс ящик"
	crate_type = /obj/structure/closet/crate

/datum/supply_pack/misc/bigband
	name = "Комплект оркестровых инструментов"
	desc = "Заставьте эту печальную станцию двигаться и сливаться с музыкой при помощи этой прекрасной коллекции! Содержит девять различных инструментов!"
	cost = BUY_CRATE_VALUE * 2
	crate_name = "ящик с музыкальными инструментами"
	contains = list(
		/obj/item/instrument/violin,
		/obj/item/instrument/guitar,
		/obj/item/instrument/glockenspiel,
		/obj/item/instrument/accordion,
		/obj/item/instrument/saxophone,
		/obj/item/instrument/trombone,
		/obj/item/instrument/recorder,
		/obj/item/instrument/harmonica,
		/obj/structure/musician/piano/unanchored
		)
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/misc/book_crate
	name = "Комплект книг"
	desc = "Эти семь книг, выбранных случайным образом из библиотеки НаноТрейзен, несомненно, будут полезны для чтения."
	cost = BUY_CRATE_VALUE * 1.1
	access_view = ACCESS_LIBRARY
	contains = list(
		/obj/item/book/codex_gigas,
		/obj/item/book/manual/random/,
		/obj/item/book/manual/random/,
		/obj/item/book/manual/random/,
		/obj/item/book/random,
		/obj/item/book/random,
		/obj/item/book/random
		)
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/misc/paper
	name = "Комплект бюрократических принадлежностей"
	desc = "Высокие стопки бумаг на вашем столе - большая проблема - сделайте их размером с горошину с помощью этих бюрократических принадлежностей! Содержит шесть ручек, немного фотопленки, принадлежности для ручной наклеивания этикеток, контейнер для бумаги, копировальную бумагу, три папки, лазерную указку, два планшета для обмена и две марки."//that was too forced
	cost = BUY_CRATE_VALUE
	contains = list(
		/obj/structure/filingcabinet/chestdrawer/wheeled,
		/obj/item/camera_film,
		/obj/item/hand_labeler,
		/obj/item/hand_labeler_refill,
		/obj/item/hand_labeler_refill,
		/obj/item/paper_bin,
		/obj/item/paper_bin/carbon,
		/obj/item/pen/fourcolor,
		/obj/item/pen/fourcolor,
		/obj/item/pen,
		/obj/item/pen/fountain,
		/obj/item/pen/blue,
		/obj/item/pen/red,
		/obj/item/storage/box/fountainpens,
		/obj/item/folder/blue,
		/obj/item/folder/red,
		/obj/item/folder/yellow,
		/obj/item/clipboard,
		/obj/item/clipboard,
		/obj/item/stamp,
		/obj/item/stamp/denied,
		/obj/item/laser_pointer/purple
		)
	crate_name = "ящик бюрократии"

/datum/supply_pack/misc/toner
	name = "Комплект картриджей для принтера"
	desc = "Потратили слишком много чернил на печать ксерокопий попок кошкодевочек? Не волнуйтесь, с этими шестью заправками тонера вы будете печатать материал для ручной работы, пока не отвалится!"
	cost = BUY_CRATE_VALUE * 1.1
	contains = list(
		/obj/item/toner,
		/obj/item/toner,
		/obj/item/toner,
		/obj/item/toner/large,
		/obj/item/toner/large,
		/obj/item/toner/large,
		/obj/item/toner/extreme
		)
	crate_name = "ящик чернил"

/datum/supply_pack/misc/training_toolbox
	name = "Комплект тренировочных ящиков для инструментов"
	desc = "Hпродемонстрируйте свои боевые способности с помощью двух наборов тренировочных ящиков для инструментов марки РОБАСТФЕСТ! Гарантированно подсчитываются попадания, нанесенные по живым существам!"
	cost = BUY_CRATE_VALUE * 2
	contains = list(
		/obj/item/training_toolbox,
		/obj/item/training_toolbox,
		/obj/structure/training_machine,
		/obj/item/target
		)
	crate_name = "ящик для тренировки"

///Special supply crate that generates random syndicate gear up to a determined TC value
/datum/supply_pack/misc/syndicate
	name = "Комплект экипировки синдиката"
	desc = "Содержит случайное барахло, что завалялось на складе."
	special = TRUE ///Cannot be ordered via cargo
	contains = list()
	crate_name = "ящик синдиката"
	crate_type = /obj/structure/closet/crate
	var/crate_value = 30 ///Total TC worth of contained uplink items

///Generate assorted uplink items, taking into account the same surplus modifiers used for surplus crates
/datum/supply_pack/misc/syndicate/fill(obj/structure/closet/crate/C)
	var/list/uplink_items = get_uplink_items(UPLINK_TRAITORS)
	while(crate_value)
		var/category = pick(uplink_items)
		var/item = pick(uplink_items[category])
		var/datum/uplink_item/I = uplink_items[category][item]
		if(!I.surplus || prob(100 - I.surplus))
			continue
		if(crate_value < I.cost)
			continue
		crate_value -= I.cost
		new I.item(C)

/datum/supply_pack/misc/fishing_portal
	name = "Комплект рыбака"
	desc = "Позволяет ловить рыбу в любое время, в любом месте."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(
		/obj/machinery/fishing_portal_generator,
		/obj/item/fishing_rod
		)
	crate_name = "ящик рыбака"

//////////////////////////////////////////////////////////////////////////////
/////////////////////// General Vending Restocks /////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/vending
	group = "Картриджи торгматов"

/datum/supply_pack/vending/bartending
	name = "Бухло-мат и Кофейник"
	desc = "Принесите заправку для автомата по продаже выпивки и кофе."
	cost = BUY_CRATE_VALUE * 1.2
	contains = list(/obj/item/vending_refill/boozeomat,
					/obj/item/vending_refill/coffee)
	crate_name = "ящик с картриджами торгматов"

/datum/supply_pack/vending/cigarette
	name = "Смог"
	desc = "Не верьте сообщениям - курите сегодня! Содержит заправку для автомата по продаже сигарет."
	cost = BUY_CRATE_VALUE * 1.1
	contains = list(/obj/item/vending_refill/cigarette)
	crate_type = /obj/structure/closet/crate
	crate_name = "ящик с картриджами торгматов"

/datum/supply_pack/vending/dinnerware
	name = "Цельнометаллическая поварешка"
	desc = "Еще ножи для шеф-повара."
	cost = BUY_CRATE_VALUE * 1.1
	contains = list(/obj/item/vending_refill/dinnerware)
	crate_name = "ящик с картриджами торгматов"

/datum/supply_pack/vending/science/modularpc
	name = "Командор-64 и Мех-Комп"
	desc = "Что такое компьютер? Содержит блок для пополнения запасов кремниевого сырья класса люкс."
	cost = BUY_CRATE_VALUE * 1.2
	contains = list(
		/obj/item/vending_refill/modularpc,
		/obj/item/vending_refill/mechcomp)
	crate_name = "ящик с картриджами торгматов"

/datum/supply_pack/vending/vendomat
	name = "Амперка"
	desc = "Дополнительные инструменты для вашего центра тестирования самодельных взрывных устройств."
	cost = BUY_CRATE_VALUE * 1.4
	contains = list(/obj/item/vending_refill/assist)
	crate_name = "ящик с картриджами торгматов"

/datum/supply_pack/vending/engivend
	name = "Уголок старателя и Твой инструмент"
	desc = "У инженеров закончились гранаты из металлической пены? Это должно помочь."
	cost = BUY_CRATE_VALUE * 1.3
	contains = list(
		/obj/item/vending_refill/engivend,
		/obj/item/vending_refill/tool
		)
	crate_name = "ящик с картриджами торгматов"

/datum/supply_pack/vending/games
	name = "SpacePunk 3077"
	desc = "Get your game on with this game vending machine refill."
	cost = BUY_CRATE_VALUE * 1.2
	contains = list(/obj/item/vending_refill/games)
	crate_type = /obj/structure/closet/crate
	crate_name = "ящик с картриджами торгматов"

/datum/supply_pack/vending/hydro_refills
	name = "Счастливая ферма, Дом и Сад"
	desc = "Когда клоун съест все банановые семечки. Содержит картриджи для ботаники."
	cost = BUY_CRATE_VALUE * 1.5
	crate_type = /obj/structure/closet/crate
	contains = list(
		/obj/item/vending_refill/hydroseeds,
		/obj/item/vending_refill/hydronutrients
		)
	crate_name = "ящик с картриджами торгматов"

/datum/supply_pack/vending/sustenance
	name = "Баланда по домашнему"
	desc = "Зэки тоже хотят кушать."
	cost = BUY_CRATE_VALUE
	contains = list(/obj/item/vending_refill/sustenance)
	crate_name = "ящик с картриджами торгматов"

/datum/supply_pack/vending/medical
	name = "Медицинские торговые автоматы"
	desc = "Содержит картриджи НаноМеда, НаноМед Плюс, НаноХим Плюс и Четверочка(мед)"
	cost = BUY_CRATE_VALUE * 3
	contains = list(
		/obj/item/vending_refill/medical,
		/obj/item/vending_refill/drugs,
		/obj/machinery/vending/chetverochka/pharma,
		/obj/item/vending_refill/wallmed
		)
	crate_name = "ящик с картриджами торгматов"

/datum/supply_pack/vending/ptech
	name = "Я-Мысль"
	desc = "Не хватает картриджей после того, как половина экипажа потеряла свои КПК из-за взрывов? Это может все исправить."
	cost = BUY_CRATE_VALUE
	contains = list(/obj/item/vending_refill/cart)
	crate_name = "ящик с картриджами торгматов"

/datum/supply_pack/vending/sectech
	name = "Закон и порядок"
	desc = "Офицер Пол купил все пончики? Просто закажите новые!"
	cost = BUY_CRATE_VALUE * 2
	access = ACCESS_SECURITY
	contains = list(/obj/item/vending_refill/security)
	crate_type = /obj/structure/closet/crate/secure/gear
	crate_name = "ящик с картриджами торгматов"

/datum/supply_pack/vending/snack
	name = "Три корочки и Четверочка"
	desc = "Картриджи для закусок! Рекомендованный стоматологом заказ номер один!"
	cost = BUY_CRATE_VALUE * 1.2
	contains = list(/obj/item/vending_refill/snack,
					/obj/item/vending_refill/chetverochka)
	crate_name = "ящик с картриджами торгматов"

/datum/supply_pack/vending/cola
	name = "Прилив Робаста"
	desc = "Тебя ударили ящиком с инструментами, но у тебя все еще есть эти надоедливые зубы? Избавьтесь от этих жемчужно-белых пятен с помощью газировки уже сегодня!"
	cost = BUY_CRATE_VALUE * 1.1
	contains = list(/obj/item/vending_refill/cola)
	crate_name = "ящик с картриджами торгматов"

/datum/supply_pack/vending/imported
	name = "Импортные торговые автоматы"
	desc = "Картриджи поставляемые с отдаленных уголков космоса."
	cost = BUY_CRATE_VALUE * 3
	contains = list(
		/obj/item/vending_refill/robotics,
		/obj/item/vending_refill/sovietsoda,
		/obj/item/vending_refill/engineering
		)
	crate_name = "ящик с картриджами торгматов"

//////////////////////////////////////////////////////////////////////////////
/////////////////////// Clothing Vending Restocks ////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/vending/wardrobes/autodrobe
	name = "ЛяМода и Дэнди"
	desc = "Соскучилась по своему любимому платью? Решите эту проблему сегодня с помощью этой автоматической заправки."
	cost = BUY_CRATE_VALUE * 1.5
	contains = list(
		/obj/item/vending_refill/autodrobe,
		/obj/machinery/vending/clothing)
	crate_name = "ящик с картриджами торгматов"

/datum/supply_pack/vending/wardrobes/cargo
	name = "Перевозчик"
	desc = "Хранит в себе любимые кепки грузчиков."
	cost = BUY_CRATE_VALUE * 1.1
	contains = list(/obj/item/vending_refill/wardrobe/cargo_wardrobe)
	crate_name = "ящик с картриджами торгматов"

/datum/supply_pack/vending/wardrobes/engineering
	name = "Работяга и Зефир"
	desc = "Содержит одежду для инженеров."
	cost = BUY_CRATE_VALUE * 1.1
	contains = list(/obj/item/vending_refill/wardrobe/engi_wardrobe,
					/obj/item/vending_refill/wardrobe/atmos_wardrobe,)
	crate_name = "ящик с картриджами торгматов"

/datum/supply_pack/vending/wardrobes/general
	name = "Сервисные одежные торгматы"
	desc = "Содержит одежду для Библиотекаря, Бармена, Повара, Уборщика, Священника и Ботаника."
	cost = BUY_CRATE_VALUE * 1.4
	contains = list(/obj/item/vending_refill/wardrobe/curator_wardrobe,
					/obj/item/vending_refill/wardrobe/bar_wardrobe,
					/obj/item/vending_refill/wardrobe/chef_wardrobe,
					/obj/item/vending_refill/wardrobe/jani_wardrobe,
					/obj/item/vending_refill/wardrobe/chap_wardrobe,
					/obj/item/vending_refill/wardrobe/hydro_wardrobe)
	crate_name = "ящик с картриджами торгматов"

/datum/supply_pack/vending/wardrobes/medical
	name = "Медицинские одежные торгматы"
	desc = "Содержит одежду для Врачей, Парамедиков, Химиков и Вирусолога."
	cost = BUY_CRATE_VALUE * 1.2
	contains = list(/obj/item/vending_refill/wardrobe/medi_wardrobe,
					/obj/item/vending_refill/wardrobe/chem_wardrobe,
					/obj/item/vending_refill/wardrobe/viro_wardrobe)
	crate_name = "ящик с картриджами торгматов"

/datum/supply_pack/vending/wardrobes/science
	name = "Научные одежные торгматы"
	desc = "Содержит одежду для Ученых, Генетиков и Робототехников."
	cost = BUY_CRATE_VALUE * 1.4
	contains = list(/obj/item/vending_refill/wardrobe/robo_wardrobe,
					/obj/item/vending_refill/wardrobe/gene_wardrobe,
					/obj/item/vending_refill/wardrobe/science_wardrobe)
	crate_name = "ящик с картриджами торгматов"

/datum/supply_pack/vending/wardrobes/security
	name = "Охранные одежные торгматы"
	desc = "Содержит одежду Офицера, Адвоката и Детектива."
	cost = BUY_CRATE_VALUE * 2
	contains = list(/obj/item/vending_refill/wardrobe/sec_wardrobe,
					/obj/item/vending_refill/wardrobe/law_wardrobe,
					/obj/machinery/vending/wardrobe/det_wardrobe)
	crate_name = "ящик с картриджами торгматов"

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Контрабанда /////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
/*
/datum/supply_pack/contraband
	group = "Контрабанда"
	contraband = TRUE
*/

/datum/supply_pack/contraband/vehicle
	name = "Комплект квадроцикла"
	desc = "Вездеход, созданный для быстрого перемещения по пересеченной местности."
	cost = BUY_CRATE_VALUE * 4
	contains = list(
		/obj/vehicle/ridden/atv,
		/obj/item/key/atv,
		/obj/item/clothing/suit/jacket/leather/overcoat,
		/obj/item/clothing/gloves/color/black,
		/obj/item/clothing/head/soft,
		/obj/item/clothing/mask/bandana/skull/black
		)
	crate_name = "ящик с квадроциклом"
	crate_type = /obj/structure/closet/crate/large
	group = "Контрабанда"
	contraband = TRUE

/datum/supply_pack/contraband/justiceinbound
	name = "Комплект снаряжения миротворца справедливости"
	desc = "Это оно. Квинтесенция моды. Апогей насилия. Страх и трепет. Лучшие из лучших из лучших. Жемчужина в короне НаноТрейзен. Альфа и омега всех защитных головных уборов. Гарантированно вселит страх в сердца каждого преступника на борту станции. Также поставляется с защитным противогазом."
	cost = BUY_CRATE_VALUE * 6 //justice comes at a price. An expensive, noisy price.
	access = ACCESS_SECURITY
	contains = list(
		/obj/item/clothing/head/helmet/justice,
		/obj/item/clothing/mask/gas/sechailer,
		/obj/item/megaphone,
		/obj/item/clothing/under/rank/security/officer/beatcop,
		/obj/item/clothing/suit/armor/vest/justice
		)
	crate_name = "security clothing crate"
	group = "Контрабанда"
	contraband = TRUE

/datum/supply_pack/contraband/constable
	name = "Комплект винтажного снаряжения СБ"
	desc = "Spare equipment found in a warehouse."
	cost = BUY_CRATE_VALUE * 2.2
	access = ACCESS_SECURITY
	contains = list(
		/obj/item/clothing/under/rank/security/constable,
		/obj/item/clothing/head/helmet/constable,
		/obj/item/clothing/gloves/color/white,
		/obj/item/clothing/mask/whistle,
		/obj/item/conversion_kit)
	crate_name = "ящик снаряжения СБ"
	group = "Контрабанда"
	contraband = TRUE

/datum/supply_pack/contraband/russian
	name = "Комплект бойца красной армии"
	desc = "Здравствуйте, товарищ, у нас есть самая современная российская военная техника, которую только может предложить черный рынок, разумеется, по разумной цене. К сожалению, мы не смогли снять замок, поэтому для его открытия требуется доступ в оружейную."
	cost = BUY_CRATE_VALUE * 6
	access = ACCESS_ARMORY
	contains = list(
		/obj/item/food/rationpack,
		/obj/item/ammo_box/a762,
		/obj/item/ammo_box/a762,
		/obj/item/ammo_box/a762,
		/obj/item/ammo_box/a762,
		/obj/item/storage/toolbox/ammo,
		/obj/item/clothing/suit/armor/vest/russian,
		/obj/item/clothing/head/helmet/rus_helmet,
		/obj/item/clothing/shoes/russian,
		/obj/item/clothing/gloves/tackler/combat,
		/obj/item/clothing/under/syndicate/rus_army,
		/obj/item/clothing/under/costume/soviet,
		/obj/item/clothing/mask/russian_balaclava,
		/obj/item/clothing/head/helmet/rus_ushanka,
		/obj/item/clothing/suit/armor/vest/russian_coat,
		/obj/item/gun/ballistic/rifle/boltaction)
	crate_name = "ящик снаряжения РККА"
	group = "Контрабанда"
	contraband = TRUE

/datum/supply_pack/contraband/armory/russian/fill(obj/structure/closet/crate/C)
	for(var/i in 1 to 10)
		var/item = pick(contains)
		new item(C)

/datum/supply_pack/contraband/cream_piee
	name = "Комплект метательных пирогов высочайшего качества"
	desc = "Разработанные подразделением передовых военных исследований ХонкКо, эти высококачественные пироги без ГМО основаны на синергии производительности и результативности. Гарантированно обеспечивает максимальные результаты."
	cost = BUY_CRATE_VALUE * 8
	contains = list(/obj/item/storage/backpack/duffelbag/clown/cream_pie)
	crate_name = "ящик с пирогами"
	access = ACCESS_THEATRE
	access_view = ACCESS_THEATRE
	crate_type = /obj/structure/closet/crate/secure
	group = "Контрабанда"
	contraband = TRUE

/datum/supply_pack/contraband/butterfly
	name = "Комплект бабочек"
	desc = "Не самые угрожающие существа, однако способные успокоить мятежный разум."
	cost = BUY_CRATE_VALUE * 3
	access_view = ACCESS_THEATRE
	contains = list(/mob/living/simple_animal/butterfly)
	crate_name = "ящик с бабочками"
	group = "Контрабанда"
	contraband = TRUE

/datum/supply_pack/contraband/butterfly/generate()
	. = ..()
	for(var/i in 1 to 49)
		new /mob/living/simple_animal/butterfly(.)

/datum/supply_pack/contraband/hyperpsy
	name = "Комплект полураспада-228"
	desc = "Сильнодействующий наркотик вызывающий раздвоение личности."
	cost = BUY_CRATE_VALUE * 6
	contains = list(/obj/item/reagent_containers/pill/hyperpsy)
	crate_name = "ящик с наркотиками"
	group = "Контрабанда"
	contraband = TRUE

/datum/supply_pack/contraband/randomised
	name = "Комплект контрабанды"
	desc = "Пссс... приятель... хочешь немного контрабанды? Я могу достать тебе плакат, несколько хороших сигарет, данк, даже кое-какие спонсорские товары...ты знаешь, хорошие вещи. Просто держи это подальше от копов, ладно?"
	cost = BUY_CRATE_VALUE * 3
	var/num_contained = 7
	contains = list(
		/obj/item/poster/random_contraband,
		/obj/item/poster/random_contraband,
		/obj/item/food/grown/cannabis,
		/obj/item/food/grown/cannabis/rainbow,
		/obj/item/food/grown/cannabis/white,
		/obj/item/storage/box/fireworks/dangerous,
		/obj/item/storage/pill_bottle/zoom,
		/obj/item/storage/pill_bottle/happy,
		/obj/item/storage/pill_bottle/lsd,
		/obj/item/storage/pill_bottle/aranesp,
		/obj/item/storage/pill_bottle/stimulant,
		/obj/item/toy/cards/deck/syndicate,
		/obj/item/reagent_containers/food/drinks/bottle/absinthe,
		/obj/item/clothing/under/syndicate/tacticool,
		/obj/item/storage/fancy/cigarettes/cigpack_syndicate,
		/obj/item/storage/fancy/cigarettes/cigpack_shadyjims,
		/obj/item/clothing/mask/gas/syndicate,
		/obj/item/clothing/neck/necklace/dope,
		/obj/item/vending_refill/donksoft)
	crate_name = "ящик"
	group = "Контрабанда"
	contraband = TRUE

/datum/supply_pack/contraband/randomised/fill(obj/structure/closet/crate/C)
	var/list/L = contains.Copy()
	for(var/i in 1 to num_contained)
		var/item = pick_n_take(L)
		new item(C)

/datum/supply_pack/contraband/foamforce
	name = "Комплект усиленных игрушечных пистолетов"
	desc = "Псс.. эй, приятель... помнишь те старые игрушечные пистолеты, которые сняли с производства из-за того, что они были слишком крутыми? Что ж, у меня есть два таких прямо здесь, с твоим именем на них. Я даже добавлю по запасному магазину для каждого, что скажешь?"
	cost = BUY_CRATE_VALUE * 8
	contains = list(/obj/item/gun/ballistic/automatic/pistol/toy,
					/obj/item/gun/ballistic/automatic/pistol/toy,
					/obj/item/ammo_box/magazine/toy/pistol,
					/obj/item/ammo_box/magazine/toy/pistol)
	crate_name = "ящик с игрушечными пистолетами"
	group = "Контрабанда"
	contraband = TRUE

/datum/supply_pack/contraband/clownpin
	name = "Комплект веселых бойков"
	desc = "Я... э-э..... Я не совсем понимаю, что это делает. Хочешь это купить?"
	cost = BUY_CRATE_VALUE * 10
	contains = list(/obj/item/firing_pin/clown)
	crate_name = "ящик с игрушками"
	crate_type = /obj/structure/closet/crate/wooden
	group = "Контрабанда"
	contraband = TRUE

/datum/supply_pack/contraband/pins
	name = "Комплект бойков для лазертага"
	desc = "Три бойка для лазертага."
	cost = BUY_CRATE_VALUE * 3.5
	contains = list(/obj/item/storage/box/lasertagpins)
	crate_name = "ящик лазертага"
	group = "Контрабанда"
	contraband = TRUE

/datum/supply_pack/contraband/mafia
	name = "Комплект рэкетера \"Коза Ностры\""
	desc = "В этом ящике содержится все, что вам нужно для организации вашей собственной операции по рэкету, основанной на этнической принадлежности."
	cost = BUY_CRATE_VALUE * 4
	contains = list()
	crate_name = "ящик"
	group = "Контрабанда"
	contraband = TRUE

/datum/supply_pack/contraband/mafia/fill(obj/structure/closet/crate/C)
	for(var/i in 1 to 4)
		new /obj/effect/spawner/lootdrop/mafia_outfit(C)
		new /obj/item/virgin_mary(C)
		if(prob(30)) //Not all mafioso have mustaches, some people also find this item annoying.
			new /obj/item/clothing/mask/fakemoustache/italian(C)
	if(prob(10)) //A little extra sugar every now and then to shake things up.
		new	/obj/item/switchblade(C)

/datum/supply_pack/contraband/blackmarket_telepad
	name = "Комплект модуля черного рынка"
	desc = "Нужен более быстрый и качественный способ транспортировки ваших нелегальных товаров со станции и обратно? Не бойтесь, блюспейс приемопередатчик дальнего и ближнего действия (сокращенно БППДБД) здесь, чтобы помочь. Содержит схему БППДБД, два блюспейс кристалла и один ансибль."
	cost = BUY_CRATE_VALUE * 20
	contains = list(
		/obj/item/circuitboard/machine/ltsrbt,
		/obj/item/stack/ore/bluespace_crystal/artificial,
		/obj/item/stack/ore/bluespace_crystal/artificial,
		/obj/item/stock_parts/subspace/ansible
	)
	crate_name = "ящик"
	group = "Контрабанда"
	contraband = TRUE

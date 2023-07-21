
/datum/supply_pack/goody
	access = NONE
	group = "Мелочёвка"
	goody = TRUE

/datum/supply_pack/goody/mod_core
	name = "Ядро МОД-Скафа"
	desc = "Содержит одно ядро для модульного скафандра. Путем хитрых финансовых манипуляций и отказа от дорогого ящика получилось немного сбросить цену."
	cost = PAYCHECK_HARD * 3
	contains = list(/obj/item/mod/core/standard)

/datum/supply_pack/goody/combatknives_single
	name = "Боевой нож"
	desc = "Армейский нож для выживания."
	cost = PAYCHECK_HARD
	contains = list(/obj/item/kitchen/knife/combat)

/datum/supply_pack/goody/ballistic_single
	name = "Помповый дробовик"
	desc = "Старое-доброе ружье всегда будет серьезным аргументом при спорах за территорию."
	cost = PAYCHECK_HARD * 12
	access_view = ACCESS_ARMORY
	contains = list(
		/obj/item/gun/ballistic/shotgun/riot,
		/obj/item/storage/belt/shotgun,
		/obj/item/storage/belt/shotgun,
		)

/datum/supply_pack/goody/energy_single
	name = "Е-Ган"
	desc = "Базовая гибридная энергетическая пушка с двумя настройками: оглушить и убить."
	cost = PAYCHECK_HARD * 15
	access_view = ACCESS_ARMORY
	contains = list(/obj/item/gun/energy/e_gun)

/datum/supply_pack/goody/hell_single
	name = "Комплект модернизации \"Адское пламя\""
	desc = "Возьмите идеально работающую лазерную винтовку . Разделайте внутреннюю часть винтовки, чтобы она пылала. Теперь у вас есть винтовка \"Адское пламя\". Вы чудовище."
	cost = PAYCHECK_HARD * 5
	access_view = ACCESS_ARMORY
	contains = list(/obj/item/weaponcrafting/gunkit/hellgun)

/datum/supply_pack/goody/sologamermitts
	name = "Изоляционные перчатки"
	desc = "Основа современного общества. Практически никогда не заказывался реальными инженерами."
	cost = PAYCHECK_MEDIUM * 8
	contains = list(/obj/item/clothing/gloves/color/yellow)

/datum/supply_pack/goody/gripper_single
	name = "Перчатки перехвата"
	desc = "Особые перчатки манипулирующие кровеносными сосудами рук владельца, дающие ему возможность врезаться в стены."
	cost = PAYCHECK_HARD * 6
	contains = list(/obj/item/clothing/gloves/tackler)

/datum/supply_pack/goody/firstaid_single
	name = "Аптечка первой помощи"
	desc = "Содержит шовный и перевязочный материал для лечения легких травм."
	cost = PAYCHECK_MEDIUM * 2
	contains = list(/obj/item/storage/firstaid/regular)

/datum/supply_pack/goody/firstaidbruises_single
	name = "Аптечка травматологическая"
	desc = "Содержит медикаменты для излечения резаных, колотых ран и травм вызванных ударами тупым предметом различной степени тяжести."
	cost = PAYCHECK_MEDIUM * 2.5
	contains = list(/obj/item/storage/firstaid/brute)

/datum/supply_pack/goody/firstaidburns_single
	name = "Аптечка противоожоговая"
	desc = "Пригодится в тех случаях когда лаборатория взрывотехники <i>-случайно-</i> сгорела."
	cost = PAYCHECK_MEDIUM * 2.5
	contains = list(/obj/item/storage/firstaid/fire)

/datum/supply_pack/goody/firstaidoxygen_single
	name = "Аптечка стабилизационная"
	desc = "Содержит препараты для предотвращения асфиксии и регенерации крови."
	cost = PAYCHECK_MEDIUM * 2.5
	contains = list(/obj/item/storage/firstaid/o2)

/datum/supply_pack/goody/firstaidtoxins_single
	name = "Аптечка для вывода токсинов"
	desc = "Используется для очищения организма от токсичного и радиоактивного загрязнения, а так же промывки кровотока от химических соединений."
	cost = PAYCHECK_MEDIUM * 2.5
	contains = list(/obj/item/storage/firstaid/toxin)

/datum/supply_pack/goody/toolbox // mostly just to water down coupon probability
	name = "Укомплектованный пояс с инструментами"
	desc = "Содержит сам пояс и все необходимые инструменты."
	cost = PAYCHECK_MEDIUM * 2
	contains = list(/obj/item/storage/belt/utility/full)

/datum/supply_pack/goody/valentine
	name = "Валентинка"
	desc = "Произведите впечатление на этого особенного человека! Поставляется с одной валентинкой и бесплатным конфетным сердечком!"
	cost = PAYCHECK_ASSISTANT * 2
	contains = list(/obj/item/valentine, /obj/item/food/candyheart)

/datum/supply_pack/goody/beeplush
	name = "Плюшевая пчёлка"
	desc = "Милая игрушка, напоминающая еще более милую пчелу."
	cost = PAYCHECK_EASY * 4
	contains = list(/obj/item/toy/plush/beeplushie)

/datum/supply_pack/goody/dyespray
	name = "Краска для волос"
	desc = "Можно покрасить волосы во всякие цвета."
	cost = PAYCHECK_EASY * 2
	contains = list(/obj/item/dyespray)

/datum/supply_pack/goody/beach_ball
	name = "Пляжный мячик"
	desc = "Простой пляжный мяч - один из самых популярных продуктов НаноТрейзен. - Зачем мы делаем пляжные мячи? Потому что мы можем! (TM)' - НаноТразен"
	cost = PAYCHECK_MEDIUM
	contains = list(/obj/item/toy/beach_ball)

/datum/supply_pack/goody/medipen_twopak
	name = "Набор продвинутых медипенов"
	desc = "Содержит продвинутый антитравматический, антиожоговый и гемолитический медипены."
	cost = PAYCHECK_MEDIUM * 2
	contains = list(
		/obj/item/reagent_containers/hypospray/medipen/super_burn,
		/obj/item/reagent_containers/hypospray/medipen/super_brute,
		/obj/item/reagent_containers/hypospray/medipen/blood_boost,
		/obj/item/storage/belt/medipenal
		)

/datum/supply_pack/goody/mothic_rations
	name = "Персональный рацион для моли"
	desc = "Коробка, содержащая несколько пайков и немного жевательной резинки Activin, чтобы поддерживать голодную моль."
	cost = PAYCHECK_HARD
	contains = list(/obj/item/storage/box/mothic_rations)

/datum/supply_pack/goody/ready_donk
	name = "Коробка со случайными донк-пакетами"
	desc = "Содержит целую коробку донк-пакетов. Вкус выбирается случайно."
	cost = PAYCHECK_MEDIUM
	contains = list(
		/obj/item/storage/box/donkpockets/donkpocketspicy,
		/obj/item/storage/box/donkpockets/donkpocketteriyaki,
		/obj/item/storage/box/donkpockets/donkpocketpizza,
		/obj/item/storage/box/donkpockets/donkpocketberry,
		/obj/item/storage/box/donkpockets/donkpockethonk
		)

/datum/supply_pack/goody/ready_donk/fill(obj/structure/closet/crate/C)
	var/item = pick(contains)
	new item(C)

/datum/supply_pack/goody/fishing_toolbox
	name = "Ящик для рыбных принадлежностей"
	desc = "Полный набор инструментов для вашего рыбацкого приключения. Усовершенствованные крючки и лески продаются отдельно."
	cost = PAYCHECK_ASSISTANT * 2
	contains = list(/obj/item/storage/toolbox/fishing)

/datum/supply_pack/goody/fishing_hook_set
	name = "Набор рыболовных крючков"
	desc = "Набор различных рыболовных крючков."
	cost = PAYCHECK_ASSISTANT
	contains = list(/obj/item/storage/box/fishing_hooks)

/datum/supply_pack/goody/fishing_line_set
	name = "Набор рыболовных лесок"
	desc = "Набор различных рыболовных лесок."
	cost = PAYCHECK_ASSISTANT
	contains = list(/obj/item/storage/box/fishing_lines)

/datum/supply_pack/goody/premium_bait
	name = "Роскошная рыболовная приманка"
	desc = "Когда стандартный сорт недостаточно хорош для вас."
	cost = PAYCHECK_ASSISTANT
	contains = list(/obj/item/bait_can/worm/premium)

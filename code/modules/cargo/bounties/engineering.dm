/datum/bounty/item/engineering/gas
	name = "Полная канистра плюоксия"
	description = "РнД ЦК исследует сверхкомпактные внутренние устройства. Отправьте им бак, полный плуоксиума, и вы получите компенсацию."
	reward = CARGO_CRATE_VALUE * 15
	wanted_types = list(/obj/item/tank)
	var/moles_required = 20 // A full tank is 28 moles, but CentCom ignores that fact.
	var/gas_type = /datum/gas/pluoxium

/datum/bounty/item/engineering/gas/applies_to(obj/O)
	if(!..())
		return FALSE
	var/obj/item/tank/T = O
	return T.air_contents.get_moles(gas_type) >= moles_required

/datum/bounty/item/engineering/gas/nitryl_tank
	name = "Полная канистра Нитрила"
	description = "Персонал станции 88, не являющиеся людьми, были вызван для тестирования препаратов, улучшающих их эффективность. Отправьте им резервуар, полный нитрила, чтобы они могли начать эксперимент."
	gas_type = /datum/gas/nitryl

/datum/bounty/item/engineering/gas/freon_tank
	name = "Полная канистра Фреона"
	description = "Суперматерия Станции 33 начала процесс деламинации. Доставьте баллон с фреоновым газом, чтобы помочь им остановить его!"
	gas_type = /datum/gas/freon

/datum/bounty/item/engineering/gas/tritium_tank
	name = "Полная канисра Тритиума"
	description = "Станция 49 надеется начать свою исследовательскую программу. Отправьте им канистру, полную трития."
	gas_type = /datum/gas/tritium

/datum/bounty/item/engineering/gas/hydrogen_tank
	name = "Полная канистра Водорода"
	description = "Наш отдел исследований и разработок занимается разработкой более эффективных электрических батарей, использующих водород в качестве катализатора. Отправьте нам полный бак Гидрогена."
	gas_type = /datum/gas/hydrogen

/datum/bounty/item/engineering/energy_ball
	name = "Удержанный шар теслы"
	description = "Станция 24 наводнена ордами разгневанных молей. Она запрашивают шар Теслы."
	reward = 75000 //requires 14k credits of purchases, not to mention cooperation with engineering/heads of staff to set up inside the cramped shuttle
	wanted_types = list(/obj/energy_ball)

/datum/bounty/item/engineering/energy_ball/applies_to(obj/O)
	if(!..())
		return FALSE
	var/obj/energy_ball/T = O
	return !T.miniball

/datum/bounty/item/engineering/gas/zauker_tank
	name = "Полная канистра Заукера"
	description = "Главная планета \[REDACTED] была выбрана в качестве полигона для испытания нового оружия, в котором используется газ Заукер. Отправьте нам полный бак. (20 моль)"
	reward = CARGO_CRATE_VALUE * 20
	gas_type = /datum/gas/zauker

/datum/bounty/item/engineering/emitter
	name = "Эмиттер"
	description = "Мы думаем, что в конструкции эмиттера вашей станции может быть дефект, основанный на огромном количестве отслоений, которые, похоже, видит ваш сектор. Отправьте нам один из ваших."
	reward = CARGO_CRATE_VALUE * 5
	wanted_types = list(/obj/machinery/power/emitter)

/datum/bounty/item/engineering/hydro_tray
	name = "Гидропонические лотки"
	description = "Лаборанты пытаются выяснить, как снизить потребление энергии лотками для гидропоники, но мы поджарили последний. Сделаете один для нас?"
	reward = CARGO_CRATE_VALUE * 4
	wanted_types = list(/obj/machinery/hydroponics/constructable)

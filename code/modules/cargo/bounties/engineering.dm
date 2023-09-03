/datum/bounty/item/engineering/gas
	name = "Полная канистра плюоксия"
	description = "РнД ЦК исследует сверхкомпактные внутренние устройства. Отправьте им бак, полный плуоксиума, и вы получите компенсацию."
	reward = CARGO_CRATE_VALUE * 15
	wanted_types = list(/obj/item/tank)
	var/moles_required = 20 // A full tank is 28 moles, but CentCom ignores that fact.
	var/gas_type = GAS_PLUOXIUM

/datum/bounty/item/engineering/gas/applies_to(obj/O)
	if(!..())
		return FALSE
	var/obj/item/tank/T = O
	return T.air_contents.get_moles(gas_type) >= moles_required

/datum/bounty/item/engineering/gas/nitrium_tank
	name = "Полная канистра Нитрила"
	description = "Персонал станции 88, не являющиеся людьми, были вызван для тестирования препаратов, улучшающих их эффективность. Отправьте им резервуар, полный нитрила, чтобы они могли начать эксперимент."
	gas_type = GAS_NITRIUM

/datum/bounty/item/engineering/gas/tritium_tank
	name = "Полная канистра Трития"
	description = "Станция 49 надеется начать свою исследовательскую программу. Отправьте им канистру, полную трития."
	gas_type = GAS_TRITIUM

/datum/bounty/item/engineering/energy_ball
	name = "Удержанный шар теслы"
	description = "Станция 24 наводнена ордами разгневанных молей. Она запрашивают шар Теслы."
	reward = 114000 //requires 14k credits of purchases, not to mention cooperation with engineering/heads of staff to set up inside the cramped shuttle
	wanted_types = list(/obj/energy_ball)

/datum/bounty/item/engineering/energy_ball/applies_to(obj/O)
	if(!..())
		return FALSE
	var/obj/energy_ball/T = O
	return !T.miniball

/datum/bounty/item/engineering/emitter
	name = "Эмиттер"
	description = "Мы думаем, что в конструкции эмиттера вашей станции может быть дефект, основанный на огромном количестве отслоений, которые, похоже, видит ваш сектор. Отправьте нам один из ваших."
	reward = CARGO_CRATE_VALUE * 100
	wanted_types = list(/obj/machinery/power/emitter)

/datum/bounty/item/engineering/hydro_tray
	name = "Гидропонические лотки"
	description = "Лаборанты пытаются выяснить, как снизить потребление энергии лотками для гидропоники, но мы поджарили последний. Сделаете один для нас?"
	reward = CARGO_CRATE_VALUE * 70
	wanted_types = list(/obj/machinery/hydroponics/constructable)

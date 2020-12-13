/datum/bounty/item/science/boh
	name = "Блюспейс сумка"
	description = "НТ хорошо использовали бы рюкзаки большой вместимости. Если у вас есть, пожалуйста, отправьте их."
	reward = 10000
	wanted_types = list(/obj/item/storage/backpack/holding)

/datum/bounty/item/science/tboh
	name = "Блюспейс мешок для мусора"
	description = "НТ хотели бы использовать мешки для мусора большой емкости. Если у вас есть, пожалуйста, отправьте их."
	reward = 10000
	wanted_types = list(/obj/item/storage/bag/trash/bluespace)

/datum/bounty/item/science/bluespace_syringe
	name = "Блюспейс шприц"
	description = "НТ хочет использовать шприцы большой емкости. Если у вас есть, пожалуйста, отправьте их."
	reward = 10000
	wanted_types = list(/obj/item/reagent_containers/syringe/bluespace)

/datum/bounty/item/science/bluespace_body_bag
	name = "Блюспейс мешок для трупов"
	description = "НТ хочет использовать сумки для тела большой емкости. Если у вас есть, пожалуйста, отправьте их."
	reward = 10000
	wanted_types = list(/obj/item/bodybag/bluespace)

/datum/bounty/item/science/nightvision_goggles
	name = "Очки ночного видения"
	description = "Электрический шторм сломал все лампы на ЦК. Пока руководство ожидает замены, возможно, несколько очков ночного видения могут быть отправлены?"
	reward = 10000
	wanted_types = list(/obj/item/clothing/glasses/night, /obj/item/clothing/glasses/meson/night, /obj/item/clothing/glasses/hud/health/night, /obj/item/clothing/glasses/hud/security/night, /obj/item/clothing/glasses/hud/diagnostic/night)

/datum/bounty/item/science/experimental_welding_tool
	name = "Экспериментальный сварочный инструмент"
	description = "Недавняя авария привела к взрыву большинства сварочных инструментов ЦК. Отправители будут вознаграждены."
	reward = 10000
	required_count = 3
	wanted_types = list(/obj/item/weldingtool/experimental)

/datum/bounty/item/science/cryostasis_beaker
	name = "Крио-стакан"
	description = "Химики ЦК обнаружили новый химикат, который можно хранить только в стаканах с криостазом. Единственная проблема в том, что у них их нет! Исправьте это, чтобы получить оплату."
	reward = 10000
	wanted_types = list(/obj/item/reagent_containers/glass/beaker/noreact)

/datum/bounty/item/science/diamond_drill
	name = "Алмазная шахтёрская дрель"
	description = "Центральное командование готово выплачивать трехмесячную зарплату в обмен на одну алмазную дрель"
	reward = 15000
	wanted_types = list(/obj/item/pickaxe/drill/diamonddrill, /obj/item/mecha_parts/mecha_equipment/drill/diamonddrill)

/datum/bounty/item/science/floor_buffer
	name = "Улучшение напольного буфера"
	description = "Один из уборщиков ЦК сделал небольшое состояние, делая ставки на скачках карпа. Теперь они хотели бы заказать улучшение напольного буфера."
	reward = 10000
	wanted_types = list(/obj/item/janiupgrade)

/datum/bounty/item/science/advanced_mop
	name = "Продвинутая Швабра"
	description = "Прошу прощения. Я хотел бы попросить 17 кр за переделку метлой. Или это, или продвинутая швабра."
	reward = 10000
	wanted_types = list(/obj/item/mop/advanced)

/datum/bounty/item/science/advanced_egun
	name = "Продвинутый е-ган"
	description = "С ростом цен на зарядные устройства, высшее руководство заинтересовано в покупке оружия с автоматическим питанием. Если вы отправите один, они заплатят."
	reward = 10000
	wanted_types = list(/obj/item/gun/energy/e_gun/nuclear)

/datum/bounty/item/science/bepis_disc
	name = "Переформатированный технический диск"
	description = "Оказывается, дискеты, на которых BEPIS печатает экспериментальные узлы, чрезвычайно экономят пространство. Когда закончите, пришлите нам один из дисков."
	reward = 4000
	wanted_types = list(/obj/item/disk/tech_disk/major)

/datum/bounty/item/science/relic
	name = "E.X.P.E.R.I-MENTORially Discovered Devices"
	description = "Psst, hey. Don't tell the assistants, but we're undercutting them on the value of those 'strange objects' they've been finding. Fish one up and send us a discovered one by using the E.X.P.E.R.I-MENTOR."
	reward = CARGO_CRATE_VALUE * 8
	wanted_types = list(/obj/item/relic)

/datum/bounty/item/science/relic/applies_to(obj/O)
	if(!..())
		return FALSE
	var/obj/item/relic/experiment = O
	if(experiment.revealed)
		return TRUE
	return

/datum/bounty/item/science/bepis_disc
	name = "Reformatted Tech Disk"
	description = "It turns out the diskettes the BEPIS prints experimental nodes on are extremely space-efficient. Send us one of your spares when you're done with it."
	reward = CARGO_CRATE_VALUE * 8
	wanted_types = list(/obj/item/disk/tech_disk/major, /obj/item/disk/tech_disk/spaceloot)

/datum/bounty/item/science/genetics
	name = "Genetics Disability Mutator"
	description = "Understanding the humanoid genome is the first step to curing many spaceborn genetic defects, and exceeding our basest limits."
	reward = CARGO_CRATE_VALUE * 2
	wanted_types = list(/obj/item/dnainjector)
	///What's the instability
	var/desired_instability = 0

/datum/bounty/item/science/genetics/New()
	. = ..()
	desired_instability = rand(10,40)
	reward += desired_instability * (CARGO_CRATE_VALUE * 0.2)
	description += " We want a DNA injector whose total instability is higher than [desired_instability] points."

/datum/bounty/item/science/genetics/applies_to(obj/O)
	if(!..())
		return FALSE
	var/obj/item/dnainjector/mutator = O
	if(mutator.used)
		return FALSE
	var/inst_total = 0
	for(var/pot_mut in mutator.add_mutations)
		var/datum/mutation/human/mutation = pot_mut
		if(initial(mutation.quality) != POSITIVE)
			continue
		inst_total += mutation.instability
	if(inst_total >= desired_instability)
		return TRUE
	return FALSE

//******Modular Computer Bounties******
/datum/bounty/item/science/NTNet
	name = "Modular Tablets"
	description = "Turns out that NTNet wasn't actually a fad afterall, who knew. Ship us some fully constructed tablets and send it turned on."
	reward = CARGO_CRATE_VALUE * 6
	required_count = 4
	wanted_types = list(/obj/item/modular_computer/tablet)

/datum/bounty/item/science/NTNet/laptops
	name = "Modular Laptops"
	description = "Central command brass need something more powerful than a tablet, but more portable than a console. Help these old fogeys out by shipping us some working laptops. Send it turned on."
	reward = CARGO_CRATE_VALUE * 3
	required_count = 2
	wanted_types = list(/obj/item/modular_computer/laptop)

/datum/bounty/item/science/NTNet/console
	name = "Modular Computer Console"
	description = "Our big data devision needs more powerful hardware to play 'Outbomb Cuban Pe-', err, to closely monitor threats in your sector. Send us a working modular computer console."
	reward = CARGO_CRATE_VALUE * 6
	required_count = 1
	wanted_types = list(/obj/machinery/modular_computer/console)

/datum/bounty/item/science/NTnet/applies_to(obj/O)
	. = ..()
	var/obj/item/modular_computer/computer = O
	if(computer.enabled)
		return TRUE
	return TRUE

/datum/bounty/item/science/NTnet/console/applies_to(obj/O)
	var/obj/machinery/modular_computer/console/computer = O
	if(computer.cpu)
		return TRUE
	return FALSE


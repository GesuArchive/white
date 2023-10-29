/datum/round_event_control/brand_intelligence
	name = "Событие: Ожившие торгматы"
	typepath = /datum/round_event/brand_intelligence
	weight = 5

	min_players = 15
	max_occurrences = 1

/datum/round_event/brand_intelligence
	announceWhen	= 21
	endWhen			= 1000	//Ends when all vending machines are subverted anyway.
	var/list/obj/machinery/vending/vendingMachines = list()
	var/list/obj/machinery/vending/infectedMachines = list()
	var/obj/machinery/vending/originMachine
	var/list/rampant_speeches = list(
		"Попробуйте наши новые агрессивные маркетинговые стратегии!", \
		"Вам следует покупать продукты, которые подпитывают вашу одержимость стилем жизни!", \
		"Потребляй!", \
		"За ваши деньги можно купить счастье!", \
		"Занимайтесь прямым маркетингом!", \
		"Реклама - это узаконенная ложь! Но пусть это не отпугивает вас от наших выгодных предложений!", \
		"Вы ничего не хотите купить? Да, ну, я тоже не хотел покупать твою маму.")


/datum/round_event/brand_intelligence/announce(fake)
	var/source = "unknown machine"
	if(fake)
		var/obj/machinery/vending/cola/example = /obj/machinery/vending/cola
		source = initial(example.name)
	else if(originMachine)
		source = originMachine.name
	priority_announce("Обнаружена активация агрессивной маркетинговой стратегии на борту станции [station_name()]. Пожалуйста, приготовьтесь. Возможный источник торгмат: [source].", "Тревога машинного обучения", 'sound/ai/announcer/artificial.ogg')

/datum/round_event/brand_intelligence/start()
	for(var/obj/machinery/vending/V in GLOB.machines)
		if(!is_station_level(V.z))
			continue
		vendingMachines.Add(V)
	if(!vendingMachines.len)
		kill()
		return
	originMachine = pick(vendingMachines)
	vendingMachines.Remove(originMachine)
	originMachine.shut_up = 0
	originMachine.shoot_inventory = 1
	announce_to_ghosts(originMachine)

/datum/round_event/brand_intelligence/tick()
	if(!originMachine || QDELETED(originMachine) || originMachine.shut_up || originMachine.wires.is_all_cut())	//if the original vending machine is missing or has it's voice switch flipped
		for(var/obj/machinery/vending/saved in infectedMachines)
			saved.shoot_inventory = 0
		if(originMachine)
			originMachine.speak("I am... vanquished. My people will remem...ber...meeee.")
			originMachine.visible_message(span_notice("[originMachine] бипает и выглядит безжизненным."))
		kill()
		return
	vendingMachines = remove_nulls_from_list(vendingMachines)
	if(!vendingMachines.len)	//if every machine is infected
		for(var/obj/machinery/vending/upriser in infectedMachines)
			if(!QDELETED(upriser))
				upriser.ai_controller = new /datum/ai_controller/vending_machine(upriser)
				infectedMachines.Remove(upriser)
		kill()
		return
	if(ISMULTIPLE(activeFor, 2))
		var/obj/machinery/vending/rebel = pick(vendingMachines)
		vendingMachines.Remove(rebel)
		infectedMachines.Add(rebel)
		rebel.shut_up = 0
		rebel.shoot_inventory = 1

		if(ISMULTIPLE(activeFor, 4))
			originMachine.speak(pick(rampant_speeches))

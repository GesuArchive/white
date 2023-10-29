/datum/major_mode/collect_items
	name = "сбор предметов"
	required_players = 0
	announce_after 	 = 5 MINUTES
	fail_after 		 = 1 HOURS
	announce_type 	 = "announce"
	announce_text 	 = "Работать."
	var/list/possbile_things = list(
		/obj/item/food/pie/applepie = 15,
		/obj/item/circuitboard/machine/gibber = 30,
		/obj/item/crowbar = 30,
		/obj/item/pen = 20,
		/obj/item/kitchen/fork = 50,
		/obj/item/surgicaldrill = 5,
		/obj/item/stack/sheet/mineral/uranium = 50,
		/obj/item/organ/appendix = 15,
		/obj/item/organ/brain = 15,
		/obj/item/organ/eyes = 15,
		/obj/item/organ/liver = 15,
		/obj/item/food/grown/apple = 50,
		/obj/item/food/grown/banana = 50,
		/obj/item/food/grown/berries = 50,
		/obj/item/food/grown/onion = 50,
		/obj/item/food/grown/pineapple = 50,
		/obj/item/food/grown/tomato = 50,
		/obj/item/food/grown/nettle = 50,
		/obj/item/reagent_containers/food/drinks/bottle/molotov = 30)
	var/list/need_to_collect = list()

/datum/major_mode/collect_items/generate_quest()
	announce_text =  "<center><h1> -- СОВЕРШЕННО СЕКРЕТНО -- </h1></center>"
	announce_text += "<center><h2>Центральное Командование</h2></center>"
	announce_text += "<center><i>Капитану или любому другому доверенному лицу на станции.</i></center>"
	announce_text += "<center><h3>Информация</h3></center>"
	announce_text += "<br>Для борьбы с Синдикатом нам требуется ваша помощь. "
	announce_text += "Необходимо собрать <b>следующие материалы</b> на грузовом шаттле и нажать <b>специальную кнопку</b> для отправки груза: "
	var/list/text_reqs = list()
	for(var/i in 1 to rand(4, 6))
		var/atom/thing_to_collect = pick(possbile_things)
		var/amt = rand(1, possbile_things[thing_to_collect])
		LAZYADD(need_to_collect, list("name" = initial(thing_to_collect.name), "type" = thing_to_collect, "amount" = amt))
		LAZYADD(text_reqs, "[amt] [initial(thing_to_collect.name)]")
	announce_text += "<u>[english_list(text_reqs)]</u>."
	announce_text += "<br><br><i>У вас <b>один час</b> на выполнение данного поручения, в случае невыполнения ваша станция будет признана подрывающей работу и будет уничтожена.</i>"
	return

/datum/major_mode/collect_items/check_completion()
	var/area/arr = GLOB.areas_by_type[/area/shuttle/supply]
	if(!arr)
		return FALSE
	var/list/temp_list_to_collect = LAZYCOPY(need_to_collect)
	var/list/things_to_remove_after = list()
	for(var/atom/A in arr)
		if(A?.contents?.len)
			for(var/atom/B in A.contents)
				for(var/list/thing in temp_list_to_collect)
					if(istype(B.type, thing["type"]))
						thing["amount"] -= 1
						things_to_remove_after += B
						continue
		if(temp_list_to_collect[A?.type])
			for(var/list/thing in temp_list_to_collect)
				if(istype(A.type, thing["type"]))
					thing["amount"] -= 1
					things_to_remove_after += A
					continue
	for(var/i in temp_list_to_collect)
		if(temp_list_to_collect[i] >= 1)
			var/list/text_reqs = list()
			for(var/list/thing in temp_list_to_collect)
				if(thing["amount"] >= 1)
					text_reqs += list("[thing["amount"]] [thing["name"]]")
			priority_announce("Ошибка отправки, собран не весь груз. Осталось собрать: [english_list(text_reqs)]", "Центральное Командование", 'sound/ai/announcer/alert.ogg')
			return FALSE
	QDEL_LIST(things_to_remove_after)
	is_done = TRUE
	SSshuttle.moveShuttle("supply", "supply_away", TRUE)
	var/datum/bank_account/D = SSeconomy.get_dep_account(ACCOUNT_CAR)
	if(D)
		D.adjust_money(500000)
	for(var/mob/M in GLOB.joined_player_list)
		if(isliving(M) && M.client && is_station_level(M.z))
			inc_metabalance(M, 150, reason="Задание выполнено!")
	priority_announce("Задание успешно выполнено, на счёт снабжения была переведена награда в размере 500000 кредитов. Можете вернуться к своим основным обязанностям.", "Центральное Командование", 'sound/ai/announcer/alert.ogg')
	return TRUE

/datum/major_mode/collect_items/fail_completion()
	message_admins("<b>Задание провалено. Начинаем зачистку.</b>")
	var/code = rand(10000, 99999)
	for(var/obj/machinery/nuclearbomb/selfdestruct/SD in GLOB.nuke_list)
		SD.r_code = code
	deathsquad_request("Уничтожить станцию ядерным устройством. Код авторизации: [code]", "MAJOR MODE")
	return

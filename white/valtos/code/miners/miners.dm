SUBSYSTEM_DEF(spm)
	name = "Криптомайнинг"
	wait = 25
	var/list/miners	= list()
	var/diff = 1.0001
	var/crypto = "BTC"

/datum/controller/subsystem/spm/Initialize()
	. = ..()

/datum/controller/subsystem/spm/stat_entry(msg)
	msg = "P:[miners.len]"
	return ..()

/datum/controller/subsystem/spm/fire()
	diff += 0.0001

	for(var/obj/machinery/power/mining_rack/MC in miners)
		if(!MC.powernet)
			miners.Remove(MC)
			MC.update()
			continue
		MC.update()

/datum/controller/subsystem/spm/proc/gen_new_crypto()
	crypto = pick(GLOB.crypto_names)

/////////////////////////////////////
// New SC miners
// love this
/////////////////////////////////////

/obj/machinery/power/mining_rack
	name = "Криптополка"
	desc = "Сюда можно установить специальное \"оборудование\"."
	icon = 'white/valtos/icons/miner.dmi'
	icon_state = "rack"

	anchored = TRUE
	density = TRUE

	use_power = NO_POWER_USE

	var/hashrate_total = 0
	var/datum/techweb/linked_techweb
	var/datum/bank_account/linked_account
	var/mining = FALSE
	var/bound_key = "HACKME"

/obj/machinery/power/mining_rack/Initialize()
	. = ..()
	name = "Криптополка #[rand(1, 99999)]"
	if(anchored)
		connect_to_network()
	linked_techweb = SSresearch.science_tech
	linked_account = SSeconomy.get_dep_account(ACCOUNT_CAR)

/obj/machinery/power/mining_rack/connect_to_network()
	var/to_return = ..()
	if(powernet)
		SSspm.miners |= src
	return to_return

/obj/machinery/power/mining_rack/disconnect_from_network()
	..()
	SSspm.miners.Remove(src)

/obj/machinery/power/mining_rack/attack_ai(mob/user)
	interact(user)

/obj/machinery/power/mining_rack/attack_paw(mob/user)
	interact(user)

/obj/machinery/power/mining_rack/examine(mob/user)
	. = ..()

	. += "<hr><span class='notice'>Датчик температуры: [get_env_temp()]°C</span>"

	if(contents.len)
		. += "<hr><span class='notice'>Внутри можно заметить:</span>"
		for(var/obj/item/mining_thing/MT in contents)
			. += "\n<span class='notice'>[icon2html(MT, user)] [MT.tech_name] \[[MT.hashrate + MT.overclock] Sols/s]</span>"
	. += "<hr><span class='notice'>Общая скорость: <b>[hashrate_total] Sols/s</b>.</span>"
	. += "\n<span class='notice'>Сложность сети: <b>[SSspm.diff]</b>.</span>"
	. += "\n<span class='notice'>Привязанный аккаунт: <b>[linked_account.account_holder]</b>.</span>"

/obj/machinery/power/mining_rack/proc/get_env_temp()
	var/datum/gas_mixture/env = loc.return_air()
	return round(env.return_temperature()-T0C, 0.01)

/obj/machinery/power/mining_rack/proc/recalculate_hashrate()

	hashrate_total = 0

	for(var/obj/item/mining_thing/MT in contents)
		hashrate_total += MT.hashrate + MT.overclock

/obj/machinery/power/mining_rack/attackby(obj/item/I, mob/living/user, params)

	if(user.a_intent == INTENT_HARM)
		return ..()

	if(istype(I, /obj/item/card/id))
		var/obj/item/card/id/acard = I
		if(acard.registered_account)
			linked_account = acard.registered_account
			to_chat(user, span_notice("Привязываю карту к полке."))
			return
		to_chat(user, span_warning("На карте нет аккаунта!"))
		return

	if(istype(I, /obj/item/mining_thing))
		if(contents.len >= 3)
			to_chat(user, span_warning("Стойка переполнена!"))
			return
		I.forceMove(src)
		switch(contents.len)
			if(1)
				to_chat(user, span_notice("Устанавливаю оборудование в верхний слот."))
				add_overlay("top_miners")
			if(2)
				to_chat(user, span_notice("Устанавливаю оборудование в средний слот."))
				add_overlay("mid_miners")
			if(3)
				to_chat(user, span_notice("Устанавливаю оборудование в нижний слот."))
				add_overlay("bot_miners")
		recalculate_hashrate()

	if(I.tool_behaviour == TOOL_WRENCH)
		to_chat(user, span_notice("Начинаю [anchored ? "от" : "при"]кручивать [src.name]..."))
		if(I.use_tool(src, user, 40, volume=75))
			to_chat(user, span_notice("[anchored ? "От" : "При"]кручиваю [src.name]."))
			set_anchored(!anchored)
		return

	if(I.tool_behaviour == TOOL_MULTITOOL)
		var/new_key = stripped_input(usr, "Текущий ключ \"[bound_key]\"", "Установка нового ключа.")
		if(!new_key)
			return
		bound_key = new_key
		to_chat(user, span_notice("Ключ \"[new_key]\" установлен."))
		return

	if(I.tool_behaviour == TOOL_CROWBAR)
		if(!contents.len)
			to_chat(user, span_warning("Внутри пусто!"))
			return
		switch(contents.len)
			if(1)
				to_chat(user, span_notice("Вытаскиваю оборудование из верхнего слота."))
				cut_overlay("top_miners")
			if(2)
				to_chat(user, span_notice("Вытаскиваю оборудование из среднего слота."))
				cut_overlay("mid_miners")
			if(3)
				to_chat(user, span_notice("Вытаскиваю оборудование из нижнего слота."))
				cut_overlay("bot_miners")
		var/obj/item/TFM = contents[contents.len]
		var/turf/T = get_turf(src)
		TFM.forceMove(T)
		recalculate_hashrate()

/obj/machinery/power/mining_rack/set_anchored(anchorvalue)
	. = ..()
	if(isnull(.))
		return
	if(anchorvalue)
		connect_to_network()
	else
		disconnect_from_network()

/obj/machinery/power/mining_rack/proc/update()
	if(!mining || (!powernet && hashrate_total * 10))
		return

	if(mining)
		if(!hashrate_total * 10 || surplus() >= hashrate_total * 10)
			add_load(hashrate_total * 10)
		else
			idle_power_usage = 40
			mining = FALSE
			return

		var/datum/gas_mixture/env = loc.return_air()

		env.set_temperature(env.return_temperature() + (hashrate_total / 100))
		air_update_turf()

		if(get_env_temp() > 250)
			add_overlay("onfire")
			for(var/obj/item/mining_thing/MT in contents)
				new /obj/item/mining_thing/burned(drop_location())
				qdel(MT)
			env.set_temperature(env.return_temperature() + (hashrate_total))
			QDEL_IN(src, 5 SECONDS)
			return

		for(var/obj/item/mining_thing/MT in contents)
			if(MT.type == /obj/item/mining_thing/burned)
				say("По статистике, [rand(60,90)]% людей не читает описание предметов.")
				add_overlay("onfire")
				mining = FALSE
				spawn(1 SECONDS)
					explosion(1, 2, 3, 4, 5)
					if(src)
						QDEL_IN(src, 1 SECONDS)
				return

		if(linked_account)
			linked_account.adjust_money(max((hashrate_total/SSspm.diff)/1000, 1))

		if(istype(linked_techweb))
			linked_techweb.add_point_list(list(TECHWEB_POINT_TYPE_DEFAULT = max(hashrate_total/SSspm.diff, 1)))

/obj/item/mining_thing
	name = "куча хлама"
	desc = "Набор из восьми видеокарт одинаковой мощности."
	icon = 'white/valtos/icons/miner.dmi'
	icon_state = "miners"
	var/maintainer = "кандидат на анпедал"
	var/tech_name = "NTX-2228 Plasma"
	var/hashrate = 1 // debug
	var/overclock = 0

/obj/item/mining_thing/attackby(obj/item/I, mob/living/user, params)

	if(user.a_intent == INTENT_HARM)
		return ..()

	if(I.tool_behaviour == TOOL_MULTITOOL)
		to_chat(user, span_notice("Пытаюсь разогнать [src.name]..."))
		if(I.use_tool(src, user, 40, volume=75))
			if(prob(overclock))
				to_chat(user, span_warning("Успешно не разгоняю [src.name]?!"))
				new /obj/item/mining_thing/burned(drop_location())
				qdel(src)
				return
			overclock += rand(5, 10)
			to_chat(user, span_notice("Успешно разгоняю [src.name]! Новый прирост: [overclock]."))

/obj/item/mining_thing/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>Производитель: <b>[maintainer]</b>.</span>"

/obj/item/mining_thing/burned
	name = "сырок палёнка"
	desc = "А нехуй."
	maintainer = "нано-пром-торг"
	tech_name = "Точно Безопасно"

/obj/item/mining_thing/burned/Initialize()
	. = ..()
	hashrate = rand(-10000, 1)

/obj/item/mining_thing/nvidia
	tech_name = "GT9600"
	maintainer = "NanoVIDIA"
	hashrate = 40

/obj/item/mining_thing/nvidia/ntx420
	tech_name = "NTX420"
	hashrate = 100

/obj/item/mining_thing/nvidia/ntx970
	tech_name = "NTX970"
	hashrate = 225

/obj/item/mining_thing/nvidia/ntx1666
	tech_name = "NTX1666"
	hashrate = 350

/obj/item/mining_thing/nvidia/ntx2080
	tech_name = "NTX2080"
	hashrate = 525

/obj/item/mining_thing/nvidia/ntx3090ti
	tech_name = "NTX3090Ti"
	hashrate = 700

/obj/item/mining_thing/amd
	tech_name = "HD4350"
	maintainer = "Advanced Mining Designs"
	hashrate = 45

/obj/item/mining_thing/amd/hd6650
	tech_name = "HD6650"
	hashrate = 115

/obj/item/mining_thing/amd/sx270
	tech_name = "SX270"
	hashrate = 240

/obj/item/mining_thing/amd/sx580
	tech_name = "SX580"
	hashrate = 375

/obj/item/mining_thing/amd/ryga580
	tech_name = "RYGA5600"
	hashrate = 575

/obj/item/mining_thing/amd/ryga5600
	tech_name = "RYGA5600"
	hashrate = 575

/obj/item/mining_thing/amd/sx6900xt
	tech_name = "SX6900XT"
	hashrate = 725

/datum/design/mining_thing/nvidia
	name = "GT9600x8"
	desc = "Самая слабая карточка из всей доступная линейки."
	id = "nvidia"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 500, /datum/material/silver = 300, /datum/material/gold = 300)
	build_path = /obj/item/mining_thing/nvidia
	category = list("Электроника")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/mining_thing/nvidia/ntx420
	name = "NTX420x8"
	desc = "Чуть более мощный вариант."
	id = "ntx420"
	materials = list(/datum/material/iron = 500, /datum/material/silver = 300, /datum/material/gold = 300, /datum/material/diamond = 200)
	build_path = /obj/item/mining_thing/nvidia/ntx420

/datum/design/mining_thing/nvidia/ntx970
	name = "NTX970x8"
	desc = "Достойный вариант для тех, кто ценит мощность и дешевизну."
	id = "ntx970"
	materials = list(/datum/material/iron = 1000, /datum/material/silver = 500, /datum/material/gold = 400, /datum/material/diamond = 400)
	build_path = /obj/item/mining_thing/nvidia/ntx970

/datum/design/mining_thing/nvidia/ntx1666
	name = "NTX1666x8"
	desc = "Роскошная версия предыдущей модели."
	id = "ntx1666"
	materials = list(/datum/material/iron = 2000, /datum/material/silver = 1500, /datum/material/gold = 1400, /datum/material/diamond = 1000, /datum/material/bluespace = 500)
	build_path = /obj/item/mining_thing/nvidia/ntx1666

/datum/design/mining_thing/nvidia/ntx2080
	name = "NTX2080x8"
	desc = "Затратный вариант видеокарты для богатых исследовательских станций."
	id = "ntx2080"
	materials = list(/datum/material/iron = 4000, /datum/material/silver = 4000, /datum/material/gold = 4000, /datum/material/diamond = 2000, /datum/material/bluespace = 1500, /datum/material/plasma = 20000)
	build_path = /obj/item/mining_thing/nvidia/ntx2080

/datum/design/mining_thing/nvidia/ntx3090ti
	name = "NTX3090Tix8"
	desc = "Лучший вариант из всех. Слишком сложен в производстве."
	id = "ntx3090ti"
	materials = list(/datum/material/iron = 40000, /datum/material/silver = 40000, /datum/material/gold = 40000, /datum/material/diamond = 20000, /datum/material/bluespace = 15000, /datum/material/plasma = 60000)
	build_path = /obj/item/mining_thing/nvidia/ntx3090ti

/datum/computer_file/program/minnet
	filename = "minnet"
	filedesc = "Min-net Controller"
	program_icon_state = "generic"
	extended_desc = "Используется для управления сетью криптомайнеров."
	requires_ntnet = TRUE
	size = 8
	tgui_id = "NtosMinnet"
	program_icon = "cog"
	var/cryptokey = "HACKME"

/datum/computer_file/program/minnet/ui_data(mob/user)
	var/list/data = get_header_data()
	var/list/all_entries[0]
	for(var/obj/machinery/power/mining_rack/MC in SSspm.miners)
		if(cryptokey != MC.bound_key)
			continue
		all_entries.Add(list(list(
			"name" = MC.name,
			"hashrate" = MC.hashrate_total,
			"mining" = MC.mining,
			"temp" = MC.get_env_temp(),
			"powerusage" = MC.hashrate_total * 10
		)))

	data["miners"] = all_entries
	data["cryptokey"] = cryptokey
	return data

/datum/computer_file/program/minnet/ui_act(action,params)
	. = ..()
	if(.)
		return
	switch(action)
		if("toggle_miner")
			for(var/obj/machinery/power/mining_rack/MC in SSspm.miners)
				if(MC.name == params["name"])
					MC.mining = !MC.mining
			. = TRUE
		if("set_key")
			var/new_key = stripped_input(usr, "Текущий ключ \"[cryptokey]\"", "Установка нового ключа.")
			if(!new_key)
				return
			cryptokey = new_key
			. = TRUE

/datum/supply_pack/misc/spaceminer
	name = "Стойка для майнинга"
	desc = "Почему?!"
	cost = 500
	contains = list(/obj/machinery/power/mining_rack)
	crate_name = "ящик стойки для майнинга"

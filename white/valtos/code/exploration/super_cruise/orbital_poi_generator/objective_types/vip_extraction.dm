/datum/orbital_objective/vip_recovery
	name = "VIP эвакуация"
	var/generated = FALSE
	var/mob/mob_to_recover
	//Relatively easy mission.
	min_payout = 10 * CARGO_CRATE_VALUE
	max_payout = 50 * CARGO_CRATE_VALUE

/datum/orbital_objective/vip_recovery/get_text()
	return "Телекоммуникационный  массив уловил сигнал бедствия, исходящий со станции [station_name]. Повторно выйти на связь не удалось. \
		Если на станции еще остались выжившие, эвакуируйте их на нашу станцию. Согласно трудовому договору они будут рассматриваться как \
		беженцы и имеют право на трудоустройство и продолжение несения службы на нашей станции. В случае гибели выживших, доставьте электронный\
		дневник погибшего члена экипажа или предпримите реанимационные мероприятия."

//If nobody takes up the ghost role, then we dont care if they died.
//I know, its a bit sad.
/datum/orbital_objective/vip_recovery/check_failed()
	if(generated)
		//Deleted
		if(QDELETED(mob_to_recover))
			return TRUE
		//Left behind
		if(mob_to_recover in SSzclear.nullspaced_mobs)
			return TRUE
		//Recovered and alive
		if(is_station_level(mob_to_recover.z) && mob_to_recover.stat == CONSCIOUS)
			complete_objective()
	return FALSE

/datum/orbital_objective/vip_recovery/generate_objective_stuff(turf/chosen_turf)
	var/mob/living/carbon/human/created_human = new(chosen_turf)
	//Maybe polling ghosts would be better than the shintience code
	created_human.ice_cream_mob = TRUE
	ADD_TRAIT(created_human, TRAIT_CLIENT_LEAVED, "ice_cream")
	LAZYADD(GLOB.mob_spawners[created_human.real_name], created_human)
	notify_ghosts("VIP-персона может быть занята.", source = created_human, action = NOTIFY_ORBIT, flashwindow = FALSE, ignore_key = POLL_IGNORE_SPLITPERSONALITY, notify_suiciders = FALSE)
	created_human.AddElement(/datum/element/point_of_interest)
	created_human.mind_initialize()
	//Remove nearby dangers
	for(var/mob/living/simple_animal/hostile/SA in range(10, created_human))
		qdel(SA)
	//Give them a space worthy suit
	var/turf/open/T = locate() in shuffle(view(1, created_human))
	if(T)
		new /obj/item/clothing/suit/space/hardsuit/ancient(T)
		new /obj/item/tank/internals/oxygen(T)
		new /obj/item/clothing/mask/gas(T)
		new /obj/item/storage/belt/utility/full(T)
	switch(pick_weight(list("centcom_official" = 2, "hos" = 1, "greytide" = 3, "engi" = 3, "sci" = 1)))
		if("centcom_official")
			created_human.equipOutfit(/datum/outfit/derelict_vip/inspector)
			created_human.mind.add_antag_datum(/datum/antagonist/derelict_vip/inspector)
		if("hos")
			created_human.equipOutfit(/datum/outfit/derelict_vip/hos)
			created_human.mind.add_antag_datum(/datum/antagonist/derelict_vip/hos)
		if("greytide")
			created_human.equipOutfit(/datum/outfit/derelict_vip/assistent)
			created_human.mind.add_antag_datum(/datum/antagonist/derelict_vip/assistent)
		if("engi")
			created_human.equipOutfit(/datum/outfit/derelict_vip/engi)
			created_human.mind.add_antag_datum(/datum/antagonist/derelict_vip/engi)
		if("sci")
			created_human.equipOutfit(/datum/outfit/derelict_vip/sci)
			created_human.mind.add_antag_datum(/datum/antagonist/derelict_vip/sci)

	mob_to_recover = created_human
	generated = TRUE

/obj/item/paper/vip_pasport		// 	Паспорт должен обязательно находиться в правом кармане у всех ВИПов
	name = "Копия трудового договора"
	info = "<center>Копия трудового договора</center><BR><BR> Данный документ подтверждает, что _______ (далее Работник) является действующим сотрудником компании Нано Трейзен (далее Компания), в соответствии с трудовым договором обязан отработать минимальный рабочий контракт в 10 (десять) стандартных Солнечных лет. <BR>Плохое самочувствие, нечеловеческие рабочие условия, отсутствие выплат заработной платы, некачественные условия проживания, кома, похищение с целью выкупа, разрушение станции, смерть и прочие неуважительные причины не являются поводом для досрочного расторжения контракта. <BR>В случае невозможности продолжения службы по месту приписки, Работник обязан направиться на ближайшую станцию Компании, после чего доложиться о своем прибытии старшему офицеру на станции согласно табелю о рангах, получить официальное назначение и оформить доступ. В случае недоступности или смерти всех членов командования, работник обязан приступить к своим непосредственным обязаностям в соответствии со специальностью."

/obj/item/paper/vip_pasport/Initialize(mapload)
	. = ..()
	if (isnull(stamps))
		stamps = list()
	stamps[++stamps.len] = list("paper121x54 stamp-centcom", 221, 378, 0)


	if (isnull(stamped))
		stamped = list()
	var/mutable_appearance/stampoverlay = mutable_appearance('icons/obj/bureaucracy.dmi', "paper_stamp-centcom")
	stampoverlay.pixel_x = rand(-2, 2)
	stampoverlay.pixel_y = rand(-3, 2)
	add_overlay(stampoverlay)


/datum/antagonist/derelict_vip
	name = "ВИП"
	show_in_antagpanel = TRUE
	roundend_category = "Выжившие"
	antagpanel_category = "Derelict VIP"
	greentext_reward = 25

/datum/antagonist/derelict_vip/proc/forge_objectives()
	var/datum/objective/survive/surv = new
	surv.owner = owner
	objectives += surv

/datum/antagonist/derelict_vip/on_gain()
	forge_objectives()
	. = ..()

/datum/outfit/derelict_vip
	name = "ВИП"

/datum/outfit/derelict_vip/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/paper/vip_pasport/S = H.r_store
	S.name = "Копия трудового договора [H.real_name]"
	S.info = "<center>Копия трудового договора</center><BR><BR> Данный документ подтверждает, что [H.real_name] (далее Работник) является действующим сотрудником компании Нано Трейзен (далее Компания), в соответствии с трудовым договором обязан отработать минимальный рабочий контракт в 10 (десять) стандартных Солнечных лет. <BR>Плохое самочувствие, нечеловеческие рабочие условия, отсутствие выплат заработной платы, некачественные условия проживания, кома, похищение с целью выкупа, разрушение станции, смерть и прочие неуважительные причины не являются поводом для досрочного расторжения контракта. <BR>В случае невозможности продолжения службы по месту приписки, Работник обязан направиться на ближайшую станцию Компании, после чего доложиться о своем прибытии старшему офицеру на станции согласно табелю о рангах, получить официальное назначение и оформить доступ. В случае недоступности или смерти всех членов командования, работник обязан приступить к своим непосредственным обязаностям в соответствии со специальностью."

	return ..()

//=====================
// Инспектор ЦК
//=====================

/datum/antagonist/derelict_vip/inspector
	name = "ВИП - Инспектор ЦК"

/datum/antagonist/derelict_vip/inspector/greet()
	owner.current.playsound_local(get_turf(owner.current), 'white/Feline/sounds/VIP_embient.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)
	to_chat(owner, "<span class='boldannounce'>Я Выживший!</span><br>\
	<B>Группа спасателей уже летит за мной!</B>")
	owner.announce_objectives()
	to_chat(owner, "<span class='notice'>Я официальный инспектор Центрального Командования. Меня направили на эту станцию для проведения \
			следственных мероприятий связанных с крайне подозрительными исследованиями в которых замешано руководство станции. Все что я \
			помню это торжественный обед с привкусом предательства... Не знаю как, но в полубессознательном состоянии я как то смог вызвать \
			подмогу с соседней станции. Главное продержаться до их прибытия, а там... Командование наверное даже и не заметит, что я \
			инспектирую немного другую станцию.")

/datum/outfit/derelict_vip/inspector
	name = "VIP Инспектор ЦК"

	uniform = /obj/item/clothing/under/rank/centcom/officer
	shoes = /obj/item/clothing/shoes/sneakers/black
	gloves = /obj/item/clothing/gloves/color/black
	ears = /obj/item/radio/headset/headset_cent/empty
	glasses = /obj/item/clothing/glasses/sunglasses
	belt = /obj/item/gun/energy/e_gun
	l_pocket = /obj/item/pen
	back = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/reagent_containers/pill/saver/vip = 1, /obj/item/modular_computer/tablet/pda/heads = 1)
	r_pocket = /obj/item/paper/vip_pasport
	l_hand = /obj/item/clipboard
	r_hand = /obj/item/gps
	id = /obj/item/card/id/away/old

//=====================
// ХоС
//=====================

/datum/antagonist/derelict_vip/hos
	name = "ВИП - ХоС"

/datum/antagonist/derelict_vip/hos/greet()
	owner.current.playsound_local(get_turf(owner.current), 'white/Feline/sounds/VIP_embient.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)
	to_chat(owner, "<span class='boldannounce'>Я Выживший!</span><br>\
	<B>Группа спасателей уже летит за мной!</B>")
	owner.announce_objectives()
	to_chat(owner, "<span class='notice'>Я Глава Службы Безопасности этой станции, теперь уже кажется бывший. И все из за этого тупого Капитана! Я же предупреждал \
			его, я говорил что это заговор! А меня объявили параноиком, даже хотели конфисковать личное оружие! Но эти неженки побоялись со мной \
			связываться и продолжили свою тупую грызню за власть. Плевать... Теперь они все мертвы... и это мое поражение... я должен был их защитить, даже если они этому противились... \
			Но больше этого не повторится. Я вызвал команду Рейнджеров с соседней станции, а от захваченного агента Синдиката я узнал, что там \
			затевается, что-то страшное. И в этот раз я справлюсь... СМЕРТЬ СИНДИКАТУ!")

/datum/outfit/derelict_vip/hos
	name = "VIP ХоС"

	uniform = /obj/item/clothing/under/rank/security/head_of_security
	suit = /obj/item/clothing/suit/armor/hos
	suit_store = /obj/item/gun/energy/e_gun
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/combat
	ears = /obj/item/radio/headset
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses/eyepatch
	belt = /obj/item/storage/belt/sabre
	l_pocket = /obj/item/ammo_box/magazine/m45
	r_pocket = /obj/item/paper/vip_pasport
	id = /obj/item/card/id/away/old
	head = /obj/item/clothing/head/hos/beret
	r_hand = /obj/item/gps
	implants = list(/obj/item/implant/mindshield)
	back = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/reagent_containers/pill/saver/vip = 1, /obj/item/gun/ballistic/automatic/pistol/m1911=1, /obj/item/ammo_box/magazine/m45=1, /obj/item/grenade/smokebomb=1)

//=====================
// Ассистент
//=====================

/datum/antagonist/derelict_vip/assistent
	name = "ВИП - Ассистент"

/datum/antagonist/derelict_vip/assistent/greet()
	owner.current.playsound_local(get_turf(owner.current), 'white/Feline/sounds/VIP_embient.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)
	to_chat(owner, "<span class='boldannounce'>Я Выживший!</span><br>\
	<B>Группа спасателей уже летит за мной!</B>")
	owner.announce_objectives()
	to_chat(owner, "<span class='notice'>Бляяять! Что вокруг происходит?! Я вообще прилетел сюда по объявлению о приеме на работу! Я не \
			хочу умирать! По радио сказали что эвакуационного шаттла не будет, но сюда летит группа быстрого реагирования с соседней \
			станции! Я снял бронежилет с мертвого охранника и сделал самопал. Господи только бы не сдохнуть и дождаться спасателей, я \
			буду обязан им по гроб жизни, если они меня отсюда вытащат!")

/datum/outfit/derelict_vip/assistent
	name = "VIP Ассисстент"

	uniform = /obj/item/clothing/under/color/grey/ancient
	suit = /obj/item/clothing/suit/armor/vest
	suit_store = /obj/item/gun/ballistic/shotgun/doublebarrel/improvised
	shoes = /obj/item/clothing/shoes/laceup
	ears = /obj/item/radio/headset
	glasses = /obj/item/clothing/glasses/sunglasses
	belt = /obj/item/storage/belt/bandolier/assistent
	l_pocket = /obj/item/gps
	r_pocket = /obj/item/paper/vip_pasport
	id = /obj/item/card/id
	head = /obj/item/clothing/head/helmet
	mask = /obj/item/clothing/mask/gas
	back = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/reagent_containers/pill/saver/vip = 1, /obj/item/clothing/gloves/color/yellow = 1)
	r_hand = /obj/item/storage/toolbox/mechanical/old


/obj/item/storage/belt/bandolier/assistent/PopulateContents()
	var/static/items_inside = list(
		/obj/item/ammo_casing/shotgun/improvised = 9,
		/obj/item/ammo_casing/shotgun = 9)
	generate_items_inside(items_inside,src)

//=====================
// Инженер
//=====================

/datum/antagonist/derelict_vip/engi
	name = "ВИП - Инженер"

/datum/antagonist/derelict_vip/engi/greet()
	owner.current.playsound_local(get_turf(owner.current), 'white/Feline/sounds/VIP_embient.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)
	to_chat(owner, "<span class='boldannounce'>Я Выживший!</span><br>\
	<B>Группа спасателей уже летит за мной!</B>")
	owner.announce_objectives()
	to_chat(owner, "<span class='notice'>Я заступил на смену в стандартное время, бригадир сказал проверить пробоину оставленную метеоритом. \
	Когда я вернулся бригадира уже доедали. Я успел заблокировать шлюз, а сунувшейся твари проломить голову гаечным ключом. Слава сингулярности \
	пароли от телекомов не успели сменить и я смог отправить сигнал бедствия. Надо заблокировать все подходы и ждать помощи. По условиям контракта \
	меня обязаны спасти. Не зря же я платил профсоюзные взносы. По крайней мере у меня есть РЦД и Гвоздомет.")

/datum/outfit/derelict_vip/engi
	name = "VIP Инженер"

	uniform = /obj/item/clothing/under/rank/engineering/engineer
	mask = /obj/item/clothing/mask/breath
	suit = /obj/item/clothing/suit/space/hardsuit/engine
	suit_store = /obj/item/tank/internals/tactical/nail_gun
	shoes = /obj/item/clothing/shoes/workboots
	ears = /obj/item/radio/headset/headset_eng
	glasses = /obj/item/clothing/glasses/meson
	belt = /obj/item/storage/belt/utility/full/vip_engi
	l_pocket = /obj/item/gps
	r_pocket = /obj/item/paper/vip_pasport
	id = /obj/item/card/id
	skillchips = list(/obj/item/skillchip/job/engineer)
	back =  /obj/item/storage/backpack/industrial
	backpack_contents = list(/obj/item/reagent_containers/pill/saver/vip = 1, /obj/item/stack/sheet/iron/fifty = 1, /obj/item/stack/sheet/glass/fifty = 1, /obj/item/ammo_box/magazine/nails/pve = 1, /obj/item/ammo_box/nail = 1, /obj/item/ammo_box/nail/pve = 1, /obj/item/clothing/gloves/color/yellow = 1)

/obj/item/storage/belt/utility/full/vip_engi/PopulateContents()
	new /obj/item/construction/rcd/loaded(src)
	new /obj/item/screwdriver/power/orange(src)
	new /obj/item/weldingtool/largetank(src)
	new /obj/item/crowbar(src)
	new /obj/item/wirecutters(src)
	new /obj/item/multitool(src)
	new /obj/item/stack/cable_coil(src)

//=====================
// Ученый
//=====================

/datum/antagonist/derelict_vip/sci
	name = "ВИП - Ученый"

/datum/antagonist/derelict_vip/sci/greet()
	owner.current.playsound_local(get_turf(owner.current), 'white/Feline/sounds/VIP_embient.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)
	to_chat(owner, "<span class='boldannounce'>Я Выживший!</span><br>\
	<B>Группа спасателей уже летит за мной!</B>")
	owner.announce_objectives()
	to_chat(owner, "<span class='notice'>Все шло по плану, мы запустили эмиттеры и стали ждать открытия врат, но внезапно поле сдерживания \
	накрылось и эти твари стали лезть наружу! Что за бред?! Все было рассчитано идеально! Превышение порога безопасности было всего лишь на 40%! \
	К счастью я слишком ценный сотрудник и меня обязательно эвакуируют. Меня лично заверили об этом с ЦК. Только почему то с соседней станции\
	тоже вылетел шаттл в нашу сторону. Интересно кто же первым успеет спасти последний светоч разума в этой галактике? Эти недалекие соседи \
	с своими Рейнджерами или же группа с ЦК? У них еще название было такое забавное, как же его там? Эскадрон Смерти?")

/datum/outfit/derelict_vip/sci
	name = "VIP Ученый"

	uniform = /obj/item/clothing/under/rank/rnd/scientist
	suit = /obj/item/clothing/suit/armor/reactive/repulse
	shoes = /obj/item/clothing/shoes/sneakers/white
	ears = /obj/item/radio/headset/headset_sci
	glasses = /obj/item/clothing/glasses/science
	belt = /obj/item/gun/energy/laser/rangers/sci
	l_pocket = /obj/item/gps
	r_pocket = /obj/item/paper/vip_pasport
	id = /obj/item/card/id
	back = /obj/item/storage/backpack/science
	backpack_contents = list(/obj/item/reagent_containers/pill/saver/vip = 1)

//=====================
// Greytide (VIP And Assassination)
//=====================

/datum/outfit/vip_target/greytide
	name = "Greytide (VIP Target)"

	suit = /obj/item/clothing/suit/armor/vest
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/color/yellow
	ears = /obj/item/radio/headset
	glasses = /obj/item/clothing/glasses/sunglasses
	belt = /obj/item/storage/belt/utility/full/engi
	id = /obj/item/card/id
	head = /obj/item/clothing/head/helmet
	l_hand = /obj/item/melee/baton/loaded

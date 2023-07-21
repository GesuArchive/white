/datum/round_aspect
	var/name = "Nothing"
	var/desc = "Ничего."
	var/weight = 150
	var/forbidden = FALSE
	var/high_impact = FALSE
	var/hidden = FALSE //Не палим аспект в начале раунда для большей ржомбы

/datum/round_aspect/proc/run_aspect()
	SSblackbox.record_feedback("tally", "aspect", 1, name) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/datum/round_aspect/random_appearance
	name = "Random appearance"
	desc = "Экипаж перестал узнавать друг-друга в лицо."
	weight = 16

/datum/round_aspect/random_appearance/run_aspect()
	CONFIG_SET(flag/force_random_names, TRUE)
	..()

/datum/round_aspect/bom_bass
	name = "Bombass"
	desc = "Кто-то заложил мины на станции!"
	weight = 14
	high_impact = TRUE

/datum/round_aspect/bom_bass/run_aspect()
	for(var/turf/X in GLOB.xeno_spawn)
		if(istype(X.loc, /area/maintenance))
			if(prob(1))
				new /obj/effect/mine/explosive(X)
	..()

/datum/round_aspect/rpg_loot
	name = "RPG Loot"
	desc = "Наши гениальные учёные достигли таких высот при работе с материалами, что теперь каждый предмет обладает <i>особенными</i> свойствами."
	weight = 4

/datum/round_aspect/rpg_loot/run_aspect()
	var/datum/round_event_control/wizard/rpgloot/D = new()
	D.runEvent()
	..()

/datum/round_aspect/no_matter
	name = "No matter"
	desc = "Какой-то смышлённый агент синдиката решил украсть кристалл суперматерии целиком."
	weight = 30

/datum/round_aspect/no_matter/run_aspect()
	if(GLOB.main_supermatter_engine)
		GLOB.main_supermatter_engine.Destroy()
	..()

/datum/round_aspect/airunlock
	name = "Airunlock"
	desc = "Кого волнует безопасность? Экипаж свободно может ходить по всем отсекам, ведь все шлюзы теперь для них доступны."
	weight = 30
	high_impact = TRUE

/datum/round_aspect/airunlock/run_aspect()
	for(var/obj/machinery/door/D in GLOB.machines)
		D.req_access_txt = "0"
		D.req_one_access_txt = "0"
	..()

/datum/round_aspect/weak_walls
	name = "Weak Walls"
	desc = "На стенах явно экономили."
	weight = 18

/datum/round_aspect/weak_walls/run_aspect()
	for(var/turf/closed/wall/r_wall/RW in world)
		RW.ChangeTurf(/turf/closed/wall, flags = CHANGETURF_INHERIT_AIR)
		CHECK_TICK
	..()

/datum/round_aspect/edison
	name = "Edison"
	desc = "Для ускорения исследований научного отдела лампы на станции теперь потребляют в 10 раз больше энергии."
	weight = 58

/datum/round_aspect/edison/run_aspect()
	for(var/obj/machinery/light/L in world)
		L.idle_power_usage   = L.idle_power_usage   * 10
		L.active_power_usage = L.active_power_usage * 10
		L.power_change()
		CHECK_TICK

	SSresearch.mining_multiplier = 5
	..()

/datum/round_aspect/rainy_shift
	name = "Rainy Shift"
	desc = "Ожидается выпадение обильных осадков."
	weight = 40
	var/area/impact_area
	var/list/possible_pack_types = list()
	var/static/list/rain_spawnable_supply_packs = list()

/datum/round_aspect/rainy_shift/run_aspect()
	start_rain()
	..()

/datum/round_aspect/rainy_shift/proc/start_rain()
	impact_area = find_event_area()
	if(!impact_area)
		CRASH("No valid areas for rain cargo pod found.")
	var/list/turf_test = get_area_turfs(impact_area)
	if(!turf_test.len)
		CRASH("Rain Cargo Pod : No valid turfs found for [impact_area] - [impact_area.type]")

	if(!rain_spawnable_supply_packs.len)
		rain_spawnable_supply_packs = SSshuttle.supply_packs.Copy()
		for(var/pack in rain_spawnable_supply_packs)
			var/datum/supply_pack/pack_type = pack
			if(initial(pack_type.special))
				rain_spawnable_supply_packs -= pack

	var/list/turf/valid_turfs = get_area_turfs(impact_area)
	//Only target non-dense turfs to prevent wall-embedded pods
	for(var/i in valid_turfs)
		var/turf/T = i
		if(T.density)
			valid_turfs -= T
	var/turf/LZ = pick(valid_turfs)
	var/pack_type
	if(possible_pack_types.len)
		pack_type = pick(possible_pack_types)
	else
		pack_type = pick(rain_spawnable_supply_packs)
	var/datum/supply_pack/SP = new pack_type
	var/obj/structure/closet/crate/crate = SP.generate(null)
	crate.locked = FALSE //Unlock secure crates
	crate.update_icon()
	var/obj/structure/closet/supplypod/pod = make_pod()
	new /obj/effect/pod_landingzone(LZ, pod, crate)

	addtimer(CALLBACK(src, PROC_REF(start_rain)), rand(60, 240) SECONDS)

/datum/round_aspect/rainy_shift/proc/make_pod()
	var/obj/structure/closet/supplypod/S = new
	return S

///Picks an area that wouldn't risk critical damage if hit by a pod explosion
/datum/round_aspect/rainy_shift/proc/find_event_area()
	var/static/list/allowed_areas
	if(!allowed_areas)
		///Places that shouldn't explode
		var/list/safe_area_types = typecacheof(list(
		/area/ai_monitored/turret_protected/ai,
		/area/ai_monitored/turret_protected/ai_upload,
		/area/engineering,
		/area/shuttle)
		)

		///Subtypes from the above that actually should explode.
		var/list/unsafe_area_subtypes = typecacheof(list(/area/engineering/break_room))
		allowed_areas = make_associative(GLOB.the_station_areas) - safe_area_types + unsafe_area_subtypes
	var/list/possible_areas = typecache_filter_list(GLOB.areas,allowed_areas)
	if (length(possible_areas))
		return pick(possible_areas)

/datum/round_aspect/rich
	name = "Rich"
	desc = "Экипаж работал усердно в прошлую смену, за что и был награждён премиями в размере 100000 кредитов каждому."
	weight = 24

/datum/round_aspect/rich/run_aspect()
	SSeconomy.bonus_money = 100000
	..()
	for(var/B in SSeconomy.bank_accounts_by_id)
		var/datum/bank_account/A = SSeconomy.bank_accounts_by_id[B]
		A.adjust_money(100000)

/datum/round_aspect/drunk
	name = "Drunk"
	desc = "На станции стоит явный запах вчерашнего веселья... и кажется оно только начинается."
	weight = 36

/datum/round_aspect/drunk/run_aspect()
	for(var/mob/living/carbon/human/H in GLOB.carbon_list)
		if(!H.client)
			continue
		if(H.stat == DEAD)
			continue
		H.drunkenness = 90
	..()

/datum/round_aspect/minecraft
	name = "Minecraft"
	desc = "Сегодня поиграю я в Майнкрафт</br>С рассвета до глубокой ночи.</br>Наружу выходить мне лень, пусть даже там - отличный день."
	weight = 1
	forbidden = TRUE
	high_impact = TRUE

/datum/round_aspect/minecraft/run_aspect()
	var/icon/I = new('white/valtos/icons/minecraft.dmi')
	for(var/turf/open/floor/plasteel/floor)
		floor.icon = I
		floor.icon_state = "stone"
	for(var/turf/open/floor/plasteel/white/floor)
		floor.icon = I
		floor.icon_state = "slab"
	for(var/turf/open/floor/plasteel/dark/floor)
		floor.icon = I
		floor.icon_state = "stone"
	for(var/turf/open/floor/circuit/cir)
		cir.icon = I
		cir.icon_state = "fug"
	for(var/turf/open/floor/plating/plating)
		plating.icon = I
		plating.icon_state = "dirt"
	for(var/turf/open/floor/engine/ef)
		ef.icon = I
		ef.icon_state = "stoneblock"
	for(var/obj/machinery/power/supermatter_crystal/engine/e)
		e.icon = I
		e.icon_state = "ender"
	for(var/turf/closed/wall/wa)
		wa.icon = I
		wa.icon_state = "cobblestone"
		wa.cut_overlays()
	for(var/turf/closed/wall/r_wall/rwa)
		rwa.icon = I
		rwa.icon_state = "obsidian"
		rwa.cut_overlays()
	for(var/turf/closed/wall/mineral/titanium/ti)
		ti.icon = I
		ti.icon_state = "quartz"
		ti.cut_overlays()
	for(var/turf/closed/indestructible/riveted/riv)
		riv.icon = I
		riv.icon_state = "adminium"
		riv.cut_overlays()
	for(var/turf/open/floor/carpet/car)
		car.icon = I
		car.icon_state = "carpet"
		car.cut_overlays()
	for(var/obj/machinery/rnd/production/protolathe/plat)
		plat.icon = I
		plat.icon_state = "furnace"
	for(var/obj/machinery/autolathe/autol)
		autol.icon = I
		autol.icon_state = "craft"
	for(var/obj/machinery/power/solar/solar)
		solar.icon = I
		solar.icon_state = "solar"
	for(var/obj/structure/window/reinforced/fulltile/rw)
		rw.icon = I
		rw.icon_state = "glass"
	for(var/obj/structure/window/fulltile/w)
		w.icon = I
		w.icon_state = "glass"
	for(var/obj/structure/grille/g)
		g.icon = I
		g.icon_state = "fence"
	for(var/obj/machinery/nuclearbomb/selfdestruct/tnt)
		tnt.icon = I
		tnt.icon_state = "tnt"
	for(var/turf/open/floor/wood/p)
		p.icon = I
		p.icon_state = "plank"
	..()

/datum/round_aspect/fast_and_furious
	name = "Fast and Furious"
	desc = "Люди спешат и не важно куда."
	weight = 9
	forbidden = TRUE
	high_impact = TRUE

/datum/round_aspect/fast_and_furious/run_aspect()
	CONFIG_SET(number/movedelay/run_delay, 1)
	..()

/datum/round_aspect/weak
	name = "Weak"
	desc = "Удары стали слабее. Пули мягче. К чему это приведёт?"
	weight = 3
	forbidden = TRUE
	high_impact = TRUE

/datum/round_aspect/weak/run_aspect()
	CONFIG_SET(number/damage_multiplier, 0.5)
	..()

/datum/round_aspect/immortality
	name = "Immortality"
	desc = "Шахтёры притащили неизвестный артефакт дарующий бессмертие и активировали его на станции. Никто не сможет получить достаточных травм, чтобы погибнуть. Наверное."
	weight = 1
	forbidden = TRUE
	hidden =  TRUE

/datum/round_aspect/immortality/run_aspect()
	CONFIG_SET(number/damage_multiplier, 0)
	..()

/datum/round_aspect/bloody
	name = "Bloody"
	desc = "В эту смену любая незначительная травма может оказаться летальной."
	weight = 2
	forbidden = TRUE
	high_impact = TRUE

/datum/round_aspect/bloody/run_aspect()
	CONFIG_SET(number/damage_multiplier, 3)
	..()

/datum/round_aspect/assistants
	name = "Assistants"
	desc = "Критическая масса ассистентов увеличивается с каждой минутой. ЦК решило перенаправить эту нагрузку и на вашу станцию."
	weight = 9
	forbidden = TRUE
	high_impact = TRUE

/datum/controller/subsystem/job/proc/DisableJobsButThis(job_path, hop)
	for(var/I in occupations)
		var/datum/job/J = I
		if(hop)
			if((!istype(J, job_path)) && (!istype(J, /datum/job/head_of_personnel)))
				J.total_positions = 0
				J.spawn_positions = 0
				J.current_positions = 0
			else if(istype(J, /datum/job/head_of_personnel))
				J.total_positions = 1
			else
				J.total_positions = 750
		else
			if(!istype(J, job_path))
				J.total_positions = 0
				J.spawn_positions = 0
				J.current_positions = 0
			else
				J.total_positions = 750

/datum/round_aspect/assistants/run_aspect()
	SSjob.DisableJobsButThis(/datum/job/assistant, TRUE)
	..()

/datum/round_aspect/clowns
	name = "Clowns"
	desc = "ХОНК!"
	weight = 4
	forbidden = TRUE
	high_impact = TRUE

/datum/round_aspect/clowns/run_aspect()
	SSjob.DisableJobsButThis(/datum/job/clown, TRUE)
	..()

/datum/round_aspect/meow
	name = "Cats"
	desc = "Сбой в системе клонирования и очистки памяти на ЦК сделал всех членов экипажа фелинидами."
	weight = 1
	forbidden = TRUE

/datum/round_aspect/meow/run_aspect()
	for(var/M in GLOB.mob_list)
		if(ishuman(M))
			purrbation_apply(M)
		CHECK_TICK
	..()

/datum/round_aspect/battled
	name = "Battled"
	desc = "Люди очень насторожены и готовы дать отпор в любую секунду."
	weight = 8
	forbidden = TRUE
	high_impact = TRUE

/datum/round_aspect/battled/run_aspect()
	SSbtension.forced_tension = TRUE
	spawn(5 SECONDS)
		summon_guns(survivor_probability = 10)
	..()

/datum/round_aspect/tts
	name = "TTS"
	desc = "В эту смену я не только вижу голоса. Я их слышу."
	weight = 16

/datum/round_aspect/tts/run_aspect()
	SStts.tts_enabled = TRUE
	..()

/datum/round_aspect/nogirlssky
	name = "No Girls Sky"
	desc = "Мужской - единственный биологический гендер на станции."
	weight = 10

/datum/round_aspect/nogirlssky/run_aspect()
	for(var/mob/living/carbon/human/M in GLOB.human_list)
		M.gender = MALE
		CHECK_TICK
	..()

/datum/round_aspect/nomanssky // ыыыы
	name = "No Man Sky"
	desc = "Женский - единственный биологический гендер на станции."
	weight = 10

/datum/round_aspect/nomanssky/run_aspect()
	for(var/mob/living/carbon/human/M in GLOB.human_list)
		M.gender = FEMALE
		CHECK_TICK
	..()

/datum/round_aspect/who_is_the_king
	name = "Unlimited"
	desc = "Из-за бюрократической ошибки станция позволяет удерживать в себе неограниченное количество людей на любой должности."
	weight = 5
	high_impact = TRUE

/datum/round_aspect/who_is_the_king/run_aspect()
	SSjob.AllowAllJobs()
	..()

/datum/controller/subsystem/job/proc/AllowAllJobs()
	for(var/I in occupations)
		var/datum/job/J = I
		J.total_positions = 750
		J.spawn_positions = 750

/datum/controller/subsystem/job/proc/DisableAllJobs()
	for(var/I in occupations)
		var/datum/job/J = I
		J.total_positions = 0
		J.spawn_positions = 0

/datum/round_aspect/emergency_meeting
	name = "Emergency Meeting"
	desc = "ЭКСТРЕННЫЙ СБОР!"
	weight = 1
	forbidden = TRUE

/datum/round_aspect/emergency_meeting/run_aspect()
	spawn(5 SECONDS)
		call_emergency_meeting("Центральное Командование", GLOB.areas_by_type[/area/command/meeting_room])
	..()

/datum/round_aspect/emp_ass
	name = "EMP"
	desc = "БЗ-З*/!?*!-"
	weight = 3
	forbidden = TRUE

/datum/round_aspect/emp_ass/run_aspect()
	var/obj/effect/landmark/observer_start/O = locate(/obj/effect/landmark/observer_start) in GLOB.landmarks_list
	if(O)
		empulse(O, 50, 125)
	..()

/datum/round_aspect/oleg
	name = "Oleg"
	desc = "Олег."
	weight = 5
	forbidden = TRUE

/datum/round_aspect/oleg/run_aspect()
	SSjob.forced_name = "Олег"
	spawn(3 SECONDS)
		for(var/mob/living/carbon/human/H in GLOB.mob_list)
			H.fully_replace_character_name(H.real_name, "[SSjob.forced_name] \Roman[SSjob.forced_num]")
			SSjob.forced_num++
	..()

/datum/round_aspect/grifon_kosmonavtov
	name = "Grifon Kosmonavtov"
	desc = "███████ ██████ ███ ███ ███████, █████ ██ ██████████ ███ ███████ █████. █████с █████ёб"
	weight = 5
	forbidden = FALSE

/datum/round_aspect/grifon_kosmonavtov/run_aspect()
	SSjob.forced_name = "TATAR"
	spawn(3 SECONDS)
		for(var/mob/living/carbon/human/H in GLOB.mob_list)
			H.fully_replace_character_name(H.real_name, get_funny_name(3))
			SSjob.forced_num++
	..()
/datum/round_aspect/key
	name = "Key"
	desc = "Ключевые события теперь подпитаны правдой."
	weight = 4
	forbidden = TRUE
	high_impact = TRUE

/datum/round_aspect/key/run_aspect()
	SSjob.forced_name = "KEY"
	spawn(5 SECONDS)
		for(var/mob/living/carbon/human/H in GLOB.mob_list)
			H.fully_replace_character_name(H.real_name, "[H.key]")
			SSjob.forced_num++
	..()

/datum/round_aspect/rdmg
	name = "Random DMG"
	desc = "Везёт же некоторым, а может и не везёт. Наше восприятие искажено до такой степени, что мы можем прожечь себе руку холодным ножом."
	weight = 15
	high_impact = TRUE

/datum/round_aspect/rdmg/run_aspect()
	GLOB.random_damage_goes_on = TRUE
	..()

/datum/round_aspect/fireunlock
	name = "Fireunlock"
	desc = "Пожарные шлюзы украли!"
	weight = 3
	forbidden = TRUE

/datum/round_aspect/fireunlock/run_aspect()
	for(var/obj/machinery/door/firedoor/F in world)
		qdel(F)
	..()

/datum/round_aspect/ihavetwobuttsbutimustseat
	name = "I Have Two Butts But I must Seat"
	desc = "Стулья украли!"
	weight = 5

/datum/round_aspect/ihavetwobuttsbutimustseat/run_aspect()
	for(var/obj/structure/chair/C in world)
		qdel(C)
	..()

/datum/round_aspect/hungry_bin
	name = "Hungry Bin"
	desc = "Мусорки проголодались!"
	weight = 1
	forbidden = TRUE
	hidden = TRUE

/datum/round_aspect/hungry_bin/run_aspect()
	GLOB.disposals_are_hungry = TRUE
	..()

/datum/round_aspect/stolen_floor
	name = "Stolen Floor"
	desc = "Рабочие забыли положить плитку при строительстве станции."
	weight = 4

/datum/round_aspect/stolen_floor/run_aspect()
	for(var/turf/open/floor/P in world)
		if(!is_station_level(P.z))
			continue
		P.ChangeTurf(/turf/open/floor/plating, flags = CHANGETURF_INHERIT_AIR)
		CHECK_TICK
	..()

/datum/round_aspect/strong_floor
	name = "Strong Floor"
	desc = "Пол был кем-то укреплён."
	weight = 3

/datum/round_aspect/strong_floor/run_aspect()
	for(var/turf/open/floor/P in world)
		if(!is_station_level(P.z))
			continue
		P.PlaceOnTop(/turf/open/floor/engine)
		CHECK_TICK
	..()

/datum/round_aspect/are_we_in_dungeon
	name = "Are We In Dungeon"
	desc = "В связи с невероятной хрупкостью окон было решено заменить их на стены."
	weight = 3

/datum/round_aspect/are_we_in_dungeon/run_aspect()
	for(var/obj/structure/window/W in world)
		if(!is_station_level(W.z))
			continue
		var/turf/TT = get_turf(W)
		if(TT)
			if(istype(W, /obj/structure/window/reinforced))
				TT.PlaceOnTop(/turf/closed/wall/r_wall)
			else
				TT.PlaceOnTop(/turf/closed/wall)
			qdel(W)
	for(var/obj/structure/grille/G in world)
		if(!is_station_level(G.z))
			continue
		qdel(G)
		CHECK_TICK
	..()

/datum/round_aspect/trash
	name = "Trash"
	desc = "Субботник начался!"
	weight = 15

/datum/round_aspect/trash/run_aspect()
	for(var/turf/open/P in world)
		if(!is_station_level(P.z))
			continue
		if(prob(5))
			var/pickedtrash = pick_weight(pick_weight(GLOB.trash_loot))
			new pickedtrash(P)
		CHECK_TICK
	..()

/datum/round_aspect/traitored
	name = "Traitored"
	desc = "Кто-то сдал всех предателей!"
	weight = 4
	forbidden = TRUE
	hidden = TRUE

/datum/round_aspect/traitored/run_aspect()
	spawn(40 SECONDS)
		//var/list/uplinks = list()
		var/list/tators = list()

		for(var/datum/mind/baddie in get_antag_minds(/datum/antagonist/traitor))
			//uplinks += baddie.find_syndicate_uplink()
			tators += baddie


		for(var/mob/living/syndie in tators)
			to_chat(syndie, span_alert("Внимание, коммуникации синдиката перехвачены, вас раскрыли!"))
			syndie.playsound_local(get_turf(syndie), 'white/alexs410/sound/palevo.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)

	spawn(rand(20, 300) SECONDS)
		var/list/our_pussies = list()
		var/list/no_announce = list(/datum/antagonist/nukeop,
									/datum/antagonist/wizard,
									/datum/antagonist/wizard_minion,
									/datum/antagonist/nightmare,
									/datum/antagonist/ashwalker,
									/datum/antagonist/rev,
									/datum/antagonist/revenant
									) //Эти антаги не раскрываются
		var/list/sneaky = list(/datum/antagonist/heretic,
								/datum/antagonist/rev/head,
								/datum/antagonist/cult
								) //Эти антаги имеют шанс на НЕРАСКРЫТИЕ
		for(var/D in GLOB.antagonists)
			var/datum/antagonist/A = D

			if(A in no_announce)
				continue
			if(A in sneaky && prob(66))
				continue
			if(A?.name && A?.owner)

				our_pussies += "[A.name] - [A.owner.name] под видом [A.owner.assigned_role][prob(1) ? ". УБЕЙТЕ ЕГО НАХУЙ!" : ""]"

		priority_announce("Прива, я тут немного собрал для вас имён интересных, надеюсь, они вам понадобятся! Список психов: [english_list(our_pussies)]", sender_override = "Апегио Крысус")
	..()

/datum/round_aspect/cursed
	name = "Cursed Words"
	desc = "Ругаться матом - плохо!"
	weight = 2
	forbidden = TRUE

/datum/round_aspect/cursed/run_aspect()
	GLOB.apply_execution_protocol = TRUE
	LAZYADD(GLOB.bad_words, GLOB.ru_ban_words)
	..()

/datum/round_aspect/lfwb
	name = "30XX"
	desc = "Какой сейчас год?!"
	weight = 2

/datum/round_aspect/lfwb/run_aspect()
	change_server_theme("lfwb")
	spawn(3 SECONDS)
		for(var/mob/living/carbon/human/H in GLOB.mob_list)
			var/hrn = H.real_name
			H.fully_replace_character_name(hrn, "[hrn]F") // just for job names trigger
			H.fully_replace_character_name("[hrn]F", hrn)
	..()

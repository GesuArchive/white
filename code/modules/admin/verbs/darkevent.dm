/********************************************************************
ВНИМАНИЕ: Тут у нас абсолютный щиткод, тгуй спизжен и перекручен в крендель
Будет удален после "похорон", так что не бойтесь
Доп приколы, не относящийся к самому вербу, оставлены тут с целях моего удобства и последующего выпила
*********************************************************************/
/client/proc/darknesshelper()
	set name = "Помощник тьмы"
	set desc = "Полуавтоматический помощник в проведении щитспавна!"
	set category = "Адм.Игра"
	var/datum/darknesshelper_menu/tgui  = new(usr)
	tgui.ui_interact(usr)

/datum/darknesshelper_menu
	var/client/holder //листы для конкретных отключений зон, иначе оно может захватить не те зоны
	var/static/list/targetzoneengi = typecacheof(list(
			/area/engineering/main, \
			/area/engineering/storage, \
			/area/engineering/storage_shared, \
			/area/engineering/engine_smes, \
			/area/command/heads_quarters/ce, \
			/area/engineering/manufactory, \
			/area/engineering/atmos/upper, \
			/area/engineering/atmospherics_engine, \
			/area/security/checkpoint/engineering, \
			/area/engineering/atmos
			))
	var/static/list/targetzonemed = typecacheof(list(
			/area/medical/medbay, \
			/area/medical/storage, \
			/area/medical/paramedic, \
			/area/medical/office, \
			/area/medical/surgery, \
			/area/medical/break_room, \
			/area/medical/coldroom, \
			/area/medical/patients_rooms, \
			/area/medical/virology, \
			/area/medical/morgue, \
			/area/medical/pharmacy, \
			/area/medical/surgery, \
			/area/medical/cryo, \
			/area/medical/exam_room, \
			/area/medical/genetics, \
			/area/medical/sleeper, \
			/area/medical/psychology, \
			/area/command/heads_quarters/cmo, \
			/area/security/checkpoint/medical
			))
	var/static/list/targetsputnikV = typecacheof(list(
			/area/ai_monitored/turret_protected
			))
	var/static/list/targetbridge = typecacheof(list(
			/area/command, \
			/area/command/bridge, \
			/area/hallway/primary/central/upload, \
			/area/hallway/secondary/command, \
			/area/command/bridge, \
			/area/command/meeting_room, \
			/area/command/meeting_room/council, \
			/area/command/corporate_showroom, \
			/area/command/heads_quarters/captain
			), only_root_path = TRUE)
	var/static/list/targetbrig = typecacheof(list(
			/area/security/prison, \
			/area/security/processing/cremation, \
			/area/security/detectives_office, \
			/area/security/range, \
			/area/security/execution, \
			/area/security/main, \
			/area/security/brig, \
			/area/security/brig/upper, \
			/area/security/courtroom, \
			/area/command/heads_quarters/hos
			))
	var/static/list/targetdorms = typecacheof(list(
			/area/commons/dorms, \
			/area/commons/fitness
			))
	var/static/list/targetmaint = typecacheof(list(
			/area/maintenance
			))
	var/static/list/targetcargo = typecacheof(list(
			/area/cargo, \
			/area/security/checkpoint/supply
			))
	var/static/list/targetbar = typecacheof(list(
			/area/service/bar, \
			/area/service/theater, \
			/area/service/cafeteria, \
			/area/service/kitchen
			))
	var/static/list/targetholyknigi = typecacheof(list(
			/area/service/library, \
			/area/service/chapel
			))
	var/static/list/targetuborshik = typecacheof(list(
			/area/service/janitor
			))
	var/static/list/targetrnd = typecacheof(list(
			/area/science/breakroom, \
			/area/science/lab, \
			/area/science/xenobiology, \
			/area/science/storage, \
			/area/science/test_area, \
			/area/science/mixing, \
			/area/science/mixing/chamber, \
			/area/science/genetics, \
			/area/science/misc_lab, \
			/area/science/misc_lab/range, \
			/area/science/server, \
			/area/science/explab, \
			/area/science/robotics/lab, \
			/area/science/robotics/mechbay, \
			/area/science/nanite, \
			/area/science/research, \
			/area/command/heads_quarters/rd
			))
	var/static/list/targetmedaway = typecacheof(list(
			/area/medical/abandoned
			))
	var/static/list/targetrndaway = typecacheof(list(
			/area/science/cytology
			))
/datum/darknesshelper_menu/New(user)
	if (istype(user, /client))
		var/client/user_client = user
		holder = user_client
	else
		var/mob/user_mob = user
		holder = user_mob.client

/datum/darknesshelper_menu/ui_state(mob/user)
	return GLOB.admin_state

/datum/darknesshelper_menu/ui_close()
	qdel(src)

/datum/darknesshelper_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DarkEvent")
		ui.open()

/datum/darknesshelper_menu/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("engineering")
			message_admins(span_adminnotice("Инженерный отдел отключен"))
			break_power(targetzoneengi)
			targetzoneengi = null //чистим листы для защиты от повторных нажатий.
		if("medical")
			message_admins(span_adminnotice("Медицинский отдел отключен"))
			break_power(targetzonemed)
			targetzonemed = null
		if("cargo")
			message_admins(span_adminnotice("Отдел снабжения отключен"))
			break_power(targetcargo)
			targetcargo = null
		if("brig")
			message_admins(span_adminnotice("Охранный отдел отключен"))
			break_power(targetbrig)
			targetbrig = null
		if("bridge")
			message_admins(span_adminnotice("Мостик отключен"))
			break_power(targetbridge)
			targetbridge = null
		if("holyknigi")
			message_admins(span_adminnotice("Библиотека+церковь отключена"))
			break_power(targetholyknigi)
			targetholyknigi = null
		if("sputnikV")
			message_admins(span_adminnotice("Спутник ИИ отключен"))
			break_power(targetsputnikV)
			targetsputnikV = null
		if("dorm")
			message_admins(span_adminnotice("Дормитории отключены"))
			break_power(targetdorms)
			targetdorms = null
		if("maint")
			message_admins(span_adminnotice("Все техтонели обесточены"))
			break_power_no_turret(targetmaint)
		if("uborshik")
			message_admins(span_adminnotice("Комната уборщика отключена"))
			break_power(targetuborshik)
			targetuborshik = null
		if("medical_away")
			message_admins(span_adminnotice("Дальний медицинский отсек отключен"))
			break_power(targetmedaway)
			targetmedaway = null
		if("bar")
			message_admins(span_adminnotice("Бар и кухня отключены"))
			break_power(targetbar)
			targetbar = null
		if("rnd")
			message_admins(span_adminnotice("Исследовательский отдел отключен"))
			break_power(targetrnd)
			targetrnd = null
		if("rnd_away")
			message_admins(span_adminnotice("Дальний РнД отключен"))
			break_power(targetrndaway)
			targetrndaway = null

/datum/darknesshelper_menu/proc/break_power(target)
	if(target)
		for(var/obj/machinery/power/apc/C in GLOB.apcs_list)
			var/area/A = C.area
			if(target[A.type])
				C.cell.charge = 0
				C.set_broken()
				new /obj/machinery/porta_turret/deadbrain(C.loc)
		for(var/area/A in GLOB.the_station_areas)
			if(target[A.type])
				A.power_light = FALSE
				A.power_equip = FALSE
				A.power_environ = FALSE

/datum/darknesshelper_menu/proc/break_power_no_turret(target)
	for(var/obj/machinery/power/apc/C in GLOB.apcs_list)
		var/area/A = C.area
		if(target[A.type])
			C.cell.charge = 0
			C.set_broken()
	for(var/area/A in GLOB.the_station_areas)
		if(target[A.type])
			A.power_light = FALSE
			A.power_equip = FALSE
			A.power_environ = FALSE

/obj/machinery/porta_turret/deadbrain //простое решение против непрошенных гостей
	name = "Пространственное искажение"
	desc = "Оно еле ощутимо, но что-то внутри подсказывает, что нужно бежать."
	alpha = 0 //она должна быть невидимой, так что меня остальной её вид не волнует :)
	installation = null
	lethal_projectile = /obj/projectile/beam/laser/braindead
	lethal_projectile_sound = null //я бы добавил сюда смешной звук...
	max_integrity = 50000
	density = FALSE
	mode = TURRET_LETHAL
	uses_stored = FALSE
	always_up = TRUE
	turret_flags = TURRET_FLAG_SHOOT_ALL_REACT
	has_cover = FALSE
	scan_range = 20
	shot_delay = 15
	use_power = NO_POWER_USE
	faction = list("faithless","turret")
	var/def_area

/obj/machinery/porta_turret/deadbrain/ComponentInitialize()
	. = ..()
	AddComponent(/datum/element/empprotection, EMP_PROTECT_SELF | EMP_PROTECT_WIRES)

/obj/machinery/porta_turret/deadbrain/setup()
	var/area/A = get_area(src)
	def_area = A?.type
	return

/obj/machinery/porta_turret/deadbrain/interact(mob/user)
	return

/obj/machinery/porta_turret/deadbrain/assess_perp(mob/living/carbon/human/perp)
	if(istype(get_area(perp), def_area))
		return 10
	return 0

/obj/projectile/beam/laser/braindead
	damage = 0
	name = "тьма"
	projectile_piercing = PASSMOB
	projectile_phasing = (ALL & (~PASSMOB))
	range = 20
	tracer_type = null //снаряд тоже должен быть невидимым, а так же исключаем звуки ОЖОГОВ от телепатического снаряда
	muzzle_type = null
	impact_type = null
	hitsound = null
	hitsound_wall = null
	light_system = NO_LIGHT_SUPPORT
	light_range = 0
	light_power = 0
	alpha = 0
/obj/projectile/beam/laser/braindead/on_hit(atom/target)
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		C.adjustOrganLoss(ORGAN_SLOT_BRAIN, 20, 200)
	if(ismecha(target))
		var/obj/vehicle/V
		for(var/mob/living/hitmob as anything in V.occupants)
			hitmob.adjustOrganLoss(ORGAN_SLOT_BRAIN, 20, 200)
	if(issilicon(target))
		var/mob/living/silicon/S = target
		S.adjustFireLoss(20)


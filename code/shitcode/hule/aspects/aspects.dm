/datum/round_aspect
	var/name = "Nothing"
	var/desc = "Ничего."
	var/weight = 10

/datum/round_aspect/proc/run_aspect()
	SSblackbox.record_feedback("tally", "aspect", 1, name) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/datum/round_aspect/random_appearance
	name = "Random appearance"
	desc = "Экипаж перестал узнавать друг-друга в лицо."
	weight = 3

/datum/round_aspect/random_appearance/run_aspect()
	CONFIG_SET(flag/force_random_names, TRUE)
	..()

/datum/round_aspect/bom_bass
	name = "Bombass"
	desc = "Инженеры схалтурили при строительстве станции и вместо обычного металлического покрытия решили использовать остатки снарядов от противотанковых винтовок, которые уже проявили себя."
	weight = 7

/datum/round_aspect/bom_bass/run_aspect()
	var/expcount = rand(1,4)

	var/list/possible_spawns = list()
	for(var/turf/X in GLOB.xeno_spawn)
		if(istype(X.loc, /area/maintenance))
			possible_spawns += X

	var/i
	for(i=0, i<expcount, i++)
		explosion(pick_n_take(possible_spawns), 7, 14, 21)
	..()

/datum/round_aspect/rpg_loot
	name = "RPG Loot"
	desc = "Наши гениальные учёные достигли таких высот при работе с материалами, что теперь каждый предмет обладает <i>особенными</i> свойствами."
	weight = 2

/datum/round_aspect/rpg_loot/run_aspect()
	new /datum/round_event_control/wizard/rpgloot
	..()

/datum/round_aspect/no_matter
	name = "No matter"
	desc = "Какой-то смышлённый агент синдиката решил украсть кристалл суперматерии целиком."
	weight = 12

/datum/round_aspect/no_matter/run_aspect()
	GLOB.main_supermatter_engine.Destroy()
	..()

/datum/round_aspect/airunlock
	name = "Airunlock"
	desc = "Кого волнует безопасность? Экипаж свободно может ходить по всем отсекам, ведь все шлюзы теперь для них доступны."
	weight = 7

/datum/round_aspect/airunlock/run_aspect()
	for(var/obj/machinery/door/D in GLOB.machines)
		D.req_access_txt = "0"
		D.req_one_access_txt = "0"
	..()

/datum/round_aspect/terraformed
	name = "Terraformed"
	desc = "Продвинутые технологии терраформирования теперь позволяют находиться на Лаваленде без надобности в дыхательных масках."
	weight = 5

/datum/round_aspect/terraformed/run_aspect()
	for(var/turf/open/floor/plating/asteroid/basalt/lava_land_surface/T in world)
		T.initial_gas_mix = OPENTURF_DEFAULT_ATMOS
		T.air.copy_from_turf(src)
	for(var/turf/open/lava/T in world)
		T.initial_gas_mix = OPENTURF_DEFAULT_ATMOS
		T.air.copy_from_turf(src)
	for(var/turf/closed/mineral/random/T in world)
		T.initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	..()

/datum/round_aspect/rich
	name = "Rich"
	desc = "Экипаж работал усердно в прошлую смену, за что и был награждён премиями в размере 5000 кредитов каждому."
	weight = 9

/datum/round_aspect/rich/run_aspect()
	for(var/datum/bank_account/department/D in SSeconomy.generated_accounts)
		D.adjust_money(5000)
	..()

/datum/round_aspect/drunk
	name = "Drunk"
	desc = "На станции стоит явный запах вчерашнего веселья... и кажется оно только начинается."
	weight = 11

/datum/round_aspect/drunk/run_aspect()
	for(var/mob/living/carbon/human/H in GLOB.carbon_list)
		if(!H.client)
			continue
		if(H.stat == DEAD)
			continue
		H.drunkenness = 50
	..()

/datum/round_aspect/prikol
	name = "Prikol"
	desc = "Произошел Правий Сиктор."
	weight = 1

/datum/round_aspect/prikol/run_aspect()
	for(var/turf/open/floor/plasteel/floor)
		if(floor.x % 2 == 0 && floor.y % 2 == 0)
			floor.add_atom_colour(("#FFF200"), WASHABLE_COLOUR_PRIORITY)
		else
			floor.add_atom_colour(("#00B7EF"), WASHABLE_COLOUR_PRIORITY)
	..()

/*
/datum/round_aspect/power_failure
	name = "Power Failure"
	weight = 4

/datum/round_aspect/power_failure/run_aspect()
	for(var/obj/machinery/power/smes/S in GLOB.machines)
		if(istype(get_area(S), /area/ai_monitored/turret_protected) || !is_station_level(S.z) || istype(get_area(S), /area/tcommsat/server))
			continue
		S.charge = 0
		S.output_level = 0
		S.output_attempt = FALSE
		S.update_icon()
		S.power_change()

	for(var/area/A in GLOB.the_station_areas)
		if(!A.requires_power || A.always_unpowered || istype(A, /area/tcommsat/server))
			continue
		if(GLOB.typecache_powerfailure_safe_areas[A.type])
			continue

		A.power_light = FALSE
		A.power_equip = FALSE
		A.power_environ = FALSE
		A.power_change()

	for(var/obj/machinery/power/apc/C in GLOB.apcs_list)
		if(istype(get_area(C), /area/ai_monitored/turret_protected) || istype(get_area(C), /area/tcommsat/server))
			continue
		if(C.cell && is_station_level(C.z))
			var/area/A = C.area
			if(GLOB.typecache_powerfailure_safe_areas[A.type])
				continue

			C.cell.charge = 0

	..()
*/

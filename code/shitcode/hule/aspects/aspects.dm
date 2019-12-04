/datum/round_aspect
	var/name = "Nothing"
	var/desc = "Ничего."
	var/weight = 26

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
	desc = "Инженеры схалтурили при строительстве станции и вместо обычного металлического покрытия решили использовать остатки снарядов от противотанковых винтовок, которые уже проявили себя."
	weight = 14

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
	GLOB.main_supermatter_engine.Destroy()
	..()

/datum/round_aspect/airunlock
	name = "Airunlock"
	desc = "Кого волнует безопасность? Экипаж свободно может ходить по всем отсекам, ведь все шлюзы теперь для них доступны."
	weight = 20

/datum/round_aspect/airunlock/run_aspect()
	for(var/obj/machinery/door/D in GLOB.machines)
		D.req_access_txt = "0"
		D.req_one_access_txt = "0"
	..()

/datum/round_aspect/terraformed
	name = "Terraformed"
	desc = "Продвинутые технологии терраформирования озеленили Лаваленд."
	weight = 18

/datum/round_aspect/terraformed/run_aspect()
	for(var/turf/open/floor/plating/asteroid/basalt/lava_land_surface/T in world)
		T.ChangeTurf(/turf/open/floor/plating/grass, flags = CHANGETURF_DEFER_CHANGE)
	for(var/turf/open/lava/T in world)
		T.ChangeTurf(/turf/open/floor/plating/beach/water, flags = CHANGETURF_DEFER_CHANGE)
	for(var/turf/closed/mineral/T in world)
		T.turf_type = /turf/open/floor/plating/grass
		T.baseturfs = /turf/open/floor/plating/grass
		T.initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	..()

/datum/round_aspect/rich
	name = "Rich"
	desc = "Экипаж работал усердно в прошлую смену, за что и был награждён премиями в размере 10000 кредитов каждому."
	weight = 24

/datum/round_aspect/rich/run_aspect()
	for(var/datum/bank_account/D in SSeconomy.bank_accounts)
		D._adjust_money(10000)
	..()

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

/datum/round_aspect/minecraft
	name = "Minecraft"
	desc = "Сегодня поиграю я в Майнкрафт</br>С рассвета до глубокой ночи.</br>Наружу выходить мне лень, пусть даже там - отличный день."
	weight = 1

/datum/round_aspect/minecraft/run_aspect()
	for(var/turf/open/floor/plasteel/floor)
		floor.icon = 'code/shitcode/valtos/icons/minecraft.dmi'
		floor.icon_state = "stone"
	for(var/turf/open/floor/plasteel/white/floor)
		floor.icon = 'code/shitcode/valtos/icons/minecraft.dmi'
		floor.icon_state = "slab"
	for(var/turf/open/floor/plasteel/dark/floor)
		floor.icon = 'code/shitcode/valtos/icons/minecraft.dmi'
		floor.icon_state = "stone"
	for(var/turf/open/floor/circuit/cir)
		cir.icon = 'code/shitcode/valtos/icons/minecraft.dmi'
		cir.icon_state = "fug"
	for(var/turf/open/floor/plating/plating)
		plating.icon = 'code/shitcode/valtos/icons/minecraft.dmi'
		plating.icon_state = "dirt"
	for(var/turf/open/floor/engine/ef)
		ef.icon = 'code/shitcode/valtos/icons/minecraft.dmi'
		ef.icon_state = "stoneblock"
	for(var/obj/machinery/power/supermatter_crystal/engine/e)
		e.icon = 'code/shitcode/valtos/icons/minecraft.dmi'
		e.icon_state = "ender"
	for(var/turf/closed/wall/wa)
		wa.icon = 'code/shitcode/valtos/icons/minecraft.dmi'
		wa.icon_state = "cobblestone"
		wa.cut_overlays()
	for(var/turf/closed/wall/r_wall/rwa)
		rwa.icon = 'code/shitcode/valtos/icons/minecraft.dmi'
		rwa.icon_state = "obsidian"
		rwa.cut_overlays()
	for(var/turf/closed/wall/mineral/titanium/ti)
		ti.icon = 'code/shitcode/valtos/icons/minecraft.dmi'
		ti.icon_state = "quartz"
		ti.cut_overlays()
	for(var/turf/closed/indestructible/riveted/riv)
		riv.icon = 'code/shitcode/valtos/icons/minecraft.dmi'
		riv.icon_state = "adminium"
		riv.cut_overlays()
	for(var/turf/open/floor/carpet/car)
		car.icon = 'code/shitcode/valtos/icons/minecraft.dmi'
		car.icon_state = "carpet"
		car.cut_overlays()
	for(var/obj/machinery/rnd/production/protolathe/plat)
		plat.icon = 'code/shitcode/valtos/icons/minecraft.dmi'
		plat.icon_state = "furnace"
	for(var/obj/machinery/autolathe/autol)
		autol.icon = 'code/shitcode/valtos/icons/minecraft.dmi'
		autol.icon_state = "craft"
	for(var/obj/machinery/power/solar/solar)
		solar.icon = 'code/shitcode/valtos/icons/minecraft.dmi'
		solar.icon_state = "solar"
	for(var/obj/structure/window/reinforced/fulltile/rw)
		rw.icon = 'code/shitcode/valtos/icons/minecraft.dmi'
		rw.icon_state = "glass"
	for(var/obj/structure/window/fulltile/w)
		w.icon = 'code/shitcode/valtos/icons/minecraft.dmi'
		w.icon_state = "glass"
	for(var/obj/structure/grille/g)
		g.icon = 'code/shitcode/valtos/icons/minecraft.dmi'
		g.icon_state = "fence"
	for(var/obj/machinery/nuclearbomb/selfdestruct/tnt)
		tnt.icon = 'code/shitcode/valtos/icons/minecraft.dmi'
		tnt.icon_state = "tnt"
	for(var/turf/open/floor/wood/p)
		p.icon = 'code/shitcode/valtos/icons/minecraft.dmi'
		p.icon_state = "plank"
	..()

/datum/round_aspect/fast_and_furious
	name = "Fast and Furious"
	desc = "Люди спешат и не важно куда."
	weight = 26

/datum/round_aspect/fast_and_furious/run_aspect()
	CONFIG_SET(number/movedelay/run_delay, 1)
	..()

/datum/round_aspect/weak
	name = "Weak"
	desc = "Удары стали слабее. Пули мягче. К чему это приведёт?"
	weight = 18

/datum/round_aspect/weak/run_aspect()
	CONFIG_SET(number/damage_multiplier, 0.5)
	..()

/datum/round_aspect/immortality
	name = "Immortality"
	desc = "Шахтёры притащили неизвестный артефакт дарующий бессмертие и активировали его на станции. Никто не сможет получить достаточных травм, чтобы погибнуть. Наверное."
	weight = 8

/datum/round_aspect/immortality/run_aspect()
	CONFIG_SET(number/damage_multiplier, 0)
	..()

/datum/round_aspect/bloody
	name = "Bloody"
	desc = "В эту смену любая незначительная травма может оказаться летальной."
	weight = 6

/datum/round_aspect/bloody/run_aspect()
	CONFIG_SET(number/damage_multiplier, 3)
	..()

/datum/round_aspect/assistants
	name = "Assistants"
	desc = "Критическая масса ассистентов увеличивается с каждой минутой. ЦК решило перенаправить эту нагрузку и на вашу станцию."
	weight = 16

/datum/controller/subsystem/job/proc/DisableJobsButThis(job_path)
	for(var/I in occupations)
		var/datum/job/J = I
		if(!istype(J, job_path))
			J.total_positions = 0
			J.spawn_positions = 0
			J.current_positions = 0
		else
			J.total_positions = 750

/datum/round_aspect/assistants/run_aspect()
	SSjob.DisableJobsButThis(/datum/job/assistant)
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

/datum/orbital_objective/nuclear_bomb
	name = "Ядерное Правосудие"
	var/generated = FALSE
	//The blackbox required to recover.
	var/obj/machinery/nuclearbomb/decomission/nuclear_bomb
	var/obj/item/disk/nuclear/decommission/nuclear_disk
	//Relatively easy mission.
	min_payout = 8 * CARGO_CRATE_VALUE
	max_payout = 20 * CARGO_CRATE_VALUE

/datum/orbital_objective/nuclear_bomb/generate_objective_stuff(turf/chosen_turf)
	generated = TRUE
	nuclear_disk = new(chosen_turf)
	nuclear_bomb.target_z = chosen_turf.z
	nuclear_bomb.linked_objective = src

/datum/orbital_objective/nuclear_bomb/get_text()
	. = "Аванпост [station_name] требует немедленного уничтожения, так как хранит в себе информацию, которая не должна попасть в руки прессы. Добудьте диск ядерной аутентификации на аванпосте и взорвите там бомбу, которую мы доставили на ваш мостик."
	if(linked_beacon)
		. += " Станция находится в локации [linked_beacon.name]. Успехов."

/datum/orbital_objective/nuclear_bomb/on_assign(obj/machinery/computer/objective/objective_computer)
	var/area/A = GLOB.areas_by_type[/area/command]
	var/turf/open/T = pick(A.get_unobstructed_turfs())
	if(!T)
		T = locate() in shuffle(A.contents)
	nuclear_bomb = new /obj/machinery/nuclearbomb/decomission(T)

/datum/orbital_objective/nuclear_bomb/check_failed()
	if((!QDELETED(nuclear_bomb) && !QDELETED(nuclear_disk) && !QDELETED(linked_beacon)) || !generated)
		return FALSE
	return TRUE

//==============
//The disk
//==============

/obj/item/disk/nuclear/decommission
	name = "устаревший диск ядерной аутентификации"
	desc = "Старый, изношенный диск, используемый в устаревшей ядерной боеголовке X-7. Нанотрейзен больше не использует эту модель аутентификации из-за ее плохой безопасности."
	fake = TRUE

/obj/item/disk/nuclear/decommission/ComponentInitialize()
	AddComponent(/datum/component/gps, "AUTH0", TRUE)

//==============
//The bomb
//==============

GLOBAL_LIST_EMPTY(decomission_bombs)

/obj/machinery/nuclearbomb/decomission
	desc = "Ядерная бомба для уничтожения станций. Использует старую версию дисков ядерной аутентификации."
	proper_bomb = FALSE
	var/datum/orbital_objective/nuclear_bomb/linked_objective
	var/target_z

/obj/machinery/nuclearbomb/decomission/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/gps, "BOMB0", TRUE)

/obj/machinery/nuclearbomb/decomission/Initialize()
	. = ..()
	GLOB.decomission_bombs += src
	r_code = "[rand(10000, 99999)]"
	print_command_report("Код взрыва ядерной бомбы: [r_code]")
	var/obj/structure/closet/supplypod/bluespacepod/pod = new()
	pod.explosionSize = list(0,0,0,4)
	new /obj/effect/pod_landingzone(get_turf(src), pod)
	forceMove(pod)

/obj/machinery/nuclearbomb/decomission/Destroy()
	. = ..()
	GLOB.decomission_bombs -= src

/obj/machinery/nuclearbomb/decomission/process()
	if(z != target_z)
		timing = FALSE
		detonation_timer = null
		countdown?.stop()
		update_icon()
		return
	. = ..()

/obj/machinery/nuclearbomb/decomission/disk_check(obj/item/disk/nuclear/D)
	if(istype(D, /obj/item/disk/nuclear/decommission))
		return TRUE
	return FALSE

/obj/machinery/nuclearbomb/decomission/set_safety()
	safety = !safety
	if(safety)
		timing = FALSE
		detonation_timer = null
		countdown.stop()
	update_icon()

/obj/machinery/nuclearbomb/decomission/set_active()
	if(safety)
		to_chat(usr, span_danger("Механизм безопасности включен."))
		return
	timing = !timing
	if(timing)
		detonation_timer = world.time + (timer_set * 10)
		countdown.start()
		priority_announce("Ядерная бомба была запущена в отдалённом секторе, будьте осторожны.",null, 'sound/misc/notice1.ogg', "Priority")
	else
		detonation_timer = null
		countdown.stop()
	update_icon()

/obj/machinery/nuclearbomb/decomission/explode()
	if(z != target_z)
		timing = FALSE
		detonation_timer = null
		countdown?.stop()
		update_icon()
		return
	. = ..()

/obj/machinery/nuclearbomb/decomission/actually_explode()
	SSticker.roundend_check_paused = FALSE
	linked_objective.complete_objective()
	grab_dat_fence(target_z)
	QDEL_NULL(linked_objective.linked_beacon)
	qdel(src)

//big thanks to ninja and ma44 on coderbus for solving my autism
/obj/item/circuitboard/machine/bluespace_miner //MODULARISE IT BECAUSE ITS AUTISM TO REMOVE IF SOMEBODY WANTS TO DISABLE IT EASILY
	name = "Блюспейс майнер (Оборудование)"
	build_path = /obj/machinery/mineral/bluespace_miner
	req_components = list(
		/obj/item/stock_parts/matter_bin = 3,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/manipulator = 3,
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stack/ore/bluespace_crystal = 3,
		/obj/item/stack/sheet/mineral/gold = 1,
		/obj/item/stack/sheet/mineral/uranium = 1)
	needs_anchored = FALSE

/datum/techweb_node/bluemining
	id = "bluemining"
	display_name = "Блюспейс майнинг технология"
	description = "С помощью технологии сжатия Bluespace-Assisted A.S.S можно добывать ресурсы."
	prereq_ids = list("practical_bluespace")
	design_ids = list("bluemine")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 10000)

/datum/design/bluemine
	name = "Блюспейс майнинг"
	desc = "Благодаря совместным усилиям Bluespace-A.S.S Technologies теперь можно добывать тонкую струйку ресурсов с помощью Блюспейс магии..."
	id = "bluemine"
	build_type = PROTOLATHE
	materials = list(/datum/material/gold = 500, /datum/material/silver = 500, /datum/material/bluespace = 500) //quite cheap, for more convenience
	build_path = /obj/item/circuitboard/machine/bluespace_miner
	category = list("Телепортация")

/obj/machinery/mineral/bluespace_miner
	name = "блюспейс майнер"
	desc = "Машина, которая использует магию Bluespace для медленного создания материалов и добавления их в связанный бункер руды.."
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "stacker"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/bluespace_miner
	layer = BELOW_OBJ_LAYER
	idle_power_usage = 2000
	var/list/ores = list(/datum/material/iron = 600, /datum/material/glass = 600, /datum/material/plasma = 400,  /datum/material/silver = 400, /datum/material/gold = 250, /datum/material/titanium = 250, /datum/material/uranium = 250, /datum/material/bananium = 90, /datum/material/diamond = 90, /datum/material/bluespace = 90)
	var/datum/component/remote_materials/materials
	var/debugging = 0
	var/mine_rate = 1

/obj/machinery/mineral/bluespace_miner/RefreshParts()
	var/tot_rating = 0
	for(var/obj/item/stock_parts/SP in src)
		tot_rating += SP.rating
	mine_rate = tot_rating

/obj/machinery/mineral/bluespace_miner/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSmachines, src)
	materials = AddComponent(/datum/component/remote_materials, "bsm", mapload)

/obj/machinery/mineral/bluespace_miner/Destroy()
	materials = null
	STOP_PROCESSING(SSmachines, src)
	return ..()

/obj/machinery/mineral/bluespace_miner/multitool_act(mob/living/user, obj/item/multitool/I)
	. = ..()
	if (istype(I))
		to_chat(user, "<span class='notice'>Обновляю буфер майнера буфером мультитула.</span>")
		materials?.silo = I.buffer
		return TRUE
	else
		to_chat(user, "<span class='notice'>Буфер пуст.</span>")
		return FALSE

/obj/machinery/mineral/bluespace_miner/examine(mob/user)
	. = ..()
	. += "<hr>"
	. += "<span class='notice'>Скорость сбора ресурсов [mine_rate]</span>"
	if(!materials?.silo)
		. += "\n<span class='notice'>Бункер для руды не подключен. Используйте многофункциональный инструмент, чтобы связать бункер для руды с этой машиной.</span>"
	else if(materials?.on_hold())
		. += "\n<span class='warning'>Доступ к рудным бункерам заблокирован, обратитесь к завхозу.</span>"

/obj/machinery/mineral/bluespace_miner/process()
	if(!materials?.silo || materials?.on_hold())
		return
	var/datum/component/material_container/mat_container = materials.mat_container
	if(!mat_container || panel_open || !powered())
		return
	var/datum/material/ore = pick(ores)
	materials.mat_container.insert_amount_mat(rand(5, 9) * mine_rate, ore)
	if(debugging == 1)
		materials.mat_container.insert_amount_mat(10000, /datum/material/iron)

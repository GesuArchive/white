//big thanks to ninja and ma44 on coderbus for solving my autism
/obj/item/circuitboard/machine/bluespace_miner
	name = "блюспейс майнер"
	desc = "Машина, которая использует блюспейс магию для медленного создания ресурсов и перемещает их в связанный рудный бункер."
	build_path = /obj/machinery/mineral/bluespace_miner
	req_components = list(
		/obj/item/stock_parts/matter_bin = 3,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/manipulator = 3,
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stack/ore/bluespace_crystal = 3)
	needs_anchored = FALSE

/obj/machinery/mineral/bluespace_miner
	name = "блюспейс майнер"
	desc = "Машина, которая использует блюспейс магию для медленного создания ресурсов и перемещает их в связанный рудный бункер."
	icon = 'white/valtos/icons/power.dmi'
	icon_state = "bsm_idle"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/bluespace_miner
	layer = BELOW_OBJ_LAYER
	var/list/ores = list(
			/datum/material/iron = 600,
			/datum/material/glass = 600,
			/datum/material/plasma = 400,
			/datum/material/silver = 400,
			/datum/material/gold = 250,
			/datum/material/titanium = 250,
			/datum/material/uranium = 250,
			/datum/material/bananium = 90,
			/datum/material/diamond = 90,
			/datum/material/bluespace = 90
		)
	var/datum/component/remote_materials/materials
	var/mine_rate = 1

/obj/machinery/mineral/bluespace_miner/update_icon_state()
	if(panel_open)
		icon_state = "bsm_t"
	else if(!powered())
		icon_state = "bsm_off"
	else if(!materials?.silo || materials?.on_hold())
		icon_state = "bsm_idle"
	else
		icon_state = "bsm_on"

/obj/machinery/mineral/bluespace_miner/RefreshParts()
	. = ..()
	var/tot_rating = 0
	for(var/obj/item/stock_parts/SP in src)
		tot_rating += SP.rating
	mine_rate = tot_rating

/obj/machinery/mineral/bluespace_miner/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSmachines, src)
	materials = AddComponent(/datum/component/remote_materials, "bsm", mapload)

	var/datum/component/soundplayer/SP = AddComponent(/datum/component/soundplayer)
	SP.prefs_toggle_flag = null
	SP.set_sound(sound('white/valtos/sounds/blueminer_loop.ogg'))
	SP.set_channel(open_sound_channel_for_boombox())
	SP.playing_volume = 100
	SP.playing_range = 14
	SP.playing_falloff = 1
	SP.active = TRUE

/obj/machinery/mineral/bluespace_miner/Destroy()
	materials = null
	STOP_PROCESSING(SSmachines, src)
	return ..()

/obj/machinery/mineral/bluespace_miner/multitool_act(mob/living/user, obj/item/multitool/I)
	. = ..()
	if (istype(I))
		to_chat(user, span_notice("Обновляю буфер майнера буфером мультитула."))
		materials?.silo = I.buffer
		return TRUE
	else
		to_chat(user, span_notice("Буфер пуст."))
		return FALSE

/obj/machinery/mineral/bluespace_miner/examine(mob/user)
	. = ..()
	. += "<hr>"
	. += span_notice("Скорость сбора ресурсов [mine_rate]")
	if(!materials?.silo)
		. += span_notice("\nБункер для руды не подключен. Используйте многофункциональный инструмент, чтобы связать бункер для руды с этой машиной.")
	else if(materials?.on_hold())
		. += span_warning("\nДоступ к рудным бункерам заблокирован, обратитесь к завхозу.")

/obj/machinery/mineral/bluespace_miner/attackby(obj/item/O, mob/user, params)
	if(user.a_intent == INTENT_HARM)
		return ..()

	if(default_deconstruction_screwdriver(user, "bsm_t", "bsm_off", O))
		update_icon_state()
		return

/obj/machinery/mineral/bluespace_miner/process()
	if(!materials?.silo || materials?.on_hold())
		update_icon_state()
		return

	var/datum/component/material_container/mat_container = materials.mat_container
	if(!mat_container || panel_open || !powered())
		update_icon_state()
		return

	var/datum/material/ore = pick_weight(ores)
	if(!mat_container.can_hold_material(ore))
		WARNING("Валера, твой блюспейс майнер опять обосрался!!! Причина: [ore]")
		return

	materials.mat_container.insert_amount_mat(mine_rate, ore)
	update_icon_state()

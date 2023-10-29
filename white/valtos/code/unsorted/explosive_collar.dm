/obj/item/clothing/neck/explosive_collar
	name = "взрывающийся ошейник"
	desc = "Лучше не трогать это руками."
	icon = 'white/valtos/icons/clothing/necks.dmi'
	worn_icon = 'white/valtos/icons/clothing/mob/neck.dmi'

	icon_state = "bombcollaroff"
	worn_icon_state = "bombcollaroff"

	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	item_flags = DROPDEL

	var/primed = FALSE
	var/condition_for_release_text = "Ждать смерти"
	var/scheduled_explosion_time = 0
	var/mob/living/carbon/human/slave

/obj/item/clothing/neck/explosive_collar/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)

/obj/item/clothing/neck/explosive_collar/examine(mob/user)
	. = ..()
	if(scheduled_explosion_time)
		. += "<hr><span class='deadsay'>Ошейник взорвётся в [time2text(scheduled_explosion_time, "hh:mm:ss")].</span>"

/obj/item/clothing/neck/explosive_collar/equipped(mob/user, slot)
	. = ..()
	slave = user
	activate()

/obj/item/clothing/neck/explosive_collar/update_icon()
	. = ..()
	icon_state = primed ? "bombcollaron" : "bombcollaroff"
	worn_icon_state = primed ? "bombcollaron" : "bombcollaroff"

/obj/item/clothing/neck/explosive_collar/proc/explode()
	SEND_SOUND(slave, 'white/valtos/sounds/timerring.ogg')
	say("Условия не соблюдены.")
	spawn(1 SECONDS)
		if(istype(slave))
			var/obj/item/bodypart/BP = slave.get_bodypart(BODY_ZONE_HEAD)
			if(BP)
				new /obj/effect/gibspawner/generic(get_turf(slave), slave)
				BP.dismember(BRUTE)
				BP.drop_organs()
				qdel(BP)
				slave.regenerate_icons()
			explosion(src, devastation_range = -1, heavy_impact_range = -1, flame_range = 1)
		visible_message(span_danger("Голова [slave] взрывается!"))
		qdel(src)

/obj/item/clothing/neck/explosive_collar/proc/deactivate()
	REMOVE_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)
	primed = FALSE
	slave = null
	update_icon()
	say("Условия соблюдены.")
	if(istype(slave))
		slave.dropItemToGround(src)

	STOP_PROCESSING(SSobj, src)

/obj/item/clothing/neck/explosive_collar/proc/activate(time_until_explosion = 30 MINUTES)
	if(primed)
		return
	primed = TRUE
	if(condition_for_release_text)
		say("Условия освобождения: [condition_for_release_text].")

	START_PROCESSING(SSobj, src)

	update_icon()

/obj/item/clothing/neck/explosive_collar/process()
	if(world.time >= scheduled_explosion_time)
		switch(condition_is_fullfilled())
			if(null)
				return PROCESS_KILL
			if(TRUE)
				deactivate()
			if(FALSE)
				explode()

/obj/item/clothing/neck/explosive_collar/proc/condition_is_fullfilled()
	return null

/obj/item/clothing/neck/explosive_collar/engineer
	var/time_until_explosion = 30 MINUTES
	condition_for_release_text = "Большая часть энергощитков должна быть заряжена"

/obj/item/clothing/neck/explosive_collar/engineer/activate()
	scheduled_explosion_time = time_until_explosion + world.time
	..()

/obj/item/clothing/neck/explosive_collar/engineer/condition_is_fullfilled()
	return check_station_charge()

/proc/check_station_charge()
	var/const/apc_req_charge = 51
	var/total_apcs = 0
	var/charged_apcs = 0
	for(var/obj/machinery/power/apc/some_apc in GLOB.machines)
		if(some_apc.cell && is_station_level(some_apc.z))
			total_apcs++
			var/const/minimum_power_cell_charge_percent = 80
			if(some_apc.cell?.percent() > minimum_power_cell_charge_percent || some_apc.charging)
				charged_apcs++
	return (100 * charged_apcs / total_apcs) >= apc_req_charge

/obj/item/clothing/neck/explosive_collar/assistant
	var/time_until_explosion = 30 MINUTES
	condition_for_release_text = "Найти работу"

/obj/item/clothing/neck/explosive_collar/assistant/activate()
	scheduled_explosion_time = time_until_explosion + world.time
	..()

/obj/item/clothing/neck/explosive_collar/assistant/condition_is_fullfilled()
	if(slave.wear_id)
		var/obj/item/card/id/our_id = slave.wear_id.GetID()
		if(our_id.assignment != JOB_ASSISTANT && our_id.registered_name == slave.real_name)
			return TRUE
	return FALSE

/obj/item/clothing/neck/explosive_collar/shaft_miner
	var/time_until_explosion = 30 MINUTES
	condition_for_release_text = "Накопать как можно больше руды"

/obj/item/clothing/neck/explosive_collar/shaft_miner/activate()
	scheduled_explosion_time = time_until_explosion + world.time
	..()

/obj/item/clothing/neck/explosive_collar/shaft_miner/condition_is_fullfilled()
	if(GLOB.ore_silo_default)
		var/obj/machinery/ore_silo/OS = GLOB.ore_silo_default
		var/datum/component/material_container/materials = OS.GetComponent(/datum/component/material_container)
		for(var/MAT in materials.materials)
			if(istype(MAT, /datum/material/bananium))
				continue
			if(materials.materials[MAT] <= 1999)
				return FALSE
			return TRUE
	return FALSE

/datum/smite/motivate_engineer
	name = "Motivate Engineer"

/datum/smite/motivate_engineer/effect(client/user, mob/living/target)
	. = ..()
	var/time_limit = input("Сколько минут даём:", "После истечения таймера будет проверка", 30) as num|null

	if(time_limit && ishuman(target))
		var/obj/item/clothing/neck/explosive_collar/engineer/collar = new /obj/item/clothing/neck/explosive_collar/engineer(target)
		collar.time_until_explosion = time_limit MINUTES
		var/mob/living/carbon/human/H = target
		var/obj/item/I = H.get_item_by_slot(ITEM_SLOT_NECK)
		if(I)
			H.dropItemToGround(I)
		H.equip_to_appropriate_slot(collar, TRUE)

/datum/smite/motivate_assistant
	name = "Motivate Assistant"

/datum/smite/motivate_assistant/effect(client/user, mob/living/target)
	. = ..()
	var/time_limit = input("Сколько минут даём:", "После истечения таймера будет проверка", 30) as num|null

	if(time_limit && ishuman(target))
		var/obj/item/clothing/neck/explosive_collar/assistant/collar = new /obj/item/clothing/neck/explosive_collar/assistant(target)
		collar.time_until_explosion = time_limit MINUTES
		var/mob/living/carbon/human/H = target
		var/obj/item/I = H.get_item_by_slot(ITEM_SLOT_NECK)
		if(I)
			H.dropItemToGround(I)
		H.equip_to_appropriate_slot(collar, TRUE)

/datum/smite/motivate_miner
	name = "Motivate Miner"

/datum/smite/motivate_miner/effect(client/user, mob/living/target)
	. = ..()
	var/time_limit = input("Сколько минут даём:", "После истечения таймера будет проверка", 30) as num|null

	if(time_limit && ishuman(target))
		var/obj/item/clothing/neck/explosive_collar/shaft_miner/collar = new /obj/item/clothing/neck/explosive_collar/shaft_miner(target)
		collar.time_until_explosion = time_limit MINUTES
		var/mob/living/carbon/human/H = target
		var/obj/item/I = H.get_item_by_slot(ITEM_SLOT_NECK)
		if(I)
			H.dropItemToGround(I)
		H.equip_to_appropriate_slot(collar, TRUE)

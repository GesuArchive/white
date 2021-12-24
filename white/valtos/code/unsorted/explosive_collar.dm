/obj/item/clothing/neck/explosive_collar
	name = "взрывающийся ошейник"
	desc = "Лучше не трогать это руками."
	icon = 'white/valtos/icons/clothing/necks.dmi'
	worn_icon = 'white/valtos/icons/clothing/mob/neck.dmi'

	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/primed = FALSE
	var/condition_for_release_text = "Ждать смерти"
	var/scheduled_explosion_time = 0
	var/mob/living/carbon/human/slave

/obj/item/clothing/neck/explosive_collar/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)

/obj/item/clothing/neck/explosive_collar/examine(mob/user)
	. = ..()
	. += "<hr><span class='deadsay'>Ошейник взорвётся в [worldtime2text(scheduled_explosion_time)].</span>"

/obj/item/clothing/neck/explosive_collar/equipped(mob/user, slot)
	. = ..()
	slave = user
	activate()

/obj/item/clothing/neck/explosive_collar/update_icon()
	icon_state = primed ? "bombcollaron" : "bombcollaroff"

/obj/item/clothing/neck/explosive_collar/proc/explode()
	if(istype(slave))
		var/obj/item/bodypart/BP = slave.get_bodypart(BODY_ZONE_HEAD)
		if(BP)
			new /obj/effect/gibspawner/generic(get_turf(slave), slave)
			BP.dismember(BRUTE)
			BP.drop_organs()
			qdel(slave)
			slave.regenerate_icons()
		explosion(src, -1, -1, 0, 1)
	say("Условия не соблюдены.")
	visible_message("<span class='danger'>Голова [slave] взрывается!</span>")
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
	return (100*charged_apcs/total_apcs) >= apc_req_charge

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

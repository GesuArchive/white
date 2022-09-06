
#define DEEPFRYER_COOKTIME 60
#define DEEPFRYER_BURNTIME 120

GLOBAL_LIST_INIT(oilfry_blacklisted_items, typecacheof(list(
	/obj/item/reagent_containers/glass,
	/obj/item/reagent_containers/syringe,
	/obj/item/reagent_containers/food/condiment,
	/obj/item/storage,
	/obj/item/delivery/small,
	/obj/item/his_grace)))

/obj/machinery/deepfryer
	name = "фритюрница"
	desc = "Жареное <i>всё</i>."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "fryer_off"
	density = TRUE
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.05
	layer = BELOW_OBJ_LAYER
	circuit = /obj/item/circuitboard/machine/deep_fryer
	var/obj/item/food/deepfryholder/frying	//What's being fried RIGHT NOW?
	var/cook_time = 0
	var/oil_use = 0.025 //How much cooking oil is used per second
	var/fry_speed = 1 //How quickly we fry food
	var/frying_fried //If the object has been fried; used for messages
	var/frying_burnt //If the object has been burnt
	var/datum/looping_sound/deep_fryer/fry_loop
	var/static/list/deepfry_blacklisted_items = typecacheof(list(
	/obj/item/screwdriver,
	/obj/item/crowbar,
	/obj/item/wrench,
	/obj/item/wirecutters,
	/obj/item/multitool,
	/obj/item/weldingtool))

/obj/machinery/deepfryer/Initialize(mapload)
	. = ..()
	create_reagents(50, OPENCONTAINER)
	reagents.add_reagent(/datum/reagent/consumable/cooking_oil, 25)
	fry_loop = new(src, FALSE)

/obj/machinery/deepfryer/Destroy()
	QDEL_NULL(fry_loop)
	return ..()

/obj/machinery/deepfryer/RefreshParts()
	. = ..()
	var/oil_efficiency
	for(var/obj/item/stock_parts/micro_laser/M in component_parts)
		oil_efficiency += M.rating
	oil_use = initial(oil_use) - (oil_efficiency * 0.00475)
	fry_speed = oil_efficiency

/obj/machinery/deepfryer/examine(mob/user)
	. = ..()
	if(frying)
		. += "<hr>Замечаю [frying] в масле."
	if(in_range(user, src) || isobserver(user))
		. += "<hr><span class='notice'>Дисплей: Жарим со скоростью <b>[fry_speed*100]%</b>.<br>Используем <b>[oil_use]</b> единиц масла в секунду.</span>"

/obj/machinery/deepfryer/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/reagent_containers/pill))
		if(!reagents.total_volume)
			to_chat(user, span_warning("В [I] нечего растворить!"))
			return
		user.visible_message(span_notice("[user] бросает [I] в [src].") , span_notice("Растворяю [I] в [src]."))
		I.reagents.trans_to(src, I.reagents.total_volume, transfered_by = user)
		qdel(I)
		return
	if(!reagents.has_reagent(/datum/reagent/consumable/cooking_oil))
		to_chat(user, span_warning("[capitalize(src.name)] больше не имеет масла в себе!"))
		return
	if(I.resistance_flags & INDESTRUCTIBLE)
		to_chat(user, span_warning("Будет неразумно попытаться зажарить [I]..."))
		return
	if(istype(I, /obj/item/food/deepfryholder))
		to_chat(user, span_userdanger("Мои кулинарные навыки не дотягивают до легендарной техники двойной прожарки"))
		return
	if(default_unfasten_wrench(user, I))
		return
	else if(default_deconstruction_screwdriver(user, "fryer_off", "fryer_off" ,I))	//where's the open maint panel icon?!
		return
	else
		if(is_type_in_typecache(I, deepfry_blacklisted_items) || is_type_in_typecache(I, GLOB.oilfry_blacklisted_items) || HAS_TRAIT(I, TRAIT_NODROP) || (I.item_flags & (ABSTRACT | DROPDEL)))
			return ..()
		else if(!frying && user.transferItemToLoc(I, src))
			to_chat(user, span_notice("Бросаю [I] в [src]."))
			frying = new/obj/item/food/deepfryholder(src, I)
			icon_state = "fryer_on"
			fry_loop.start()

/obj/machinery/deepfryer/process(delta_time)
	..()
	var/datum/reagent/consumable/cooking_oil/C = reagents.has_reagent(/datum/reagent/consumable/cooking_oil)
	if(!C)
		return
	reagents.chem_temp = C.fry_temperature
	if(frying)
		reagents.trans_to(frying, oil_use * delta_time, multiplier = fry_speed * 3) //Fried foods gain more of the reagent thanks to space magic
		cook_time += fry_speed * delta_time
		if(cook_time >= DEEPFRYER_COOKTIME && !frying_fried)
			frying_fried = TRUE //frying... frying... fried
			playsound(src.loc, 'sound/machines/ding.ogg', 50, TRUE)
			audible_message(span_notice("[capitalize(src.name)] дзынькает!"))
		else if (cook_time >= DEEPFRYER_BURNTIME && !frying_burnt)
			frying_burnt = TRUE
			visible_message(span_warning("[capitalize(src.name)] издает едкий запах!"))
		use_power(active_power_usage)

/obj/machinery/deepfryer/attack_ai(mob/user)
	return

/obj/machinery/deepfryer/attack_hand(mob/user)
	if(frying)
		if(frying.loc == src)
			to_chat(user, span_notice("Извлекаю [frying] из [src]."))
			frying.fry(cook_time)
			icon_state = "fryer_off"
			frying.forceMove(drop_location())
			if(Adjacent(user) && !issilicon(user))
				user.put_in_hands(frying)
			frying = null
			cook_time = 0
			frying_fried = FALSE
			frying_burnt = FALSE
			fry_loop.stop()
			return
	else if(user.pulling && user.a_intent == INTENT_GRAB && iscarbon(user.pulling) && reagents.total_volume)
		if(user.grab_state < GRAB_AGGRESSIVE)
			to_chat(user, span_warning("Потребуется более сильный захват для этого!"))
			return
		var/mob/living/carbon/C = user.pulling
		user.visible_message(span_danger("[user] окунает личико [C] в [src]!"))
		reagents.expose(C, TOUCH)
		log_combat(user, C, "fryer slammed")
		var/bio_multiplier = C.getarmor(BODY_ZONE_HEAD, BIO) * 0.01
		C.apply_damage(min(30 * bio_multiplier, reagents.total_volume), BURN, BODY_ZONE_HEAD)
		if(reagents.reagent_list) //This can runtime if reagents has nothing in it.
			reagents.remove_any((reagents.total_volume/2))
		C.Paralyze(60)
		SEND_SIGNAL(C, COMSIG_ADD_MOOD_EVENT, "fryer", /datum/mood_event/fried)
		user.changeNext_move(CLICK_CD_MELEE)
	return ..()

#undef DEEPFRYER_COOKTIME
#undef DEEPFRYER_BURNTIME

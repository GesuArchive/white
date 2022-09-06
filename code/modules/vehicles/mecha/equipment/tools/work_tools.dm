
//Hydraulic clamp, Kill clamp, Extinguisher, RCD, Cable layer.


/obj/item/mecha_parts/mecha_equipment/hydraulic_clamp
	name = "гидравлический манипулятор"
	desc = "Оборудование для инженерных экзокостюмов. Поднимает предметы и загружает их в хранилище."
	icon_state = "mecha_clamp"
	equip_cooldown = 15
	energy_drain = 10
	tool_behaviour = TOOL_RETRACTOR
	range = MECHA_MELEE
	toolspeed = 0.8
	harmful = TRUE
	mech_flags = EXOSUIT_MODULE_RIPLEY
	///Bool for whether we beat the hell out of things we punch (and tear off their arms)
	var/killer_clamp = FALSE
	///How much base damage this clamp does
	var/clamp_damage = 20
	///Var for the chassis we are attached to, needed to access ripley contents and such
	var/obj/vehicle/sealed/mecha/working/ripley/cargo_holder
	///Audio for using the hydraulic clamp
	var/clampsound = 'sound/mecha/hydraulic.ogg'

/obj/item/mecha_parts/mecha_equipment/hydraulic_clamp/can_attach(obj/vehicle/sealed/mecha/M, attach_right = FALSE)
	. = ..()
	if(!.)
		return
	if(!istype(M, /obj/vehicle/sealed/mecha/working/ripley))
		return FALSE

/obj/item/mecha_parts/mecha_equipment/hydraulic_clamp/attach(obj/vehicle/sealed/mecha/M)
	. = ..()
	cargo_holder = M

/obj/item/mecha_parts/mecha_equipment/hydraulic_clamp/detach(atom/moveto = null)
	. = ..()
	cargo_holder = null

/obj/item/mecha_parts/mecha_equipment/hydraulic_clamp/action(mob/source, atom/target, params)
	if(!action_checks(target))
		return
	if(!cargo_holder)
		return
	if(ismecha(target))
		var/obj/vehicle/sealed/mecha/M = target
		var/have_ammo
		for(var/obj/item/mecha_ammo/box in cargo_holder.cargo)
			if(istype(box, /obj/item/mecha_ammo) && box.rounds)
				have_ammo = TRUE
				if(M.ammo_resupply(box, source, TRUE))
					return
		if(have_ammo)
			to_chat(source, "Никакие дополнительные поставки не могут быть предоставлены для [M].")
		else
			to_chat(source, "В грузовом отсеке не обнаружено необходимых припасов")

	else if(isobj(target))
		var/obj/clamptarget = target
		if(istype(clamptarget, /obj/machinery/door/firedoor))
			var/obj/machinery/door/firedoor/targetfiredoor = clamptarget
			playsound(chassis, clampsound, 50, FALSE, -6)
			targetfiredoor.try_to_crowbar(src, source)
			return
		if(istype(clamptarget, /obj/machinery/door/airlock/))
			var/obj/machinery/door/airlock/targetairlock = clamptarget
			playsound(chassis, clampsound, 50, FALSE, -6)
			targetairlock.try_to_crowbar(src, source)
			return
		if(clamptarget.anchored)
			to_chat(source, "[icon2html(src, source)]<span class='warning'>[target] надежно закреплен!</span>")
			return
		if(LAZYLEN(cargo_holder.cargo) >= cargo_holder.cargo_capacity)
			to_chat(source, "[icon2html(src, source)]<span class='warning'>Недостаточно места в грузовом отсеке!</span>")
			return
		playsound(chassis, clampsound, 50, FALSE, -6)
		chassis.visible_message(span_notice("[chassis] поднимает [target] и начинает загружать его в грузовой отсек."))
		clamptarget.set_anchored(TRUE)
		if(!do_after_cooldown(target, source))
			clamptarget.set_anchored(initial(clamptarget.anchored))
			return
		LAZYADD(cargo_holder.cargo, clamptarget)
		clamptarget.forceMove(chassis)
		clamptarget.set_anchored(FALSE)
		if(!cargo_holder.box && istype(clamptarget, /obj/structure/ore_box))
			cargo_holder.box = clamptarget
		to_chat(source, "[icon2html(src, source)]<span class='notice'>[target] успешно загружен.</span>")
		log_message("Loaded [clamptarget]. Cargo compartment capacity: [cargo_holder.cargo_capacity - LAZYLEN(cargo_holder.cargo)]", LOG_MECHA)

	else if(isliving(target))
		var/mob/living/M = target
		if(M.stat == DEAD)
			return
		if(source.a_intent == INTENT_HELP)
			step_away(M,chassis)
			if(killer_clamp)
				target.visible_message(span_danger("[chassis] швыряет [target] как лист бумаги!") , \
					span_userdanger("[chassis] швыряет тебя, как лист бумаги!"))
			else
				to_chat(source, "[icon2html(src, source)]<span class='notice'>Ты толкаешь [target] с дороги.</span>")
				chassis.visible_message(span_notice("[chassis] толкает [target] с дороги.") , \
				span_notice("[chassis] толкает тебя."))
			return ..()
		else if(source.a_intent == INTENT_DISARM && iscarbon(M))//meme clamp here
			if(!killer_clamp)
				to_chat(source, span_notice("Вы пытаетесь оторвать руки [M]."))
				return
			var/mob/living/carbon/C = target
			var/torn_off = FALSE
			var/obj/item/bodypart/affected = C.get_bodypart(BODY_ZONE_L_ARM)
			if(affected != null)
				affected.dismember(damtype)
				torn_off = TRUE
			affected = C.get_bodypart(BODY_ZONE_R_ARM)
			if(affected != null)
				affected.dismember(damtype)
				torn_off = TRUE
			if(!torn_off)
				to_chat(source, span_notice("Руки [M] уже оторваны, требуется найти нового претендента, достойного убийства!"))
				return
			playsound(src, get_dismember_sound(), 80, TRUE)
			target.visible_message(span_danger("[chassis] отрывает руки [target]!") , \
						   span_userdanger("[chassis] отрывает твои руки!"))
			log_combat(source, M, "removed both arms with a real clamp,", "[name]", "(INTENT: [uppertext(source.a_intent)]) (DAMTYPE: [uppertext(damtype)])")
			return ..()

		M.take_overall_damage(clamp_damage)
		if(!M) //get gibbed stoopid
			return
		M.adjustOxyLoss(round(clamp_damage))
		M.updatehealth()
		target.visible_message(span_danger("[chassis] сжимает [target]!") , \
							span_userdanger("[chassis] сжимает тебя!") ,\
							span_hear("Слышу хруст."))
		log_combat(source, M, "attacked", "[name]", "(INTENT: [uppertext(source.a_intent)]) (DAMTYPE: [uppertext(damtype)])")
	return ..()



//This is pretty much just for the death-ripley
/obj/item/mecha_parts/mecha_equipment/hydraulic_clamp/kill
	name = "\improper СМЕРТЕЛЬНЫЙ гидравлический манипулятор"
	desc = "В детстве вы были из тех детишек, что любили отрывать у мух все лишнее..."
	killer_clamp = TRUE


/obj/item/mecha_parts/mecha_equipment/hydraulic_clamp/kill/fake//harmless fake for pranks
	desc = "В детстве вы были из тех детишек, что любили отрывать у мух все лишнее... Шутеечка..."
	energy_drain = 0
	clamp_damage = 0
	killer_clamp = FALSE


/obj/item/mecha_parts/mecha_equipment/extinguisher
	name = "огнетушитель экзокостюма"
	desc = "Оборудование для инженерных экзокостюмов. Быстродействующий огнетушитель большой мощности."
	icon_state = "mecha_exting"
	equip_cooldown = 5
	energy_drain = 0
	equipment_slot = MECHA_UTILITY
	range = MECHA_MELEE|MECHA_RANGED
	mech_flags = EXOSUIT_MODULE_WORKING
	///Minimum amount of reagent needed to activate.
	var/required_amount = 80

/obj/item/mecha_parts/mecha_equipment/extinguisher/Initialize(mapload)
	. = ..()
	create_reagents(400)
	reagents.add_reagent(/datum/reagent/water, 400)

/obj/item/mecha_parts/mecha_equipment/extinguisher/proc/spray_extinguisher(mob/user)
	if(reagents.total_volume < required_amount)
		return

	for(var/turf/targetturf in RANGE_TURFS(1, chassis))
		var/obj/effect/particle_effect/water/extinguisher/water = new /obj/effect/particle_effect/water/extinguisher(targetturf)
		var/datum/reagents/water_reagents = new /datum/reagents(required_amount/8) //required_amount/8, because the water usage is split between eight sprays. As of this comment, required_amount/8 = 10u each.
		water.reagents = water_reagents
		water_reagents.my_atom = water
		reagents.trans_to(water, required_amount/8)
		water.move_at(get_step(chassis, get_dir(targetturf, chassis)), 2, 4) //Target is the tile opposite of the mech as the starting turf.

	playsound(chassis, 'sound/effects/extinguish.ogg', 75, TRUE, -3)

/**
 * Handles attemted refills of the extinguisher.
 *
 * The mech can only refill an extinguisher that is in front of it.
 * Only water tank objects can be used.
 */
/obj/item/mecha_parts/mecha_equipment/extinguisher/proc/attempt_refill(mob/user)
	if(reagents.maximum_volume == reagents.total_volume)
		return
	var/turf/in_front = get_step(chassis, chassis.dir)
	var/obj/structure/reagent_dispensers/watertank/refill_source = locate(/obj/structure/reagent_dispensers/watertank) in in_front
	if(!refill_source)
		to_chat(user, span_notice("Заправка невозможна. Не обнаружен совместимый бак."))
		return
	if(!refill_source.reagents?.total_volume)
		to_chat(user, span_notice("Заправка невозможна. Бак пуст."))
		return

	refill_source.reagents.trans_to(src, reagents.maximum_volume)
	playsound(chassis, 'sound/effects/refill.ogg', 50, TRUE, -6)

/obj/item/mecha_parts/mecha_equipment/extinguisher/get_snowflake_data()
	return list(
		"snowflake_id" = MECHA_SNOWFLAKE_ID_EXTINGUISHER,
		"reagents" = reagents.total_volume,
		"total_reagents" = reagents.maximum_volume,
		"minimum_requ" = required_amount,
	)

/obj/item/mecha_parts/mecha_equipment/extinguisher/ui_act(action, list/params)
	. = ..()
	if(.)
		return TRUE
	switch(action)
		if("activate")
			spray_extinguisher(usr)
			return TRUE
		if("refill")
			attempt_refill(usr)
			return TRUE

/obj/item/mecha_parts/mecha_equipment/extinguisher/can_attach(obj/vehicle/sealed/mecha/M, attach_right = FALSE)
	. = ..()
	if(!.)
		return
	if(!istype(M, /obj/vehicle/sealed/mecha/working))
		return FALSE


#define MODE_DECONSTRUCT	0
#define MODE_WALL			1
#define MODE_AIRLOCK		2

/obj/item/mecha_parts/mecha_equipment/rcd
	name = "РЦД экзокостюма"
	desc = "Обладает меньшим функционалом, однако работает от батареи."
	icon_state = "mecha_rcd"
	equip_cooldown = 10
	energy_drain = 250
	range = MECHA_MELEE|MECHA_RANGED
	item_flags = NO_MAT_REDEMPTION
	///determines what we'll so when clicking on a turf
	var/mode = MODE_DECONSTRUCT

/obj/item/mecha_parts/mecha_equipment/rcd/Initialize(mapload)
	. = ..()
	GLOB.rcd_list += src

/obj/item/mecha_parts/mecha_equipment/rcd/Destroy()
	GLOB.rcd_list -= src
	return ..()

/obj/item/mecha_parts/mecha_equipment/rcd/get_snowflake_data()
	return list(
		"snowflake_id" = MECHA_SNOWFLAKE_ID_MODE,
		"name" = "RCD control",
		"mode" = get_mode_name(),
	)

/// fetches the mode name to display in the UI
/obj/item/mecha_parts/mecha_equipment/rcd/proc/get_mode_name()
	switch(mode)
		if(MODE_DECONSTRUCT)
			return "Deconstruct"
		if(MODE_WALL)
			return "Build wall"
		if(MODE_AIRLOCK)
			return "Build Airlock"
		else
			return "Someone didnt set this"

/obj/item/mecha_parts/mecha_equipment/rcd/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	if(action == "change_mode")
		mode++
		if(mode > MODE_AIRLOCK)
			mode = MODE_DECONSTRUCT
		switch(mode)
			if(MODE_DECONSTRUCT)
				to_chat(chassis.occupants, "[icon2html(src, chassis.occupants)][span_notice("Switched RCD to Deconstruct.")]")
				energy_drain = initial(energy_drain)
			if(MODE_WALL)
				to_chat(chassis.occupants, "[icon2html(src, chassis.occupants)][span_notice("Switched RCD to Construct Walls and Flooring.")]")
				energy_drain = 2*initial(energy_drain)
			if(MODE_AIRLOCK)
				to_chat(chassis.occupants, "[icon2html(src, chassis.occupants)][span_notice("Switched RCD to Construct Airlock.")]")
				energy_drain = 2*initial(energy_drain)
		return TRUE

/obj/item/mecha_parts/mecha_equipment/rcd/action(mob/source, atom/target, list/modifiers)
	if(!isturf(target) && !istype(target, /obj/machinery/door/airlock))
		target = get_turf(target)
	if(!action_checks(target) || get_dist(chassis, target)>3 || istype(target, /turf/open/space/transit))
		return
	playsound(chassis, 'sound/machines/click.ogg', 50, TRUE)

	switch(mode)
		if(MODE_DECONSTRUCT)
			to_chat(source, "[icon2html(src, source)]<span class='notice'>Производится деконструкция [target]...</span>")
			if(iswallturf(target))
				var/turf/closed/wall/W = target
				if(!do_after_cooldown(W, source))
					return
				W.ScrapeAway()
			else if(isfloorturf(target))
				var/turf/open/floor/F = target
				if(!do_after_cooldown(target, source))
					return
				F.ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
			else if (istype(target, /obj/machinery/door/airlock))
				if(!do_after_cooldown(target, source))
					return
				qdel(target)
		if(MODE_WALL)
			if(isspaceturf(target))
				var/turf/open/space/S = target
				to_chat(source, "[icon2html(src, source)]<span class='notice'>Производится строительство пола...</span>")
				if(!do_after_cooldown(S, source))
					return
				S.PlaceOnTop(/turf/open/floor/plating, flags = CHANGETURF_INHERIT_AIR)
			else if(isfloorturf(target))
				var/turf/open/floor/F = target
				to_chat(source, "[icon2html(src, source)]<span class='notice'>Производится строительство стены...</span>")
				if(!do_after_cooldown(F, source))
					return
				F.PlaceOnTop(/turf/closed/wall)
		if(MODE_AIRLOCK)
			if(isfloorturf(target))
				to_chat(source, "[icon2html(src, source)]<span class='notice'>Производится строительство шлюза...</span>")
				if(!do_after_cooldown(target, source))
					return
				var/obj/machinery/door/airlock/T = new /obj/machinery/door/airlock(target)
				T.autoclose = TRUE
				playsound(target, 'sound/effects/sparks2.ogg', 50, TRUE)
	chassis.spark_system.start()
	playsound(target, 'sound/items/deconstruct.ogg', 50, TRUE)
	return ..()

#undef MODE_DECONSTRUCT
#undef MODE_WALL
#undef MODE_AIRLOCK

//Dunno where else to put this so shrug
/obj/item/mecha_parts/mecha_equipment/ripleyupgrade
	name = "Комплект модернизации Рипли МК-2"
	desc = "Комплект модернизации корпуса АПЛУ \"Рипли\" МК-1 в МК-2, предоставляет полную защиту от окружающей среды, в том числе космического вакуума, ценой замедления ходовой части. Модернизация не подлежит деконструкции."
	icon_state = "ripleyupgrade"
	mech_flags = EXOSUIT_MODULE_RIPLEY

/obj/item/mecha_parts/mecha_equipment/ripleyupgrade/can_attach(obj/vehicle/sealed/mecha/working/ripley/M, attach_right = FALSE)
	if(M.type != /obj/vehicle/sealed/mecha/working/ripley)
		to_chat(loc, span_warning("This conversion kit can only be applied to APLU MK-I models."))
		return FALSE
	if(LAZYLEN(M.cargo))
		to_chat(loc, span_warning("[M] cargo hold must be empty before this conversion kit can be applied."))
		return FALSE
	if(!(M.mecha_flags & ADDING_MAINT_ACCESS_POSSIBLE)) //non-removable upgrade, so lets make sure the pilot or owner has their say.
		to_chat(loc, span_warning("[M] must have maintenance protocols active in order to allow this conversion kit."))
		return FALSE
	if(LAZYLEN(M.occupants)) //We're actualy making a new mech and swapping things over, it might get weird if players are involved
		to_chat(loc, span_warning("[M] must be unoccupied before this conversion kit can be applied."))
		return FALSE
	if(!M.cell) //Turns out things break if the cell is missing
		to_chat(loc, span_warning("The conversion process requires a cell installed."))
		return FALSE
	return TRUE

/obj/item/mecha_parts/mecha_equipment/ripleyupgrade/attach(obj/vehicle/sealed/mecha/markone, attach_right = FALSE)
	var/obj/vehicle/sealed/mecha/working/ripley/mk2/marktwo = new (get_turf(markone),1)
	if(!marktwo)
		return
	QDEL_NULL(marktwo.cell)
	if (markone.cell)
		marktwo.cell = markone.cell
		markone.cell.forceMove(marktwo)
		markone.cell = null
	QDEL_NULL(marktwo.scanmod)
	if (markone.scanmod)
		marktwo.scanmod = markone.scanmod
		markone.scanmod.forceMove(marktwo)
		markone.scanmod = null
	QDEL_NULL(marktwo.capacitor)
	if (markone.capacitor)
		marktwo.capacitor = markone.capacitor
		markone.capacitor.forceMove(marktwo)
		markone.capacitor = null
	marktwo.update_part_values()
	for(var/obj/item/mecha_parts/mecha_equipment/equipment in markone.flat_equipment) //Move the equipment over...
		var/righthandgun = markone.equip_by_category[MECHA_R_ARM] == equipment
		equipment.detach(marktwo)
		equipment.attach(marktwo, righthandgun)
	marktwo.dna_lock = markone.dna_lock
	marktwo.mecha_flags = markone.mecha_flags
	marktwo.strafe = markone.strafe
	marktwo.obj_integrity = round((markone.obj_integrity / markone.max_integrity) * marktwo.obj_integrity) //Integ set to the same percentage integ as the old mecha, rounded to be whole number
	if(markone.name != initial(markone.name))
		marktwo.name = markone.name
	markone.wreckage = FALSE
	qdel(markone)
	playsound(get_turf(marktwo),'sound/items/ratchet.ogg',50,TRUE)
	return

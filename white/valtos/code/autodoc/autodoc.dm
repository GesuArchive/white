/proc/list_avg(list/L)
	. = 0
	for(var/num in L)
		. += num
	. /= length(L)
	LAZYCLEARLIST(L)

/obj/machinery/autodoc
	name = "Авто-Док МК IX"
	desc = "Автоматический хирургически комплекс специализированный на восстановительных и модернизирующих операциях."
	circuit = /obj/item/circuitboard/machine/autodoc
	icon = 'white/valtos/icons/64x64_autodoc.dmi'
	icon_state = "autodoc_base"
	density = FALSE
	anchored = TRUE
	layer = ABOVE_WINDOW_LAYER
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 10
	pixel_x = -16
	var/speed_mult = 1
	var/list/valid_surgeries = list()
	var/datum/surgery/target_surgery
	var/datum/surgery/active_surgery
	var/datum/surgery_step/active_step
	var/target_zone = "chest"
	var/in_use = FALSE
	var/caesar = FALSE
	var/message_cooldown = 0
	var/mutable_appearance/top_overlay

/obj/machinery/autodoc/examine(mob/user)
	. = ..()
	if(occupant)
		. += "<hr><span class='notice'>Вижу <b>[occupant]</b> внутри.</span>"
		. += "<hr><span class='notice'><b>ПКМ</b> для экстренного извлечения.</span>"
	. += "<hr><span class='notice'><b>Ctrl-Клик</b>, чтобы открыть внутреннее хранилище.</span>"

/obj/machinery/autodoc/CanPass(atom/movable/mover, border_dir)
	if(border_dir == NORTH)
		return FALSE
	return ..()

/obj/machinery/autodoc/Initialize(mapload)
	. = ..()
	top_overlay = mutable_appearance(icon, "autodoc_top", ABOVE_MOB_LAYER)
	occupant_typecache = GLOB.typecache_living
	update_icon()
	for(var/datum/surgery/S in GLOB.surgeries_list)
		var/valid = TRUE
		if((ispath(S.replaced_by) && S.replaced_by != S.type) || !LAZYLEN(S.steps)) // the autodoc only uses the BEST versions of a surgery
			valid = FALSE
		else
			for(var/step in S.steps)
				if(!is_type_in_typecache(step, GLOB.autodoc_supported_surgery_steps))
					valid = FALSE
					break
		if(valid)
			valid_surgeries += S

/obj/machinery/autodoc/RefreshParts()
	. = ..()
	var/list/P = list()
	var/avg = 1
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		P += M.get_part_rating()
	avg = round(list_avg(P), 1)
	switch(avg)
		if(2)
			speed_mult = 0.75
		if(3)
			speed_mult = 0.5
		if(4)
			speed_mult = 0.25
		else
			speed_mult = 0.1

	//Энергопотребление (10к -> 7.5к -> 5к -> 2.5к -> 1к)
	var/Pwr = -1
	for(var/obj/item/stock_parts/capacitor/cap in component_parts)
		Pwr += cap.rating
	active_power_usage = initial(active_power_usage) - (initial(active_power_usage)*(Pwr))/4
	if(active_power_usage <= 1000)
		active_power_usage = 1000

/obj/machinery/autodoc/CtrlClick(mob/user)
	playsound(src, 'white/valtos/sounds/error2.ogg', 50, FALSE)

/obj/machinery/autodoc/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	playsound(src, 'white/valtos/sounds/error2.ogg', 50, FALSE)
	active_surgery.complete()
	active_surgery = null
	active_step = null
	in_use = FALSE
	if(!state_open)
		open_machine()
	update_icon()

/obj/machinery/autodoc/ui_act(action, list/params)
	if(..())
		return
	switch(action)
		if("target")
			if(!in_use && (params["part"] in list(BODY_ZONE_CHEST, BODY_ZONE_HEAD, BODY_ZONE_PRECISE_GROIN, BODY_ZONE_PRECISE_EYES, BODY_ZONE_PRECISE_EYES, BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)))
				target_zone = params["part"]
		if("surgery")
			if(!in_use)
				var/path = text2path(params["path"])
				for(var/datum/surgery/S in valid_surgeries)
					if((S.type == path) && S.possible_locs.Find(target_zone))
						target_surgery = S
						return
		if("start")
			INVOKE_ASYNC(src, PROC_REF(surgery_time), usr)

/obj/machinery/autodoc/Destroy()
	if(active_surgery)
		active_surgery.complete()
	open_machine()
	return ..()

/obj/machinery/autodoc/proc/mcdonalds(mob/living/carbon/victim)
	for(var/obj/item/bodypart/BP in victim.bodyparts)
		if(BP.body_part != HEAD && BP.body_part != CHEST && BP.dismemberable)
			playsound(src, 'sound/weapons/circsawhit.ogg', 50, TRUE)
			BP.drop_limb()
			victim.emote("agony")
			BP.forceMove(get_turf(src))
			BP.throw_at(get_edge_target_turf(src, pick(GLOB.alldirs)), INFINITY, 5, spin = TRUE)
			sleep(10)
	var/list/organs = list()
	for(var/obj/item/organ/OR in victim.internal_organs)
		if(!istype(OR, /obj/item/organ/brain) && !istype(OR, /obj/item/organ/heart))
			organs += OR
	if(LAZYLEN(organs))
		var/obj/item/organ/O = pick(organs)
		O.Remove(victim)
		O.forceMove(get_turf(src))
		victim.emote("agony")
		O.throw_at(get_edge_target_turf(src, pick(GLOB.alldirs)), INFINITY, 5, spin = TRUE)
	// this is just a big ol' middle finger to the victim
	victim.slurring = 300
	victim.dizziness = 300
	victim.jitteriness = 300
	victim.setOrganLoss(ORGAN_SLOT_BRAIN, max(135, victim.getOrganLoss(ORGAN_SLOT_BRAIN)))
	caesar = FALSE
	playsound(src, 'sound/weapons/circsawhit.ogg', 50, TRUE)

/obj/machinery/autodoc/proc/surgery_time(mob/living/doer)
	var/mob/living/carbon/patient
	if(in_use)
		say("Авто-Док уже используется!")
		playsound(src, 'white/valtos/sounds/error2.ogg', 50, FALSE)
		return
	if(!target_surgery || !target_zone)
		say("Неверные настройки!")
		playsound(src, 'white/valtos/sounds/error2.ogg', 50, FALSE)
		if(!state_open)
			open_machine()
		return
	if(state_open)
		close_machine()
	update_icon()
	for(var/mob/living/carbon/C in src)
		patient = C
		break
	if(!patient)
		say("Не обнаружен пациент!")
		playsound(src, 'white/valtos/sounds/error2.ogg', 50, FALSE)
		if(!state_open)
			open_machine()
		return
	var/obj/item/bodypart/affecting = patient.get_bodypart(check_zone(target_zone))
	if(affecting)
		if(!target_surgery.requires_bodypart)
			playsound(src, 'white/valtos/sounds/error2.ogg', 50, FALSE)
			if(!state_open)
				open_machine()
			return
		if(target_surgery.requires_bodypart_type && affecting.status != target_surgery.requires_bodypart_type)
			say("Авто-Док не умеет работать с этой частью тела!")
			playsound(src, 'white/valtos/sounds/error2.ogg', 50, FALSE)
			if(!state_open)
				open_machine()
			return
		if(target_surgery.requires_real_bodypart && affecting.is_pseudopart)
			playsound(src, 'white/valtos/sounds/error2.ogg', 50, FALSE)
			if(!state_open)
				open_machine()
			return
	else if(patient && target_surgery.requires_bodypart) //mob with no limb in surgery zone when we need a limb
		playsound(src, 'white/valtos/sounds/error2.ogg', 50, FALSE)
		if(!state_open)
			open_machine()
		return
	log_combat(doer, patient, "began [target_surgery] surgery", src)
	for(var/surgery_type in target_surgery.steps)
		var/datum/surgery_step/SS = new surgery_type
		if(!SS.autodoc_check(target_zone, src, FALSE, patient))
			qdel(SS)
			playsound(src, 'white/valtos/sounds/error2.ogg', 50, FALSE)
			if(!state_open)
				open_machine()
			return
		qdel(SS)
	in_use = TRUE
	update_icon()
	active_surgery = new target_surgery.type(patient, target_zone, affecting)
	while(active_surgery.status <= active_surgery.steps.len)
		if(caesar)
			mcdonalds(patient)
			break
		var/datum/surgery_step/next_step = active_surgery.get_surgery_next_step()
		if(!next_step)
			break
		active_step = next_step
		active_surgery.step_in_progress = TRUE
		active_surgery.status++
		if(next_step.repeatable || next_step.ad_repeatable)
			while(next_step.autodoc_check(target_zone, src, TRUE, patient))
				sleep((next_step.time * speed_mult) / 2)
				playsound(src, 'sound/weapons/circsawhit.ogg', 50, TRUE)
				sleep((next_step.time * speed_mult) / 2)
				playsound(src, 'sound/weapons/circsawhit.ogg', 50, TRUE)
				next_step.autodoc_success(patient, target_zone, active_surgery, src)
		else
			sleep((next_step.time * speed_mult) / 2)
			playsound(src, 'sound/weapons/circsawhit.ogg', 50, TRUE)
			sleep((next_step.time * speed_mult) / 2)
			playsound(src, 'sound/weapons/circsawhit.ogg', 50, TRUE)
			next_step.autodoc_success(patient, target_zone, active_surgery, src)
		active_surgery.step_in_progress = FALSE
	active_surgery.complete()
	active_surgery = null
	active_step = null
	in_use = FALSE
	if(!state_open)
		open_machine()
	update_icon()
	use_power(active_power_usage)

/obj/machinery/autodoc/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Autodoc", name)
		ui.open()

/obj/machinery/autodoc/ui_data(mob/user)
	. = list()
	if(in_use)
		.["mode"] = 2
		.["s_name"] = target_surgery.name
		.["steps"] = list()
		for(var/s in target_surgery.steps)
			var/datum/surgery_step/S = s
			.["steps"] += list(list(
				"name" = initial(S.name),
				"current" = active_step ? (active_step.type == s) : FALSE
			))
	else
		.["mode"] = 1
		.["target"] = target_zone
		.["surgeries"] = list()
		for(var/datum/surgery/S in valid_surgeries)
			if(S.possible_locs.Find(target_zone))
				.["surgeries"] += list(list(
					"name" = S.name,
					"selected" = (S == target_surgery),
					"path" = "[S.type]",
				))

/obj/machinery/autodoc/MouseDrop_T(mob/target, mob/user)
	if(!QDELETED(occupant) && istype(occupant))
		return
	if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK) || !Adjacent(target) || !user.Adjacent(target) || !iscarbon(target))
		return
	if(close_machine(target))
		log_combat(user, target, "inserted", null, "into [src].")
	add_fingerprint(user)

/obj/machinery/autodoc/emag_act(mob/user)
	if(caesar)
		to_chat(user, span_notice("Бедный <b>[src]</b> уже взломан!"))
		return
	log_combat(user, src, "emagged")
	to_chat(user, span_notice("Нещадно провожу криптокаркой по <b>[src]</b>, заставляя его сойти с ума."))
	add_fingerprint(user)
	caesar = TRUE

/obj/machinery/autodoc/update_icon()
	. = ..()
	cut_overlays()
	add_overlay(top_overlay)
	if(!(machine_stat & (NOPOWER|BROKEN)))
		if(in_use)
			add_overlay("auto_doc_lights_working")
		else
			add_overlay("auto_doc_lights_on")
	if(occupant)
		add_overlay("autodoc_door_closed")
	else
		add_overlay("autodoc_door_open")

/obj/machinery/autodoc/proc/toggle_open(mob/user)
	if(panel_open)
		to_chat(user, span_notice("Надо бы панель закрыть."))
		return
	if(state_open)
		close_machine(null, user)
		return
	else if(in_use)
		to_chat(user, span_notice("Не открыть. Похоже надо подождать."))
		return
	open_machine()

/obj/machinery/autodoc/open_machine()
	if(state_open)
		return FALSE
	..(FALSE)
	if(occupant)
		occupant.forceMove(get_turf(src))
	update_icon()
	return TRUE

/obj/machinery/autodoc/relaymove(mob/user as mob)
	if(user.stat || in_use)
		if(message_cooldown <= world.time)
			message_cooldown = world.time + 50
			to_chat(user, span_warning("Дверца <b>[src]</b> застряла!"))
		return
	open_machine()


/obj/item/circuitboard/machine/autodoc
	name = "Плата Авто-Дока МК IX"
	desc = "Автоматический хирургически комплекс специализированный на восстановительных и модернизирующих операциях."
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/autodoc
	req_components = list(
							/obj/item/stock_parts/capacitor = 5,
							/obj/item/stock_parts/scanning_module = 5,
							/obj/item/stock_parts/manipulator = 5,
							/obj/item/stock_parts/micro_laser = 5,
							/obj/item/scalpel/advanced = 1,
							/obj/item/retractor/advanced = 1,
							/obj/item/cautery/advanced = 1,
							/obj/item/stack/sheet/glass = 15)

/datum/design/board/autodoc
	name = "Авто-Док МК IX"
	desc = "Автоматический хирургически комплекс специализированный на восстановительных и модернизирующих операциях."
	id = "autodoc"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	build_path = /obj/item/circuitboard/machine/autodoc
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_MEDICAL
	category = list ("Медицинское оборудование")
	sub_category = list("Автохирургия")

/datum/techweb_node/autodoc
	id = "autodoc"
	display_name = "Автоматические медицинские комплексы"
	description = "\"Авто-Док МК IX\" - автоматический хирургически комплекс специализированный на восстановительных и модернизирующих операциях. Многофункциональный медицинский комплекс \"Солнце\" - передовая военная разработка в области экстренной полевой медицины."
	prereq_ids = list("exp_surgery", "bio_process", "adv_datatheory", "adv_engi", "high_efficiency")
	design_ids = list("autodoc", "solnce")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 15000)

/datum/surgery_step/incise/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if (!(NOBLOOD in H.dna.species.species_traits))
			H.bleed(3)
	return TRUE

/datum/surgery_step/clamp_bleeders/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	if(locate(/datum/surgery_step/saw) in surgery.steps)
		target.heal_bodypart_damage(20,0)
	if (ishuman(target))
		var/mob/living/carbon/human/H = target
		var/obj/item/bodypart/BP = H.get_bodypart(target_zone)
		if(BP)
			BP.generic_bleedstacks -= 3
	return TRUE

/datum/surgery_step/close/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	if(locate(/datum/surgery_step/saw) in surgery.steps)
		target.heal_bodypart_damage(45,0)
	if (ishuman(target))
		var/mob/living/carbon/human/H = target
		var/obj/item/bodypart/BP = H.get_bodypart(target_zone)
		if(BP)
			BP.generic_bleedstacks -= 3
	return TRUE

/datum/surgery_step/saw/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	target.apply_damage(50, BRUTE, "[target_zone]")
	return TRUE

/datum/surgery_step/sever_limb/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	if(surgery.operated_bodypart)
		var/obj/item/bodypart/target_limb = surgery.operated_bodypart
		target_limb.drop_limb()
		target_limb.forceMove(get_turf(autodoc))
		autodoc.visible_message(span_notice("<b>[autodoc]</b> выплёвывает <b>[target_limb]</b>!"))
	return TRUE

/datum/surgery_step/heal/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	target.heal_bodypart_damage(brutehealing,burnhealing)
	return TRUE

/datum/surgery_step/extract_implant/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	for(var/obj/item/O in target.implants)
		I = O
		break
	if(I)
		I.removed(target)
		var/obj/item/implantcase/case
		for(var/obj/item/implantcase/ic in autodoc.contents)
			case = ic
			break
		if(!case)
			case = locate(/obj/item/implantcase) in get_turf(target)
		if(case && !case.imp)
			case.imp = I
			I.forceMove(case)
			case.update_icon()
		else
			qdel(I)
	return TRUE

/datum/surgery_step/remove_fat/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	target.overeatduration = 0 //patient is unfatted
	var/removednutriment = target.nutrition
	target.set_nutrition(NUTRITION_LEVEL_WELL_FED)
	removednutriment -= 450 //whatever was removed goes into the meat
	var/mob/living/carbon/human/H = target
	var/typeofmeat = /obj/item/food/meat/slab/human

	if(H.dna && H.dna.species)
		typeofmeat = H.dna.species.meat

	var/obj/item/food/meat/slab/human/newmeat = new typeofmeat
	newmeat.name = "жирное мясо"
	newmeat.desc = "Невероятно жирный кусок мяса."
	newmeat.subjectname = H.real_name
	newmeat.subjectjob = H.job
	newmeat.reagents.add_reagent (/datum/reagent/consumable/nutriment, (removednutriment / 15)) //To balance with nutriment_factor of nutriment
	newmeat.forceMove(get_turf(autodoc))
	autodoc.visible_message(span_notice("<b>[autodoc]</b> выплёвывает <b>[newmeat]</b>!"))
	return TRUE

/datum/surgery_step/fix_eyes/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	var/obj/item/organ/eyes/E = target.get_organ_slot(ORGAN_SLOT_EYES)
	target.cure_blind(list(EYE_DAMAGE))
	target.set_blindness(0)
	target.cure_nearsighted(list(EYE_DAMAGE))
	target.blur_eyes(35)	//this will fix itself slowly.
	E.setOrganDamage(0)
	return TRUE

/datum/surgery_step/heal/autodoc_check(target_zone, obj/machinery/autodoc/autodoc, silent, mob/living/carbon/target)
	if(target && !(brutehealing && target.getBruteLoss()) && !(burnhealing && target.getFireLoss()))
		return FALSE
	return TRUE

/datum/surgery_step/pacify/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	target.gain_trauma(/datum/brain_trauma/severe/pacifism, TRAUMA_RESILIENCE_LOBOTOMY)
	return TRUE

/datum/surgery_step/thread_veins/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	new /datum/bioware/threaded_veins(target)
	return TRUE

/datum/surgery_step/splice_nerves/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	new /datum/bioware/spliced_nerves(target)
	return TRUE

/datum/surgery_step/ground_nerves/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	new /datum/bioware/grounded_nerves(target)
	return TRUE

/datum/surgery_step/muscled_veins/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	new /datum/bioware/muscled_veins(target)
	return TRUE

/datum/surgery_step/reinforce_ligaments/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	new /datum/bioware/reinforced_ligaments(target)
	return TRUE

/datum/surgery_step/reshape_ligaments/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	new /datum/bioware/hooked_ligaments(target)
	return TRUE

/datum/surgery_step/proc/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	return TRUE

/datum/surgery_step
	var/ad_repeatable = FALSE

/datum/surgery_step/proc/autodoc_check(target_zone, obj/machinery/autodoc/autodoc, silent = TRUE, mob/living/carbon/target)
	return TRUE

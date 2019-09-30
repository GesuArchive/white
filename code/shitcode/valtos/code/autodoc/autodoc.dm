/proc/list_avg(list/L)
	. = 0
	for(var/num in L)
		. += num
	. /= length(L)
	LAZYCLEARLIST(L)

/datum/component/storage/concrete/autodoc
	silent = TRUE
	max_combined_w_class = WEIGHT_CLASS_HUGE
	max_w_class = WEIGHT_CLASS_BULKY
	drop_all_on_deconstruct = TRUE
	drop_all_on_destroy = TRUE
	attack_hand_interact = FALSE

GLOBAL_LIST_INIT(autodoc_supported_surgery_steps, typecacheof(list(
	/datum/surgery_step/incise,
	/datum/surgery_step/clamp_bleeders,
	/datum/surgery_step/close,
	/datum/surgery_step/saw,
	/datum/surgery_step/fix_brain,
	/datum/surgery_step/sever_limb,
	/datum/surgery_step/heal,
	/datum/surgery_step/extract_implant,
	/datum/surgery_step/manipulate_organs,
	/datum/surgery_step/remove_fat,
	/datum/surgery_step/replace_limb,
	/datum/surgery_step/remove_object,
	/datum/surgery_step/add_prosthetic,
	/datum/surgery_step/drill,
	/datum/surgery_step/retract_skin,
	/datum/surgery_step/insert_pill,
	/datum/surgery_step/fix_eyes,
	/datum/surgery_step/replace,
	/datum/surgery_step/revive,
	/datum/surgery_step/pacify,
	/datum/surgery_step/thread_veins,
	/datum/surgery_step/splice_nerves,
	/datum/surgery_step/ground_nerves,
	/datum/surgery_step/muscled_veins,
	/datum/surgery_step/reinforce_ligaments,
	/datum/surgery_step/reshape_ligaments
)))

/obj/machinery/autodoc
	name = "Auto-Doc Mark IX"
	desc = "A fully stationary automated surgeon! Fun for the whole family!"
	circuit = /obj/item/circuitboard/machine/autodoc
	icon = 'icons/obj/machines/nanite_chamber.dmi'
	icon_state = "nanite_chamber"
	density = TRUE
	anchored = TRUE
	layer = ABOVE_WINDOW_LAYER
	use_power = IDLE_POWER_USE
	idle_power_usage = 50
	active_power_usage = 300
	var/speed_mult = 1
	var/max_storage = 1
	var/list/valid_surgeries = list()
	var/datum/surgery/target_surgery
	var/datum/surgery/active_surgery
	var/datum/surgery_step/active_step
	var/target_zone = "chest"
	var/in_use = FALSE
	var/caesar = FALSE
	var/message_cooldown = 0

/obj/machinery/autodoc/examine(mob/user)
	. = ..()
	if(occupant)
		. += "<span class='notice'>You see <b>[occupant]</b> inside.</span>"
	. += "<span class='notice'><b>Ctrl-Click</b> to access the internal storage.</span>"

/obj/machinery/autodoc/Initialize()
	. = ..()
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
			//to_chat(world, "[S]([S.type]) is a valid surgery!")
			valid_surgeries += S

/obj/machinery/autodoc/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete/autodoc)

/obj/machinery/autodoc/RefreshParts()
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
			speed_mult = 1
	for(var/obj/item/stock_parts/matter_bin/M in component_parts)
		P += M.get_part_rating()
	max_storage = round(list_avg(P), 1)
	var/datum/component/storage/ST = LoadComponent(/datum/component/storage/concrete/autodoc)
	ST.max_items = max_storage

/obj/machinery/autodoc/CtrlClick(mob/user)
	if(in_use)
		playsound(src, 'sound/machines/buzz-two.ogg', 50, FALSE)
		return
	var/datum/component/storage/ST = GetComponent(/datum/component/storage/concrete/autodoc)
	if (user.active_storage)
		user.active_storage.close(user)
	ST.orient2hud(user)
	ST.show_to(user)

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
			INVOKE_ASYNC(src, .proc/surgery_time)

/obj/machinery/autodoc/Destroy()
	active_surgery.complete()
	open_machine()
	return ..()

/obj/machinery/autodoc/proc/mcdonalds(mob/living/carbon/victim)
	for(var/obj/item/bodypart/BP in victim.bodyparts)
		if(BP.body_part != HEAD && BP.body_part != CHEST && BP.dismemberable)
			BP.dismember()
	// this is just a big ol' middle finger to the victim
	victim.slurring = 300
	victim.dizziness = 300
	victim.jitteriness = 300
	victim.setOrganLoss(ORGAN_SLOT_BRAIN, min(135, victim.getOrganLoss(ORGAN_SLOT_BRAIN)))
	caesar = FALSE

/obj/machinery/autodoc/proc/surgery_time()
	var/mob/living/carbon/patient
	if(in_use)
		say("Auto-Doc currently in use!")
		playsound(src, 'sound/machines/buzz-two.ogg', 50, FALSE)
		return
	if(!target_surgery || !target_zone)
		say("Invalid configuration!")
		playsound(src, 'sound/machines/buzz-two.ogg', 50, FALSE)
		if(!state_open)
			open_machine()
			update_icon()
		return
	if(state_open)
		close_machine()
	update_icon()
	for(var/mob/living/carbon/C in src)
		patient = C
		break
	if(!patient)
		say("No patient inside!")
		playsound(src, 'sound/machines/buzz-two.ogg', 50, FALSE)
		if(!state_open)
			open_machine()
			update_icon()
		return
	var/obj/item/bodypart/affecting = patient.get_bodypart(check_zone(target_zone))
	if(affecting)
		if(!target_surgery.requires_bodypart)
			playsound(src, 'sound/machines/buzz-two.ogg', 50, FALSE)
			if(!state_open)
				open_machine()
				update_icon()
			return
		if(target_surgery.requires_bodypart_type && affecting.status != target_surgery.requires_bodypart_type)
			playsound(src, 'sound/machines/buzz-two.ogg', 50, FALSE)
			if(!state_open)
				open_machine()
				update_icon()
			return
		if(target_surgery.requires_real_bodypart && affecting.is_pseudopart)
			playsound(src, 'sound/machines/buzz-two.ogg', 50, FALSE)
			if(!state_open)
				open_machine()
				update_icon()
			return
	else if(patient && target_surgery.requires_bodypart) //mob with no limb in surgery zone when we need a limb
		playsound(src, 'sound/machines/buzz-two.ogg', 50, FALSE)
		if(!state_open)
			open_machine()
			update_icon()
		return
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
		if(next_step.repeatable)
			while(next_step.autodoc_check(target_zone, src, TRUE, patient))
				playsound(src, 'sound/weapons/circsawhit.ogg', 50, TRUE)
				sleep(next_step.time * speed_mult)
				playsound(src, 'sound/weapons/circsawhit.ogg', 50, TRUE)
				next_step.autodoc_success(patient, target_zone, active_surgery, src)
		else
			playsound(src, 'sound/weapons/circsawhit.ogg', 50, TRUE)
			sleep(next_step.time * speed_mult)
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

/obj/machinery/autodoc/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, \
									datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "autodoc", name, 455, 440, master_ui, state)
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
	if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK) || !Adjacent(target) || !user.Adjacent(target) || !iscarbon(target))
		return
	if(close_machine(target))
		log_combat(user, target, "inserted", null, "into [src].")
	add_fingerprint(user)

/obj/machinery/autodoc/emag_act(mob/user)
	if(caesar)
		to_chat(user, "<span class='notice'>\The [src]'s safeties are already corrupted!</span>")
		return
	to_chat(user, "<span class='notice'>You discretely emag \the [src], corrupting it's safeties.</span>")
	add_fingerprint(user)
	caesar = TRUE

/obj/machinery/autodoc/update_icon()
	cut_overlays()

	if((stat & MAINT) || panel_open)
		add_overlay("maint")
	else if(!(stat & (NOPOWER|BROKEN)))
		if(in_use)
			add_overlay("red")
		else
			add_overlay("green")

	//running and someone in there
	if(occupant)
		if(in_use)
			icon_state = initial(icon_state) + "_active"
		else
			icon_state = initial(icon_state) + "_occupied"
		return

	//running
	icon_state = initial(icon_state) + "_open"

/obj/machinery/autodoc/proc/toggle_open(mob/user)
	if(panel_open)
		to_chat(user, "<span class='notice'>Close the maintenance panel first.</span>")
		return
	if(state_open)
		close_machine(null, user)
		return
	else if(in_use)
		to_chat(user, "<span class='notice'>The bolts are locked down, securing the door shut.</span>")
		return
	open_machine()

/obj/machinery/autodoc/open_machine()
	if(state_open)
		return FALSE
	..(FALSE)
	if(occupant)
		occupant.forceMove(get_turf(src))
	return TRUE

/obj/machinery/autodoc/relaymove(mob/user as mob)
	if(user.stat || in_use)
		if(message_cooldown <= world.time)
			message_cooldown = world.time + 50
			to_chat(user, "<span class='warning'>[src]'s door won't budge!</span>")
		return
	open_machine()


/obj/item/circuitboard/machine/autodoc
	name = "circuit board (Auto-Doc Mark IX)"
	build_path = /obj/machinery/autodoc
	req_components = list(
							/obj/item/stock_parts/capacitor = 2,
							/obj/item/stock_parts/scanning_module = 1,
							/obj/item/stock_parts/manipulator = 2,
							/obj/item/stock_parts/micro_laser = 2,
							/obj/item/stock_parts/matter_bin = 1,
							/obj/item/stack/sheet/glass = 1)

/datum/design/board/autodoc
	name = "Machine Design (Auto-Doc Mark IX)"
	desc = "Allows for the construction of circuit boards used to build a Auto-Doc Mark IX."
	id = "autodoc"
	build_path = /obj/item/circuitboard/machine/autodoc
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_MEDICAL
	category = list ("Medical Machinery")

/datum/techweb_node/autodoc
	id = "autodoc"
	display_name = "Complex Anatomical Automation"
	description = "Advanced automation and complex anatomical knowhow combined to make advanced surgical things!"
	prereq_ids = list("exp_surgery", "bio_process", "adv_datatheory", "adv_engi", "high_efficiency")
	design_ids = list("autodoc")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 15000)
	export_price = 10000

/datum/surgery_step/incise/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if (!(NOBLOOD in H.dna.species.species_traits))
			H.bleed_rate += 3
	return TRUE

/datum/surgery_step/clamp_bleeders/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	if(locate(/datum/surgery_step/saw) in surgery.steps)
		target.heal_bodypart_damage(20,0)
	if (ishuman(target))
		var/mob/living/carbon/human/H = target
		H.bleed_rate = max( (H.bleed_rate - 3), 0)
	return TRUE

/datum/surgery_step/close/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	if(locate(/datum/surgery_step/saw) in surgery.steps)
		target.heal_bodypart_damage(45,0)
	if (ishuman(target))
		var/mob/living/carbon/human/H = target
		H.bleed_rate = max( (H.bleed_rate - 3), 0)
	return TRUE

/datum/surgery_step/saw/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	target.apply_damage(50, BRUTE, "[target_zone]")
	return TRUE

/datum/surgery_step/fix_brain/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	if(target.mind && target.mind.has_antag_datum(/datum/antagonist/brainwashed))
		target.mind.remove_antag_datum(/datum/antagonist/brainwashed)
	target.setOrganLoss(ORGAN_SLOT_BRAIN, -60)
	target.cure_all_traumas(TRAUMA_RESILIENCE_SURGERY)
	return TRUE

/datum/surgery_step/sever_limb/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	if(surgery.operated_bodypart)
		var/obj/item/bodypart/target_limb = surgery.operated_bodypart
		target_limb.drop_limb()
		target_limb.forceMove(get_turf(autodoc))
		autodoc.visible_message("<span class='notice'>\The [autodoc] spits out \the [target_limb]!</span>")
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

/datum/surgery_step/manipulate_organs/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	for(var/obj/item/organ/O in autodoc.contents)
		if(O.zone == target_zone)
			O.Insert(target)
	return TRUE

/datum/surgery_step/manipulate_organs/autodoc_check(target_zone, obj/machinery/autodoc/autodoc, silent = TRUE, mob/living/carbon/target)
	for(var/obj/item/organ/O in autodoc.contents)
		if(O.zone == target_zone)
			return TRUE
	if(!silent)
		autodoc.say("No valid organs that fit into the [parse_zone(target_zone)] found in internal storage!")
	return FALSE

/datum/surgery_step/remove_fat/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	target.overeatduration = 0 //patient is unfatted
	var/removednutriment = target.nutrition
	target.set_nutrition(NUTRITION_LEVEL_WELL_FED)
	removednutriment -= 450 //whatever was removed goes into the meat
	var/mob/living/carbon/human/H = target
	var/typeofmeat = /obj/item/reagent_containers/food/snacks/meat/slab/human

	if(H.dna && H.dna.species)
		typeofmeat = H.dna.species.meat

	var/obj/item/reagent_containers/food/snacks/meat/slab/human/newmeat = new typeofmeat
	newmeat.name = "fatty meat"
	newmeat.desc = "Extremely fatty tissue taken from a patient."
	newmeat.subjectname = H.real_name
	newmeat.subjectjob = H.job
	newmeat.reagents.add_reagent (/datum/reagent/consumable/nutriment, (removednutriment / 15)) //To balance with nutriment_factor of nutriment
	newmeat.forceMove(get_turf(autodoc))
	autodoc.visible_message("<span class='notice'>\The [autodoc] spits out \the [newmeat]!</span>")
	return TRUE

/datum/surgery_step/replace_limb/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	for(var/obj/item/bodypart/limb in autodoc.contents)
		if(limb.body_zone == target_zone)
			L = limb
			break
	if(L)
		L.replace_limb(target, TRUE)
	return TRUE

/datum/surgery_step/replace_limb/autodoc_check(target_zone, obj/machinery/autodoc/autodoc, silent = TRUE, mob/living/carbon/target)
	for(var/obj/item/bodypart/limb in autodoc.contents)
		if(limb.body_zone == target_zone)
			return TRUE
	if(!silent)
		autodoc.say("No valid bodyparts that fit onto the [parse_zone(target_zone)] found in internal storage!")
	return FALSE

/datum/surgery_step/remove_object/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	if(L)
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			for(var/obj/item/I in L.embedded_objects)
				autodoc.visible_message("<span class='notice'>\The [autodoc] spits out \the [I]!</span>")
				I.forceMove(get_turf(autodoc))
				L.embedded_objects -= I
			if(!H.has_embedded_objects())
				H.clear_alert("embeddedobject")
				SEND_SIGNAL(H, COMSIG_CLEAR_MOOD_EVENT, "embedded")
	return TRUE

/datum/surgery_step/add_prosthetic/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	var/obj/item/bodypart/L
	for(var/obj/item/bodypart/limb in autodoc.contents)
		if(limb.body_zone == target_zone)
			L = limb
			break
	if(L)
		L.attach_limb(target)
		if(organ_rejection_dam)
			target.adjustToxLoss(organ_rejection_dam)
	return TRUE

/datum/surgery_step/insert_pill/autodoc_check(target_zone, obj/machinery/autodoc/autodoc, silent = TRUE, mob/living/carbon/target)
	for(var/obj/item/reagent_containers/pill/P in autodoc.contents)
		return TRUE
	if(!silent)
		autodoc.say("No pills found in internal storage!")
	return FALSE

/datum/surgery_step/insert_pill/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	var/obj/item/reagent_containers/pill/pill
	for(var/obj/item/reagent_containers/pill/P in autodoc.contents)
		pill = P
		break
	if(pill)
		pill.forceMove(target)
		var/datum/action/item_action/hands_free/activate_pill/P = new(pill)
		P.button.name = "Activate [pill.name]"
		P.target = pill
		P.Grant(target)
	return TRUE

/datum/surgery_step/fix_eyes/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	var/obj/item/organ/eyes/E = target.getorganslot(ORGAN_SLOT_EYES)
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

/datum/surgery_step/revive/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	playsound(get_turf(target), 'sound/magic/lightningbolt.ogg', 50, 1)
	target.adjustOxyLoss(-50, 0)
	target.updatehealth()
	if(target.revive())
		target.visible_message("...[target] wakes up, alive and aware!")
		target.emote("gasp")
		target.setOrganLoss(ORGAN_SLOT_BRAIN, 50, 199) //MAD SCIENCE
		return TRUE
	else
		target.visible_message("...[target.p_they()] convulses, then lies still.")
		return FALSE

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

/datum/surgery_step/proc/autodoc_check(target_zone, obj/machinery/autodoc/autodoc, silent = TRUE, mob/living/carbon/target)
	return TRUE

/obj/item/organ/brain
	name = "мозг"
	desc = "Кусок сочного мяса, найденный в голове человека."
	icon_state = "brain"
	throw_speed = 3
	throw_range = 5
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_BRAIN
	organ_flags = ORGAN_VITAL
	attack_verb_continuous = list("атакует", "шлёпает", "вмазывает")
	attack_verb_simple = list("атакует", "шлёпает", "вмазывает")

	///The brain's organ variables are significantly more different than the other organs, with half the decay rate for balance reasons, and twice the maxHealth
	decay_factor = STANDARD_ORGAN_DECAY	* 0.5		//30 minutes of decaying to result in a fully damaged brain, since a fast decay rate would be unfun gameplay-wise

	maxHealth = BRAIN_DAMAGE_DEATH
	low_threshold = 45
	high_threshold = 120

	var/suicided = FALSE
	var/mob/living/brain/brainmob = null
	var/decoy_override = FALSE	//if it's a fake brain with no brainmob assigned. Feedback messages will be faked as if it does have a brainmob. See changelings & dullahans.
	//two variables necessary for calculating whether we get a brain trauma or not
	var/damage_delta = 0


	var/list/datum/brain_trauma/traumas = list()

	/// List of skillchip items, their location should be this brain.
	var/list/obj/item/skillchip/skillchips
	/// Maximum skillchip complexity we can support before they stop working. Do not reference this var directly and instead call get_max_skillchip_complexity()
	var/max_skillchip_complexity = 6
	/// Maximum skillchip slots available. Do not reference this var directly and instead call get_max_skillchip_slots()
	var/max_skillchip_slots = 5

/obj/item/organ/brain/Insert(mob/living/carbon/C, special = 0,no_id_transfer = FALSE)
	. = ..()

	name = "мозг"

	if(C.mind && C.mind.has_antag_datum(/datum/antagonist/changeling) && !no_id_transfer)	//congrats, you're trapped in a body you don't control
		if(brainmob && !(C.stat == DEAD || (HAS_TRAIT(C, TRAIT_DEATHCOMA))))
			to_chat(brainmob, "<span class= danger>Не ощущаю своего тела! Я всё ещё простой мозг!</span>")
		forceMove(C)
		C.update_hair()
		return

	if(brainmob)
		if(C.key)
			C.ghostize()

		if(brainmob.mind)
			brainmob.mind.transfer_to(C)
		else
			C.key = brainmob.key

		QDEL_NULL(brainmob)

	for(var/X in traumas)
		var/datum/brain_trauma/BT = X
		BT.owner = owner
		BT.on_gain()

	//Update the body's icon so it doesnt appear debrained anymore
	C.update_hair()

/obj/item/organ/brain/Remove(mob/living/carbon/C, special = 0, no_id_transfer = FALSE)
	// Delete skillchips first as parent proc sets owner to null, and skillchips need to know the brain's owner.
	if(!QDELETED(C) && length(skillchips))
		to_chat(C, span_notice("Мои чипы навыков включают аварийный режим энергосбережения, деактивируясь, когда мой мозг покидает моё тело..."))
		for(var/chip in skillchips)
			var/obj/item/skillchip/skillchip = chip
			// Run the try_ proc with force = TRUE.
			skillchip.try_deactivate_skillchip(FALSE, TRUE)

	. = ..()

	for(var/X in traumas)
		var/datum/brain_trauma/BT = X
		BT.on_lose(TRUE)
		BT.owner = null

	if((!gc_destroyed || (owner && !owner.gc_destroyed)) && !no_id_transfer)
		transfer_identity(C)
	C.update_hair()

/obj/item/organ/brain/proc/transfer_identity(mob/living/L)
	name = "мозг [L.name]"
	if(brainmob || decoy_override)
		return
	if(!L.mind)
		return
	brainmob = new(src)
	brainmob.name = L.real_name
	brainmob.real_name = L.real_name
	brainmob.timeofhostdeath = L.timeofdeath
	brainmob.suiciding = suicided
	if(L.has_dna())
		var/mob/living/carbon/C = L
		if(!brainmob.stored_dna)
			brainmob.stored_dna = new /datum/dna/stored(brainmob)
		C.dna.copy_dna(brainmob.stored_dna)
		// Hack, fucked dna needs to follow the brain to prevent memes, so we need to copy over the trait sources and shit
		for(var/source in GET_TRAIT_SOURCES(L, TRAIT_BADDNA))
			ADD_TRAIT(brainmob, TRAIT_BADDNA, source)
	if(L.mind && L.mind.current)
		L.mind.transfer_to(brainmob)
	to_chat(brainmob, span_notice("Ощущаю себя немного дезориентированным. Возможно, потому что теперь я просто мозг?"))

/obj/item/organ/brain/attackby(obj/item/O, mob/user, params)
	user.changeNext_move(CLICK_CD_MELEE)

	if(istype(O, /obj/item/organ_storage))
		return //Borg organ bags shouldn't be killing brains

	if((organ_flags & ORGAN_FAILING) && O.is_drainable() && O.reagents.has_reagent(/datum/reagent/medicine/mannitol)) //attempt to heal the brain
		. = TRUE //don't do attack animation.
		if(brainmob?.health <= HEALTH_THRESHOLD_DEAD) //if the brain is fucked anyway, do nothing
			to_chat(user, span_warning("[capitalize(src.name)] слишком сильно повреждён! В мусорку."))
			return

		if(!O.reagents.has_reagent(/datum/reagent/medicine/mannitol, 10))
			to_chat(user, span_warning("Недостаточно маннитола в [O] для попытки восстановить [src.name]!"))
			return

		user.visible_message(span_notice("[user] начинает обильно поливать [src.name] из [O].") , span_notice("Начинаю обильно поливать [src.name] из [O]."))
		if(!do_after(user, 6 SECONDS, src))
			to_chat(user, span_warning("Не вышло нормально починить [src]!"))
			return

		user.visible_message(span_notice("[user] выливает содержимое [O] на [src.name], заставляя его реформировать свою первоначальную форму и приобрести более яркий оттенок розового.") , span_notice("Выливаю содержимое [O] на [src.name], заставляя его реформировать свою первоначальную форму и приобрести более яркий оттенок розового."))
		var/healby = O.reagents.get_reagent_amount(/datum/reagent/medicine/mannitol)
		setOrganDamage(damage - healby*2)	//heals 2 damage per unit of mannitol, and by using "setorgandamage", we clear the failing variable if that was up
		O.reagents.clear_reagents()
		return

	// Cutting out skill chips.
	if(length(skillchips) && O.get_sharpness() == SHARP_EDGED)
		to_chat(user,span_notice("Начинаю вырезать скиллчипы из [src.name]."))
		if(do_after(user, 15 SECONDS, target = src))
			for(var/chip in skillchips)
				var/obj/item/skillchip/skillchip = chip

				if(!istype(skillchip))
					stack_trace("Item of type [skillchip.type] qdel'd from [src] skillchip list.")
					qdel(skillchip)
					continue

				remove_skillchip(skillchip)

				if(skillchip.removable)
					skillchip.forceMove(drop_location())
					continue

				qdel(skillchip)

			skillchips = null
		return

	if(brainmob) //if we aren't trying to heal the brain, pass the attack onto the brainmob.
		O.attack(brainmob, user) //Oh noooeeeee

	if(O.force != 0 && !(O.item_flags & NOBLUDGEON))
		setOrganDamage(maxHealth) //fails the brain as the brain was attacked, they're pretty fragile.
		visible_message(span_danger("[user] бьёт [src.name] используя [O]!"))
		to_chat(user, span_danger("Бью [src.name] используя [O]!"))

/obj/item/organ/brain/examine(mob/user)
	. = ..()
	if(length(skillchips))
		. += "<hr><span class='info'>Внутри торчит скиллчип. Возможно, что не один.</span>"
	if(suicided)
		. += "<hr><span class='info'>Он начал слегка сереть. Носитель, должно быть, не смог справиться со всем этим стрессом.</span>"
		return
	if((brainmob && (brainmob.client || brainmob.get_ghost())) || decoy_override)
		if(organ_flags & ORGAN_FAILING)
			. += "<hr><span class='info'>Кажется, в нем еще есть немного энергии, но он сильно поврежден... Возможно, получится восстановить его с помощью <b>маннитола</b>.</span>"
		else if(damage >= BRAIN_DAMAGE_DEATH*0.5)
			. += "<hr><span class='info'>Можно почувствовать небольшую искру жизни, которая все еще осталась в этом мозге, но он повреждён. Возможно, получится восстановить его с помощью <b>маннитола</b>.</span>"
		else
			. += "<hr><span class='info'>Можно почувствовать маленькую искру жизни, которая все еще осталась в этом мозге.</span>"
	else
		. += "<hr><span class='info'>Он полностью мёртв.</span>"

/obj/item/organ/brain/attack(mob/living/carbon/C, mob/user)
	if(!istype(C))
		return ..()

	add_fingerprint(user)

	if(user.zone_selected != BODY_ZONE_HEAD)
		return ..()

	var/target_has_brain = C.getorgan(/obj/item/organ/brain)

	if(!target_has_brain && C.is_eyes_covered())
		to_chat(user, span_warning("Стоит открыть [C.ru_ego()] голову сначала!"))
		return

	//since these people will be dead M != usr

	if(!target_has_brain)
		if(!C.get_bodypart(BODY_ZONE_HEAD) || !user.temporarilyRemoveItemFromInventory(src))
			return
		var/msg = "[C] вставляет [src] в голову [user]."
		if(C == user)
			msg = "[user] вставляет [src] в [user.ru_ego()] голову!"

		C.visible_message(span_danger("[msg]") ,
						span_userdanger("[msg]"))

		if(C != user)
			to_chat(C, span_notice("[user] вставляет [src] в мою голову."))
			to_chat(user, span_notice("Вставляю [src] в голову [C]."))
		else
			to_chat(user, span_notice("Вставляю [src] в свою голову.") 	)

		Insert(C)
	else
		..()

/obj/item/organ/brain/Destroy() //copypasted from MMIs.
	if(brainmob)
		QDEL_NULL(brainmob)
	QDEL_LIST(traumas)

	destroy_all_skillchips()
	if(owner?.mind) //You aren't allowed to return to brains that don't exist
		owner.mind.set_current(null)
	return ..()

/obj/item/organ/brain/on_life(delta_time, times_fired)
	if(damage >= BRAIN_DAMAGE_DEATH) //rip
		to_chat(owner, span_userdanger("Последняя искра жизни в моём мозгу угасает.."))
		owner.death()

/obj/item/organ/brain/check_damage_thresholds(mob/M)
	. = ..()
	//if we're not more injured than before, return without gambling for a trauma
	if(damage <= prev_damage)
		return
	damage_delta = damage - prev_damage
	if(damage > BRAIN_DAMAGE_MILD)
		if(prob(damage_delta * (1 + max(0, (damage - BRAIN_DAMAGE_MILD)/100)))) //Base chance is the hit damage; for every point of damage past the threshold the chance is increased by 1% //learn how to do your bloody math properly goddamnit
			gain_trauma_type(BRAIN_TRAUMA_MILD, natural_gain = TRUE)

	var/is_boosted = (owner && HAS_TRAIT(owner, TRAIT_SPECIAL_TRAUMA_BOOST))
	if(damage > BRAIN_DAMAGE_SEVERE)
		if(prob(damage_delta * (1 + max(0, (damage - BRAIN_DAMAGE_SEVERE)/100)))) //Base chance is the hit damage; for every point of damage past the threshold the chance is increased by 1%
			if(prob(20 + (is_boosted * 30)))
				gain_trauma_type(BRAIN_TRAUMA_SPECIAL, is_boosted ? TRAUMA_RESILIENCE_SURGERY : null, natural_gain = TRUE)
			else
				gain_trauma_type(BRAIN_TRAUMA_SEVERE, natural_gain = TRUE)

	if (owner)
		if(owner.stat < UNCONSCIOUS) //conscious or soft-crit
			var/brain_message
			if(prev_damage < BRAIN_DAMAGE_MILD && damage >= BRAIN_DAMAGE_MILD)
				brain_message = span_warning("Ощущаю лёгкое головокружение.")
			else if(prev_damage < BRAIN_DAMAGE_SEVERE && damage >= BRAIN_DAMAGE_SEVERE)
				brain_message = span_warning("Чувствую, что меньше контролирую свои мысли")
			else if(prev_damage < (BRAIN_DAMAGE_DEATH - 20) && damage >= (BRAIN_DAMAGE_DEATH - 20))
				brain_message = span_warning("Воспринимаю, что мой разум скоро отключится совсем...")

			if(.)
				. += "\n[brain_message]"
			else
				return brain_message

/obj/item/organ/brain/before_organ_replacement(obj/item/organ/replacement)
	. = ..()
	var/obj/item/organ/brain/replacement_brain = replacement
	if(!istype(replacement_brain))
		return

	// If we have some sort of brain type or subtype change and have skillchips, engage the failsafe procedure!
	if(owner && length(skillchips) && (replacement_brain.type != type))
		activate_skillchip_failsafe(FALSE)

	// Check through all our skillchips, remove them from this brain, add them to the replacement brain.
	for(var/chip in skillchips)
		var/obj/item/skillchip/skillchip = chip

		// We're technically doing a little hackery here by bypassing the procs, but I'm the one who wrote them
		// and when you know the rules, you can break the rules.

		// Technically the owning mob is the same. We don't need to activate or deactivate the skillchips.
		// All the skillchips themselves care about is what brain they're in.
		// Because the new brain will ultimately be owned by the same body, we can safely leave skillchip logic alone.

		// Directly change the new holding_brain.
		skillchip.holding_brain = replacement_brain
		//And move the actual obj into the new brain (contents)
		skillchip.forceMove(replacement_brain)

		// Directly add them to the skillchip list in the new brain.
		LAZYADD(replacement_brain.skillchips, skillchip)

	// Any skillchips has been transferred over, time to empty the list.
	LAZYCLEARLIST(skillchips)

/obj/item/organ/brain/alien
	name = "чужеродный мозг"
	desc = "Мы почти не понимаем мозг земных животных. Кто знает, что мы можем найти в мозгу столь продвинутого вида?"
	icon_state = "brain-x"


////////////////////////////////////TRAUMAS////////////////////////////////////////

/obj/item/organ/brain/proc/has_trauma_type(brain_trauma_type = /datum/brain_trauma, resilience = TRAUMA_RESILIENCE_ABSOLUTE)
	for(var/X in traumas)
		var/datum/brain_trauma/BT = X
		if(istype(BT, brain_trauma_type) && (BT.resilience <= resilience))
			return BT

/obj/item/organ/brain/proc/get_traumas_type(brain_trauma_type = /datum/brain_trauma, resilience = TRAUMA_RESILIENCE_ABSOLUTE)
	. = list()
	for(var/X in traumas)
		var/datum/brain_trauma/BT = X
		if(istype(BT, brain_trauma_type) && (BT.resilience <= resilience))
			. += BT

/obj/item/organ/brain/proc/can_gain_trauma(datum/brain_trauma/trauma, resilience, natural_gain = FALSE)
	if(!ispath(trauma))
		trauma = trauma.type
	if(!initial(trauma.can_gain))
		return FALSE
	if(!resilience)
		resilience = initial(trauma.resilience)

	var/resilience_tier_count = 0
	for(var/X in traumas)
		if(istype(X, trauma))
			return FALSE
		var/datum/brain_trauma/T = X
		if(resilience == T.resilience)
			resilience_tier_count++

	var/max_traumas
	switch(resilience)
		if(TRAUMA_RESILIENCE_BASIC)
			max_traumas = TRAUMA_LIMIT_BASIC
		if(TRAUMA_RESILIENCE_SURGERY)
			max_traumas = TRAUMA_LIMIT_SURGERY
		if(TRAUMA_RESILIENCE_WOUND)
			max_traumas = TRAUMA_LIMIT_WOUND
		if(TRAUMA_RESILIENCE_LOBOTOMY)
			max_traumas = TRAUMA_LIMIT_LOBOTOMY
		if(TRAUMA_RESILIENCE_MAGIC)
			max_traumas = TRAUMA_LIMIT_MAGIC
		if(TRAUMA_RESILIENCE_ABSOLUTE)
			max_traumas = TRAUMA_LIMIT_ABSOLUTE

	if(natural_gain && resilience_tier_count >= max_traumas)
		return FALSE
	return TRUE

//Proc to use when directly adding a trauma to the brain, so extra args can be given
/obj/item/organ/brain/proc/gain_trauma(datum/brain_trauma/trauma, resilience, ...)
	var/list/arguments = list()
	if(args.len > 2)
		arguments = args.Copy(3)
	. = brain_gain_trauma(trauma, resilience, arguments)

//Direct trauma gaining proc. Necessary to assign a trauma to its brain. Avoid using directly.
/obj/item/organ/brain/proc/brain_gain_trauma(datum/brain_trauma/trauma, resilience, list/arguments)
	if(!can_gain_trauma(trauma, resilience))
		return FALSE

	var/datum/brain_trauma/actual_trauma
	if(ispath(trauma))
		if(!LAZYLEN(arguments))
			actual_trauma = new trauma() //arglist with an empty list runtimes for some reason
		else
			actual_trauma = new trauma(arglist(arguments))
	else
		actual_trauma = trauma

	if(actual_trauma.brain) //we don't accept used traumas here
		WARNING("gain_trauma was given an already active trauma.")
		return FALSE

	traumas += actual_trauma
	actual_trauma.brain = src
	if(owner)
		actual_trauma.owner = owner
		SEND_SIGNAL(owner, COMSIG_CARBON_GAIN_TRAUMA, trauma)
		actual_trauma.on_gain()
	if(resilience)
		actual_trauma.resilience = resilience
	. = actual_trauma
	SSblackbox.record_feedback("tally", "traumas", 1, actual_trauma.type)
	return TRUE

//Add a random trauma of a certain subtype
/obj/item/organ/brain/proc/gain_trauma_type(brain_trauma_type = /datum/brain_trauma, resilience, natural_gain = FALSE)
	var/list/datum/brain_trauma/possible_traumas = list()
	for(var/T in subtypesof(brain_trauma_type))
		var/datum/brain_trauma/BT = T
		if(can_gain_trauma(BT, resilience, natural_gain) && initial(BT.random_gain))
			possible_traumas += BT

	if(!LAZYLEN(possible_traumas))
		return

	var/trauma_type = pick(possible_traumas)
	return gain_trauma(trauma_type, resilience)

//Cure a random trauma of a certain resilience level
/obj/item/organ/brain/proc/cure_trauma_type(brain_trauma_type = /datum/brain_trauma, resilience = TRAUMA_RESILIENCE_BASIC)
	var/list/traumas = get_traumas_type(brain_trauma_type, resilience)
	if(LAZYLEN(traumas))
		qdel(pick(traumas))

/obj/item/organ/brain/proc/cure_all_traumas(resilience = TRAUMA_RESILIENCE_BASIC)
	var/amount_cured = 0
	var/list/traumas = get_traumas_type(resilience = resilience)
	for(var/X in traumas)
		qdel(X)
		amount_cured++
	return amount_cured

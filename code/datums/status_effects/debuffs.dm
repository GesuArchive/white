#define TRAIT_STATUS_EFFECT(effect_id) "[effect_id]-trait"

//Largely negative status effects go here, even if they have small benificial effects
//STUN EFFECTS
/datum/status_effect/incapacitating
	tick_interval = 0
	status_type = STATUS_EFFECT_REPLACE
	alert_type = null
	var/needs_update_stat = FALSE

/datum/status_effect/incapacitating/on_creation(mob/living/new_owner, set_duration)
	if(isnum(set_duration))
		duration = set_duration
	. = ..()
	if(. && (needs_update_stat || issilicon(owner)))
		owner.update_stat()


/datum/status_effect/incapacitating/on_remove()
	if(needs_update_stat || issilicon(owner)) //silicons need stat updates in addition to normal canmove updates
		owner.update_stat()
	return ..()


//STUN
/datum/status_effect/incapacitating/stun
	id = "stun"

/datum/status_effect/incapacitating/stun/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_INCAPACITATED, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_HANDS_BLOCKED, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/stun/on_remove()
	REMOVE_TRAIT(owner, TRAIT_INCAPACITATED, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_HANDS_BLOCKED, TRAIT_STATUS_EFFECT(id))
	return ..()


//KNOCKDOWN
/datum/status_effect/incapacitating/knockdown
	id = "knockdown"

/datum/status_effect/incapacitating/knockdown/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_FLOORED, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/knockdown/on_remove()
	REMOVE_TRAIT(owner, TRAIT_FLOORED, TRAIT_STATUS_EFFECT(id))
	return ..()


//IMMOBILIZED
/datum/status_effect/incapacitating/immobilized
	id = "immobilized"

/datum/status_effect/incapacitating/immobilized/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/immobilized/on_remove()
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_STATUS_EFFECT(id))
	return ..()


//PARALYZED
/datum/status_effect/incapacitating/paralyzed
	id = "paralyzed"

/datum/status_effect/incapacitating/paralyzed/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_INCAPACITATED, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_FLOORED, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_HANDS_BLOCKED, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/paralyzed/on_remove()
	REMOVE_TRAIT(owner, TRAIT_INCAPACITATED, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_FLOORED, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_HANDS_BLOCKED, TRAIT_STATUS_EFFECT(id))
	return ..()


//UNCONSCIOUS
/datum/status_effect/incapacitating/unconscious
	id = "unconscious"
	needs_update_stat = TRUE

/datum/status_effect/incapacitating/unconscious/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/unconscious/on_remove()
	REMOVE_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))
	return ..()

/datum/status_effect/incapacitating/unconscious/tick()
	if(owner.getStaminaLoss())
		owner.adjustStaminaLoss(-0.3) //reduce stamina loss by 0.3 per tick, 6 per 2 seconds


//SLEEPING
/datum/status_effect/incapacitating/sleeping
	id = "sleeping"
	alert_type = /atom/movable/screen/alert/status_effect/asleep
	needs_update_stat = TRUE
	tick_interval = 2 SECONDS
	var/mob/living/carbon/carbon_owner
	var/mob/living/carbon/human/human_owner

/datum/status_effect/incapacitating/sleeping/on_creation(mob/living/new_owner)
	. = ..()
	if(.)
		if(iscarbon(owner)) //to avoid repeated istypes
			carbon_owner = owner
		if(ishuman(owner))
			human_owner = owner

/datum/status_effect/incapacitating/sleeping/Destroy()
	carbon_owner = null
	human_owner = null
	return ..()

/datum/status_effect/incapacitating/sleeping/on_apply()
	. = ..()
	if(!.)
		return
	if(!HAS_TRAIT(owner, TRAIT_SLEEPIMMUNE))
		ADD_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))
		tick_interval = -1
	RegisterSignal(owner, SIGNAL_ADDTRAIT(TRAIT_SLEEPIMMUNE), PROC_REF(on_owner_insomniac))
	RegisterSignal(owner, SIGNAL_REMOVETRAIT(TRAIT_SLEEPIMMUNE), PROC_REF(on_owner_sleepy))

/datum/status_effect/incapacitating/sleeping/on_remove()
	UnregisterSignal(owner, list(SIGNAL_ADDTRAIT(TRAIT_SLEEPIMMUNE), SIGNAL_REMOVETRAIT(TRAIT_SLEEPIMMUNE)))
	if(!HAS_TRAIT(owner, TRAIT_SLEEPIMMUNE))
		REMOVE_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))
		tick_interval = initial(tick_interval)
	return ..()

///If the mob is sleeping and gain the TRAIT_SLEEPIMMUNE we remove the TRAIT_KNOCKEDOUT and stop the tick() from happening
/datum/status_effect/incapacitating/sleeping/proc/on_owner_insomniac(mob/living/source)
	SIGNAL_HANDLER
	REMOVE_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))
	tick_interval = -1

///If the mob has the TRAIT_SLEEPIMMUNE but somehow looses it we make him sleep and restart the tick()
/datum/status_effect/incapacitating/sleeping/proc/on_owner_sleepy(mob/living/source)
	SIGNAL_HANDLER
	ADD_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))
	tick_interval = initial(tick_interval)

/datum/status_effect/incapacitating/sleeping/tick()
	if(owner.maxHealth)
		var/health_ratio = owner.health / owner.maxHealth
		var/healing = -1
		if((locate(/obj/structure/bed) in owner.loc))
			healing -= 2
		else if((locate(/obj/structure/table) in owner.loc))
			healing -= 1
		for(var/obj/item/bedsheet/bedsheet in range(owner.loc,0))
			if(bedsheet.loc != owner.loc) //bedsheets in your backpack/neck don't give you comfort
				continue
			healing -= 1
			break //Only count the first bedsheet
		if(health_ratio < 0.8)
			owner.adjustBruteLoss(healing)
			owner.adjustFireLoss(healing)
			owner.adjustToxLoss(healing * 0.5, TRUE, TRUE)
		owner.adjustStaminaLoss(healing)
	if(human_owner?.drunkenness)
		human_owner.drunkenness *= 0.997 //reduce drunkenness by 0.3% per tick, 6% per 2 seconds
	if(prob(20))
		if(carbon_owner)
			carbon_owner.handle_dreams()
		if(prob(10) && owner.health > owner.crit_threshold)
			owner.emote("snore")

/atom/movable/screen/alert/status_effect/asleep
	name = "Сон"
	desc = "Я сплю. Скоро проснусь, надеюсь."
	icon_state = "asleep"

//STASIS
/datum/status_effect/grouped/stasis
	id = "stasis"
	duration = -1
	tick_interval = 10
	alert_type = /atom/movable/screen/alert/status_effect/stasis
	var/last_dead_time

/datum/status_effect/grouped/stasis/proc/update_time_of_death()
	if(last_dead_time)
		var/delta = world.time - last_dead_time
		var/new_timeofdeath = owner.timeofdeath + delta
		owner.timeofdeath = new_timeofdeath
		owner.tod = station_time_timestamp()
		last_dead_time = null
	if(owner.stat == DEAD)
		last_dead_time = world.time

/datum/status_effect/grouped/stasis/on_creation(mob/living/new_owner, set_duration)
	. = ..()
	if(.)
		update_time_of_death()
		owner.reagents?.end_metabolization(owner, FALSE)

/datum/status_effect/grouped/stasis/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_HANDS_BLOCKED, TRAIT_STATUS_EFFECT(id))
	owner.add_filter("stasis_status_ripple", 2, list("type" = "ripple", "flags" = WAVE_BOUNDED, "radius" = 0, "size" = 2))
	var/filter = owner.get_filter("stasis_status_ripple")
	animate(filter, radius = 32, time = 15, size = 0, loop = -1)

	if(iscarbon(owner))
		var/mob/living/carbon/carbon_owner = owner
		carbon_owner.update_bodypart_bleed_overlays()


/datum/status_effect/grouped/stasis/tick()
	update_time_of_death()

/datum/status_effect/grouped/stasis/on_remove()
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_HANDS_BLOCKED, TRAIT_STATUS_EFFECT(id))
	owner.remove_filter("stasis_status_ripple")
	update_time_of_death()
	if(iscarbon(owner))
		var/mob/living/carbon/carbon_owner = owner
		carbon_owner.update_bodypart_bleed_overlays()
	return ..()

/atom/movable/screen/alert/status_effect/stasis
	name = "Стазис"
	desc = "Мои биологические функции остановились. Можно так жить вечно, но это довольно скучно."
	icon_state = "stasis"

//GOLEM GANG

//OTHER DEBUFFS
/datum/status_effect/strandling //get it, strand as in durathread strand + strangling = strandling hahahahahahahahahahhahahaha i want to die
	id = "strandling"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/strandling

/datum/status_effect/strandling/on_apply()
	ADD_TRAIT(owner, TRAIT_MAGIC_CHOKE, "dumbmoron")
	return ..()

/datum/status_effect/strandling/on_remove()
	REMOVE_TRAIT(owner, TRAIT_MAGIC_CHOKE, "dumbmoron")
	return ..()

/atom/movable/screen/alert/status_effect/strandling
	name = "Choking strand"
	desc = "Волшебная прядь протектора дюраткань обернута вокруг шеи, препятствуя дыханию! Щелкните этот значок, чтобы удалить прядь."
	icon_state = "his_grace"
	alerttooltipstyle = "hisgrace"

/atom/movable/screen/alert/status_effect/strandling/Click(location, control, params)
	. = ..()
	if(usr != owner)
		return
	to_chat(owner, span_notice("Пытаюсь снять прядь дюраткани с моей шеи."))
	if(do_after(owner, 3.5 SECONDS, owner))
		if(isliving(owner))
			var/mob/living/L = owner
			to_chat(owner, span_notice("Успешно удаляю прядь дюраткани."))
			L.remove_status_effect(STATUS_EFFECT_CHOKINGSTRAND)

//OTHER DEBUFFS
/datum/status_effect/pacify
	id = "pacify"
	status_type = STATUS_EFFECT_REPLACE
	tick_interval = 1
	duration = 100
	alert_type = null

/datum/status_effect/pacify/on_creation(mob/living/new_owner, set_duration)
	if(isnum(set_duration))
		duration = set_duration
	. = ..()

/datum/status_effect/pacify/on_apply()
	ADD_TRAIT(owner, TRAIT_PACIFISM, "status_effect")
	return ..()

/datum/status_effect/pacify/on_remove()
	REMOVE_TRAIT(owner, TRAIT_PACIFISM, "status_effect")

/datum/status_effect/his_wrath //does minor damage over time unless holding His Grace
	id = "his_wrath"
	duration = -1
	tick_interval = 4
	alert_type = /atom/movable/screen/alert/status_effect/his_wrath

/atom/movable/screen/alert/status_effect/his_wrath
	name = "Его Гнев"
	desc = "Я бежал от Его милости вместо того, чтобы накормить Его, и теперь страдаю."
	icon_state = "his_grace"
	alerttooltipstyle = "hisgrace"

/datum/status_effect/his_wrath/tick()
	for(var/obj/item/his_grace/HG in owner.held_items)
		qdel(src)
		return
	owner.adjustBruteLoss(0.1)
	owner.adjustFireLoss(0.1)
	owner.adjustToxLoss(0.2, TRUE, TRUE)

/datum/status_effect/cultghost //is a cult ghost and can't use manifest runes
	id = "cult_ghost"
	duration = -1
	alert_type = null

/datum/status_effect/cultghost/on_apply()
	owner.set_invis_see(SEE_INVISIBLE_OBSERVER)
	owner.set_see_in_dark(2)

/datum/status_effect/cultghost/tick()
	if(owner.reagents)
		owner.reagents.del_reagent(/datum/reagent/water/holywater) //can't be deconverted

/datum/status_effect/the_shadow
	id = "the_shadow"
	status_type = STATUS_EFFECT_REPLACE
	alert_type = null
	duration = -1
	var/mutable_appearance/shadow

/datum/status_effect/the_shadow/on_apply()
	if(ishuman(owner))
		shadow = mutable_appearance('icons/effects/effects.dmi', "curse")
		shadow.pixel_x = -owner.pixel_x
		shadow.pixel_y = -owner.pixel_y
		owner.add_overlay(shadow)
		to_chat(owner, span_boldwarning("The shadows invade your mind, MUST. GET. THEM. OUT"))
		return TRUE
	return FALSE

/datum/status_effect/the_shadow/tick()
	var/turf/T = get_turf(owner)
	var/light_amount = T.get_lumcount()
	if(light_amount > 0.2)
		to_chat(owner, span_notice("As the light reaches the shadows, they dissipate!"))
		qdel(src)
	if(owner.stat == DEAD)
		qdel(src)
	owner.hallucination += 2
	owner.set_confusion(2)
	owner.adjustOrganLoss(ORGAN_SLOT_EARS, 5)

/datum/status_effect/the_shadow/Destroy()
	if(owner)
		owner.cut_overlay(shadow)
	QDEL_NULL(shadow)
	return ..()

/datum/status_effect/crusher_mark
	id = "crusher_mark"
	duration = 300 //if you leave for 30 seconds you lose the mark, deal with it
	status_type = STATUS_EFFECT_REPLACE
	alert_type = null
	var/mutable_appearance/marked_underlay
	var/obj/item/kinetic_crusher/hammer_synced

/datum/status_effect/crusher_mark/on_creation(mob/living/new_owner, obj/item/kinetic_crusher/new_hammer_synced)
	. = ..()
	if(.)
		hammer_synced = new_hammer_synced

/datum/status_effect/crusher_mark/on_apply()
	if(owner.mob_size >= MOB_SIZE_LARGE)
		marked_underlay = mutable_appearance('icons/effects/effects.dmi', "shield2")
		marked_underlay.pixel_x = -owner.pixel_x
		marked_underlay.pixel_y = -owner.pixel_y
		owner.underlays += marked_underlay
		return TRUE
	return FALSE

/datum/status_effect/crusher_mark/Destroy()
	hammer_synced = null
	if(owner)
		owner.underlays -= marked_underlay
	QDEL_NULL(marked_underlay)
	return ..()

/datum/status_effect/crusher_mark/be_replaced()
	owner.underlays -= marked_underlay //if this is being called, we should have an owner at this point.
	..()

/datum/status_effect/eldritch
	id = "heretic_mark"
	duration = 15 SECONDS
	status_type = STATUS_EFFECT_REPLACE
	alert_type = null
	on_remove_on_mob_delete = TRUE
	///underlay used to indicate that someone is marked
	var/mutable_appearance/marked_underlay
	/// icon file for the underlay
	var/effect_icon = 'icons/effects/eldritch.dmi'
	/// icon state for the underlay
	var/effect_icon_state = ""

/datum/status_effect/eldritch/on_creation(mob/living/new_owner, ...)
	marked_underlay = mutable_appearance(effect_icon, effect_icon_state, BELOW_MOB_LAYER)
	return ..()

/datum/status_effect/eldritch/Destroy()
	QDEL_NULL(marked_underlay)
	return ..()

/datum/status_effect/eldritch/on_apply()
	if(owner.mob_size >= MOB_SIZE_HUMAN)
		RegisterSignal(owner, COMSIG_ATOM_UPDATE_OVERLAYS, PROC_REF(update_owner_underlay))
		owner.update_icon(UPDATE_OVERLAYS)
		return TRUE
	return FALSE

/datum/status_effect/eldritch/on_remove()
	UnregisterSignal(owner, COMSIG_ATOM_UPDATE_OVERLAYS)
	owner.update_icon(UPDATE_OVERLAYS)
	return ..()

/**
 * Signal proc for [COMSIG_ATOM_UPDATE_OVERLAYS].
 *
 * Adds the generated mark overlay to the afflicted.
 */
/datum/status_effect/eldritch/proc/update_owner_underlay(atom/source, list/overlays)
	SIGNAL_HANDLER

	overlays += marked_underlay

/**
 * Called when the mark is activated by the heretic.
 */
/datum/status_effect/eldritch/proc/on_effect()
	SHOULD_CALL_PARENT(TRUE)

	playsound(owner, 'sound/magic/repulse.ogg', 75, TRUE)
	qdel(src) //what happens when this is procced.

//Each mark has diffrent effects when it is destroyed that combine with the mansus grasp effect.
/datum/status_effect/eldritch/flesh
	effect_icon_state = "emark1"

/datum/status_effect/eldritch/flesh/on_effect()
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		var/obj/item/bodypart/bodypart = pick(human_owner.bodyparts)
		var/datum/wound/slash/severe/crit_wound = new()
		crit_wound.apply_wound(bodypart)

	return ..()

/datum/status_effect/eldritch/ash
	effect_icon_state = "emark2"
	/// Dictates how much stamina and burn damage the mark will cause on trigger.
	var/repetitions = 1

/datum/status_effect/eldritch/ash/on_creation(mob/living/new_owner, repetition = 5)
	. = ..()
	src.repetitions = max(1, repetition)

/datum/status_effect/eldritch/ash/on_effect()
	if(iscarbon(owner))
		var/mob/living/carbon/carbon_owner = owner
		carbon_owner.adjustStaminaLoss(6 * repetitions) // first one = 30 stam
		carbon_owner.adjustFireLoss(3 * repetitions) // first one = 15 burn
		for(var/mob/living/carbon/victim in shuffle(range(1, carbon_owner)))
			if(IS_HERETIC(victim) || victim == carbon_owner)
				continue
			victim.apply_status_effect(type, repetitions - 1)
			break

	return ..()

/datum/status_effect/eldritch/rust
	effect_icon_state = "emark3"

/datum/status_effect/eldritch/rust/on_effect()
	if(iscarbon(owner))
		var/mob/living/carbon/carbon_owner = owner
		var/static/list/organs_to_damage = list(
			ORGAN_SLOT_BRAIN,
			ORGAN_SLOT_EARS,
			ORGAN_SLOT_EYES,
			ORGAN_SLOT_LIVER,
			ORGAN_SLOT_LUNGS,
			ORGAN_SLOT_STOMACH,
			ORGAN_SLOT_HEART,
		)

		// Roughly 75% of their organs will take a bit of damage
		for(var/organ_slot in organs_to_damage)
			if(prob(75))
				carbon_owner.adjustOrganLoss(organ_slot, 20)

		// And roughly 75% of their items will take a smack, too
		for(var/obj/item/thing in carbon_owner.get_all_gear())
			if(!QDELETED(thing) && prob(75))
				thing.take_damage(100)

	return ..()

/datum/status_effect/eldritch/void
	effect_icon_state = "emark4"

/datum/status_effect/eldritch/void/on_effect()
	var/turf/open/our_turf = get_turf(owner)
	our_turf.TakeTemperature(-40)
	owner.adjust_bodytemperature(-20)

	if(iscarbon(owner))
		var/mob/living/carbon/carbon_owner = owner
		carbon_owner.silent += 5

	return ..()

/datum/status_effect/eldritch/blade
	effect_icon_state = "emark5"
	/// If set, the owner of the status effect will not be able to leave this area.
	var/area/locked_to

/datum/status_effect/eldritch/blade/Destroy()
	locked_to = null
	return ..()

/datum/status_effect/eldritch/blade/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOVABLE_PRE_THROW, PROC_REF(on_pre_throw))
	RegisterSignal(owner, COMSIG_MOVABLE_TELEPORTED, PROC_REF(on_teleport))
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(on_move))

/datum/status_effect/eldritch/blade/on_remove()
	UnregisterSignal(owner, list(
		COMSIG_MOVABLE_PRE_THROW,
		COMSIG_MOVABLE_TELEPORTED,
		COMSIG_MOVABLE_MOVED,
	))

	return ..()

/// Checks if the movement from moving_from to going_to leaves our [var/locked_to] area. Returns TRUE if so.
/datum/status_effect/eldritch/blade/proc/is_escaping_locked_area(atom/moving_from, atom/going_to)
	if(!locked_to)
		return FALSE

	// If moving_from isn't in our locked area, it means they've
	// somehow completely escaped, so we'll opt not to act on them.
	if(get_area(moving_from) != locked_to)
		return FALSE

	// If going_to is in our locked area,
	// they're just moving within the area like normal.
	if(get_area(going_to) == locked_to)
		return FALSE

	return TRUE

/// Signal proc for [COMSIG_MOVABLE_PRE_THROW] that prevents people from escaping our locked area via throw.
/datum/status_effect/eldritch/blade/proc/on_pre_throw(mob/living/source, list/throw_args)
	SIGNAL_HANDLER

	var/atom/throw_dest = throw_args[1]
	if(!is_escaping_locked_area(source, throw_dest))
		return

	var/mob/thrower = throw_args[4]
	if(istype(thrower))
		to_chat(thrower, span_hypnophrase("An otherworldly force prevents you from throwing [source] out of [get_area_name(locked_to)]!"))

	to_chat(source, span_hypnophrase("An otherworldly force prevents you from being thrown out of [get_area_name(locked_to)]!"))

	return COMPONENT_CANCEL_THROW

/// Signal proc for [COMSIG_MOVABLE_TELEPORTED] that blocks any teleports from our locked area.
/datum/status_effect/eldritch/blade/proc/on_teleport(mob/living/source, atom/destination, channel)
	SIGNAL_HANDLER

	if(!is_escaping_locked_area(source, destination))
		return

	to_chat(source, span_hypnophrase("An otherworldly force prevents your escape from [get_area_name(locked_to)]!"))

	source.Stun(1 SECONDS)
	return COMPONENT_BLOCK_TELEPORT

/// Signal proc for [COMSIG_MOVABLE_MOVED] that blocks any movement out of our locked area
/datum/status_effect/eldritch/blade/proc/on_move(mob/living/source, turf/old_loc, movement_dir, forced)
	SIGNAL_HANDLER

	// Let's not mess with heretics dragging a potential victim.
	if(ismob(source.pulledby) && IS_HERETIC(source.pulledby))
		return

	// If the movement's forced, just let it happen regardless.
	if(forced || !is_escaping_locked_area(old_loc, source))
		return

	to_chat(source, span_hypnophrase("An otherworldly force prevents your escape from [get_area_name(locked_to)]!"))

	var/turf/further_behind_old_loc = get_edge_target_turf(old_loc, REVERSE_DIR(movement_dir))

	source.Stun(1 SECONDS)
	source.throw_at(further_behind_old_loc, 3, 1, gentle = TRUE) // Keeping this gentle so they don't smack into the heretic max speed

/// A status effect used for specifying confusion on a living mob.
/// Created automatically with /mob/living/set_confusion.
/datum/status_effect/confusion
	id = "confusion"
	alert_type = null
	var/strength

/datum/status_effect/confusion/tick()
	strength -= 1
	if (strength <= 0)
		owner.remove_status_effect(STATUS_EFFECT_CONFUSION)
		return

/datum/status_effect/confusion/proc/set_strength(new_strength)
	strength = new_strength

/datum/status_effect/stacking/saw_bleed
	id = "saw_bleed"
	tick_interval = 6
	delay_before_decay = 5
	stack_threshold = 10
	max_stacks = 10
	overlay_file = 'icons/effects/bleed.dmi'
	underlay_file = 'icons/effects/bleed.dmi'
	overlay_state = "bleed"
	underlay_state = "bleed"
	var/bleed_damage = 200

/datum/status_effect/stacking/saw_bleed/fadeout_effect()
	new /obj/effect/temp_visual/bleed(get_turf(owner))

/datum/status_effect/stacking/saw_bleed/threshold_cross_effect()
	owner.adjustBruteLoss(bleed_damage)
	var/turf/T = get_turf(owner)
	new /obj/effect/temp_visual/bleed/explode(T)
	for(var/d in GLOB.alldirs)
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(T, d)
	playsound(T, "desecration", 100, TRUE, -1)

/datum/status_effect/stacking/saw_bleed/bloodletting
	id = "bloodletting"
	stack_threshold = 7
	max_stacks = 7
	bleed_damage = 20

/datum/status_effect/neck_slice
	id = "neck_slice"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	duration = -1

/datum/status_effect/neck_slice/tick()
	var/mob/living/carbon/human/H = owner
	var/obj/item/bodypart/throat = H.get_bodypart(BODY_ZONE_HEAD)
	if(!throat)
		H.remove_status_effect(/datum/status_effect/neck_slice)

	var/still_bleeding = FALSE
	for(var/thing in throat.wounds)
		var/datum/wound/W = thing
		if(W.wound_type == WOUND_SLASH && W.severity > WOUND_SEVERITY_MODERATE)
			still_bleeding = TRUE
			break
	if(!still_bleeding)
		H.remove_status_effect(/datum/status_effect/neck_slice)

	if(prob(10))
		H.emote(pick("gasp", "gag", "choke"))

/mob/living/proc/apply_necropolis_curse(set_curse)
	var/datum/status_effect/necropolis_curse/C = has_status_effect(STATUS_EFFECT_NECROPOLIS_CURSE)
	if(!set_curse)
		set_curse = pick(CURSE_BLINDING, CURSE_SPAWNING, CURSE_WASTING, CURSE_GRASPING)
	if(QDELETED(C))
		apply_status_effect(STATUS_EFFECT_NECROPOLIS_CURSE, set_curse)
	else
		C.apply_curse(set_curse)
		C.duration += 3000 //time added by additional curses
	return C

/datum/status_effect/necropolis_curse
	id = "necrocurse"
	duration = 6000 //you're cursed for 10 minutes have fun
	tick_interval = 50
	alert_type = null
	var/curse_flags = NONE
	var/effect_last_activation = 0
	var/effect_cooldown = 100
	var/obj/effect/temp_visual/curse/wasting_effect = new

/datum/status_effect/necropolis_curse/on_creation(mob/living/new_owner, set_curse)
	. = ..()
	if(.)
		apply_curse(set_curse)

/datum/status_effect/necropolis_curse/Destroy()
	if(!QDELETED(wasting_effect))
		qdel(wasting_effect)
		wasting_effect = null
	return ..()

/datum/status_effect/necropolis_curse/on_remove()
	remove_curse(curse_flags)

/datum/status_effect/necropolis_curse/proc/apply_curse(set_curse)
	curse_flags |= set_curse
	if(curse_flags & CURSE_BLINDING)
		owner.overlay_fullscreen("curse", /atom/movable/screen/fullscreen/curse, 1)

/datum/status_effect/necropolis_curse/proc/remove_curse(remove_curse)
	if(remove_curse & CURSE_BLINDING)
		owner.clear_fullscreen("curse", 50)
	curse_flags &= ~remove_curse

/datum/status_effect/necropolis_curse/tick()
	if(owner.stat == DEAD)
		return
	if(curse_flags & CURSE_WASTING)
		wasting_effect.forceMove(owner.loc)
		wasting_effect.setDir(owner.dir)
		wasting_effect.transform = owner.transform //if the owner has been stunned the overlay should inherit that position
		wasting_effect.alpha = 255
		animate(wasting_effect, alpha = 0, time = 32)
		playsound(owner, 'sound/effects/curse5.ogg', 20, TRUE, -1)
		owner.adjustFireLoss(0.75)
	if(effect_last_activation <= world.time)
		effect_last_activation = world.time + effect_cooldown
		if(curse_flags & CURSE_SPAWNING)
			var/turf/spawn_turf
			var/sanity = 10
			while(!spawn_turf && sanity)
				spawn_turf = locate(owner.x + pick(rand(10, 15), rand(-10, -15)), owner.y + pick(rand(10, 15), rand(-10, -15)), owner.z)
				sanity--
			if(spawn_turf)
				var/mob/living/simple_animal/hostile/asteroid/curseblob/C = new (spawn_turf)
				C.set_target = owner
				C.GiveTarget()
		if(curse_flags & CURSE_GRASPING)
			var/grab_dir = turn(owner.dir, pick(-90, 90, 180, 180)) //grab them from a random direction other than the one faced, favoring grabbing from behind
			var/turf/spawn_turf = get_ranged_target_turf(owner, grab_dir, 5)
			if(spawn_turf)
				grasp(spawn_turf)

/datum/status_effect/necropolis_curse/proc/grasp(turf/spawn_turf)
	set waitfor = FALSE
	new/obj/effect/temp_visual/dir_setting/curse/grasp_portal(spawn_turf, owner.dir)
	playsound(spawn_turf, 'sound/effects/curse2.ogg', 80, TRUE, -1)
	var/turf/ownerloc = get_turf(owner)
	var/obj/projectile/curse_hand/C = new (spawn_turf)
	C.preparePixelProjectile(ownerloc, spawn_turf)
	C.fire()

/obj/effect/temp_visual/curse
	icon_state = "curse"

/obj/effect/temp_visual/curse/Initialize(mapload)
	. = ..()
	deltimer(timerid)


/datum/status_effect/gonbola_pacify
	id = "gonbolaPacify"
	status_type = STATUS_EFFECT_MULTIPLE
	tick_interval = -1
	alert_type = null

/datum/status_effect/gonbola_pacify/on_apply()
	ADD_TRAIT(owner, TRAIT_PACIFISM, "gonbolaPacify")
	ADD_TRAIT(owner, TRAIT_MUTE, "gonbolaMute")
	ADD_TRAIT(owner, TRAIT_JOLLY, "gonbolaJolly")
	to_chat(owner, span_notice("Внезапно чувствую покой и отпала необходимость совершать внезапные или опрометчивые действия..."))
	return ..()

/datum/status_effect/gonbola_pacify/on_remove()
	REMOVE_TRAIT(owner, TRAIT_PACIFISM, "gonbolaPacify")
	REMOVE_TRAIT(owner, TRAIT_MUTE, "gonbolaMute")
	REMOVE_TRAIT(owner, TRAIT_JOLLY, "gonbolaJolly")

/datum/status_effect/trance
	id = "trance"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 300
	tick_interval = 10
	examine_text = span_warning("SUBJECTPRONOUN стоит в ступоре.")
	var/stun = TRUE
	alert_type = /atom/movable/screen/alert/status_effect/trance

/atom/movable/screen/alert/status_effect/trance
	name = "Транс"
	desc = "Все кажется таким отдаленным, и можно почувствовать, как мои мысли образуют петли в голове...."
	icon_state = "high"

/datum/status_effect/trance/tick()
	if(stun)
		owner.Stun(60, TRUE)
	owner.dizziness = 20

/datum/status_effect/trance/on_apply()
	if(!iscarbon(owner))
		return FALSE
	RegisterSignal(owner, COMSIG_MOVABLE_HEAR, PROC_REF(hypnotize))
	ADD_TRAIT(owner, TRAIT_MUTE, "trance")
	owner.add_client_colour(/datum/client_colour/monochrome/trance)
	owner.visible_message("[stun ? span_warning("[owner] стоит смирно и пялится на точку в далеке.")  : ""]", \
	span_warning("[pick("Чувствую, что мои мысли замедлились....", "У меня кружится голова....", "У меня такое чувство, что я в середине сна....","Чувствую себя невероятно расслаблено...")]"))
	return TRUE

/datum/status_effect/trance/on_creation(mob/living/new_owner, _duration, _stun = TRUE)
	duration = _duration
	stun = _stun
	return ..()

/datum/status_effect/trance/on_remove()
	UnregisterSignal(owner, COMSIG_MOVABLE_HEAR)
	REMOVE_TRAIT(owner, TRAIT_MUTE, "trance")
	owner.dizziness = 0
	owner.remove_client_colour(/datum/client_colour/monochrome/trance)
	to_chat(owner, span_warning("Выхожу из своего транса!"))

/datum/status_effect/trance/proc/hypnotize(datum/source, list/hearing_args)
	SIGNAL_HANDLER

	if(!owner.can_hear())
		return
	var/mob/hearing_speaker = hearing_args[HEARING_SPEAKER]
	if(hearing_speaker == owner)
		return
	var/mob/living/carbon/C = owner
	C.cure_trauma_type(/datum/brain_trauma/hypnosis, TRAUMA_RESILIENCE_SURGERY) //clear previous hypnosis
	hearing_speaker.log_message("has hypnotised [key_name(C)] with the phrase '[hearing_args[HEARING_RAW_MESSAGE]]'", LOG_ATTACK)
	C.log_message("has been hypnotised by the phrase '[hearing_args[HEARING_RAW_MESSAGE]]' spoken by [key_name(hearing_speaker)]", LOG_VICTIM, log_globally = FALSE)
	addtimer(CALLBACK(C, TYPE_PROC_REF(/mob/living/carbon, gain_trauma), /datum/brain_trauma/hypnosis, TRAUMA_RESILIENCE_SURGERY, hearing_args[HEARING_RAW_MESSAGE]), 10)
	addtimer(CALLBACK(C, TYPE_PROC_REF(/mob/living, Stun), 60, TRUE, TRUE), 15) //Take some time to think about it
	qdel(src)

/datum/status_effect/hypertrance
	id = "hypertrance"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 300000
	tick_interval = 1000
	examine_text = span_warning("SUBJECTPRONOUN повторяет фразы.")
	alert_type = /atom/movable/screen/alert/status_effect/hypertrance

/atom/movable/screen/alert/status_effect/hypertrance
	name = "гипертранс"
	desc = "БУДУ ПОВТОРЯТЬ!"
	icon_state = "high"

/datum/status_effect/hypertrance/on_apply()
	if(!iscarbon(owner))
		return FALSE
	RegisterSignal(owner, COMSIG_MOVABLE_HEAR, PROC_REF(repeat_shit))
	return TRUE

/datum/status_effect/hypertrance/on_remove()
	UnregisterSignal(owner, COMSIG_MOVABLE_HEAR)

/datum/status_effect/hypertrance/proc/repeat_shit(datum/source, list/hearing_args)
	SIGNAL_HANDLER

	if(!owner.can_hear())
		return
	if(hearing_args[HEARING_SPEAKER] == owner)
		return
	INVOKE_ASYNC(owner, TYPE_PROC_REF(/atom/movable, say), hearing_args[HEARING_RAW_MESSAGE])

/datum/status_effect/spasms
	id = "spasms"
	status_type = STATUS_EFFECT_MULTIPLE
	alert_type = null
	var/probability = 15

/datum/status_effect/spasms/heavy
	probability = 30

/datum/status_effect/spasms/tick()
	if(prob(probability))
		switch(rand(1,5))
			if(1)
				if((owner.mobility_flags & MOBILITY_MOVE) && isturf(owner.loc))
					to_chat(owner, span_warning("Мою ногу схватила судорога!"))
					step(owner, pick(GLOB.cardinals))
			if(2)
				if(owner.incapacitated())
					return
				var/obj/item/I = owner.get_active_held_item()
				if(I)
					to_chat(owner, span_warning("Мой палец схватила судорога!"))
					owner.log_message("used [I] due to a Muscle Spasm", LOG_ATTACK)
					I.attack_self(owner)
			if(3)
				var/prev_intent = owner.a_intent
				owner.a_intent = INTENT_HARM

				var/range = 1
				if(istype(owner.get_active_held_item(), /obj/item/gun)) //get targets to shoot at
					range = 7

				var/list/mob/living/targets = list()
				for(var/mob/M in oview(owner, range))
					if(isliving(M))
						targets += M
				if(LAZYLEN(targets))
					to_chat(owner, span_warning("Мою руку схватила судорога!"))
					owner.log_message(" attacked someone due to a Muscle Spasm", LOG_ATTACK) //the following attack will log itself
					owner.ClickOn(pick(targets))
				owner.a_intent = prev_intent
			if(4)
				var/prev_intent = owner.a_intent
				owner.a_intent = INTENT_HARM
				to_chat(owner, span_warning("Мою руку схватила судорога!"))
				owner.log_message("attacked [owner.ru_na()]self to a Muscle Spasm", LOG_ATTACK)
				owner.ClickOn(owner)
				owner.a_intent = prev_intent
			if(5)
				if(owner.incapacitated())
					return
				var/obj/item/I = owner.get_active_held_item()
				var/list/turf/targets = list()
				for(var/turf/T in oview(owner, 3))
					targets += T
				if(LAZYLEN(targets) && I)
					to_chat(owner, span_warning("Мою руку схватила судорога!"))
					owner.log_message("threw [I] due to a Muscle Spasm", LOG_ATTACK)
					owner.throw_item(pick(targets))

/datum/status_effect/convulsing
	id = "convulsing"
	duration = 	150
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/convulsing

/datum/status_effect/convulsing/on_creation(mob/living/zappy_boy)
	. = ..()
	to_chat(zappy_boy, span_boldwarning("Чувствую шок, движущийся по моему телу! Мои руки начинают дрожать!"))

/datum/status_effect/convulsing/tick()
	var/mob/living/carbon/H = owner
	if(prob(40))
		var/obj/item/I = H.get_active_held_item()
		if(I && H.dropItemToGround(I))
			H.visible_message(span_notice("Рука [H] дёргается и случайно выбрасывает [skloname(I.name, VINITELNI, I.gender)]!") ,span_userdanger("Моя рука внезапно дёргается и из неё выпадает то, что я держу!"))
			H.jitteriness += 5

/atom/movable/screen/alert/status_effect/convulsing
	name = "Дрожащие руки"
	desc = "Меня ударили чем-то, и руки не перестают трястись! Похоже, что вещи теперь будут выпадать у меня из рук часто."
	icon_state = "convulsing"

/datum/status_effect/dna_melt
	id = "dna_melt"
	duration = 600
	status_type = STATUS_EFFECT_REPLACE
	alert_type = /atom/movable/screen/alert/status_effect/dna_melt
	var/kill_either_way = FALSE //no amount of removing mutations is gonna save you now

/datum/status_effect/dna_melt/on_creation(mob/living/new_owner, set_duration)
	. = ..()
	to_chat(new_owner, span_boldwarning("Мое тело не выдержит больше мутаций! Мне нужно, чтобы мои мутации были быстро удалены!"))

/datum/status_effect/dna_melt/on_remove()
	if(!ishuman(owner))
		owner.gib() //fuck you in particular
		return
	var/mob/living/carbon/human/H = owner
	H.something_horrible(kill_either_way)

/atom/movable/screen/alert/status_effect/dna_melt
	name = "Генетическая разбивка"
	desc = "Мое тело не выдержит больше мутаций! У меня есть минута, чтобы мои мутации были быстро удалены или меня ждёт страшная судьба!"
	icon_state = "dna_melt"

/datum/status_effect/go_away
	id = "go_away"
	duration = 100
	status_type = STATUS_EFFECT_REPLACE
	tick_interval = 1
	alert_type = /atom/movable/screen/alert/status_effect/go_away
	var/direction

/datum/status_effect/go_away/on_creation(mob/living/new_owner, set_duration)
	. = ..()
	direction = pick(NORTH, SOUTH, EAST, WEST)
	new_owner.setDir(direction)

/datum/status_effect/go_away/tick()
	owner.AdjustStun(1, ignore_canstun = TRUE)
	var/turf/T = get_step(owner, direction)
	owner.forceMove(T)

/atom/movable/screen/alert/status_effect/go_away
	name = "К ЗВЕЗДАМ И ДАЛЬШЕ!"
	desc = "Мне надо идти, меня ждут мои люди!"
	icon_state = "high"

//Clock cult
/datum/status_effect/interdiction
	id = "interdicted"
	duration = 25
	status_type = STATUS_EFFECT_REFRESH
	tick_interval = 1
	alert_type = /atom/movable/screen/alert/status_effect/interdiction
	var/running_toggled = FALSE

/datum/status_effect/interdiction/tick()
	if(owner.m_intent == MOVE_INTENT_RUN)
		owner.toggle_move_intent(owner)
		running_toggled = TRUE
		to_chat(owner, span_warning("You know you shouldn't be running here..."))
	owner.add_movespeed_modifier(/datum/movespeed_modifier/interdiction)

/datum/movespeed_modifier/interdiction
	multiplicative_slowdown = 1.5
	movetypes = GROUND

/datum/status_effect/interdiction/on_remove()
	owner.remove_movespeed_modifier(MOVESPEED_ID_INTERDICTION)
	if(running_toggled && owner.m_intent == MOVE_INTENT_WALK)
		owner.toggle_move_intent(owner)

/atom/movable/screen/alert/status_effect/interdiction
	name = "Interdicted"
	desc = "I don't think I am meant to go this way..."
	icon_state = "inathneqs_endowment"

/datum/status_effect/fake_virus
	id = "fake_virus"
	duration = 1800//3 minutes
	status_type = STATUS_EFFECT_REPLACE
	tick_interval = 1
	alert_type = null
	var/msg_stage = 0//so you dont get the most intense messages immediately

/datum/status_effect/fake_virus/tick()
	var/fake_msg = ""
	var/fake_emote = ""
	switch(msg_stage)
		if(0 to 300)
			if(prob(1))
				fake_msg = pick(span_warning("[pick("Голова болит.", "Моя голова разрывается.")]") ,
				span_warning("[pick("Дышать сложно.", "Моё дыхание становится более тяжелым.")]") ,
				span_warning("[pick("У меня кружится голова.", "Перед глазами всё вращается.")]") ,
				"<span notice='warning'>[pick("Сглатываю излишки слизи.", "Я слегка покашливаю.")]</span>",
				span_warning("[pick("Голова болит.", "Мой разум на мгновение остался пустым.")]") ,
				span_warning("[pick("Горло болит.", "Прочищаю своё горло.")]"))
		if(301 to 600)
			if(prob(2))
				fake_msg = pick(span_warning("[pick("Моя голова сильно болит.", "Моя голова постоянно разрывается.")]") ,
				span_warning("[pick("Моё дыхательное горлышко похоже на соломинку.", "Дышать невероятно сложно.")]") ,
				span_warning("Чувствую себя очень [pick("плохо","дурно","слабо")].") ,
				span_warning("[pick("Слышу звон в ушах.", "В ушах стреляет.")]") ,
				span_warning("Засыпаю на мгновение."))
		else
			if(prob(3))
				if(prob(50))// coin flip to throw a message or an emote
					fake_msg = pick(span_userdanger("[pick("Голова болит!", "Чувствую горящий нож в моём мозгу!", "Волна боли заполняет мою голову!")]") ,
					span_userdanger("[pick("В груди очень сильно болит!", "Больно дышать!")]") ,
					span_warning("[pick("Меня тошнит.", "Меня сейчас вырвет!")]"))
				else
					fake_emote = pick("cough", "sniff", "sneeze")

	if(fake_emote)
		owner.emote(fake_emote)
	else if(fake_msg)
		to_chat(owner, fake_msg)

	msg_stage++

/datum/status_effect/corrosion_curse
	id = "corrosion_curse"
	status_type = STATUS_EFFECT_REPLACE
	alert_type = null
	tick_interval = 1 SECONDS

/datum/status_effect/corrosion_curse/on_creation(mob/living/new_owner, ...)
	. = ..()
	to_chat(owner, span_danger("Your feel your body starting to break apart..."))

/datum/status_effect/corrosion_curse/tick()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	var/chance = rand(0,100)
	switch(chance)
		if(0 to 19)
			H.vomit()
		if(20 to 29)
			H.Dizzy(10)
		if(30 to 39)
			H.adjustOrganLoss(ORGAN_SLOT_LIVER,5)
		if(40 to 49)
			H.adjustOrganLoss(ORGAN_SLOT_HEART,5)
		if(50 to 59)
			H.adjustOrganLoss(ORGAN_SLOT_STOMACH,5)
		if(60 to 69)
			H.adjustOrganLoss(ORGAN_SLOT_EYES,10)
		if(70 to 79)
			H.adjustOrganLoss(ORGAN_SLOT_EARS,10)
		if(80 to 89)
			H.adjustOrganLoss(ORGAN_SLOT_LUNGS,10)
		if(90 to 99)
			H.adjustOrganLoss(ORGAN_SLOT_TONGUE,10)
		if(100)
			H.adjustOrganLoss(ORGAN_SLOT_BRAIN,20)

/datum/status_effect/amok
	id = "amok"
	status_type = STATUS_EFFECT_REPLACE
	alert_type = null
	duration = 10 SECONDS
	tick_interval = 1 SECONDS

/datum/status_effect/amok/on_apply(mob/living/afflicted)
	. = ..()
	to_chat(owner, span_boldwarning("You feel filled with a rage that is not your own!"))

/datum/status_effect/amok/tick()
	. = ..()
	var/prev_intent = owner.a_intent
	owner.a_intent = INTENT_HARM

	var/list/mob/living/targets = list()
	for(var/mob/living/potential_target in oview(owner, 1))
		if(IS_HERETIC(potential_target) || IS_HERETIC_MONSTER(potential_target))
			continue
		targets += potential_target
	if(LAZYLEN(targets))
		owner.log_message(" attacked someone due to the amok debuff.", LOG_ATTACK) //the following attack will log itself
		owner.ClickOn(pick(targets))
	owner.a_intent = prev_intent

/datum/status_effect/cloudstruck
	id = "cloudstruck"
	status_type = STATUS_EFFECT_REPLACE
	duration = 3 SECONDS
	on_remove_on_mob_delete = TRUE
	///This overlay is applied to the owner for the duration of the effect.
	var/mutable_appearance/mob_overlay

/datum/status_effect/cloudstruck/on_creation(mob/living/new_owner, set_duration)
	if(isnum(set_duration))
		duration = set_duration
	. = ..()

/datum/status_effect/cloudstruck/on_apply()
	mob_overlay = mutable_appearance('icons/effects/eldritch.dmi', "cloud_swirl", ABOVE_MOB_LAYER)
	owner.overlays += mob_overlay
	owner.update_icon()
	ADD_TRAIT(owner, TRAIT_BLIND, "cloudstruck")
	return TRUE

/datum/status_effect/cloudstruck/on_remove()
	. = ..()
	if(QDELETED(owner))
		return
	REMOVE_TRAIT(owner, TRAIT_BLIND, "cloudstruck")
	if(owner)
		owner.overlays -= mob_overlay
		owner.update_icon()

/datum/status_effect/cloudstruck/Destroy()
	. = ..()
	QDEL_NULL(mob_overlay)

//Deals with ants covering someone.
/datum/status_effect/ants
	id = "ants"
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/ants
	duration = 2 MINUTES //Keeping the normal timer makes sure people can't somehow dump 300+ ants on someone at once so they stay there for like 30 minutes. Max w/ 1 dump is 57.6 brute.
	examine_text = span_warning("SUBJECTPRONOUN is covered in ants!")
	processing_speed = STATUS_EFFECT_NORMAL_PROCESS
	/// Will act as the main timer as well as changing how much damage the ants do.
	var/ants_remaining = 0

/datum/status_effect/ants/on_creation(mob/living/new_owner, amount_left)
	if(isnum(amount_left))
		to_chat(new_owner, span_userdanger("You're covered in ants!"))
		ants_remaining += amount_left
	. = ..()

/datum/status_effect/ants/refresh(effect, amount_left)
	var/mob/living/carbon/human/victim = owner
	if(isnum(amount_left) && ants_remaining >= 1)
		if(!prob(1)) // 99%
			to_chat(victim, span_userdanger("You're covered in MORE ants!"))
		else // 1%
			victim.say("AAHH! THIS SITUATION HAS ONLY BEEN MADE WORSE WITH THE ADDITION OF YET MORE ANTS!!", forced = /datum/status_effect/ants)
		ants_remaining += amount_left
	. = ..()

/datum/status_effect/ants/on_remove()
	ants_remaining = 0
	to_chat(owner, span_notice("All of the ants are off of your body!"))
	UnregisterSignal(owner, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(ants_washed))
	. = ..()

/datum/status_effect/ants/proc/ants_washed()
	SIGNAL_HANDLER
	owner.remove_status_effect(STATUS_EFFECT_ANTS)
	return COMPONENT_CLEANED

/datum/status_effect/ants/tick()
	var/mob/living/carbon/human/victim = owner
	victim.adjustBruteLoss(max(0.1, round((ants_remaining * 0.004),0.1))) //Scales with # of ants (lowers with time). Roughly 10 brute over 50 seconds.
	if(victim.stat <= SOFT_CRIT) //Makes sure people don't scratch at themselves while they're unconcious
		if(prob(15))
			switch(rand(1,2))
				if(1)
					victim.say(pick("GET THEM OFF ME!!", "OH GOD THE ANTS!!", "MAKE IT END!!", "THEY'RE EVERYWHERE!!", "GET THEM OFF!!", "SOMEBODY HELP ME!!"), forced = /datum/status_effect/ants)
				if(2)
					victim.emote("agony")
		if(prob(50))
			switch(rand(1,50))
				if (1 to 8) //16% Chance
					var/obj/item/bodypart/head/hed = victim.get_bodypart(BODY_ZONE_HEAD)
					to_chat(victim, span_danger("You scratch at the ants on your scalp!."))
					hed.receive_damage(0.1,0)
				if (9 to 29) //40% chance
					var/obj/item/bodypart/arm = victim.get_bodypart(pick(BODY_ZONE_L_ARM,BODY_ZONE_R_ARM))
					to_chat(victim, span_danger("You scratch at the ants on your arms!"))
					arm.receive_damage(0.1,0)
				if (30 to 49) //38% chance
					var/obj/item/bodypart/leg = victim.get_bodypart(pick(BODY_ZONE_L_LEG,BODY_ZONE_R_LEG))
					to_chat(victim, span_danger("You scratch at the ants on your leg!"))
					leg.receive_damage(0.1,0)
				if(50) // 2% chance
					to_chat(victim, span_danger("You rub some ants away from your eyes!"))
					victim.blur_eyes(3)
					ants_remaining -= 5 // To balance out the blindness, it'll be a little shorter.
	ants_remaining--
	if(ants_remaining <= 0 || victim.stat >= HARD_CRIT)
		victim.remove_status_effect(STATUS_EFFECT_ANTS) //If this person has no more ants on them or are dead, they are no longer affected.

/atom/movable/screen/alert/status_effect/ants
	name = "Ants!"
	desc = span_warning("JESUS FUCKING CHRIST! CLICK TO GET THOSE THINGS OFF!")
	icon_state = "antalert"

/atom/movable/screen/alert/status_effect/ants/Click()
	var/mob/living/living = owner
	if(!istype(living) || !living.can_resist() || living != owner)
		return
	to_chat(living, span_notice("You start to shake the ants off!"))
	if(!do_after(living, 2 SECONDS, target = living))
		return
	for (var/datum/status_effect/ants/ant_covered in living.status_effects)
		to_chat(living, span_notice("You manage to get some of the ants off!"))
		ant_covered.ants_remaining -= 10 // 5 Times more ants removed per second than just waiting in place

/datum/status_effect/ghoul
	id = "ghoul"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/ghoul
	/// The new max health value set for the ghoul, if supplied
	var/new_max_health
	/// Reference to the master of the ghoul's mind
	var/datum/mind/master_mind
	/// An optional callback invoked when a ghoul is made (on_apply)
	var/datum/callback/on_made_callback
	/// An optional callback invoked when a goul is unghouled (on_removed)
	var/datum/callback/on_lost_callback

/datum/status_effect/ghoul/Destroy()
	master_mind = null
	QDEL_NULL(on_made_callback)
	QDEL_NULL(on_lost_callback)
	return ..()

/datum/status_effect/ghoul/on_creation(
	mob/living/new_owner,
	new_max_health,
	datum/mind/master_mind,
	datum/callback/on_made_callback,
	datum/callback/on_lost_callback,
)

	src.new_max_health = new_max_health
	src.master_mind = master_mind
	src.on_made_callback = on_made_callback
	src.on_lost_callback = on_lost_callback

	. = ..()

	if(master_mind)
		linked_alert.desc += " You are an eldritch monster reanimated to serve its master, [master_mind]."
	if(isnum(new_max_health))
		if(new_max_health > initial(new_owner.maxHealth))
			linked_alert.desc += " You are stronger in this form."
		else
			linked_alert.desc += " You are more fragile in this form."

/datum/status_effect/ghoul/on_apply()
	if(!ishuman(owner))
		return FALSE

	var/mob/living/carbon/human/human_target = owner

	RegisterSignal(human_target, COMSIG_LIVING_DEATH, PROC_REF(remove_ghoul_status))
	human_target.revive(full_heal = TRUE, admin_revive = TRUE)

	if(new_max_health)
		human_target.setMaxHealth(new_max_health)
		human_target.health = new_max_health

	on_made_callback?.Invoke(human_target)
	human_target.become_husk(MAGIC_TRAIT)
	human_target.faction |= FACTION_HERETIC

	if(human_target.mind)
		var/datum/antagonist/heretic_monster/heretic_monster = human_target.mind.add_antag_datum(/datum/antagonist/heretic_monster)
		heretic_monster.set_owner(master_mind)

	return TRUE

/datum/status_effect/ghoul/on_remove()
	remove_ghoul_status()
	return ..()

/// Removes the ghoul effects from our owner and returns them to normal.
/datum/status_effect/ghoul/proc/remove_ghoul_status(datum/source)
	SIGNAL_HANDLER

	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/human_target = owner

	if(new_max_health)
		human_target.setMaxHealth(initial(human_target.maxHealth))

	on_lost_callback?.Invoke(human_target)
	human_target.cure_husk(MAGIC_TRAIT)
	human_target.faction -= FACTION_HERETIC
	human_target.mind?.remove_antag_datum(/datum/antagonist/heretic_monster)

	UnregisterSignal(human_target, COMSIG_LIVING_DEATH)
	if(!QDELETED(src))
		qdel(src)

/atom/movable/screen/alert/status_effect/ghoul
	name = "Flesh Servant"
	desc = "You are a Ghoul! A eldritch monster reanimated to serve its master."
	icon_state = "mind_control"


/datum/status_effect/stagger
	id = "stagger"
	status_type = STATUS_EFFECT_REFRESH
	duration = 30 SECONDS
	tick_interval = 1 SECONDS
	alert_type = null

/datum/status_effect/stagger/on_apply()
	owner.next_move_modifier *= 1.5
	if(ishostile(owner))
		var/mob/living/simple_animal/hostile/simple_owner = owner
		simple_owner.ranged_cooldown_time *= 2.5
	return TRUE

/datum/status_effect/stagger/on_remove()
	. = ..()
	if(QDELETED(owner))
		return
	owner.next_move_modifier /= 1.5
	if(ishostile(owner))
		var/mob/living/simple_animal/hostile/simple_owner = owner
		simple_owner.ranged_cooldown_time /= 2.5

#define STARTING_FILTER_PRIORITY 20

//HEAD RAPE
//DURATION SHOULD ALWAYS BE DIVISIBLE BY 40 (4 SECONDS) TO ENSURE SMOOTH ANIMATION.
//IF YOU DON'T ABIDE BY THE ABOVE, YOUR MAILBOX WILL RECEIVE A VERY FUN SURPRISE.
/datum/status_effect/incapacitating/headrape
	id = "head_rape"
	status_type = STATUS_EFFECT_REFRESH
	processing_speed = STATUS_EFFECT_NORMAL_PROCESS
	tick_interval = 8 SECONDS
	/// Alpha of the first composite layer
	var/starting_alpha = 64
	/// How many total layers we get, each new layer halving the previous layer's alpha
	var/intensity = 3
	/// How much we are allowed to vary in x
	var/variation_x = 32
	/// How much we are allowed to vary in y
	var/variation_y = 32
	/// Render relay plate we get our render_source from
	var/atom/movable/screen/plane_master/rendering_plate/source_plate
	/// Render relay plate we are actually messing with
	var/atom/movable/screen/plane_master/rendering_plate/filter_plate
	/// Funny tinnitus sound effect
	var/datum/looping_sound/tinnitus/tinnitus
	/// Each filter we are handling, assoc list
	var/list/list/filters_handled = list()
	/// Black layer filter that makes shit actually look normal
	var/list/black_filter_params = list()

/datum/status_effect/incapacitating/headrape/Destroy()
	if(!QDELETED(filter_plate))
		INVOKE_ASYNC(src, PROC_REF(end_animation))
		QDEL_IN(tinnitus, 4 SECONDS)
	else
		qdel(tinnitus)
	tinnitus = null
	source_plate = null
	filter_plate = null
	filters_handled = null
	black_filter_params = null
	return ..()

/datum/status_effect/incapacitating/headrape/on_apply()
	. = ..()
	tinnitus = new(owner, TRUE, TRUE, TRUE)
	if(owner?.hud_used?.get_plane_master(RENDER_PLANE_MASTER) && owner.hud_used.get_plane_master(RENDER_PLANE_GAME))
		source_plate = owner.hud_used.get_plane_master(RENDER_PLANE_GAME)
		filter_plate = owner.hud_used.get_plane_master(RENDER_PLANE_MASTER)
		black_filter_params = layering_filter(render_source = source_plate.render_target, \
											blend_mode = BLEND_OVERLAY, \
											x = 0, \
											y = 0, \
											color = "#000000")
		for(var/i in 1 to intensity)
			var/filter_intensity = max(16, starting_alpha/(2**(i-1)))
			var/filter_color = rgb(255, 255, 255, filter_intensity)
			filters_handled["headrape[i]"] = layering_filter(render_source = source_plate.render_target, \
															blend_mode = BLEND_MULTIPLY, \
															x = 0, \
															y = 0, \
															color = filter_color)
		for(var/filter_name in filters_handled)
			var/filter_index = filters_handled.Find(filter_name)
			var/list/filter_params = filters_handled[filter_name]
			filter_plate.add_filter(filter_name, STARTING_FILTER_PRIORITY+1-filter_index, filter_params)
	if(!QDELETED(filter_plate))
		INVOKE_ASYNC(src, PROC_REF(perform_animation))

/datum/status_effect/incapacitating/headrape/tick()
	. = ..()
	if(!QDELETED(filter_plate))
		INVOKE_ASYNC(src, PROC_REF(perform_animation))

/datum/status_effect/incapacitating/headrape/proc/perform_animation()
	for(var/filter_name in filters_handled)
		filters_handled[filter_name]["x"] = rand(-variation_x, variation_x)
		filters_handled[filter_name]["y"] = rand(-variation_y, variation_y)
	update_rape_filters(4 SECONDS)

/datum/status_effect/incapacitating/headrape/proc/end_animation()
	var/atom/movable/screen/plane_master/rendering_plate/old_filter_plate = filter_plate
	var/list/old_filters_handled = list()
	var/kill_color = rgb(255, 255, 255, 0)
	for(var/filter_name in filters_handled)
		filters_handled[filter_name]["x"] = 0
		filters_handled[filter_name]["y"] = 0
		filters_handled[filter_name]["color"] = kill_color
		old_filters_handled += filter_name
	update_rape_filters(4 SECONDS)
	//Sleep call ensures the ending looks smooth no matter what
	sleep(4 SECONDS)
	//KILL the filters now
	if(!QDELETED(old_filter_plate))
		for(var/filter_name in old_filters_handled)
			old_filter_plate.remove_filter(filter_name)

/datum/status_effect/incapacitating/headrape/proc/update_rape_filters(time = 4 SECONDS)
	for(var/filter_name in filters_handled)
		var/list/filter_params = filters_handled[filter_name].Copy()
		filter_params -= "render_source"
		filter_plate.transition_filter(filter_name, time, filter_params, LINEAR_EASING, FALSE)

#undef STARTING_FILTER_PRIORITY

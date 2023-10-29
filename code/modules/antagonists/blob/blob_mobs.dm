
////////////////
// BASE TYPE //
////////////////

//Do not spawn
/mob/living/simple_animal/hostile/blob
	icon = 'icons/mob/blob.dmi'
	pass_flags = PASSBLOB
	faction = list(ROLE_BLOB)
	bubble_icon = "blob"
	speak_emote = null //so we use verb_yell/verb_say/etc
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = INFINITY
	unique_name = 1
	a_intent = INTENT_HARM
	see_in_dark = 8
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	initial_language_holder = /datum/language_holder/empty
	retreat_distance = null //! retreat doesn't obey pass_flags, so won't work on blob mobs.
	var/mob/camera/blob/overmind = null
	var/obj/structure/blob/special/factory = null
	var/independent = FALSE
	var/no_ghost = FALSE
	discovery_points = 1000

/mob/living/simple_animal/hostile/blob/update_icons()
	if(overmind)
		add_atom_colour(overmind.blobstrain.color, FIXED_COLOUR_PRIORITY)
	else
		remove_atom_colour(FIXED_COLOUR_PRIORITY)

/mob/living/simple_animal/hostile/blob/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/nerfed_pulling, GLOB.typecache_general_bad_things_to_easily_move)
	AddElement(/datum/element/prevent_attacking_of_types, GLOB.typecache_general_bad_hostile_attack_targets, "Мерзость! Оно плохо пахнет! Нехочу это есть или трогать!")
	if(!independent) //no pulling people deep into the blob
		remove_verb(src, /mob/living/verb/pulled)
	else
		pass_flags &= ~PASSBLOB

/mob/living/simple_animal/hostile/blob/Destroy()
	if(overmind)
		overmind.blob_mobs -= src
	return ..()

/mob/living/simple_animal/hostile/blob/get_status_tab_items()
	. = ..()
	if(overmind)
		. += "Массы до победы: [overmind.blobs_legit.len]/[overmind.blobwincount]"

/mob/living/simple_animal/hostile/blob/blob_act(obj/structure/blob/B)
	if(stat != DEAD && health < maxHealth)
		for(var/i in 1 to 2)
			var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal(get_turf(src)) //hello yes you are being healed
			if(overmind)
				H.color = overmind.blobstrain.complementary_color
			else
				H.color = "#000000"
		adjustHealth(-maxHealth*BLOBMOB_HEALING_MULTIPLIER)

/mob/living/simple_animal/hostile/blob/fire_act(exposed_temperature, exposed_volume)
	..()
	if(exposed_temperature)
		adjustFireLoss(clamp(0.01 * exposed_temperature, 1, 5))
	else
		adjustFireLoss(5)

/mob/living/simple_animal/hostile/blob/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(istype(mover, /obj/structure/blob))
		return TRUE

///override to use astar/JPS instead of walk_to so we can take our blob pass_flags into account.
/mob/living/simple_animal/hostile/blob/Goto(target, delay, minimum_distance)
	if(prevent_goto_movement)
		return FALSE
	if(target == src.target)
		approaching_target = TRUE
	else
		approaching_target = FALSE

	SSmove_manager.jps_move(moving = src, chasing = target, delay = delay, repath_delay = 2 SECONDS, minimum_distance = minimum_distance, simulated_only = FALSE, skip_first = TRUE, timeout = 5 SECONDS, flags = MOVEMENT_LOOP_IGNORE_GLIDE)
	return TRUE

/mob/living/simple_animal/hostile/blob/Process_Spacemove(movement_dir = 0, continuous_move = FALSE)
	for(var/obj/structure/blob/B in range(1, src))
		return 1
	return ..()

/mob/living/simple_animal/hostile/blob/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	var/spanned_message = say_quote(capitalize(message))
	var/rendered = "<font color=\"#EE4000\"><b>\[Телепатия\] [capitalize(real_name)]</b> [spanned_message]</font>"
	for(var/M in GLOB.mob_list)
		if(isovermind(M) || istype(M, /mob/living/simple_animal/hostile/blob))
			to_chat(M, rendered)
		if(isobserver(M))
			var/link = FOLLOW_LINK(M, src)
			to_chat(M, "[link] [rendered]")

////////////////
// BLOB SPORE //
////////////////

/mob/living/simple_animal/hostile/blob/blobspore
	name = "Спора массы"
	desc = "Летающая, хрупкая масса."
	icon = 'icons/mob/blob_64.dmi'
	icon_state = "blobpod"
	icon_living = "blobpod"
	health_doll_icon = "blobpod"
	health = BLOBMOB_SPORE_HEALTH
	maxHealth = BLOBMOB_SPORE_HEALTH
	verb_say = "физически пульсирует"
	verb_ask = "физически вопрошает"
	verb_exclaim = "физически громогласит"
	verb_yell = "физически пищит"
	melee_damage_lower = BLOBMOB_SPORE_DMG_LOWER
	melee_damage_upper = BLOBMOB_SPORE_DMG_UPPER
	environment_smash = ENVIRONMENT_SMASH_NONE
	obj_damage = 0
	attack_verb_continuous = "бьёт"
	attack_verb_simple = "бьёт"
	attack_sound = 'sound/weapons/genhit1.wav'
	del_on_death = TRUE
	death_message = "взрывается!"
	gold_core_spawnable = NO_SPAWN //gold slime cores should only spawn the independent subtype
	var/death_cloud_size = 1 //size of cloud produced from a dying spore
	var/mob/living/carbon/human/oldguy
	var/is_zombie = FALSE
	///Whether or not this is a fragile spore from Distributed Neurons
	var/is_weak = FALSE

/mob/living/simple_animal/hostile/blob/blobspore/Initialize(mapload, obj/structure/blob/special/linked_node)
	. = ..()

	icon = GLOB.blob_current_icon

	AddElement(/datum/element/simple_flying)
	if(istype(linked_node))
		factory = linked_node
		factory.spores += src
		if(linked_node.overmind && istype(linked_node.overmind.blobstrain, /datum/blobstrain/reagent/distributed_neurons) && !istype(src, /mob/living/simple_animal/hostile/blob/blobspore/weak))
			notify_ghosts("Свободная спора доступна в [get_area(src)].", source = src, action = NOTIFY_ORBIT, flashwindow = FALSE, header = "Спора создана")
		add_cell_sample()

/mob/living/simple_animal/hostile/blob/blobspore/Life(delta_time = SSMOBS_DT, times_fired)
	if(!is_zombie && isturf(src.loc))
		for(var/mob/living/carbon/human/H in view(src,1)) //Only for corpse right next to/on same tile
			if(!is_weak && H.stat == DEAD)
				Zombify(H)
				break
	if(factory && z != factory.z)
		death()
	return ..()

/mob/living/simple_animal/hostile/blob/blobspore/attack_ghost(mob/user)
	. = ..()
	if(.)
		return
	if(no_ghost)
		return
	humanize_pod(user)

/mob/living/simple_animal/hostile/blob/blobspore/proc/humanize_pod(mob/user)
	if((!overmind || istype(src, /mob/living/simple_animal/hostile/blob/blobspore/weak) || !istype(overmind.blobstrain, /datum/blobstrain/reagent/distributed_neurons)) && !is_zombie)
		return
	if(key || stat)
		return
	var/pod_ask = tgui_alert(usr,"Стать спорой?", "Ты долбоёб?", list("Да", "Нет"))
	if(pod_ask == "Нет" || !src || QDELETED(src))
		return
	if(key)
		to_chat(user, span_warning("Кто-то уже забрал спору"))
		return
	key = user.key
	log_game("[key_name(src)] took control of [name].")

/mob/living/simple_animal/hostile/blob/blobspore/proc/Zombify(mob/living/carbon/human/H)
	is_zombie = 1
	if(H.wear_suit)
		var/obj/item/clothing/suit/armor/A = H.wear_suit
		maxHealth += A.armor.melee //That zombie's got armor, I want armor!
	maxHealth += 40
	health = maxHealth
	name = "зомби массы"
	desc = "Труп, который управляется массой."
	mob_biotypes |= MOB_HUMANOID
	melee_damage_lower += 8
	melee_damage_upper += 11
	obj_damage = 20 //now that it has a corpse to puppet, it can properly attack structures
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	movement_type = GROUND
	death_cloud_size = 0
	icon = H.icon
	icon_state = "zombie"
	H.hairstyle = null
	H.update_hair()
	H.forceMove(src)
	oldguy = H
	update_icons()
	visible_message(span_warning("Тело [H.name] внезапно восстаёт из мёртвых!"))
	if(!key)
		if(!no_ghost)
			notify_ghosts("<b>[capitalize(src)]</b> был создан в [get_area(src)].", source = src, action = NOTIFY_ORBIT, flashwindow = FALSE, header = "Зомби массы создан")

/mob/living/simple_animal/hostile/blob/blobspore/death(gibbed)
	// On death, create a small smoke of harmful gas (s-Acid)
	/*
	var/datum/effect_system/fluid_spread/smoke/chem/S = new
	var/turf/location = get_turf(src)

	// Create the reagents to put into the air
	create_reagents(10)



	if(overmind?.blobstrain)
		overmind.blobstrain.on_sporedeath(src)
	else
		reagents.add_reagent(/datum/reagent/toxin/spore, 10)

	// Attach the smoke spreader and setup/start it.
	S.attach(location)
	S.set_up(death_cloud_size, carry = reagents, location = location, silent = TRUE)
	S.start()
	*/
	if(factory)
		factory.spore_delay = world.time + factory.spore_cooldown //put the factory on cooldown

	..()

/mob/living/simple_animal/hostile/blob/blobspore/Destroy()
	if(factory)
		factory.spores -= src
		factory = null
	if(oldguy)
		oldguy.forceMove(loc)
		oldguy = null
	return ..()

/mob/living/simple_animal/hostile/blob/blobspore/update_icons()
	if(overmind)
		add_atom_colour(overmind.blobstrain.complementary_color, FIXED_COLOUR_PRIORITY)
	else
		remove_atom_colour(FIXED_COLOUR_PRIORITY)
	if(is_zombie)
		copy_overlays(oldguy, TRUE)
		var/mutable_appearance/blob_head_overlay = mutable_appearance('icons/mob/blob.dmi', "blob_head")
		if(overmind)
			blob_head_overlay.color = overmind.blobstrain.complementary_color
		color = initial(color)//looks better.
		add_overlay(blob_head_overlay)

/mob/living/simple_animal/hostile/blob/blobspore/add_cell_sample()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_BLOBSPORE, CELL_VIRUS_TABLE_GENERIC_MOB, 1, 5)

/mob/living/simple_animal/hostile/blob/blobspore/independent
	gold_core_spawnable = HOSTILE_SPAWN
	independent = TRUE

/mob/living/simple_animal/hostile/blob/blobspore/independent/no_ghost
	no_ghost = TRUE

/mob/living/simple_animal/hostile/blob/blobspore/weak
	name = "Хрупкая спора массы"
	health = 15
	maxHealth = 15
	melee_damage_lower = 1
	melee_damage_upper = 2
	death_cloud_size = 0
	is_weak = TRUE

/////////////////
// BLOBBERNAUT //
/////////////////

/mob/living/simple_animal/hostile/blob/blobbernaut
	name = "Массанаут"
	desc = "Огромный мобильный кусок массы."
	icon_state = "blobbernaut"
	icon_living = "blobbernaut"
	icon_dead = "blobbernaut_dead"
	health = BLOBMOB_BLOBBERNAUT_HEALTH
	maxHealth = BLOBMOB_BLOBBERNAUT_HEALTH
	damage_coeff = list(BRUTE = 0.5, BURN = 1, TOX = 1, CLONE = 1, STAMINA = 0, OXY = 1)
	melee_damage_lower = BLOBMOB_BLOBBERNAUT_DMG_SOLO_LOWER
	melee_damage_upper = BLOBMOB_BLOBBERNAUT_DMG_SOLO_UPPER
	obj_damage = BLOBMOB_BLOBBERNAUT_DMG_OBJ
	attack_verb_continuous = "раздавливает"
	attack_verb_simple = "раздавливает"
	attack_sound = 'sound/effects/blobattack.ogg'
	verb_say = "булькает"
	verb_ask = "требует"
	verb_exclaim = "рычит"
	verb_yell = "воздыхает"
	force_threshold = 10
	pressure_resistance = 50
	mob_size = MOB_SIZE_LARGE
	hud_type = /datum/hud/living/blobbernaut

/mob/living/simple_animal/hostile/blob/blobbernaut/Initialize(mapload)
	. = ..()
	add_cell_sample()

/mob/living/simple_animal/hostile/blob/blobbernaut/add_cell_sample()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_BLOBBERNAUT, CELL_VIRUS_TABLE_GENERIC_MOB, 1, 5)

/mob/living/simple_animal/hostile/blob/blobbernaut/Life(delta_time = SSMOBS_DT, times_fired)
	if(!..())
		return
	var/list/blobs_in_area = range(2, src)
	if(independent)
		return // strong independent blobbernaut that don't need no blob
	var/damagesources = 0
	if(!(locate(/obj/structure/blob) in blobs_in_area))
		damagesources++

	if(!factory)
		damagesources++
	else
		if(locate(/obj/structure/blob/special/core) in blobs_in_area)
			adjustHealth(-maxHealth*BLOBMOB_BLOBBERNAUT_HEALING_CORE * delta_time)
			var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal(get_turf(src)) //hello yes you are being healed
			if(overmind)
				H.color = overmind.blobstrain.complementary_color
			else
				H.color = "#000000"
		if(locate(/obj/structure/blob/special/node) in blobs_in_area)
			adjustHealth(-maxHealth*BLOBMOB_BLOBBERNAUT_HEALING_NODE * delta_time)
			var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal(get_turf(src))
			if(overmind)
				H.color = overmind.blobstrain.complementary_color
			else
				H.color = "#000000"

	if(damagesources)
		adjustHealth(maxHealth * BLOBMOB_BLOBBERNAUT_HEALTH_DECAY * damagesources * delta_time) //take 2.5% of max health as damage when not near the blob or if the naut has no factory, 5% if both
		var/image/I = new('icons/mob/blob.dmi', src, "nautdamage", MOB_LAYER+0.01)
		I.appearance_flags = RESET_COLOR
		if(overmind)
			I.color = overmind.blobstrain.complementary_color
		flick_overlay_view(I, src, 8)

/mob/living/simple_animal/hostile/blob/blobbernaut/AttackingTarget()
	. = ..()
	if(. && isliving(target) && overmind)
		overmind.blobstrain.blobbernaut_attack(target, src)

/mob/living/simple_animal/hostile/blob/blobbernaut/update_icons()
	..()
	if(overmind) //if we have an overmind, we're doing chemical reactions instead of pure damage
		melee_damage_lower = BLOBMOB_BLOBBERNAUT_DMG_LOWER
		melee_damage_upper = BLOBMOB_BLOBBERNAUT_DMG_UPPER
		attack_verb_continuous = overmind.blobstrain.blobbernaut_message
	else
		melee_damage_lower = initial(melee_damage_lower)
		melee_damage_upper = initial(melee_damage_upper)
		attack_verb_continuous = initial(attack_verb_continuous)

/mob/living/simple_animal/hostile/blob/blobbernaut/death(gibbed)
	..(gibbed)
	if(factory)
		factory.naut = null //remove this naut from its factory
		factory.max_integrity = initial(factory.max_integrity)
	flick("blobbernaut_death", src)

/mob/living/simple_animal/hostile/blob/blobbernaut/independent
	independent = TRUE
	gold_core_spawnable = HOSTILE_SPAWN

/mob/living/simple_animal/hostile/blob/blobbernaut/independent/no_ghost
	no_ghost = TRUE

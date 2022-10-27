
//Apprenticeship contract - moved to antag_spawner.dm

///////////////////////////Veil Render//////////////////////

/obj/item/veilrender
	name = "проявитель вуали"
	desc = "Зловещий изогнутый клинок неизвестного происхождения, извлеченный из руин огромного города."
	icon = 'icons/obj/eldritch.dmi'
	icon_state = "bone_blade"
	inhand_icon_state = "bone_blade"
	worn_icon_state = "bone_blade"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 15
	throwforce = 10
	w_class = WEIGHT_CLASS_NORMAL
	hitsound = 'sound/weapons/stab1.ogg'
	var/charges = 1
	var/spawn_type = /obj/tear_in_reality
	var/spawn_amt = 1
	var/activate_descriptor = "реальности"
	var/rend_desc = "Нужно бежать, СРОЧНО!"
	var/spawn_fast = FALSE //if TRUE, ignores checking for mobs on loc before spawning

/obj/item/veilrender/attack_self(mob/user)
	if(charges > 0)
		new /obj/effect/rend(get_turf(user), spawn_type, spawn_amt, rend_desc, spawn_fast)
		charges--
		user.visible_message(span_boldannounce("[src] гудит силой, когда [user] наносит удар по [activate_descriptor]!"))
	else
		to_chat(user, span_danger("Неизвестная энергия, питавшая клинок, теперь неактивна."))

/obj/effect/rend
	name = "разрыв в ткани реальности"
	desc = "Нужно бежать, СРОЧНО!"
	icon = 'icons/effects/effects.dmi'
	icon_state = "rift"
	density = TRUE
	anchored = TRUE
	var/spawn_path = /mob/living/simple_animal/cow //defaulty cows to prevent unintentional narsies
	var/spawn_amt_left = 20
	var/spawn_fast = FALSE

/obj/effect/rend/Initialize(mapload, spawn_type, spawn_amt, desc, spawn_fast)
	. = ..()
	src.spawn_path = spawn_type
	src.spawn_amt_left = spawn_amt
	src.desc = desc
	src.spawn_fast = spawn_fast
	START_PROCESSING(SSobj, src)

/obj/effect/rend/process()
	if(!spawn_fast)
		if(locate(/mob) in loc)
			return
	new spawn_path(loc)
	spawn_amt_left--
	if(spawn_amt_left <= 0)
		qdel(src)

/obj/effect/rend/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/nullrod))
		user.visible_message(span_danger("[user] запечатывает [src] с помощью [I]."))
		qdel(src)
		return
	else
		return ..()

/obj/effect/rend/singularity_act()
	return

/obj/effect/rend/singularity_pull()
	return

/obj/item/veilrender/vealrender
	name = "проявитель голода"
	desc = "Зловещий изогнутый клинок неизвестного происхождения, найденный на развалинах огромной фермы."
	spawn_type = /mob/living/simple_animal/cow
	spawn_amt = 20
	activate_descriptor = "голоду"
	rend_desc = "Эхом отдается звук десяти тысяч Мууу-у-у-у!"

/obj/item/veilrender/honkrender
	name = "проявитель комедии"
	desc = "Зловещий изогнутый клинок неизвестного происхождения, найденный на развалинах огромного цирка."
	spawn_type = /mob/living/simple_animal/hostile/clown
	spawn_amt = 10
	activate_descriptor = "депрессии"
	rend_desc = "До вас долетают отзвуки бесконечного смеха."
	icon_state = "banana_blade"
	inhand_icon_state = "banana_blade"
	worn_icon_state = "render"

/obj/item/veilrender/honkrender/honkhulkrender
	name = "проявитель трагедии"
	desc = "Зловещий изогнутый клинок неизвестного происхождения, найденный на развалинах огромного цирка. Этот мерцает по особенному."
	spawn_type = /mob/living/simple_animal/hostile/clown/clownhulk
	spawn_amt = 5
	activate_descriptor = "депрессии"
	rend_desc = "Вы слышите звуки веселого хонканья."

#define TEAR_IN_REALITY_CONSUME_RANGE 3
#define TEAR_IN_REALITY_SINGULARITY_SIZE STAGE_FOUR

/// Tear in reality, spawned by the veil render
/obj/tear_in_reality
	name = "разрыв в ткани реальности"
	desc = "Так быть не должно..."
	icon = 'icons/effects/224x224.dmi'
	icon_state = "reality"
	pixel_x = -96
	pixel_y = -96
	anchored = TRUE
	density = TRUE
	move_resist = INFINITY
	plane = MASSIVE_OBJ_PLANE
	plane = ABOVE_LIGHTING_PLANE
	light_range = 6
	appearance_flags = LONG_GLIDE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	obj_flags = CAN_BE_HIT | DANGEROUS_POSSESSION

/obj/tear_in_reality/Initialize(mapload)
	. = ..()

	AddComponent(
		/datum/component/singularity, \
		consume_range = TEAR_IN_REALITY_CONSUME_RANGE, \
		notify_admins = !mapload, \
		roaming = FALSE, \
		singularity_size = TEAR_IN_REALITY_SINGULARITY_SIZE, \
	)

/obj/tear_in_reality/attack_tk(mob/user)
	if(!iscarbon(user))
		return
	. = COMPONENT_CANCEL_ATTACK_CHAIN
	var/mob/living/carbon/jedi = user
	var/datum/component/mood/insaneinthemembrane = jedi.GetComponent(/datum/component/mood)
	if(insaneinthemembrane.sanity < 15)
		return //they've already seen it and are about to die, or are just too insane to care
	to_chat(jedi, span_userdanger("БОЖЕ! ЭТО НЕ ПРАВДА! ЭТО ВСЁ НЕ ПРААААААААВДАААААААА!"))
	insaneinthemembrane.sanity = 0
	for(var/lore in typesof(/datum/brain_trauma/severe))
		jedi.gain_trauma(lore)
	addtimer(CALLBACK(src, .proc/deranged, jedi), 10 SECONDS)

/obj/tear_in_reality/proc/deranged(mob/living/carbon/C)
	if(!C || C.stat == DEAD)
		return
	C.vomit(0, TRUE, TRUE, 3, TRUE)
	C.spew_organ(3, 2)
	C.death()

#undef TEAR_IN_REALITY_CONSUME_RANGE
#undef TEAR_IN_REALITY_SINGULARITY_SIZE

/////////////////////////////////////////Scrying///////////////////

/obj/item/scrying
	name = "сфера провидца"
	desc = "Раскаленный шар потусторонней энергии, просто держа его в руках, ваше зрение и слух с легкостью преступает рамки ограничивающие смертных, а пристальный взгляд в него позволяет вам увидеть всю вселенную."
	icon = 'icons/obj/guns/projectiles.dmi'
	icon_state ="bluespace"
	throw_speed = 3
	throw_range = 7
	throwforce = 15
	damtype = BURN
	force = 15
	hitsound = 'sound/items/welder2.ogg'

	var/mob/current_owner

/obj/item/scrying/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/scrying/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/scrying/process()
	var/mob/holder = get(loc, /mob)
	if(current_owner && current_owner != holder)

		to_chat(current_owner, span_notice("Я больше не вижу мёртвых..."))

		REMOVE_TRAIT(current_owner, TRAIT_SIXTHSENSE, SCRYING_ORB)
		REMOVE_TRAIT(current_owner, TRAIT_XRAY_VISION, SCRYING_ORB)
		current_owner.update_sight()

		current_owner = null

	if(!current_owner && holder)
		current_owner = holder

		to_chat(current_owner, span_notice("Я вижу... вижу всё!"))

		ADD_TRAIT(current_owner, TRAIT_SIXTHSENSE, SCRYING_ORB)
		ADD_TRAIT(current_owner, TRAIT_XRAY_VISION, SCRYING_ORB)
		current_owner.update_sight()

/obj/item/scrying/attack_self(mob/user)
	visible_message(span_danger("[user] смотрит в [src], и его глаза застилает тьма."))
	user.ghostize(1)

/////////////////////////////////////////Necromantic Stone///////////////////

/obj/item/necromantic_stone
	name = "камень некроманта"
	desc = "Камень, способный воскрешать мёртвых в качестве ваших рабов-скелетов."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "necrostone"
	inhand_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	var/list/spooky_scaries = list()
	var/unlimited = 0

/obj/item/necromantic_stone/unlimited
	unlimited = 1

/obj/item/necromantic_stone/attack(mob/living/carbon/human/M, mob/living/carbon/human/user)
	if(!istype(M))
		return ..()

	if(!istype(user) || !user.canUseTopic(M, BE_CLOSE))
		return

	if(M.stat != DEAD)
		to_chat(user, span_warning("Этот артефакт бессилен на живых!"))
		return

	for(var/mob/dead/observer/ghost in GLOB.dead_mob_list) //excludes new players
		if(ghost.mind && ghost.mind.current == M && ghost.client)  //the dead mobs list can contain clientless mobs
			ghost.reenter_corpse()
			break

	if(!M.mind || !M.client)
		to_chat(user, span_warning("Я не чувствую души..."))
		return

	check_spooky()//clean out/refresh the list
	if(spooky_scaries.len >= 3 && !unlimited)
		to_chat(user, span_warning("Этот артефакт может контролировать не более трёх рабов одновременно!"))
		return

	M.set_species(/datum/species/skeleton, icon_update=0)
	M.revive(full_heal = TRUE, admin_revive = TRUE)
	spooky_scaries |= M
	to_chat(M, "[span_userdanger("Вы были воскрешены ")]<B>[user.real_name]!</B>")
	to_chat(M, span_userdanger("[user.p_theyre(TRUE)] теперь твой хозяин, помогите [user.p_them()] даже если это будет стоить вашего оставшегося подобия жизни!"))
	var/datum/antagonist/wizard/antag_datum = user.mind.has_antag_datum(/datum/antagonist/wizard)
	if(antag_datum)
		if(!antag_datum.wiz_team)
			antag_datum.create_wiz_team()
		M.mind.add_antag_datum(/datum/antagonist/wizard_minion, antag_datum.wiz_team)

	equip_roman_skeleton(M)

	desc = "Камень, способный воскрешать мёртвых в качестве ваших рабов-скелетов[unlimited ? "." : ", [spooky_scaries.len]/3 активных рабов."]"

/obj/item/necromantic_stone/proc/check_spooky()
	if(unlimited) //no point, the list isn't used.
		return

	for(var/X in spooky_scaries)
		if(!ishuman(X))
			spooky_scaries.Remove(X)
			continue
		var/mob/living/carbon/human/H = X
		if(H.stat == DEAD)
			H.dust(TRUE)
			spooky_scaries.Remove(X)
			continue
	list_clear_nulls(spooky_scaries)

//Funny gimmick, skeletons always seem to wear roman/ancient armour
/obj/item/necromantic_stone/proc/equip_roman_skeleton(mob/living/carbon/human/H)
	for(var/obj/item/I in H)
		H.dropItemToGround(I)

	var/hat = pick(/obj/item/clothing/head/helmet/roman, /obj/item/clothing/head/helmet/roman/legionnaire)
	H.equip_to_slot_or_del(new hat(H), ITEM_SLOT_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/costume/roman(H), ITEM_SLOT_ICLOTHING)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/roman(H), ITEM_SLOT_FEET)
	H.put_in_hands(new /obj/item/shield/riot/roman(H), TRUE)
	H.put_in_hands(new /obj/item/claymore(H), TRUE)
	H.equip_to_slot_or_del(new /obj/item/spear(H), ITEM_SLOT_BACK)

//Provides a decent heal, need to pump every 6 seconds
/obj/item/organ/heart/cursed/wizard
	pump_delay = 60
	heal_brute = 25
	heal_burn = 25
	heal_oxy = 25

///Warp whistle, spawns a tornado that teleports you
/obj/item/warp_whistle
	name = "варп-свисток"
	desc = "Вызывает смерч, способный забрать вас и высадить в случайном месте на станции."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "whistle"

	/// Person using the warp whistle
	var/mob/living/whistler

/obj/item/warp_whistle/attack_self(mob/user)
	if(whistler)
		to_chat(user, span_warning("[src] еще не готов к повторному использованию!"))
		return

	whistler = user
	var/turf/current_turf = get_turf(user)
	var/turf/spawn_location = locate(user.x + pick(-7, 7), user.y, user.z)
	playsound(current_turf,'sound/magic/warpwhistle.ogg', 200, TRUE)
	new /obj/effect/temp_visual/teleporting_tornado(spawn_location, src)

///Teleporting tornado, spawned by warp whistle, teleports the user if they manage to pick them up.
/obj/effect/temp_visual/teleporting_tornado
	name = "торнадо"
	desc = "Эта штука ужасна!"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "tornado"
	layer = FLY_LAYER
	plane = ABOVE_GAME_PLANE
	randomdir = FALSE
	duration = 8 SECONDS
	movement_type = PHASING

	/// Reference to the whistle
	var/obj/item/warp_whistle/whistle
	/// List of all mobs currently held by the tornado.
	var/list/pickedup_mobs = list()

/obj/effect/temp_visual/teleporting_tornado/Initialize(mapload, obj/item/warp_whistle/whistle)
	. = ..()
	src.whistle = whistle
	if(!whistle)
		qdel(src)
		return
	RegisterSignal(src, COMSIG_MOVABLE_CROSS_OVER, .proc/check_teleport)
	SSmove_manager.move_towards(src, get_turf(whistle.whistler))

/// Check if anything the tornado crosses is the creator.
/obj/effect/temp_visual/teleporting_tornado/proc/check_teleport(datum/source, atom/movable/crossed)
	SIGNAL_HANDLER
	if(crossed != whistle.whistler || (crossed in pickedup_mobs))
		return

	pickedup_mobs += crossed
	buckle_mob(crossed, TRUE, FALSE)
	ADD_TRAIT(crossed, TRAIT_INCAPACITATED, WARPWHISTLE_TRAIT)
	animate(src, alpha = 20, pixel_y = 400, time = 3 SECONDS)
	animate(crossed, pixel_y = 400, time = 3 SECONDS)
	addtimer(CALLBACK(src, .proc/send_away), 2 SECONDS)

/obj/effect/temp_visual/teleporting_tornado/proc/send_away()
	var/turf/ending_turfs = find_safe_turf()
	for(var/mob/stored_mobs as anything in pickedup_mobs)
		do_teleport(stored_mobs, ending_turfs, channel = TELEPORT_CHANNEL_MAGIC)
		animate(stored_mobs, pixel_y = null, time = 1 SECONDS)
		stored_mobs.log_message("warped with [whistle].", LOG_ATTACK, color = "red")
		REMOVE_TRAIT(stored_mobs, TRAIT_INCAPACITATED, WARPWHISTLE_TRAIT)

/// Destroy the tornado and teleport everyone on it away.
/obj/effect/temp_visual/teleporting_tornado/Destroy()
	if(whistle)
		whistle.whistler = null
		whistle = null
	return ..()

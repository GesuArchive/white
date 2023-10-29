/obj/item/terroristsc4
	name = "БОМБА"
	desc = "Модифицированный заряд C-4, который смешно пиликает."
	icon = 'icons/obj/grenade.dmi'
	icon_state = "plastic-explosive0"
	inhand_icon_state = "plastic-explosive"
	worn_icon_state = "c4"
	lefthand_file = 'icons/mob/inhands/weapons/bombs_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/bombs_righthand.dmi'
	w_class = WEIGHT_CLASS_HUGE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/det_time = 30

/obj/item/terroristsc4/afterattack(atom/movable/AM, mob/user, flag)
	to_chat(user, span_notice("Нужно активировать бомбу в РУКЕ для установки."))
	return

/obj/item/terroristsc4/attack_self(mob/user)
	var/datum/antagonist/combatant/comb = user.mind.has_antag_datum(/datum/antagonist/combatant/red)
	if(!comb)
		to_chat(user, span_notice("Это не входит в рамки специальной операции."))
		return
	var/found = FALSE
	for(var/atom/A in SSviolence.bomb_locations)
		var/turf/T1 = get_turf(A)
		var/turf/T2 = get_turf(user)
		if(get_dist(T1, T2) <= 2)
			found = TRUE

	if(!found)
		to_chat(user, span_notice("Нужно ставить бомбу строго возле необходимой точки!"))
		return

	to_chat(user, span_notice("Начинаю устанавливать [src]. Таймер установлен на [det_time]..."))

	playsound(get_turf(user), 'sound/effects/violence/c4_click.ogg', 100)

	for(var/s in 1 to 6)
		if(!do_after(user, rand(5, 8), target = get_turf(user)))
			return
		playsound(get_turf(user), 'sound/effects/violence/c4_click.ogg', 100)

	if(!user.temporarilyRemoveItemFromInventory(src))
		return

	to_chat(world, leader_brass("Бомба установлена! Время до взрыва: [det_time] секунд."))

	if(SSviolence.players[user?.ckey])
		var/datum/violence_player/VP = SSviolence.players[user.ckey]
		VP.money += 30
		to_chat(user, span_boldnotice("+30₽ за установку бомбы!"))

	SSviolence.time_limit = 30 SECONDS

	forceMove(get_turf(user))

	interaction_flags_item = NONE

	anchored = TRUE

	SSviolence.bomb_active = TRUE
	SSviolence.bomb_planted = TRUE

	spawn(4 SECONDS)
		play_sound_to_everyone('sound/effects/violence/bcountdown.ogg', 100, CHANNEL_NASHEED)

	addtimer(CALLBACK(src, PROC_REF(detonate)), det_time SECONDS)

/obj/item/terroristsc4/attack_hand(mob/user)
	if(!SSviolence.bomb_planted)
		return ..()
	var/datum/antagonist/combatant/comb = user.mind.has_antag_datum(/datum/antagonist/combatant/blue)
	if(!comb)
		return
	playsound(get_turf(user), 'sound/effects/violence/c4_disarm.ogg', 100)
	if(do_after(user, 10 SECONDS, target = src))
		to_chat(world, leader_brass("Бомба обезврежена [user]!"))
		SSviolence.bomb_active = FALSE
		play_sound_to_everyone(null, 0, CHANNEL_NASHEED)
		if(SSviolence.players[user?.ckey])
			var/datum/violence_player/VP = SSviolence.players[user.ckey]
			VP.money += 30
			to_chat(user, span_boldnotice("+30₽ за обезвреживание бомбы!"))
		qdel(src)

/obj/item/terroristsc4/attackby(obj/item/I, mob/user, params)
	if(!SSviolence.bomb_planted)
		return ..()
	var/datum/antagonist/combatant/comb = user.mind.has_antag_datum(/datum/antagonist/combatant/blue)
	if(!comb)
		return
	var/defuse_time = 10 SECONDS

	if(I.tool_behaviour == TOOL_WIRECUTTER)
		defuse_time = 5 SECONDS

	playsound(get_turf(user), 'sound/effects/violence/c4_disarm.ogg', 100)

	if(do_after(user, defuse_time, target = src))
		to_chat(world, leader_brass("Бомба обезврежена [user]!"))
		SSviolence.bomb_active = FALSE
		play_sound_to_everyone(null, 0, CHANNEL_NASHEED)
		if(SSviolence.players[user?.ckey])
			var/datum/violence_player/VP = SSviolence.players[user.ckey]
			VP.money += 30
			to_chat(user, span_boldnotice("+30₽ за обезвреживание бомбы!"))
		qdel(src)

/obj/item/terroristsc4/proc/detonate()
	for(var/mob/M in view(7, get_turf(src)))
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			H.gib()
	SSviolence.bomb_detonated = TRUE
	explosion(src, light_impact_range = 3, flame_range = 14, flash_range = 14)
	explosion(get_turf(src), 0, 0, 0, 0)
	to_chat(world, leader_brass("Бомба взорвана!"))
	qdel(src)

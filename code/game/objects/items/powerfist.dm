/obj/item/melee/powerfist
	name = "силовой кулак"
	desc = "Металлическая перчатка с поршневым тараном на вершине для дополнительной силы в вашем ударе."
	icon_state = "powerfist"
	inhand_icon_state = "powerfist"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	flags_1 = CONDUCT_1
	attack_verb_continuous = list("вмазывает", "фистит", "очень сильно бьёт")
	attack_verb_simple = list("вмазывает", "фистит", "очень сильно бьёт")
	force = 20
	throwforce = 10
	throw_range = 7
	w_class = WEIGHT_CLASS_NORMAL
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 40)
	resistance_flags = FIRE_PROOF
	var/click_delay = 1.5
	var/fisto_setting = 1
	var/gasperfist = 3
	var/obj/item/tank/internals/tank = null //Tank used for the gauntlet's piston-ram.


/obj/item/melee/powerfist/examine(mob/user)
	. = ..()
	if(!in_range(user, src))
		. += "<hr><span class='notice'>Нужно подойти ближе, чтобы увидеть что-то ещё.</span>"
		return
	if(tank)
		. += "<hr><span class='notice'>[icon2html(tank, user)] It has \a [tank] mounted onto it.</span>"


/obj/item/melee/powerfist/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/tank/internals))
		if(!tank)
			var/obj/item/tank/internals/IT = W
			if(IT.volume <= 3)
				to_chat(user, span_warning("<b>[capitalize(IT)]</b> is too small for <b>[src.name]</b>."))
				return
			updateTank(W, 0, user)
	else if(W.tool_behaviour == TOOL_WRENCH)
		switch(fisto_setting)
			if(1)
				fisto_setting = 2
			if(2)
				fisto_setting = 3
			if(3)
				fisto_setting = 1
		W.play_tool_sound(src)
		to_chat(user, span_notice("Настраиваю поршневой клапан <b>[src.name]</b> на [fisto_setting]."))
	else if(W.tool_behaviour == TOOL_SCREWDRIVER)
		if(tank)
			updateTank(tank, 1, user)

/obj/item/melee/powerfist/proc/updateTank(obj/item/tank/internals/thetank, removing = 0, mob/living/carbon/human/user)
	if(removing)
		if(!tank)
			to_chat(user, span_notice("<b>[capitalize(src)]</b> не имеет баллона."))
			return
		to_chat(user, span_notice("Открепляю [thetank] от <b>[src.name]</b>."))
		tank.forceMove(get_turf(user))
		user.put_in_hands(tank)
		tank = null
	if(!removing)
		if(tank)
			to_chat(user, span_warning("<b>[capitalize(src)]</b> уже имеет баллон."))
			return
		if(!user.transferItemToLoc(thetank, src))
			return
		to_chat(user, span_notice("Присоединяю [thetank] к <b>[src.name]</b>."))
		tank = thetank


/obj/item/melee/powerfist/attack(mob/living/target, mob/living/user)
	if(!tank)
		to_chat(user, span_warning("<b>[capitalize(src)]</b> не может работать без источника газа!"))
		return
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning("Не хочу вредить живым существам!"))
		return
	var/datum/gas_mixture/gasused = tank.air_contents.remove(gasperfist * fisto_setting)
	var/turf/T = get_turf(src)
	if(!T)
		return
	T.assume_air(gasused)
	T.air_update_turf()
	if(!gasused)
		to_chat(user, span_warning("<b>[capitalize(src)]</b>'s tank is empty!"))
		target.apply_damage((force / 5), BRUTE)
		playsound(loc, 'sound/weapons/punch1.ogg', 50, TRUE)
		target.visible_message(span_danger("[user] силовой кулак издает тупой стук от удара [user.ru_who()] по [user.p_es()] [target.name]!") , \
			span_userdanger("[user] бьет тебя!"))
		return
	if(gasused.total_moles() < gasperfist * fisto_setting)
		to_chat(user, span_warning("Поршневая рама <b>[src.name]</b> издает слабое шипение, ей нужно больше газа!"))
		playsound(loc, 'sound/weapons/punch4.ogg', 50, TRUE)
		target.apply_damage((force / 2), BRUTE)
		target.visible_message(span_danger("[user] силовой кулак издает слабое шипение во время удара [user.ru_who()] по [user.p_es()] [target.name]!") , \
			span_userdanger("[user] бьет с большой силой!"))
		return

	target.apply_damage(force * fisto_setting, BRUTE, wound_bonus = CANT_WOUND)
	target.visible_message(span_danger("[user] силовой кулак издает сильное шипение во время удара [user.ru_who()] по [user.p_es()] [target.name]!") , \
		span_userdanger("Вскрикиваю от боли, когда [user] удар отбрасывает меня назад!"))
	new /obj/effect/temp_visual/kinetic_blast(target.loc)
	playsound(loc, 'sound/weapons/resonator_blast.ogg', 50, TRUE)
	playsound(loc, 'sound/weapons/genhit2.wav', 50, TRUE)

	var/atom/throw_target = get_edge_target_turf(target, get_dir(src, get_step_away(target, src)))

	target.throw_at(throw_target, 5 * fisto_setting, 0.5 + (fisto_setting / 2))

	log_combat(user, target, "power fisted", src)

	user.changeNext_move(CLICK_CD_MELEE * click_delay)

	return

/obj/structure/chair/noose //It's a "chair".
	name = "вешалка"
	desc = "Интересная."
	icon_state = "noose"
	icon = 'white/valtos/icons/objects.dmi'
	layer = FLY_LAYER
	flags_1 = NODECONSTRUCT_1
	var/image/over

/obj/structure/chair/noose/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/wirecutters))
		user.visible_message("[user] режет вешалку.", span_notice("Режу вешалку."))
		if(has_buckled_mobs())
			for(var/m in buckled_mobs)
				var/mob/living/buckled_mob = m
				if(buckled_mob.mob_has_gravity())
					buckled_mob.visible_message(span_danger("[buckled_mob] падает на пол!") ,\
						span_userdanger("Падаю на пол!"))
					buckled_mob.adjustBruteLoss(10)
		var/obj/item/stack/cable_coil/C = new(get_turf(src))
		C.amount = 25
		qdel(src)
		return
	..()

/obj/structure/chair/noose/Initialize()
	. = ..()
	pixel_y += 16 //Noose looks like it's "hanging" in the air
	over = image(icon, "noose_overlay")
	over.layer = FLY_LAYER
	add_overlay(over)

/obj/structure/chair/noose/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/chair/noose/post_buckle_mob(mob/living/M)
	if(has_buckled_mobs())
		src.layer = MOB_LAYER
		START_PROCESSING(SSobj, src)
		M.dir = SOUTH
		animate(M, pixel_y = initial(pixel_y) + 8, time = 8, easing = LINEAR_EASING)
	else
		layer = initial(layer)
		STOP_PROCESSING(SSobj, src)
		M.pixel_x = initial(M.pixel_x)
		pixel_x = initial(pixel_x)
		M.pixel_y = M.base_pixel_y

/obj/structure/chair/noose/user_unbuckle_mob(mob/living/M,mob/living/user)
	if(has_buckled_mobs())
		if(M != user && user)
			user.visible_message(span_notice("[user] начинает ослаблять вешалку вокруг шеи [M]...") ,\
				span_notice("Начинаю ослаблять вешалку вокруг шеи [M]..."))
			if(!do_mob(user, M, 100))
				return
			user.visible_message(span_notice("[user] ослабляет вешалку вокруг шеи [M]!") ,\
				span_notice("Ослабляю вешалку вокруг шеи [M]!"))
		else
			M.visible_message(\
				span_warning("[M] дёргатся пытаясь выбраться из вешалки!") ,\
				span_notice("Дёргаюсь пытаясь выбраться из вешалки... (Надо не двигаться 15 секунд.)"))
			if(!do_after(M, 150, target = src))
				if(M && M.buckled)
					to_chat(M, span_warning("НЕ ВЫШЛО!"))
				return
			if(!M.buckled)
				return
			M.visible_message(\
				span_warning("[M] снимает вешалку со своей шеи!") ,\
				span_notice("Снимаю вешалку со своей шеи!"))
			M.Knockdown(60)
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			H.noosed = FALSE
		unbuckle_all_mobs(force=1)
		M.pixel_z = initial(M.pixel_z)
		pixel_z = initial(pixel_z)
		add_fingerprint(user)

/obj/structure/chair/noose/user_buckle_mob(mob/living/carbon/human/M, mob/user, check_loc = TRUE)
	if(!in_range(user, src) || user.stat || !iscarbon(M))
		return FALSE

	if (!M.get_bodypart("head"))
		to_chat(user, span_warning("[M] без головы!"))
		return FALSE

	if(M.loc != src.loc)
		return FALSE //Can only noose someone if they're on the same tile as noose

	add_fingerprint(user)

	M.visible_message(\
		span_danger("[user] пытается накинуть вешалку на шею [M]!") ,\
		span_userdanger("[user] пытается натянуть вешалку на мою шею!"))
	if(user != M)
		to_chat(user, span_notice("Это займёт примерно 20 секунд и надо не двигаться."))
	if(do_mob(user, M, user == M ? 10:200))
		if(buckle_mob(M))
			user.visible_message(\
				span_warning("[user] вешает [M != user ? "[M]" : "себя"]!") ,\
				span_userdanger("[M != user ? "[user] вешает меня" : "Вешаю себя"]!"))
			playsound(user.loc, 'white/valtos/sounds/noosed.ogg', 50, 1, -1)
			log_combat(user, M, "hanged", src)
			M.noosed = TRUE
			return TRUE
	user.visible_message(\
		span_warning("[user] не может накинуть вешалку на шею [M]!") ,\
		span_warning("Не получается накинуть вешалку на шею [M]!"))
	log_combat(user, M, "tried to hang", src)
	return FALSE


/obj/structure/chair/noose/process()
	if(!has_buckled_mobs())
		STOP_PROCESSING(SSobj, src)
		return
	for(var/m in buckled_mobs)
		var/mob/living/buckled_mob = m
		if(pixel_x >= 0)
			animate(src, pixel_x = -3, time = 45, easing = ELASTIC_EASING)
			animate(m, pixel_x = -3, time = 45, easing = ELASTIC_EASING)
		else
			animate(src, pixel_x = 3, time = 45, easing = ELASTIC_EASING)
			animate(m, pixel_x = 3, time = 45, easing = ELASTIC_EASING)
		if(buckled_mob.mob_has_gravity())
			buckled_mob.adjustOxyLoss(5)
			if(prob(40))
				buckled_mob.emote("gasp")
			if(prob(20))
				var/flavor_text = list(span_suicide("[buckled_mob] дёргает своими ножками в агонии.") ,\
					span_suicide("[buckled_mob] пытается выбраться из вешалки весело подёргиваясь.") ,\
					span_suicide("[buckled_mob] раскачивается взад и вперёд постепенно замедляясь."))
				if(buckled_mob.stat == DEAD)
					flavor_text = list(span_suicide("[buckled_mob] вяло качается на вешалке.") ,\
						span_suicide("Взгляд [buckled_mob] направлен в пустоту."))
				if(prob(5))
					buckled_mob.visible_message(pick(flavor_text))
				playsound(buckled_mob.loc, 'white/valtos/sounds/noose_idle.ogg', 30, 1, -3)

/mob/living/carbon/human
	var/noosed = FALSE

/mob/living/carbon/human/proc/checknoosedrop()
	if(noosed)
		for(var/obj/structure/chair/noose/noose in loc)
			noose.unbuckle_all_mobs(force = 1)

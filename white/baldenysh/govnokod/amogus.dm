/obj/structure/statue/amogus
	name = "статуя космонавта"
	desc = "Статуя космонавта в смирительном скафандре. Выполнена из настоящей асбестовой ткани, намотанной на металлический каркас."
	icon = 'white/baldenysh/icons/obj/amogus.dmi'
	icon_state = "amogusdrip_statue"
	max_integrity = 500
	pixel_y = 16
	density = TRUE
	anchored = TRUE
	var/ripper = FALSE

/obj/structure/statue/amogus/Initialize()
	. = ..()
	transform *= 2
	LoadComponent(/datum/component/storage/concrete/pockets/butt/bluebutt)
	if(prob(30))
		var/list/butt_loot = list(
				/obj/item/gun/ballistic/automatic/pistol/deagle,
				/obj/item/gun/ballistic/revolver/mateba,
				/obj/item/gun/ballistic/xviii_rifle,
				/obj/item/gun/ballistic/shotgun/sniper,
				/obj/item/gun/ballistic/rifle/boltaction
				)
		var/loot_type = pick(butt_loot)
		new loot_type(src)
	if(prob(50))
		ripper = TRUE

/obj/structure/statue/amogus/examine(mob/user)
	. = ..()
	if(get_dist(src, user) < 2)
		. += "\n<span class='notice'>Похоже, между ягодицами можно просунуть руку... \n GROIN+GRAB+CLICK чтобы пошариться в заднице статуи.</span>"

/obj/structure/statue/amogus/MouseDrop(atom/over, src_location, over_location, src_control, over_control, params)
	return

/obj/structure/statue/amogus/attack_hand(mob/living/user)
	. = ..()
	if(user.zone_selected == BODY_ZONE_PRECISE_GROIN && user.a_intent == INTENT_GRAB && iscarbon(user))
		var/mob/living/carbon/c_user = user
		var/datum/component/storage/STR = GetComponent(/datum/component/storage)
		user.visible_message(span_notice("[user] сует руку в попу [src].") , \
			span_notice("Начинаю шариться между булками у [src]..."))
		if(do_after(c_user, 7 SECONDS))
			if(ripper && prob(80))
				user.visible_message(span_danger("[src] вырывает и засасывает руку [user]!") , \
					span_userdanger("Задница [src] поглощает мою драгоценную ручку!!!"))
				var/which_hand = BODY_ZONE_L_ARM
				if(!(c_user.active_hand_index % 2))
					which_hand = BODY_ZONE_R_ARM
				var/obj/item/bodypart/hand = c_user.get_bodypart(which_hand)
				hand.dismember()
				if (user.active_storage == STR)
					user.active_storage.close(user)
				hand.forceMove(src)
				return TRUE
			if (user.active_storage)
				user.active_storage.close(user)
			STR.orient2hud(user)
			STR.show_to(user)
			return TRUE



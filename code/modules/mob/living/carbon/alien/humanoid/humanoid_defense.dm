

/mob/living/carbon/alien/humanoid/attack_hulk(mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return
	adjustBruteLoss(15)
	var/hitverb = "hit"
	if(mob_size < MOB_SIZE_LARGE)
		safe_throw_at(get_edge_target_turf(src, get_dir(user, src)), 2, 1, user)
		hitverb = "slam"
	playsound(loc, "punch", 25, TRUE, -1)
	visible_message(span_danger("[user] [hitverb]s [src]!") , \
					span_userdanger("[user] [hitverb]s you!") , span_hear("Слышу звук разрывающейся плоти!") , COMBAT_MESSAGE_RANGE, user)
	to_chat(user, span_danger("You [hitverb] [src]!"))

/mob/living/carbon/alien/humanoid/attack_hand(mob/living/carbon/human/M)
	if(..())
		switch(M.a_intent)
			if (INTENT_HARM)
				var/damage = rand(1, 9)
				if (prob(90))
					playsound(loc, "punch", 25, TRUE, -1)
					visible_message(span_danger("[M] punches [src]!") , \
									span_userdanger("[M] punches you!") , span_hear("Слышу звук разрывающейся плоти!") , COMBAT_MESSAGE_RANGE, M)
					to_chat(M, span_danger("You punch [src]!"))
					if ((stat != DEAD) && (damage > 9 || prob(5)))//Regular humans have a very small chance of knocking an alien down.
						Unconscious(40)
						visible_message(span_danger("[M] knocks [src] down!") , \
										span_userdanger("[M] knocks you down!") , span_hear("Слышу звук разрывающейся плоти!") , null, M)
						to_chat(M, span_danger("You knock [src] down!"))
					var/obj/item/bodypart/affecting = get_bodypart(ran_zone(M.zone_selected))
					apply_damage(damage, BRUTE, affecting)
					log_combat(M, src, "атакует")
				else
					playsound(loc, 'sound/weapons/punchmiss.ogg', 25, TRUE, -1)
					visible_message(span_danger("[M] punch misses [src]!") , \
									span_danger("You avoid [M] punch!") , span_hear("Слышу взмах!") , COMBAT_MESSAGE_RANGE, M)
					to_chat(M, span_warning("Your punch misses [src]!"))

			if (INTENT_DISARM)
				if (body_position == STANDING_UP)
					if (prob(5))
						Unconscious(40)
						playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, TRUE, -1)
						log_combat(M, src, "pushed")
						visible_message(span_danger("[M] pushes [src] down!") , \
										span_userdanger("[M] pushes you down!") , span_hear("Слышу агрессивную потасовку сопровождающуюся громким стуком!") , null, M)
						to_chat(M, span_danger("You push [src] down!"))
					else
						if (prob(50))
							dropItemToGround(get_active_held_item())
							playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, TRUE, -1)
							visible_message(span_danger("[M] disarms [src]!") , \
											span_userdanger("[M] disarms you!") , span_hear("Слышу агрессивную потасовку!") , COMBAT_MESSAGE_RANGE, M)
							to_chat(M, span_danger("You disarm [src]!"))
						else
							playsound(loc, 'sound/weapons/punchmiss.ogg', 25, TRUE, -1)
							visible_message(span_danger("[M] fails to disarm [src]!") ,\
											span_danger("[M] fails to disarm you!") , span_hear("Слышу взмах!") , COMBAT_MESSAGE_RANGE, M)
							to_chat(M, span_warning("You fail to disarm [src]!"))



/mob/living/carbon/alien/humanoid/do_attack_animation(atom/A, visual_effect_icon, obj/item/used_item, no_effect)
	if(!no_effect && !visual_effect_icon)
		visual_effect_icon = ATTACK_EFFECT_CLAW
	..()


//holographic signs and barriers

/obj/structure/holosign
	name = "holo sign"
	icon = 'icons/effects/effects.dmi'
	anchored = TRUE
	max_integrity = 1
	armor = list(MELEE = 0, BULLET = 50, LASER = 50, ENERGY = 50, BOMB = 0, BIO = 0, RAD = 0, FIRE = 20, ACID = 20)
	var/obj/item/holosign_creator/projector
	var/use_vis_overlay = TRUE

/obj/structure/holosign/Initialize(loc, source_projector)
	. = ..()
	var/turf/our_turf = get_turf(src)
	if(use_vis_overlay)
		alpha = 0
		SSvis_overlays.add_vis_overlay(src, icon, icon_state, ABOVE_MOB_LAYER, MUTATE_PLANE(GAME_PLANE_UPPER, our_turf), dir, add_appearance_flags = RESET_ALPHA) //you see mobs under it, but you hit them like they are above it
	if(source_projector)
		projector = source_projector
		LAZYADD(projector.signs, src)

/obj/structure/holosign/Destroy()
	if(projector)
		LAZYREMOVE(projector.signs, src)
		projector = null
	return ..()

/obj/structure/holosign/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	attack_holosign(user)

/obj/structure/holosign/proc/attack_holosign(mob/living/user)
	user.do_attack_animation(src, ATTACK_EFFECT_PUNCH)
	user.changeNext_move(CLICK_CD_MELEE)
	take_damage(5 , BRUTE, MELEE, 1)

/obj/structure/holosign/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			playsound(loc, 'sound/weapons/egloves.ogg', 80, TRUE)
		if(BURN)
			playsound(loc, 'sound/weapons/egloves.ogg', 80, TRUE)

/obj/structure/holosign/wetsign
	name = "знак мокрого пола"
	desc = "Слова мелькают, как будто они ничего не значат."
	icon = 'icons/effects/effects.dmi'
	icon_state = "holosign"

/obj/structure/holosign/barrier
	name = "голографический барьер"
	desc = "Небольшой голографический барьер, который можно преодолеть только замедлившись до шага."
	icon_state = "holosign_sec"
	pass_flags_self = PASSTABLE | PASSGRILLE | PASSGLASS | LETPASSTHROW
	density = TRUE
	max_integrity = 20
	var/allow_walk = TRUE //can we pass through it on walk intent

/obj/structure/holosign/barrier/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(.)
		return
	if(iscarbon(mover))
		var/mob/living/carbon/C = mover
		if(C.stat)	// Lets not prevent dragging unconscious/dead people.
			return TRUE
		if(allow_walk && (C.m_intent == MOVE_INTENT_WALK || C.m_intent == MOVE_INTENT_CRAWL))
			return TRUE

/obj/structure/holosign/barrier/wetsign
	name = "голографический барьер мокрого пола"
	desc = "Когда он говорит \"шагом\", это означает \"шагом\"."
	icon = 'icons/effects/effects.dmi'
	icon_state = "holosign"

/obj/structure/holosign/barrier/wetsign/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(iscarbon(mover))
		var/mob/living/carbon/C = mover
		if(C.stat)	// Lets not prevent dragging unconscious/dead people.
			return TRUE
		if(allow_walk && C.m_intent != MOVE_INTENT_WALK)
			return FALSE

/obj/structure/holosign/barrier/engineering
	icon_state = "holosign_engi"
	flags_1 = RAD_PROTECT_CONTENTS_1 | RAD_NO_CONTAMINATE_1
	rad_insulation = RAD_LIGHT_INSULATION

/obj/structure/holosign/barrier/atmos
	name = "голографический барьер АТМОСа"
	desc = "Барьер, препятствующие прохождению газов, но не людей."
	icon_state = "holo_firelock"
	density = FALSE
	anchored = TRUE
	can_atmos_pass = ATMOS_PASS_NO
	alpha = 150
	flags_1 = RAD_PROTECT_CONTENTS_1 | RAD_NO_CONTAMINATE_1
	rad_insulation = RAD_LIGHT_INSULATION

/obj/structure/holosign/barrier/atmos/sturdy
	name = "крепкий голофайрлок"
	max_integrity = 150

/obj/structure/holosign/barrier/atmos/Initialize(mapload)
	. = ..()
	air_update_turf(TRUE)

/obj/structure/holosign/barrier/atmos/block_superconductivity()
	return TRUE

/obj/structure/holosign/barrier/atmos/Destroy()
	. = ..()
	air_update_turf(TRUE)

/obj/structure/holosign/barrier/cyborg
	name = "Energy Field"
	desc = "A fragile energy field that blocks movement. Excels at blocking lethal projectiles."
	density = TRUE
	max_integrity = 10
	allow_walk = FALSE

/obj/structure/holosign/barrier/cyborg/bullet_act(obj/projectile/P)
	take_damage((P.damage / 5) , BRUTE, MELEE, 1)	//Doesn't really matter what damage flag it is.
	if(istype(P, /obj/projectile/energy/electrode))
		take_damage(10, BRUTE, MELEE, 1)	//Tasers aren't harmful.
	if(istype(P, /obj/projectile/beam/disabler))
		take_damage(5, BRUTE, MELEE, 1)	//Disablers aren't harmful.
	return BULLET_ACT_HIT

/obj/structure/holosign/barrier/medical
	name = "голографический барьер PENLITE"
	desc = "Барьер который блокирует проход пациентам с опасными заболеваниями. Используется для контроля эпидемий."
	icon_state = "holo_medical"
	alpha = 125 //lazy :)
	var/force_allaccess = FALSE
	var/buzzcd = 0

/obj/structure/holosign/barrier/medical/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>The biometric scanners are <b>[force_allaccess ? "off" : "on"]</b>.</span>"

/obj/structure/holosign/barrier/medical/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(force_allaccess)
		return TRUE
	if(istype(mover, /obj/vehicle/ridden))
		for(var/M in mover.buckled_mobs)
			if(ishuman(M))
				if(!CheckHuman(M))
					return FALSE
	if(ishuman(mover))
		return CheckHuman(mover)
	return TRUE

/obj/structure/holosign/barrier/medical/Bumped(atom/movable/AM)
	. = ..()
	icon_state = "holo_medical"
	if(ishuman(AM) && !CheckHuman(AM))
		if(buzzcd < world.time)
			playsound(get_turf(src),'white/valtos/sounds/error1.ogg',65,TRUE,4)
			buzzcd = (world.time + 60)
		icon_state = "holo_medical-deny"

/obj/structure/holosign/barrier/medical/proc/CheckHuman(mob/living/carbon/human/sickboi)
	var/threat = sickboi.check_virus()
	if(get_disease_severity_value(threat) > get_disease_severity_value(DISEASE_SEVERITY_MINOR))
		return FALSE
	return TRUE

/obj/structure/holosign/barrier/medical/attack_hand(mob/living/user, list/modifiers)
	if(user.a_intent != INTENT_HARM && CanPass(user, get_dir(src, user)))
		force_allaccess = !force_allaccess
		to_chat(user, span_warning("You [force_allaccess ? "deactivate" : "activate"] the biometric scanners.")) //warning spans because you can make the station sick!
	else
		return ..()

/obj/structure/holosign/barrier/cyborg/hacked
	name = "Charged Energy Field"
	desc = "A powerful energy field that blocks movement. Energy arcs off it."
	max_integrity = 20
	var/shockcd = 0

/obj/structure/holosign/barrier/cyborg/hacked/bullet_act(obj/projectile/P)
	take_damage(P.damage, BRUTE, MELEE, 1)	//Yeah no this doesn't get projectile resistance.
	return BULLET_ACT_HIT

/obj/structure/holosign/barrier/cyborg/hacked/proc/cooldown()
	shockcd = FALSE

/obj/structure/holosign/barrier/cyborg/hacked/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!shockcd)
		if(ismob(user))
			var/mob/living/M = user
			M.electrocute_act(15,"Energy Barrier")
			shockcd = TRUE
			addtimer(CALLBACK(src, PROC_REF(cooldown)), 5)

/obj/structure/holosign/barrier/cyborg/hacked/Bumped(atom/movable/AM)
	if(shockcd)
		return

	if(!ismob(AM))
		return

	var/mob/living/M = AM
	M.electrocute_act(15,"Energy Barrier")
	shockcd = TRUE
	addtimer(CALLBACK(src, PROC_REF(cooldown)), 5)

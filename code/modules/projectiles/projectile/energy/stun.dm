/obj/projectile/energy/electrode
	name = "электрод"
	icon_state = "spark"
	color = "#FFFF00"
	nodamage = FALSE
	paralyze = 100
	damage = 40
	damage_type = STAMINA
	stutter = 5
	jitter = 20
	hitsound = 'sound/weapons/taserhit.ogg'
	range = 3
	tracer_type = /obj/effect/projectile/tracer/stun
	muzzle_type = /obj/effect/projectile/muzzle/stun
	impact_type = /obj/effect/projectile/impact/stun

/obj/projectile/energy/electrode/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(!ismob(target) || blocked >= 100) //Fully blocked by mob or collided with dense object - burst into sparks!
		do_sparks(1, TRUE, src)
	else if(iscarbon(target))
		var/mob/living/carbon/C = target
		if((istype(C.gloves, /obj/item/clothing/gloves/color/yellow))&&(C.can_catch_item()))
			var/obj/item/I =  new /obj/item/ammo_casing/caseless/pissball
			C.put_in_active_hand(I)
			visible_message("<span class='warning'><b>[C]</b> ловит <b>[I.name] рукой</b>!</span>", \
							"<span class='userdanger'>Ловлю <b>[I.name] рукой</b>!</span>")
			C.throw_mode_off(THROW_MODE_TOGGLE)
			return BULLET_ACT_BLOCK

		SEND_SIGNAL(C, COMSIG_ADD_MOOD_EVENT, "tased", /datum/mood_event/tased)
		SEND_SIGNAL(C, COMSIG_LIVING_MINOR_SHOCK)
		if(C.dna && C.dna.check_mutation(HULK))
			C.say(pick(";ААААААРГХ!", ";УАААААААААХ!", ";ГРРРРРРРРРРРРРРХ!", "НЫЫЫЫЫЫЫЫЫЫАААХ!", ";РЫЫЫЫЫЫЫЫЫЫЫЫЫРХ!" ), forced = "hulk")
		else if((C.status_flags & CANKNOCKDOWN) && !HAS_TRAIT(C, TRAIT_STUNIMMUNE))
			C.emote("scream")
			addtimer(CALLBACK(C, /mob/living/carbon.proc/do_jitter_animation, jitter), 5)


/obj/projectile/energy/electrode/on_range() //to ensure the bolt sparks when it reaches the end of its range if it didn't hit a target yet
	do_sparks(1, TRUE, src)
	..()

/datum/looping_sound/effector_vaper
	start_sound = 'sound/machines/shower/shower_start.ogg'
	start_length = 2
	mid_sounds = list('sound/machines/shower/shower_mid1.ogg'=1,'sound/machines/shower/shower_mid2.ogg'=1,'sound/machines/shower/shower_mid3.ogg'=1)
	mid_length = 10
	end_sound = 'sound/machines/shower/shower_end.ogg'
	volume = 10

/obj/machinery/effector
	name = "парилка"
	desc = "Парит. Гы."
	icon = 'white/valtos/icons/effector.dmi'
	icon_state = "effector"
	var/workdir = "up"
	var/datum/looping_sound/effector_vaper/soundloop
	var/temp_cd = 30
	particles = new /particles/vaper_smoke

/obj/machinery/effector/Initialize(mapload)
	. = ..()
	soundloop = new(src, TRUE)
	soundloop.start()
	if(workdir != "up")
		particles.gravity = list(0, -1)

/obj/machinery/effector/attack_hand(mob/living/user)
	if(Adjacent(user) && user.pulling)
		if(isliving(user.pulling))
			var/mob/living/pushed_mob = user.pulling
			if(pushed_mob.buckled)
				to_chat(user, span_warning("<b>[pushed_mob]</b> прикован к <b>[pushed_mob.buckled]</b>!"))
				return
			if(user.a_intent == INTENT_GRAB)
				if(user.grab_state < GRAB_AGGRESSIVE)
					to_chat(user, span_warning("Надо бы посильнее взять!"))
					return
				if(user.grab_state >= GRAB_NECK)
					user.emote("laugh")
					pushed_mob.visible_message(span_warning("<b>[user]</b> пытается принудить <b>[pushed_mob]</b> подышать паром над <b>парилкой</b>...") , \
									span_userdanger("<b>[user]</b> пытается приставить <b>мою голову</b> к <b>парилке</b>..."))
					if(do_after(user, 35, target = pushed_mob) && temp_cd == 30)
						if(temp_cd < 30)
							return
						temp_cd = 0
						pushed_mob.Knockdown(10)
						pushed_mob.apply_damage(30, BURN, BODY_ZONE_HEAD)
						pushed_mob.apply_damage(60, STAMINA)
						pushed_mob.emote("agony")
						playsound(pushed_mob, 'sound/machines/shower/shower_mid1.ogg', 90, TRUE)
						pushed_mob.visible_message(span_danger("<b>[user]</b> принуждает <b>[pushed_mob]</b> вкусить свежий пар!") ,
									span_userdanger("<b>[user]</b> принуждает меня вкусить свежий пар!"))
						log_combat(user, pushed_mob, "head fried", null, "against <b>[src]</b>")
						SEND_SIGNAL(pushed_mob, COMSIG_ADD_MOOD_EVENT, "table", /datum/mood_event/table)
					else
						return
	return ..()

/obj/machinery/effector/Destroy()
	QDEL_NULL(soundloop)
	return ..()

/particles/vaper_smoke
	icon = 'white/valtos/icons/effector.dmi'
	icon_state = "smoke"
	width = 64
	height = 128
	count = 10
	spawning = 1
	lifespan = 10
	fade = 7
	fadein = 7
	position = generator("box", list(2,2,0), list(-2,-2,0))
	scale = generator("num", 0.5, 0.7)
	gravity = list(0, 1)

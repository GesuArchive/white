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
	layer = ABOVE_ALL_MOB_LAYER
	var/workdir = "up"
	var/datum/looping_sound/effector_vaper/soundloop
	particles = new /particles/vaper_smoke

/obj/machinery/effector/Initialize(mapload)
	. = ..()
	soundloop = new(src, TRUE)
	soundloop.start()
	if(workdir != "up")
		particles.gravity = list(0, -1)

/obj/machinery/effector/attack_hand(mob/living/user)
	if(user.pulling && user.grab_state >= GRAB_NECK && isliving(user.pulling))
		user.emote("laugh")
		var/mob/living/projarka_mob = user.pulling
		projarka_mob.visible_message(span_warning("<b>[user]</b> пытается принудить <b>[projarka_mob]</b> подышать паром над <b>парилкой</b>...") , \
						span_userdanger("<b>[user]</b> пытается приставить <b>мою голову</b> к <b>парилке</b>..."))
		if(do_after(user, 3 SECONDS, target = projarka_mob))
			projarka_mob.emote("agony")
			playsound(projarka_mob, 'sound/machines/shower/shower_mid1.ogg', 90, TRUE)
			projarka_mob.visible_message(span_danger("<b>[user]</b> принуждает <b>[projarka_mob]</b> вкусить свежий пар!") ,
						span_userdanger("<b>[user]</b> принуждает меня вкусить свежий пар!"))
			log_combat(user, projarka_mob, "head fried", null, "against <b>[src]</b>")
			SEND_SIGNAL(projarka_mob, COMSIG_ADD_MOOD_EVENT, "effector", /datum/mood_event/fried)
			projarka_mob.apply_damage(30, BURN, BODY_ZONE_HEAD)
			projarka_mob.Paralyze(60)
			user.changeNext_move(CLICK_CD_RESIST)
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

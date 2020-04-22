/area/boxplanet
	icon_state = "mining"
	has_gravity = STANDARD_GRAVITY
	flags_1 = NONE
	flora_allowed = TRUE
	blob_allowed = FALSE

/area/boxplanet/surface
	name = "Поверхность"
	outdoors = TRUE
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	icon_state = "explored"
	always_unpowered = TRUE
	poweralm = FALSE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	requires_power = TRUE
	ambientsounds = MINING

/area/boxplanet/underground
	name = "Пещеры"
	outdoors = TRUE
	always_unpowered = TRUE
	requires_power = TRUE
	poweralm = FALSE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	ambientsounds = MINING
	mob_spawn_allowed = FALSE
	megafauna_spawn_allowed = FALSE

/area/boxplanet/underground/unexplored
	icon_state = "unexplored"
	tunnel_allowed = TRUE

/area/boxplanet/underground/explored
	name = "Подземелье"
	flora_allowed = FALSE

/obj/structure/flora/tree/boxplanet
	name = "что-то"
	desc = "АААААААААААААААААААААААААААА"
	icon = 'code/shitcode/valtos/icons/mineflora.dmi'
	icon_state = null
	pixel_x = 0

/obj/structure/flora/tree/boxplanet/kartoshmel
	name = "картошмель"
	desc = "Удивительное растение, которое... Будем честны - какая-то непонятная херобора торчащая из земли и убивающая своим присутствием всех вокруг."
	icon_state = "kartoshmel"
	var/mob_type
	var/spawned_mobs = 0
	var/max_spawn = 3
	var/cooldown = 0

/obj/structure/flora/tree/boxplanet/kartoshmel/Initialize()
	mob_type = rand(1, 5)
	. = ..()

/obj/structure/flora/tree/boxplanet/kartoshmel/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/flora/tree/boxplanet/kartoshmel/process()
	if(cooldown < world.time - 480)
		cooldown = world.time
		if(max_spawn > spawned_mobs)
			spawned_mobs++
			var/turf/T = get_turf(src)
			switch(mob_type)
				if(1)
					new /mob/living/simple_animal/hostile/skeleton/vanya(T)
				if(2)
					new /mob/living/simple_animal/hostile/vanya/killermeat(T)
				if(3)
					new /mob/living/simple_animal/hostile/vanya/leech(T)
				if(4)
					new /mob/living/simple_animal/hostile/faithless/vanya/chort(T)
				if(5)
					new /mob/living/simple_animal/hostile/faithless/vanya/drown(T)
		else
			STOP_PROCESSING(SSobj, src)

/obj/structure/flora/tree/boxplanet/glikodil
	name = "гликодил"
	desc = "Целебный куст."
	icon_state = "glikodil"
	var/has_cure = TRUE

/obj/structure/flora/tree/boxplanet/glikodil/attack_hand(mob/user)
	. = ..()
	if(has_cure)
		has_cure = FALSE
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.adjustBruteLoss(-25)
			H.adjustFireLoss(-25)
			H.remove_CC()
			H.bodytemperature = H.get_body_temp_normal()
			visible_message("<span class='notice'>[H] прикасается рукой к растению и его раны начинают затягиваться.</span>")
		else
			visible_message("<span class='warning'>Похоже, что эта штука помогает только людям, но не животным. <b>[capitalize(user)]</b> поедает гликодил.</span>")
			qdel(src)
		spawn(rand(600, 3600))
			has_cure = TRUE
	else
		to_chat(user, "<span class='notice'>Не могу найти лечебных листочков на этом растении. Видимо ещё не время.</span>")

/obj/structure/flora/tree/boxplanet/svetosvin
	name = "светосвин"
	desc = "Эта штука светится. Надеешься, что это растение не радиоактивное."
	icon_state = "svetosvin"
	light_color = "#00aaff"
	light_power = 1
	light_range = 5
	var/cooldown = 0

/obj/structure/flora/tree/boxplanet/svetosvin/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/flora/tree/boxplanet/svetosvin/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/flora/tree/boxplanet/svetosvin/process()
	if(cooldown < world.time - 60)
		cooldown = world.time
		radiation_pulse(src, 25, 2)

/obj/effect/step_trigger/ambush
	mobs_only = TRUE
	var/amb_chance = 0

/obj/effect/step_trigger/ambush/Trigger(atom/A)
	if(!ishuman(A))
		return
	if(prob(amb_chance))
		amb_chance = 0
		var/mob/living/carbon/human/H = A
		var/msg = pick("ЗАСАДА!", "ЗДЕСЬ КТО-ТО ЕСТЬ!", "МОНСТРЫ!")
		visible_message("<span class='userdanger'>[msg]</span>")
		for(/obj/structure/flora/tree/boxplanet/kartoshmel/K in orange(7, src))
			K.spawned_mobs = 0
			START_PROCESSING(SSobj, K)
	else
		amb_chance += 5

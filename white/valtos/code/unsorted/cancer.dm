/mob/living/simple_animal/hostile/megafauna/sans
	name = "Санс"
	desc = "Из Undertale."
	icon = 'white/valtos/icons/undertale/SANESSS.dmi'
	icon_state = "sans"
	icon_dead = "sans"
	attack_verb_simple = "костылит"
	attack_verb_continuous = "костылит"
	attack_sound = 'white/valtos/sounds/undertale/snd_hurt1.wav'
	deathmessage = "уходит в закат."
	rapid_melee = 1
	melee_queue_distance = 2
	melee_damage_lower = 35
	melee_damage_upper = 35
	speed = 5
	move_to_delay = 5
	wander = FALSE
	var/block_chance = 50
	ranged = 1
	ranged_cooldown_time = 30
	minimum_distance = 1
	health = 2500
	maxHealth = 2500
	movement_type = GROUND
	weather_immunities = list("lava","ash")
	var/phase = 1
	var/list/introduced = list()
	var/speen = FALSE
	var/speenrange = 7
	var/obj/savedloot = null
	var/charging = FALSE
	var/chargetiles = 0
	var/chargerange = 21
	var/stunned = FALSE
	var/stunduration = 15
	var/move_to_charge = 1.5
	loot = list(/obj/item/kitchen/knife/combat/bone/sans)
	crusher_loot = list(/obj/item/kitchen/knife/combat/bone/sans)
	var/arena_cooldown = 200

/mob/living/simple_animal/hostile/megafauna/sans/Initialize(mapload)
	. = ..()
	var/datum/component/soundplayer/SP = GetComponent(/datum/component/soundplayer)
	if(!SP)
		SP = AddComponent(/datum/component/soundplayer)
		SP.active = TRUE
		SP.environmental = TRUE
		SP.playing_channel = CHANNEL_CUSTOM_JUKEBOX
	SP.playing_volume = 100
	SP.playing_range = 16
	if(prob(3))
		SP.set_sound(sound('white/valtos/sounds/undertale/SANESSS.ogg'))
	else
		SP.set_sound(sound('white/valtos/sounds/undertale/megalovania_but_beats_2_and_4_are_swapped.ogg'))

/mob/living/simple_animal/hostile/megafauna/sans/death(gibbed, list/force_grant)
	. = ..()
	animate(src, alpha = 0, 30)
	QDEL_IN(src, 30)

/mob/living/simple_animal/hostile/megafauna/sans/Life()
	. = ..()
	if(!wander)
		for(var/mob/living/M in view(4, src))
			if(!(M in introduced) && (stat != DEAD))
				introduction(M)

/mob/living/simple_animal/hostile/megafauna/sans/apply_damage(damage = 0,damagetype = BRUTE, def_zone = null, blocked = FALSE, forced = FALSE, spread_damage = FALSE, wound_bonus = 0, bare_wound_bonus = 0, sharpness = SHARP_NONE) //skyrat edit
	if(speen)
		visible_message("<span class='danger'>[capitalize(src.name)] уворачивается всех входящих атак!")
		step(src, pick(GLOB.cardinals))
		return FALSE
	else if(prob(50) && (phase == 1) && !stunned)
		visible_message("<span class='danger'>[capitalize(src.name)] отбивает все входящие атаки костями!")
		return FALSE
	..()
	update_phase()
	var/adjustment_amount = min(damage * 0.15, 15)
	if(world.time + adjustment_amount > next_move)
		changeNext_move(adjustment_amount)

/mob/living/simple_animal/hostile/megafauna/sans/proc/introduction(mob/living/target)
	if(src == target)
		introduced += src
		return
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		var/list/messages = list("Ха! Никогда не понимал, почему люди не используют в начале самую сильную атаку.",\
								"Какой чудесный на улице день: птички поют, цветочки благоухают. В такие дни дети, как ты, ДОЛЖНЫ ГОРЕТЬ В АДУ!",\
								"Давай-ка позовём всех твоих друзей на большую шумную вечеринку. Там будет пирог, и хот-доги, и... хммм... стоп... что-то не так. У тебя нет друзей.",\
								"Так что, эм, эй... Даже если мы тут внизу не сдаемся, то и ты не смей сдаваться, где бы ты ни был, окей?")
		say(message = pick(messages))
		introduced |= H

	else
		say("ХОЧЕШЬ ПЛОХОЕ ВРЕМЯ?!")
		introduced |= target

/mob/living/simple_animal/hostile/megafauna/sans/Move(atom/newloc, dir, step_x, step_y)
	if(speen || stunned)
		return FALSE
	else
		if(ischasm(newloc))
			var/list/possiblelocs = list()
			switch(dir)
				if(NORTH)
					possiblelocs += locate(x +1, y + 1, z)
					possiblelocs += locate(x -1, y + 1, z)
				if(EAST)
					possiblelocs += locate(x + 1, y + 1, z)
					possiblelocs += locate(x + 1, y - 1, z)
				if(WEST)
					possiblelocs += locate(x - 1, y + 1, z)
					possiblelocs += locate(x - 1, y - 1, z)
				if(SOUTH)
					possiblelocs += locate(x - 1, y - 1, z)
					possiblelocs += locate(x + 1, y - 1, z)
				if(SOUTHEAST)
					possiblelocs += locate(x + 1, y, z)
					possiblelocs += locate(x + 1, y + 1, z)
				if(SOUTHWEST)
					possiblelocs += locate(x - 1, y, z)
					possiblelocs += locate(x - 1, y + 1, z)
				if(NORTHWEST)
					possiblelocs += locate(x - 1, y, z)
					possiblelocs += locate(x - 1, y - 1, z)
				if(NORTHEAST)
					possiblelocs += locate(x + 1, y - 1, z)
					possiblelocs += locate(x + 1, y, z)
			for(var/turf/T in possiblelocs)
				if(ischasm(T))
					possiblelocs -= T
			if(possiblelocs.len)
				var/turf/validloc = pick(possiblelocs)
				if(charging)
					chargetiles++
					if(chargetiles >= chargerange)
						discharge()
				return ..(validloc)
			return FALSE
		else
			if(charging)
				chargetiles++
				if(chargetiles >= chargerange)
					discharge()
			..()

/mob/living/simple_animal/hostile/megafauna/sans/Bump(atom/A)
	. = ..()
	if(charging)
		if(isliving(A))
			var/mob/living/LM = A
			forceMove(LM.loc)
			visible_message("<span class='userdanger'>[capitalize(src.name)] укладывает [LM] отдохнуть!</span>")
			discharge()
		else if(istype(A, /turf/closed))
			visible_message("<span class='userdanger'>[capitalize(src.name)] впечатывает [A] в стену!</span>")
			discharge(1.33)

/mob/living/simple_animal/hostile/megafauna/sans/proc/update_phase()
	var/healthpercentage = 100 * (health/maxHealth)
	if(src.stat == DEAD)
		return
	switch(healthpercentage)
		if(75 to 100)
			phase = 1
			rapid_melee = initial(rapid_melee)
			move_to_delay = initial(move_to_delay)
			melee_damage_upper = initial(melee_damage_upper)
			melee_damage_lower = initial(melee_damage_lower)
		if(30 to 75)
			phase = 2
			rapid_melee = 2
			move_to_delay = 2
			melee_damage_upper = 30
			melee_damage_lower = 30
		if(0 to 30)
			phase = 3
			rapid_melee = 4
			melee_damage_upper = 25
			melee_damage_lower = 25
			move_to_delay = 1.7
	if(charging)
		move_to_delay = move_to_charge

/mob/living/simple_animal/hostile/megafauna/sans/proc/bonespin()
	visible_message("<span class='boldwarning'>[capitalize(src.name)] готовит мощную атаку!</span>")
	speen = TRUE
	animate(src, color = "#66ffff", 10)
	sleep(5)
	var/list/speenturfs = list()
	var/list/temp = (view(speenrange, src) - view(speenrange-1, src))
	speenturfs.len = temp.len
	var/woop = FALSE
	var/start = 0
	for(var/i in 0 to speenrange)
		speenturfs[1+i] = locate(x - i, y - speenrange, z)
		start = i
	for(var/i in 1 to (speenrange*2))
		var/turf/T = speenturfs[start]
		speenturfs[start+i] = locate(T.x, T.y + i, T.z)
		if(i == (speenrange*2))
			start = (start+i)
	for(var/i in 1 to (speenrange*2))
		var/turf/T = speenturfs[start]
		speenturfs[start+i] = locate(T.x + i, T.y, T.z)
		if(i == (speenrange*2))
			start = (start+i)
	for(var/i in 1 to (speenrange*2))
		var/turf/T = speenturfs[start]
		speenturfs[start+i] = locate(T.x, T.y - i, T.z)
		if(i == (speenrange*2))
			start = (start+i)
	for(var/i in 1 to speenrange)
		var/turf/T = speenturfs[start]
		speenturfs[start+i] = locate(T.x - i, T.y, T.z)
	var/list/hit_things = list()
	for(var/turf/T in speenturfs)
		src.dir = get_dir(src, T)
		for(var/turf/U in (getline(src, T) - get_turf(src)))
			var/obj/effect/temp_visual/bone/bonk = new /obj/effect/temp_visual/bone(U)
			QDEL_IN(bonk, 2.25)
			for(var/mob/living/M in U)
				if(!faction_check(faction, M.faction) && !(M in hit_things))
					playsound(src, 'white/valtos/sounds/undertale/snd_hurt1.wav', 75, 0)
					if(M.apply_damage(40, BRUTE, BODY_ZONE_CHEST, M.run_armor_check(BODY_ZONE_CHEST), null, null, CANT_WOUND))
						visible_message("<span class = 'userdanger'>[capitalize(src.name)] вмазывает [M] костями!</span>")
					else
						visible_message("<span class = 'userdanger'>Атака [capitalize(src.name)]а была остановлена [M]!</span>")
						woop = TRUE
					hit_things += M
		if(woop)
			break
		sleep(0.25)
	animate(src, color = initial(color), 3)
	sleep(3)
	speen = FALSE

/mob/living/simple_animal/hostile/megafauna/sans/proc/chargeattack(atom/target, var/range)
	face_atom(target)
	visible_message("<span class='boldwarning'>[capitalize(src.name)] готовится к очередной атаке!</span>")
	animate(src, color = "#66ffff", 3)
	sleep(4)
	face_atom(target)
	move_to_delay = move_to_charge
	minimum_distance = 0
	charging = TRUE

/mob/living/simple_animal/hostile/megafauna/sans/proc/discharge(var/modifier = 1)
	stunned = TRUE
	charging = FALSE
	minimum_distance = 1
	chargetiles = 0
	animate(src, color = initial(color), 7)
	update_phase()
	sleep(stunduration * modifier)
	stunned = FALSE

/mob/living/simple_animal/hostile/megafauna/sans/proc/teleport(atom/target)
	var/turf/T = get_step(target, -target.dir)
	new /obj/effect/temp_visual/bone(get_turf(src))
	playsound(src, 'white/valtos/sounds/undertale/snd_b.wav', 60, 0)
	sleep(4)
	if(!ischasm(T) && !(/mob/living in T))
		new /obj/effect/temp_visual/bone(T)
		forceMove(T)
	else
		var/list/possiblelocs = (view(3, target) - view(1, target))
		for(var/atom/A in possiblelocs)
			if(!isturf(A))
				possiblelocs -= A
			else
				if(ischasm(A) || istype(A, /turf/closed) || (/mob/living in A))
					possiblelocs -= A
		if(possiblelocs.len)
			T = pick(possiblelocs)
			new /obj/effect/temp_visual/bone(T)
			forceMove(T)

/mob/living/simple_animal/hostile/megafauna/sans/AttackingTarget()
	. = ..()
	if(speen || stunned)
		return FALSE
	if(charging)
		Bump(target)
	if(. && prob(5 * phase))
		teleport(target)

/mob/living/simple_animal/hostile/megafauna/sans/proc/boneappletea(atom/target)
	var/obj/item/kitchen/knife/combat/bone/sans/boned = new /obj/item/kitchen/knife/combat/bone/sans(get_turf(src))
	boned.throwforce = 35
	playsound(src, 'white/valtos/sounds/undertale/snd_b.wav', 60, 0)
	boned.throw_at(target, 14, 3, src)
	QDEL_IN(boned, 30)
	for(var/turf/turf in range(9, get_turf(target)))
		if(prob(22))
			new /obj/effect/temp_visual/target/sans(turf)

/mob/living/simple_animal/hostile/megafauna/sans/OpenFire()
	if(world.time < ranged_cooldown)
		return FALSE
	if(speen || stunned || charging)
		return FALSE

	arena_trap(target)

	ranged_cooldown = world.time
	switch(phase)
		if(1)
			if(prob(25) && (get_dist(src, target) <= 7))
				bonespin()
				ranged_cooldown += 70
			else
				if(prob(66))
					chargeattack(target, 21)
					ranged_cooldown += 40
				else
					boneappletea(target)
					ranged_cooldown += 35
		if(2)
			if(prob(40) && (get_dist(src, target) <= 4))
				bonespin()
				ranged_cooldown += 55
			else
				if(prob(40))
					boneappletea(target)
					ranged_cooldown += 35
				else
					teleport(target)
					ranged_cooldown += 30
		if(3)
			if(prob(35))
				boneappletea(target)
				ranged_cooldown += 30
			else
				bonespin(target)
				ranged_cooldown += 20

//Aggression helpers
/obj/effect/step_trigger/sans
	var/mob/living/simple_animal/hostile/megafauna/sans/sansy

/obj/effect/step_trigger/sans/Initialize()
	. = ..()
	for(var/mob/living/simple_animal/hostile/megafauna/sans/G in view(7, src))
		if(!sansy)
			sansy = G

/obj/effect/step_trigger/sans/Trigger(atom/movable/A)
	if(isliving(A))
		var/mob/living/bruh = A
		sansy.GiveTarget(bruh)
		for(var/obj/effect/step_trigger/sans/glad in view(7, src))
			qdel(glad)
		return TRUE
	return FALSE

/obj/item/kitchen/knife/combat/bone/sans
	name = "кость"
	icon = 'white/valtos/icons/undertale/SANESSS.dmi'
	icon_state = "bone"
	force = 40
	throwforce = 35

/obj/effect/temp_visual/bone
	icon = 'white/valtos/icons/undertale/SANESSS.dmi'
	icon_state = "bone"
	duration = 3

/obj/effect/temp_visual/bone/Initialize()
	. = ..()
	SpinAnimation(1, -1)

/obj/effect/temp_visual/bone/fromsky
	layer = FLY_LAYER
	pixel_z = 270

/obj/effect/temp_visual/bone/fromsky/Initialize()
	. = ..()
	animate(src, pixel_z = 0, time = duration)

/obj/effect/temp_visual/bone/Crossed(atom/movable/AM, oldloc)
	. = ..()
	if(isliving(AM))
		var/mob/living/L = AM
		L.adjustBruteLoss(rand(10,15))
		playsound(src, 'white/valtos/sounds/undertale/snd_hurt1.wav', 100, 0)

/mob/living/simple_animal/hostile/megafauna/sans/proc/arena_trap(mob/victim) //trap a target in an arena
	var/turf/T = get_turf(victim)
	if(!istype(victim) || victim.stat == DEAD || !T || arena_cooldown > world.time)
		return
	arena_cooldown = world.time + initial(arena_cooldown)
	for(var/t in RANGE_TURFS(11, T))
		if(t && get_dist(t, T) == 11)
			new /obj/effect/temp_visual/sansarena(t, src)
	if(get_dist(src, T) >= 11)
		INVOKE_ASYNC(src, .proc/teleport, T)

/obj/effect/temp_visual/sansarena
	name = "костяная стена"
	icon = 'white/valtos/icons/undertale/SANESSS.dmi'
	icon_state = "bone"
	duration = 100
	light_range = MINIMUM_USEFUL_LIGHT_RANGE
	var/mob/living/caster //who made this, anyway

/obj/effect/temp_visual/sansarena/Initialize(mapload, new_caster)
	. = ..()
	SpinAnimation(1, -1)
	if(new_caster)
		caster = new_caster

/obj/effect/temp_visual/hierophant/wall/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(QDELETED(caster))
		return FALSE
	if(mover == caster.pulledby)
		return
	if(istype(mover, /obj/projectile))
		var/obj/projectile/P = mover
		if(P.firer == caster)
			return
	if(mover != caster)
		return FALSE

/obj/effect/temp_visual/target/sans/fall(list/flame_hit)
	var/turf/T = get_turf(src)
	playsound(T,'white/valtos/sounds/undertale/snd_b.wav', 80, TRUE)
	new /obj/effect/temp_visual/bone/fromsky(T)
	sleep(duration)
	if(ismineralturf(T))
		var/turf/closed/mineral/M = T
		M.gets_drilled()
	playsound(T, "explosion", 30, TRUE)
	for(var/mob/living/L in T.contents)
		if(istype(L, /mob/living/simple_animal/hostile/megafauna/sans))
			continue
		L.adjustBruteLoss(10)


/obj/item/extinguisher
	name = "огнетушитель"
	desc = "Классический красный огнетушитель. Может оказаться в одном месте при неправильном обращении."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "fire_extinguisher0"
	inhand_icon_state = "fire_extinguisher"
	hitsound = 'sound/weapons/smash.ogg'
	flags_1 = CONDUCT_1
	throwforce = 10
	w_class = WEIGHT_CLASS_NORMAL
	throw_speed = 2
	throw_range = 7
	force = 12
	custom_materials = list(/datum/material/iron = 90)
	attack_verb_continuous = list("бьёт", "ударяет", "устраивает развал", "баллонит", "грейтайдит", "наносит удар")
	attack_verb_simple = list("бьёт", "ударяет", "устраивает развал", "баллонит", "грейтайдит", "наносит удар")
	dog_fashion = /datum/dog_fashion/back
	resistance_flags = FIRE_PROOF
	var/max_water = 50
	var/last_use = 1
	var/chem = /datum/reagent/water
	var/safety = TRUE
	var/refilling = FALSE
	var/tanktype = /obj/structure/reagent_dispensers/watertank
	var/sprite_name = "fire_extinguisher"
	var/power = 5 //Maximum distance launched water will travel
	var/precision = FALSE //By default, turfs picked from a spray are random, set to 1 to make it always have at least one water effect per row
	var/cooling_power = 2 //Sets the cooling_temperature of the water reagent datum inside of the extinguisher when it is refilled
	var/broken = FALSE
	var/can_explode = TRUE
	/// Icon state when inside a tank holder
	var/tank_holder_icon_state = "holder_extinguisher"

/obj/item/extinguisher/mini
	name = "карманный огнетушитель"
	desc = "Лёгкий и компактный, рамка из оптоволокна, что ещё нужно?"
	icon_state = "miniFE0"
	inhand_icon_state = "miniFE"
	hitsound = null	//it is much lighter, after all.
	flags_1 = null //doesn't CONDUCT_1
	throwforce = 2
	w_class = WEIGHT_CLASS_SMALL
	force = 3
	custom_materials = list(/datum/material/iron = 50, /datum/material/glass = 40)
	max_water = 30
	sprite_name = "miniFE"
	dog_fashion = null
	can_explode = FALSE

/obj/item/extinguisher/crafted
	name = "импровизированный охлаждающий спрей"
	desc = "Спрей, который может мощно пшикнуть."
	icon_state = "coolant0"
	inhand_icon_state = "miniFE"
	hitsound = null	//it is much lighter, after all.
	flags_1 = null //doesn't CONDUCT_1
	throwforce = 1
	w_class = WEIGHT_CLASS_SMALL
	force = 3
	custom_materials = list(/datum/material/iron = 50, /datum/material/glass = 40)
	max_water = 30
	sprite_name = "coolant"
	dog_fashion = null
	cooling_power = 1.5
	power = 3

/obj/item/extinguisher/crafted/attack_self(mob/user)
	safety = !safety
	icon_state = "[sprite_name][!safety]"
	to_chat(user, "[safety ? "Убираю трубочку и прикрепляю её к боку канистры" : "Устанавливаю трубочку в качестве дула, спрей готов к использованию"].")

/obj/item/extinguisher/proc/refill()
	if(!chem)
		return
	create_reagents(max_water, AMOUNT_VISIBLE)
	reagents.add_reagent(chem, max_water)

/obj/item/extinguisher/Initialize(mapload)
	. = ..()
	refill()

/obj/item/extinguisher/ComponentInitialize()
	. = ..()
	if(tank_holder_icon_state)
		AddComponent(/datum/component/container_item/tank_holder, tank_holder_icon_state)

/obj/item/extinguisher/advanced
	name = "продвинутый огнетушитель"
	desc = "Используется для остановки распространения термоядерных пожаров внутри двигателя."
	icon_state = "foam_extinguisher0"
	inhand_icon_state = "foam_extinguisher"
	tank_holder_icon_state = "holder_foam_extinguisher"
	dog_fashion = null
	chem = /datum/reagent/firefighting_foam
	tanktype = /obj/structure/reagent_dispensers/foamtank
	sprite_name = "foam_extinguisher"
	precision = TRUE
	can_explode = FALSE

/obj/item/extinguisher/suicide_act(mob/living/carbon/user)
	if (!safety && (reagents.total_volume >= 1))
		user.visible_message(span_suicide("[user] puts the nozzle to [user.ru_ego()] mouth. It looks like [user.p_theyre()] trying to extinguish the spark of life!"))
		afterattack(user,user)
		return OXYLOSS
	else if (safety && (reagents.total_volume >= 1))
		user.visible_message(span_warning("[user] puts the nozzle to [user.ru_ego()] mouth... The safety's still on!"))
		return SHAME
	else
		user.visible_message(span_warning("[user] puts the nozzle to [user.ru_ego()] mouth... [src] is empty!"))
		return SHAME

/obj/item/extinguisher/attack_self(mob/user)
	if(broken)
		to_chat(user, span_warning("Не хочет переключаться!"))
		return
	safety = !safety
	src.icon_state = "[sprite_name][!safety]"
	to_chat(user, "Предохранитель [safety ? "включен" : "отключен"].")
	return

/obj/item/extinguisher/attack(mob/M, mob/user)
	if(user.a_intent == INTENT_HELP && !safety) //If we're on help intent and going to spray people, don't bash them.
		return FALSE
	else
		if(prob(5) && !broken && can_explode)
			to_chat(user, span_userdanger("Огнетушитель шипит!"))
			playsound(get_turf(src), 'white/valtos/sounds/pshsh.ogg', 80, TRUE, 5)
			spawn(rand(10, 50))
				babah(user)
			broken = TRUE
			return FALSE
		return ..()

/obj/item/extinguisher/proc/babah(mob/living/H)
	var/turf/bang_turf = get_turf(src)
	if(!bang_turf)
		return

	for(var/turf/T in bang_turf.reachableAdjacentTurfs())
		if(isopenturf(T))
			var/turf/open/theturf = T
			theturf.MakeSlippery(TURF_WET_WATER, min_wet_time = 10 SECONDS, wet_time_to_add = 5 SECONDS)

	if(prob(75))
		force = 8 // как вы вообще этим бить собрались
		icon = 'white/valtos/icons/weapons/melee.dmi'
		icon_state = inhand_icon_state
		reagents.clear_reagents()
		max_water = 0
		for(var/mob/living/M in get_hearers_in_view(5, bang_turf))
			to_chat(M, span_warning("Похоже, пронесло!"))
		return

	playsound(bang_turf, 'sound/weapons/flashbang.ogg', 100, TRUE, 8, 0.9)

	new /obj/effect/dummy/lighting_obj (bang_turf, COLOR_WHITE, (5), 4, 2)

	AddComponent(/datum/component/pellet_cloud, projectile_type=/obj/projectile/bullet/pellet/shotgun_rubbershot, magnitude=5)
	// в петушителях находятся шарики для тактического вспенивания содержимого внутри (а также для использования в качестве ручной гранаты при окопных войнах)
	SEND_SIGNAL(src, COMSIG_EXTINGUISHER_BOOM)

	explosion(bang_turf, light_impact_range = 2, explosion_cause = src)

	for(var/mob/living/M in get_hearers_in_view(5, bang_turf))
		if(M.stat == DEAD)
			return
		M.show_message("<big>БАХ!</big>", MSG_AUDIBLE)
		var/distance = max(0,get_dist(get_turf(src),get_turf(M)))
		if(M.flash_act(affect_silicon = 1))
			M.Paralyze(max(20/max(1,distance), 5))
			M.Knockdown(max(200/max(1,distance), 60))
		if(!distance || loc == M || loc == M.loc)	//Stop allahu akbarring rooms with this.
			M.Paralyze(20)
			M.Knockdown(200)
			M.soundbang_act(1, 200, 10, 15)
		else
			if(distance <= 1) // Adds more stun as to not prime n' pull (#45381)
				M.Paralyze(5)
				M.Knockdown(30)
			M.soundbang_act(1, max(200/max(1,distance), 60), rand(0, 5))
	qdel(src)

/obj/item/extinguisher/attack_obj(obj/O, mob/living/user)
	if(AttemptRefill(O, user))
		refilling = TRUE
		return FALSE
	else
		if(prob(10) && !broken && can_explode)
			to_chat(user, span_userdanger("Щас ебанёт кажись..."))
			playsound(get_turf(src), 'white/valtos/sounds/pshsh.ogg', 80, TRUE, 5)
			new /obj/effect/particle_effect/fluid(get_turf(src))
			spawn(rand(10, 50))
				babah(user)
			broken = TRUE
			return FALSE
		return ..()

/obj/item/extinguisher/examine(mob/user)
	. = ..()
	. += "<hr>"
	. += "Предохранитель [safety ? "включен" : "отключен"]."

	if(reagents.total_volume)
		. += "</br><span class='notice'>ПКМ, чтобы опустошить его.</span>"

/obj/item/extinguisher/proc/AttemptRefill(atom/target, mob/user)
	if(istype(target, tanktype) && target.Adjacent(user))
		var/safety_save = safety
		safety = TRUE
		if(reagents.total_volume == reagents.maximum_volume)
			to_chat(user, span_warning("[capitalize(src.name)] уже полон!"))
			safety = safety_save
			return TRUE
		var/obj/structure/reagent_dispensers/W = target //will it work?
		var/transferred = W.reagents.trans_to(src, max_water, transfered_by = user)
		if(transferred > 0)
			to_chat(user, span_notice("[capitalize(src.name)] пополнен [transferred] единицами."))
			playsound(src.loc, 'sound/effects/refill.ogg', 50, TRUE, -6)
			for(var/datum/reagent/water/R in reagents.reagent_list)
				R.cooling_temperature = cooling_power
		else
			to_chat(user, span_warning("[capitalize(W.name)] совсем пустой!"))
		safety = safety_save
		return TRUE
	else
		return FALSE

/obj/item/extinguisher/afterattack(atom/target, mob/user , flag)
	. = ..()
	// Make it so the extinguisher doesn't spray yourself when you click your inventory items
	if (target.loc == user)
		return
	//TODO; Add support for reagents in water.

	if(refilling)
		refilling = FALSE
		return
	if (!safety)


		if (src.reagents.total_volume < 1)
			to_chat(usr, span_warning("[capitalize(src.name)] совсем пустой!"))
			return

		if (world.time < src.last_use + 12)
			return

		src.last_use = world.time

		playsound(src.loc, 'sound/effects/extinguish.ogg', 75, TRUE, -3)

		var/direction = get_dir(src,target)

		if(user.buckled && isobj(user.buckled) && !user.buckled.anchored)
			var/obj/B = user.buckled
			var/movementdirection = turn(direction,180)
			addtimer(CALLBACK(src, /obj/item/extinguisher/proc/move_chair, B, movementdirection), 1)

		else
			user.newtonian_move(turn(direction, 180))

		//Get all the turfs that can be shot at
		var/turf/T = get_turf(target)
		var/turf/T1 = get_step(T,turn(direction, 90))
		var/turf/T2 = get_step(T,turn(direction, -90))
		var/list/the_targets = list(T,T1,T2)
		if(precision)
			var/turf/T3 = get_step(T1, turn(direction, 90))
			var/turf/T4 = get_step(T2,turn(direction, -90))
			the_targets.Add(T3,T4)

		var/list/water_particles = list()
		for(var/a in 1 to 5)
			var/obj/effect/particle_effect/water/extinguisher/water = new /obj/effect/particle_effect/water/extinguisher(get_turf(src))
			var/my_target = pick(the_targets)
			water_particles[water] = my_target
			// If precise, remove turf from targets so it won't be picked more than once
			if(precision)
				the_targets -= my_target
			var/datum/reagents/water_reagents = new /datum/reagents(5)
			water.reagents = water_reagents
			water_reagents.my_atom = water
			reagents.trans_to(water, 1, transfered_by = user)

		//Make em move dat ass, hun
		move_particles(water_particles)

//Particle movement loop
/obj/item/extinguisher/proc/move_particles(list/particles)
	var/delay = 2
	// Second loop: Get all the water particles and make them move to their target
	for(var/obj/effect/particle_effect/water/extinguisher/water as anything in particles)
		water.move_at(particles[water], delay, power)

//Chair movement loop
/obj/item/extinguisher/proc/move_chair(obj/buckled_object, movementdirection)
	var/datum/move_loop/loop = SSmove_manager.move(buckled_object, movementdirection, 1, timeout = 9, flags = MOVEMENT_LOOP_START_FAST, priority = MOVEMENT_ABOVE_SPACE_PRIORITY)
	//This means the chair slowing down is dependant on the extinguisher existing, which is weird
	//Couldn't figure out a better way though
	RegisterSignal(loop, COMSIG_MOVELOOP_POSTPROCESS, PROC_REF(manage_chair_speed))

/obj/item/extinguisher/proc/manage_chair_speed(datum/move_loop/move/source)
	SIGNAL_HANDLER
	switch(source.lifetime)
		if(4 to 5)
			source.delay = 2
		if(1 to 3)
			source.delay = 3

/obj/item/extinguisher/AltClick(mob/user)
	if(!user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE, TRUE))
		return
	if(!user.is_holding(src))
		to_chat(user, span_notice("Надо бы держать в руках [src]!"))
		return
	EmptyExtinguisher(user)

/obj/item/extinguisher/proc/EmptyExtinguisher(mob/user)
	if(loc == user && reagents.total_volume)
		reagents.clear_reagents()

		var/turf/T = get_turf(loc)
		if(isopenturf(T))
			var/turf/open/theturf = T
			theturf.MakeSlippery(TURF_WET_WATER, min_wet_time = 10 SECONDS, wet_time_to_add = 5 SECONDS)

		user.visible_message(span_notice("[user] опустошает [src] используя выпускной клапан.") , span_info("Быстренько опустошаю [src] используя выпускной клапан."))

//firebot assembly
/obj/item/extinguisher/attackby(obj/O, mob/user, params)
	if(istype(O, /obj/item/bodypart/l_arm/robot) || istype(O, /obj/item/bodypart/r_arm/robot))
		to_chat(user, span_notice("Добавляю [O] к [src]."))
		qdel(O)
		qdel(src)
		user.put_in_hands(new /obj/item/bot_assembly/firebot)
	else
		..()

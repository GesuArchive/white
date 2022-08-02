/obj/item/reactive_armour_shell
	name = "реактивная броня"
	desc = "Экспериментальный образец, в ожидании установки аномального ядра."
	icon_state = "reactiveoff"
	icon = 'icons/obj/clothing/suits.dmi'
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/reactive_armour_shell/attackby(obj/item/I, mob/user, params)
	..()
	var/static/list/anomaly_armour_types = list(
		/obj/effect/anomaly/grav	                = /obj/item/clothing/suit/armor/reactive/repulse,
		/obj/effect/anomaly/flux 	           		= /obj/item/clothing/suit/armor/reactive/tesla,
		/obj/effect/anomaly/bluespace 	            = /obj/item/clothing/suit/armor/reactive/teleport,
		/obj/effect/anomaly/pyro					= /obj/item/clothing/suit/armor/reactive/fire
		)

	if(istype(I, /obj/item/assembly/signaler/anomaly))
		var/obj/item/assembly/signaler/anomaly/A = I
		var/armour_path = anomaly_armour_types[A.anomaly_type]
		if(!armour_path)
			armour_path = /obj/item/clothing/suit/armor/reactive/stealth //Lets not cheat the player if an anomaly type doesnt have its own armour coded
		to_chat(user, span_notice("Вставляю [A] в нагрудную пластину и броня, с нежным гудением, оживает."))
		new armour_path(get_turf(src))
		qdel(src)
		qdel(A)

//Reactive armor
/obj/item/clothing/suit/armor/reactive
	name = "реактивная броня"
	desc = "По какой-то причине мало что делает."
	var/active = 0
	var/reactivearmor_cooldown_duration = 0 //cooldown specific to reactive armor
	var/reactivearmor_cooldown = 0
	icon_state = "reactiveoff"
	inhand_icon_state = "reactiveoff"
	blood_overlay_type = "armor"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	actions_types = list(/datum/action/item_action/toggle)
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	hit_reaction_chance = 50
	allowed = list(/obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/flashlight, /obj/item/gun/ballistic, /obj/item/gun/energy, /obj/item/kitchen/knife/combat, /obj/item/melee/baton, /obj/item/melee/classic_baton, /obj/item/reagent_containers/spray/pepper, /obj/item/restraints/handcuffs, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman, /obj/item/storage/belt/holster/detective, /obj/item/storage/belt/holster/thermal, /obj/item/storage/belt/holster/nukie, /obj/item/tank/internals/emergency_oxygen, /obj/item/healthanalyzer, /obj/item/medbot_carrier, /obj/item/gun/syringe, /obj/item/solnce)

/obj/item/clothing/suit/armor/reactive/attack_self(mob/user)
	active = !(active)
	if(active)
		to_chat(user, span_notice("[capitalize(src.name)] сейчас включен."))
		icon_state = "reactive"
		inhand_icon_state = "reactive"
	else
		to_chat(user, span_notice("[capitalize(src.name)] сейчас выключен."))
		icon_state = "reactiveoff"
		inhand_icon_state = "reactiveoff"
	add_fingerprint(user)
	return

/obj/item/clothing/suit/armor/reactive/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	active = FALSE
	icon_state = "reactiveoff"
	inhand_icon_state = "reactiveoff"
	reactivearmor_cooldown = world.time + 200

//When the wearer gets hit, this armor will teleport the user a short distance away (to safety or to more danger, no one knows. That's the fun of it!)
/obj/item/clothing/suit/armor/reactive/teleport
	name = "реактивная телепортная броня"
	desc = "У директора исследований сорвало голову, чтобы создать это!"
	var/tele_range = 6
	var/rad_amount= 15
	reactivearmor_cooldown_duration = 100

/obj/item/clothing/suit/armor/reactive/teleport/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "атаку", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(!active)
		return FALSE
	if(prob(hit_reaction_chance))
		if(world.time < reactivearmor_cooldown)
			owner.visible_message(span_danger("Телепортная броня перезаряжается! Скачок невозможен [owner]!"))
			return FALSE
		owner.visible_message(span_danger("Сработала телепортная защита брони [owner] от [attack_text], система защиты перезаряжается!"))
		playsound(get_turf(owner),'sound/magic/blink.ogg', 100, TRUE)
		do_teleport(owner, get_turf(owner), tele_range, no_effects = TRUE, channel = TELEPORT_CHANNEL_BLUESPACE)
		owner.rad_act(rad_amount)
		reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
		return TRUE
	return FALSE

//Fire

/obj/item/clothing/suit/armor/reactive/fire
	name = "реактивная зажигательная броня"
	desc = "Экспериментальный костюм брони с массивом реактивных датчиков, прикрепленным к источнику пламени. Для стильного пиромана."

/obj/item/clothing/suit/armor/reactive/fire/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "атаку", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(!active)
		return FALSE
	if(prob(hit_reaction_chance))
		if(world.time < reactivearmor_cooldown)
			owner.visible_message(span_danger("Зажигательная броня [owner] активировалась, но заряда нехватило для работы!"))
			return
		owner.visible_message(span_danger("[capitalize(src.name)] блокировал [attack_text], рассылаются струи пламени!"))
		playsound(get_turf(owner),'sound/magic/fireball.ogg', 100, TRUE)
		for(var/mob/living/carbon/C in range(6, owner))
			if(C != owner)
				C.adjust_fire_stacks(8)
				C.ignite_mob()
		owner.set_fire_stacks(-20)
		reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
		return TRUE
	return FALSE

//Stealth

/obj/item/clothing/suit/armor/reactive/stealth
	name = "реактивная стелс броня"
	desc = "Экспериментальная броня, которая делает владельца невидимым в случае опасности и создает приманку, убегающую от носящего. Вы не можете драться с тем, чего не видите."

/obj/item/clothing/suit/armor/reactive/stealth/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "атаку", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(!active)
		return FALSE
	if(prob(hit_reaction_chance))
		if(world.time < reactivearmor_cooldown)
			owner.visible_message(span_danger("Реактивная система на [owner] включилась, но на зарядке!"))
			return
		var/mob/living/simple_animal/hostile/illusion/escape/E = new(owner.loc)
		E.Copy_Parent(owner, 50)
		E.GiveTarget(owner) //so it starts running right away
		E.Goto(owner, E.move_to_delay, E.minimum_distance)
		owner.alpha = 0
		owner.visible_message(span_danger("[owner] ударен [attack_text] в грудь!")) //We pretend to be hit, since blocking it would stop the message otherwise
		addtimer(VARSET_CALLBACK(owner, alpha, initial(owner.alpha)), 4 SECONDS)
		reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
		return TRUE

//Tesla

/obj/item/clothing/suit/armor/reactive/tesla
	name = "реактивная броня теслы"
	desc = "Экспериментальный комплект брони с чувствительными детекторами, подключенными к огромной конденсаторной сетке, из которой выступают излучатели."
	siemens_coefficient = -1
	var/zap_power = 25000
	var/zap_range = 20
	var/zap_flags = ZAP_MOB_DAMAGE | ZAP_OBJ_DAMAGE
	reactivearmor_cooldown_duration = 15 SECONDS

/obj/item/clothing/suit/armor/reactive/tesla/dropped(mob/user)
	..()
	if(istype(user))
		ADD_TRAIT(user, TRAIT_TESLA_SHOCKIMMUNE, "reactive_tesla_armor")

/obj/item/clothing/suit/armor/reactive/tesla/equipped(mob/user, slot)
	..()
	if(slot_flags & slot) //Was equipped to a valid slot for this item?
		REMOVE_TRAIT(user, TRAIT_TESLA_SHOCKIMMUNE, "reactive_tesla_armor")

/obj/item/clothing/suit/armor/reactive/tesla/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "атаку", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(!active)
		return FALSE
	if(prob(hit_reaction_chance))
		if(world.time < reactivearmor_cooldown)
			var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread
			sparks.set_up(1, 1, src)
			sparks.start()
			owner.visible_message(span_danger("Конденсаторы [owner] тесла брони перезаряжаются! Броня просто испускает искры."))
			return
		owner.visible_message(span_danger("[capitalize(src.name)] блокировала [attack_text], испуская лучи света!"))
		tesla_zap(owner, zap_range, zap_power, zap_flags)
		reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
		return TRUE

//Repulse

/obj/item/clothing/suit/armor/reactive/repulse
	name = "реактивная броня отталкивания"
	desc = "Экспериментальный образец, отталкивающий людей, которые атакуют вас."
	var/repulse_force = MOVE_FORCE_EXTREMELY_STRONG

/obj/item/clothing/suit/armor/reactive/repulse/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "атаку", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(!active)
		return FALSE
	if(prob(hit_reaction_chance))
		if(world.time < reactivearmor_cooldown)
			owner.visible_message(span_danger("The repulse generator is still recharging!"))
			return FALSE
		playsound(get_turf(owner),'sound/magic/repulse.ogg', 100, TRUE)
		owner.visible_message(span_danger("[capitalize(src.name)] блокировала [attack_text], переводя атаку в мощный силовой импульс!"))
		var/turf/T = get_turf(owner)
		var/list/thrown_items = list()
		for(var/atom/movable/A in range(T, 7))
			if(A == owner || A.anchored || thrown_items[A])
				continue
			var/throwtarget = get_edge_target_turf(T, get_dir(T, get_step_away(A, T)))
			A.safe_throw_at(throwtarget, 10, 1, force = repulse_force)
			thrown_items[A] = A

		reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
		return TRUE

/obj/item/clothing/suit/armor/reactive/table
	name = "реактивная табличная броня"
	desc = "Экспериментальный образец клоунского назначения."
	var/tele_range = 10

/obj/item/clothing/suit/armor/reactive/table/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "атаку", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(!active)
		return FALSE
	if(prob(hit_reaction_chance))
		var/mob/living/carbon/human/H = owner
		if(world.time < reactivearmor_cooldown)
			owner.visible_message(span_danger("Реактивная броня на перезарядке!"))
			return
		owner.visible_message(span_danger("Реактивная система телепортации сбрасывает [H] от [attack_text] и бросает [H.ru_na()] на созданный стол!"))
		owner.visible_message(span_boldwarning("[H] ОТПРАВЛЯЕТСЯ НА СТОЛ!!!"))
		owner.Paralyze(40)
		do_teleport(owner, get_turf(owner), tele_range, no_effects = TRUE, channel = TELEPORT_CHANNEL_BLUESPACE)
		new /obj/structure/table(get_turf(owner))
		reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
		return TRUE
	return FALSE

/obj/item/clothing/suit/armor/reactive/table/emp_act()
	return

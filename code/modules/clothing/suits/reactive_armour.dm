/obj/item/reactive_armour_shell
	name = "реактивная броня"
	desc = "Экспериментальный образец, в ожидании установки аномального ядра."
	icon_state = "reactiveoff"
	icon = 'icons/obj/clothing/suits/armor.dmi'
	w_class = WEIGHT_CLASS_BULKY

/obj/item/reactive_armour_shell/attackby(obj/item/weapon, mob/user, params)
	..()
	var/static/list/anomaly_armour_types = list(
		/obj/effect/anomaly/grav	                = /obj/item/clothing/suit/armor/reactive/repulse,
		/obj/effect/anomaly/flux 	           		= /obj/item/clothing/suit/armor/reactive/tesla,
		/obj/effect/anomaly/bluespace 	            = /obj/item/clothing/suit/armor/reactive/teleport,
		/obj/effect/anomaly/pyro					= /obj/item/clothing/suit/armor/reactive/fire,
		/obj/effect/anomaly/bioscrambler 			= /obj/item/clothing/suit/armor/reactive/bioscrambling,
		/obj/effect/anomaly/hallucination 			= /obj/item/clothing/suit/armor/reactive/hallucinating,
		/obj/effect/anomaly/dimensional				= /obj/item/clothing/suit/armor/reactive/barricade,
	)

	if(istype(weapon, /obj/item/assembly/signaler/anomaly))
		var/obj/item/assembly/signaler/anomaly/anomaly = weapon
		var/armour_path = anomaly_armour_types[anomaly.anomaly_type]
		if(!armour_path)
			armour_path = /obj/item/clothing/suit/armor/reactive/stealth //Lets not cheat the player if an anomaly type doesnt have its own armour coded
		to_chat(user, span_notice("Вставляю [weapon] в нагрудную пластину и броня, с нежным гудением, оживает."))
		new armour_path(get_turf(src))
		qdel(src)
		qdel(anomaly)

//Reactive armor
/obj/item/clothing/suit/armor/reactive
	name = "реактивная броня"
	desc = "По какой-то причине мало что делает."
	icon_state = "reactiveoff"
	inhand_icon_state = "reactiveoff"
	blood_overlay_type = "armor"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 100, ACID = 100)
	actions_types = list(/datum/action/item_action/toggle)
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	hit_reaction_chance = 50
	///Whether the armor will try to react to hits (is it on)
	var/active = FALSE
	///This will be true for 30 seconds after an EMP, it makes the reaction effect dangerous to the user.
	var/bad_effect = FALSE
	///Message sent when the armor is emp'd. It is not the message for when the emp effect goes off.
	var/emp_message = span_warning("The reactive armor has been emp'd! Damn, now it's REALLY gonna not do much!")
	///Message sent when the armor is still on cooldown, but activates.
	var/cooldown_message = span_danger("The reactive armor fails to do much, as it is recharging! From what? Only the reactive armor knows.")
	///Duration of the cooldown specific to reactive armor for when it can activate again.
	var/reactivearmor_cooldown_duration = 10 SECONDS
	///The cooldown itself of the reactive armor for when it can activate again.
	var/reactivearmor_cooldown = 0

/obj/item/clothing/suit/armor/reactive/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob, ITEM_SLOT_OCLOTHING)

/obj/item/clothing/suit/armor/reactive/update_icon_state()
	. = ..()
	if(active)
		icon_state = "reactive"
		inhand_icon_state = "reactive"
	else
		icon_state = "reactiveoff"
		inhand_icon_state = "reactiveoff"

/obj/item/clothing/suit/armor/reactive/attack_self(mob/user)
	active = !active
	to_chat(user, span_notice("[capitalize(src.name)] [active ? "включен" : "выключен"]а."))
	update_icon()
	add_fingerprint(user)

/obj/item/clothing/suit/armor/reactive/hit_reaction(owner, hitby, attack_text, final_block_chance, damage, attack_type)
	if(!active || !prob(hit_reaction_chance))
		return FALSE
	if(world.time < reactivearmor_cooldown)
		cooldown_activation(owner)
		return FALSE
	if(bad_effect)
		return emp_activation(owner, hitby, attack_text, final_block_chance, damage, attack_type)
	else
		return reactive_activation(owner, hitby, attack_text, final_block_chance, damage, attack_type)

/**
 * A proc for doing cooldown effects (like the sparks on the tesla armor, or the semi-stealth on stealth armor)
 * Called from the suit activating whilst on cooldown.
 * You should be calling ..()
 */
/obj/item/clothing/suit/armor/reactive/proc/cooldown_activation(mob/living/carbon/human/owner)
	owner.visible_message(cooldown_message)

/**
 * A proc for doing reactive armor effects.
 * Called from the suit activating while off cooldown, with no emp.
 * Returning TRUE will block атаку that triggered this
 */
/obj/item/clothing/suit/armor/reactive/proc/reactive_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "атаку", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.visible_message(span_danger("The reactive armor doesn't do much! No surprises here."))
	return TRUE

/**
 * A proc for doing owner unfriendly reactive armor effects.
 * Called from the suit activating while off cooldown, while the armor is still suffering from the effect of an EMP.
 * Returning TRUE will block атаку that triggered this
 */
/obj/item/clothing/suit/armor/reactive/proc/emp_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "атаку", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.visible_message(span_danger("The reactive armor doesn't do much, despite being emp'd! Besides giving off a special message, of course."))
	return TRUE

/obj/item/clothing/suit/armor/reactive/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF || bad_effect || !active) //didn't get hit or already emp'd, or off
		return
	visible_message(emp_message)
	bad_effect = TRUE
	addtimer(VARSET_CALLBACK(src, bad_effect, FALSE), 30 SECONDS)

//When the wearer gets hit, this armor will teleport the user a short distance away (to safety or to more danger, no one knows. That's the fun of it!)
/obj/item/clothing/suit/armor/reactive/teleport
	name = "реактивная телепортная броня"
	desc = "У директора исследований сорвало голову, чтобы создать это!"
	emp_message = span_warning("Сработала телепортная защита брони с ошибками!")
	cooldown_message = span_danger("Телепортная броня перезаряжается! Скачок невозможен!")
	reactivearmor_cooldown_duration = 10 SECONDS
	var/tele_range = 6

/obj/item/clothing/suit/armor/reactive/teleport/reactive_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "атаку", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.visible_message(span_danger("Сработала телепортная защита брони [owner] от [attack_text]!"))
	playsound(get_turf(owner),'sound/magic/blink.ogg', 100, TRUE)
	do_teleport(owner, get_turf(owner), tele_range, no_effects = TRUE, channel = TELEPORT_CHANNEL_BLUESPACE)
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

/obj/item/clothing/suit/armor/reactive/teleport/emp_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "атаку", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.visible_message(span_danger("Сработала телепортная защита брони от [attack_text], оставляя кого-то позади неё!"))
	owner.dropItemToGround(src, TRUE, TRUE)
	playsound(get_turf(owner),'sound/machines/buzz-sigh.ogg', 50, TRUE)
	playsound(get_turf(owner),'sound/magic/blink.ogg', 100, TRUE)
	do_teleport(src, get_turf(owner), tele_range, no_effects = TRUE, channel = TELEPORT_CHANNEL_BLUESPACE)
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return FALSE //you didn't actually evade атаку now did you

//Fire

/obj/item/clothing/suit/armor/reactive/fire
	name = "реактивная зажигательная броня"
	desc = "Экспериментальный костюм брони с массивом реактивных датчиков, прикрепленным к источнику пламени. Для стильного пиромана."
	cooldown_message = span_danger("Зажигательная броня активировалась, но заряда нехватило для работы!")
	emp_message = span_warning("Зажигательная броня в процессе перезарядки...")

/obj/item/clothing/suit/armor/reactive/fire/reactive_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "атаку", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.visible_message(span_danger("[capitalize(src.name)] блокирует [attack_text], выдавая потоки пламени!"))
	playsound(get_turf(owner),'sound/magic/fireball.ogg', 100, TRUE)
	for(var/mob/living/carbon/carbon_victim in range(6, get_turf(src)))
		if(carbon_victim != owner)
			carbon_victim.adjust_fire_stacks(8)
			carbon_victim.ignite_mob()
	owner.set_wet_stacks(20)
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

/obj/item/clothing/suit/armor/reactive/fire/emp_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "атаку", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.visible_message(span_danger("[capitalize(src.name)] блокирует [attack_text], но заливает огнём [owner]!"))
	playsound(get_turf(owner),'sound/magic/fireball.ogg', 100, TRUE)
	owner.adjust_fire_stacks(12)
	owner.ignite_mob()
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return FALSE

//Stealth

/obj/item/clothing/suit/armor/reactive/stealth
	name = "реактивная стелс броня"
	desc = "Экспериментальная броня, которая делает владельца невидимым в случае опасности и создает приманку, убегающую от носящего. Вы не можете драться с тем, чего не видите."
	cooldown_message = span_danger("Реактивная система включилась, но на перезарядку!")
	emp_message = span_warning("Система обнаружения угроз реактивной брони выдаёт ошибку...")
	///when triggering while on cooldown will only flicker the alpha slightly. this is how much it removes.
	var/cooldown_alpha_removal = 50
	///cooldown alpha flicker- how long it takes to return to the original alpha
	var/cooldown_animation_time = 3 SECONDS
	///how long they will be fully stealthed
	var/stealth_time = 4 SECONDS
	///how long it will animate back the alpha to the original
	var/animation_time = 2 SECONDS
	var/in_stealth = FALSE

/obj/item/clothing/suit/armor/reactive/stealth/cooldown_activation(mob/living/carbon/human/owner)
	if(in_stealth)
		return //we don't want the cooldown message either)
	owner.alpha = max(0, owner.alpha - cooldown_alpha_removal)
	animate(owner, alpha = initial(owner.alpha), time = cooldown_animation_time)
	..()

/obj/item/clothing/suit/armor/reactive/stealth/reactive_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "атаку", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	var/mob/living/simple_animal/hostile/illusion/escape/decoy = new(owner.loc)
	decoy.Copy_Parent(owner, 50)
	decoy.GiveTarget(owner) //so it starts running right away
	decoy.Goto(owner, decoy.move_to_delay, decoy.minimum_distance)
	owner.alpha = 0
	in_stealth = TRUE
	owner.visible_message(span_danger("[capitalize(attack_text)] проходит [owner] в грудь!")) //We pretend to be hit, since blocking it would stop the message otherwise
	addtimer(CALLBACK(src, PROC_REF(end_stealth), owner), stealth_time)
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

/obj/item/clothing/suit/armor/reactive/stealth/proc/end_stealth(mob/living/carbon/human/owner)
	in_stealth = FALSE
	animate(owner, alpha = initial(owner.alpha), time = animation_time)

/obj/item/clothing/suit/armor/reactive/stealth/emp_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "атаку", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(!isliving(hitby))
		return FALSE //it just doesn't activate
	var/mob/living/attacker = hitby
	owner.visible_message(span_danger("[capitalize(src.name)] активируется, но маскирует не того!"))
	attacker.alpha = 0
	addtimer(VARSET_CALLBACK(attacker, alpha, initial(attacker.alpha)), 4 SECONDS)
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return FALSE

//Tesla

/obj/item/clothing/suit/armor/reactive/tesla
	name = "реактивная броня теслы"
	desc = "Экспериментальный комплект брони с чувствительными детекторами, подключенными к огромной конденсаторной сетке, из которой выступают излучатели."
	siemens_coefficient = -1
	cooldown_message = span_danger("Конденсаторы тесла брони перезаряжаются! Броня просто испускает искры.")
	emp_message = span_warning("Кондесаторы пищат с ехидной улыбкой.")
	var/zap_power = 25000
	var/zap_range = 20
	var/zap_flags = ZAP_MOB_DAMAGE | ZAP_OBJ_DAMAGE

/obj/item/clothing/suit/armor/reactive/tesla/dropped(mob/user)
	..()
	if(istype(user))
		REMOVE_TRAIT(user, TRAIT_TESLA_SHOCKIMMUNE, "reactive_tesla_armor")

/obj/item/clothing/suit/armor/reactive/tesla/equipped(mob/user, slot)
	..()
	if(slot_flags & slot) //Was equipped to a valid slot for this item?
		ADD_TRAIT(user, TRAIT_TESLA_SHOCKIMMUNE, "reactive_tesla_armor")

/obj/item/clothing/suit/armor/reactive/tesla/cooldown_activation(mob/living/carbon/human/owner)
	var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread
	sparks.set_up(1, 1, src)
	sparks.start()
	..()

/obj/item/clothing/suit/armor/reactive/tesla/reactive_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "атаку", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.visible_message(span_danger("[capitalize(src.name)] блокирует [attack_text], выпуская мощный разряд!"))
	tesla_zap(owner, zap_range, zap_power, zap_flags)
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

/obj/item/clothing/suit/armor/reactive/tesla/emp_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "атаку", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.visible_message(span_danger("[capitalize(src.name)] блокирует [attack_text], но выпускает мощный разряд в [owner] из окружения!"))
	REMOVE_TRAIT(owner, TRAIT_TESLA_SHOCKIMMUNE, "reactive_tesla_armor") //oops! can't shock without this!
	electrocute_mob(owner, get_area(src), src, 1)
	ADD_TRAIT(owner, TRAIT_TESLA_SHOCKIMMUNE, "reactive_tesla_armor")
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

//Repulse

/obj/item/clothing/suit/armor/reactive/repulse
	name = "реактивная броня отталкивания"
	desc = "Экспериментальный образец, отталкивающий людей, которые атакуют вас."
	cooldown_message = span_danger("Генератор импульса на перезарядке! Не получится выдать достаточно сильный импульс сейчас!")
	emp_message = span_warning("Настройки генератора импульса сбрасываются...")
	var/repulse_force = MOVE_FORCE_EXTREMELY_STRONG

/obj/item/clothing/suit/armor/reactive/repulse/reactive_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "атаку", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	playsound(get_turf(owner),'sound/magic/repulse.ogg', 100, TRUE)
	owner.visible_message(span_danger("[capitalize(src.name)] блокирует [attack_text], преобразуя энергию в кинетическую силу!"))
	var/turf/owner_turf = get_turf(owner)
	var/list/thrown_items = list()
	for(var/atom/movable/repulsed in range(owner_turf, 7))
		if(repulsed == owner || repulsed.anchored || thrown_items[repulsed])
			continue
		var/throwtarget = get_edge_target_turf(owner_turf, get_dir(owner_turf, get_step_away(repulsed, owner_turf)))
		repulsed.safe_throw_at(throwtarget, 10, 1, force = repulse_force)
		thrown_items[repulsed] = repulsed

	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

/obj/item/clothing/suit/armor/reactive/repulse/emp_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "атаку", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	playsound(get_turf(owner),'sound/magic/repulse.ogg', 100, TRUE)
	owner.visible_message(span_danger("[capitalize(src.name)] НЕ блокирует [attack_text] и вместо этого генерирует притягивающую силу!"))
	var/turf/owner_turf = get_turf(owner)
	var/list/thrown_items = list()
	for(var/atom/movable/repulsed in range(owner_turf, 7))
		if(repulsed == owner || repulsed.anchored || thrown_items[repulsed])
			continue
		repulsed.safe_throw_at(owner, 10, 1, force = repulse_force)
		thrown_items[repulsed] = repulsed

	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return FALSE

/obj/item/clothing/suit/armor/reactive/table
	name = "реактивная табличная броня"
	desc = "Экспериментальный образец клоунского назначения."
	cooldown_message = span_danger("Реактивная броня на перезарядке!")
	emp_message = span_danger("Реактивная броня щёлкает странно...")
	var/tele_range = 10

/obj/item/clothing/suit/armor/reactive/table/reactive_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "атаку", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.visible_message(span_danger("Реактивная система телепортации уводит [owner] от [attack_text] и укладывает [owner.ru_ego()] прямо на стол!"))
	owner.visible_message("<font color='red' size='3'>[uppertext(owner)] ОТПРАВЛЯЕТСЯ НА СТОЛ!!!</font>")
	owner.Knockdown(30)
	owner.apply_damage(10, BRUTE)
	owner.apply_damage(40, STAMINA)
	playsound(owner, 'sound/effects/tableslam.ogg', 90, TRUE)
	SEND_SIGNAL(owner, COMSIG_ADD_MOOD_EVENT, "table", /datum/mood_event/table_limbsmash)
	do_teleport(owner, get_turf(owner), tele_range, no_effects = TRUE, channel = TELEPORT_CHANNEL_BLUESPACE)
	new /obj/structure/table(get_turf(owner))
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

/obj/item/clothing/suit/armor/reactive/table/emp_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "атаку", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.visible_message(span_danger("Реактивная система телепортации уводит [owner] от [attack_text] и укладывает [owner.ru_ego()] прямо на стеклянный стол!"))
	owner.visible_message("<font color='red' size='3'>[uppertext(owner)] ОТПРАВЛЯЕТСЯ НА СТЕКЛЯННЫЙ СТОЛ!!!</font>")
	do_teleport(owner, get_turf(owner), tele_range, no_effects = TRUE, channel = TELEPORT_CHANNEL_BLUESPACE)
	var/obj/structure/table/glass/shattering_table = new /obj/structure/table/glass(get_turf(owner))
	shattering_table.table_shatter(owner)

	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

//Hallucinating

/obj/item/clothing/suit/armor/reactive/hallucinating
	name = "реактивная псионическая броня"
	desc = "Экспериментальная броня с чувствительными детекторами, подключенными к разуму владельца. При атаке она посылает мысленные импульсы, которые вызывают вокруг него галлюцинации."
	cooldown_message = span_danger("В данный момент соединение не синхронизировано... Повторная калибровка.")
	emp_message = span_warning("Разум застилается от ответного всплеска мысленного импульса.")
	var/range = 3

/obj/item/clothing/suit/armor/reactive/hallucinating/dropped(mob/user)
	..()
	if(istype(user))
		REMOVE_TRAIT(user, TRAIT_SUPERMATTER_MADNESS_IMMUNE, "reactive_hallucinating_armor")

/obj/item/clothing/suit/armor/reactive/hallucinating/equipped(mob/user, slot)
	..()
	if(slot_flags & slot) //Was equipped to a valid slot for this item?
		ADD_TRAIT(user, TRAIT_SUPERMATTER_MADNESS_IMMUNE, "reactive_hallucinating_armor")

/obj/item/clothing/suit/armor/reactive/hallucinating/cooldown_activation(mob/living/carbon/human/owner)
	var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread
	sparks.set_up(1, 1, src)
	sparks.start()
	..()

/obj/item/clothing/suit/armor/reactive/hallucinating/reactive_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.visible_message(span_danger("[src] блокирует [attack_text], отправляя в ответ ментальный удар!"))
	for(var/mob/living/carbon/carbon_victim in range(6, get_turf(src)))
		if(carbon_victim != owner)
			carbon_victim.Knockdown(25)
	hallucination_pulse(owner)
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

/obj/item/clothing/suit/armor/reactive/hallucinating/emp_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.visible_message(span_danger("[src] блокирует [attack_text], но втягивает в [owner] огромный заряд ментальной энергии из окружающей среды!"))
	owner.hallucination += 25
	owner.hallucination = clamp(owner.hallucination, 0, 150)
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

/obj/item/clothing/suit/armor/reactive/hallucinating/proc/hallucination_pulse(mob/living/carbon/human/owner)
	var/turf/location = get_turf(owner)
	for(var/mob/living/carbon/human/near in view(location, range))
		// If they are immune to hallucinations.
		if (HAS_TRAIT(near, TRAIT_SUPERMATTER_MADNESS_IMMUNE) || (near.mind && HAS_TRAIT(near.mind, TRAIT_SUPERMATTER_MADNESS_IMMUNE)))
			continue

		// Everyone else gets hallucinations.
		var/dist = sqrt(1 / max(1, get_dist(near, location)))
		near.hallucination += 25 * dist
		near.hallucination = clamp(near.hallucination, 0, 150)

//Bioscrambling

/obj/item/clothing/suit/armor/reactive/bioscrambling
	name = "реактивная биоконверсионная броня"
	desc = "Экспериментальный бронекостюм с чувствительными детекторами, подключенными к предохранительному клапану биологической опасности. Он насильно изменяет тела окружающих при атаке."
	cooldown_message = span_danger("В данный момент соединение не синхронизировано... Повторная калибровка.")
	emp_message = span_warning("Я чувствую, как броня съеживается.")
	///Range of the effect.
	var/range = 5
	///Lists for zones and bodyparts to swap and randomize
	var/static/list/zones = list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	var/static/list/chests
	var/static/list/heads
	var/static/list/l_arms
	var/static/list/r_arms
	var/static/list/l_legs
	var/static/list/r_legs

/obj/item/clothing/suit/armor/reactive/bioscrambling/Initialize(mapload)
	. = ..()
	if(!chests)
		chests = typesof(/obj/item/bodypart/chest)
	if(!heads)
		heads = typesof(/obj/item/bodypart/head)
	if(!l_arms)
		l_arms = typesof(/obj/item/bodypart/l_arm)
	if(!r_arms)
		r_arms = typesof(/obj/item/bodypart/r_arm)
	if(!l_legs)
		l_legs = typesof(/obj/item/bodypart/l_leg)
	if(!r_legs)
		r_legs = typesof(/obj/item/bodypart/r_leg)

/obj/item/clothing/suit/armor/reactive/bioscrambling/cooldown_activation(mob/living/carbon/human/owner)
	var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread
	sparks.set_up(1, 1, src)
	sparks.start()
	..()

/obj/item/clothing/suit/armor/reactive/bioscrambling/reactive_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.visible_message(span_danger("[src] блокирует [attack_text], выпуская в ответ облако мутагенов!"))
	bioscrambler_pulse(owner, FALSE)
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

/obj/item/clothing/suit/armor/reactive/bioscrambling/emp_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.visible_message(span_danger("[src] блокирует [attack_text], но окутывает [owner] облаком мутагенов!"))
	bioscrambler_pulse(owner, TRUE)
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

/obj/item/clothing/suit/armor/reactive/bioscrambling/proc/bioscrambler_pulse(mob/living/carbon/human/owner, can_hit_owner = FALSE)
	for(var/mob/living/carbon/nearby in range(range, get_turf(src)))
		if(!can_hit_owner && nearby == owner)
			continue
		if(nearby.run_armor_check(attack_flag = BIO, absorb_text = "Броня защищает меня от [src]!") >= 100)
			continue //We are protected
		var/picked_zone = pick(zones)
		var/obj/item/bodypart/picked_user_part = nearby.get_bodypart(picked_zone)
		var/obj/item/bodypart/picked_part
		switch(picked_zone)
			if(BODY_ZONE_HEAD)
				picked_part = pick(heads)
			if(BODY_ZONE_CHEST)
				picked_part = pick(chests)
			if(BODY_ZONE_L_ARM)
				picked_part = pick(l_arms)
			if(BODY_ZONE_R_ARM)
				picked_part = pick(r_arms)
			if(BODY_ZONE_L_LEG)
				picked_part = pick(l_legs)
			if(BODY_ZONE_R_LEG)
				picked_part = pick(r_legs)
		var/obj/item/bodypart/new_part = new picked_part()
		new_part.replace_limb(nearby, TRUE)
		new_part.receive_damage(brute=10, updating_health=TRUE, wound_bonus = CANT_WOUND)
		qdel(picked_user_part)
		nearby.update_body(TRUE)
		balloon_alert(nearby, "я сегодня не такой как вчера...")

// When the wearer gets hit, this armor will push people nearby and spawn some blocking objects.
/obj/item/clothing/suit/armor/reactive/barricade
	name = "реактивная пространственная броня"
	desc = "Экспериментальная броня, которая создает препятствия для атакующих, когда обнаруживает, что ее носитель в опасности."
	emp_message = span_warning("The reactive armor's dimensional coordinates are scrambled!")
	cooldown_message = span_danger("Система реактивного барьера все еще перезаряжается! Он не активируется!")
	reactivearmor_cooldown_duration = 10 SECONDS

/obj/item/clothing/suit/armor/reactive/barricade/reactive_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "атаку", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	playsound(get_turf(owner),'sound/magic/repulse.ogg', 100, TRUE)
	owner.visible_message(span_danger("Реактивная броня помещает материю из другого мира между [src] и [attack_text]!"))
	for (var/atom/movable/target in repulse_targets(owner))
		repulse(target, owner)

	var/datum/armour_dimensional_theme/theme = new()
	theme.apply_random(get_turf(owner), dangerous = FALSE)
	qdel(theme)

	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

/**
 * Returns a list of all atoms around the source which can be moved away from it.
 *
 * Arguments
 * * source - Thing to try to move things away from.
 */
/obj/item/clothing/suit/armor/reactive/barricade/proc/repulse_targets(atom/source)
	var/list/push_targets = list()
	for (var/atom/movable/nearby_movable in view(1, source))
		if(nearby_movable == source)
			continue
		if(nearby_movable.anchored)
			continue
		push_targets += nearby_movable
	return push_targets

/**
 * Pushes something one tile away from the source.
 *
 * Arguments
 * * victim - Thing being moved.
 * * source - Thing to move it away from.
 */
/obj/item/clothing/suit/armor/reactive/barricade/proc/repulse(atom/movable/victim, atom/source)
	var/dist_from_caster = get_dist(victim, source)

	if(dist_from_caster == 0)
		return

	if (isliving(victim))
		to_chat(victim, span_userdanger("Меня отбросило назад волной искажающегося пространства!"))
	var/turf/throwtarget = get_edge_target_turf(source, get_dir(source, get_step_away(victim, source, 1)))
	victim.safe_throw_at(throwtarget, 1, 1, source, force = MOVE_FORCE_EXTREMELY_STRONG)

/obj/item/clothing/suit/armor/reactive/barricade/emp_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "атаку", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.visible_message(span_danger("Реактивная броня отводит материю из нестабильного измерения!"))
	var/datum/armour_dimensional_theme/theme = new()
	theme.apply_random(get_turf(owner), dangerous = TRUE)
	qdel(theme)
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return FALSE

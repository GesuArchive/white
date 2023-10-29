/**********************Mining drone**********************/
#define MINEDRONE_COLLECT 1
#define MINEDRONE_ATTACK 2

/mob/living/simple_animal/hostile/mining_drone
	name = "шахтерский дрон"
	desc = "Инструкция сбоку гласит: Этот маленький робот используется для поддержки шахтёров, может искать разбросанную руду или помогать уничтожать живность."
	gender = NEUTER
	icon = 'icons/mob/aibots.dmi'
	icon_state = "mining_drone"
	icon_living = "mining_drone"
	status_flags = CANSTUN|CANKNOCKDOWN|CANPUSH
	mouse_opacity = MOUSE_OPACITY_ICON
	faction = list("neutral")
	a_intent = INTENT_HARM
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	move_to_delay = 10
	health = 125
	maxHealth = 125
	melee_damage_lower = 15
	melee_damage_upper = 15
	obj_damage = 10
	environment_smash = ENVIRONMENT_SMASH_NONE
	check_friendly_fire = TRUE
	stop_automated_movement_when_pulled = TRUE
	attack_verb_continuous = "дреллирует"
	attack_verb_simple = "дреллирует"
	attack_sound = 'sound/weapons/circsawhit.ogg'
	sentience_type = SENTIENCE_MINEBOT
	speak_emote = list("констатирует")
	wanted_objects = list(
		/obj/item/stack/ore/diamond,
		/obj/item/stack/ore/gold,
		/obj/item/stack/ore/silver,
		/obj/item/stack/ore/plasma,
		/obj/item/stack/ore/uranium,
		/obj/item/stack/ore/iron,
		/obj/item/stack/ore/bananium,
		/obj/item/stack/ore/titanium
	)
	healable = 0
	loot = list(/obj/effect/decal/cleanable/robot_debris)
	del_on_death = TRUE
	light_system = MOVABLE_LIGHT
	light_range = 6
	light_on = FALSE
	var/mode = MINEDRONE_COLLECT
	var/obj/item/gun/energy/kinetic_accelerator/minebot/stored_gun

/mob/living/simple_animal/hostile/mining_drone/Initialize(mapload)
	. = ..()

	AddElement(/datum/element/footstep, FOOTSTEP_OBJ_ROBOT, 1, -6, sound_vary = TRUE)

	stored_gun = new(src)
	var/datum/action/innate/minedrone/toggle_light/toggle_light_action = new()
	toggle_light_action.Grant(src)
	var/datum/action/innate/minedrone/toggle_meson_vision/toggle_meson_vision_action = new()
	toggle_meson_vision_action.Grant(src)
	var/datum/action/innate/minedrone/toggle_mode/toggle_mode_action = new()
	toggle_mode_action.Grant(src)
	var/datum/action/innate/minedrone/dump_ore/dump_ore_action = new()
	dump_ore_action.Grant(src)
	var/obj/item/implant/radio/mining/imp = new(src)
	imp.implant(src)

	access_card = new /obj/item/card/id/advanced/gold(src)
	SSid_access.apply_trim_to_card(access_card, /datum/id_trim/job/shaft_miner)

	SetCollectBehavior()

/mob/living/simple_animal/hostile/mining_drone/Destroy()
	for (var/datum/action/innate/minedrone/action in actions)
		qdel(action)
	return ..()

/mob/living/simple_animal/hostile/mining_drone/sentience_act()
	..()
	check_friendly_fire = 0

/mob/living/simple_animal/hostile/mining_drone/examine(mob/user)
	. = ..()
	var/t_He = ru_who(TRUE)
	var/t_him = ru_na()
	var/t_ego = ru_ego()
	if(health < maxHealth)
		if(health >= maxHealth * 0.5)
			. += "<hr><span class='warning'>[t_He] выглядит немного подбитым.</span>"
		else
			. += "<hr><span class='boldwarning'>[t_He] выглядит серьёзно подбитым!</span>"
	. += {"<hr><span class='notice'>Использование нахтёрского сканнера на [t_him] проинструктирует [t_ego] сбросить руду. <b>[max(0, LAZYLEN(contents) - 1)] единиц запасённой руды</b>\n
	Починка осуществляется сваркой."}
	if(stored_gun?.max_mod_capacity)
		. += "<hr><b>[stored_gun.get_remaining_mod_capacity()]%</b> запаса модификаций."
		for(var/A in stored_gun.modkits)
			var/obj/item/borg/upgrade/modkit/M = A
			. += span_notice("\nЗдесь есть [M] внутри, использует <b>[M.cost]%</b> запаса.")

/mob/living/simple_animal/hostile/mining_drone/welder_act(mob/living/user, obj/item/I)
	..()
	. = TRUE
	if(mode == MINEDRONE_ATTACK)
		to_chat(user, span_warning("[capitalize(src.name)] должен расслабиться!"))
		return

	if(maxHealth == health)
		to_chat(user, span_info("[capitalize(src.name)] в полном порядке."))
		return

	if(I.use_tool(src, user, 0, volume=40))
		adjustBruteLoss(-15)
		to_chat(user, span_info("Чиню броню [src]."))

/mob/living/simple_animal/hostile/mining_drone/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/mining_scanner) || istype(I, /obj/item/t_scanner/adv_mining_scanner))
		to_chat(user, span_info("Настраиваю [src] на сбор руды."))
		DropOre()
		return
	if(I.tool_behaviour == TOOL_CROWBAR || istype(I, /obj/item/borg/upgrade/modkit))
		I.melee_attack_chain(user, stored_gun, params)
		return
	..()

/mob/living/simple_animal/hostile/mining_drone/death()
	DropOre(0)
	if(stored_gun)
		for(var/obj/item/borg/upgrade/modkit/M in stored_gun.modkits)
			M.uninstall(stored_gun)
	death_message = "разлетается на куски!"
	..()

/mob/living/simple_animal/hostile/mining_drone/attack_hand(mob/living/carbon/human/M)
	. = ..()
	if(.)
		return
	if(M.a_intent == INTENT_HELP)
		toggle_mode()
		switch(mode)
			if(MINEDRONE_COLLECT)
				to_chat(M, span_info("[capitalize(src.name)] теперь ищет руду."))
			if(MINEDRONE_ATTACK)
				to_chat(M, span_info("[capitalize(src.name)] теперь в режиме охоты."))
		return

/mob/living/simple_animal/hostile/mining_drone/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(istype(mover, /obj/projectile/kinetic))
		var/obj/projectile/kinetic/projectile = mover
		if(projectile.kinetic_gun)
			if (locate(/obj/item/borg/upgrade/modkit/minebot_passthrough) in projectile.kinetic_gun.modkits)
				return TRUE
	else if(istype(mover, /obj/projectile/destabilizer))
		return TRUE

/mob/living/simple_animal/hostile/mining_drone/proc/SetCollectBehavior()
	mode = MINEDRONE_COLLECT
	vision_range = 9
	search_objects = 2
	wander = TRUE
	ranged = FALSE
	minimum_distance = 1
	retreat_distance = null
	icon_state = "mining_drone"
	to_chat(src, span_info("Мне нужно собирать руду."))

/mob/living/simple_animal/hostile/mining_drone/proc/SetOffenseBehavior()
	mode = MINEDRONE_ATTACK
	vision_range = 7
	search_objects = 0
	wander = FALSE
	ranged = TRUE
	retreat_distance = 2
	minimum_distance = 1
	icon_state = "mining_drone_offense"
	to_chat(src, span_info("Мне нужно стрелять в монстров."))

/mob/living/simple_animal/hostile/mining_drone/AttackingTarget()
	if(istype(target, /obj/item/stack/ore) && mode == MINEDRONE_COLLECT)
		CollectOre()
		return
	if(isliving(target))
		SetOffenseBehavior()
	return ..()

/mob/living/simple_animal/hostile/mining_drone/OpenFire(atom/A)
	if(CheckFriendlyFire(A))
		return
	stored_gun.afterattack(A, src) //of the possible options to allow minebots to have KA mods, would you believe this is the best?

/mob/living/simple_animal/hostile/mining_drone/proc/CollectOre()
	for(var/obj/item/stack/ore/O in range(1, src))
		O.forceMove(src)

/mob/living/simple_animal/hostile/mining_drone/proc/DropOre(message = 1)
	if(!contents.len)
		if(message)
			to_chat(src, span_warning("Пытаюсь сбросить руду, но её нет!"))
		return
	if(message)
		to_chat(src, span_notice("Сбрасываю руду."))
	for(var/obj/item/stack/ore/O in contents)
		O.forceMove(drop_location())

/mob/living/simple_animal/hostile/mining_drone/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	if(mode != MINEDRONE_ATTACK && amount > 0)
		SetOffenseBehavior()
	. = ..()

/datum/action/innate/minedrone/toggle_meson_vision
	name = "Мезонное зрение"
	button_icon_state = "meson"

/datum/action/innate/minedrone/toggle_meson_vision/Activate()
	var/mob/living/simple_animal/hostile/mining_drone/user = owner
	if(user.sight & SEE_TURFS)
		user.clear_sight(SEE_TURFS)
		user.lighting_alpha = initial(user.lighting_alpha)
	else
		user.add_sight(SEE_TURFS)
		user.lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE

	user.sync_lighting_plane_alpha()

	to_chat(user, span_notice("Переключаю мезонки в состояние [(user.sight & SEE_TURFS) ? "вкл" : "выкл"]."))


/mob/living/simple_animal/hostile/mining_drone/proc/toggle_mode()
	switch(mode)
		if(MINEDRONE_ATTACK)
			SetCollectBehavior()
		else
			SetOffenseBehavior()

//Actions for sentient minebots

/datum/action/innate/minedrone
	check_flags = AB_CHECK_CONSCIOUS
	button_icon = 'icons/mob/actions/actions_mecha.dmi'
	background_icon_state = "bg_default"
	overlay_icon_state = "bg_default_border"

/datum/action/innate/minedrone/toggle_light
	name = "Переключить свет"
	button_icon_state = "mech_lights_off"


/datum/action/innate/minedrone/toggle_light/Activate()
	var/mob/living/simple_animal/hostile/mining_drone/user = owner
	user.set_light_on(!user.light_on)
	to_chat(user, span_notice("Переключаю свет в состояние [user.light_on ? "вкл" : "выкл"]."))


/datum/action/innate/minedrone/toggle_mode
	name = "Переключить режим"
	button_icon_state = "mech_cycle_equip_off"

/datum/action/innate/minedrone/toggle_mode/Activate()
	var/mob/living/simple_animal/hostile/mining_drone/user = owner
	user.toggle_mode()

/datum/action/innate/minedrone/dump_ore
	name = "Сбросить руду"
	button_icon_state = "mech_eject"

/datum/action/innate/minedrone/dump_ore/Activate()
	var/mob/living/simple_animal/hostile/mining_drone/user = owner
	user.DropOre()


/**********************Minebot Upgrades**********************/

//Melee

/obj/item/mine_bot_upgrade
	name = "дрон: Улучшение ближнего боя"
	desc = "Улучшение шахтерского дрона."
	icon_state = "door_electronics"
	icon = 'icons/obj/module.dmi'

/obj/item/mine_bot_upgrade/afterattack(mob/living/simple_animal/hostile/mining_drone/M, mob/user, proximity)
	. = ..()
	if(!istype(M) || !proximity)
		return
	upgrade_bot(M, user)

/obj/item/mine_bot_upgrade/proc/upgrade_bot(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	if(M.melee_damage_upper != initial(M.melee_damage_upper))
		to_chat(user, span_warning("[capitalize(src.name)] уже получил улучшение ближнего боя!"))
		return
	M.melee_damage_lower += 7
	M.melee_damage_upper += 7
	qdel(src)

//Health

/obj/item/mine_bot_upgrade/health
	name = "дрон: Улучшение здоровья"

/obj/item/mine_bot_upgrade/health/upgrade_bot(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	if(M.maxHealth != initial(M.maxHealth))
		to_chat(user, span_warning("[capitalize(src.name)] уже получил улучшение здоровья!"))
		return
	M.maxHealth += 45
	M.updatehealth()
	qdel(src)

//AI

/obj/item/slimepotion/slime/sentience/mining
	name = "дрон: Улучшение ИИ"
	desc = "Может использоваться для наделения шахтерских дронов разумом. Несовместим с улучшениями здоровья и ближнего боя и отменяет их."
	icon_state = "door_electronics"
	icon = 'icons/obj/module.dmi'
	sentience_type = SENTIENCE_MINEBOT
	var/base_health_add = 5 //sentient minebots are penalized for beign sentient; they have their stats reset to normal plus these values
	var/base_damage_add = 1 //this thus disables other minebot upgrades
	var/base_speed_add = 1
	var/base_cooldown_add = 10 //base cooldown isn't reset to normal, it's just added on, since it's not practical to disable the cooldown module

/obj/item/slimepotion/slime/sentience/mining/after_success(mob/living/user, mob/living/simple_animal/SM)
	if(istype(SM, /mob/living/simple_animal/hostile/mining_drone))
		var/mob/living/simple_animal/hostile/mining_drone/M = SM
		M.maxHealth = initial(M.maxHealth) + base_health_add
		M.melee_damage_lower = initial(M.melee_damage_lower) + base_damage_add
		M.melee_damage_upper = initial(M.melee_damage_upper) + base_damage_add
		M.move_to_delay = initial(M.move_to_delay) + base_speed_add
		if(M.stored_gun)
			M.stored_gun.overheat_time += base_cooldown_add

#undef MINEDRONE_COLLECT
#undef MINEDRONE_ATTACK

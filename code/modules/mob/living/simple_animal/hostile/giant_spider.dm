#define INTERACTION_SPIDER_KEY "spider_key"

/**
 * # Poison Hostile Simplemob
 *
 * A subtype of the hostile simplemob which injects reagents into its target on attack, assuming the target accepts reagents.
 */
/mob/living/simple_animal/hostile/poison
	///How much of a reagent the mob injects on attack
	var/poison_per_bite = 5
	///What reagent the mob injects targets with
	var/poison_type = /datum/reagent/toxin

/mob/living/simple_animal/hostile/poison/AttackingTarget()
	. = ..()
	if(.)
		inject_poison(target)

/**
 * Injects poison into a given target.
 *
 * Checks if a given target accepts reagents, and then injects a given reagent into them if so.
 * Arguments:
 * * living_target - The targeted mob
 */
/mob/living/simple_animal/hostile/poison/proc/inject_poison(mob/living/living_target)
	if(poison_per_bite != 0 && living_target?.reagents)
		living_target.reagents.add_reagent(poison_type, poison_per_bite)

/**
 * # Giant Spider
 *
 * A versatile mob which can occur from a variety of sources.
 *
 * A mob which can be created by botany or xenobiology.  The basic type is the guard, which is slower but sturdy and outputs good damage.
 * All spiders can produce webbing.  Currently does not inject toxin into its target.
 */
/mob/living/simple_animal/hostile/giant_spider
	name = "огромный паук"
	desc = "Черный и пушистый, с огромными хелицерами и красными светящимися глазами, что то в нем заставляет испытывать первобытный страх."
	icon_state = "guard"
	icon_living = "guard"
	icon_dead = "guard_dead"
	mob_biotypes = MOB_ORGANIC|MOB_BUG
	speak_emote = list("трепещет")
	emote_hear = list("трепещет")
	speak_chance = 5
	speed = 0
	turns_per_move = 5
	butcher_results = list(/obj/item/food/meat/slab/spider = 2, /obj/item/food/spiderleg = 8)
	response_help_continuous = "гладит"
	response_help_simple = "гладит"
	response_disarm_continuous = "аккуратно отталкивает"
	response_disarm_simple = "аккуратно отталкивает"
	initial_language_holder = /datum/language_holder/spider
	maxHealth = 80
	health = 80
	damage_coeff = list(BRUTE = 1, BURN = 1.25, TOX = 1, CLONE = 1, STAMINA = 1, OXY = 1)
	unsuitable_cold_damage = 8
	unsuitable_heat_damage = 8
	obj_damage = 30
	melee_damage_lower = 20
	melee_damage_upper = 25
	a_intent = INTENT_HARM
	faction = list("spiders")
	pass_flags = PASSTABLE
	move_to_delay = 6
	attack_verb_continuous = "кусает"
	attack_verb_simple = "кусает"
	attack_sound = 'sound/weapons/bite.ogg'
	attack_vis_effect = ATTACK_EFFECT_BITE
	unique_name = 1
	gold_core_spawnable = HOSTILE_SPAWN
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	see_in_dark = NIGHTVISION_FOV_RANGE
	footstep_type = FOOTSTEP_MOB_CLAW
	///How much of a reagent the mob injects on attack
	var/poison_per_bite = 0
	///What reagent the mob injects targets with
	var/poison_type = /datum/reagent/toxin
	///How quickly the spider can place down webbing.  One is base speed, larger numbers are slower.
	var/web_speed = 1
	///Whether or not the spider can create sealed webs.
	var/web_sealer = FALSE
	///The message that the mother spider left for this spider when the egg was layed.
	var/directive = ""
	/// Short description of what this mob is capable of, for radial menu uses
	var/menu_description = "Versatile spider variant for frontline combat with high health and damage."
	discovery_points = 1000

/mob/living/simple_animal/hostile/giant_spider/Initialize(mapload)
	. = ..()
	var/datum/action/innate/spider/lay_web/webbing = new(src)
	webbing.Grant(src)

	if(poison_per_bite)
		AddElement(/datum/element/venomous, poison_type, poison_per_bite)
	AddElement(/datum/element/nerfed_pulling, GLOB.typecache_general_bad_things_to_easily_move)
	AddElement(/datum/element/prevent_attacking_of_types, GLOB.typecache_general_bad_hostile_attack_targets, "Мерзость! Оно плохо пахнет! Нехочу это есть или трогать!")

/mob/living/simple_animal/hostile/giant_spider/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	if(directive)
		to_chat(src, span_spider("Королева отдала приказ! Его необходимо выполнить любой ценой!"))
		to_chat(src, span_spider("<b>[directive]</b>"))
		if(mind)
			mind.store_memory(span_spider("<b>[directive]</b>"))
	GLOB.spidermobs[src] = TRUE

/mob/living/simple_animal/hostile/giant_spider/Destroy()
	GLOB.spidermobs -= src
	return ..()

/mob/living/simple_animal/hostile/giant_spider/handle_temperature_damage()
	if(bodytemperature < minbodytemp)
		adjustBruteLoss(20)
		throw_alert("temp", /atom/movable/screen/alert/cold, 3)
	else if(bodytemperature > maxbodytemp)
		adjustBruteLoss(20)
		throw_alert("temp", /atom/movable/screen/alert/hot, 3)
	else
		clear_alert("temp")

/**
 * # Spider Hunter
 *
 * A subtype of the giant spider with purple eyes and toxin injection.
 *
 * A subtype of the giant spider which is faster, has toxin injection, but less health.  This spider is only slightly slower than a human.
 */
/mob/living/simple_animal/hostile/giant_spider/hunter
	name = "паук охотник"
	desc = "Самый распространный вид космических пауков, это быстрый и весьма ядовитый паразит с фиолетовыми глазами."
	icon_state = "hunter"
	icon_living = "hunter"
	icon_dead = "hunter_dead"
	maxHealth = 50
	health = 50
	melee_damage_lower = 15
	melee_damage_upper = 20
	poison_per_bite = 5
	move_to_delay = 5
	speed = -0.1

/**
 * # Spider Nurse
 *
 * A subtype of the giant spider with green eyes that specializes in support.
 *
 * A subtype of the giant spider which specializes in support skills.  Nurses can place down webbing in a quarter of the time
 * that other species can and can wrap other spiders' wounds, healing them.  Note that it cannot heal itself.
 */
/mob/living/simple_animal/hostile/giant_spider/nurse
	name = "паучья фрейлина"
	desc = "Этих экземпляров редко можно увидеть вне гнезда, а в бою они обычно держатся позади, однако убивать их нужно в первую очередь, ведь именно они откладывают яйца и выхаживают раненых бойцов."
	icon_state = "nurse"
	icon_living = "nurse"
	icon_dead = "nurse_dead"
	gender = FEMALE
	butcher_results = list(/obj/item/food/meat/slab/spider = 2, /obj/item/food/spiderleg = 8, /obj/item/food/spidereggs = 4)
	maxHealth = 40
	health = 40
	melee_damage_lower = 5
	melee_damage_upper = 10
	poison_per_bite = 3
	web_speed = 0.25
	///The health HUD applied to the mob.
	var/health_hud = DATA_HUD_MEDICAL_ADVANCED

/mob/living/simple_animal/hostile/giant_spider/nurse/Initialize(mapload)
	. = ..()
	var/datum/atom_hud/datahud = GLOB.huds[health_hud]
	datahud.show_to(src)

/mob/living/simple_animal/hostile/giant_spider/nurse/AttackingTarget()
	if(DOING_INTERACTION(src, INTERACTION_SPIDER_KEY))
		return
	if(!istype(target, /mob/living/simple_animal/hostile/giant_spider))
		return ..()
	var/mob/living/simple_animal/hostile/giant_spider/hurt_spider = target
	if(hurt_spider == src)
		to_chat(src, span_warning("Не получается извернуться и дотянутся до своих собственных ран."))
		return
	if(hurt_spider.health >= hurt_spider.maxHealth)
		to_chat(src, span_warning("Этот собрат цел."))
		return
	visible_message(span_notice("[src] начинает залатывать раны [hurt_spider].") ,span_notice("Начинаю залатывать раны [hurt_spider]."))

	if(!do_after(src, 2 SECONDS, target = hurt_spider, interaction_key = INTERACTION_SPIDER_KEY))
		return

	hurt_spider.heal_overall_damage(20, 20)
	new /obj/effect/temp_visual/heal(get_turf(hurt_spider), "#80F5FF")
	visible_message(span_notice("[src] залатала раны [hurt_spider].") ,span_notice("Залатываю раны [hurt_spider]."))

/**
 * # Tarantula
 *
 * The tank of spider subtypes.  Is incredibly slow when not on webbing, but has a lunge and the highest health and damage of any spider type.
 *
 * A subtype of the giant spider which specializes in pure strength and staying power.  Is slowed down greatly when not on webbing, but can lunge
 * to throw off attackers and possibly to stun them, allowing the tarantula to net an easy kill.
 */
/mob/living/simple_animal/hostile/giant_spider/tarantula
	name = "тарантул"
	desc = "Огромный даже для космического паука, невероятно сильный и живучий. Чаще всего их можно обнаружить на страже крупных гнезд, за их границами они чувствуют себя некомфортно."
	icon_state = "tarantula"
	icon_living = "tarantula"
	icon_dead = "tarantula_dead"
	maxHealth = 300 // woah nelly
	health = 300
	melee_damage_lower = 35
	melee_damage_upper = 40
	obj_damage = 100
	damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 1, CLONE = 1, STAMINA = 0, OXY = 1)
	poison_per_bite = 0
	move_to_delay = 8
	speed = 1
	status_flags = NONE
	mob_size = MOB_SIZE_LARGE
	gold_core_spawnable = NO_SPAWN
	///Whether or not the tarantula is currently walking on webbing.
	var/silk_walking = TRUE
	/// Charging ability
	var/datum/action/cooldown/mob_cooldown/charge/basic_charge/charge

/mob/living/simple_animal/hostile/giant_spider/tarantula/Initialize(mapload)
	. = ..()
	charge = new /datum/action/cooldown/mob_cooldown/charge/basic_charge()
	charge.Grant(src)

/mob/living/simple_animal/hostile/giant_spider/tarantula/Destroy()
	QDEL_NULL(charge)
	return ..()

/mob/living/simple_animal/hostile/giant_spider/tarantula/OpenFire()
	if(client)
		return
	charge.Trigger(target = target)

/mob/living/simple_animal/hostile/giant_spider/tarantula/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	. = ..()
	var/obj/structure/spider/stickyweb/web = locate() in loc
	if(web && !silk_walking)
		remove_movespeed_modifier(/datum/movespeed_modifier/tarantula_web)
		silk_walking = TRUE
	else if(!web && silk_walking)
		add_movespeed_modifier(/datum/movespeed_modifier/tarantula_web)
		silk_walking = FALSE

/**
 * # Spider Viper
 *
 * The assassin of spider subtypes.  Essentially a juiced up version of the hunter.
 *
 * A subtype of the giant spider which specializes in speed and poison.  Injects a deadlier toxin than other spiders, moves extremely fast,
 * but like the hunter has a limited amount of health.
 */
/mob/living/simple_animal/hostile/giant_spider/viper
	name = "черная вдова"
	desc = "Крайне быстрая и ядовитая тварь с очень опасным токсином, слава богам встречается довольно редко."
	icon_state = "viper"
	icon_living = "viper"
	icon_dead = "viper_dead"
	maxHealth = 40
	health = 40
	melee_damage_lower = 5
	melee_damage_upper = 5
	poison_per_bite = 5
	move_to_delay = 4
	poison_type = /datum/reagent/toxin/venom
	speed = -0.5
	gold_core_spawnable = NO_SPAWN

/**
 * # Spider Broodmother
 *
 * The reproductive line of spider subtypes.  Is the only subtype to lay eggs, which is the only way for spiders to reproduce.
 *
 * A subtype of the giant spider which is the crux of a spider horde.  Can lay normal eggs at any time which become normal spider types,
 * but by consuming human bodies can lay special eggs which can become one of the more specialized subtypes, including possibly another broodmother.
 * However, this spider subtype has no offensive capability and can be quickly dispatched without assistance from other spiders.  They are also capable
 * of sending messages to all living spiders, being a communication line for the rest of the horde.
 */
/mob/living/simple_animal/hostile/giant_spider/midwife
	name = "королева роя"
	desc = "Редчайшая особь с зачатками интеллекта и псионическими способностями позволяющими ей контролировать других пауков, как правило королеву можно найти только в очень крупных гнездах, но даже одна особь может погубить станцию."
	gender = FEMALE
	icon_state = "midwife"
	icon_living = "midwife"
	icon_dead = "midwife_dead"
	maxHealth = 40
	health = 40
	melee_damage_lower = 5
	melee_damage_upper = 10
	poison_per_bite = 3
	gold_core_spawnable = NO_SPAWN
	web_sealer = TRUE

/mob/living/simple_animal/hostile/giant_spider/midwife/Initialize(mapload)
	. = ..()
	var/datum/action/cooldown/wrap/wrapping = new(src)
	wrapping.Grant(src)

	var/datum/action/innate/spider/lay_eggs/make_eggs = new(src)
	make_eggs.Grant(src)

	var/datum/action/innate/spider/lay_eggs/enriched/make_better_eggs = new(src)
	make_better_eggs.Grant(src)

	var/datum/action/innate/spider/set_directive/give_orders = new(src)
	give_orders.Grant(src)

	var/datum/action/innate/spider/comm/not_hivemind_talk = new(src)
	not_hivemind_talk.Grant(src)

/datum/action/innate/spider
	button_icon = 'icons/mob/actions/actions_animal.dmi'
	background_icon_state = "bg_alien"
	overlay_icon_state = "bg_alien_border"

/datum/action/innate/spider/lay_web
	name = "Сплести паутину"
	desc = "Хорошее средство для защиты гнезда, замедляет потенциальных недоброжелателей и не препятствует движению пауков."
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "lay_web"

/datum/action/innate/spider/lay_web/IsAvailable(feedback = FALSE)
	. = ..()
	if(!.)
		return FALSE

	if(DOING_INTERACTION(owner, INTERACTION_SPIDER_KEY))
		return FALSE
	if(!isspider(owner))
		return FALSE

	var/mob/living/simple_animal/hostile/giant_spider/spider = owner
	var/obj/structure/spider/stickyweb/web = locate() in get_turf(spider)
	if(web && (!spider.web_sealer || istype(web, /obj/structure/spider/stickyweb/sealed)))
		to_chat(spider, span_warning("Тут уже есть паутина!"))
		return FALSE

	if(!isturf(spider.loc))
		return FALSE

	return TRUE

/datum/action/innate/spider/lay_web/Activate()
	var/turf/spider_turf = get_turf(owner)
	var/mob/living/simple_animal/hostile/giant_spider/spider = owner
	var/obj/structure/spider/stickyweb/web = locate() in spider_turf
	if(web)
		spider.visible_message(
			span_notice("[spider] начинает выделять липкую субстанцию."),
			span_notice("Начинаю плести паутину."),
		)
	else
		spider.visible_message(
			span_notice("[spider] начинает выделять липкую субстанцию."),
			span_notice("Начинаю плести паутину."),
		)

	spider.stop_automated_movement = TRUE

	if(do_after(spider, 4 SECONDS * spider.web_speed, target = spider_turf))
		if(spider.loc == spider_turf)
			if(web)
				qdel(web)
				new /obj/structure/spider/stickyweb/sealed(spider_turf)
			new /obj/structure/spider/stickyweb(spider_turf)

	spider.stop_automated_movement = FALSE

/datum/action/cooldown/wrap
	name = "Опутать"
	desc = "Позволяет оплести жертву паутиной и тем самым подготовить ее в качестве пищи для паучат гвардейцев."
	background_icon_state = "bg_alien"
	overlay_icon_state = "bg_alien_border"
	button_icon = 'icons/mob/actions/actions_animal.dmi'
	button_icon_state = "wrap_0"
	check_flags = AB_CHECK_CONSCIOUS
	click_to_activate = TRUE
	ranged_mousepointer = 'icons/effects/mouse_pointers/wrap_target.dmi'
	/// The time it takes to wrap something.
	var/wrap_time = 5 SECONDS

/datum/action/cooldown/wrap/IsAvailable(feedback = FALSE)
	. = ..()
	if(!.)
		return FALSE
	if(owner.incapacitated())
		return FALSE
	if(DOING_INTERACTION(owner, INTERACTION_SPIDER_KEY))
		return FALSE
	return TRUE

/datum/action/cooldown/wrap/set_click_ability(mob/on_who)
	. = ..()
	if(!.)
		return

	to_chat(on_who, span_notice("Подготавливаю паутиновые железы. <B>Left-click your target to start wrapping!</B>"))
	button_icon_state = "wrap_0"
	build_all_button_icons()

/datum/action/cooldown/wrap/unset_click_ability(mob/on_who, refund_cooldown = TRUE)
	. = ..()
	if(!.)
		return

	if(refund_cooldown)
		to_chat(on_who, span_notice("Скрываю паутиновые железы."))
	button_icon_state = "wrap_1"
	build_all_button_icons()

/datum/action/cooldown/wrap/Activate(atom/to_wrap)
	if(!owner.Adjacent(to_wrap))
		owner.balloon_alert(owner, "надо быть ближе!")
		return FALSE

	if(!ismob(to_wrap) && !isobj(to_wrap))
		return FALSE

	if(to_wrap == owner)
		return FALSE

	if(isspider(to_wrap))
		owner.balloon_alert(owner, "своих то зачем?!")
		return FALSE

	var/atom/movable/target_movable = to_wrap
	if(target_movable.anchored)
		return FALSE

	StartCooldown(wrap_time)
	INVOKE_ASYNC(src, PROC_REF(cocoon), to_wrap)
	return TRUE

/datum/action/cooldown/wrap/proc/cocoon(atom/movable/to_wrap)
	owner.visible_message(
		span_notice("[owner] начинает оборачивать [to_wrap] паутиной."),
		span_notice("Начинаю заворачивать [to_wrap] в кокон."),
	)

	var/mob/living/simple_animal/animal_owner = owner
	if(istype(animal_owner))
		animal_owner.stop_automated_movement = TRUE

	if(do_after(owner, wrap_time, target = to_wrap, interaction_key = INTERACTION_SPIDER_KEY))
		var/obj/structure/spider/cocoon/casing = new(to_wrap.loc)
		if(isliving(to_wrap))
			var/mob/living/living_wrapped = to_wrap
			// if they're not dead, you can consume them anyway
			if(ishuman(living_wrapped) && (living_wrapped.stat != DEAD || !HAS_TRAIT(living_wrapped, TRAIT_SPIDER_CONSUMED)))
				var/datum/action/innate/spider/lay_eggs/enriched/egg_power = locate() in owner.actions
				if(egg_power)
					egg_power.charges++
					egg_power.build_all_button_icons()
					owner.visible_message(
						span_danger("[owner] втыкает хоботок в [living_wrapped] и высасывает всякое из него."),
						span_notice("Сосу вкусняху из [living_wrapped], теперь можно произвести более сильное потомство."),
					)

				living_wrapped.death() //you just ate them, they're dead.
			else
				to_chat(owner, span_warning("[living_wrapped] не сможет удовлетворить мой голод!"))

		to_wrap.forceMove(casing)
		if(to_wrap.density || ismob(to_wrap))
			casing.icon_state = pick("cocoon_large1", "cocoon_large2", "cocoon_large3")

	if(istype(animal_owner))
		animal_owner.stop_automated_movement = TRUE

/datum/action/innate/spider/lay_eggs
	name = "Отложить паучью кладку"
	desc = "Откладывает яйца, из которых вскоре вылупятся обычные паучата."
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "lay_eggs"
	///How long it takes for a broodmother to lay eggs.
	var/egg_lay_time = 15 SECONDS
	///The type of egg we create
	var/egg_type = /obj/effect/mob_spawn/spider

/datum/action/innate/spider/lay_eggs/IsAvailable(feedback = FALSE)
	. = ..()
	if(!.)
		return FALSE

	if(!isspider(owner))
		return FALSE
	var/obj/structure/spider/eggcluster/eggs = locate() in get_turf(owner)
	if(eggs)
		to_chat(owner, span_warning("Это место уже занято!"))
		return FALSE
	if(DOING_INTERACTION(owner, INTERACTION_SPIDER_KEY))
		return FALSE

	return TRUE

/datum/action/innate/spider/lay_eggs/Activate()

	owner.visible_message(
		span_notice("[owner] начинает откладывать яйца."),
		span_notice("Начинаю откладывать яйца."),
	)

	var/mob/living/simple_animal/hostile/giant_spider/spider = owner
	spider.stop_automated_movement = TRUE

	if(do_after(owner, egg_lay_time, target = get_turf(owner), interaction_key = INTERACTION_SPIDER_KEY))
		var/obj/structure/spider/eggcluster/eggs = locate() in get_turf(owner)
		if(!eggs || !isturf(spider.loc))
			var/obj/effect/mob_spawn/spider/new_eggs = new egg_type(get_turf(spider))
			new_eggs.directive = spider.directive
			new_eggs.faction = spider.faction
			build_all_button_icons(UPDATE_BUTTON_STATUS)

	spider.stop_automated_movement = FALSE

/datum/action/innate/spider/lay_eggs/enriched
	name = "Отложить гвардейскую кладку"
	desc = "Откладывает яйца, из которых вскоре вылупятся редкие элитные паучата. Требует по соседству кокон с опутанной жертвой для пропитания потомства."
	button_icon_state = "lay_enriched_eggs"
	egg_type = /obj/effect/mob_spawn/spider/enriched
	/// How many charges we have to make eggs
	var/charges = 0

/datum/action/innate/spider/lay_eggs/enriched/IsAvailable(feedback = FALSE)
	return ..() && (charges > 0)

/datum/action/innate/spider/set_directive
	name = "Установить директиву"
	desc = "Установите директиву которой будут следовать ваши дети."
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "directive"

/datum/action/innate/spider/set_directive/IsAvailable(feedback = FALSE)
	return ..() && istype(owner, /mob/living/simple_animal/hostile/giant_spider)

/datum/action/innate/spider/set_directive/Activate()
	var/mob/living/simple_animal/hostile/giant_spider/midwife/spider = owner

	spider.directive = stripped_input(spider, "Установите новую директиву", "Создайте директиву", "[spider.directive]")
	if(isnull(spider.directive) || QDELETED(src) || QDELETED(owner) || !IsAvailable())
		return FALSE

	message_admins("[ADMIN_LOOKUPFLW(owner)] set its directive to: '[spider.directive]'.")
	owner.log_message("set its directive to: '[spider.directive]'.", LOG_GAME)
	return TRUE

/datum/action/innate/spider/comm
	name = "Приказ"
	desc = "Отдать приказ всем паукам."
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "command"

/datum/action/innate/spider/comm/IsAvailable(feedback = FALSE)
	return ..() && istype(owner, /mob/living/simple_animal/hostile/giant_spider/midwife)

/datum/action/innate/spider/comm/Trigger(trigger_flags)
	var/input = tgui_input_text(owner, "Введите приказ для вашего легиона.", "Приказ")
	if(!input || QDELETED(src) || QDELETED(owner) || !IsAvailable())
		return FALSE

	spider_command(owner, input)
	return TRUE

/**
 * Sends a message to all spiders from the target.
 *
 * Allows the user to send a message to all spiders that exist.  Ghosts will also see the message.
 * Arguments:
 * * user - The spider sending the message
 * * message - The message to be sent
 */
/datum/action/innate/spider/comm/proc/spider_command(mob/living/user, message)
	if(!message)
		return
	var/my_message
	my_message = span_spider("<b>Приказ от [user]:</b> [message]")
	for(var/mob/living/simple_animal/hostile/giant_spider/spider in GLOB.spidermobs)
		to_chat(spider, my_message)
	for(var/ghost in GLOB.dead_mob_list)
		var/link = FOLLOW_LINK(ghost, user)
		to_chat(ghost, "[link] [my_message]")
	usr.log_talk(message, LOG_SAY, tag="spider command")

/**
 * # Giant Ice Spider
 *
 * A giant spider immune to temperature damage.  Injects frost oil.
 *
 * A subtype of the giant spider which is immune to temperature damage, unlike its normal counterpart.
 * Currently unused in the game unless spawned by admins.
 */
/mob/living/simple_animal/hostile/giant_spider/ice
	name = "огромный морозный паук"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	poison_type = /datum/reagent/consumable/frostoil
	color = rgb(114,228,250)
	gold_core_spawnable = NO_SPAWN

/**
 * # Ice Nurse Spider
 *
 * A nurse spider immune to temperature damage.  Injects frost oil.
 *
 * Same thing as the giant ice spider but mirrors the nurse subtype.  Also unused.
 */
/mob/living/simple_animal/hostile/giant_spider/nurse/ice
	name = "ледяная фрейлина"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	poison_type = /datum/reagent/consumable/frostoil
	color = rgb(114,228,250)

/**
 * # Ice Hunter Spider
 *
 * A hunter spider immune to temperature damage.  Injects frost oil.
 *
 * Same thing as the giant ice spider but mirrors the hunter subtype.  Also unused.
 */
/mob/living/simple_animal/hostile/giant_spider/hunter/ice
	name = "морозный паук охотник"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	poison_type = /datum/reagent/consumable/frostoil
	color = rgb(114,228,250)
	gold_core_spawnable = NO_SPAWN

/**
 * # Flesh Spider
 *
 * A giant spider subtype specifically created by changelings.  Built to be self-sufficient, unlike other spider types.
 *
 * A subtype of giant spider which only occurs from changelings.  Has the base stats of a hunter, but they can heal themselves.
 * They also produce web in 70% of the time of the base spider.  They also occasionally leave puddles of blood when they walk around.  Flavorful!
 */
/mob/living/simple_animal/hostile/giant_spider/hunter/flesh
	name = "кровавый паук"
	desc = "Маленькое мясистое существо в форме паука. Его глаза черны как смоль и горят ненавистью."
	icon_state = "flesh_spider"
	icon_living = "flesh_spider"
	icon_dead = "flesh_spider_dead"
	web_speed = 0.7

/mob/living/simple_animal/hostile/giant_spider/hunter/flesh/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/blood_walk, \
		blood_type = /obj/effect/decal/cleanable/blood/bubblegum, \
		blood_spawn_chance = 5)

/mob/living/simple_animal/hostile/giant_spider/hunter/flesh/AttackingTarget()
	if(DOING_INTERACTION(src, INTERACTION_SPIDER_KEY))
		return
	if(src == target)
		if(health >= maxHealth)
			to_chat(src, span_warning("Мое тело в порядке и не нуждается в восстановлении."))
			return
		visible_message(span_notice("[src] заращивает на себе раны..."),span_notice("Начинаю заращивать свои раны..."))
		if(do_after(src, 2 SECONDS, target = src, interaction_key = INTERACTION_SPIDER_KEY))
			heal_overall_damage(50, 50)
			new /obj/effect/temp_visual/heal(get_turf(src), "#80F5FF")
			visible_message(span_notice("[src] восстанавливается."),span_notice("Мне лучше."))
		return
	return ..()

/**
 * # Viper Spider (Wizard)
 *
 * A viper spider buffed slightly so I don't need to hear anyone complain about me nerfing an already useless wizard ability.
 *
 * A viper spider with buffed attributes.  All I changed was its health value and gave it the ability to ventcrawl.  The crux of the wizard meta.
 */
/mob/living/simple_animal/hostile/giant_spider/viper/wizard
	maxHealth = 80
	health = 80
	menu_description = "Stronger assassin spider variant with an unmatched speed, high amount of health and very deadly poison, but deals very low amount of damage. It also has ability to ventcrawl."

/mob/living/simple_animal/hostile/giant_spider/viper/wizard/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)

#undef INTERACTION_SPIDER_KEY

/mob/living/simple_animal/hostile/giant_spider/sgt_araneus
	name = "Сержант Арахниус"
	real_name = "Сержант Арахниус"
	desc = "Свирепый компаньон главы службы безопасности, этот паук был тщательно обучен специалистами НаноТрейзен. От его пристальных глаз-бусинок по спине пробегают мурашки."
	emote_hear = list("стрекочет")
	faction = list("neutral")
	harm_intent_damage = 3
	icon_dead = "guard_dead"
	icon_gib = "guard_dead"
	icon_living = "guard"
	icon_state = "guard"
	health = 300
	maxHealth = 300
	melee_damage_lower = 15
	melee_damage_upper = 20
	movement_type = GROUND
	response_help_continuous = "гладит"
	response_help_simple = "гладит"
	turns_per_move = 10
	pet_bonus = TRUE
	pet_bonus_emote = "радостно стрекочет!"

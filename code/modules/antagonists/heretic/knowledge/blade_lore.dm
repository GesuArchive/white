/**
 * # The path of Blades. Stab stab.
 *
 * Goes as follows:
 *
 * The Cutting Edge
 * Grasp of the Blade
 * Dance of the Brand
 * > Sidepaths:
 *   Shattered Risen
 *   Armorer's Ritual
 *
 * Mark of the Blade
 * Ritual of Knowledge
 * Stance of the Scarred Duelist
 * > Sidepaths:
 *   Carving Knife
 *   Mawed Crucible
 *
 * Swift Blades
 * Furious Steel
 * > Sidepaths:
 *   Maid in the Mirror
 *   Lionhunter Rifle
 *
 * Maelstrom of Silver
 */
/datum/heretic_knowledge/limited_amount/starting/base_blade
	name = "Режущее острие"
	desc = "Открывает вам путь лезвия. \
		Позволяет преобразовать нож и два листа серебра для создания затемненного лезвия. \
		Вы можете создать одновременно лишь 5 лезвий."
	gain_text = "Наши могучие предки ковали мечи и тренировались в спаррингах даже в великих битвах."
	next_knowledge = list(/datum/heretic_knowledge/blade_grasp)
	required_atoms = list(
		/obj/item/kitchen/knife = 1,
		/obj/item/stack/sheet/mineral/silver = 2,
	)
	result_atoms = list(/obj/item/melee/sickly_blade/dark)
	limit = 5 // It's the blade path, it's a given
	route = PATH_BLADE

/datum/heretic_knowledge/blade_grasp
	name = "Хватка лезвий"
	desc = "Ваша хватка Мансуса вызовет короткое оглушение при использовании на том кто лежит или не смотрит на вас."
	gain_text = "История пехотинца началась в глубокой древности. Это история крови и доблести, \
		что отстаивается мечом, сталью и серебром."
	next_knowledge = list(/datum/heretic_knowledge/blade_dance)
	cost = 1
	route = PATH_BLADE

/datum/heretic_knowledge/blade_grasp/on_gain(mob/user)
	RegisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK, PROC_REF(on_mansus_grasp))

/datum/heretic_knowledge/blade_grasp/on_lose(mob/user)
	UnregisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK)

/datum/heretic_knowledge/blade_grasp/proc/on_mansus_grasp(mob/living/source, mob/living/target)
	SIGNAL_HANDLER

	// Let's see if source is behind target
	// "Behind" is defined as 3 tiles directly to the back of the target
	// x . .
	// x > .
	// x . .

	var/are_we_behind = FALSE
	// No tactical spinning allowed
	if(target.flags_1 & IS_SPINNING_1)
		are_we_behind = TRUE

	// We'll take "same tile" as "behind" for ease
	if(target.loc == source.loc)
		are_we_behind = TRUE

	// We'll also assume lying down is behind, as mob directions when lying are unclear
	if(target.body_position == LYING_DOWN)
		are_we_behind = TRUE

	// Exceptions aside, let's actually check if they're, yknow, behind
	var/dir_target_to_source = get_dir(target, source)
	if(target.dir & REVERSE_DIR(dir_target_to_source))
		are_we_behind = TRUE

	if(!are_we_behind)
		return

	// We're officially behind them, apply effects
	target.AdjustParalyzed(1.5 SECONDS)
	target.apply_damage(10, BRUTE, wound_bonus = CANT_WOUND)
	target.balloon_alert(source, "удар в спину!")
	playsound(get_turf(target), 'sound/weapons/guillotine.ogg', 100, TRUE)

/// The cooldown duration between trigers of blade dance
#define BLADE_DANCE_COOLDOWN 20 SECONDS

/datum/heretic_knowledge/blade_dance
	name = "Танец лезвий"
	desc = "Держа по клинку в каждой руке, вы можете парировать каждую атаку. Этот эффект срабатывает не чаще, чем раз в 20 секунд."
	gain_text = "Право держать в руках Клинок требует большой самоотдачи и авторитета."
	next_knowledge = list(
		/datum/heretic_knowledge/limited_amount/risen_corpse,
		/datum/heretic_knowledge/mark/blade_mark,
		/datum/heretic_knowledge/codex_cicatrix,
		/datum/heretic_knowledge/armor,
	)
	cost = 1
	route = PATH_BLADE
	/// Whether the counter-attack is ready or not.
	/// Used instead of cooldowns, so we can give feedback when it's ready again
	var/riposte_ready = TRUE

/datum/heretic_knowledge/blade_dance/on_gain(mob/user)
	RegisterSignal(user, COMSIG_HUMAN_CHECK_SHIELDS, PROC_REF(on_shield_reaction))

/datum/heretic_knowledge/blade_dance/on_lose(mob/user)
	UnregisterSignal(user, COMSIG_HUMAN_CHECK_SHIELDS)

/datum/heretic_knowledge/blade_dance/proc/on_shield_reaction(
	mob/living/carbon/human/source,
	atom/movable/hitby,
	damage = 0,
	attack_text = "парирование",
	attack_type = MELEE_ATTACK,
	armour_penetration = 0,
)

	SIGNAL_HANDLER

	if(attack_type != MELEE_ATTACK)
		return

	if(!riposte_ready)
		return

	if(source.incapacitated(IGNORE_GRAB))
		return

	var/mob/living/attacker = hitby.loc
	if(!istype(attacker))
		return

	if(!source.Adjacent(attacker))
		return

	// Let's check their held items to see if we can do a riposte
	var/obj/item/main_hand = source.get_active_held_item()
	var/obj/item/off_hand = source.get_inactive_held_item()
	// This is the item that ends up doing the "blocking" (flavor)
	var/obj/item/striking_with

	// First we'll check if the offhand is valid
	if(!QDELETED(off_hand) && istype(off_hand, /obj/item/melee/sickly_blade))
		striking_with = off_hand

	// Then we'll check the mainhand
	// We do mainhand second, because we want to prioritize it over the offhand
	if(!QDELETED(main_hand) && istype(main_hand, /obj/item/melee/sickly_blade))
		striking_with = main_hand

	// No valid item in either slot? No riposte
	if(!striking_with)
		return

	// If we made it here, deliver the strike
	INVOKE_ASYNC(src, PROC_REF(counter_attack), source, attacker, striking_with, attack_text)

	// And reset after a bit
	riposte_ready = FALSE
	addtimer(CALLBACK(src, PROC_REF(reset_riposte), source), BLADE_DANCE_COOLDOWN)

/datum/heretic_knowledge/blade_dance/proc/counter_attack(mob/living/carbon/human/source, mob/living/target, obj/item/melee/sickly_blade/weapon, attack_text)
	playsound(get_turf(source), 'sound/weapons/parry.ogg', 100, TRUE)
	source.balloon_alert(source, "парирование")
	source.visible_message(
		span_warning("[source] использует [attack_text] и наносит ответный удар [target]!"),
		span_warning("Я делаю выпад навстречу атаке и наношу контрудар [target]!"),
		span_hear("Слышу лязг, за которым следует удар."),
	)
	weapon.melee_attack_chain(source, target)

/datum/heretic_knowledge/blade_dance/proc/reset_riposte(mob/living/carbon/human/source)
	riposte_ready = TRUE
	source.balloon_alert(source, "парирование готово")

#undef BLADE_DANCE_COOLDOWN

/datum/heretic_knowledge/mark/blade_mark
	name = "Метка лезвия"
	desc = "Ваша Хватка Мансуса теперь наносит Метку Лезвия. Пока жертв обнаружена, \
		она не может исключить поражение места до попадания или активацию метки. \
		Активация метки призовёт нож, который будет вращаться вокруг вас в течение короткого времени. \
		Нож блокирует любую атаку, направленную на вас, но ломается при использовании."
	gain_text = "Здесь не было места трусости! Тех, кто сбежал, били в спину. \
		И именно так я с ним познакомился. Его звали Полковник."
	next_knowledge = list(/datum/heretic_knowledge/knowledge_ritual/blade)
	route = PATH_BLADE
	mark_type = /datum/status_effect/eldritch/blade

/datum/heretic_knowledge/mark/blade_mark/create_mark(mob/living/source, mob/living/target)
	var/datum/status_effect/eldritch/blade/blade_mark = ..()
	if(!istype(blade_mark))
		return

	var/area/to_lock_to = get_area(target)
	blade_mark.locked_to = to_lock_to
	to_chat(target, span_hypnophrase("Что-то не даёт мне покинуть [get_area_name(to_lock_to)]!"))

/datum/heretic_knowledge/mark/blade_mark/trigger_mark(mob/living/source, mob/living/target)
	. = ..()
	if(!.)
		return
	source.apply_status_effect(/datum/status_effect/protective_blades, 60 SECONDS, 1, 20, 0 SECONDS)

/datum/heretic_knowledge/knowledge_ritual/blade
	next_knowledge = list(/datum/heretic_knowledge/duel_stance)
	route = PATH_BLADE

/// The amount of blood flow reduced per level of severity of gained bleeding wounds for Stance of the Scarred Duelist.
#define BLOOD_FLOW_PER_SEVEIRTY 1

/datum/heretic_knowledge/duel_stance
	name = "Стойка дуэлянта"
	desc = "Дает сопротивление кровотечению и иммунитет к отсеканию конечностей. \
		Кроме того, если ваше здоровье ниже 50% от максимума, \
		у вас увеличивается сопротивление ко всем видам урона и защита от дубинок."
	gain_text = "Полковник был великим на протяжении всей эпохи. Но теперь он слеп, он глух. \
		Его нельзя ранить, и ему нельзя отказать. Его методы гарантируют, это."
	next_knowledge = list(
		/datum/heretic_knowledge/blade_upgrade/blade,
		/datum/heretic_knowledge/reroll_targets,
		/datum/heretic_knowledge/rune_carver,
		/datum/heretic_knowledge/crucible,
	)
	cost = 1
	route = PATH_BLADE
	/// Whether we're currently in duelist stance, gaining certain buffs (low health)
	var/in_duelist_stance = FALSE

/datum/heretic_knowledge/duel_stance/on_gain(mob/user)
	ADD_TRAIT(user, TRAIT_NODISMEMBER, type)
	RegisterSignal(user, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(user, COMSIG_CARBON_GAIN_WOUND, PROC_REF(on_wound_gain))
	RegisterSignal(user, COMSIG_CARBON_HEALTH_UPDATE, PROC_REF(on_health_update))

	on_health_update(user) // Run this once, so if the knowledge is learned while hurt it activates properly

/datum/heretic_knowledge/duel_stance/on_lose(mob/user)
	REMOVE_TRAIT(user, TRAIT_NODISMEMBER, type)
	if(in_duelist_stance)
		REMOVE_TRAIT(user, TRAIT_HARDLY_WOUNDED, type)
		REMOVE_TRAIT(user, TRAIT_STUNRESISTANCE, type)

	UnregisterSignal(user, list(COMSIG_PARENT_EXAMINE, COMSIG_CARBON_GAIN_WOUND, COMSIG_CARBON_HEALTH_UPDATE))

/datum/heretic_knowledge/duel_stance/proc/on_examine(mob/living/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	var/obj/item/held_item = source.get_active_held_item()
	if(in_duelist_stance)
		examine_list += span_warning("[source] выглядит неестественно уравновешенным [held_item?.force >= 15 ? " и готовым к бою":""].")

/datum/heretic_knowledge/duel_stance/proc/on_wound_gain(mob/living/source, datum/wound/gained_wound, obj/item/bodypart/limb)
	SIGNAL_HANDLER

	if(gained_wound.blood_flow <= 0)
		return

	gained_wound.blood_flow -= (gained_wound.severity * BLOOD_FLOW_PER_SEVEIRTY)

/datum/heretic_knowledge/duel_stance/proc/on_health_update(mob/living/source)
	SIGNAL_HANDLER

	if(in_duelist_stance && source.health > source.maxHealth * 0.5)
		source.balloon_alert(source, "выходит из стойки дуэлянта")
		in_duelist_stance = FALSE
		REMOVE_TRAIT(source, TRAIT_HARDLY_WOUNDED, type)
		REMOVE_TRAIT(source, TRAIT_STUNRESISTANCE, type)
		return

	if(!in_duelist_stance && source.health <= source.maxHealth * 0.5)
		source.balloon_alert(source, "встаёт в стойку дуэлянта")
		in_duelist_stance = TRUE
		ADD_TRAIT(source, TRAIT_HARDLY_WOUNDED, type)
		ADD_TRAIT(source, TRAIT_STUNRESISTANCE, type)
		return

#undef BLOOD_FLOW_PER_SEVEIRTY

/datum/heretic_knowledge/blade_upgrade/blade
	name = "Быстрые лезвия"
	desc = "Атака кого то с затемнёнными клинками в обеих руках \
		будет наносить удар обоими сразу, нанося две атаки в быстрой последовательности. \
		Второй удар будет чуть слабее."
	gain_text = "Я смогу постичь мастерство Полковника. Наконец я познаю доблесть..."
	next_knowledge = list(/datum/heretic_knowledge/spell/furious_steel)
	route = PATH_BLADE

/datum/heretic_knowledge/blade_upgrade/blade/do_melee_effects(mob/living/source, mob/living/target, obj/item/melee/sickly_blade/blade)
	if(target == source)
		return

	var/obj/item/off_hand = source.get_inactive_held_item()
	if(QDELETED(off_hand) || !istype(off_hand, /obj/item/melee/sickly_blade))
		return
	// If our off-hand is the blade that's attacking,
	// quit out now to avoid an infinite stab combo
	if(off_hand == blade)
		return

	// Give it a short delay (for style, also lets people dodge it I guess)
	addtimer(CALLBACK(src, PROC_REF(follow_up_attack), source, target, off_hand), 0.25 SECONDS)

/datum/heretic_knowledge/blade_upgrade/blade/proc/follow_up_attack(mob/living/source, mob/living/target, obj/item/melee/sickly_blade/blade)
	if(QDELETED(source) || QDELETED(target) || QDELETED(blade))
		return
	// Sanity to ensure that the blade we're delivering
	// an offhand attack with is actually our offhand
	if(blade != source.get_inactive_held_item())
		return
	if(!source.Adjacent(target))
		return

	// Blade are 17 force: 17 + 17 = 34 (3 hits to crit, unarmored)
	// So, -5 force is put on the offhand blade: 17 + 12 = 29 (4 hits to crit, unarmored)
	blade.force -= 5
	blade.melee_attack_chain(source, target)
	blade.force += 5

/datum/heretic_knowledge/spell/furious_steel
	name = "Яростная сталь"
	desc = "Дает вам целевое заклинание - Яростную сталь. Использовав его вы вызовете три \
		вращающиеся вокруг тебя лезвия. Они защитят своего хозяина от всех атак, \
		но расходуются при использовании. Кроме того, вы можете нажать на свою цель, чтобы запустить в неё лезвием \
		цель будет ранена и может начать истекать кровью."
	gain_text = "Его искусство владения мечом стало моим вдохновением и закономерным исходом этой истории..."
	next_knowledge = list(
		/datum/heretic_knowledge/summon/maid_in_mirror,
		/datum/heretic_knowledge/final/blade_final,
		/datum/heretic_knowledge/rifle,
	)
	spell_to_add = /datum/action/cooldown/spell/pointed/projectile/furious_steel
	cost = 1
	route = PATH_BLADE

/datum/heretic_knowledge/final/blade_final
	name = "Водоворот серебра"
	desc = "Ритуал вознесения на Пути Лезвий. \
		Принесите 3 обезглавленных трупа к руне трансмутации, для начала ритуала. \
		Когда вы закончите, вы будете окружены постоянной, восстанавливающейся орбитой из лезвий. \
		Эти клинки защитят вас от всех атак, и будут ломаться при использовании. \
		Ваше заклинание Яростной Стали получит уменьшение перезарядки. \
		Кроме того, вы становитесь мастером боя, получая защиту от ранений и иммунитет к оглушению. \
		Ваши затемненные клинки наносят дополнительный урон и получают вампиризм от нанесённого урона."
	gain_text = "Полковник, имея большой опыт, раскрыл мне три корня победы. \
		Хитрость. Сила. И агония! Это была его тайная доктрина! С этими знаниями и моим потенциалом, \
		МНЕ НЕТ РАВНЫХ! ШТОРМ ИЗ СТАЛИ И СЕРЕБРА НАДВИГАЕТСЯ НА ВАС! СТАНЬТЕ СВИДЕТЕЛЯМИ МОЕГО ВОЗНЕСЕНИЯ!"
	route = PATH_BLADE

/datum/heretic_knowledge/final/blade_final/is_valid_sacrifice(mob/living/carbon/human/sacrifice)
	. = ..()
	if(!.)
		return FALSE

	return !sacrifice.get_bodypart(BODY_ZONE_HEAD)

/datum/heretic_knowledge/final/blade_final/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	. = ..()
	priority_announce("[generate_heretic_text()] Мастер лезвий, ученик Полковника, [user.real_name] вознесся! Его сталь - это то, что рассечет реальность в водовороте серебра! [generate_heretic_text()]","[generate_heretic_text()]", ANNOUNCER_SPANOMALIES)
	user.client?.give_award(/datum/award/achievement/misc/blade_ascension, user)
	ADD_TRAIT(user, TRAIT_STUNIMMUNE, name)
	ADD_TRAIT(user, TRAIT_NEVER_WOUNDED, name)
	RegisterSignal(user, COMSIG_HERETIC_BLADE_ATTACK, PROC_REF(on_eldritch_blade))
	user.apply_status_effect(/datum/status_effect/protective_blades/recharging, null, 8, 30, 0.25 SECONDS, 1 MINUTES)

	var/datum/action/cooldown/spell/pointed/projectile/furious_steel/steel_spell = locate() in user.actions
	steel_spell?.cooldown_time /= 3

/datum/heretic_knowledge/final/blade_final/proc/on_eldritch_blade(mob/living/source, mob/living/target, obj/item/melee/sickly_blade/blade)
	SIGNAL_HANDLER

	if(target == source)
		return

	// Turns your heretic blades into eswords, pretty much.
	var/bonus_damage = clamp(30 - blade.force, 0, 12)

	target.apply_damage(
		damage = bonus_damage,
		damagetype = BRUTE,
		wound_bonus = 5,
		sharpness = SHARP_EDGED,
		attack_direction = get_dir(source, target),
	)

	if(target.stat != DEAD)
		// And! Get some free healing for a portion of the bonus damage dealt.
		source.heal_overall_damage(bonus_damage / 2, bonus_damage / 2)

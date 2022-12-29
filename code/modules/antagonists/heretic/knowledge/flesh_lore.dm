/// The max amount of health a ghoul has.
#define GHOUL_MAX_HEALTH 25
/// The max amount of health a voiceless dead has.
#define MUTE_MAX_HEALTH 50

/**
 * # The path of Flesh.
 *
 * Goes as follows:
 *
 * Principle of Hunger
 * Grasp of Flesh
 * Imperfect Ritual
 * > Sidepaths:
 *   Void Cloak
 *   Ashen Eyes
 *
 * Mark of Flesh
 * Ritual of Knowledge
 * Raw Ritual
 * > Sidepaths:
 *   Blood Siphon
 *   Curse of Paralysis
 *
 * Bleeding Steel
 * Lonely Ritual
 * > Sidepaths:
 *   Ashen Ritual
 *   Cleave
 *
 * Priest's Final Hymn
 */
/datum/heretic_knowledge/limited_amount/starting/base_flesh
	name = "Принцип Голода"
	desc = "Открывает вам Путь Плоти. \
		Позволяет вам трансмутировать кухонный нож и лужу крови в Кровавый клинок. \
		У вас может быть только три клинка одновременно."
	gain_text = "Сотни из нас голодали, но не я... Меня питала моя алчность."
	next_knowledge = list(/datum/heretic_knowledge/limited_amount/flesh_grasp)
	required_atoms = list(
		/obj/item/kitchen/knife = 1,
		/obj/effect/decal/cleanable/blood = 1,
	)
	result_atoms = list(/obj/item/melee/sickly_blade/flesh)
	limit = 3 // Bumped up so they can arm up their ghouls too.
	route = PATH_FLESH

/datum/heretic_knowledge/limited_amount/starting/base_flesh/on_research(mob/user)
	. = ..()
	var/datum/antagonist/heretic/our_heretic = IS_HERETIC(user)
	our_heretic.heretic_path = route

	var/datum/objective/heretic_summon/summon_objective = new()
	summon_objective.owner = our_heretic.owner
	our_heretic.objectives += summon_objective

	to_chat(user, span_hierophant("Обязуясь следовать по Пути Плоти, вы так же получаете и ещё одну цель."))
	our_heretic.owner.announce_objectives()

/datum/heretic_knowledge/limited_amount/flesh_grasp
	name = "Метка Плоти"
	desc = "Теперь ваша Хватка Мансуса может создать гуля из трупа с присутствующей в нем душой. \
		Гули имеют только 25 очков здоровья и выглядят в глазах неверных как хаски, но они могут использовать Кровавый клинок. \
		Одновременно у вас может быть только один гуль. Хаски гулями стать не могут."
	gain_text = "Мои новоприобретенные страсти вели меня к новым высотам."
	next_knowledge = list(/datum/heretic_knowledge/limited_amount/flesh_ghoul)
	limit = 1
	cost = 1
	route = PATH_FLESH

/datum/heretic_knowledge/limited_amount/flesh_grasp/on_gain(mob/user)
	RegisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK, PROC_REF(on_mansus_grasp))

/datum/heretic_knowledge/limited_amount/flesh_grasp/on_lose(mob/user)
	UnregisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK)

/datum/heretic_knowledge/limited_amount/flesh_grasp/proc/on_mansus_grasp(mob/living/source, mob/living/target)
	SIGNAL_HANDLER

	if(target.stat != DEAD)
		return

	if(LAZYLEN(created_items) >= limit)
		target.balloon_alert(source, "at ghoul limit!")
		return COMPONENT_BLOCK_HAND_USE

	if(HAS_TRAIT(target, TRAIT_HUSK))
		target.balloon_alert(source, "husked!")
		return COMPONENT_BLOCK_HAND_USE

	if(!IS_VALID_GHOUL_MOB(target))
		target.balloon_alert(source, "invalid body!")
		return COMPONENT_BLOCK_HAND_USE

	target.grab_ghost()

	// The grab failed, so they're mindless or playerless. We can't continue
	if(!target.mind || !target.client)
		target.balloon_alert(source, "no soul!")
		return COMPONENT_BLOCK_HAND_USE

	make_ghoul(source, target)

/// Makes [victim] into a ghoul.
/datum/heretic_knowledge/limited_amount/flesh_grasp/proc/make_ghoul(mob/living/user, mob/living/carbon/human/victim)
	log_game("[key_name(user)] created a ghoul, controlled by [key_name(victim)].")
	message_admins("[ADMIN_LOOKUPFLW(user)] created a ghoul, [ADMIN_LOOKUPFLW(victim)].")

	victim.apply_status_effect(
		/datum/status_effect/ghoul,
		GHOUL_MAX_HEALTH,
		user.mind,
		CALLBACK(src, PROC_REF(apply_to_ghoul)),
		CALLBACK(src, PROC_REF(remove_from_ghoul)),
	)

/// Callback for the ghoul status effect - Tracking all of our ghouls
/datum/heretic_knowledge/limited_amount/flesh_grasp/proc/apply_to_ghoul(mob/living/ghoul)
	LAZYADD(created_items, WEAKREF(ghoul))

/// Callback for the ghoul status effect - Tracking all of our ghouls
/datum/heretic_knowledge/limited_amount/flesh_grasp/proc/remove_from_ghoul(mob/living/ghoul)
	LAZYREMOVE(created_items, WEAKREF(ghoul))

/datum/heretic_knowledge/limited_amount/flesh_ghoul
	name = "Незавершенный Ритуал"
	desc = "Позволяет произвести ритуал трансмутации мертвого тела и мака для создания Безмолвного Мертвеца. \
		Безмолвный мертвец не способен говорить и имеет 50 очков здоровья, но он может использовать Кровавый клинок. \
		У вас может быть только два таких прислужника одновременно."
	gain_text = "Мною были найдены запретные темные знания, их незаконченные обрывки...пока, незаконченные. Я продолжил двигаться вперед."
	next_knowledge = list(
		/datum/heretic_knowledge/mark/flesh_mark,
		/datum/heretic_knowledge/codex_cicatrix,
		/datum/heretic_knowledge/void_cloak,
		/datum/heretic_knowledge/medallion,
	)
	required_atoms = list(
		/mob/living/carbon/human = 1,
		/obj/item/food/grown/poppy = 1,
	)
	limit = 2
	cost = 1
	route = PATH_FLESH

/datum/heretic_knowledge/limited_amount/flesh_ghoul/recipe_snowflake_check(mob/living/user, list/atoms, list/selected_atoms, turf/loc)
	. = ..()
	if(!.)
		return FALSE

	for(var/mob/living/carbon/human/body in atoms)
		if(body.stat != DEAD)
			continue
		if(!IS_VALID_GHOUL_MOB(body) || HAS_TRAIT(body, TRAIT_HUSK))
			to_chat(user, span_hierophant_warning("Тело [skloname(body, RODITELNI, body.gender)] неспособно стать гулем."))
			continue

		// We'll select any valid bodies here. If they're clientless, we'll give them a new one.
		selected_atoms += body
		return TRUE

	loc.balloon_alert(user, "ritual failed, no valid body!")
	return FALSE

/datum/heretic_knowledge/limited_amount/flesh_ghoul/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	var/mob/living/carbon/human/soon_to_be_ghoul = locate() in selected_atoms
	if(QDELETED(soon_to_be_ghoul)) // No body? No ritual
		stack_trace("[type] reached on_finished_recipe without a human in selected_atoms to make a ghoul out of.")
		loc.balloon_alert(user, "ритуал провален, тело не подходит!")
		return FALSE

	soon_to_be_ghoul.grab_ghost()

	if(!soon_to_be_ghoul.mind || !soon_to_be_ghoul.client)
		message_admins("[ADMIN_LOOKUPFLW(user)] is creating a voiceless dead of a body with no player.")
		var/list/mob/dead/observer/candidates = poll_candidates_for_mob("Вы хотите играть как [soon_to_be_ghoul.real_name], в роли Безмолвного Мертвеца?", ROLE_HERETIC, ROLE_HERETIC, 5 SECONDS, soon_to_be_ghoul)
		if(!LAZYLEN(candidates))
			loc.balloon_alert(user, "ритуал провален, нет подходящей души!")
			return FALSE

		var/mob/dead/observer/chosen_candidate = pick(candidates)
		message_admins("[key_name_admin(chosen_candidate)] has taken control of ([key_name_admin(soon_to_be_ghoul)]) to replace an AFK player.")
		soon_to_be_ghoul.ghostize(FALSE)
		soon_to_be_ghoul.key = chosen_candidate.key

	selected_atoms -= soon_to_be_ghoul
	make_ghoul(user, soon_to_be_ghoul)
	return TRUE

/// Makes [victim] into a ghoul.
/datum/heretic_knowledge/limited_amount/flesh_ghoul/proc/make_ghoul(mob/living/user, mob/living/carbon/human/victim)
	log_game("[key_name(user)] created a voiceless dead, controlled by [key_name(victim)].")
	message_admins("[ADMIN_LOOKUPFLW(user)] created a voiceless dead, [ADMIN_LOOKUPFLW(victim)].")

	victim.apply_status_effect(
		/datum/status_effect/ghoul,
		MUTE_MAX_HEALTH,
		user.mind,
		CALLBACK(src, PROC_REF(apply_to_ghoul)),
		CALLBACK(src, PROC_REF(remove_from_ghoul)),
	)

/// Callback for the ghoul status effect - Tracks all of our ghouls and applies effects
/datum/heretic_knowledge/limited_amount/flesh_ghoul/proc/apply_to_ghoul(mob/living/ghoul)
	LAZYADD(created_items, WEAKREF(ghoul))
	ADD_TRAIT(ghoul, TRAIT_MUTE, MAGIC_TRAIT)

/// Callback for the ghoul status effect - Tracks all of our ghouls and applies effects
/datum/heretic_knowledge/limited_amount/flesh_ghoul/proc/remove_from_ghoul(mob/living/ghoul)
	LAZYREMOVE(created_items, WEAKREF(ghoul))
	REMOVE_TRAIT(ghoul, TRAIT_MUTE, MAGIC_TRAIT)

/datum/heretic_knowledge/mark/flesh_mark
	name = "Метка Плоти"
	desc = "Ваша Хватка Мансуса теперь накладывает Метку Плоти. Её активация происходит после того, как вы атакуете жертву Кровавым клинком. \
		При активации метка вызывает у носителя обильное кровотечение."
	gain_text = "И тогда я узрел их, отмеченных. Они были недостижимы. А крики их наполнены агонией."
	next_knowledge = list(/datum/heretic_knowledge/knowledge_ritual/flesh)
	route = PATH_FLESH
	mark_type = /datum/status_effect/eldritch/flesh

/datum/heretic_knowledge/knowledge_ritual/flesh
	next_knowledge = list(/datum/heretic_knowledge/summon/raw_prophet)
	route = PATH_FLESH

/datum/heretic_knowledge/summon/raw_prophet
	name = "Нечестивый Ритуал"
	desc = "Позволяет произвести ритуал трансмутации пары глаз, левой руки и лужи крови для создания Нечестивого Пророка. \
		Нечестивый Пророк видит на большее расстрояние, имеет способность к бестелесному перемещению и имеет возможность смотреть сквозь стены. Помимо всего прочего \
		он может создать телепатическую сеть для общения и ослеплять ваших врагов, но он крайне слаб и легко может быть уничтожен в бою."
	gain_text = "Продолжать путь в одиночестве было невыносимо. И тогда я призвал Пророка, дабы он помог узреть больше. \
		И крики...постоянные крики, они затихли. Его нечестивое присутствие подавляло их. Ничто более не было недостижимым."
	next_knowledge = list(
		/datum/heretic_knowledge/blade_upgrade/flesh,
		/datum/heretic_knowledge/reroll_targets,
		/datum/heretic_knowledge/spell/blood_siphon,
		/datum/heretic_knowledge/curse/paralysis,
	)
	required_atoms = list(
		/obj/item/organ/eyes = 1,
		/obj/effect/decal/cleanable/blood = 1,
		/obj/item/bodypart/l_arm = 1,
	)
	mob_to_summon = /mob/living/simple_animal/hostile/heretic_summon/raw_prophet
	cost = 1
	route = PATH_FLESH

/datum/heretic_knowledge/blade_upgrade/flesh
	name = "Иссекающая сталь"
	desc = "Ваш Кровавый клинок теперь вызывает сильное кровотечение при атаке."
	gain_text = "Но Пророк не был одинок. Он привел меня к Маршалу. \
		Ко мне наконец пришло просвещение. И небеса окропили землю кровью."
	next_knowledge = list(/datum/heretic_knowledge/summon/stalker)
	route = PATH_FLESH

/datum/heretic_knowledge/blade_upgrade/flesh/do_melee_effects(mob/living/source, mob/living/target, obj/item/melee/sickly_blade/blade)
	if(!iscarbon(target) || source == target)
		return

	var/mob/living/carbon/carbon_target = target
	var/obj/item/bodypart/bodypart = pick(carbon_target.bodyparts)
	var/datum/wound/slash/severe/crit_wound = new()
	crit_wound.apply_wound(bodypart, attack_direction = get_dir(source, target))

/datum/heretic_knowledge/summon/stalker
	name = "Одинокий Ритуал"
	desc = "Позволяет произвести ритуал трансмутации где хвост, желудок, язык, ручка и лист бумаги используются для создания Преследователя. \
		Преследователи могут становиться нематериальными, испускать ЭМИ импульс, превращаться в небольших существ. Также они весьма сильны в бою."
	gain_text = "Я смешал свою жадность и желания воедино, дабы призвать невиданное доселе сверхестественное существо. \
		И чем сильнее эта масса плоти изменялась, тем больше она узнавала обо мне. Маршал был доволен."
	next_knowledge = list(
		/datum/heretic_knowledge/final/flesh_final,
		/datum/heretic_knowledge/summon/ashy,
		/datum/heretic_knowledge/spell/cleave,
	)
	required_atoms = list(
		/obj/item/organ/tail = 1,
		/obj/item/organ/stomach = 1,
		/obj/item/organ/tongue = 1,
		/obj/item/pen = 1,
		/obj/item/paper = 1,
	)
	mob_to_summon = /mob/living/simple_animal/hostile/heretic_summon/stalker
	cost = 1
	route = PATH_FLESH

/datum/heretic_knowledge/final/flesh_final
	name = "Последний Гимн Жреца"
	desc = "Ритуал вознесения Пути Плоти. \
		Принесите 4 трупа к руне трансмутации чтобы начать ритуал. \
		Когда ритуал будет завершён вы получите возможность отринуть вашу человеческую личину \
		дабы превратиться в Повелителя Ночи, крайне могущественное существо. \
		Во время превращения сердца окружающих вас неверных наполнятся страхом и они получат психологическую травму. \
		Находясь в форме Повелителя Ночи вы можете лечиться и становиться сильнее пожирая руки своих жертв. \
		Также теперь вы можете создать в три раза больше Гулей и Безмолвных Мертвецов, \
		кроме того вы можете создать сколько угодно Кровавых Клинков для того, чтобы вооружить их ими."
	gain_text = "Благодаря познаниям Маршала мои силы достигли пика. Трон ждет своего обладателя. \
		Услышьте же меня, жители мира сего, время пришло! Маршал ведет мою армию! \
		Реальность покорится ПОВЕЛИТЕЛЮ НОЧИ или будет уничтожена! УЗРИТЕ МОЁ ВОЗВЫШЕНИЕ!"
	required_atoms = list(/mob/living/carbon/human = 4)
	route = PATH_FLESH

/datum/heretic_knowledge/final/flesh_final/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	. = ..()
	priority_announce("[generate_heretic_text()] Вихрь усиливается. Реальность распадается. ТРЕПЕЩИТЕ, ИБО ПОВЕЛИТЕЛЬ НОЧИ, [user.real_name] возвысился! Страшитесь его карающей длани! [generate_heretic_text()]", "[generate_heretic_text()]", ANNOUNCER_SPANOMALIES)

	var/datum/action/cooldown/spell/shed_human_form/worm_spell = new(user.mind)
	worm_spell.Grant(user)

	user.client?.give_award(/datum/award/achievement/misc/flesh_ascension, user)

	var/datum/antagonist/heretic/heretic_datum = IS_HERETIC(user)
	var/datum/heretic_knowledge/limited_amount/flesh_grasp/grasp_ghoul = heretic_datum.get_knowledge(/datum/heretic_knowledge/limited_amount/flesh_grasp)
	grasp_ghoul.limit *= 3
	var/datum/heretic_knowledge/limited_amount/flesh_ghoul/ritual_ghoul = heretic_datum.get_knowledge(/datum/heretic_knowledge/limited_amount/flesh_ghoul)
	ritual_ghoul.limit *= 3
	var/datum/heretic_knowledge/limited_amount/starting/base_flesh/blade_ritual = heretic_datum.get_knowledge(/datum/heretic_knowledge/limited_amount/starting/base_flesh)
	blade_ritual.limit = 999

#undef GHOUL_MAX_HEALTH
#undef MUTE_MAX_HEALTH

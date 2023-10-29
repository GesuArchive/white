/**
 * # The path of Ash.
 *
 * Goes as follows:
 *
 * Nightwatcher's Secret
 * Grasp of Ash
 * Ashen Passage
 * > Sidepaths:
 *   Priest's Ritual
 *   Ashen Eyes
 *
 * Mark of Ash
 * Ritual of Knowledge
 * Mask of Madness
 * > Sidepaths:
 *   Curse of Corrosion
 *   Curse of Paralysis
 *
 * Fiery Blade
 * Nightwater's Rebirth
 * > Sidepaths:
 *   Ashen Ritual
 *   Rusted Ritual
 *
 * Ashlord's Rite
 */
/datum/heretic_knowledge/limited_amount/starting/base_ash
	name = "Секрет Ночного Стража"
	desc = "Открывает перед вами путь пепла. \
		Позволяет трансмутировать спичку и кухонный нож в Пепельный клинок. \
		Одновременно может быть лишь два клинка."
	gain_text = "Ночная стража знает своё дело. Если вы загляните к ним ночью, то они расскажут вам историю о пепельном фонаре."
	next_knowledge = list(/datum/heretic_knowledge/ashen_grasp)
	required_atoms = list(
		/obj/item/kitchen/knife = 1,
		/obj/item/match = 1,
	)
	result_atoms = list(/obj/item/melee/sickly_blade/ash)
	route = PATH_ASH

/datum/heretic_knowledge/limited_amount/starting/base_ash/on_research(mob/user)
	. = ..()
	var/datum/antagonist/heretic/our_heretic = IS_HERETIC(user)
	our_heretic.heretic_path = route

/datum/heretic_knowledge/ashen_grasp
	name = "Власть Пепла"
	desc = "Ваша хватка Мансуса опаляет глаза ваших жертв, нанося им урон и ослепляя их."
	gain_text = "Ночной Страж был первым среди достойных, и всё началось с его предательства. \
		Его фонарь обратился в пепел, его дозор завершился."
	next_knowledge = list(/datum/heretic_knowledge/spell/ash_passage)
	cost = 1
	route = PATH_ASH

/datum/heretic_knowledge/ashen_grasp/on_gain(mob/user)
	RegisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK, PROC_REF(on_mansus_grasp))

/datum/heretic_knowledge/ashen_grasp/on_lose(mob/user)
	UnregisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK)

/datum/heretic_knowledge/ashen_grasp/proc/on_mansus_grasp(mob/living/source, mob/living/target)
	SIGNAL_HANDLER

	if(target.is_blind())
		return

	if(!target.get_organ_slot(ORGAN_SLOT_EYES))
		return

	to_chat(target, span_danger("Ослепительно яркий зеленый свет сжигает ваши глаза!"))
	target.adjustOrganLoss(ORGAN_SLOT_EYES, 15)
	target.blur_eyes(10)

/datum/heretic_knowledge/spell/ash_passage
	name = "Пепельная Тропа"
	desc = "Позволяет вам использовать Пепельные Тропы, которые позволяют игнорировать материальные преграды на короткий промежуток времени."
	gain_text = "Ему были ведомы пути огибающие реальность."
	next_knowledge = list(
		/datum/heretic_knowledge/mark/ash_mark,
		/datum/heretic_knowledge/codex_cicatrix,
		/datum/heretic_knowledge/essence,
		/datum/heretic_knowledge/medallion,
	)
	spell_to_add = /datum/action/cooldown/spell/jaunt/ethereal_jaunt/ash
	cost = 1
	route = PATH_ASH

/datum/heretic_knowledge/mark/ash_mark
	name = "Метка Пепла"
	desc = "Ваша хватка Мансуса теперь так же накладывает и Метку Пепла. Метка активируется с помощью удара Пепельным клинком.  \
		Когда метка активируется, жертва страдает от урона по выносливости и жутких ожогов. После чего соседние цели так же помечаются. \
		С каждым последующим распространением от активации предыдущей метки урон уменьшается."
	gain_text = "Он был особенным человеком, смотрящим в самое сердце тьмы. \
		Однако будучи верным своему долгу, он всегда блуждал сквозь Манс высоко подняв свой яркий фонарь. \
		Он нёс свет во тьму, до тех пор пока фонарь не угас."
	next_knowledge = list(/datum/heretic_knowledge/knowledge_ritual/ash)
	route = PATH_ASH
	mark_type = /datum/status_effect/eldritch/ash

/datum/heretic_knowledge/mark/ash_mark/trigger_mark(mob/living/source, mob/living/target)
	. = ..()
	if(!.)
		return

	// Also refunds 75% of charge!
	var/datum/action/cooldown/spell/touch/mansus_grasp/grasp = locate() in source.actions
	if(grasp)
		grasp.next_use_time = min(round(grasp.next_use_time - grasp.cooldown_time * 0.75, 0), 0)
		grasp.build_all_button_icons()

/datum/heretic_knowledge/knowledge_ritual/ash
	next_knowledge = list(/datum/heretic_knowledge/mad_mask)
	route = PATH_ASH

/datum/heretic_knowledge/mad_mask
	name = "Маска безумия"
	desc = "Позволяет трансмутировать любую маску, четыре свечи, электрическую дубинку и печень в Маску безумия. \
		Маска вселяет страх в окружающих вас неверных, нанося им урон по их выносливости, а также вызывая галлюцинации и безумие. \
		Её также можно надеть на неверного, после чего тот уже не сможет её снять..."
	gain_text = "Ночной Страж пропал. Так подумала Стража. Но он всё ещё блуждал по миру, незримый для всех."
	next_knowledge = list(
		/datum/heretic_knowledge/blade_upgrade/ash,
		/datum/heretic_knowledge/reroll_targets,
		/datum/heretic_knowledge/curse/corrosion,
		/datum/heretic_knowledge/curse/paralysis,
	)
	required_atoms = list(
		/obj/item/organ/liver = 1,
		/obj/item/melee/baton = 1,  // Technically means a cattleprod is valid
		/obj/item/clothing/mask = 1,
		/obj/item/candle = 4,
	)
	result_atoms = list(/obj/item/clothing/mask/madness_mask)
	cost = 1
	route = PATH_ASH

/datum/heretic_knowledge/blade_upgrade/ash
	name = "Огненный клинок"
	desc = "Теперь атаки вашим клинком поджигают жертв."
	gain_text = "Он вернулся, с клинком в руке, покачивая им, покуда пепел падал с небес. \
		Его город, люди, которых он поклялся защищать... и дозор, который он нёс. Всё это сгорело до тла."
	next_knowledge = list(/datum/heretic_knowledge/spell/flame_birth)
	route = PATH_ASH

/datum/heretic_knowledge/blade_upgrade/ash/do_melee_effects(mob/living/source, mob/living/target, obj/item/melee/sickly_blade/blade)
	if(source == target)
		return

	target.adjust_fire_stacks(1)
	target.ignite_mob()

/datum/heretic_knowledge/spell/flame_birth
	name = "Возрождение Ночного Стража"
	desc = "Обучает вас Возрождению Ночного Стража, этот навык гасит огонь на вас и поджигает находящихся рядом с вами неверных. \
		Те, кто находятся в огне, лечат вас пропорционально количеству горящих. \
		Если же жертва находилась в критическом состоянии - она мгновенно умрет."
	gain_text = "Огонь уже было не остановить, но всё же, жизнь теплилась в его обугленном теле. \
		Ночной Страж был особенным человеком, смотрящим..."
	next_knowledge = list(
		/datum/heretic_knowledge/final/ash_final,
		/datum/heretic_knowledge/summon/ashy,
		/datum/heretic_knowledge/summon/rusty,
	)
	spell_to_add = /datum/action/cooldown/spell/aoe/fiery_rebirth
	cost = 1
	route = PATH_ASH

/datum/heretic_knowledge/final/ash_final
	name = "Ритуал Пепельного Лорда"
	desc = "Ритуал вознесения Пути Пепла. \
		Принесите 3 горящих трупа или хаска к руне трансмутации для начала ритуала. \
		Когда ритуал будет завершен, вы станете Предвестником Пламени, а также получите два навыка. \
		Каскад Огня, который раскаляет воздух вокруг вас, \
		и Клятву Пламени, создающую кольцо огня вокруг вас. \
		Вы также становитесь иммунны к урону от огня, давления, холода и другим эффектам окружающей вас среды."
	gain_text = "Его фонарь обратился в пепел, Ночной Страж сгорел вместе с ним. Но его пламя разгорится вновь, \
		во имя Ночного стража я завершу этот ритуал! Он продолжает наблюдать, и теперь я един с пламенем, \
		УЗРИТЕ ЖЕ МОЁ ВОЗНЕСЕНИЕ, ПЕПЕЛЬНЫЙ ФОНАРЬ ЗАЖЖЕТСЯ ВНОВЬ!"
	route = PATH_ASH
	/// A static list of all traits we apply on ascension.
	var/static/list/traits_to_apply = list(
		TRAIT_RESISTHEAT,
		TRAIT_NOBREATH,
		TRAIT_RESISTCOLD,
		TRAIT_RESISTHIGHPRESSURE,
		TRAIT_RESISTLOWPRESSURE,
		TRAIT_NOFIRE,
	)

/datum/heretic_knowledge/final/ash_final/is_valid_sacrifice(mob/living/carbon/human/sacrifice)
	. = ..()
	if(!.)
		return

	if(sacrifice.on_fire)
		return TRUE
	if(HAS_TRAIT_FROM(sacrifice, TRAIT_HUSK, BURN))
		return TRUE
	return FALSE

/datum/heretic_knowledge/final/ash_final/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	. = ..()
	priority_announce("[generate_heretic_text()] Бойтесь пламени, ибо Лорд Пепла, [user.real_name] возвысился! Пламя пожрет всё сущее! [generate_heretic_text()]","[generate_heretic_text()]", ANNOUNCER_SPANOMALIES)

	var/datum/action/cooldown/spell/fire_sworn/circle_spell = new(user.mind)
	circle_spell.Grant(user)

	var/datum/action/cooldown/spell/fire_cascade/big/screen_wide_fire_spell = new(user.mind)
	screen_wide_fire_spell.Grant(user)

	user.client?.give_award(/datum/award/achievement/misc/ash_ascension, user)
	for(var/trait in traits_to_apply)
		ADD_TRAIT(user, trait, MAGIC_TRAIT)

/**
 * # The path of VOID.
 *
 * Goes as follows:
 *
 * Glimmer of Winter
 * Grasp of Void
 * Aristocrat's Way
 * > Sidepaths:
 *   Void Cloak
 *   Shattered Ritual
 *
 * Mark of Void
 * Ritual of Knowledge
 * Void Phase
 * > Sidepaths:
 *   Carving Knife
 *   Blood Siphon
 *
 * Seeking blade
 * Void Pull
 * > Sidepaths:
 *   Cleave
 *   Maid in the Mirror
 *
 * Waltz at the End of Time
 */
/datum/heretic_knowledge/limited_amount/starting/base_void
	name = "Мерцание зимы"
	desc = "Открывает перед вами путь Пустоты. \
		Позволяет трансмутировать нож при минусовой температуре в Клинок Пустоты. \
		Одновременно у вас могут быть лишь два клинка."
	gain_text = "Я чувствую мерцание вокруг, воздух вокруг меня становится холоднее. \
		Я начинаю осознавать пустоту существования. Что-то наблюдает за мной."
	next_knowledge = list(/datum/heretic_knowledge/void_grasp)
	required_atoms = list(/obj/item/kitchen/knife = 1)
	result_atoms = list(/obj/item/melee/sickly_blade/void)
	route = PATH_VOID

/datum/heretic_knowledge/limited_amount/starting/base_void/on_research(mob/user)
	. = ..()
	var/datum/antagonist/heretic/our_heretic = IS_HERETIC(user)
	our_heretic.heretic_path = route

/datum/heretic_knowledge/limited_amount/starting/base_void/recipe_snowflake_check(mob/living/user, list/atoms, list/selected_atoms, turf/loc)
	if(!isopenturf(loc))
		loc.balloon_alert(user, "ритуал провален, неверная локация!")
		return FALSE

	var/turf/open/our_turf = loc
	if(our_turf.GetTemperature() > T0C)
		loc.balloon_alert(user, "ритуал провален, недостаточно холодно!")
		return FALSE

	return ..()

/datum/heretic_knowledge/void_grasp
	name = "Хватка Пустоты"
	desc = "Временно лишает жертву дара речи, а также снижает температуру ее тела."
	gain_text = "Я чувствую незримого наблюдателя, который смотрит за мной. Холод растет во мне. \
		Это лишь первый шаг в познании тайны."
	next_knowledge = list(/datum/heretic_knowledge/cold_snap)
	cost = 1
	route = PATH_VOID

/datum/heretic_knowledge/void_grasp/on_gain(mob/user)
	RegisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK, PROC_REF(on_mansus_grasp))

/datum/heretic_knowledge/void_grasp/on_lose(mob/user)
	UnregisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK)

/datum/heretic_knowledge/void_grasp/proc/on_mansus_grasp(mob/living/source, mob/living/target)
	SIGNAL_HANDLER

	if(!iscarbon(target))
		return

	var/mob/living/carbon/carbon_target = target
	var/turf/open/target_turf = get_turf(carbon_target)
	target_turf.TakeTemperature(-20)
	carbon_target.adjust_bodytemperature(-40)
	carbon_target.silent += 5

/datum/heretic_knowledge/cold_snap
	name = "Путь Аристократа"
	desc = "Делает вас невосприимчивым к низким температурам, и убирает потребность в дыхании. \
		Однако вы все еще можете получить урон от недостатка давления."
	gain_text = "Я нашел нить ледяного дыхания. Она привела меня в странное святилище, сплошь состоящее из кристаллов. \
		Полупрозачное, белоснежное изображение благородного человека стояло передо мной."
	next_knowledge = list(
		/datum/heretic_knowledge/mark/void_mark,
		/datum/heretic_knowledge/codex_cicatrix,
		/datum/heretic_knowledge/void_cloak,
		/datum/heretic_knowledge/limited_amount/risen_corpse,
	)
	cost = 1
	route = PATH_VOID

/datum/heretic_knowledge/cold_snap/on_gain(mob/user)
	ADD_TRAIT(user, TRAIT_RESISTCOLD, type)
	ADD_TRAIT(user, TRAIT_NOBREATH, type)

/datum/heretic_knowledge/cold_snap/on_lose(mob/user)
	REMOVE_TRAIT(user, TRAIT_RESISTCOLD, type)
	REMOVE_TRAIT(user, TRAIT_NOBREATH, type)

/datum/heretic_knowledge/mark/void_mark
	name = "Знак Пустоты"
	desc = "Ваша Хватка Мансуса теперь накладывает Метку Пустоты. Чтобы активировать метку, ударьте жертву Клинком Пустоты. \
		При срабатывании он заставляет жертву замолчать и значительно понижает температуру ее тела."
	gain_text = "Порыв ветра? Может быть, мерцание в воздухе. Его присутствие подавляет, \
		все мои чувства предали меня, мой разум - мой враг."
	next_knowledge = list(/datum/heretic_knowledge/knowledge_ritual/void)
	route = PATH_VOID
	mark_type = /datum/status_effect/eldritch/void

/datum/heretic_knowledge/knowledge_ritual/void
	next_knowledge = list(/datum/heretic_knowledge/spell/void_phase)
	route = PATH_VOID

/datum/heretic_knowledge/spell/void_phase
	name = "Пустотный сдвиг"
	desc = "Вы получаете рывок, позволяющий вам  \
		мгновенно телепортироваться в нужное место, нанося урон вокруг вас и выбранного вами места."
	gain_text = "Существо назвало себя Аристократом. Он легко проходят по воздуху, как \
		сквозь пустоту, оставляя за собой резкий холодный ветер. Он исчез, оставляв меня в снегу."
	next_knowledge = list(
		/datum/heretic_knowledge/blade_upgrade/void,
		/datum/heretic_knowledge/reroll_targets,
		/datum/heretic_knowledge/spell/blood_siphon,
		/datum/heretic_knowledge/rune_carver,
	)
	spell_to_add = /datum/action/cooldown/spell/pointed/void_phase
	cost = 1
	route = PATH_VOID

/datum/heretic_knowledge/blade_upgrade/void
	name = "Ищущий Клинок"
	desc = "Теперь вы можете использовать свой клинок на удаленной отмеченной цели, чтобы переместиться к ней и атаковать."
	gain_text = "Мимолетные воспоминания путь имеющий начало, но не имеющий конца. Я отмечаю свой путь кровью на снегу. Я не помню кто я и куда я иду"
	next_knowledge = list(/datum/heretic_knowledge/spell/void_pull)
	route = PATH_VOID

/datum/heretic_knowledge/blade_upgrade/void/do_ranged_effects(mob/living/user, mob/living/target, obj/item/melee/sickly_blade/blade)
	if(!target.has_status_effect(/datum/status_effect/eldritch))
		return

	var/dir = angle2dir(dir2angle(get_dir(user, target)) + 180)
	user.forceMove(get_step(target, dir))

	INVOKE_ASYNC(src, PROC_REF(follow_up_attack), user, target, blade)

/datum/heretic_knowledge/blade_upgrade/void/proc/follow_up_attack(mob/living/user, mob/living/target, obj/item/melee/sickly_blade/blade)
	blade.melee_attack_chain(user, target)

/datum/heretic_knowledge/spell/void_pull
	name = "Притяжение пустоты"
	desc = "Вы получаете способность, которая позволяет вам притягивать к себе окружающих вас людей и ненадолго оглушать их."
	gain_text = "Все мимолетно, но что еще остается? Я близок к завершению начатого. \
		Я снова видел Аристократа. Он сказал мне, что я опаздываю. Его тяга огромна, я не могу повернуть назад."
	next_knowledge = list(
		/datum/heretic_knowledge/final/void_final,
		/datum/heretic_knowledge/spell/cleave,
		/datum/heretic_knowledge/summon/maid_in_mirror,
	)
	spell_to_add = /datum/action/cooldown/spell/aoe/void_pull
	cost = 1
	route = PATH_VOID

/datum/heretic_knowledge/final/void_final
	name = "Вальс Конца Времен"
	desc = "Ритуал вознесения Пути Пустоты. \
		Принесите 3 трупа на руну начертанную при минусовой температуре, чтобы выполнить ритуал. \
		После завершения вызывает пустотную бурю \
		что окутывает станцию, замораживает и ранит язычников. Те, кто находится поблизости, замерзают ещё быстрее, а также теряют возможность говорить. \
		Кроме того, вы приобретете иммунитет к воздействию космоса."
	gain_text = "Мир погружается во тьму. Я стою на пороге пустоты, вокруг, мерцая острыми гранями, бушует ледяной шторм. \
		Передо мной стоит Аристократ, жестом приглашая меня станцевать. Мы сыграем вальс под шепот умирающей реальности, \
		пока мир разрушается на наших глазах. Пустота обратит все в ничто, СТАНЬТЕ СВИДЕТЕЛЕМ МОЕГО ВОЗНЕСЕНИЯ!"
	route = PATH_VOID
	///soundloop for the void theme
	var/datum/looping_sound/void_loop/sound_loop
	///Reference to the ongoing voidstrom that surrounds the heretic
	var/datum/weather/void_storm/storm

/datum/heretic_knowledge/final/void_final/recipe_snowflake_check(mob/living/user, list/atoms, list/selected_atoms, turf/loc)
	if(!isopenturf(loc))
		loc.balloon_alert(user, "ритуал провален, неверная локация!")
		return FALSE

	var/turf/open/our_turf = loc
	if(our_turf.GetTemperature() > T0C)
		loc.balloon_alert(user, "ритуал провален, недостаточно холодно!")
		return FALSE

	return ..()

/datum/heretic_knowledge/final/void_final/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	. = ..()
	priority_announce("[generate_heretic_text()] Аристократ пустоты [user.real_name] прибыл, станцуйте же с ним в Вальсе Конца Времён! [generate_heretic_text()]","[generate_heretic_text()]", ANNOUNCER_SPANOMALIES)
	user.client?.give_award(/datum/award/achievement/misc/void_ascension, user)
	ADD_TRAIT(user, TRAIT_RESISTLOWPRESSURE, MAGIC_TRAIT)

	// Let's get this show on the road!
	sound_loop = new(user, TRUE, TRUE)
	RegisterSignal(user, COMSIG_LIVING_LIFE, PROC_REF(on_life))
	RegisterSignal(user, COMSIG_LIVING_DEATH, PROC_REF(on_death))

/datum/heretic_knowledge/final/void_final/on_lose(mob/user)
	on_death() // Losing is pretty much dying. I think
	RegisterSignals(user, list(COMSIG_LIVING_LIFE, COMSIG_LIVING_DEATH))

/**
 * Signal proc for [COMSIG_LIVING_LIFE].
 *
 * Any non-heretics nearby the heretic ([source])
 * are constantly silenced and battered by the storm.
 *
 * Also starts storms in any area that doesn't have one.
 */
/datum/heretic_knowledge/final/void_final/proc/on_life(mob/living/source, delta_time, times_fired)
	SIGNAL_HANDLER

	for(var/mob/living/carbon/close_carbon in view(5, source))
		if(IS_HERETIC_OR_MONSTER(close_carbon))
			continue
		close_carbon.silent += 1
		close_carbon.adjust_bodytemperature(-20)

	var/turf/open/source_turf = get_turf(source)
	if(!isopenturf(source_turf))
		return
	source_turf.TakeTemperature(-20)

	var/area/source_area = get_area(source)

	if(!storm)
		storm = new /datum/weather/void_storm(list(source_turf.z))
		storm.telegraph()

	storm.area_type = source_area.type
	storm.impacted_areas = list(source_area)
	storm.update_areas()

/**
 * Signal proc for [COMSIG_LIVING_DEATH].
 *
 * Stop the storm when the heretic passes away.
 */
/datum/heretic_knowledge/final/void_final/proc/on_death()
	SIGNAL_HANDLER

	if(sound_loop)
		sound_loop.stop()
	if(storm)
		storm.end()
		QDEL_NULL(storm)

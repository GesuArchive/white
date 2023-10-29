#define PINPOINTER_MINIMUM_RANGE 15
#define PINPOINTER_EXTRA_RANDOM_RANGE 10
#define PINPOINTER_PING_TIME 40
#define PROB_ACTUAL_TRAITOR 20
#define TRAITOR_AGENT_ROLE "Агент Внутренних Дел Синдиката"

/datum/antagonist/traitor/internal_affairs
	name = "Агент Внутренних Дел"
	employer = "NanoTrasen"
	special_role = "агент внутренних дел"
	antagpanel_category = "IAA"
	var/syndicate = FALSE
	var/last_man_standing = FALSE
	var/list/datum/mind/targets_stolen
	greentext_reward = 15

/datum/antagonist/traitor/internal_affairs/proc/give_pinpointer()
	if(!owner)
		CRASH("Antag datum with no owner.")

	if(owner.current)
		owner.current.apply_status_effect(/datum/status_effect/agent_pinpointer)

/datum/antagonist/traitor/internal_affairs/apply_innate_effects()
	. = ..()

	if(!owner)
		CRASH("Antag datum with no owner.")

	if(owner.current)
		give_pinpointer(owner.current)

/datum/antagonist/traitor/internal_affairs/remove_innate_effects()
	. = ..()

	if(!owner)
		CRASH("Antag datum with no owner.")

	if(owner.current)
		owner.current.remove_status_effect(/datum/status_effect/agent_pinpointer)

/datum/antagonist/traitor/internal_affairs/on_gain()
	START_PROCESSING(SSprocessing, src)
	. = ..()
/datum/antagonist/traitor/internal_affairs/on_removal()
	STOP_PROCESSING(SSprocessing,src)
	. = ..()
/datum/antagonist/traitor/internal_affairs/process()
	iaa_process()

/datum/status_effect/agent_pinpointer
	id = "agent_pinpointer"
	duration = -1
	tick_interval = PINPOINTER_PING_TIME
	alert_type = /atom/movable/screen/alert/status_effect/agent_pinpointer
	var/minimum_range = PINPOINTER_MINIMUM_RANGE
	var/range_fuzz_factor = PINPOINTER_EXTRA_RANDOM_RANGE
	var/mob/scan_target = null
	var/range_mid = 8
	var/range_far = 16

/atom/movable/screen/alert/status_effect/agent_pinpointer
	name = "Указатель цели"
	desc = "Еще скрытнее, чем обычный имплант."
	icon = 'icons/obj/device.dmi'
	icon_state = "pinon"

/datum/status_effect/agent_pinpointer/proc/point_to_target() //If we found what we're looking for, show the distance and direction
	if(!scan_target)
		linked_alert.icon_state = "pinonnull"
		return
	var/turf/here = get_turf(owner)
	var/turf/there = get_turf(scan_target)
	if(here.z != there.z)
		linked_alert.icon_state = "pinonnull"
		return
	if(get_dist_euclidian(here,there)<=minimum_range + rand(0, range_fuzz_factor))
		linked_alert.icon_state = "pinondirect"
	else
		linked_alert.setDir(get_dir(here, there))
		var/dist = (get_dist(here, there))
		if(dist >= 1 && dist <= range_mid)
			linked_alert.icon_state = "pinonclose"
		else if(dist > range_mid && dist <= range_far)
			linked_alert.icon_state = "pinonmedium"
		else if(dist > range_far)
			linked_alert.icon_state = "pinonfar"

/datum/status_effect/agent_pinpointer/proc/scan_for_target()
	scan_target = null
	if(owner)
		if(owner.mind)
			for(var/datum/objective/objective_ in owner.mind.get_all_objectives())
				if(!is_internal_objective(objective_))
					continue
				var/datum/objective/assassinate/internal/objective = objective_
				var/mob/current = objective.target.current
				if(current&&current.stat!=DEAD)
					scan_target = current
				break

/datum/status_effect/agent_pinpointer/tick()
	if(!owner)
		qdel(src)
		return
	scan_for_target()
	point_to_target()


/proc/is_internal_objective(datum/objective/O)
	return (istype(O, /datum/objective/assassinate/internal)||istype(O, /datum/objective/destroy/internal))

/datum/antagonist/traitor/proc/replace_escape_objective()
	if(!owner)
		CRASH("Antag datum with no owner.")
	if(!objectives.len)
		return
	for (var/objective_ in objectives)
		if(!(istype(objective_, /datum/objective/escape)||istype(objective_, /datum/objective/survive)))
			continue
		remove_objective(objective_)

	var/datum/objective/martyr/martyr_objective = new
	martyr_objective.owner = owner
	add_objective(martyr_objective)

/datum/antagonist/traitor/proc/reinstate_escape_objective()
	if(!owner)
		CRASH("Antag datum with no owner.")
	if(!objectives.len)
		return
	for (var/objective_ in objectives)
		if(!istype(objective_, /datum/objective/martyr))
			continue
		remove_objective(objective_)

/datum/antagonist/traitor/internal_affairs/reinstate_escape_objective()
	..()
	var/objtype = traitor_kind == TRAITOR_HUMAN ? /datum/objective/escape : /datum/objective/survive
	var/datum/objective/escape_objective = new objtype
	escape_objective.owner = owner
	add_objective(escape_objective)

/datum/antagonist/traitor/internal_affairs/proc/steal_targets(datum/mind/victim)
	if(!owner.current||owner.current.stat==DEAD)
		return
	to_chat(owner.current, span_userdanger("Цель ликвидирована: [victim.name]"))
	for(var/objective_ in victim.get_all_objectives())
		if(istype(objective_, /datum/objective/assassinate/internal))
			var/datum/objective/assassinate/internal/objective = objective_
			if(objective.target==owner)
				continue
			else if(targets_stolen.Find(objective.target) == 0)
				var/datum/objective/assassinate/internal/new_objective = new
				new_objective.owner = owner
				new_objective.target = objective.target
				new_objective.update_explanation_text()
				add_objective(new_objective)
				targets_stolen += objective.target
				var/status_text = objective.check_completion() ? "нейтрализована" : "жива"
				to_chat(owner.current, span_userdanger("Новая цель внесена в базу данных: [objective.target.name] ([status_text])"))
		else if(istype(objective_, /datum/objective/destroy/internal))
			var/datum/objective/destroy/internal/objective = objective_
			var/datum/objective/destroy/internal/new_objective = new
			if(objective.target==owner)
				continue
			else if(targets_stolen.Find(objective.target) == 0)
				new_objective.owner = owner
				new_objective.target = objective.target
				new_objective.update_explanation_text()
				add_objective(new_objective)
				targets_stolen += objective.target
				var/status_text = objective.check_completion() ? "нейтрализована" : "жива"
				to_chat(owner.current, span_userdanger("Новая цель внесена в базу данных: [objective.target.name] ([status_text])"))
	last_man_standing = TRUE
	for(var/objective_ in objectives)
		if(!is_internal_objective(objective_))
			continue
		var/datum/objective/assassinate/internal/objective = objective_
		if(!objective.check_completion())
			last_man_standing = FALSE
			return
	if(last_man_standing)
		if(syndicate)
			to_chat(owner.current,span_userdanger("Все лояльные агенты мертвы, и вы больше не нуждаетесь в чём-либо. Умрите славной смертью!"))
		else
			to_chat(owner.current,span_userdanger("Все остальные агенты мертвы, и вы остались одни. Организуйте террористическую атаку Синдиката, чтобы сокрыть сегодняшние события этой смены. У вас больше не имеется ограничений на ущерб корпорации."))
		replace_escape_objective(owner)

/datum/antagonist/traitor/internal_affairs/proc/iaa_process()
	if(!owner)
		CRASH("Antag datum with no owner.")
	if(owner.current && owner.current.stat != DEAD)
		for(var/objective_ in objectives)
			if(!is_internal_objective(objective_))
				continue
			var/datum/objective/assassinate/internal/objective = objective_
			if(!objective.target)
				continue
			if(objective.check_completion())
				if(objective.stolen)
					continue
				else
					steal_targets(objective.target)
					objective.stolen = TRUE
			else
				if(objective.stolen)
					var/fail_msg = span_userdanger("Ваши сенсоры говорят, что ваша цель - [objective.target.current.real_name], которую необходимо ликвидировать, всё еще жива! Выполните свою работу тщательнее!")
					if(last_man_standing)
						if(syndicate)
							fail_msg += span_userdanger(" У вас больше нет права на смерть. ")
						else
							fail_msg += span_userdanger(" Остались свидетели!</font><B><font size=5 color=red> Немедленно прекратите любые террористические действия, вредящие имуществу NanoTrasen или приводящие к гибели сотрудников! В противном случае это приведёт к расторжению контракта.")
						reinstate_escape_objective(owner)
						last_man_standing = FALSE
					to_chat(owner.current, fail_msg)
					objective.stolen = FALSE

/datum/antagonist/traitor/internal_affairs/proc/forge_iaa_objectives()
	if(SSticker.mode.target_list.len && SSticker.mode.target_list[owner]) // Is a double agent
		// Assassinate
		var/datum/mind/target_mind = SSticker.mode.target_list[owner]
		if(issilicon(target_mind.current))
			var/datum/objective/destroy/internal/destroy_objective = new
			destroy_objective.owner = owner
			destroy_objective.target = target_mind
			destroy_objective.update_explanation_text()
			add_objective(destroy_objective)
		else
			var/datum/objective/assassinate/internal/kill_objective = new
			kill_objective.owner = owner
			kill_objective.target = target_mind
			kill_objective.update_explanation_text()
			add_objective(kill_objective)

		//Optional traitor objective
		if(prob(PROB_ACTUAL_TRAITOR))
			employer = "Синдикат"
			owner.special_role = TRAITOR_AGENT_ROLE
			special_role = TRAITOR_AGENT_ROLE
			syndicate = TRUE
			forge_single_objective()

/datum/antagonist/traitor/internal_affairs/forge_traitor_objectives()
	forge_iaa_objectives()

	var/objtype = traitor_kind == TRAITOR_HUMAN ? /datum/objective/escape : /datum/objective/survive
	var/datum/objective/escape_objective = new objtype
	escape_objective.owner = owner
	add_objective(escape_objective)

/datum/antagonist/traitor/internal_affairs/proc/greet_iaa()
	var/crime = pick(
		"распространении контрабанды",
		"несанкционированных эротических действий при исполнении служебных обязанностей",
		"растратах бюджета",
		"пьяном пилотировании",
		"дезертирстве",
		"участии в организованной преступной группировке",
		"мятеже",
		"массовых убийствах",
		"шпионаже",
		"получении взяток",
		"злоупотреблении должностными полномочиями",
		"боготворении иных форм жизни",
		"владении запрещенной литературой",
		"убийстве",
		"поджоге",
		"оскорблении её менеджера",
		"крупной краже",
		"заговоре",
		"попытке в объединении профсоюзов",
		"вандализме",
		"ужасном некомпетенции",
	)

	if(syndicate)
		to_chat(owner.current, span_userdanger("Вы внутренний агент Синдиката."))
		to_chat(owner.current, span_userdanger("Ваша цель обвиняется в [crime], и вам было поручено ликвидировать её для предотвращения защиты цели в суде."))
		to_chat(owner.current, "<B><font size=5 color=red>Любой ущерб, который вы причините, станет позором для NanoTrasen, поэтому у вас не имеется ограничений на вред станции.</font></B>")
		to_chat(owner.current, span_userdanger("Вам был предоставлен стандартный аплинк для успешного выполнения вашей задачи."))
	else
		to_chat(owner.current, span_userdanger("Вы внутренний агент NanoTrasen."))
		to_chat(owner.current, span_userdanger("Ваша цель подозревается в [crime], и вам было поручено ликвидировать её любой ценой, чтобы избежать дальнейшей разборки в крайне затратном и позорным для корпорации суде."))
		to_chat(owner.current, "<B><font size=5 color=red>В то время, как у вас имеется лицензия на убийство цели, нежелательный материальный ущерб или гибель сотрудников NT приведут к расторжению контракта с Вами.</font></B>")
		to_chat(owner.current, span_userdanger("Ради правдоподобного отрицания и прикрытия, вам был предоставлен трофейный аплинк Синдиката."))

	to_chat(owner.current, span_userdanger("Будьте предельно аккуратны и осторожными. У вашей цели есть весьма серьёзные связи, и наши разведданные предполагают, что кто-то мог заключить контракт на обеспечение защиты для неё."))
	owner.announce_objectives()

/datum/antagonist/traitor/internal_affairs/greet()
	greet_iaa()

#undef PROB_ACTUAL_TRAITOR
#undef PINPOINTER_EXTRA_RANDOM_RANGE
#undef PINPOINTER_MINIMUM_RANGE
#undef PINPOINTER_PING_TIME

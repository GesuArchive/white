/*
Abilities that can be purchased by disease mobs. Most are just passive symptoms that will be
added to their disease, but some are active abilites that affect only the target the overmind
is currently following.
*/

GLOBAL_LIST_INIT(disease_ability_singletons, list(
new /datum/disease_ability/action/cough,
new /datum/disease_ability/action/sneeze,
new /datum/disease_ability/action/infect,
new /datum/disease_ability/symptom/mild/cough,
new /datum/disease_ability/symptom/mild/sneeze,
new /datum/disease_ability/symptom/medium/shedding,
new /datum/disease_ability/symptom/medium/beard,
new /datum/disease_ability/symptom/medium/hallucigen,
new /datum/disease_ability/symptom/medium/choking,
new /datum/disease_ability/symptom/medium/confusion,
new /datum/disease_ability/symptom/medium/vomit,
new /datum/disease_ability/symptom/medium/voice_change,
new /datum/disease_ability/symptom/medium/visionloss,
new /datum/disease_ability/symptom/medium/deafness,
new /datum/disease_ability/symptom/powerful/narcolepsy,
new /datum/disease_ability/symptom/medium/fever,
new /datum/disease_ability/symptom/medium/shivering,
new /datum/disease_ability/symptom/medium/headache,
new /datum/disease_ability/symptom/medium/nano_boost,
new /datum/disease_ability/symptom/medium/nano_destroy,
new /datum/disease_ability/symptom/medium/viraladaptation,
new /datum/disease_ability/symptom/medium/viralevolution,
new /datum/disease_ability/symptom/medium/disfiguration,
new /datum/disease_ability/symptom/medium/polyvitiligo,
new /datum/disease_ability/symptom/medium/itching,
new /datum/disease_ability/symptom/medium/heal/weight_loss,
new /datum/disease_ability/symptom/medium/heal/sensory_restoration,
new /datum/disease_ability/symptom/medium/heal/mind_restoration,
new /datum/disease_ability/symptom/powerful/fire,
new /datum/disease_ability/symptom/powerful/flesh_eating,
new /datum/disease_ability/symptom/powerful/genetic_mutation,
new /datum/disease_ability/symptom/powerful/inorganic_adaptation,
new /datum/disease_ability/symptom/powerful/heal/starlight,
new /datum/disease_ability/symptom/powerful/heal/oxygen,
new /datum/disease_ability/symptom/powerful/heal/chem,
new /datum/disease_ability/symptom/powerful/heal/metabolism,
new /datum/disease_ability/symptom/powerful/heal/dark,
new /datum/disease_ability/symptom/powerful/heal/water,
new /datum/disease_ability/symptom/powerful/heal/plasma,
new /datum/disease_ability/symptom/powerful/heal/radiation,
new /datum/disease_ability/symptom/powerful/heal/coma,
new /datum/disease_ability/symptom/powerful/youth
))

/datum/disease_ability
	var/name
	var/cost = 0
	var/required_total_points = 0
	var/start_with = FALSE
	var/short_desc = ""
	var/long_desc = ""
	var/stat_block = ""
	var/threshold_block = list()
	var/category = ""

	var/list/symptoms
	var/list/actions

/datum/disease_ability/New()
	..()
	if(symptoms)
		var/stealth = 0
		var/resistance = 0
		var/stage_speed = 0
		var/transmittable = 0
		for(var/T in symptoms)
			var/datum/symptom/S = T
			stealth += initial(S.stealth)
			resistance += initial(S.resistance)
			stage_speed += initial(S.stage_speed)
			transmittable += initial(S.transmittable)
			threshold_block += initial(S.threshold_descs)
			stat_block = "Сопротивление: [resistance]<br>Скрытность: [stealth]<br>Скорость распостранения: [stage_speed]<br>Способность к передаче: [transmittable]<br><br>"
			if(symptoms.len == 1) //lazy boy's dream
				name = initial(S.name)
				if(short_desc == "")
					short_desc = initial(S.desc)
				if(long_desc == "")
					long_desc = initial(S.desc)

/datum/disease_ability/proc/CanBuy(mob/camera/disease/D)
	if(world.time < D.next_adaptation_time)
		return FALSE
	if(!D.unpurchased_abilities[src])
		return FALSE
	return (D.points >= cost) && (D.total_points >= required_total_points)

/datum/disease_ability/proc/Buy(mob/camera/disease/D, silent = FALSE, trigger_cooldown = TRUE)
	if(!silent)
		to_chat(D, span_notice("Адаптировано [name]."))
	D.points -= cost
	D.unpurchased_abilities -= src
	if(trigger_cooldown)
		D.adapt_cooldown()
	D.purchased_abilities[src] = TRUE
	for(var/V in (D.disease_instances+D.disease_template))
		var/datum/disease/advance/sentient_disease/SD = V
		if(symptoms)
			for(var/T in symptoms)
				var/datum/symptom/S = new T()
				SD.symptoms += S
				S.OnAdd(SD)
				if(SD.processing)
					if(S.Start(SD))
						S.next_activation = world.time + rand(S.symptom_delay_min * 10, S.symptom_delay_max * 10)
			SD.Refresh()
	for(var/T in actions)
		var/datum/action/A = new T()
		A.Grant(D)


/datum/disease_ability/proc/CanRefund(mob/camera/disease/D)
	if(world.time < D.next_adaptation_time)
		return FALSE
	return D.purchased_abilities[src]

/datum/disease_ability/proc/Refund(mob/camera/disease/D, silent = FALSE, trigger_cooldown = TRUE)
	if(!silent)
		to_chat(D, span_notice("Деградировало [name]."))
	D.points += cost
	D.unpurchased_abilities[src] = TRUE
	if(trigger_cooldown)
		D.adapt_cooldown()
	D.purchased_abilities -= src
	for(var/V in (D.disease_instances+D.disease_template))
		var/datum/disease/advance/sentient_disease/SD = V
		if(symptoms)
			for(var/T in symptoms)
				var/datum/symptom/S = locate(T) in SD.symptoms
				if(S)
					SD.symptoms -= S
					S.OnRemove(SD)
					if(SD.processing)
						S.End(SD)
					qdel(S)
			SD.Refresh()
	for(var/T in actions)
		var/datum/action/A = locate(T) in D.actions
		qdel(A)

//these sybtypes are for conveniently separating the different categories, they have no unique code.

/datum/disease_ability/action
	category = "Active"

/datum/disease_ability/symptom
	category = "Symptom"

//active abilities and their associated actions

/datum/disease_ability/action/cough
	name = "Вынужденный кашель"
	actions = list(/datum/action/cooldown/disease_cough)
	cost = 0
	required_total_points = 0
	start_with = TRUE
	short_desc = "Заставьте носителя, за которым вы следите, кашлять, распространяя вашу инфекцию на тех, кто находится поблизости."
	long_desc = " Заставьте носителя, за которым вы следите, кашлять с особой силой, распространяя вашу инфекцию на тех, кто находится в радиусе двух метров от вашего зараженного, даже при низкой степени вирулентности.<br>Перезарядка: 10 секунд"


/datum/action/cooldown/disease_cough
	name = "Кашель"
	button_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	button_icon_state = "cough"
	desc = "Заставьте носителя, за которым вы следите, кашлять с особой силой, распространяя вашу инфекцию на тех, кто находится в радиусе двух метров от вашего зараженного, даже при низкой степени вирулентности.<br>Перезарядка: 10 секунд"
	cooldown_time = 100
	click_to_activate = TRUE

/datum/action/cooldown/disease_cough/Trigger(trigger_flags)
	if(!..())
		return FALSE
	var/mob/camera/disease/D = owner
	var/mob/living/L = D.following_host
	if(!L)
		return FALSE
	if(L.stat != CONSCIOUS)
		to_chat(D, span_warning("Чтобы кашлять, заражённый должен быть в сознании."))
		return FALSE
	to_chat(D, span_notice("Заставляю [L.real_name] кашлять."))
	L.emote("cough")
	if(L.CanSpreadAirborneDisease()) //don't spread germs if they covered their mouth
		var/datum/disease/advance/sentient_disease/SD = D.hosts[L]
		SD.spread(2)
	StartCooldown()
	return TRUE


/datum/disease_ability/action/sneeze
	name = "Вынужденное Чихание"
	actions = list(/datum/action/cooldown/disease_sneeze)
	cost = 2
	required_total_points = 3
	short_desc = "Заставьте заражённого, за которым вы следите, чихнуть, распространяя вашу инфекцию на тех, кто находится перед ними."
	long_desc = "Заставьте заражённого, за которым вы следуете, чихать с особой силой, распространяя вашу инфекцию на множество жертв в 4-метровом конусе перед вашим носителем.<br>Перезарядка: 20 секунд"

/datum/action/cooldown/disease_sneeze
	name = "Чихание"
	button_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	button_icon_state = "sneeze"
	desc = "Заставьте заражённого, за которым вы следуете, чихать с особой силой, распространяя вашу инфекцию на множество жертв в 4-метровом конусе перед вашим носителем, даже при низкой степени вирулентности.<br>Перезарядка: 20 секунд"
	cooldown_time = 200
	click_to_activate = TRUE

/datum/action/cooldown/disease_sneeze/Trigger(trigger_flags)
	if(!..())
		return FALSE
	var/mob/camera/disease/D = owner
	var/mob/living/L = D.following_host
	if(!L)
		return FALSE
	if(L.stat != CONSCIOUS)
		to_chat(D, span_warning("Чтобы чихать, заражённый должен быть в сознании."))
		return FALSE
	to_chat(D, span_notice("Заставляю [L.real_name] чихать."))
	L.emote("sneeze")
	if(L.CanSpreadAirborneDisease()) //don't spread germs if they covered their mouth
		var/datum/disease/advance/sentient_disease/SD = D.hosts[L]

		for(var/mob/living/M in oview(4, SD.affected_mob))
			if(is_source_facing_target(SD.affected_mob, M) && disease_air_spread_walk(get_turf(SD.affected_mob), get_turf(M)))
				M.AirborneContractDisease(SD, TRUE)

	StartCooldown()
	return TRUE


/datum/disease_ability/action/infect
	name = "Контактное заражение"
	actions = list(/datum/action/cooldown/disease_infect)
	cost = 2
	required_total_points = 3
	short_desc = "Выделить из тела заражённого, часть вируса, чтобы все объекты, к которым прикасается ваш носитель, стали заразными в течение ограниченного времени, распространяя вашу инфекцию на всех, кто к ним прикасается."
	long_desc = "Заставьте носителя, за которым вы следите, выделять инфекционное вещество из своих пор, в результате чего все предметы, соприкасающиеся с их кожей, передадут вашу инфекцию любому, кто прикоснется к ним в течение следующих 30 секунд. Это включает в себя пол, если на них нет обуви, и любые предметы, которые они держат в руках, если на них нет перчаток.<br>Перезарядка: 40 секунд"

/datum/action/cooldown/disease_infect
	name = "Контактное заражение"
	button_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	button_icon_state = "infect"
	desc = "Заставьте носителя, за которым вы следите, выделять инфекционное вещество из своих пор, в результате чего все предметы, соприкасающиеся с их кожей, передадут вашу инфекцию любому, кто прикоснется к ним в течение следующих 30 секунд.<br>Перезарядка: 40 секунд"
	cooldown_time = 400
	click_to_activate = TRUE

/datum/action/cooldown/disease_infect/Trigger(trigger_flags)
	if(!..())
		return FALSE
	var/mob/camera/disease/D = owner
	var/mob/living/carbon/human/H = D.following_host
	if(!H)
		return FALSE
	for(var/V in H.get_equipped_items(FALSE))
		var/obj/O = V
		O.AddComponent(/datum/component/infective, D.disease_template, 300)
	//no shoes? infect the floor.
	if(!H.shoes)
		var/turf/T = get_turf(H)
		if(T && !isspaceturf(T))
			T.AddComponent(/datum/component/infective, D.disease_template, 300)
	//no gloves? infect whatever we are holding.
	if(!H.gloves)
		for(var/V in H.held_items)
			if(!V)
				continue
			var/obj/O = V
			O.AddComponent(/datum/component/infective, D.disease_template, 300)
	StartCooldown()
	return TRUE

/*******************BASE SYMPTOM TYPES*******************/
// cost is for convenience and can be changed. If you're changing req_tot_points then don't use the subtype...
//healing costs more so you have to techswitch from naughty disease otherwise we'd have friendly disease for easy greentext (no fun!)

/datum/disease_ability/symptom/mild
	cost = 2
	required_total_points = 4
	category = "Симптом (Слабый)"

/datum/disease_ability/symptom/medium
	cost = 4
	required_total_points = 8
	category = "Симптом"

/datum/disease_ability/symptom/medium/heal
	cost = 5
	category = "Симптом (+)"

/datum/disease_ability/symptom/powerful
	cost = 4
	required_total_points = 16
	category = "Симптом (Сильный)"

/datum/disease_ability/symptom/powerful/heal
	cost = 8
	category = "Симптом (Сильный+)"

/******MILD******/

/datum/disease_ability/symptom/mild/cough
	name = "Непроизвольный Кашель"
	symptoms = list(/datum/symptom/cough)
	short_desc = "Заставляет жертв периодически кашлять."
	long_desc = "Заставляет жертв периодически кашлять, распространяя вашу инфекцию."

/datum/disease_ability/symptom/mild/sneeze
	name = "Непроизвольное Чихание"
	symptoms = list(/datum/symptom/sneeze)
	short_desc = "Заставляет жертв периодически чихать."
	long_desc = "Заставляет жертв периодически чихать, распространяя вашу инфекцию, а также увеличивая вероятность передачи и устойчивость за счет скрытности."

/******MEDIUM******/

/datum/disease_ability/symptom/medium/shedding
	symptoms = list(/datum/symptom/shedding)

/datum/disease_ability/symptom/medium/beard
	symptoms = list(/datum/symptom/beard)
	short_desc = "Заставить всех жертв отрастить роскошную бороду."
	long_desc = "Заставь всех жертв отрастить роскошную бороду. Неэффективен против Деда Мороза."

/datum/disease_ability/symptom/medium/hallucigen
	symptoms = list(/datum/symptom/hallucigen)
	short_desc = "Вызывают у жертв галлюцинации."
	long_desc = "Вызывают у жертв галлюцинации. Уменьшает характеристики, особенно сопротивление."

/datum/disease_ability/symptom/medium/choking
	symptoms = list(/datum/symptom/choking)
	short_desc = "Заставляют жертв задыхаться."
	long_desc = "Заставляют жертв задыхаться, угрожая удушьем. Уменьшает характеристики, особенно способность к передаче."

/datum/disease_ability/symptom/medium/confusion
	symptoms = list(/datum/symptom/confusion)
	short_desc = "Дезориентирует жертву."
	long_desc = "Периодически дезориентирует жертву."

/datum/disease_ability/symptom/medium/vomit
	symptoms = list(/datum/symptom/vomit)
	short_desc = "Вызывает у жертвы рвоту."
	long_desc = "Вызывают у жертвы рвоту. Незначительно увеличивает передаваемость. Рвота также приводит к тому, что жертвы теряют питание и устраняют некоторые повреждения от токсинов."

/datum/disease_ability/symptom/medium/voice_change
	symptoms = list(/datum/symptom/voice_change)
	short_desc = "Изменяет голос жертвы."
	long_desc = "Изменять голос жертвы, вызывая путаницу в общении."

/datum/disease_ability/symptom/medium/visionloss
	symptoms = list(/datum/symptom/visionloss)
	short_desc = "Повреждает глаза жертвы, в конечном итоге вызывая слепоту."
	long_desc = "Повреждает глаза жертвы, в конечном итоге вызывая слепоту. Уменьшает все характеристики."

/datum/disease_ability/symptom/medium/deafness
	symptoms = list(/datum/symptom/deafness)

/datum/disease_ability/symptom/medium/fever
	symptoms = list(/datum/symptom/fever)

/datum/disease_ability/symptom/medium/shivering
	symptoms = list(/datum/symptom/shivering)

/datum/disease_ability/symptom/medium/headache
	symptoms = list(/datum/symptom/headache)

/datum/disease_ability/symptom/medium/nano_boost
	symptoms = list(/datum/symptom/nano_boost)

/datum/disease_ability/symptom/medium/nano_destroy
	symptoms = list(/datum/symptom/nano_destroy)

/datum/disease_ability/symptom/medium/viraladaptation
	symptoms = list(/datum/symptom/viraladaptation)
	short_desc = "Сделать вашу инфекцию более устойчивой к обнаружению и исцелению."
	long_desc = "Заставьте вашу инфекцию имитировать функцию нормальных клеток организма, что значительно затруднит обнаружение и исцеление, но снизит ее скорость распространения."

/datum/disease_ability/symptom/medium/viralevolution
	symptoms = list(/datum/symptom/viralevolution)

/datum/disease_ability/symptom/medium/polyvitiligo
	symptoms = list(/datum/symptom/polyvitiligo)

/datum/disease_ability/symptom/medium/disfiguration
	symptoms = list(/datum/symptom/disfiguration)

/datum/disease_ability/symptom/medium/itching
	symptoms = list(/datum/symptom/itching)
	short_desc = "Вызывают у жертвы зуд."
	long_desc = "Вызывает у жертвы зуд, увеличивая все характеристики, кроме скрытности."

/datum/disease_ability/symptom/medium/heal/weight_loss
	symptoms = list(/datum/symptom/weight_loss)
	short_desc = "Ускоряет метаболизм заражённых, вынуждая их менее эффективно перерабатывать питательные вещества и голодать."
	long_desc = "Ускоряет метаболизм заражённых, вынуждая их менее эффективно перерабатывать питательные вещества и голодать. Недостаточное питание позволяет вашей инфекции легче распространяться от носителей, особенно при чихании."

/datum/disease_ability/symptom/medium/heal/sensory_restoration
	symptoms = list(/datum/symptom/sensory_restoration)
	short_desc = "Ускоряет восстановление глаз и ушей у инфицированных людей."
	long_desc = "Ускоряет восстановление глаз и ушей у инфицированных людей."

/datum/disease_ability/symptom/medium/heal/mind_restoration
	symptoms = list(/datum/symptom/mind_restoration)

/******POWERFUL******/

/datum/disease_ability/symptom/powerful/fire
	symptoms = list(/datum/symptom/fire)

/datum/disease_ability/symptom/powerful/flesh_eating
	symptoms = list(/datum/symptom/flesh_eating)

/datum/disease_ability/symptom/powerful/genetic_mutation
	symptoms = list(/datum/symptom/genetic_mutation)
	cost = 8

/datum/disease_ability/symptom/powerful/inorganic_adaptation
	symptoms = list(/datum/symptom/inorganic_adaptation)

/datum/disease_ability/symptom/powerful/narcolepsy
	symptoms = list(/datum/symptom/narcolepsy)

/datum/disease_ability/symptom/powerful/youth
	symptoms = list(/datum/symptom/youth)
	short_desc = "Улучшает генетическую структуру и процесс обновления клеток, тем самым дарую носителю вечную молодость."
	long_desc = "Улучшает генетическую структуру и процесс обновления клеток, тем самым дарую носителю вечную молодость. Обеспечивает повышение всех характеристик, кроме способности к передаче."

/****HEALING SUBTYPE****/

/datum/disease_ability/symptom/powerful/heal/starlight
	symptoms = list(/datum/symptom/heal/starlight)

/datum/disease_ability/symptom/powerful/heal/oxygen
	symptoms = list(/datum/symptom/oxygen)

/datum/disease_ability/symptom/powerful/heal/chem
	symptoms = list(/datum/symptom/heal/chem)

/datum/disease_ability/symptom/powerful/heal/metabolism
	symptoms = list(/datum/symptom/heal/metabolism)
	short_desc = "Увеличивают метаболизм заражённых, заставляя их перерабатывать химические вещества и быстрее голодать."
	long_desc = "Увеличивают метаболизм заражённых, заставляя их перерабатывать химические вещества в два раза быстрее и быстрее испытывать голод."

/datum/disease_ability/symptom/powerful/heal/dark
	symptoms = list(/datum/symptom/heal/darkness)

/datum/disease_ability/symptom/powerful/heal/water
	symptoms = list(/datum/symptom/heal/water)

/datum/disease_ability/symptom/powerful/heal/plasma
	symptoms = list(/datum/symptom/heal/plasma)

/datum/disease_ability/symptom/powerful/heal/radiation
	symptoms = list(/datum/symptom/heal/radiation)

/datum/disease_ability/symptom/powerful/heal/coma
	symptoms = list(/datum/symptom/heal/coma)
	short_desc = "При тяжелых ранениях вынуждает заражённых впадать в коматозное состояние неотличимое от смерти, во время которого все силы организма мобилизуются для восстановления."
	long_desc = "При тяжелых ранениях вынуждает заражённых впадать в коматозное состояние неотличимое от смерти, во время которого все силы организма мобилизуются для восстановления."

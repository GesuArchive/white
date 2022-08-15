/datum/disease/transformation
	name = "Трансформация"
	max_stages = 5
	spread_text = "Проникновение"
	spread_flags = DISEASE_SPREAD_SPECIAL
	cure_text = "Любовь кодера (возможно)."
	agent = "Шенаниганы"
	viable_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/alien, /mob/living/carbon/human/species/monkey)
	severity = DISEASE_SEVERITY_BIOHAZARD
	stage_prob = 5
	visibility_flags = HIDDEN_SCANNER|HIDDEN_PANDEMIC
	disease_flags = CURABLE
	var/list/stage1 = list("Чувствую себя непримечательно.")
	var/list/stage2 = list("Мне хочется что-то делать.")
	var/list/stage3 = list("Чувствую равнодушие.")
	var/list/stage4 = list("Чувствую белый хлеб.")
	var/list/stage5 = list("О, человечество!")
	var/new_form = /mob/living/carbon/human
	var/bantype
	var/transformed_antag_datum //Do we add a specific antag datum once the transformation is complete?

/datum/disease/transformation/Copy()
	var/datum/disease/transformation/D = ..()
	D.stage1 = stage1.Copy()
	D.stage2 = stage2.Copy()
	D.stage3 = stage3.Copy()
	D.stage4 = stage4.Copy()
	D.stage5 = stage5.Copy()
	D.new_form = D.new_form
	return D


/datum/disease/transformation/stage_act(delta_time, times_fired)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(1)
			if (stage1 && DT_PROB(stage_prob, delta_time))
				to_chat(affected_mob, pick(stage1))
		if(2)
			if (stage2 && DT_PROB(stage_prob, delta_time))
				to_chat(affected_mob, pick(stage2))
		if(3)
			if (stage3 && DT_PROB(stage_prob * 2, delta_time))
				to_chat(affected_mob, pick(stage3))
		if(4)
			if (stage4 && DT_PROB(stage_prob * 2, delta_time))
				to_chat(affected_mob, pick(stage4))
		if(5)
			do_disease_transformation(affected_mob)


/datum/disease/transformation/proc/do_disease_transformation(mob/living/affected_mob)
	if(istype(affected_mob, /mob/living/carbon) && affected_mob.stat != DEAD)
		if(stage5)
			to_chat(affected_mob, pick(stage5))
		if(QDELETED(affected_mob))
			return
		if(affected_mob.notransform)
			return
		affected_mob.notransform = 1
		for(var/obj/item/W in affected_mob.get_equipped_items(TRUE))
			affected_mob.dropItemToGround(W)
		for(var/obj/item/I in affected_mob.held_items)
			affected_mob.dropItemToGround(I)
		var/mob/living/new_mob = new new_form(affected_mob.loc)
		if(istype(new_mob))
			if(bantype && is_banned_from(affected_mob.ckey, bantype))
				replace_banned_player(new_mob)
			new_mob.a_intent = INTENT_HARM
			if(affected_mob.mind)
				affected_mob.mind.transfer_to(new_mob)
			else
				new_mob.key = affected_mob.key
		if(transformed_antag_datum)
			new_mob.mind.add_antag_datum(transformed_antag_datum)
		new_mob.name = affected_mob.real_name
		new_mob.real_name = new_mob.name
		qdel(affected_mob)

/datum/disease/transformation/proc/replace_banned_player(mob/living/new_mob) // This can run well after the mob has been transferred, so need a handle on the new mob to kill it if needed.
	set waitfor = FALSE

	var/list/mob/dead/observer/candidates = poll_candidates_for_mob("Хочешь быть [affected_mob.real_name]?", bantype, null, 50, affected_mob)
	if(LAZYLEN(candidates))
		var/mob/dead/observer/C = pick(candidates)
		to_chat(affected_mob, span_userdanger("Тело захватил призрак! Подай апелляцию, если хочешь избежать этого в будущем!"))
		message_admins("[key_name_admin(C)] has taken control of ([key_name_admin(affected_mob)]) to replace a jobbanned player.")
		affected_mob.ghostize(0)
		affected_mob.key = C.key
	else
		to_chat(new_mob, span_userdanger("Тело захвачено смертью. Подай апелляцию, если хочешь избежать этого в будущем!"))
		new_mob.death()
		if (!QDELETED(new_mob))
			new_mob.ghostize(can_reenter_corpse = FALSE)
			new_mob.key = null

/datum/disease/transformation/jungle_fever
	name = "Тропическая лихорадка"
	cure_text = "Смерть."
	cures = list(/datum/reagent/medicine/adminordrazine)
	spread_text = "Укус обезьяны"
	spread_flags = DISEASE_SPREAD_SPECIAL
	viable_mobtypes = list(/mob/living/carbon/human)
	spreading_modifier = 1
	cure_chance = 0.5
	disease_flags = CAN_CARRY|CAN_RESIST
	desc = "Обезьяны, страдающие этим заболеванием, кусают людей, в результате чего люди мутируют в обезьян."
	severity = DISEASE_SEVERITY_BIOHAZARD
	stage_prob = 2
	visibility_flags = NONE
	agent = "Kongey Vibrion M-909"
	new_form = /mob/living/carbon/human/species/monkey
	bantype = ROLE_MONKEY


	stage1	= list()
	stage2	= list()
	stage3	= list()
	stage4	= list(span_warning("Спина болит") , span_warning("Дышу через РОТ.") ,
					span_warning("Хочу бананы.") , span_warning("В голове туман."))
	stage5	= list(span_warning("Да я же обезьяна."))

/datum/disease/transformation/jungle_fever/do_disease_transformation(mob/living/carbon/affected_mob)
	if(affected_mob.mind && !is_monkey(affected_mob.mind))
		add_monkey(affected_mob.mind)
		affected_mob.monkeyize()


/datum/disease/transformation/jungle_fever/stage_act(delta_time, times_fired)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(2)
			if(DT_PROB(1, delta_time))
				to_chat(affected_mob, span_notice("Моя [pick("спина", "рука", "нога", "жопа", "голова")] чешется."))
		if(3)
			if(DT_PROB(2, delta_time))
				to_chat(affected_mob, span_danger("Чувствую острую боль в голове!."))
				affected_mob.add_confusion(10)
		if(4)
			if(DT_PROB(1.5, delta_time))
				affected_mob.say(pick("Иик, уук уук!", "Иик-eeek!", "Ииии!", "Унгх, унгх."), forced = "jungle fever")


/datum/disease/transformation/jungle_fever/cure()
	remove_monkey(affected_mob.mind)
	..()

/datum/disease/transformation/jungle_fever/monkeymode
	visibility_flags = HIDDEN_SCANNER|HIDDEN_PANDEMIC
	disease_flags = CAN_CARRY //no vaccines! no cure!

/datum/disease/transformation/jungle_fever/monkeymode/after_add()
	if(affected_mob && !is_monkey_leader(affected_mob.mind))
		visibility_flags = NONE



/datum/disease/transformation/robot

	name = "Роботизированная трансформация"
	cure_text = "Укол меди."
	cures = list(/datum/reagent/copper)
	cure_chance = 2.5
	agent = "R2D2 Наномашины"
	desc = "Эта болезнь, на самом деле острая инфекция наномашин, превращает жертву в киборга."
	severity = DISEASE_SEVERITY_BIOHAZARD
	visibility_flags = NONE
	stage1	= list()
	stage2	= list("Суставы жестеют.", span_danger("Бип... Буп..."))
	stage3	= list(span_danger("Суставы сильно жестеют.") , "Кожа слезает.", span_danger("Что-то движется... внутри."))
	stage4	= list(span_danger("Кожа сейчас отвалится.") , span_danger("Ощущаю... что-то... внутри меня."))
	stage5	= list(span_danger("Кожа слетает с меня!"))
	new_form = /mob/living/silicon/robot
	infectable_biotypes = MOB_ORGANIC|MOB_UNDEAD|MOB_ROBOTIC
	bantype = JOB_CYBORG


/datum/disease/transformation/robot/stage_act(delta_time, times_fired)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(3)
			if (DT_PROB(4, delta_time))
				affected_mob.say(pick("Бип, буп", "Бип, бип!", "Буп... буп"), forced = "robotic transformation")
			if(DT_PROB(2, delta_time))
				to_chat(affected_mob, span_danger("Чувствую острую боль в голове!."))
				affected_mob.Unconscious(40)
		if(4)
			if (DT_PROB(10, delta_time))
				affected_mob.say(pick("Бип, бип!", "Буп боп буп бип.", "Уууббееей мммееееннняя...", "Я хооооччччууууу ууууумееррррееееттть..."), forced = "robotic transformation")


/datum/disease/transformation/xeno

	name = "Ксеноморфная трансформация"
	cure_text = "Космоциллин и глицерин"
	cures = list(/datum/reagent/medicine/spaceacillin, /datum/reagent/glycerol)
	cure_chance = 2.5
	agent = "Rip-LEY чужеродные микробы"
	desc = "Эта болезнь превращает жертву в ксеноморфа."
	severity = DISEASE_SEVERITY_BIOHAZARD
	visibility_flags = NONE
	stage1	= list()
	stage2	= list("Горло чешется.", span_danger("Убивать..."))
	stage3	= list(span_danger("Горло очень сильно чешется.") , "Кожа утягивается.", span_danger("Что-то движется... внутри."))
	stage4	= list(span_danger("Кожа очень плотная.") , span_danger("Кровь кипит!") , span_danger("Ощущаю... что-то... внутри меня."))
	stage5	= list(span_danger("Кожа слетает с меня!"))
	new_form = /mob/living/carbon/alien/humanoid/hunter
	bantype = ROLE_ALIEN


/datum/disease/transformation/xeno/stage_act(delta_time, times_fired)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(3)
			if(DT_PROB(2, delta_time))
				to_chat(affected_mob, span_danger("Чувствую острую боль в голове!."))
				affected_mob.Unconscious(40)
		if(4)
			if(DT_PROB(10, delta_time))
				affected_mob.say(pick("Выгляжу восхитительно.", "Собираюсь... пожрать тебя...", "Хсссхххх!"), forced = "xenomorph transformation")


/datum/disease/transformation/slime
	name = "Расширенное преобразование мутаций"
	cure_text = "морозное масло"
	cures = list(/datum/reagent/consumable/frostoil)
	cure_chance = 55
	agent = "Токсин повышенной мутации"
	desc = "Этот высококонцентрированный экстракт превращает все в нечто большее."
	severity = DISEASE_SEVERITY_BIOHAZARD
	visibility_flags = NONE
	stage1	= list("Мне плохо.")
	stage2	= list("Кожа скользкая.")
	stage3	= list(span_danger("Пальцы тают.") , span_danger("Конечности меняют форму."))
	stage4	= list(span_danger("Превращаюсь в слайма."))
	stage5	= list(span_danger("Да я же слайм."))
	new_form = /mob/living/simple_animal/slime/random


/datum/disease/transformation/slime/stage_act(delta_time, times_fired)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(1)
			if(ishuman(affected_mob) && affected_mob.dna)
				if(affected_mob.dna.species.id == "slime" || affected_mob.dna.species.id == "stargazer" || affected_mob.dna.species.id == "lum")
					stage = 5
		if(3)
			if(ishuman(affected_mob))
				var/mob/living/carbon/human/human = affected_mob
				if(human.dna.species.id != "slime" && affected_mob.dna.species.id != "stargazer" && affected_mob.dna.species.id != "lum")
					human.set_species(/datum/species/jelly/slime)


/datum/disease/transformation/corgi
	name = "Баркенинг"
	cure_text = "Смерть"
	cures = list(/datum/reagent/medicine/adminordrazine)
	agent = "Fell Doge Majicks"
	desc = "Эта болезнь превращает жертву в корги."
	severity = DISEASE_SEVERITY_BIOHAZARD
	visibility_flags = NONE
	stage1	= list("ГАВ.")
	stage2	= list("Чувствую необходимость носить глупые шляпы.")
	stage3	= list(span_danger("Надо... поесть... шоколад...") , span_danger("ЯП"))
	stage4	= list(span_danger("Видения стиральных машин атакуют мой разум!"))
	stage5	= list(span_danger("АУУУУУУУ!!!"))
	new_form = /mob/living/simple_animal/pet/dog/corgi


/datum/disease/transformation/corgi/stage_act(delta_time, times_fired)
	. = ..()
	if(!.)
		return
	switch(stage)
		if(3)
			if (DT_PROB(4, delta_time))
				affected_mob.say(pick("ЯП", "Вуф!"), forced = "corgi transformation")
		if(4)
			if (DT_PROB(10, delta_time))
				affected_mob.say(pick("Гав!", "АУУУУУУУУ"), forced = "corgi transformation")


/datum/disease/transformation/morph
	name = "Благословение обжорства"
	cure_text = "Ничего"
	cures = list(/datum/reagent/consumable/nothing)
	agent = "Благословение обжорства"
	desc = "«Подарок» от кого-то ужасного."
	stage_prob = 10
	severity = DISEASE_SEVERITY_BIOHAZARD
	visibility_flags = NONE
	stage1	= list("В животе урчит.")
	stage2	= list("Кожа обвисла.")
	stage3	= list(span_danger("Пальцы растворяются.") , span_danger("Конечности меняют форму."))
	stage4	= list(span_danger("Хочу кушать."))
	stage5	= list(span_danger("Кажется я теперь морф."))
	new_form = /mob/living/simple_animal/hostile/morph
	infectable_biotypes = MOB_ORGANIC|MOB_MINERAL|MOB_UNDEAD //magic!
	transformed_antag_datum = /datum/antagonist/morph

/datum/disease/transformation/gondola
	name = "Трансформация гондолы"
	cure_text = "Конденсированный капсаицин, принимаемый внутрь или вводимый путем инъекции." //getting pepper sprayed doesn't help
	cures = list(/datum/reagent/consumable/condensedcapsaicin) //beats the hippie crap right out of your system
	cure_chance = 55
	stage_prob = 2.5
	agent = "Спокойствие"
	desc = "Потребление мяса гондолы обходится ужасно."
	severity = DISEASE_SEVERITY_BIOHAZARD
	visibility_flags = NONE
	stage1	= list("Походка стала немного легче.")
	stage2	= list("Улыбаюсь.")
	stage3	= list(span_danger("Жестокое чувство покоя овладевает мной.") , span_danger("Не чувствую рук!") , span_danger("Больше не хочу бить клоуна."))
	stage4	= list(span_danger("Больше не ощущаю руки. Да и это меня не волнует.") , span_danger("Прощаю клоуну все пакости в мою сторону."))
	stage5	= list(span_danger("Становлюсь Гондолой."))
	new_form = /mob/living/simple_animal/pet/gondola


/datum/disease/transformation/gondola/stage_act(delta_time, times_fired)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(2)
			if(DT_PROB(2.5, delta_time))
				affected_mob.emote("smile")
			if(DT_PROB(10, delta_time))
				affected_mob.reagents.add_reagent_list(list(/datum/reagent/pax = 5))
		if(3)
			if(DT_PROB(2.5, delta_time))
				affected_mob.emote("smile")
			if(DT_PROB(10, delta_time))
				affected_mob.reagents.add_reagent_list(list(/datum/reagent/pax = 5))
		if(4)
			if(DT_PROB(2.5, delta_time))
				affected_mob.emote("smile")
			if(DT_PROB(10, delta_time))
				affected_mob.reagents.add_reagent_list(list(/datum/reagent/pax = 5))
			if(DT_PROB(1, delta_time))
				var/obj/item/held_item = affected_mob.get_active_held_item()
				if(held_item)
					to_chat(affected_mob, span_danger("Отпускаю всё, что держал."))
					affected_mob.dropItemToGround(held_item)


/datum/disease/transformation/apostle
	name = "Вознесение"
	cure_text = "Ничего"
	cures = list(/datum/reagent/consumable/nothing)
	agent = "Вознесение"
	desc = "Превращение в нечто более прекрасное!"
	stage_prob = 20
	severity = DISEASE_SEVERITY_BIOHAZARD
	visibility_flags = NONE
	stage1	= list("Живот урчит.")
	stage2	= list("Слышу смех краем уха.")
	stage3	= list(span_danger("Моя кожа пахнет бананами.") , span_danger("Набираю вес."))
	stage4	= list(span_danger("Так хочется есть..."))
	stage5	= list(span_danger("Теперь я Апостол."))
	new_form = /mob/living/simple_animal/hostile/clown/mutant/glutton/
	infectable_biotypes = MOB_ORGANIC|MOB_MINERAL|MOB_UNDEAD //magic!

// Sidepaths for knowledge between Ash and Flesh.
/datum/heretic_knowledge/medallion
	name = "Пепельный Глаз"
	desc = "Позволяет вам трансмутировать глаза, свечу и осколок стекла в Древний Медальон. \
		Будучи надетым на шею, дарует вам возможность видеть жертв через твердые объекты."
	gain_text = "Пронзающий взгляд вел их сквозь обыденную реальность. Ни тьма, ни ужас не могли остановить их."
	next_knowledge = list(
		/datum/heretic_knowledge/spell/ash_passage,
		/datum/heretic_knowledge/limited_amount/flesh_ghoul,
	)
	required_atoms = list(
		/obj/item/organ/eyes = 1,
		/obj/item/shard = 1,
		/obj/item/candle = 1,
	)
	result_atoms = list(/obj/item/clothing/neck/eldritch_amulet)
	cost = 1
	route = PATH_SIDE

/datum/heretic_knowledge/curse/paralysis
	name = "Проклятье Паралича"
	desc = "Позволяет вам трансмутировать топорик, правую и левую ногу, \
		а также предмет с отпечатком пальцев, для того, чтобы наложить проклятие \
		на владельца отпечатков. Пока проклятие действует, \
		жертва не сможет ходить."
	gain_text = "Человеческая плоть слаба. Пусти кровь, сломай все кости. Покажи им всю их ничтожность."
	next_knowledge = list(
		/datum/heretic_knowledge/mad_mask,
		/datum/heretic_knowledge/summon/raw_prophet,
	)
	required_atoms = list(
		/obj/item/bodypart/l_leg = 1,
		/obj/item/bodypart/r_leg = 1,
		/obj/item/hatchet = 1,
	)
	duration = 5 MINUTES
	cost = 1
	route = PATH_SIDE

/datum/heretic_knowledge/curse/paralysis/curse(mob/living/carbon/human/chosen_mob)
	if(chosen_mob.usable_legs <= 0) // What're you gonna do, curse someone who already can't walk?
		to_chat(chosen_mob, span_notice("Чувствую легкую боль, но она быстро проходит. Странно."))
	else
		to_chat(chosen_mob, span_danger("Внезапно перестаю чувствовать свои ноги!"))

	ADD_TRAIT(chosen_mob, TRAIT_PARALYSIS_L_LEG, type)
	ADD_TRAIT(chosen_mob, TRAIT_PARALYSIS_R_LEG, type)

/datum/heretic_knowledge/curse/paralysis/uncurse(mob/living/carbon/human/chosen_mob)
	REMOVE_TRAIT(chosen_mob, TRAIT_PARALYSIS_L_LEG, type)
	REMOVE_TRAIT(chosen_mob, TRAIT_PARALYSIS_R_LEG, type)

	if(chosen_mob.usable_legs <= 0) // What're you gonna do, curse someone who already can't walk?
		to_chat(chosen_mob, span_notice("Слабая боль возвращается, но вскоре снова пропадает."))
	else
		to_chat(chosen_mob, span_notice("Вновь начинаю чувствовать свои ноги!"))

/datum/heretic_knowledge/summon/ashy
	name = "Ритуал Пепла"
	desc = "Позволяет трансмутировать голову, горстку пепла и книгу, чтобы создать Пепельника. \
		Пепельники обладают способностью к бестелесному перемещению, что позволяет им проходить сквозь стены, \
		а так же они могут накладывать кровотечение на цель с дистанции. \
		Также они способны создать кольцо огня вокруг себя на определенное время."
	gain_text = "Я объединил принцип голода с моим желанием разрушения. Маршал знал мое имя, и Ночной Страж смотрел на меня."
	next_knowledge = list(
		/datum/heretic_knowledge/summon/stalker,
		/datum/heretic_knowledge/spell/flame_birth,
	)
	required_atoms = list(
		/obj/effect/decal/cleanable/ash = 1,
		/obj/item/bodypart/head = 1,
		/obj/item/book = 1,
		)
	mob_to_summon = /mob/living/simple_animal/hostile/heretic_summon/ash_spirit
	cost = 1
	route = PATH_SIDE

/datum/heretic_knowledge/summon/ashy/cleanup_atoms(list/selected_atoms)
	var/obj/item/bodypart/head/ritual_head = locate() in selected_atoms
	if(!ritual_head)
		CRASH("[type] required a head bodypart, yet did not have one in selected_atoms when it reached cleanup_atoms.")

	// Spill out any brains or stuff before we delete it.
	ritual_head.drop_organs()
	return ..()

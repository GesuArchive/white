// Sidepaths for knowledge between Rust and Ash.

/datum/heretic_knowledge/essence
	name = "Ритуал Жреца"
	desc = "Позволяет трансмутировать бак с водой и осколок стекла во фляжку с Древней Эссенцией. \
		Воду можно выпить для лечения, или дать неверным в качестве смертельного яда."
	gain_text = "Это довольно старый рецепт. Сова нашептала его мне. \
		Жидкость, созданная Жрецом - квинтэссенция древнего ужаса, настолько пугающая, \
		что казалось сама ее суть отторгается миром. Но тебе удалось увидеть в ней скрытую силу."
	next_knowledge = list(
		/datum/heretic_knowledge/rust_regen,
		/datum/heretic_knowledge/spell/ash_passage,
		)
	required_atoms = list(
		/obj/structure/reagent_dispensers/watertank = 1,
		/obj/item/shard = 1,
	)
	result_atoms = list(/obj/item/reagent_containers/glass/beaker/eldritch)
	cost = 1
	route = PATH_SIDE

/datum/heretic_knowledge/curse/corrosion
	name = "Проклятие Разложения"
	desc = "Позволяет трансмутировать кусачки, лужу рвоты, сердце \
		и предмет с отпечатками пальцев на нем, для наложения Проклятия Разложения \
		на владельца отпечатков. Проклятие длится две минуты. Под его воздействием, \
		жертва подвержена постоянным приступам рвоты, в то время, как её органы постепенно отказывают."
	gain_text = "Тело человека ограничено временем. Люди, словно металл, что покрывается ржавчиной, а затем обращается в прах. Покажи это им всем."
	next_knowledge = list(
		/datum/heretic_knowledge/mad_mask,
		/datum/heretic_knowledge/spell/area_conversion,
	)
	required_atoms = list(
		/obj/item/wirecutters = 1,
		/obj/effect/decal/cleanable/vomit = 1,
		/obj/item/organ/heart = 1,
	)
	duration = 2 MINUTES
	cost = 1
	route = PATH_SIDE

/datum/heretic_knowledge/curse/corrosion/curse(mob/living/carbon/human/chosen_mob)
	to_chat(chosen_mob, span_danger("Ужасно себя чувствую."))
	chosen_mob.apply_status_effect(/datum/status_effect/corrosion_curse)

/datum/heretic_knowledge/curse/corrosion/uncurse(mob/living/carbon/human/chosen_mob)
	chosen_mob.remove_status_effect(/datum/status_effect/corrosion_curse)
	to_chat(chosen_mob, span_notice("Мне становится лучше."))

/datum/heretic_knowledge/summon/rusty
	name = "Ритуал Ржавчины"
	desc = "Позволяет трансмутировать лужу рвоты, книгу и голову, для создания Ржавого Ходока. \
		Ходоки отлично распростроняют ржавчину и неплохи в бою."
	gain_text = "Я объединил мой Принцип Голода с Верностью Ржавчине. Маршал прошептал мое имя, а Ржавые Холмы эхом повторили его."
	next_knowledge = list(
		/datum/heretic_knowledge/spell/entropic_plume,
		/datum/heretic_knowledge/spell/flame_birth,
	)
	required_atoms = list(
		/obj/effect/decal/cleanable/vomit = 1,
		/obj/item/book = 1,
		/obj/item/bodypart/head = 1,
	)
	mob_to_summon = /mob/living/simple_animal/hostile/heretic_summon/rust_spirit
	cost = 1
	route = PATH_SIDE

/datum/heretic_knowledge/summon/rusty/cleanup_atoms(list/selected_atoms)
	var/obj/item/bodypart/head/ritual_head = locate() in selected_atoms
	if(!ritual_head)
		CRASH("[type] required a head bodypart, yet did not have one in selected_atoms when it reached cleanup_atoms.")

	// Spill out any brains or stuff before we delete it.
	ritual_head.drop_organs()
	return ..()

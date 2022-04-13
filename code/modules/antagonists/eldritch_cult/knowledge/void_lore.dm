/datum/eldritch_knowledge/base_void
	name = "Мерцание зимы"
	desc = "Opens up the path of void to you. Allows you to transmute a knife in a sub-zero temperature into a void blade."
	gain_text = "I feel a shimmer in the air, atmosphere around me gets colder. I feel my body realizing the emptiness of existance. Something's watching me"
	banned_knowledge = list(/datum/eldritch_knowledge/base_ash,/datum/eldritch_knowledge/base_flesh,/datum/eldritch_knowledge/final/ash_final,/datum/eldritch_knowledge/final/flesh_final,/datum/eldritch_knowledge/base_rust,/datum/eldritch_knowledge/final/rust_final)
	next_knowledge = list(/datum/eldritch_knowledge/void_grasp)
	required_atoms = list(/obj/item/kitchen/knife)
	result_atoms = list(/obj/item/melee/sickly_blade/void)
	cost = 1
	route = PATH_VOID

/datum/eldritch_knowledge/base_void/recipe_snowflake_check(list/atoms, loc)
	. = ..()
	var/turf/open/turfie = loc
	if(turfie.GetTemperature() > T0C)
		return FALSE

/datum/eldritch_knowledge/void_grasp
	name = "Хватка Пустоты"
	desc = "Временно лишает жертву дара речи, а также снижает температуру ее тела."
	gain_text = "Я нашел наблюдателя, который смотрит за мной. Холод растет во мне. Это не конец тайны."
	cost = 1
	route = PATH_VOID
	next_knowledge = list(/datum/eldritch_knowledge/cold_snap)

/datum/eldritch_knowledge/void_grasp/on_mansus_grasp(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!iscarbon(target))
		return
	var/mob/living/carbon/carbon_target = target
	var/turf/open/turfie = get_turf(carbon_target)
	turfie.TakeTemperature(-20)
	carbon_target.adjust_bodytemperature(-40)
	carbon_target.silent += 4
	return TRUE

/datum/eldritch_knowledge/void_grasp/on_eldritch_blade(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	var/datum/status_effect/eldritch/E = H.has_status_effect(/datum/status_effect/eldritch/rust) || H.has_status_effect(/datum/status_effect/eldritch/ash) || H.has_status_effect(/datum/status_effect/eldritch/flesh)  || H.has_status_effect(/datum/status_effect/eldritch/void)
	if(!E)
		return
	E.on_effect()
	H.silent += 3

/datum/eldritch_knowledge/cold_snap
	name = "Путь Аристократа"
	desc = "Делает вас невосприимчивым к низким температурам, и вам больше не нужно дышать, вы все еще можете получить урон от недостатка давления."
	gain_text = "Я нашел нить ледяного дыхания. Она привела меня в странное святилище, сплошь состоящее из кристаллов. Полупрозрачное и белое, изображение благородного человека стояло передо мной."
	cost = 1
	route = PATH_VOID
	next_knowledge = list(/datum/eldritch_knowledge/void_cloak,/datum/eldritch_knowledge/void_mark,/datum/eldritch_knowledge/armor)

/datum/eldritch_knowledge/cold_snap/on_gain(mob/user)
	. = ..()
	ADD_TRAIT(user,TRAIT_RESISTCOLD,MAGIC_TRAIT)
	ADD_TRAIT(user, TRAIT_NOBREATH, MAGIC_TRAIT)

/datum/eldritch_knowledge/cold_snap/on_lose(mob/user)
	. = ..()
	REMOVE_TRAIT(user,TRAIT_RESISTCOLD,MAGIC_TRAIT)
	REMOVE_TRAIT(user, TRAIT_NOBREATH, MAGIC_TRAIT)

/datum/eldritch_knowledge/void_cloak
	name = "Плащ Пустоты"
	desc = "Плащ, который может стать невидимым по желанию, скрывая предметы, которые вы в нем храните. Для создания преобразуйте осколок стекла, любой предмет одежды, который вы можете надеть на свою униформу, и любой тип простыни."
	gain_text = "Сова - хранительница вещей, которые на практике таковыми не являются, но в теории являются." //Я в ахуе с ебаной тавтологии
	cost = 1
	next_knowledge = list(/datum/eldritch_knowledge/flesh_ghoul,/datum/eldritch_knowledge/cold_snap)
	result_atoms = list(/obj/item/clothing/suit/hooded/cultrobes/void)
	required_atoms = list(/obj/item/shard,/obj/item/clothing/suit,/obj/item/bedsheet)

/datum/eldritch_knowledge/void_mark
	name = "Знак Пустоты"
	gain_text = "Порыв ветра? Может быть, мерцание в воздухе. Присутствие подавляет, мои чувства предали меня, мой разум - мой враг.."
	desc = "Ваша Хватка Мансуса теперь накладывает Метку Пустоты. Чтобы наложить этот эффект, используйте свой Клинок на жертву. Метка Пустоты при применении значительно понижает температуру тела жертвы."
	cost = 2
	next_knowledge = list(/datum/eldritch_knowledge/spell/void_phase)
	banned_knowledge = list(/datum/eldritch_knowledge/rust_mark,/datum/eldritch_knowledge/ash_mark,/datum/eldritch_knowledge/flesh_mark)
	route = PATH_VOID

/datum/eldritch_knowledge/void_mark/on_mansus_grasp(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!isliving(target))
		return
	. = TRUE
	var/mob/living/living_target = target
	living_target.apply_status_effect(/datum/status_effect/eldritch/void)

/datum/eldritch_knowledge/spell/void_phase
	name = "Фаза Пустоты"
	gain_text = "Реальность прогибается под властью памяти, ибо все мимолетно, а что еще остается?"
	desc = "Вы получаете дальнобойный рывок, которой позволяет вам мгновенно телепортироваться в нужное место, нанося урон вокруг вас и выбранного вами места."
	cost = 1
	spell_to_add = /obj/effect/proc_holder/spell/pointed/void_blink
	next_knowledge = list(/datum/eldritch_knowledge/rune_carver,/datum/eldritch_knowledge/crucible,/datum/eldritch_knowledge/void_blade_upgrade)
	route = PATH_VOID

/datum/eldritch_knowledge/rune_carver
	name = "Нож для резьбы"
	gain_text = "Высеченные, вырезанные... вечные. Я могу высечь монолит и вызвать их силу!"
	desc = "Вы можете создать Нож для резьбы, который позволяет создать на полу до 3 рун, оказывающих различные эффекты на неверующих, которые проходят по ним. Из них получается довольно удобное метательное оружие. Чтобы создать Нож для резьбы трансмутируйте нож с осколком стекла и листом бумаги.."
	cost = 1
	next_knowledge = list(/datum/eldritch_knowledge/spell/void_phase,/datum/eldritch_knowledge/summon/raw_prophet)
	required_atoms = list(/obj/item/kitchen/knife,/obj/item/shard,/obj/item/paper)
	result_atoms = list(/obj/item/melee/rune_knife)

/datum/eldritch_knowledge/crucible
	name = "Плавильный котёл"
	gain_text = "Это чистая агония, я не смог вызвать отказ императора, но наткнулся на другой рецепт..."
	desc = "Позволяет создать тигель, элдрическое сооружение, позволяющее создавать зелья с различными эффектами, для этого трансмутируйте стол с резервуаром для воды"
	cost = 1
	next_knowledge = list(/datum/eldritch_knowledge/spell/void_phase,/datum/eldritch_knowledge/spell/area_conversion)
	required_atoms = list(/obj/structure/reagent_dispensers/watertank,/obj/structure/table)
	result_atoms = list(/obj/structure/eldritch_crucible)

/datum/eldritch_knowledge/void_blade_upgrade
	name = "Ищущий Клинок"
	gain_text = "Мимолетные воспоминания. Я могу отметить свой путь застывшей кровью на снегу. Покрытый и забытый."
	desc = "Теперь вы можете использовать свой клинок на удаленной отмеченной цели, чтобы переместиться к ней и атаковать."
	cost = 2
	next_knowledge = list(/datum/eldritch_knowledge/spell/voidpull)
	banned_knowledge = list(/datum/eldritch_knowledge/ash_blade_upgrade,/datum/eldritch_knowledge/flesh_blade_upgrade,/datum/eldritch_knowledge/rust_blade_upgrade)
	route = PATH_VOID

/datum/eldritch_knowledge/void_blade_upgrade/on_ranged_attack_eldritch_blade(atom/target, mob/user, click_parameters)
	. = ..()
	if(!ishuman(target) || !iscarbon(user))
		return
	var/mob/living/carbon/carbon_human = user
	var/mob/living/carbon/human/human_target = target
	var/datum/status_effect/eldritch/effect = human_target.has_status_effect(/datum/status_effect/eldritch/rust) || human_target.has_status_effect(/datum/status_effect/eldritch/ash) || human_target.has_status_effect(/datum/status_effect/eldritch/flesh) || human_target.has_status_effect(/datum/status_effect/eldritch/void)
	if(!effect)
		return
	var/dir = angle2dir(dir2angle(get_dir(user,human_target))+180)
	carbon_human.forceMove(get_step(human_target,dir))
	var/obj/item/melee/sickly_blade/blade = carbon_human.get_active_held_item()
	blade.melee_attack_chain(carbon_human,human_target)

/datum/eldritch_knowledge/spell/voidpull
	name = "Притяжение пустоты"
	gain_text = "Это существо называет себя аристократом, я близок к завершению начатого."
	desc = "Вы получаете способность, которая позволяет вам притягивать к себе окружающих вас людей."
	cost = 1
	spell_to_add = /obj/effect/proc_holder/spell/targeted/void_pull
	next_knowledge = list(/datum/eldritch_knowledge/final/void_final,/datum/eldritch_knowledge/spell/blood_siphon,/datum/eldritch_knowledge/summon/rusty)
	route = PATH_VOID

/datum/eldritch_knowledge/final/void_final
	name = "Вальс Конца Света"
	desc = "Принесите 3 трупа на руну трансмутации. После завершения ритуала вы автоматически заставите окружающих замолчать и вызовете вокруг себя снежную бурю."
	gain_text = "Мир погружается во тьму. Я стою в пустом самолете, с неба падают мелкие хлопья льда. Передо мной стоит Аристократ, он машет мне рукой. Мы будем танцевать вальс под шепот умирающей реальности, пока мир разрушается на наших глазах."
	cost = 3
	required_atoms = list(/mob/living/carbon/human)
	route = PATH_VOID
	///soundloop for the void theme
	var/datum/looping_sound/void_loop/sound_loop
	///Reference to the ongoing voidstrom that surrounds the heretic
	var/datum/weather/void_storm/storm

/datum/eldritch_knowledge/final/void_final/on_finished_recipe(mob/living/user, list/atoms, loc)
	var/mob/living/carbon/human/H = user
	H.physiology.brute_mod *= 0.5
	H.physiology.burn_mod *= 0.5
	ADD_TRAIT(H, TRAIT_RESISTLOWPRESSURE, MAGIC_TRAIT)
	H.client?.give_award(/datum/award/achievement/misc/void_ascension, H)
	priority_announce("$^@&#*$^@(#&$(@&#^$&#^@# Аристократ пустоты [H.real_name] прибыл, станцуйте же с ним в Вальсе, убивающий миры! $^@&#*$^@(#&$(@&#^$&#^@#","#$^@&#*$^@(#&$(@&#^$&#^@#", ANNOUNCER_SPANOMALIES)

	sound_loop = new(user, TRUE, TRUE)
	return ..()

/datum/eldritch_knowledge/final/void_final/on_death()
	if(sound_loop)
		sound_loop.stop()
	if(storm)
		storm.end()
		QDEL_NULL(storm)

/datum/eldritch_knowledge/final/void_final/on_life(mob/user)
	. = ..()
	if(!finished)
		return

	for(var/mob/living/carbon/livies in spiral_range(7,user)-user)
		if(IS_HERETIC_MONSTER(livies) || IS_HERETIC(livies))
			return
		livies.silent += 1
		livies.adjust_bodytemperature(-20)

	var/turf/turfie = get_turf(user)
	if(!isopenturf(turfie))
		return
	var/turf/open/open_turfie = turfie
	open_turfie.TakeTemperature(-20)

	var/area/user_area = get_area(user)
	var/turf/user_turf = get_turf(user)

	if(!storm)
		storm = new /datum/weather/void_storm(list(user_turf.z))
		storm.telegraph()

	storm.area_type = user_area.type
	storm.impacted_areas = list(user_area)
	storm.update_areas()

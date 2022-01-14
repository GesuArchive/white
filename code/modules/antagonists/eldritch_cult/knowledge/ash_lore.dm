/datum/eldritch_knowledge/base_ash
	name = "Секрет Ночного Стража"
	desc = "Открывает перед тобой Путь Пепла. Позволяет трансмутировать спичку и кухонный нож в Пепельный клинок."
	gain_text = "Городская стража знает свои часы. Если вы спросите их ночью, они могут рассказать вам о пепельном фонаре."
	banned_knowledge = list(/datum/eldritch_knowledge/base_rust,/datum/eldritch_knowledge/base_flesh,/datum/eldritch_knowledge/final/rust_final,/datum/eldritch_knowledge/final/flesh_final,/datum/eldritch_knowledge/final/void_final,/datum/eldritch_knowledge/base_void)
	next_knowledge = list(/datum/eldritch_knowledge/ashen_grasp)
	required_atoms = list(/obj/item/kitchen/knife,/obj/item/match)
	result_atoms = list(/obj/item/melee/sickly_blade/ash)
	cost = 1
	route = PATH_ASH

/datum/eldritch_knowledge/spell/ashen_shift
	name = "Пепельный Сдвиг"
	gain_text = "Ночной Сторож был первым из них, с его измены все и началось."
	desc = "Телепортация на короткие расстояния. Поможет избавиться от неприятностей."
	cost = 1
	spell_to_add = /obj/effect/proc_holder/spell/targeted/ethereal_jaunt/shift/ash
	next_knowledge = list(/datum/eldritch_knowledge/ash_mark,/datum/eldritch_knowledge/essence,/datum/eldritch_knowledge/ashen_eyes)
	route = PATH_ASH

/datum/eldritch_knowledge/ashen_grasp
	name = "Хватка Пепла"
	gain_text = "Он знал, как ходить между плоскостями."
	desc = "Усиливает вашу хватку Мансуса, позволяя ослепить ею врага."
	cost = 1
	next_knowledge = list(/datum/eldritch_knowledge/spell/ashen_shift)
	route = PATH_ASH

/datum/eldritch_knowledge/ashen_grasp/on_mansus_grasp(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!iscarbon(target))
		return
	var/mob/living/carbon/C = target
	to_chat(C, span_danger("Your eyes burn horrifically!")) //pocket sand! also, this is the message that changeling blind stings use, and no, I'm not ashamed about reusing it
	C.become_nearsighted(EYE_DAMAGE)
	C.blind_eyes(5)
	C.blur_eyes(10)
	return

/datum/eldritch_knowledge/ashen_grasp/on_eldritch_blade(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!iscarbon(target))
		return
	var/mob/living/carbon/C = target
	var/datum/status_effect/eldritch/E = C.has_status_effect(/datum/status_effect/eldritch/rust) || C.has_status_effect(/datum/status_effect/eldritch/ash) || C.has_status_effect(/datum/status_effect/eldritch/flesh) || C.has_status_effect(/datum/status_effect/eldritch/void)
	if(E)
		E.on_effect()
		for(var/X in user.mind.spell_list)
			if(!istype(X,/obj/effect/proc_holder/spell/targeted/touch/mansus_grasp))
				continue
			var/obj/effect/proc_holder/spell/targeted/touch/mansus_grasp/MG = X
			MG.charge_counter = min(round(MG.charge_counter + MG.charge_max * 0.75),MG.charge_max) // refunds 75% of charge.

/datum/eldritch_knowledge/ashen_eyes
	name = "Пепельные Глаза"
	gain_text = "Пронзительный взгляд, веди меня сквозь мирское."
	desc = "Позволяет создать амулет тепловизионного зрения путем трансмутации глаз и осколков стекла."
	cost = 1
	next_knowledge = list(/datum/eldritch_knowledge/spell/ashen_shift,/datum/eldritch_knowledge/flesh_ghoul)
	required_atoms = list(/obj/item/organ/eyes,/obj/item/shard)
	result_atoms = list(/obj/item/clothing/neck/eldritch_amulet)

/datum/eldritch_knowledge/ash_mark
	name = "Метка Пепла"
	gain_text = "Ночной Страж был особенным человеком, всегда наблюдавшим глубокую ночь. Но, несмотря на свой долг, он регулярно обходил особняк с высоко поднятым пылающим фонарем."
	desc = "Ваша хватка Мансуса теперь наносит Метку Пепла при попадании. Атакуйте пораженных своим Пепельным Клинком, чтобы активировать метку. При активации Метка Пепла наносит урон выносливости и поджигает, а также распространяется ближайшего противника. Урон уменьшается с каждым распространением."
	cost = 2
	next_knowledge = list(/datum/eldritch_knowledge/mad_mask)
	banned_knowledge = list(/datum/eldritch_knowledge/rust_mark,/datum/eldritch_knowledge/flesh_mark,/datum/eldritch_knowledge/void_mark)
	route = PATH_ASH

/datum/eldritch_knowledge/ash_mark/on_mansus_grasp(target,user,proximity_flag,click_parameters)
	. = ..()
	if(isliving(target))
		. = TRUE
		var/mob/living/living_target = target
		living_target.apply_status_effect(/datum/status_effect/eldritch/ash,5)

/datum/eldritch_knowledge/mad_mask
	name = "Маска Безумия"
	gain_text = "Он ходит по миру, незамеченный массами."
	desc = "Позволяет трансмутировать любую маску, со свечой и парой глаз, чтобы создать маску безумия, она наносит урон выносливости всем вокруг владельца и вызывает галлюцинации, может быть надета на неверного, чтобы он не смог ее снять..."
	cost = 1
	result_atoms = list(/obj/item/clothing/mask/void_mask)
	required_atoms = list(/obj/item/organ/eyes,/obj/item/clothing/mask,/obj/item/candle)
	next_knowledge = list(/datum/eldritch_knowledge/curse/corrosion,/datum/eldritch_knowledge/ash_blade_upgrade,/datum/eldritch_knowledge/curse/paralysis)
	route = PATH_ASH

/datum/eldritch_knowledge/spell/flame_birth
	name = "Рождение Пламени" //>Рождение пламени >наносит брейндамаг
	gain_text = "Ночной Страж был человеком принципов, и все же его сила происходила из хаоса, с которым он поклялся бороться."
	desc = "Заклинание ближнего боя, которое позволяет вам проклясть кого-то, нанеся большой урон рассудку."
	cost = 1
	spell_to_add = /obj/effect/proc_holder/spell/targeted/fiery_rebirth
	next_knowledge = list(/datum/eldritch_knowledge/spell/cleave,/datum/eldritch_knowledge/summon/ashy,/datum/eldritch_knowledge/final/ash_final)
	route = PATH_ASH

/datum/eldritch_knowledge/ash_blade_upgrade
	name = "Огненный Клинок"
	gain_text = "С клинком в руке он размахивал и размахивал, пока пепел падал с небес. Его город, его народ... все сгорело дотла, и все же жизнь еще оставалась в его обугленном теле."
	desc = "Ваш клинок теперь будет поджигать ваших врагов."
	cost = 2
	next_knowledge = list(/datum/eldritch_knowledge/spell/flame_birth)
	banned_knowledge = list(/datum/eldritch_knowledge/rust_blade_upgrade,/datum/eldritch_knowledge/flesh_blade_upgrade,/datum/eldritch_knowledge/void_blade_upgrade)
	route = PATH_ASH

/datum/eldritch_knowledge/ash_blade_upgrade/on_eldritch_blade(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		C.adjust_fire_stacks(1)
		C.IgniteMob()

/datum/eldritch_knowledge/curse/corrosion
	name = "Проклятие Разложения"
	gain_text = "Проклятая земля, проклятый человек, проклятый разум."
	desc = "Проклинает вашу жертву на 2 минуты, вызывая рвоту и серьезные повреждения органов. Используйте кусачки, лужу крови, сердце, левую руку и правую руку, а также предмет, к которому жертва прикасалась голыми руками."
	cost = 1
	required_atoms = list(/obj/item/wirecutters,/obj/effect/decal/cleanable/vomit,/obj/item/organ/heart)
	next_knowledge = list(/datum/eldritch_knowledge/mad_mask,/datum/eldritch_knowledge/spell/area_conversion)
	timer = 2 MINUTES

/datum/eldritch_knowledge/curse/corrosion/curse(mob/living/chosen_mob)
	. = ..()
	chosen_mob.apply_status_effect(/datum/status_effect/corrosion_curse)

/datum/eldritch_knowledge/curse/corrosion/uncurse(mob/living/chosen_mob)
	. = ..()
	chosen_mob.remove_status_effect(/datum/status_effect/corrosion_curse)

/datum/eldritch_knowledge/curse/paralysis
	name = "Проклятие паралича"
	gain_text = "Зарази их плоть, заставь истекать кровью."
	desc = "Проклинает вашу жертву на 5 минут неспособности ходить. Используйте на руне трансмутации нож, лужу крови, пару ног, топорик и предмет, к которому жертва прикасалась голыми руками. "
	cost = 1
	required_atoms = list(/obj/item/bodypart/l_leg,/obj/item/bodypart/r_leg,/obj/item/hatchet)
	next_knowledge = list(/datum/eldritch_knowledge/mad_mask,/datum/eldritch_knowledge/summon/raw_prophet)
	timer = 5 MINUTES

/datum/eldritch_knowledge/curse/paralysis/curse(mob/living/chosen_mob)
	. = ..()
	ADD_TRAIT(chosen_mob,TRAIT_PARALYSIS_L_LEG,MAGIC_TRAIT)
	ADD_TRAIT(chosen_mob,TRAIT_PARALYSIS_R_LEG,MAGIC_TRAIT)


/datum/eldritch_knowledge/curse/paralysis/uncurse(mob/living/chosen_mob)
	. = ..()
	REMOVE_TRAIT(chosen_mob,TRAIT_PARALYSIS_L_LEG,MAGIC_TRAIT)
	REMOVE_TRAIT(chosen_mob,TRAIT_PARALYSIS_R_LEG,MAGIC_TRAIT)


/datum/eldritch_knowledge/spell/cleave
	name = "Рассечение"
	gain_text = "Сначала я не понимал этих орудий войны, но священник сказал мне использовать их, несмотря ни на что. Скоро, сказал он, я буду хорошо их знать."
	desc = "Обучает заклинанию, которое обладает уроном по площади, вызывающее сильное кровотечение и потерю крови."
	cost = 1
	spell_to_add = /obj/effect/proc_holder/spell/pointed/cleave
	next_knowledge = list(/datum/eldritch_knowledge/spell/entropic_plume,/datum/eldritch_knowledge/spell/flame_birth)

/datum/eldritch_knowledge/final/ash_final
	name = "Ритуал Повелителя Пепла"
	gain_text = "Ночной Страж познал пепел, познал ритуал и поделился им с человечеством! Ибо сейчас, Я, един с огнем, СТАНЬ СВИДЕТЕЛЕМ МОЕГО ВОЗНЕСЕНИЯ!"
	desc = "Положите 3 трупа на руну трансмутации, вы станете невосприимчивы к огню, космическому вакууму, холоду и другим экологическим опасностям и станете в целом более устойчивыми ко всем другим повреждениям. Вы также научитесь заклинаниям, которые пассивно создают огонь вокруг вас. Первое заклинание охватывает вас огнём на одну минуту, другое создаёт огромную, огненную волну.."
	required_atoms = list(/mob/living/carbon/human)
	cost = 3
	route = PATH_ASH
	var/list/trait_list = list(TRAIT_RESISTHEAT,TRAIT_NOBREATH,TRAIT_RESISTCOLD,TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE,TRAIT_NOFIRE)

/datum/eldritch_knowledge/final/ash_final/on_finished_recipe(mob/living/user, list/atoms, loc)
	priority_announce("$^@&#*$^@(#&$(@&#^$&#^@# Бойся пламени, ибо Повелитель Пепла, [user.real_name] Вознесся! Пламя поглотит все! $^@&#*$^@(#&$(@&#^$&#^@#","#$^@&#*$^@(#&$(@&#^$&#^@#", ANNOUNCER_SPANOMALIES)
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/fire_cascade/big)
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/fire_sworn)
	var/mob/living/carbon/human/H = user
	H.physiology.brute_mod *= 0.5
	H.physiology.burn_mod *= 0.5
	H.client?.give_award(/datum/award/achievement/misc/ash_ascension, H)
	for(var/X in trait_list)
		ADD_TRAIT(user,X,MAGIC_TRAIT)
	return ..()

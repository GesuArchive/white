/datum/eldritch_knowledge/base_flesh
	name = "Принцип Голода"
	desc = "Открывает перед тобой Путь Плоти. Позволяет трансмутировать лужу крови и кухонный нож в Лезвие из Плоти.."
	gain_text = "Сотни из нас голодали, но не я... Я нашел силу в своей жадности."
	banned_knowledge = list(/datum/eldritch_knowledge/base_ash,/datum/eldritch_knowledge/base_rust,/datum/eldritch_knowledge/final/ash_final,/datum/eldritch_knowledge/final/rust_final,/datum/eldritch_knowledge/final/void_final,/datum/eldritch_knowledge/base_void)
	next_knowledge = list(/datum/eldritch_knowledge/flesh_grasp)
	required_atoms = list(/obj/item/kitchen/knife,/obj/effect/decal/cleanable/blood)
	result_atoms = list(/obj/item/melee/sickly_blade/flesh)
	cost = 1
	route = PATH_FLESH

/datum/eldritch_knowledge/flesh_ghoul
	name = "незавершенный Ритуал"
	desc = "Позволяет воскрешать мертвых как немых мертвецов, принося их в жертву на руне трансмутации с маком. Немые мертвецы слабее обычного человека в два раза. У вас может быть только два за раз."
	gain_text = "Я нашел записи о темном ритуале, незаконченные... и все же я продолжал двигаться вперед."
	cost = 1
	required_atoms = list(/mob/living/carbon/human,/obj/item/food/grown/poppy)
	next_knowledge = list(/datum/eldritch_knowledge/flesh_mark,/datum/eldritch_knowledge/void_cloak,/datum/eldritch_knowledge/ashen_eyes)
	route = PATH_FLESH
	var/max_amt = 2
	var/current_amt = 0
	var/list/ghouls = list()

/datum/eldritch_knowledge/flesh_ghoul/on_finished_recipe(mob/living/user,list/atoms,loc)
	var/mob/living/carbon/human/humie = locate() in atoms
	if(QDELETED(humie) || humie.stat != DEAD)
		return

	if(length(ghouls) >= max_amt)
		return

	if(HAS_TRAIT(humie,TRAIT_HUSK))
		return

	humie.grab_ghost()

	if(!humie.mind || !humie.client)
		var/list/mob/dead/observer/candidates = poll_candidates_for_mob("Do you want to play as a [humie.real_name], a voiceless dead", ROLE_HERETIC, null, 50,humie)
		if(!LAZYLEN(candidates))
			return
		var/mob/dead/observer/C = pick(candidates)
		message_admins("[key_name_admin(C)] has taken control of ([key_name_admin(humie)]) to replace an AFK player.")
		humie.ghostize(0)
		humie.key = C.key

	ADD_TRAIT(humie,TRAIT_MUTE,MAGIC_TRAIT)
	log_game("[key_name_admin(humie)] has become a voiceless dead, their master is [user.real_name]")
	humie.revive(full_heal = TRUE, admin_revive = TRUE)
	humie.setMaxHealth(50)
	humie.health = 50 // Voiceless dead are much tougher than ghouls
	humie.become_husk()
	humie.faction |= "heretics"

	var/datum/antagonist/heretic_monster/heretic_monster = humie.mind.add_antag_datum(/datum/antagonist/heretic_monster)
	var/datum/antagonist/heretic/master = user.mind.has_antag_datum(/datum/antagonist/heretic)
	heretic_monster.set_owner(master)
	atoms -= humie
	RegisterSignal(humie,COMSIG_LIVING_DEATH,.proc/remove_ghoul)
	ghouls += humie

/datum/eldritch_knowledge/flesh_ghoul/proc/remove_ghoul(datum/source)
	var/mob/living/carbon/human/humie = source
	ghouls -= humie
	humie.mind.remove_antag_datum(/datum/antagonist/heretic_monster)
	UnregisterSignal(source,COMSIG_LIVING_DEATH)

/datum/eldritch_knowledge/flesh_grasp
	name = "Хватка Плоти"
	gain_text = "Мои вновь обретенные желания вели меня ко все большим и большим высотам."
	desc = "Наделяет вашу хватку мансуса способностью некромантии, позволяет наделить жизнью мёртвого человека, но тот станет упырем. Упыри очень слабые и не представляют весомой угрозы.." //Тут немного перефразировал
	cost = 1
	next_knowledge = list(/datum/eldritch_knowledge/flesh_ghoul)
	var/ghoul_amt = 1
	var/list/spooky_scaries
	route = PATH_FLESH

/datum/eldritch_knowledge/flesh_grasp/on_mansus_grasp(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!ishuman(target) || target == user)
		return
	var/mob/living/carbon/human/human_target = target


	if(QDELETED(human_target) || human_target.stat != DEAD)
		return

	human_target.grab_ghost()

	if(!human_target.mind || !human_target.client)
		to_chat(user, span_warning("There is no soul connected to this body..."))
		return

	if(HAS_TRAIT(human_target, TRAIT_HUSK))
		to_chat(user, span_warning("You cannot revive a dead ghoul!"))
		return

	if(LAZYLEN(spooky_scaries) >= ghoul_amt)
		to_chat(user, span_warning("Your patron cannot support more ghouls on this plane!"))
		return

	LAZYADD(spooky_scaries, human_target)
	log_game("[key_name_admin(human_target)] has become a ghoul, their master is [user.real_name]")
	//we change it to true only after we know they passed all the checks
	. = TRUE
	RegisterSignal(human_target,COMSIG_LIVING_DEATH,.proc/remove_ghoul)
	human_target.revive(full_heal = TRUE, admin_revive = TRUE)
	human_target.setMaxHealth(25)
	human_target.health = 25
	human_target.become_husk()
	human_target.faction |= "heretics"
	var/datum/antagonist/heretic_monster/heretic_monster = human_target.mind.add_antag_datum(/datum/antagonist/heretic_monster)
	var/datum/antagonist/heretic/master = user.mind.has_antag_datum(/datum/antagonist/heretic)
	heretic_monster.set_owner(master)
	return

/datum/eldritch_knowledge/flesh_grasp/on_eldritch_blade(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/human_target = target
	var/datum/status_effect/eldritch/eldritch_effect = human_target.has_status_effect(/datum/status_effect/eldritch/rust) || human_target.has_status_effect(/datum/status_effect/eldritch/ash) || human_target.has_status_effect(/datum/status_effect/eldritch/flesh)  || human_target.has_status_effect(/datum/status_effect/eldritch/void)
	if(eldritch_effect)
		eldritch_effect.on_effect()
		if(iscarbon(target))
			var/mob/living/carbon/carbon_target = target
			var/obj/item/bodypart/bodypart = pick(carbon_target.bodyparts)
			var/datum/wound/slash/severe/crit_wound = new
			crit_wound.apply_wound(bodypart)

/datum/eldritch_knowledge/flesh_grasp/proc/remove_ghoul(datum/source)
	var/mob/living/carbon/human/humie = source
	spooky_scaries -= humie
	humie.mind.remove_antag_datum(/datum/antagonist/heretic_monster)
	UnregisterSignal(source, COMSIG_LIVING_DEATH)

/datum/eldritch_knowledge/flesh_mark
	name = "Метка Плоти"
	gain_text = "Я видел их, помеченных. Крики... тишина."
	desc = "Ваша хватка Мансуса теперь оставляет Метку Плоти при попадании. Атакуйте пораженных своим Клинком Плоти, чтобы активировать метку. При активации метка вызывает кровотечение у жертвы.."
	cost = 2
	next_knowledge = list(/datum/eldritch_knowledge/summon/raw_prophet)
	banned_knowledge = list(/datum/eldritch_knowledge/rust_mark,/datum/eldritch_knowledge/ash_mark,/datum/eldritch_knowledge/void_mark)
	route = PATH_FLESH

/datum/eldritch_knowledge/flesh_mark/on_mansus_grasp(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(isliving(target))
		. = TRUE
		var/mob/living/living_target = target
		living_target.apply_status_effect(/datum/status_effect/eldritch/flesh)

/datum/eldritch_knowledge/flesh_blade_upgrade
	name = "Кровоточащая сталь"
	gain_text = "А потом с небес полилась кровь. Вот тогда я наконец понял учение Маршала."
	desc = "Ваш Клинок Плоти теперь вызовет дополнительное кровотечения."
	cost = 2
	next_knowledge = list(/datum/eldritch_knowledge/summon/stalker)
	banned_knowledge = list(/datum/eldritch_knowledge/ash_blade_upgrade,/datum/eldritch_knowledge/rust_blade_upgrade,/datum/eldritch_knowledge/void_blade_upgrade)
	route = PATH_FLESH

/datum/eldritch_knowledge/flesh_blade_upgrade/on_eldritch_blade(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		var/obj/item/bodypart/bodypart = pick(carbon_target.bodyparts)
		var/datum/wound/slash/severe/crit_wound = new
		crit_wound.apply_wound(bodypart)

/datum/eldritch_knowledge/summon/raw_prophet
	name = "Сырой Ритуал"
	gain_text = "Сверхъестественное существо, которое в одиночестве бродит по долине между мирами... Я смог призвать его на помощь."
	desc = "Теперь вы можете вызвать Настоящего Пророка, трансмутируя пару глаз, левую руку и лужу крови. Пророки обладают увеличенной дальностью обзора, а также рентгеновским зрением, но они очень слабые.."
	cost = 1
	required_atoms = list(/obj/item/organ/eyes,/obj/effect/decal/cleanable/blood,/obj/item/bodypart/l_arm)
	mob_to_summon = /mob/living/simple_animal/hostile/eldritch/raw_prophet
	next_knowledge = list(/datum/eldritch_knowledge/flesh_blade_upgrade,/datum/eldritch_knowledge/rune_carver,/datum/eldritch_knowledge/curse/paralysis)
	route = PATH_FLESH

/datum/eldritch_knowledge/summon/stalker
	name = "Одинокий Ритуал"
	gain_text = "Я смог объединить свою жадность и желания, чтобы призвать жуткого зверя, которого я никогда раньше не видел. Постоянно меняющаяся масса плоти, она хорошо знала мои цели."
	desc = "Теперь вы можете вызвать Преследователя, преобразовав пару глаз, свечу, ручку и лист бумаги. Преследователи могут превращаться в безобидных животных, чтобы подобраться поближе к жертве."
	cost = 1
	required_atoms = list(/obj/item/pen,/obj/item/organ/eyes,/obj/item/candle,/obj/item/paper)
	mob_to_summon = /mob/living/simple_animal/hostile/eldritch/stalker
	next_knowledge = list(/datum/eldritch_knowledge/summon/ashy,/datum/eldritch_knowledge/summon/rusty,/datum/eldritch_knowledge/final/flesh_final)
	route = PATH_FLESH

/datum/eldritch_knowledge/summon/ashy
	name = "Пепельный Ритуал"
	gain_text = "Я объединил свой принцип голода с моим желанием разрушения. И Ночной Сторож знал мое имя."
	desc = "Теперь вы можете призвать Пепельного Человека, преобразовав кучу пепла, голову и книгу."
	cost = 1
	required_atoms = list(/obj/effect/decal/cleanable/ash,/obj/item/bodypart/head,/obj/item/book)
	mob_to_summon = /mob/living/simple_animal/hostile/eldritch/ash_spirit
	next_knowledge = list(/datum/eldritch_knowledge/summon/stalker,/datum/eldritch_knowledge/spell/flame_birth)

/datum/eldritch_knowledge/summon/rusty
	name = "Ржавый Ритуал"
	gain_text = "Я объединил свой принцип голода с моим стремлением к разложению. И Ржавые Холмы звали меня по имени."
	desc = "Теперь вы можете призвать Ржавого Ходока, преобразовав лужу рвоты, голову и книгу."
	cost = 1
	required_atoms = list(/obj/effect/decal/cleanable/vomit,/obj/item/book,/obj/item/bodypart/head)
	mob_to_summon = /mob/living/simple_animal/hostile/eldritch/rust_spirit
	next_knowledge = list(/datum/eldritch_knowledge/spell/voidpull,/datum/eldritch_knowledge/spell/entropic_plume)

/datum/eldritch_knowledge/spell/blood_siphon
	name = "Кровавый Сифон"
	gain_text = "Неважно, кто это, мы все равно истекаем кровью. Вот что сказал мне маршал."
	desc = "Вы обучаетесь заклинанию, которое высасывает жизненные силы у ваших врагов, чтобы восстановить ваше собственные."
	cost = 1
	spell_to_add = /obj/effect/proc_holder/spell/pointed/blood_siphon
	next_knowledge = list(/datum/eldritch_knowledge/summon/stalker,/datum/eldritch_knowledge/spell/voidpull)

/datum/eldritch_knowledge/final/flesh_final
	name = "Заключительный Гимн Священника"
	gain_text = "Люди этого мира. Услышьте меня, ибо пришло время Повелителя Рук! Император Плоти ведет мою армию!"
	desc = "Положи 3 тела на руну трансмутации, чтобы отречься от своей человеческой формы и вознестись к несказанной силе."
	required_atoms = list(/mob/living/carbon/human)
	cost = 3
	route = PATH_FLESH

/datum/eldritch_knowledge/final/flesh_final/on_finished_recipe(mob/living/user, list/atoms, loc)
	. = ..()
	priority_announce("$^@&#*$^@(#&$(@&#^$&#^@# Постоянно остывающий вихрь. Реальность перешатнулас. ПОВЕЛИТЕЛЬ РУК, [user.real_name] вознесся! Бойтесь вечно извивающейся руки! $^@&#*$^@(#&$(@&#^$&#^@#","#$^@&#*$^@(#&$(@&#^$&#^@#", ANNOUNCER_SPANOMALIES)
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shed_human_form)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	H.physiology.brute_mod *= 0.5
	H.physiology.burn_mod *= 0.5
	H.client?.give_award(/datum/award/achievement/misc/flesh_ascension, H)
	var/datum/antagonist/heretic/heretic = user.mind.has_antag_datum(/datum/antagonist/heretic)
	var/datum/eldritch_knowledge/flesh_grasp/ghoul1 = heretic.get_knowledge(/datum/eldritch_knowledge/flesh_grasp)
	ghoul1.ghoul_amt *= 3
	var/datum/eldritch_knowledge/flesh_ghoul/ghoul2 = heretic.get_knowledge(/datum/eldritch_knowledge/flesh_ghoul)
	ghoul2.max_amt *= 3

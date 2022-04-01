// Clusterfuck of skyrat code because I fuck their file sorting

/obj/item/reagent_containers/hash
	name = "гашиш"
	desc = "Концентрированный экстракт каннабиса. Обеспечивает гораздо лучший кайф при использовании в кальяне."
	icon = 'white/rebolution228/icons/unsorted/crack.dmi'
	icon_state = "hash"
	volume = 20
	possible_transfer_amounts = list()
	list_reagents = list(/datum/reagent/drug/thc = 15, /datum/reagent/toxin/lipolicide = 5)

/obj/item/reagent_containers/hash/dabs
	name = "дэб"
	desc = "Масляный экстракт из растений конопли. Просто обеспечивает другой тип удара."
	icon = 'white/rebolution228/icons/unsorted/crack.dmi'
	icon_state = "dab"
	volume = 40
	possible_transfer_amounts = list()
	list_reagents = list(/datum/reagent/drug/thc = 40) //horrendously powerful

/obj/item/reagent_containers/hashbrick
	name = "пачка гашиша"
	desc = "Кирпич гашиша. Хорошо подходит для транспортировки!"
	icon = 'white/rebolution228/icons/unsorted/crack.dmi'
	icon_state = "hashbrick"
	volume = 25
	possible_transfer_amounts = list()
	list_reagents = list(/datum/reagent/drug/cocaine = 60, /datum/reagent/toxin/lipolicide = 20)


/obj/item/reagent_containers/hashbrick/attack_self(mob/user)
	user.visible_message(span_notice("[user] начинает разламывать [src]."))
	if(do_after(user,10))
		to_chat(user, span_notice("Разламываю [src]."))
		for(var/i = 1 to 4)
			new /obj/item/reagent_containers/hash(user.loc)
		qdel(src)

/datum/crafting_recipe/hashbrick
	name = "Гашишный кирпич"
	result = /obj/item/reagent_containers/hashbrick
	reqs = list(/obj/item/reagent_containers/hash = 4)
	parts = list(/obj/item/reagent_containers/hash = 4)
	time = 20
	category = CAT_CHEMISTRY

//export values
/datum/export/hash
	cost = CARGO_CRATE_VALUE * 0.35
	unit_name = "hash"
	export_types = list(/obj/item/reagent_containers/hash)
	include_subtypes = FALSE

/datum/export/crack/hashbrick
	cost = CARGO_CRATE_VALUE * 2
	unit_name = "hash brick"
	export_types = list(/obj/item/reagent_containers/hashbrick)
	include_subtypes = FALSE

/datum/export/dab
	cost = CARGO_CRATE_VALUE * 0.4
	unit_name = "dab"
	export_types = list(/obj/item/reagent_containers/hash/dabs)
	include_subtypes = FALSE

/obj/item/food/grown/cannabis/on_grind()
	. = ..()
	if(HAS_TRAIT(src, TRAIT_DRIED))
		grind_results = list(/datum/reagent/drug/thc/hash = 0.15*src.seed.potency)
		reagents.clear_reagents() //prevents anything else from coming out

/datum/chemical_reaction/hash
	required_reagents = list(/datum/reagent/drug/thc/hash = 10)
	reaction_flags = REACTION_INSTANT
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_CHEMICAL

/datum/chemical_reaction/hash/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /obj/item/reagent_containers/hash(location)

/datum/chemical_reaction/dabs
	required_reagents = list(/datum/reagent/drug/thc = 20)
	required_temp = 420 //haha very funny
	reaction_flags = REACTION_INSTANT
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_CHEMICAL

/datum/chemical_reaction/dabs/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /obj/item/reagent_containers/hash/dabs(location)

/atom/movable/screen/alert/stoned
	name = "Обкурен"
	desc = "Ты обкурился до беспамятства! Ва-а-ау..."
	icon_state = "high"

//the reagent itself
/datum/reagent/drug/thc
	name = "ТГК"
	description = "Химическое вещество, содержащееся в конопле и являющееся ее основным психоактивным компонентом."
	reagent_state = LIQUID
	color = "#cfa40c"
	overdose_threshold = 30 //just gives funny effects, but doesnt hurt you; thc has no actual known overdose
	ph = 6
	taste_description = "skunk"

/datum/reagent/drug/thc/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	var/high_message = pick("Чувствую себя спокойно.", "Чувствую себя в жопе.", "Как же мне хреново...")
	if(M.hud_used!=null)
		var/atom/movable/plane_master_controller/game_plane_master_controller = M.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]
		game_plane_master_controller.add_filter("weed_blur", 10, angular_blur_filter(0, 0, 0.45))
	if(DT_PROB(2.5, delta_time))
		to_chat(M, span_notice("[high_message]"))
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "stoned", /datum/mood_event/stoned, name)
	M.throw_alert("stoned", /atom/movable/screen/alert/stoned)
	M.sound_environment_override = SOUND_ENVIRONMENT_DRUGGED
	M.Dizzy(5 * REM * delta_time)
	M.adjust_nutrition(-1 * REM * delta_time) //munchies
	if(DT_PROB(3.5, delta_time))
		M.emote(pick("laugh","giggle"))
	..()

/datum/reagent/drug/thc/on_mob_end_metabolize(mob/living/carbon/M)
	if(M.hud_used!=null)
		var/atom/movable/plane_master_controller/game_plane_master_controller = M.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]
		game_plane_master_controller.remove_filter("weed_blur")
	M.clear_alert("stoned")
	M.sound_environment_override = SOUND_ENVIRONMENT_NONE

/mob/proc/adjust_drowsyness(amount)
	drowsyness = max(drowsyness + amount, 0)

/datum/reagent/drug/thc/overdose_process(mob/living/M, delta_time, times_fired)
	var/cg420_message = pick("Много-о, ой, много-о...", "О боже...",)
	if(DT_PROB(1.5, delta_time))
		M.say("[cg420_message]")
	M.adjust_drowsyness(0.1 * REM * normalise_creation_purity() * delta_time)
	if(DT_PROB(3.5, delta_time))
		playsound(M, pick('white/rebolution228/sounds/misc/lungbust_cough1.ogg','white/rebolution228/sounds/misc/lungbust_cough2.ogg'), 50, TRUE)
		M.emote("cough")
	..()
	. = TRUE

/datum/reagent/drug/thc/hash //only exists to generate hash object
	name = "гашиш"
	description = "Концентрированный экстракт каннабиса. Обеспечивает гораздо лучший кайф при использовании в кальяне."
	color = "#cfa40c"

/datum/chemical_reaction/powder_cocaine
	is_cold_recipe = TRUE
	required_reagents = list(/datum/reagent/drug/cocaine = 10)
	required_temp = 250 //freeze it
	reaction_flags = REACTION_INSTANT
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_CHEMICAL
	mix_message = "Раствор застывает в порошок!"

/datum/chemical_reaction/powder_cocaine/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /obj/item/reagent_containers/cocaine(location)

/datum/chemical_reaction/freebase_cocaine
	required_reagents = list(/datum/reagent/drug/cocaine = 10, /datum/reagent/water = 5, /datum/reagent/ash = 10) //mix 20 cocaine, 10 water, 20 ash
	required_temp = 480 //heat it up
	reaction_flags = REACTION_INSTANT
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_CHEMICAL

/datum/chemical_reaction/freebase_cocaine/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /obj/item/reagent_containers/crack(location)

/datum/reagent/drug/cocaine
	name = "Кокаин"
	description = "Мощный стимулятор, извлекаемый из листьев коки. Уменьшает время оглушения, но при передозировке вызывает сонливость и тяжелые повреждения мозга."
	reagent_state = LIQUID
	color = "#ffffff"
	overdose_threshold = 20
	ph = 9
	taste_description = "bitterness" //supposedly does taste bitter in real life
	addiction_types = list(/datum/addiction/stimulants = 14) //5.6 per 2 seconds

/datum/reagent/drug/cocaine/on_mob_metabolize(mob/living/containing_mob)
	..()
	containing_mob.add_movespeed_modifier(/datum/movespeed_modifier/reagent/stimulants)
	ADD_TRAIT(containing_mob, TRAIT_STUNRESISTANCE, type)

/datum/reagent/drug/cocaine/on_mob_end_metabolize(mob/living/containing_mob)
	containing_mob.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/stimulants)
	REMOVE_TRAIT(containing_mob, TRAIT_STUNRESISTANCE, type)
	..()

/datum/reagent/drug/cocaine/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(DT_PROB(2.5, delta_time))
		var/high_message = pick("Чувствую нервозность.", "Чувствую скорость.", "Чувствую, как нужно сделать шаг вперёд.")
		to_chat(M, span_notice("[high_message]"))
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "zoinked", /datum/mood_event/stimulant_heavy, name)
	M.AdjustStun(-15 * REM * delta_time)
	M.AdjustKnockdown(-15 * REM * delta_time)
	M.AdjustUnconscious(-15 * REM * delta_time)
	M.AdjustImmobilized(-15 * REM * delta_time)
	M.AdjustParalyzed(-15 * REM * delta_time)
	M.adjustStaminaLoss(-2 * REM * delta_time, 0)
	if(DT_PROB(2.5, delta_time))
		M.emote("shiver")
	..()
	. = TRUE

/datum/reagent/drug/cocaine/overdose_start(mob/living/M)
	to_chat(M, span_userdanger("Мое сердце бьётся так сильно, что это причиняет мне боль!"))

/datum/reagent/drug/cocaine/overdose_process(mob/living/M, delta_time, times_fired)
	M.adjustToxLoss(1 * REM * delta_time, 0)
	M.adjustOrganLoss(ORGAN_SLOT_HEART, (rand(10, 20) / 10) * REM * delta_time)
	M.Jitter(2 * REM * delta_time)
	if(DT_PROB(2.5, delta_time))
		M.emote(pick("twitch","drool"))
	if(!HAS_TRAIT(M, TRAIT_FLOORED))
		if(DT_PROB(1.5, delta_time))
			M.visible_message(span_danger("[M] падает на пол!"))
			M.Paralyze(135,TRUE)
			M.drop_all_held_items()
	..()
	. = TRUE

/datum/reagent/drug/cocaine/freebase_cocaine
	name = "курительный кокаин"
	description = "Курительная форма кокаина."
	color = "#f0e6bb"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/drug/cocaine/powder_cocaine
	name = "порошок кокаина"
	description = "Порошковый вид кокаина."
	color = "#ffffff"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/obj/item/reagent_containers/crack
	name = "крэк"
	desc = "Камень кокаина на свободной основе, иначе известный как крэк."
	icon = 'white/rebolution228/icons/unsorted/crack.dmi'
	icon_state = "crack"
	volume = 10
	possible_transfer_amounts = list()
	list_reagents = list(/datum/reagent/drug/cocaine/freebase_cocaine = 10)

/obj/item/reagent_containers/crackbrick
	name = "кирпич крэка"
	desc = "Кирпич крэк-кокаина."
	icon = 'white/rebolution228/icons/unsorted/crack.dmi'
	icon_state = "crackbrick"
	volume = 40
	possible_transfer_amounts = list()
	list_reagents = list(/datum/reagent/drug/cocaine/freebase_cocaine = 40)

/obj/item/reagent_containers/crackbrick/attackby(obj/item/W, mob/user, params)
	if(W.get_sharpness())
		user.show_message(span_notice("You cut \the [src] into some rocks."), MSG_VISUAL)
		for(var/i = 1 to 4)
			new /obj/item/reagent_containers/crack(user.loc)
		qdel(src)

/datum/crafting_recipe/crackbrick
	name = "Кирпич крэка"
	result = /obj/item/reagent_containers/crackbrick
	reqs = list(/obj/item/reagent_containers/crack = 4)
	parts = list(/obj/item/reagent_containers/crack = 4)
	time = 20
	category = CAT_CHEMISTRY //i might just make a crafting category for drugs at some point

// Should probably give this the edible component at some point
/obj/item/reagent_containers/cocaine
	name = "кокаин"
	desc = "Воссоздайте свои любимые сцены из фильма \"Лицо со шрамом\"!"
	icon = 'white/rebolution228/icons/unsorted/crack.dmi'
	icon_state = "cocaine"
	volume = 5
	possible_transfer_amounts = list()
	list_reagents = list(/datum/reagent/drug/cocaine = 5)

/obj/item/reagent_containers/cocaine/proc/snort(mob/living/user)
	if(!iscarbon(user))
		return
	var/covered = ""
	if(user.is_mouth_covered(head_only = 1))
		covered = "headgear"
	else if(user.is_mouth_covered(mask_only = 1))
		covered = "mask"
	if(covered)
		to_chat(user, span_warning("Надо снять [covered]!"))
		return
	user.visible_message(span_notice("'[user] начинает занюхивать [src]."))
	if(do_after(user, 30))
		to_chat(user, span_notice("Заканчиваю занюхивать [src]."))
		if(reagents.total_volume)
			reagents.trans_to(user, reagents.total_volume, transfered_by = user, methods = INGEST)
		qdel(src)

/obj/item/reagent_containers/cocaine/attack(mob/target, mob/user)
	if(target == user)
		snort(user)

/obj/item/reagent_containers/cocaine/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(!in_range(user, src) || user.get_active_held_item())
		return

	snort(user)

	return

/obj/item/reagent_containers/cocainebrick
	name = "кирпич кокаина"
	desc = "Кирпич кокаина. Хорошо подходит для транспортировки!"
	icon = 'white/rebolution228/icons/unsorted/crack.dmi'
	icon_state = "cocainebrick"
	volume = 25
	possible_transfer_amounts = list()
	list_reagents = list(/datum/reagent/drug/cocaine = 25)


/obj/item/reagent_containers/cocainebrick/attack_self(mob/user)
	user.visible_message(span_notice("[user] начинает разламывать [src]."))
	if(do_after(user,10))
		to_chat(user, span_notice("Заканчиваю разламывать [src]."))
		for(var/i = 1 to 5)
			new /obj/item/reagent_containers/cocaine(user.loc)
		qdel(src)

/datum/crafting_recipe/cocainebrick
	name = "Кокаиновый кирпич"
	result = /obj/item/reagent_containers/cocainebrick
	reqs = list(/obj/item/reagent_containers/cocaine = 5)
	parts = list(/obj/item/reagent_containers/cocaine = 5)
	time = 20
	category = CAT_CHEMISTRY //i might just make a crafting category for drugs at some point

//if you want money, convert it into crackbricks
/datum/export/crack
	cost = CARGO_CRATE_VALUE * 0.5
	unit_name = "crack"
	export_types = list(/obj/item/reagent_containers/crack)
	include_subtypes = FALSE

/datum/export/crack/crackbrick
	cost = CARGO_CRATE_VALUE * 2.5
	unit_name = "crack brick"
	export_types = list(/obj/item/reagent_containers/crackbrick)
	include_subtypes = FALSE

/datum/export/cocaine
	cost = CARGO_CRATE_VALUE * 0.4
	unit_name = "cocaine"
	export_types = list(/obj/item/reagent_containers/cocaine)
	include_subtypes = FALSE

/datum/export/cocainebrick
	cost = CARGO_CRATE_VALUE * 2
	unit_name = "cocaine brick"
	export_types = list(/obj/item/reagent_containers/cocainebrick)
	include_subtypes = FALSE

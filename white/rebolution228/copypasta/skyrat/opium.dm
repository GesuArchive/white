/datum/chemical_reaction/heroin
	results = list(/datum/reagent/drug/opium/heroin = 4)
	required_reagents = list(/datum/reagent/drug/opium = 2, /datum/reagent/acetone = 2)
	reaction_tags = REACTION_TAG_CHEMICAL
	required_temp = 480
	optimal_ph_min = 8
	optimal_ph_max = 12
	H_ion_release = -0.04
	rate_up_lim = 12.5
	purity_min = 0.5

/datum/chemical_reaction/powder_heroin
	is_cold_recipe = TRUE
	required_reagents = list(/datum/reagent/drug/opium/heroin = 8)
	required_temp = 250 //freeze it
	reaction_flags = REACTION_INSTANT
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_CHEMICAL
	mix_message = "Раствор застывает в порошок!"

/datum/chemical_reaction/powder_heroin/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /obj/item/reagent_containers/heroin(location)

/obj/item/reagent_containers/heroin
	name = "героин"
	desc = "Займите очередь и уделите немного времени человеку."
	icon = 'white/rebolution228/icons/unsorted/crack.dmi'
	icon_state = "heroin"
	volume = 4
	possible_transfer_amounts = list()
	list_reagents = list(/datum/reagent/drug/opium/heroin = 4)

/obj/item/reagent_containers/heroin/proc/snort(mob/living/user)
	if(!iscarbon(user))
		return
	var/covered = ""
	if(user.is_mouth_covered(head_only = 1))
		covered = "headgear"
	else if(user.is_mouth_covered(mask_only = 1))
		covered = "mask"
	if(covered)
		to_chat(user, span_warning("Сначала надо снять [covered]!"))
		return
	user.visible_message(span_notice("'[user] начинает занюхивать [src]."))
	if(do_after(user, 30))
		to_chat(user, span_notice("Заканчиваю занюхивать [src]."))
		if(reagents.total_volume)
			reagents.trans_to(user, reagents.total_volume, transfered_by = user, methods = INGEST)
		qdel(src)

/obj/item/reagent_containers/heroin/attack(mob/target, mob/user)
	if(target == user)
		snort(user)

/obj/item/reagent_containers/heroin/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(!in_range(user, src) || user.get_active_held_item())
		return

	snort(user)

	return

/obj/item/reagent_containers/heroinbrick
	name = "пачка героина"
	desc = "Кирпич героина. Хорошо подходит для транспортировки!"
	icon = 'white/rebolution228/icons/unsorted/crack.dmi'
	icon_state = "heroinbrick"
	volume = 20
	possible_transfer_amounts = list()
	list_reagents = list(/datum/reagent/drug/opium/heroin = 20)


/obj/item/reagent_containers/heroinbrick/attack_self(mob/user)
	user.visible_message(span_notice("[user] начинает разламывать [src]."))
	if(do_after(user,10))
		to_chat(user, span_notice("Заканчиваю разламывать [src]."))
		for(var/i = 1 to 5)
			new /obj/item/reagent_containers/heroin(user.loc)
		qdel(src)

/datum/crafting_recipe/heroinbrick
	name = "пачка героина"
	result = /obj/item/reagent_containers/heroinbrick
	reqs = list(/obj/item/reagent_containers/heroin = 5)
	parts = list(/obj/item/reagent_containers/heroin = 5)
	time = 20
	category = CAT_CHEMISTRY

/datum/chemical_reaction/blacktar
	required_reagents = list(/datum/reagent/drug/opium/blacktar = 5)
	required_temp = 480
	reaction_flags = REACTION_INSTANT
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_CHEMICAL

/datum/chemical_reaction/blacktar/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /obj/item/reagent_containers/blacktar(location)

/atom/movable/screen/fullscreen/color_vision/heroin_color
	color = "#444444"

/datum/reagent/drug/opium
	name = "Опиум"
	description = "Экстракт опийного мака. Приводит пользователя в слегка эйфорическое состояние."
	reagent_state = LIQUID
	color = "#ffe669"
	overdose_threshold = 30
	ph = 8
	taste_description = "flowers"
	addiction_types = list(/datum/addiction/opiods = 18)

/datum/reagent/drug/opium/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	var/high_message = pick("Чувствую эйфорию.", "Чувствую, как я нахожусь на вершине мира.")
	if(DT_PROB(2.5, delta_time))
		to_chat(M, span_notice("[high_message]"))
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "smacked out", /datum/mood_event/narcotic_heavy, name)
	M.adjustBruteLoss(-0.1 * REM * delta_time, 0) //can be used as a (shitty) painkiller
	M.adjustFireLoss(-0.1 * REM * delta_time, 0)
	M.hal_screwyhud = SCREWYHUD_HEALTHY
	M.overlay_fullscreen("heroin_euphoria", /atom/movable/screen/fullscreen/color_vision/heroin_color)
	..()

/datum/reagent/drug/opium/overdose_process(mob/living/M, delta_time, times_fired)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2 * REM * delta_time)
	M.adjustToxLoss(3 * REM * delta_time, 0)
	M.adjust_drowsyness(6 * REM * normalise_creation_purity() * delta_time)
	..()
	. = TRUE

/datum/reagent/drug/opium/on_mob_end_metabolize(mob/living/M)
	if(iscarbon(M))
		var/mob/living/carbon/N = M
		N.hal_screwyhud = SCREWYHUD_NONE
		N.clear_fullscreen("heroin_euphoria")
	..()

/datum/reagent/drug/opium/heroin
	name = "Героин"
	description = "Она для меня как героин, она для меня как героин! Она не может... пропустить вену!"
	reagent_state = LIQUID
	color = "#ffe669"
	overdose_threshold = 20
	ph = 6
	taste_description = "цветы"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	failed_chem = /datum/reagent/drug/opium/blacktar

/datum/reagent/drug/opium/heroin/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	var/high_message = pick("Чуствую, что ничто не сможет меня остановить.", "Чувствую себя Богом.")
	if(DT_PROB(2.5, delta_time))
		to_chat(M, span_notice("[high_message]"))
	M.adjustBruteLoss(-0.4 * REM * delta_time, 0) //more powerful as a painkiller, possibly actually useful to medical now
	M.adjustFireLoss(-0.4 * REM * delta_time, 0)
	..()

/datum/reagent/drug/opium/blacktar
	name = "черный деготь героина"
	description = "Нечистая, свободная форма героина. Вероятно, не стоит принимать это...."
	reagent_state = LIQUID
	color = "#242423"
	overdose_threshold = 10 //more easy to overdose on
	ph = 8
	taste_description = "flowers"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	failed_chem = null

/datum/reagent/drug/opium/blacktar/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	var/high_message = pick("Чувствую деготь.", "Кровь в моих венах похожа на сироп.")
	if(DT_PROB(2.5, delta_time))
		to_chat(M, span_notice("[high_message]"))
	M.set_drugginess(15 * REM * delta_time)
	M.adjustToxLoss(0.5 * REM * delta_time, 0) //toxin damage
	..()

//Exports
/datum/export/heroin
	cost = CARGO_CRATE_VALUE * 0.5
	unit_name = "героин"
	export_types = list(/obj/item/reagent_containers/heroin)
	include_subtypes = FALSE

/datum/export/heroinbrick
	cost = CARGO_CRATE_VALUE * 2.5
	unit_name = "пачка героина"
	export_types = list(/obj/item/reagent_containers/heroinbrick)
	include_subtypes = FALSE

/datum/export/blacktar
	cost = CARGO_CRATE_VALUE * 0.4
	unit_name = "черный деготь героина"
	export_types = list(/obj/item/reagent_containers/blacktar)
	include_subtypes = FALSE


/obj/item/seeds/poppy/opiumpoppy
	name = "пакет семян опийного мака"
	desc = "Из этих семян вырастают настоящие опийные маки."
	icon = 'white/rebolution228/icons/unsorted/hydroponics/seeds.dmi'
	growing_icon = 'white/rebolution228/icons/unsorted/hydroponics/growing.dmi'
	icon_state = "seed-opiumpoppy"
	species = "opiumpoppy"
	icon_grow = "opiumpoppy-grow"
	icon_dead = "opiumpoppy-dead"
	plantname = "Листья Опийного Мака"
	product = /obj/item/food/grown/poppy/opiumpoppy
	reagents_add = list(/datum/reagent/drug/opium = 0.3, /datum/reagent/toxin/fentanyl = 0.075, /datum/reagent/consumable/nutriment = 0.05)
	slot_flags = null

/obj/item/food/grown/poppy/opiumpoppy
	seed = /obj/item/seeds/poppy/opiumpoppy
	name = "семенная кожура опийного мака"
	desc = "Семенной комок растения опийного мака, содержащий опийный латекс."
	icon = 'white/rebolution228/icons/unsorted/hydroponics/harvest.dmi'
	icon_state = "opiumpoppy"
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_colors = null
	distill_reagent = /datum/reagent/consumable/ethanol/turbo //How can a slow drug make fast drink? Don't question it.

/obj/item/seeds/cocaleaf
	name = "пакет семян листьев коки"
	desc = "Из этих семян вырастают кусты коки. При одном взгляде на них вы чувствуете прилив сил.."
	icon = 'white/rebolution228/icons/unsorted/hydroponics/seeds.dmi'
	growing_icon = 'white/rebolution228/icons/unsorted/hydroponics/growing.dmi'
	icon_state = "seed-cocoleaf"
	species = "cocoleaf"
	plantname = "Листья Коки"
	maturation = 8
	potency = 20
	growthstages = 1
	product = /obj/item/food/grown/cocaleaf
	mutatelist = list()
	reagents_add = list(/datum/reagent/drug/cocaine = 0.3, /datum/reagent/consumable/nutriment = 0.15)

/obj/item/food/grown/cocaleaf
	seed = /obj/item/seeds/cocaleaf
	name = "лист коки"
	desc = "Лист кустарника коки, который содержит мощный психоактивный алкалоид, известный как 'кокаин'."
	icon = 'white/rebolution228/icons/unsorted/hydroponics/harvest.dmi'
	icon_state = "cocoleaf"
	foodtypes = FRUIT //i guess? i mean it grows on trees...
	tastes = list("листья" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/sins_delight //Cocaine is one hell of a sin.

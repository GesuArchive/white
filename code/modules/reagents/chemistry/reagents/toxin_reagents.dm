
//////////////////////////Poison stuff (Toxins & Acids)///////////////////////

/datum/reagent/toxin
	name = "Токсин"
	enname = "toxin"
	description = "Токсичный химикат."
	color = "#CF3600" // rgb: 207, 54, 0
	taste_description = "горечь"
	taste_mult = 1.2
	harmful = TRUE
	var/toxpwr = 1.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	var/silent_toxin = FALSE //won't produce a pain message when processed by liver/life() if there isn't another non-silent toxin present.
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

// Are you a bad enough dude to poison your own plants?
/datum/reagent/toxin/on_hydroponics_apply(obj/item/seeds/myseed, datum/reagents/chems, obj/machinery/hydroponics/mytray, mob/user)
	. = ..()
	if(chems.has_reagent(type, 1))
		mytray.adjustToxic(round(chems.get_reagent_amount(type) * 2))

/datum/reagent/toxin/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(toxpwr)
		M.adjustToxLoss(toxpwr * REM * normalise_creation_purity(), 0)
		. = TRUE
	..()

/datum/reagent/toxin/amatoxin
	name = "Аматоксин"
	enname = "amatoxin"
	description = "Мощный яд, полученный из определенного вида грибов."
	color = "#792300" // rgb: 121, 35, 0
	toxpwr = 2.5
	taste_description = "грибы"
	ph = 13
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/mutagen
	name = "Нестабильный мутаген"
	enname = "unstable mutagen"
	description = "Может вызвать непредсказуемые мутации. Держать подальше от детей."
	color = "#00FF00"
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 0
	taste_description = "слайм"
	taste_mult = 0.9
	ph = 2.3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/mutagen/expose_mob(mob/living/carbon/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if(!exposed_mob.has_dna() || HAS_TRAIT(exposed_mob, TRAIT_GENELESS) || HAS_TRAIT(exposed_mob, TRAIT_BADDNA))
		return  //No robots, AIs, aliens, Ians or other mobs should be affected by this.
	if(((methods & VAPOR) && prob(min(33, reac_volume))) || (methods & (INGEST|PATCH|INJECT)))
		exposed_mob.randmuti()
		if(prob(98))
			exposed_mob.easy_randmut(NEGATIVE+MINOR_NEGATIVE)
		else
			exposed_mob.easy_randmut(POSITIVE)
		exposed_mob.updateappearance()
		exposed_mob.domutcheck()

/datum/reagent/toxin/mutagen/on_mob_life(mob/living/carbon/C, delta_time, times_fired)
	C.apply_effect(5 * REM * delta_time, EFFECT_IRRADIATE, 0)
	return ..()

/datum/reagent/toxin/mutagen/on_hydroponics_apply(obj/item/seeds/myseed, datum/reagents/chems, obj/machinery/hydroponics/mytray, mob/user)
	mytray.mutation_roll(user)
	if(chems.has_reagent(type, 1))
		mytray.adjustToxic(3) //It is still toxic, mind you, but not to the same degree.

#define	LIQUID_PLASMA_BP (50+T0C)

/datum/reagent/toxin/plasma
	name = "Плазма"
	enname = "plasma"
	description = "Плазма в её жидкой форме."
	taste_description = "горечь"
	specific_heat = SPECIFIC_HEAT_PLASMA
	taste_mult = 1.5
	color = "#8228A0"
	toxpwr = 3
	material = /datum/material/plasma
	penetrates_skin = NONE
	ph = 4
	burning_temperature = 4500//plasma is hot!!
	burning_volume = 0.3//But burns fast
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/plasma/on_new(data)
	. = ..()
	RegisterSignal(holder, COMSIG_REAGENTS_TEMP_CHANGE, PROC_REF(on_temp_change))

/datum/reagent/toxin/plasma/Destroy()
	UnregisterSignal(holder, COMSIG_REAGENTS_TEMP_CHANGE)
	return ..()

/datum/reagent/toxin/plasma/on_mob_life(mob/living/carbon/C, delta_time, times_fired)
	if(holder.has_reagent(/datum/reagent/medicine/epinephrine))
		holder.remove_reagent(/datum/reagent/medicine/epinephrine, 2 * REM * delta_time)
	C.adjustPlasma(20 * REM * delta_time)
	return ..()

/// Handles plasma boiling.
/datum/reagent/toxin/plasma/proc/on_temp_change(datum/reagents/_holder, old_temp)
	SIGNAL_HANDLER
	if(holder.chem_temp < LIQUID_PLASMA_BP)
		return
	if(!holder.my_atom)
		return

	var/atom/A = holder.my_atom
	A.atmos_spawn_air("plasma=[volume];TEMP=[holder.chem_temp]")
	holder.del_reagent(type)

/datum/reagent/toxin/plasma/expose_turf(turf/open/exposed_turf, reac_volume)
	if(!istype(exposed_turf))
		return
	var/temp = holder ? holder.chem_temp : T20C
	if(temp >= LIQUID_PLASMA_BP)
		exposed_turf.atmos_spawn_air("plasma=[reac_volume];TEMP=[temp]")
	return ..()

/datum/reagent/toxin/plasma/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)//Splashing people with plasma is stronger than fuel!
	. = ..()
	if(methods & (TOUCH|VAPOR))
		exposed_mob.adjust_fire_stacks(reac_volume / 5)
		return

/datum/reagent/toxin/hot_ice
	name = "Пылкая Слякоть"
	enname = "hot ice"
	description = "Замороженная плазма, на вес золота для нужных людей."
	reagent_state = SOLID
	color = "#724cb8" // rgb: 114, 76, 184
	taste_description = "thick and smokey"
	specific_heat = SPECIFIC_HEAT_PLASMA
	toxpwr = 3
	material = /datum/material/hot_ice
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/hot_ice/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(holder.has_reagent(/datum/reagent/medicine/epinephrine))
		holder.remove_reagent(/datum/reagent/medicine/epinephrine, 2 * REM * delta_time)
	M.adjustPlasma(20 * REM * delta_time)
	M.adjust_bodytemperature(-7 * TEMPERATURE_DAMAGE_COEFFICIENT * REM * delta_time, M.get_body_temp_normal())
	if(ishuman(M))
		var/mob/living/carbon/human/humi = M
		humi.adjust_coretemperature(-7 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, M.get_body_temp_normal())
	return ..()

/datum/reagent/toxin/lexorin
	name = "Лексорин"
	enname = "lexorin"
	description = "Сильный яд, используемый для остановки дыхания."
	color = "#7DC3A0"
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 0
	taste_description = "кислота"
	ph = 1.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/lexorin/on_mob_life(mob/living/carbon/C, delta_time, times_fired)
	. = TRUE

	if(HAS_TRAIT(C, TRAIT_NOBREATH))
		. = FALSE

	if(.)
		C.adjustOxyLoss(5 * REM * normalise_creation_purity(), 0)
		C.losebreath += 2 * REM * normalise_creation_purity()
		if(DT_PROB(10, delta_time))
			C.emote("gasp")
	..()

/datum/reagent/toxin/slimejelly
	name = "Желе Слайма"
	enname = "slime jelly"
	description = "Липкая полужидкость полученная из одной из самой смертоносной формы жизни. ТАК РЕАЛЬНО."
	color = "#801E28" // rgb: 128, 30, 40
	toxpwr = 0
	taste_description = "слайм"
	taste_mult = 1.3
	ph = 10
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/slimejelly/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(DT_PROB(5, delta_time))
		to_chat(M, span_danger("Моё нутро пылает!"))
		M.adjustToxLoss(rand(20,60)*REM, 0)
		. = 1
	else if(DT_PROB(23, delta_time))
		M.heal_bodypart_damage(5*REM)
		. = 1
	..()

/datum/reagent/toxin/minttoxin
	name = "Мятный Токсин"
	enname = "mint toxin"
	description = "Полезно для работы с нежелательными клиентами."
	color = "#CF3600" // rgb: 207, 54, 0
	toxpwr = 0
	taste_description = "мята"
	ph = 8
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/minttoxin/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(HAS_TRAIT(M, TRAIT_FAT))
		M.inflate_gib()
	return ..()

/datum/reagent/toxin/carpotoxin
	name = "Карпотоксин"
	enname = "carpotoxin"
	description = "Смертельный нейротоксин, производимый космическими карпами."
	silent_toxin = TRUE
	color = "#003333" // rgb: 0, 51, 51
	toxpwr = 2
	taste_description = "рыба"
	ph = 12
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/carpotoxin/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	. = ..()
	for(var/i in M.all_scars)
		qdel(i)

/datum/reagent/toxin/zombiepowder
	name = "Зомби-Порошок"
	enname = "zombie powder"
	description = "Сильный нейротоксин, который погружает цель в состояние, подобное смерти."
	silent_toxin = TRUE
	reagent_state = SOLID
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	color = "#669900" // rgb: 102, 153, 0
	toxpwr = 0.5
	taste_description = "смерть"
	penetrates_skin = NONE
	var/fakedeath_active = FALSE
	ph = 13
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/zombiepowder/on_mob_metabolize(mob/living/L)
	..()
	ADD_TRAIT(L, TRAIT_FAKEDEATH, type)
	if(fakedeath_active)
		L.fakedeath(type)

/datum/reagent/toxin/zombiepowder/on_mob_end_metabolize(mob/living/L)
	L.cure_fakedeath(type)
	..()

/datum/reagent/toxin/zombiepowder/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	exposed_mob.adjustOxyLoss(0.5*REM, 0)
	if(methods & INGEST)
		var/datum/reagent/toxin/zombiepowder/zombiepowder = exposed_mob.reagents.has_reagent(/datum/reagent/toxin/zombiepowder)
		if(istype(zombiepowder))
			zombiepowder.fakedeath_active = TRUE

/datum/reagent/toxin/zombiepowder/on_mob_life(mob/living/M, delta_time, times_fired)
	..()
	if(fakedeath_active)
		return TRUE
	switch(current_cycle)
		if(1 to 5)
			M.add_confusion(1 * REM * delta_time)
			M.drowsyness += 1 * REM * delta_time
			M.slurring += 3 * REM * delta_time
		if(5 to 8)
			M.adjustStaminaLoss(40 * REM * delta_time, 0)
		if(9 to INFINITY)
			fakedeath_active = TRUE
			M.fakedeath(type)

/datum/reagent/toxin/ghoulpowder
	name = "Гуле-порошок"
	enname = "ghoul powder"
	description = "Сильный нейротоксин, который, замедляет метаболизм до состояния, подобное смерти, пока держит пациента полностью активным. При долго использовании могут начать появлятся токсины в организме."
	reagent_state = SOLID
	color = "#664700" // rgb: 102, 71, 0
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 0.8
	taste_description = "смерть"
	ph = 14.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/ghoulpowder/on_mob_metabolize(mob/living/L)
	..()
	ADD_TRAIT(L, TRAIT_FAKEDEATH, type)

/datum/reagent/toxin/ghoulpowder/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_FAKEDEATH, type)
	..()

/datum/reagent/toxin/ghoulpowder/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjustOxyLoss(1 * REM * delta_time, 0)
	..()
	. = TRUE

/datum/reagent/toxin/mindbreaker
	name = "Разрушающий Разум Токсин"
	enname = "mindbreaker toxin"
	description = "Мощный голлюциноген. С этим не стоит шутить."
	color = "#B31008" // rgb: 139, 166, 233
	toxpwr = 0
	taste_description = "кислотность"
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	ph = 11
	impure_chem = /datum/reagent/impurity/rosenol
	inverse_chem = null
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = list(/datum/addiction/hallucinogens = 18)  //7.2 per 2 seconds

/datum/reagent/toxin/mindbreaker/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.hallucination += 5 * REM * delta_time
	return ..()

/datum/reagent/toxin/plantbgone
	name = "Гербицид общего назначения"
	enname = "Plant-B-Gone"
	description = "Опасный токсин для выведения всех растений. Не употреблять внутрь!"
	color = "#49002E" // rgb: 73, 0, 46
	toxpwr = 1
	taste_mult = 1
	penetrates_skin = NONE
	ph = 2.7
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

	// Plant-B-Gone is just as bad
/datum/reagent/toxin/plantbgone/on_hydroponics_apply(obj/item/seeds/myseed, datum/reagents/chems, obj/machinery/hydroponics/mytray, mob/user)
	. = ..()
	if(chems.has_reagent(type, 1))
		mytray.adjustHealth(-round(chems.get_reagent_amount(type) * 10))
		mytray.adjustToxic(round(chems.get_reagent_amount(type) * 6))
		mytray.adjustWeeds(-rand(4,8))

/datum/reagent/toxin/plantbgone/expose_obj(obj/exposed_obj, reac_volume)
	. = ..()
	if(istype(exposed_obj, /obj/structure/alien/weeds))
		var/obj/structure/alien/weeds/alien_weeds = exposed_obj
		alien_weeds.take_damage(rand(15,35), BRUTE, 0) // Kills alien weeds pretty fast
	else if(istype(exposed_obj, /obj/structure/glowshroom)) //even a small amount is enough to kill it
		qdel(exposed_obj)
	else if(istype(exposed_obj, /obj/structure/spacevine))
		var/obj/structure/spacevine/SV = exposed_obj
		SV.on_chem_effect(src)

/datum/reagent/toxin/plantbgone/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if(!(methods & VAPOR) || !iscarbon(exposed_mob))
		return
	var/mob/living/carbon/exposed_carbon = exposed_mob
	if(!exposed_carbon.wear_mask)
		exposed_carbon.adjustToxLoss(min(round(0.4 * reac_volume, 0.1), 10))

/datum/reagent/toxin/plantbgone/weedkiller
	name = "Гербицид против сорняков"
	enname = "Weed Killer"
	description = "Опасный токсин для выведения сорняков. Не употреблять внутрь!"
	color = "#4B004B" // rgb: 75, 0, 75
	ph = 3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

	//Weed Spray
/datum/reagent/toxin/plantbgone/weedkiller/on_hydroponics_apply(obj/item/seeds/myseed, datum/reagents/chems, obj/machinery/hydroponics/mytray, mob/user)
	if(!mytray)
		return
	if(chems.has_reagent(type, 1))
		mytray.adjustToxic(round(chems.get_reagent_amount(type) * 0.5))
		mytray.adjustWeeds(-rand(1,2))

/datum/reagent/toxin/pestkiller
	name = "Пестицид против паразитов"
	enname = "Pest Killer"
	description = "Опасный токсин для убийства насекомых. Не употреблять внутрь!"
	color = "#4B004B" // rgb: 75, 0, 75
	toxpwr = 1
	ph = 3.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

//Pest Spray
/datum/reagent/toxin/pestkiller/on_hydroponics_apply(obj/item/seeds/myseed, datum/reagents/chems, obj/machinery/hydroponics/mytray, mob/user)
	if(!mytray)
		return
	if(chems.has_reagent(type, 1))
		mytray.adjustToxic(round(chems.get_reagent_amount(type) * 1))
		mytray.adjustPests(-rand(1,2))

/datum/reagent/toxin/pestkiller/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if(exposed_mob.mob_biotypes & MOB_BUG)
		var/damage = min(round(0.4*reac_volume, 0.1),10)
		exposed_mob.adjustToxLoss(damage)

/datum/reagent/toxin/pestkiller/organic
	name = "Пестицид мягкого действия"
	enname = "Natural Pest Killer"
	description = "Органическая смесь, используемая для убийства насекомых с более мягкими последствиями. Не употреблять внутрь!"
	color = "#4b2400" // rgb: 75, 0, 75
	toxpwr = 1
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

//Pest Spray
/datum/reagent/toxin/pestkiller/organic/on_hydroponics_apply(obj/item/seeds/myseed, datum/reagents/chems, obj/machinery/hydroponics/mytray, mob/user)
	if(!mytray)
		return
	if(chems.has_reagent(type, 1))
		mytray.adjustToxic(round(chems.get_reagent_amount(type) * 0.1))
		mytray.adjustPests(-rand(1,2))

/datum/reagent/toxin/spore
	name = "Споровой Токсин"
	enname = "Spore Toxin"
	description = "Натуральный токсин, производимый спорами блоба, который ослабляет зрение при попадании внутрь организма."
	color = "#9ACD32"
	toxpwr = 1
	ph = 11
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/spore/on_mob_life(mob/living/carbon/C, delta_time, times_fired)
	C.damageoverlaytemp = 60
	C.update_damage_hud()
	C.blur_eyes(3 * REM * delta_time)
	return ..()

/datum/reagent/toxin/spore_burning
	name = "Горящий Споровой Токсин"
	enname = "Burning Spore Toxin"
	description = "Натуральный токсин, производимый спорами блоба, который провоцируют горение жертвы."
	color = "#9ACD32"
	toxpwr = 0.5
	taste_description = "сжигание"
	ph = 13
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/spore_burning/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjust_fire_stacks(2 * REM * delta_time)
	M.ignite_mob()
	return ..()

/datum/reagent/toxin/chloralhydrate
	name = "Хлоралгидрат"
	enname = "Chloral Hydrate"
	description = "Сильное седитативное средство, которое сначала дезориентирует жертву, а затем усыпит."
	silent_toxin = TRUE
	reagent_state = SOLID
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	color = "#000067" // rgb: 0, 0, 103
	toxpwr = 0
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	ph = 11
	impure_chem = /datum/reagent/impurity/chloralax
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/chloralhydrate/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	switch(current_cycle)
		if(1 to 10)
			M.add_confusion(2 * REM * normalise_creation_purity())
			M.drowsyness += 2 * REM * normalise_creation_purity()
		if(10 to 50)
			M.Sleeping(40 * REM * normalise_creation_purity())
			. = TRUE
		if(51 to INFINITY)
			M.Sleeping(40 * REM * normalise_creation_purity())
			M.adjustToxLoss(1 * (current_cycle - 50) * REM * normalise_creation_purity(), 0)
			. = TRUE
	..()

/datum/reagent/toxin/fakebeer	//disguised as normal beer for use by emagged brobots
	name = "Пиво?"
	enname = "beer"
	description = "Специально разработанное снотворное, под видом пива. Оно мгновенно погрузит жертву в сон."
	color = "#664300" // rgb: 102, 67, 0
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	taste_description = "моча"
	glass_icon_state = "beerglass"
	glass_name = "Банка пива"
	glass_desc = "Холодное пиво."
	ph = 2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/fakebeer/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	switch(current_cycle)
		if(1 to 50)
			M.Sleeping(40 * REM * delta_time)
		if(51 to INFINITY)
			M.Sleeping(40 * REM * delta_time)
			M.adjustToxLoss(1 * (current_cycle - 50) * REM * delta_time, 0)
	return ..()

/datum/reagent/toxin/coffeepowder
	name = "Кофейная Гуща"
	enname = "Coffee Powder"
	description = "Мелко размолотые кофейные зерна, используемые для приготовления кофе."
	reagent_state = SOLID
	color = "#5B2E0D" // rgb: 91, 46, 13
	toxpwr = 0.5
	ph = 4.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/teapowder
	name = "Молотые Чайные Листья"
	enname = "Tea Powder"
	description = "Мелко измельченные чайные листья, используемые для приготовления чая."
	reagent_state = SOLID
	color = "#7F8400" // rgb: 127, 132, 0
	toxpwr = 0.1
	taste_description = "зелёный чай"
	ph = 4.9
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/mutetoxin //the new zombie powder.
	name = "Токсин Онемения"
	enname = "Mute Toxin"
	description = "Нелетальный токсин, который подавляет речь жертвы."
	silent_toxin = TRUE
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	color = "#F0F8FF" // rgb: 240, 248, 255
	toxpwr = 0
	taste_description = "молчание"
	ph = 12.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/mutetoxin/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.silent = max(M.silent, 3 * REM * normalise_creation_purity())
	..()

/datum/reagent/toxin/staminatoxin
	name = "Тиризен"
	enname = "Tirizene"
	description = "Нелетальный яд, который крайне сильно изматывает и ослабляет жертву."
	silent_toxin = TRUE
	color = "#6E2828"
	data = 15
	toxpwr = 0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/staminatoxin/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjustStaminaLoss(data * REM * delta_time, 0)
	data = max(data - 1, 3)
	..()
	. = TRUE

/datum/reagent/toxin/polonium
	name = "Полоний"
	enname = "Polonium"
	description = "Крайне радиоактивный материал в жидкой форме. Проглатывание приведет к смертельному облучению."
	reagent_state = LIQUID
	color = "#787878"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/polonium/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.radiation += 4 * REM * delta_time
	..()

/datum/reagent/toxin/histamine
	name = "Гистамин"
	enname = "Histamine"
	description = "Эффекты гистамина очень сильно зависят от размера введенной дозы. Последствия варируются от небольшого раздражения, до летального исхода."
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#FA6464"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 30
	toxpwr = 0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/histamine/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(DT_PROB(30, delta_time))
		switch(pick(1, 2, 3, 4))
			if(1)
				to_chat(M, span_danger("Почти ничего не вижу!"))
				M.blur_eyes(3)
			if(2)
				M.emote("cough")
			if(3)
				M.emote("sneeze")
			if(4)
				if(prob(75))
					to_chat(M, span_danger("Зудит всё тело."))
					M.adjustBruteLoss(2*REM, 0)
					. = TRUE
	..()

/datum/reagent/toxin/histamine/overdose_process(mob/living/M, delta_time, times_fired)
	M.adjustOxyLoss(2 * REM * delta_time, FALSE)
	M.adjustBruteLoss(2 * REM * delta_time, FALSE, FALSE, BODYPART_ORGANIC)
	M.adjustToxLoss(2 * REM * delta_time, FALSE)
	..()
	. = TRUE

/datum/reagent/toxin/formaldehyde
	name = "Формальдегид"
	enname = "Formaldehyde"
	description = "Формальдегид, сам по себе, крайне слабый токсин. Полностью останавливает разложение в трупах. В нем есть следы Гистомина, отчего он очень редко распадается на этот самый Гистомин."
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#B4004B"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 1
	ph = 2.0
	impure_chem = /datum/reagent/impurity/methanol
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/formaldehyde/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(DT_PROB(2.5, delta_time))
		holder.add_reagent(/datum/reagent/toxin/histamine, pick(5,15))
		holder.remove_reagent(/datum/reagent/toxin/formaldehyde, 1.2)
	else
		return ..()

/datum/reagent/toxin/venom
	name = "Отрава"
	enname = "Venom"
	description = "Экзотический яд, полученные из крайне токсичной фауны. Черевато токсинами и травмами, тяжесть которых зависит от размера дозы. Обычно распадается на Гистамин."
	reagent_state = LIQUID
	color = "#F0FFF0"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	toxpwr = 0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/venom/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	toxpwr = 0.1 * volume
	M.adjustBruteLoss((0.3 * volume) * REM * delta_time, 0)
	. = TRUE
	if(DT_PROB(8, delta_time))
		holder.add_reagent(/datum/reagent/toxin/histamine, pick(5, 10))
		holder.remove_reagent(/datum/reagent/toxin/venom, 1.1)
	else
		..()

/datum/reagent/toxin/fentanyl
	name = "Фентанил"
	enname = "Fentanyl"
	description = "Фентанил будет подавлять работу мозга и наносить урон токсинами, после чего жертва потеряет сознание."
	reagent_state = LIQUID
	color = "#64916E"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 0
	ph = 9
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = list(/datum/addiction/opiods = 25)

/datum/reagent/toxin/fentanyl/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 3 * REM * normalise_creation_purity(), 150)
	if(M.toxloss <= 60)
		M.adjustToxLoss(1 * REM * normalise_creation_purity(), 0)
	if(current_cycle >= 4)
		SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "smacked out", /datum/mood_event/narcotic_heavy, name)
	if(current_cycle >= 18)
		M.Sleeping(40 * REM * normalise_creation_purity())
	..()
	return TRUE

/datum/reagent/toxin/cyanide
	name = "Цианид"
	enname = "Cyanide"
	description = "Знамитый яд, известный за частое использование в убийствах. Вызывает токсичное отравление осложненное удушьем и потерей сознания."
	reagent_state = LIQUID
	color = "#00B4FF"
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 1.25
	ph = 9.3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/cyanide/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(DT_PROB(2.5, delta_time))
		M.losebreath += 1
	if(DT_PROB(4, delta_time))
		to_chat(M, span_danger("Чувствую пугающую слабость!"))
		M.Stun(40)
		M.adjustToxLoss(2*REM * normalise_creation_purity(), 0)
	return ..()

/datum/reagent/toxin/bad_food
	name = "Плохая Еда"
	enname = "Bad food"
	description = "Результат какого-то мерзкого кулинарного искусства, еда настолько плоха, что токсична."
	reagent_state = LIQUID
	color = "#d6d6d8"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	toxpwr = 0.5
	taste_description = "говно"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/itching_powder
	name = "Чесоточный Порошок"
	enname = "Itching Powder"
	description = "Порошок, вызывающий зуд при контакте с кожей. Заставляет жертву чесать её конечности и имеет очень малый шанс на распад в Гистомин."
	silent_toxin = TRUE
	reagent_state = LIQUID
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	color = "#C8C8C8"
	metabolization_rate = 0.4 * REAGENTS_METABOLISM
	toxpwr = 0
	ph = 7
	penetrates_skin = TOUCH|VAPOR
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/itching_powder/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(DT_PROB(8, delta_time))
		to_chat(M, span_danger("Чешу голову."))
		M.adjustBruteLoss(0.2*REM, 0)
		. = 1
	if(DT_PROB(8, delta_time))
		to_chat(M, span_danger("Чешу ногу."))
		M.adjustBruteLoss(0.2*REM, 0)
		. = 1
	if(DT_PROB(8, delta_time))
		to_chat(M, span_danger("Чешу руку."))
		M.adjustBruteLoss(0.2*REM, 0)
		. = TRUE
	if(DT_PROB(1.5, delta_time))
		holder.add_reagent(/datum/reagent/toxin/histamine,rand(1,3))
		holder.remove_reagent(/datum/reagent/toxin/itching_powder,1.2)
		return
	..()

/datum/reagent/toxin/initropidril
	name = "Инитропидрил"
	enname = "Initropidril"
	description = "Мощный яд с коварным действием. Он может спровоцировать оглушение, остановку дыхания и сердечный приступ."
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#7F10C0"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 2.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/initropidril/on_mob_life(mob/living/carbon/C, delta_time, times_fired)
	if(DT_PROB(13, delta_time))
		var/picked_option = rand(1,3)
		switch(picked_option)
			if(1)
				C.Paralyze(60)
				. = TRUE
			if(2)
				C.losebreath += 10
				C.adjustOxyLoss(rand(5,25), 0)
				. = TRUE
			if(3)
				if(!C.undergoing_cardiac_arrest() && C.can_heartattack())
					C.set_heartattack(TRUE)
					if(C.stat == CONSCIOUS)
						C.visible_message(span_userdanger("[C] хватается за свою грудь, будто бы [C.ru_ego()] сердце остановилось!"))
				else
					C.losebreath += 10
					C.adjustOxyLoss(rand(5,25), 0)
					. = TRUE
	return ..() || .

/datum/reagent/toxin/pancuronium
	name = "Панкуроний"
	enname = "Pancuronium"
	description = "Скрытный токсин, который быстро выводит из строя свою жертву. Также может вызвать остановку дыхания."
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#195096"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	toxpwr = 0
	taste_mult = 0 // undetectable, I guess?
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/pancuronium/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(current_cycle >= 10)
		M.Stun(40 * REM * delta_time)
		. = TRUE
	if(DT_PROB(10, delta_time))
		M.losebreath += 4
	..()

/datum/reagent/toxin/sodium_thiopental
	name = "Тиопентал Натрия"
	enname = "Sodium Thiopental"
	description = "Тиопентал Натрия вызывает сильную слабость у своей цели, после чего лишает её сознания."
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#6496FA"
	metabolization_rate = 0.75 * REAGENTS_METABOLISM
	toxpwr = 0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/sodium_thiopental/on_mob_add(mob/living/L, amount)
	. = ..()
	ADD_TRAIT(L, TRAIT_ANTICONVULSANT, name)

/datum/reagent/toxin/sodium_thiopental/on_mob_delete(mob/living/L)
	. = ..()
	REMOVE_TRAIT(L, TRAIT_ANTICONVULSANT, name)

/datum/reagent/toxin/sodium_thiopental/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(current_cycle >= 10)
		M.Sleeping(40 * REM * delta_time)
	M.adjustStaminaLoss(10 * REM * delta_time, 0)
	..()
	return TRUE

/datum/reagent/toxin/sulfonal
	name = "Сульфонал"
	enname = "Sulfonal"
	description = "Скрытный яд, который наносит малый урон токсинами и усыпляет цель."
	silent_toxin = TRUE
	reagent_state = LIQUID
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	color = "#7DC3A0"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 0.5
	ph = 6
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/sulfonal/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(current_cycle >= 22)
		M.Sleeping(40 * REM * normalise_creation_purity())
	return ..()

/datum/reagent/toxin/amanitin
	name = "Аманитин"
	enname = "Amanitin"
	description = "Очень мощный токсин замедленного действия. После полного цикла метаболизма, будет нанесен огромный урон токсинами, который зависит от того, насколько долго яд находился в кровотоке жертвы."
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#FFFFFF"
	toxpwr = 0
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/amanitin/on_mob_delete(mob/living/M)
	var/toxdamage = current_cycle*3*REM
	M.log_message("has taken [toxdamage] toxin damage from amanitin toxin", LOG_ATTACK)
	M.adjustToxLoss(toxdamage)
	..()

/datum/reagent/toxin/lipolicide
	name = "Липолицид"
	enname = "Lipolicide"
	description = "Мощный токсин, который разрушает жировые клетки, значительно снижая массу тела за короткое время. Смертельно опасен для тех, у кого в организме нет питательных веществ."
	silent_toxin = TRUE
	taste_description = "нафталин"
	reagent_state = LIQUID
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	color = "#F0FFF0"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 0
	ph = 6
	impure_chem = /datum/reagent/impurity/ipecacide
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/lipolicide/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.nutrition <= NUTRITION_LEVEL_STARVING)
		M.adjustToxLoss(1 * REM * delta_time, 0)
	M.adjust_nutrition(-3 * REM * normalise_creation_purity()) // making the chef more valuable, one meme trap at a time
	M.overeatduration = 0
	return ..()

/datum/reagent/toxin/coniine
	name = "Кониин"
	enname = "Coniine"
	description = "Кониин крайне медленно усваивается, но наносит большой урон токсинами и останавливает дыхание."
	reagent_state = LIQUID
	color = "#7DC3A0"
	metabolization_rate = 0.06 * REAGENTS_METABOLISM
	toxpwr = 1.75
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/coniine/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.losebreath += 5 * REM * delta_time
	return ..()

/datum/reagent/toxin/spewium
	name = "Спьювиум"
	enname = "Spewium"
	description = "Сильное средство, провоцирует неконтролируюмую рвоту. При введении большой дозы, цель может выблевать собственные органы."
	reagent_state = LIQUID
	color = "#2f6617" //A sickly green color
	metabolization_rate = REAGENTS_METABOLISM
	overdose_threshold = 29
	toxpwr = 0
	taste_description = "блевотня"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	var/vomiting_cycle = 11

/datum/reagent/toxin/spewium/fast
	name = "Быстрый Спьювиум"
	enname = "Speedy Spewium"
	vomiting_cycle = 3

/datum/reagent/toxin/spewium/on_mob_life(mob/living/carbon/C, delta_time, times_fired)
	. = ..()
	if(current_cycle >= vomiting_cycle && DT_PROB(min(30, current_cycle), delta_time))
		C.vomit(10, prob(10), prob(50), rand(0,4), TRUE)
		for(var/datum/reagent/toxin/R in C.reagents.reagent_list)
			if(R != src)
				C.reagents.remove_reagent(R.type,1)

/datum/reagent/toxin/spewium/overdose_process(mob/living/carbon/C, delta_time, times_fired)
	. = ..()
	if(current_cycle >= 33 && DT_PROB(7.5, delta_time))
		C.spew_organ()
		C.vomit(0, TRUE, TRUE, 4)
		to_chat(C, span_userdanger("Чувствую как ком встает в горле во время рвоты."))

/datum/reagent/toxin/curare
	name = "Кураре"
	enname = "Curare"
	description = "Вызывает небольшой урон токсинами, сопровождающиеся оглушениями и удушением."
	reagent_state = LIQUID
	color = "#191919"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 1
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/curare/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(current_cycle >= 11)
		M.Paralyze(60 * REM * delta_time)
	M.adjustOxyLoss(0.5*REM*delta_time, 0)
	. = TRUE
	..()

/datum/reagent/toxin/heparin //Based on a real-life anticoagulant. I'm not a doctor, so this won't be realistic.
	name = "Гепарин"
	enname = "Heparin"
	description = "Сильный антикоагулянт. Все порезы и раны на жертве откроются и будут кровоточить гораздо быстрее"
	silent_toxin = TRUE
	reagent_state = LIQUID
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	color = "#C8C8C8" //RGB: 200, 200, 200
	metabolization_rate = 0.2 * REAGENTS_METABOLISM
	toxpwr = 0
	ph = 11.6
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/heparin/on_mob_metabolize(mob/living/M)
	ADD_TRAIT(M, TRAIT_BLOODY_MESS, /datum/reagent/toxin/heparin)
	return ..()

/datum/reagent/toxin/heparin/on_mob_end_metabolize(mob/living/M)
	REMOVE_TRAIT(M, TRAIT_BLOODY_MESS, /datum/reagent/toxin/heparin)
	return ..()

/datum/reagent/toxin/rotatium //Rotatium. Fucks up your rotation and is hilarious
	name = "Вращаний"
	enname = "Rotatium"
	description = "Постоянно кружащаяся, странного цвета жидкость. Приводит к нарушению чувства направления и зрительно-моторной координации потребителя."
	silent_toxin = TRUE
	reagent_state = LIQUID
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	color = "#AC88CA" //RGB: 172, 136, 202
	metabolization_rate = 0.6 * REAGENTS_METABOLISM
	toxpwr = 0.5
	ph = 6.2
	taste_description = "крутилка"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/rotatium/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.hud_used)
		if(current_cycle >= 20 && (current_cycle % 20) == 0)
			var/atom/movable/plane_master_controller/pm_controller = M.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]

			var/rotation = min(round(current_cycle/20), 89) // By this point the player is probably puking and quitting anyway
			for(var/atom/movable/screen/plane_master/plane as anything in pm_controller.get_planes())
				animate(plane, transform = matrix(rotation, MATRIX_ROTATE), time = 5, easing = QUAD_EASING, loop = -1)
				animate(transform = matrix(-rotation, MATRIX_ROTATE), time = 5, easing = QUAD_EASING)
	return ..()

/datum/reagent/toxin/rotatium/on_mob_end_metabolize(mob/living/M)
	if(M?.hud_used)
		var/atom/movable/plane_master_controller/pm_controller = M.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]
		for(var/atom/movable/screen/plane_master/plane as anything in pm_controller.get_planes())
			animate(plane, transform = matrix(), time = 5, easing = QUAD_EASING)
	..()

/datum/reagent/toxin/anacea
	name = "Анацея"
	enname = "Anacea"
	description = "Токсин, который быстро выводит лекарства и очень медленно метаболизируется."
	reagent_state = LIQUID
	color = "#3C5133"
	metabolization_rate = 0.08 * REAGENTS_METABOLISM
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 0.15
	ph = 8
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/anacea/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	var/remove_amt = 5
	if(holder.has_reagent(/datum/reagent/medicine/calomel) || holder.has_reagent(/datum/reagent/medicine/pen_acid))
		remove_amt = 0.5
	for(var/datum/reagent/medicine/R in M.reagents.reagent_list)
		M.reagents.remove_reagent(R.type, remove_amt * REM * normalise_creation_purity())
	return ..()

//ACID


/datum/reagent/toxin/acid
	name = "Серная кислота"
	enname = "Sulphuric acid"
	description = "Сильный минеральная кислота с молекулярной формулой H2SO4."
	color = "#00FF32"
	toxpwr = 1
	var/acidpwr = 10 //the amount of protection removed from the armour
	taste_description = "кислота"
	self_consuming = TRUE
	ph = 2.75
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

// ...Why? I mean, clearly someone had to have done this and thought, well, acid doesn't hurt plants, but what brought us here, to this point?
/datum/reagent/toxin/acid/on_hydroponics_apply(obj/item/seeds/myseed, datum/reagents/chems, obj/machinery/hydroponics/mytray, mob/user)
	. = ..()
	if(chems.has_reagent(type, 1))
		mytray.adjustHealth(-round(chems.get_reagent_amount(type) * 1))
		mytray.adjustToxic(round(chems.get_reagent_amount(type) * 1.5))
		mytray.adjustWeeds(-rand(1,2))

/datum/reagent/toxin/acid/expose_mob(mob/living/carbon/exposed_carbon, methods=TOUCH, reac_volume)
	. = ..()
	if(!istype(exposed_carbon))
		return
	reac_volume = round(reac_volume,0.1)
	if(methods & INGEST)
		exposed_carbon.adjustBruteLoss(min(6*toxpwr, reac_volume * toxpwr))
		return
	if(methods & INJECT)
		exposed_carbon.adjustBruteLoss(1.5 * min(6*toxpwr, reac_volume * toxpwr))
		return
	exposed_carbon.acid_act(acidpwr, reac_volume)

/datum/reagent/toxin/acid/expose_obj(obj/exposed_obj, reac_volume)
	. = ..()
	if(ismob(exposed_obj.loc)) //handled in human acid_act()
		return
	reac_volume = round(reac_volume,0.1)
	exposed_obj.acid_act(acidpwr, reac_volume)

/datum/reagent/toxin/acid/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()
	if (!istype(exposed_turf))
		return
	reac_volume = round(reac_volume,0.1)
	exposed_turf.acid_act(acidpwr, reac_volume)

/datum/reagent/toxin/acid/fluacid
	name = "Фтористоводородная кислота"
	enname = "Fluorosulfuric acid"
	description = "Фтористоводородная кислота является чрезвычайно коррозийным химическим веществом."
	color = "#5050FF"
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 2
	acidpwr = 42.0
	ph = 0.0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

// SERIOUSLY
/datum/reagent/toxin/acid/fluacid/on_hydroponics_apply(obj/item/seeds/myseed, datum/reagents/chems, obj/machinery/hydroponics/mytray, mob/user)
	. = ..()
	if(chems.has_reagent(type, 1))
		mytray.adjustHealth(-round(chems.get_reagent_amount(type) * 2))
		mytray.adjustToxic(round(chems.get_reagent_amount(type) * 3))
		mytray.adjustWeeds(-rand(1,4))

/datum/reagent/toxin/acid/fluacid/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjustFireLoss((current_cycle/15) * REM * normalise_creation_purity(), 0)
	. = TRUE
	..()

/datum/reagent/toxin/acid/nitracid
	name = "Азотная кислота"
	enname = "Nitric acid"
	description = "Азотная кислота - чрезвычайно едкое химическое вещество, которое бурно реагирует с живыми органическими тканями."
	color = "#5050FF"
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 3
	acidpwr = 5.0
	ph = 1.3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/acid/nitracid/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjustFireLoss((volume/10) * REM * normalise_creation_purity(), FALSE) //here you go nervar
	. = TRUE
	..()

/datum/reagent/toxin/delayed
	name = "Микрокапсулы Токсина"
	enname = "Toxin Microcapsules"
	description = "Провоцируют тяжелый урон токсинами после короткого временеи покоя."
	reagent_state = LIQUID
	metabolization_rate = 0 //stays in the system until active.
	var/actual_metaboliztion_rate = REAGENTS_METABOLISM
	toxpwr = 0
	var/actual_toxpwr = 5
	var/delay = 30
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/delayed/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(current_cycle > delay)
		holder.remove_reagent(type, actual_metaboliztion_rate * M.metabolism_efficiency * delta_time)
		M.adjustToxLoss(actual_toxpwr * REM * delta_time, 0)
		if(DT_PROB(5, delta_time))
			M.Paralyze(20)
		. = TRUE
	..()

/datum/reagent/toxin/mimesbane
	name = "Отрава Мима"
	enname = "Mime's Bane"
	description = "Несмертельный нейротоксин, нарушающий способность жертвы жестикулировать."
	silent_toxin = TRUE
	color = "#F0F8FF" // rgb: 240, 248, 255
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 0
	ph = 1.7
	taste_description = "неподвижность"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/mimesbane/on_mob_metabolize(mob/living/L)
	ADD_TRAIT(L, TRAIT_EMOTEMUTE, type)

/datum/reagent/toxin/mimesbane/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_EMOTEMUTE, type)

/datum/reagent/toxin/bonehurtingjuice //oof ouch
	name = "Ранящий Кости Сок"
	enname = "Bone Hurting Juice"
	description = "Странная субстанция, которая сильна похожа на воду. Пить его странно заманчиво. Уф ауч."
	silent_toxin = TRUE //no point spamming them even more.
	color = "#AAAAAA77" //RGBA: 170, 170, 170, 77
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 0
	ph = 3.1
	taste_description = "костянка"
	overdose_threshold = 50
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/bonehurtingjuice/on_mob_add(mob/living/carbon/M)
	M.say("oof ouch my bones", forced = /datum/reagent/toxin/bonehurtingjuice) // stop translating memes you fucking shitboots
	return ..()

/datum/reagent/toxin/bonehurtingjuice/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjustStaminaLoss(7.5 * REM * delta_time, 0)
	if(DT_PROB(10, delta_time))
		switch(rand(1, 3))
			if(1)
				M.say(pick("уф.", "ауч.", "мои кости.", "уф ауч.", "уф ауч, мои кости."), forced = /datum/reagent/toxin/bonehurtingjuice)
			if(2)
				M.manual_emote(pick("oofs silently.", "looks like their bones hurt.", "grimaces, as though their bones hurt."))
			if(3)
				to_chat(M, span_warning("Мои кости болят!"))
	return ..()

/datum/reagent/toxin/bonehurtingjuice/overdose_process(mob/living/carbon/M, delta_time, times_fired)
	if(DT_PROB(2, delta_time) && iscarbon(M)) //big oof
		var/selected_part = pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG) //God help you if the same limb gets picked twice quickly.
		var/obj/item/bodypart/bp = M.get_bodypart(selected_part)
		if(bp)
			playsound(M, get_sfx("desecration"), 50, TRUE, -1)
			M.visible_message(span_warning("Кости [M] очень сильно болят!!") , span_danger("Мои кости очень сильно болят!!"))
			M.say("OOF!!", forced = /datum/reagent/toxin/bonehurtingjuice)
			bp.receive_damage(20, 0, 200, wound_bonus = rand(30, 130))
		else //SUCH A LUST FOR REVENGE!!!
			to_chat(M, span_warning("Фантомная конечность болит!"))
			M.say("Why are we still here, just to suffer?", forced = /datum/reagent/toxin/bonehurtingjuice)
	return ..()

/datum/reagent/toxin/bungotoxin
	name = "Bungotoxin"
	enname = "Bungotoxin"
	description = "A horrible cardiotoxin that protects the humble bungo pit."
	silent_toxin = TRUE
	color = "#EBFF8E"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 0
	taste_description = "дубильня"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/bungotoxin/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjustOrganLoss(ORGAN_SLOT_HEART, 3 * REM * delta_time)
	M.set_confusion(M.dizziness) //add a tertiary effect here if this is isn't an effective poison.
	if(current_cycle >= 12 && DT_PROB(4, delta_time))
		var/tox_message = pick("You feel your heart spasm in your chest.", "You feel faint.","You feel you need to catch your breath.","You feel a prickle of pain in your chest.")
		to_chat(M, span_notice("[tox_message]"))
	. = TRUE
	..()

/datum/reagent/toxin/skewium
	name = "Скевий"
	enname = "Skewium"
	description = "Странная, тускло окрашанная жидкость которая, кажется, искривляется взад и вперед внутри своего контейнера. Вызывает у любого потребителя визуальные явления, похожие на упомянутое искривление."
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#ADBDCD"
	metabolization_rate = 0.8 * REAGENTS_METABOLISM
	toxpwr = 0.25
	taste_description = "перекос"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/skewium/on_mob_life(mob/living/carbon/M)
	if(M.hud_used)
		if(current_cycle >= 5 && current_cycle % 3 == 0)
			var/list/screens = list(M.hud_used.get_plane_master(FLOOR_PLANE), M.hud_used.get_plane_master(GAME_PLANE), M.hud_used.get_plane_master(LIGHTING_PLANE))
			var/matrix/skew = matrix()
			var/intensity = 8
			skew.set_skew(rand(-intensity,intensity), rand(-intensity,intensity))
			var/matrix/newmatrix = skew

			if(prob(33)) // 1/3rd of the time, let's make it stack with the previous matrix! Mwhahahaha!
				var/atom/movable/screen/plane_master/PM = M.hud_used.get_plane_master(GAME_PLANE)
				newmatrix = skew * PM.transform

			for(var/whole_screen in screens)
				animate(whole_screen, transform = newmatrix, time = 5, easing = QUAD_EASING, loop = -1)
				animate(transform = -newmatrix, time = 5, easing = QUAD_EASING)
	return ..()

/datum/reagent/toxin/skewium/on_mob_end_metabolize(mob/living/M)
	if(M && M.hud_used)
		var/list/screens = list(M.hud_used.get_plane_master(FLOOR_PLANE), M.hud_used.get_plane_master(GAME_PLANE), M.hud_used.get_plane_master(LIGHTING_PLANE))
		for(var/whole_screen in screens)
			animate(whole_screen, transform = matrix(), time = 5, easing = QUAD_EASING)
	..()

/datum/reagent/toxin/leadacetate
	name = "Ацетат Свинца"
	enname = "Lead Acetate"
	description = "Использовался сотни лет назад в качестве подсластителя, до того, как узнали, что он крайне ядовит."
	reagent_state = SOLID
	color = "#2b2b2b" // rgb: 127, 132, 0
	toxpwr = 0.5
	taste_mult = 1.3
	taste_description = "сладкая сладость"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/leadacetate/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjustOrganLoss(ORGAN_SLOT_EARS, 1 * REM * delta_time)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 1 * REM * delta_time)
	if(DT_PROB(0.5, delta_time))
		to_chat(M, span_notice("А, что это было? Кажется, я что-то слышал..."))
		M.add_confusion(5)
	return ..()

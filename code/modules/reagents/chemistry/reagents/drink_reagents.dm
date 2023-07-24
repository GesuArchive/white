

/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// DRINKS BELOW, Beer is up there though, along with cola. Cap'n Pete's Cuban Spiced Rum////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/reagent/consumable/orangejuice
	name = "Апельсиновый сок"
	description = "Обладает отличным вкусом и богат витамином C, что еще нужно для счастья?"
	color = "#E78108" // rgb: 231, 129, 8
	taste_description = "апельсины"
	glass_icon_state = "glass_orange"
	glass_name = "апельсиновый сок"
	glass_desc = "Витамины! Ура!"
	ph = 3.3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/orangejuice/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.getOxyLoss() && DT_PROB(16, delta_time))
		M.adjustOxyLoss(-1, 0)
		. = TRUE
	..()

/datum/reagent/consumable/tomatojuice
	name = "Томатный сок"
	description = "Из томатов делают сок. Какая трата больших, сочных томатов, а?"
	color = "#731008" // rgb: 115, 16, 8
	taste_description = "томаты"
	glass_icon_state = "glass_red"
	glass_name = "томатный сок"
	glass_desc = "А вы точно уверены, что это томатный сок?"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/tomatojuice/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.getFireLoss() && DT_PROB(10, delta_time))
		M.heal_bodypart_damage(0, 1, 0)
		. = TRUE
	..()

/datum/reagent/consumable/limejuice
	name = "Сок лайма"
	description = "The sweet-sour juice of limes."
	color = "#365E30" // rgb: 54, 94, 48
	taste_description = "невыносимая кислинка"
	glass_icon_state = "glass_green"
	glass_name = "сок лайма"
	glass_desc = "Стакан кисло-сладкого сока лайма."
	ph = 2.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/limejuice/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.getToxLoss() && DT_PROB(10, delta_time))
		M.adjustToxLoss(-1, 0)
		. = TRUE
	..()

/datum/reagent/consumable/carrotjuice
	name = "Морковный сок"
	description = "Это как морковь, но без привычного хруста."
	color = "#973800" // rgb: 151, 56, 0
	taste_description = "морковки"
	glass_icon_state = "carrotjuice"
	glass_name = "морковный сок"
	glass_desc = "Это как морковь, но без привычного хруста."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/carrotjuice/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjust_blurriness(-1 * REM * delta_time)
	M.adjust_blindness(-1 * REM * delta_time)
	switch(current_cycle)
		if(1 to 20)
			//nothing
		if(21 to 110)
			if(DT_PROB(100 * (1 - (sqrt(110 - current_cycle) / 10)), delta_time))
				M.cure_nearsighted(list(EYE_DAMAGE))
		if(110 to INFINITY)
			M.cure_nearsighted(list(EYE_DAMAGE))
	..()
	return

/datum/reagent/consumable/berryjuice
	name = "Ягодный сок"
	description = "Восхитительный микс нескольких сортов ягод."
	color = "#863333" // rgb: 134, 51, 51
	taste_description = "ягоды"
	glass_icon_state = "berryjuice"
	glass_name = "ягодный сок"
	glass_desc = "Ягодный сок. А может, это джем. Какая разница?"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/applejuice
	name = "Яблочный сок"
	description = "Сладкий яблочный сок, подходящий для всех возрастов."
	color = "#ECFF56" // rgb: 236, 255, 86
	taste_description = "яблоки"
	ph = 3.2 // ~ 2.7 -> 3.7
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/poisonberryjuice
	name = "Ядовитый ягодный сок"
	description = "Вкусный сок, приготовленный из нескольких видов смертоносных и ядовитых ягод."
	color = "#863353" // rgb: 134, 51, 83
	taste_description = "ягоды"
	glass_icon_state = "poisonberryjuice"
	glass_name = "ягодный сок"
	glass_desc = "Ягодный сок. А может, это яд. Кому какое дело?"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/poisonberryjuice/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjustToxLoss(1 * REM * delta_time, 0)
	. = TRUE
	..()

/datum/reagent/consumable/watermelonjuice
	name = "Арбузный сок"
	description = "Восхитительный сок из арбузов."
	color = "#863333" // rgb: 134, 51, 51
	taste_description = "сочный арбуз"
	glass_icon_state = "glass_red"
	glass_name = "арбузный сок"
	glass_desc = "Стакан арбузного сока."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

/datum/reagent/consumable/lemonjuice
	name = "Лимонный сок"
	description = "Этот сок ОЧЕНЬ кислый."
	color = "#863333" // rgb: 175, 175, 0
	taste_description = "кислотность"
	glass_icon_state  = "lemonglass"
	glass_name = "лимонный сок"
	glass_desc = "Кисло..."
	ph = 2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/banana
	name = "Банановый сок"
	description = "Чистейший экстракт банана. ХОНК!"
	color = "#863333" // rgb: 175, 175, 0
	taste_description = "банан"
	glass_icon_state = "banana"
	glass_name = "банановый сок"
	glass_desc = "Чистейший экстракт банана. ХОНК!"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/banana/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	var/obj/item/organ/liver/liver = M.get_organ_slot(ORGAN_SLOT_LIVER)
	if((liver && HAS_TRAIT(liver, TRAIT_COMEDY_METABOLISM)) || ismonkey(M))
		M.heal_bodypart_damage(1 * REM * delta_time, 1 * REM * delta_time, 0)
		. = TRUE
	..()

/datum/reagent/consumable/nothing
	name = "Ничего"
	description = "Абсолютное ничто."
	taste_description = "ничего"
	glass_icon_state = "nothing"
	glass_name = "nothing"
	glass_desc = "Абсолютное ничто."
	shot_glass_icon_state = "shotglass"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

/datum/reagent/consumable/nothing/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(ishuman(M) && M.mind?.miming)
		M.silent = max(M.silent, MIMEDRINK_SILENCE_DURATION)
		M.heal_bodypart_damage(1 * REM * delta_time, 1 * REM * delta_time)
		. = TRUE
	..()

/datum/reagent/consumable/laughter
	name = "Хохотач"
	description = "Некоторые говорят, что это лучшее лекарство, но последние исследования доказали, что это неправда."
	metabolization_rate = INFINITY
	color = "#FF4DD2"
	taste_description = "ржака"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

/datum/reagent/consumable/laughter/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.emote("laugh")
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "chemical_laughter", /datum/mood_event/chemical_laughter)
	..()

/datum/reagent/consumable/superlaughter
	name = "Полный хохотач"
	description = "Забавно до тех пор, пока ты не начнешь понимать, что ты не можешь остановиться."
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	color = "#FF4DD2"
	taste_description = "ржака"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

/datum/reagent/consumable/superlaughter/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(DT_PROB(16, delta_time))
		M.visible_message(span_danger("[M] разразился приступом неконтролируемого смеха!") , span_userdanger("Зашелся в приступе неконтролируемого смеха!"))
		M.Stun(5)
		SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "chemical_laughter", /datum/mood_event/chemical_superlaughter)
	..()

/datum/reagent/consumable/potato_juice
	name = "Картофельный сок"
	description = "Сок из картофеля. Фу."
	nutriment_factor = 2 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0
	taste_description = "ирландская грусть"
	glass_icon_state = "glass_brown"
	glass_name = "картофельный сок"
	glass_desc = "Фу..."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/grapejuice
	name = "Виноградный сок"
	description = "Сок из виноградной грозди. Гарантированно безалкогольный."
	color = "#290029" // dark purple
	taste_description = "виноградная сода"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/milk
	name = "Молоко"
	description = "Непрозрачная белая жидкость, вырабатываемая молочными железами млекопитающих."
	color = "#DFDFDF" // rgb: 223, 223, 223
	taste_description = "молоко"
	glass_icon_state = "glass_white"
	glass_name = "молоко"
	glass_desc = "Белая и питательная вкуснятина." //(?) Пейте дети молоко, будете здоровы!
	ph = 6.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

	// Milk is good for humans, but bad for plants. The sugars cannot be used by plants, and the milk fat harms growth. Not shrooms though. I can't deal with this now...
/datum/reagent/consumable/milk/on_hydroponics_apply(obj/item/seeds/myseed, datum/reagents/chems, obj/machinery/hydroponics/mytray, mob/user)
	. = ..()
	if(chems.has_reagent(type, 1))
		mytray.adjustWater(round(chems.get_reagent_amount(type) * 0.3))
		if(myseed)
			myseed.adjust_potency(-chems.get_reagent_amount(type) * 0.5)

/datum/reagent/consumable/milk/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.getBruteLoss() && DT_PROB(10, delta_time))
		M.heal_bodypart_damage(1,0, 0)
		. = TRUE
	if(holder.has_reagent(/datum/reagent/consumable/capsaicin))
		holder.remove_reagent(/datum/reagent/consumable/capsaicin, 1 * delta_time)
	..()

/datum/reagent/consumable/soymilk
	name = "Соевое молоко"
	description = "Непрозрачная белая жидкость из соевых бобов."
	color = "#DFDFC7" // rgb: 223, 223, 199
	taste_description = "соевое молоко"
	glass_icon_state = "glass_white"
	glass_name = "соевое молоко"
	glass_desc = "Не так хорошо, как обычное молоко, но пить можно."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/soymilk/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.getBruteLoss() && DT_PROB(10, delta_time))
		M.heal_bodypart_damage(1, 0, 0)
		. = TRUE
	..()

/datum/reagent/consumable/cream
	name = "Сливки"
	description = "Жирные сливки, изготовленные из натурального молока. Почему бы тебе не смешать это со скотчем, а?"
	color = "#DFD7AF" // rgb: 223, 215, 175
	taste_description = "сливочное молоко"
	glass_icon_state  = "glass_white"
	glass_name = "сливки"
	glass_desc = "Не содержит ГМО."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/cream/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.getBruteLoss() && DT_PROB(10, delta_time))
		M.heal_bodypart_damage(1, 0, 0)
		. = TRUE
	..()

/datum/reagent/consumable/coffee
	name = "Кофе"
	description = "Кофе - это напиток, приготовленный из обжаренных кофейных зерен."
	color = "#482000" // rgb: 72, 32, 0
	nutriment_factor = 0
	overdose_threshold = 80
	taste_description = "горечь"
	glass_icon_state = "glass_brown"
	glass_name = "кофе"
	glass_desc = "Не уроните его, иначе вы обожжетесь!"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_STOCK
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

/datum/reagent/consumable/coffee/overdose_process(mob/living/M, delta_time, times_fired)
	M.Jitter(5 * REM * delta_time)
	..()

/datum/reagent/consumable/coffee/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.dizziness = max(M.dizziness - (5 * REM * delta_time), 0)
	M.drowsyness = max(M.drowsyness - (3 * REM * delta_time), 0)
	M.AdjustSleeping(-40 * REM * delta_time)
	//310.15 is the normal bodytemp.
	M.adjust_bodytemperature(25 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, 0, M.get_body_temp_normal())
	if(holder.has_reagent(/datum/reagent/consumable/frostoil))
		holder.remove_reagent(/datum/reagent/consumable/frostoil, 5 * REM * delta_time)
	..()
	. = TRUE

/datum/reagent/consumable/tea
	name = "Чай"
	description = "Вкусный черный чай, в нем есть антиоксиданты, он полезен для здоровья!"
	color = "#101000" // rgb: 16, 16, 0
	nutriment_factor = 0
	taste_description = "пирог и черный чай"
	glass_icon_state = "teaglass"
	glass_name = "чай"
	glass_desc = "Пить его из стакана кажется неправильным."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_STOCK
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

/datum/reagent/consumable/tea/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.dizziness = max(M.dizziness - (2 * REM * delta_time), 0)
	M.drowsyness = max(M.drowsyness - (1 * REM * delta_time), 0)
	M.jitteriness = max(M.jitteriness - (3 * REM * delta_time), 0)
	M.AdjustSleeping(-20 * REM * delta_time)
	if(M.getToxLoss() && DT_PROB(10, delta_time))
		M.adjustToxLoss(-1, 0)
	M.adjust_bodytemperature(20 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, 0, M.get_body_temp_normal())
	..()
	. = TRUE

/datum/reagent/consumable/lemonade
	name = "Лимонад"
	description = "Сладкий, терпкий лимонад."
	color = "#FFE978"
	quality = DRINK_NICE
	taste_description = "солнце и лето"
	glass_icon_state = "lemonpitcher"
	glass_name = "лимонад"
	glass_desc = "Этот напиток почему-то вызывает воспоминания о детстве."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_EASY
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

/datum/reagent/consumable/tea/arnold_palmer
	name = "Арнольд Палмер"
	description = "Поощряет пациента к игре в гольф."
	color = "#FFB766"
	quality = DRINK_NICE
	nutriment_factor = 2
	taste_description = "горький чай"
	glass_icon_state = "arnold_palmer"
	glass_name = "Арнольд Палмер"
	glass_desc = "После нескольких глотков вы начинаете вспоминать о своем любимом спорте."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/tea/arnold_palmer/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(DT_PROB(2.5, delta_time))
		to_chat(M, span_notice("[pick("Вспомнил что нужно расправить плечи.","Вспомнил что нужно опустить голову.","Не могу решить что делать, расправить плечи или опустить голову.","Вспомнил что нужно расслабиться.","Думаю, однажды, я улучшу свой счет в гольфе, снизив его на два удара.")]"))
	..()
	. = TRUE

/datum/reagent/consumable/icecoffee
	name = "Кофе со льдом"
	description = "Кофе со льдом, бодрит и охлаждает."
	color = "#102838" // rgb: 16, 40, 56
	nutriment_factor = 0
	taste_description = "горький холод"
	glass_icon_state = "icedcoffeeglass"
	glass_name = "кофе со льдом"
	glass_desc = "Напиток, который взбодрит и охладит вас!"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

/datum/reagent/consumable/icecoffee/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.dizziness = max(M.dizziness - (5 * REM * delta_time), 0)
	M.drowsyness = max(M.drowsyness - (3 * REM * delta_time), 0)
	M.AdjustSleeping(-40 * REM * delta_time)
	M.adjust_bodytemperature(-5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, M.get_body_temp_normal())
	M.Jitter(5 * REM * delta_time)
	..()
	. = TRUE

/datum/reagent/consumable/hot_ice_coffee
	name = "Кофе с горячим льдом"
	description = "Кофе с горячими осколками льда."
	color = "#102838" // rgb: 16, 40, 56
	nutriment_factor = 0
	taste_description = "горечь и намёк на дым"
	glass_icon_state = "hoticecoffee"
	glass_name = "кофе с горячим льдом"
	glass_desc = "Буквально острый!"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

/datum/reagent/consumable/hot_ice_coffee/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.dizziness = max(M.dizziness - (5 * REM * delta_time), 0)
	M.drowsyness = max(M.drowsyness - (3 * REM * delta_time), 0)
	M.AdjustSleeping(-60 * REM * delta_time)
	M.adjust_bodytemperature(-7 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, M.get_body_temp_normal())
	M.Jitter(5 * REM * delta_time)
	M.adjustToxLoss(1 * REM * delta_time, 0)
	..()
	. = TRUE

/datum/reagent/consumable/icetea
	name = "Чай со льдом"
	description = "Не имеет отношения к определенному рэп исполнителю."
	color = "#104038" // rgb: 16, 64, 56
	nutriment_factor = 0
	taste_description = "сладкий чай"
	glass_icon_state = "icedteaglass"
	glass_name = "чай со льдом"
	glass_desc = "Натуральный, богатый антиоксидантами аромат."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

/datum/reagent/consumable/icetea/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.dizziness = max(M.dizziness - (2 * REM * delta_time), 0)
	M.drowsyness = max(M.drowsyness - (1 * REM * delta_time), 0)
	M.AdjustSleeping(-40 * REM * delta_time)
	if(M.getToxLoss() && DT_PROB(10, delta_time))
		M.adjustToxLoss(-1, 0)
	M.adjust_bodytemperature(-5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, M.get_body_temp_normal())
	..()
	. = TRUE

/datum/reagent/consumable/space_cola
	name = "Космо-Кола"
	description = "Освежающий напиток."
	color = "#100800" // rgb: 16, 8, 0
	taste_description = "кола"
	glass_icon_state  = "spacecola"
	glass_name = "Космо-Кола"
	glass_desc = "Стакан освежающей колы."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/space_cola/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.drowsyness = max(M.drowsyness - (5 * REM * delta_time), 0)
	M.adjust_bodytemperature(-5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, M.get_body_temp_normal())
	..()

/datum/reagent/consumable/nuka_cola
	name = "Нюка-Кола"
	description = "Кола. Кола никогда не меняется."
	special_sound = 'white/valtos/sounds/drink/fallout_3.ogg'
	color = "#100800" // rgb: 16, 8, 0
	quality = DRINK_VERYGOOD
	taste_description = "будущее"
	glass_icon_state = "nuka_colaglass"
	glass_name = "Нюка-Кола"
	glass_desc = "Не плачь, не поднимай голову. Это всего лишь ядерная пустошь."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/nuka_cola/on_mob_metabolize(mob/living/L)
	..()
	L.add_movespeed_modifier(/datum/movespeed_modifier/reagent/nuka_cola)

/datum/reagent/consumable/nuka_cola/on_mob_end_metabolize(mob/living/L)
	L.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/nuka_cola)
	..()

/datum/reagent/consumable/nuka_cola/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.Jitter(20 * REM * delta_time)
	M.set_drugginess(30 * REM * delta_time)
	M.dizziness += 1.5 * REM * delta_time
	M.drowsyness = 0
	M.AdjustSleeping(-40 * REM * delta_time)
	M.adjust_bodytemperature(-5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, M.get_body_temp_normal())
	..()
	. = TRUE

/datum/reagent/consumable/grey_bull
	name = "Grey Bull"
	description = "Grey Bull заземляет!"
	color = "#EEFF00" // rgb: 238, 255, 0
	quality = DRINK_VERYGOOD
	taste_description = "газированное масло"
	glass_icon_state = "grey_bull_glass"
	glass_name = "Grey Bull"
	glass_desc = "Удивительно, но он не серый."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/grey_bull/on_mob_metabolize(mob/living/L)
	..()
	ADD_TRAIT(L, TRAIT_SHOCKIMMUNE, type)

/datum/reagent/consumable/grey_bull/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_SHOCKIMMUNE, type)
	..()

/datum/reagent/consumable/grey_bull/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.Jitter(20 * REM * delta_time)
	M.dizziness += 1 * REM * delta_time
	M.drowsyness = 0
	M.AdjustSleeping(-40 * REM * delta_time)
	M.adjust_bodytemperature(-5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, M.get_body_temp_normal())
	..()

/datum/reagent/consumable/spacemountainwind
	name = "Солнечный Ветер"
	description = "Бодрящий напиток, который вдохновляет на новые открытия."
	color = "#102000" // rgb: 16, 32, 0
	taste_description = "сладкая цитрусовая сода"
	glass_icon_state = "Space_mountain_wind_glass"
	glass_name = "Солнечнй Ветер"
	glass_desc = "Космический горный ветер. Как вы знаете, в космосе нет гор, есть только ветер."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/spacemountainwind/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.drowsyness = max(M.drowsyness - (7 * REM * delta_time), 0)
	M.AdjustSleeping(-20 * REM * delta_time)
	M.adjust_bodytemperature(-5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, M.get_body_temp_normal())
	M.Jitter(5 * REM * delta_time)
	..()
	. = TRUE

/datum/reagent/consumable/dr_gibb
	name = "Dr. Gibb"
	description = "Восхитительная смесь из 42 различных вкусов."
	color = "#102000" // rgb: 16, 32, 0
	taste_description = "вишневая сода" // FALSE ADVERTISING
	glass_icon_state = "dr_gibb_glass"
	glass_name = "Dr. Gibb"
	glass_desc = "Dr. Gibb. Не так опасен, как может показаться из названия."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/dr_gibb/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.drowsyness = max(M.drowsyness - (6 * REM * delta_time), 0)
	M.adjust_bodytemperature(-5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, M.get_body_temp_normal())
	..()

/datum/reagent/consumable/space_up
	name = "На Взлёт!"
	description = "Вкус напоминает разгерму, как это?"
	color = "#00FF00" // rgb: 0, 255, 0
	taste_description = "вишневая сода"
	glass_icon_state = "space-up_glass"
	glass_name = "стакан Space-Up"
	glass_desc = "На Взлёт! Помогает сохранять хладнокровие."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/space_up/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjust_bodytemperature(-8 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, M.get_body_temp_normal())
	..()

/datum/reagent/consumable/lemon_lime
	name = "Лаймон-Флеш"
	description = "Терпкий напиток, состоящик из 0.5% натурального лайма!"
	color = "#8CFF00" // rgb: 135, 255, 0
	taste_description = "острый лайм и лимонная сода"
	glass_icon_state = "lemonlime"
	glass_name = "Лаймон-Флеш"
	glass_desc = "Вы уверены, что тут лайм?"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/lemon_lime/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjust_bodytemperature(-8 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, M.get_body_temp_normal())
	..()

/datum/reagent/consumable/pwr_game
	name = "PWR Game"
	description = "Единственный напиток с PWR, которого жаждут настоящие геймеры."
	color = "#9385bf" // rgb: 58, 52, 75
	taste_description = "сладкий и соленый запах"
	glass_icon_state = "pwrggame"
	glass_name = "PWR Game"
	glass_desc = "Я буду устанавливать сейчас все игры!"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/pwr_game/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if(exposed_mob?.mind?.get_skill_level(/datum/skill/gaming) >= SKILL_LEVEL_LEGENDARY && (methods & INGEST) && !HAS_TRAIT(exposed_mob, TRAIT_GAMERGOD))
		ADD_TRAIT(exposed_mob, TRAIT_GAMERGOD, "pwr_game")
		to_chat(exposed_mob, "<span class='nicegreen'>Выпив Pwr Game, я распахнул геймерский третий глаз... \
		Чувствую, будто мне открылась великая загадка вселенной...</span>")

/datum/reagent/consumable/pwr_game/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjust_bodytemperature(-8 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, M.get_body_temp_normal())
	if(DT_PROB(5, delta_time))
		M.mind?.adjust_experience(/datum/skill/gaming, 5)
	..()

/datum/reagent/consumable/shamblers
	name = "Сок Тьманника" //Darkest Dungeon
	description = "~Взболтай мне немного сока Тьманника!~"
	color = "#f00060" // rgb: 94, 0, 38
	taste_description = "газированная металлическая сода"
	glass_icon_state = "shamblerjuice"
	glass_name = "сок Тьманника"
	glass_desc = "Ммм, тьма!"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/shamblers/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjust_bodytemperature(-8 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, M.get_body_temp_normal())
	..()

/datum/reagent/consumable/sodawater
	name = "Газированная вода"
	description = "Банка содовой, почему бы не смешать ее со скотчем?"
	color = "#619494" // rgb: 97, 148, 148
	taste_description = "газировка"
	glass_icon_state = "glass_clearcarb"
	glass_name = "газированная вода"
	glass_desc = "Содовая. Почему бы не смешать ее со скотчем?"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

	// A variety of nutrients are dissolved in club soda, without sugar.
	// These nutrients include carbon, oxygen, hydrogen, phosphorous, potassium, sulfur and sodium, all of which are needed for healthy plant growth.
/datum/reagent/consumable/sodawater/on_hydroponics_apply(obj/item/seeds/myseed, datum/reagents/chems, obj/machinery/hydroponics/mytray, mob/user)
	. = ..()
	if(chems.has_reagent(type, 1))
		mytray.adjustWater(round(chems.get_reagent_amount(type) * 1))
		mytray.adjustHealth(round(chems.get_reagent_amount(type) * 0.1))

/datum/reagent/consumable/sodawater/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.dizziness = max(M.dizziness - (5 * REM * delta_time), 0)
	M.drowsyness = max(M.drowsyness - (3 * REM * delta_time), 0)
	M.adjust_bodytemperature(-5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, M.get_body_temp_normal())
	..()

/datum/reagent/consumable/tonic
	name = "Тонизирующая вода"
	description = "Вкус странный, но, по крайней мере, хинин держит космическую малярию на расстоянии."
	color = "#0064C8" // rgb: 0, 100, 200
	taste_description = "терпкий и свежий"
	glass_icon_state = "glass_clearcarb"
	glass_name = "тонизирующая вода"
	glass_desc = "У хинина странноватый вкус, но, по крайней мере, он убережет от космической малярии."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

/datum/reagent/consumable/tonic/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.dizziness = max(M.dizziness - (5 * REM * delta_time), 0)
	M.drowsyness = max(M.drowsyness - (3 * REM * delta_time), 0)
	M.AdjustSleeping(-40 * REM * delta_time)
	M.adjust_bodytemperature(-5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, M.get_body_temp_normal())
	..()
	. = TRUE

/datum/reagent/consumable/monkey_energy
	name = "Monkey Energy"
	description = "Дайте волю примату внутри вас!"
	color = "#f39b03" // rgb: 243, 155, 3
	overdose_threshold = 60
	taste_description = "барбекю и ностальгия"
	glass_icon_state = "monkey_energy_glass"
	glass_name = "Monkey Energy"
	glass_desc = "Дайте волю примату внутри вас!"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/monkey_energy/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.Jitter(40 * REM * delta_time)
	M.dizziness += 1 * REM * delta_time
	M.drowsyness = 0
	M.AdjustSleeping(-40 * REM * delta_time)
	M.adjust_bodytemperature(-5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, M.get_body_temp_normal())
	..()

/datum/reagent/consumable/monkey_energy/on_mob_metabolize(mob/living/L)
	..()
	if(ismonkey(L))
		L.add_movespeed_modifier(/datum/movespeed_modifier/reagent/monkey_energy)

/datum/reagent/consumable/monkey_energy/on_mob_end_metabolize(mob/living/L)
	L.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/monkey_energy)
	..()

/datum/reagent/consumable/monkey_energy/overdose_process(mob/living/M, delta_time, times_fired)
	if(DT_PROB(7.5, delta_time))
		M.say(pick_list_replacements(BOOMER_FILE, "boomer"), forced = /datum/reagent/consumable/monkey_energy)
	..()

/datum/reagent/consumable/ice
	name = "Лед"
	description = "Замороженная вода, вашему стоматологу не понравится, если вы будете ее жевать."
	reagent_state = SOLID
	color = "#619494" // rgb: 97, 148, 148
	taste_description = "лёд"
	glass_icon_state = "iceglass"
	glass_name = "лед"
	glass_desc = "Как правило, вы должны смешать его с чем-то еще..."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ice/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjust_bodytemperature(-5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, M.get_body_temp_normal())
	..()

/datum/reagent/consumable/soy_latte
	name = "Соевое латте"
	description = "Приятный и вкусный напиток, то что нужно, пока вы читаете свои хиппи-книги."
	color = "#664300" // rgb: 102, 67, 0
	quality = DRINK_NICE
	taste_description = "сливочное кофе"
	glass_icon_state = "soy_latte"
	glass_name = "соевое латте"
	glass_desc = "Приятный и освежающий напиток, то что нужно, пока вы читаете."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_EASY
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/soy_latte/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.dizziness = max(M.dizziness - (5 * REM * delta_time), 0)
	M.drowsyness = max(M.drowsyness - (3 *REM * delta_time), 0)
	M.SetSleeping(0)
	M.adjust_bodytemperature(5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, 0, M.get_body_temp_normal())
	M.Jitter(5 * REM * delta_time)
	if(M.getBruteLoss() && DT_PROB(10, delta_time))
		M.heal_bodypart_damage(1,0, 0)
	..()
	. = TRUE

/datum/reagent/consumable/cafe_latte
	name = "Латте"
	description = "Хороший, крепкий и освежающий напиток, идеален под хорошую книгу."
	color = "#664300" // rgb: 102, 67, 0
	quality = DRINK_NICE
	taste_description = "горький крем"
	glass_icon_state = "cafe_latte"
	glass_name = "латте"
	glass_desc = "Хороший, крепкий и освежающий напиток, идеален под хорошую книгу."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_EASY
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/cafe_latte/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.dizziness = max(M.dizziness - (5 * REM * delta_time), 0)
	M.drowsyness = max(M.drowsyness - (6 * REM * delta_time), 0)
	M.SetSleeping(0)
	M.adjust_bodytemperature(5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, 0, M.get_body_temp_normal())
	M.Jitter(5 * REM * delta_time)
	if(M.getBruteLoss() && DT_PROB(10, delta_time))
		M.heal_bodypart_damage(1, 0, 0)
	..()
	. = TRUE

/datum/reagent/consumable/doctor_delight
	name = "Восторг врача"
	description = "Смесь соков, которая довольно быстро исцеляет большинство типов повреждений."
	color = "#FF8CFF" // rgb: 255, 140, 255
	quality = DRINK_VERYGOOD
	taste_description = "домашний фрукт"
	glass_icon_state = "doctorsdelightglass"
	glass_name = "Восторг врача"
	glass_desc = "Любимец медиков, вкусный и полезный напиток, который восстанавливает большинство видов повреждений, но при этом заставляет вас чувствовать голод."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

/datum/reagent/consumable/doctor_delight/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjustBruteLoss(-0.5 * REM * delta_time, 0)
	M.adjustFireLoss(-0.5 * REM * delta_time, 0)
	M.adjustToxLoss(-0.5 * REM * delta_time, 0)
	M.adjustOxyLoss(-0.5 * REM * delta_time, 0)
	if(M.nutrition && (M.nutrition - 2 > 0))
		var/obj/item/organ/liver/liver = M.get_organ_slot(ORGAN_SLOT_LIVER)
		if(!(HAS_TRAIT(liver, TRAIT_MEDICAL_METABOLISM)))
			// Drains the nutrition of the holder. Not medical doctors though, since it's the Doctor's Delight!
			M.adjust_nutrition(-2 * REM * delta_time)
	..()
	. = TRUE

/datum/reagent/consumable/cherryshake
	name = "Вишневый молочный коктейль"
	description = "Молочный коктейль со вкусом вишни."
	color = "#FFB6C1"
	quality = DRINK_VERYGOOD
	nutriment_factor = 4 * REAGENTS_METABOLISM
	taste_description = "сливочная вишня"
	glass_icon_state = "cherryshake"
	glass_name = "вишневый молочный коктейль"
	glass_desc = "Молочный коктейль со вкусом вишни."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_MEDIUM
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/bluecherryshake
	name = "Молочный коктейль с синей вишней"
	description = "Экзотический молочный коктейль с синей вишней."
	color = "#00F1FF"
	quality = DRINK_VERYGOOD
	nutriment_factor = 4 * REAGENTS_METABOLISM
	taste_description = "сливочно-голубая вишня"
	glass_icon_state = "bluecherryshake"
	glass_name = "молочный коктейль с синей вишней"
	glass_desc = "Экзотический молочный коктейль с синей вишней."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/pumpkin_latte
	name = "Тыквенное латте"
	description = "Смесь тыквенного сока и кофе."
	color = "#F4A460"
	quality = DRINK_VERYGOOD
	nutriment_factor = 3 * REAGENTS_METABOLISM
	taste_description = "сливочная тыква"
	glass_icon_state = "pumpkin_latte"
	glass_name = "тыквенное латте"
	glass_desc = "Смесь тыквенного сока и кофе."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/gibbfloats
	name = "Хороший Пловец"
	description = "Dr. Gibb со сливочным мороженым."
	color = "#B22222"
	quality = DRINK_NICE
	nutriment_factor = 3 * REAGENTS_METABOLISM
	taste_description = "сливочная вишня"
	glass_icon_state = "gibbfloats"
	glass_name = "Хороший Пловец"
	glass_desc = "Dr. Gibb со сливочным мороженым."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/pumpkinjuice
	name = "Тыквенный сок"
	description = "Сок из тыквы."
	color = "#FFA500"
	taste_description = "тыква"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/blumpkinjuice
	name = "Синетыквенный сок"
	description = "Сок из синей тыквы."
	color = "#00BFFF"
	taste_description = "глоток воды в бассейне"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/triple_citrus
	name = "Тройной Цитрус"
	description = "Прекрасная смесь цитрусовых."
	color = "#EEFF00"
	quality = DRINK_NICE
	taste_description = "крайняя горечь"
	glass_icon_state = "triplecitrus" //needs own sprite mine are trash //your sprite is great tho
	glass_name = "Тройной Цитрус"
	glass_desc = "Смесь цитрусовых соков. Терпкая, но мягкая."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/grape_soda
	name = "Виноградная газировка"
	description = "Её любят дети и бывшие алкоголики."
	color = "#E6CDFF"
	taste_description = "виноградная сода"
	glass_name = "виноградная газировка"
	glass_desc = "Это виноградная газировка!"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/grape_soda/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjust_bodytemperature(-5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, M.get_body_temp_normal())
	..()

/datum/reagent/consumable/milk/chocolate_milk
	name = "Шоколадное молоко"
	description = "Молоко для крутых ребят."
	color = "#7D4E29"
	quality = DRINK_NICE
	taste_description = "шоколадное молоко"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/hot_coco
	name = "Горячее какао"
	description = "Сделано с любовью!"
	nutriment_factor = 3 * REAGENTS_METABOLISM
	color = "#403010" // rgb: 64, 48, 16
	taste_description = "сливочный шоколад"
	glass_icon_state  = "chocolateglass"
	glass_name = "горячее какао"
	glass_desc = "Лучший напиток для зимних вечеров."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/hot_coco/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjust_bodytemperature(5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, 0, M.get_body_temp_normal())
	if(M.getBruteLoss() && DT_PROB(10, delta_time))
		M.heal_bodypart_damage(1, 0, 0)
		. = TRUE
	if(holder.has_reagent(/datum/reagent/consumable/capsaicin))
		holder.remove_reagent(/datum/reagent/consumable/capsaicin, 2 * REM * delta_time)
	..()

/datum/reagent/consumable/menthol
	name = "Ментол"
	description = "Облегчает симптомы кашля."
	color = "#80AF9C"
	taste_description = "мята"
	glass_icon_state = "glass_green"
	glass_name = "Ментол"
	glass_desc = "Вкус натуральной мяты, вызывает легкое онемение."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/menthol/on_mob_life(mob/living/L, delta_time, times_fired)
	L.apply_status_effect(/datum/status_effect/throat_soothed)
	..()

/datum/reagent/consumable/grenadine
	name = "Гренадин"
	description = "Не со вкусом вишни!"
	color = "#EA1D26"
	taste_description = "сладкие гранаты"
	glass_name = "Гренадин"
	glass_desc = "Вкуснейший сироп для коктейлей."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/parsnipjuice
	name = "Сок пастернака"
	description = "Зачем..."
	color = "#FFA500"
	taste_description = "пастернак"
	glass_name = "сок пастернака"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/pineapplejuice
	name = "Ананасовый сок"
	description = "Терпкий, тропический и горячо обсуждаемый."
	special_sound = 'white/valtos/sounds/drink/pineapple_apple_pen.ogg'
	color = "#F7D435"
	taste_description = "ананас"
	glass_name = "ананасовый сок"
	glass_desc = "Все мы знаем, для чего вы его пьете."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/peachjuice //Intended to be extremely rare due to being the limiting ingredients in the blazaam drink
	name = "Персиковый сок"
	description = "Просто персиковый сок."
	color = "#E78108"
	taste_description = "персики"
	glass_name = "персиковый сок"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/cream_soda
	name = "Крем-сода"
	description = "Класичесский для космо-Америки напиток с ванильными нотками."
	color = "#dcb137"
	quality = DRINK_VERYGOOD
	taste_description = "шипучая ваниль"
	glass_icon_state = "cream_soda"
	glass_name = "Крем-сода"
	glass_desc = "Класичесский для космо-Америки напиток с ванильными нотками."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/cream_soda/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjust_bodytemperature(-5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, M.get_body_temp_normal())
	..()

/datum/reagent/consumable/sol_dry
	name = "Меркурий"	//wiki - Меркурий
	description = "Успокаивающий, мягкий напиток, приготовленный из имбиря."
	color = "#f7d26a"
	quality = DRINK_NICE
	taste_description = "сладкая имбирная специя"
	glass_name = "Меркурий"
	glass_desc = "Успокаивающий, мягкий напиток, приготовленный из имбиря."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/sol_dry/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjust_disgust(-5 * REM * delta_time)
	..()

/datum/reagent/consumable/red_queen
	name = "Красная Королева"
	description = "ВЫПЕЙ МЕНЯ."
	color = "#e6ddc3"
	quality = DRINK_GOOD
	taste_description = "чудо"
	glass_icon_state = "red_queen"
	glass_name = "Красная Королева"
	glass_desc = "ВЫПЕЙ МЕНЯ."
	var/current_size = RESIZE_DEFAULT_SIZE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/red_queen/on_mob_life(mob/living/carbon/H, delta_time, times_fired)
	if(DT_PROB(50, delta_time))
		return ..()

	var/newsize = pick(0.5, 0.75, 1, 1.50, 2)
	newsize *= RESIZE_DEFAULT_SIZE
	H.resize = newsize/current_size
	current_size = newsize
	H.update_transform()
	if(DT_PROB(23, delta_time))
		H.emote("sneeze")
	..()

/datum/reagent/consumable/red_queen/on_mob_end_metabolize(mob/living/M)
	M.resize = RESIZE_DEFAULT_SIZE/current_size
	current_size = RESIZE_DEFAULT_SIZE
	M.update_transform()
	..()

/datum/reagent/consumable/bungojuice
	name = "Сок Бунго"
	color = "#F9E43D"
	description = "Экзотично! Вы уже чувствуете себя, как в отпуске."
	taste_description = "сочный бунго"
	glass_icon_state = "glass_yellow"
	glass_name = "сок Бунго"
	glass_desc = "Экзотично! Вы уже чувствуете себя, как в отпуске."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/prunomix
	name = "Микс Пруно"
	color = "#E78108"
	description = "Фрукты, сахар, дрожжи и вода, измельченные в едкую суспензию."
	taste_description = "мусор"
	glass_icon_state = "glass_orange"
	glass_name = "Пруно"
	glass_desc = "Фрукты, сахар, дрожжи и вода, измельченные в едкую суспензию."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/aloejuice
	name = "Сок алоэ"
	color = "#A3C48B"
	description = "Полезный и освежающий сок."
	taste_description = "овощи"
	glass_icon_state = "glass_yellow"
	glass_name = "сок алоэ"
	glass_desc = "Полезный и освежающий сок."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/consumable/aloejuice/on_mob_life(mob/living/M, delta_time, times_fired)
	if(M.getToxLoss() && DT_PROB(16, delta_time))
		M.adjustToxLoss(-1, 0)
	..()
	. = TRUE

/datum/reagent/consumable/lean
	name = "Лин"
	description = "Выпивка, заставляющая вас хрипеть."
	color = "#DE55ED"
	quality = DRINK_NICE
	taste_description = "фиолетовый намек на опиоид."
	glass_icon_state = "lean"
	glass_name = "Лин"
	glass_desc = "Напиток, который делает вашу жизнь менее несчастной."
	addiction_types = list(/datum/addiction/opiods = 6)
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/lean/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.slurring < 3)
		M.slurring += 2 * REM * delta_time
	if(M.druggy < 3)
		M.adjust_drugginess(1 * REM * delta_time)
	if(M.drowsyness < 3)
		M.drowsyness += 1 * REM * delta_time
	return ..()

//Moth Stuff
/datum/reagent/consumable/toechtauese_juice
	name = "Сок Тёхтаузе"
	description = "Неприятный сок из ягод тёхтаузе. Лучше всего приготовить из него сироп, если вам не нравится боль."
	color = "#554862"
	nutriment_factor = 0
	taste_description = "жгучая зудящая боль"
	glass_icon_state = "toechtauese_syrup"
	glass_name = "сок Тёхтаузе"
	glass_desc = "Свежевыжатый сок тёхтаузе. Один глоток заставит вас сожалеть."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/toechtauese_syrup
	name = "Сироп Тёхтаузе"
	description = "Резко пряный и горький сироп, приготовленный из ягод тёхтаузе. Не рекомендуется употреблять в чистом виде."
	color = "#554862"
	nutriment_factor = 0
	taste_description = "sugar, spice, and nothing nice"
	glass_icon_state = "toechtauese_syrup"
	glass_name = "сироп Тёхтаузе"
	glass_desc = "Не рекомендуется употреблять в чистом виде."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/rootbeer
	name = "Рутбир"
	description = "Восхитительный напиток, в котором так много сахара, что он может заставить вас дважды нажимать на курок."
	color = "#181008" // rgb: 24, 16, 8
	quality = DRINK_VERYGOOD
	nutriment_factor = 10 * REAGENTS_METABOLISM
	metabolization_rate = 2 * REAGENTS_METABOLISM
	taste_description = "чудовищный сахарный передоз"
	glass_icon_state = "spacecola"
	glass_name = "Рутбир"
	glass_desc = "Стакан сильнодействующего, невероятно сладкого рутбира."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	/// If we activated the effect
	var/effect_enabled = FALSE

/datum/reagent/consumable/rootbeer/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_DOUBLE_TAP, type)
	if(current_cycle > 10)
		to_chat(L, span_warning("Чувствую некоторую усталость, когда тремор слегка отпускает..."))
		L.adjustStaminaLoss(min(80, current_cycle * 3))
		L.drowsyness += current_cycle
	..()

/datum/reagent/consumable/rootbeer/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(current_cycle >= 3 && !effect_enabled) // takes a few seconds for the bonus to kick in to prevent microdosing
		to_chat(M, span_notice("Кажется, у меня чешутся пальцы."))
		ADD_TRAIT(M, TRAIT_DOUBLE_TAP, type)
		effect_enabled = TRUE

	M.jitteriness += 2
	if(prob(50))
		M.dizziness += 2
	if(current_cycle > 10)
		M.dizziness += 3
	..()
	. = TRUE

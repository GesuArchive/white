#define ALCOHOL_THRESHOLD_MODIFIER 1 //Greater numbers mean that less alcohol has greater intoxication potential
#define ALCOHOL_RATE 0.005 //The rate at which alcohol affects you
#define ALCOHOL_EXPONENT 1.6 //The exponent applied to boozepwr to make higher volume alcohol at least a little bit damaging to the liver

////////////// I don't know who made this header before I refactored alcohols but I'm going to fucking strangle them because it was so ugly, holy Christ
// ALCOHOLS //
//////////////

/datum/reagent/consumable/ethanol
	name = "Этанол"
	enname = "Ehtanol"
	description = "Известный алкоголь с множеством применений."
	color = "#404030" // rgb: 64, 64, 48
	nutriment_factor = 0
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW
	taste_description = "алкоголь"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	ph = 7.33
	burning_temperature = 2193//ethanol burns at 1970C (at it's peak)
	burning_volume = 0.1
	var/boozepwr = 65 //Higher numbers equal higher hardness, higher hardness equals more intense alcohol poisoning

/*
Boozepwr Chart
Note that all higher effects of alcohol poisoning will inherit effects for smaller amounts (i.e. light poisoning inherts from slight poisoning)
In addition, severe effects won't always trigger unless the drink is poisonously strong
All effects don't start immediately, but rather get worse over time; the rate is affected by the imbiber's alcohol tolerance

0: Non-alcoholic
1-10: Barely classifiable as alcohol - occassional slurring
11-20: Slight alcohol content - slurring
21-30: Below average - imbiber begins to look slightly drunk
31-40: Just below average - no unique effects
41-50: Average - mild disorientation, imbiber begins to look drunk
51-60: Just above average - disorientation, vomiting, imbiber begins to look heavily drunk
61-70: Above average - small chance of blurry vision, imbiber begins to look smashed
71-80: High alcohol content - blurry vision, imbiber completely shitfaced
81-90: Extremely high alcohol content - heavy toxin damage, passing out
91-100: Dangerously toxic - swift death
*/

/datum/reagent/consumable/ethanol/New()
	addiction_types = list(/datum/addiction/alcohol = 0.05 * boozepwr)
	return ..()

/datum/reagent/consumable/ethanol/on_mob_life(mob/living/carbon/C, delta_time, times_fired)
	if(C.drunkenness < volume * boozepwr * ALCOHOL_THRESHOLD_MODIFIER || boozepwr < 0)
		var/booze_power = boozepwr
		if(HAS_TRAIT(C, TRAIT_ALCOHOL_TOLERANCE)) //we're an accomplished drinker
			booze_power *= 0.7
		if(HAS_TRAIT(C, TRAIT_LIGHT_DRINKER))
			booze_power *= 2
		C.drunkenness = max((C.drunkenness + (sqrt(volume) * booze_power * ALCOHOL_RATE * REM * delta_time)), 0) //Volume, power, and server alcohol rate effect how quickly one gets drunk
		if(boozepwr > 0)
			var/obj/item/organ/liver/L = C.get_organ_slot(ORGAN_SLOT_LIVER)
			if (istype(L))
				L.applyOrganDamage(((max(sqrt(volume) * (boozepwr ** ALCOHOL_EXPONENT) * L.alcohol_tolerance * delta_time, 0))/150))
	return ..()

/datum/reagent/consumable/ethanol/expose_obj(obj/exposed_obj, reac_volume)
	if(istype(exposed_obj, /obj/item/paper))
		var/obj/item/paper/paperaffected = exposed_obj
		paperaffected.clearpaper()
		to_chat(usr, span_notice("чернила на [paperaffected] смываются."))
	if(istype(exposed_obj, /obj/item/book))
		if(reac_volume >= 5)
			var/obj/item/book/affectedbook = exposed_obj
			affectedbook.dat = null
			exposed_obj.visible_message(span_notice("Надписи на [exposed_obj] смыты [name]!"))
		else
			exposed_obj.visible_message(span_warning("[name] размазал чернила по [exposed_obj], но они не смылись!"))
	return ..()

/datum/reagent/consumable/ethanol/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)//Splashing people with ethanol isn't quite as good as fuel.
	. = ..()
	if(!(methods & (TOUCH|VAPOR|PATCH)))
		return

	exposed_mob.adjust_fire_stacks(reac_volume / 15)

	if(!iscarbon(exposed_mob))
		return

	var/mob/living/carbon/exposed_carbon = exposed_mob
	var/power_multiplier = boozepwr / 65 // Weak alcohol has less sterilizing power

	for(var/s in exposed_carbon.surgeries)
		var/datum/surgery/surgery = s
		surgery.speed_modifier = max(0.1*power_multiplier, surgery.speed_modifier)

/datum/reagent/consumable/ethanol/beer
	name = "Пиво"
	enname = "Beer"
	description = "Алкогольный напиток, который варили с дневних времен еще на старой земле. Всё еще популярен."
	color = "#664300" // rgb: 102, 67, 0
	nutriment_factor = 1 * REAGENTS_METABOLISM
	boozepwr = 25
	taste_description = "моча"
	glass_name = "пиво"
	glass_desc = "Освежающая пинта пива."
	ph = 4
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	fallback_icon_state = "beer"
	glass_price = DRINK_PRICE_STOCK


	// Beer is a chemical composition of alcohol and various other things. It's a garbage nutrient but hey, it's still one. Also alcohol is bad, mmmkay?
/datum/reagent/consumable/ethanol/beer/on_hydroponics_apply(obj/item/seeds/myseed, datum/reagents/chems, obj/machinery/hydroponics/mytray, mob/user)
	. = ..()
	if(chems.has_reagent(src, 1))
		mytray.adjustHealth(-round(chems.get_reagent_amount(src.type) * 0.05))
		mytray.adjustWater(round(chems.get_reagent_amount(src.type) * 0.7))

/datum/reagent/consumable/ethanol/beer/light
	name = "Светлое Пиво"
	enname = "Light Beer"
	description = "Алкогольный напиток, который варили с дневних времен еще на старой земле. Этот сорт отличается меньшим количеством калорий и алкоголя."
	boozepwr = 5 //Space Europeans hate it
	taste_description = "стекломойка"
	glass_name = "светлое пиво"
	glass_desc = "Освежающая пинта водянистого светлого пива."
	ph = 5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	fallback_icon_state = "beer"

/datum/reagent/consumable/ethanol/beer/maltliquor
	name = "Солодовый Ликер"
	enname = "Malt Liquor"
	description = "Алкогольный напиток, который варили с дневних времен еще на старой земле. Этот сорт сильнее обычного, крайне дешевый и крайне ужасный."
	boozepwr = 35
	taste_description = "сладкое кукурузное пиво с нотками черного гетто"
	glass_name = "солодовый ликер"
	glass_desc = "Освежающая пинта солодового ликера."
	ph = 4.8
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/beer/green
	name = "Зеленое Пиво"
	enname = "Green Beer"
	description = "Алкогольный напиток, который варили с дневних времен еще на старой земле. Этот сорт окрашен в зеленый цвет."
	color = "#A8E61D"
	taste_description = "зелёная моча"
	glass_icon_state = "greenbeerglass"
	glass_name = "зеленое пиво"
	glass_desc = "Освежающая пинта зеленого пива. Праздничная!"
	ph = 6
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED


/datum/reagent/consumable/ethanol/beer/green/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.color != color)
		M.add_atom_colour(color, TEMPORARY_COLOUR_PRIORITY)
	return ..()

/datum/reagent/consumable/ethanol/beer/green/on_mob_end_metabolize(mob/living/M)
	M.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, color)

/datum/reagent/consumable/ethanol/kahlua
	name = "Кофейный ликер"
	enname = "Kahlua"
	description = "Широко известный мексиканский ликер со вкусом кофе. Выпускается с 1936-го года!"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 45
	glass_icon_state = "kahluaglass"
	glass_name = "кофейный ликер"
	glass_desc = "БЛЯ ЭТА ШТУКА ВЫГЛЯДИТ КРЕПКО!"
	shot_glass_icon_state = "shotglasscream"
	ph = 6
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/kahlua/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.dizziness = max(M.dizziness - (5 * REM * delta_time), 0)
	M.drowsyness = max(M.drowsyness - (3 * REM * delta_time), 0)
	M.AdjustSleeping(-40 * REM * delta_time)
	if(!HAS_TRAIT(M, TRAIT_ALCOHOL_TOLERANCE))
		M.Jitter(5)
	..()
	. = TRUE

/datum/reagent/consumable/ethanol/whiskey
	name = "Виски"
	enname = "Whiskey"
	description = "Превосходный и хорошо выдержанный односолодовый виски."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 75
	taste_description = "меласса"
	glass_icon_state = "whiskeyglass"
	glass_name = "виски"
	glass_desc = "Шелковистый, дымчатый вкус виски в стакане придает напитку очень стильный вид."
	shot_glass_icon_state = "shotglassbrown"
	ph = 4.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_STOCK

/datum/reagent/consumable/ethanol/whiskey/kong
	name = "Конг"
	description = "Заставляет вас сойти с ума!&#174;"
	color = "#332100" // rgb: 51, 33, 0
	taste_description = "хватка гигантской обезьяны"
	glass_name = "Конг"
	glass_desc = "Заставляет вас сойти с ума!&#174;"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/whiskey/candycorn
	name = "конфетно-кукурузный ликер"
	description = "Такой же, как во времена сухого закона."
	color = "#ccb800" // rgb: 204, 184, 0
	taste_description = "блинный сироп"
	glass_name = "конфетно-кукурузный ликер"
	glass_desc = "Полезен для вашего воображения."
	var/hal_amt = 4
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/whiskey/candycorn/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(DT_PROB(5, delta_time))
		M.hallucination += hal_amt //conscious dreamers can be treasurers to their own currency
	..()

/datum/reagent/consumable/ethanol/thirteenloko
	name = "Локо Тринадцать"
	description = "Мощная смесь кофе и алкоголя."
	color = "#102000" // rgb: 16, 32, 0
	nutriment_factor = 1 * REAGENTS_METABOLISM
	boozepwr = 80
	quality = DRINK_GOOD
	overdose_threshold = 60
	taste_description = "дрожь и смерть"
	glass_icon_state = "thirteen_loko_glass"
	glass_name = "Локо Тринадцать"
	glass_desc = "Это бокал Тринадцати Локо, похоже, он самого высокого качества. Напиток, а не стакан."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/thirteenloko/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.drowsyness = max(M.drowsyness - (7 * REM * delta_time))
	M.AdjustSleeping(-40 * REM * delta_time)
	M.adjust_bodytemperature(-5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, M.get_body_temp_normal())
	if(!HAS_TRAIT(M, TRAIT_ALCOHOL_TOLERANCE))
		M.Jitter(5)
	return ..()

/datum/reagent/consumable/ethanol/thirteenloko/overdose_start(mob/living/M)
	to_chat(M, span_userdanger("Всё моё тело сильно дрожит с приходом тошноты. Наверное не стоило пить так много [name]!"))
	M.Jitter(20)
	M.Stun(15)

/datum/reagent/consumable/ethanol/thirteenloko/overdose_process(mob/living/M, delta_time, times_fired)
	if(DT_PROB(3.5, delta_time) && iscarbon(M))
		var/obj/item/I = M.get_active_held_item()
		if(I)
			M.dropItemToGround(I)
			to_chat(M, span_notice("Мои руки дрожат и я выронил из них то, что держал!"))
			M.Jitter(10)

	if(DT_PROB(3.5, delta_time))
		to_chat(M, span_notice("[pick("У меня очень сильно болит голова.", "Глазам больно.", "Мне сложно ровно стоять.", "По ощущениям мое сердце буквально вырывается из груди.")]"))

	if(DT_PROB(2.5, delta_time) && iscarbon(M))
		var/obj/item/organ/eyes/eyes = M.get_organ_slot(ORGAN_SLOT_EYES)
		if(M.is_blind())
			if(istype(eyes))
				eyes.Remove(M)
				eyes.forceMove(get_turf(M))
				to_chat(M, span_userdanger("Сгибаюсь от боли, кажется мои глазные яблоки разжижаются в голове!"))
				M.emote("agony")
				M.adjustBruteLoss(15)
		else
			to_chat(M, span_userdanger("Кричу от ужаса, я ослеп!"))
			eyes.applyOrganDamage(eyes.maxHealth)
			M.emote("agony")

	if(DT_PROB(1.5, delta_time) && iscarbon(M))
		M.visible_message(span_danger("[M] бьется в припадке!") , span_userdanger("У меня припадок!"))
		M.Unconscious(100)
		M.Jitter(350)

	if(DT_PROB(0.5, delta_time) && iscarbon(M))
		var/datum/disease/D = new /datum/disease/heart_failure
		M.ForceContractDisease(D)
		to_chat(M, span_userdanger("Уверен что ощутил как мое сердце пропустило удар.."))
		M.playsound_local(M, 'sound/effects/singlebeat.ogg', 100, 0)

/datum/reagent/consumable/ethanol/vodka
	name = "Водка"
	description = "Напиток и топливо номер один для русских по всему миру."
	color = "#0064C8" // rgb: 0, 100, 200
	boozepwr = 65
	taste_description = "зерновой спирт"
	glass_icon_state = "ginvodkaglass"
	glass_name = "водка"
	glass_desc = "Только рюмка водки на столе."
	shot_glass_icon_state = "shotglassclear"
	ph = 8.1
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_CLEANS //Very high proof

/datum/reagent/consumable/ethanol/vodka/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.radiation = max(M.radiation - (2 * REM * delta_time),0)
	return ..()

/datum/reagent/consumable/ethanol/bilk
	name = "Билк"
	description = "Похоже, это пиво, смешанное с молоком. Отвратительно."
	color = "#895C4C" // rgb: 137, 92, 76
	nutriment_factor = 2 * REAGENTS_METABOLISM
	boozepwr = 15
	taste_description = "отчаяние и лактат"
	glass_icon_state = "glass_brown"
	glass_name = "Билк"
	glass_desc = "Варево из молока и пива. Для тех алкоголиков, которые боятся остеопороза."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/bilk/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.getBruteLoss() && DT_PROB(5, delta_time))
		M.heal_bodypart_damage(brute = 1)
		. = TRUE
	return ..() || .

/datum/reagent/consumable/ethanol/threemileisland
	name = "Три мили от берега"
	description = "Made for a woman, strong enough for a man."
	color = "#666340" // rgb: 102, 99, 64
	boozepwr = 10
	quality = DRINK_FANTASTIC
	taste_description = "сухость"
	glass_icon_state = "threemileislandglass"
	glass_name = "Три мили от берега"
	glass_desc = "Стакан этого напитка обязательно предотвратит срыв."
	ph = 3.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/threemileisland/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.set_drugginess(50 * REM * delta_time)
	return ..()

/datum/reagent/consumable/ethanol/gin
	name = "Джин"
	description = "Это не просто джин. Это космический джин!"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 45
	taste_description = "алкогольная рождественская елка"
	glass_icon_state = "ginvodkaglass"
	glass_name = "джин"
	glass_desc = "Бокал кристально прозрачного джина."
	ph = 6.9
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/rum
	name = "Ром"
	description = "Йо-хо-хо, так сказать."
	special_sound = 'white/valtos/sounds/drink/rum.ogg'
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 60
	taste_description = "колючие ириски"
	glass_icon_state = "rumglass"
	glass_name = "ром"
	glass_desc = "Теперь вы хотите купить костюм пирата, не так ли?"
	shot_glass_icon_state = "shotglassbrown"
	ph = 6.5

/datum/reagent/consumable/ethanol/tequila
	name = "Текила"
	description = "Крепкий и мягкий по вкусу спиртной напиток мексиканского производства. Хочешь выпить, приятель?"
	special_sound = 'white/valtos/sounds/drink/tequila.ogg'
	color = "#FFFF91" // rgb: 255, 255, 145
	boozepwr = 70
	taste_description = "растворитель"
	glass_icon_state = "tequilaglass"
	glass_name = "текила"
	glass_desc = "Не хватает чего-то красочного!"
	shot_glass_icon_state = "shotglassgold"
	ph = 4
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_STOCK

/datum/reagent/consumable/ethanol/vermouth
	name = "Вермут"
	description = "Вам вдруг захотелось выпить мартини..."
	color = "#91FF91" // rgb: 145, 255, 145
	boozepwr = 45
	taste_description = "сухой алкоголь"
	glass_icon_state = "vermouthglass"
	glass_name = "вермут"
	glass_desc = "Удивительно, как это вообще можно пить неразбавленным."
	shot_glass_icon_state = "shotglassclear"
	ph = 3.25
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/wine
	name = "Вино"
	description = "Алкоголь высшего качества, изготовленный из дистиллированного виноградного сока."
	color = "#7E4043" // rgb: 126, 64, 67
	boozepwr = 35
	taste_description = "горькая сладость"
	glass_icon_state = "wineglass"
	glass_name = "вино"
	glass_desc = "Очень элегантно выглядящий напиток."
	shot_glass_icon_state = "shotglassred"
	ph = 3.45
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/wine/on_merge(data)
	. = ..()
	if(src.data && data && data["vintage"] != src.data["vintage"])
		src.data["vintage"] = "mixed wine"

/datum/reagent/consumable/ethanol/wine/get_taste_description(mob/living/taster)
	if(HAS_TRAIT(taster,TRAIT_WINE_TASTER))
		if(data && data["vintage"])
			return list("[data["vintage"]]" = 1)
		else
			return list("synthetic wine"=1)
	return ..()

/datum/reagent/consumable/ethanol/lizardwine
	name = "Вино из ящериц"
	description = "Алкогольный напиток из космического Китая, изготовленный путем настаивания хвостов ящериц в этаноле."
	color = "#7E4043" // rgb: 126, 64, 67
	boozepwr = 45
	quality = DRINK_FANTASTIC
	taste_description = "масштабная сладость"
	ph = 3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/grappa
	name = "Граппа"
	description = "Прекрасный итальянский бренди, когда обычное вино недостаточно крепкое для вас."
	color = "#F8EBF1"
	boozepwr = 60
	taste_description = "классная горькая сладость"
	glass_icon_state = "grappa"
	glass_name = "Граппа"
	glass_desc = "Изысканный напиток, изначально созданный для уменьшения отходов производства путем использования остатков виноделия."
	ph = 3.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/amaretto
	name = "Амаретто"
	description = "Нежный напиток со сладким ароматом."
	color = "#E17600"
	boozepwr = 25
	taste_description = "fruity and nutty sweetness"
	glass_icon_state = "amarettoglass"
	glass_name = "Амаретто"
	glass_desc = "Нежный напиток, похожий на сироп, со вкусом миндаля и абрикосов."
	shot_glass_icon_state = "shotglassgold"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/cognac
	name = "Коньяк"
	description = "Сладкий и сильноалкогольный напиток, изготовленный после многочисленных дистилляций и многолетней выдержки."
	color = "#AB3C05" // rgb: 171, 60, 5
	boozepwr = 75
	taste_description = "ирландская злость"
	glass_icon_state = "cognacglass"
	glass_name = "коньяк"
	glass_desc = "Черт возьми, вы чувствуете себя французским аристократом, просто держа его в руках."
	shot_glass_icon_state = "shotglassbrown"
	ph = 3.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/absinthe
	name = "Абсент"
	description = "Крепкий алкогольный напиток. По слухам, вызывает галлюцинации, но это не так."
	color = rgb(10, 206, 0)
	boozepwr = 80 //Very strong even by default
	taste_description = "смерть и солодка"
	glass_icon_state = "absinthe"
	glass_name = "абсент"
	glass_desc = "Вкус такой же крепкий, как и запах."
	shot_glass_icon_state = "shotglassgreen"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/absinthe/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(DT_PROB(5, delta_time) && !HAS_TRAIT(M, TRAIT_ALCOHOL_TOLERANCE))
		M.hallucination += 4 //Reference to the urban myth
	..()

/datum/reagent/consumable/ethanol/hooch
	name = "Хуч"
	description = "Либо чья-то неудача в приготовлении коктейля, либо попытка производства алкоголя. В любом случае, вы действительно хотите это выпить?"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 100
	taste_description = "чистая отставка"
	glass_icon_state = "glass_brown2"
	glass_name = "Хуч"
	glass_desc = "Вы действительно достигли дна... Ваша печень собрала свои вещи и ушла вчера вечером."
	addiction_types = list(/datum/addiction/alcohol = 5, /datum/addiction/maintenance_drugs = 2)
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/hooch/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	var/obj/item/organ/liver/liver = M.get_organ_slot(ORGAN_SLOT_LIVER)
	if(liver && HAS_TRAIT(liver, TRAIT_GREYTIDE_METABOLISM) || HAS_TRAIT(liver, TRAIT_BOMJ_METABOLISM))
		M.heal_bodypart_damage(1 * REM * delta_time, 1 * REM * delta_time)
		. = TRUE
	return ..() || .

/datum/reagent/consumable/ethanol/ale
	name = "Эль"
	description = "Темный алкогольный напиток, приготовленный из ячменного солода и дрожжей."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 65
	taste_description = "сытный ячменный эль"
	glass_icon_state = "aleglass"
	glass_name = "эль"
	glass_desc = "Пинта восхитительного эля"
	ph = 4.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/goldschlager
	name = "Гольдшпигер"
	description = "Шнапс с корицей 100% пробы, созданный для алкоголиков-подростков на весенних каникулах."
	color = "#FFFF91" // rgb: 255, 255, 145
	boozepwr = 25
	quality = DRINK_VERYGOOD
	taste_description = "горящая корица"
	glass_icon_state = "goldschlagerglass"
	glass_name = "Гольдшпигер"
	glass_desc = "100% доказательство того, что девочки-подростки будут пить все, что содержит золото."
	shot_glass_icon_state = "shotglassgold"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

	/// Ratio of gold that the goldschlager recipe contains
	var/static/gold_ratio

	// This drink is really popular with a certain demographic.
	var/teenage_girl_quality = DRINK_VERYGOOD

/datum/reagent/consumable/ethanol/goldschlager/New()
	. = ..()
	if(!gold_ratio)
		// Calculate the amount of gold that goldschlager is made from
		var/datum/chemical_reaction/drink/goldschlager/goldschlager_reaction = new
		var/vodka_amount = goldschlager_reaction.required_reagents[/datum/reagent/consumable/ethanol/vodka]
		var/gold_amount = goldschlager_reaction.required_reagents[/datum/reagent/gold]
		gold_ratio = gold_amount / (gold_amount + vodka_amount)
		qdel(goldschlager_reaction)

/datum/reagent/consumable/ethanol/goldschlager/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	// Reset quality each time, since the bottle can be shared
	quality = initial(quality)

	if(ishuman(exposed_mob))
		var/mob/living/carbon/human/human = exposed_mob
		// tgstation13 does not endorse underage drinking. laws may vary by your jurisdiction.
		if(human.age >= 13 && human.age <= 19 && human.gender == FEMALE)
			quality = teenage_girl_quality

	return ..()

/datum/reagent/consumable/ethanol/goldschlager/on_transfer(atom/A, methods = TOUCH, trans_volume)
	if(!(methods & INGEST))
		return ..()

	var/convert_amount = trans_volume * gold_ratio
	A.reagents.remove_reagent(/datum/reagent/consumable/ethanol/goldschlager, convert_amount)
	A.reagents.add_reagent(/datum/reagent/gold, convert_amount)
	return ..()

/datum/reagent/consumable/ethanol/patron
	name = "Текила «Патрон»"
	description = "Текила с серебром, обожаемая девушками с низкой социальной ответственностью."
	color = "#585840" // rgb: 88, 88, 64
	boozepwr = 60
	quality = DRINK_VERYGOOD
	taste_description = "дорогой металл"
	glass_icon_state = "patronglass"
	glass_name = "Текила «Патрон»"
	glass_desc = "Drinking patron in the bar, with all the subpar ladies."
	shot_glass_icon_state = "shotglassclear"
	ph = 4.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_HIGH

/datum/reagent/consumable/ethanol/gintonic
	name = "Джин-тоник"
	description = "Классический коктейль на все времена."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 25
	quality = DRINK_NICE
	taste_description = "мягкий и терпкий"
	glass_icon_state = "gintonicglass"
	glass_name = "Джин-тоник"
	glass_desc = "Мягкий, но все же отличный коктейль. Пейте, как истинный англичанин."
	ph = 3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/rum_coke
	name = "Ром с колой"
	description = "Ром, смешанный с колой."
	taste_description = "кола"
	boozepwr = 40
	quality = DRINK_NICE
	color = "#3E1B00"
	glass_icon_state = "whiskeycolaglass"
	glass_name = "Ром с колой"
	glass_desc = "Классический напиток посвящения космо-пиратов."
	ph = 4
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/cuba_libre
	name = "Куба Либре"
	description = "Да здравствует революция! Да здравствует свободная Куба!"
	special_sound = 'white/valtos/sounds/drink/cuba.ogg'
	color = "#3E1B00" // rgb: 62, 27, 0
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "освежающий брак цитрусовых и рома"
	glass_icon_state = "cubalibreglass"
	glass_name = "Куба Либре"
	glass_desc = "Классическая смесь рома, колы и лайма. Любимый напиток всех революционеров!"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/cuba_libre/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.mind && M.mind.has_antag_datum(/datum/antagonist/rev)) //Cuba Libre, the traditional drink of revolutions! Heals revolutionaries.
		M.adjustBruteLoss(-1 * REM * delta_time, 0)
		M.adjustFireLoss(-1 * REM * delta_time, 0)
		M.adjustToxLoss(-1 * REM * delta_time, 0)
		M.adjustOxyLoss(-5 * REM * delta_time, 0)
		. = TRUE
	return ..() || .

/datum/reagent/consumable/ethanol/whiskey_cola
	name = "Виски кола"
	description = "Виски, смешанное с колой. Удивительно освежает."
	color = "#3E1B00" // rgb: 62, 27, 0
	boozepwr = 70
	quality = DRINK_NICE
	taste_description = "кола"
	glass_icon_state = "whiskeycolaglass"
	glass_name = "Виски кола"
	glass_desc = "Невинная на вид смесь колы и виски. Вкусно."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED


/datum/reagent/consumable/ethanol/martini
	name = "Классический Мартини"
	description = "Вермут с джином. Не совсем то, что любил агент 007, но все равно вкусно."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 60
	quality = DRINK_NICE
	taste_description = "сухой класс"
	glass_icon_state = "martiniglass"
	glass_name = "классический Мартини"
	glass_desc = "Черт, а бармен красавчик! Перемешал, но не встряхивал."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/vodkamartini
	name = "Мартини с водкой"
	description = "Водка с джином. Не совсем то, что любил агент 007, но все равно вкусно."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 65
	quality = DRINK_NICE
	taste_description = "встряхивают, не перемешивают"
	glass_icon_state = "martiniglass"
	glass_name = "мартини с водкой"
	glass_desc = "Ублюдочная версия классического мартини, но все равно вкусно."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/white_russian
	name = "Белый Русский"
	description = "Это всего лишь твое мнение..."
	color = "#A68340" // rgb: 166, 131, 64
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "горький крем"
	glass_icon_state = "whiterussianglass"
	glass_name = "Белый Русский"
	glass_desc = "Очень красивый напиток. Но это только твое мнение, чувак."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/screwdrivercocktail
	name = "Отвертка"
	description = "Водка, смешанная с обычным апельсиновым соком. Результат удивительно хорош."
	color = "#A68310" // rgb: 166, 131, 16
	boozepwr = 55
	quality = DRINK_NICE
	taste_description = "апельсины"
	glass_icon_state = "screwdriverglass"
	glass_name = "Отвертка"
	glass_desc = "Простая, но превосходная смесь водки и апельсинового сока. Как раз то, что нужно уставшему инженеру."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/screwdrivercocktail/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	var/obj/item/organ/liver/liver = M.get_organ_slot(ORGAN_SLOT_LIVER)
	if(HAS_TRAIT(liver, TRAIT_ENGINEER_METABOLISM))
		// Engineers lose radiation poisoning at a massive rate.
		M.radiation = max(M.radiation - (25 * REM * delta_time), 0)
	return ..()

/datum/reagent/consumable/ethanol/booger
	name = "Бугер"
	description = "Фууу..."
	color = "#8CFF8C" // rgb: 140, 255, 140
	boozepwr = 45
	taste_description = "сладкий и сливочный"
	glass_icon_state = "booger"
	glass_name = "Бугер"
	glass_desc = "Фууу..."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/bloody_mary
	name = "Кровавая Мэри"
	description = "Странная, но приятная смесь из водки, томата и сока лайма. По крайней мере, вам КАЖЕТСЯ что красное вещество - это томатный сок."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 55
	quality = DRINK_GOOD
	taste_description = "помидоры с ноткой лайма"
	glass_icon_state = "bloodymaryglass"
	glass_name = "Кровавая Мэри"
	glass_desc = "Томатный сок, смешанный с водкой и небольшим количеством лайма."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/bloody_mary/on_mob_life(mob/living/carbon/C, delta_time, times_fired)
	if(C.blood_volume < BLOOD_VOLUME_NORMAL)
		C.blood_volume = min(C.blood_volume + (3 * REM * delta_time), BLOOD_VOLUME_NORMAL) //Bloody Mary quickly restores blood loss.
	..()

/datum/reagent/consumable/ethanol/brave_bull
	name = "Храбрый Бык"
	description = "Один глоток даёт заряд бравады на целую смену."
	special_sound = 'white/valtos/sounds/drink/bull.ogg'
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 60
	quality = DRINK_NICE
	taste_description = "алкогольная храбрость"
	glass_icon_state = "bravebullglass"
	glass_name = "Храбрый Бык"
	glass_desc = "Текила и кофейный ликер, соединенные в аппетитную смесь. Зацени."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	var/tough_text
	glass_price = DRINK_PRICE_EASY

/datum/reagent/consumable/ethanol/brave_bull/on_mob_metabolize(mob/living/M)
	tough_text = pick("brawny", "tenacious", "tough", "hardy", "sturdy") //Tuff stuff
	to_chat(M, span_notice("Чувствую [tough_text]!"))
	M.maxHealth += 10 //Brave Bull makes you sturdier, and thus capable of withstanding a tiny bit more punishment.
	M.health += 10

/datum/reagent/consumable/ethanol/brave_bull/on_mob_end_metabolize(mob/living/M)
	to_chat(M, span_notice("Ощущение [tough_text] прошло."))
	M.maxHealth -= 10
	M.health = min(M.health - 10, M.maxHealth) //This can indeed crit you if you're alive solely based on alchol ingestion

/datum/reagent/consumable/ethanol/tequila_sunrise
	name = "Текила Санрайз"
	description = "Текила, гренадин и апельсиновый сок."
	special_sound = 'white/valtos/sounds/drink/tequila_sunrise.ogg'
	color = "#FFE48C" // rgb: 255, 228, 140
	boozepwr = 45
	quality = DRINK_GOOD
	taste_description = "апельсины с оттенком граната"
	glass_icon_state = "tequilasunriseglass"
	glass_name = "Текила Санрайз"
	glass_desc = "Класс, теперь вы ностальгируете по восходам солнца на Земле..."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	var/obj/effect/light_holder
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/ethanol/tequila_sunrise/on_mob_metabolize(mob/living/M)
	to_chat(M, span_notice("Чувствую как по моему телу расползается приятное тепло!"))
	light_holder = new(M)
	light_holder.set_light(3, 0.7, "#FFCC00") //Tequila Sunrise makes you radiate dim light, like a sunrise!

/datum/reagent/consumable/ethanol/tequila_sunrise/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(QDELETED(light_holder))
		holder.del_reagent(type) //If we lost our light object somehow, remove the reagent
	else if(light_holder.loc != M)
		light_holder.forceMove(M)
	return ..()

/datum/reagent/consumable/ethanol/tequila_sunrise/on_mob_end_metabolize(mob/living/M)
	to_chat(M, span_notice("Тепло покрывшее мое тело развеивается."))
	QDEL_NULL(light_holder)

/datum/reagent/consumable/ethanol/toxins_special
	name = "Бомбление"
	description = "ПОЖАР! ВЗРЫВОТЕХНИКИ СНОВА ГОРЯТ!! ВЫЗОВИТЕ СРАНЫЙ ШАТЛ!!!"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 25
	quality = DRINK_VERYGOOD
	taste_description = "пряные токсины"
	glass_icon_state = "toxinsspecialglass"
	glass_name = "Бомбление"
	glass_desc = "Вау, оно горит!"
	shot_glass_icon_state = "toxinsspecialglass"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/toxins_special/on_mob_life(mob/living/M, delta_time, times_fired)
	M.adjust_bodytemperature(15 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, 0, M.get_body_temp_normal() + 20) //310.15 is the normal bodytemp.
	return ..()

/datum/reagent/consumable/ethanol/beepsky_smash
	name = "Удар Бипски"
	description = "Выпейте это и приготовьтесь к ПРАВОСУДИЮ."
	special_sound = 'white/valtos/sounds/drink/criminal.ogg'
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 60 //THE FIST OF THE LAW IS STRONG AND HARD
	quality = DRINK_GOOD
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	taste_description = "СПРАВЕДЛИВОСТЬ"
	glass_icon_state = "beepskysmashglass"
	glass_name = "Удар Бипски"
	glass_desc = "Тяжелый, горячий и сильный. Прямо как железный кулак ПРАВОСУДИЯ."
	overdose_threshold = 40
	var/datum/brain_trauma/special/beepsky/B
	ph = 2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/beepsky_smash/on_mob_metabolize(mob/living/carbon/M)
	if(HAS_TRAIT(M, TRAIT_ALCOHOL_TOLERANCE))
		metabolization_rate = 0.8
	// if you don't have a liver, or your liver isn't an officer's liver
	var/obj/item/organ/liver/liver = M.get_organ_slot(ORGAN_SLOT_LIVER)
	if(!liver || !HAS_TRAIT(liver, TRAIT_LAW_ENFORCEMENT_METABOLISM))
		B = new()
		M.gain_trauma(B, TRAUMA_RESILIENCE_ABSOLUTE)
	..()

/datum/reagent/consumable/ethanol/beepsky_smash/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.Jitter(2)
	var/obj/item/organ/liver/liver = M.get_organ_slot(ORGAN_SLOT_LIVER)
	// if you don't have a liver, or your liver isn't an officer's liver
	if(!liver || !HAS_TRAIT(liver, TRAIT_LAW_ENFORCEMENT_METABOLISM))
		M.adjustStaminaLoss(-10 * REM * delta_time, 0)
		if(DT_PROB(10, delta_time))
			new /datum/hallucination/items_other(M)
		if(DT_PROB(5, delta_time))
			new /datum/hallucination/stray_bullet(M)
	..()
	. = TRUE

/datum/reagent/consumable/ethanol/beepsky_smash/on_mob_end_metabolize(mob/living/carbon/M)
	if(B)
		QDEL_NULL(B)
	return ..()

/datum/reagent/consumable/ethanol/beepsky_smash/overdose_start(mob/living/carbon/M)
	var/obj/item/organ/liver/liver = M.get_organ_slot(ORGAN_SLOT_LIVER)
	// if you don't have a liver, or your liver isn't an officer's liver
	if(!liver || !HAS_TRAIT(liver, TRAIT_LAW_ENFORCEMENT_METABOLISM))
		M.gain_trauma(/datum/brain_trauma/mild/phobia/security, TRAUMA_RESILIENCE_BASIC)

/datum/reagent/consumable/ethanol/irish_cream
	name = "Айриш Крим"
	description = "Сливки с виски - что еще можно ожидать от ирландцев?"
	special_sound = 'white/valtos/sounds/drink/irish_coffee.ogg'
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 50
	quality = DRINK_NICE
	taste_description = "сливочный спирт"
	glass_icon_state = "irishcreamglass"
	glass_name = "Айриш Крим"
	glass_desc = "Это сливки, смешанные с виски. Что еще можно ожидать от ирландцев?"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/manly_dorf
	name = "Мужественный Дорф"
	description = "Пиво и эль, собранные вместе в восхитительный микс. Только для настоящих мужчин."
	special_sound = 'white/valtos/sounds/drink/df.ogg'
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 100 //For the manly only
	quality = DRINK_NICE
	taste_description = "волосы на груди и подбородке"
	glass_icon_state = "manlydorfglass"
	glass_name = "Мужественный Дорф"
	glass_desc = "Коктейль из эля и пива. Только для настоящих мужчин."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	var/dorf_mode

/datum/reagent/consumable/ethanol/manly_dorf/on_mob_metabolize(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(HAS_TRAIT(H, TRAIT_DWARF))
			to_chat(H, span_notice("Вот ЭТО и есть МУЖЕСТВО!"))
			boozepwr = 50 // will still smash but not as much.
			dorf_mode = TRUE

/datum/reagent/consumable/ethanol/manly_dorf/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(dorf_mode)
		M.adjustBruteLoss(-2 * REM * delta_time)
		M.adjustFireLoss(-2 * REM * delta_time)
	return ..()

/datum/reagent/consumable/ethanol/longislandicedtea
	name = "Лонг-Айленд айс ти"
	description = "Восхитительная смесь водки, джина, текилы и куба либре. Предназначен только для женщин-алкоголиков бальзаковского возраста."
	special_sound = 'white/valtos/sounds/drink/long_island.ogg'
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 35
	quality = DRINK_VERYGOOD
	taste_description = "смесь алкоголя"
	glass_icon_state = "longislandicedteaglass"
	glass_name = "Лонг-Айленд айс ти"
	glass_desc = "Восхитительная смесь водки, джина, текилы и куба либре. Предназначен только для женщин-алкоголиков бальзаковского возраста."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED


/datum/reagent/consumable/ethanol/moonshine
	name = "Лунный свет"
	description = "Вы действительно достигли дна... Ваша печень собрала свои вещи и ушла вчера вечером."
	special_sound = 'white/valtos/sounds/drink/moonshine.ogg'
	color = "#AAAAAA77" // rgb: 170, 170, 170, 77 (alpha) (like water)
	boozepwr = 95
	taste_description = "горечь"
	glass_icon_state = "glass_clear"
	glass_name = "Лунный свет"
	glass_desc = "Вы действительно достигли дна... Ваша печень собрала свои вещи и ушла вчера вечером."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/b52
	name = "Б-52"
	description = "Кофе, айриш крим и коньяк. Тебя просто разорвёт."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 85
	quality = DRINK_GOOD
	taste_description = "злой и ирландский"
	glass_icon_state = "b52glass"
	glass_name = "Б-52"
	glass_desc = "Кофе, айриш крим и коньяк. Тебя просто разорвёт."
	shot_glass_icon_state = "b52glass"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_EASY

/datum/reagent/consumable/ethanol/b52/on_mob_metabolize(mob/living/M)
	playsound(M, 'white/valtos/sounds/nuclearexplosion.ogg', 100, FALSE)

/datum/reagent/consumable/ethanol/irishcoffee
	name = "Ирландский кофе"
	description = "Кофе и алкоголь. Веселее, чем пить \"Мимозу\" по утрам."
	special_sound = 'white/valtos/sounds/drink/irish_coffee.ogg'
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 35
	quality = DRINK_NICE
	taste_description = "сдаться за день"
	glass_icon_state = "irishcoffeeglass"
	glass_name = "Ирландский Кофе"
	glass_desc = "Кофе и алкоголь. Веселее, чем пить \"Мимозу\" по утрам."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/margarita
	name = "Маргарита"
	description = "На камнях с солью по краю. Арриба~!"
	color = "#8CFF8C" // rgb: 140, 255, 140
	boozepwr = 35
	quality = DRINK_NICE
	taste_description = "сухой и соленый"
	glass_icon_state = "margaritaglass"
	glass_name = "Маргарита"
	glass_desc = "На камнях с солью по краю. Арриба~!"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/ethanol/black_russian
	name = "Черный русский"
	description = "Для людей с непереносимостью лактозы. По-прежнему стильный, как белый русский."
	color = "#360000" // rgb: 54, 0, 0
	boozepwr = 70
	quality = DRINK_NICE
	taste_description = "горечь"
	glass_icon_state = "blackrussianglass"
	glass_name = "Черный русский"
	glass_desc = "Для людей с непереносимостью лактозы. По-прежнему стильный, как белый русский."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/manhattan
	name = "Манхэттен"
	description = "Любимый напиток детектива под прикрытием. Он никогда не мог переварить джин..."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 30
	quality = DRINK_NICE
	taste_description = "легкая сухость"
	glass_icon_state = "manhattanglass"
	glass_name = "Манхэттен"
	glass_desc = "Любимый напиток детектива под прикрытием. Он никогда не мог переварить джин..."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_EASY

/datum/reagent/consumable/ethanol/manhattan_proj
	name = "Проект Манхэттен"
	description = "Любимый напиток ученых, мечтающих как взорвать станцию."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 45
	quality = DRINK_VERYGOOD
	taste_description = "смерть, разрушитель миров"
	glass_icon_state = "proj_manhattanglass"
	glass_name = "Проект Манхэттен"
	glass_desc = "Любимый напиток ученых, мечтающих как взорвать станцию."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/manhattan_proj/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.set_drugginess(30 * REM * delta_time)
	return ..()

/datum/reagent/consumable/ethanol/whiskeysoda
	name = "Виски с содовой"
	description = "Идеально освежает."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 70
	quality = DRINK_NICE
	taste_description = "сода"
	glass_icon_state = "whiskeysodaglass2"
	glass_name = "Виски с содовой"
	glass_desc = "Идеально освежает."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/antifreeze
	name = "Антифриз"
	description = "Идеально освежает. Внешний вид может обмануть."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 35
	quality = DRINK_NICE
	taste_description = "моча Джека Фроста"
	glass_icon_state = "antifreeze"
	glass_name = "Антифриз"
	glass_desc = "Идеально освежает."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/antifreeze/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjust_bodytemperature(20 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, 0, M.get_body_temp_normal() + 20) //310.15 is the normal bodytemp.
	return ..()

/datum/reagent/consumable/ethanol/barefoot
	name = "Босоножка"
	description = "Босая и беременная."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 45
	quality = DRINK_VERYGOOD
	taste_description = "сливочные ягоды"
	glass_icon_state = "b&p"
	glass_name = "Босоножка"
	glass_desc = "Босая и беременная."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/barefoot/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(ishuman(M)) //Barefoot causes the imbiber to quickly regenerate brute trauma if they're not wearing shoes.
		var/mob/living/carbon/human/H = M
		if(!H.shoes)
			H.adjustBruteLoss(-3 * REM * delta_time, 0)
			. = TRUE
	return ..() || .

/datum/reagent/consumable/ethanol/snowwhite
	name = "Белоснежка"
	description = "Холодная свежесть."
	color = "#FFFFFF" // rgb: 255, 255, 255
	boozepwr = 35
	quality = DRINK_NICE
	taste_description = "освежающий холод"
	glass_icon_state = "snowwhite"
	glass_name = "Белоснежка"
	glass_desc = "Холодная свежесть."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/demonsblood //Prevents the imbiber from being dragged into a pool of blood by a slaughter demon.
	name = "Кровь демона"
	description = "ААААА!!!!"
	color = "#820000" // rgb: 130, 0, 0
	boozepwr = 75
	quality = DRINK_VERYGOOD
	taste_description = "сладкое железо"
	glass_icon_state = "demonsblood"
	glass_name = "Кровь демона"
	glass_desc = "От одного взгляда на этот коктейль волосы на затылке встают дыбом.."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/devilskiss //If eaten by a slaughter demon, the demon will regret it.
	name = "Поцелуй дьявола"
	description = "Жуть!"
	color = "#A68310" // rgb: 166, 131, 16
	boozepwr = 70
	quality = DRINK_VERYGOOD
	taste_description = "горькое железо"
	glass_icon_state = "devilskiss"
	glass_name = "Поцелуй дьявола"
	glass_desc = "Жуть!"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/vodkatonic
	name = "Водка с тоником"
	description = "Для тех случаев, когда джин с тоником не достаточно по-русски."
	color = "#0064C8" // rgb: 0, 100, 200
	boozepwr = 70
	quality = DRINK_NICE
	taste_description = "терпкая горечь"
	glass_icon_state = "vodkatonicglass"
	glass_name = "Водка с тоником"
	glass_desc = "Для тех случаев, когда джин с тоником не достаточно по-русски."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED


/datum/reagent/consumable/ethanol/ginfizz
	name = "Джин физ"
	description = "Освежающе лимонный, восхитительно сухой."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 45
	quality = DRINK_GOOD
	taste_description = "сухой, терпкий лимон"
	glass_icon_state = "ginfizzglass"
	glass_name = "Джин физ"
	glass_desc = "Освежающе лимонный, восхитительно сухой."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED


/datum/reagent/consumable/ethanol/bahama_mama
	name = "Багама мама"
	description = "Тропический коктейль со сложным сочетанием вкусов."
	special_sound = 'white/valtos/sounds/drink/bahama_mama.ogg'
	color = "#FF7F3B" // rgb: 255, 127, 59
	boozepwr = 35
	quality = DRINK_GOOD
	taste_description = "ананас, кокос и кофе"
	glass_icon_state = "bahama_mama"
	glass_name = "Багама мама"
	glass_desc = "Тропический коктейль со сложным сочетанием вкусов."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/singulo
	name = "Сингуло"
	description = "Блюспейс коктейль!"
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 35
	quality = DRINK_VERYGOOD
	taste_description = "концентрированное вещество"
	glass_icon_state = "singulo"
	glass_name = "Сингуло"
	glass_desc = "Блюспейс коктейль!"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/sbiten
	name = "Сбитень"
	description = "Водка с перцом! Не обожгись!"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 70
	quality = DRINK_GOOD
	taste_description = "горячий и пряный"
	glass_icon_state = "sbitenglass"
	glass_name = "Сбитеньб"
	glass_desc = "Пряная смесь водки и перца."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/sbiten/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjust_bodytemperature(50 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, 0, BODYTEMP_HEAT_DAMAGE_LIMIT) //310.15 is the normal bodytemp.
	return ..()

/datum/reagent/consumable/ethanol/red_mead
	name = "Красная медовуха"
	description = "Настоящий напиток викингов! Несмотря его странный цвет."
	color = "#C73C00" // rgb: 199, 60, 0
	boozepwr = 31 //Red drinks are stronger
	quality = DRINK_GOOD
	taste_description = "сладкий и соленый алкоголь"
	glass_icon_state = "red_meadglass"
	glass_name = "Красная медовуха"
	glass_desc = "Настоящий напиток викингов, приготовленный из крови их врагов."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/mead
	name = "Медовуха"
	description = "Напиток викингов, хоть и дешевый, но любимый."
	color = "#664300" // rgb: 102, 67, 0
	nutriment_factor = 1 * REAGENTS_METABOLISM
	boozepwr = 30
	quality = DRINK_NICE
	taste_description = "сладкий, сладкий алкоголь"
	glass_icon_state = "meadglass"
	glass_name = "Медовуха"
	glass_desc = "Напиток из Вальхаллы."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/iced_beer
	name = "Ледяное пиво"
	description = "Настолько холодное пиво, что воздух вокруг замерзает."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 15
	taste_description = "освежающая прохлада"
	glass_icon_state = "iced_beerglass"
	glass_name = "ледяное пиво"
	glass_desc = "Настолько холодное пиво, что воздух вокруг замерзает."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/iced_beer/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjust_bodytemperature(-20 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, T0C) //310.15 is the normal bodytemp.
	return ..()

/datum/reagent/consumable/ethanol/grog
	name = "Грог"
	description = "Разбавленный водой ром, НаноТрейзен одобряет!"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 1 //Basically nothing
	taste_description = "плохое оправдание для алкоголя"
	glass_icon_state = "grogglass"
	glass_name = "Грог"
	glass_desc = "Прекрасный напиток для космоса."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED


/datum/reagent/consumable/ethanol/aloe
	name = "Алоэ"
	description = "Очень, очень, очень хорош."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 35
	quality = DRINK_VERYGOOD
	taste_description = "сладкий и сливочный"
	glass_icon_state = "aloe"
	glass_name = "Алоэ"
	glass_desc = "Очень, очень, очень хорош."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	//somewhat annoying mix
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/ethanol/andalusia
	name = "Андалузия"
	description = "Приятный напиток со странным названием."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 40
	quality = DRINK_GOOD
	taste_description = "лимоны"
	glass_icon_state = "andalusia"
	glass_name = "Андалузия"
	glass_desc = "Приятный напиток со странным названием"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/alliescocktail
	name = "Коктейль союзников"
	description = "Напиток, приготовленный вашими союзниками. Не так сладок, как напиток, приготовленный из ваших врагов."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 45
	quality = DRINK_NICE
	taste_description = "горький, но свободный"
	glass_icon_state = "alliescocktail"
	glass_name = "Коктейль союзников"
	glass_desc = "От товарищей по борьбе."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/acid_spit
	name = "Кислотный плевок"
	description = "Напиток для смелых. При неправильном приготовлении может оказаться смертельно опасным!"
	special_sound = 'white/valtos/sounds/drink/airlock_alien_prying.ogg'
	color = "#365000" // rgb: 54, 80, 0
	boozepwr = 70
	quality = DRINK_VERYGOOD
	taste_description = "желудочная кислота"
	glass_icon_state = "acidspitglass"
	glass_name = "Кислотный плевок"
	glass_desc = "Фирменный напиток NanoTrasen."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/amasec
	name = "Амасек"
	description = "Официальный напиток оружейного клуба \"НаноТрейзен\"!"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 35
	quality = DRINK_GOOD
	taste_description = "темный и металлический"
	glass_icon_state = "amasecglass"
	glass_name = "Амасек"
	glass_desc = "Всегда под рукой перед БОЕМ!!!"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/changelingsting
	name = "Жало генокрада"
	description = "Вы делаете маленький глоток и чувствуете жжение...."
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "мой мозг выходит из носа"
	glass_icon_state = "changelingsting"
	glass_name = "Жало генокрада"
	glass_desc = "Жгучий коктейль."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/changelingsting/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.mind) //Changeling Sting assists in the recharging of changeling chemicals.
		var/datum/antagonist/changeling/changeling = M.mind.has_antag_datum(/datum/antagonist/changeling)
		if(changeling)
			changeling.chem_charges += metabolization_rate * REM * delta_time
			changeling.chem_charges = clamp(changeling.chem_charges, 0, changeling.chem_storage)
	return ..()

/datum/reagent/consumable/ethanol/irishcarbomb
	name = "Ирландская Автомобильная бомба"
	description = "Ммм, на вкус как свободное ирландское государство."
	special_sound = 'white/valtos/sounds/drink/irish_coffee.ogg'
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 25
	quality = DRINK_GOOD
	taste_description = "вкусный гнев"
	glass_icon_state = "irishcarbomb"
	glass_name = "Ирландская Автомобильная бомба."
	glass_desc = "Ирландская Автомобильная бомба."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/syndicatebomb
	name = "Бомба Синдиката"
	description = "На вкус как терроризм!"
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 90
	quality = DRINK_GOOD
	taste_description = "очищенный антагонизм"
	glass_icon_state = "syndicatebomb"
	glass_name = "Бомба Синдиката"
	glass_desc = "Для настоящих агентов."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/syndicatebomb/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(DT_PROB(2.5, delta_time))
		playsound(get_turf(M), pick(FAR_EXPLOSION_SOUNDS), 100, TRUE)
	return ..()

/datum/reagent/consumable/ethanol/hiveminderaser
	name = "Стиратель улья"
	description = "Сосуд чистого вкуса."
	color = "#FF80FC" // rgb: 255, 128, 252
	boozepwr = 40
	quality = DRINK_GOOD
	taste_description = "экстрасенсорные ссылки"
	glass_icon_state = "hiveminderaser"
	glass_name = "Стиратель улья"
	glass_desc = "Для тех случаев, когда даже щиты разума не могут вас спасти."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/erikasurprise
	name = "Сюрприз Эрики"
	description = "Это сюрпиз! И он зеленый!"
	special_sound = 'white/valtos/sounds/drink/erika.ogg'
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 35
	quality = DRINK_VERYGOOD
	taste_description = "терпкость и бананы"
	glass_icon_state = "erikasurprise"
	glass_name = "Сюрприз Эрики"
	glass_desc = "Это сюрприз! И он зеленый!"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/driestmartini
	name = "Сухой Мартини"
	description = "Только для бывалых. Вам кажется, что вы видите песок, плавающий в бокале."
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 65
	quality = DRINK_GOOD
	taste_description = "пляж"
	glass_icon_state = "driestmartiniglass"
	glass_name = "Сухой Мартини"
	glass_desc = "Только для бывалых. Вам кажется, что вы видите песок, плавающий в бокале."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/bananahonk
	name = "Банановый Хонк"
	description = "Напиток из клоунского рая."
	special_sound = 'white/valtos/sounds/drink/bikehorn.ogg'
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#FFFF91" // rgb: 255, 255, 140
	boozepwr = 60
	quality = DRINK_GOOD
	taste_description = "плохая шутка"
	glass_icon_state = "bananahonkglass"
	glass_name = "Банановый хонк"
	glass_desc = "Напиток из клоунского рая."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/bananahonk/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	var/obj/item/organ/liver/liver = M.get_organ_slot(ORGAN_SLOT_LIVER)
	if((liver && HAS_TRAIT(liver, TRAIT_COMEDY_METABOLISM)) || ismonkey(M))
		M.heal_bodypart_damage(1 * REM * delta_time, 1 * REM * delta_time)
		. = TRUE
	return ..() || .

/datum/reagent/consumable/ethanol/silencer
	name = "Глушитель"
	description = "Напиток из Рая для Мимов."
	nutriment_factor = 2 * REAGENTS_METABOLISM
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 59 //Proof that clowns are better than mimes right here
	quality = DRINK_GOOD
	taste_description = "ластик"
	glass_icon_state = "silencerglass"
	glass_name = "Глушитель"
	glass_desc = "Напиток из Рая для Мимов."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/silencer/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(ishuman(M) && M.mind?.miming)
		M.silent = max(M.silent, MIMEDRINK_SILENCE_DURATION)
		M.heal_bodypart_damage(1 * REM * delta_time, 1 * REM * delta_time)
		. = TRUE
	return ..() || .

/datum/reagent/consumable/ethanol/drunkenblumpkin
	name = "Пьяный тупица"
	description = "Странная смесь виски и сока бюспейс тыквы."
	color = "#1EA0FF" // rgb: 102, 67, 0
	boozepwr = 50
	quality = DRINK_VERYGOOD
	taste_description = "патока и глоток воды в бассейне"
	glass_icon_state = "drunkenblumpkin"
	glass_name = "Пьяный тупица"
	glass_desc = "Выпивка для пьяниц."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/whiskey_sour //Requested since we had whiskey cola and soda but not sour.
	name = "Виски Сауэр"
	description = "Lemon juice/whiskey/sugar mixture. Moderate alcohol content."
	color = rgb(255, 201, 49)
	boozepwr = 35
	quality = DRINK_GOOD
	taste_description = "кислые лимоны"
	glass_icon_state = "whiskey_sour"
	glass_name = "whiskey sour"
	glass_desc = "Lemon juice mixed with whiskey and a dash of sugar. Surprisingly satisfying."

/datum/reagent/consumable/ethanol/hcider
	name = "Крепкий Сидр"
	description = "Яблочный сок для взрослых."
	special_sound = 'white/nocringe/sounds/drink/hcider.ogg'
	color = "#CD6839"
	nutriment_factor = 1 * REAGENTS_METABOLISM
	boozepwr = 25
	taste_description = "сезон, который <i>выпадает</i> между летом и зимой"
	glass_icon_state = "whiskeyglass"
	glass_name = "крепкий сидр"
	glass_desc = "Что такое осень - это небо."
	shot_glass_icon_state = "shotglassbrown"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/fetching_fizz //A reference to one of my favorite games of all time. Pulls nearby ores to the imbiber!
	name = "Приход"
	description = "Смесь кислого виски с железом и ураном, в результате чего образуется высокомагнитная суспензия." //Requires no alcohol to make but has alcohol anyway because ~magic~
	color = rgb(255, 91, 15)
	boozepwr = 10
	quality = DRINK_VERYGOOD
	metabolization_rate = 0.1 * REAGENTS_METABOLISM
	taste_description = "заряженный металл" // the same as teslium, honk honk.
	glass_icon_state = "fetching_fizz"
	glass_name = "Приход"
	glass_desc = "Вызывает магнетизм у выпившего. Коктейль появился как шутка в баре, но потом стал популярным среди шахтеров. Имеет металлическое послевкусие."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/fetching_fizz/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	for(var/obj/item/stack/ore/O in orange(3, M))
		step_towards(O, get_turf(M))
	return ..()

//Another reference. Heals those in critical condition extremely quickly.
/datum/reagent/consumable/ethanol/hearty_punch
	name = "Сердечный Пунш"
	description = "Смесь Храброго Быка, Бомбы Синдиката и абсента, в результате чего получается возбуждающий напиток."
	color = rgb(140, 0, 0)
	boozepwr = 90
	quality = DRINK_VERYGOOD
	metabolization_rate = 0.4 * REAGENTS_METABOLISM
	taste_description = "бравада перед лицом катастрофы"
	glass_icon_state = "hearty_punch"
	glass_name = "Сердечный Пунш"
	glass_desc = "Ароматный напиток, который подается горячим. Согласно народным преданиям, он может разбудить даже мертвого."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/hearty_punch/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.health <= 0)
		M.adjustBruteLoss(-3 * REM * delta_time, 0)
		M.adjustFireLoss(-3 * REM * delta_time, 0)
		M.adjustCloneLoss(-5 * REM * delta_time, 0)
		M.adjustOxyLoss(-4 * REM * delta_time, 0)
		M.adjustToxLoss(-3 * REM * delta_time, 0)
		. = TRUE
	return ..() || .

/datum/reagent/consumable/ethanol/bacchus_blessing //An EXTREMELY powerful drink. Smashed in seconds, dead in minutes.
	name = "Бахус"
	description = "Неидентифицируемая смесь. Неизмеримо высокое содержание алкоголя."
	color = rgb(51, 19, 3) //Sickly brown
	boozepwr = 300 //I warned you
	taste_description = "кирпичная стена"
	glass_icon_state = "glass_brown2"
	glass_name = "Бахус"
	glass_desc = "Вы не думали, что жидкость может быть настолько отвратительной...?"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/atomicbomb
	name = "Атомная Бомба"
	description = "Ядерное оружие никогда не было таким вкусным."
	special_sound = 'white/valtos/sounds/drink/atomic_bomb.ogg'
	color = "#666300" // rgb: 102, 99, 0
	boozepwr = 0 //custom drunk effect
	quality = DRINK_FANTASTIC
	taste_description = "бомба"
	glass_icon_state = "atomicbombglass"
	glass_name = "Атомная Бомба"
	glass_desc = "НаноТрейзен не может взять на себя юридическую ответственность за ваши действия после употребления этого коктейля."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_HIGH

/datum/reagent/consumable/ethanol/atomicbomb/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.set_drugginess(50 * REM * delta_time)
	if(!HAS_TRAIT(M, TRAIT_ALCOHOL_TOLERANCE))
		M.set_confusion(max(M.get_confusion() + (2 * REM * delta_time),0))
		M.Dizzy(10 * REM * delta_time)
	if (!M.slurring)
		M.slurring = 1 * REM * delta_time
	M.slurring += 3 * REM * delta_time
	switch(current_cycle)
		if(51 to 200)
			M.Sleeping(100 * REM * delta_time)
			. = TRUE
		if(201 to INFINITY)
			M.AdjustSleeping(40 * REM * delta_time)
			M.adjustToxLoss(2 * REM * delta_time, 0)
			. = TRUE
	..()

/datum/reagent/consumable/ethanol/gargle_blaster
	name = "Пангалактический ополаскиватель"
	description = "Вау, эта штука выглядит нестабильной."
	special_sound = 'white/valtos/sounds/drink/enter_galactic.ogg'
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 0 //custom drunk effect
	quality = DRINK_GOOD
	taste_description = "мои мозги разбиты лимоном, обернутым вокруг золотого кирпича"
	glass_icon_state = "gargleblasterglass"
	glass_name = "Пангалактический ополаскиватель"
	glass_desc = "Как если бы тебе выбили мозг долькой лимона, обернутой вокруг большого золотого кирпича."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/gargle_blaster/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.dizziness += 1.5 * REM * delta_time
	switch(current_cycle)
		if(15 to 45)
			if(!M.slurring)
				M.slurring = 1 * REM * delta_time
			M.slurring += 3 * REM * delta_time
		if(45 to 55)
			if(DT_PROB(30, delta_time))
				M.set_confusion(max(M.get_confusion() + 3, 0))
		if(55 to 200)
			M.set_drugginess(55 * REM * delta_time)
		if(200 to INFINITY)
			M.adjustToxLoss(2 * REM * delta_time, 0)
			. = TRUE
	..()

/datum/reagent/consumable/ethanol/neurotoxin
	name = "Нейротоксин"
	description = "Сильный нейротоксин, который вводит субъекта в состояние, подобное смерти."
	color = "#2E2E61" // rgb: 46, 46, 97
	boozepwr = 50
	quality = DRINK_VERYGOOD
	taste_description = "онемение"
	metabolization_rate = 1 * REAGENTS_METABOLISM
	glass_icon_state = "neurotoxinglass"
	glass_name = "Нейротоксин"
	glass_desc = "Напиток, который гарантированно собьет вас с толку."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/neurotoxin/proc/pickt()
	return (pick(TRAIT_PARALYSIS_L_ARM,TRAIT_PARALYSIS_R_ARM,TRAIT_PARALYSIS_R_LEG,TRAIT_PARALYSIS_L_LEG))

/datum/reagent/consumable/ethanol/neurotoxin/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.set_drugginess(50 * REM * delta_time)
	M.dizziness += 2 * REM * delta_time
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 1 * REM * delta_time, 150)
	if(DT_PROB(10, delta_time))
		M.adjustStaminaLoss(10)
		M.drop_all_held_items()
		to_chat(M, span_notice("Не чувствую свои руки!"))
	if(current_cycle > 5)
		if(DT_PROB(10, delta_time))
			var/t = pickt()
			ADD_TRAIT(M, t, type)
			M.adjustStaminaLoss(10)
		if(current_cycle > 30)
			M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2 * REM * delta_time)
			if(current_cycle > 50 && DT_PROB(7.5, delta_time))
				if(!M.undergoing_cardiac_arrest() && M.can_heartattack())
					M.set_heartattack(TRUE)
					if(M.stat == CONSCIOUS)
						M.visible_message(span_userdanger("[M] хватается за [M.ru_ego()] грудь, будто [M.ru_ego()] сердце остановилось!"))
	. = TRUE
	..()

/datum/reagent/consumable/ethanol/neurotoxin/on_mob_end_metabolize(mob/living/carbon/M)
	REMOVE_TRAIT(M, TRAIT_PARALYSIS_L_ARM, type)
	REMOVE_TRAIT(M, TRAIT_PARALYSIS_R_ARM, type)
	REMOVE_TRAIT(M, TRAIT_PARALYSIS_R_LEG, type)
	REMOVE_TRAIT(M, TRAIT_PARALYSIS_L_LEG, type)
	M.adjustStaminaLoss(10)
	..()

/datum/reagent/consumable/ethanol/hippies_delight
	name = "Услада Хиппи"
	description = "Ты просто не догоняешь, чуваааак."
	color = "#664300" // rgb: 102, 67, 0
	nutriment_factor = 0
	boozepwr = 0 //custom drunk effect
	quality = DRINK_FANTASTIC
	metabolization_rate = 0.2 * REAGENTS_METABOLISM
	taste_description = "дать миру шанс"
	glass_icon_state = "hippiesdelightglass"
	glass_name = "Услада Хиппи"
	glass_desc = "Напиток, которым наслаждались люди в 1960-е годы."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/hippies_delight/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if (!M.slurring)
		M.slurring = 1 * REM * delta_time
	switch(current_cycle)
		if(1 to 5)
			M.Dizzy(10 * REM * delta_time)
			M.set_drugginess(30 * REM * delta_time)
			if(DT_PROB(5, delta_time))
				M.emote(pick("twitch","giggle"))
		if(5 to 10)
			M.Jitter(20 * REM * delta_time)
			M.Dizzy(20 * REM * delta_time)
			M.set_drugginess(45 * REM * delta_time)
			if(DT_PROB(10, delta_time))
				M.emote(pick("twitch","giggle"))
		if (10 to 200)
			M.Jitter(40 * REM * delta_time)
			M.Dizzy(40 * REM * delta_time)
			M.set_drugginess(60 * REM * delta_time)
			if(DT_PROB(16, delta_time))
				M.emote(pick("twitch","giggle"))
		if(200 to INFINITY)
			M.Jitter(60 * REM * delta_time)
			M.Dizzy(60 * REM * delta_time)
			M.set_drugginess(75 * REM * delta_time)
			if(DT_PROB(23, delta_time))
				M.emote(pick("twitch","giggle"))
			if(DT_PROB(16, delta_time))
				M.adjustToxLoss(2, 0)
				. = TRUE
	..()

/datum/reagent/consumable/ethanol/eggnog
	name = "Гоголь-Моголь"
	description = "Для наслаждения самым замечательным временем года."
	color = "#fcfdc6" // rgb: 252, 253, 198
	nutriment_factor = 2 * REAGENTS_METABOLISM
	boozepwr = 1
	quality = DRINK_VERYGOOD
	taste_description = "заварной крем и алкоголь"
	glass_icon_state = "glass_yellow"
	glass_name = "Гоголь-Моголь"
	glass_desc = "Для наслаждения самым замечательным временем года."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED


/datum/reagent/consumable/ethanol/narsour
	name = "Нар'Кис"
	description = "Побочные эффекты включают самобичевание и накопительство пластали."
	color = RUNE_COLOR_DARKRED
	boozepwr = 10
	quality = DRINK_FANTASTIC
	taste_description = "кровь"
	glass_icon_state = "narsour"
	glass_name = "Нар'Кис"
	glass_desc = "Новый хитовый коктейль, вдохновленный пивоварней РУКА, заставит вас кричать Fuu ma'jin в мгновение ока!"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/narsour/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.cultslurring = min(M.cultslurring + (3 * REM * delta_time), 3)
	M.stuttering = min(M.stuttering + (3 * REM * delta_time), 3)
	..()

/datum/reagent/consumable/ethanol/triple_sec
	name = "Трипл Сек"
	description = "Сладкий и яркий на вкус апельсиновый ликер."
	color = "#ffcc66"
	boozepwr = 30
	taste_description = "теплый цветочный апельсиновый вкус, напоминающий воздушный океан и летний карибский ветер"
	glass_icon_state = "glass_orange"
	glass_name = "Трипл Сек"
	glass_desc = "Стакан натурального Трипл Сек."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/creme_de_menthe
	name = "Мятный ликер"
	description = "Мятный ликер отлично подходит для освежающих, прохладных напитков."
	color = "#00cc00"
	boozepwr = 20
	taste_description = "мятный, прохладный и бодрящий всплеск холодной воды"
	glass_icon_state = "glass_green"
	glass_name = "Мятный ликер"
	glass_desc = "Глядя на него, можно почувствовать первое дыхание весны."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/creme_de_cacao
	name = "Шоколадный ликер"
	description = "Шоколадный ликер отлично подходит для придания десертных нот напиткам и подкупа женских обществ."
	color = "#996633"
	boozepwr = 20
	taste_description = "гладкий и ароматный намек конфет, кружащихся в укусе алкоголя"
	glass_icon_state = "glass_brown"
	glass_name = "Шоколадный ликер"
	glass_desc = "Миллион судебных исков о дедовщине и отравлениях алкоголем начались с этого скромного коктейля."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/creme_de_coconut
	name = "Кокосовый ликер"
	description = "Кокосовый ликер для мягких, сливочных, тропических напитков."
	color = "#F7F0D0"
	boozepwr = 20
	taste_description = "сладкий молочный вкус с нотами поджаренного сахара"
	glass_icon_state = "glass_white"
	glass_name = "Кокосовый ликер"
	glass_desc = "Неотразимый бокал кокосового ликера."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/quadruple_sec
	name = "Квадрипл Сек"
	description = "Прекрасен, как облизывание батарейки станбатона."
	color = "#cc0000"
	boozepwr = 35
	quality = DRINK_GOOD
	taste_description = "бодрящая горькая свежесть, которая наполняет ваше существо; ни один враг станции не останется незамеченным в этот день"
	glass_icon_state = "quadruple_sec"
	glass_name = "Квадрипл Сек"
	glass_desc = "Выпив, вы чувствуете себя как супер-секурити, который может пройти через стену и убить всех врагов станции."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/quadruple_sec/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	//Securidrink in line with the Screwdriver for engineers or Nothing for mimes
	var/obj/item/organ/liver/liver = M.get_organ_slot(ORGAN_SLOT_LIVER)
	if(liver && HAS_TRAIT(liver, TRAIT_LAW_ENFORCEMENT_METABOLISM))
		M.heal_bodypart_damage(1 * REM * delta_time, 1 * REM * delta_time)
		M.adjustBruteLoss(-2 * REM * delta_time, 0)
		. = TRUE
	return ..()

/datum/reagent/consumable/ethanol/quintuple_sec
	name = "Квантипл Сек"
	description = "Закон, порядок, алкоголь и полицейское "
	color = "#ff3300"
	boozepwr = 55
	quality = DRINK_FANTASTIC
	taste_description = "ЗАКОН"
	glass_icon_state = "quintuple_sec"
	glass_name = "Квантипл Сек"
	glass_desc = "Теперь \"ТЫ\" закон, уничтожитель клоунов."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/quintuple_sec/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	//Securidrink in line with the Screwdriver for engineers or Nothing for mimes but STRONG..
	var/obj/item/organ/liver/liver = M.get_organ_slot(ORGAN_SLOT_LIVER)
	if(liver && HAS_TRAIT(liver, TRAIT_LAW_ENFORCEMENT_METABOLISM))
		M.heal_bodypart_damage(2 * REM * delta_time, 2 * REM *  delta_time, 2 * REM * delta_time)
		M.adjustBruteLoss(-5 * REM * delta_time, 0)
		M.adjustOxyLoss(-5 * REM * delta_time, 0)
		M.adjustFireLoss(-5 * REM * delta_time, 0)
		M.adjustToxLoss(-5 * REM * delta_time, 0)
		. = TRUE
	return ..()

/datum/reagent/consumable/ethanol/grasshopper
	name = "Кузнечик"
	description = "Свежий и сладкий десертный шутер. Трудно выглядеть мужественным, когда пьешь это."
	color = "#00ff00"
	boozepwr = 25
	quality = DRINK_GOOD
	taste_description = "шоколад и мята танцуют вокруг моего рта"
	glass_icon_state = "grasshopper"
	glass_name = "Кузнечик"
	glass_desc = "Вы не знали, что коктейли могут быть такими зелеными."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/stinger
	name = "Стингер"
	description = "Отличный способ закончить день."
	color = "#ccff99"
	boozepwr = 25
	quality = DRINK_NICE
	taste_description = "пощечина в лучшем виде"
	glass_icon_state = "stinger"
	glass_name = "Стингер"
	glass_desc = "Интересно, что произойдет, если направить его на источник тепла..."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/bastion_bourbon
	name = "Бурбон «Бастион»"
	description = "Успокаивающий горячий травяной напиток с восстанавливающими свойствами."
	color = "#00FFFF"
	boozepwr = 30
	quality = DRINK_FANTASTIC
	taste_description = "горячий травяной напиток с фруктовым оттенком"
	metabolization_rate = 2 * REAGENTS_METABOLISM //0.8u per tick
	glass_icon_state = "bastion_bourbon"
	glass_name = "Бурбон «Бастион»"
	glass_desc = "Если вы чувствуете себя неважно, положитесь на маслянистый вкус нашего собственного бурбона \"Бастион\"."
	shot_glass_icon_state = "shotglassgreen"
	ph = 4
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_HIGH

/datum/reagent/consumable/ethanol/bastion_bourbon/on_mob_metabolize(mob/living/L)
	var/heal_points = 10
	if(L.health <= 0)
		heal_points = 20 //heal more if we're in softcrit
	for(var/i in 1 to min(volume, heal_points)) //only heals 1 point of damage per unit on add, for balance reasons
		L.adjustBruteLoss(-1)
		L.adjustFireLoss(-1)
		L.adjustToxLoss(-1)
		L.adjustOxyLoss(-1)
		L.adjustStaminaLoss(-1)
	L.visible_message(span_warning("[L] дрожит с новой силой!") , span_notice("Вкус [lowertext(name)] наполняет меня энергией!"))
	if(!L.stat && heal_points == 20) //brought us out of softcrit
		L.visible_message(span_danger("[L] накренилась в сторону [L.ru_ego()] ноги!") , span_boldnotice("Проснись и пой, малыш."))

/datum/reagent/consumable/ethanol/bastion_bourbon/on_mob_life(mob/living/L, delta_time, times_fired)
	if(L.health > 0)
		L.adjustBruteLoss(-1 * REM * delta_time)
		L.adjustFireLoss(-1 * REM * delta_time)
		L.adjustToxLoss(-0.5 * REM * delta_time)
		L.adjustOxyLoss(-3 * REM * delta_time)
		L.adjustStaminaLoss(-5 * REM * delta_time)
		. = TRUE
	..()

/datum/reagent/consumable/ethanol/squirt_cider
	name = "Сидровый сквирт"
	description = "Забродивший экстракт сквирта с ароматом черствого хлеба и океанской воды. Что бы это ни было."
	color = "#FF0000"
	boozepwr = 40
	taste_description = "черствый хлеб с послевкусием послевкусия"
	nutriment_factor = 2 * REAGENTS_METABOLISM
	glass_icon_state = "squirt_cider"
	glass_name = "Сидровый сквирт"
	glass_desc = "Этот сидр сделает вас крепче. Жаль, что послевкусие не очень"
	shot_glass_icon_state = "shotglassgreen"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/squirt_cider/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.satiety += 5 * REM * delta_time //for context, vitamins give 15 satiety per second
	..()
	. = TRUE

/datum/reagent/consumable/ethanol/fringe_weaver
	name = "Бон Развязон"
	description = "Пузырчатый, стильный и, несомненно, сильный - классика Глитч Сити."
	special_sound = 'white/valtos/sounds/drink/va-lchalla.ogg'
	color = "#FFEAC4"
	boozepwr = 90 //classy hooch, essentially, but lower pwr to make up for slightly easier access
	quality = DRINK_GOOD
	taste_description = "этиловый спирт с оттенком сахара"
	glass_icon_state = "fringe_weaver"
	glass_name = "Бон Развязон"
	glass_desc = "Удивительно, что он не выливается из стакана."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/sugar_rush
	name = "Сладкий форсаж"
	description = "Сладкий, легкий и фруктовый - девчачий."
	special_sound = 'white/valtos/sounds/drink/va-lchalla.ogg'
	color = "#FF226C"
	boozepwr = 10
	quality = DRINK_GOOD
	taste_description = "ваши артерии засоряются сахаром"
	nutriment_factor = 2 * REAGENTS_METABOLISM
	glass_icon_state = "sugar_rush"
	glass_name = "Сладкий форсаж"
	glass_desc = "Если ты не можешь сделать \"Сладкий форсаж\", то ты не можешь называть себя барменом."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/sugar_rush/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.satiety -= 10 * REM * delta_time //junky as hell! a whole glass will keep you from being able to eat junk food
	..()
	. = TRUE

/datum/reagent/consumable/ethanol/crevice_spike
	name = "Спазм Кишок"
	description = "Кислый, горький и отлично отрезвляющий."
	special_sound = 'white/valtos/sounds/drink/va-lchalla.ogg'
	color = "#5BD231"
	boozepwr = -10 //sobers you up - ideally, one would drink to get hit with brute damage now to avoid alcohol problems later
	quality = DRINK_VERYGOOD
	taste_description = "горький спайк с кислым послевкусием"
	glass_icon_state = "crevice_spike"
	glass_name = "Спазм Кишок"
	glass_desc = "Он либо отрезвит тебя, либо окончательно вырубит. Скорее всего, и то, и другое."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/crevice_spike/on_mob_metabolize(mob/living/L) //damage only applies when drink first enters system and won't again until drink metabolizes out
	L.adjustBruteLoss(3 * min(5,volume)) //minimum 3 brute damage on ingestion to limit non-drink means of injury - a full 5 unit gulp of the drink trucks you for the full 15

/datum/reagent/consumable/ethanol/sake
	name = "Сакэ"
	description = "Сладкое рисовое вино сомнительной легальности и чрезвычайно сильного действия."
	color = "#DDDDDD"
	boozepwr = 70
	taste_description = "сладкое рисовое вино"
	glass_icon_state = "sakecup"
	glass_name = "Сакэ"
	glass_desc = "Чашка традиционного сакэ."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_STOCK

/datum/reagent/consumable/ethanol/peppermint_patty
	name = "Мятная Пэтти"
	description = "Этот слабоалкогольный напиток сочетает в себе полезные свойства ментола и какао."
	color = "#45ca7a"
	taste_description = "мята и шоколад"
	boozepwr = 25
	quality = DRINK_GOOD
	glass_icon_state = "peppermint_patty"
	glass_name = "Мятная Пэтти"
	glass_desc = "Пьянящее мятное горячее какао, которое согреет ваш живот в холодную ночь."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/peppermint_patty/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.apply_status_effect(/datum/status_effect/throat_soothed)
	M.adjust_bodytemperature(5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, 0, M.get_body_temp_normal())
	..()

/datum/reagent/consumable/ethanol/alexander
	name = "Александр"
	description = "Названная в честь греческого героя, эта смесь, как говорят, укрепляет щит пользователя, как будто он находится в фаланге."
	special_sound = 'white/valtos/sounds/drink/alexander.ogg'
	color = "#F5E9D3"
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "горький, сливочный какао"
	glass_icon_state = "alexander"
	glass_name = "Александр"
	glass_desc = "Сливочное, снисходительное наслаждение, которое крепче, чем кажется."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	var/obj/item/shield/mighty_shield

/datum/reagent/consumable/ethanol/alexander/on_mob_metabolize(mob/living/L)
	if(ishuman(L))
		var/mob/living/carbon/human/thehuman = L
		for(var/obj/item/shield/theshield in thehuman.contents)
			mighty_shield = theshield
			mighty_shield.block_chance += 10
			to_chat(thehuman, span_notice("[theshield] выглядит отполированным, хотя, я, кажется, его не полировал."))
			return TRUE

/datum/reagent/consumable/ethanol/alexander/on_mob_life(mob/living/L, delta_time, times_fired)
	..()
	if(mighty_shield && !(mighty_shield in L.contents)) //If you had a shield and lose it, you lose the reagent as well. Otherwise this is just a normal drink.
		holder.remove_reagent(type)

/datum/reagent/consumable/ethanol/alexander/on_mob_end_metabolize(mob/living/L)
	if(mighty_shield)
		mighty_shield.block_chance -= 10
		to_chat(L,span_notice("Заметил что [mighty_shield] снова выглядит потрепанным. Странно."))
	..()

/datum/reagent/consumable/ethanol/amaretto_alexander
	name = "Александр Амаретто"
	description = "Более слабая версия Александра, но то, чего ей не хватает в силе, она восполняет во вкусе."
	color = "#DBD5AE"
	boozepwr = 35
	quality = DRINK_VERYGOOD
	taste_description = "sweet, creamy cacao"
	glass_icon_state = "alexanderam"
	glass_name = "Александр Амаретто"
	glass_desc = "Сливочное, снисходительное наслаждение, которое на самом деле такое нежно, каким кажется."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/sidecar
	name = "Сайдкар"
	description = "Единственная поездка, ради которой вы с радостью отдадите руль."
	color = "#FFC55B"
	boozepwr = 45
	quality = DRINK_GOOD
	taste_description = "вкусная свобода"
	glass_icon_state = "sidecar"
	glass_name = "Сайдкар"
	glass_desc = "Единственная поездка, ради которой вы с радостью отдадите руль."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/ethanol/between_the_sheets
	name = "Между Простынями"
	description = "Классика с провокационным названием. Забавно, но врачи рекомендуют пить его перед сном."
	color = "#F4C35A"
	boozepwr = 55
	quality = DRINK_GOOD
	taste_description = "обольщение"
	glass_icon_state = "between_the_sheets"
	glass_name = "Между Простынями"
	glass_desc = "Единственный напиток, который поставляется с этикеткой, напоминающей вам о политике нетерпимости к беспорядочным половым связям компании НаноТрейзен."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/ethanol/between_the_sheets/on_mob_life(mob/living/L, delta_time, times_fired)
	..()
	if(L.IsSleeping())
		if(L.getBruteLoss() && L.getFireLoss()) //If you are damaged by both types, slightly increased healing but it only heals one. The more the merrier wink wink.
			if(prob(50))
				L.adjustBruteLoss(-0.25 * REM * delta_time)
			else
				L.adjustFireLoss(-0.25 * REM * delta_time)
		else if(L.getBruteLoss()) //If you have only one, it still heals but not as well.
			L.adjustBruteLoss(-0.2 * REM * delta_time)
		else if(L.getFireLoss())
			L.adjustFireLoss(-0.2 * REM * delta_time)

/datum/reagent/consumable/ethanol/kamikaze
	name = "Камикадзе"
	description = "Божественный ветер."
	color = "#EEF191"
	boozepwr = 60
	quality = DRINK_GOOD
	taste_description = "божественная ветренность"
	glass_icon_state = "kamikaze"
	glass_name = "Камикадзе"
	glass_desc = "Божественный ветер."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/mojito
	name = "Мохито"
	description = "Один только вид этого напитка освежает вас."
	color = "#DFFAD9"
	boozepwr = 30
	quality = DRINK_GOOD
	taste_description = "освежающая мята"
	glass_icon_state = "mojito"
	glass_name = "Мохито"
	glass_desc = "Один только вид этого напитка освежает вас."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/ethanol/moscow_mule
	name = "Московский Мул"
	description = "Прохладительный напиток, напоминающий вам о Дереликте."
	color = "#EEF1AA"
	boozepwr = 30
	quality = DRINK_GOOD
	taste_description = "освежающая пряность"
	glass_icon_state = "moscow_mule"
	glass_name = "Московский Мул"
	glass_desc = "Прохладительный напиток, напоминающий вам о Дереликте."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/fernet
	name = "Фернет"
	description = "Невероятно горький травяной ликер, используемый в качестве дижестива."
	color = "#1B2E24" // rgb: 27, 46, 36
	boozepwr = 80
	taste_description = "полная горечь"
	glass_name = "Фернет"
	glass_desc = "Бокал чистого Фернета. Только абсолютный безумец будет пить его в одиночку." //Hi Kevum
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/fernet/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.nutrition <= NUTRITION_LEVEL_STARVING)
		M.adjustToxLoss(1 * REM * delta_time, 0)
	M.adjust_nutrition(-5 * REM * delta_time)
	M.overeatduration = 0
	return ..()

/datum/reagent/consumable/ethanol/fernet_cola
	name = "Фернет с Колой"
	description = "Очень популярный и горько-сладкий дижестив. Идеально подавать после плотного обеда."
	color = "#390600" // rgb: 57, 6,
	boozepwr = 25
	quality = DRINK_NICE
	taste_description = "сладкое облегчение"
	glass_icon_state = "godlyblend"
	glass_name = "Фернет с Колой"
	glass_desc = "Бутылка из-под колы, наполненная Фернет Колой. Лучший напиток после еды."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/fernet_cola/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.nutrition <= NUTRITION_LEVEL_STARVING)
		M.adjustToxLoss(0.5 * REM * delta_time, 0)
	M.adjust_nutrition(-3 * REM * delta_time)
	M.overeatduration = 0
	return ..()

/datum/reagent/consumable/ethanol/fanciulli

	name = "Фанциулли"
	description = "Что если бы в коктейле \"Манхэттен\" ДЕЙСТВИТЕЛЬНО использовался ликер из горьких трав? Помогает протрезветь." //also causes a bit of stamina damage to symbolize the afterdrink lazyness
	color = "#CA933F" // rgb: 202, 147, 63
	boozepwr = -10
	quality = DRINK_NICE
	taste_description = "сладкая отрезвляющая смесь"
	glass_icon_state = "fanciulli"
	glass_name = "Фанциулли"
	glass_desc = "Бокал \"Фансиулли\". Это просто Манхэттен с Фернетом."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_HIGH

/datum/reagent/consumable/ethanol/fanciulli/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjust_nutrition(-5 * REM * delta_time)
	M.overeatduration = 0
	return ..()

/datum/reagent/consumable/ethanol/fanciulli/on_mob_metabolize(mob/living/M)
	if(M.health > 0)
		M.adjustStaminaLoss(20)
		. = TRUE
	..()


/datum/reagent/consumable/ethanol/branca_menta
	name = "Бранка Мента"
	description = "Освежающая смесь горького Фернета с мятным кремовым ликером."
	color = "#4B5746" // rgb: 75, 87, 70
	boozepwr = 35
	quality = DRINK_GOOD
	taste_description = "горькая свежесть"
	glass_icon_state= "minted_fernet"
	glass_name = "Бранка Мента"
	glass_desc = "Бокал \"Бранка Мента\", идеально подходящий для жарких летних воскресных полдников." //Get lazy literally by drinking this
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_MEDIUM


/datum/reagent/consumable/ethanol/branca_menta/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjust_bodytemperature(-20 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, T0C)
	return ..()

/datum/reagent/consumable/ethanol/branca_menta/on_mob_metabolize(mob/living/M)
	if(M.health > 0)
		M.adjustStaminaLoss(35)
		. = TRUE
	..()

/datum/reagent/consumable/ethanol/blank_paper
	name = "Чистый Лист"
	description = "Бокал пузырящейся белой жидкости. При одном взгляде на него вы почувствуете свежесть."
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#DCDCDC" // rgb: 220, 220, 220
	boozepwr = 20
	quality = DRINK_GOOD
	taste_description = "возможность пузырения"
	glass_icon_state = "blank_paper"
	glass_name = "Чистый Лист"
	glass_desc = "Шипучий коктейль для тех, кто хочет начать жизнь с чистого листа."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/blank_paper/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(ishuman(M) && M.mind?.miming)
		M.silent = max(M.silent, MIMEDRINK_SILENCE_DURATION)
		M.heal_bodypart_damage(1 * REM * delta_time, 1 * REM * delta_time)
		. = TRUE
	return ..()

/datum/reagent/consumable/ethanol/fruit_wine
	name = "Фруктовое Вино"
	description = "A wine made from grown plants."
	color = "#FFFFFF"
	boozepwr = 35
	quality = DRINK_GOOD
	taste_description = "плохой код"
	var/list/names = list("null fruit" = 1) //Names of the fruits used. Associative list where name is key, value is the percentage of that fruit.
	var/list/tastes = list("плохой код" = 1) //List of tastes. See above.
	ph = 4

/datum/reagent/consumable/ethanol/fruit_wine/on_new(list/data)
	names = data["names"]
	tastes = data["tastes"]
	boozepwr = data["boozepwr"]
	color = data["color"]
	generate_data_info(data)

/datum/reagent/consumable/ethanol/fruit_wine/on_merge(list/data, amount)
	..()
	var/diff = (amount/volume)
	if(diff < 1)
		color = BlendRGB(color, data["color"], diff/2) //The percentage difference over two, so that they take average if equal.
	else
		color = BlendRGB(color, data["color"], (1/diff)/2) //Adjust so it's always blending properly.
	var/oldvolume = volume-amount

	var/list/cachednames = data["names"]
	for(var/name in names | cachednames)
		names[name] = ((names[name] * oldvolume) + (cachednames[name] * amount)) / volume

	var/list/cachedtastes = data["tastes"]
	for(var/taste in tastes | cachedtastes)
		tastes[taste] = ((tastes[taste] * oldvolume) + (cachedtastes[taste] * amount)) / volume

	boozepwr *= oldvolume
	var/newzepwr = data["boozepwr"] * amount
	boozepwr += newzepwr
	boozepwr /= volume //Blending boozepwr to volume.
	generate_data_info(data)

/datum/reagent/consumable/ethanol/fruit_wine/proc/generate_data_info(list/data)
	// BYOND's compiler fails to catch non-consts in a ranged switch case, and it causes incorrect behavior. So this needs to explicitly be a constant.
	var/const/minimum_percent = 0.15 //Percentages measured between 0 and 1.
	var/list/primary_tastes = list()
	var/list/secondary_tastes = list()
	glass_name = "стакан [name]"
	glass_desc = description
	for(var/taste in tastes)
		switch(tastes[taste])
			if(minimum_percent*2 to INFINITY)
				primary_tastes += taste
			if(minimum_percent to minimum_percent*2)
				secondary_tastes += taste

	var/minimum_name_percent = 0.35
	name = ""
	var/list/names_in_order = sortTim(names, GLOBAL_PROC_REF(cmp_numeric_dsc), TRUE)
	var/named = FALSE
	for(var/fruit_name in names)
		if(names[fruit_name] >= minimum_name_percent)
			name += "[fruit_name] "
			named = TRUE
	if(named)
		name += "wine"
	else
		name = "вино, смешанное из [names_in_order[1]]"

	var/alcohol_description
	switch(boozepwr)
		if(120 to INFINITY)
			alcohol_description = "suicidally strong"
		if(90 to 120)
			alcohol_description = "rather strong"
		if(70 to 90)
			alcohol_description = "strong"
		if(40 to 70)
			alcohol_description = "rich"
		if(20 to 40)
			alcohol_description = "mild"
		if(0 to 20)
			alcohol_description = "sweet"
		else
			alcohol_description = "watery" //How the hell did you get negative boozepwr?

	var/list/fruits = list()
	if(names_in_order.len <= 3)
		fruits = names_in_order
	else
		for(var/i in 1 to 3)
			fruits += names_in_order[i]
		fruits += "other plants"
	var/fruit_list = english_list(fruits)
	description = "A [alcohol_description] wine brewed from [fruit_list]."

	var/flavor = ""
	if(!primary_tastes.len)
		primary_tastes = list("[alcohol_description] алкоголь")
	flavor += english_list(primary_tastes)
	if(secondary_tastes.len)
		flavor += ", с намеком на "
		flavor += english_list(secondary_tastes)
	taste_description = flavor

/datum/reagent/consumable/ethanol/champagne //How the hell did we not have champagne already!?
	name = "Шампанское"
	description = "Игристое вино, известное своей способностью наносить быстрые и сильные удары по вашей печени."
	color = "#ffffc1"
	boozepwr = 40
	taste_description = "благоприятные случаи и плохие решения"
	glass_icon_state = "champagne_glass"
	glass_name = "Шампанское"
	glass_desc = "На стекле четко видны медленно поднимающиеся пузырьки."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_EASY

/datum/reagent/consumable/ethanol/wizz_fizz
	name = "Виз Физ"
	description = "Волшебное зелье, шипучее и дикое! Однако вкус, как вы заметите, довольно мягкий."
	color = "#4235d0" //Just pretend that the triple-sec was blue curacao.
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "дружба! Это ведь магия"
	glass_icon_state = "wizz_fizz"
	glass_name = "Виз Физ"
	glass_desc = "Жидкость в бокале пузырится и пенится с почти магической интенсивностью."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/wizz_fizz/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	//A healing drink similar to Quadruple Sec, Ling Stings, and Screwdrivers for the Wizznerds; the check is consistent with the changeling sting
	if(M?.mind?.has_antag_datum(/datum/antagonist/wizard))
		M.heal_bodypart_damage(1 * REM * delta_time, 1 * REM * delta_time, 1 * REM * delta_time)
		M.adjustOxyLoss(-1 * REM * delta_time, 0)
		M.adjustToxLoss(-1 * REM * delta_time, 0)
	return ..()

/datum/reagent/consumable/ethanol/bug_spray
	name = "Спрей от Насекомых"
	description = "Резкий, едкий, горький напиток, для тех, кому нужно что-то для укрепления сил."
	color = "#33ff33"
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "боль десяти тысяч убитых комаров"
	glass_icon_state = "bug_spray"
	glass_name = "Спрей от Насекомых"
	glass_desc = "Ваши глаза начинают слезиться, когда до них доходит жгучий запах алкоголя."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/bug_spray/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	//Bugs should not drink Bug spray.
	if(ismoth(M) || isflyperson(M))
		M.adjustToxLoss(1 * REM * delta_time, 0)
	return ..()

/datum/reagent/consumable/ethanol/bug_spray/on_mob_metabolize(mob/living/carbon/M)
	if(ismoth(M) || isflyperson(M))
		M.emote("agony")
	return ..()

/datum/reagent/consumable/ethanol/applejack
	name = "Эплджек"
	description = "Идеальный напиток для тех случаев, когда вы хотите побузить."
	color = "#ff6633"
	boozepwr = 20
	taste_description = "честный день работы в саду"
	glass_icon_state = "applejack_glass"
	glass_name = "Эплджек"
	glass_desc = "Вы чувствуете, что могли бы пить его всю ночь."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/jack_rose
	name = "Джек Роуз"
	description = "Легкий коктейль, который идеально подходит для потягивания с кусочком пирога."
	color = "#ff6633"
	boozepwr = 15
	quality = DRINK_NICE
	taste_description = "кисло-сладкий кусочек яблока"
	glass_icon_state = "jack_rose"
	glass_name = "Джек Роуз"
	glass_desc = "Если выпить достаточно, то вам будет казаться, что ваши пальцы стали розами."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/turbo
	name = "Турбо"
	description = "Бурный коктейль, связянный с незаконными гонками на ховербайках. Не для слабонервных."
	color = "#e94c3a"
	boozepwr = 85
	quality = DRINK_VERYGOOD
	taste_description = "дух вне закона"
	glass_icon_state = "turbo"
	glass_name = "Турбо"
	glass_desc = "Бурный коктейль для ховербайкеров-преступников."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/turbo/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(DT_PROB(2, delta_time))
		to_chat(M, span_notice("[pick("Начинаю ощущать пренебрежение к верховенству закона.", "Чувствую себя накачанным!", "Голова стучит.", "Мысли вылетают..")]"))
	M.adjustStaminaLoss(-0.25 * M.drunkenness * REM * delta_time)
	return ..()

/datum/reagent/consumable/ethanol/old_timer
	name = "Старый Таймер"
	description = "Архаичный напиток, которым наслаждаются старики всех возрастов."
	color = "#996835"
	boozepwr = 35
	quality = DRINK_NICE
	taste_description = "более простые времена"
	glass_icon_state = "old_timer"
	glass_name = "Старый Таймер"
	glass_desc = "ВНИМАНИЕ! Может вызвать преждевременное старение!"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/old_timer/on_mob_life(mob/living/carbon/human/metabolizer, delta_time, times_fired)
	if(DT_PROB(10, delta_time) && istype(metabolizer))
		metabolizer.age += 1
		if(metabolizer.age > 70)
			metabolizer.facial_hair_color = "ccc"
			metabolizer.hair_color = "ccc"
			metabolizer.update_hair()
			if(metabolizer.age > 100)
				metabolizer.become_nearsighted(type)
				if(metabolizer.gender == MALE)
					metabolizer.facial_hairstyle = "Beard (Very Long)"
					metabolizer.update_hair()

				if(metabolizer.age > 969) //Best not let people get older than this or i might incur G-ds wrath
					metabolizer.visible_message(span_notice("[metabolizer] становится старше чем кто либо.. и рассыпается прахом!"))
					metabolizer.dust(just_ash = FALSE, drop_items = TRUE, force = FALSE)

	return ..()

/datum/reagent/consumable/ethanol/rubberneck
	name = "Зевака"
	description = "Качественный коктейль \"Зевака\" не должен содержать натуральных ингредиентов."
	color = "#ffe65b"
	boozepwr = 60
	quality = DRINK_GOOD
	taste_description = "искусственная фруктовость"
	glass_icon_state = "rubberneck"
	glass_name = "Зевака"
	glass_desc = "Популярный напиток среди тех, кто придерживается полностью синтетической диеты."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/rubberneck/on_mob_metabolize(mob/living/L)
	. = ..()
	ADD_TRAIT(L, TRAIT_SHOCKIMMUNE, type)

/datum/reagent/consumable/ethanol/rubberneck/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_SHOCKIMMUNE, type)
	return ..()

/datum/reagent/consumable/ethanol/duplex
	name = "Дуплекс"
	description = "Неразрывное сочетание двух фруктовых напитков."
	color = "#50e5cf"
	boozepwr = 25
	quality = DRINK_NICE
	taste_description = "зелёные яблоки и голубая малина"
	glass_icon_state = "duplex"
	glass_name = "Дуплекс"
	glass_desc = "Употребление одного ингредиента отдельно от другого считается большой оплошностью."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/trappist
	name = "Траппистское пиво"
	description = "Крепкий темный эль, предпочитаемый космическими монахами."
	color = "#390c00"
	boozepwr = 40
	quality = DRINK_VERYGOOD
	taste_description = "сушеные сливы и солод"
	glass_icon_state = "trappistglass"
	glass_name = "Траппистское пиво"
	glass_desc = "Пьяное католичество в бокале."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/trappist/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.mind?.holy_role)
		M.adjustFireLoss(-2.5 * REM * delta_time, 0)
		M.jitteriness = max(M.jitteriness - (1 * REM * delta_time), 0)
		M.stuttering = max(M.stuttering - (1 * REM * delta_time), 0)
	return ..()

/datum/reagent/consumable/ethanol/blazaam
	name = "Блазаам"
	description = "Странный напиток, о существовании которого мало кто помнит."
	boozepwr = 70
	quality = DRINK_FANTASTIC
	taste_description = "альтернативные реалии"
	glass_icon_state = "blazaamglass"
	glass_name = "Блазаам"
	glass_desc = "Кажется, что стекло переливается отражениями различных реальностей."
	var/stored_teleports = 0

/datum/reagent/consumable/ethanol/blazaam/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.drunkenness > 40)
		if(stored_teleports)
			do_teleport(M, get_turf(M), rand(1,3), channel = TELEPORT_CHANNEL_WORMHOLE)
			stored_teleports--

		if(DT_PROB(5, delta_time))
			stored_teleports += rand(2, 6)
			if(prob(70))
				M.vomit(vomit_type = VOMIT_PURPLE)
	return ..()


/datum/reagent/consumable/ethanol/planet_cracker
	name = "Планетарный потрошитель"
	description = "Этот ликующий напиток празднует победу человечества над инопланетной угрозой. Может быть оскорбительным для нечеловеческих членов экипажа."
	boozepwr = 50
	quality = DRINK_FANTASTIC
	taste_description = "торжество с оттенком горечи"
	glass_icon_state = "planet_cracker"
	glass_name = "Планетарный потрошитель"
	glass_desc = "Хотя историки считают, что изначально напиток был создан в честь окончания важного конфликта в прошлом человечества, его происхождение в значительной степени забыто, и сегодня он воспринимается скорее как общий символ человеческого превосходства."

/datum/reagent/consumable/ethanol/mauna_loa
	name = "Мауна-Лоа"
	description = "Чрезвычайно горячий. Не для слабонервных!"
	boozepwr = 40
	color = "#fe8308" // 254, 131, 8
	quality = DRINK_FANTASTIC
	taste_description = "огненный, с послевкусием сгоревшей плоти"
	glass_icon_state = "mauna_loa"
	glass_name = "Мауна-Лоа"
	glass_desc = "Лаваленд в кружке... вулкан... вещь."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/mauna_loa/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	// Heats the user up while the reagent is in the body. Occasionally makes you burst into flames.
	M.adjust_bodytemperature(25 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time)
	if (DT_PROB(2.5, delta_time))
		M.adjust_fire_stacks(1)
		M.ignite_mob()
	..()

/datum/reagent/consumable/ethanol/painkiller
	name = "Обезбол"
	description = "Притупляет вашу боль. Вашу эмоциональную боль, то есть."
	boozepwr = 20
	color = "#EAD677"
	quality = DRINK_NICE
	taste_description = "сладкая терпкость"
	glass_icon_state = "painkiller"
	glass_name = "Обезбол"
	glass_desc = "Сочетание сока тропических фруктов и рома. Несомненно, это поможет вам чувствовать себя лучше."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/pina_colada
	name = "Пина Колада"
	description = "Напиток из свежего ананаса с кокосовым ромом. Очень вкусно."
	special_sound = 'white/valtos/sounds/drink/pina_colada.ogg'
	boozepwr = 40
	color = "#FFF1B2"
	quality = DRINK_FANTASTIC
	taste_description = "ананас, кокос и океан"
	glass_icon_state = "pina_colada"
	glass_name = "Пина Колада"
	glass_desc = "Если вы любите пина-коладу и попадать под дождь... что ж, вам понравится этот напиток.."


/datum/reagent/consumable/ethanol/pruno // pruno mix is in drink_reagents
	name = "Пруно"
	color = "#E78108"
	description = "Перебродившее тюремное вино, сделанное из фруктов, сахара и отчаяния. Служба безопасности любит его конфисковывать, и это единственное доброе дело, которое она когда-либо делала."
	boozepwr = 85
	taste_description = "мои вкусовые рецепторы индивидуально отшлифованы"
	glass_icon_state = "glass_orange"
	glass_name = "Пруно"
	glass_desc = "Перебродившее тюремное вино, сделанное из фруктов, сахара и отчаяния. Служба безопасности любит его конфисковывать, и это единственное доброе дело, которое она когда-либо делала."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/pruno/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjust_disgust(5 * REM * delta_time)
	..()

/datum/reagent/consumable/ethanol/ginger_amaretto
	name = "Джинджер Амаретто"
	description = "Восхитительно простой коктейль, вкус которого вас порадует."
	boozepwr = 30
	color = "#EFB42A"
	quality = DRINK_GOOD
	taste_description = "сладость, за которой следует мягкая кислинка и теплота"
	glass_icon_state = "gingeramaretto"
	glass_name = "Джинджер Амаретто"
	glass_desc = "Веточка розмарина придает напитку приятный аромат!"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/godfather
	name = "Крестный Отец"
	//translate description to russian
	description = "Коктейл, который вам не стоит пить, если вы не хотите, чтобы вас нашли."
	special_sound = 'white/valtos/sounds/drink/godfather.ogg'
	boozepwr = 50
	color = "#E68F00"
	quality = DRINK_GOOD
	taste_description = "a delightful softened punch"
	glass_icon_state = "godfather"
	glass_name = "Крестный Отец"
	glass_desc = "Классика старой Италии, которой наслаждались гангстеры. Молитесь, чтобы апельсиновая корка не попала вам в рот."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/ethanol/sins_delight
	name = "Греховное наслаждение"
	description = "Напиток пахнет семью грехами."
	color = "#330000"
	boozepwr = 66
	quality = DRINK_FANTASTIC
	taste_description = "непреодолимая сладость с оттенком кислинки, за которой следует железо и ощущение теплого летнего бриза"
	glass_icon_state = "sins_delight"
	glass_name = "бокал греховного наслаждения"
	glass_desc = "Вы чувствуете запах семи грехов, скатывающийся с верха бокала."

/datum/reagent/consumable/ethanol/godmother
	name = "Крестная Мать"
	description = "Возвращение к классике, который больше нравится зрелым женщинам."
	boozepwr = 50
	color = "#E68F00"
	quality = DRINK_GOOD
	taste_description = "sweetness and a zesty twist"
	glass_icon_state = "godmother"
	glass_name = "Крестная Мать"
	glass_desc = "Прекрасный коктейль, настоящее сицилийское наслаждение."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

//Moth Drinks
/datum/reagent/consumable/ethanol/curacao
	name = "Кюрасао"
	description = "Изготовлен с добавлением апельсинов сорта лараха для придания аромата."
	special_sound = 'white/nocringe/sounds/drink/curacao.ogg'
	boozepwr = 30
	color = "#1a5fa1"
	quality = DRINK_NICE
	taste_description = "blue orange"
	glass_icon_state = "curacao"
	glass_name = "Кюрасао"
	glass_desc = "Айм блю дабу ди дабу дай"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/navy_rum //IN THE NAVY
	name = "Ром ВМФ"
	description = "Ром - лучший напиток моряков."
	boozepwr = 90 //the finest sailors are often drunk
	color = "#d8e8f0"
	quality = DRINK_NICE
	taste_description = "a life on the waves"
	glass_icon_state = "ginvodkaglass"
	glass_name = "ром ВМФ"
	glass_desc = "Разрубите грот-балку, и Боже, храни короля."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/bitters //why do they call them bitters, anyway? they're more spicy than anything else
	name = "Андромеда Биттерс"
	description = "Лучший друг бармена, часто используется для придания деликатной остроты любому напитку. Производится в Новом Тринидаде, отныне и навсегда."
	boozepwr = 70
	color = "#1c0000"
	quality = DRINK_NICE
	taste_description = "пряный алкоголь"
	glass_icon_state = "bitters"
	glass_name = "Андромеда Биттерс"
	glass_desc = "Обычно вы хотите смешать это с чем нибудь - так вы и поступаете."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/admiralty //navy rum, vermouth, fernet
	name = "Адмиралтейство"
	description = "Изысканный, горький напиток, приготовленный из флотского рома, вермута и фернета."
	boozepwr = 100
	color = "#1F0001"
	quality = DRINK_VERYGOOD
	taste_description = "надменное высокомерие"
	glass_icon_state = "admiralty"
	glass_name = "Адмиралтейство"
	glass_desc = "Слава адмиралу, ибо он принес честные вести и ром."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/long_haul //Rum, Curacao, Sugar, dash of bitters, lengthened with soda water
	name = "Длинный путь"
	description = "Любимец пилотов грузовых кораблей и недобросовестных контрабандистов."
	boozepwr = 35
	color = "#003153"
	quality = DRINK_VERYGOOD
	taste_description = "companionship"
	glass_icon_state = "long_haul"
	glass_name = "Длинный путь"
	glass_desc = "Идеальный компаньон для одинокого дальнего перелета."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/long_john_silver //navy rum, bitters, lemonade
	name = "Лонг Джон Сильвер"
	description = "Лонг дринк из флотского рома, горького и лимонада. Особенно популярен на борту мольского флота, так как не требует больших затрат на рационы и обладает богатым вкусом."
	boozepwr = 50
	color = "#c4b35c"
	quality = DRINK_VERYGOOD
	taste_description = "ром и специи"
	glass_icon_state = "long_john_silver"
	glass_name = "Лонг Джон Сильвер"
	glass_desc = "Назван в честь знаменитого пирата, который мог быть вымышленным, а мог и не быть. Но зачем мешать правду с правдой?" //Chopper Reid says "How the fuck are ya?"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/tropical_storm //dark rum, pineapple juice, triple citrus, curacao
	name = "Тропический шторм"
	description = "Вкус Карибского моря в одном бокале."
	boozepwr = 40
	color = "#00bfa3"
	quality = DRINK_VERYGOOD
	taste_description = "тропики"
	glass_icon_state = "tropical_storm"
	glass_name = "Тропический шторм"
	glass_desc = "Менее разрушительный, чем настоящий."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/dark_and_stormy //rum and ginger beer- simple and classic
	name = "Дарк энд Сторми"
	description = "Классический напиток, прибывающий под гром аплодисментов." //thank you, thank you, I'll be here forever
	boozepwr = 50
	color = "#8c5046"
	quality = DRINK_GOOD
	taste_description = "имбирь и ром"
	glass_icon_state = "dark_and_stormy"
	glass_name = "Дарк энд Сторми"
	glass_desc = "Гром и молния, очень страшно."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/salt_and_swell //navy rum, tochtause syrup, egg whites, dash of saline-glucose solution
	name = "Солт энд Свелл"
	description = "Бодрящая кислинка с интересным соленым вкусом."
	boozepwr = 60
	color = "#b4abd0"
	quality = DRINK_FANTASTIC
	taste_description = "соль и специи"
	glass_icon_state = "salt_and_swell"
	glass_name = "Солт энд Свелл"
	glass_desc = "Ах, я люблю бывать на берегу моря."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/tiltaellen //yoghurt, salt, vinegar
	name = "Тильталлен"
	description = "Слегка ферментированный йогуртовый напиток с добавлением соли и небольшого количества уксуса. Имеет выраженный кисловато-сырный вкус."
	boozepwr = 10
	color = "#F4EFE2"
	quality = DRINK_NICE
	taste_description = "Кислый сырный йогурт"
	glass_icon_state = "tiltaellen"
	glass_name = "Тильталлен"
	glass_desc = "Фу... оно свернулось."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/tich_toch
	name = "Тич Точ"
	description = "Смесь тильталлена, сиропа \"Тохтаузе\" и водки. Не всем по вкусу."
	boozepwr = 75
	color = "#b4abd0"
	quality = DRINK_VERYGOOD
	taste_description = "острый кислый сырный йогурт"
	glass_icon_state = "tich_toch"
	glass_name = "Тич Точ"
	glass_desc = "Боже."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

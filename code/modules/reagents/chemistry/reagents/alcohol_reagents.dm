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
			var/obj/item/organ/liver/L = C.getorganslot(ORGAN_SLOT_LIVER)
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
	glass_name = "стакан пива"
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
	glass_name = "стакан светлого пива"
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
	glass_name = "стакан солодового ликера"
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
	glass_name = "стакан зеленого пива"
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
	name = "Калуа"
	enname = "Kahlua"
	description = "Широко известный мексиканский ликер со вкусом кофе. Выпускается с 1936-го года!"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 45
	glass_icon_state = "kahluaglass"
	glass_name = "Стакан калуа"
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
	description = "A superb and well-aged single-malt whiskey. Damn."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 75
	taste_description = "меласса"
	glass_icon_state = "whiskeyglass"
	glass_name = "стакан whiskey"
	glass_desc = "The silky, smokey whiskey goodness inside the glass makes the drink look very classy."
	shot_glass_icon_state = "shotglassbrown"
	ph = 4.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_STOCK

/datum/reagent/consumable/ethanol/whiskey/kong
	name = "Конг"
	description = "Makes You Go Ape!&#174;"
	color = "#332100" // rgb: 51, 33, 0
	taste_description = "хватка гигантской обезьяны"
	glass_name = "стакан Kong"
	glass_desc = "Makes You Go Ape!&#174;"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
/datum/reagent/consumable/ethanol/whiskey/candycorn
	name = "конфетно-кукурузный ликер"
	description = "Like they drank in 2D speakeasies."
	color = "#ccb800" // rgb: 204, 184, 0
	taste_description = "блинный сироп"
	glass_name = "стакан candy corn liquor"
	glass_desc = "Good for your Imagination."
	var/hal_amt = 4
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/whiskey/candycorn/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(DT_PROB(5, delta_time))
		M.hallucination += hal_amt //conscious dreamers can be treasurers to their own currency
	..()

/datum/reagent/consumable/ethanol/thirteenloko
	name = "Локо Тринадцать"
	description = "A potent mixture of caffeine and alcohol."
	color = "#102000" // rgb: 16, 32, 0
	nutriment_factor = 1 * REAGENTS_METABOLISM
	boozepwr = 80
	quality = DRINK_GOOD
	overdose_threshold = 60
	taste_description = "дрожь и смерть"
	glass_icon_state = "thirteen_loko_glass"
	glass_name = "стакан Thirteen Loko"
	glass_desc = "This is a glass of Thirteen Loko, it appears to be of the highest quality. The drink, not the glass."
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
		var/obj/item/organ/eyes/eyes = M.getorganslot(ORGAN_SLOT_EYES)
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
	description = "Number one drink AND fueling choice for Russians worldwide."
	color = "#0064C8" // rgb: 0, 100, 200
	boozepwr = 65
	taste_description = "зерновой спирт"
	glass_icon_state = "ginvodkaglass"
	glass_name = "стакан vodka"
	glass_desc = "The glass contain wodka. Xynta."
	shot_glass_icon_state = "shotglassclear"
	ph = 8.1
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_CLEANS //Very high proof

/datum/reagent/consumable/ethanol/vodka/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.radiation = max(M.radiation - (2 * REM * delta_time),0)
	return ..()

/datum/reagent/consumable/ethanol/bilk
	name = "Билк"
	description = "This appears to be beer mixed with milk. Disgusting."
	color = "#895C4C" // rgb: 137, 92, 76
	nutriment_factor = 2 * REAGENTS_METABOLISM
	boozepwr = 15
	taste_description = "отчаяние и лактат"
	glass_icon_state = "glass_brown"
	glass_name = "стакан bilk"
	glass_desc = "A brew of milk and beer. For those alcoholics who fear osteoporosis."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/bilk/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.getBruteLoss() && DT_PROB(5, delta_time))
		M.heal_bodypart_damage(brute = 1)
		. = TRUE
	return ..() || .

/datum/reagent/consumable/ethanol/threemileisland
	name = "Холодный тай Three Mile Island"
	description = "Made for a woman, strong enough for a man."
	color = "#666340" // rgb: 102, 99, 64
	boozepwr = 10
	quality = DRINK_FANTASTIC
	taste_description = "сухость"
	glass_icon_state = "threemileislandglass"
	glass_name = "Three Mile Island Ice Tea"
	glass_desc = "A glass of this is sure to prevent a meltdown."
	ph = 3.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/threemileisland/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.set_drugginess(50 * REM * delta_time)
	return ..()

/datum/reagent/consumable/ethanol/gin
	name = "Джин"
	description = "It's gin. In space. I say, good sir."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 45
	taste_description = "алкогольная рождественская елка"
	glass_icon_state = "ginvodkaglass"
	glass_name = "стакан gin"
	glass_desc = "A crystal clear glass of Griffeater gin."
	ph = 6.9
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/rum
	name = "Ром"
	description = "Yohoho and all that."
	special_sound = 'white/valtos/sounds/drink/rum.ogg'
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 60
	taste_description = "колючие ириски"
	glass_icon_state = "rumglass"
	glass_name = "стакан rum"
	glass_desc = "Now you want to Pray for a pirate suit, don't you?"
	shot_glass_icon_state = "shotglassbrown"
	ph = 6.5

/datum/reagent/consumable/ethanol/tequila
	name = "Текила"
	description = "A strong and mildly flavoured, Mexican produced spirit. Feeling thirsty, hombre?"
	special_sound = 'white/valtos/sounds/drink/tequila.ogg'
	color = "#FFFF91" // rgb: 255, 255, 145
	boozepwr = 70
	taste_description = "растворитель"
	glass_icon_state = "tequilaglass"
	glass_name = "стакан tequila"
	glass_desc = "Now all that's missing is the weird colored shades!"
	shot_glass_icon_state = "shotglassgold"
	ph = 4
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_STOCK

/datum/reagent/consumable/ethanol/vermouth
	name = "Вермут"
	description = "You suddenly feel a craving for a martini..."
	color = "#91FF91" // rgb: 145, 255, 145
	boozepwr = 45
	taste_description = "сухой алкоголь"
	glass_icon_state = "vermouthglass"
	glass_name = "стакан vermouth"
	glass_desc = "You wonder why you're even drinking this straight."
	shot_glass_icon_state = "shotglassclear"
	ph = 3.25
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/wine
	name = "Вино"
	description = "A premium alcoholic beverage made from distilled grape juice."
	color = "#7E4043" // rgb: 126, 64, 67
	boozepwr = 35
	taste_description = "горькая сладость"
	glass_icon_state = "wineglass"
	glass_name = "стакан wine"
	glass_desc = "A very classy looking drink."
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
	name = "Ящерное Вино"
	description = "An alcoholic beverage from Space China, made by infusing lizard tails in ethanol."
	color = "#7E4043" // rgb: 126, 64, 67
	boozepwr = 45
	quality = DRINK_FANTASTIC
	taste_description = "масштабная сладость"
	ph = 3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/grappa
	name = "Граппа"
	description = "A fine Italian brandy, for when regular wine just isn't alcoholic enough for you."
	color = "#F8EBF1"
	boozepwr = 60
	taste_description = "классная горькая сладость"
	glass_icon_state = "grappa"
	glass_name = "стакан grappa"
	glass_desc = "A fine drink originally made to prevent waste by using the leftovers from winemaking."
	ph = 3.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/amaretto
	name = "Амаретто"
	description = "A gentle drink that carries a sweet aroma."
	color = "#E17600"
	boozepwr = 25
	taste_description = "fruity and nutty sweetness"
	glass_icon_state = "amarettoglass"
	glass_name = "стакан amaretto"
	glass_desc = "A sweet and syrupy looking drink."
	shot_glass_icon_state = "shotglassgold"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/cognac
	name = "Коньяк"
	description = "A sweet and strongly alcoholic drink, made after numerous distillations and years of maturing. Classy as fornication."
	color = "#AB3C05" // rgb: 171, 60, 5
	boozepwr = 75
	taste_description = "ирландская злость"
	glass_icon_state = "cognacglass"
	glass_name = "стакан cognac"
	glass_desc = "Damn, you feel like some kind of French aristocrat just by holding this."
	shot_glass_icon_state = "shotglassbrown"
	ph = 3.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/absinthe
	name = "Абсент"
	description = "A powerful alcoholic drink. Rumored to cause hallucinations but does not."
	color = rgb(10, 206, 0)
	boozepwr = 80 //Very strong even by default
	taste_description = "смерть и солодка"
	glass_icon_state = "absinthe"
	glass_name = "стакан absinthe"
	glass_desc = "It's as strong as it smells."
	shot_glass_icon_state = "shotglassgreen"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/absinthe/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(DT_PROB(5, delta_time) && !HAS_TRAIT(M, TRAIT_ALCOHOL_TOLERANCE))
		M.hallucination += 4 //Reference to the urban myth
	..()

/datum/reagent/consumable/ethanol/hooch
	name = "Хуч"
	description = "Either someone's failure at cocktail making or attempt in alcohol production. In any case, do you really want to drink that?"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 100
	taste_description = "чистая отставка"
	glass_icon_state = "glass_brown2"
	glass_name = "Hooch"
	glass_desc = "You've really hit rock bottom now... your liver packed its bags and left last night."
	addiction_types = list(/datum/addiction/alcohol = 5, /datum/addiction/maintenance_drugs = 2)
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/hooch/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	var/obj/item/organ/liver/liver = M.getorganslot(ORGAN_SLOT_LIVER)
	if(liver && HAS_TRAIT(liver, TRAIT_GREYTIDE_METABOLISM) || HAS_TRAIT(liver, TRAIT_BOMJ_METABOLISM))
		M.heal_bodypart_damage(1 * REM * delta_time, 1 * REM * delta_time)
		. = TRUE
	return ..() || .

/datum/reagent/consumable/ethanol/ale
	name = "Эль"
	description = "A dark alcoholic beverage made with malted barley and yeast."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 65
	taste_description = "сытный ячменный эль"
	glass_icon_state = "aleglass"
	glass_name = "стакан ale"
	glass_desc = "A freezing pint of delicious Ale."
	ph = 4.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/goldschlager
	name = "Гольдшпигер"
	description = "100 proof cinnamon schnapps, made for alcoholic teen girls on spring break."
	color = "#FFFF91" // rgb: 255, 255, 145
	boozepwr = 25
	quality = DRINK_VERYGOOD
	taste_description = "горящая корица"
	glass_icon_state = "goldschlagerglass"
	glass_name = "стакан goldschlager"
	glass_desc = "100% proof that teen girls will drink anything with gold in it."
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
	description = "Tequila with silver in it, a favorite of alcoholic women in the club scene."
	color = "#585840" // rgb: 88, 88, 64
	boozepwr = 60
	quality = DRINK_VERYGOOD
	taste_description = "дорогой металл"
	glass_icon_state = "patronglass"
	glass_name = "стакан patron"
	glass_desc = "Drinking patron in the bar, with all the subpar ladies."
	shot_glass_icon_state = "shotglassclear"
	ph = 4.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_HIGH

/datum/reagent/consumable/ethanol/gintonic
	name = "Джин Тоник"
	description = "An all time classic, mild cocktail."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 25
	quality = DRINK_NICE
	taste_description = "мягкий и терпкий"
	glass_icon_state = "gintonicglass"
	glass_name = "Gin and Tonic"
	glass_desc = "A mild but still great cocktail. Drink up, like a true Englishman."
	ph = 3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/rum_coke
	name = "Ром с Колой"
	description = "Rum, mixed with cola."
	taste_description = "кола"
	boozepwr = 40
	quality = DRINK_NICE
	color = "#3E1B00"
	glass_icon_state = "whiskeycolaglass"
	glass_name = "Rum and Coke"
	glass_desc = "The classic go-to of space-fratboys."
	ph = 4
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/cuba_libre
	name = "Куба Либре"
	description = "Viva la Revolucion! Viva Cuba Libre!"
	special_sound = 'white/valtos/sounds/drink/cuba.ogg'
	color = "#3E1B00" // rgb: 62, 27, 0
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "освежающий брак цитрусовых и рома"
	glass_icon_state = "cubalibreglass"
	glass_name = "Cuba Libre"
	glass_desc = "A classic mix of rum, cola, and lime. A favorite of revolutionaries everywhere!"
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
	name = "Виски Кола"
	description = "Whiskey, mixed with cola. Surprisingly refreshing."
	color = "#3E1B00" // rgb: 62, 27, 0
	boozepwr = 70
	quality = DRINK_NICE
	taste_description = "кола"
	glass_icon_state = "whiskeycolaglass"
	glass_name = "whiskey cola"
	glass_desc = "An innocent-looking mixture of cola and whiskey. Delicious."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED


/datum/reagent/consumable/ethanol/martini
	name = "Классический Мартини"
	description = "Vermouth with Gin. Not quite how 007 enjoyed it, but still delicious."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 60
	quality = DRINK_NICE
	taste_description = "сухой класс"
	glass_icon_state = "martiniglass"
	glass_name = "Classic Martini"
	glass_desc = "Damn, the bartender even stirred it, not shook it."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/vodkamartini
	name = "Мартини с Водкой"
	description = "Vodka with Gin. Not quite how 007 enjoyed it, but still delicious."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 65
	quality = DRINK_NICE
	taste_description = "встряхивают, не перемешивают"
	glass_icon_state = "martiniglass"
	glass_name = "Vodka martini"
	glass_desc ="A bastardisation of the classic martini. Still great."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/white_russian
	name = "Белый Русский"
	description = "That's just, like, your opinion, man..."
	color = "#A68340" // rgb: 166, 131, 64
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "горький крем"
	glass_icon_state = "whiterussianglass"
	glass_name = "White Russian"
	glass_desc = "A very nice looking drink. But that's just, like, your opinion, man."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/screwdrivercocktail
	name = "Отвертка"
	description = "Vodka, mixed with plain ol' orange juice. The result is surprisingly delicious."
	color = "#A68310" // rgb: 166, 131, 16
	boozepwr = 55
	quality = DRINK_NICE
	taste_description = "апельсины"
	glass_icon_state = "screwdriverglass"
	glass_name = "Screwdriver"
	glass_desc = "A simple, yet superb mixture of Vodka and orange juice. Just the thing for the tired engineer."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/screwdrivercocktail/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	var/obj/item/organ/liver/liver = M.getorganslot(ORGAN_SLOT_LIVER)
	if(HAS_TRAIT(liver, TRAIT_ENGINEER_METABOLISM))
		// Engineers lose radiation poisoning at a massive rate.
		M.radiation = max(M.radiation - (25 * REM * delta_time), 0)
	return ..()

/datum/reagent/consumable/ethanol/booger
	name = "Бугер"
	description = "Ewww..."
	color = "#8CFF8C" // rgb: 140, 255, 140
	boozepwr = 45
	taste_description = "сладкий и сливочный"
	glass_icon_state = "booger"
	glass_name = "Booger"
	glass_desc = "Ewww..."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/bloody_mary
	name = "Кровавая Мэри"
	description = "A strange yet pleasurable mixture made of vodka, tomato and lime juice. Or at least you THINK the red stuff is tomato juice."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 55
	quality = DRINK_GOOD
	taste_description = "помидоры с ноткой лайма"
	glass_icon_state = "bloodymaryglass"
	glass_name = "Bloody Mary"
	glass_desc = "Tomato juice, mixed with Vodka and a li'l bit of lime. Tastes like liquid murder."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/bloody_mary/on_mob_life(mob/living/carbon/C, delta_time, times_fired)
	if(C.blood_volume < BLOOD_VOLUME_NORMAL)
		C.blood_volume = min(C.blood_volume + (3 * REM * delta_time), BLOOD_VOLUME_NORMAL) //Bloody Mary quickly restores blood loss.
	..()

/datum/reagent/consumable/ethanol/brave_bull
	name = "Храбрый Бык"
	description = "It's just as effective as Dutch-Courage!"
	special_sound = 'white/valtos/sounds/drink/bull.ogg'
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 60
	quality = DRINK_NICE
	taste_description = "алкогольная храбрость"
	glass_icon_state = "bravebullglass"
	glass_name = "Brave Bull"
	glass_desc = "Tequila and Coffee liqueur, brought together in a mouthwatering mixture. Drink up."
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
	description = "Tequila, Grenadine, and Orange Juice."
	special_sound = 'white/valtos/sounds/drink/tequila_sunrise.ogg'
	color = "#FFE48C" // rgb: 255, 228, 140
	boozepwr = 45
	quality = DRINK_GOOD
	taste_description = "апельсины с оттенком граната"
	glass_icon_state = "tequilasunriseglass"
	glass_name = "tequila Sunrise"
	glass_desc = "Oh great, now you feel nostalgic about sunrises back on Terra..."
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
	name = "Особые Токсины"
	description = "This thing is ON FIRE! CALL THE DAMN SHUTTLE!"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 25
	quality = DRINK_VERYGOOD
	taste_description = "пряные токсины"
	glass_icon_state = "toxinsspecialglass"
	glass_name = "Toxins Special"
	glass_desc = "Whoah, this thing is on FIRE!"
	shot_glass_icon_state = "toxinsspecialglass"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/toxins_special/on_mob_life(mob/living/M, delta_time, times_fired)
	M.adjust_bodytemperature(15 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, 0, M.get_body_temp_normal() + 20) //310.15 is the normal bodytemp.
	return ..()

/datum/reagent/consumable/ethanol/beepsky_smash
	name = "Громящий Бипски"
	description = "Drink this and prepare for the LAW."
	special_sound = 'white/valtos/sounds/drink/criminal.ogg'
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 60 //THE FIST OF THE LAW IS STRONG AND HARD
	quality = DRINK_GOOD
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	taste_description = "СПРАВЕДЛИВОСТЬ"
	glass_icon_state = "beepskysmashglass"
	glass_name = "Beepsky Smash"
	glass_desc = "Heavy, hot and strong. Just like the Iron fist of the LAW."
	overdose_threshold = 40
	var/datum/brain_trauma/special/beepsky/B
	ph = 2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/beepsky_smash/on_mob_metabolize(mob/living/carbon/M)
	if(HAS_TRAIT(M, TRAIT_ALCOHOL_TOLERANCE))
		metabolization_rate = 0.8
	// if you don't have a liver, or your liver isn't an officer's liver
	var/obj/item/organ/liver/liver = M.getorganslot(ORGAN_SLOT_LIVER)
	if(!liver || !HAS_TRAIT(liver, TRAIT_LAW_ENFORCEMENT_METABOLISM))
		B = new()
		M.gain_trauma(B, TRAUMA_RESILIENCE_ABSOLUTE)
	..()

/datum/reagent/consumable/ethanol/beepsky_smash/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.Jitter(2)
	var/obj/item/organ/liver/liver = M.getorganslot(ORGAN_SLOT_LIVER)
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
	var/obj/item/organ/liver/liver = M.getorganslot(ORGAN_SLOT_LIVER)
	// if you don't have a liver, or your liver isn't an officer's liver
	if(!liver || !HAS_TRAIT(liver, TRAIT_LAW_ENFORCEMENT_METABOLISM))
		M.gain_trauma(/datum/brain_trauma/mild/phobia/security, TRAUMA_RESILIENCE_BASIC)

/datum/reagent/consumable/ethanol/irish_cream
	name = "Ирландский Крем"
	description = "Whiskey-imbued cream, what else would you expect from the Irish?"
	special_sound = 'white/valtos/sounds/drink/irish_coffee.ogg'
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 50
	quality = DRINK_NICE
	taste_description = "сливочный спирт"
	glass_icon_state = "irishcreamglass"
	glass_name = "Irish Cream"
	glass_desc = "It's cream, mixed with whiskey. What else would you expect from the Irish?"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/manly_dorf
	name = "Мужественный Дорф"
	description = "Beer and Ale, brought together in a delicious mix. Intended for true men only."
	special_sound = 'white/valtos/sounds/drink/df.ogg'
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 100 //For the manly only
	quality = DRINK_NICE
	taste_description = "волосы на груди и подбородке"
	glass_icon_state = "manlydorfglass"
	glass_name = "The Manly Dorf"
	glass_desc = "A manly concoction made from Ale and Beer. Intended for true men only."
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
	name = "Холодный Чай «Long Island»"
	description = "The liquor cabinet, brought together in a delicious mix. Intended for middle-aged alcoholic women only."
	special_sound = 'white/valtos/sounds/drink/long_island.ogg'
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 35
	quality = DRINK_VERYGOOD
	taste_description = "смесь колы и алкоголя"
	glass_icon_state = "longislandicedteaglass"
	glass_name = "Long Island Iced Tea"
	glass_desc = "The liquor cabinet, brought together in a delicious mix. Intended for middle-aged alcoholic women only."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED


/datum/reagent/consumable/ethanol/moonshine
	name = "Самогон"
	description = "You've really hit rock bottom now... your liver packed its bags and left last night."
	special_sound = 'white/valtos/sounds/drink/moonshine.ogg'
	color = "#AAAAAA77" // rgb: 170, 170, 170, 77 (alpha) (like water)
	boozepwr = 95
	taste_description = "горечь"
	glass_icon_state = "glass_clear"
	glass_name = "Moonshine"
	glass_desc = "You've really hit rock bottom now... your liver packed its bags and left last night."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/b52
	name = "Б-52"
	description = "Coffee, Irish Cream, and cognac. You will get bombed."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 85
	quality = DRINK_GOOD
	taste_description = "злой и ирландский"
	glass_icon_state = "b52glass"
	glass_name = "B-52"
	glass_desc = "Kahlua, Irish Cream, and cognac. You will get bombed."
	shot_glass_icon_state = "b52glass"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_EASY

/datum/reagent/consumable/ethanol/b52/on_mob_metabolize(mob/living/M)
	playsound(M, 'white/valtos/sounds/nuclearexplosion.ogg', 100, FALSE)

/datum/reagent/consumable/ethanol/irishcoffee
	name = "Ирландский Кофе"
	description = "Coffee, and alcohol. More fun than a Mimosa to drink in the morning."
	special_sound = 'white/valtos/sounds/drink/irish_coffee.ogg'
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 35
	quality = DRINK_NICE
	taste_description = "сдаться за день"
	glass_icon_state = "irishcoffeeglass"
	glass_name = "Irish Coffee"
	glass_desc = "Coffee and alcohol. More fun than a Mimosa to drink in the morning."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/margarita
	name = "Маргарита"
	description = "On the rocks with salt on the rim. Arriba~!"
	color = "#8CFF8C" // rgb: 140, 255, 140
	boozepwr = 35
	quality = DRINK_NICE
	taste_description = "сухой и соленый"
	glass_icon_state = "margaritaglass"
	glass_name = "Margarita"
	glass_desc = "On the rocks with salt on the rim. Arriba~!"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/ethanol/black_russian
	name = "Черный Русский"
	description = "For the lactose-intolerant. Still as classy as a White Russian."
	color = "#360000" // rgb: 54, 0, 0
	boozepwr = 70
	quality = DRINK_NICE
	taste_description = "горечь"
	glass_icon_state = "blackrussianglass"
	glass_name = "Black Russian"
	glass_desc = "For the lactose-intolerant. Still as classy as a White Russian."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED


/datum/reagent/consumable/ethanol/manhattan
	name = "Манхэттен"
	description = "The Detective's undercover drink of choice. He never could stomach gin..."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 30
	quality = DRINK_NICE
	taste_description = "легкая сухость"
	glass_icon_state = "manhattanglass"
	glass_name = "Manhattan"
	glass_desc = "The Detective's undercover drink of choice. He never could stomach gin..."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_EASY


/datum/reagent/consumable/ethanol/manhattan_proj
	name = "Проект Манхэттен"
	description = "A scientist's drink of choice, for pondering ways to blow up the station."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 45
	quality = DRINK_VERYGOOD
	taste_description = "смерть, разрушитель миров"
	glass_icon_state = "proj_manhattanglass"
	glass_name = "Manhattan Project"
	glass_desc = "A scientist's drink of choice, for thinking how to blow up the station."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED


/datum/reagent/consumable/ethanol/manhattan_proj/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.set_drugginess(30 * REM * delta_time)
	return ..()

/datum/reagent/consumable/ethanol/whiskeysoda
	name = "Виски с Содовой"
	description = "For the more refined griffon."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 70
	quality = DRINK_NICE
	taste_description = "сода"
	glass_icon_state = "whiskeysodaglass2"
	glass_name = "whiskey soda"
	glass_desc = "Ultimate refreshment."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/antifreeze
	name = "Антифриз"
	description = "The ultimate refreshment. Not what it sounds like."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 35
	quality = DRINK_NICE
	taste_description = "моча Джека Фроста"
	glass_icon_state = "antifreeze"
	glass_name = "Anti-freeze"
	glass_desc = "The ultimate refreshment."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/antifreeze/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjust_bodytemperature(20 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, 0, M.get_body_temp_normal() + 20) //310.15 is the normal bodytemp.
	return ..()

/datum/reagent/consumable/ethanol/barefoot
	name = "Босоножка"
	description = "Barefoot and pregnant."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 45
	quality = DRINK_VERYGOOD
	taste_description = "сливочные ягоды"
	glass_icon_state = "b&p"
	glass_name = "Barefoot"
	glass_desc = "Barefoot and pregnant."
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
	description = "A cold refreshment."
	color = "#FFFFFF" // rgb: 255, 255, 255
	boozepwr = 35
	quality = DRINK_NICE
	taste_description = "освежающий холод"
	glass_icon_state = "snowwhite"
	glass_name = "Snow White"
	glass_desc = "A cold refreshment."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/demonsblood //Prevents the imbiber from being dragged into a pool of blood by a slaughter demon.
	name = "Кровь Демона"
	description = "AHHHH!!!!"
	color = "#820000" // rgb: 130, 0, 0
	boozepwr = 75
	quality = DRINK_VERYGOOD
	taste_description = "сладкое железо"
	glass_icon_state = "demonsblood"
	glass_name = "Demons Blood"
	glass_desc = "Just looking at this thing makes the hair at the back of your neck stand up."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/devilskiss //If eaten by a slaughter demon, the demon will regret it.
	name = "Поцелуй Дьявола"
	description = "Creepy time!"
	color = "#A68310" // rgb: 166, 131, 16
	boozepwr = 70
	quality = DRINK_VERYGOOD
	taste_description = "горькое железо"
	glass_icon_state = "devilskiss"
	glass_name = "Devils Kiss"
	glass_desc = "Creepy time!"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/vodkatonic
	name = "Водка с Тоником"
	description = "For when a gin and tonic isn't Russian enough."
	color = "#0064C8" // rgb: 0, 100, 200
	boozepwr = 70
	quality = DRINK_NICE
	taste_description = "терпкая горечь"
	glass_icon_state = "vodkatonicglass"
	glass_name = "vodka and tonic"
	glass_desc = "For when a gin and tonic isn't Russian enough."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED


/datum/reagent/consumable/ethanol/ginfizz
	name = "Джин Физ"
	description = "Refreshingly lemony, deliciously dry."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 45
	quality = DRINK_GOOD
	taste_description = "сухой, терпкий лимон"
	glass_icon_state = "ginfizzglass"
	glass_name = "gin fizz"
	glass_desc = "Refreshingly lemony, deliciously dry."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED


/datum/reagent/consumable/ethanol/bahama_mama
	name = "Багана Мама"
	description = "A tropical cocktail with a complex blend of flavors."
	special_sound = 'white/valtos/sounds/drink/bahama_mama.ogg'
	color = "#FF7F3B" // rgb: 255, 127, 59
	boozepwr = 35
	quality = DRINK_GOOD
	taste_description = "ананас, кокос и кофе"
	glass_icon_state = "bahama_mama"
	glass_name = "Bahama Mama"
	glass_desc = "A tropical cocktail with a complex blend of flavors."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/singulo
	name = "Singulo"
	description = "A blue-space beverage!"
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 35
	quality = DRINK_VERYGOOD
	taste_description = "концентрированное вещество"
	glass_icon_state = "singulo"
	glass_name = "Singulo"
	glass_desc = "A blue-space beverage."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/sbiten
	name = "Сбитень"
	description = "A spicy Vodka! Might be a little hot for the little guys!"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 70
	quality = DRINK_GOOD
	taste_description = "горячий и пряный"
	glass_icon_state = "sbitenglass"
	glass_name = "Sbiten"
	glass_desc = "A spicy mix of Vodka and Spice. Very hot."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/sbiten/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjust_bodytemperature(50 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, 0, BODYTEMP_HEAT_DAMAGE_LIMIT) //310.15 is the normal bodytemp.
	return ..()

/datum/reagent/consumable/ethanol/red_mead
	name = "Красный Мёд"
	description = "The true Viking drink! Even though it has a strange red color."
	color = "#C73C00" // rgb: 199, 60, 0
	boozepwr = 31 //Red drinks are stronger
	quality = DRINK_GOOD
	taste_description = "сладкий и соленый алкоголь"
	glass_icon_state = "red_meadglass"
	glass_name = "Red Mead"
	glass_desc = "A true Viking's beverage, made with the blood of their enemies."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/mead
	name = "Медовуха"
	description = "A Viking drink, though a cheap one."
	color = "#664300" // rgb: 102, 67, 0
	nutriment_factor = 1 * REAGENTS_METABOLISM
	boozepwr = 30
	quality = DRINK_NICE
	taste_description = "сладкий, сладкий алкоголь"
	glass_icon_state = "meadglass"
	glass_name = "Mead"
	glass_desc = "A drink from Valhalla."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/iced_beer
	name = "Охлажденное Пиво"
	description = "A beer which is so cold the air around it freezes."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 15
	taste_description = "освежающая прохлада"
	glass_icon_state = "iced_beerglass"
	glass_name = "iced beer"
	glass_desc = "A beer so frosty, the air around it freezes."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/iced_beer/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjust_bodytemperature(-20 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, T0C) //310.15 is the normal bodytemp.
	return ..()

/datum/reagent/consumable/ethanol/grog
	name = "Грог"
	description = "Watered-down rum, Nanotrasen approves!"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 1 //Basically nothing
	taste_description = "плохое оправдание для алкоголя"
	glass_icon_state = "grogglass"
	glass_name = "Grog"
	glass_desc = "A fine and cepa drink for Space."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED


/datum/reagent/consumable/ethanol/aloe
	name = "Алоэ"
	description = "So very, very, very good."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 35
	quality = DRINK_VERYGOOD
	taste_description = "сладкий и сливочный"
	glass_icon_state = "aloe"
	glass_name = "Aloe"
	glass_desc = "Very, very, very good."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	//somewhat annoying mix
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/ethanol/andalusia
	name = "Андалузия"
	description = "A nice, strangely named drink."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 40
	quality = DRINK_GOOD
	taste_description = "лимоны"
	glass_icon_state = "andalusia"
	glass_name = "Andalusia"
	glass_desc = "A nice, strangely named drink."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/alliescocktail
	name = "Коктейль Союзники"
	description = "A drink made from your allies. Not as sweet as those made from your enemies."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 45
	quality = DRINK_NICE
	taste_description = "горький, но свободный"
	glass_icon_state = "alliescocktail"
	glass_name = "Allies cocktail"
	glass_desc = "A drink made from your allies."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/acid_spit
	name = "Кислотный Плевок"
	description = "A drink for the daring, can be deadly if incorrectly prepared!"
	special_sound = 'white/valtos/sounds/drink/airlock_alien_prying.ogg'
	color = "#365000" // rgb: 54, 80, 0
	boozepwr = 70
	quality = DRINK_VERYGOOD
	taste_description = "желудочная кислота"
	glass_icon_state = "acidspitglass"
	glass_name = "Acid Spit"
	glass_desc = "A drink from Nanotrasen. Made from live aliens."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/amasec
	name = "Амасек"
	description = "Official drink of the Nanotrasen Gun-Club!"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 35
	quality = DRINK_GOOD
	taste_description = "темный и металлический"
	glass_icon_state = "amasecglass"
	glass_name = "Amasec"
	glass_desc = "Always handy before COMBAT!!!"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/changelingsting
	name = "Жало Генокрада"
	description = "You take a tiny sip and feel a burning sensation..."
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "мой мозг выходит из носа"
	glass_icon_state = "changelingsting"
	glass_name = "Changeling Sting"
	glass_desc = "A stingy drink."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/changelingsting/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.mind) //Changeling Sting assists in the recharging of changeling chemicals.
		var/datum/antagonist/changeling/changeling = M.mind.has_antag_datum(/datum/antagonist/changeling)
		if(changeling)
			changeling.chem_charges += metabolization_rate * REM * delta_time
			changeling.chem_charges = clamp(changeling.chem_charges, 0, changeling.chem_storage)
	return ..()

/datum/reagent/consumable/ethanol/irishcarbomb
	name = "Ирландская Автомобильная Бомба"
	description = "Mmm, tastes like the free Irish state."
	special_sound = 'white/valtos/sounds/drink/irish_coffee.ogg'
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 25
	quality = DRINK_GOOD
	taste_description = "вкусный гнев"
	glass_icon_state = "irishcarbomb"
	glass_name = "Irish Car Bomb"
	glass_desc = "An Irish car bomb."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/syndicatebomb
	name = "Синдикатская Бомба"
	description = "Tastes like terrorism!"
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 90
	quality = DRINK_GOOD
	taste_description = "очищенный антагонизм"
	glass_icon_state = "syndicatebomb"
	glass_name = "Syndicate Bomb"
	glass_desc = "A syndicate bomb."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/syndicatebomb/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(DT_PROB(2.5, delta_time))
		playsound(get_turf(M), pick(FAR_EXPLOSION_SOUNDS), 100, TRUE)
	return ..()

/datum/reagent/consumable/ethanol/hiveminderaser
	name = "Стиратель Коллективного Разума"
	description = "A vessel of pure flavor."
	color = "#FF80FC" // rgb: 255, 128, 252
	boozepwr = 40
	quality = DRINK_GOOD
	taste_description = "экстрасенсорные ссылки"
	glass_icon_state = "hiveminderaser"
	glass_name = "Hivemind Eraser"
	glass_desc = "For when even mindshields can't save you."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/erikasurprise
	name = "Сюрприз Эрики"
	description = "The surprise is, it's green!"
	special_sound = 'white/valtos/sounds/drink/erika.ogg'
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 35
	quality = DRINK_VERYGOOD
	taste_description = "терпкость и бананы"
	glass_icon_state = "erikasurprise"
	glass_name = "Erika Surprise"
	glass_desc = "The surprise is, it's green!"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/driestmartini
	name = "Самый Сухой Мартини"
	description = "Only for the experienced. You think you see sand floating in the glass."
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 65
	quality = DRINK_GOOD
	taste_description = "пляж"
	glass_icon_state = "driestmartiniglass"
	glass_name = "Driest Martini"
	glass_desc = "Only for the experienced. You think you see sand floating in the glass."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/bananahonk
	name = "Банановый Хонк"
	description = "A drink from Clown Heaven."
	special_sound = 'white/valtos/sounds/drink/bikehorn.ogg'
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#FFFF91" // rgb: 255, 255, 140
	boozepwr = 60
	quality = DRINK_GOOD
	taste_description = "плохая шутка"
	glass_icon_state = "bananahonkglass"
	glass_name = "Banana Honk"
	glass_desc = "A drink from Clown Heaven."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/bananahonk/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	var/obj/item/organ/liver/liver = M.getorganslot(ORGAN_SLOT_LIVER)
	if((liver && HAS_TRAIT(liver, TRAIT_COMEDY_METABOLISM)) || ismonkey(M))
		M.heal_bodypart_damage(1 * REM * delta_time, 1 * REM * delta_time)
		. = TRUE
	return ..() || .

/datum/reagent/consumable/ethanol/silencer
	name = "Глушитель"
	description = "A drink from Mime Heaven."
	nutriment_factor = 2 * REAGENTS_METABOLISM
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 59 //Proof that clowns are better than mimes right here
	quality = DRINK_GOOD
	taste_description = "ластик"
	glass_icon_state = "silencerglass"
	glass_name = "Silencer"
	glass_desc = "A drink from Mime Heaven."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/silencer/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(ishuman(M) && M.mind?.miming)
		M.silent = max(M.silent, MIMEDRINK_SILENCE_DURATION)
		M.heal_bodypart_damage(1 * REM * delta_time, 1 * REM * delta_time)
		. = TRUE
	return ..() || .

/datum/reagent/consumable/ethanol/drunkenblumpkin
	name = "Туалетный Отсос"
	description = "A weird mix of whiskey and blumpkin juice."
	color = "#1EA0FF" // rgb: 102, 67, 0
	boozepwr = 50
	quality = DRINK_VERYGOOD
	taste_description = "патока и глоток воды в бассейне"
	glass_icon_state = "drunkenblumpkin"
	glass_name = "Drunken Blumpkin"
	glass_desc = "A drink for the drunks."
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
	description = "Apple juice, for adults."
	color = "#CD6839"
	nutriment_factor = 1 * REAGENTS_METABOLISM
	boozepwr = 25
	taste_description = "сезон, который <i>выпадает</i> между летом и зимой"
	glass_icon_state = "whiskeyglass"
	glass_name = "hard cider"
	glass_desc = "Tastes like autumn... no wait, fall!"
	shot_glass_icon_state = "shotglassbrown"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED


/datum/reagent/consumable/ethanol/fetching_fizz //A reference to one of my favorite games of all time. Pulls nearby ores to the imbiber!
	name = "Приход"
	description = "Whiskey sour/iron/uranium mixture resulting in a highly magnetic slurry. Mild alcohol content." //Requires no alcohol to make but has alcohol anyway because ~magic~
	color = rgb(255, 91, 15)
	boozepwr = 10
	quality = DRINK_VERYGOOD
	metabolization_rate = 0.1 * REAGENTS_METABOLISM
	taste_description = "заряженный металл" // the same as teslium, honk honk.
	glass_icon_state = "fetching_fizz"
	glass_name = "Fetching Fizz"
	glass_desc = "Induces magnetism in the imbiber. Started as a barroom prank but evolved to become popular with miners and scrappers. Metallic aftertaste."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED


/datum/reagent/consumable/ethanol/fetching_fizz/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	for(var/obj/item/stack/ore/O in orange(3, M))
		step_towards(O, get_turf(M))
	return ..()

//Another reference. Heals those in critical condition extremely quickly.
/datum/reagent/consumable/ethanol/hearty_punch
	name = "Сердечный Пунш"
	description = "Brave bull/syndicate bomb/absinthe mixture resulting in an energizing beverage. Mild alcohol content."
	color = rgb(140, 0, 0)
	boozepwr = 90
	quality = DRINK_VERYGOOD
	metabolization_rate = 0.4 * REAGENTS_METABOLISM
	taste_description = "бравада перед лицом катастрофы"
	glass_icon_state = "hearty_punch"
	glass_name = "Hearty Punch"
	glass_desc = "Aromatic beverage served piping hot. According to folk tales it can almost wake the dead."
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
	name = "Благословление Диониса"
	description = "Unidentifiable mixture. Unmeasurably high alcohol content."
	color = rgb(51, 19, 3) //Sickly brown
	boozepwr = 300 //I warned you
	taste_description = "кирпичная стена"
	glass_icon_state = "glass_brown2"
	glass_name = "Bacchus' Blessing"
	glass_desc = "You didn't think it was possible for a liquid to be so utterly revolting. Are you sure about this...?"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED



/datum/reagent/consumable/ethanol/atomicbomb
	name = "Атомная Бомба"
	description = "Nuclear proliferation never tasted so good."
	special_sound = 'white/valtos/sounds/drink/atomic_bomb.ogg'
	color = "#666300" // rgb: 102, 99, 0
	boozepwr = 0 //custom drunk effect
	quality = DRINK_FANTASTIC
	taste_description = "бомба"
	glass_icon_state = "atomicbombglass"
	glass_name = "Atomic Bomb"
	glass_desc = "Nanotrasen cannot take legal responsibility for your actions after imbibing."
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
	description = "Whoah, this stuff looks volatile!"
	special_sound = 'white/valtos/sounds/drink/enter_galactic.ogg'
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 0 //custom drunk effect
	quality = DRINK_GOOD
	taste_description = "мои мозги разбиты лимоном, обернутым вокруг золотого кирпича"
	glass_icon_state = "gargleblasterglass"
	glass_name = "Pan-Galactic Gargle Blaster"
	glass_desc = "Like having your brain smashed out by a slice of lemon wrapped around a large gold brick."
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
	description = "A strong neurotoxin that puts the subject into a death-like state."
	color = "#2E2E61" // rgb: 46, 46, 97
	boozepwr = 50
	quality = DRINK_VERYGOOD
	taste_description = "онемение"
	metabolization_rate = 1 * REAGENTS_METABOLISM
	glass_icon_state = "neurotoxinglass"
	glass_name = "Neurotoxin"
	glass_desc = "A drink that is guaranteed to knock you silly."
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
	description = "You just don't get it maaaan."
	color = "#664300" // rgb: 102, 67, 0
	nutriment_factor = 0
	boozepwr = 0 //custom drunk effect
	quality = DRINK_FANTASTIC
	metabolization_rate = 0.2 * REAGENTS_METABOLISM
	taste_description = "дать миру шанс"
	glass_icon_state = "hippiesdelightglass"
	glass_name = "Hippie's Delight"
	glass_desc = "A drink enjoyed by people during the 1960's."
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
	description = "For enjoying the most wonderful time of the year."
	color = "#fcfdc6" // rgb: 252, 253, 198
	nutriment_factor = 2 * REAGENTS_METABOLISM
	boozepwr = 1
	quality = DRINK_VERYGOOD
	taste_description = "заварной крем и алкоголь"
	glass_icon_state = "glass_yellow"
	glass_name = "eggnog"
	glass_desc = "For enjoying the most wonderful time of the year."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED


/datum/reagent/consumable/ethanol/narsour
	name = "Нар'Кис"
	description = "Side effects include self-mutilation and hoarding plasteel."
	color = RUNE_COLOR_DARKRED
	boozepwr = 10
	quality = DRINK_FANTASTIC
	taste_description = "кровь"
	glass_icon_state = "narsour"
	glass_name = "Nar'Sour"
	glass_desc = "A new hit cocktail inspired by THE ARM Breweries will have you shouting Fuu ma'jin in no time!"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/narsour/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.cultslurring = min(M.cultslurring + (3 * REM * delta_time), 3)
	M.stuttering = min(M.stuttering + (3 * REM * delta_time), 3)
	..()

/datum/reagent/consumable/ethanol/triple_sec
	name = "Трипл Сек"
	description = "A sweet and vibrant orange liqueur."
	color = "#ffcc66"
	boozepwr = 30
	taste_description = "теплый цветочный апельсиновый вкус, напоминающий воздушный океан и летний карибский ветер"
	glass_icon_state = "glass_orange"
	glass_name = "Triple Sec"
	glass_desc = "A glass of straight Triple Sec."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/creme_de_menthe
	name = "Creme de Menthe"
	description = "A minty liqueur excellent for refreshing, cool drinks."
	color = "#00cc00"
	boozepwr = 20
	taste_description = "мятный, прохладный и бодрящий всплеск холодной воды"
	glass_icon_state = "glass_green"
	glass_name = "Creme de Menthe"
	glass_desc = "You can almost feel the first breath of spring just looking at it."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/creme_de_cacao
	name = "Creme de Cacao"
	description = "A chocolatey liqueur excellent for adding dessert notes to beverages and bribing sororities."
	color = "#996633"
	boozepwr = 20
	taste_description = "гладкий и ароматный намек конфет, кружащихся в укусе алкоголя"
	glass_icon_state = "glass_brown"
	glass_name = "Creme de Cacao"
	glass_desc = "A million hazing lawsuits and alcohol poisonings have started with this humble ingredient."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/creme_de_coconut
	name = "Creme de Coconut"
	description = "A coconut liqueur for smooth, creamy, tropical drinks."
	color = "#F7F0D0"
	boozepwr = 20
	taste_description = "сладкий молочный вкус с нотами поджаренного сахара"
	glass_icon_state = "glass_white"
	glass_name = "Creme de Coconut"
	glass_desc = "An unintimidating glass of coconut liqueur."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/quadruple_sec
	name = "Квадрипл Сек"
	description = "Kicks just as hard as licking the power cell on a baton, but tastier."
	color = "#cc0000"
	boozepwr = 35
	quality = DRINK_GOOD
	taste_description = "бодрящая горькая свежесть, которая наполняет ваше существо; ни один враг станции не останется незамеченным в этот день"
	glass_icon_state = "quadruple_sec"
	glass_name = "Quadruple Sec"
	glass_desc = "An intimidating and lawful beverage dares you to violate the law and make its day. Still can't drink it on duty, though."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/quadruple_sec/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	//Securidrink in line with the Screwdriver for engineers or Nothing for mimes
	var/obj/item/organ/liver/liver = M.getorganslot(ORGAN_SLOT_LIVER)
	if(liver && HAS_TRAIT(liver, TRAIT_LAW_ENFORCEMENT_METABOLISM))
		M.heal_bodypart_damage(1 * REM * delta_time, 1 * REM * delta_time)
		M.adjustBruteLoss(-2 * REM * delta_time, 0)
		. = TRUE
	return ..()

/datum/reagent/consumable/ethanol/quintuple_sec
	name = "Квантипл Сек"
	description = "Law, Order, Alcohol, and Police Brutality distilled into one single elixir of JUSTICE."
	color = "#ff3300"
	boozepwr = 55
	quality = DRINK_FANTASTIC
	taste_description = "ЗАКОН"
	glass_icon_state = "quintuple_sec"
	glass_name = "Quintuple Sec"
	glass_desc = "Now you are become law, destroyer of clowns."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/quintuple_sec/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	//Securidrink in line with the Screwdriver for engineers or Nothing for mimes but STRONG..
	var/obj/item/organ/liver/liver = M.getorganslot(ORGAN_SLOT_LIVER)
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
	description = "A fresh and sweet dessert shooter. Difficult to look manly while drinking this."
	color = "#00ff00"
	boozepwr = 25
	quality = DRINK_GOOD
	taste_description = "шоколад и мята танцуют вокруг моего рта"
	glass_icon_state = "grasshopper"
	glass_name = "Grasshopper"
	glass_desc = "You weren't aware edible beverages could be that green."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/stinger
	name = "Стингер"
	description = "A snappy way to end the day."
	color = "#ccff99"
	boozepwr = 25
	quality = DRINK_NICE
	taste_description = "пощечина в лучшем виде"
	glass_icon_state = "stinger"
	glass_name = "Stinger"
	glass_desc = "You wonder what would happen if you pointed this at a heat source..."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/bastion_bourbon
	name = "Бурбон «Бастион»"
	description = "Soothing hot herbal brew with restorative properties. Hints of citrus and berry flavors."
	color = "#00FFFF"
	boozepwr = 30
	quality = DRINK_FANTASTIC
	taste_description = "горячий травяной напиток с фруктовым оттенком"
	metabolization_rate = 2 * REAGENTS_METABOLISM //0.8u per tick
	glass_icon_state = "bastion_bourbon"
	glass_name = "Bastion Bourbon"
	glass_desc = "If you're feeling low, count on the buttery flavor of our own bastion bourbon."
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
	name = "Брызгающий Сидр"
	description = "Fermented squirt extract with a nose of stale bread and ocean water. Whatever a squirt is."
	color = "#FF0000"
	boozepwr = 40
	taste_description = "черствый хлеб с послевкусием послевкусия"
	nutriment_factor = 2 * REAGENTS_METABOLISM
	glass_icon_state = "squirt_cider"
	glass_name = "Squirt Cider"
	glass_desc = "Squirt cider will toughen you right up. Too bad about the musty aftertaste."
	shot_glass_icon_state = "shotglassgreen"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/squirt_cider/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.satiety += 5 * REM * delta_time //for context, vitamins give 15 satiety per second
	..()
	. = TRUE

/datum/reagent/consumable/ethanol/fringe_weaver
	name = "Бон Развязон"
	description = "Bubbly, classy, and undoubtedly strong - a Glitch City classic."
	special_sound = 'white/valtos/sounds/drink/va-lchalla.ogg'
	color = "#FFEAC4"
	boozepwr = 90 //classy hooch, essentially, but lower pwr to make up for slightly easier access
	quality = DRINK_GOOD
	taste_description = "этиловый спирт с оттенком сахара"
	glass_icon_state = "fringe_weaver"
	glass_name = "Fringe Weaver"
	glass_desc = "It's a wonder it doesn't spill out of the glass."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/sugar_rush
	name = "Сахарный Прилив"
	description = "Sweet, light, and fruity - as girly as it gets."
	special_sound = 'white/valtos/sounds/drink/va-lchalla.ogg'
	color = "#FF226C"
	boozepwr = 10
	quality = DRINK_GOOD
	taste_description = "ваши артерии засоряются сахаром"
	nutriment_factor = 2 * REAGENTS_METABOLISM
	glass_icon_state = "sugar_rush"
	glass_name = "Sugar Rush"
	glass_desc = "If you can't mix a Sugar Rush, you can't tend bar."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/sugar_rush/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.satiety -= 10 * REM * delta_time //junky as hell! a whole glass will keep you from being able to eat junk food
	..()
	. = TRUE

/datum/reagent/consumable/ethanol/crevice_spike
	name = "Спазм Кишок"
	description = "Sour, bitter, and smashingly sobering."
	special_sound = 'white/valtos/sounds/drink/va-lchalla.ogg'
	color = "#5BD231"
	boozepwr = -10 //sobers you up - ideally, one would drink to get hit with brute damage now to avoid alcohol problems later
	quality = DRINK_VERYGOOD
	taste_description = "горький спайк с кислым послевкусием"
	glass_icon_state = "crevice_spike"
	glass_name = "Crevice Spike"
	glass_desc = "It'll either knock the drunkenness out of you or knock you out cold. Both, probably."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/crevice_spike/on_mob_metabolize(mob/living/L) //damage only applies when drink first enters system and won't again until drink metabolizes out
	L.adjustBruteLoss(3 * min(5,volume)) //minimum 3 brute damage on ingestion to limit non-drink means of injury - a full 5 unit gulp of the drink trucks you for the full 15

/datum/reagent/consumable/ethanol/sake
	name = "Сакэ"
	description = "A sweet rice wine of questionable legality and extreme potency."
	color = "#DDDDDD"
	boozepwr = 70
	taste_description = "сладкое рисовое вино"
	glass_icon_state = "sakecup"
	glass_name = "cup of sake"
	glass_desc = "A traditional cup of sake."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_STOCK

/datum/reagent/consumable/ethanol/peppermint_patty
	name = "Пепперминт Пэтти"
	description = "This lightly alcoholic drink combines the benefits of menthol and cocoa."
	color = "#45ca7a"
	taste_description = "мята и шоколад"
	boozepwr = 25
	quality = DRINK_GOOD
	glass_icon_state = "peppermint_patty"
	glass_name = "Peppermint Patty"
	glass_desc = "A boozy minty hot cocoa that warms your belly on a cold night."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/peppermint_patty/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.apply_status_effect(/datum/status_effect/throat_soothed)
	M.adjust_bodytemperature(5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time, 0, M.get_body_temp_normal())
	..()

/datum/reagent/consumable/ethanol/alexander
	name = "Александр"
	description = "Named after a Greek hero, this mix is said to embolden a user's shield as if they were in a phalanx."
	special_sound = 'white/valtos/sounds/drink/alexander.ogg'
	color = "#F5E9D3"
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "горький, сливочный какао"
	glass_icon_state = "alexander"
	glass_name = "Alexander"
	glass_desc = "A creamy, indulgent delight that is stronger than it seems."
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
	name = "Александр с Амаретто"
	description = "A weaker version of the Alexander, what it lacks in strength it makes up for in flavor."
	color = "#DBD5AE"
	boozepwr = 35
	quality = DRINK_VERYGOOD
	taste_description = "sweet, creamy cacao"
	glass_icon_state = "alexanderam"
	glass_name = "Amaretto Alexander"
	glass_desc = "A creamy, indulgent delight that is in fact as gentle as it seems."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/sidecar
	name = "Сайдкар"
	description = "The one ride you'll gladly give up the wheel for."
	color = "#FFC55B"
	boozepwr = 45
	quality = DRINK_GOOD
	taste_description = "вкусная свобода"
	glass_icon_state = "sidecar"
	glass_name = "Sidecar"
	glass_desc = "The one ride you'll gladly give up the wheel for."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/ethanol/between_the_sheets
	name = "Между Простынями"
	description = "A provocatively named classic. Funny enough, doctors recommend drinking it before taking a nap."
	color = "#F4C35A"
	boozepwr = 55
	quality = DRINK_GOOD
	taste_description = "обольщение"
	glass_icon_state = "between_the_sheets"
	glass_name = "Between the Sheets"
	glass_desc = "The only drink that comes with a label reminding you of Nanotrasen's zero-tolerance promiscuity policy."
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
	description = "Divinely windy."
	color = "#EEF191"
	boozepwr = 60
	quality = DRINK_GOOD
	taste_description = "божественная ветренность"
	glass_icon_state = "kamikaze"
	glass_name = "Kamikaze"
	glass_desc = "Divinely windy."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/mojito
	name = "Мохито"
	description = "A drink that looks as refreshing as it tastes."
	color = "#DFFAD9"
	boozepwr = 30
	quality = DRINK_GOOD
	taste_description = "освежающая мята"
	glass_icon_state = "mojito"
	glass_name = "Mojito"
	glass_desc = "A drink that looks as refreshing as it tastes."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/ethanol/moscow_mule
	name = "Московский Мул"
	description = "A chilly drink that reminds you of the Derelict."
	color = "#EEF1AA"
	boozepwr = 30
	quality = DRINK_GOOD
	taste_description = "освежающая пряность"
	glass_icon_state = "moscow_mule"
	glass_name = "Moscow Mule"
	glass_desc = "A chilly drink that reminds you of the Derelict."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/fernet
	name = "Фернет"
	description = "An incredibly bitter herbal liqueur used as a digestif."
	color = "#1B2E24" // rgb: 27, 46, 36
	boozepwr = 80
	taste_description = "полная горечь"
	glass_name = "стакан fernet"
	glass_desc = "A glass of pure Fernet. Only an absolute madman would drink this alone." //Hi Kevum
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/fernet/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.nutrition <= NUTRITION_LEVEL_STARVING)
		M.adjustToxLoss(1 * REM * delta_time, 0)
	M.adjust_nutrition(-5 * REM * delta_time)
	M.overeatduration = 0
	return ..()

/datum/reagent/consumable/ethanol/fernet_cola
	name = "Фернет с Колой"
	description = "A very popular and bittersweet digestif, ideal after a heavy meal. Best served on a sawed-off cola bottle as per tradition."
	color = "#390600" // rgb: 57, 6,
	boozepwr = 25
	quality = DRINK_NICE
	taste_description = "сладкое облегчение"
	glass_icon_state = "godlyblend"
	glass_name = "стакан fernet cola"
	glass_desc = "A sawed-off cola bottle filled with Fernet Cola. Nothing better after eating like a lardass."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/fernet_cola/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.nutrition <= NUTRITION_LEVEL_STARVING)
		M.adjustToxLoss(0.5 * REM * delta_time, 0)
	M.adjust_nutrition(-3 * REM * delta_time)
	M.overeatduration = 0
	return ..()

/datum/reagent/consumable/ethanol/fanciulli

	name = "Фанциулли"
	description = "What if the Manhattan cocktail ACTUALLY used a bitter herb liquour? Helps you sober up." //also causes a bit of stamina damage to symbolize the afterdrink lazyness
	color = "#CA933F" // rgb: 202, 147, 63
	boozepwr = -10
	quality = DRINK_NICE
	taste_description = "сладкая отрезвляющая смесь"
	glass_icon_state = "fanciulli"
	glass_name = "стакан fanciulli"
	glass_desc = "A glass of Fanciulli. It's just Manhattan with Fernet."
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
	description = "A refreshing mixture of bitter Fernet with mint creme liquour."
	color = "#4B5746" // rgb: 75, 87, 70
	boozepwr = 35
	quality = DRINK_GOOD
	taste_description = "горькая свежесть"
	glass_icon_state= "minted_fernet"
	glass_name = "стакан branca menta"
	glass_desc = "A glass of Branca Menta, perfect for those lazy and hot Sunday summer afternoons." //Get lazy literally by drinking this
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
	description = "A bubbling glass of blank paper. Just looking at it makes you feel fresh."
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#DCDCDC" // rgb: 220, 220, 220
	boozepwr = 20
	quality = DRINK_GOOD
	taste_description = "возможность пузырения"
	glass_icon_state = "blank_paper"
	glass_name = "стакан blank paper"
	glass_desc = "A fizzy cocktail for those looking to start fresh."
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
	var/minimum_percent = 0.15 //Percentages measured between 0 and 1.
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
	var/list/names_in_order = sortTim(names, /proc/cmp_numeric_dsc, TRUE)
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
	description = "A sparkling wine known for its ability to strike fast and hard."
	color = "#ffffc1"
	boozepwr = 40
	taste_description = "благоприятные случаи и плохие решения"
	glass_icon_state = "champagne_glass"
	glass_name = "Champagne"
	glass_desc = "The flute clearly displays the slowly rising bubbles."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_EASY


/datum/reagent/consumable/ethanol/wizz_fizz
	name = "Виз Физ"
	description = "A magical potion, fizzy and wild! However the taste, you will find, is quite mild."
	color = "#4235d0" //Just pretend that the triple-sec was blue curacao.
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "дружба! Это ведь магия"
	glass_icon_state = "wizz_fizz"
	glass_name = "Wizz Fizz"
	glass_desc = "The glass bubbles and froths with an almost magical intensity."
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
	description = "A harsh, acrid, bitter drink, for those who need something to brace themselves."
	color = "#33ff33"
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "боль десяти тысяч убитых комаров"
	glass_icon_state = "bug_spray"
	glass_name = "Bug Spray"
	glass_desc = "Your eyes begin to water as the sting of alcohol reaches them."
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
	description = "The perfect beverage for when you feel the need to horse around."
	color = "#ff6633"
	boozepwr = 20
	taste_description = "честный день работы в саду"
	glass_icon_state = "applejack_glass"
	glass_name = "Applejack"
	glass_desc = "You feel like you could drink this all neight."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/jack_rose
	name = "Джек Роуз"
	description = "A light cocktail perfect for sipping with a slice of pie."
	color = "#ff6633"
	boozepwr = 15
	quality = DRINK_NICE
	taste_description = "кисло-сладкий кусочек яблока"
	glass_icon_state = "jack_rose"
	glass_name = "Jack Rose"
	glass_desc = "Enough of these, and you really will start to suppose your toeses are roses."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/turbo
	name = "Турбо"
	description = "A turbulent cocktail associated with outlaw hoverbike racing. Not for the faint of heart."
	color = "#e94c3a"
	boozepwr = 85
	quality = DRINK_VERYGOOD
	taste_description = "дух вне закона"
	glass_icon_state = "turbo"
	glass_name = "Turbo"
	glass_desc = "A turbulent cocktail for outlaw hoverbikers."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/turbo/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(DT_PROB(2, delta_time))
		to_chat(M, span_notice("[pick("Начинаю ощущать пренебрежение к верховенству закона.", "Чувствую себя накачанным!", "Голова стучит.", "Мысли вылетают..")]"))
	M.adjustStaminaLoss(-0.25 * M.drunkenness * REM * delta_time)
	return ..()

/datum/reagent/consumable/ethanol/old_timer
	name = "Старый Таймер"
	description = "An archaic potation enjoyed by old coots of all ages."
	color = "#996835"
	boozepwr = 35
	quality = DRINK_NICE
	taste_description = "более простые времена"
	glass_icon_state = "old_timer"
	glass_name = "Old Timer"
	glass_desc = "WARNING! May cause premature aging!"
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
	description = "A quality rubberneck should not contain any gross natural ingredients."
	color = "#ffe65b"
	boozepwr = 60
	quality = DRINK_GOOD
	taste_description = "искусственная фруктовость"
	glass_icon_state = "rubberneck"
	glass_name = "Rubberneck"
	glass_desc = "A popular drink amongst those adhering to an all synthetic diet."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/rubberneck/on_mob_metabolize(mob/living/L)
	. = ..()
	ADD_TRAIT(L, TRAIT_SHOCKIMMUNE, type)

/datum/reagent/consumable/ethanol/rubberneck/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_SHOCKIMMUNE, type)
	return ..()

/datum/reagent/consumable/ethanol/duplex
	name = "Дуплекс"
	description = "An inseparable combination of two fruity drinks."
	color = "#50e5cf"
	boozepwr = 25
	quality = DRINK_NICE
	taste_description = "зелёные яблоки и голубая малина"
	glass_icon_state = "duplex"
	glass_name = "Duplex"
	glass_desc = "To imbibe one component separately from the other is consider a great faux pas."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/trappist
	name = "Траппистское пиво"
	description = "A strong dark ale brewed by space-monks."
	color = "#390c00"
	boozepwr = 40
	quality = DRINK_VERYGOOD
	taste_description = "сушеные сливы и солод"
	glass_icon_state = "trappistglass"
	glass_name = "Trappist Beer"
	glass_desc = "boozy Catholicism in a glass."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/trappist/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.mind?.holy_role)
		M.adjustFireLoss(-2.5 * REM * delta_time, 0)
		M.jitteriness = max(M.jitteriness - (1 * REM * delta_time), 0)
		M.stuttering = max(M.stuttering - (1 * REM * delta_time), 0)
	return ..()

/datum/reagent/consumable/ethanol/blazaam
	name = "Блазам"
	description = "A strange drink that few people seem to remember existing. Doubles as a Berenstain remover."
	boozepwr = 70
	quality = DRINK_FANTASTIC
	taste_description = "альтернативные реалии"
	glass_icon_state = "blazaamglass"
	glass_name = "Blazaam"
	glass_desc = "The glass seems to be sliding between realities. Doubles as a Berenstain remover."
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
	name = "Планетный Шелкун"
	description = "This jubilant drink celebrates humanity's triumph over the alien menace. May be offensive to non-human crewmembers."
	boozepwr = 50
	quality = DRINK_FANTASTIC
	taste_description = "торжество с оттенком горечи"
	glass_icon_state = "planet_cracker"
	glass_name = "Planet Cracker"
	glass_desc = "Although historians believe the drink was originally created to commemorate the end of an important conflict in man's past, its origins have largely been forgotten and it is today seen more as a general symbol of human supremacy."

/datum/reagent/consumable/ethanol/mauna_loa
	name = "Mauna Loa"
	description = "Extremely hot; not for the faint of heart!"
	boozepwr = 40
	color = "#fe8308" // 254, 131, 8
	quality = DRINK_FANTASTIC
	taste_description = "огненный, с послевкусием сгоревшей плоти"
	glass_icon_state = "mauna_loa"
	glass_name = "Mauna Loa"
	glass_desc = "Lavaland in a drink... mug... volcano... thing."
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
	description = "Dulls your pain. Your emotional pain, that is."
	boozepwr = 20
	color = "#EAD677"
	quality = DRINK_NICE
	taste_description = "сладкая терпкость"
	glass_icon_state = "painkiller"
	glass_name = "Painkiller"
	glass_desc = "A combination of tropical juices and rum. Surely this will make you feel better."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/pina_colada
	name = "Пина Колада"
	description = "A fresh pineapple drink with coconut rum. Yum."
	special_sound = 'white/valtos/sounds/drink/pina_colada.ogg'
	boozepwr = 40
	color = "#FFF1B2"
	quality = DRINK_FANTASTIC
	taste_description = "ананас, кокос и океан"
	glass_icon_state = "pina_colada"
	glass_name = "Pina Colada"
	glass_desc = "If you like pina coladas, and getting caught in the rain... well, you'll like this drink."


/datum/reagent/consumable/ethanol/pruno // pruno mix is in drink_reagents
	name = "пруно"
	color = "#E78108"
	description = "Fermented prison wine made from fruit, sugar, and despair. Security loves to confiscate this, which is the only kind thing Security has ever done."
	boozepwr = 85
	taste_description = "мои вкусовые рецепторы индивидуально отшлифованы"
	glass_icon_state = "glass_orange"
	glass_name = "стакан pruno"
	glass_desc = "Fermented prison wine made from fruit, sugar, and despair. Security loves to confiscate this, which is the only kind thing Security has ever done."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/pruno/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjust_disgust(5 * REM * delta_time)
	..()

/datum/reagent/consumable/ethanol/ginger_amaretto
	name = "Джинджер Амаретто"
	description = "A delightfully simple cocktail that pleases the senses."
	boozepwr = 30
	color = "#EFB42A"
	quality = DRINK_GOOD
	taste_description = "sweetness followed by a soft sourness and warmth"
	glass_icon_state = "gingeramaretto"
	glass_name = "Ginger Amaretto"
	glass_desc = "The sprig of rosemary adds a nice aroma to the drink, and isn't just to be pretentious afterall!"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/godfather
	name = "Крестный Отец"
	description = "A rough cocktail with illegal connections."
	special_sound = 'white/valtos/sounds/drink/godfather.ogg'
	boozepwr = 50
	color = "#E68F00"
	quality = DRINK_GOOD
	taste_description = "a delightful softened punch"
	glass_icon_state = "godfather"
	glass_name = "Godfather"
	glass_desc = "A classic from old Italy and enjoyed by gangsters, pray the orange peel doesnt end up in your mouth."
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
	description = "A twist on a classic, liked more by mature women."
	boozepwr = 50
	color = "#E68F00"
	quality = DRINK_GOOD
	taste_description = "sweetness and a zesty twist"
	glass_icon_state = "godmother"
	glass_name = "Godmother"
	glass_desc = "A lovely fresh smelling cocktail, a true Sicilian delight."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

//Moth Drinks
/datum/reagent/consumable/ethanol/curacao
	name = "Curaçao"
	description = "Made with laraha oranges, for an aromatic finish."
	boozepwr = 30
	color = "#1a5fa1"
	quality = DRINK_NICE
	taste_description = "blue orange"
	glass_icon_state = "curacao"
	glass_name = "стакан curaçao"
	glass_desc = "It's blue, da ba dee."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/navy_rum //IN THE NAVY
	name = "Navy Rum"
	description = "Rum as the finest sailors drink."
	boozepwr = 90 //the finest sailors are often drunk
	color = "#d8e8f0"
	quality = DRINK_NICE
	taste_description = "a life on the waves"
	glass_icon_state = "ginvodkaglass"
	glass_name = "стакан navy rum"
	glass_desc = "Splice the mainbrace, and God save the King."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/bitters //why do they call them bitters, anyway? they're more spicy than anything else
	name = "Andromeda Bitters"
	description = "A bartender's best friend, often used to lend a delicate spiciness to any drink. Produced in New Trinidad, now and forever."
	boozepwr = 70
	color = "#1c0000"
	quality = DRINK_NICE
	taste_description = "spiced alcohol"
	glass_icon_state = "bitters"
	glass_name = "стакан bitters"
	glass_desc = "Typically you'd want to mix this with something- but you do you."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/admiralty //navy rum, vermouth, fernet
	name = "Admiralty"
	description = "A refined, bitter drink made with navy rum, vermouth and fernet."
	boozepwr = 100
	color = "#1F0001"
	quality = DRINK_VERYGOOD
	taste_description = "haughty arrogance"
	glass_icon_state = "admiralty"
	glass_name = "Admiralty"
	glass_desc = "Hail to the Admiral, for he brings fair tidings, and rum too."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/long_haul //Rum, Curacao, Sugar, dash of bitters, lengthened with soda water
	name = "Long Haul"
	description = "A favourite amongst freighter pilots, unscrupulous smugglers, and nerf herders."
	boozepwr = 35
	color = "#003153"
	quality = DRINK_VERYGOOD
	taste_description = "companionship"
	glass_icon_state = "long_haul"
	glass_name = "Long Haul"
	glass_desc = "A perfect companion for a lonely long haul flight."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/long_john_silver //navy rum, bitters, lemonade
	name = "Long John Silver"
	description = "A long drink of navy rum, bitters, and lemonade. Particularly popular aboard the Mothic Fleet as it's light on ration credits and heavy on flavour."
	boozepwr = 50
	color = "#c4b35c"
	quality = DRINK_VERYGOOD
	taste_description = "rum and spices"
	glass_icon_state = "long_john_silver"
	glass_name = "Long John Silver"
	glass_desc = "Named for a famous pirate, who may or may not have been fictional. But hey, why let the truth get in the way of a good yarn?" //Chopper Reid says "How the fuck are ya?"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/tropical_storm //dark rum, pineapple juice, triple citrus, curacao
	name = "Tropical Storm"
	description = "A taste of the Caribbean in one glass."
	boozepwr = 40
	color = "#00bfa3"
	quality = DRINK_VERYGOOD
	taste_description = "the tropics"
	glass_icon_state = "tropical_storm"
	glass_name = "Tropical Storm"
	glass_desc = "Less destructive than the real thing."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/dark_and_stormy //rum and ginger beer- simple and classic
	name = "Dark and Stormy"
	description = "A classic drink arriving to thunderous applause." //thank you, thank you, I'll be here forever
	boozepwr = 50
	color = "#8c5046"
	quality = DRINK_GOOD
	taste_description = "ginger and rum"
	glass_icon_state = "dark_and_stormy"
	glass_name = "Dark and Stormy"
	glass_desc = "Thunder and lightning, very very frightening."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/salt_and_swell //navy rum, tochtause syrup, egg whites, dash of saline-glucose solution
	name = "Salt and Swell"
	description = "A bracing sour with an interesting salty taste."
	boozepwr = 60
	color = "#b4abd0"
	quality = DRINK_FANTASTIC
	taste_description = "salt and spice"
	glass_icon_state = "salt_and_swell"
	glass_name = "Salt and Swell"
	glass_desc = "Ah, I do like to be beside the seaside."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/tiltaellen //yoghurt, salt, vinegar
	name = "Tiltällen"
	description = "A lightly fermented yoghurt drink with salt and a light dash of vinegar. Has a distinct sour cheesy flavour."
	boozepwr = 10
	color = "#F4EFE2"
	quality = DRINK_NICE
	taste_description = "sour cheesy yoghurt"
	glass_icon_state = "tiltaellen"
	glass_name = "стакан tiltällen"
	glass_desc = "Eww... it's curdled."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/tich_toch
	name = "Tich Toch"
	description = "A mix of Tiltällen, Töchtaüse Syrup, and vodka. It's not exactly to everyones' tastes."
	boozepwr = 75
	color = "#b4abd0"
	quality = DRINK_VERYGOOD
	taste_description = "spicy sour cheesy yoghurt"
	glass_icon_state = "tich_toch"
	glass_name = "Tich Toch"
	glass_desc = "Oh god."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

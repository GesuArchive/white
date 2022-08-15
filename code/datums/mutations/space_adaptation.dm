//Cold Resistance gives your entire body an orange halo, and makes you immune to the effects of vacuum and cold.
/datum/mutation/human/space_adaptation
	name = "Космическая адаптация"
	desc = "Мутация сформировавшаяся у экипажей разведывательных межсистемных первопроходцев, странным образом ограждает носителя от холода и космического вакуума. К сожалению мы все еще нуждаемся в кислороде."
	quality = POSITIVE
	difficulty = 16
	text_gain_indication = span_notice("Ощущаю некое родство с окружающей нас пустотой космоса! Так и хочется выйти из шлюза, протянуть к нему руку, снять шлем и ...")
	instability = 30

/datum/mutation/human/space_adaptation/New(class_ = MUT_OTHER, timer, datum/mutation/human/copymut)
	..()
	if(!(type in visual_indicators))
		visual_indicators[type] = list(mutable_appearance('icons/effects/genetics.dmi', "fire", -MUTATIONS_LAYER))

/datum/mutation/human/space_adaptation/get_visual_indicator()
	return visual_indicators[type][1]

/datum/mutation/human/space_adaptation/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_RESISTCOLD, "space_adaptation")
	ADD_TRAIT(owner, TRAIT_RESISTLOWPRESSURE, "space_adaptation")

/datum/mutation/human/space_adaptation/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_RESISTCOLD, "space_adaptation")
	REMOVE_TRAIT(owner, TRAIT_RESISTLOWPRESSURE, "space_adaptation")


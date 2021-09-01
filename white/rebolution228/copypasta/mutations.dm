/datum/mutation/human/spaceproof
	name = "Space Resistance"
	desc = "Специальная модификация мутации, созданная для защиты от влияния разгерметизации на человека. Не требует кислорода, но не спасает от холода."
	quality = POSITIVE
	locked = TRUE
	difficulty = 500
	text_gain_indication = span_notice("Вы чувствуете себя невосприимчивым к космосу.")
	time_coeff = 5
	instability = 30

/datum/mutation/human/spaceproof/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_NOBREATH, "spaceproof")
	ADD_TRAIT(owner, TRAIT_RESISTLOWPRESSURE, "spaceproof")

/datum/mutation/human/spaceproof/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_NOBREATH, "spaceproof")
	REMOVE_TRAIT(owner, TRAIT_RESISTLOWPRESSURE, "spaceproof")

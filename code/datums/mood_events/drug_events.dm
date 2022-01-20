/datum/mood_event/high
	mood_change = 8
	description = "<span class='nicegreen'>Вооооууу... Чувааааак... Меня так вштыыырилооо...</span>\n"

/datum/mood_event/smoked
	description = "<span class='nicegreen'>Мне удалось покурить недавно.</span>\n"
	mood_change = 4
	timeout = 6 MINUTES

/datum/mood_event/stoned
	mood_change = 10
	description = "<span class='nicegreen'>Чува-а-а-а-ак... я так обкуре-е-е-е-ен...</span>\n"

/datum/mood_event/wrong_brand
	description = "<span class='warning'>Ненавижу эту марку сигарет.</span>\n"
	mood_change = -1
	timeout = 6 MINUTES

/datum/mood_event/overdose
	mood_change = -16
	timeout = 5 MINUTES

/datum/mood_event/overdose/add_effects(drug_name)
	description = "<span class='warning'>У меня передозировка [drug_name]</span>\n"

/datum/mood_event/withdrawal_light
	mood_change = -4

/datum/mood_event/withdrawal_light/add_effects(drug_name)
	description = "<span class='warning'>Мне не помешало бы немного [drug_name]</span>\n"

/datum/mood_event/withdrawal_medium
	mood_change = -10

/datum/mood_event/withdrawal_medium/add_effects(drug_name)
	description = "<span class='warning'>Мне очень нужно [drug_name]</span>\n"

/datum/mood_event/withdrawal_severe
	mood_change = -16

/datum/mood_event/withdrawal_severe/add_effects(drug_name)
	description = "<span class='boldwarning'>О, боже, как же я хочу [drug_name]</span>\n"

/datum/mood_event/withdrawal_critical
	mood_change = -20

/datum/mood_event/withdrawal_critical/add_effects(drug_name)
	var/drug = uppertext(drug_name)
	description = "<span class='boldwarning'>[drug]! [drug]! [drug]!</span>\n"

/datum/mood_event/happiness_drug
	description = "<span class='nicegreen'>Ничего не чувствую, и не хочу, чтобы это прекратилось.</span>\n"
	mood_change = 500 // coderbus
/datum/mood_event/happiness_drug_good_od
	description = "<span class='nicegreen'>ДА! ДА!! ДА!!!</span>\n"
	mood_change = 1000
	timeout = 0.5 MINUTES
	special_screen_obj = "mood_happiness_good"

/datum/mood_event/happiness_drug_bad_od
	description = "<span class='boldwarning'>НЕТ! НЕТ!! НЕТ!!!</span>\n"
	mood_change = -20000
	timeout = 0.5 MINUTES
	special_screen_obj = "mood_happiness_bad"

/datum/mood_event/narcotic_medium
	description = "<span class='nicegreen'>Это приятное оцепенение...</span>\n"
	mood_change = 4
	timeout = 3 MINUTES

/datum/mood_event/narcotic_heavy
	description = "<span class='nicegreen'>Ощущение, словно меня обернули золотом... </span>\n" // хз чё там должно было быть после "обернули", дописал "золотом".
	mood_change = 9
	timeout = 3 MINUTES

/datum/mood_event/stimulant_medium
	description = "<span class='nicegreen'>У меня столько энергии, что я чувствую, будто могу свернуть горы!</span>\n"
	mood_change = 4
	timeout = 3 MINUTES

/datum/mood_event/stimulant_heavy
	description = "<span class='nicegreen'>Ух Ах АААА!! ХА ХА ХА ХА ХАА! А-ах!</span>\n"
	mood_change = 12
	timeout = 3 MINUTES

#define EIGENTRIP_MOOD_RANGE 10

/datum/mood_event/eigentrip
	description = "<span class='nicegreen'>I swapped places with an alternate reality version of myself!</span>\n"
	mood_change = 0
	timeout = 10 MINUTES

/datum/mood_event/eigentrip/add_effects(param)
	var/value = rand(-EIGENTRIP_MOOD_RANGE,EIGENTRIP_MOOD_RANGE)
	mood_change = value
	if(value < 0)
		description = "<span class='warning'>I swapped places with an alternate reality version of myself! I want to go home!</span>\n"
	else
		description = "<span class='nicegreen'>I swapped places with an alternate reality version of myself! Though, this place is much better than my old life.</span>\n"

#undef EIGENTRIP_MOOD_RANGE

/datum/mood_event/nicotine_withdrawal_moderate
	description = "<span class='warning'>Haven't had a smoke in a while. Feeling a little on edge... </span>\n"
	mood_change = -10

/datum/mood_event/nicotine_withdrawal_severe
	description = "<span class='boldwarning'>Head pounding. Cold sweating. Feeling anxious. Need a smoke to calm down!</span>\n"
	mood_change = -16

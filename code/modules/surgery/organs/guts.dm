/obj/item/organ/guts
	name = "кишки"
	desc = "Мотать можно долго, хоть целых двадцать минут."
	icon_state = "guts"
	base_icon_state = "guts"
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_GUTS

	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY

	low_threshold_passed = span_info("Живот болит...")
	high_threshold_passed = span_warning("Что-то сильно болит в животе.")
	now_fixed = span_info("В животе перестаёт болеть.")
	high_threshold_cleared = span_info("Боль в животе утихает.")

	food_reagents = list(/datum/reagent/consumable/nutriment/organ_tissue = 5)

	var/metabolism_efficiency = 0.03
	var/operated = FALSE

	reagent_vol = 300

/obj/item/organ/guts/Initialize()
	. = ..()
	if(!reagents)
		create_reagents(reagent_vol, REAGENT_HOLDER_ALIVE)
	else
		reagents.flags |= REAGENT_HOLDER_ALIVE

/obj/item/organ/guts/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][damage > 50 ? "-damaged" : ""]"

/obj/item/organ/guts/on_life(delta_time, times_fired)
	. = ..()
	var/mob/living/carbon/human/body = owner
	var/datum/reagent/uri = locate(/datum/reagent/toxin/urine) in reagents.reagent_list

	if(uri?.volume > reagent_vol)
		body.try_poo()

	if(body?.nutrition <= 50)
		applyOrganDamage(0.1)
		update_icon()

	if(body?.nutrition)
		body.nutrition -= delta_time * metabolism_efficiency
		reagents.add_reagent(/datum/reagent/toxin/poo, delta_time * metabolism_efficiency)

	if(damage < low_threshold)
		return

	if(damage > high_threshold && DT_PROB(0.5 * damage, delta_time))
		to_chat(body, span_warning("В животе болит и голова кружится"))
		body.adjustToxLoss(1)

/obj/item/organ/guts/get_availability(datum/species/S)
	return !(NOGUTS in S.inherent_traits)

/obj/item/organ/guts/fly
	desc = "Кто-то хранил в них уголь. Ну дела."
	icon_state = "guts-x"
	base_icon_state = "guts-x"

/obj/item/organ/guts/cybernetic
	name = "базовые кибернетические кишки"
	icon_state = "guts-c"
	base_icon_state = "guts-c"
	desc = "Базовое устройство, имитирующее функции человеческих кишок."
	organ_flags = ORGAN_SYNTHETIC
	maxHealth = STANDARD_ORGAN_THRESHOLD * 0.5
	var/emp_vulnerability = 80
	metabolism_efficiency = 0.05

/obj/item/organ/guts/cybernetic/tier2
	name = "кибернетические кишки"
	icon_state = "guts-c-u"
	base_icon_state = "guts-c-u"
	desc = "Усовершенствованное устройство, превосходящее функции человеческих кишок."
	maxHealth = 1.5 * STANDARD_ORGAN_THRESHOLD
	emp_vulnerability = 40
	metabolism_efficiency = 0.02

/obj/item/organ/guts/cybernetic/tier3
	name = "продвинутые кибернетические кишки"
	icon_state = "guts-c-u2"
	base_icon_state = "guts-c-u2"
	desc = "Эта версия кибернетических кишок имеет огромный внутренний запас."
	maxHealth = 2 * STANDARD_ORGAN_THRESHOLD
	emp_vulnerability = 20
	metabolism_efficiency = 0.01

/obj/item/organ/guts/cybernetic/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(!COOLDOWN_FINISHED(src, severe_cooldown))
		owner.try_poo()
		COOLDOWN_START(src, severe_cooldown, 10 SECONDS)
	if(prob(emp_vulnerability/severity))
		organ_flags |= ORGAN_SYNTHETIC_EMP
